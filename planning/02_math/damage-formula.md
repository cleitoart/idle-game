# Formula de Dano

> Pipeline completo de calculo de dano para auto-battle. Cada componente e uma funcao isolada que pode ser testada e ajustada.

## 0. Pipeline Geral

A funcao `compute_hit` e o orquestrador. Recebe `attacker`, `defender` e `skill`, e retorna um `Dictionary` rico para o sistema de UI consumir (damage numbers, status icons, log).

```gdscript
func compute_hit(attacker: CombatStats, defender: CombatStats, skill: SkillData) -> Dictionary:
    var result = {
        "damage": 0,
        "is_miss": false,
        "is_crit": false,
        "is_block": false,
        "is_dodge": false,
        "block_amount": 0,
        "element_mult": 1.0,
        "armor_type_mult": 1.0,
        "lifesteal": 0,
        "thorns_to_attacker": 0,
        "status_applied": [],
    }

    # 1. Hit chance vs dodge
    if not roll_hit(attacker, defender, skill):
        result["is_miss"] = true
        return result
    if roll_dodge(attacker, defender):
        result["is_dodge"] = true
        return result

    # 2. Base damage
    var base = compute_base_damage(attacker, skill)

    # 3. Element matrix
    var elem_mult = element_multiplier(skill.element, defender.element_resist_profile)
    base *= elem_mult
    result["element_mult"] = elem_mult

    # 4. Type-of-attack vs armor matrix
    var armor_mult = armor_type_multiplier(skill.attack_type, defender.armor_type)
    base *= armor_mult
    result["armor_type_mult"] = armor_mult

    # 5. Crit
    if roll_crit(attacker, skill):
        base *= attacker.crit_damage_mult
        result["is_crit"] = true

    # 6. Defense mitigation
    var dmg_after_def = apply_defense(base, defender, skill)

    # 7. Block
    if roll_block(defender):
        var blocked = min(dmg_after_def, defender.block_amount)
        dmg_after_def -= blocked
        result["is_block"] = true
        result["block_amount"] = int(blocked)

    # 8. Final damage rounding + minimum 1
    var final_dmg = int(max(1.0, floor(dmg_after_def)))
    result["damage"] = final_dmg

    # 9. Lifesteal e thorns
    result["lifesteal"] = int(floor(final_dmg * attacker.lifesteal_pct))
    result["thorns_to_attacker"] = int(floor(final_dmg * defender.thorns_pct))

    # 10. Status effects
    result["status_applied"] = roll_statuses(attacker, defender, skill)

    return result
```

---

## 1. Hit Chance e Accuracy

### 1.1 Penalidade por diferenca de level

Para evitar que jogador no level 50 tente farmar zonas de level 200 trivialmente (e vice-versa, evita one-shot do bicho de Z6 num jogador subindo).

```gdscript
const LEVEL_DIFF_THRESHOLD: int = 5
const LEVEL_DIFF_PENALTY_PER_LEVEL: float = 0.02  # -2% accuracy por level acima do threshold

func level_diff_penalty(attacker_level: int, defender_level: int) -> float:
    var diff = defender_level - attacker_level
    if diff <= LEVEL_DIFF_THRESHOLD:
        return 0.0
    var excess = diff - LEVEL_DIFF_THRESHOLD
    return min(0.95, excess * LEVEL_DIFF_PENALTY_PER_LEVEL)
```

### 1.2 Hit roll

```gdscript
func roll_hit(attacker: CombatStats, defender: CombatStats, skill: SkillData) -> bool:
    var base_acc = attacker.accuracy + skill.accuracy_bonus  # ambos em [0..1]
    var penalty = level_diff_penalty(attacker.level, defender.level)
    var hit_chance = clamp(base_acc - penalty - defender.dodge_chance, 0.05, 0.99)
    return randf() < hit_chance
```

**Justificativa:** clamp `[0.05, 0.99]` impede que (a) accuracy negativa torne todo hit miss e (b) accuracy 1.0 torne dodge inutil. Mesma filosofia de WoW e Path of Exile (sempre tem ~1-5% de chance de errar/acertar).

---

## 2. Dodge

```gdscript
func roll_dodge(attacker: CombatStats, defender: CombatStats) -> bool:
    var d = clamp(defender.dodge_chance - attacker.accuracy_pierce, 0.0, 0.75)
    return randf() < d
```

`accuracy_pierce` e um stat avancado (vem de equip/encantamento) que reduz dodge inimigo. Cap em 0.75 para nao haver enemy "untouchable".

---

## 3. Damage Base

