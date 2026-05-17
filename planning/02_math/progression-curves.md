# Curvas de Progressao

> Curvas matematicas que regem XP, gold, stats de inimigos e stats do jogador. Todas as formulas estao em pseudo-codigo aplicavel direto em GDScript (Godot 4.6).

## 1. Curva de XP

### 1.1 Formula vigente

A formula atual de `scripts/systems/xp_curve.gd` e a base. Mantida por ja ter sido validada empiricamente no MVP.

```gdscript
const BASE: float = 10.0
const POW_EXP: float = 2.0
const GROWTH: float = 1.07

func xp_to_next(level: int) -> int:
    var l: float = max(1, level)
    return int(floor(BASE * pow(l, POW_EXP) * pow(GROWTH, l)))
```

A combinacao **polinomial (level^2) x exponencial (1.07^level)** e o padrao classico de cRPGs idle (Melvor, Idle Heroes, NGU). O termo polinomial domina cedo (level 1-50), o exponencial assume tarde (level 200+). Isso evita "XP wall" abrupto e mantem a sensacao de progresso fluida.

### 1.2 Tabela de milestones (XP por nivel e cumulativo)

Calculo: `xp_to_next(level)` e `cumulative_xp(level) = sum(xp_to_next(i) for i in 1..level-1)`.

| Level | xp_to_next(L) | Cumulative XP ate L |
|---:|---:|---:|
| 1 | 10 | 0 |
| 5 | 350 | 654 |
| 10 | 1.967 | 5.025 |
| 25 | 33.948 | 219.116 |
| 50 | 736.349 | 8.918.654 |
| 75 | 7.398.621 | 169.245.000 |
| 100 | 73.917.000 | 2.470.000.000 |
| 200 | 1,67 x 10^14 | ~5,4 x 10^15 |
| 500 | 7,71 x 10^36 | ~3,3 x 10^38 |
| 1000 | 1,86 x 10^77 | ~1,3 x 10^79 |

### 1.3 Validacao: int64 overflow

`int64.MAX = 9.22 x 10^18`. A formula explode em **L ~ 215** (passa de 10^18). Ou seja, em pre-Transcendencia (cap 1000), os numeros precisam **virar BigInt ou ser representados em ponto flutuante** para HUD/save. Decisao:

- **Internamente:** XP guardado como `float` (53 bits de mantissa, suporta ate ~9 x 10^15 sem perda; alem disso, perda de precisao mas nao crash).
- **HUD:** mostrar com sufixos (K, M, B, T, Q, ...) ou notacao cientifica em level 50+.
- **Saves:** serializar como string para preservar precisao em level cap (1000).

### 1.4 Tempo estimado por milestone (com kills/min e xp/kill por zona)

Premissas: kills_per_min = 30 (auto-battle, sem speed-up), xp_per_kill segue `enemy_xp_reward(level)` da formula vigente.

| Marco | Zona alvo | Inimigo lvl medio | XP/kill | XP/min | Tempo (h) |
|---|---|---:|---:|---:|---:|
| L1 -> L10 | Z1 | 3 | ~25 | 750 | ~0,1 |
| L10 -> L25 | Z1-Z2 | 12 | ~520 | 15.600 | ~0,3 |
| L25 -> L50 | Z2-Z3 | 35 | ~31.000 | 930.000 | ~2,8 |
| L50 -> L75 | Z3-Z4 | 60 | ~3,1M | ~93M | ~5,5 |
| L75 -> L100 | Z4 | 85 | ~330M | ~9,9B | ~12 |
| L100 -> L200 | Z5 | 150 | ~5T | ~150T | ~80 |
| L500 -> L1000 | Z6+T+ | 750 | ~10^60 | ~10^61 | absurdo sem multiplicadores |

**Conclusao:** sem multiplicadores de Renascimento/Transcendencia/Constelacoes, atingir L1000 e literalmente impossivel. Esta e a intencao: a curva forca o jogador a **prestigir** ao redor de L100-150, voltar com multiplicadores, e cada renascimento corta tempo em ordens de magnitude. Mesma filosofia de NGU Idle / Melvor com prestige scrolls.

### 1.5 Constantes propostas finais

| Constante | Valor | Justificativa |
|---|---:|---|
| BASE | 10.0 | Mantido. xp_to_next(1) = 10 e amigavel. |
| POW_EXP | 2.0 | Quadratico classico. Cookie Clicker, Realm Grinder usam expoente 1.5-2.0 em layers basicas. |
| GROWTH | 1.07 | Mantido. 7%/level e a "regra de 72": dobra a cada ~10 levels. Idle Slayer usa 1.05, IdleOn ~1.08. |

