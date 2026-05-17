# Sintese: Zonas, Inimigos, Quests e NPCs

> Research output baseado em leitura de:
> - `references/idleon-reference/03_MAPS_MONSTERS.md`
> - `references/idleon-reference/05_COLLECTIBLES.md`
> - `references/ieh2_dump/docs/09-area-prestige.md`
> - `references/ieh2_dump/docs/10-super-dungeon.md`
> - `references/ieh2_dump/docs/11-challenges.md`
> - `references/ieh2_dump/docs/12-town-buildings.md`
> - `references/ieh2_dump/docs/16-titles.md`
> - `references/ieh2_dump/docs/17-combat.md`
> - `references/cookie-clicker-dump/05-achievements-milk.md`
> - `references/cookie-clicker-dump/09-dragon.md`
> - `references/cookie-clicker-dump/10-seasons.md`
> - `references/cookie-clicker-dump/15-misc-systems.md`
>
> Cross-ref docs locais:
> - `STATE-OF-THE-PROJECT.md` (estado atual: 2 zonas, 4 inimigos, bestiary tracking)
> - `01_design/enemies-catalog.md` (6 zonas planejadas, 11+2+1 mobs/zona)
> - `01_design/quests-catalog.md` (60 main + 20 side + 10 daily + 5 weekly)
> - `01_design/npcs-catalog.md` (25+ NPCs por estagios do Acampamento)
> - `01_design/cards-catalog.md` (1 card por inimigo, 3 abas)
> - `01_design/events-catalog.md` (4 sazonais + 3 invasoes + 3 festivais)
> - `00_meta/release-plan.md` (R1.0 prevista para 5 zonas, 12-18 meses)
>
> Profundidade alvo: 600-1200 linhas. Zero emojis. PT-BR. Conflitos sao
> marcados `[DECISAO PENDENTE: ...]`.

---

## 1. Como cada jogo faz

### 1.1 Cookie Clicker

Cookie Clicker NAO tem zonas, inimigos comuns, quests ou NPCs no sentido
classico de RPG. O jogo eh single-screen, single-scene. Mas tem 5 sistemas
adjacentes que sao relevantes para o nosso brief:

#### 1.1.1 Achievements como moeda de progressao (`05-achievements-milk.md`)

- **622 achievement entries** no codigo, divididos em 3 pools (`05-achievements-milk.md` linhas 53-59):
  - `normal` (default, ~599 entries) — contam para o Milk system.
  - `shadow` (19 entries) — secretos / cheats / easter eggs / RNG extremo, NAO contam.
  - `dungeon` (4 entries) — reservados pra feature nunca lancada.
- **Sistema Milk** (`05-achievements-milk.md` linhas 62-70):
  - `Game.milkProgress = AchievementsOwned / 25`
  - Cada 25 achievements normais = +1 nivel de Milk
  - Milk eh consumido por **15 upgrades Kitten** (Kitten helpers/workers/.../strategists), cada um adiciona um fator multiplicativo `(1 + milkProgress * X * milkMult)` ao multiplicador global de prédios.
  - **Implicacao de design** (linha 700): "Achievements em Cookie Clicker não são apenas troféus — são uma moeda passiva que escala o late-game. Cada novo achievement marginal contribui (~0.04 em milkProgress) e é multiplicado por 15 Kitten upgrades simultâneos."
- **Categorias de achievements** (`05-achievements-milk.md` secao 4):
  - Tiered building achievements (15 tiers x 20 prédios, threshold 1/50/100/.../700).
  - Production achievements (3 tiers, 10^12 a 10^39 cookies de cada prédio).
  - Bank achievements (50 tiers, 1 cookie a 1e73).
  - CpS achievements (44 tiers, 1 CpS a 1e52).
  - Click achievements (15 tiers, 1k a 1e31).
  - Golden cookie achievements (1, 7, 27, 77, 777, 7777, 27777 GCs clicados).
  - Ascension achievements (1e6 a 1e57 cookies baked durante uma run).
  - Building totals (100, 500, 1k, 2.5k, ..., ate "≥700 de cada").
  - Upgrade collection (20, 50, 100, ..., 700 upgrades comprados).
  - Wrinkler-related (1, 50, 200 wrinklers estourados).
  - Minigame achievements (Grimoire spells, Garden plants, Stock Market, Sugar Lumps).
  - Season-specific (Halloween, Christmas, Easter, Valentines).
  - Shadow (19 secretos).
- **Achievement texto** (linhas 12-21): cada achievement tem `name`, `dname` (display localizado), `desc`, `icon` [col,row], `pool`, `order`. Padrao **muito leve**: 7 campos basta.

#### 1.1.2 Sistema Dragon (Krumblor) — "pet de longo prazo" (`09-dragon.md`)

- **26 levels** de evolucao do dragao (`09-dragon.md` secao 2):
  - Levels 0-3 (ovo): pagos em cookies (1M, 2M, 4M, 8M).
  - Levels 4-23: cada level custa **100 unidades de um prédio especifico** (Cursor, Grandma, Farm, Mine, Factory, ..., You).
  - Level 24: 50 de TODOS os prédios.
  - Level 25: 200 de TODOS os prédios.
  - Level 26: achievement final `Here be dragon`.
- **22 auras** (`09-dragon.md` secao 3): 2 slots ativos (slot 2 destrava em level >= 27). Aura 18 "Reality Bending" da 10% de cada outra aura conhecida — sinergia meta.
- **Padrao**: progressao linear que consome saldo dos prédios. Cada level eh uma decisao de "estou disposto a vender 100 farms?".

#### 1.1.3 Seasons (eventos sazonais por data real) (`10-seasons.md`)

- **5 seasons** (`10-seasons.md` secao 2):
  - Halloween (out, dias 297-304)
  - Christmas (dez, dias 349-365)
  - Valentine's (fev, dias 41-46)
  - Easter (semana antes da Pascoa)
  - Business Day/Fools (1 de abril, dias 90-92)
- **Trigger**: automatico por `new Date()` ou manual via `Season switcher` (1111 heavenly chips, ativa 24h).
- **Conteudo**:
  - Halloween: 7 spooky cookies (drop de wrinklers estourados).
  - Christmas: 15 levels de Santa progression + 14 Santa drops + 7 reindeer cookies + spawn de reindeer shimmers.
  - Valentine's: 7 heart biscuits com preco fixo escalado.
  - Easter: 20 eggs (12 comuns + 8 raros), drop de GCs e wrinklers.
  - Business Day: visual + Stock Market sinergia tematica (sem drops dedicados).
- **Custo de troca** (linhas 12428-12445): `1bi + cps*60 * 1.5^seasonUses * godMult`. Trocar muitas seasons fica exponencialmente caro.
- **Persistencia**: prestige upgrades `Star*` (`Starsnow`, `Starlove`, `Starspawn`, `Startrade`, `Starterror`) custam 111.111 heavenly chips cada e dao +5-10% nos drops da season correspondente (`10-seasons.md` linhas 110, 189, 217, 228, 292).
- **55 itens season-locked** no total (`10-seasons.md` apendice).

#### 1.1.4 News Ticker (`15-misc-systems.md` secao 1)

