# Ascension Multipliers (Renascimento, Transcendencia, Cosmica)

> Matematica das 3 camadas de prestige. Define multiplicadores, formulas de pontos, requisitos.

## 0. Visao geral das camadas

| Camada | Trigger | O que reseta | O que mantem | Moeda ganha |
|---|---|---|---|---|
| **Renascimento** | level cap atingido (100, 200, ..., 1000) | level, inventario, equip, codex de materiais do personagem | codex de zonas/inimigos, album, pets, compras loja eterna | Pontos de Renascimento (Chakra) |
| **Transcendencia** | level 1000 + codex Z1-Z6 completo | tudo do personagem (XP, itens, album, etc.) exceto compras eternas, codex permanece, pets, conquistas | base codex, conquistas, loja eterna | Transcended Points |
| **Ascensao Cosmica** | varias transcendencias (game-design driven) | tudo (gathering, equip) | cards, bestiario, pets, conquistas, loja eterna, pontos de constelacao | Multiplicador Cosmico + Moedas Galacticas (drop comeca aqui) |

---

## 1. Renascimento e Estrelas

### 1.1 Multiplicador linear de estrelas

```gdscript
const STAR_MULT_BASE: float = 1.0
const STAR_MULT_PER_STAR: float = 0.5

func star_multiplier(stars: int) -> float:
    return STAR_MULT_BASE + STAR_MULT_PER_STAR * clamp(stars, 0, 10)
```

| Estrelas | Multiplicador | Level cap |
|---:|---:|---:|
| 0 | 1.0x | 100 |
| 1 | 1.5x | 200 |
| 2 | 2.0x | 300 |
| 3 | 2.5x | 400 |
| 4 | 3.0x | 500 |
| 5 | 3.5x | 600 |
| 6 | 4.0x | 700 |
| 7 | 4.5x | 800 |
| 8 | 5.0x | 900 |
| 9 | 5.5x | 950 |
| 10 | 6.0x | 1000 |

**Por que linear, nao exponencial?** Cada renascimento tem um custo crescente de tempo (level 100 -> 200 dura mais que 0 -> 100). Multiplicador linear contrabalanca: jogador ganha bonus equivalente ao esforco. Exponencial trivializaria.

**Aplicado em:** HP Max, MP Max, ATK base, DEF base, Magic ATK, Magic DEF (todos os stats principais). Nao aplicado em chances (crit, dodge, etc.) para nao quebrar curvas de probabilidade.

### 1.2 Awakening (ramos de evolucao)

Em **★1, ★3, ★5, ★7, ★9 e ★10**, o personagem ganha um no de escolha:

- ★1: primeiro no, escolha entre 2 ramos
- ★3: refinamento do ramo escolhido (sub-escolha 2x2)
- ★5: skill assinatura desbloqueada
- ★7: refinamento avancado
- ★9: skill assinatura 2
- ★10: especializacao final + skin + titulo unico

Detalhamento mecanico em `planning/01_design/classes-and-characters.md`. Aqui apenas registramos que **stats nao sao alterados pelo ramo escolhido** (so kit de skills e visual). Multiplicador de estrela e o mesmo independente do ramo.

### 1.3 Pontos de Renascimento (RP)

Ao renascer, jogador converte progresso em RP, que sao gastos no Chakra (loja de renascimento).

```gdscript
const REBIRTH_POINTS_PER_10_LEVELS: int = 1
const REBIRTH_POINTS_STAR_BONUS: float = 1.0  # +100% por estrela atual

func rebirth_points_gained(level_at_rebirth: int, current_star: int) -> int:
    var base_levels = max(1, level_at_rebirth)
    var base_points = floor(base_levels / 10.0) * REBIRTH_POINTS_PER_10_LEVELS
    var multiplier = 1.0 + REBIRTH_POINTS_STAR_BONUS * current_star
    return int(floor(base_points * multiplier))
```

**Tabela de exemplos:**

| Level renascendo | Star atual | RP ganhos |
|---:|---:|---:|
| 100 | 0 | 10 |
| 100 | 1 | 20 |
| 100 | 5 | 60 |
| 50 | 1 | 10 |
| 50 | 5 | 30 |
| 200 | 1 | 40 |
| 1000 | 9 | 1.000 |

