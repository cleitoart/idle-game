# Sintese: Stats e Curva de Progressao

> Mescla informada das 3 referencias (Incremental Epic Hero 2, Legends of IdleOn,
> Cookie Clicker). Material de pesquisa, nao decisao final. Decisoes que precisam
> de input estao marcadas `[DECISAO PENDENTE]`.

Fontes lidas (paths absolutos):
- `C:\Users\Carlos Henrique\idle-game\references\ieh2_dump\docs\00-overview.md`
- `C:\Users\Carlos Henrique\idle-game\references\ieh2_dump\docs\02-heroes-and-stats.md`
- `C:\Users\Carlos Henrique\idle-game\references\ieh2_dump\docs\03-progression-curves.md`
- `C:\Users\Carlos Henrique\idle-game\references\ieh2_dump\docs\17-combat.md`
- `C:\Users\Carlos Henrique\idle-game\references\idleon-reference\INDEX.md`
- `C:\Users\Carlos Henrique\idle-game\references\idleon-reference\XP_CURVES.md`
- `C:\Users\Carlos Henrique\idle-game\references\idleon-reference\COMBAT_MATH.md`
- `C:\Users\Carlos Henrique\idle-game\references\cookie-clicker-dump\02-formulas-core.md`

Documentos do projeto consultados:
- `STATE-OF-THE-PROJECT.md` (snapshot 2026-05-14)
- `planning/02_math/progression-curves.md`
- `planning/02_math/damage-formula.md`
- `planning/02_math/balance-tables.md`
- `planning/01_design/classes-and-characters.md`

---

## 1. Como cada jogo faz

### 1.1 Cookie Clicker

Genero diferente (clicker puro, sem stats de personagem), porem **a engenharia
de compound growth e cap pratico e exatamente o problema que um idle RPG
enfrenta** — alguem comprou um sistema escalavel em 2013 e ele aguenta 12 anos
de inflacao numerica sem quebrar. Vale como modelo de "como fazer numero gigante
parecer legivel".

#### Compound growth via multiplicadores empilhados

Fonte: `cookie-clicker-dump/02-formulas-core.md` secao 1 (linhas 13-46 do
md, `main.js:4934-5172`).

A producao final (cookies/seg) e' o resultado de **muitas multiplicacoes
sequenciais** sobre um valor base de cada edificio. Estrutura simplificada:

```
cookiesPs_edificio = baseCps
                   x tieredMult         (cada tier comprado x2)
                   x synergies          (1 + 0.05 x other_building.amount)
                   x fortuneMult        (x1.07 se fortune comprada)
                   x grandmaSynergy     (1 + grandmas x 0.01/(id-1))
                   x levelMult          (1 + level x 0.01)
                   x buildMult          (gods)
                   x amount             (qty comprada)
cookiesPs = SUM(cookiesPs_edificio) x multGlobal
```

`multGlobal` por si so empilha ~20 fatores (prestige, kittens, eggs, dragon
auras, season events, buffs). No endgame, **multGlobal atinge 10^9+** durante
combo de buffs (cookie-clicker-dump/02-formulas-core.md linha 386).

**Padrao replicavel:** cada bonus carrega uma tag/fonte e e' aplicado como
`stat *= (1 + bonus_pct)` ou `stat *= flat_mult`. Isso ja existe parcialmente
em IEH2 via `Multiplier` (ver IEH2 01-architecture.md, citado em 00-overview.md
linha 50).

#### Crescimento de custo de edificios: 1.15^n

Fonte: `cookie-clicker-dump/02-formulas-core.md` secao 4 (linhas 196-205).

```
price = basePrice x 1.15^max(0, amount - free)
```

`Game.priceIncrease = 1.15` (`main.js:7673`, citado na linha 415 do md). 15%
por compra e' a constante classica do genero idle desde Cookie Clicker (2013).
Tres propriedades importantes:

1. Garante que a Nth compra custe ~`1.15^N` vezes a primeira -> 50 compras =
   `1.15^50 ~= 1.083` mil vezes o preco inicial.
2. A renda do edificio escala linearmente com `amount` (n unidades x cps), mas o
   custo escala exponencialmente. Resultado: **payback time aumenta com cada
   compra** mas nunca explode (porque novos tiers de edificios destravam).
3. Permite multibuy (5x, 10x, 25x) usando soma de PG (progressao geometrica):
   `total = base * (r^n - 1) / (r - 1)` com `r = 1.15`.

#### Prestige curva: raiz cubica

Fonte: `cookie-clicker-dump/02-formulas-core.md` secao 6 (linhas 260-283,
`main.js:3967`).

```
heavenly_chips = (cookies_total / 1e12) ^ (1/3)
```

Expoente 1/3 significa **dobrar prestige exige 8x mais cookies**. E uma escolha
deliberada de Orteil: forca runs cada vez mais longos pra ter ganho marginal.
Cookie Clicker comentado no md (linha 279): "expoente 1/3 e' mais agressivo
que 1/2 (Realm Grinder). Cria runs cada vez mais longos."

Aplicavel ao Idle Medieval: a **Estrela de Renascimento** atual usa
`star_multiplier(s) = 1 + 0.5*s` linear ate cap 10. Isso e' o oposto — mais
estrelas sao **igualmente faceis** de conseguir. Se quisermos forcar runs
crescentes, uma curva `stars = (cumulative_level / X)^(1/3)` segue o
pattern Cookie Clicker.

#### Heavenly multiplier gate (pattern de "destrava o prestige")

Fonte: `cookie-clicker-dump/02-formulas-core.md` secao 6 (linhas 284-305).

Cookie Clicker tem cinco upgrades celestiais que somam ate 100% do bonus de
chip. **Sem comprar nenhum, prestige nao da CPS** (`heavenlyPower = 1` x
`heavenlyMultiplier = 0` = `0%`). Brilhante: forca o player a entender que
"resetar e' gratis no inicio do prestige" porque ele primeiro precisa investir
os heavenly chips em upgrades que destravam o ganho. Padrao replicavel pro
Renascimento.

#### Cap pratico: nao ha hard cap

Cookie Clicker nao tem level cap. O cap pratico vem do desinteresse do jogador
quando os incrementos por hora ficam < 1% da reserva total. IEH2 fixa
`maxHeroLevel = 3000` (`02-heroes-and-stats.md` linha 117). **Filosofias
diferentes**: Cookie aceita inflacao infinita, IEH2 prefere walls.

---

### 1.2 Legends of IdleOn

IdleOn e' o jogo de referencia mais proximo do Idle Medieval em arquetipo
(idle RPG multi-personagem, auto-battle, gathering paralelo). E' por isso
que vale ler com mais profundidade.

#### Stats primarios: STR / AGI / WIS / LUK + cruzamento de accuracy

Fonte: `idleon-reference/COMBAT_MATH.md` secao 2 (linhas 30-51).

| Classe family | mainStat | accuracyStat |
|---|---|---|
| Warrior / Barbarian | STR | WIS |
| Archer / Bowman | AGI | STR |
| Mage / Wizard | WIS | AGI |
| Beginner / Maestro | LUK | LUK |

O ponto critico aqui e' a **escolha cruzada**: a stat principal de uma classe
nao da accuracy pra propria classe. Warrior precisa de WIS pra acertar mesmo
mirando em STR pra dano. Resultado: dump 100% em STR vira "tudo errado". Isso
forca build hibrida e e' citado no md (linha 42): "A escolha cruzada forca
build hibrida — nao da pra dump 100% num stat so".

Idleon tem apenas 4 stats (STR, AGI, WIS, LUK). **Sem VIT, sem INT separado.**
HP vem de itens e bubbles, nao de stat de personagem.

#### XP curve canonica: (polinomial + linear) x geometrico - offset

Fonte: `idleon-reference/XP_CURVES.md` secao "Estrutura genérica" (linhas
35-52).

```
expReq(Lv) = (BASE + Lv^POW + LINEAR x Lv) x (GEOM_BASE - decay)^Lv - OFFSET
onde decay = min(CAP, COEF x Lv / (Lv + SOFT))
```

