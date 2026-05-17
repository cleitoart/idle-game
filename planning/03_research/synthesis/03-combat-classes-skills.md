# Sintese: Combate, Classes e Habilidades

> Sintese de pesquisa para o modulo de combate, classes e skills do Idle Medieval.
> Fontes: Cookie Clicker (Grimoire), Legends of IdleOn (combat math + classes/talents)
> e Incremental Epic Hero 2 (heroes, skills, combat, challenges). Compara os tres
> jogos, identifica convergencias/divergencias, propoe mescla para R1.0 e linka com
> os documentos ja existentes em `planning/`.

---

## 0. Mapa rapido do problema

O projeto atual tem:

- 1 classe instanciada: Warrior (`data/characters/warrior.tres`), com 10 classes
  catalogadas em `planning/01_design/classes-and-characters.md:28-39` mas so
  Warrior implementado.
- Skill tree: stub em `scripts/systems/skill_tree.gd` que so chama
  `apply_bonuses` em `CombatStats`. Tree visual nao definida.
- Damage formula completa documentada em `planning/02_math/damage-formula.md`
  (pipeline `compute_hit` ja descrito em GDScript, com hit/dodge/crit/block/
  elementos/armor matrix/lifesteal/thorns/reflect e status effects com stacks).
- Combat loop em `scenes/combat/combat_controller.gd`: real-time auto-battle,
  1 player vs 1 enemy ativo por vez, `Engine.time_scale` controla 1x/2x.
- Status effects projetados (ver `damage-formula.md:350-362`): Poison, Burning,
  Bleeding, Slowed, Blind, Freeze, Stun, ATK Up, Shielded, Thorns, Berserker.
- 8 elementos planejados (`damage-formula.md:204-219`): Fire, Ice, Water, Wind,
  Rock, Electric, Light, Dark.
- 7 tipos de ataque (`damage-formula.md:243-256`): Slash, Stab, Crush, Blunt,
  Magic, Pierce, Lacerate, contra 4 armaduras (Cloth, Leather, Mail, Plate).

A pergunta deste documento: dado que o framework matematico ja existe (e e
consistente), **quantas classes/skills/elementos REALMENTE ativar em R1.0?** E
qual e a forma final da skill tree, do crescimento de skill, e dos sistemas
ortogonais (cooldowns, channeling, summons)?

---

## 1. Como cada jogo faz

### 1.1 Cookie Clicker — Grimoire (referencia indireta)

Cookie Clicker nao tem classes nem combate. A referencia aqui e o **minigame
Grimoire** (Wizard tower), que e o exemplo mais puro de "skill ativa com
recurso e backfire" do incremental tradicional. Importante porque sugere ideias
para skills ativas em sistema idle.

#### 1.1.1 Recurso unico: Magic

Fonte: `references/cookie-clicker-dump/14-minigame-grimoire.md:23-67`.

- Magic e o recurso unico do minigame. Tem max e current.
- `magicM = floor(4 + towers^0.6 + ln((towers + (level-1)*10)/15 + 1) * 15)`
  (linha 33 do arquivo). Cresce com numero de buildings e level do building.
- Regeneracao: `magicPS = max(0.002, sqrt(magic / max(magicM,100))) * 0.002`
  por tick (30 ticks/segundo). **Quanto mais cheia a barra, mais rapido enche**.
  Curva sqrt cria sensacao de momentum.
- Refill instantaneo possivel via Sugar Lump (recurso premium): +100 magic.

#### 1.1.2 Catalogo de spells (9 total)

Fonte: `14-minigame-grimoire.md:88-100`. Cada spell tem:

- `costMin` flat + `costPercent * magicM` (custo escala com max mana, nao com
  current, o que e elegante).
- `failChance` base 15%, modificado por buffs (`Magic adept` x0.1, `Magic
  inept` x5), aura `Supreme Intellect` (+10% fail mas -10% cost), e funcs
  custom (FtHoF: +0.15 por golden cookie ativo).

Spells:

1. **Conjure Baked Goods** — +30 min de CpS, capado em 15% dos cookies.
   Backfire: clot -50% CpS por 15 min.
2. **Force the Hand of Fate** — spawna golden cookie aleatorio; backfire spawna
   wrath cookie.
3. **Stretch Time** — +10% no maxTime de todos buffs ativos. Backfire: -20%.
4. **Spontaneous Edifice** — compra um building gratis. Backfire: sacrifica 1.
5. **Haggler's Charm** — upgrades 2% mais baratos por 60s. Backfire: 2% mais
   caros por 60 min.
6. **Summon Crafty Pixies** — buildings 2% mais baratos por 60s. Backfire: 60
   min de pixie misery.
7. **Gambler's Fever Dream** — relanca spell aleatoria por metade do custo, fail
   forcado >= 50%.
8. **Resurrect Abomination** — spawna wrinkler.
9. **Diminish Ineptitude** — buff `magic adept` (spells fail 10x menos) por 5
   min. Backfire: `magic inept` (fail 5x mais) por 10 min.

#### 1.1.3 Insights de design

Padroes uteis para Idle Medieval:

1. **Drawbacks duram mais que buffs** (60s vs 60min em haggler, 5min vs 10min em
   diminish). Castiga uso agressivo com pouco recurso. Comentado em
   `14-minigame-grimoire.md:288`.
2. **Custo proporcional ao max mana**. Spells caras escalam junto com o
   personagem, mantendo relevancia. Spells baratas (Gambler 5%) sao chao.
3. **Recurso unico + sem cooldown explicito**. Mana regen e o cooldown
   implicito. Diferente de IEH2/IdleOn que tem CDs separados.
4. **Custo de spell visivel no tooltip** + chance de backfire visivel +
   modificadores listados. Transparencia total. Boa pratica de UX.
5. **Backfire integra com sistema externo** (FtHoF afeta golden cookies, que
   afetam o core loop). Isso ancora o minigame no jogo principal.

#### 1.1.4 Por que isso importa pro Idle Medieval

Nosso skills catalog (`skills-catalog.md`) ja tem dezenas de skills ativas. O
Grimoire mostra que **skills ativas em idle game podem prescindir de slots de
hotbar** se cada uma tiver custo+gate proprio. No nosso caso: cooldown + mana
ja sao gates suficientes. Nao precisamos copiar o sistema de backfire (e nao
combina com auto-battle), mas a logica de "custo cresce com poder" e algo a
considerar para skills high-tier.

---

### 1.2 Legends of IdleOn

#### 1.2.1 Estrutura de classes — promotion tree

Fonte: `references/idleon-reference/01_CLASSES_TALENTS.md:7-25`.

3 familias principais + 1 transversal:

- **Beginner/LUK** — classe inicial, promove pra Journeyman ou Maestro.
- **STR/Warrior** — Warrior -> Barbarian -> {Blood_Berserker, Death_Bringer};
  Warrior -> Squire -> {Divine_Knight, Royal_Guardian}.
- **AGI/Archer** — Archer -> Bowman -> Hunter -> {Beast_Master, Siege_Breaker,
  Wind_Walker}.
- **WIS/Mage** — Mage -> Wizard -> {Shaman -> Elemental_Sorcerer,
  Bubonic_Conjuror}; Mage -> Spiritual_Monk -> Arcane_Cultist.

**Total de classes jogaveis**: ~17 promocoes finais, mas com branching forte.

#### 1.2.2 Insights

Fonte: `01_CLASSES_TALENTS.md:9-23`.

- Promocao tem **arvore com sub-promocoes** (ate 3 niveis: Warrior -> Squire ->
  Divine_Knight). Nao e flat "9 classes paralelas" — e progressao de
  identidade.
- **Cap de 10 personagens**, mas cada personagem pode estar numa fase de
  promocao diferente.
