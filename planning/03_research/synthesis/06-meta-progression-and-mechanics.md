# Sintese: Meta-Progressao, Pets, Eventos e Timers

> Comparacao das cascatas de prestige, sistemas de pet, mecanicas de buff
> cronometradas, guild e premium store entre Cookie Clicker (CC), Legends of
> IdleOn (IO) e Incremental Epic Hero 2 (IEH2). Foco em informar as Fases
> 04-05 do Idle Medieval (rebirth ja planejado, ascensao/transcendencia em
> `02_math/ascension-multipliers.md` ainda com numeros provisorios).
>
> Todas as numericas citam arquivo+linha das fontes em
> `references/<jogo>/`. Quando o jogo oficial diverge das nossas suposicoes
> do hub, anotei `[CONFLITO]`. Quando 3 ou mais opcoes incompativeis aparecem,
> anotei `[DECISAO PENDENTE]`.

---

## 1. Como cada jogo faz

### 1.1 Cookie Clicker (referencia classica de prestige idle)

#### 1.1.1 Camadas de prestige

CC tem **uma camada** de prestige (Ascension / Reincarnate), com **uma moeda
secundaria opcional** (Sugar Lumps).

Citacao da formula (`references/cookie-clicker-dump/07-prestige-ascension.md`
linhas 14-22):

```js
Game.HCfactor = 3
Game.HowMuchPrestige(cookies) = (cookies / 1e12)^(1/3)   // cbrt
Game.HowManyCookiesReset(chips) = chips^3 * 1e12
```

Cada prestige level vale **+1% CpS permanente** (linha 23-26). O ganho usa a
soma historica `cookiesReset + cookiesForfeited`, entao re-ascender nunca
"perde" prestige acumulado (linhas 47-58).

#### 1.1.2 Custo crescente cubico

`07-prestige-ascension.md` linha 30-39:

| Prestige Level | Cookies totais necessarios (level^3 * 1e12) |
|---:|---:|
| 1 | 1e12 |
| 10 | 1e15 |
| 100 | 1e18 |
| 1.000 | 1e21 |
| 10.000 | 1e24 |
| 100.000 | 1e27 |
| 1.000.000 | 1e30 |

Heuristica da comunidade ("regra dos +10%"): so vale ascender quando o ganho
de prestige seria >= 10% do prestige atual
(`07-prestige-ascension.md` linha 553).

#### 1.1.3 Heavenly Tree (84+ upgrades)

Tabela completa em `07-prestige-ascension.md` linhas 638-726. O nó raiz e'
**Legacy** (1 chip, linha 645). Os 5 unlockers do multiplicador
(`Heavenly chip secret` -> `Heavenly key`) custam, somados,
**1.122 bilhao de chips** (linha 747) para liberar 100% do bonus de prestige.

Linhas tematicas:
- Angelica (7 upgrades, precos `7^N`: 7, 49, 343, 2401, 16807, 117649, 823543)
  — +CpS offline cumulativo (linha 248-258).
- Demoniaca espelhada (linha 260-269).
- Convergencia em **Chimera** custando `7^9 = 40.353.607` chips (linha 274).
- 5 perma-slots progressivos (100 -> 50.000.000.000 chips, total ~50B,
  linha 487-493).

#### 1.1.4 Sugar Lumps (segunda moeda meta, tempo real)

`08-sugar-lumps.md` linhas 36-41:

```js
hour = 1000 * 60 * 60
lumpMatureAge   = hour * 20    // 20h
lumpRipeAge     = hour * 23    // 23h
lumpOverripeAge = lumpRipeAge + hour   // 24h
```

**Cada lump leva 20-24h real** para amadurecer. Custo de level N de building
e' `N+1` lumps; total ate level 15 = 120 lumps; level 20 = 210 lumps
(`08-sugar-lumps.md` linhas 149-160). Isso vira **gate de calendario** (~1
lump/dia), impossivel de acelerar por progressao normal.

Lumps **persistem entre ascensoes** (linha 16). Tipos especiais: Bifurcated
(10-15%), Golden (0.3%), Meaty (proporcional a wrath), Caramelized (2%)
— tabela em `08-sugar-lumps.md` linhas 98-106.

#### 1.1.5 Born again (challenge mode)

`07-prestige-ascension.md` linhas 99-110:

```
Born again: bloqueia efeito de prestige, heavenly upgrades, sugar lumps,
levels de building, perma-upgrades, minigames, heralds.
Existem achievements exclusivos desse modo.
```

#### 1.1.6 Golden Cookies e Buffs cronometrados

`06-golden-cookies-buffs-wrinklers.md` linha 33-65: spawn 5-15 min base
(modificado por upgrades para tao baixo quanto 0.05s em chain mode). Lifetime
13s na tela. Probabilidade de spawn por frame `((t - minTime) / (maxTime -
minTime))^5` — ou seja chance 0 antes de minTime, garantido perto de maxTime.

Efeitos possiveis (linha 119-141):

| Efeito | Multiplicador | Duracao |
|---|---|---|
| Frenzy | CpS x7 | 77s |
| Click Frenzy | clique x777 | 13s |
| Elder Frenzy | CpS x666 | 6s |
| Cookie chain | dinheiro escalonado | varios cliques |
| Cookie Storm | mini-cookies caindo | 7s |
| Lucky! | 15% das cookies banked OU 15min de CpS, o menor | instantaneo |
| Dragon Harvest | CpS x15 | 60s |
| Building special | CpS x (amount/10 + 1) | 30s |

**Padroes-chave:**
- Buffs sao **respostas ativas opcionais** — o jogador clica para receber.
- Existem achievements por combos ("Get To Choppah!" = 7 buffs simultaneos).
- Wrath cookies tem mesma frequencia mas chance de **debuff** (clot CpS x0.5
  por 66s; linha 119).

#### 1.1.7 Wrinklers (consumo passivo + payout)

`06-golden-cookies-buffs-wrinklers.md` linhas 290-321:

```
wrinklerHP = 2.1, wrinklerLimit = 14
suckRate = 1/20 (5% da CpS por wrinkler)
Quando explode: devolve 110% do que sugou (base toSuck=1.1)
```

Cap 10 wrinklers (linha 299), +2 com Elder spice = 12. Cada um come 5% da
CpS. Funcionam como **savings account** com taxa 10% (sair com 110%). Shiny
wrinkler (0.01% spawn, linha 318) paga 3x.

#### 1.1.8 Pantheon (minigame de buffs slot)

`13-minigame-pantheon.md` linha 30-38: 3 slots (Diamond, Ruby, Jade) com
intensidade decrescente. 11 deuses, cada um com efeito-positivo + drawback.

Cooldown de swap (linha 247-251):

```js
2 swaps disponiveis  -> recarrega em 1h
1 swap disponivel    -> 4h
0 swaps              -> 16h
```

Swap pode ser refilled gastando 1 sugar lump (linha 422-429).

### 1.2 Legends of IdleOn (multi-personagem, foco em colecoes)

#### 1.2.1 Camadas de prestige

IdleOn nao tem rebirth tradicional como CC ou IEH2. Em vez disso, tem uma
**cadeia de meta-progressao por colecao** que tecnicamente nunca reseta:

- **Achievements** (420 entradas; `idleon-reference/09_META_PROGRESS.md`
  linhas 48-83). Alguns viram alavanca de balance (linha 82-83): achievement
  184 = +5% crit chance por nivel. Achievements **dao bonus mecanico**, nao
  cosmetico.
- **Tasks** (6 mundos * ~25 tasks; linha 91-103). Cada task tem 10
  breakpoints progressivos. Completar tier da tokens gastos em Merits.