Forma decomposta:
- `BASE`: piso (15 ate 100 conforme skill).
- `Lv^POW`: termo polinomial (POW varia entre 1.3 e 3 conforme skill).
- `LINEAR x Lv`: tempero linear.
- `(GEOM_BASE - decay)^Lv`: geometrico **com base que reduz com level**.
- `decay = min(CAP, COEF x Lv / (Lv + SOFT))`: comeca em 0, cresce ate CAP.

**Por que e' interessante** (md linha 47-52): em Lv baixo a base e' alta
(~1.21^Lv = +21%/level, sensacao de progresso rapido); em Lv alto a base baixa
(~1.05^Lv = +5%/level, progresso lento e estavel). Tudo isso **sem mudar de
formula** — e' a propria geometrica que se atenua.

Constantes da skill Character (Lv geral):

```
expReq(Lv) = (15 + Lv^1.9 + 11 x Lv)
           x (1.208 - min(0.164, 0.215 x Lv/(Lv+100)))^Lv
           - 15
```

Marcos numericos (md linha 67-72):

| Lv | XP req |
|---|---|
| 1 | 13 |
| 10 | 405 |
| 50 | 90 k |
| 100 | 18 M |
| 200 | 18 G |

Note como a curva fica **mais leve** que a vigente do Idle Medieval no L100:
`progression-curves.md` linha 32 ja mostra `cumulative XP ate L100 = 2.47B`
(quase 1.4x maior). Reforco em secao 4.

#### Combat math: dano via WP^2 + stat + soft caps duplos

Fonte: `idleon-reference/COMBAT_MATH.md` secao 3 (linhas 56-72) e secao 4
(linhas 73-97).

```
weaponPowerEffect = ((WP x (1 + talentMods/100) + baseWP) / 3)^2     (QUADRATICO)
                  + damageFromStat
                  + goldenFood
                  + min(150, 2*WP + damageFromStat)
                  + arcadeBonus + owlBonus + vaultBonuses

damage = weaponPowerEffect + stamps + equipment + obols + ...
       + (hpBubble x log(maxHP - 250))     (LOG do excesso acima de threshold)
       + (speedBubble x log2(speed/100 - 0.1) / 0.25)
       + (mpBubble x log(maxMP - 150))
       + cardBonus + sigil

if damage > 4000:  damage = 4000  + (damage - 4000)^0.91
if damage > 15000: damage = 15000 + (damage - 15000)^0.84

damage += foodBonus    (FOOD aplicada DEPOIS dos soft caps, sem teto)
```

Tres patterns chave aqui:

1. **WP entra ao quadrado**. Cada ponto de WP vale absurdamente mais que cada
   ponto de stat. Isso e' a razao pela qual builds de Idleon priorizam arma
   antes de tudo.
2. **Soft cap polinomial** `cap + (excess)^p` com `p < 1`. Padrao anti-inflacao
   classico do genero. A cada threshold (4k, 15k), o expoente diminui (0.91 ->
   0.84) e o "preco" pra dobrar dano sobe.
3. **Food adicionada DEPOIS do soft cap** = canal de progressao tardia que
   escapa do cap. Quem investe em food no late game tem ganho linear contra os
   demais que estagnam.

Para Hit Chance (md secao 5, linhas 100-133):

```
effective = playerAccuracy / monsterDefence
hitChance = 0     se effective < 0.5
          = min(100 x (0.95 x effective - 0.425), 100)% caso contrario
```

**Accuracy gate**: se voce nao tem 0.5x a defesa do monstro, **literalmente
nao acerta nada**. Hit cap em `effective >= 1.5` (md linha 130-131). Cria
portoes duros de progressao — antes de zona nova, precisa subir accuracy.

#### Mastery (RNG dampening)

Fonte: `idleon-reference/COMBAT_MATH.md` secao 1 (linhas 18-28).

```
maxDamage = baseDamage x perDamage x percentDamage
minDamage = mastery x maxDamage
mastery = clamp(0.35 + bonuses/100, max = 0.80)
```

Default: dano varia entre 35% e 100% do max. Cap em 80% (variancia 80-100%).
"RNG dampening" — quanto mais investe, menos variavel fica. Excelente UX
porque player sente "estou ficando consistente" sem perder a aleatoriedade.

#### 11 formulas diferentes de XP por skill

Fonte: `XP_CURVES.md` secao toda. Cada skill (Mining, Smithing, Construction,
Worship, Breeding, Lab, Sailing, Divinity, Gaming, Farming, Sneaking,
Summoning, Spelunking, Research) tem **formula propria**.

Examples notaveis:
- **Construction (skill 8)**: muda de regime em Lv 71. Antes: geometrico
  ~1.05; depois: 1.003 (essencialmente polinomial puro). "Rebalanceio no
  meio da curva."
- **Breeding (skill 11)**: `(10 + Lv^1.9 + 10*Lv) * 1.11^Lv`. Sem decay. Geometrico
  puro a 11% — projetado pra ser apertado eternamente.
- **Lab (skill 12)**: brutal em Lv 1-4 (`6.4*Lv*1.6^Lv` = 60%/level), depois
  abre. "Muro inicial" pra forcar investimento concentrado.
- **Gaming (skill 15)**: 1.13^Lv ate Lv 20, depois 1.13^Lv x 1.13^(Lv-20) =
  **base efetiva 1.28** (28%/level). "Wall artificial em Lv 20-30."
- **Farming (skill 16)**: 4 exponenciais multiplicadas — mais brutal do jogo.
- **Research (skill 20)**: expoente dinamico `Lv^(1 + 0.04*Lv/10)`. A polinomial
  fica progressivamente mais ingreme.

**Conclusao para o Idle Medieval**: o jogo vigente trata XP como **uma curva
unica para o nivel do personagem**. IdleOn diferencia por skill — Mining tem
sua curva, Smithing outra, Cooking outra. Se adotarmos Mastery por skill (ja
mencionado em `02_math/progression-curves.md` secao 7.5), e' o caso de pensar
em **curva propria por Mastery**.

#### Padroes universais de IdleOn (do INDEX.md secao 15)

Citados em `idleon-reference/INDEX.md` linhas 105-135. Os mais relevantes pra
o nosso projeto:

1. Soft caps polinomiais `cap + (excess)^p, p<1` — padrao anti-inflacao
   universal.
2. Stat principal cruzado com accuracy — forca build hibrida.
3. Bonus + curse no mesmo upgrade (prayers de Idleon) — trade-offs explicitos.
4. `func: "decay"` para 50%+ dos talents — diminishing returns como default.
5. WP entrando ao quadrado — pattern "stat escolhida" pelo jogo.

---

### 1.3 Incremental Epic Hero 2

IEH2 e' o jogo de referencia mais sofisticado dos tres em arquitetura de
stats. Recomendo profunda atencao porque ele resolve problemas que o Idle
Medieval ainda nao endereca.

#### Quinteto VIT / STR / INT / AGI / LUK + 5 classes (6 oficialmente, mas
"Tamer" e' suporte)

Fonte: `ieh2_dump/docs/02-heroes-and-stats.md` secao "5 atributos" (linhas
13-15) e "6 classes" (linhas 5-9).

```csharp
public enum HeroKind { Warrior, Wizard, Angel, Thief, Archer, Tamer }
public enum AbilityKind { Vitality, Strength, Intelligence, Agility, Luck }
```

Note: IEH2 usa **AGI no lugar de DEX**. Funcionalmente equivalente.

#### Stats base por classe (Lv 1)

Fonte: `02-heroes-and-stats.md` linhas 37-46.

| # | Hero    | HP | MP | ATK | MATK | DEF | MDEF | SPD | PhysCrit | MagCrit | CritDmg | EQDrop | MoveSpd |
|---|---------|----|----|-----|------|-----|------|-----|----------|---------|---------|--------|---------|
| 0 | Warrior | 20 | 5  | 2.0 | 0.5  | 0   | 0    | 0   | 0.01     | 0       | 2.0     | 0.001  | 200     |
| 1 | Wizard  | 10 | 10 | 0.5 | 2.0  | 0   | 0    | 0   | 0        | 0.01    | 2.0     | 0.001  | 150     |
| 2 | Angel   | 15 | 7.5| 1.5 | 1.5  | 0   | 0    | 0   | 0.005    | 0.005   | 2.0     | 0.001  | 250     |
| 3 | Thief   | 10 | 5  | 1.0 | 1.0  | 0   | 0    | 0   | **0.05** | **0.05**| 2.0     | 0.0015 | 250     |
| 4 | Archer  | 10 | 10 | 1.5 | 1.5  | 0   | 0    | 0   | 0.005    | 0.005   | 2.0     | 0.001  | 200     |
| 5 | Tamer   | 20 | 10 | 1.0 | 1.0  | 0   | 0    | 0   | 0.005    | 0.005   | 2.0     | 0.001  | 150     |