- Barra de texto rolante na base da tela.
- Conteudo: lore progress (`log10(cookies/10)+1`) + frases por prédio que possui (Grandma, Farm, ..., You) + frases tematicas por season ativa.
- **Fortune cookies** (linhas 50-69): com 2-4% de chance por mensagem, exibe um fortune que da reward 1-shot por ascensao (golden cookie spawn, 1h de cps, ou unlock de fortune upgrade).
- **Insight de design**: o ticker eh um vetor mecanico, nao so flavor. "Sleep-friendly" mas com paypoff em atencao ativa.

#### 1.1.5 Notifications (`15-misc-systems.md` secao 2)

- `Game.Note(title, desc, pic, quick)` — toast com cap de 50, exibicao de ate 5 simultaneos.
- Triggers: achievement won, upgrade bought, sugar lump harvested, season started, pledge ran out, wrinkler popped, etc.
- Botao "close all" aparece com >=2 notes.

#### 1.1.6 Bakery name + heralds (`15-misc-systems.md` secoes 3-4)

- Bakery name: 28 chars max, easter eggs (nomear "orteil" => -1% cps).
- Heralds: numero global de jogadores Steam ativos (cap 100). Cada herald = +1% CpS para todos (via heavenly upgrade `Heralds`).

### 1.2 Legends of IdleOn

#### 1.2.1 Estrutura mundial (`03_MAPS_MONSTERS.md` secao 1)

- **327 mapas** organizados por mundo (W1-W7).
- **403 entries em `monsters`** (DB completo: mobs comuns + bosses + summoned + decoration).
- **119 entries em `mapEnemies`** — apenas mobs grindaveis (que sao alvo AFK).
- **99 entries em `deathNote`** — subset rastreavel pelo "killbook" do W3.
- **Estrutura hierarquica**:
  - Mundo (W1, W2, ...) -> N mapas por mundo.
  - Cada mapa tem 1 mob principal definido em `mapEnemiesArray[mapIdx]`.
  - Mapas conectados por `mapPortals` (adjacency list, alguns mapas tem multiplos portais).
- **Padroes** (`03_MAPS_MONSTERS.md` secao 8):
  - Separa nome interno (`rawMapNames`) do display name (`mapNames`) desde dia 1 — facilita localizacao.
  - "Múltiplos níveis de monstro" (full DB vs grindáveis vs killbook) — separa intencionalmente.
  - `SpecialType: 'BOSS' | 'MINIBOSS' | '_'` no mesmo schema do mob normal.
  - Map "tier" implicito no nome (`GrasslandsA`, `GrasslandsB`, ...).

#### 1.2.2 Schema do inimigo (`03_MAPS_MONSTERS.md` secao 2)

Campos por monstro (exemplo `mushG` linhas 29-58):
- `Name`, `Type` ("Monster"), `SpecialType` ("_" ou "BOSS"/"MINIBOSS").
- `MonsterHPTotal`, `Defence`, `Damages: [min, max]`, `MoveSPEED`, `RespawnTime`.
- `ExpGiven` + `ExpType` (qual skill leva o XP — 0=combat, outros valores para skills especiais).
- `AFKtype` — id da branch do `getAfkGain` (acopla data com behavior).
- Sprite/animation embedded no monster data (sem "monster definitions" separada).
- `worldIndex` duplicado no monster + no mapa (redundancia controlada para queries diretas).

#### 1.2.3 Cards (`05_COLLECTIBLES.md` secao 1)

- **271 cards** (1 por mob grindavel + extras).
- Schema (linha 12-22): `rawName`, `displayName`, `cardIndex` ("A0"), `effect` ("+{_Base_HP"), `bonus` (12), `perTier` (5), `category` ("Blunder_Hills").
- **Tier system** (linhas 26-30): Drops sobem tier 1-5. Bonus = `bonus + perTier * (tier-1)`. Mitiga frustracao de duplicatas.
- **Equipped vs passive** (linhas 37-42): 8 slots ativos por personagem com bonus normal; cards descobertos (account-wide) dao versao "Passive" com bonus reduzido.
- **13 card sets** (linhas 44-62): cada categoria = uma regiao. Equipar 8 cards do mesmo set = bonus de set unico.
- **101 cardBonuses indexados por numero** (linha 64-77): permite consulta polimorfica.

#### 1.2.4 Stamps, Statues, Star Signs (`05_COLLECTIBLES.md` secoes 2-4)

- **~150 stamps** em 3 categorias (Combat/Skills/Misc). Custos exponenciais. Material muda a cada N levels (anti-stockpile).
- **32 statues** com formula `level^1.17 * 1.35^(level/10)` acima de level 300. Onyx statues aplicam pra todos os personagens.
- **94 star signs** em 3 arvores. Constellations (49) sao **mini-quests nao-lineares**: "chegue no mapa X com Y personagens de classe Z". Recompensa: star points -> ativar signs.

#### 1.2.5 Padrao das 4 progressoes (`05_COLLECTIBLES.md` secao 5)

| Sistema | Como obtem | Levels | Slot ativo | Pool |
|---|---|---|---|---|
| Cards | Drop de mob | tier 1-5 | 8/char | 271 |
| Stamps | 1x compra + upgrade infinito | inf | sempre ativo | ~150 |
| Statues | Drop de mob (pickup) | inf | sempre ativo | 32 |
| Star Signs | Constellation quests | unlocked/not | 2 | 94 |

"Cada um aciona um circuito psicológico diferente. Quem ama drops curte cards. Quem ama planning curte stamps. Quem ama colecionar curte statues. Quem ama exploração curte star signs."

### 1.3 Incremental Epic Hero 2

#### 1.3.1 Area Prestige (`09-area-prestige.md`)