- **Merits** (6 mundos * ~10 merits; linha 105-116). Bonus permanentes
  account-wide.
- **Upgrade Vault** (90 upgrades; linha 191-199): late-game tree com bonus
  multiplicativos account-wide. Custos crescem exponencialmente. Onde
  jogadores de 1000h+ continuam progredindo.

#### 1.2.2 Bribes (gold sinks permanentes)

`09_META_PROGRESS.md` linhas 232-236; detalhe em `10_MONETIZATION.md` linhas
86-99:

```
41 NPC bribes
Custos: 750 gold -> 100M+ gold
Efeito: permanent, account-wide
Exemplos: stamp cost -5%, shop -7%, +AFK time
```

**Padrao chave:** bribes resolvem economia infinita — milhoes de gold viram
permanent bonus em vez de inflar pra nada.

#### 1.2.3 Companions (167 entradas)

`09_META_PROGRESS.md` linhas 124-160:

```json
"King_Doot": {
  "effect": "All Divinities from World 5 count as Active",
  "bonus": 1,
  "tourPower": 165
}
"Dedotated_Ram": {
  "effect": "Use Storage Chest anywhere in Quickref"  // QoL pura
}
```

167 companions agrupados em 5 categorias tematicas. Tem efeitos que vao de
**buffs game-changing** ate **conveniencias de UI**. Sistema **separado** do
combat — tem stats proprios (`tourPower`) usados em "world tours" auto-battler
(linha 146-151).

#### 1.2.4 Weekly Bosses (timer real semanal)

`09_META_PROGRESS.md` linhas 166-185:

```
9 weekly bosses
Reset semanal
Drop weekly tokens gastos em weeklyBossesShop
```

Cria ritmo de engajamento sem demandar daily login (linha 187).

#### 1.2.5 Cards (sistema de colecionaveis com bonus)

(Nao detalhado em `09_META_PROGRESS.md` mas referenciado.) O sistema IdleOn
canonico tem ~400 cards (1 por inimigo). Cada card equipado da bonus passivo.
Cards "shiny" sao variantes raras com efeito amplificado. Set bonus quando
N+ cards de mesma categoria equipados — espelha 1:1 a estrutura de
`cards-catalog.md` do projeto atual.

#### 1.2.6 Alchemy (bubbles + vials + sigils + refinery + salt lick)

`04_ALCHEMY.md` linhas 8-19, 56-83:

- **4 cauldrons** (Power/Quicc/IQ/Kazam), cada um com **35 bubbles** = 140
  bubbles totais. Bubbles tem `func: "addDECAY"` com cap em level 50.000
  (linha 47-50) — escala indefinida com diminishing returns.
- **84 vials** (linha 56). Diferente de bubbles, vials nao consomem material
  cada level — sobe **uma vez** e bonus permanente. 13 levels cada.
- **4 P2W sigils** com 2-3 tiers cada (linha 88-103). Comprados com gems.
- **Refinery** (9 sais) -> **Salt Lick** (10 upgrades). Cadeia de
  transformacao idle (linha 117-167).
- **Market** (16 farming upgrades, linha 169-189).

Total de "alavancas" no sistema: 140 + 84 + 4 + 10 + 16 = **254 upgrades
permanentes** so em Alchemy. Cada bubble tem `itemReq` com **liquid de cores
diferentes** — forca investir em todos os 4 cauldrons (linha 38-45).

#### 1.2.7 Construction Towers (27 buildings, gating de subsistemas)

`06_WORLD3_SUBSYSTEMS.md` linhas 9-49:

```
27 building types, cada um com maxLevel + custo cost*exponent^L
Construction precisa de um Squire/Mage character locked (linha 45-49)
- Death_Note unlock -> killbook tracking
- Salt_Lick unlock -> subsistema Salt Lick
- Talent_Book_Library unlock -> +max level em talents
```

**Padrao:** building unlocks habilitam **subsistemas inteiros**. "Pra cada
feature W3+ existe um gating por construcao" (linha 307).

#### 1.2.8 Prayers (buff + curse simultaneo)

`06_WORLD3_SUBSYSTEMS.md` linhas 80-115:

```
25 prayers
Cada prayer: efeito positivo + curse no mesmo card.
Exemplos:
- Big_Brain_Time: +30% Class EXP, +X% HP em monstros
- Unending_Energy: +25% Class+Skill EXP, Max AFK = 10h (cap permanente)
- Zerg_Rushogen: +AFK gain, +respawn time em mobs
```

Trade-offs explicitos. Player escolhe ativar baseado em situacao.

#### 1.2.9 Breeding/Pets (genes + shiny)

`07_WORLD4_5_SUBSYSTEMS.md` linhas 107-143:

```
36 genes (Fighter, Forager, etc.) — define habilidade em combate
100+ pets coletaveis (cada mob tem versao pet)
13 upgrades de infraestrutura (Egg_Capacity etc.)
Shiny mobs: pets ganham nivel de shiny ao longo do tempo
```

Pet level + shiny level = idle dentro de idle. Pets sao **separados** do
combat principal (sao para "tour battles" auto-battler).

#### 1.2.10 Gem Shop (premium store)

`10_MONETIZATION.md` linhas 12-53:

5 sections (usables, inventory, oddities, etc.). Padroes:
- `maxPurchases: N` limita stockpile.
- `costIncrement` aumenta preco a cada compra (anti-spam).
- Daily restock em alguns itens — gera ritmo de login.

**Filosofia documentada (linha 49-52):** *"o gem shop tem muito time candy e
QoL, mas pouco buy power directly. E' time-skip economy, nao stat-boost
economy. Voce compra TEMPO, nao STATS."*

Tipos de item:
- **Usables**: Time Candy (1h, 24h, 48h, 72h boost), talent reset potions.
- **Inventory**: bag/storage expansions (permanente).
- **Oddities**: quest items raros, evento items, lanterns.
- **Bundles**: USD $5-20 com perks permanentes nao-replicaveis F2P (linha
  56-77).

#### 1.2.11 Outras moedas/economias siloed

`08_WORLD6_7_SUBSYSTEMS.md` linhas 351-352:

> "Cada subsistema com sua moeda (essences, dust, jade, opal, feathers,
> sushi-credits, ...) — economias siloed evitam exploits cross-system."

Lista: Flurbo (dungeons), Salts (refinery), Acorns/Sprouts (gaming),
Dream tokens (equinox), Skulls (killroy), Souls (worship), Pens
(post office). **Cada uma so funciona em UM sistema** — voce sempre tem
moeda; so nao da que precisa.

### 1.3 Incremental Epic Hero 2 (5 camadas de prestige)

IEH2 e' a referencia mais rica em meta-progressao porque tem **5 camadas
encadeadas** (Run -> Rebirth -> Ascension -> WA1 -> WA2 -> WA3).

#### 1.3.1 Rebirth (1a camada, ~110 upgrades, 8 tipos de pontos)

`ieh2_dump/docs/06-rebirth.md` linhas 16-26:

```csharp
public enum RebirthPointKind {
    HeroLevel, SkillLevel, EQLevel, Quest, Move,
    HeroGrade, ArtifactLevel, SkillTriggerNum
}
```

**8 tipos de Rebirth Point**, cada um vindo de comportamento diferente
(linha 28). Voce nao pode farmar tudo no mesmo loop.

Gating por Hero Level (linha 32-38):

```csharp
public static long[] tierHeroLevel = new long[7] {
    100, 200, 300, 500, 1000, 1500, 2000
};
```