```gdscript
func compute_base_damage(attacker: CombatStats, skill: SkillData) -> float:
    var atk_stat = attacker.atk
    if skill.is_magic:
        atk_stat = attacker.magic_atk
    # Variacao +/-10% para combate parecer organico
    var variance = 0.9 + randf() * 0.2
    return atk_stat * skill.damage_multiplier * variance
```

`skill.damage_multiplier` e o multiplicador da skill (ex: ataque basico = 1.0, fireball = 1.5, ultimate = 4.0).

---

## 4. Mitigation por Defesa

### 4.1 Formula escolhida

Formula classica de **diminishing returns**:

```gdscript
func apply_defense(damage: float, defender: CombatStats, skill: SkillData) -> float:
    var def_stat = defender.def
    if skill.is_magic:
        def_stat = defender.magic_def
    # Reduction = def / (def + scale_factor)
    var scale = scale_factor_for_level(defender.level)
    var reduction = def_stat / float(def_stat + scale)
    return damage * (1.0 - reduction)

func scale_factor_for_level(level: int) -> float:
    # Scale cresce com level para que DEF do early-game seja relevante
    # mas DEF nao trivialize late-game.
    return 50.0 + 10.0 * level
```

**Por que essa formula e nao linear (`damage - def`)?** Linear cria walls (def > damage = 0 dano). A formula `def / (def + scale)` da reducao assintotica que nunca chega em 100%. E o padrao de WoW, Diablo, Path of Exile.

**Exemplo de validacao:**
- L1, def=2, damage=10 -> reduction = 2/62 = 3.2% -> dano final ~9.7
- L50, def=100, damage=500 -> reduction = 100/650 = 15.4% -> dano final ~423
- L1000, def=10000, damage=50000 -> reduction = 10000/20050 = 49.9% -> dano final ~25.000

### 4.2 Pierce de armor

Stat `armor_pierce_pct` (0..1): subtrai a parte da reducao final.

```gdscript
func apply_defense_with_pierce(damage: float, defender: CombatStats, skill: SkillData, attacker: CombatStats) -> float:
    var dmg = apply_defense(damage, defender, skill)
    var pierced_back = damage * attacker.armor_pierce_pct * (damage - dmg) / max(damage, 1.0)
    return dmg + pierced_back
```

---

## 5. Crit

```gdscript
func roll_crit(attacker: CombatStats, skill: SkillData) -> bool:
    var c = clamp(attacker.crit_chance + skill.crit_bonus, 0.0, 1.0)
    return randf() < c
```

`attacker.crit_damage_mult` default = 1.5x, escalavel via stat/encantamento ate ~5.0x (cap mole).

---

## 6. Block

```gdscript
func roll_block(defender: CombatStats) -> bool:
    return randf() < clamp(defender.block_chance, 0.0, 0.75)
```

`defender.block_amount` e flat (vem do escudo/armadura). Bloqueia ate `block_amount` do dano apos defense, mas nunca abaixo de 1 (sempre passa minimo 1).

---

## 7. Matriz de Elementos

8 elementos: Fire, Ice, Water, Wind, Rock, Electric, Light, Dark.