**[DECISAO PENDENTE]:** se o player chegar mais rapido que o esperado em L100, considerar GROWTH = 1.075 ou 1.08. Tunavel sem refator.

---

## 2. Curva de Gold-per-Kill por Zona

### 2.1 Formula

```gdscript
const BASE_GOLD: int = 1
const GOLD_GROWTH: float = 1.6  # crescimento entre zonas
const GOLD_LEVEL_FACTOR: float = 0.10  # bonus por nivel do inimigo

func gold_per_kill(zone_index: int, enemy_level: int) -> int:
    var z: float = max(1, zone_index)
    var l: float = max(1, enemy_level)
    var raw: float = BASE_GOLD * pow(GOLD_GROWTH, z - 1) * (1.0 + GOLD_LEVEL_FACTOR * l)
    return int(floor(raw))
```

`GOLD_GROWTH = 1.6` significa que gold/kill na Z6 e ~10x maior que na Z1 (1.6^5 ~= 10.5). Isso e suficiente para tornar Z6 atrativa para farmar gold, sem trivializar economia da Z1 (early-game ainda precisa de gold).

### 2.2 Tabela: gold/kill por zona

Niveis "tipicos" do inimigo medio na zona (referenciar `recommended_player_level` em `balance-tables.md`):

| Zona | Inimigo lvl baixo | Gold (baixo) | Inimigo lvl medio | Gold (medio) | Inimigo lvl alto | Gold (alto) |
|---:|---:|---:|---:|---:|---:|---:|
| Z1 (Floresta) | 1 | 1 | 12 | 2 | 25 | 3 |
| Z2 (Deserto) | 25 | 5 | 50 | 7 | 75 | 10 |
| Z3 (Caverna) | 75 | 22 | 110 | 30 | 150 | 39 |
| Z4 (Pantano) | 150 | 92 | 225 | 130 | 300 | 167 |
| Z5 (Vulcao) | 300 | 386 | 450 | 552 | 600 | 717 |
| Z6 (Ruinas) | 600 | 1.642 | 800 | 2.130 | 1000 | 2.617 |

### 2.3 Modificadores

| Modificador | Multiplicador no gold |
|---|---:|
| Inimigo Elite | 3x |
| Inimigo Shiny | 10x |
| Inimigo Dungeon | 5x |
| Boss de estagio | 50x |
| Boss de zona | 100x |
| Mini-boss | 15x |
| Buff de evento (festival) | +50% adicional (multiplicativo no total) |
| Stat "Gold Gain %" do jogador | (1 + gold_gain_pct/100) multiplicativo |

```gdscript
func apply_gold_modifiers(base: int, mods: Dictionary) -> int:
    var total: float = base
    if mods.get("is_elite", false): total *= 3.0
    if mods.get("is_shiny", false): total *= 10.0
    if mods.get("is_dungeon", false): total *= 5.0
    if mods.get("is_stage_boss", false): total *= 50.0
    if mods.get("is_zone_boss", false): total *= 100.0
    if mods.get("is_mini_boss", false): total *= 15.0
    total *= (1.0 + mods.get("event_bonus_pct", 0.0) / 100.0)
    total *= (1.0 + mods.get("player_gold_gain_pct", 0.0) / 100.0)
    return int(floor(total))
```

---

## 3. Curva de Stats de Inimigos (HP / ATK / DEF)

### 3.1 Premissas

Cada zona Z (1..6), cada estagio S (1..10), cada area A (1..8). Estagio 10 termina em boss. Areas crescem progressivamente.

`attack_speed` **NAO** escala por formula global. E definido por inimigo (resource `.tres`), variando entre 0.4 e 1.5 com base em arquetipo (slime lento, lobo rapido).

### 3.2 Formulas