**Note bem**: esses valores sao **multiplicadores aplicados ao numero de
pontos atribuidos**. Nao sao stats iniciais "absolutos". Ver formula em
linhas 70-78 do md.

#### Formula de derivacao: stat <- atributos (a parte mais importante)

Fonte: `02-heroes-and-stats.md` linhas 70-83.

| Stat  | Formula |
|-------|---------|
| HP    | `stats[hero][HP]  x VIT_points` |
| MP    | `stats[hero][MP]  x (AGI_points + INT_points) / 2` |
| ATK   | `stats[hero][ATK] x STR_points` |
| MATK  | `stats[hero][MATK] x INT_points` |
| DEF   | `stats[hero][DEF]  x (VIT + STR) / 2` |
| MDEF  | `stats[hero][MDEF] x (VIT + INT) / 2` |
| SPD   | `stats[hero][SPD]  x AGI_points` |

Brilhante: **cada stat secundaria pesa em 1 ou 2 atributos primarios**.
Quem dump 100% VIT pega HP cheio, mas perde DEF/MDEF (que precisam STR/INT
tambem) e perde MP (que precisa AGI/INT). Padrao identico ao "cross stat"
de IdleOn — forca build hibrida.

#### LUK escala stats secundarias com expoente sub-linear

Fonte: `02-heroes-and-stats.md` linhas 86-97.

```csharp
stats[6] += Parameter.stats[hero][7] x LUK              // PhysCrit linear
stats[7] += Parameter.stats[hero][8] x LUK              // MagCrit linear
stats[9] += Parameter.stats[hero][10] x LUK^(2/3)       // EQDrop com expoente 2/3
stats[10]+= Parameter.stats[hero][11] x AGI^(2/3)       // MoveSpd com expoente 2/3 em AGI
```

**Expoente 2/3 em stats de QoL** (EQDrop, MoveSpeed) garante retornos
decrescentes. LUK 1000 -> EQDrop bonus de `LUK^(2/3) = ~100`. LUK 1M ->
`LUK^(2/3) = ~10k`. Ou seja: 1000x mais LUK so da 100x mais drop. Evita
trivializacao.

#### Clamps relevantes (caps explicitos)

Fonte: `02-heroes-and-stats.md` linhas 99-112.

```csharp
// Resistencias elementais
stats[0..4].maxValue = 0.9       // 90% maximo
stats[0..4].minValue = -1e100    // sem piso (pode ficar -100%)

// EQDropChance
stats[9].maxValue = 1.0          // 100% drop

// MoveSpeed
stats[10].minValue = 50.0
stats[10].maxValue = 1000.0
```

`maxValue = 0.9 em resistencias` previne god-mode (sempre toma pelo menos 10%
de dano elemental).

#### Cap de level: 3000

Fonte: `02-heroes-and-stats.md` linhas 114-118 e `03-progression-curves.md`
linhas 53-58.

```csharp
public static readonly long maxHeroLevel = 3000L;
```

#### Curva de XP: soma de polinomios + multiplicadores em threshold

Fonte: `ieh2_dump/docs/03-progression-curves.md` linhas 7-49.

```
Xpoly(L) = 100*L
         + 50*(L/2)^2
         + 100*(L/5)^3
         + 150*(L/10)^4
         + 200*(L/15)^5
         + 1000*(L/30)^6
         + 2000*(L/50)^8
         + 100000*(L/100)^12
         + 10^7*(L/200)^20
         + 10^9*(L/300)^35
```

Cada termo "domina" em uma faixa de level (md linha 24-32):

| Faixa  | Termo dominante                | Custo aprox. para passar |
|--------|-------------------------------|---------------------------|
| 1-10   | linear                         | ~100 a 1.000 |
| 10-30  | polinomio 3-4                  | ~10^4 |
| 30-60  | polinomio 5-6                  | ~10^6 |
| 60-100 | polinomio 8                    | ~10^9 |
| 100-200| termo `(L/100)^12`             | ~10^12 a 10^17 |
| 200-300| `(L/200)^20` + multiplicadores | explode |

Multiplicadores por threshold (linha 39-48 do md):

```csharp
if (level >= 200) num *= Math.Pow(2,    (level-200)/100);
if (level >= 500) num *= Math.Pow(3,    (level-500)/100);
if (level >= 600) num *= Math.Pow(5,    (level-600)/100);
if (level >= 700) num *= Math.Pow(10,   (level-700)/100);
if (level >= 800) num *= Math.Pow(100,  (level-800)/100);
if (level >= 900) num *= Math.Pow(1000, (level-900)/100);
if (level >= 1200) num *= Math.Pow(100, (level-1200)/100);
if (level >= 1400) num *= Math.Pow(100, (level-1400)/100);
```

Cria **escaloes** onde o player ve "ok, vou ficar travado, hora de prestige".

Marcos numericos (md linha 107-120):

| Level | XP requerida (aprox.) |
|-------|----------------------|
| 1     | 100                  |
| 10    | ~2.500               |
| 50    | ~10^6                |
| 100   | ~10^10               |
| 200   | ~10^21               |
| 500   | ~10^48               |
| 1000  | ~10^100              |
| 3000  | ~10^700              |

#### Pre-computacao da curva inteira

Fonte: `03-progression-curves.md` linhas 53-58.

```csharp
calculatedRequiredExps[maxHeroLevel*2]  // array pre-computed
```

**Lookup O(1)** em vez de recalcular toda hora. Idle Medieval ja faz parcialmente
em `xp_curve.gd` (verificar).

#### SPD logaritmico por regime

Fonte: `02-heroes-and-stats.md` linhas 121-133.

| SPD bruto    | Expoente aplicado |
|--------------|-------------------|
| < 1 000      | 1.0 (linear)      |
| 1 000-10 k   | 0.9               |
| 10 k-100 k   | 0.8               |
| 100 k-1 M    | 0.7               |
| 1 M-10 M     | 0.65              |
| > 10 M       | 0.6               |

Depois passa por `log_{1.4}(1.4 + spd/25000) - 1`. SPD sempre melhora, mas o
ganho marginal cai por regime.

#### ArmoredFury / WardedFury (resolver "stat irrelevante")

Fonte: `ieh2_dump/docs/17-combat.md` linhas 60-77.

```csharp
elementDamages[Physical].RegisterMultiplier(MultiplierKind.ArmoredFury, Mul,
    () => stats[ArmoredFury].Value() x log2(max(1, basicStats[DEF].Value()))
);
```

Padrao genial: DEF/MDEF normalmente sao "lixo" no late game (player prefere
ATK pra matar antes). ArmoredFury **converte DEF em offensive damage
logaritmicamente**. Resolve o classico "high DEF doesn't matter at higher
levels" sem reescrever stats. Pode ser adotado pelo Idle Medieval como um
node de Skill Tree ou Awakening.

#### Custos de upgrade: dois patterns (linear e exponencial)

Fonte: `03-progression-curves.md` linhas 65-95.

```csharp
num = !isLinear
    ? (initCost * Math.Pow(baseCost, level))   // exponencial
    : (initCost + level * baseCost);           // linear
```

Linear: "muitas compras baratas" (incentiva stacar). Exponencial: "poucas
compras de impacto enorme" (cap-bumps, slots).

**Idle Medieval hoje nao tem upgrade store** (ver
`STATE-OF-THE-PROJECT.md` secao 13 — Crafting placeholder, Skill Tree stub).
Quando entrar, padronizar em **2 funcoes apenas**.

#### Tier de Rebirth gateado por Hero Level

Fonte: `03-progression-curves.md` linha 97-103.