Custos: 2 patterns universal (linear ou exponencial, linha 43-47).
Replicacao de tier T1=T2=T3=T4=T5 com a mesma estrutura (linha 71-79) —
economia de design.

Upgrade "broken" exemplo: `SkillDamage` cresce `2^level - 1`, max 10
(level 10 = 1023x dano), `initCost: 50k, baseCost: 1000, exp` (linha 95).

#### 1.3.2 Ascension / WA1 (2a camada, ~28 upgrades, ~18 milestones)

`07-ascension.md` linhas 16-31. Reseta **todos os rebirths**. Upgrades chaves:

- **PreRebirthTier{N}**: da pontos de Rebirth gratis no inicio de cada
  rebirth (linha 51-57). Primeiros 100 niveis sao GRATIS (custo = 1 ponto
  cada), depois custo `10^((level-100)/200)` (linha 56).
- **RebirthTier{N}BonusCap**: expande o cap dos upgrades de rebirth da tier
  N.
- **NitroSpeed/NitroCap**: relacionado ao sistema Nitro (acelerador de
  tempo, ver 1.3.6).

Citacao do design ensinamento (linha 95-96):
> "Pre-X bonuses: dar pontos de prestige na hora de fazer prestige e' um
> acelerador poderoso. Tira a dor do começar do zero de novo."

#### 1.3.3 WA1/WA2/WA3 (camadas 3-5, milestones cumulativos)

`08-world-ascension.md` linhas 6-19. Estrutura:

| Subsistema | Tipo |
|---|---|
| WAUpgrade | Compra com pontos |
| WAMilestone | Goals cumulativos que se autocompletam |

Milestone `WAM_HeroLvReached` (linha 26-32):

```
currentValue = TotalHeroLevel
GoalValue(1) = 6.000
GoalValue(2) = 9.000
...
GoalValue(10) = 18.000
PassiveEffectValue(level) = 10^level - 1
Aplicado em Stats.ExpGain  -> fator multiplicativo ate 10^10
```

Milestone `WAM_RebirthPointGainTier1` (linha 60-87):

```
L1: 2M       L2: 5M       L3: 20M       L4: 125M      L5: 750M
L6: 5B       L7: 50B      L8: 500B      L9: 5T        L10: 100T
L11: 50P     L20: 10^80   (cresce 10x-500x por level)

PassiveEffectValue:
  level <= 10: 0.1 * level * 2^((level-1)/9)
  level > 10:  dobra a cada level extra
```

`08-world-ascension.md` linha 121-127 (warning de design):
> "**Resista a fazer 5 camadas de prestige.** IEH2 chegou nisso apos anos.
> Comece com 1 (Rebirth). Adicione Ascension so quando perceber que
> jogadores zeraram Rebirth N vezes."

#### 1.3.4 Guild (meta-personagem, 26 abilities + 20 super)

`13-guild.md` linhas 11-32:

```csharp
GuildLevel, GuildExp, GuildGrade, GuildFame
GuildMember[6]      // 1 por HeroKind
GuildAbility[20]    // 20 abilities (escolhidas via point allocation)
List<GuildSuperAbility> superAbilityList
Multiplier activableNum    // base 3 = so 3 ativas simultaneamente
```

26 abilities (linha 35-50), 3 ativas simultaneas. Cada uma e' bonus
permanente que **soma** quando ativa: StoneGain, GoldGain, RB1..RB6
(boost de Rebirth Tier 1..6), MaterialDrop, etc.

20 Super Abilities (linha 56-65): versao mais forte e mais cara.

Guild Advisor (linha 84-97): ~50 marcos de progressao guiada — sistema de
tutorial nao-bloqueante. Apresenta novo conteudo "GuildLv5 = Shop, GuildLv10
= Swarm, GuildLv15+ = avancado". Funciona como **retencao de novato**.

#### 1.3.5 Pets (12 especies x 8 cores = ~96 variantes + 68 active effects)

`14-pets.md` linhas 13-26:

```csharp
public enum MonsterSpecies {
    Slime, MagicSlime, Spider, Bat, Fairy, Fox,
    DevilFish, Treant, FlameTiger, Unicorn,
    Mimic, ChallengeBoss
}
public enum MonsterColor {
    Normal, Blue, Yellow, Red, Green, Purple, Boss, Metal
}
```

3 eixos de XP por pet (linha 49-54):

| Eixo | Cresce com | Efeito |
|------|---|---|
| level | Combate / passive XP | Stats em batalha |
| loyalty | Tempo + uso | Mais drops, melhor cooperation |
| tamingPoint | Capturar mais do mesmo | Variantes raras desbloqueiam |

**maxPetSpawnNum = 10 slots por hero** (linha 67-72).

68 Active Effects (linha 75-95): auto-coleta de resource, material, equip,
queue de upgrade/alchemy, **auto-rebirth (Tier 1-6)**, auto-buy de shop
materials, captura automatica. Cada effect e' um job que substitui acao
manual.

Loyalty (linha 122-124):
> "Pet level alto sem loyalty = mid pet. Pet level medio + loyalty cheia =
> top pet. Cria reason pra usar o mesmo pet repetidamente."

#### 1.3.6 Consumables (85 potions + 10 alchemy upgrades + 8 blessings)

`15-consumables.md` estrutura central (linha 10-15):

```
Materials (drop de mob)
    v Alchemy recipe
Potion (consumivel)
    v equip slot + condicao
Trigger automatico em batalha (Blessing temporario ativado)
    v
Buff por X segundos (MultiplierKind.Blessing)
```

Auto-trigger das potions (linha 76-84):

```csharp
public enum PotionConsumeConditionKind {
    Nothing,        // manual
    HpHalf,         // quando HP <= 50%
    AreaComplete,   // ao zerar uma area
    Defeat,         // ao matar mob (cada N?)
    Move,           // ao mover X
    Capture         // ao capturar
}
```

**Padrao chave:** o jogador **configura quando** a potion dispara, nao
clica em hotkey. Idle puro.

3 currencies de Alchemy (linha 108-114):
- `AlchemyPoint` — manual, gasta nos upgrades
- `TalismanFragment` — sub-currency rara para forge Talisman
- `MysteriousWater` — gerado passivamente, com cap expandivel

8 Blessings (linha 137-145): Hp, Atk, MAtk, MoveSpeed, SkillProf, EquipProf,
GoldGain, ExpGain. **Apenas 8 (versao simples).**

#### 1.3.7 Nitro (banked time / acelerador)

`19-meta-and-qol.md` linhas 31-44:

```csharp
public class NitroController {
    Multiplier nitroCap;       // base 10.000 sec ~= 2.7 horas
    Nitro      nitro;           // currency (tempo banked)
    Multiplier maxNitroSpeed;
    NitroSpeed speed;
    bool       isActive;
    float      nitroTimescale = 2f;  // ativo: 2x mais rapido
}
```

Gasta 1s de Nitro pra cada 1s de gameplay extra. Cap base 10.000s, ampliavel.

Citacao da licao (linha 44-46):
> "Da ao jogador um boost button sem ser pay-to-win e sem acelerar tudo.
> Catch-up tool se ficou offline."

12 NitroReactors (linha 50-58) — categorias que geram pontos de Nitro
baseadas em stat cumulativa do save (kills, rebirths, etc.).

#### 1.3.8 Offline bonus (escolha pelo player)

`19-meta-and-qol.md` linhas 62-76:

```
2 opcoes:
1. Nitro: tempo offline vira Nitro acumulado pra usar depois
2. Playtime: simula direto e da rewards (XP, gold, materials)
gainFactor = 0.95   // 95% do simulado (anti-exploit, online ainda melhor)
```

#### 1.3.9 Auto-Rebirth (3 tiers de QoL)