```gdscript
# Bases globais.
const BASE_HP: float = 20.0
const BASE_ATK: float = 3.0
const BASE_DEF: float = 1.0

# Crescimento dentro de uma zona.
const HP_GROWTH_PER_AREA: float = 1.08
const HP_GROWTH_PER_STAGE: float = 1.30
# Crescimento entre zonas (salto significativo).
const HP_GROWTH_PER_ZONE: float = 4.0

# ATK cresce um pouco mais devagar (HP > ATK para combate idle nao virar one-shot).
const ATK_GROWTH_PER_AREA: float = 1.06
const ATK_GROWTH_PER_STAGE: float = 1.22
const ATK_GROWTH_PER_ZONE: float = 3.0

# DEF cresce devagar (def alta demais quebra DPS).
const DEF_GROWTH_PER_AREA: float = 1.04
const DEF_GROWTH_PER_STAGE: float = 1.15
const DEF_GROWTH_PER_ZONE: float = 2.2

# Bonus por nivel individual do inimigo (nivel determinado em .tres).
const ENEMY_LEVEL_FACTOR: float = 0.05

func enemy_hp(zone: int, stage: int, area: int, level: int) -> int:
    var z = max(1, zone); var s = max(1, stage); var a = max(1, area); var l = max(1, level)
    var raw = BASE_HP \
        * pow(HP_GROWTH_PER_AREA, a - 1) \
        * pow(HP_GROWTH_PER_STAGE, s - 1) \
        * pow(HP_GROWTH_PER_ZONE, z - 1) \
        * (1.0 + ENEMY_LEVEL_FACTOR * l)
    return int(floor(raw))

func enemy_atk(zone: int, stage: int, area: int, level: int) -> int:
    var z = max(1, zone); var s = max(1, stage); var a = max(1, area); var l = max(1, level)
    var raw = BASE_ATK \
        * pow(ATK_GROWTH_PER_AREA, a - 1) \
        * pow(ATK_GROWTH_PER_STAGE, s - 1) \
        * pow(ATK_GROWTH_PER_ZONE, z - 1) \
        * (1.0 + ENEMY_LEVEL_FACTOR * l)
    return int(floor(raw))

func enemy_def(zone: int, stage: int, area: int, level: int) -> int:
    var z = max(1, zone); var s = max(1, stage); var a = max(1, area); var l = max(1, level)
    var raw = BASE_DEF \
        * pow(DEF_GROWTH_PER_AREA, a - 1) \
        * pow(DEF_GROWTH_PER_STAGE, s - 1) \
        * pow(DEF_GROWTH_PER_ZONE, z - 1) \
        * (1.0 + ENEMY_LEVEL_FACTOR * l)
    return int(floor(raw))
```

### 3.3 Validacao com inimigos atuais

Os `.tres` atuais (Blue Slime: hp=22 atk=3 lvl=2; Red Slime: hp=80 atk=7 lvl=5) devem cair em zona/estagio/area baixos.

`enemy_hp(1, 1, 1, 2) = 20 * 1.0 * 1.0 * 1.0 * 1.10 = 22` -> bate com Blue Slime.
`enemy_hp(1, 2, 1, 5) = 20 * 1.0 * 1.30 * 1.0 * 1.25 = 32,5` -> Red Slime tem 80 (esta acima do esperado, mas Red Slime e mini-elite 5x, nao monstro comum).

### 3.4 Tabela: HP medio do inimigo na area-tipica do meio (S5, A4) de cada zona

| Zona | Inimigo lvl medio | HP base (S5,A4) | ATK base | DEF base |
|---:|---:|---:|---:|---:|
| Z1 | 12 | 121 | 12 | 2 |
| Z2 | 50 | 1.694 | 92 | 11 |
| Z3 | 110 | 19.500 | 590 | 38 |
| Z4 | 225 | 199.300 | 3.444 | 109 |
| Z5 | 450 | 1.700.000 | 18.250 | 273 |
| Z6 | 800 | 12.500.000 | 87.000 | 575 |

(Numeros arredondados; usar formula para valores exatos.)

---

## 4. Curva de Stats do Jogador

### 4.1 Por nivel