- Indices 30+ (Mining, Smithing, Chopping) nao sao classes jogaveis — sao
  metadata de skills nao-combate (gathering). Cada gathering skill ocupa um
  "slot" no enum de classes para indexacao de talents.

#### 1.2.3 Talents — 418 talents em 29 arvores

Fonte: `01_CLASSES_TALENTS.md:30-50`.

Estrutura de um talent (JSON):

```json
"HEALTH_BOOSTER": {
  "x1": 1, "x2": 0.15, "funcX": "add",
  "y1": null, "y2": null, "funcY": "txt",
  "skillIndex": 0
}
```

Cada talent tem ate 2 "canais" (X e Y). X = valor primario, Y = preview do
ganho proximo level.

#### 1.2.4 8 funcoes de growth

Fonte: `01_CLASSES_TALENTS.md:53-134`. **Esta e a parte mais interessante**.

| funcX | Formula | Uso (talents) |
|---|---|---:|
| `add` | `0.5 * x2 * L^2 + (x1 + 0.5*x2) * L` (quadratica!) | 116 |
| `decay` | `x1 * L / (L + x2)` (assintotica) | 208 |
| `bigBase` | `x1 + x2 * L` (linear de verdade) | 49 |
| `decayMulti` | `1 + (x1*L) / (L + x2)` (multiplicador) | 15 |
| `intervalAdd` | `x1 + floor(L / x2)` (stepwise) | 28 |
| `addDECAY` | linear ate Lv 50k, depois soft cap | - |
| `reduce` | `x1 - x2 * L` (decresce com level) | 2 |
| `special1` | `100 - x1*L/(L+x2)` | - |

Observacoes:

- **`add` quadratica e enganosa**. Talent que parece linear (`+1.15 HP por
  level`) na verdade vira `0.075*L^2 + 1.075*L`, ou seja Lv 100 = 857 HP, nao
  115. Ver linha 66-72: `HEALTH_BOOSTER` x1=1, x2=0.15.
- **`decay` e a default para %**. 208/418 talents (50%). Tem cap claro (x1) e
  comportamento previsivel. Reservar quadratica para stats base (HP/MP/ATK),
  decay para %.
- **`intervalAdd` gera "patamares satisfatorios"**. Cada multiplo de x2 vira
  step visivel. Boa pra long-term hooks (talent que ganha +1 a cada 5 levels,
  por exemplo).
- **Cap de 50.000 em `addDECAY`**. Cap embutido mesmo absurdo previne overflow
  e exploits. Sempre tenha cap.

#### 1.2.5 Special talents (account-wide)

Fonte: `01_CLASSES_TALENTS.md:171-178`. 4 arvores "Special Talent" com pontos
**compartilhados entre todos os personagens** (50 pontos no Special 1, etc.).
Adiciona uma decisao economica: "invest em talent classe-especifico vs talent
account-wide?".

#### 1.2.6 Class family bonuses

Fonte: `01_CLASSES_TALENTS.md:184-202`. 42 entries.

```json
{
  "name": "+{%_FIGHTING_AFK_GAINS",
  "func": "decay", "x1": 5, "x2": 250, "x3": 69, "order": 8
}
```

**Cada classe da um bonus passivo a TODOS os personagens, vinculado ao
personagem de maior nivel naquela classe.** `x3` = level minimo do personagem
para unlock do bonus, `order` = ordem de unlock dentro da classe.

Isso justifica ter 10 slots de personagem mesmo que voce so jogue 2-3
ativamente. Os outros 7 ficam "AFK em alguma classe" gerando bonus account-wide.

#### 1.2.7 Legend Talents (endgame)

Fonte: `01_CLASSES_TALENTS.md:206-217`. 50 talents extras via "Compass system"
endgame. Formato simplificado: sem `funcX`, so `x1`, `x2`, `bonus`,
`description`. Provavelmente decay implicito.

#### 1.2.8 Combat math — IdleOn

Fonte: `references/idleon-reference/COMBAT_MATH.md`.

**Damage pipeline (linhas 9-16):**

```
maxDamage = baseDamage * perDamage * percentDamage
minDamage = mastery * maxDamage
dano final = aleatorio em [minDamage, maxDamage]
```

3 multiplicadores empilhados. **Mastery (linhas 17-30)** clamp(0.35 + bonuses,
max=0.80). Quanto maior, menos variavel o dano. "RNG damping" — sensacao de
progressao sem perder aleatoriedade.

**Stat principal (linhas 32-51):**

- Warrior: STR, accuracy = WIS.
- Archer: AGI, accuracy = STR.
- Mage: WIS, accuracy = AGI.
- Beginner/Maestro: LUK / LUK.

**Cruz proposital**: STR usa WIS para accuracy. Forca build hibrido — nao da
para dump 100% num stat so.

**Weapon Power quadratico (linhas 56-71):**

```
weaponPowerEffect = ((WP*(1+talents/100) + baseWP) / 3)^2
                  + damageFromStat
                  + goldenFood
                  + min(150, 2*WP + damageFromStat)
                  + arcadeBonus + ...
```

WP entra **ao quadrado**. Por isso WP e absurdamente mais valioso que stat
isolada. Sao 2 alavancas de scaling: aritmetica (stat) e quadratica (weapon).

**Damage com soft caps duplos (linhas 75-88):**

```
if damage > 4000:  damage = 4000  + (damage - 4000)^0.91
if damage > 15000: damage = 15000 + (damage - 15000)^0.84
damage += foodBonus  // food adicionado DEPOIS, sem teto
```

Soft cap polinomial `cap + (x - cap)^p, p<1` e o padrao do genero. **Food
adicionada apos o cap** = canal late-game que escapa.

**Bonus log-escalados (linha 96):** `hpBubble * log(maxHP - 250)`. Stat so
contribui para dano depois de passar de threshold (250 HP nesse caso).

**Hit chance (linhas 117-130):**

```
effective = playerAccuracy / monsterDefence
if effective < 0.5: hitChance = 0
else: hitChance = min(100*(0.95*effective - 0.425), 100)%
```

- effective < 0.5: literalmente nao acerta nada.
- effective 1.0: 52.5% hit.
- effective 1.5: 100% cap.

**Esse e o "accuracy gate" classico**. Cria portoes duros de progressao. Sem
accuracy suficiente, farm e zero.

**Crit (linhas 138-150):**

```
if STR < 1000: base = (STR+1)^0.37 / 40 - 1/40  // soft superlinear ^0.37
else:          base = (STR-1000)/(STR+2500) * 0.5 + 0.255  // hyperbolico
critDamage% = 1.2 + base + outros bonus
```

Mesma forma para crit chance (com AGI). Funcao `x/(x+k)` converge
assintoticamente.

**Defense (linhas 156-171):**

```
base = monsterDmg - 2.5 * defence^0.8        // alivia early
mit  = defence^1.5 / 100                       // escala late
monsterDamage_in = base / max(1 + (defence/monsterDmg) * mit, 1)
if monsterDamage_in < 0.5: return 0           // anti-chip damage
```

Duas camadas de DEF: subtracao sublinear (early) + divisao superlinear (late).
"Pouca defesa = pouco efeito, muita defesa = quase imune".

**Kills por hora (linhas 173-194):**

```
hitDmg = maxDamage * media_mastery * exp_crit * hitChance * atk_speed
actionWaitTime = max(0.1, (1 + (10-weaponSpeed)/5) / (1 + bonuses/100))
hourlyKills = min(
  mapNumber / (respawnRate + 0.1),                              // cap A: spawn
  K / (mapDist/(130*speed/100) + actionWaitTime * ...)         // cap B: kill
)
killsPerHour = floor(3600 * hourlyKills)
```