`19-meta-and-qol.md` linha 84-90:
- **AutoRebirth 1**: rebirth quando atinge level X
- **AutoRebirth 2**: rebirth + presets de allocation
- **AutoRebirth 3**: rebirth + ascension automaticos

#### 1.3.10 EpicStore (premium shop)

`19-meta-and-qol.md` linhas 104-115:

```csharp
public enum EpicStoreCurrencyType {
    // EC (Epic Coin), Ruby, PortalOrb, ...
}
```

EC ganho via daily quests, achievements. Itens: slots de inventario,
currency de outros sistemas. **6 versoes** do array de IAPs (linha 165-171) —
jogo com anos de live ops.

#### 1.3.11 Save split

`19-meta-and-qol.md` linha 22-26:

```
Main.main.S    = Save geral (nao reseta com Rebirth)
Main.main.SR   = Save Rebirth-reset (zera a cada Rebirth)
```

"Esse split E' a estrutura de dados que define o que e' permanente vs do run."

---

## 2. Convergencias

### 2.1 Prestige com unica formula crescente sub-linear

CC usa `cbrt` (`pow(cookies/1e12, 1/3)`,
`07-prestige-ascension.md` linha 17). IEH2 usa fonte cumulativa de
tipos diferentes (HeroLevel/SkillLevel/Quest/Move...) com cresimento
sub-linear por tipo. IdleOn evita single-currency e usa
multiplas tokens. **Todos sub-lineares** — exponencial trivializaria.

Nosso plano em `ascension-multipliers.md` linha 24 usa `STAR_MULT_PER_STAR
= 0.5` (linear simples). Linha 41:
> "Por que linear, nao exponencial? Cada renascimento tem um custo crescente
> de tempo. Multiplicador linear contrabalanca; exponencial trivializaria."

**Convergencia confirmada:** crescimento linear-a-cubico por camada.

### 2.2 Mesma "moeda x N tipos" para diversificar comportamento

- CC: prestige level (1 tipo, mas com upgrades de **comportamento** diverso —
  perma-slots, angelica, demoniaca, lucky 7s).
- IO: **achievements + tasks + merits + bribes + vault** (5 sistemas paralelos).
- IEH2: **8 tipos de RebirthPoint** (`06-rebirth.md` linha 16-26).

**Convergencia:** nao usar so uma moeda de prestige. Tipos diferentes vem de
atividades diferentes. **Padrao critico** para evitar tedio "1 acao repete
pra sempre".

### 2.3 Auto-trigger de buffs (potions) com condicao

IEH2 tem `PotionConsumeConditionKind` (HpHalf, AreaComplete, Defeat, Move,
Capture, `15-consumables.md` linhas 76-84). IdleOn tem Food slots auto-eat
acionados por HP. CC nao tem analogue (golden cookies sao clique).

**Convergencia (idle puro):** potions/buffs disparam **automaticamente** por
contexto. Configurar uma vez, jogar em paz.

### 2.4 Eventos cronometrados com janela curta

CC: golden cookies 5-15min, lifetime 13s
(`06-golden-cookies-buffs-wrinklers.md` linha 33, 71).
IO: Weekly Bosses reset semanal (`09_META_PROGRESS.md` linha 167-185).
IEH2: Nitro como banked time (`19-meta-and-qol.md` linha 31-44), Daily quests
(linha 140-142).

**Convergencia:** ha **algum evento curto** em todos os jogos, mas o que
varia muito e' a janela:
- CC: 13s (clique reativo).
- IO: weekly (zero pressure de daily).
- IEH2: 24h daily quest + nitro como catch-up.

Para o Idle Medieval e' compativel com o que ja temos em `events-catalog.md`
(festivais 5-15min, invasoes 30-60min, sazonais mensais).

### 2.5 Premium store = time-skip + slots + cosmetics

CC nao monetiza (single-dev grátis). IdleOn e IEH2 alinham (`10_MONETIZATION.md`
linha 49-52, `19-meta-and-qol.md` linha 104-115):

| Item | CC | IO | IEH2 |
|---|---|---|---|
| Time-skip (candy/nitro) | n/a | sim | sim |
| Inventory bag expansion | n/a | sim | sim |
| Talent reset potion | n/a | sim | sim |
| Slot extras (pet/skill) | n/a | implicito | sim |
| Cosmeticos | n/a | sim | sim |
| Stat boost direto | n/a | nao (sigils sao gradual) | nao |

Filosofia documentada em ambos: **vende tempo, nao poder**. F2P viavel.

### 2.6 Save split (S vs SR ou equivalente)

IEH2 explicita (linha 22-26). CC implicito (campos como `cookiesReset`
e `cookies`, `07-prestige-ascension.md` linha 152-172). IdleOn: account-wide
vs char-specific stats.

**Convergencia:** **decidir no dia 1** o que e' "save da conta" vs "save do
run" / "save do personagem".

Para nos, ja temos `account-vs-character.md` no `01_design/` — verificar
alinhamento.

### 2.7 Cap de N efeitos ativos por sistema

CC Pantheon: 3 slots (Diamond/Ruby/Jade), 11 deuses
(`13-minigame-pantheon.md` linha 30-38).
IEH2 Guild: 3 abilities ativas de 26
(`13-guild.md` linha 31).
IdleOn Shrines: 1 shrine ativa por mapa
(`06_WORLD3_SUBSYSTEMS.md` linha 64-74).

**Convergencia:** sistemas com tabela de N opcoes mas K << N slots ativos.
Forca decisao tatica.

---

## 3. Divergencias / Decisoes pendentes

### 3.1 Quantas camadas de prestige

| Jogo | Camadas | Tempo medio |
|---|---|---|
| CC | 1 (Ascension) + Sugar Lumps como moeda secundaria | ~50-150h por run inicial |
| IO | 0 prestige tradicional, mas Vault + Upgrade trees | ~1000h pra unlock final |
| IEH2 | **5** (Rebirth -> Asc -> WA1 -> WA2 -> WA3) | anos |

Aviso IEH2 (`08-world-ascension.md` linha 122):
> "Resista a fazer 5 camadas. IEH2 chegou nisso apos anos."

Nosso plano em `ascension-multipliers.md` ja propoe **3 camadas**:
Renascimento (★0-★10) -> Transcendencia -> Ascensao Cosmica. **Numero
correto?**

[DECISAO PENDENTE: manter 3 camadas planejadas, ou colapsar pra 2
(Renascimento + Ascensao) seguindo a recomendacao IEH2?]

Argumentos para **3**:
- Estrelas (★0-★10) sao **dentro** da camada Renascimento (nao e' uma camada
  separada de fato — funciona como nivel da camada 1).
- Transcendencia tem trigger especifico (level 1000 + codex completo) que
  funciona naturalmente como gate de quem ja zerou.
- Ascensao Cosmica abre NG+ + nova moeda (Moedas Galacticas) — caracteriza
  fase de expansao pos-MVP.

Argumentos para **2** (consolidar):
- Conteudo de 3-5 anos. Cada camada precisa de upgrades + visual + UI
  proprios.
- Auto-rebirth precisa ser feito **3x** (1 por camada).

**Sugestao:** manter 3 camadas mas **so implementar Renascimento ★0-★10 +
Transcendencia no Release 1.0** (Fases 03-04). Ascensao Cosmica e
Constelacoes ficam para pos-launch (Fase 04 final / Fase 05). Adoçar com
texto in-game indicando que "outras camadas existirao" sem datar.

### 3.2 Sugar Lumps style: ter moeda de calendario real?