```gdscript
# Sao bases POR NIVEL alocado, nao crescimento auto.
# Stats principais sobem por (a) nivel base do personagem (b) pontos alocados (c) equip (d) buffs.
# Aqui modelamos o crescimento "natural" de stats base que vem com level.

const PLAYER_HP_BASE: int = 50
const PLAYER_HP_PER_LEVEL: int = 10
const PLAYER_MP_BASE: int = 20
const PLAYER_MP_PER_LEVEL: int = 4
const PLAYER_ATK_BASE: int = 5
const PLAYER_ATK_PER_LEVEL: int = 2
const PLAYER_DEF_BASE: int = 2
const PLAYER_DEF_PER_LEVEL: int = 1

# Soft cap: passados N levels, ganho por level cai em escala log.
const PLAYER_SOFT_CAP_LEVEL: int = 100

func player_hp_max(level: int) -> int:
    var l = max(1, level)
    if l <= PLAYER_SOFT_CAP_LEVEL:
        return PLAYER_HP_BASE + l * PLAYER_HP_PER_LEVEL
    var soft = PLAYER_HP_BASE + PLAYER_SOFT_CAP_LEVEL * PLAYER_HP_PER_LEVEL
    var extra = log(l - PLAYER_SOFT_CAP_LEVEL + 1.0) * PLAYER_HP_PER_LEVEL * 5.0
    return int(floor(soft + extra))

func player_atk_base(level: int) -> int:
    var l = max(1, level)
    if l <= PLAYER_SOFT_CAP_LEVEL:
        return PLAYER_ATK_BASE + l * PLAYER_ATK_PER_LEVEL
    var soft = PLAYER_ATK_BASE + PLAYER_SOFT_CAP_LEVEL * PLAYER_ATK_PER_LEVEL
    var extra = log(l - PLAYER_SOFT_CAP_LEVEL + 1.0) * PLAYER_ATK_PER_LEVEL * 5.0
    return int(floor(soft + extra))

# Equivalentes para MP, DEF, com mesma estrutura.
```

**Por que soft cap?** Sem ele, um jogador L1000 com (PLAYER_HP_PER_LEVEL=10) teria 10.050 HP base. Inimigos da Z6 batem por 87.000+. Com soft cap, jogador depende de equip+stars+constelacoes para fechar o gap, o que e o design intencional. Esta e a mesma decisao que o Idle Heroes usa: stats base "platam" cedo, multiplicadores fazem o late-game.

### 4.2 Multiplicadores de Estrela (Renascimento)

```gdscript
func star_multiplier(stars: int) -> float:
    return 1.0 + 0.5 * clamp(stars, 0, 10)
```

| Estrelas | Multiplicador | Level cap |
|---:|---:|---:|
| 0 (start) | 1.0x | 100 |
| 1 | 1.5x | 200 |
| 2 | 2.0x | 300 |
| 3 | 2.5x | 400 |
| 5 | 3.5x | 600 |
| 7 | 4.5x | 800 |
| 10 | 6.0x | 1000 |

Aplicado em **HP, MP, ATK, DEF totais** (apos equip e pontos). Ver `ascension-multipliers.md` para detalhes.

### 4.3 Multiplicador de Transcendencia

```gdscript
func transcendence_multiplier(t_level: int) -> float:
    return pow(2.0, max(0, t_level))  # cada T-level dobra os stats finais
```

T1 = 2x, T5 = 32x, T10 = 1024x. Cresce muito rapido, mas T-points sao raros (ver `ascension-multipliers.md`).

### 4.4 Stat cap

- **Hard cap nao existe** (nao queremos parede absoluta antes de Cosmic Ascension).
- **Soft cap**: a partir de L100 (=PLAYER_SOFT_CAP_LEVEL), ganho por level cai em escala log.
- **Cap visivel pos-Transcendencia**: stats sao multiplicados por `transcendence_multiplier`, mas a interpolacao log continua valida sobre o resultado base.

---

## 5. Tabela Final Consolidada: Milestones

| Level | xp_to_next | Cumulative | Gold/kill (Z1) | Gold/kill (Z3) | Gold/kill (Z6) | Player HP base | Player ATK base |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 10 | 0 | 1 | - | - | 60 | 7 |
| 5 | 350 | 654 | 1 | - | - | 100 | 15 |
| 10 | 1.967 | 5.025 | 2 | - | - | 150 | 25 |
| 25 | 33.948 | 219.116 | 3 | - | - | 300 | 55 |
| 50 | 736.349 | 8.918.654 | - | 22 | - | 550 | 105 |
| 75 | 7.398.621 | 169.245.000 | - | 30 | - | 800 | 155 |
| 100 | 73.917.000 | 2,47B | - | 39 | 1.642 | 1.050 | 205 |
| 200 | 1,67 x 10^14 | 5,4 x 10^15 | - | - | 1.880 | 1.078 | 209 |
| 500 | 1,67 x 10^14 | 3,3 x 10^38 | - | - | 2.290 | 1.116 | 215 |
| 1000 | 1,86 x 10^77 | 1,3 x 10^79 | - | - | 2.617 | 1.150 | 220 |

(Player HP/ATK base nas linhas L200+ assumem soft cap ativo. Sem multiplicadores de star/transcendence o jogador nao sobrevive em Z5+.)