`min(A, B)` elegante: cap A = "monstros nao respawnam rapido", cap B = "voce
nao mata rapido". Bottleneck muda ao longo da progressao. **Justifica upgrades
de spawn rate.**

**Survivability (linhas 200-209):**

```
ttd = maxHP / (monsterDamage * mapMult - healFromFood)
survivability = 100 * ttd / (ttd + respawnTime/3600)
```

Mede tempo ate morte vs tempo ate respawn. Encoraja balanceamento sustain.

---

### 1.3 Incremental Epic Hero 2

#### 1.3.1 6 classes (heroKind)

Fonte: `references/ieh2_dump/docs/02-heroes-and-stats.md:7-9`.

```csharp
public enum HeroKind { Warrior, Wizard, Angel, Thief, Archer, Tamer }
```

Note: **6 classes**, sem promotion branching. Cada heroi pode existir
simultaneamente.

#### 1.3.2 Stats base por classe

Fonte: `02-heroes-and-stats.md:34-46`.

12 stats: HP, MP, ATK, MATK, DEF, MDEF, SPD, PhysCrit, MagCrit, CritDmg,
EQDrop, MoveSpd.

| # | Hero | HP | MP | ATK | MATK | DEF | MDEF | SPD | PhysCrit | MagCrit | CritDmg |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | Warrior | 20 | 5 | 2.0 | 0.5 | 0 | 0 | 0 | 0.01 | 0 | 2.0 |
| 1 | Wizard | 10 | 10 | 0.5 | 2.0 | 0 | 0 | 0 | 0 | 0.01 | 2.0 |
| 2 | Angel | 15 | 7.5 | 1.5 | 1.5 | 0 | 0 | 0 | 0.005 | 0.005 | 2.0 |
| 3 | Thief | 10 | 5 | 1.0 | 1.0 | 0 | 0 | 0 | 0.05 | 0.05 | 2.0 |
| 4 | Archer | 10 | 10 | 1.5 | 1.5 | 0 | 0 | 0 | 0.005 | 0.005 | 2.0 |
| 5 | Tamer | 20 | 10 | 1.0 | 1.0 | 0 | 0 | 0 | 0.005 | 0.005 | 2.0 |

Notas:

- Warrior tem **ATK 2.0** (4x do Wizard). Wizard tem **MATK 2.0** (4x do
  Warrior). Identidade clara.
- Thief tem **PhysCrit 0.05** (5%) e **MagCrit 0.05** — 10x maior que media.
  Glass cannon explicito.
- DEF/MDEF/SPD comecam zero em todos — sao stats "construidos" via AP.
- MoveSpd diferencia: Warrior 200, Angel/Thief 250, Wizard/Tamer 150. Posicao
  no campo importa.

#### 1.3.3 Atributos (5) e formula de derivacao

Fonte: `02-heroes-and-stats.md:14-16, 69-82`.

```csharp
public enum AbilityKind { Vitality, Strength, Intelligence, Agility, Luck }
```

**Formula**:

| Stat | Formula |
|---|---|
| HP | `stats[hero][HP] * VIT_points` |
| MP | `stats[hero][MP] * (AGI + INT) / 2` |
| ATK | `stats[hero][ATK] * STR_points` |
| MATK | `stats[hero][MATK] * INT_points` |
| DEF | `stats[hero][DEF] * (VIT + STR) / 2` |
| MDEF | `stats[hero][MDEF] * (VIT + INT) / 2` |
| SPD | `stats[hero][SPD] * AGI_points` |

**Padrao**: cada stat secundaria depende de **2 atributos** (com 2 excecoes:
HP/VIT, MATK/INT). Impede dump em 1 atributo so.

#### 1.3.4 LUK escala secundarias com 2/3

Fonte: `02-heroes-and-stats.md:89-95`.

```
PhysCrit  += stats[hero][7]  * LUK
MagCrit   += stats[hero][8]  * LUK
CritDmg   += ... 
EQDrop    += stats[hero][10] * LUK^(2/3)   // expoente sub-linear
MoveSpd   += stats[hero][11] * AGI^(2/3)
```

**Expoente 2/3 em EQDrop e MoveSpd**. Retornos decrescentes embutidos.

#### 1.3.5 Resistencias capadas em 90%

Fonte: `02-heroes-and-stats.md:99-112`.

```
stats[FireRes..DarkRes].maxValue = 0.9   // resistencia max 90%
stats[EQDrop].maxValue = 1.0              // 100% drop
stats[MoveSpd].min = 50, max = 1000
```

**Nunca 100% imune a um elemento.** Preserva tensao de combate.

#### 1.3.6 SPD com regimes nao-lineares

Fonte: `02-heroes-and-stats.md:120-133`. SPD bruto passa por expoente
decrescente por faixa:

| SPD bruto | Expoente |
|---|---|
| < 1.000 | 1.0 |
| 1.000-10k | 0.9 |
| 10k-100k | 0.8 |
| 100k-1M | 0.7 |
| 1M-10M | 0.65 |
| > 10M | 0.6 |

Depois passa por `log_{1.4}(1.4 + spd/25000) - 1`. SPD sempre melhora mas com
soft cap progressivo. Esse e o pattern de "scaling controlado" do idle.

#### 1.3.7 SuperStats (camada 2)

Fonte: `02-heroes-and-stats.md:144-152`. Apos milestone (Hero Grade/Fame),
heroi destrava **SuperAbilities** — uma segunda dimensao de pontos com
**mesma estrutura** (VIT/STR/INT/AGI/LUK). Mesmo mapping. **Padrao classico de
"prestige tier"** — primeiro layer escala aritmeticamente, segundo
multiplicativamente.

#### 1.3.8 Cap de level: 3000

Fonte: `02-heroes-and-stats.md:115-118`. `maxHeroLevel = 3000L`. Bem maior que
o limite usual do genero (200-500). Combina com rebirth e endgame longo.

#### 1.3.9 Skills — sistema dual rank/level

Fonte: `references/ieh2_dump/docs/05-skills.md:7-15`.

**Cada heroi tem 30 skills** (`maxSkillKindNum = 30`). Cada skill tem 3
variaveis:

| Variavel | Definicao | Cap |
|---|---|---|
| `rank` | Compra com resource (Stone/Crystal/Leaf/Catalyst) | 50 |
| `level` | Sobe usando skill em combate | `rank * levelCapPerRank` |
| `proficiency` | XP barra da skill | escala com level |

**2 eixos de progressao** independentes:

1. **Rank** = quanto investi (gold/stone).
2. **Level** = quanto usei (proficiencia).

Skill em rank 10 com `levelCapPerRank=5` = max level 50.

#### 1.3.10 Loadouts

Fonte: `05-skills.md:17-23`. 20 skills equipadas por heroi, 24 slots
disponiveis, **5 preset loadouts saveis**. Permite trocar build (PvE vs
ChallengeBoss vs Trial) sem reconfigurar.

#### 1.3.11 Custo de rank com muros explicitos

Fonte: `05-skills.md:28-45`.

```csharp
cost(rank) = baseFactor * initCost * Pow(baseCost, rank)
if rank >= 50:  cost *= 1e6
if rank >= 60:  cost *= 1e9
if rank >= 80:  cost *= 1e15
if rank >= 110: cost *= 1e24
if rank >= 150: cost *= 1e36
```

**Muros explicitos no preco**. Cada multiplo de rank vira "ja passei do
plateau" mesmo dentro da mesma skill. Bom design — gera frequencia de
celebracao.

#### 1.3.12 Curva de proficiencia com muros

Fonte: `05-skills.md:55-71`.