CC sugar lumps: ~20-24h por unidade
(`08-sugar-lumps.md` linha 36-41). IO/IEH2: nao tem analogue puro (IEH2 Nitro
e gerado por tempo de jogo, nao calendario absoluto).

**Vantagens** (CC):
- Forca **algum** retorno ao jogo a cada 24h.
- Cria ritmo previsivel ("amanha colho meu lump").
- Persistente entre ascensoes — sempre uma stat que cresce.

**Desvantagens:**
- Jogador que joga 3h por dia ganha igual ao jogador 12h (justo? injusto?).
- Numero pequeno gera frustracao de "1 unidade por dia".

Decisao mais limpa: ter **uma** moeda que se acumula em escala diaria, mas
**varios** usos (level building, refill minigame, comprar upgrades raros).
CC faz isso bem.

[DECISAO PENDENTE: introduzir "Cristal Eterno" como contraparte medieval do
sugar lump (1/24h real), gasto em building levels do Acampamento e refills
de cooldown de pets/buffs?] [PLACEHOLDER: arte do cristal]

**Sugestao:** sim, **mas adiar para Fase 04+** (junto com Reino). Adiciona
fundo natural para Loja Eterna sem inflacionar early game.

### 3.3 Pets: combate? buff? expedicao? quantos?

| Jogo | Total pets | Funcao primaria |
|---|---|---|
| CC | n/a (sem pets) | — |
| IO Companions | 167 | tour battles + buffs passivos + QoL |
| IO Breeding | 100+ | shiny levels + genes |
| IEH2 | 96 (12 species x 8 colors) | summons em batalha + auto-jobs + buffs |

Catalogo atual `pets-catalog.md`: **30 pets** (12 combat + 10 buff + 8
expedicao). Comparavel ao IEH2 medio. **Tamanho ok para R1.1.**

Pontos do IEH2 que ainda nao temos:
- 3 eixos de XP por pet (level/loyalty/tamingPoint).
- **Auto-jobs** acionados por pet (auto-gather, auto-rebirth quando tier
  alta).
- Pet Rank Milestone (cumulativo da bonus passivo).

Pontos do IO Breeding que ainda nao temos:
- Shiny pets que sobem level passivamente em background.

[DECISAO PENDENTE: adicionar conceito de "Loyalty" aos pets (segundo eixo de
XP) ou manter so level + tier do MVP atual?]

**Sugestao:**
- Loyalty: **adiar para Fase 04-05**. MVP usa so level.
- Auto-jobs (auto-gather/auto-craft via pet): **adiar para Fase 05** (encaixa
  no Bicho de Estimacao do Imperio).
- Shiny pets: **nao implementar inicialmente.** Conflita com nosso sistema
  shiny de inimigos/itens.

### 3.4 Sistema Card-like / Album / Statues

Cards-catalog.md ja existe (84 cards). Como cada referencia faz:

| Jogo | Mecanica analoga |
|---|---|
| CC | Heavenly Tree upgrades (84+ upgrades, `pool='prestige'`) |
| IO | Cards (~400) + Statues + Achievements (420) — 3 sistemas paralelos |
| IEH2 | Dictionary (codex) + Achievements + Pet Rank Milestone |

Nosso `cards-catalog.md` ja tem:
- 66 cards regulares + 12 corrupted + 6 greedy (84 cards).
- 14 set bonuses por categoria.
- 3 slots de 5 cards cada (15 endgame).

Comparacao:
- IO tem ~400 cards: mais cards mas card-mantissa cresce linear, exposicao
  fica diluida.
- IEH2 nao tem cards — usa milestones cumulativos.

**Sugestao:** manter cards como esta no catalogo. **Convergencia confirmada.**

### 3.5 Statues / Alavancas adicionais

Faltamos algo equivalente a:
- **IO Stamps** (~700 stamps): bonus por inimigo morto x N
  (`idleon-reference/01-09` references mencionam multiplas vezes).
- **IO Alchemy Bubbles** (140 bubbles + 84 vials = 254 alavancas
  permanentes).
- **IEH2 Rebirth Upgrades** (~110 upgrades).

Comparativamente, o nosso plano tem:
- Renascimento Chakra: ~7 upgrades exemplo (`ascension-multipliers.md` linha
  92-101) — **MUITO POUCO**.
- Constelacao: 5 constelacoes x 5-15 nos = 25-75 nos. Suficiente.
- Transcendencia Tree: numero ainda sem definir.

[DECISAO PENDENTE: expandir Chakra (loja de Renascimento) para ~50-100
upgrades, mais alinhado com referencias? Ou manter ~10 upgrades simples?]

**Sugestao:** expandir **gradualmente** — Fase 03 entrega ~20 upgrades, Fase
04 expande pra ~50, Fase 05 alcanca ~80+. Tier-based como IEH2
(`06-rebirth.md` linha 71-83) — T1=T2=T3=...=T5 com mesma estrutura.

### 3.6 Buff cronometrado curto (Golden Cookie) ou nao?

CC golden cookie 5-15min cada, 13s lifetime, clique para colher
(`06-golden-cookies-buffs-wrinklers.md` linha 33, 71). E' mecanica
**ativa** — pune AFK.

Nos planejamos **Festivais do Acampamento** com trigger a cada 1-2h reais,
duracao 5-15min (`events-catalog.md` linha 114-129). **Aplicacao automatica,
sem clique.** Mais idle-friendly.

**Convergencia:** ter buffs cronometrados curtos. **Divergencia:** se exigem
clique ou nao.

[DECISAO PENDENTE: Festivais aplicam buff automaticamente OU jogador precisa
clicar em um icone "colher" durante a janela curta?]

**Sugestao:** automatico, conforme catalogo atual. Idle-puro. Para quem quer
o clique, ofereçer "Caça ao Doce" como sub-evento (icone aparece, dura 30s,
clica pra +20% bonus em cima). Atende ambas as audiencias.

### 3.7 Wrinkler-style: investimento passivo com payout?

CC wrinklers comem 5% da CpS, devolvem 110% ao explodir
(`06-golden-cookies-buffs-wrinklers.md` linha 339-355). Strategy game dentro
do idle.

**Nada similar nas referencias IO/IEH2.** Mecanica unica do CC.

[DECISAO PENDENTE: ter um analogue medieval ao Wrinkler? "Coletores
Fantasma" que ficam em zona, consomem 5% do drop, e ao explodir devolvem
110% acumulado?]

**Sugestao:** **NAO** para Fase 03-04. Adiar para pos-launch ou nunca. Cria
overlap com nosso "Acelerador Cosmico"
(`ascension-multipliers.md` linha 250-292) que ja serve esse papel
(simulacao em massa de clears).

### 3.8 Guild: ter ou nao?

IEH2 tem (`13-guild.md`). IdleOn tem (`09_META_PROGRESS.md` linha 213-225).
CC nao tem.

Decisoes ja documentadas no projeto: o **acampamento e' a guild** — varios
personagens em paralelo. Mas:
- IEH2 Guild **e' single-player** — voce sozinho gerencia 6 herois. Guild =
  meta-personagem.
- IO Guild **e' multiplayer** — players reais compartilham task.

Nosso projeto e' single-player. O analogue medieval natural:
- Reino do Acampamento (Fase 04) = "guild" do IEH2.
- **Sem** multiplayer no horizonte. Guild social IO nao se aplica.

**Sugestao:** manter o nome **Reino** ou **Acampamento Estagio 4**, mas
reaproveitar a estrutura conceitual do GuildController:
- GuildLevel = Reino Level (`Acampamento` ja tem progressao por estagio).
- GuildAbility[20] -> "Decretos do Reino" (3 ativos de N decretos).
- GuildAdvisor[50] -> "Conselheiro do Reino" — tutorial nao-bloqueante por
  Reino Level.