**Justificativa:**
- Renascer cedo (level 50 vs 100) da menos pontos, mas e valido (recompensa flexibilidade).
- Estrela ja conquistada multiplica futuros ganhos. "Quanto mais voce ja prestigiou, mais facil prestigir de novo." E o snowball de NGU Idle.

### 1.4 Chakra (loja de renascimento)

Lista de upgrades comprados com RP. **[DECISAO PENDENTE]** — definicoes finais em `01_design/`. Exemplos esperados:

| Upgrade | Custo (RP) | Efeito |
|---|---:|---|
| HP Max +5% (perma) | 10 | flat sobre HP base |
| ATK +5% (perma) | 10 | flat sobre ATK |
| Gold Gain +10% (perma) | 25 | aplica em gold/kill |
| Loot Gain +5% (perma) | 50 | aplica em drops |
| XP Gain +5% (perma) | 50 | aplica em XP/kill |
| Slot extra de skill ativa | 100 | +1 slot ate cap 12 |
| Bonus para Pet (atribui +5% efeito) | 75 | global |

Upgrades sao stackaveis ate cap definido. RP tambem pode ser usado para **respec** (resetar Chakra) com custo gratis primeira vez, depois 50 RP.

---

## 2. Transcendencia

### 2.1 Pre-requisitos

- Level 1000 atingido em ★10
- Codex completo:
  - Bestiario Z1-Z6 (todos inimigos comuns, elite, shiny opcional)
  - Materiais Z1-Z6 (todos os materiais coletados pelo menos 1x)
  - Zonas Z1-Z6 (todas exploradas 100%)
- Receitas e equipamento NAO precisam estar completos (sao mais demorados)

### 2.2 Conversao em Transcended Points

Ao transcender, todo o progresso acumulado vira poucos pontos:

```gdscript
const TP_LOG_DIVISOR: float = 10.0
const TP_KILLS_FACTOR: float = 100000.0  # 1 unidade extra por 100k kills
const TP_MIN: int = 1
const TP_MAX_FIRST: int = 50  # cap na primeira transcendencia

func transcended_points_from_progress(total_xp: float, kills_total: int, gold_earned_total: float, codex_completion: float) -> int:
    var xp_term = log(max(total_xp, 1.0) + 1.0)  # ~ ln(total_xp)
    var kills_term = 1.0 + kills_total / TP_KILLS_FACTOR
    var raw = xp_term * codex_completion * kills_term
    var points = int(floor(raw / TP_LOG_DIVISOR))
    return clamp(points, TP_MIN, TP_MAX_FIRST)
```

**Exemplo de calculo:**

| Cenario | total_xp | kills_total | codex_completion | TP ganhos |
|---|---:|---:|---:|---:|
| Speedrun (minimo) | 10^15 | 200.000 | 1.0 | (ln(10^15) * 1.0 * 3.0) / 10 = 10 |
| Normal | 10^18 | 1M | 1.0 | (ln(10^18) * 1.0 * 11) / 10 = 45 |
| Completista | 10^20 | 5M | 1.0 | clamp em 50 |
| Codex incompleto (50%) | 10^18 | 1M | 0.5 | 22 |

**Justificativa do log:** XP cresce em ordens de magnitude (10^15 -> 10^20 entre runs). Sem log, primeiros transcendencias dariam 0 e ultimos dariam milhoes. Log linealiza.

**Cap em 50 na primeira transcendencia:** evita "transcendencia perfeita" trivial. Limita o ramp inicial. Nas proximas transcendencias, o cap pode subir gradualmente:

```gdscript
func tp_cap_for_nth_transcendence(n: int) -> int:
    return 50 + n * 25  # T1: 50, T2: 75, T3: 100, T10: 300
```

### 2.3 T-level (nivel da arvore de transcendencia)

Cada vez que o jogador transcende, ele ganha TP que sao gastos na **Arvore de Transcendencia**. Cada no da arvore consumido conta como **+1 T-level**.

```gdscript
func transcendence_total_multiplier(t_level: int) -> float:
    return pow(2.0, max(0, t_level))
```

**Cada T-level dobra os stats finais.** Aplicado por cima de star_multiplier:

```gdscript
func final_stat_multiplier(stars: int, t_level: int, cosmic: int) -> float:
    return star_multiplier(stars) * transcendence_total_multiplier(t_level) * cosmic_multiplier(cosmic)
```

| T-level | Multiplicador final (vs T0) |
|---:|---:|
| T0 | 1.0x |
| T1 | 2.0x |
| T3 | 8.0x |
| T5 | 32.0x |
| T10 | 1024.0x |
| T20 | 1,05M x |

**Justificativa:** dobrar a cada T-level parece extremo, mas T-points sao *muito* raros (cap 50 inicial, alguns nos custam 10+ TP). Em pratica, T10 leva varias transcendencias.

### 2.4 Codex Transcendido

Pos-transcendencia, o jogo ganha "codex transcendido" — versoes corrupted/transcended dos inimigos com:
- Stats x4 (em cima da formula original)
- Novos drops, novos cards
- Novos comportamentos visuais

Detalhamento em `01_design/enemies-catalog.md` (referencia futura).

---

## 3. Ascensao Cosmica

### 3.1 Multiplicador Cosmico

Pre-definido em tabela:

```gdscript
const COSMIC_MULTIPLIERS = [1.0, 1.5, 2.0, 3.0, 5.0, 8.0, 12.0, 18.0, 26.0, 36.0]
const COSMIC_GROWTH_BEYOND: float = 1.4

func cosmic_multiplier(ascension_count: int) -> float:
    if ascension_count < COSMIC_MULTIPLIERS.size():
        return COSMIC_MULTIPLIERS[ascension_count]
    var last = COSMIC_MULTIPLIERS[COSMIC_MULTIPLIERS.size() - 1]
    var beyond = ascension_count - COSMIC_MULTIPLIERS.size() + 1
    return last * pow(COSMIC_GROWTH_BEYOND, beyond)
```

| Ascension count | Multiplicador |
|---:|---:|
| 0 (start) | 1.0x |
| 1 | 1.5x |
| 2 | 2.0x |
| 3 | 3.0x |
| 4 | 5.0x |
| 5 | 8.0x |
| 6 | 12.0x |
| 9 | 36.0x |
| 12 | 36 * 1.4^3 = 99x |
| 20 | 36 * 1.4^11 = 1.450x |

**Justificativa da tabela inicial:** valores selecionados manualmente seguindo Fibonacci-like (1, 1.5, 2, 3, 5, 8, 12...) para ter "saltos" perceptiveis a cada ascensao. Apos a 9a ascensao (endgame), passa a crescer 40% por ascensao.

### 3.2 Drop chance de Moeda Galactica

Apos primeira ascensao, inimigos comuns dropam Moeda Galactica em chance baixa:

```gdscript
const GALACTIC_BASE_CHANCE: float = 0.001
const GALACTIC_PER_ASCENSION: float = 0.001

func galactic_coin_drop_chance(ascension_count: int) -> float:
    return GALACTIC_BASE_CHANCE * ascension_count
```

| Ascension | Chance/kill |
|---:|---:|
| 1 | 0.1% |
| 5 | 0.5% |
| 10 | 1.0% |
| 20 | 2.0% |

Quantidade dropada: 1-3 por kill. Multiplicador via "Galactic Forge upgrades".

---

## 4. Acelerador Cosmico (Cosmic Accelerator)

### 4.1 Conceito

Mecanica desbloqueada apos primeira Ascensao. Multiplica a quantidade de cleans simulados de uma area, baseado em uma cleanada real.

```gdscript
func accelerator_yield(base_kills: int, base_drops: Array, accelerator_factor: float, modifiers: Dictionary) -> Dictionary:
    var multiplied_kills = int(floor(base_kills * accelerator_factor))
    var multiplied_drops: Array = []

    # Drops normais escalam linearmente
    for drop in base_drops:
        if not drop.is_special:  # special = elite/shiny obtido na cleanada
            multiplied_drops.append({
                "item": drop.item,
                "qty": int(floor(drop.qty * accelerator_factor))
            })

    # Drops especiais (elite/shiny) viram chance, nao garantia
    var elite_chance_per_clean: float = modifiers.get("elite_chance", 0.03)
    var shiny_chance_per_clean: float = modifiers.get("shiny_chance", 0.0005)
    for i in range(int(floor(accelerator_factor))):
        if randf() < elite_chance_per_clean:
            multiplied_drops.append({"item": modifiers.elite_loot, "qty": 1, "is_elite": true})
        if randf() < shiny_chance_per_clean:
            multiplied_drops.append({"item": modifiers.shiny_loot, "qty": 1, "is_shiny": true})

    return {
        "kills": multiplied_kills,
        "drops": multiplied_drops,
        "gold": int(floor(modifiers.gold_per_clean * accelerator_factor)),
        "xp": int(floor(modifiers.xp_per_clean * accelerator_factor))
    }
```