```
prof(level) = 5 * (1 + profDifficulty*0.75) * (1+level) * 3^(level/100)
                / max(0.1, initInterval)

if level >= 250: prof *= 10^((level-250)/25)
if level >= 300: prof *= 2 ^((level-300)/25)
if level >= 400: prof *= 4 ^((level-400)/25)
if level >= 550: prof *= 8 ^((level-550)/25)
if level >= 750: prof *= 16^((level-750)/25)
if level >= 900: prof *= 32^((level-900)/100)
```

`profDifficulty` baixo = skill "facil" (sobe rapido), alto = "dificil". Skill
com `initInterval` baixo (rapida) pede mais proficiencia/level. Isso balanceia
"fast hit small" vs "slow hit hard".

#### 1.3.13 Skill passives

Fonte: `05-skills.md:99-117`. Skills equipadas dao bonus passivos via
`SkillPassiveKind` (41 tipos). **Skills viram tecido conectivo entre
sistemas** — afetam Pet, Expedition, Town material gain, etc., nao so combate.

#### 1.3.14 Skill buffs (channeled)

Fonte: `05-skills.md:121-133`. Buffs temporarios podem ser **channeled** —
duram so enquanto a skill esta sendo canalizada. Permite skills "mantenedoras"
que voce mantem ativa para o buff.

#### 1.3.15 Skill prerequisitos

Fonte: `05-skills.md:136-141`. `requiredSkills: Dictionary<int, long>` — skill
X precisa estar em level Y. **Cria arvore de skills natural** sem precisar
desenhar grafo visual rigido.

#### 1.3.16 Cap absoluto de skill

Fonte: `05-skills.md:157-159`. `calculatedRequiredProficiencys = new
double[2000]`. Skills podem chegar a level ~2000 em endgame. Com 30 skills * 6
herois * 50 rank cada = **profundidade absurda de progressao**.

#### 1.3.17 Combat — elementos e debuffs

Fonte: `references/ieh2_dump/docs/17-combat.md`.

**6 elementos (linha 40):**

```csharp
public enum Element { Physical, Fire, Ice, Thunder, Light, Dark }
```

Nota: **Physical e elemento 0**, nao separado. Permite operacoes uniformes.

**Resistencias e modificadores (linhas 48-58):**

```csharp
Multiplier[6] elementDamages;        // bonus de dano emitido
Multiplier[6] elementAbsoptions;     // chance de absorver (HP em vez de dano)
Multiplier[6] elementInvalids;       // chance de imunidade total
Multiplier[6] elementSlayerDamages;  // dano extra vs inimigo do elemento
```

Absoption e Invalids capados em 0.9.

**ArmoredFury/WardedFury (linhas 60-77):** padrao raro e elegante.

```csharp
elementDamages[Physical] += ArmoredFury * log2(max(1, DEF))
elementDamages[Magic*]   += WardedFury  * log2(max(1, MDEF))
```

**DEF/MDEF normalmente seriam "lixo no late game"**. ArmoredFury converte DEF
em offensive damage **logaritmicamente**. Resolve elegantemente "high DEF
doesn't matter late". Use no nosso jogo.

**24 debuffs (linhas 81-95):**

```csharp
public enum Debuff {
  Nothing,
  AtkDown, MatkDown, DefDown, MdefDown, SpdDown, MaxMPDown,    // stat down
  Stop, Electric, Poison, Knockback, Gravity, Death,            // CC
  FireResDown, IceResDown, ThunderResDown, LightResDown, DarkResDown,  // elem res
  MPAspiration, Banana, SlimeBall, RestoreAmmo, RestoreDodge, CleanupAttacks
}
```

Cada heroi tem `Multiplier[24] debuffChances` — chance de aplicar cada debuff
em hit. **Mistura debuffs serios (AtkDown, Poison) com piadas tematicas
(Banana, SlimeBall)**. Da personalidade.

**12 monster species + 8 colors (linhas 112-122):**

```csharp
MonsterSpecies { Slime, MagicSlime, Spider, Bat, Fairy, Fox, DevilFish, Treant,
                 FlameTiger, Unicorn, Mimic, ChallengeBoss }
MonsterColor { Normal, Blue, Yellow, Red, Green, Purple, Boss, Metal }
```

12 x 8 = 96 variantes nominais. Cada cor altera drops, stats, mecanica
especial.

**Movement patterns (linhas 167-169):**

```csharp
public enum MovePattern { Shortest, Kiting }
```

So 2. Suficiente para idle.

#### 1.3.18 Challenges

Fonte: `references/ieh2_dump/docs/11-challenges.md`.

**265 arquivos com prefixo Challenge** — sistema mais massivo do jogo.

**Tipos (linhas 10-19):**

```csharp
public enum ChallengeType {
  RaidBossBattle, SingleBossBattle, HandicappedBattle,
  SuperDungeon, UltimateTrial
}
```

**175+ challenges nominados** (linhas 22-32). Padrao de nome: `Raid{Boss}{Lv}`,
`Solo{Boss}{Lv}`, `HC{Boss}{Lv}`. Bosses tem nomes proprios: Florzporb,
Arachnetta, GuardianKor, Bananoon, etc.

**17 handicaps (linhas 36-50):**

```csharp
public enum ChallengeHandicapKind {
  OnlyWeapon, OnlyArmor, OnlyJewelry, Only1EQforAllPart,
  Only1Weapon, Only1Armor, Only1Jewelry, NoEQ,
  OnlyClassSkill, OnlyBaseAndGlobal, Only2ClassSkillAnd1Global,
  Only2ClassSkill, OnlyBaseSkill, NoSkill,
  DamageLimit, DisableManualMove, MoveLimit10meter
}
```

Cada handicap **forca estilo de jogo diferente**. Permite reusar engine base
com restricoes para criar conteudo de horizonte longo.

**Estrategia: 17 handicaps x 10 bosses x 3 modos (Raid/Solo/HC) = ~510
desafios sem programar 510 lutas.** Configuracao, nao codigo. (linha 112)

**Recompensa = Multiplier permanente.** Challenges nao dao moeda; dao bonus
permanente registrado quando completo. Ficam relevantes pra sempre.

---

## 2. Convergencias

### 2.1 Numero de classes: 6-10 e o sweet spot

- IEH2: **6 classes** (Warrior/Wizard/Angel/Thief/Archer/Tamer) — todas
  utilizaveis.
- IdleOn: ~6 "ramos primarios" mas com ate 17 promocoes finais via branching.
- Idle Medieval planejou **10 classes** (`classes-and-characters.md:28-39`).

Convergencia: **menos que 6 vira monotono, mais que 10 vira inbalanceavel**.
IdleOn so consegue 17 porque cada promocao herda do anterior (codigo
compartilhado).

### 2.2 5 atributos primarios (VIT/STR/INT/AGI/LUK)

- IEH2: VIT/STR/INT/AGI/LUK (`02-heroes-and-stats.md:14-16`).
- IdleOn: STR/AGI/WIS/LUK (4 atributos, sem VIT separado — embute em HP).
- Idle Medieval: STR/DEX/INT/VIT/LUK (`STATE-OF-THE-PROJECT.md:61`).

Convergencia: **5 atributos basicos sao o padrao classico DnD-derivative**.
IdleOn omite VIT porque HP escala direto de STR. Nosso projeto ja tem os 5.

### 2.3 Stats secundarias derivadas de 2 atributos

- IEH2: DEF = `(VIT + STR)/2`, MDEF = `(VIT + INT)/2`
  (`02-heroes-and-stats.md:71-82`). Forca build hibrido.
- IdleOn: stat principal cruzado com accuracy (Warrior STR, mas accuracy de
  WIS) (`COMBAT_MATH.md:38-42`). Mesma logica.

Convergencia: **stats derivadas nao devem depender de 1 atributo so**, senao
o player dumpa tudo nesse 1. Linka 2 atributos pra cada stat derivada.

