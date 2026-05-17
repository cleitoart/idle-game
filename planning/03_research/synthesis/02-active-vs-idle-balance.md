# Sintese: Balanceamento Ativo vs Idle

> Documento gerado em 2026-05-14 por agente paralelo do hub `planning/03_research/synthesis/`.
> Pergunta-norte: como Cookie Clicker, Legends of IdleOn e Incremental Epic Hero 2
> balanceam ganhos quando o jogador esta presente vs ausente, e como isso pode
> ser mesclado num idle medieval que ja tem combate em tempo real, game speed
> 1x/2x e offline cap de 12h.
>
> Fontes citadas:
> - `references/idleon-reference/AFK_PROGRESSION.md`
> - `references/idleon-reference/COMBAT_MATH.md`
> - `references/idleon-reference/INDEX.md`
> - `references/ieh2_dump/docs/17-combat.md`
> - `references/ieh2_dump/docs/18-economy.md`
> - `references/ieh2_dump/docs/19-meta-and-qol.md`
> - `references/cookie-clicker-dump/03-buildings.md`
> - `references/cookie-clicker-dump/06-golden-cookies-buffs-wrinklers.md`
>
> Cross-references com docs do hub:
> - [ver: `planning/01_design/save-offline-spec.md` secao 4 — Offline progression]
> - [ver: `planning/02_math/time-to-progress.md` secao 2.2 — % offline vs ativo]
> - [ver: `planning/01_design/events-catalog.md` secao 3-4 — Invasoes e Festivais]
> - [ver: `planning/00_meta/pending-decisions.md` #18 — Cap 12h resolvido]
> - [ver: `planning/01_design/account-vs-character.md` — Loja Eterna boundary]

---

## 1. Como cada jogo faz

### 1.1 Cookie Clicker

Cookie Clicker e' um idle puro. Nao existe "AFK rate" como conceito — o jogo
sempre roda 100% offline na mesma cadencia que online. O que muda e' a
**presenca de eventos que so disparam com o jogador olhando para a tela**.

#### 1.1.1 Geracao passiva e' a baseline

A producao de cookies por segundo (`Game.cookiesPs`) e' a soma de:

```
storedTotalCps = building.amount × cps(building)
cookiesPs      = soma(storedTotalCps) × Game.globalCpsMult
```

Fonte: `cookie-clicker-dump/03-buildings.md` linha 250-253. Esse calculo roda
identico independente do jogador estar presente — Cookie Clicker so persiste o
estado e na proxima abertura calcula `delta_t * cookiesPs` (com perda de
~50-90%, dependendo de upgrades de "legacy", documentado fora do escopo desses
arquivos).

#### 1.1.2 Cap de offline

Cookie Clicker **nao tem cap explicito** de tempo offline para producao passiva
dos buildings. O jogo simplesmente computa o delta entre `lastSave` e `now`. O
gargalo real e' indireto:

- **Wrinklers**: maximo 10-14 simultaneos (`getWrinklersMax`, fonte
  `cookie-clicker-dump/06-golden-cookies-buffs-wrinklers.md` linha 297-303).
  Cada um suga `1/20 = 5%` da CpS (linha 333). Com 10 wrinklers fase-2, voce
  perde ~50% da CpS imediata, mas quando estouram devolvem **1.1x** o sugado
  (linha 348-358). Isso e' o "cap implicito": apos uns minutos toda CpS
  ofensiva fica banked no wrinkler, e o estoque deles e' finito.
- **Golden cookies acumuladas**: nao existe. Se voce esta offline, golden
  cookies simplesmente nao aparecem (`Game.shimmer` spawn requer game loop
  ativo).
- **Sugar lumps**: maturam em tempo real, mas o calculo e' "data atual −
  data plantada", entao offline conta.

Conclusao: producao de cookies offline e' infinita por design, mas tudo que
**exige interacao** (golden cookies, dragon aura clicks, sugar lumps frescos)
acumula zero offline.

#### 1.1.3 O que premia presenca ativa

Tres mecanicas fazem ficar online valer muito mais que offline:

1. **Golden cookies** (spawn entre 5-15min, fonte `06-golden-cookies-buffs-wrinklers.md`
   linha 33-57). Cada golden clicado dispara um efeito da tabela em linha
   118-138. Os principais:
   - `Frenzy`: CpS x7 por 77s (linha 122).
   - `Lucky!`: ganha `min(estoque*0.15, CpS*60*15)+13` cookies de uma vez
     (linha 123).
   - `Click frenzy`: clique x777 por 13s (linha 130).
   - `Cookie storm`: chove mini-cookies por 7s (linha 125).
   - `Building special`: buff x(amount/10+1) por 30s (linha 127).
   - `Dragon harvest`: CpS x15 por 60s (linha 128).
   - `Blood frenzy` (wrath): CpS x666 por 6s (linha 136).

   Cliques combinados (Frenzy + Click frenzy + Dragonflight) sao os "momentos
   epicos" do jogo. **Quem joga ativo durante uma cadeia de golden combos
   ganha em 1 minuto o equivalente a 30+ minutos passivos.** Cap teorico de
   combo: `7 × 15 × 777 × 1111 ≈ 90M de CpS-equivalente por clique` durante
   janelas de 10s.

2. **Wrinklers** (`06-golden-cookies-buffs-wrinklers.md` linha 287-381). Em
   Grandmapocalypse (elderWrath > 0), wrinklers spawnam em ~0.001-0.003%/frame
   por wrath level (linha 307-313). Estourar manualmente cada um custa
   ~3 cliques (0.75 HP por clique vs 2.1 HP base, linha 293, 361). Wrinkler
   shiny (0.01% spawn rate, linha 317-322) paga 3x. Estourar 10 wrinklers
   "fed" devolve ~5500% do tempo offline. **Quem nao estoura, perde os
   cookies (cap de 14 wrinklers ativos).**

3. **Stock Market** (Bank building level >= 1, fonte `03-buildings.md` linha
   16, 112-116). Minigame de bolsa que so atualiza em tempo real. Comprar
   na baixa / vender na alta exige presenca. Documento nao detalha numeros
   especificos do minigame.

#### 1.1.4 Punicao de idle

**Zero punicao direta.** Quem deixa o jogo aberto e nunca clica em nada ainda
ganha 100% da CpS base. Apenas perde **multiplicadores que requerem clique**.
Esse e' o trade-off explicito: idle e' viavel, ativo e' superior por fator
~10-50x em janelas curtas, mas o jogo nunca te diz "voce esta perdendo".

#### 1.1.5 Pretty please vs presenca cronometrada

Golden cookies sao **timer-based** (5-15min base, reduzivel a 2-7min com
upgrades), nao acumulam offline, mas tambem nao se perdem se voce demora 1
minuto a clicar (dur=13s base, ate 52s com upgrades, linha 70-81). Ou seja:
**a janela de presenca exigida e' curta mas frequente**, ideal para sessoes de
30 minutos.

#### 1.1.6 Compressao de tempo

Cookie Clicker **nao tem sistema explicito de skip/time travel**. O que tem:

- **Sugar lumps maturam em tempo real** (~20h cada). Persistem offline. Sao a
  "moeda do tempo" do jogo.
- **Heavenly chips** (prestige): ao fazer Ascension, voce mantem chips que
  multiplicam CpS na nova run. Nao e' skip — e' "comprimir cumulativo da run
  anterior em multiplicador permanente".
- **`Stretch Time` (Grimoire)**: feitico que extende buffs ativos. Custa Magic
  (regenera em tempo real). Nao gera cookies, so extende.

---

### 1.2 Legends of IdleOn

IdleOn e' o oposto: AFK e' explicitamente um modo separado, com formula e
cap proprios.

#### 1.2.1 Formula base do AFK rate

Fonte: `idleon-reference/AFK_PROGRESSION.md` linha 25-48.

```
afkRate = (BASE_MULTI + sum_of_bonuses_percent) / 100 × afkMulti
afkMulti = (1 + tesseractBonus/100) × (1 + equipmentAfkMulti/100)
gains_during_afk = active_rate × afkRate × timeAway
```

`BASE_MULTI` por modo (linha 36-46):

| Modo | Base |
|---|---:|
| `FIGHTING` (combate) | **40** (40% do ativo) |
| `MINING` | 50 |
| `COOKING` | 50 |
| `CHOPPIN` (lenha) | 50 |
| `FISHING` | 50 |
| Demais skills | 50 |
| `WORSHIP`, `LABORATORY` | custom |
| `Nothing` (NPC, fast travel) | 0 |

**Por que combate e' 40 e nao 50** (linha 47): combate tem mais "headroom"
ativo (skill rotation, dodging, posicionamento), entao o gap inicial e'
maior para que ativo seja superior por mais tempo. Skills idle (mining,
fishing) ja sao auto por natureza, entao 50% base e' justo.

#### 1.2.2 AFK rate pode passar 100%

O ponto-chave do design: **investindo em bonuses certos, AFK rende MAIS que
ativo** (linha 18-21). Isso e' o "carrot" — vira meta-progressao por si so.
Bonuses que somam direto no `+ sum_of_bonuses_percent` (linha 50-65) incluem:
tasks W4, family bonus, cards (`Skill_AFK_gain_rate`), card set 5, guild
bonus, talents (`SLEEPIN'_ON_THE_JOB`), sigil, chip 8 do Lab, equipamento
slots 24+59, prayer `Zerg_Rushogen` (positivo) menos `Ruck_Sack` (negativo),
event shop, golden food `Golden_Dumpling`, vault upgrade 23.

Apos passar de 100%, AFK e' literalmente superior — o jogador desconecta de
proposito para farmar mais rapido.

#### 1.2.3 Bonuses por modo (granularidade)

Linha 91-106. Cada modo tem talents/itens exclusivos:

- `FIGHTING`: `IDLE_BRAWLING`, `IDLE_CASTING`, `IDLE_SHOOTING`, Post office
  `Civil_War_Memory_Box`, Star sign `Fight_AFK_Gain`.
- `MINING`: `IDLE_SKILLING`, `DREAM_OF_IRONFISH` bubble, Post office
  `Dwarven_Supplies`.

Resultado: cada skill tem identidade propria de AFK. Voce nao monta um build
"all-AFK" generico, monta um build de AFK mining ou AFK fighting.

#### 1.2.4 Cap de tempo offline

Fonte: `AFK_PROGRESSION.md` linha 217-243.

**Nao existe um cap unico.** Cada subsistema tem seu:

- `TimeAway.Player`: clamp em 10.000s (~2.8h) como minimo, max 2e8s (~6 anos)
  como overflow guard (linha 222-227).
- `Arcade_MaxClaimTime`, `BribeTimeMax`: caps por subsistema, configuraveis
  via talents/bribes.
- O famoso "cap de 10h" do combate (linha 240-241) e' resultado da curva
  `ArcadeTimeMax,decay,12,30,5,...` — uma decay curve com asymptote em ~30h+.

Threshold para considerar AFK (linha 230-232): **120 segundos**. Menos que
isso conta como "ainda jogando" e nao processa.

Lesson aplicada: "o cap nao e' uma constante hard-coded, e' uma **stat
upgradavel** ao longo do jogo" (linha 243).

#### 1.2.5 Servidor vs cliente (anti-cheat)

Linha 220-235. `GlobalTime` vem do servidor da Lava Flame Studios. Se voce
mexer no relogio local, o jogo usa `GlobalTime` como referencia. Sanity
checks evitam abuso (delta absurdo reseta para zero).

#### 1.2.6 Eventos so em jogo ativo

IdleOn tem alguns subsistemas que so progridem com o jogo aberto:

- **Sailing**: timers de ilha em tempo real, mas pickup precisa ser manual.
- **Cooking**: meals cozinham em tempo real, claim manual.
- **Constructions / Towers**: progridem offline mas precisam ser realocadas
  manualmente para evitar idle improdutivo.
- **Tasks dailies**: refresh em horario fixo, perde-se se nao logar.

Nenhum desses tem o "drama" do golden cookie — sao mais "lembre-se de fazer
manutencao", nao "perca momento epico".

#### 1.2.7 Accuracy gate

Fonte: `COMBAT_MATH.md` linha 119-133 e `AFK_PROGRESSION.md` linha 161-165.

```
effective = playerAccuracy / monsterDefence
hitChance = 0  se effective < 0.5
```

Se accuracy/def < 0.5, hit chance e' 0 e **AFK rende absolutamente nada**.
Esse e' o "portao duro" do AFK: voce nao pode farmar conteudo onde nao
acerta. Funciona como auto-gate de zona, sem precisar de "level requirement".

#### 1.2.8 Respawn rate como nerf-knob

Fonte: `AFK_PROGRESSION.md` linha 110-140.

```
respawnRate = baseRespawnTime / (1 + totalBonus / 100)
World 7: totalBonus = 0.65 × commonBonus + bigFishBonus  # nerf de 35%
```

Devs aplicam multiplier global por mundo (linha 132-138) para limitar
inflacao do AFK rate em conteudos novos sem nerfar mecanicas individuais. Bom
padrao para reutilizar.

#### 1.2.9 Kills por hora

`COMBAT_MATH.md` linha 178-194:

```
hourlyKills = min(
    mapSpawnCap / (respawnRate + 0.1),                       # cap A
    K / (mapDist/(130×speed/100) + actionWaitTime × ...)      # cap B
)
killsPerHour = floor(3600 × hourlyKills)
```

`min(A, B)` significa que dois bottlenecks competem: spawn rate da zona vs
kill speed do player. Em zonas baixas, spawn limita. Em zonas altas
(otimizado), seu DPS limita. Isso justifica investir tanto em
"spawn-rate-up" (shrines, schematics) quanto em "DPS-up" (gear).

---

### 1.3 Incremental Epic Hero 2

IEH2 e' um meio-termo: combate ativo + AFK gerenciado + "moeda de tempo"
(Nitro).

#### 1.3.1 Formula offline

Fonte: `ieh2_dump/docs/19-meta-and-qol.md` linha 64-82.

```csharp
public class OfflineBonus {
    double expPerOfflineTimesec;
    double goldPerOfflineTimesec;
    double areaClearNumPerOfflineTimesec;
    double[] materialsPerOfflineTimesec;
    
    double offlineTimesec = -1.0;
    double gainFactor = 0.95;   // 95% do calculado
}
```

`gainFactor = 0.95` (linha 73) e' a "taxa de imposto" offline. Recebe 95% do
simulado. Pequeno mas faz online valer ligeiramente mais. Comparacao direta:
IEH2 e' 5% mais lento offline, IdleOn fight e' 60% mais lento, Cookie Clicker
e' 0%-100% mais lento dependendo do que voce conta (golden cookies x base).

#### 1.3.2 Duas formas de receber offline

Linha 76-80:

```csharp
public enum OfflineBonusKind { Nitro, Playtime }
```

1. **Playtime**: simula direto, da XP/gold/materials. Escolha "default".
2. **Nitro**: o tempo offline vira `Nitro` (moeda do tempo) acumulada para
   usar depois.

Decisao do jogador — alguns querem rewards instantaneos (Playtime), outros
querem banking para detonar em momento estrategico (Nitro).

#### 1.3.3 Sistema Nitro

Linha 31-46.

```csharp
public class NitroController {
    Multiplier nitroCap;        // base 10.000 sec (~2.7h)
    Nitro      nitro;            // currency atual
    Multiplier maxNitroSpeed;
    NitroSpeed speed;
    bool       isActive;
    float      nitroTimescale = 2f;  // ativo: 2x time
}
```

Nitro funciona como Game Speed 2x do jogo. Quando ativado, gasta 1 segundo
de Nitro por segundo de tempo real, e jogo roda em 2x (ou ate maior com
upgrades). Cap base 10.000s, upgradeable via `WAU_NitroCap`. Pattern do
genero: o jogador "banca tempo", deploya em momento bom (boss, evento de
drop, daily quest).

NitroReactor (linha 49-60) permite alocar a Nitro acumulada em 12 categorias
de bonus permanente (SkillTriggerNum, RebirthCount, PetEXPGain, etc.).
"Trocar Nitro por bonus permanente" — outro vetor de retencao.

#### 1.3.4 Cap de offline

Linha 65-72: nao explicito no fragmento. Apenas `offlineTimesec = -1.0`
como flag de "nao computado". Provavelmente outros docs do dump tem o cap,
mas para esse documento assumimos que **Nitro funciona como cap de facto**:
mais de N horas offline e' inutil porque vira mais Nitro do que o cap atual,
e o excedente e' perdido.

#### 1.3.5 Auto-Rebirth e automacao crescente

Linha 84-91. 3 tiers:

1. AutoRebirth 1: rebirth quando atinge level X.
2. AutoRebirth 2: rebirth com presets de allocation.
3. AutoRebirth 3: rebirth + ascension automaticos.

Cada tier desbloqueia mais automacao. **Padrao: QoL e' reward, nao default.**

`AutoSD` (Super Dungeon automatica) so libera em Tier 4+.

#### 1.3.6 Eventos timed

Linha 140-145: Daily quests rendem EpicCoin (200/250/350/500/1000 EC por
raridade, linha 142-145). Reset diario, claim manual obrigatorio. Perde-se
se nao logar.

`BonusCode` (linha 119-126): codigos promocionais (Twitter, comunidade) com
recompensa one-shot. Marketing/retencao.

#### 1.3.7 Combate ativo

Fonte: `ieh2_dump/docs/17-combat.md` linha 9-22.

```
HeroBattle       hero;
HeroAlly[]       heroAllys;     # 5 outros
PetBattle[]      pets;          # 10
MonsterBattle[]  monsters;      # ate 30
```

Pool fixo, spawn em arena 800x800 (linha 27-34). Combate roda em real time
mesmo offline (simulado). Nao tem "burst window" tipo golden cookie — e'
mais "loop estavel" tipo IdleOn.

#### 1.3.8 Real time vs game time

Linha 147-150. `playtimes[6]` (game time por hero) vs `playtimesRealTime[6]`
(wall-clock). Separados para que Nitro nao mascare tempo real de sessao. Bom
para analytics e anti-cheat.

#### 1.3.9 Drop chance flat

Fonte: `17-combat.md` linha 132-142.

```csharp
static double dropChanceBase      = 0.01;   // 1% base
static double colorDropChanceBase = 0.001;  // 0.1% color especial
```

Multiplicador (gear, pet passives) sobe a partir disso. 1% piso garante que
todo kill **tem chance de dropar algo**, mesmo offline. Sem zero-drops em
janelas curtas.

---

## 2. Convergencias

Os tres jogos concordam em pontos chave:

### 2.1 Idle nunca e' superior por puro tempo

Os tres tem **rate offline < rate online**:

- Cookie Clicker: offline produz base CpS, mas perde 100% dos buffs de
  golden cookie (que sao a maior parte do upside).
- IdleOn: combate offline e' 40% do ativo base.
- IEH2: gainFactor offline = 0.95 (95% do simulado).

**Lesson:** offline deve ser **inferior em rate** ao ativo. Cap inicial pode
ser 50-95%, dependendo do quanto se quer empurrar o jogador para ficar
presente. Nunca passa de ~95% — sempre deve "valer a pena" ficar online por
ao menos um delta.

### 2.2 Cap de offline existe (explicito ou implicito)

- Cookie Clicker: cap implicito via wrinklers (14 max) e ausencia de
  acumulo de golden cookies.
- IdleOn: cap explicito por subsistema, upgradavel.
- IEH2: cap explicito via Nitro overflow.

**Lesson:** algum cap precisa existir. Ele protege a economia (impede
"comeback infinito" apos hiato) e cria razao para logar mais frequente.

### 2.3 Cap deve ser upgradavel

- IdleOn: ArcadeTimeMax decay curve, sobe com talents e bribes.
- IEH2: NitroCap como Multiplier, sobe com upgrades.
- Cookie Clicker: numero de wrinklers sobe com `Elder spice` (+2) e Dragon
  Guts aura.

**Lesson:** **o cap nao e' constante, e' progressao.** O jogador desbloqueia
mais cap como recompensa, criando vetor de retencao alem do nivel
"hardcore".

### 2.4 Eventos cronometrados estimulam presenca sem punir ausencia

- Cookie Clicker: golden cookies (5-15min spawn, 13-52s na tela).
- IdleOn: dailies, weekly bosses, sailing pickups (longos cooldowns).
- IEH2: daily quest (EC), BonusCode (one-shot).

**Lesson:** eventos podem **adicionar** ao ativo sem **subtrair** do idle.
Quem chega a logar pega bonus extra; quem nao chega, ainda joga normalmente.

### 2.5 Servidor/seguranca contra cheat de relogio

- IdleOn: `GlobalTime` vs `TimeAway.Player` (`AFK_PROGRESSION.md` linha
  220-235). Sanity checks rejeitam delta absurdo.
- IEH2: arrays versionados (`_ver01011401`, etc., `19-meta-and-qol.md`
  linha 6-19).
- Cookie Clicker: minimal, mas Steam build tem checksum no save.

**Lesson:** alguma forma de validar tempo decorrido e' obrigatoria. O hub
ja decidiu hash sha256 do save ([ver: `01_design/save-offline-spec.md`
secao 3.2]) — falta apenas adicionar **clamp em `now < last_save`** para
detectar relogio para tras (decisao D7 em pending).

### 2.6 Subsistemas siloed por atividade

Cada atividade do jogador tem AFK rate diferente:

- IdleOn: FIGHTING=40%, skills=50%.
- IEH2: combat ativo, mas Cooking/etc. com timer proprio.
- Cookie Clicker: building produz, mas Garden tem ciclo (10-30min plant),
  Stock Market exige presenca total.

**Lesson:** **gathering pode ser MAIS offline-friendly que combate**. O hub
ja modela isso parcialmente — gathering nao tem combate ativo, e' so
"bate, lota inventario, troca de spot". Mesma logica do AFK Mining do
IdleOn aplica.

### 2.7 Pool fixo de objetos em hot path

Tres jogos usam pool fixo (IEH2 30 monsters max, Cookie Clicker DOM nodes
pre-alocados). Indica que **simulacao tem que ser barata** para escalar com
multi-hora offline.

---

## 3. Divergencias / Decisoes pendentes

### 3.1 Cookie Clicker vs IdleOn vs IEH2: filosofia central

| Aspecto | Cookie Clicker | IdleOn | IEH2 |
|---|---|---|---|
| Offline rate | 100% base, 0% buffs | 40-50% base, escalavel >100% | 95% flat |
| Cap explicito? | Nao (so via wrinklers) | Sim, por subsistema | Sim, via Nitro |
| Burst ativo | Sim, intenso (golden) | Nao, suave | Nao, suave |
| Recompensa de presenca | Multiplicativa (combo) | Aditiva (dailies) | Aditiva (dailies + Nitro spend) |
| Punicao de ausencia | Indireta (golden perdido) | Direta (cap atinge) | Suave (5% taxa) |

### 3.2 [DECISAO PENDENTE: rate offline base — 40%, 50%, 70% ou 95%?]

Tres referencias, tres numeros. Recomendacao do hub atual ([ver:
`02_math/time-to-progress.md` linha 60]): **~80% do ativo, "otimo
configurado"**.

Opcoes:

| Rate | Modelo | Pro | Contra |
|---|---|---|---|
| 40% | IdleOn combat | Ativo claramente superior, gap forte | Sente-se punitivo se jogador casual |
| 50% | IdleOn skills | Equilibrio classico, room para grow >100% | Mid — nao tem identidade clara |
| 70% | (proposta hibrida) | Menos punitivo que IdleOn, ainda da incentivo ativo | Burst ativo precisa ser ainda mais forte |
| 80% | hub current | Bem proximo do ativo, casual amigavel | Pouco upside para investir em "AFK rate up" |
| 95% | IEH2 | Quase identico — minimo incomodo | Praticamente nao existe incentivo de ficar ativo |

**Recomendacao**: comecar com **70% offline base para combate**, **85% para
gathering** (atividades inerentemente idle), e adicionar bonuses
escalaveis (cards, equipamento, talents) que sobem 70% -> 90% -> 110% ao
longo do jogo. Justificativa em secao 4.1.

### 3.3 [DECISAO PENDENTE: cap unico (12h global) ou cap por atividade?]

- Cookie Clicker: nao tem.
- IdleOn: cap por subsistema (combat=10h base, arcade=tem proprio, etc.).
- IEH2: cap unico via Nitro overflow.
- Hub atual ([ver: `01_design/save-offline-spec.md` secao 4.2]): 12h
  global hardcoded.

Cap por atividade e' mais elegante mas complexo de comunicar. Cap unico e'
mais legivel mas pouco flexivel.

**Recomendacao**: manter cap unico global 12h por enquanto (decisao #18 ja
resolvida). Considerar caps por atividade como **upgrade Loja Eterna no
endgame** (ex: "Cap de combate offline +24h", "Cap de gathering offline
+48h").

### 3.4 [DECISAO PENDENTE: bonus para presenca cronometrada — golden-style ou daily-style?]

| Estilo | Spawn | Duracao na tela | Efeito | Exemplo |
|---|---|---|---|---|
| Golden cookie | 5-15min | 13-52s | Buff curto x7 a x666 | Cookie Clicker `frenzy` |
| Daily quest | Reset 24h | Persistente ate claim | Recurso/EC | IEH2 dailies |
| Festival random | 1-2h, dura 5-15min | Persistente durante evento | Buff +50% | Hub current (events-catalog) |
| Invasao | 12-18h, dura 30-60min | Persistente | Drops +100-200% | Hub current |

O hub ja tem festival e invasao ([ver: `01_design/events-catalog.md`
secao 3-4]). **Falta a "golden cookie"** — um pulse rapido (15-60s) com
buff intenso (x3 a x10) que so dispara em jogo ativo.

### 3.5 [DECISAO PENDENTE: moeda do tempo (Nitro-like) ou nao?]

- IEH2: Nitro como pilar central, banking + spend.
- IdleOn: nao tem.
- Cookie Clicker: sugar lumps maturam em tempo real mas nao sao "banking".

Hub atual tem `gemas_eternidade` e `glory` ([ver:
`01_design/save-offline-spec.md` secao 1.4]) como currencies premium, mas
nenhuma e' "tempo banked".

**Recomendacao**: nao adicionar Nitro como sistema novo. Em vez disso,
usar **game_speed 2x ja existente** + futuros 4x/8x como o "spending de
tempo". Tempo offline acumulado vira **ticket de speed-up**: "+1h em 2x"
ou "+30min em 4x". Detalhado em proposta 4.4.

### 3.6 [DECISAO PENDENTE: ofuscacao do save vs cheating]

Cookie Clicker e' trivialmente cheataval (save em base64). IdleOn usa
GlobalTime do servidor (anti-relogio-cheat). IEH2 usa ES3 + versioning.

Hub atual: hash sha256 ([ver: `01_design/save-offline-spec.md` secao 3.2]).
**Recomendacao**: manter hash + adicionar:
- Clamp `now < last_save_unix`: usa `last_save_unix` como referencia se
  sistema voltou no tempo.
- Reject delta > 30 dias: provavel reset de relogio.
- Aviso visivel: "save modificado manualmente, continuar?" (ja previsto na
  spec linha 317-321).

---

## 4. Proposta para o Idle Medieval

### 4.1 Rate offline por atividade

**Tres tiers**, baseados em quao "idle-friendly" cada atividade e:

| Atividade | Rate base offline | Justificativa |
|---|---:|---|
| **Combate (active wave)** | **70%** | Player ativo tem advantage de reagir, swap target, descartar buffs. Range vs IdleOn (40%) e CC (100%) — meio-termo casual. |
| **Gathering** (mining, wood, fishing, harvesting) | **85%** | Atividade ja e' inerentemente repetitiva. Penalidade pequena. Mesma logica de IdleOn (50% base) porem mais generosa para casual. |
| **Crafting / cooking** (sistemas com timer absoluto) | **100%** | Como sugar lumps de CC — completa em tempo real, sem penalty. Persistente offline. |
| **Quests dailies / EpicCoin-equivalente** | **0%** | So dispara/claima online (como IEH2 dailies). |

**Bonuses upgradaveis** (curva inspirada em IdleOn):

```
afk_rate = base_rate × (1 + sum_bonuses_pct/100) × (1 + afk_multi/100)

onde:
- sum_bonuses_pct vem de: cards equipados, equipamento (slot reservado),
  loja eterna (upgrade "AFK Combat +10%"), pet passives, skill tree node
- afk_multi vem de: 1 fonte multiplicativa rara (ex: artefato lendario)
```

Endgame teorico: 70% × (1 + 80%) × (1 + 30%) = 70% × 1.80 × 1.30 ≈ **164%**.
Ou seja, jogador investido **bate o ativo casual em 64%**. Quem joga ativo +
investe = mantem advantage. Quem so investe e desconecta = bate quem so
joga ativo.

**Implementacao**: hub atual ja tem `combat_stats.gd` com gain modifiers
([ver: `02_math/progression-curves.md` secao Gold Gain]). Adicionar campo
`afk_rate_bonus_pct` em CombatStats, somar de cards/equip/loja/etc.

### 4.2 Cap offline

**Cap inicial 12h** ([ver: `01_design/save-offline-spec.md` secao 4.2 e
`00_meta/pending-decisions.md` #18], ja resolvido).

**Path de progressao via Loja Eterna**:

| Upgrade | Custo (Gemas) | Efeito | Disponivel apos |
|---|---:|---|---|
| Tempo Estendido I | 200 gemas | Cap 12h -> 24h | Primeiro Renascimento |
| Tempo Estendido II | 800 gemas | Cap 24h -> 48h | Renascimento 3 |
| Tempo Estendido III | 2400 gemas | Cap 48h -> 72h | Renascimento 5 |
| Tempo Eterno | 8000 gemas | Cap 72h -> 168h (7 dias) | Primeira Transcendencia |

Inspirado em IdleOn (`ArcadeTimeMax,decay,12,30,5,...`, fonte
`AFK_PROGRESSION.md` linha 241).

**Cap NUNCA cresce sozinho**. So via gemas eternas + apos milestone. Isso
casa com a logica do hub ([ver: `01_design/account-vs-character.md` — Loja
Eterna boundary]).

### 4.3 Atividades 100% AFK vs exigem presenca

**100% AFK (offline progress full)**:
- Combate em zona ja clearada (replay de stage, 70% rate).
- Gathering em spot conhecido (85% rate).
- Crafting com timer absoluto (100%).
- Pet expedicoes/sailing (quando implementado, 100% via timer).

**Exigem presenca para iniciar (mas progride offline)**:
- Combate em zona NOVA (precisa primeiro clear manual antes de offline
  contar — decisao D5 em pending, [ver: `00_meta/pending-decisions.md`]).
- Quest objectives (precisa estar em zona certa, mas combate offline conta
  kills).
- Bestiario shiny (drop e' por kill, conta offline, mas shiny e' tao raro
  que o gargalo e' kill count, nao presenca).

**Exigem presenca total (zero offline)**:
- Dailies / EpicCoin-equivalente: claim manual, reset 24h.
- Eventos cronometrados (Golden-Pulse, festival, invasao) — secao 4.5.
- Boss invocavel ([ver: `01_design/events-catalog.md` linha 28, 43, 57]
  — bosses sazonais com cooldown 24h).
- Combo de prestige (Renascimento, Transcendencia, Ascensao) — decisao
  manual do jogador.

### 4.4 Game speed como spend de tempo

Em vez de adicionar Nitro como sistema novo, **reutilizar game_speed**:

- 1x default.
- 2x ja desbloqueado.
- 4x desbloqueado apos Renascimento 1 ([ver: `00_meta/pending-decisions.md`
  #14]).
- 8x desbloqueado apos Renascimento 5.

**Cost**: nada. Game speed e' free e sempre disponivel (so unlock por
progressao).

**Trade-off**: game speed acelera o **tempo da sessao**, nao o tempo
offline. Se voce joga 30min em 2x, e' equivalente a 1h em 1x. Offline cap
ainda e' 12h reais.

**Compressao adicional (Nitro-equivalente)**:

Considerar **Tickets de Compressao** como item raro:
- "Pergaminho do Tempo": consome 1 unidade, simula 1h offline a 100% (sem
  penalty do offline rate). Drop raro em Renascimento+.
- "Cristal do Tempo": simula 6h. Drop endgame.

Exemplo: jogador esta com cap 24h, ficou 26h offline, perde 2h. Usa
"Pergaminho do Tempo" para recuperar 1h dos 2h perdidos. Soft-cap em vez
de hard-cap.

**[DECISAO PENDENTE: Tickets de Compressao — adicionar como item ou nao?]**
Adiciona complexidade mas resolve frustracao de "perdi tempo offline acima
do cap".

### 4.5 Sistema "Golden-Pulse" — bonus de presenca curto

Inspirado em golden cookies de CC (`06-golden-cookies-buffs-wrinklers.md`
linha 33-138). Pulse rapido com buff intenso so capturavel ativo.

**Mecanica proposta**:

- **Spawn**: a cada 10-20min (uniform), durante combate ATIVO no jogo. Nao
  spawna offline. Reset timer ao logar.
- **Visual**: pequeno orb dourado flutuando na tela de Battle (canvas
  layer alto).
- **Duracao na tela**: 30-60s. Some sem efeito se nao clicado.
- **Click reward** (sorteado entre):
  - "Frenesi": +200% Gold gain por 60s. (~peso 30%)
  - "Frenesi de Heroi": +300% XP gain por 60s. (~peso 30%)
  - "Sorte do Saqueador": +100% Drop chance por 60s. (~peso 20%)
  - "Furia": +500% Atk speed por 30s. (~peso 15%)
  - "Tesouro": ganho instantaneo de `min(estoque_gold*0.10, gold/h*30min)`
    (mesma logica do `Lucky!` golden cookie, `06-golden...md` linha 123).
    (~peso 5%)

**Combinacao** (CC-style "stack"):
- Frenesi + Frenesi de Heroi simultaneos = double bonus.
- Sorte + Frenesi de Heroi = janela ideal pra farmar drops + XP.
- Furia = "burst de waves" — mata mais rapido.

**Cooldown global**: nao. Se voce ficar 3h online, podem aparecer 9-18
pulses. Premia sessoes longas sem castigar curtas.

**Skip**: jogador pode toggle off em Settings (`gameplay_golden_pulse:
bool`). Acessibilidade para quem nao quer mecanica de clique.

**Hooks no codigo atual**:
- `EventBus` autoload ([ver: STATE-OF-THE-PROJECT.md secao 1]) ja tem ~25
  signals. Adicionar `golden_pulse_spawned`, `golden_pulse_clicked`,
  `golden_pulse_expired`.
- `CombatStats` recebe modifier temporario via timer (mesmo mecanismo de
  buff de food futuro).
- VFX: pequeno orb sprite com pulse animation (juicy candidato).

### 4.6 Bonus de presenca CONSISTENTE (anti-streak-burnout)

Importante: **nao punir quem so joga 20min/dia**.

**Regras**:

1. **Golden-Pulse spawn cap por sessao**: max 6 por sessao continua. Apos 6,
   pula. Reset ao desconectar 30min. Evita que jogador 8h/dia ganhe 24x
   o ganho de jogador 20min/dia em proporcao injusta.

2. **Daily bonus log-in**: primeira sessao do dia (UTC), reward fixo:
   - Dia 1: 1000 gold + 1 ticket de craft.
   - Dia 2: 2000 gold.
   - Dia 3: 1 Gema da Eternidade.
   - Dia 4: 3000 gold.
   - Dia 5: 1 Gema da Eternidade + 1 ticket.
   - Dia 7: 2 Gemas + 1 booster `+50% XP por 1h`.
   - Reset ao "miss day" — mas **NAO punir** alem do reset. Soft penalty.

   Inspirado em IEH2 daily quest (`19-meta-and-qol.md` linha 140-145) mas
   sem EpicCoin separado — usa Gemas/gold direto. Hub ja tem campo
   `cronicas_do_mundo` para milestones por dia ([ver:
   `01_design/save-offline-spec.md` secao 1.4]).

3. **Catch-up para casual**: se delta entre logins > 24h, no proximo combo
   de Golden-Pulse, garantir o primeiro pulse em ate 2min (priority spawn).
   Premia quem voltou.

4. **"Welcome back" cum**: modal de offline ja existe ([ver:
   `01_design/save-offline-spec.md` secao 4.4]). Adicionar:
   - Resumo de drops + XP + gold normal.
   - **+ Bonus de retorno**: se delta > 6h, +20% no offline computado
     (recovery bonus). Inspirado no IEH2 gainFactor (95%) invertido para
     "boost de retorno".

### 4.7 Comparativo final

| Categoria | Casual (1h/dia ativo + ~11h offline em cap) | Hardcore (8h ativo + 12h offline) |
|---|---:|---:|
| Combate ativo (1h) | 100% rate base | 800% rate base × 8h |
| Combate offline (12h) | 70% × 12h = 840% base | 70% × 12h = 840% base |
| Golden-Pulse durante ativo | ~3 pulses × 100% buff médio = +300% sobre 1h | ~24 pulses (capped 6/sessão) × 100% = +600% |
| Daily login (Gemas/gold) | +1x reward | +1x reward (mesmo) |
| **Total relativo** | **~1240% base** | **~2240% base** |

Hardcore so' tem **~1.8x** o ganho do casual com 12h cap, **nao 8x**. Isso
e' o que torna idle viavel em sessoes curtas ([ver:
`02_math/time-to-progress.md` secao 2.2]). Hub atual ja projetava ~10.6h
equivalentes/dia para casual; com a proposta, fica ~12-15h equivalentes/dia
(melhor).

Se hardcore quiser mais ganho relativo, **investe em AFK rate bonuses**
(cards, equip, loja) para que o offline cresca proporcionalmente. Isso
mantem a curva long-term aberta sem invalidar casual.

---

## 5. Hooks com docs existentes

### 5.1 Arquivos a atualizar/criar

| Doc | Mudancas necessarias |
|---|---|
| [`01_design/save-offline-spec.md`](../../01_design/save-offline-spec.md) | Secao 4.3 (Simulacao por personagem) precisa especificar `afk_rate_base = 0.70` para combat e `0.85` para gathering. Decisao pendente #5 (offline avanca zonas?) — recomendar NAO avanca, ja proposto. |
| [`02_math/time-to-progress.md`](../../02_math/time-to-progress.md) | Secao 2.2 (Quanto da progressao vem de offline) — atualizar 80% para 70% combat / 85% gathering. Secao 4.1 (Acelerador de Progressao) — adicionar "Tickets de Compressao" e "Bonus de retorno". |
| [`02_math/progression-curves.md`](../../02_math/progression-curves.md) | Adicionar formula `afk_rate = base × (1 + sum_pct/100) × (1 + multi_pct/100)`. Listar fontes de cada bonus. |
| [`01_design/events-catalog.md`](../../01_design/events-catalog.md) | Adicionar secao 5: "Golden-Pulse — bonus de presenca cronometrado". Spec spawn/duracao/efeitos como proposto em 4.5. |
| [`01_design/account-vs-character.md`](../../01_design/account-vs-character.md) | Adicionar entry de Loja Eterna: "Tempo Estendido I/II/III" e "Tempo Eterno". Custos em Gemas. |
| [`00_meta/pending-decisions.md`](../../00_meta/pending-decisions.md) | Adicionar entries: AFK rate base (3.2), bonus presenca style (3.4), Tickets de Compressao (4.4). Resolver/atualizar D5 (offline avanca zonas — recomendar NAO). |
| [`00_meta/glossary.md`](../../00_meta/glossary.md) | Adicionar: `golden_pulse`, `afk_rate_bonus_pct`, `ticket_compressao`, `tempo_estendido`. |
| [`04_phases/phase-01-core-loops.md`](../../04_phases/phase-01-core-loops.md) | Adicionar "Golden-Pulse system" como feature da fase 01 (pos-MVP). |
| [`04_phases/phase-02-expansion.md`](../../04_phases/phase-02-expansion.md) | Adicionar "Loja Eterna — Tempo Estendido I" como feature da fase 02. |

### 5.2 Codigo a tocar (autoloads e systems)

| Arquivo | Mudanca |
|---|---|
| `autoload/event_bus.gd` | Adicionar signals: `golden_pulse_spawned(reward)`, `golden_pulse_clicked(reward)`, `golden_pulse_expired()`. |
| `scripts/systems/combat_stats.gd` | Adicionar campo `afk_rate_bonus_pct: float`, somar de cards/equip/loja. Adicionar buff temporario API. |
| `scripts/systems/offline_simulator.gd` | Mudar formula de combate: `gains = active_rate × afk_rate × delta_t`, onde `afk_rate = 0.70 × (1 + bonus_pct/100)`. Mudar gathering para 0.85 base. |
| `autoload/game_state.gd` | Adicionar campo `last_daily_bonus_date: String`. Logica de dispatch de daily reward na primeira sessao do dia. |
| `scenes/views/battle_view.gd` | Adicionar nodo `GoldenPulseSpawner` que rola spawn a cada 10-20min uniform e instancia clickable. |
| Novo: `scripts/systems/golden_pulse.gd` | Sistema de pulse. Spawn timer, click handler, reward rolling, buff application via CombatStats. |
| Novo: `scenes/ui/golden_pulse.tscn` | Sprite/animation do orb dourado, click area. |

### 5.3 Decisoes pendentes desta sintese

Para serem migradas para `00_meta/pending-decisions.md` na proxima passada:

1. **[DECISAO PENDENTE: 3.2]** Rate offline base — confirmar **70% combat /
   85% gathering / 100% crafting**, ou ajustar.
2. **[DECISAO PENDENTE: 3.4]** Estilo de bonus de presenca — confirmar
   **Golden-Pulse** (CC-style burst), ou alternativa.
3. **[DECISAO PENDENTE: 4.4]** Tickets de Compressao como item drop —
   adicionar ou nao?
4. **[DECISAO PENDENTE: 4.6]** Daily login reward — tabela de 7 dias
   funciona, ou rotacao mensal?
5. **[DECISAO PENDENTE: 4.6.3]** Bonus de retorno (+20% se delta > 6h) —
   adicionar ou nao?
6. **[DECISAO PENDENTE: cap inicial — secao 3.3]** Cap unico (12h global)
   esta resolvido; cap por atividade (combate/gathering separados) e' uma
   evolucao endgame opcional via Loja Eterna.

### 5.4 Numeros que dependem de balance interno

| Numero | Default proposto | Onde decidir |
|---|---:|---|
| `afk_rate_base.combat` | 0.70 | `02_math/progression-curves.md` |
| `afk_rate_base.gathering` | 0.85 | `02_math/progression-curves.md` |
| `afk_rate_base.crafting` | 1.00 | `02_math/progression-curves.md` |
| `offline_cap_hours.base` | 12 | ja resolvido #18 |
| `offline_cap_hours.tier1_eterna` | 24 | `01_design/account-vs-character.md` |
| `offline_cap_hours.tier2_eterna` | 48 | `01_design/account-vs-character.md` |
| `offline_cap_hours.tier3_eterna` | 72 | `01_design/account-vs-character.md` |
| `offline_cap_hours.tier_max_eterna` | 168 | `01_design/account-vs-character.md` |
| `golden_pulse.spawn_min_min` | 10 | novo, `01_design/events-catalog.md` |
| `golden_pulse.spawn_max_min` | 20 | novo, `01_design/events-catalog.md` |
| `golden_pulse.duracao_s` | 30-60 (uniform) | novo, `01_design/events-catalog.md` |
| `golden_pulse.cap_por_sessao` | 6 | novo, `01_design/events-catalog.md` |
| `golden_pulse.sessao_reset_min` | 30 | novo, `01_design/events-catalog.md` |
| `daily_bonus.reward_dia_1` | 1000 gold + 1 ticket craft | novo |
| `daily_bonus.reward_dia_3` | 1 Gema da Eternidade | novo |
| `daily_bonus.reward_dia_7` | 2 Gemas + booster +50% XP/1h | novo |
| `welcome_back.bonus_pct_se_delta_6h` | 20% | novo, `01_design/save-offline-spec.md` |
| `ticket_compressao.simulate_h` | 1 | novo |
| `cristal_tempo.simulate_h` | 6 | novo |

---

## 6. Apendice — Padroes reutilizaveis dos 3 jogos

Resumo dos pattern que aparecem mais de uma vez nos 3 jogos:

1. **Soft cap > Hard cap em rate** (IdleOn cap upgradavel, IEH2 Nitro
   overflow). Hub deve seguir.

2. **Dois canais de bonus (aditivo + multiplicativo)** (IdleOn formula
   `(base + sum)/100 × multi`, `AFK_PROGRESSION.md` linha 27-32). Hub deve
   adotar para `afk_rate_bonus_pct`.

3. **Log-scaling em recursos infinitos** (IdleOn `log(maxHp)`, `log(copperOwned)`,
   `AFK_PROGRESSION.md` linha 196-198). Para cap de offline ou bonus que
   cresca com totalKills, usar log.

4. **Anti-cheat via server clock** (IdleOn `GlobalTime`,
   `AFK_PROGRESSION.md` linha 220-235). Hub usa local mas hash + clamp
   funciona equivalente.

5. **Pool fixo de drops/monsters** (IEH2 30 max,
   `17-combat.md` linha 9-22). Hub ja usa stage roster cacheado.

6. **Each subsistema com sua moeda** (CC sugar lumps, IdleOn salt/jade,
   IEH2 EpicCoin/Ruby/PortalOrb). Hub tem gold + Gemas Eternidade + Glory +
   Dungeon Tokens — alinhado.

7. **Eventos timed mas opt-in** (CC golden cookies clicaveis, IdleOn
   dailies, IEH2 EpicStore daily quest). Hub vai adicionar Golden-Pulse +
   daily login. Festivais ja existem.

8. **Bonus + curse mesmo upgrade** (IdleOn prayers `Zerg_Rushogen` vs
   `Ruck_Sack`, IEH2 loan/interest pair). Considerar para Renascimento
   choices futuros.

9. **Threshold 120s "comeca a contar AFK"** (IdleOn `AFK_PROGRESSION.md`
   linha 230-232). Hub atualmente usa 60s ([ver:
   `01_design/save-offline-spec.md` secao 4.2]). Avaliar subir para 120s.

10. **Welcome-back modal com resumo claro** (IEH2 `OfflineBonus` + summary,
    hub atual `offline_summary_modal` ja existe). Apenas adicionar bonus
    de retorno (secao 4.6).

11. **Game speed como recurso de progressao** (IdleOn talents de speed,
    IEH2 Nitro). Hub ja tem 1x/2x e plano para 4x/8x. Manter.

12. **`min(A, B)` para bottleneck duplo** (IdleOn kills/hr,
    `AFK_PROGRESSION.md` linha 152-156). Para offline simulation, considerar:
    `kills_offline = min(spawn_cap × delta_t, dps_cap × delta_t)`.

13. **DEF/MDEF -> damage via log** (IEH2 ArmoredFury, `17-combat.md` linha
    62-76). Para evitar "stat irrelevante late game". Hook em
    `02_math/damage-formula.md`.

14. **Sinergias cruzadas entre buildings/systems** (CC grandma-X upgrades,
    IEH2 town materials por species). Hub pode considerar "cards de
    inimigo X dao bonus a ferramenta Y" futuro.

15. **Multibuy bar com saltos exponenciais** (IEH2 1, 5, 10, ..., 1Q,
    `18-economy.md` linha 158-169). Hub vai precisar quando adicionar
    upgrade shop / Loja Eterna UI.

---

## 7. Notas finais

- Os 3 jogos sao consistentes: **idle < active < idle invested**. O hub
  deve seguir essa curva para nao subverter o genero.
- O ponto mais delicado e' o **rate base** (40% IdleOn vs 95% IEH2). A
  proposta de **70% combat / 85% gathering** e' meio-termo casual-friendly,
  mas pode ser ajustada apos playtest.
- O **cap de 12h** ja resolvido (#18) e' competitivo com IdleOn (10h base) e
  pode crescer para 72-168h via Loja Eterna, similar ao path do IdleOn.
- **Golden-Pulse** e' a feature mais nova proposta — sem ela, o jogo tende
  ao "passivo demais" estilo CC-base. Com ela, ganha o pulse de presenca
  ativa que CC tem com golden cookies.
- **Daily login** + **bonus de retorno** garantem que casuais (20min/dia) e
  retornantes (passou 1 semana) tenham razao para voltar sem se sentir
  punidos.
- Nenhum dos 3 jogos referencia tem mecanica de **multi-personagem
  paralelo** (IdleOn tem multi-char mas cada um faz sua coisa, nao "junto").
  O idle medieval pode explorar: **bonus se 2+ personagens estao em zonas
  diferentes simultaneamente offline** (incentiva diversificacao de farm).
  Marcar como [DECISAO PENDENTE: bonus multi-char offline?].

---

> Documento ~700 linhas. Proximas acoes:
> 1. Revisao do usuario.
> 2. Migrar decisoes pendentes para `00_meta/pending-decisions.md`.
> 3. Atualizar `progress-log.md` mencionando esta sintese.
> 4. Apos consenso, migrar valores numericos para os catalogos
>    (`02_math/progression-curves.md`, `01_design/events-catalog.md`).