- **Reset local por area** — diferente de Rebirth (reseta tudo) ou Ascension (reseta Rebirths).
- 10 upgrades por area (linhas 9-22):
  - `MaxAreaLevelUp` (sobe cap de level da area)
  - `UnlockMission` (habilita quest especifica da area)
  - `ClearCount` (ganha algo por # de clears)
  - `DecreaseMaxWave` (diminui # de waves pra completar)
  - `ExpBonus`, `MoveSpeedBonus`, `TreasureChest`, `LimitTime`, `MetalSlime`, `PortalOrb`.
- Caps (linhas 27-31): areas normais ate level 19, dungeons ate level 9.
- Custos dual-exponencial: `2^level` ate level 8, `256 * 3^(level-8)` apos. Muro intencional pra forcar diversificacao.
- **`monsterColorRate[5][8]`** (linhas 70-79): conforme area sobe em prestige, cores de mobs viram tiers maiores -> drops melhores. **Mesmo mob, cores diferentes, raridades diferentes**.

#### 1.3.2 Super Dungeon (rogue-lite encaixado) (`10-super-dungeon.md`)

- Mini-game dentro do idle. Entra com heroi, tempo limitado, recebe drafts de powerups.
- 4 sub-sistemas:
  - **21 SDPowerups** (drafts in-run): Heal, TimeLimit, DamageMultiplier, DodgeHeal, EquipmentDropChance, etc.
  - **26 SDModifiers** (afixos opt-in): SwapATKWithDEF, DrainHPPerSec, MonsterExplode, etc. Risk/reward style PoE map mods.
  - **17 SDGems** com max level 100-1000, formula poly+exp para XP requirement.
  - **SDShop/SDUpgrade** com 4 tabs (Currency, Heroes, Special, Permanent).
- 8 origens de multiplier diferentes so para SD.
- Insight (linha 162): "Não comece com SD. Adicione depois que jogo base funciona. É enorme."

#### 1.3.3 Challenges (`11-challenges.md`)

- **265 arquivos** comecam com `Challenge` — sistema mais massivo do jogo em # de classes.
- 5 tipos: RaidBossBattle, SingleBossBattle, HandicappedBattle, SuperDungeon, UltimateTrial.
- **17 Handicaps** (linhas 35-50): OnlyWeapon, NoEQ, OnlyClassSkill, NoSkill, DamageLimit, DisableManualMove, etc.
- **175+ desafios nominados** com padrao: `Raid{Boss}{Level}`, `Solo{Boss}{Level}`, `HC{Boss}{Level}`.
- Boss tem HP fixo (nao escala) — vence quem deal damage suficiente, nao quem fica online mais tempo.
- Recompensa: bonus permanentes via `MultiplierKind.Challenge` (sem currency).

#### 1.3.4 Town Buildings (`12-town-buildings.md`)

- **12 prédios** (linhas 8-22):
  - StatueOfHeroes (stats base)
  - Cartographer (descobre/desbloqueia areas)
  - AlchemistsHut (potions)
  - Blacksmith (crafting)
  - Temple (blessings)
  - Trapper (captura pets)
  - SlimeBank (gold cap)
  - MysticArena (arenas PvE)
  - ArcaneResearcher (skill prof)
  - Tavern (hire heroes, quests)
  - Dojo (training)
  - AdventuringParty (party management)
- **3 eixos de progressao por prédio**: Rank (0-5, saltos com pre-requisitos), Level (0-inf), Research (3 arvores paralelas).
- Pre-requisitos nao-monetarios: "Mate 1500 mobs unicos antes de subir rank 4".
- Unlock por Guild Level: 1, 5, 10, 15, 25, ...
- Pet automatiza research (cross-system).

#### 1.3.5 Titles (`16-titles.md`)

- **27 titulos** hardcoded em `Parameter.TitleEffectValue()`.
- Marcos permanentes obtidos por condicao (kill X, capturar todos os Slimes, completar tier de quest).
- Aplicam `MultiplierKind.Title`. Persistem pos-Rebirth/Ascension.
- 6 padroes de formula (linhas 71-115):
  - Linear simples (`level`)
  - Linear em % (`X * level`)
  - Polinomial (`level^1.5`)
  - Exponencial capped (`min(level, 0.1 * 2^level)` — duas fases)
  - Tabela manual (`cooperationEfficiency = [0, 0.2, 0.4, 0.6, 0.8, 0.9, 0.95]`)
  - Exponencial puro (`MonsterDistinguisher` `min(1,level) * 10 * 2^level`)

#### 1.3.6 Combat e variants de mob (`17-combat.md`)

- **12 monster species** (linhas 113-117): Slime, MagicSlime, Spider, Bat, Fairy, Fox, DevilFish, Treant, FlameTiger, Unicorn, Mimic, ChallengeBoss.
- **8 monster colors** (linhas 119-122): Normal, Blue, Yellow, Red, Green, Purple, Boss, Metal.
- 12 x 8 = 96 variants nominais.
- Cada cor implica drops diferentes, stats diferentes, mecanica especial (Metal = high XP + alta evasao, Boss = HP fixo).
- **Pool fixo** de monstros (max 30 spawnados), spawn ciclico. Nao instantiate dinamica.
- Movement patterns: apenas 2 (Shortest, Kiting).

---

## 2. Convergencias

Onde os 3 jogos alinham (mescla recomendada sem decisao):

### 2.1 Bestiary tracking como sistema de progressao, nao so coleta

Todos os 3 jogos usam "kill count por inimigo" como gatilho de bonus permanente:

- **Cookie Clicker**: 1, 7, 27, 77, 777, 7777, 27777 golden cookies clicados = achievements.
- **IdleOn**: deathNote (W3 unlock) — 99 mobs rastreados. Cada tier de kill = bonus passivo "% damage vs this mob".
- **IEH2**: `Title.MonsterDistinguisher` e similares — `main = min(1, level) * 10 * 2^level`.

**Mescla**: nosso `Bestiary` autoload ja registra kills por enemy_id. Falta:
- Marcos por kill count com bonus permanente (`enemies-catalog.md` secao 8 ja define: 10/100/1k/10k/100k/1M para comuns; 1/5/25/100/500 pra elites; 1/3/10/25/50 pra bosses).
- UI no `bestiary_modal` mostrando o proximo marco e o bonus pendente.

### 2.2 Inimigos como entries de DB compartilhada (boss = mob com flag)

Convergencia forte:
- IdleOn: `SpecialType: "_" | "BOSS" | "MINIBOSS"` no mesmo schema do mob comum.
- IEH2: `MonsterColor.Boss` eh uma cor (variant), `BATTLE` eh classe base para Hero/Ally/Pet/Monster.

**Mescla**: nosso `EnemyData` ja eh `Resource`. Adicionar campo `enemy_class: enum { COMMON, ELITE, BOSS }`. Logic de "boss tem HP fixo, nao escala automaticamente" pode ser flag.

### 2.3 Categorias visuais (cor/tier) reutilizam o mesmo sprite

- IdleOn: cada mob tem `MonsterFace`, `sprite`. Variantes via spritesheet.
- IEH2: 8 cores x 12 species = 96 variantes. `monsterColorRate` define drop tier.

**Mescla**: nosso projeto ja tem 4 slimes verde/azul/roxo/vermelho — exatamente o padrao IEH2 (Slime + 4 cores). Validacao do approach. Continue assim quando expandir.

### 2.4 Drops dinamicos (drop_chance_base * multiplier), nao fixos

- Cookie Clicker: `dropRate = base * multipliers (Lucky day, Mind over matter, etc.)`.
- IdleOn: drop tables com chances baixas (0.002 pro mushG card), mas `Drop Rate` stat global empurra tudo.
- IEH2: `dropChanceBase = 0.01`, multiplicado por Pet passives, equipment, etc.

**Mescla**: nosso `LootRoller` ja aplica gain modifiers de `CombatStats`. Continuar.

### 2.5 NPCs nao precisam ser muitos por zona

Nenhum dos 3 jogos tem muitos NPCs por mundo/zona:
- Cookie Clicker: zero NPCs no sentido classico (so dragao Krumblor e Santa progression).
- IdleOn: tipicamente 2-4 NPCs por mundo (giver de questline, shopkeeper, lore).
- IEH2: NPCs aparecem como buildings (Tavern, Cartographer, Temple) — sem identidade individual visivel.

**Mescla**: nosso `npcs-catalog.md` ja propoe 3-5 NPCs por estagio do Acampamento + 1 NPC itinerante por zona. Esta no ponto saudavel.

### 2.6 Achievements/titulos como meta-progression imutavel

Os 3 jogos tem um sistema de "marcos permanentes que nao resetam":
- Cookie Clicker: achievements (~599 normal) -> Milk multiplier.
- IdleOn: cards (271) -> stats permanentes + sets bonus.
- IEH2: titles (27) -> MultiplierKind.Title aplicado em stats.

**Mescla**: nosso `cards-catalog.md` ja cobre o eixo "card por inimigo". Falta um sistema explicito de "titles/achievements" como meta-progression separada. **Proposta na secao 4 abaixo**.

### 2.7 Quest grindavel + lore separadas

- IdleOn: cada NPC dá ~3-5 quests, mistura "mate X" + "entregue Y" + uma de lore.
- IEH2: missions sao por area (`APU_UnlockMission`).
- Cookie Clicker: nao tem quests, mas fortune cookies cumprem papel similar de "objetivo lateral inesperado".

**Mescla**: nosso `quests-catalog.md` ja segue esse padrao (60 main + 20 side + 10 daily + 5 weekly). Continuar.

### 2.8 Eventos sazonais sao opcionais, nao centrais

- Cookie Clicker: 5 seasons, opcional via heavenly upgrade (1111 chips).
- IdleOn: tem eventos sazonais leves (Halloween costumes nos mobs).
- IEH2: nao tem mecanica sazonal por data real.

**Mescla**: nosso `events-catalog.md` ja propoe 4 sazonais + 3 invasoes + 3 festivais. Convergencia: faz sentido ter, mas POS-1.0 conforme `release-plan.md`.

---

## 3. Divergencias / Decisoes pendentes

### 3.1 Numero de zonas para 1.0

| Jogo | Zonas/Mundos | Mapas por mundo | Total mapas |
|---|---|---|---|
| Cookie Clicker | 1 (single-screen) | N/A | N/A |
| IdleOn (`03_MAPS_MONSTERS.md` linha 9) | 7 (W1-W7) | ~47 medio | 327 |
| IEH2 (`17-combat.md` linha 145) | 10 area tiers | varia | (sem # explicito) |

**Nosso plano** (`release-plan.md` secao "Release 1.0"): 5 zonas para R1.0, expandindo a 6 em patches 1.x.

`enemies-catalog.md` ja detalha 6 zonas com 11 comuns + 2 elites + 1 boss cada.

[DECISAO PENDENTE: A R1.0 mira 5 ou 6 zonas? release-plan.md diz "5 zonas" mas enemies-catalog tem 6. Recomendo manter 6 no catalogo e marcar Zona 6 (Templo Celestial) como "stretch goal R1.1" no release-plan.]

### 3.2 Estrutura interna da zona

Como cada jogo segmenta uma zona:

- **IdleOn**: zona = mundo. Cada mundo tem N **mapas** (estaticos). Player escolhe qual farmar.
- **IEH2**: zona = area. Cada area tem N **waves** linearmente. Player avanca em ordem.
- **Cookie Clicker**: N/A.

**Nosso modelo atual** (state-of-project.md secao 4): zona -> N areas -> N stages -> N waves. Profundidade 3.

[DECISAO PENDENTE: 3 niveis (zone/area/stage) eh demasiado pra jogador novato? IEH2 funciona com 2 (area/wave). IdleOn com 2 (world/map). Recomendo simplificar pra "zone -> stage com waves" para R1.0 — ou seja, abolir `area` como conceito visivel e tratar como simples agrupador. Implementacao atual ja eh agnostica via `StageRoster`.]

Numeros sugeridos para R1.0 (escolha):
- **Opcao A (rasa, IdleOn-style)**: 6 zonas x 6 stages/zona = 36 stages totais. Cada stage = 5-8 waves.
- **Opcao B (profunda, IEH2-style)**: 6 zonas x 4 areas x 4 stages = 96 stages. Cada stage = 3-5 waves.
- **Opcao C (atual, hibrida)**: 6 zonas x N areas (varia 2-5) x 4-8 stages cada. Sem padrao fixo.

[DECISAO PENDENTE: A/B/C? Recomendacao: **Opcao A** para R1.0 (mais simples, mais legivel no mapa, alinhado com IdleOn). Migrar pra B se precisar de mais conteudo em 2.0.]

### 3.3 Inimigos: variantes de cor

Tres modelos coexistem:

- **IEH2** (`17-combat.md` linhas 113-122): 12 species x 8 colors = 96 nominais. Mesmo sprite, palette swap. Cada cor = tier de drop.
- **IdleOn** (`03_MAPS_MONSTERS.md` secao 2): cada cor eh um inimigo separado no DB (`mushG`, `mushR`, `mushW`, ...).
- **Cookie Clicker**: N/A.

**Nosso projeto**: 4 slimes (verde, azul, roxo, vermelho) — implementados como 4 EnemyData separados, ja seguindo o padrao IdleOn.

[DECISAO PENDENTE: manter 4 EnemyData separados por cor, OU consolidar em 1 `slime.tres` com campo `color_variants: Array[ColorData]`? Recomendacao: **manter 4 separados** (KISS, ja funciona). Refactor pra variants so se a quantidade explodir (>10 cores na mesma especie).]

### 3.4 Profundidade do questing

| Jogo | Quests principais | Quests laterais | Dailies/Weeklies |
|---|---|---|---|
| Cookie Clicker | nao tem | Fortune cookies (~30 entries) | nao tem |
| IdleOn (referencia geral) | ~10 questlines por mundo | varias | nao tem (a fonte nao fala) |
| IEH2 (`09-area-prestige.md` linha 14) | `UnlockMission` por area | sim | nao tem documentado |

**Nosso plano**: `quests-catalog.md` ja tem 60 main + 20 side + 10 daily + 5 weekly.

[DECISAO PENDENTE: 60 main quests pra R1.0 eh muito. Cada main quest precisa de:
- Texto de dialogo (giver)
- Objetivo claro
- Recompensa configurada
- Trigger no codigo

Cronograma realista para R1.0: 6 zonas x 5 main quests = **30 main quests para R1.0** (nao 60). Migrar as outras 30 para R1.1-1.3.

Para side quests: 10 templates reaproveitaveis pra R1.0 (nao 20).

Dailies: 5 templates rotativos (nao 10). Weeklies: 3 (nao 5).]

### 3.5 Sistema de achievements/titles separado dos cards

Convergencia diz "ter um sistema permanente", mas qual?

- Cookie Clicker: 599 normal achievements, todos visiveis numa lista enorme.
- IdleOn: 271 cards (drop-based) + 32 statues + ~150 stamps — 4 sistemas paralelos.
- IEH2: 27 titles (4 padroes de formula).

**Nosso projeto**: ja tem **cards** (cards-catalog.md) e **bestiary** (kill counts). Falta um sistema explicito de **achievements/titulos** independente.

[DECISAO PENDENTE: precisamos de "Titulos" alem de cards? Recomendacao: **sim**, mas escopo pequeno (~20 titulos para R1.0).

Proposta:
- Titulos sao **trofeus** ganhos por marcos: "Matou 1000 inimigos", "Completou Floresta", "Equipou item Legendary", "Alcancou level 50".
- Aplicam bonus pequeno permanente (~1-3% em stats). Soma com cards/bestiary.
- UI no `character_modal` -> nova aba "Titulos" ou no `bestiary_modal` -> nova aba.

Detalhamento de bonus em `02_math/character-stats.md` (criar entrada nova).]

### 3.6 Achievements visiveis na UI (Steam achievements)

`release-plan.md` (Release 1.0) menciona "Steam achievements implementados (>=20 achievements core)". Esses sao:
- **Diferentes** dos "Titulos" propostos acima — sao integration com Steam API, sem bonus mecanico.
- Subset do que vai pra Codex/Bestiary/Cards.

[DECISAO PENDENTE: lista exata dos 20+ Steam achievements pra R1.0. Sugestao em secao 4 abaixo.]

### 3.7 Como NPCs interagem com zonas

- IdleOn: NPCs ficam em **towns** dentro do mundo. Cada mundo tem 1 town com 3-5 NPCs.
- IEH2: NPCs sao **buildings na Town central** (12 prédios documentados em `12-town-buildings.md`). Sem NPC humano por zona.
- Cookie Clicker: zero NPCs.

**Nosso projeto**: `npcs-catalog.md` propoe NPCs centrais no Acampamento (que evolui em estagios: Acampamento -> Vilarejo -> Cidade -> Reino -> Imperio). NPCs itinerantes aparecem nas zonas.

[DECISAO PENDENTE: NPCs itinerantes (Caravaneiro Ferido, Sigrid Anã Perdida, Astrid Caçadora) aparecem na zona ou no Acampamento? Recomendacao: **na zona, em area especifica**. Quando o player vai pra primeira vez aquela area, NPC aparece como overlay clickavel. Quest fica registrada no questlog mesmo apos sair da area.]

### 3.8 Eventos sazonais: cosmeticos ou tambem mecanicos?

- Cookie Clicker: cosmeticos (cookies que dao +2% production, sao perm-unlock).
- IdleOn: leves (costumes nos mobs, sem efeito mecanico forte).
- IEH2: nao tem sazonais.

**Nosso `events-catalog.md`**: propoe seasonals com drops mecanicos (Pé de Coelho Premium +1 LUK/nivel, Bola de Sino x10).

[DECISAO PENDENTE: drops sazonais sao **permanente uma vez ganhos** (Cookie Clicker-style, +X% permanente apos compra) ou **expiram fim da temporada**? Recomendacao: **permanente uma vez ganhos**. Senao perde o sentido de "voltar todo ano".]

### 3.9 Quando implementar Area Prestige

IEH2 tem `AreaPrestige` (reset local). Cookie Clicker e IdleOn nao tem equivalente.

[DECISAO PENDENTE: Area Prestige eh feature pra qual release? Nosso roadmap nao menciona. Recomendacao: **post-2.0**. Eh sistema secundario, low priority.]

### 3.10 Super Dungeon / Challenges

IEH2 tem ambos, sao **enormes** (`10-super-dungeon.md` linha 162: "Não comece com SD. Adicione depois que jogo base funciona.").

[DECISAO PENDENTE: SD/Challenges entram em qual release? Recomendacao: **3.0+** (junto com seasons recorrentes).]

---

## 4. Proposta para o Idle Medieval

Baseada em convergencias + decisoes recomendadas acima.

### 4.1 Zone structure (escolha A da secao 3.2)

**R1.0**: 6 zonas, cada zona = 6 stages, cada stage = 5-8 waves. Total: 36 stages.

| # | Zona | Status atual | Stages alvo R1.0 |
|---|---|---|---|
| 1 | Floresta | implementada (4 areas, ~10 stages) | 6 stages (consolidar de 4 areas atuais) |
| 2 | Deserto | placeholder | 6 stages |
| 3 | Caverna | docs apenas (enemies-catalog.md secao 4) | 6 stages |
| 4 | Pantano | docs apenas | 6 stages |
| 5 | Tundra | docs apenas | 6 stages |
| 6 | Templo Celestial | docs apenas | 6 stages (stretch goal R1.1 se cronograma apertar) |

**Implementacao**: `StageRoster` ja gera stages on-demand. So precisa popular `ZoneData.areas[].stages[]` ou simplificar zone -> stages direto.

[DECISAO PENDENTE: abolir `area` como nivel intermediario, ou manter? Recomendacao: **abolir visivelmente**, manter internamente como agrupador opcional. `MapModal` mostra so "Zona -> Stage 1/2/3/.../6".]

### 4.2 Enemy design

#### 4.2.1 Categorias

3 niveis (alinhado com `enemies-catalog.md`):

| Categoria | HP relativo | ATK relativo | Quantidade por zona | Mecanica |
|---|---|---|---|---|
| Comum | 1x baseline | 1x | 8-11 | sprite + 1-2 skills |
| Elite | 4-6x | 1.5-2x | 2 | 2-3 skills + telegraph + appearance especial |
| Boss | 20-40x | 3-4x | 1 | 4-5 skills + multi-phase opcional + drop garantido |

Cross-ref `enemies-catalog.md` secoes 2-7 (ja tem stats balanceados).

#### 4.2.2 Mecanicas por inimigo (alem de stats)

Inimigos ja tem skills com cooldown (`enemies-catalog.md`). Padroes recorrentes:

- **Telegraph**: skill com warning visual antes do hit. Ja existe `dev_spawn_wave_requested` no controller — adicionar `enemy.tween_telegraph(seconds)` antes de aplicar skill com cooldown >=8s.
- **Regen**: skill de auto-heal (boss da Floresta: "Cura da Floresta cd 30s, +20% HP"). Implementar via `EnemyAI.apply_status(REGENERATING, duration)` que loop a aplica heal.
- **Summon**: skill que spawna mobs (Mae Vespa: "Convoca Vespas cd 20s, +2 vespas"). Implementar via `combat_controller.spawn_extra_enemy(enemy_data)`.
- **Enrage**: skill que ativa Berserker self quando hp < threshold (Lobisomem Alpha: "Frenesi Sangrento"). Implementar via signal `enemy.hp_threshold_crossed(0.5)` -> apply_status(BERSERKER).
- **AoE**: skill que afeta player + summoned mobs. Marcar `Skill.is_aoe = true`.
- **Reflect/Thorns**: passivo (Caracol de Limo: "Concha Reflectora cd 18s, Reflect 50%"). Implementar via `enemy.has_passive(REFLECT)` consultado no damage step.

**Sistema generico**: criar `EnemySkill` resource (`scripts/data/enemy_skill.gd`) com:
```
@export var id: String
@export var cooldown_seconds: float
@export var damage_multiplier: float = 1.0
@export var status_effects: Array[StatusEffectData]
@export var summon_enemy: EnemyData = null
@export var heal_percent: float = 0.0
@export var is_aoe: bool = false
@export var telegraph_seconds: float = 0.0
@export var vfx_pattern: String = "default"
```

Cada `EnemyData.skills: Array[EnemySkill]`. Controller polls cooldowns.

#### 4.2.3 Boss = enemy com flag, nao classe separada

Adicionar campo `enemy_class: Enum { COMMON, ELITE, BOSS }` em `EnemyData`.

Effects:
- BOSS nao escala HP por wave (mantem HP fixo, alinhado com IEH2 `bossHp`).
- BOSS toca musica especial.
- BOSS spawna so 1 por stage (ultima wave).
- ELITE tem chance 5-10% de spawnar como wave extra opcional (golden cookie style).

#### 4.2.4 Tile size

`enemies-catalog.md` nao menciona tile size explicitamente. Cross-ref `idleon-reference/03_MAPS_MONSTERS.md` linha 49: `HeightOfMonster: 50`, `MonsterOffsetX/Y`. Cada mob tem altura propria.

[DECISAO PENDENTE: `EnemyData` precisa de campos `display_size_x`, `display_size_y`? Ja temos `sprite_scale` implicito? Verificar com state-of-project.md. Recomendacao: adicionar `display_scale: float = 1.0` que multiplica baseline. Bosses usam `2.0`+ pra parecer maiores na arena.]

### 4.3 Quest system

#### 4.3.1 Estrutura para R1.0

| Tipo | Quantidade R1.0 | Quantidade total (`quests-catalog.md`) | Notas |
|---|---|---|---|
| Main | **30** (5 por zona x 6 zonas) | 60 | Adiar 30 pra R1.1-1.3 |
| Side | **10** (templates reutilizaveis) | 20 | Adiar 10 |
| Daily | **5** templates | 10 | Adiar 5 |
| Weekly | **3** templates | 5 | Adiar 2 |
| **Total R1.0** | **48** quests visiveis | 95 | — |

#### 4.3.2 Tipos de main quest por zona (5 por zona)

Padrao recorrente:

| # | Tipo | Exemplo Floresta |
|---|---|---|
| 1 | Tutorial / Introducao | "Bem-vindo a Floresta — kill 5 Slime Verde" |
| 2 | Coleta basica | "Primeiro Cobre — Mining: 10 Cobre" |
| 3 | Elite hunt | "O Lider Goblin — kill [ELITE] Lider Goblin Sangrento" |
| 4 | Boss hunt | "O Fim do Bosque — kill [BOSS] Espirito Anciao" |
| 5 | Lore (Eldwin) | "Lore da Floresta — coletar 3 itens iconicos" |

Mantem variedade: kill, coleta, elite, boss, lore.

#### 4.3.3 Side quests (10 templates)

Reaproveitar `quests-catalog.md` secao 3, mas escolher os 10 mais polivalentes (que funcionam em qualquer zona):
- S1 (Encontre meu Filho — kill mob raro)
- S5 (Coletor de Pelo — coletar peles cross-zona)
- S8 (Limpeza da Cidade — vender N gold)
- S10 (Codice de 100 Materiais)
- S11 (Aprendiz do Forjador)
- S13 (Cacador de Cards)
- S15 (Mil Mortos)
- S16 (Coleta Pesada Mining)
- S17 (Coleta Pesada Herbalism)
- S18 (Tratado da Floresta — alinhada com main da Floresta)

#### 4.3.4 Daily/Weekly quests

5 dailies (rotativo, jogador ve 3 por dia):
- DQ1 (Cacador do Dia)
- DQ2 (Coletor do Dia)
- DQ3 (Forjador do Dia)
- DQ4 (Mercador do Dia)
- DQ9 (Conquistador do Dia — elite)

3 weeklies (rotativo, jogador ve 2 por semana):
- WQ1 (Boss Hunter Semanal)
- WQ2 (Coletor Semanal)
- WQ4 (Aventureiro Semanal — 30 dailies)

#### 4.3.5 Quests secretas / hidden

Inspirado em Cookie Clicker `shadow achievements` (`05-achievements-milk.md` secao 4.14, 19 entries).

Lista para R1.0 (6 secretas):
- "Mil e Uma Noites" — Kill 1001 inimigos em 1 dia real (sem reset).
- "O Primeiro Heroi" — Reach level 30 com Warrior em <12h reais de gameplay.
- "Sortudo" — Drop 5 itens Legendary em 1 stage.
- "Pacifista" — Complete 1 stage sem tomar dano.
- "Vela Apagada" — Reach Tundra com 1 personagem sem morrer.
- "Madrugada" — Login as 3am-5am (sistema clock).

Trigger silencioso (sem indicacao previa). Recompensa: Titulo + 5 gemas + cosmetico.

#### 4.3.6 Class quests

[DECISAO PENDENTE: ter quests especificas por classe (Warrior-only, Mage-only, etc) eh esperado? `quests-catalog.md` nao detalha. Recomendacao: **sim, mas pos-R1.0**. R1.0 tem so Warrior + 2 outras classes; quests por classe podem virar duplicacao desnecessaria. Adicionar em R1.1+ quando 5 classes estiverem balanceadas.]

### 4.4 NPCs (lista minima por zona)

Manter `npcs-catalog.md` mas reduzir para escopo R1.0:

#### 4.4.1 Acampamento basico (NPCs fixos)

Ja descritos em `npcs-catalog.md` secao 2:
- Bertran (Ferreiro / Smithing)
- Marisol (Alquimista)
- Olav (Taverneiro / recrutar personagens)
- Padre Aldo (Curador / revive)
- Luma (Mercador Itinerante)

5 NPCs. Suficiente para R1.0.

#### 4.4.2 NPCs itinerantes por zona (1 por zona, opcional)

Reduzir lista de `npcs-catalog.md` secao 8 para R1.0:
- Floresta: Mara (Encontre meu Filho — side quest)
- Deserto: Bertin (Caravaneiro Ferido — main D1)
- Caverna: Sigrid (Anã Perdida — main C3)
- Pantano: [PLACEHOLDER: NPC pantano — sugestao: Yara Curandeira Errante]
- Tundra: Astrid (Cacadora Veterana — main T1+T2)
- Templo: Yura (Monge Errante — side opcional)

6 NPCs itinerantes. Total NPCs R1.0: 5 fixos + 6 itinerantes = 11 NPCs.

#### 4.4.3 NPCs adiados pra R2.0+

- Olav (Taverneiro) — pode estar ja em R1.0, ok.
- Joaquim (Carpinteiro), Wenzel (Cacador), Tonio (Pescador), Iara (Plantio), Roman (Curral) — Vilarejo estagio 2, **R1.0 stretch goal**.
- Helga, Rodrigo, Anselmo, Iza (Cidade estagio 3) — **R2.0+**.
- Thaddeus, Severin, Aurelia (Reino estagio 4) — **R2.0+**.
- Vorthel, Belasco, Celestina (Imperio estagio 5) — **R3.0+**.
- Transcendido, Renascido, Eldwin (especiais) — **R2.0+** (vinculados a sistemas prestige).

#### 4.4.4 Integracao com Settlement view

State-of-project.md secao 8 lista `SettlementView` como placeholder.

Proposta:
- Settlement view eh o **Acampamento basico** visualizado como cena.
- Cada NPC fixo eh um ponto clicavel no Acampamento.
- Clicar abre modal de dialogo + lista de quests do NPC.
- NPCs itinerantes nao aparecem aqui (ficam na zona).

### 4.5 Achievements / Titulos / Collectibles

#### 4.5.1 Estrutura proposta

3 sistemas paralelos (alinhado com convergencia 2.6):

1. **Cards** (ja existe em `cards-catalog.md`) — drop-based, 84 cards totais (66 reg + 12 corr + 6 greedy). Bonus mecanico.
2. **Bestiary** (ja existe como autoload) — kill counts. Marcos com bonus mecanico (`enemies-catalog.md` secao 8).
3. **Titulos** (NOVO, proposta abaixo) — trofeus por marcos diversos. Bonus mecanico pequeno + cosmetico (titulo aparece sob o nome do char no Hero panel).

#### 4.5.2 Titulos para R1.0 (20 entries)

Inspirado em `16-titles.md` (IEH2 tem 27 titulos hardcoded).

| # | Titulo | Condicao | Bonus permanente |
|---|---|---|---|
| 1 | Aventureiro Novato | Complete tutorial | +1% Gold Gain |
| 2 | Cacador de Slimes | Kill 100 Slime (qualquer cor) | +2% damage vs Slime |
| 3 | Mata-mil | Kill 1000 inimigos totais | +1% ATK |
| 4 | Mata-cem-mil | Kill 100k inimigos totais | +5% ATK |
| 5 | Veterano | Reach level 50 com 1 char | +3% XP gain |
| 6 | Heroi Lendario | Reach level 100 com 1 char | +5% XP gain |
| 7 | Primeiro Boss | Kill primeiro boss | +2% damage vs Boss |
| 8 | Cacador de Bosses | Kill 50 bosses totais | +5% damage vs Boss |
| 9 | Explorador | Visite todas as 6 zonas | +3% Move Speed (futuro) |
| 10 | Colecionador | Possua 50 cards diferentes | +5% Card Drop Chance |
| 11 | Conhecedor | Possua todos os 66 cards regulares | +10% Drop Chance global |
| 12 | Ferreiro | Forje 100 itens | +5% Crafting XP |
| 13 | Mineiro Mestre | Mine 1000 vezes | +5% Mining Efficiency |
| 14 | Lenhador Mestre | Woodcutting 1000 vezes | +5% Woodcutting Efficiency |
| 15 | Pescador Mestre | Fishing 500 vezes | +5% Fishing Efficiency |
| 16 | Coletor | Tenha 100 materiais unicos no inventory | +5% Material Drop |
| 17 | Equipado | Use 1 item Legendary | +3% Stat de equipamento |
| 18 | Endinheirado | Acumule 1M gold | +5% Gold Gain |
| 19 | Multi-Heroi | Tenha 3 chars level 30+ | +5% Bestiary bonus |
| 20 | Sazonal | Complete 1 evento sazonal | Titulo cosmetico + 5 gemas |

Bonus medio: ~3-5%. Soma-se a cards + bestiary. Nao quebra economia.

#### 4.5.3 Steam achievements (>=20 core para R1.0)

Subset dos titulos acima + extras:
- Os 20 titulos acima viram Steam achievements diretos.
- Extras (cosmeticos, sem bonus in-game):
  - "Welcome to Idle Medieval" — login first time.
  - "First Wave" — kill first enemy.
  - "First Level Up" — reach level 2.
  - "Equipped" — equip first weapon.
  - "First Save" — first autosave.

Total: 25 Steam achievements.

#### 4.5.4 Achievements secretos (hidden)

6 quests secretas da secao 4.3.5 viram tambem hidden achievements. Sem texto descritivo na lista (mostra "???" ate ser cumprido).

#### 4.5.5 Meta-progression unlock vs cosmetic only

[DECISAO PENDENTE: achievements/titulos devem dar bonus mecanico (Cookie Clicker Milk, IdleOn cards) ou ser **so cosmeticos** (titulo aparece sob o nome)? Recomendacao: **bonus pequeno mecanico (1-5%) + cosmetico**. Justifica grind de completionist mas nao quebra economia.

Stack com cards/bestiary: deve haver cap pra evitar +50% damage stackado. Cap sugerido: +30% damage de cards, +20% de bestiary, +10% de titulos. Total max ~60% damage adicional via meta-progression (alem de stat points + equipment + skill tree).]

### 4.6 Seasonal events (ter ou nao?)

[DECISAO PENDENTE: Implementar eventos sazonais (Halloween, Natal, Pascoa, Aniversario) em qual release?

Opcoes:
- **A**: R1.0 minimo (1-2 eventos prontos, alinhados com data real de release).
- **B**: R1.1 patch.
- **C**: R2.0+.

Recomendacao: **B (Patch 1.1)**. Release-plan.md ja menciona "Eventos sazonais leves (Halloween, Natal) se data permitir" em 1.1. R1.0 foca no loop core.

Razao: implementar 4 eventos sazonais antes do core estar polido eh fragmentar foco. Mas ter o **framework** (event_bus signals, event detector por data real) ja em R1.0 = preparacao boa.]

**Para o framework**:
- `EventManager` autoload novo:
  - `_process` checa data real (cross-ref `15-misc-systems.md` linhas 1294-1305).
  - Emite signal `event_started(event_id)` e `event_ended(event_id)`.
  - Persiste no save: `events_completed: Dictionary` (event_id -> ano).
- Events ativam:
  - Tema visual (overlay no Acampamento).
  - Drops tematicos (`LootRoller` checa se event ativo, aplica drop pool sazonal).
  - Quest event-only desbloqueia ("Caçada de Aboboras" so existe em outubro).

### 4.7 Hooks com sistemas existentes

| Sistema proposto | Plug em sistema existente | Arquivos a tocar |
|---|---|---|
| `enemy_class` flag | `EnemyData` resource | `scripts/data/enemy_data.gd` |
| `EnemySkill` resource | novo, usado por `combat_controller` | `scripts/data/enemy_skill.gd` (novo) |
| Bestiary marcos | `Bestiary` autoload + `bestiary_modal` | `autoload/bestiary.gd`, `scenes/ui/modals/bestiary_modal.gd` |
| Titulos | novo autoload `TitleManager` + modal | `autoload/title_manager.gd` (novo), `scenes/ui/modals/titles_modal.tscn` (novo) |
| Quest log | novo autoload `QuestManager` + view | `autoload/quest_manager.gd` (novo), `scenes/views/quests_view.gd` (preencher placeholder) |
| NPC interactions | novo `NPCData` resource + modal de dialogo | `scripts/data/npc_data.gd` (novo), `scenes/ui/modals/npc_dialog_modal.tscn` (novo) |
| Event manager | novo autoload | `autoload/event_manager.gd` (novo) |
| Zone simplification | manter `ZoneData` + `AreaData`, simplificar `map_modal` UI | `scenes/ui/modals/map_modal.gd` |

---

## 5. Hooks com docs existentes

### 5.1 Catalogos que ja cobrem este escopo

- `01_design/enemies-catalog.md` — 6 zonas, mob/elite/boss detalhados, stats balanceados. **Manter como source of truth**. So adicionar:
  - Campo `enemy_class` (COMMON/ELITE/BOSS) — ja implicito via `[ELITE]`/`[BOSS]` prefix.
  - Campo `display_scale` (sugestao secao 4.2.4).
- `01_design/quests-catalog.md` — 60+20+10+5 quests. **Cortar pra 30+10+5+3** em R1.0 (secao 4.3.1).
- `01_design/npcs-catalog.md` — 25+ NPCs. **Reduzir pra 11 em R1.0** (secao 4.4).
- `01_design/cards-catalog.md` — 84 cards (66+12+6). **Manter integral**. Cross-ref direto com `enemies-catalog.md`.
- `01_design/events-catalog.md` — 4 sazonais + 3 invasoes + 3 festivais. **Adiar implementacao pra R1.1**, mas framework em R1.0.

### 5.2 Novos catalogos a criar

- `01_design/titles-catalog.md` (NOVO) — 20 titulos para R1.0 (secao 4.5.2). Pode ser sub-secao de cards-catalog.md em vez de arquivo separado.
- `01_design/enemy-skills-catalog.md` (NOVO) — padrao `EnemySkill` resource + lista de skills compartilhadas entre inimigos (Telegraph, Regen, Summon, Enrage, AoE, Reflect). Pode ser sub-secao de enemies-catalog.md.

### 5.3 Atualizacoes em `00_meta/`

- `progress-log.md` — registrar criacao deste synthesis doc.
- `pending-decisions.md` — adicionar as decisoes pendentes listadas:
  - 3.1: 5 ou 6 zonas R1.0?
  - 3.2: 3 niveis (zone/area/stage) ou 2 (zone/stage)?
  - 3.4: 60 ou 30 main quests R1.0?
  - 3.5: Sistema de Titulos alem de cards?
  - 3.7: NPCs itinerantes na zona ou no Acampamento?
  - 3.8: Drops sazonais permanentes ou expiram?
  - 3.9: Quando Area Prestige?
  - 3.10: Quando SD/Challenges?
- `release-plan.md` — atualizar Release 1.0 para refletir:
  - 6 zonas (nao 5).
  - 30 main quests (nao 60).
  - 25 Steam achievements (nao 20).
  - Framework de eventos sazonais em R1.0, conteudo em R1.1.

### 5.4 Cross-refs

- `02_math/character-stats.md` — adicionar bonus de Titulos (caps de stack proposto em secao 4.5.5).
- `04_phases/phase-02-*.md` — incluir implementacao de TitleManager + QuestManager + NPCData.
- `04_phases/phase-03-*.md` — incluir EventManager (framework + 2 eventos para 1.1).
- `STATE-OF-THE-PROJECT.md` — secao 4 "Map / Zonas / Stages" precisa atualizar quando decisao 3.2 for tomada.

---

## Apendice A: Comparativo numerico

| Eixo | Cookie Clicker | IdleOn | IEH2 | Nossa proposta R1.0 |
|---|---|---|---|---|
| Zonas/Mundos | 1 (single screen) | 7 (W1-W7) | 10 area tiers | 6 |
| Mapas/Stages | N/A | 327 | varia | 36 (6 zonas x 6 stages) |
| Inimigos no DB | N/A | 403 | 12 species x 8 colors = 96 | ~84 (`enemies-catalog.md`: 66 comuns + 12 elites + 6 bosses) |
| Inimigos rastreaveis | N/A | 99 (deathNote) | 96 | 84 (todos) |
| Cards/Coletaveis | N/A | 271 cards + 32 statues + ~150 stamps | 27 titles | 84 cards + 20 titulos = 104 |
| Achievements visiveis | 622 | nao tem (cards + stamps fazem o papel) | nao tem (titles fazem o papel) | 25 Steam achievements + 6 hidden |
| Main quests | 0 | ~10/mundo = 70 | varia (UnlockMission por area) | 30 |
| Side quests | 0 (fortune cookies cumprem papel) | varias | varias | 10 templates |
| Daily/Weekly | 0 | 0 documentado | 0 documentado | 5 dailies + 3 weeklies |
| NPCs | 0 | ~5/mundo = 35 | ~12 buildings | 11 (5 acamp + 6 itinerantes) |
| Eventos sazonais | 5 | leves | 0 | framework em 1.0, conteudo em 1.1 |
| Boss mechanics | N/A | HP fixo + drops | HP fixo + Multiplier reward | HP fixo + drops + Card |

## Apendice B: Padroes copiados de cada jogo

### B.1 Do Cookie Clicker
- News ticker (`15-misc-systems.md` secao 1) — opcional, R2.0+. Util pra fortune cookies / dailies hint.
- Notifications stack com cap 5 + close all (`15-misc-systems.md` secao 2) — **ja temos** `NotificationStack`.
- Seasons triggered por data real (`10-seasons.md` secao 1) — framework R1.0, conteudo R1.1.
- Achievement esoterico/shadow (`05-achievements-milk.md` secao 4.14) — 6 hidden em R1.0.

### B.2 Do IdleOn
- Map/zone naming convention (raw vs display) (`03_MAPS_MONSTERS.md` secao 4) — ja seguimos via `zone.id` + `zone.display_name`.
- `SpecialType` no schema do inimigo (`03_MAPS_MONSTERS.md` secao 2) — adotar `enemy_class`.
- Tier system para drops repetidos (`05_COLLECTIBLES.md` secao 1) — cards ja tem (`cards-catalog.md`: Common -> Uncommon -> Rare -> Epic com 5/8/15 duplicatas).
- Card sets por categoria (`05_COLLECTIBLES.md` linhas 44-62) — `cards-catalog.md` secao 6 ja propoe.

### B.3 Do IEH2
- 10 upgrades por area (`09-area-prestige.md` linhas 9-22) — Area Prestige adiado pra 2.0+.
- Boss com HP fixo (nao escala) (`11-challenges.md` linha 96) — adotar para bosses R1.0.
- Padroes de formula de titulo (`16-titles.md` secao "Padrões de design") — usar para nossos titulos:
  - Linear simples (titulos 1-5%)
  - Tabela manual para titulos com valores especificos
- Pool fixo de monstros (max 30 spawnados) (`17-combat.md` linha 17-19) — relevante pra performance, ja seguimos no fato de termos 1 enemy ativo por vez.

---

## Apendice C: Resumo executivo para tomada de decisao

**5 decisoes criticas que destravam o resto**:

1. **3.2** — Zone structure: 2 niveis (zone/stage) ou 3 (zone/area/stage)?
2. **3.4** — Cortar de 60 main quests pra 30 em R1.0?
3. **3.5** — Implementar sistema de Titulos (alem de cards/bestiary)?
4. **3.8** — Drops sazonais sao permanentes uma vez ganhos?
5. **3.9 + 3.10** — Quando Area Prestige e SD/Challenges?

Estas 5 decisoes guiam:
- Estrutura de `ZoneData`/`AreaData`/`StageData`
- Cronograma de implementacao
- Novos autoloads (`TitleManager`, `EventManager`, `QuestManager`)
- Catalogos a criar/atualizar

**Recomendacoes** (do agente):
- 1: 2 niveis (zone/stage). Mais simples.
- 2: 30 quests R1.0. Adiar 30 pra R1.1-1.3.
- 3: Sim, ~20 titulos com bonus pequeno (1-5%).
- 4: Permanente uma vez ganhos. Cookie Clicker style.
- 5: Area Prestige R2.0+. SD/Challenges R3.0+.

---

## Termos novos introduzidos neste arquivo

- "Enemy class" — flag em EnemyData (COMMON/ELITE/BOSS) para diferenciar mecanicamente.
- "EnemySkill resource" — recurso novo para skills configuraveis por inimigo.
- "Titulos" — sistema novo de meta-progression paralelo a cards/bestiary.
- "Event framework" — autoload novo (`EventManager`) com detector de data real.
- "Quest log" — view de quests preenchida (atualmente placeholder).
- "Hidden achievement" — 6 achievements secretos R1.0 (Cookie Clicker shadow style).
- "Stretch goal R1.1" — feature planejada pra R1.0 mas movel pra patch 1.1 se cronograma apertar.