### 2.4 Elementos: 6-8 elementos com matriz de fraquezas

- IEH2: **6 elementos** (Physical + Fire/Ice/Thunder/Light/Dark)
  (`17-combat.md:40`).
- Idle Medieval planejou **8 elementos**
  (`damage-formula.md:204-219`: Fire, Ice, Water, Wind, Rock, Electric, Light,
  Dark) com matriz `multiplier_table[atk][def]`.
- IdleOn: nao tem elementos no sentido tradicional (so Physical/Magic split).

Convergencia parcial: **6 elementos e padrao confortavel**; 8 e teto antes de
"planilha". Nosso projeto ja escolheu 8 — funciona se Wind/Rock/Water vierem
aos poucos.

### 2.5 Resistencias capadas (nunca 100%)

- IEH2: resistencias max 0.9 (`02-heroes-and-stats.md:101`).
- IdleOn: hit chance clamp [0%, 100%] com effective gate em 0.5
  (`COMBAT_MATH.md:117-128`).
- Idle Medieval: cap dodge 0.75, block 0.75, accuracy clamp [0.05, 0.99]
  (`damage-formula.md:399-411`).

Convergencia: **nunca permita imunidade total**. Sempre 1-10% de tensao.

### 2.6 Status effects: misturar damage-over-time + crowd control + buffs

- IEH2: 24 debuffs misturando severidade alta (Poison, Death) e
  pequena/tematica (Banana, SlimeBall) (`17-combat.md:81-95`).
- Idle Medieval: 11 status planejados (`damage-formula.md:350-362`).

Convergencia: ter **3 categorias** misturadas:

1. **DoT**: Poison, Burning, Bleeding.
2. **CC**: Stun, Freeze, Slowed, Blind, Silence, Confused.
3. **Buff/Debuff stat**: ATK Up/Down, DEF Up/Down, Atk Speed Up, Shielded.

### 2.7 Skills com 2 eixos de progressao

- IEH2: rank (investimento) + level (uso) (`05-skills.md:12-15`).
- IdleOn: talents com 8 funcoes de growth (level invest)
  (`01_CLASSES_TALENTS.md:53-134`).

Convergencia: **skills nao devem ter so 1 dimensao**. IdleOn so tem level
(invest), IEH2 tem rank+level. Idle Medieval atualmente tem 0 (skill tree e
stub).

### 2.8 Soft caps polinomiais

- IdleOn: `cap + (x-cap)^p, p<1` em dano (`COMBAT_MATH.md:75-88`).
- IEH2: expoente decrescente por faixa em SPD (`02-heroes-and-stats.md:120-
  133`).
- Idle Medieval: diminishing returns `def / (def + scale)` em DEF
  (`damage-formula.md:144-157`).

Convergencia: **toda stat principal precisa de soft cap matematico**. Linear
explode. Multiplicativo trivializa. `x/(x+k)` ou `(x-cap)^p` sao as opcoes.

### 2.9 Auto-battle + lookup de tipo de ataque vs armor

- IEH2: elementDamages com elementSlayer adicional para racas
  (`17-combat.md:55`).
- IdleOn: nao explicito mas escondido em weapon types.
- Idle Medieval: 7x4 matrix Atk type vs Armor type (`damage-formula.md:248-256`).

Convergencia: **lookup tables matriciais sao o padrao para criar
identidade de classe** sem mudar formula.

---

## 3. Divergencias / Decisoes pendentes

### 3.1 Class promotion: branching tree (IdleOn) vs paralelo (IEH2)

- IdleOn: tree com promotions. Player escolhe identidade aprofundando.
- IEH2: 6 classes paralelas, sem promotion.
- Idle Medieval atual: catalogou 10 classes paralelas COM Awakening tree (★1, 3,
  5, 7, 9, 10) que e' uma promotion tardia (`classes-and-characters.md:46-53`).
  Hibrido.

[DECISAO PENDENTE: Awakening eh promotion ou so passive tree?
`classes-and-characters.md` descreve Awakening como **escolha de ramo em ★3 e
★5**. Isso e branching. Mas todas as 10 classes estao definidas paralelas
desde o inicio. Hibrido funciona se Awakening for tardio (lv 100+) e as 10
classes forem desbloqueaveis aos poucos (1 a cada 50 levels somados, conforme
`classes-and-characters.md:11`). Confirmar com o usuario.]

### 3.2 Quantos skills por classe? 20 (IdleOn-like) vs 30 (IEH2)

- IEH2: 30 skills por heroi (`05-skills.md:9`).
- Idle Medieval planejou: 20 skills por classe x 10 = 200 (`skills-catalog.md:1`).

20 e' enxuto. Permite ter cada skill com identidade. 30 dilui. **Manter 20**.

### 3.3 Skill points: por level vs investimento de recurso

- IdleOn: ganha skill point por level, gasta em talent.
- IEH2: rank custa **resource** (Stone/Crystal/Leaf), level sobe **usando** (sem
  custo direto, mas com cap por rank).
- Idle Medieval atual: `skill_points_unspent += 1 por level`
  (`STATE-OF-THE-PROJECT.md:84`). Padrao IdleOn.

[DECISAO PENDENTE: Skill rank custara gold/stone separado, ou so skill point
ganho por level? Recomendacao: **manter so skill point por level em R1.0**.
Adicionar rank-resource em prestige tier (rebirth/Awakening). Evita complexidade
prematura.]

### 3.4 Active vs passive ratio

- IEH2: skill ativa com cast time + skill passive equipada
  (`05-skills.md:99-117`).
- Cookie Clicker Grimoire: tudo ativo (`14-minigame-grimoire.md:88-100`).
- Idle Medieval planejado: mistura. Warrior tem 8 active + 12 passive
  (`skills-catalog.md:22-43`).

Convergencia parcial. **Padrao recomendado: 50% active / 50% passive**. Ativas
sao o "skill rotation"; passivas sao o "build identity".

### 3.5 Cooldown system: por skill vs recurso global

- IdleOn: nao tem CD explicito visivel (auto-attack puro).
- IEH2: cada skill tem cast time + interval (`05-skills.md:62-71`).
- Cookie Clicker: so mana, sem CD por spell.
- Idle Medieval planejou: **CD por skill em segundos**
  (`skills-catalog.md:22-43`).

[DECISAO PENDENTE: confirmar que CD por skill e o padrao. Alternativa: mana
global como Cookie Clicker (sem CD individual). Recomendacao: **manter CD por
skill + custo de MP**. Auto-battle decide ordem por prioridade (CD ready + MP
disponivel).]

### 3.6 Status effects: 11 (Idle Medieval planejado) vs 24 (IEH2)

- IEH2: 24 (com piadas tematicas como Banana).
- Idle Medieval: 11 status base
  (`damage-formula.md:350-362`).

[DECISAO PENDENTE: Adicionar status tematicos medievais? Ex: Wet (ice mais
forte), Oiled (fire mais forte), Marked (next hit +crit), Hexed (debuff
generico)? Recomendacao: **manter 11 em R1.0**; adicionar 5-10 mais em R2.0
junto com classes Bard/Necromancer.]

### 3.7 Elementos: 6 (IEH2) vs 8 (Idle Medieval planejado)

- IEH2: 6 elementos com Physical = elemento 0.
- Idle Medieval: 8 elementos, sem Physical separado
  (`damage-formula.md:204-219`).