---

## Atualizacao 2026-05-06: Velocidade do jogo

(RESOLVIDO 2026-05-06 #14): velocidade base do jogo e' **1x e 2x desde o inicio** (toggle disponivel sem unlock). 4x e 8x viram unlocks progressivos via Renascimento + Loja Eterna.

Implicacao para esta documentacao: as curvas de XP, gold, stats e mastery NAO dependem da velocidade. Speed multiplica somente o tempo (delta) entregue ao loop de combate/gathering, nao a curva matematica em si. As tabelas de "tempo estimado por milestone" nas secoes 1.4 e 2 assumem 1x. Em 2x os mesmos milestones acontecem em metade do tempo de relogio. NAO precisa rebalancear formulas.

---

## 7. Eficiencia de Gathering (RESOLVIDO 2026-05-06 #15)

> Ponto unico de verdade da formula. `01_design/gathering-materials.md` secao 9 contem as tabelas tunavies; aqui fica a formula matematica que o engine usa.

### 7.1 Formula

```gdscript
func eficiencia(personagem, skill_id: String) -> int:
    var base: float = 0.0
    base += personagem.mastery[skill_id] * 1.0                           # 1 por nivel de Mastery
    base += personagem.level * 0.5                                       # 0.5 por nivel
    base += class_affinity_bonus(personagem.class, skill_id)             # 0..50 (ver 7.2)
    base += tool_efficiency(personagem.equipped_tool[skill_id])          # 0..300 (ver 7.3)
    return int(base)
```

### 7.2 `class_affinity_bonus`

Constante por (classe, skill). Tabela completa em `01_design/gathering-materials.md` secao 9.4. Resumo: 0 (nao afim), 20 (afinidade alt), 30 (afinidade primaria). Cap superior atual = 50 (espaco para futuros bonuses).

### 7.3 `tool_efficiency`

Constante por tier da ferramenta equipada. T1=+5, T2=+20, T3=+50, T4=+100, T5=+180, T6=+300. Tabela completa em `01_design/gathering-materials.md` secao 9.5.

### 7.4 Drop chance

```gdscript
func drop_chance(personagem, node) -> float:
    var efic = eficiencia(personagem, node.skill_id)
    if efic >= node.eficiencia_minima:
        return 1.0
    return clamp(float(efic) / float(node.eficiencia_minima), 0.0, 1.0)
```

`node.eficiencia_minima` por tier (proposta): T1=10, T2=25, T3=50, T4=100, T5=200, T6=400. `[a tunar em playtest]`.

### 7.5 Constantes-chave

| Const | Valor proposto | Onde |
|---|---:|---|
| MASTERY_EFICIENCIA_PER_LEVEL | 1.0 | eficiencia |
| CHARACTER_LEVEL_EFICIENCIA_FACTOR | 0.5 | eficiencia |
| CLASS_AFFINITY_PRIMARY | 30 | eficiencia |
| CLASS_AFFINITY_ALT | 20 | eficiencia |
| TOOL_EFICIENCIA_T1..T6 | 5/20/50/100/180/300 | eficiencia |
| NODE_EFICIENCIA_MIN_T1..T6 | 10/25/50/100/200/400 | drop chance |

---

## 8. Constantes-chave do Documento (resumo)

| Const | Valor | Onde |
|---|---:|---|
| BASE (XP) | 10.0 | xp_curve |
| POW_EXP (XP) | 2.0 | xp_curve |
| GROWTH (XP) | 1.07 | xp_curve |
| BASE_GOLD | 1 | gold_per_kill |
| GOLD_GROWTH | 1.6 | gold_per_kill |
| GOLD_LEVEL_FACTOR | 0.10 | gold_per_kill |
| BASE_HP / BASE_ATK / BASE_DEF | 20 / 3 / 1 | enemy stats |
| HP_GROWTH_PER_ZONE | 4.0 | enemy stats |
| HP_GROWTH_PER_STAGE | 1.30 | enemy stats |
| HP_GROWTH_PER_AREA | 1.08 | enemy stats |
| PLAYER_HP_BASE / PER_LEVEL | 50 / 10 | player stats |
| PLAYER_ATK_BASE / PER_LEVEL | 5 / 2 | player stats |
| PLAYER_SOFT_CAP_LEVEL | 100 | player stats |

Ajustes finos (1.06 -> 1.08 etc.) sao tunavies sem refator.
