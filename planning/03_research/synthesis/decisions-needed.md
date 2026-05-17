# Decisoes Pendentes — Consolidado da Sintese

> Punch list das ~60 decisoes que apareceram nos 6 docs de sintese.
> Cada entrada lista as opcoes lado-a-lado e cita a fonte. Detalhe completo
> esta no doc de sintese de origem. Quando voce decidir, marque a entrada e
> migre o resolvido para `00_meta/pending-decisions.md` (lista canonica) ou
> para o catalogo afetado em `01_design/` ou `02_math/`.
>
> Convencoes:
> - **P0** = bloqueia trabalho da Fase 02 ja em andamento (decidir cedo)
> - **P1** = bloqueia Fase 03-04 (decidir nos proximos meses)
> - **P2** = bloqueia Fase 05+ ou e' polish (pode esperar)
> - **Default** = o que assumir se nao decidirmos antes da implementacao
> - **Fonte** = arquivo de sintese + secao

---

## 1. Stats e progressao

### 1.1 Cap de level dos personagens [P1]
- **Opcao A — IEH2-style (3000)**: cap alto cria walls naturais. Permite
  ganhar 0.1% mesmo no late-game.
- **Opcao B — IdleOn-style (sem hard cap)**: progressao geometrica indefinida.
  Requer escalonamento de zonas eternamente.
- **Opcao C — Hard cap 1000 + walls**: cap pratico de R1.0; walls em
  L100/200/350/500/750/1000 que exigem item especifico ou meta-progressao.
- **Default**: Opcao C com cap 1000.
- **Fonte**: `01-stats-and-progression.md` 3.1, 4.4.
  
  Decisão do Dev: Opcao B — IdleOn-style
  Motivo: Gosto da ideia do jogo ter que ser expansivo e não vamos mais trabalhar com sistema de reset por prestígio, ao invés disso, vamos ter elementos que aumentem a dificuldade do mundo e elementos que desbloqueiam potencial do jogador, que atuariam como prestigio, porém, não resetam o progresso.

### 1.2 Cap de level unificado entre classes? [P1]
- **A**: mesmo cap (1000) para todas as classes.
- **B**: cap diferente por classe (Warrior 1000, Mage 1200 etc).
- **Default**: A (unificado).
- **Fonte**: `01-stats-and-progression.md` 3.2.
  
  Decisão do Dev: Não teremos um "cap" como mencionado acima.

### 1.3 Curva XP — manter polinomial-exp atual ou migrar para IdleOn-style com decay? [P0]
- **A (Atual)**: `BASE * L^2 * 1.07^L`. Funcional pro MVP mas sem walls
  explicitos.
- **B (IdleOn)**: polinomial + decay assintotico, com walls explicitos a cada
  ~100 levels.
- **Default**: A para R1.0, migrar pra B antes de Fase 04 (Renascimento).
- **Fonte**: `01-stats-and-progression.md` 3.6, 4.3.
  
  Decisão do Dev: Migrar para a opção B

### 1.4 Walls progressivos de XP em L100/200/...? [P0]
- **A**: sim, multiplicar custo por 2x/3x/5x em thresholds.
- **B**: nao, curva contínua suaviza naturalmente.
- **Default**: A — walls em L100 (2x), L250 (3x), L500 (5x), L1000 (10x).
- **Fonte**: `01-stats-and-progression.md` 3.7, 4.3.
  
  Decisão do Dev: Opçao A

### 1.5 Cross-stat para accuracy (IdleOn-style)? [P1]
- **A**: stat principal contribui pra ATK, stat secundario contribui pra
  ACCURACY (cria builds hibridas).
- **B**: ACCURACY e' apenas atributo derivado de DEX.
- **Default**: B em R1.0. Reavaliar em Fase 03 quando classes hibridas
  chegarem.
- **Fonte**: `01-stats-and-progression.md` 3.4.
  
  Decisão do Dev: Creio que a opção A seja a melhor escolha, para fazer com que o jogador não invista apenas em um stat mantendo uma build muito linear.