```csharp
public static long[] tierHeroLevel = new long[7] { 100, 200, 300, 500, 1000, 1500, 2000 };
```

Tier-N de upgrades de Rebirth so destrava se atingiu o level N. Forma simples
de gating sem precisar de quests/missions.

#### Multibuy bar

Fonte: `03-progression-curves.md` linha 131-136.

```csharp
public static long[] multibuyNums = {
    1, 5, 10, 25, 50, 100, 250, 1000, 2500, 10000,
    100000, 1000000, 100000000, 1000000000, 1000000000000, 1000000000000000
};
```

16 valores com saltos exponenciais conforme o jogo escala. QoL critica em
qualquer idle moderno.

---

## 2. Convergencias (mescla recomendada)

Pontos onde os 3 jogos (ou pelo menos 2 dos 3 relevantes) alinham.

### 2.1 Atributos primarios

| Sistema | Atributos | Cap visivel |
|---|---|---|
| IEH2 | VIT, STR, INT, AGI, LUK (5) | sem cap absoluto, mas LUK tem expoente 2/3 |
| IdleOn | STR, AGI, WIS, LUK (4) | nenhum |
| **Convergencia** | **Quinteto e' o padrao da industria** | LUK com retorno decrescente |

**O Idle Medieval ja adota STR/DEX/INT/VIT/LUK**, o que matche IEH2 com renomeio
DEX<->AGI e mantem todos os 5. Esta certo. Sem alteracao.

Reforco: nem IEH2 nem IdleOn usam INT (IdleOn usa WIS no lugar). **Isso indica
que "INT" pode ser substituido por outro termo sem perda** — mas como o
Idle Medieval ja usa INT e o termo e' bem entendido em pt-BR (Inteligencia),
nao mudar.

### 2.2 Formulas de derived stats

Convergencia entre IEH2 e Idle Medieval:

| Stat derivado | IEH2 (linha 70-83 do 02-heroes) | Idle Medieval (`STATE-OF-THE-PROJECT.md` linha 62) |
|---|---|---|
| HP | `multipler x VIT_points` | `VIT +5 HP/pt` |
| ATK | `multiplier x STR_points` | `STR +1 ATK/pt` |
| MATK | `multiplier x INT_points` | `INT +1 MATK/pt` |
| SPD | `multiplier x AGI_points` | `DEX +0.02 SPD/pt` |
| Crit% | `multiplier x LUK_points` | `LUK +0.5% crit/pt` |
| DEF | `multiplier x (VIT+STR)/2` | **(ausente)** |
| MDEF | `multiplier x (VIT+INT)/2` | **(ausente)** |
| MP | `multiplier x (AGI+INT)/2` | **(ausente)** |

**Lacuna identificada**: o Idle Medieval atribui 1 stat por atributo (1-pra-1).
IEH2 tem stats que dependem de **media de 2 atributos** (DEF, MDEF, MP). Isso
e' o que forca build hibrida em IEH2. Considerar adicao em `combat_stats.gd`:
- `DEF += 0.5 x (VIT + STR)` por ponto
- `MDEF += 0.5 x (VIT + INT)` por ponto
- `MP += 0.5 x (DEX + INT)` por ponto (em vez de ausente)

Ver secao 4 abaixo para proposta concreta.

### 2.3 Shape da curva de XP

| Jogo | Shape |
|---|---|
| Cookie Clicker | Custo exponencial puro (`1.15^n`) — sem level explicito |
| IdleOn | `(polinomial + linear) x geometrico_com_decay` |
| IEH2 | Soma de polinomios de graus crescentes + multiplicadores em threshold |
| Idle Medieval atual | `BASE x L^2 x 1.07^L` (polinomial 2 x geometrico fixo) |

**Convergencia**: tanto IdleOn quanto IEH2 usam **polinomial + geometrico**
mas com refinamentos. IdleOn faz a **base geometrica diminuir com o level**
(decay). IEH2 faz a **soma de polinomios de graus crescentes** (cada termo
domina em uma faixa).

A formula vigente do Idle Medieval (linha 12-19 de
`02_math/progression-curves.md`):

```gdscript
BASE * pow(L, 2.0) * pow(1.07, L)
```