[DECISAO PENDENTE: introduzir conceito de "Decreto do Reino" (3 ativos de
20+) na Fase 04, ou manter Reino com bonus passivo simples?]

**Sugestao:** sim, **mas estreitar pra 12 decretos / 2 ativos** no MVP.
Subir gradativamente.

### 3.9 Loja Eterna: que itens vender (minimum viable)?

Lista comparativa do que CC/IO/IEH2 vendem na premium store:

| Categoria | Item exemplo IO | Item exemplo IEH2 | Adotamos? |
|---|---|---|---|
| Time-skip | Time Candy 24h, 48h, 72h | Nitro Boost | sim |
| Inventory expansion | Bag/Storage upgrade | EquipmentInventory cap | sim |
| Talent reset | Reset Potion | Respec gratis 1x, depois 50 RP | sim |
| Cosmetic | Wallpapers, milks, hats | Pet color/skins | sim |
| Slot extras | (implicito em vault) | EQ Slot expansion | sim |
| Daily bonus | Daily login chest | Daily quest EC | sim |
| Bundle (USD) | $5-20 packs com perks | inAppPurchasedNum 6 versoes | sim |
| Sigils (P2W gradual) | gem-gated P2W upgrades | (n/a, ascensao serve) | nao |
| Random box | (loot box) | (n/a) | nao [DECISAO PENDENTE] |
| Stat boost direto | nao tem | nao tem | nao |

**Minimum Viable Loja Eterna (Release 1.0):**

1. **Pocao Cosmica** (time-skip) — 1h / 24h / 48h / 72h ofertas. Cada pocao
   da +X% gain de tudo durante a duracao. Espelha Time Candy do IO.
2. **Cestas de Inventario** — slot extras de inventario + de chest da
   guilda. Permanente.
3. **Pocao de Respec** (reset talent/Chakra) — 1x gratis por personagem,
   depois custo em Gemas.
4. **Slot extra de Pet de Buff** — capacidade de equipar +1 pet de buff
   permanente.
5. **Slot extra de Pet de Expedicao** — capacidade de mandar +1 pet em
   missao.
6. **Slot extra de Skill Ativa** — +1 skill ativa em combate (cap +2 da Loja
   Eterna).
7. **Skin tematica de classe** (cosmetico puro) — 6 classes x 4 skins iniciais
   = 24 skins. Posteriormente expandidos por evento.
8. **Cosmeticos de Acampamento** — bandeiras, decoracoes, NPCs personagem
   placa. Cosmetico puro.
9. **Daily Chest** — chest gratuito 1x/dia, melhora qualidade com Loja
   Eterna (de 1 gema/dia para 5 gemas/dia).
10. **Pacote de Boas Vindas** (USD bundle exemplo $4.99) — 500 gemas + 3
    pocoes cosmicas + 1 skin + 1 slot extra.
11. **Pacote Premium** (USD $19.99) — 2500 gemas + 1 cosmetic Acampamento
    + 1 pet exclusivo (combate, nao buff).

**Naao no MVP:** itens que viram pay-to-win direto (stat boost). Cards
duplicados, equipamentos lendarios, recursos crus de Drop. Nada que faca o
F2P sentir que **nao consegue chegar la**.

[DECISAO PENDENTE: aceitar lootbox-style com pacote "Caixa do Aventureiro"
contendo random pet (1 de 8 cosmeticos)? Legal em alguns paises, problematico
em outros.]

**Sugestao:** **nao** no MVP. Adicionar so pos-launch e somente caixas
**totalmente cosmeticas** (sem stat). Veja regulacoes (UK, Belgium, etc.).

### 3.10 Timer de craft/gather/expedicao: quanto eh "longo"?

Citacoes:

CC sugar lumps: 20-24h por unidade
(`08-sugar-lumps.md` linha 36-41). Eh **gating de calendario**.

IO Construction: cada level pode levar dias de producao idle
(`06_WORLD3_SUBSYSTEMS.md` linha 41-44).

IO Trapping (traps `06_WORLD3_SUBSYSTEMS.md` linha 149-154):
```
[type 0]: 20min->1, 1h->2, 8h->10, 20h->20
[type 2]: 3h->5, 60h->50, 120h->100, 120h->200
```

IEH2 Eclosao de ovos (catalogo atual `pets-catalog.md` linha 110-119):
```
Ovo de Slime: 4h
Ovo de Pedra: 8h
Ovo de Sombra: 12h
Ovo Solar: 24h
Ovo Cosmico: 48h
```

**Padrao convergente para timers idle:**

| Categoria | Timer recomendado | Justificativa |
|---|---|---|
| Gather rapido (madeira local, pesca) | 1-5 min | "fastpath para click" |
| Gather medio (mineracao, alquimia) | 15-60 min | "perfil 1 hora online" |
| Crafting basico | 5-30 min | "snack-size" |
| Crafting alto-tier (lendario) | 4-24h | "1 vez por dia" |
| Expedicao com pet | 4h / 8h / 24h | "snapshot diario" |
| Eclosao de ovo raro | 24h-48h | "ritmo CC sugar lump" |
| Recurso passivo (lump-like) | 20-24h por unidade | "force calendario" |
| Weekly content | 7 dias | "ritmo IO" |

**Sugestao:** o catalogo atual de pets (4h-48h) esta bem alinhado. Adicionar
**1 recurso passivo de 24h** (Cristal Eterno) na Fase 04+, garante login
diario sem ser opressivo.

---

## 4. Proposta para o Idle Medieval

### 4.1 Quantas camadas de meta-progressao (resposta direta)

**3 camadas, lancadas em ordem:**

| # | Nome | Fase de release | Trigger | Reset | Mantem |
|---|---|---|---|---|---|
| 1 | **Renascimento** (★0..★10) | Fase 03 (Release 1.0) | Level cap 100, 200, ..., 1000 | Personagem (level, inv, equip, codex de materials) | Album, pets, conquistas, Loja Eterna |
| 2 | **Transcendencia** | Fase 04 (Release 1.1) | Level 1000 em ★10 + codex Z1-Z6 100% | Todo personagem (exceto purchases eternas) | Codex base, pets, conquistas, Loja Eterna |
| 3 | **Ascensao Cosmica** | Fase 05 (Release 2.0+) | Pos-Transcendencia x N (a definir) | Tudo (gathering, equip) | Cards, bestiario, pets, conquistas, Loja Eterna, constelacoes |

Manter as 3 camadas planejadas em `ascension-multipliers.md`. Numeros ja
balanceados nesse arquivo permanecem (linhas 19-30 e 199-208).

Nao seguir 5-layer IEH2 — explicitamente desaconselhado pelo proprio dump
(`08-world-ascension.md` linha 121-122).

### 4.2 Quando o 1o rebirth e' disponivel

**Trigger primario:** level cap (100). Sem time gate.

**Esperado:** 4-8h de jogo ativo, 12-24h de jogo casual mixed
afk/ativo. Alinha com `time-to-progress.md` (existente).

**Adicionalmente:**
- NPC "O Transcendido" aparece no acampamento desde o inicio (Fase 03).
  Antes do level 100 ele explica o conceito sem destravar mecanica.
- Achievement "First Star" desbloqueia tutorial expandido + 1 ponto de
  Chakra gratis.

### 4.3 Numericas-chave (referenciam ascension-multipliers.md)

Renascimento (`ascension-multipliers.md` linhas 19-24, 60-83):