### 1.6 Adicionar DEF / MDEF / MP hibridos (cada um derivado de 2 atributos)? [P0]
- **A (IEH2-style)**: DEF = (VIT+STR)/2, MDEF = (VIT+INT)/2, MP = (INT+VIT)/2.
- **B (atual)**: stats so vem de equipamento.
- **Default**: A. Adicionar na proxima rodada de combat tuning.
- **Fonte**: `01-stats-and-progression.md` 3.5, 4.2.
  
  Decisão do Dev: Utilizar a opção A e baseando-se na sua recomendação.

### 1.7 Mastery (RNG dampening por kill count na zona)? [P2]
- **A (IdleOn)**: cada kill diminui variance do drop em 0.01% ate cap. Apos N
  kills, drops viram garantidos.
- **B (sem)**: drops sao sempre roll RNG.
- **Default**: A — implementar na Fase 03.
- **Fonte**: `01-stats-and-progression.md` 3.8.
  
  Decisão do Dev: Utilizar a opção A

### 1.8 Cap de resistencias elementais [P0]
- **A**: 90% (IEH2).
- **B**: 75%.
- **Default**: A (90%). Inimigos endgame podem ter "armor pierce" pra furar.
- **Fonte**: `01-stats-and-progression.md` 3.10.
  
  Decisão do Dev: Utilizar a opção A

### 1.9 LUK +0.5% crit/pt — manter ou reduzir? [P0]
- **A (atual)**: +0.5%/pt — chega a 100% crit em L200 puro LUK.
- **B**: +0.1%/pt — cap natural em ~50% em L500.
- **Default**: B + cap mole de crit em 75% via funcao logistica.
- **Fonte**: `01-stats-and-progression.md` 4.1.
  
  Decisão do Dev: Utilizar a opção B

### 1.10 ArmoredFury/WardedFury como node de Awakening? [P2]
- Mecanica IEH2 que converte stat sobrando em offensive. Resolve "DEF
  inutilmente alta tarde no jogo".
- **Default**: implementar como awakening node em Fase 04.
- **Fonte**: `01-stats-and-progression.md` 4.8, `03-combat-classes-skills.md` 3.14.
  
  Decisão do Dev: Pode ser.
  
---

## 2. Ativo vs idle

### 2.1 Rate offline base — 40%, 50%, 70% ou 95%? [P0]
- **A (IdleOn-like, 40%)**: idle e' claramente inferior a ativo. Combate ativo
  da 2.5x mais XP que offline.
- **B (IEH2-like, 95%)**: idle quase iguala ativo. Bom pra casual.
- **C (Recomendacao mid)**: 70% combat / 85% gathering / 100% crafting.
- **Default**: C.
- **Fonte**: `02-active-vs-idle-balance.md` 3.2, 4.1.
  
  Decisão do Dev: Pode ser a opção C, que mantém entre os 2