(RESOLVIDO 2026-05-06 #13): **Stats elementais nao tem afinidade base por classe.** Todos os `attacker.element_dmg[elem]` comecam ZERADOS no `CombatStats.from_character()`. O `element_multiplier` so contribui no calculo final se a skill/equip/encantamento explicitamente carregar um elemento (`skill.element != ""`). Quando `skill.element == ""` ou `attacker` nao tem nenhum bonus elemental ativo, o calculo e' NEUTRO (`elem_mult = 1.0`). Build elemental emerge inteiramente da combinacao de equip + skill + encantamento — nao da classe. Ver `00_meta/pending-decisions.md` #13.

Multiplicador final = `multiplier_table[atacante_elem][defensor_elem]`.

| atk \ def | Fire | Ice | Water | Wind | Rock | Electric | Light | Dark |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **Fire** | 0.5 | 1.5 | 0.5 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 |
| **Ice** | 0.5 | 0.5 | 1.0 | 1.5 | 1.0 | 1.0 | 1.0 | 1.0 |
| **Water** | 1.5 | 1.0 | 0.5 | 1.0 | 1.0 | 0.5 | 1.0 | 1.0 |
| **Wind** | 1.0 | 0.5 | 1.0 | 0.5 | 1.5 | 1.0 | 1.0 | 1.0 |
| **Rock** | 1.0 | 1.0 | 1.0 | 0.5 | 0.5 | 1.5 | 1.0 | 1.0 |
| **Electric** | 1.0 | 1.0 | 1.5 | 1.0 | 0.5 | 0.5 | 1.0 | 1.0 |
| **Light** | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 0.5 | 1.5 |
| **Dark** | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.5 | 0.5 |

```gdscript
const ELEMENT_MATRIX = {
    "fire":     {"fire":0.5,"ice":1.5,"water":0.5,"wind":1.0,"rock":1.0,"electric":1.0,"light":1.0,"dark":1.0},
    "ice":      {"fire":0.5,"ice":0.5,"water":1.0,"wind":1.5,"rock":1.0,"electric":1.0,"light":1.0,"dark":1.0},
    "water":    {"fire":1.5,"ice":1.0,"water":0.5,"wind":1.0,"rock":1.0,"electric":0.5,"light":1.0,"dark":1.0},
    "wind":     {"fire":1.0,"ice":0.5,"water":1.0,"wind":0.5,"rock":1.5,"electric":1.0,"light":1.0,"dark":1.0},
    "rock":     {"fire":1.0,"ice":1.0,"water":1.0,"wind":0.5,"rock":0.5,"electric":1.5,"light":1.0,"dark":1.0},
    "electric": {"fire":1.0,"ice":1.0,"water":1.5,"wind":1.0,"rock":0.5,"electric":0.5,"light":1.0,"dark":1.0},
    "light":    {"fire":1.0,"ice":1.0,"water":1.0,"wind":1.0,"rock":1.0,"electric":1.0,"light":0.5,"dark":1.5},
    "dark":     {"fire":1.0,"ice":1.0,"water":1.0,"wind":1.0,"rock":1.0,"electric":1.0,"light":1.5,"dark":0.5},
}

func element_multiplier(atk_element: String, def_element: String) -> float:
    if atk_element == "" or def_element == "":
        return 1.0
    return ELEMENT_MATRIX.get(atk_element, {}).get(def_element, 1.0)
```

**Filosofia:** mantemos os 6 elementos classicos (Pokemon-style) com 4 trios em `Fire/Water/Wind/Rock/Ice/Electric` e um eixo separado Light/Dark (oposicao binaria, igual ao Pokemon Gold/Silver Dark/Psychic).

---

## 8. Matriz: Tipo de Ataque vs Tipo de Armor

7 tipos de ataque: Slash, Stab, Crush, Blunt, Magic, Pierce, Lacerate.
4 tipos de armor (do defensor): Cloth, Leather, Mail, Plate.

| Atk \ Armor | Cloth | Leather | Mail | Plate |
|---|---:|---:|---:|---:|
| **Slash** | 1.2 | 1.3 | 0.9 | 0.7 |
| **Stab** | 1.0 | 1.2 | 1.1 | 0.8 |
| **Crush** | 0.8 | 0.9 | 1.1 | 1.4 |
| **Blunt** | 1.0 | 1.0 | 1.0 | 1.2 |
| **Magic** | 1.5 | 1.0 | 0.8 | 0.7 |
| **Pierce** | 1.1 | 1.0 | 1.3 | 1.0 |
| **Lacerate** | 1.3 | 1.4 | 0.8 | 0.6 |

```gdscript
const ARMOR_TYPE_MATRIX = {
    "slash":    {"cloth":1.2,"leather":1.3,"mail":0.9,"plate":0.7},
    "stab":     {"cloth":1.0,"leather":1.2,"mail":1.1,"plate":0.8},
    "crush":    {"cloth":0.8,"leather":0.9,"mail":1.1,"plate":1.4},
    "blunt":    {"cloth":1.0,"leather":1.0,"mail":1.0,"plate":1.2},
    "magic":    {"cloth":1.5,"leather":1.0,"mail":0.8,"plate":0.7},
    "pierce":   {"cloth":1.1,"leather":1.0,"mail":1.3,"plate":1.0},
    "lacerate": {"cloth":1.3,"leather":1.4,"mail":0.8,"plate":0.6},
}

func armor_type_multiplier(atk_type: String, armor_type: String) -> float:
    if atk_type == "" or armor_type == "":
        return 1.0
    return ARMOR_TYPE_MATRIX.get(atk_type, {}).get(armor_type, 1.0)
```

**Justificativa:**
- Slash (espada) bom contra cloth/leather, ruim contra plate.
- Crush (clava) bom contra plate, ruim contra cloth.
- Magic ignora armor mas falha contra plate magico-resistente.
- Lacerate (machado) extra-letal contra leather/cloth (sangra), inutil contra plate.

Padrao herdado de RuneScape e Mount&Blade.

---

## 9. Status Effects

### 9.1 Aplicacao base

```gdscript
func roll_statuses(attacker: CombatStats, defender: CombatStats, skill: SkillData) -> Array:
    var applied = []
    for status_def in skill.status_pool:
        # status_def: { id, base_chance, duration, magnitude, stack_cap }
        var resist = defender.status_resist.get(status_def.id, 0.0)
        var effective_chance = clamp(status_def.base_chance * (1.0 - resist), 0.0, 1.0)
        if randf() < effective_chance:
            # Resistencia tambem reduz duracao e magnitude (nao zera)
            var duration = status_def.duration * (1.0 - 0.5 * resist)
            var magnitude = status_def.magnitude * (1.0 - 0.3 * resist)
            applied.append({
                "id": status_def.id,
                "duration": duration,
                "magnitude": magnitude,
                "stack_cap": status_def.stack_cap,
            })
    return applied
```

`status_resist[id]` em [0..1]. 1.0 = imune.

### 9.2 Bleeding stack (mecanica especial)

Cada hit com tipo Lacerate adiciona 1 stack de Bleeding (cap 20). Cada stack causa `lacerate_dmg_per_stack` (5% do hit que aplicou) por segundo.

Em **20 stacks**, dispara explosao = `sum(lacerate_dmg_per_stack stored) * 5`.

```gdscript
class BleedingState:
    var stacks: int = 0
    var stack_dmg: Array = []  # historico do dano de cada stack
    const STACK_CAP: int = 20
    const EXPLOSION_MULT: float = 5.0

    func add_stack(damage_of_hit: float) -> void:
        if stacks >= STACK_CAP:
            return
        stacks += 1
        stack_dmg.append(damage_of_hit * 0.05)  # 5% do hit como dano por stack
        if stacks >= STACK_CAP:
            _explode()

    func tick(delta: float) -> float:
        var total = 0.0
        for d in stack_dmg:
            total += d * delta
        return total

    func _explode() -> float:
        var total = 0.0
        for d in stack_dmg:
            total += d
        var burst = total * EXPLOSION_MULT
        stacks = 0
        stack_dmg.clear()
        return burst
```

### 9.3 Stack rules por status

| Status | Stack? | Cap | Comportamento |
|---|---|---:|---|
| Poison | Sim | 5 | Cada stack adiciona dot independente |
| Burning | Sim | 3 | Substitui stack mais fraco |
| Bleeding (Lacerate) | Sim | 20 | Explode em cap |
| Slowed | Nao | - | Renova duracao |
| Blind | Nao | - | Renova duracao |
| Freeze | Nao | - | Refresh duracao + immunity 2s pos-quebra |
| Stun | Nao | - | Refresh, mas DR (diminishing returns) acumulado |
| ATK Up | Sim | 3 | Up, Up!!, Up!!! (variantes) |
| Shielded | Sim | sem cap | Shields se somam |
| Thorns | Nao | - | So efeito ativo, nao stack |
| Berserker | Nao | - | Estado, nao acumula |

---

## 10. Lifesteal e Reflect/Thorns

```gdscript
# Aplicado pelo combat_controller apos compute_hit:
func apply_post_hit(attacker: CombatNode, defender: CombatNode, hit_result: Dictionary) -> void:
    if hit_result["lifesteal"] > 0:
        attacker.heal(hit_result["lifesteal"])
    if hit_result["thorns_to_attacker"] > 0:
        attacker.take_pure_damage(hit_result["thorns_to_attacker"])
```

`lifesteal_pct` cap em 0.5 (50%) para nao trivializar tank-DPS infinito.
`thorns_pct` cap em 0.3 (devolve ate 30% do dano recebido).

---

## 11. Reflect (mecanica de magic-only)

`reflect_pct` separado de thorns. So aplica em hits magicos.

```gdscript
func apply_reflect(damage: int, defender: CombatStats, skill: SkillData) -> int:
    if not skill.is_magic:
        return 0
    return int(floor(damage * defender.reflect_pct))
```

---

## 12. Resumo de constantes-chave

| Const | Valor | Onde |
|---|---:|---|
| LEVEL_DIFF_THRESHOLD | 5 | hit chance |
| LEVEL_DIFF_PENALTY_PER_LEVEL | 0.02 | hit chance |
| variance damage | +/-10% | base damage |
| crit_damage_mult default | 1.5x | crit |
| element matrix grid | 0.5 / 1.0 / 1.5 | element matrix |
| armor matrix range | 0.6 - 1.5 | armor matrix |
| Bleeding STACK_CAP | 20 | bleeding |
| Bleeding EXPLOSION_MULT | 5.0x | bleeding |
| lifesteal_pct cap | 0.5 | lifesteal |
| thorns_pct cap | 0.3 | thorns |
| dodge cap | 0.75 | dodge |
| block cap | 0.75 | block |
| accuracy clamp | 0.05 - 0.99 | hit chance |
