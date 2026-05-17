# Drop Rates

> Modelo matematico de drops de loot, raridades, modificadores (elite/shiny/boss) e interacao com stats do jogador (Loot Gain %, Material Drop Chance %, etc.).

## 1. Tabela de Raridade Base

(RESOLVIDO 2026-05-06 #12: 6 tiers oficiais, ver `01_design/equipment-catalog.md` secao 2 e `00_meta/pending-decisions.md` #12.)

| Raridade | Chance base | Cor (UI) | Notas |
|---|---:|---|---|
| Common | 60.0% | cinza | drops triviais (slime goo, madeira) |
| Uncommon | 25.0% | verde | drops uteis cedo |
| Rare | 10.0% | azul | requer kills sustentados |
| Epic | 3.5% | roxo | drops de mid-game |
| Legendary | 1.2% | laranja | drops de elite/boss |
| Mythic | 0.3% | vermelho/dourado | drops endgame, ultra raros |

Soma = 100.0%. Justificativa proporcional:

- **Common 60%**: feedback constante. Cada kill da algo (mesmo que seja goo). Combate idle precisa de feedback.
- **Uncommon 25%**: ainda comum, mas ja tem estilo "ah, achei algo legal".
- **Rare 10%**: aparece a cada ~10 kills, suficiente pra criar saudade.
- **Epic 3.5%**: ~28 kills/drop. Item que voce lembra onde dropou.
- **Legendary 1.2%**: ~83 kills/drop. Marco de progressao.
- **Mythic 0.3%**: ~333 kills/drop em condicao base. Em pratica, com modificadores Mythic e endgame puro.

**Comparacao com referencias:**
- **Diablo 4**: legendary ~1%, mythic ~0.05% (mais rigido).
- **Path of Exile**: rare ~10-15%, unique ~0.5-2%.
- **Idle Slayer**: legendary ~2%, mythic ~0.5%.

Nossas taxas sao um pouco mais generosas que Diablo 4 e mais alinhadas com Idle Slayer/IdleOn — apropriado pra um idle (jogador nao vai ficar 1000h sem ver Mythic).

---

## 2. Loot Tables por Inimigo

Cada inimigo tem `loot_table: Array[LootEntry]`. Cada `LootEntry`:

```gdscript
class_name LootEntry
extends Resource

@export var item: ItemData
@export var chance: float = 0.5         # 0..1, chance base independente
@export var min_qty: int = 1
@export var max_qty: int = 1
@export var rarity: String = "common"   # common, uncommon, rare, epic, legendary, mythic
@export var is_material: bool = true
@export var is_equipment: bool = false
@export var is_card: bool = false
@export var is_boss_exclusive: bool = false
@export var is_elite_exclusive: bool = false
@export var is_shiny_exclusive: bool = false
@export var unlocks_at_kill_count: int = 0  # mob slaughter gating
```

Cada entry rola **independente**. Um inimigo pode dropar 0, 1, 2... drops por kill.

---

## 3. Formula Principal de Roll

```gdscript
const LOOT_GAIN_CAP_PCT: float = 500.0  # +500% maximum (6x base)
const MATERIAL_DROP_CAP_PCT: float = 300.0
const EQUIP_DROP_CAP_PCT: float = 300.0
const CARD_DROP_CAP_PCT: float = 300.0

func roll_loot(enemy: EnemyData, player_stats: CombatStats, mods: Dictionary) -> Array:
    var drops = []
    var killed_count = mods.get("kill_count", 0)

    for entry in enemy.loot_table:
        # Gating por kill count (mob slaughter)
        if entry.unlocks_at_kill_count > 0 and killed_count < entry.unlocks_at_kill_count:
            continue

        # Gating por modificador
        if entry.is_boss_exclusive and not mods.get("is_boss", false):
            continue
        if entry.is_elite_exclusive and not mods.get("is_elite", false):
            continue
        if entry.is_shiny_exclusive and not mods.get("is_shiny", false):
            continue

        # Calcular chance
        var c = entry.chance

        # Stat: Loot Gain % aplica em todos os drops
        var loot_gain = clamp(player_stats.loot_gain_pct, 0.0, LOOT_GAIN_CAP_PCT)
        c *= 1.0 + loot_gain / 100.0

        # Stats por categoria (aditivos com Loot Gain via multiplicacao)
        if entry.is_material:
            var mat = clamp(player_stats.material_drop_chance_pct, 0.0, MATERIAL_DROP_CAP_PCT)
            c *= 1.0 + mat / 100.0
        if entry.is_equipment:
            var eq = clamp(player_stats.equip_drop_chance_pct, 0.0, EQUIP_DROP_CAP_PCT)
            c *= 1.0 + eq / 100.0
        if entry.is_card:
            var cd = clamp(player_stats.card_drop_chance_pct, 0.0, CARD_DROP_CAP_PCT)
            c *= 1.0 + cd / 100.0

        # Modificadores do inimigo
        c = apply_enemy_mods_chance(c, mods)

        # Cap mole para nao garantir tudo (exceto boss-exclusive abaixo)
        c = min(c, 0.99)

        # Roll
        if randf() < c:
            var qty = randi_range(entry.min_qty, entry.max_qty)
            qty = apply_quantity_mods(qty, mods)
            drops.append({"item": entry.item, "qty": qty, "rarity": entry.rarity})

    # Boss e shiny garantem algo se a tabela tiver entry exclusiva
    drops = ensure_guaranteed_drops(enemy, drops, mods)

    return drops
```

---

## 4. Modificadores de Inimigo

### 4.1 Tabela

| Modificador | Quantidade x | Chance x | Drop garantido |
|---|---:|---:|---|
| Common | 1.0x | 1.0x | nao |
| Elite | 3.0x | 1.5x | drop raro garantido + chance 5% drop exclusivo |
| Shiny | 10.0x | 3.0x | card unico garantido + 20% drop ultra-exclusivo |
| Mini-boss | 2.0x | 1.5x | item mini-boss garantido |
| Boss de estagio | 5.0x | 2.0x | boss-specific drop garantido |
| Boss de zona | 10.0x | 3.0x | boss-zona drop garantido + token |
| Dungeon | 5.0x | 2.0x | dungeon-specific items + tokens |

### 4.2 Implementacao

```gdscript
func apply_enemy_mods_chance(base_chance: float, mods: Dictionary) -> float:
    var c = base_chance
    if mods.get("is_elite", false): c *= 1.5
    if mods.get("is_shiny", false): c *= 3.0
    if mods.get("is_mini_boss", false): c *= 1.5
    if mods.get("is_stage_boss", false): c *= 2.0
    if mods.get("is_zone_boss", false): c *= 3.0
    if mods.get("is_dungeon", false): c *= 2.0
    return c

func apply_quantity_mods(base_qty: int, mods: Dictionary) -> int:
    var q = float(base_qty)
    if mods.get("is_elite", false): q *= 3.0
    if mods.get("is_shiny", false): q *= 10.0
    if mods.get("is_mini_boss", false): q *= 2.0
    if mods.get("is_stage_boss", false): q *= 5.0
    if mods.get("is_zone_boss", false): q *= 10.0
    if mods.get("is_dungeon", false): q *= 5.0
    return int(floor(q))

func ensure_guaranteed_drops(enemy: EnemyData, drops: Array, mods: Dictionary) -> Array:
    # Se for elite, garantir pelo menos 1 drop rare+
    if mods.get("is_elite", false):
        var has_rare = drops.any(func(d): return d.rarity in ["rare","epic","legendary","mythic"])
        if not has_rare:
            var rare_entry = pick_random_rarity_from_table(enemy.loot_table, "rare")
            if rare_entry != null:
                drops.append({"item": rare_entry.item, "qty": 1, "rarity": "rare"})
    # Se for shiny, garantir card
    if mods.get("is_shiny", false):
        var card_entry = pick_first_card_entry(enemy.loot_table)
        if card_entry != null:
            drops.append({"item": card_entry.item, "qty": 1, "rarity": card_entry.rarity})
    # Se for boss, garantir boss-exclusive
    if mods.get("is_stage_boss", false) or mods.get("is_zone_boss", false):
        for entry in enemy.loot_table:
            if entry.is_boss_exclusive:
                drops.append({"item": entry.item, "qty": randi_range(entry.min_qty, entry.max_qty), "rarity": entry.rarity})
                break
    return drops
```

---

## 5. Stats do Jogador que Afetam Drop

| Stat | Aplica em | Cap | Fonte tipica |
|---|---|---:|---|
| Loot Gain % | TUDO | +500% | constelacao Sortudo, equip rare |
| Equip Drop Chance % | so equipamento | +300% | encantamento "Filho do Drop" |
| Material Drop Chance % | so material | +300% | mastery, pets de gathering |
| Card Drop Chance % | so card | +300% | encantamento, set de cards |
| Gold Gain % | gold (separado) | +500% | constelacao Sortudo, equip |
| EXP Gain % | xp (separado) | +500% | poções, eventos |

**Aplicacao multiplicativa, nao aditiva.** Loot Gain + Equip Drop Chance num drop de equipamento aplicam **ambos**:

```gdscript
chance_final = chance_base * (1 + loot_gain/100) * (1 + equip_drop/100)
```

Isso e o que da o "snowball effect" classico: stackar dois bonus de drop vira muito poderoso. Mesmo design de PoE/Diablo (item rarity vs item quantity).

---

## 6. Pity / Soft-Pity

(RESOLVIDO 2026-05-06 #8: SIM, implementar pity simples em Mythic. Threshold = 100 legendary sem mythic. Ver `00_meta/pending-decisions.md` #8.)

### 6.1 Implementacao oficial

```gdscript
# Em CharacterInstance ou GameState
var legendary_streak_without_mythic: int = 0
const MYTHIC_PITY_THRESHOLD: int = 100  # apos 100 legendary sem mythic, proximo legendary vira mythic

func register_drop(rarity: String) -> void:
    if rarity == "mythic":
        legendary_streak_without_mythic = 0
    elif rarity == "legendary":
        legendary_streak_without_mythic += 1

func should_force_mythic() -> bool:
    return legendary_streak_without_mythic >= MYTHIC_PITY_THRESHOLD
```

Aplicado no `roll_loot`:
```gdscript
if entry.rarity == "legendary" and should_force_mythic():
    # next_legendary_drop forces upgrade to mythic
    var upgraded = find_mythic_equivalent(entry)
    if upgraded != null:
        drops.append({"item": upgraded, "qty": 1, "rarity": "mythic"})
        legendary_streak_without_mythic = 0
        continue
```

**Justificativa:** Genshin Impact, Honkai Star Rail e muitos gachas usam pity. Em idle, evita que o jogador rode milhares de kills num azar estatistico e desista. 100 legendary = ~8.300 kills com taxa base, ou ~2.000 kills com modificadores. Razoavel para garantir progressao percebida.

### 6.2 Alternativa (rejeitada)

Pity em Legendary tambem? Decidimos **nao**, porque Legendary ja e relativamente comum (1.2% base, ~83 kills/drop). Pity em Legendary trivializaria a raridade.

---

## 7. Tabela de Validacao: Kills Esperados ate Drop

Premissa: jogador L25 em Z1, Loot Gain = +50%, Material Drop Chance = +30%, sem outros modificadores.

| Raridade | Chance base | Chance efetiva (mat) | Kills esperados (1/c) |
|---|---:|---:|---:|
| Common | 60% | 60% * 1.5 * 1.3 = 117% (cap 99%) | ~1 |
| Uncommon | 25% | 25% * 1.5 * 1.3 = 48,75% | ~2 |
| Rare | 10% | 10% * 1.5 * 1.3 = 19,5% | ~5 |
| Epic | 3.5% | 6,8% | ~15 |
| Legendary | 1.2% | 2,3% | ~43 |
| Mythic | 0.3% | 0,58% | ~172 |

Premissa endgame (Z6, jogador L600, Loot Gain = +400%, Material Drop = +200%):

| Raridade | Chance base | Chance efetiva | Kills esperados |
|---|---:|---:|---:|
| Common | 60% | cap 99% | ~1 |
| Uncommon | 25% | cap 99% | ~1 |
| Rare | 10% | cap 99% | ~1 |
| Epic | 3.5% | 52,5% | ~2 |
| Legendary | 1.2% | 18% | ~6 |
| Mythic | 0.3% | 4,5% | ~22 |

**Observacao:** o cap em 99% por entry e crucial. Sem ele, jogador endgame "garantiria" tudo. Cap garante que sempre exista um momento de "perdi um drop", o que mantem o vicio.

---

## 8. Cards: Drop Rate Especial

Cards tem regras proprias por serem essenciais para o album.

| Categoria | Drop chance base |
|---|---:|
| Card de inimigo comum | 1% (sobe 0.5%/100 kills ate cap 5%) |
| Card de inimigo elite | 5% |
| Card de boss | 25% (no kill do boss) |
| Card shiny (greedy) | 100% (raro mesmo o inimigo aparecer) |
| Card corrupted (elite-card de fato) | 10% |

```gdscript
func card_drop_chance(enemy: EnemyData, kill_count: int, mods: Dictionary) -> float:
    var base = 0.01
    if mods.get("is_boss", false): base = 0.25
    if mods.get("is_elite", false): base = 0.05
    if mods.get("is_shiny", false): base = 1.0  # garantido (mas a aparicao do shiny e que e rara)
    # Mob slaughter aumenta drop de card comum
    var slaughter_bonus = min(0.04, kill_count / 100.0 * 0.005)
    return clamp(base + slaughter_bonus, 0.0, 1.0)
```

---

## 9. Constantes-chave

| Const | Valor |
|---|---:|
| Common base chance | 0.60 |
| Uncommon base chance | 0.25 |
| Rare base chance | 0.10 |
| Epic base chance | 0.035 |
| Legendary base chance | 0.012 |
| Mythic base chance | 0.003 |
| LOOT_GAIN_CAP_PCT | 500 |
| MATERIAL_DROP_CAP_PCT | 300 |
| EQUIP_DROP_CAP_PCT | 300 |
| CARD_DROP_CAP_PCT | 300 |
| Per-entry chance cap | 0.99 |
| MYTHIC_PITY_THRESHOLD | 100 |
| Elite qty mult | 3.0 |
| Shiny qty mult | 10.0 |
| Stage boss qty mult | 5.0 |
| Zone boss qty mult | 10.0 |
| Dungeon qty mult | 5.0 |

**Tunaveis criticos:** `Mythic base chance`, `LOOT_GAIN_CAP_PCT`, `MYTHIC_PITY_THRESHOLD`. Esses 3 sao os que mais afetam pacing endgame.