E' **a versao mais simples possivel desse padrao** — funciona pra MVP, mas
nao tem walls naturais (a curva e' lisa). Ver secao 3.3 (divergencias) e
secao 4 (proposta).

### 2.4 Cap pratico de progressao por sistema

| Mecanismo | Cookie | IdleOn | IEH2 |
|---|---|---|---|
| Level cap absoluto | nao | nao (cada skill chega a Lv 250-500) | sim, 3000 |
| Soft caps polinomiais | sim (`1.15^n`) | sim (4k, 15k) | sim (`maxValue = 0.9` em resistencias, expoente 2/3 em LUK) |
| Walls progressivos | nao | sim (Lab Lv 1-4, Gaming Lv 20, Construction Lv 71) | sim (level 200, 500, 600, 700, 800, 900, 1200, 1400) |
| Prestige reset | sim (heavenly chips) | parcial (Rebirth de talent points) | sim (Rebirth -> Ascension -> WA1/2/3 — 5 camadas) |
| Cap visivel via stat | nao | sim (mastery cap 0.80) | sim (resist max 0.9, EQDrop 1.0, MoveSpd 1000) |

**Convergencia**: TODOS usam **soft cap polinomial** como ferramenta anti-
inflacao. **TODOS usam prestige** como reset com bonus permanente. **2 de 3**
(IdleOn e IEH2) usam walls progressivos em level threshold pra forcar
decisao de prestige.

Idle Medieval ja prevê Renascimento (linha 263-281 de
`progression-curves.md`) com cap por estrela:

| Estrelas | Mult | Level cap |
|---|---|---|
| 0 | 1.0x | 100 |
| 1 | 1.5x | 200 |
| 5 | 3.5x | 600 |
| 10 | 6.0x | 1000 |

Isto e' **um cap progressivo via prestige**, parecido com o `tierHeroLevel`
de IEH2 (linha 99 do `03-progression-curves.md` da ref). Bom desenho.

### 2.5 RNG dampening

| Jogo | Como? |
|---|---|
| IdleOn | Mastery (0.35 a 0.80 cap, ratio min/max) |
| IEH2 | Crit damage como termo logaritmico (linha 144-149 de COMBAT_MATH idleon ref) |
| Cookie | nao tem combate |

Idle Medieval tem variance fixa de +/-10% em `damage-formula.md` linha 130.
**Esta correto pro MVP** mas falta o crescimento da consistencia. Sugestao
em secao 4.

---

## 3. Divergencias / Decisoes pendentes

### 3.1 Cap de level hard vs soft

- **Opcao A (IEH2): cap hard em 3000 com walls progressivos antes (200,
  500, 600, 700, 800, 900, 1200, 1400 multiplicando o custo).**
  - Pros: dev sabe que o jogo "acaba" em algum lugar; pre-computa array de XP;
    facil balancear porque jogador segue trilho.
  - Contras: jogador pode sentir que "terminou" e parar; precisa muitas camadas
    de prestige acima do cap (5 camadas em IEH2!) pra manter engajamento.
- **Opcao B (IdleOn/Cookie): sem cap absoluto, soft caps em todo stat.**
  - Pros: jogo "nunca acaba"; player sempre pode bater records.
  - Contras: numeros explodem (precisa BigInt/format K/M/B); balanceamento
    requer mais cuidado em soft caps.
- **Recomendacao se eu precisasse escolher hoje**: **Opcao A com cap em 1000
  (ja documentado no Idle Medieval em `progression-curves.md` linha 38 e
  `balance-tables.md` linha 14)**. Manter como esta, mas adicionar walls
  estilo IEH2 antes do cap pra criar pontos de decisao "passa ou prestige".
- **Status**: [DECISAO PENDENTE: confirmar cap 1000 e adicionar walls em
  L100/L200/L500/L800?]

### 3.2 Cap de level por classe

Nenhum dos tres jogos referencia limita level **por classe**. IEH2 tem 6
classes que compartilham o mesmo cap 3000. IdleOn tem 63 classes (com
sub-classes via promotion) sem distincao de cap.

Idle Medieval `classes-and-characters.md` linha 11-12: "Roster inicial 1
personagem (Warrior). Maximo inicial 10 personagens." — cada um com seu
proprio level (multi-personagem IdleOn-style).

- **Opcao A**: cap unificado de 1000 pra todas as 10 classes.
- **Opcao B**: cap variavel por classe (Mage cap 1200, Warrior cap 800, etc).
- **Recomendacao**: **Opcao A**. Variar cap por classe adiciona complexidade
  sem proposito narrativo claro. Diferenciacao de classes deve vir das
  awakening trees ja documentadas em `classes-and-characters.md`.
- **Status**: [DECISAO PENDENTE: confirmar cap 1000 unificado entre classes]

### 3.3 Cap de level por zona

Nem IEH2 nem IdleOn gateiam acesso a zona por nivel rigido — ambos usam **gate
por progresso anterior** (terminar zona anterior).

Idle Medieval em `STATE-OF-THE-PROJECT.md` linha 113: gating no map_modal e'
"zona desbloqueada + area iniciada/anterior completada + stage <= furthest+1".
Ou seja, ja segue o pattern dos referencias.

Porem, em `balance-tables.md` linhas 8-14 existe a tabela "Recommended Player
Level" por zona (Z1: 1-25, Z2: 25-75, ... Z6: 600-1000). Isso e' apenas
**recomendado**, nao hard cap.

- **Recomendacao**: manter como esta — recomendacao sem hard gate, jogador
  pode tentar Z6 com personagem L100 (mas vai apanhar feio porque o
  accuracy gate de IdleOn-style `effective < 0.5 = 0% hit` vai impedir
  progresso real).
- **Status**: ok, sem decisao pendente.

### 3.4 Cross-stat para accuracy (Idleon style)

- **Opcao A (IdleOn): accuracy de uma classe vem de stat secundario, nao
  do main stat.** Ex: Warrior usa STR pra dano, WIS pra accuracy.
- **Opcao B (IEH2/Idle Medieval atual): accuracy vem da formula generica
  (`damage-formula.md` linhas 84-103 usa `attacker.accuracy + skill.accuracy`).**
- **Recomendacao**: nao adotar cross-stat agora. Idle Medieval ja tem
  classes diferenciadas via stats base (linha 28-39 de
  `classes-and-characters.md`) e adicionar cross-stat torna o jogo
  significativamente mais complexo pra player entender. Pode entrar como
  Fase 2-3.
- **Status**: [DECISAO PENDENTE: adotar cross-stat na Fase 02 ou 03? Caso
  sim, qual mapeamento?]

### 3.5 Stat-derived defesas hibridas (DEF baseada em 2 atributos)

- **Opcao A (IEH2)**: DEF = `multiplier * (VIT + STR) / 2`. Forca quem quer
  tankar a investir em 2 stats.
- **Opcao B (Idle Medieval atual)**: DEF nao vem de atributo, vem de equip
  e flat (`STATE-OF-THE-PROJECT.md` linha 60-62 lista bonuses de equip).
- **Recomendacao**: **Opcao A**. Atualmente VIT so da HP, STR so da ATK. Faz
  sentido que VIT+STR juntos dem DEF, e VIT+INT juntos dem MDEF, e DEX+INT
  juntos dem MP. Cria builds hibridas naturalmente.
- **Status**: [DECISAO PENDENTE: adicionar DEF/MDEF/MP por atributo? Quais
  pesos exatos? Sugestao em secao 4.]

### 3.6 Shape da curva de XP

Tres opcoes para evoluir a formula atual:

- **Opcao A (manter formula atual)**: `BASE * L^2 * 1.07^L`. Simples,
  funcional, ja validada empiricamente.
- **Opcao B (IdleOn-style com decay)**: trocar `1.07^L` por
  `(1.20 - min(0.13, 0.21*L/(L+100)))^L`. Comeca em +20%/level, atenua pra
  +7%/level. Mais "satisfatorio" no early.
- **Opcao C (IEH2-style soma de polinomios)**: substituir por soma de termos
  `c_i * (L/k_i)^p_i` com p crescentes. Cria walls naturais nas trocas de
  termo dominante.
- **Recomendacao**: **manter A no MVP, migrar pra B na Fase 2** (deveria ser
  rapido — so trocar a formula em `xp_curve.gd`). C e' overkill pra
  estado atual mas pode entrar na Fase 4/5 quando o cap aumentar.
- **Status**: [DECISAO PENDENTE: migrar pra Opcao B antes do release ou
  manter A por simplicidade?]

### 3.7 Walls progressivos por threshold

IEH2 (linha 39-48 do `03-progression-curves.md`):

```csharp
if (level >= 200) num *= Math.Pow(2,    (level-200)/100);
if (level >= 500) num *= Math.Pow(3,    (level-500)/100);
...
```

Idle Medieval atual: **nao tem walls explicitos**. A curva 1.07^L cresce de
forma lisa.

- **Opcao A**: adicionar walls em L100, L200, L500, L800.
- **Opcao B**: manter curva lisa, deixar walls emergirem de gear/zone gate.
- **Recomendacao**: **A**, copia direta do pattern IEH2. Cria pontos
  claros de "vou prestige aqui" sem precisar UI explicita.
- **Status**: [DECISAO PENDENTE: aprovar walls? Em quais niveis exatamente?]

### 3.8 RNG dampening progressivo (Mastery de IdleOn)

- **Opcao A (Idleon)**: variance de damage diminui com investimento em
  bubble/card. Cap em 80-100% (vs 35-100% inicial).
- **Opcao B (Idle Medieval atual)**: variance fixa em +/-10%.
- **Recomendacao**: **A**, mas mais leve. Variancia inicial +/-20%, cap em
  +/-5%. Investimento via skill tree node.
- **Status**: [DECISAO PENDENTE: implementar Mastery na Fase 3?]

### 3.9 Estrutura de stat derivados secundarios

IEH2 tem **24 stats secundarias** (`02-heroes-and-stats.md` linhas 22-31):
FireRes, IceRes, ThunderRes, LightRes, DarkRes, DebuffRes, PhysCritChance,
MagCritChance, CriticalDamage, EquipmentDropChance, MoveSpeed,
SkillProficiencyGain, EquipmentProficiencyGain, TamingPointGain, ExpGain,
ArmoredFury, WardedFury, PetPhysCritChance, PetMagCritChance,
PetCriticalDamage, PetDebuffResistance, ArtifactProficiencyGain,
SkillTriggerNumGain, RebirthCountGain.

Idle Medieval tem **~30 stats derivados** ja listados em
`STATE-OF-THE-PROJECT.md` linha 57 ("HP/MP/ATK/DEF/SPD + 5 atributos
primarios + 30+ stats derivados (crit/dodge/elem/regen/leech/gain%/etc)").
Numero compativel.

- Sem decisao pendente — manter como esta.

### 3.10 Resistencias com `maxValue = 0.9`

IEH2 explicitamente clampa resistencias em 0.9 (`02-heroes-and-stats.md`
linhas 102-104). Idle Medieval `damage-formula.md` linha 411 tem cap
0.75 para dodge e block, mas **nao tem cap explicito para
elem_resist**. A matriz de elementos em `damage-formula.md` secao 7 vai
de 0.5 a 1.5 (fator multiplicativo, nao resistencia % do defensor).

- **Opcao A**: adicionar `MAX_ELEM_RESIST = 0.9` ao Idle Medieval.
- **Recomendacao**: **A**, copia direta. Previne god-mode trivial via
  enchantment elemental empilhado.
- **Status**: [DECISAO PENDENTE: confirmar cap 0.9 em resistencias
  elementais individuais?]

### 3.11 Auto-allocate de stats em rebirth

IEH2 tem auto-allocate por preset (`02-heroes-and-stats.md` linhas 141-142):
"em Rebirth, AP e' resetado mas ha um `AutoAddAbilityPoint(isRebirth: true)`
que redistribui os preset values automaticamente — voce nao perde a build
manual."

Idle Medieval ainda nao implementou Renascimento (Fase 3). **Quando entrar,
ja prever auto-allocate**. Padrao essencial pra idle multi-personagem onde
re-distribuir 1000 pontos manualmente seria tedioso.

- **Status**: planejar pra Fase 3 (ja em `04_phases/`).

### 3.12 Diferenciacao entre 2 heroes do mesmo level

IEH2 diferencia por:
1. **Stats base por classe** (linhas 37-46 do md, multiplicadores por classe).
2. **Stats por AP por classe** (linhas 60-67 do md, multiplicadores por
   classe para cada AP gasto).
3. **HeroSuperStats** layer 2 (linhas 145-151) destravada por milestone.

Idle Medieval ja tem (1) e (2) parcialmente — `data/characters/warrior.tres`
define stats base e os pontos de stat sao genericos (todos +1 ATK por STR).

- **Opcao A**: adotar pattern IEH2 com `Parameter.stats[hero][stat]`
  multiplicador por classe. Warrior +1 ATK/pt STR, Mage +0.25 ATK/pt STR
  (mas +1 MATK/pt INT, etc.). Esta lista em `02-heroes-and-stats.md` linhas
  60-67.
- **Recomendacao**: **A**, eventualmente. Hoje so 1 classe (Warrior)
  existe, entao adiar pra quando Mage entrar (Fase 2 da `04_phases/`).
- **Status**: [DECISAO PENDENTE: aprovar matriz de "stat por AP por
  classe"? Quando entrar Fase 2.]

---

## 4. Proposta para o Idle Medieval

### 4.1 Quinteto STR/DEX/INT/VIT/LUK — calibragem

Ja existe, ja confirmado correto. Comparacao com IEH2:

| Stat | Idle Medieval atual | IEH2 Warrior (linha 41 do md) | Comentario |
|---|---|---|---|
| HP/VIT pt | +5 | +20 | IEH2 da 4x mais; mas IEH2 cap level e' 3x maior (3000 vs 1000) |
| ATK/STR pt | +1 | +1 | identico |
| SPD/DEX pt | +0.02 | +1 | IEH2 SPD escala log apos 1k, entao isso eh comparativel |
| MATK/INT pt | +1 | +0.25 (Warrior, +1.0 pra Wizard) | IEH2 diferencia por classe |
| Crit/LUK pt | +0.5% | +0.0001 = 0.01% | Idle Medieval da 50x mais — pode ser excessivo |

**Recomendacao**: ajustar LUK pra +0.1% crit/pt (atual +0.5% e' caro demais),
**OU** manter +0.5% e colocar cap mole em crit chance (ja existe? Verificar
em `combat_stats.gd`). Fonte: IEH2 `Stats.PhysCritChance` clampa em 1.0 mas
o ganho por LUK e' tao pequeno que dificilmente bate cap.

**Para revisar em playtest**:
1. VIT +5 HP/pt provavelmente fica baixo no late game (L1000 com 200 pontos
   em VIT = 1000 HP, mas inimigo Z6 bate 320k, ver `balance-tables.md`
   linha 180). Considerar `+5 + 0.1 * level` por VIT point invested.
2. LUK +0.5% crit/pt pode chegar a 100% crit em L200 com all-LUK
   (200 pts * 0.5% = 100%). **Adicionar cap mole** estilo IEH2:
   `crit_chance = min(1.0, raw)` ou usar formula assintotica `x/(x+k)`.

### 4.2 Adicionar derived stats hibridos (DEF/MDEF/MP por 2 atributos)

Atual: VIT so da HP, STR so da ATK, INT so da MATK, DEX so da SPD, LUK so da
crit. Forma 1-pra-1. **IEH2 mostra que stats hibridas (medias de 2
atributos) forcam build hibrida**.

Proposta concreta para `combat_stats.gd`:

```gdscript
# Stats derivados primarios (1 atributo)
stats.max_hp += 5 * stat_bonus.get("VIT", 0)
stats.atk += 1 * stat_bonus.get("STR", 0)
stats.magic_atk += 1 * stat_bonus.get("INT", 0)
stats.attack_speed += 0.02 * stat_bonus.get("DEX", 0)
stats.crit_chance += 0.005 * stat_bonus.get("LUK", 0)  # ou 0.001 (ver 4.1)

# NOVO: Stats derivados hibridos (2 atributos)
var vit = stat_bonus.get("VIT", 0)
var str_pts = stat_bonus.get("STR", 0)
var int_pts = stat_bonus.get("INT", 0)
var dex_pts = stat_bonus.get("DEX", 0)
stats.defense += 0.5 * (vit + str_pts)         # DEF do (VIT + STR)/2 (IEH2)
stats.magic_def += 0.5 * (vit + int_pts)       # MDEF do (VIT + INT)/2 (IEH2)
stats.max_mp += 0.5 * (dex_pts + int_pts)      # MP do (DEX + INT)/2 (IEH2)
```

Cita: `02-heroes-and-stats.md` linhas 70-78 (IEH2 mesma formula).

**Impacto**: jogador que dump 100% VIT pega HP cheio mas DEF medio (porque
falta STR/INT). Quem quer ser tank precisa mix VIT+STR. **Build emergente.**

### 4.3 XP curve — ajustes citados

Atual em `xp_curve.gd` (linha 12-19 de `02_math/progression-curves.md`):

```gdscript
BASE * pow(L, 2.0) * pow(1.07, L)
```

Tabela citada do mesmo doc (linha 30-39):

| L | xp_to_next | Cumulative |
|---|---|---|
| 1 | 10 | 0 |
| 10 | 1.967 | 5.025 |
| 50 | 736.349 | 8.918.654 |
| 100 | 73.917.000 | 2.470.000.000 |
| 200 | 1.67 x 10^14 | 5.4 x 10^15 |
| 1000 | 1.86 x 10^77 | 1.3 x 10^79 |

Comparativo com IdleOn Character (lv 0, `XP_CURVES.md` linha 67):

| L | Idle Medieval | IdleOn Character | IEH2 |
|---|---|---|---|
| 10 | 1.967 | 405 | ~2.500 |
| 50 | 736k | 90k | ~1M |
| 100 | 73M | 18M | ~10^10 |
| 200 | 167T | 18G | ~10^21 |

**Observacoes**:
- Idle Medieval e' **mais caro em L10** que IdleOn (5x) mas **mais barato em
  L100** que IEH2 (10^7 vs 10^10).
- A explosao em L200 e' brutal no Idle Medieval (167T vs 18G de IdleOn).
- Como o Idle Medieval prevê cap L1000 (vs IEH2 cap 3000 e IdleOn skill cap
  ~250), o 10^77 em L1000 e' **muito mais alto** que o equivalente IEH2
  L1000 (~10^100, mas em uma curva mais lenta).

**Recomendacao 1**: manter formula atual. E' funcional ate ~L100.

**Recomendacao 2**: **adicionar walls progressivos** (style IEH2) apos L100
pra criar pontos de decisao de prestige:

```gdscript
func xp_to_next(level: int) -> float:
    var l: float = max(1, level)
    var base: float = BASE * pow(l, 2.0) * pow(1.07, l)
    # Walls (style IEH2 03-progression-curves.md linhas 39-48):
    if level >= 100: base *= pow(1.5, (level - 100) / 100.0)
    if level >= 300: base *= pow(2.0, (level - 300) / 100.0)
    if level >= 500: base *= pow(3.0, (level - 500) / 100.0)
    if level >= 800: base *= pow(5.0, (level - 800) / 100.0)
    return base
```

Cita IEH2 `03-progression-curves.md` linha 39-48 como fonte.

**Recomendacao 3** (Fase 2): considerar migrar pra formula IdleOn-style
com decay:

```gdscript
const BASE_GEOM = 1.20
const DECAY_COEF = 0.215
const DECAY_CAP = 0.13
const DECAY_SOFT = 100.0

func xp_to_next_idleon_style(level: int) -> float:
    var l: float = max(1, level)
    var decay: float = min(DECAY_CAP, DECAY_COEF * l / (l + DECAY_SOFT))
    return (15 + pow(l, 1.9) + 11 * l) * pow(BASE_GEOM - decay, l) - 15
```

Pros: **mais satisfatorio no early** (+20%/level inicial vs +7% atual).
Cita: `XP_CURVES.md` linha 60-65.

**Status**: [DECISAO PENDENTE: aplicar Recomendacao 2 imediatamente?
Recomendacao 3 fica pra Fase 2/3?]

### 4.4 Cap de level por classe

Manter cap unificado 1000 conforme `progression-curves.md` linha 270 e
`balance-tables.md` linha 12. Justificativa em secao 3.2.

**Decisao**: **nao precisa mudar nada**. Apenas confirmar no progress-log.

### 4.5 Cap de level por zona — soft via accuracy gate

Adotar pattern Idleon: **accuracy gate** (`COMBAT_MATH.md` linhas 125-131):

```
effective = playerAccuracy / monsterDefence
hit = 0% se effective < 0.5
hit = 100% se effective >= 1.5
```

Hoje Idle Medieval ja tem `level_diff_penalty` em `damage-formula.md` linhas
84-92 (-2% accuracy por level acima de threshold 5). Funciona, **mas a
forma do gate e' diferente**: Idleon e' um **floor** (0% se ratio < 0.5,
1% por ponto acima), Idle Medieval e' **interpolacao linear**.

**Recomendacao**: manter linear por enquanto. Idleon-style accuracy gate
"0% abaixo de threshold" e' brutal pra player que entra de gear errado.

**Status**: ok.

### 4.6 Cap de stats individuais

| Stat | Cap atual | Cap IEH2 (fonte) | Cap proposto Idle Medieval |
|---|---|---|---|
| crit_chance | 1.0 (clamp em `damage-formula.md` linha 184) | 1.0 (PhysCritChance) | manter 1.0 |
| dodge_chance | 0.75 (linha 117) | nao explicito | manter 0.75 |
| block_chance | 0.75 (linha 195) | nao explicito | manter 0.75 |
| element_resist | sem cap (matriz vai 0.5-1.5) | 0.9 (linhas 102-104 de 02-heroes) | **adicionar 0.9** |
| lifesteal_pct | 0.5 (linha 408) | nao explicito | manter 0.5 |
| thorns_pct | 0.3 (linha 408) | nao explicito | manter 0.3 |
| reflect_pct | sem cap explicito | 0.5 (estimativa) | **adicionar 0.5** |

### 4.7 Multiplicadores de Renascimento (Estrela) e Transcendencia

Atual em `progression-curves.md` linha 263-291:

```gdscript
star_multiplier(stars) = 1 + 0.5 * clamp(stars, 0, 10)
transcendence_multiplier(t) = pow(2.0, t)
```

Cookie Clicker (linha 282-283 do md): "expoente 1/3 faz com que dobrar
prestige exija 8x mais cookies — cria runs cada vez mais longos." Idle
Medieval usa **linear em estrelas e 2^t em transcendence** — completamente
diferente.

- **Star**: 1.0x a 6.0x (linear). **Crescimento linear e' OK** porque cap em
  10. Cookie Clicker tem prestige sem cap, daí a raiz cubica.
- **Transcendence**: `2^t` cresce muito rapido. T10 = 1024x. Combina com a
  dificuldade de ganhar T-points (T-points sao raros, segundo
  `progression-curves.md` linha 290).

**Decisao**: manter como esta. **Sem alteracao recomendada**. Citar pattern
Cookie Clicker apenas como referencia.

### 4.8 ArmoredFury / WardedFury como node de Awakening

Padrao IEH2 (`17-combat.md` linhas 60-77): converter DEF em offensive damage
logaritmico. Resolve o problema "DEF e' inutil no late game".

Sugestao para `classes-and-characters.md` (no Warrior Awakening Tree):

Adicionar como node opcional ★5/★7 para o ramo **Cavaleiro Sagrado (★3A)**:

```
Furia Blindada (★7 A2 ou node novo)
- Adiciona 5% do log2(max(1, DEF)) ao ATK final.
- DEF agora vale algo em DPS, nao so em mitigacao.
```

Cita: `02-heroes-and-stats.md` linhas 60-67 (Warrior ATK por STR pt) e
`17-combat.md` linhas 60-76.

### 4.9 Pre-computacao da curva de XP

Atual `xp_curve.gd` provavelmente computa on-the-fly (precisa verificar).
IEH2 (`03-progression-curves.md` linha 53-58) pre-computa
`calculatedRequiredExps[maxHeroLevel*2]` na inicializacao para lookup O(1).

**Recomendacao**: se `xp_curve.gd` ainda calcula on-demand, pre-computar
array `[1001]` (level 0 a 1000) no `_ready()` do autoload. Custo: 1000
chamadas de pow, negligible. Beneficio: nao recalcula no `add_xp` loop.

**Status**: [DECISAO PENDENTE: confirmar se `xp_curve.gd` ja pre-computa.
Se nao, fazer Fase 2.]

### 4.10 Multibuy bar (futuro)

Quando entrar shop/upgrade store (Fase 2-3?), adotar multibuy bar pattern
IEH2 com saltos exponenciais (`03-progression-curves.md` linhas 131-136):

```
[1, 5, 10, 25, 50, 100, 250, 1000, 2500, 10000,
 100000, 1000000, 100000000, 1000000000, 1000000000000]
```

**Status**: noted pra Fase 2.

### 4.11 SPD logaritmico por regime

Atualmente `attack_speed` no Idle Medieval e' linear (`STATE-OF-THE-PROJECT.md`
linha 62: "DEX +0.02 SPD/pt"). Em L1000 com all-DEX (200 pts),
attack_speed = 4.0 ataques/seg. Razoavel.

Em endgame com gear (provavelmente +100 SPD de equipment), pode chegar a 6-8
ataques/seg. **Ainda dentro do controlavel.**

IEH2 ja prevê (linhas 122-131 do `02-heroes`) regime log apos 1000 SPD bruto.
**Idle Medieval nao deveria precisar disso ate Fase 4** quando builds com
+1000 SPD ficarem comuns.

**Status**: noted pra Fase 4.

### 4.12 Resumo de constantes recomendadas

Tabela de constantes finais para `combat_stats.gd` e `xp_curve.gd`:

| Constante | Valor atual | Valor recomendado | Fonte |
|---|---|---|---|
| HP por VIT pt | +5 | +5 base + 0.1 * level | IEH2 baseline + level scaling |
| ATK por STR pt | +1 | +1 | IEH2 linha 60 |
| MATK por INT pt | +1 | +1 (Mage) / +0.5 (others) | IEH2 linha 60-67 differentiation |
| SPD por DEX pt | +0.02 | +0.02 (linear ate 100, depois log) | IEH2 secao SPD regime |
| crit% por LUK pt | +0.5% | +0.1% (ou manter 0.5% com cap) | IEH2 LUK x 0.0001 |
| DEF por (VIT+STR)/2 | nao existe | +0.5 | IEH2 linha 76 |
| MDEF por (VIT+INT)/2 | nao existe | +0.5 | IEH2 linha 77 |
| MP por (DEX+INT)/2 | nao existe | +0.5 | IEH2 linha 73 |
| Max element resist | sem cap | 0.9 | IEH2 linha 102 |
| Max reflect_pct | sem cap | 0.5 | extrapolacao |
| Crit chance cap mole | hard 1.0 | x/(x+1000) ou hard 0.95 | IEH2 PhysCritChance pattern |
| XP wall 1 | nao existe | x1.5 apos L100, escalado 1/100 | IEH2 linha 40 |
| XP wall 2 | nao existe | x2.0 apos L300 | IEH2 linha 41 |
| XP wall 3 | nao existe | x3.0 apos L500 | IEH2 linha 41 |
| XP wall 4 | nao existe | x5.0 apos L800 | IEH2 linha 42 |
| Variance damage | +/-10% | +/-20% inicial, cap +/-5% | IdleOn mastery linha 22 |

---

## 5. Hooks com docs existentes

Documentos do `planning/` que devem ser atualizados quando as decisoes
forem tomadas:

- **`planning/02_math/progression-curves.md`** — secoes 1.5 (constantes XP),
  4.1 (player stats por level), 4.4 (stat cap):
  - Adicionar walls progressivos em XP (secao 4.3 desta sintese).
  - Documentar formula `(VIT+STR)/2` para DEF (secao 4.2).
  - Adicionar tabela de stats hibridos.
  - Documentar pre-computacao da curva (secao 4.9).
- **`planning/02_math/damage-formula.md`** — secoes 7 (element matrix), 12
  (constantes-chave):
  - Adicionar `MAX_ELEM_RESIST = 0.9` (secao 4.6 desta sintese).
  - Adicionar `MAX_REFLECT_PCT = 0.5`.
  - Citar `[ver: planning/03_research/synthesis/01-stats-and-progression.md#46-cap-de-stats-individuais]`.
- **`planning/02_math/balance-tables.md`** — secao 0 (recommended player level):
  - Ja esta consistente. Apenas adicionar nota sobre accuracy gate (secao
    4.5 desta sintese).
- **`planning/01_design/classes-and-characters.md`** — secao 2 (stats base
  por classe Lv1):
  - Considerar adicao de "stat multipliers per class" estilo IEH2 (secao
    3.12 desta sintese). Adiar pra Fase 2 quando Mage entrar.
  - Adicionar node "Furia Blindada / ArmoredFury" em Warrior Awakening
    Tree (secao 4.8 desta sintese).
  - Citar `[ver: planning/03_research/synthesis/01-stats-and-progression.md#42-adicionar-derived-stats-hibridos]`.
- **`planning/01_design/character-stats.md`** — (verificar se existe esse
  arquivo; STATE-OF-THE-PROJECT linha 397 menciona `02_math/character-stats.md`):
  - Documentar quais stats sao 1-pra-1 e quais sao hibridos (2-atributos).
  - Documentar caps mol e duros.
- **`planning/00_meta/pending-decisions.md`** — adicionar as decisoes
  pendentes desta sintese:
  - 3.1 walls em XP
  - 3.4 cross-stat para accuracy
  - 3.5 stat hibridos DEF/MDEF/MP
  - 3.6 migrar XP curve para IdleOn-style com decay
  - 3.8 RNG dampening progressivo
  - 3.10 cap em resistencia elemental
  - 3.12 stat multipliers per class
  - 4.9 pre-computar curva XP
- **`planning/00_meta/glossary.md`** — adicionar termos novos:
  - "Mastery" (RNG dampening de IdleOn)
  - "ArmoredFury / Furia Blindada" (DEF->ATK log de IEH2)
  - "Wall progressivo" (multiplicador XP por threshold de IEH2)
  - "Accuracy gate" (hit chance baseada em ratio accuracy/defence)
  - "Stat hibrido" (derivado de media de 2 atributos)
- **`planning/00_meta/progress-log.md`** — append:
  - "Sintese 01 (stats e progressao) criada em 2026-05-14. 12 decisoes
    pendentes identificadas. Ver `03_research/synthesis/01-stats-and-progression.md`."

---

## Apendice A — Tabela comparativa rapida

| Aspecto | Cookie Clicker | IdleOn | IEH2 | Idle Medieval atual |
|---|---|---|---|---|
| Genero | Clicker puro | Idle RPG multi-char | Idle RPG single (com pets) | Idle RPG multi-char |
| Cap level | nao existe | nao existe (skills cap 250-500) | 3000 hard | 1000 planejado |
| Atributos primarios | nenhum | 4 (STR, AGI, WIS, LUK) | 5 (VIT, STR, INT, AGI, LUK) | 5 (STR, DEX, INT, VIT, LUK) |
| Stats derivados | n/a | HP via gear, DMG via stat + WP^2 | 7 basic + 24 secondary | 5 basic + 30+ secondary |
| Stat hibridos (2 atrib) | n/a | nao | sim (DEF, MDEF, MP) | nao (proposta: sim) |
| Shape XP curve | n/a | (poly+lin) x geom com decay | soma de polinomios + walls | poly x geom fixo |
| Walls progressivos | n/a | sim em algumas skills | sim em 8 niveis | nao (proposta: sim) |
| RNG damping (mastery) | n/a | sim (0.35 -> 0.80) | parcial (CritDmg log) | nao (proposta: sim) |
| Accuracy gate | n/a | hard (0% < 0.5x def) | suave | suave |
| Prestige layers | 1 (Heavenly) | parcial | 5 (Rebirth -> Ascension -> WA1/2/3) | 2 planejado (Star, Transcend) |
| Multibuy | sim | sim | sim (16 valores) | nao (futuro) |
| Pre-compute XP array | n/a | sim | sim | a verificar |

---

## Apendice B — Marcacao das decisoes pendentes

Lista consolidada das 12 decisoes pendentes geradas por esta sintese:

1. **[DECISAO PENDENTE 3.1]**: confirmar cap 1000 e adicionar walls em
   L100/L200/L500/L800?
2. **[DECISAO PENDENTE 3.2]**: confirmar cap 1000 unificado entre classes?
3. **[DECISAO PENDENTE 3.4]**: adotar cross-stat (accuracy de stat
   secundario) na Fase 02 ou 03?
4. **[DECISAO PENDENTE 3.5]**: adicionar DEF/MDEF/MP por atributo
   (hibrido)? Quais pesos exatos (0.5 cada do par)?
5. **[DECISAO PENDENTE 3.6]**: migrar pra Opcao B (IdleOn-style com decay)
   antes do release ou manter A por simplicidade?
6. **[DECISAO PENDENTE 3.7]**: aprovar walls progressivos? Em quais niveis
   exatamente?
7. **[DECISAO PENDENTE 3.8]**: implementar Mastery (RNG dampening
   progressivo) na Fase 3?
8. **[DECISAO PENDENTE 3.10]**: confirmar cap 0.9 em resistencias
   elementais individuais?
9. **[DECISAO PENDENTE 3.12]**: aprovar matriz de "stat por AP por classe"?
   (Quando entrar Fase 2, Mage.)
10. **[DECISAO PENDENTE 4.1]**: LUK +0.5% crit/pt vs +0.1% — manter alto e
    adicionar cap mole, ou reduzir?
11. **[DECISAO PENDENTE 4.3]**: aplicar walls em XP imediatamente
    (Recomendacao 2) ou esperar Fase 2?
12. **[DECISAO PENDENTE 4.9]**: confirmar se `xp_curve.gd` ja pre-computa
    array; se nao, fazer Fase 2.

---

## Apendice C — Citacoes diretas de linhas

Para auditabilidade, marcos numericos com fonte exata:

- IEH2 maxHeroLevel = 3000: `references/ieh2_dump/docs/02-heroes-and-stats.md`
  linha 117.
- IEH2 Warrior base stats: linhas 41 (HP 20, MP 5, ATK 2.0, MATK 0.5).
- IEH2 formula derived stats: linhas 70-83 (HP via VIT, DEF via (VIT+STR)/2,
  etc).
- IEH2 expoente 2/3 em LUK: linhas 86-97.
- IEH2 maxValue resistencia 0.9: linhas 102-104.
- IEH2 XP polynomial: linhas 12-22 de `03-progression-curves.md`.
- IEH2 XP walls multipliers: linhas 39-48 de `03-progression-curves.md`.
- IEH2 tier Rebirth gate: linha 99-103.
- IEH2 multibuy bar: linhas 131-136.
- IEH2 ArmoredFury formula: linhas 60-77 de `17-combat.md`.
- IdleOn Character XP formula: linhas 60-67 de `XP_CURVES.md`.
- IdleOn mastery (RNG dampening): linhas 18-28 de `COMBAT_MATH.md`.
- IdleOn WP^2 formula: linhas 56-72 de `COMBAT_MATH.md`.
- IdleOn soft caps duplos: linhas 73-97 de `COMBAT_MATH.md`.
- IdleOn accuracy gate (0% < 0.5x def): linhas 125-131 de `COMBAT_MATH.md`.
- IdleOn cross-stat (STR usa WIS pra accuracy): linhas 30-51 de
  `COMBAT_MATH.md`.
- IdleOn 11 formulas diferentes por skill: linhas 55-180 de `XP_CURVES.md`.
- Cookie Clicker priceIncrease 1.15: `cookie-clicker-dump/02-formulas-core.md`
  linha 197 (e referencia main.js:7673).
- Cookie Clicker prestige expoente 1/3: linha 263.
- Cookie Clicker multGlobal empilhamento: linhas 13-46 (e referencia
  main.js:4934-5172).