### 2.2 Cap offline unico (12h global) ou por atividade? [P1]
- **A**: 12h global (decisao #18 ja resolvida).
- **B**: 12h combat, 24h gathering, infinito crafting.
- **Default**: A para R1.0. B vira evolucao endgame via Loja Eterna.
- **Fonte**: `02-active-vs-idle-balance.md` 3.3, 4.2.
  
  Decisão do Dev: Mantenha a opção A

### 2.3 Sistema Golden-Pulse (buff cronometrado curto)? [P0]
- Bonus curto (30-60s) que aparece em 10-20min, cap 6/sessao. Inspirado em
  CC golden cookies.
- **Default**: SIM. Implementar na Fase 02. Drop: bau brilhante que aparece
  na zona; clicar = +200% drops/XP/gold por 30s.
- **Fonte**: `02-active-vs-idle-balance.md` 4.5.
  
  Decisão do Dev: Sim! Alinha-se com minha ideia, já estava pensando em colocar baús que aparecem com o tempo para o jogador coletar.

### 2.4 Daily login reward — tabela de 7 dias? [P1]
- **Default**: SIM. Dia 1: 10 gemas. Dia 7: bau raro + 50 gemas. Reseta em
  semana cheia perdida; bonus +20% se voltou apos 6h+ ausente.
- **Fonte**: `02-active-vs-idle-balance.md` 4.6.
  
  Decisão do Dev: Não, ao invés disso, podemos ter na loja uma recompensa diária que entrega gemas da eternidade para o jogador, em uma quantidade não tão grande, porém a longo prazo, o jogador pode conseguir ajustar com as outras gemas que ganha no jogo para poder consolidar seus upgrades.

### 2.5 Tickets de Compressao (time-skip item dropavel)? [P2]
- IEH2 chama de Nitro. IdleOn de Time Candy.
- **Default**: SIM em Fase 03. Tickets de 1h/4h/24h sao craftaveis raros +
  vendidos na Loja Eterna.
- **Fonte**: `02-active-vs-idle-balance.md` 4.4.
  
  Decisão do Dev: Sim, gostei desse formato de itens que dão saltos de tempo, mas também gosto da ideia de gastar um recurso específico para acelerar o tempo, creio que podemos deixar as duas ideias no jogo. Porém o recurso de aceleração de tempo sendo desbloqueado em uma outra fase do jogo, através de um artefato, não logo de inicio.

### 2.6 Bonus multi-character offline (jogar com 3 chars rende 3x)? [P1]
- IdleOn faz: cada personagem farma sua zona em paralelo.
- **Default**: SIM. Cap de offline e' por personagem, nao por conta.
- **Fonte**: `02-active-vs-idle-balance.md` 7.
  
  Decisão do Dev: Não, cada personagem defe farmar seus próprios recursos.

### 2.7 Ofuscar save vs hash only? [P2]
- **A**: so hash (atual).
- **B**: ofuscacao base64 + hash.
- **Default**: A. Revisitar se cheating virar problema.
- **Fonte**: `02-active-vs-idle-balance.md` 3.6.
  
  Decisão do Dev: Faça de acordo com sua recomendação.

---

## 3. Combate, classes e habilidades

### 3.1 Numero de classes em R1.0 [P0]
- **A**: 3 (Warrior/Mage/Ranger).
- **B**: 5 (+ Rogue, Cleric).
- **C**: 7+ (IdleOn-style).
- **Default**: A. R1.5 adiciona 2. R2.0 adiciona 2.
- **Fonte**: `03-combat-classes-skills.md` 4.1.
  
  Decisão do Dev: De inicio o jogo vai ter 4 classes por padrão, podendo ser melee, mage, ranged e a ultima classe se pareceria um pouco com a classe "beginner/maestro" do Idleon, onde o jogador deverá jogar com personagem desequipado até certo ponto, para liberar uso as armas da classe, que serão luvas e soqueiras. Vamos nomea-la de "monk". A ideia final é que as classes tenham evoluções com ramificações de especialização, assim como no Idleon.

### 3.2 Awakening como promotion tree ou passive tree? [P1]
- **A (IdleOn-style)**: classe evolui em sub-classe (Warrior -> Berserker ou
  Paladin).
- **B (IEH2-style)**: classe fixa, tree de talentos branched.
- **Default**: B em R1.0. Awakening como sistema de passive tree adicional na
  Fase 04.
- **Fonte**: `03-combat-classes-skills.md` 3.1, 4.11.
  
  Decisão do Dev: Como não vamos mais ter mecânicas de reset, só de evolução de mundo e quebra de limite do personagem, acho que devemos manter o estilo de IdleOn, podendo evoluir a classe no momento da quebra de limite.

### 3.3 Skills por classe — 20 (IdleOn) ou 30 (IEH2)? [P1]
- **Default**: 18 (3 ramos x 6 nodes) em R1.0. Cada node tem 3 ranks =
  54 SP/classe.
- **Fonte**: `03-combat-classes-skills.md` 3.2, 4.3.

### 3.4 Skill points so via level-up ou tambem investimento de gold/stone? [P1]
- **A**: so level-up (1 SP/level).
- **B (IEH2)**: SP via level + investimento de skill_stone.
- **Default**: A em R1.0. B em Fase 03 (skill_stone dropa de boss).
- **Fonte**: `03-combat-classes-skills.md` 3.3.

### 3.5 Cooldown system: por skill ou recurso global (mana)? [P0]
- **A**: cooldown individual por skill (atual planejado).
- **B**: pool de mana compartilhado.
- **Default**: A. Mana so como recurso de cast custom de elementais especiais.
- **Fonte**: `03-combat-classes-skills.md` 3.5, 4.6.

### 3.6 Status effects — 11 (planejado) ou 24 (IEH2)? [P1]
- **Default**: 11 em R1.0 (poison/burn/freeze/shock/stun/slow/silence/bleed/
  curse/buff_atk/buff_def). Adicionar 5 tematicos medievais em R1.5 (Wet,
  Frostbitten, Holy_smite, etc).
- **Fonte**: `03-combat-classes-skills.md` 3.6, 4.8.

### 3.7 Elementos — 6 (IEH2) ou 8 (planejado)? [P0]
- **A**: 6 — Fire/Ice/Lightning/Water/Earth/Light_or_Dark.
- **B**: 8 — Fire/Ice/Lightning/Water/Earth/Wind/Light/Dark.
- **Default**: B no codigo. Gating por zona (Forest=Fire/Ice/Water,
  Desert=+Wind/Earth, Caverns=+Lightning, Crypt=+Light/Dark).
- **Fonte**: `03-combat-classes-skills.md` 3.7, 4.7.

### 3.8 Pet/Summon system em R1.0? [P1]
- **Default**: NAO em R1.0. Necromancer/Beastmaster aparecem em R1.5+. Pets
  como sistema separado em Fase 04.
- **Fonte**: `03-combat-classes-skills.md` 3.8.

### 3.9 Channeled skills (manter buff ativo enquanto canaliza)? [P2]
- IEH2 tem; IdleOn nao.
- **Default**: NAO em R1.0. Considerar em R2.0.
- **Fonte**: `03-combat-classes-skills.md` 3.9.

### 3.10 Skill tree shape — linear, branched ou grid? [P0]
- **A (linear A->B->C)**: simples, baixa decisao.
- **B (branched 3 ramos)**: media decisao, baixo respec cost.
- **C (grid)**: alta decisao, respec caro.
- **Default**: B com ranks por node (1-3 ranks cada).
- **Fonte**: `03-combat-classes-skills.md` 3.10, 4.3.

### 3.11 Ranks por node — 1 (binary unlock) ou 5? [P1]
- **Default**: 3 ranks. Suficiente decisao sem inflar SP requirements.
- **Fonte**: `03-combat-classes-skills.md` 4.3.

### 3.12 Class family bonuses (IdleOn-style)? [P2]
- **Default**: NAO em R1.0. Implementar em R1.5+ depois de 5 classes.
- **Fonte**: `03-combat-classes-skills.md` 3.11.

### 3.13 Soft cap de dano [P0]
- IEH2 usa formula `5k^0.9 + 25k^0.8`. IdleOn usa duplos soft caps.
- **Default**: aplicar soft cap em ATK final, nao em stat raw. Constante
  `cap_factor = 5000` antes do decay.
- **Fonte**: `03-combat-classes-skills.md` 3.13, 4.9.

### 3.14 Hit types — 6 (Normal/Crit/Block/Dodge/Miss/Heal) ou 7 (+ Glance)? [P1]
- **Default**: 6 em R1.0.
- **Fonte**: `03-combat-classes-skills.md` 4.10.

### 3.15 Challenge system (handicap mode)? [P2]
- **Default**: SIM em R1.5+.
- **Fonte**: `03-combat-classes-skills.md` 3.15.

### 3.16 Hotbar slots em R1.0 [P1]
- Quantas skills equipadas simultaneamente?
- **Default**: 6 slots (4 active + 2 ultimate).
- **Fonte**: `03-combat-classes-skills.md` 4.5.

---

## 4. Items, crafting e equipment

### 4.1 Tiers de equipment por slot — manter 6 raridades ou adicionar 3 variantes nomeadas? [P0]
- **A**: 6 raridades x 1 variante = 6 items por slot.
- **B**: 6 raridades x 3 variantes nomeadas = 18 items por slot.
- **Default**: A em R1.0. B em Fase 03+.
- **Fonte**: `04-items-crafting-equipment.md` 3.1, 4.1.

### 4.2 Drop rate model — per-kill chance OU kill_count threshold? [P0]
- **A**: per-kill chance (atual).
- **B (IdleOn)**: drop libera apos N kills do mesmo inimigo.
- **Default**: A + adicionar campo `unlocks_at_kill_count` em LootEntry pra
  alguns drops raros.
- **Fonte**: `04-items-crafting-equipment.md` 3.2, 4.5.

### 4.3 Crafting graph: 2-3 niveis (MVP) ou 4 niveis (Master Recipes)? [P1]
- **Default**: 2-3 niveis em R1.0. 4 niveis em Fase 04+ via Master Recipes
  descobertos por NPC ou drop.
- **Fonte**: `04-items-crafting-equipment.md` 3.3, 4.3.

### 4.4 Upgrade pos-drop — enchant + gem + level (atual) ou +forge + evolution? [P1]
- 5 camadas propostas: Enchant (F02), Gems (F02), Maestria (F03), Forge (F04),
  Evolution (F05).
- **Default**: SIM, todas as 5 conforme fase. Confirmar adoption antes de F02.
- **Fonte**: `04-items-crafting-equipment.md` 3.4, 4.2.

### 4.5 Level de Maestria — global (account) ou per-personagem? [P1]
- **A**: global. Item se beneficia em qualquer hero que equipa.
- **B**: per-personagem. Item upa so com o hero que usa.
- **Default**: A (global) — incentiva sharing de items.
- **Fonte**: `04-items-crafting-equipment.md` 4.2.3.

### 4.6 Encantamento consome slot permanente ou pode ser reciclado? [P1]
- **A (IEH2)**: cada enchant consome 1 slot do item, irreversivel.
- **B (IdleOn)**: enchants podem ser removidos com material raro.
- **Default**: A com max 3 slots de enchant per item.
- **Fonte**: `04-items-crafting-equipment.md` 4.8.3.

### 4.7 Slots de consumables equipados [P0]
- **Default**: 4 slots em F02, 6 slots em F03 via Loja Eterna.
- **Fonte**: `04-items-crafting-equipment.md` 3.5, 4.4.

### 4.8 Consumables: auto-trigger ou click manual? [P0]
- **A (IEH2)**: condicao auto-trigger (ex: HP<30% -> usa healing pot).
- **B**: click manual.
- **Default**: A com condicoes configuraveis. Manual como override.
- **Fonte**: `04-items-crafting-equipment.md` 4.4.

### 4.9 Currencies endgame — quantas? [P1]
- IEH2 tem 6 tiers de currency. IdleOn tem ~10.
- **Default**: 6 — gold (atual), gem (premium), shard (Renascimento),
  catalyst (forge), star (evolution), eternal_essence (Loja).
- **Fonte**: `04-items-crafting-equipment.md` 3.7, 4.7.

### 4.10 Sets — IdleOn-style flexivel ou IEH2-style full-set? [P1]
- **A**: bonus parcial em 2, 4, 6 pecas (flexivel).
- **B**: bonus so com set completo.
- **Default**: A.
- **Fonte**: `04-items-crafting-equipment.md` 3.9, 4.6.

### 4.11 Tier de potion segue familia x tier x elemento? [P2]
- IEH2-style: 5 familias (HP/MP/STR/etc) x 5 tiers x opcional elemento.
- **Default**: SIM em F03.
- **Fonte**: `04-items-crafting-equipment.md` 4.4.

---

## 5. Zonas, inimigos, quests, NPCs

### 5.1 Zonas para R1.0 — 5 ou 6? [P0]
- `release-plan.md` diz 5, `enemies-catalog.md` tem 6.
- **Default**: 6 com Zona 6 (Templo Celestial) marcada como stretch goal R1.1.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.1.

### 5.2 Estrutura interna — zone/area/stage (atual 3 niveis) ou zone/stage (2 niveis)? [P0]
- **A**: 3 niveis (atual).
- **B**: 2 niveis (zone -> stage com waves). MapModal mostra so zone+stage.
- **Default**: B visivelmente, manter `area` internamente como agrupador
  opcional.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.2, 4.1.

### 5.3 Variantes de inimigo — 4 EnemyData separados (atual) ou 1 com color_variants? [P2]
- **Default**: manter 4 separados (KISS). Refactor so se cores explodirem.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.3.

### 5.4 Main quests pra R1.0 — 60 (planejado) ou 30 (recomendado)? [P0]
- **Default**: 30 (5 por zona x 6 zonas).
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.4.

### 5.5 Quests de classe (Warrior-only etc)? [P2]
- **Default**: NAO em R1.0. R1.1+ quando 5 classes balanceadas.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 4.3.6.

### 5.6 Titulos com bonus mecanico ou so cosmetico? [P1]
- **A**: cosmetico only.
- **B**: bonus pequeno (1-5%) + cosmetico.
- **Default**: B com 20 titulos R1.0.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.5, 4.5.5.

### 5.7 Steam achievements pra R1.0 [P1]
- **Default**: 25 core achievements. Lista exata em sintese 4.5.3.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.6.

### 5.8 NPCs itinerantes aparecem na zona ou no Acampamento? [P1]
- **Default**: na zona (em area especifica). Quest fica no log mesmo apos
  sair.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.7.

### 5.9 Eventos sazonais — drops permanentes ou expiram? [P2]
- **Default**: permanentes uma vez ganhos (Cookie Clicker-style).
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.8.

### 5.10 Area Prestige (IEH2 feature) — em qual release? [P2]
- **Default**: post-2.0.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.9.

### 5.11 Super Dungeon / Challenges — em qual release? [P2]
- **Default**: 3.0+.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 3.10.

### 5.12 EnemyData precisa `display_scale: float`? [P1]
- **Default**: SIM. Bosses usam 2.0+.
- **Fonte**: `05-zones-enemies-quests-npcs.md` 4.2.4.

---

## 6. Meta-progressao, pets, eventos

### 6.1 Quantas camadas de prestige — 1, 2 ou 3? [P0]
- **A**: 1 (so Renascimento).
- **B**: 2 (Renascimento + Transcendencia).
- **C**: 3 (Renascimento + Transcendencia + Ascensao Cosmica). Roadmap atual.
- **Default**: C com Fase 03/04/05. IEH2 tem 5 camadas e nao recomenda
  replicar.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.1, 4.1.

### 6.2 1o rebirth disponivel em qual level? [P0]
- **Default**: L100. Em ~6-8h de jogo casual.
- **Fonte**: `06-meta-progression-and-mechanics.md` 4.2.

### 6.3 Cristal Eterno (analog Sugar Lumps — moeda de tempo real)? [P1]
- Calendar-based currency que persiste entre rebirths. CC: 20-24h pra ganhar 1
  unit.
- **Default**: SIM em F04. 1 Cristal a cada 18h real.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.2, 4.3.

### 6.4 Pets — sistema MVP em R1.0 ou skipar pra R1.1+? [P1]
- **Default**: skipar R1.0. MVP em R1.1 com 1 eixo de XP (sem Loyalty, sem
  auto-jobs). Loyalty + jobs em F04+.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.3, 4.4.

### 6.5 Pets — Loyalty como segundo eixo de XP? [P2]
- IEH2-style: XP cresce com tempo equipado, nao so com kills.
- **Default**: SIM em F04+.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.3.

### 6.6 Sistema Card-like (album com bonus por kill count)? [P1]
- IdleOn faz: matar 100x slime libera card; card da +X% bonus permanente.
- **Default**: SIM em F03. 1 card por especie de inimigo.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.4.

### 6.7 Chakra (loja de Renascimento) tamanho [P2]
- IEH2 tem ~110 upgrades. CC tem 84.
- **Default**: 50-100 upgrades. Comecar em 50 em F03 e expandir.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.5.

### 6.8 Festivais aplicam buff auto OU jogador precisa clicar? [P0]
- **A**: auto. Festival comeca, buff aplica.
- **B**: clicar (golden-cookie style, presenca recompensada).
- **Default**: A pra Festivais (cronometrados em datas). B para Golden-Pulse
  (drops aleatorios em-zona).
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.6.

### 6.9 Wrinkler-style (coletor passivo com payout)? [P2]
- CC: wrinklers chupam producao mas ao matar devolvem 1.1x. Investimento
  reverso.
- **Default**: NAO em R1.0. Considerar como "Coletor Sombrio" em R2.0.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.7.

### 6.10 Guild como meta-personagem (IEH2-style)? [P2]
- IEH2 Guild tem 26 abilities + 20 super, age como "8o hero".
- **Default**: NAO em R1.0. Em R2.0 introduzir "Decreto do Reino" (3 ativos
  de buff global).
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.8.

### 6.11 Loja Eterna — aceitar lootbox? [P1]
- "Caixa do Aventureiro" com loot RNG.
- **Default**: NAO. Apenas items determinísticos: time-skip, slots, respec,
  cosmeticos, pacotes USD.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.9.

### 6.12 Loja Eterna — items minimum-viable em R1.0 [P0]
- **Default**: 11 items — Ticket 1h, Ticket 4h, Ticket 24h, Slot Inv+5,
  Slot Char+1, Respec Skill, Respec Stat, 3 cosmeticos, 2 pacotes USD.
- **Fonte**: `06-meta-progression-and-mechanics.md` 4.6.

### 6.13 Timers de craft/gather/expedicao — quanto e' "longo"? [P1]
- **Default**: craft basico 30s-5min, craft master 30min-4h, expedicao 6-12h.
- **Fonte**: `06-meta-progression-and-mechanics.md` 3.10.

### 6.14 Save split (S vs SR — atual vs renascimento)? [P2]
- IEH2 mantem 2 saves: atual e ultima renascimento.
- **Default**: NAO em R1.0 (so save atual). SIM em F04.
- **Fonte**: `06-meta-progression-and-mechanics.md` 2.6.

---

## Apendice: priorizacao recomendada para a proxima sessao

### Decidir AGORA (P0 — bloqueiam Fase 02 que ja esta em andamento)
1.3, 1.4, 1.6, 1.8, 1.9 (stats/curva)
2.1, 2.3 (idle balance)
3.1, 3.5, 3.7, 3.10, 3.13 (combate basico)
4.1, 4.2, 4.7, 4.8 (items)
5.1, 5.2, 5.4 (zonas/quests)
6.1, 6.2, 6.8, 6.12 (meta layer)

Total: **22 decisoes P0**.

### Decidir em ate 1 mes (P1)
- Tudo marcado [P1] acima.

### Pode aguardar (P2)
- Mecanicas de F04-F05 e cosmeticas.

---

## Como usar este doc

1. Voce le, decide P0 primeiro.
2. Cada decisao confirmada migra pra `00_meta/pending-decisions.md` (lista
   canonica do projeto) marcando-a como resolvida + cita o doc-fonte da
   sintese.
3. Mudancas resultantes em catalogo (ex: 4.1 muda `equipment-catalog.md`)
   sao atualizadas em PR ou diretamente.
4. Apos resolver todos os P0, o `progress-log.md` ganha entrada nova
   "Decisoes pos-sintese aplicadas".