```gdscript
star_multiplier(stars) = 1.0 + 0.5 * clamp(stars, 0, 10)
rebirth_points_gained(level, star) = floor(level/10) * (1 + 1.0 * star)
```

Estas formulas **estao corretas e bem balanceadas**. Sem mudanca aqui.

Transcendencia (linhas 119-153):

```gdscript
transcendence_multiplier(t_level) = 2^t_level
TP_MAX_FIRST = 50  // cap na primeira transcendencia
```

**Recomendacao:** revisar cap em 50 quando jogador chegar ao final do MVP.
Em testes provavel ajustar para 75-100.

Ascensao Cosmica (linhas 199-208):

```gdscript
COSMIC_MULTIPLIERS = [1.0, 1.5, 2.0, 3.0, 5.0, 8.0, 12.0, 18.0, 26.0, 36.0]
```

Sequencia Fibonacci-like — manter. Acelerador Cosmico
(linhas 250-292) tambem manter como esta.

### 4.4 Sistema de pets: skipar ou implementar pra R1.1+?

**Manter pets para Release 1.0** (catalogo ja em
`pets-catalog.md` com 30 pets). Justificativas:
- E' diferencial do projeto (idle RPG medieval com pets).
- Esta proximo do tamanho IEH2 / IO Breeding.
- Slots (1/1/2 iniciais expandindo via Loja Eterna) ja definidos.

**Recortar para MVP (Release 1.0):**
- Pets de combate: 12 (catalogo).
- Pets de buff: 10 (catalogo).
- Pets de expedicao: 8 (catalogo).
- 1 eixo de XP (level cap 50). Sem loyalty.
- Sem auto-jobs (jobs como auto-gather sao via building/talent, nao pet).

**Recortar para R1.1+:**
- Loyalty (2o eixo, IEH2-style) — necessario quando o jogador esgota level
  50.
- Auto-jobs (pet faz auto-craft/auto-gather) — adicional pos-Transcendencia.
- Shiny pets — **nao implementar**. Conflita com shiny de inimigos.

### 4.5 Sistema de buffs cronometrados (analogo a golden cookies)

**Manter sistema atual de Festivais** em `events-catalog.md`. Auto-aplicado
sem clique, dura 5-15min, trigger 1-2h.

**Adicionar opcional 'evento clique'** para quem ama o feel do CC:

- **Forasteiro do Acampamento** (sub-evento): icone aparece random a cada
  ~30-90min. Dura 30s. Clica para receber buff curto:
  - 70% chance: +50% Gold por 5min.
  - 20% chance: +100% Drop por 3min.
  - 9% chance: +200% Crit por 2min.
  - 1% chance: "Sorte do Forasteiro" — proximos 30s rendem 1h de progresso.