[DECISAO PENDENTE: Manter os 8 elementos planejados ou reduzir? Pergunta no
brief de R1.0: "todos os 8 ou subset?" Recomendacao: **ATIVAR todos os 8 em
R1.0 no codigo (ja estao na formula), mas LIBERAR conteudo elemental
gradualmente:**
- Forest (R1.0): Fire/Ice/Water somente (slimes verdes/azuis/vermelhos podem
  ser Water/Ice/Fire).
- Desert (R1.0): + Wind/Rock.
- Caverns (R1.5): + Electric.
- Cathedral/Crypt (R1.5): + Light/Dark.]

### 3.8 Pet/Summon system: integrar ja em R1.0?

- IEH2: pets como BATTLE subjects, ate 10 em campo (`17-combat.md:13-14`).
- IdleOn: Beast_Master, Bubonic_Conjuror tem companions.
- Idle Medieval planejou Ranger Druida (★3 ramo B), Necromancer, Summoner.

[DECISAO PENDENTE: Em R1.0 nenhuma classe Summoner esta ativa. Necromancer e
Summoner sao 2 das 10 classes. Recomendacao: **summons em R1.5+ junto com
Necromancer/Summoner unlock**.]

### 3.9 Channeled skills

- IEH2: channeled buffs (`05-skills.md:131-133`).
- Idle Medieval: nao planejado.

[DECISAO PENDENTE: Channeled skills permitem "manter buff ativo enquanto
canaliza". Combina mal com auto-battle (player nao decide quando canalizar).
Recomendacao: **NAO implementar channeled em R1.0**. Substituir por buffs
timed (duration X segundos).]

### 3.10 Skill prerequisitos

- IEH2: skill X precisa de skill Y level Z (`05-skills.md:136-141`).
- Idle Medieval: skill tree visual ainda nao desenhada.

[DECISAO PENDENTE: skill tree shape — linear (path A->B->C), branched (3 paths
divergem) ou grid (Path of Exile style com nodes free-form)? Recomendacao:
**branched simples**, 3 ramos por classe (DPS / Tank / Utility), cada ramo
6-7 nodes lineares, com requisito de "X pontos no ramo" para destravar nodes
keystone. Ver secao 4 abaixo.]

### 3.11 Class family bonuses

- IdleOn: cada classe da bonus account-wide via personagem de maior nivel
  (`01_CLASSES_TALENTS.md:184-202`).
- IEH2: nao tem equivalente.
- Idle Medieval: nao planejado.

[DECISAO PENDENTE: Implementar family bonuses agora ou esperar 5+ classes
desbloqueadas? Recomendacao: **adicionar em R1.5** quando o player ja tem
3-5 classes. Antes disso, nao tem peso.]

### 3.12 Mastery (RNG damping)

- IdleOn: mastery clamp(0.35 + bonus, 0.80) — controla min/max ratio do dano
  (`COMBAT_MATH.md:17-30`).
- IEH2: nao tem mastery explicito; usa damage variance em outro lugar.
- Idle Medieval: variance fixa +/-10% (`damage-formula.md:127-130`).

[DECISAO PENDENTE: Substituir variance fixa por mastery escalavel? IdleOn faz
isso muito bem — quanto mais o player investe, mais consistente o dano fica.
Recomendacao: **adicionar mastery stat em R1.5**. Default 0.7 (varia 70%-100%
do max), pode subir ate 0.95 via talents.]

### 3.13 Soft caps de dano

- IdleOn: 2 soft caps (4k, 15k) com expoente decrescente
  (`COMBAT_MATH.md:75-88`).
- IEH2: SPD com 6 regimes de expoente (`02-heroes-and-stats.md:120-133`).
- Idle Medieval: nao tem soft cap explicito em damage.

[DECISAO PENDENTE: Em que stat aplicar soft cap em Idle Medieval? Recomendacao:
**ATK final apos defesa**, com 2 thresholds (`5000` e `25000`) e expoentes
`0.9` e `0.8`. Detalhar em `02_math/damage-formula.md` antes de R1.0 (porque
ja eh problema em endgame).]

### 3.14 ArmoredFury/WardedFury

- IEH2: DEF/MDEF -> dano via log2 (`17-combat.md:62-77`).
- Outros: nao tem.

[DECISAO PENDENTE: Vale implementar? Pro: resolve elegantemente "high DEF
doesn't matter late game". Contra: complexidade extra na formula. Recomendacao:
**implementar em R1.5 com nome "Fury Stance"** — passiva de Tank que converte
DEF excedente em ATK. So ativa em Warrior ★5A2 (Paladino).]

### 3.15 Challenge system (handicap mode)

- IEH2: 510 challenges via 17 handicaps x 10 bosses x 3 modos
  (`11-challenges.md`).
- Outros: nao tem nada equivalente.

[DECISAO PENDENTE: Adicionar challenge mode em algum momento? Recomendacao:
**R2.0 ou mais tarde**. Idle Medieval ja tem zone/area/stage; challenges
ortogonais funcionam quando a base esta pronta. Marcar como porta de expansao
em `04_phases/`.]

---

## 4. Proposta para o Idle Medieval

> Decisoes especificas para R1.0 (versao 1.0 jogavel) e portas de expansao R1.5+.

### 4.1 Numero de classes em R1.0

**3 classes ativas em R1.0:**

1. **Warrior** — ja existe. DPS/Tank hibrido melee.
2. **Mage** — DPS magico, primeira classe usando elementos.
3. **Ranger** — DPS ranged, primeira classe usando Dodge alto e Pierce.

Justificativa:

- **3 classes** e o minimo viavel para fantasia de party (Tank/DPS-mag/DPS-fis).
- Cobre os 3 tipos de damage: physical melee, magic, physical ranged.
- Cobre 3 stats primarios distintos como main: STR / INT / DEX. **LUK** e
  secundario para todos. VIT e split entre Warrior (alto) e outros (medio).
- 7 classes restantes (Rogue, Cleric, Berserker, Necromancer, Monk, Bard,
  Summoner) ficam para R1.5+. Cada release adiciona 1-2 classes.

**Roster max em R1.0: 3 personagens** (1 slot por classe). Em R1.5: 5. R2.0: 10.

### 4.2 Class differentiation (alem de stat)

Cada classe em R1.0 deve ter pelo menos:

1. **Stat scaling diferente**: Warrior ATK escala 1.0x/STR, Mage MATK 1.0x/INT,
   Ranger ATK 0.6x/STR + 0.6x/DEX.
2. **Tipo de ataque base**: Warrior Slash (ou Crush se warhammer), Mage Magic,
   Ranger Pierce.
3. **Stat secundaria caracteristica**: Warrior Block chance alto, Mage Cast
   speed, Ranger Crit damage.
4. **Status effect inato** (small inherent application): Warrior pode aplicar
   Stun via skills basicas; Mage Burning; Ranger Bleeding ou Poison.
5. **Resource diferente**: Warrior MP baixo (skills basicas custam pouco), Mage
   MP alto (skills caras de magia), Ranger MP medio (skills tematicas).

Justificativa: IEH2 diferencia classes em 12 stats (`02-heroes-and-stats.md:34-
46`). Idle Medieval ja tem stats base por classe definidos
(`classes-and-characters.md:28-39`); ativar os 3 primeiros e suficiente.

### 4.3 Skill tree shape

**Branched simples — 3 ramos paralelos por classe.**

Layout:

```
              [Class Awakening keystone] (Lv 100)
                          |
        +-----------------+-----------------+
        |                 |                 |
     RAMO A           RAMO B           RAMO C
   (6 nodes)        (6 nodes)        (6 nodes)
        |                 |                 |
   [keystone A]      [keystone B]      [keystone C]
        |                 |                 |
     +---+              +---+              +---+
     |   |              |   |              |   |
    A1  A2             B1  B2             C1  C2
     |   |              |   |              |   |
   [...]               [...]              [...]
```

Cada classe tem:

