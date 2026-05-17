# Reference Games - Catalogo de Jogos Pesquisados

> **Nota metodologica importante:** As ferramentas de busca externa (`mcp__brave-search__*`) foram negadas durante esta sessao. O conteudo abaixo foi compilado a partir do conhecimento previo do agente (cutoff janeiro 2026) e cita URLs de wikis publicas conhecidas. Nao foi possivel verificar links/screenshots em tempo real - o usuario deve revisar as URLs e validar antes de compromissos de design baseados nelas. Marcacoes `[VERIFICAR]` sinalizam onde uma checagem manual e' especialmente recomendavel.

---

## Indice

- [1. Cookie Clicker](#1-cookie-clicker)
- [2. NGU Idle](#2-ngu-idle)
- [3. Melvor Idle](#3-melvor-idle)
- [4. Legends of IdleOn (IdleOn MMO)](#4-legends-of-idleon-idleon-mmo)
- [5. Idle Skilling](#5-idle-skilling)
- [6. Idle Slayer](#6-idle-slayer)
- [7. Crusaders of the Lost Idols](#7-crusaders-of-the-lost-idols)
- [8. Realm Grinder](#8-realm-grinder)
- [9. Idle Heroes](#9-idle-heroes)
- [10. Almost a Hero](#10-almost-a-hero)
- [11. Idle Champions of the Forgotten Realms](#11-idle-champions-of-the-forgotten-realms)
- [12. AFK Arena](#12-afk-arena)
- [13. Genshin Impact](#13-genshin-impact)
- [14. Honkai: Star Rail](#14-honkai-star-rail)
- [15. Tower of Fantasy](#15-tower-of-fantasy)
- [16. Path of Exile](#16-path-of-exile)
- [17. Diablo 4](#17-diablo-4)
- [18. Last Epoch](#18-last-epoch)
- [19. Grim Dawn](#19-grim-dawn)
- [20. Lost Ark](#20-lost-ark)
- [21. MapleStory](#21-maplestory)
- [22. Tibia](#22-tibia)
- [23. RuneScape (RS3)](#23-runescape-rs3)
- [24. Old School RuneScape](#24-old-school-runescape)
- [25. Albion Online](#25-albion-online)
- [26. Milky Way Idle](#26-milky-way-idle)
- [27. Idle Iktah](#27-idle-iktah)
- [28. World of Warcraft](#28-world-of-warcraft)

---

## 1. Cookie Clicker

- **Ano:** 2013 - Web/Steam (PC, Android via ports)
- **Wiki oficial / Fandom:** https://cookieclicker.fandom.com/wiki/Cookie_Clicker_Wiki

### Proposta core
O incremental seminal. Voce produz cookies clicando, depois compra geradores que clicam por voce. A graca esta em camadas progressivas: cada algumas horas um novo subsistema (Garden, Stock Market, Pantheon, Dragon, Grandmas variants, Wrinklers) e' revelado, mantendo a sensacao de descoberta por centenas de horas.

### Sistemas aplicaveis ao nosso projeto
- **Curva exponencial de custos** com base ~1.15: ver roadmap secao 1.4 (loops aninhados) e 3.16 (evolucao do Acampamento). E' o "default mathematicamente seguro" pra qualquer custo escalavel.
- **Mini-jogos como subsistemas opcionais**: padrao perfeito pras nossas Mecanicas de Bonus (4.x). Garden e Pantheon nao sao requisitos pra progredir, mas multiplicam quem se engaja. Mapeia direto pra Forja Cosmica, Biblioteca dos Antigos, Espelho dos Gemeos.
- **Heavenly Chips / Prestige**: dinheiro de prestigio que da % global. Forma simples e testada, similar ao nosso Renascimento (3.19) com estrelas.
- **Achievements visiveis como progresso**: cada acao gera achievements, alguns com bonus passivo. Reforca nosso 3.21 (Selos) e 3.22 (Titulos).
- **Sugar Lumps**: recurso lento (1 a cada ~22h reais) que da meta-decisao "onde gastar". Util pra pensarmos em Gemas da Eternidade nao acumulaveis trivialmente.

### Anti-padroes a evitar
- **Idle puro extremo:** Cookie Clicker pode ficar 12+ horas sem decisao real. Para nosso jogo de auto-battle com builds, queremos decisao a cada sessao, nao uma vez por dia.
- **Densidade de UI sem onboarding:** late-game vira tela explodindo de numeros. Precisamos de UI progressiva.
- **Achievements "shadow"** (escondidos arbitrariamente): frustram. Os nossos devem dar dica.

### Screenshots de UI relevante
- [VERIFICAR] Pagina principal da wiki em https://cookieclicker.fandom.com/wiki/Cookie_Clicker_Wiki normalmente exibe um screenshot do main game.
  - **Mostra:** painel esquerdo com cookie gigante, painel central com upgrades, painel direito com lista de buildings. Layout em 3 colunas.
- [VERIFICAR] https://cookieclicker.fandom.com/wiki/Garden
  - **Mostra:** mini-grade de plantio com timers, exemplo de subsistema autocontido dentro do jogo principal.

---

## 2. NGU Idle

- **Ano:** 2017 (web), 2019 Steam (PC)
- **Wiki oficial / Fandom:** https://ngu-idle.fandom.com/wiki/NGU_Idle_Wiki

### Proposta core
Idle de paquidermes de prestigio. NGU = "Number Go Up". Cada feature e' uma curva propria com nome unico (NGU, Hacks, Wishes, Augments, Quests, Adventure, ITOPOD, Rebirth, Sadistic Rebirth). O design fala "voce nunca termina, sempre tem mais uma camada".

### Sistemas aplicaveis ao nosso projeto
- **Curvas multiplas de prestigio aninhadas**: Rebirth → Sadistic. Aplica direto na nossa secao 3.19 (Renascimento → Transcendencia → Ascensao Cosmica).
- **Time Machine**: investimento que rende com tempo real, nao com active play. Mapa pra nosso offline progression (3.10).
- **ITOPOD (Infinite Tower of Pain and Death)**: torre infinita com escalamento polinomial de stats - referencia pra escalar Arena dos Gladiadores (3.25) infinitamente sem quebrar.
- **Beards / Hacks com decay temporal**: multiplicadores que ficam mais lentos quanto mais alto o nivel. Util pra "soft cap" de stats (impedindo broken builds em mid-game).
- **Equipment Loadouts**: presets nomeados de gear pra rapida troca entre conteudos diferentes. Aplica em Dungeon Party (3.24) e Arena.

### Anti-padroes a evitar
- **UI hostil ao iniciante**: sopa de abas e numerinhos sem onboarding. Nosso Codex (3.27) precisa onboardar progressivamente.
- **Renomear features sem necessidade ("NGU", "Wandoos", "Macguffins"):** nomes confundem se nao houver contexto narrativo. Nossos nomes seguem fantasy/tematica medieval.
- **Reset da progressao sem retorno justo**: alguns rebirths em NGU exigem comprometimento de dezenas de horas pra "voltar" ao ponto que estava. Nossas estrelas (3.19) precisam dar boost imediato perceptivel.

### Screenshots
- [VERIFICAR] https://ngu-idle.fandom.com/wiki/Adventure
  - **Mostra:** zona de combate ativo com inimigo central, barras grandes de HP, botoes de skill numerados.
- [VERIFICAR] https://ngu-idle.fandom.com/wiki/NGU
  - **Mostra:** lista de NGUs com niveis. Layout extremamente denso, muitas barras lado a lado.

---

## 3. Melvor Idle

- **Ano:** 2019 (browser), 2021 Steam, 2022 Mobile
- **Wiki oficial:** https://wiki.melvoridle.com

### Proposta core
RuneScape-like reduzido a essencia idle. 29 skills (9 combat + 20 nao-combat), todas evoluem em paralelo, sem prestigio (decisao deliberada do dev). Progressao pura por mastery e desbloqueio horizontal.

### Sistemas aplicaveis ao nosso projeto
- **Mastery por item especifico, nao so por skill**: cada peixe, cada arvore, cada minerio tem seu nivel 1-99 proprio. Aplicacao direta em nossa 3.9 (Coleta) - nao usar so "Fishing 1-99", mas "Truta 1-99", "Tubarao 1-99", etc.
- **Township**: sistema de "vilarejo" ecoacopiado. Espelha nosso Acampamento (3.16). Estagios de evolucao funcionam.
- **Combat triangle (Melee/Ranged/Magic) + Slayer mods**: simples mas profundo, vale comparar com nosso sistema de tipos de ataque (Slash/Stab/Crush/Magic/Pierce/Lacerate em 3.2).
- **Offline progression honesto (24h)**: limite alto + log retroativo. Nosso modelo (3.10).
- **Dungeons como conteudo finito de skill check**: nao infinitos como ITOPOD; tem boss e drop especifico. Aplica em nossas Dungeons (3.24).

### Anti-padroes a evitar
- **Visual demasiadamente sobrio**: o jogo da pouco feedback de impacto, pouco efeito visual em crit/kill. Nosso 1.3 ja preve "combate visualmente legivel" - nao podemos repetir esse erro.
- **Mastery levels lentissimos no late-game**: ate ficar quase impossivel completar. Cuidado com curvas exponenciais de Mastery.

### Screenshots
- [VERIFICAR] https://wiki.melvoridle.com/w/Combat
  - **Mostra:** tela de combate centralizada, status do player a esquerda, status do inimigo a direita, log de combate abaixo. Layout que vale replicar.
- [VERIFICAR] https://wiki.melvoridle.com/w/Mastery
  - **Mostra:** tabelas extensas de mastery por item dentro de uma skill. Padrao UI util pra Codex.

---

## 4. Legends of IdleOn (IdleOn MMO)

- **Ano:** 2021 Steam, mobile
- **Wiki:** https://idleon.wiki  e  https://legendsofidleon.fandom.com/wiki/Legends_of_IdleOn_MMO_Wiki

### Proposta core
A referencia mais direta pro nosso paradigma. Multiple characters (ate ~10) farmando em paralelo. Cada classe e' melhor em certas atividades. Stamps e bribes dao buffs globais. Cards equipaveis. World by world progression (cada world tem suas mecanicas exclusivas).

### Sistemas aplicaveis
- **Roster ate 10 personagens em paralelo**: aplicacao direta em 3.10. IdleOn provou o paradigma.
- **Stamps**: itens de drop raro que dao buff globais permanentes. Mapeia para nossos Selos (3.21) ou Bestiario kill stack rewards (3.15).
- **Cards equipaveis em sets**: nossa secao 3.14 ja segue isso direto.
- **Talents Books / Star Talents**: alguns talents de uma classe podem ser equipados por outras via livros. Sugestao pra nossa Skill Tree (3.11): permitir "talent books" cross-class de tier raro.
- **Anvil**: producao automatica de items com filas. Util pra crafting passivo - vale virar feature do nosso Acampamento (Forja com fila).

### Anti-padroes a evitar
- **Densidade de mecanicas sem onboarding**: IdleOn tem dezenas de subsistemas e zero tutorial coeso. Nosso Codex (3.27) deve atuar como onboarding ativo.
- **Premium currency com pressao**: gemas no IdleOn sao agressivamente vendidas pra acelerar timers. Nosso modelo nao-pay-to-win em 3.18 deve evitar isso.
- **Bugs persistentes do vivo-mas-instavel**: jogo lanca features com pressa. Nosso roadmap por fase deve estabilizar.

### Screenshots
- [VERIFICAR] https://idleon.wiki/wiki/Main_Page
  - **Mostra:** sprites pixel art de varios personagens em telas separadas, UI de menus laterais em estilo cartoon.
- [VERIFICAR] https://legendsofidleon.fandom.com/wiki/Cards
  - **Mostra:** grid de cards com tiers, set bonuses sinalizados visualmente.

---

## 5. Idle Skilling

- **Ano:** 2019 web, 2020 Steam
- **Wiki:** https://idle-skilling.fandom.com/wiki/Idle_Skilling_Wiki

### Proposta core
Mesmo dev de IdleOn, versao solo. Mistura Skilling (mining, fishing, etc.) com combate. Pets sao centrais: tem raids de pets, expedicoes, pets ativos no farm.

### Sistemas aplicaveis
- **Pet raids como mini-conteudo**: pets fazem suas proprias dungeons enquanto personagem faz outra coisa. Mapeia pra nossa 3.13 (Pets de combate em paralelo, modelo "sombra do personagem").
- **Forge com slots de gemas**: aplicacao direta em equipamento (3.5).
- **Gambling/Casino subsystem**: subsistema opcional. Vale considerar mas com cuidado por questoes legais/eticas se publicarmos pra menores.
- **Multi-class tip jar / Class swap em runs**: forma agil de testar classes. Pode inspirar UX no nosso Renascimento.
- **Crafting com filas**: similar ao Anvil do IdleOn.

### Anti-padroes a evitar
- **Casino/gambling com pressao psicologica**: usa loops de "quase ganhei". Nao replicar.
- **UI inconsistente entre subsistemas**: cada feature parece de jogo diferente. Padronizar UI desde o inicio.

### Screenshots
- [VERIFICAR] https://idle-skilling.fandom.com/wiki/Pets
  - **Mostra:** lista de pets em grid, com niveis e raridades, slot equipados.

---

## 6. Idle Slayer

- **Ano:** 2018 mobile, 2020 Steam
- **Wiki / Fandom:** https://idle-slayer.fandom.com/wiki/Idle_Slayer_Wiki

### Proposta core
Active idle pixel art com side-scroller infinito. Player corre automaticamente, mata mobs, coleta moedas. Boss runs em momentos especificos.

### Sistemas aplicaveis
- **Efeitos visuais de combate satisfatorios**: pixel art com partculas, screen shake leve, popups de dano. Inspiracao direta pra nossa "combate visualmente legivel" (1.3).
- **Prestige por Glory**: prestige loop simples e bem comunicado.
- **Active mode vs Idle mode**: jogador pode escolher. Aplicacao: nosso speed-up em 3.29 ja contempla.

### Anti-padroes a evitar
- **Conteudo finito que repete**: corrida infinita acaba virando "mesma corrida". Nossa profundidade por zona/codex deve evitar.

### Screenshots
- [VERIFICAR] https://idle-slayer.fandom.com/wiki/Stages
  - **Mostra:** tela de combate side-scroller pixel, player a esquerda, mobs a direita, HUD em cima.

---

## 7. Crusaders of the Lost Idols

- **Ano:** 2015 web/Steam
- **Wiki:** https://crusaders-of-the-lost-idols.fandom.com/wiki/Crusaders_of_the_Lost_Idols_Wiki

### Proposta core
Idle de formacao com sinergias por adjacencia. Cruzados em grade fixa (front/middle/back), cada um com auras de range especifico. Reposicionar = reformular toda a build.

### Sistemas aplicaveis
- **Grade de formacao 3x2 ou maior com auras posicionais**: aplicacao direta em nossa Dungeon Party (3.24, ja explicito). Tipos de aura: adjacente, mesma coluna, mesma linha, diagonal, toda a party.
- **Eventos com banner-de-cruzado novo**: cada evento adiciona 1-2 cruzados unicos. Aplica em nossos Eventos (3.26).
- **Crusader achievements para upgrade tiers**: cada cruzado tem talents desbloqueaveis por feats com ele equipado.

### Anti-padroes a evitar
- **Eventos so disponiveis na janela**: missar o evento = missar o cruzado pra sempre (versao mais antiga). Eventos sazonais nossos devem ter forma alternativa de aquisicao posterior.
- **Ouro como unica metrica de progressao**: monotono. Nossa progressao tem multiplas metricas (nivel, codex, mastery).

### Screenshots
- [VERIFICAR] https://crusaders-of-the-lost-idols.fandom.com/wiki/Formation
  - **Mostra:** grade fixa 3x2 com slots ocupados por cruzados, indicadores visuais de aura ativa.

---

## 8. Realm Grinder

- **Ano:** 2015 web/Steam/mobile
- **Wiki:** https://realm-grinder.fandom.com/wiki/Realm_Grinder_Wiki

### Proposta core
Incremental medieval com faccoes mutuamente exclusivas. Bem (Fairy/Elf/Angel), Mal (Demon/Undead/Goblin), Neutro (Druid/Mercenary/Dwarf). Sua escolha muda buildings, spells, research disponiveis. Reincarnacao permite trocar.

### Sistemas aplicaveis
- **Faccoes mutuamente exclusivas**: aplicacao direta em nossa 4.6 (Pacto com Espiritos). Em vez de "subir Pacto Fogo as vezes reduz Pacto Agua", faccoes inteiras competem.
- **Trophies/Feats**: tracking de marcos atingidos com bonus permanentes. Reforco do nosso 3.21 (Selos).
- **Spells com cooldown global**: sistema de sinergias entre faccao + spells. Util pra Skill Tree (3.11) com nodes de spells.
- **Excavations**: drops aleatorios profundos com tema arqueologico. Nossa Archaeology (3.9 lista nova) pode seguir esse modelo.

### Anti-padroes a evitar
- **Curvas tao grandes que viram notacao cientifica de E10000**: alienante visualmente. Use abreviacoes claras (K/M/B/T/Aa/Bb...).
- **Reset que demora horas pra recuperar**: gating de tempo real. Nossas Ascensoes precisam preview de "quanto tempo ate recuperar minha velocidade".

### Screenshots
- [VERIFICAR] https://realm-grinder.fandom.com/wiki/Factions
  - **Mostra:** menu de selecao de faccao com arvores diferentes pra cada uma.

---

## 9. Idle Heroes

- **Ano:** 2016 mobile
- **Wiki:** https://idle-heroes.fandom.com/wiki/Idle_Heroes_Wiki

### Proposta core
Coleta de herois mobile. 6 faccoes (Fortress/Forest/Abyss/Shadow/Light/Dark). Hero stars (1-10★) via duplicatas/fusion. Awakening (transcendencia a tier maior) e Ascension com ramos de evolucao escolhidos pelo jogador.

### Sistemas aplicaveis
- **Awakening com ramos**: ja referenciado em 3.19 do roadmap. Nosso modelo de 3★/5★/7★/9★/10★ com escolhas de evolucao vem direto daqui.
- **Stones/Heroic Miracle/Prophet Tree**: meta-progressao paralela ao nivel do heroi. Aplicavel a Constelacoes (3.20).
- **Aspen Dungeon/Brave Trial**: conteudo de party recompensado por logs ja batidos. Util pra Arena (3.25).
- **Heroes equipping artifacts (4 slots)**: separado dos slots regulares. Pode inspirar slots especiais cosmeticos ou de Cards (3.14).

### Anti-padroes a evitar
- **Pity sistema agressivo**: rolls "pity 100" e "VIP system" que pune jogadores free-to-play. Nosso modelo nao-pay-to-win deve evitar (ver gacha-patterns.md).
- **Power creep absurdo**: herois novos invalidam herois antigos. Nossa retrocompatibilidade via Coleção de Equipamentos (3.33) preve isso.

### Screenshots
- [VERIFICAR] https://idle-heroes.fandom.com/wiki/Heroes
  - **Mostra:** card de heroi com stats laterais, retrato grande, equip slots no rodape.

---

## 10. Almost a Hero

- **Ano:** 2016 mobile, 2017 Steam
- **Wiki:** https://almost-a-hero.fandom.com/wiki/Almost_a_Hero_Wiki

### Proposta core
Idle hero collector. 9 herois "incompetentes" que evoluem juntos. Tap-com-formacao-fixa. Rings com gemas como meta-power.

### Sistemas aplicaveis
- **Heroes com talents tree individual**: cada heroi tem 3 talents desbloqueados em niveis 25/50/75. Modelo simples replicavel em Skill Tree (3.11).
- **Mercenaries**: herois temporarios de evento alugados por X minutos. Inspira sistema de "convidados" em party - vale considerar.
- **Adventures/Time Challenges**: gauntlet com cap de tempo. Modelo pra mini-eventos rotativos no Acampamento.

### Anti-padroes a evitar
- **Free-to-play wall pesada**: dimishing returns de gemas force compra. Nao replicar.

### Screenshots
- [VERIFICAR] https://almost-a-hero.fandom.com/wiki/Adventures
  - **Mostra:** bracket de adventures com timer.

---

## 11. Idle Champions of the Forgotten Realms

- **Ano:** 2017 Steam/mobile (D&D theme)
- **Wiki:** https://idlechampions.fandom.com/wiki/Idle_Champions_of_the_Forgotten_Realms_Wiki

### Proposta core
Idle game oficialmente D&D. Champions com formacoes (slots fixos). Champion specs e skill upgrades por gold. Eventos de "modron core" com personagens limitados e formula classica.

### Sistemas aplicaveis
- **Formation Slots em linha (1, 2, 3, 4 alinhamentos)**: 4 fileiras com 3 slots. Variante de formacao 3x2 nossa.
- **Champion Specializations**: cada champion tem 2-3 specs no level 50. Modelo claro pra ramos de Awakening (3.19).
- **Familiars**: pets simples que dao bonus passivos. Reforco da nossa secao 3.13.
- **Gold-find vs Damage variantes**: builds explicitos. Util como template pra builds esperados.

### Anti-padroes a evitar
- **Gating por evento limitado**: champions exclusivos so disponiveis durante 1 semana/ano. Nossa filosofia anti-FOMO.
- **UI saturada de iconinhos pequenos**: dificil de parsear. Nosso UI deve ser mais clean.

### Screenshots
- [VERIFICAR] https://idlechampions.fandom.com/wiki/Formations
  - **Mostra:** formacao em fileiras com slots ocupados por sprites de champions.

---

## 12. AFK Arena

- **Ano:** 2019 mobile/PC
- **Wiki:** https://afk-arena.fandom.com/wiki/AFK_Arena_Wiki

### Proposta core
Idle hero collector mobile. Auto-battle com 5 herois em fileira. Ascension tiers (Common → Mythic+). Crystal mechanic, signature items, furniture.

### Sistemas aplicaveis
- **Hero Ascension (rarity tiers)**: drop dups → fundir → upar tier. Modelo direto pra nossos Cards (3.14, ja contempla).
- **Faction synergies**: matar com 5 da mesma faccao = bonus. Padrao classico, vale incluir em Dungeons.
- **Resonating Crystal**: pool global que aplica niveis automaticamente nos N herois mais altos. Mecanica que vale considerar como QoL: "sub-personagens herdam % dos stats do main".
- **Library of Ascension**: progressao linear de bencao por avancar no campaign. Aplica em Codex completion bonuses.

### Anti-padroes a evitar
- **Power Spike artificial em tiers**: tier Mythic+ tem stats absurdamente acima de Mythic. Curva descontinua que frustra. Manter curva continua.
- **Eventos paywall pesados**: nao replicar.

### Screenshots
- [VERIFICAR] https://afk-arena.fandom.com/wiki/Heroes
  - **Mostra:** grid de herois com retrato, nivel, ascension tier visualmente codificado por cor.

---

## 13. Genshin Impact

- **Ano:** 2020 cross-platform
- **Wiki:** https://genshin-impact.fandom.com/wiki/Genshin_Impact_Wiki  e  https://wiki.hoyolab.com/

### Proposta core
Action RPG open world com combat de elementos e gacha. Daily commissions, ascension de personagens (level cap em tiers), constellations (eidolons em HSR), artifacts.

### Sistemas aplicaveis
- **Character Ascension (caps de nivel destrancaveis por materiais)**: nossa secao 3.19 (renascimentos) pode considerar gating por materiais especificos de mundo, nao so XP.
- **Daily Commissions (4 tarefas que renovam diariamente)**: aplica em Dungeons/Quests diarias da Guilda do Acampamento (3.16).
- **Combat UI em party de 4 com swap rapido**: minimalista. Ico de heroi + HP no canto. Util pra Dungeon UI.
- **Battle Pass + Welkin Moon**: monetizacao - VER COM CUIDADO no nosso modelo nao-pay-to-win.
- **Constellation system (C0-C6)**: melhorias permanentes desbloqueadas com duplicatas. Padrao gacha. Comparar com nossas Constelacoes (3.20) - sao coisas DIFERENTES no Genshin (C0-C6 e' do personagem; constelacao e' lore visual). Cuidado pra nao confundir terminologia.

### Anti-padroes a evitar
- **Resin/Stamina cap diario**: limita progresso. Sistemas anti-fun de "voce ja jogou demais hoje". Nosso 3.10 ja decidiu offline progress como modelo, nao stamina.
- **Pity de 90 rolls em banner premium**: forte FOMO. Nao replicar.

### Screenshots
- [VERIFICAR] https://genshin-impact.fandom.com/wiki/Daily_Commissions
  - **Mostra:** lista de 4 tarefas diarias com checkbox, recompensas a direita.

---

## 14. Honkai: Star Rail

- **Ano:** 2023 cross-platform
- **Wiki:** https://honkai-star-rail.fandom.com/wiki/Honkai:_Star_Rail_Wiki  e  https://wiki.hoyolab.com/pc/hsr/home

### Proposta core
Turn-based combat gacha. Light Cones (armas), Eidolons (constellations no HSR), Trace tree (skill tree). Combate em fila visivel (action queue). Path system (classes-like).

### Sistemas aplicaveis
- **Action Queue UI**: barra que mostra quem age proxima na linha do tempo. Ouro pra nossas Dungeons (3.24) que sao party turn-base-like.
- **Light Cones equipaveis**: armas com efeitos de set unicos. Aplica em Set Bonus de Equipamento (3.5).
- **Trace tree**: variante mais visual que skill tree linear. Modelo pra nossa 3.11.
- **Energy/Ult mechanic**: cada heroi ganha energia ao agir, ult disponivel ao encher. Modelo pra cooldown de skills assinatura (3.12).
- **Daily Trailblaze Power**: equivalente a stamina. NAO usar.

### Anti-padroes a evitar
- **Trailblaze Power = stamina = anti-fun**: idem Genshin.
- **Eidolons (E1-E6) escondidos atras de pity**: NAO replicar em modelo nao-pay-to-win.

### Screenshots
- [VERIFICAR] https://honkai-star-rail.fandom.com/wiki/Combat
  - **Mostra:** fila de acao no topo (icones de personagem em ordem), area central de combate, comandos no rodape.

---

## 15. Tower of Fantasy

- **Ano:** 2022 cross-platform
- **Wiki:** https://toweroffantasy.fandom.com/wiki/Tower_of_Fantasy_Wiki

### Proposta core
Action MMORPG cross-platform. Loadouts de armas (3 simultaneas com swap em combate). Matrix system (slots de buff por arma). Open world.

### Sistemas aplicaveis
- **Weapon Loadout com 3 armas simultaneas e swap em combate**: aplicacao parcial - nosso jogo e' auto-battle, mas a IDEIA de "kit de 3 armas que se complementam" pode virar feature: equipar arma principal + 2 secundarias com cooldown de uso. Considerar nova feature.
- **Matrix slots por arma (4 slots cada)**: parecido com encantamentos por equipamento (3.8). Em vez de slots por equipamento, slots por arma (mais focado).

### Anti-padroes a evitar
- **Mecanicas redundantes com Genshin**: copiou demais sem ter identidade. Nosso jogo precisa identidade clara, nao referencias soltas.

### Screenshots
- [VERIFICAR] https://toweroffantasy.fandom.com/wiki/Weapons
  - **Mostra:** weapon detail page com tres slots de loadout no topo.

---

## 16. Path of Exile

- **Ano:** 2013 PC, depois consoles
- **Wiki oficial:** https://www.poewiki.net  (substituiu o antigo wiki.pathofexile.com)

### Proposta core
ARPG profundo com economia, atlas (endgame mapas com customizacao), passive tree massiva (~1500 nodes), itens com affix system rico (prefixos, sufixos, implicits, corruptions, influence).

### Sistemas aplicaveis
- **Atlas system**: mapa de mapas com customizacao via Atlas Tree (passive tree do endgame). Aplicacao em meta-mapa de Zonas (3.1) - cada zona tem upgrades meta que afetam suas drops/dificuldade.
- **Affix tiers**: prefix tier 1, tier 2, tier 3 etc. Aplicacao direta em atributos aleatorios (3.5).
- **Crafting bench / Master crafts**: voce pode adicionar 1 affix garantido pagando custo. Util pra reforjar (3.7).
- **Loot filter**: regras configuraveis de visualizacao por raridade/tier. Recurso essencial em jogos com muito drop. Vale incluir como QoL early.
- **Atlas/Map Watchstones**: aplicar modifiers em mapa para drops melhores. Inspira "mods de zona" - antes de entrar, gastar resource pra modificar dificuldade/drop.

### Anti-padroes a evitar
- **Complexidade que vira barreira de entrada**: PoE tem fama de ser hostil. Nosso onboarding via Codex deve diluir.
- **Trading out of game**: economia depende de site externo (poe.trade). Em jogo solo idle, evitar.
- **Power creep entre leagues**: cada league mais forte. Nao temos leagues, mas aplica a NG+ ascensao (3.19).

### Screenshots
- [VERIFICAR] https://www.poewiki.net/wiki/Atlas_of_Worlds
  - **Mostra:** rede gigante de mapas conectados, exemplo de meta-mapa endgame.
- [VERIFICAR] https://www.poewiki.net/wiki/Passive_skill_tree
  - **Mostra:** passive tree com mais de 1000 nodes, jewels sockets visiveis.

---

## 17. Diablo 4

- **Ano:** 2023 PC/console
- **Wiki:** https://diablo.fandom.com/wiki/Diablo_IV  e  https://maxroll.gg

### Proposta core
ARPG moderno. Codex of Power (extraidos de itens legendaries em uma "biblioteca de affixes"), Aspects (modificadores aplicaveis). Paragon board (segunda arvore endgame). Helltides, Nightmare Dungeons.

### Sistemas aplicaveis
- **Codex of Power**: extraindo Aspect de um Legendary, ele fica no Codex pra sempre. Aplicar em outro item gasta material. Aplicacao direta em nosso "Coleção de Equipamentos" (3.33) com twist - o stat e' aplicavel, nao so passivo.
- **Aspects rolaveis vs fixos**: alguns Aspects sao do Codex (fixos), outros so dropam (rolaveis com range). Camada extra de design. Util.
- **Paragon Board**: 4-5 boards encadeados de talents, cada um com glyphs. Aplicacao em nossa Skill Tree (3.11) ou Constelacoes (3.20) como late-game.
- **Nightmare Dungeons (NM tier)**: dungeons escaladas com modifiers aleatorios. Aplica em Dungeon dificuldades (3.24).

### Anti-padroes a evitar
- **Renown reset entre temporadas**: jogador refaz tudo todo trimestre. Frustracao. Nosso modelo de prestige (3.19) deve ser opt-in nao mandatorio.
- **Itemizacao "boring affixes"**: muito affix de "1% to a stat". Affixes nossos devem ser perceptiveis.

### Screenshots
- [VERIFICAR] https://diablo.fandom.com/wiki/Codex_of_Power
  - **Mostra:** lista categorizada de Aspects com filtros, retrato visualizado.
- [VERIFICAR] https://maxroll.gg/d4/getting-started/d4-intro
  - **Mostra:** UI de gameplay tipico, hotbar inferior, minimapa lateral.

---

## 18. Last Epoch

- **Ano:** 2019 EA, 2024 release
- **Wiki:** https://wiki.lastepoch.com  e  https://www.lastepochtools.com

### Proposta core
ARPG com Mastery system (cada classe escolhe 1 de 3 masteries em nivel 25, mutuamente exclusivo). Loot Filter robusto built-in. Item factions (Circle of Fortune vs Merchants Guild).

### Sistemas aplicaveis
- **Masteries mutuamente exclusivas (3 por classe)**: aplicacao direta em nosso 3.19 (ramos de Awakening). Last Epoch faz isso em level 25, sem prestige - menos punitivo. Vale considerar pra primeira escolha de ramo (3★).
- **Loot Filter integrado**: nivel de detalhamento profissional. UI deve permitir esconder, destacar, recolor por affix/tier.
- **Idol slots (formato Tetris-like)**: alem de equipamento, voce tem grade de idolos com formatos. Pode inspirar slots especiais (cards greedy/elite ja tem aba propria).
- **Faction grind escolhido**: jogador opta por faccao, nao auto-aplica. Modelo pra nossa 4.6 (Pacto com Espiritos) com escolha clara.
- **Skill Specialization**: skills tem propria progression tree. Util pra nossas skills-com-cooldown (3.12).

### Anti-padroes a evitar
- **Trade vs SSF (Solo Self-Found) split community**: dividir base de jogador. Solo idle nao tem esse problema, mas evite criar sub-communidades artificiais.

### Screenshots
- [VERIFICAR] https://wiki.lastepoch.com/wiki/Loot_Filter
  - **Mostra:** UI do loot filter com regras visuais, preview de item.
- [VERIFICAR] https://wiki.lastepoch.com/wiki/Skill
  - **Mostra:** skill specialization tree compacta.

---

## 19. Grim Dawn

- **Ano:** 2016 PC
- **Wiki:** https://grimdawn.fandom.com/wiki/Grim_Dawn_Wiki

### Proposta core
ARPG isometrico classico. Devotion shrine (segunda arvore de constelacoes celestes que voce ativa por shrines spalhados). Dual-class system. Faction Quartermasters.

### Sistemas aplicaveis
- **Devotion Constellations**: usuario ativa shrines no mapa pra ganhar pontos, gasta pontos em constelacoes celestes (literalmente desenhadas no mapa estelar). Aplicacao DIRETA em nossa secao 3.20 (Constelacoes) - referencia de design visual e gameplay.
- **Dual class** (mistura 2 masteries em 1 personagem): pode inspirar variant de classe avancada em late-game.
- **Faction Quartermasters**: NPCs de faccao com recompensas especiais por reputation. Aplica em NPCs do Acampamento.

### Anti-padroes a evitar
- **UI envelhecida**: pode parecer datada, mas sistemas sao ouro. Nossa UI deve ser moderna.

### Screenshots
- [VERIFICAR] https://grimdawn.fandom.com/wiki/Devotion
  - **Mostra:** mapa estelar com constelacoes ligadas, nodes ativados em destaque. **Referencia visual obrigatoria pra nosso 3.20.**

---

## 20. Lost Ark

- **Ano:** 2018 KR, 2022 global
- **Wiki:** https://lostark.fandom.com/wiki/Lost_Ark_Wiki

### Proposta core
MMOARPG cross. Engravings system (combinacoes de sigilos que dao buffs unicos). Gear Honing (upgrade com taxa de sucesso). Cube content (mini-dungeons diarios com escala).

### Sistemas aplicaveis
- **Engravings (3 active, 5+ total)**: combinacao de sigilos da efeitos categorizados. Aplica em Encantamentos (3.8) com twist - varios sigilos somando ate cap.
- **Honing (refine com chance + pity)**: sucess rate aumenta em runs ate "garantido". Aplica em Refinar (3.7) com pity. ATENCAO: ja temos pedras de protecao - balancear.
- **Una's tasks (daily/weekly tasks)**: rotativas com recompensa moderada. Modelo pra Quests da Guilda (3.16).
- **Skill Tripods**: skills tem 3 escolhas em 3 niveis = 9 builds por skill. Profundidade rica. Aplica em ramos de skills com cooldown.

### Anti-padroes a evitar
- **Honing fail despertruction**: items podem virar pedaco de cooldown se falhar muito. Nosso refinamento (3.7) ja prefere "destruido" em vez de "perdido vida util".
- **Daily/weekly checklist excessivo**: 30+ tarefas diarias = chore. Limitar.

### Screenshots
- [VERIFICAR] https://lostark.fandom.com/wiki/Engravings
  - **Mostra:** lista de engravings ativos com niveis e seus efeitos.

---

## 21. MapleStory

- **Ano:** 2003 (Korea), 2005 NA
- **Wiki:** https://strategywiki.org/wiki/MapleStory  e  https://maplestorywiki.net/

### Proposta core
2D side-scrolling MMORPG. Star Force enhancement (estrelas em equipamento). Cubing affixes. Inumeras classes (40+) com identity unica. Job advancements em niveis especificos.

### Sistemas aplicaveis
- **Star Force (estrelas em equip ate 25★)**: incremento gradual com falha possivel. Aplica em "Quebra de Limite" (3.7).
- **Cubing**: re-rolar potential affixes com cubos. Aplica em Reforjar (3.7).
- **Job Advancement**: a classe avanca em level X (10, 30, 60, 100, 200), ganhando skill set novo. Aplica direto em ramos de Awakening (3.19) - referencia direta.
- **Equip Sets (set bonus em 3/5/7 pecas)**: aplica direto em Equipment Sets (3.5).
- **Hyper Skills / 5th Job**: layers extras de habilidades em niveis altos. Aplica em skills de transcendencia.

### Anti-padroes a evitar
- **Cube Gambling como time gate**: rerolar bom potential pode custar 100+ cubos = horas/dias. Frustrante.
- **Nikkel-and-dime monetization**: NX, slots, hairstyles, cosmeticos pagos. Cuidado.
- **Power gap massivo entre F2P e P2W**: lendario.

### Screenshots
- [VERIFICAR] https://strategywiki.org/wiki/MapleStory/Star_Force
  - **Mostra:** UI de star force com slot de item central, botao "Enhance", historico de tentativas.

---

## 22. Tibia

- **Ano:** 1997 PC
- **Wiki oficial:** https://tibia.fandom.com/wiki/Main_Page  e  https://tibiawiki.com.br/wiki/

### Proposta core
2D MMO classico. Skills sobem por uso (Sword Fighting, Magic Level, etc.) - uma das primeiras a popularizar. Online/Offline progression.

### Sistemas aplicaveis
- **Skills via uso**: ja ecoa Mastery (3.9). Modelo simples e classico.
- **Bestiary/Charm system**: matar X de monstro libera info + charm slot. Aplicacao direta em nosso Bestiario (3.15).
- **Imbuements**: temporarios em equipamento (ex: 20h de buff por ouro). Variante de encantamentos com timer. Aplica como "buff temporario" em equip via materiais.

### Anti-padroes a evitar
- **Death penalty severo**: morrer = perder XP/skills. Em idle nao queremos esse stress.

### Screenshots
- [VERIFICAR] https://tibia.fandom.com/wiki/Bestiary
  - **Mostra:** lista de criaturas com progress bar de descoberta, charm slots no topo.

---

## 23. RuneScape (RS3)

- **Ano:** 2001, RS3 a partir de ~2013
- **Wiki:** https://runescape.wiki

### Proposta core
MMO com 28+ skills, todos progredindo de 1-99 (ate 120 em algumas). Quest-based content profundo. RS3 modernizou com combat tier, action bars, abilities.

### Sistemas aplicaveis
- **Skill cap unificado 1-99 com XP curve identica**: padroniza UI/expectativas. Aplica em nossas skills (3.9).
- **Quest system com requisites cross-skill**: "precisa Mining 50 + Smithing 60 pra fazer X". Aplica em quests da Guilda - cria gating natural via diversificacao de personagens.
- **Invention skill (combinar materiais antigos pra blueprints novas)**: pode inspirar Crafting "metaprogression" (combinar materiais finalizados em itens unicos).

### Anti-padroes a evitar
- **MTX em hub de XP**: Treasure Hunter etc. NAO REPLICAR.
- **Curva 99→120 elitizada**: ultimos niveis exigem grind brutal. Cuidar com curvas finais.

### Screenshots
- [VERIFICAR] https://runescape.wiki/w/Skills
  - **Mostra:** lista de skills com niveis em grid 4x7. Layout limpo, util.

---

## 24. Old School RuneScape (OSRS)

- **Ano:** 2013 (revival do RS de 2007)
- **Wiki:** https://oldschool.runescape.wiki

### Proposta core
Filosofia oposta a RS3: mantém combate tick-based simples, design conservador. Comunidade vota toda atualizacao via polls.

### Sistemas aplicaveis
- **Slayer skill (mestres que dao tasks de matar X de Y)**: aplicacao DIRETA em quests de bestiario tematizadas (3.15). Slayer NPC no Acampamento (Mestre da Guilda).
- **Diary system (achievements regionais com tiers Easy/Med/Hard/Elite)**: aplicacao em achievements regionais (Selos por zona).
- **Combat Achievements (boss-specific feats)**: aplica em Mob Slaughter elites/bosses (3.15).
- **Polls / community-driven design**: filosofia inteira. Em jogo solo nao se aplica, mas o respeito ao jogador e' modelo.

### Anti-padroes a evitar
- **Tick system unforgiving**: muito tecnico pra novato. Nosso auto-battle resolve isso.
- **PVP wilderness loot**: nao temos PVP, irrelevante.

### Screenshots
- [VERIFICAR] https://oldschool.runescape.wiki/w/Slayer
  - **Mostra:** master selection screen com requisitos de combate.
- [VERIFICAR] https://oldschool.runescape.wiki/w/Combat_Achievements
  - **Mostra:** tier list de achievements com progress.

---

## 25. Albion Online

- **Ano:** 2017 cross-platform
- **Wiki:** https://wiki.albiononline.com

### Proposta core
Sandbox MMO com economia 100% player-driven. Crafted gear como base de tudo. Localized markets. Tier system simples (T1-T8).

### Sistemas aplicaveis
- **Crafting como economia central**: incentiva especializacao. Em solo, traduz pra "personagens com crafting altos viram bottleneck dos outros" - fortalece paradigma multi-personagem (3.10).
- **Destiny board (skill tree em formato de mapa de destino)**: visualizacao alternativa de progressao por categoria. Pode inspirar Codex (3.27).
- **Localized markets**: itens nao circulam entre cidades sem transporte. Em solo, vira "armazens por cidade" - vale considerar pra Acampamento Cidade+ ter armazens regionais.

### Anti-padroes a evitar
- **PVP full loot**: nao se aplica.
- **Premium account com massive XP boost**: cuidado.

### Screenshots
- [VERIFICAR] https://wiki.albiononline.com/wiki/Destiny_Board
  - **Mostra:** tree gigante visual de progressao por categoria.

---

## 26. Milky Way Idle

- **Ano:** 2024 web (browser)
- **Wiki / refs:** https://www.milkywayidle.com  (site oficial); fandom em https://milky-way-idle.fandom.com/wiki/Milky_Way_Idle_Wiki [VERIFICAR existencia]

### Proposta core
RuneScape-like browser idle multiplayer. Marketplace player-driven. Skills + combat + leaderboards.

### Sistemas aplicaveis
- **Online marketplace**: nao prioridade pra nosso solo, mas modelo de "valor de cada item bem definido" e' util.
- **Leaderboards globais**: vale considerar pra escalar Arena (3.25) com leaderboard local/global futuro.

### Anti-padroes a evitar
- **Multiplayer trade que cria farm bots**: nao se aplica em solo.

### Screenshots
- [VERIFICAR] https://www.milkywayidle.com - site oficial, screenshots na landing.

---

## 27. Idle Iktah

- **Ano:** 2020 mobile/web
- **Wiki:** https://idle-iktah.fandom.com/wiki/Idle_Iktah_Wiki  [VERIFICAR existencia]

### Proposta core
Idle small-scope mas com **interdependencia ecologica de recursos**: sobreexplorar uma area afeta outras downstream.

### Sistemas aplicaveis
- **Recurso "esgotamento" por area**: regiao com kill stack alto demais reduz drop por hora ate "recuperar" com tempo real. Anti-grind degenerado. **Vale considerar feature nova:** rotacao forcada de zonas em late-game.
- **Crafting chains profundos**: A → B → C → D forca planning de recursos.

### Anti-padroes a evitar
- **Interface mobile primeira sem upgrade pc**: nao se aplica diretamente, mas alerta de UX dual.

### Screenshots
- [VERIFICAR] na fandom acima.

---

## 28. World of Warcraft

- **Ano:** 2004 PC (live since)
- **Wiki:** https://wowpedia.fandom.com/wiki/Wowpedia  e  https://www.wowhead.com

### Proposta core
MMORPG referencial. Transmog (cosmetic gear collection), Professions (mineracao, alquimia, etc.), Achievements/Mounts/Pets como meta-collection.

### Sistemas aplicaveis
- **Transmog/Wardrobe**: cada item desbloqueado pra cosmetic. Aplicacao direta em nosso 3.5 ("slots visuais") e 3.33 (Coleção de Equipamentos - cada item registra na coleção).
- **Professions com receitas raras dropadas de mob/world**: incentiva exploracao por crafting. Aplicacao direta em receitas do Codex (3.27).
- **Achievement system com pontos visuais**: pontos somam, alguns achievements dao titulos/mounts/pets. Modelo direto pra nosso 3.21 (Selos) e 3.22 (Titulos).
- **Mythic+ scaling (chave por dungeon que cresce em dificuldade)**: aplica em Dungeons (3.24) com sistema de chaves escalaveis.

### Anti-padroes a evitar
- **Borrowed Power systems** (Azerite, Covenants, Shards) que reset entre expansoes: jogador sente investimento perdido. Nossa Ascensao Cosmica (3.19) tem que comunicar bem o que se mantem.
- **Daily quest treadmill**: lista interminavel de chores. Limitar.

### Screenshots
- [VERIFICAR] https://wowpedia.fandom.com/wiki/Transmogrification
  - **Mostra:** UI de transmog com lista de aparencias coletadas, slot ativo.
- [VERIFICAR] https://www.wowhead.com/achievements
  - **Mostra:** sistema de achievements organizado por categoria, com pontos visiveis.

---

## Cross-reference rapida com roadmap

- **3.1 Combate** - Melvor (UI), HSR (action queue), Idle Slayer (efeitos visuais)
- **3.2 Stats** - Incremental Epic Hero 2, PoE (affixes)
- **3.5 Equipamento** - Diablo 4 (Codex of Power), MapleStory (Star Force), PoE (affix tiers), AFK Arena (ascension)
- **3.7 Refinar** - MapleStory, Lost Ark (Honing)
- **3.8 Encantamentos** - PoE, Lost Ark (Engravings), Tibia (Imbuements)
- **3.9 Coleta** - Melvor (mastery por item), RuneScape, Tibia, Albion
- **3.10 Multi personagem** - IdleOn (master), Idle Skilling, FF14
- **3.11 Skill Tree** - Last Epoch (mastery escolhida), HSR (Trace), PoE (passive tree), D4 (Paragon)
- **3.13 Pets** - Idle Skilling (raids), Genshin (companions)
- **3.14 Cards** - IdleOn (modelo direto), Tibia (charms)
- **3.15 Bestiario / Mob Slaughter** - Tibia, OSRS (Slayer), WoW
- **3.19 Renascimento/Ramos** - Idle Heroes, MapleStory (Job Adv), Last Epoch (Mastery)
- **3.20 Constelacoes** - Grim Dawn (referencia VISUAL direta), Genshin
- **3.24 Dungeons formacao** - Crusaders of the Lost Idols (referencia direta), Idle Champions, AFK Arena
- **3.25 Arena** - NGU (ITOPOD), WoW (Mythic+)
- **3.27 Codex** - WoW (achievement), OSRS (Diary), Tibia (Bestiary)

---

*Fim do documento. Ver tambem:* `idle-genre-patterns.md`, `wiki-reference-list.md`, `ui-screenshots-references.md`.