### 4.2 Limite de fator de aceleracao

```gdscript
const ACCELERATOR_FACTOR_BASE: float = 2.0   # primeira compra
const ACCELERATOR_FACTOR_MAX: float = 100.0  # cap absoluto, evita overflow

func accelerator_factor_for_level(upgrade_level: int) -> float:
    var f = ACCELERATOR_FACTOR_BASE * pow(1.5, upgrade_level)
    return min(f, ACCELERATOR_FACTOR_MAX)
```

| Upgrade level | Fator |
|---:|---:|
| 0 | 2.0x |
| 1 | 3.0x |
| 5 | 15.2x |
| 10 | 115x (cap 100x) |

Comprado com Moedas Galacticas + ouro.

### 4.3 Custo de uso

Cada uso do acelerador consome **Energia Cosmica** (recurso regenerativo, similar a stamina):

- Capacidade base: 100 EC
- Regenera: 1 EC / minuto real (24h = 1440 EC, ~14 cleans diarios em 100EC/clean)
- Cap aumenta com upgrades de Loja Eterna

Custo de 1 cleanada acelerada: `100 EC * (accelerator_factor / 2)` (entre 100 e 5000 EC). Forca o jogador a usar com sabedoria.

---

## 5. Multiplicador Final (todos combinados)

```gdscript
func compute_final_stat(base_stat: float, stars: int, t_level: int, cosmic: int, equip_bonus_pct: float, buff_pct: float) -> float:
    var ascension_mult = star_multiplier(stars) * transcendence_total_multiplier(t_level) * cosmic_multiplier(cosmic)
    var modifier_mult = (1.0 + equip_bonus_pct / 100.0) * (1.0 + buff_pct / 100.0)
    return base_stat * ascension_mult * modifier_mult
```

**Exemplo: HP base = 1.000 do jogador L1000 ★10 T5 Cosmic 3:**
- ascension_mult = 6.0 * 32.0 * 3.0 = 576x
- HP final base (sem equip/buff) = 576.000

Se equipamento da +200% e buff de poção +50%:
- modifier_mult = 3.0 * 1.5 = 4.5
- HP final total = 576.000 * 4.5 = 2.592.000

Numeros enormes, mas justos para encarar inimigos T+ corruptos com HP 100M+.

---

## 6. Constantes-chave

| Const | Valor | Onde |
|---|---:|---|
| STAR_MULT_PER_STAR | 0.5 | rebirth |
| Cap de estrelas | 10 | rebirth |
| REBIRTH_POINTS_PER_10_LEVELS | 1 | rebirth |
| REBIRTH_POINTS_STAR_BONUS | 1.0 | rebirth |
| TP_LOG_DIVISOR | 10.0 | transcendence |
| TP_KILLS_FACTOR | 100.000 | transcendence |
| TP_MIN / TP_MAX_FIRST | 1 / 50 | transcendence |
| transcendence multiplier | 2^t_level | transcendence |
| COSMIC_MULTIPLIERS[0..9] | [1, 1.5, 2, 3, 5, 8, 12, 18, 26, 36] | cosmic |
| COSMIC_GROWTH_BEYOND | 1.4 | cosmic (ascension > 9) |
| GALACTIC_BASE_CHANCE | 0.001 | cosmic |
| ACCELERATOR_FACTOR_BASE | 2.0 | accelerator |
| ACCELERATOR_FACTOR_MAX | 100.0 | accelerator |

**Tunaveis criticos:** `STAR_MULT_PER_STAR`, expoente da transcendencia (atual = 2.0), `COSMIC_MULTIPLIERS`. Esses 3 controlam pacing de prestige inteiro.