Inspirado em CC golden cookie mas idle-friendly (perde se ignorar, mas nao
e' obrigatorio).

Analogue ao **chain cookie** de CC nao recomendado — interaccao muito ativa
que estraga o tom idle.

### 4.6 Quais items na Loja Eterna minimum-viable

(Ver §3.9 acima para lista detalhada de 11 itens.)

**Moeda primaria:** **Gemas da Eternidade** (in-game ja referenciada).
**Moeda secundaria:** Pontos Eternos (achievement / login). Ambas usam o
mesmo shop.

Estrutura final proposta:

```
Loja Eterna - 6 secoes:

1. CONSUMIVEIS
   - Pocao Cosmica 1h    | 20 gemas
   - Pocao Cosmica 24h   | 100 gemas (max 4/sem; restock semanal)
   - Pocao Cosmica 48h   | 250 gemas (max 2/sem)
   - Pocao Cosmica 72h   | 500 gemas (max 1/sem)
   - Caixa do Trade      | 200 gemas (1 material raro random)

2. EXPANSOES (permanente)
   - Slot Pet Buff +1    | 750 gemas (cap +2)
   - Slot Pet Expedicao +1 | 500 gemas (cap +2)
   - Slot Skill Ativa +1 | 1000 gemas (cap +2)
   - Slot Inventario +50 | 200 gemas
   - Slot Chest +50      | 300 gemas

3. RESETS
   - Pocao de Respec     | 100 gemas (1 gratis/personagem/mes)
   - Restauracao do Chakra | 250 gemas

4. COSMETICOS - CLASSES
   - Skin tematica       | 200-500 gemas cada
   - 4 skins iniciais x 6 classes = 24 itens

5. COSMETICOS - ACAMPAMENTO
   - Bandeira do Reino   | 50-200 gemas
   - Decoracao raro      | 500+ gemas
   - NPC personalizado   | 1000 gemas

6. PACOTES (USD)
   - Boas Vindas $4.99   | 500 gemas + 3 pocoes + 1 skin + 1 slot
   - Mensal $9.99        | 1200 gemas + daily chest 30 dias
   - Premium $19.99      | 2500 gemas + pet exclusivo
   - Anual $49.99        | 7500 gemas + pet + cosmetics
```

### 4.7 Outros sistemas a herdar (priorizados)

#### Alta prioridade (Fase 03-04):

1. **Save split S/SR (IEH2 style)**: implementar `account_state.gd` vs
   `character_state.gd` (`save-offline-spec.md` ja preve algo similar — vale
   referencia explicita).

2. **Auto-trigger de pocoes (IEH2 PotionConsumeCondition)**: criar enum
   `PotionConsumeConditionKind` em `scripts/data/potion_condition.gd`. Slots
   de pocao auto-equipam com condicao. **Critico para idle.**

3. **Save versionado (IEH2 inAppPurchasedNum_verXXXXXXXX)**: arrays
   versionados para migracao entre versoes.

4. **Offline bonus: escolha do player (IEH2)**: ao retornar, jogador escolhe
   entre **acumular tempo** (vira recurso) ou **simular direto** (recebe XP +
   gold + drops). Padrao IEH2 com `gainFactor = 0.95`.

#### Media prioridade (Fase 04):

5. **Nitro / Acelerador de tempo**: ja temos Acelerador Cosmico em
   `ascension-multipliers.md`. Estender com banked-time analogous quando
   chega na Transcendencia.

6. **Auto-Rebirth 3 tiers**: AutoRebirth 1/2/3 ao subir progresso.
   Tier 1: "rebirth quando level X". Tier 2: rebirth + auto-allocate
   presets. Tier 3: full automation (inclui Transcendencia se ativa).

7. **Cristal Eterno (Sugar Lump style)**: 1 cristal a cada 20-24h reais.
   Gastos em:
   - Subir nivel do Acampamento (cost N+1 cristais por level).
   - Refill de cooldown de skill ativa (1 cristal = reset cooldowns).
   - Comprar 1 upgrade da Loja Eterna marcado "Eterno" (cap 30/mes).

#### Baixa prioridade (Fase 05+):

8. **Guild Decretos** (sistema Reino, 12 decretos / 3 ativos).

9. **Auto-jobs via pet** (pet de combate auto-mata em zona enquanto offline,
   limitado pelo cap de Energia Cosmica).

10. **Pet Loyalty** (2o eixo de XP).

### 4.8 Estrutura geral resumida (visao panoramica)

```
+------------------------------------------------------------+
| ETERNAL (nunca reseta)                                     |
|  - Loja Eterna purchases                                    |
|  - Achievements & Codex                                     |
|  - Cards (album)                                            |
|  - Pets (level mantido)                                     |
|  - Cristal Eterno (Fase 04+, sugar-lump-like)               |
|  - Account-level Decretos (Fase 04+)                        |
+------------------------------------------------------------+
+------------------------------------------------------------+
| COSMIC RESET (Ascensao Cosmica, Fase 05)                    |
|  - Mantem: Eternal + Constelacoes                           |
|  - Reseta: tudo abaixo                                      |
+------------------------------------------------------------+
| TRANSCENDENCIA (Fase 04)                                    |
|  - Mantem: Codex base, conquistas, T-tree                   |
|  - Reseta: personagem e progresso de star                   |
+------------------------------------------------------------+
| RENASCIMENTO (Fase 03, ★0-★10)                              |
|  - Mantem: Chakra upgrades, awakening branch                |
|  - Reseta: nivel, equipamento, inventario do personagem     |
+------------------------------------------------------------+
| RUN ATIVO                                                   |
|  - Level 1-1000                                             |
|  - Combate, gathering, crafting, expedicao                  |
|  - Festival do Acampamento (5-15min, auto-buff)             |
|  - Forasteiro do Acampamento (30s clique opcional)          |
|  - Invasao tematica (30-60min)                              |
|  - Evento Sazonal (mes inteiro)                             |
|  - Eclosao de ovo (4-48h)                                   |
+------------------------------------------------------------+
```

---

## 5. Hooks com docs existentes

### 5.1 Atualizacoes propostas

**`02_math/ascension-multipliers.md`:**
- Linha 91-104 (Chakra exemplos): expandir lista de ~7 upgrades para ~20
  upgrades iniciais. Adicionar nota sobre crescimento gradual ate Fase 05.
- Adicionar secao **"4. Cristal Eterno"** com formula:
  ```
  CRISTAL_HOURS_PER_UNIT = 24
  CRISTAL_COST_BUILDING_LEVEL_N = N + 1
  ```
  (vir do CC sugar lump pattern, `08-sugar-lumps.md` linhas 36-41 e 149-160).
- Adicionar nota sobre escolha de offline bonus (Nitro vs Playtime).

**`01_design/pets-catalog.md`:**
- Linha 122-128 (Slots): confirmado. Sem mudanca.
- Adicionar secao **"9. Loyalty (Fase 04+)"** com placeholder.
- Adicionar secao **"10. Auto-jobs de pet (Fase 05)"** com placeholder.

**`01_design/cards-catalog.md`:**
- Sem mudanca de conteudo. Adicionar nota cross-ref com este sintese.

**`01_design/events-catalog.md`:**
- Adicionar sub-secao **"4.4 Forasteiro do Acampamento"** (sub-evento
  opcional clicavel, descrito em §4.5 deste doc).
- Manter Festivais como auto-buff.

**`04_phases/phase-04-late-game.md`:**
- Adicionar item F04.08 **"Cristal Eterno"** (sistema de moeda calendario,
  sugar-lump-like).
- Adicionar item F04.09 **"Decretos do Reino"** (Reino + Guild Abilities
  IEH2-style com 3 ativos de 12).
- Adicionar item F04.10 **"Auto-Rebirth Tier 1/2/3"** (QoL automation IEH2
  style).

**`04_phases/phase-05-end-game.md`:**
- Adicionar item F05.11 **"Loyalty de Pets"** (2o eixo XP de pet).
- Adicionar item F05.12 **"Auto-jobs de Pet"** (pet automatiza
  gather/craft/rebirth).

**`00_meta/pending-decisions.md`:**
- Adicionar 5 decisoes pendentes deste doc:
  - 3 camadas vs 2 (§3.1).
  - Cristal Eterno calendar-currency (§3.2 / §3.7).
  - Pet Loyalty + Auto-jobs (§3.3).
  - Chakra expandido (§3.5).
  - Lootbox-style cosmetic (§3.9).
  - Wrinkler analogue (§3.7).

**Novo arquivo (sugerido) `01_design/loja-eterna-catalog.md`:**
- Lista detalhada dos 11 itens MVP (§4.6).
- Estrutura de 6 secoes.
- Custos em gemas + pacotes USD.
- Pet exclusivo de pacote premium [PLACEHOLDER: nome + stats].

### 5.2 Sumario das decisoes pendentes (recapitulacao)

| # | Decisao | Recomendacao deste doc |
|---|---|---|
| 1 | Manter 3 camadas de prestige? | **Sim**, 3 lancadas em ordem (Fase 03/04/05). |
| 2 | Adicionar Cristal Eterno (sugar-lump style)? | **Sim, na Fase 04+.** |
| 3 | Pet Loyalty + auto-jobs no MVP? | **Nao no MVP, Fase 04-05.** |
| 4 | Expandir Chakra para 50+ upgrades? | **Sim, gradativo (Fase 03 ~20, Fase 04 ~50, Fase 05 ~80).** |
| 5 | Festivais auto-buff vs clique? | **Auto-buff + sub-evento clique opcional ("Forasteiro").** |
| 6 | Wrinkler analogue medieval? | **Nao** (Acelerador Cosmico ja cobre o caso). |
| 7 | Guild (Reino) com 12 decretos / 3 ativos? | **Sim, Fase 04.** |
| 8 | Loja Eterna com lootbox cosmetico? | **Nao no MVP. Avaliar pos-launch.** |

### 5.3 Cross-references

- `02_math/ascension-multipliers.md` linhas 19-30 (Renascimento), 119-153
  (Transcendencia), 199-208 (Cosmica) — formulas validadas.
- `01_design/pets-catalog.md` linhas 22-71 (pets) — alinhamento confirmado
  com IEH2/IO escala.
- `01_design/cards-catalog.md` linhas 67-198 (cards) — alinhamento
  confirmado com IO.
- `01_design/events-catalog.md` linhas 114-129 (Festivais) — alinhamento
  confirmado.
- `04_phases/phase-04-late-game.md` linhas 55-77 (Transcendencia), 102-127
  (Ascensao Cosmica) — manter como planejado, adicionar itens novos.
- `04_phases/phase-05-end-game.md` linhas 18-176 (Imperio + sistemas) —
  manter, expandir com pet loyalty/auto-jobs.
- `references/ieh2_dump/docs/06-rebirth.md` — referencia primaria de
  Rebirth com 8 RPK types.
- `references/ieh2_dump/docs/07-ascension.md` — referencia de Ascension
  layer 2.
- `references/ieh2_dump/docs/13-guild.md` — referencia para Reino +
  Decretos.
- `references/ieh2_dump/docs/14-pets.md` — referencia para Loyalty + 68
  active effects.
- `references/ieh2_dump/docs/15-consumables.md` — referencia para
  PotionConsumeCondition.
- `references/ieh2_dump/docs/19-meta-and-qol.md` — referencia para
  Save split, Nitro, Offline bonus, Auto-Rebirth, EpicStore.
- `references/cookie-clicker-dump/07-prestige-ascension.md` — referencia
  para curva cubic, perma-slots, heavenly tree.
- `references/cookie-clicker-dump/08-sugar-lumps.md` — referencia para
  Cristal Eterno.
- `references/cookie-clicker-dump/06-golden-cookies-buffs-wrinklers.md` —
  referencia para Forasteiro (golden cookie analog).
- `references/cookie-clicker-dump/13-minigame-pantheon.md` — referencia
  para 3-slot system com swap cooldown.
- `references/idleon-reference/04_ALCHEMY.md` — referencia para
  140 bubbles + 84 vials (escala de alavancas).
- `references/idleon-reference/06_WORLD3_SUBSYSTEMS.md` — referencia para
  Shrines, Prayers (buff + curse), Building unlocks.
- `references/idleon-reference/09_META_PROGRESS.md` — referencia para
  Companions, Weekly Bosses, Bribes, Vault.
- `references/idleon-reference/10_MONETIZATION.md` — referencia para
  Gem Shop, Bundles, sistema de moedas siloed.