- **3 ramos** com identidade clara (Warrior: Berserker DPS / Defender TANK /
  Tactician UTIL). Ja planejado em
  `classes-and-characters.md:55-77`.
- **18 nodes por classe** (6 por ramo). 6 = enough para sentir progresso, sem
  ser planilha.
- **2 keystones por ramo** (em positions 3 e 6 do ramo): keystones sao nodes
  com efeito ativo/passivo grande que muda a build.
- **Awakening** vira separado, em arvore propria (★1 a ★10) liberada apos Lv
  100. Detalhado em `classes-and-characters.md:46-53`.

Pontos por level:

- **1 skill point por level**. Total Lv 1-100 = 100 pontos. **18 nodes x 5
  ranks = 90 pontos por classe**. Player consegue maximizar 1 classe inteira
  em Lv 90, sobrando 10 pontos para respec ou trial-and-error.
- Nao implementar respec gratis em R1.0 (player se compromete com build).
  Adicionar respec via Scroll of Forgetting em R1.5.

[DECISAO PENDENTE: ranks por node — 1 rank (binary unlock) ou 5 ranks
(progressive)? Recomendacao: **3 ranks** por node (sweet spot entre granularidade
e pesinho). Total: 18 nodes x 3 ranks = 54 pontos por classe maxima.]

### 4.4 Skill upgrade levels

**Adotar rank/level dual como IEH2** — modificado para nao explodir
complexidade.

Cada skill tem:

- **Rank** (1-10): comprado com skill point (1 SP por rank). Determina
  cap_level.
- **Level** (1 a rank*10): sobe usando a skill em combate. XP de skill ganho
  por uso. Nao custa moeda.
- **Cap absoluto**: rank 10 -> level 100 max. Em R1.0, cap rank em 5 (level 50).
  Em R1.5+, cap em 10. Em Awakening tier, cap em 20.

Justificativa: IEH2 separa "investimento" de "uso" elegantemente
(`05-skills.md:7-15`). Player sempre tem alguma progressao de skill rodando
mesmo sem grindar gold.

### 4.5 Active vs passive mix

**Mix sugerido por classe (de 20 skills total):**

- **8 active skills** (com CD e MP cost).
- **8 passive skills** (sempre ativos).
- **4 ultimate/keystone** (mix, com CD longo ou passive grande).

Active skill execution em auto-battle: **prioridade fila por CD ready + MP
disponivel + signature condition**. Player escolhe ordem de prioridade nos
slots da hotbar (similar a IEH2 com 20 equipped slots).

[DECISAO PENDENTE: quantos slots de hotbar (skills equipadas) em R1.0?
Recomendacao: **6 slots** (3 active + 2 passive + 1 ultimate). Em R1.5+ subir
para 10.]

### 4.6 Cooldowns

**Manter CD por skill (em segundos), como planejado em `skills-catalog.md`.**

Categorias de CD:

| Tipo | CD range | Exemplo |
|---|---|---|
| Spam | 2-5s | Golpe Forte, Bola de Fogo, Tiro Certeiro |
| Standard | 6-12s | Investida, Tempestade de Gelo, Tiro Preciso |
| Strong | 15-25s | Decapitar, Meteoro, Camuflagem |
| Ultimate | 60-120s | Sol Caido, Sussurro do Final dos Tempos |

Justificativa: CD por skill ja escolhido em `skills-catalog.md`. Manter.

### 4.7 Elementos: 8 no codigo, gating por zona

**Manter os 8 elementos planejados, com gating de conteudo.**

Codigo ja preparado em `damage-formula.md:204-219`. Liberar elementos via:

1. **Forest (R1.0)**: Fire, Ice, Water (3 elementos slime).
2. **Desert (R1.0)**: + Wind, Rock (2 elementos novos).
3. **Caverns (R1.5)**: + Electric.
4. **Sky Temple / Crypt (R1.5)**: + Light, Dark.

Bonus elemental no equipamento entra so quando elemento esta liberado. Drops
de items elementais so em zona correspondente.

[DECISAO PENDENTE: Light/Dark sao mutualmente exclusivos por build (escolha de
alinhamento), ou stackam? Recomendacao: **stack permitido** — player pode
buildar hibrido. Em IEH2 sao 2 elementos independentes (`17-combat.md:40`).]

### 4.8 Status effects: 11 em R1.0

**Ativar 11 status do `damage-formula.md:350-362`:**

| Status | Tipo | Em R1.0? |
|---|---|---|
| Poison | DoT | Sim |
| Burning | DoT | Sim |
| Bleeding (Lacerate) | DoT stackavel | Sim |
| Slowed | Debuff | Sim |
| Blind | CC (miss chance) | Sim |
| Freeze | CC hard | Sim |
| Stun | CC hard | Sim |
| ATK Up | Buff | Sim |
| Shielded | Buff (block flat) | Sim |
| Thorns | Buff (reflect %) | Sim |
| Berserker | State | Sim |

R1.5+ adicionar:

- **Confused**: ataque proprios aliados.
- **Silence**: nao usa active skills.
- **Broken Armor**: DEF reduzido.
- **Curse**: Heal reduzido.
- **Marked**: proximo hit +50% dano.

Justificativa: 11 cobre as 3 categorias (DoT/CC/Stat). 5 adicionais sao para
classes Bard/Necromancer (R1.5+).

### 4.9 Damage formula final

**Manter pipeline ja descrito em `damage-formula.md:9-73`**, com adicoes:

1. **Adicionar soft cap polinomial** apos defesa:

```gdscript
const SOFT_CAP_1 = 5000.0
const SOFT_CAP_1_EXP = 0.9
const SOFT_CAP_2 = 25000.0
const SOFT_CAP_2_EXP = 0.8

func apply_soft_caps(dmg: float) -> float:
    if dmg > SOFT_CAP_1:
        dmg = SOFT_CAP_1 + pow(dmg - SOFT_CAP_1, SOFT_CAP_1_EXP)
    if dmg > SOFT_CAP_2:
        dmg = SOFT_CAP_2 + pow(dmg - SOFT_CAP_2, SOFT_CAP_2_EXP)
    return dmg
```

Aplicar no step 6 (apos `apply_defense`), antes de block.

2. **Adicionar mastery stat** em CombatStats:

```gdscript
@export var mastery: float = 0.7  # min/max damage ratio
# damage roll: random in [max * mastery, max]
```

Substituir variance fixa +/-10% por mastery configuravel
(`damage-formula.md:127-130`).

3. **Adicionar accuracy gate ao estilo IdleOn** como camada extra (opcional —
ativar so em endgame zones):

```gdscript
const ACCURACY_GATE_RATIO = 0.5
func roll_hit_gated(attacker, defender, skill) -> bool:
    var effective = attacker.accuracy / defender.evasion
    if effective < ACCURACY_GATE_RATIO:
        return false  # literalmente nao acerta
    # ...resto do calc
```

Justificativa: cria "portoes de progressao" em zonas tardias
(`COMBAT_MATH.md:117-128`).

4. **Manter element matrix e armor type matrix** ja descritos
   (`damage-formula.md:204-273`).

### 4.10 Hit types

**Padronizar 6 hit types** em compute_hit result:

| Hit type | Cor (PSD) | Trigger |
|---|---|---|
| Normal | branco | hit normal |
| Crit | amarelo | crit roll passa |
| Block | cinza | block roll passa (parcial) |
| Dodge | azul claro | dodge roll passa (full) |
| Miss | azul escuro | hit roll falha |
| Heal | verde | self-heal/lifesteal exibido em quem ganha HP |

`damage-formula.md` ja produz `is_crit`/`is_block`/`is_dodge`/`is_miss`.
**Heal exibido a parte** quando lifesteal > 0.

