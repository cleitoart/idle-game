# UI Screenshots References - Telas Notaveis para Inspiracao

> **Nota metodologica importante:** Brave Search foi negado nesta sessao - nao foi possivel verificar links nem capturar/buscar screenshots em tempo real. As entradas abaixo descrevem **conhecimento previo** sobre layout das telas e citam URLs publicas das wikis onde o screenshot **provavelmente** esta disponivel. Cada entrada esta marcada `[VERIFICAR]`. O usuario deve abrir os links manualmente para confirmar disponibilidade e atualizar URLs especificas se necessario.

Para cada UI: jogo, tela/contexto, descricao do que mostra, o que vale replicar, o que NAO vale.

---

## Indice

1. [Melvor Idle - Combat Page](#1-melvor-idle---combat-page)
2. [Melvor Idle - Mastery Tables](#2-melvor-idle---mastery-tables)
3. [IdleOn - Cards Album](#3-idleon---cards-album)
4. [IdleOn - World Map / Roster](#4-idleon---world-map--roster)
5. [Crusaders of the Lost Idols - Formation Grid](#5-crusaders-of-the-lost-idols---formation-grid)
6. [Idle Heroes - Hero Detail](#6-idle-heroes---hero-detail)
7. [AFK Arena - Hero Selection / Library](#7-afk-arena---hero-selection--library)
8. [Genshin Impact - Daily Commissions](#8-genshin-impact---daily-commissions)
9. [Honkai: Star Rail - Combat Action Queue](#9-honkai-star-rail---combat-action-queue)
10. [Path of Exile - Atlas of Worlds](#10-path-of-exile---atlas-of-worlds)
11. [Path of Exile - Passive Tree](#11-path-of-exile---passive-tree)
12. [Diablo 4 - Codex of Power](#12-diablo-4---codex-of-power)
13. [Last Epoch - Loot Filter](#13-last-epoch---loot-filter)
14. [Grim Dawn - Devotion Star Map](#14-grim-dawn---devotion-star-map)
15. [Lost Ark - Engravings](#15-lost-ark---engravings)
16. [MapleStory - Star Force UI](#16-maplestory---star-force-ui)
17. [Cookie Clicker - Main Game Layout](#17-cookie-clicker---main-game-layout)
18. [WoW - Achievement Categories](#18-wow---achievement-categories)
19. [Realm Grinder - Faction Selection](#19-realm-grinder---faction-selection)
20. [OSRS - Bestiary / Slayer Log](#20-osrs---bestiary--slayer-log)

---

## 1. Melvor Idle - Combat Page

- **Jogo:** Melvor Idle
- **Tela:** Combat (durante luta com inimigo)
- **URL provavel:** https://wiki.melvoridle.com/w/Combat  [VERIFICAR]
- **O que mostra:** painel central com sprite do player e do inimigo lado a lado; barras de HP grandes e bem legiveis; log de combate textual ao lado direito; indicadores de ataque proximo (cooldown radial); slots de equipamento visiveis a esquerda; botoes de food/spell logo abaixo do player.

**O que vale replicar**
- HP bars grandes que dominam o eixo visual.
- Log textual paralelo (nosso BattleLog ja contempla).
- Slots de equipamento sempre visiveis durante combate (acesso rapido).
- Indicador de "proximo ataque" com cooldown radial.
- Layout horizontal limpo, com player e inimigo equidistantes.

**O que NAO vale replicar**
- Falta de efeitos visuais animados em crit/skill (combat fica estatico demais).
- Sprites pequenos demais; visual sem peso.
- UI estatica sem animacao de entrada/saida.

---

## 2. Melvor Idle - Mastery Tables

- **Jogo:** Melvor Idle
- **Tela:** Lista de mastery levels por skill
- **URL provavel:** https://wiki.melvoridle.com/w/Mastery  [VERIFICAR]
- **O que mostra:** tabela longa por skill (ex: Fishing) listando cada item (Truta, Tubarao...) com colunas: nivel atual, XP/sessao, pool de mastery, tempo estimado pra proximo nivel.

**O que vale replicar**
- Tabela ordenavel/filtravel.
- Coluna "tempo estimado" em formato real-time (8h17m).
- Pool de mastery global por skill (nivel medio das masteries do skill).
- Cores por tier de mastery (cinza Common ate dourado 99).

**O que NAO vale replicar**
- Numeros em fonte pequena demais.
- Falta de tooltip explicando "o que essa mastery faz" especificamente.

---

## 3. IdleOn - Cards Album

- **Jogo:** Legends of IdleOn
- **Tela:** Album de cards
- **URL provavel:** https://legendsofidleon.fandom.com/wiki/Cards  [VERIFICAR]
- **O que mostra:** grid 5x5 ou 6xN de slots de cards. Cards equipados com brilho/borda colorida. Tier de card visivel (estrelas pequenas no topo). Hover mostra stat e set bonus.

**O que vale replicar**
- Grid bem organizado, cards quadrados.
- Borda colorida = tier (Common cinza, Uncommon verde, Rare azul, Epic roxo, Legendary laranja, Mythic vermelho/dourado).
- Hover/tap revela detalhe.
- Set indicators na lateral (5 cards de set X equipados? sim/nao).
- Categoria do card no canto inferior (raca/comportamento/elemento).

**O que NAO vale replicar**
- UI muito densa em mobile (textos sobrescritos).
- Falta de "completion %" do album visivel. (Nosso 3.27 deve mostrar.)

---

## 4. IdleOn - World Map / Roster

- **Jogo:** Legends of IdleOn
- **Tela:** Mapa do mundo / Roster overview
- **URL provavel:** https://idleon.wiki/wiki/Main_Page (banner principal) ou https://legendsofidleon.fandom.com/wiki/Worlds  [VERIFICAR]
- **O que mostra:** mapa estilizado com varios "worlds" interconectados (port, town, ice, jungle...). Botoes pra trocar entre personagens em cima. Cada personagem tem retrato pequeno + classe + nivel.

**O que vale replicar**
- Personagens listados em barra superior com retrato + classe + status atual ("Mining @ Iron Mine").
- Trocar de personagem = trocar de "camera" do mundo.
- World map estilizado com portoes/desbloqueios visuais.
- Indicators piscando: "este personagem precisa de atencao!" (level up disponivel, equip melhor).

**O que NAO vale replicar**
- Mapa pode parecer cartoonesco demais para nosso tema medieval. Adaptar estilo.

---

## 5. Crusaders of the Lost Idols - Formation Grid

- **Jogo:** Crusaders of the Lost Idols
- **Tela:** Formation 3x2 / 4x4
- **URL provavel:** https://crusaders-of-the-lost-idols.fandom.com/wiki/Formation  [VERIFICAR]
- **O que mostra:** grade fixa com 3 colunas (front/middle/back) e 2 linhas. Cada slot ocupado por sprite do crusader. Hover destaca AURAS visualmente (linhas conectando o crusader aos afetados).

**O que vale replicar**
- **Visualizacao de auras**: ao selecionar um personagem, linhas/glows mostram visualmente quais slots ele afeta. Critico pra nosso 3.24.
- Slots vazios marcados com placeholder visual.
- Drag-and-drop pra reposicionar.
- Preset de formacoes salvas em barrinha lateral.
- Total de stats da party em painel inferior (somatorio).

**O que NAO vale replicar**
- UI envelhecida (jogo de 2015).
- Crusaders muitos, pouco diferenciacao visual entre os de mesma raridade.

---

## 6. Idle Heroes - Hero Detail

- **Jogo:** Idle Heroes
- **Tela:** Tela de detalhe de heroi
- **URL provavel:** https://idle-heroes.fandom.com/wiki/Heroes  [VERIFICAR]
- **O que mostra:** retrato grande do heroi a esquerda, nivel/stars/awakening tier no topo, stats no centro com botoes de upgrade, equipamento na direita com 4 slots de gear + 4 slots de artifact, skills em baixo (4 skills com tooltips).

**O que vale replicar**
- Retrato grande dominante.
- Stars (1-10★) bem visuais (no topo, dourado).
- Awakening tier indicator distinto de stars (icone diferente).
- Skills em barra inferior, hover/tap pra detalhe.
- Equipamento separado de artifact (cards pra nos).

**O que NAO vale replicar**
- Densidade de pontos vermelhos de "tem upgrade pendente" - polui visual.
- Power level total exibido em numero gigante - pode incentivar comparacao toxica em PVP (nao temos PVP).

---

## 7. AFK Arena - Hero Selection / Library

- **Jogo:** AFK Arena
- **Tela:** Hero collection / Library of Heroes
- **URL provavel:** https://afk-arena.fandom.com/wiki/Heroes  [VERIFICAR]
- **O que mostra:** grid de retratos de herois, ordenavel por faccao/raridade/level. Filtros laterais por categoria. Hero ascension tier em borda (cor + simbolos especiais Mythic+).

**O que vale replicar**
- Filtros por categoria sempre visiveis.
- Ascension tier codificado em cor da borda + simbolos especiais.
- Compactacao de informacao por hero card (retrato + nivel + tier suficiente sem clicar).
- Faccao indicator no canto.

**O que NAO vale replicar**
- "Power level" gigante embaixo de cada heroi. (Mesmo argumento de 6.)
- Banners de evento intrusivos por cima da UI.

---

## 8. Genshin Impact - Daily Commissions

- **Jogo:** Genshin Impact
- **Tela:** Daily Commissions UI
- **URL provavel:** https://genshin-impact.fandom.com/wiki/Daily_Commissions  [VERIFICAR]
- **O que mostra:** lista vertical de 4 tarefas, cada uma com icone, descricao curta, status (pending/done), recompensa preview a direita. Botao "claim all" no final.

**O que vale replicar**
- Lista vertical, max 4-5 itens (nosso cap recomendado em idle-genre-patterns.md).
- Status visual claro (checkbox ticado/aberto).
- Recompensa preview ANTES de aceitar.
- "Claim all" que recolhe de uma vez.
- Reset timer visivel ("renova em 8h12m").

**O que NAO vale replicar**
- Daily mandatorio para progredir Battle Pass / Adventure Rank.
- Tasks repetitivas ("matar 3 inimigos do tipo X").

---

## 9. Honkai: Star Rail - Combat Action Queue

- **Jogo:** Honkai: Star Rail
- **Tela:** Combat (turn-based with action queue)
- **URL provavel:** https://honkai-star-rail.fandom.com/wiki/Combat  [VERIFICAR]
- **O que mostra:** barra horizontal no topo com retratos pequenos dos atacantes (party + inimigos) na ordem em que vao agir. Maior peso visual nos personagens da nossa party. Inimigos tem nameplate com "weakness" elementais (icones de elementos resistidos/fracos).

**O que vale replicar**
- **Action queue / barra de ordem de ataque**: ouro pra nossas Dungeons. Mostra ao jogador quem age proximo.
- Weakness icons em cima dos inimigos (nosso sistema de elementos + tipos de ataque pode usar isso).
- Visual de "break" quando inimigo recebe dano de seu weakness (efeito de quebra de armor).
- Stagger bar que enche quando hits weakness consecutivos.

**O que NAO vale replicar**
- Cutscene em ult que pode atrasar combate idle. Nossa ult deve ser efeito visual rapido (1-2s).

---

## 10. Path of Exile - Atlas of Worlds

- **Jogo:** Path of Exile
- **Tela:** Atlas of Worlds (endgame map progression)
- **URL provavel:** https://www.poewiki.net/wiki/Atlas_of_Worlds  [VERIFICAR]
- **O que mostra:** rede gigante de mapas conectados por linhas. Cada node e' um mapa. Cores indicam tier e zona. Mapas completados visivelmente diferentes dos pendentes.

**O que vale replicar (parcialmente)**
- Conceito de "meta-mapa" mostrando progressao endgame.
- Visual de "completou X% do atlas".
- Mapas com modifiers (ja pensamos pra nossa Zona refinements).

**O que NAO vale replicar**
- Densidade absurda do Atlas atual (200+ mapas). Nosso "meta-mapa" deve ter 30-50 nodes max no endgame.
- Aprendizado curve hostil. Onboardar.

---

## 11. Path of Exile - Passive Tree

- **Jogo:** Path of Exile
- **Tela:** Passive Skill Tree
- **URL provavel:** https://www.poewiki.net/wiki/Passive_skill_tree  [VERIFICAR]
- **O que mostra:** mais de 1500 nodes em uma arvore radial. Classes comecam em pontos diferentes. Jewels socketaveis em slots especificos. Keystones grandes destacados.

**O que vale replicar**
- Visualizacao radial elegante.
- Keystones (nodes grandes) com efeitos game-changing.
- Rotacao/zoom suave.

**O que NAO vale replicar**
- 1500 nodes = paralisia de escolha. Nossa Skill Tree deve ter 100-200 nodes no endgame.
- Necessidade de ferramentas externas (PoB) pra planejar build.

---

## 12. Diablo 4 - Codex of Power

- **Jogo:** Diablo 4
- **Tela:** Codex of Power
- **URL provavel:** https://diablo.fandom.com/wiki/Codex_of_Power  [VERIFICAR]
- **O que mostra:** lista categorizada de Aspects (offensive/defensive/utility/resource), cada um com: nome, descricao, range de valor, status (descoberto/extraido/aplicado).

**O que vale replicar**
- Categorizacao de aspects/encantamentos (offensive/defensive/utility/...).
- Status visual: descoberto vs aplicavel vs em uso.
- Range de valor mostrado (rolable).
- Filtro por categoria.

**O que NAO vale replicar**
- Aspect "lost" se nao extraido a tempo. Nossa Coleção (3.33) registra automaticamente.

---

## 13. Last Epoch - Loot Filter

- **Jogo:** Last Epoch
- **Tela:** Loot Filter UI
- **URL provavel:** https://wiki.lastepoch.com/wiki/Loot_Filter  [VERIFICAR]
- **O que mostra:** painel de regras com lista vertical de regras (cor, condicao, acao). Preview de item afetado pela regra a direita. Drag-and-drop pra reordenar regras.

**O que vale replicar**
- Lista de regras editavel.
- Preview imediato.
- Cores customizaveis por regra.
- Presets gravaveis (gold builder / mythic hunter / show all).

**O que NAO vale replicar**
- Complexidade que vira programacao. Nosso filtro deve ser modular com regras simples (3-5 ja cobrem 90%).

---

## 14. Grim Dawn - Devotion Star Map

- **Jogo:** Grim Dawn
- **Tela:** Devotion Constellations
- **URL provavel:** https://grimdawn.fandom.com/wiki/Devotion  [VERIFICAR]
- **O que mostra:** ceu noturno escuro com constelacoes desenhadas conectando pontos brilhantes. Cada constelacao tem 3-7 nodes. Ativadas tem brilho dourado; pendentes tem brilho fraco. Linhas conectam nodes da mesma constelacao.

**O que vale replicar - REFERENCIA OBRIGATORIA PARA 3.20**
- **Visual de mapa estelar com constelacoes desenhadas.** Eh o pano de fundo perfeito.
- Constelacoes "completaveis" com efeito visual de explosion/brilho ao concluir.
- Nodes com requirement (so libera se constelacao A esta ativada).
- Tooltip rico em cada node.
- Zoom suave entre constelacao individual e mapa global.

**O que NAO vale replicar**
- Affinity system (Eldritch/Order/Chaos/...) e' complexo. Podemos simplificar pra "categoria" sem affinity points.

---

## 15. Lost Ark - Engravings

- **Jogo:** Lost Ark
- **Tela:** Engraving setup
- **URL provavel:** https://lostark.fandom.com/wiki/Engravings  [VERIFICAR]
- **O que mostra:** lista de engravings ativas (3 slots) + lista de engravings em "books" (livros nao usados). Cada engraving tem 3 niveis ativaveis ao acumular X books.

**O que vale replicar**
- Niveis incrementais de engraving (1/2/3).
- Books/livros como recurso colecionavel pra ativar.
- Active vs storage list.
- Negative engravings (penalty) para multiclassing avancado.

**O que NAO vale replicar**
- Sistema "negativos" pode confundir novato. Restringir a positivas em mid-game.

---

## 16. MapleStory - Star Force UI

- **Jogo:** MapleStory
- **Tela:** Star Force enhancement UI
- **URL provavel:** https://strategywiki.org/wiki/MapleStory/Star_Force  [VERIFICAR]
- **O que mostra:** slot central com item, contador de estrelas atual / max, botao "Enhance" grande, taxa de sucesso/falha visivel, custo em mesos visivel, historico de tentativas.

**O que vale replicar**
- Taxa de sucesso/falha **EXPLICITA**. Jogador nao pode ser surpreendido.
- Historico de tentativas ("ja tentou 4x, falhou 3x").
- Botao "auto enhance ate X" se tem certeza.
- Custo total acumulado visivel.
- Pedras de protecao/safeguard como toggle.

**O que NAO vale replicar**
- Star Force e' famosa por ser "sucess gambling" agressiva. Nossa pity system (gacha-patterns.md item 2) anti-frustracao.

---

## 17. Cookie Clicker - Main Game Layout

- **Jogo:** Cookie Clicker
- **Tela:** Tela principal do jogo
- **URL provavel:** https://cookieclicker.fandom.com/wiki/Cookie_Clicker_Wiki  [VERIFICAR]
- **O que mostra:** layout em 3 colunas verticais. Esquerda: cookie gigante clicavel + stats (cookies, cps). Centro: lista de upgrades disponiveis com tooltips. Direita: lista de buildings (1 linha por building com icone + count + custo proximo).

**O que vale replicar**
- Layout em colunas claras.
- Custo do proximo nivel sempre visivel (nao precisa abrir tooltip).
- Stats globais sempre visiveis no topo (cookies/cps; pra nos: gold/dps de personagem).
- Upgrades de tier (Common → Mythic) coloridos por raridade.

**O que NAO vale replicar**
- Late game vira muro de texto.
- Subsistemas escondidos atras de "open mod" - falta visibility.

---

## 18. WoW - Achievement Categories

- **Jogo:** World of Warcraft
- **Tela:** Achievement panel
- **URL provavel:** https://wowpedia.fandom.com/wiki/Achievement  [VERIFICAR]
- **O que mostra:** painel com categorias na esquerda (General, Quests, Exploration, PvP, Dungeons, Raids, Professions, Reputation, World Events, Pet Battles, Collections, Battle for Azeroth, Shadowlands...). Cada categoria expansivel. Achievements com icone, descricao, pontos, progresso.

**O que vale replicar**
- Categorias hierarquicas.
- Pontos de achievement como total visivel.
- Achievement "in progress" tem barra de progresso.
- Filtros: completos/pendentes/recentes.

**O que NAO vale replicar**
- Achievement legacy de expansoes antigas que viram inalcancaveis.

---

## 19. Realm Grinder - Faction Selection

- **Jogo:** Realm Grinder
- **Tela:** Faction selection / Reincarnation
- **URL provavel:** https://realm-grinder.fandom.com/wiki/Factions  [VERIFICAR]
- **O que mostra:** ate 9 faccoes em grade, agrupadas por alinhamento (Bem/Mal/Neutro). Cada faccao tem icone tematico + buildings preview + spell preview. Selecionar trava as outras ate proxima reincarnation.

**O que vale replicar**
- Agrupamento por alinhamento visual.
- Preview do que cada faccao "des-bloqueia" antes de escolher.
- Aviso claro: "voce nao podera mudar ate Reincarnation".
- Comparison tool entre 2 faccoes.

**O que NAO vale replicar**
- 9 faccoes e' demais pra iniciantes. Nossa 4.6 (Pacto com Espiritos) pode ter 3-5.

---

## 20. OSRS - Bestiary / Slayer Log

- **Jogo:** Old School RuneScape
- **Tela:** Slayer Master interaction / Combat Achievements
- **URL provavel:** https://oldschool.runescape.wiki/w/Slayer  ou  https://oldschool.runescape.wiki/w/Combat_Achievements  [VERIFICAR]
- **O que mostra:** menu de slayer master com tasks oferecidas, requisitos de combate visiveis, points granted por completar. Combat Achievements organizados por boss/zona com tier (Easy/Medium/Hard/Elite/Master/Grandmaster).

**O que vale replicar**
- Tier de tarefa visivel (Easy → Master).
- Requisito de combat level/skills visivel ANTES de aceitar task.
- Points por categoria.
- Bosses listados por zona.
- "Done" vs "Pending" + "Locked" indicators.

**O que NAO vale replicar**
- Slayer mecanica de skip task com cost. Nao se aplica em idle, mas a logica de "task atual obrigatoria" e' inflexivel demais.

---

## Resumo: telas mais valiosas pra usar como referencia

### Top 5 referencias visuais
1. **Grim Dawn Devotion (item 14)** - obrigatoria pra nossa secao 3.20.
2. **Crusaders Formation (item 5)** - obrigatoria pra nossa secao 3.24.
3. **Melvor Combat (item 1)** - layout limpo e legivel pra combate solo.
4. **HSR Action Queue (item 9)** - obrigatoria pra Dungeons em party.
5. **Diablo 4 Codex (item 12)** - referencia direta pra Coleção de Equipamentos.

### Top 5 padroes de UI a evitar
1. Power level gigante competitivo (Idle Heroes / AFK Arena).
2. Densidade de pontos vermelhos de "ha algo a fazer".
3. Cutscenes longas em combate (HSR ult).
4. Mapas/arvores de 1000+ nodes (PoE Atlas/Tree).
5. Daily/weekly checklist excessivo (Lost Ark, Genshin).

---

*Fim do documento. Ver tambem:* `reference-games.md`, `wiki-reference-list.md`.