[DECISAO PENDENTE: Adicionar "Glance" como 7o hit type? IdleOn nao tem. IEH2
nao tem. Recomendacao: **NAO**. Manter os 6.]

### 4.11 Awakening tree

Manter `classes-and-characters.md:46-53`:

- Lv 100 (apos primeiro Rebirth): destrava Awakening.
- 10 estrelas, escolhas em ★3, ★5.
- ★10 e skill assinatura.

Em R1.0: **so Warrior tem Awakening completamente detalhado**
(`classes-and-characters.md:55-77`). Mage e Ranger tem ★3/★5 detalhados mas
★7/★9/★10 marcado como [PLACEHOLDER].

[DECISAO PENDENTE: R1.0 inclui Awakening jogavel ou so como "estrutura
documentada"? Recomendacao: **Awakening em R1.5** quando o player tem
acumulado dezenas de horas. Manter ★1-★3 jogavel em R1.0 como "preview".]

### 4.12 Class family bonuses

[DECISAO PENDENTE: Recomendacao: **R1.5+**, depois que player tem 3+ classes.
Implementacao simples: bonus passive account-wide vinculado ao personagem
mais alto naquela classe, com formula `decay(x1, x2)` ao estilo IdleOn
(`01_CLASSES_TALENTS.md:184-202`). Lista de bonus em
`classes-and-characters.md` (adicionar secao em R1.5).]

### 4.13 Resumo: features R1.0 vs portas de expansao

| Feature | R1.0 | R1.5 | R2.0+ |
|---|---|---|---|
| Classes ativas | 3 (Warrior, Mage, Ranger) | 5 (+Rogue, +Cleric) | 10 |
| Skill tree | 18 nodes x 3 ranks por classe | mesma | + respec |
| Skill rank cap | 5 | 10 | 20 |
| Skill level cap | 50 | 100 | 200 |
| Hotbar slots | 6 | 8 | 10 |
| Active/passive ratio | 50/50 | 50/50 | 50/50 |
| Elementos ativos | 5 (Fire/Ice/Water/Wind/Rock) | 7 (+Electric, +Light/Dark) | 8 |
| Status effects | 11 | 16 | 16 |
| Hit types | 6 | 6 | 6 |
| Damage soft caps | 1 cap (5k) | 2 caps (5k, 25k) | 3+ |
| Mastery stat | nao (variance fixa) | sim | sim |
| Accuracy gate | nao (so clamp) | sim em zonas tardias | sim |
| ArmoredFury/WardedFury | nao | parcial (Paladino) | sim |
| Awakening tree | preview ★1-★3 | jogavel ★1-★5 | completo ★10 |
| Class family bonuses | nao | sim | sim |
| Channeled skills | nao | nao | talvez |
| Pets/Summons | nao | nao | sim (Necromancer/Summoner) |
| Challenge mode | nao | nao | sim |

---

## 5. Hooks com docs existentes

### 5.1 Documentos que ja existem e suportam esta proposta

- `STATE-OF-THE-PROJECT.md:56-62`: CombatStats ja tem 30+ stats derivados,
  incluindo cap de crit/dodge/elem/regen/leech.
- `STATE-OF-THE-PROJECT.md:84`: `skill_points_unspent += 1 por level` ja
  implementado. Combina com proposta de 1 SP por level.
- `STATE-OF-THE-PROJECT.md:100-102`: SkillTree.apply_bonuses stub aceita
  CharacterInstance + CombatStats. Pronto para receber a logica de 18 nodes.
- `STATE-OF-THE-PROJECT.md:374-378`: SkillTree marcado como porta de expansao.
  Esta proposta preenche o stub.
- `planning/01_design/classes-and-characters.md`: ja tem 10 classes
  catalogadas + Awakening trees por classe. Esta proposta gerencia ROLLOUT
  (3 em R1.0, +2 em R1.5, +5 em R2.0).
- `planning/01_design/skills-catalog.md`: ja tem 200 skills catalogadas (20
  por classe). Esta proposta confirma o numero e separa active/passive.
- `planning/02_math/damage-formula.md`: pipeline `compute_hit` ja descrito,
  com hit/dodge/crit/block/lifesteal/thorns/reflect/status. Esta proposta
  adiciona soft caps e mastery, mantendo o resto.

### 5.2 Documentos a atualizar como consequencia

1. **`planning/02_math/damage-formula.md`**:
   - Adicionar secao "Soft caps" (sub 4.3) com pipeline polinomial.
   - Adicionar secao "Mastery" (sub 3.1) substituindo variance fixa.
   - Adicionar secao "Accuracy gate" (sub 1.3) opcional.
2. **`planning/01_design/classes-and-characters.md`**:
   - Adicionar secao "Rollout por release": R1.0 tem 3, R1.5 tem 5, R2.0 tem 10.
   - Confirmar nos ★7/★9/★10 das classes restantes ate R1.5 (placeholder).
3. **`planning/01_design/skills-catalog.md`**:
   - Marcar quais skills estao em R1.0 vs R1.5 (so as 60 skills de
     Warrior/Mage/Ranger sao R1.0).
4. **`planning/04_phases/`**:
   - Atualizar Phase 01 (Core Loops) para incluir 3 classes + skill tree
     funcional + 11 status + 5 elementos ativos.
   - Atualizar Phase 02 (Expansion) para Rogue + Cleric + Electric + Light/Dark.
   - Atualizar Phase 03 (Mid-game) para Awakening jogavel.
5. **`planning/00_meta/pending-decisions.md`**:
   - Adicionar [DECISAO PENDENTE] das secoes 3.x deste documento como entries
     numerados.
6. **`planning/00_meta/glossary.md`**:
   - Adicionar termos novos: "rank/level dual", "mastery", "soft cap",
     "accuracy gate", "ArmoredFury/WardedFury", "class family bonus".

### 5.3 Cross-references explicitos

Os links abaixo devem ser usados em vez de duplicar conteudo:

- Hit types e cores: `[ver: planning/03_research/synthesis/03-combate-classes-
  skills.md#410-hit-types]`.
- Soft caps de dano: `[ver: planning/03_research/synthesis/03-combate-classes-
  skills.md#49-damage-formula-final]`.
- Numero de classes em R1.0: `[ver: planning/03_research/synthesis/03-combate-
  classes-skills.md#41-numero-de-classes-em-r10]`.
- Skill tree shape: `[ver: planning/03_research/synthesis/03-combate-classes-
  skills.md#43-skill-tree-shape]`.

---

## 6. Resumo executivo (TL;DR)

1. **3 classes em R1.0** (Warrior + Mage + Ranger). 7 classes para R1.5/R2.0.
2. **Skill tree branched simples** — 3 ramos x 6 nodes x 3 ranks = 54 SP por
   classe. 1 SP por level.
3. **Rank/level dual de IEH2 — rank custa SP, level sobe com uso**. R1.0 cap
   rank 5 -> level 50.
4. **Damage formula adiciona soft caps polinomiais e mastery** ao pipeline ja
   existente em `damage-formula.md`.
5. **8 elementos no codigo** (ja tem), mas **gating de conteudo**: Forest/Desert
   tem 5 elementos visiveis; Light/Dark vem em R1.5.
6. **11 status effects ativos em R1.0**, +5 em R1.5.
7. **6 hit types padronizados**: Normal/Crit/Block/Dodge/Miss/Heal.
8. **Awakening em R1.5** (so preview ★1-★3 em R1.0).
9. **Pets/Summons, channeled skills, challenge mode** todos R2.0+.
10. **Class family bonuses** estilo IdleOn em R1.5.

Conflitos com docs existentes: nenhum bloqueador. Esta proposta refina o que
ja esta documentado, sem inventar. Ver secao 3 para 15 decisoes pendentes
explicitas a confirmar com o usuario.
