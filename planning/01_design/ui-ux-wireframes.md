# UI / UX Wireframes - Mockups e Fluxos de Navegacao

> Mockups ASCII (~25 linhas cada) e descricao de fluxo para cada tela principal do jogo.
> Convencoes: `[BotaoAssim]` = botao clicavel. `( )` = checkbox/radio off. `(X)` = on. `<text input>` = caixa de texto.
> Cross-references: `account-vs-character.md`, `classes-and-characters.md`, `enemies-catalog.md`, `pets-catalog.md`, `cards-catalog.md`.
> [DECISAO PENDENTE: tela orientacao] — assume-se desktop landscape 1280x720+ ou mobile portrait 1080x1920? Mockups abaixo sao landscape.

---

## Mapa global de navegacao

```
[Splash] -> [Title Screen] -> [Tela de Conta] -> [Roster Overview] (HUB CENTRAL)
                                |
                                +-- [Character Modal] -- [Equipment Screen]
                                |                       -- [Skill Tree]
                                |                       -- [Constelacao] (post-renascimento)
                                |
                                +-- [Battle View] (camera de personagem ativo)
                                |       +-- [Map View] -- [Modal: info de zona/estagio/area]
                                |       +-- [Battle Log Panel]
                                |
                                +-- [Inventory] -- [Item detail tooltip]
                                |
                                +-- [Codex] -- [sub-aba: Bestiario / Materiais / NPCs / Zonas / Receitas / Cards / Pets]
                                |       +-- [Cards Album]
                                |       +-- [Bestiario detail]
                                |
                                +-- [Camp View] (vista do acampamento)
                                |       +-- [Crafting Hub] -- [Smithing/Smelting/Sawmill/Leather/Alchemy/Cooking/Enchanting]
                                |       +-- [Quest Log]
                                |       +-- [Market / Loja com Gold]
                                |       +-- [Loja Eterna]
                                |       +-- [Forja Cosmica] (post-renasc)
                                |       +-- [Biblioteca dos Antigos] (Cidade+)
                                |       +-- [Espelho dos Gemeos] (Reino+)
                                |
                                +-- [Dungeon Lobby] -- [Battle View party-mode]
                                +-- [Arena Lobby] -- [Battle View arena-mode]
                                +-- [Quest Log]
                                +-- [Renascimento Modal]
                                +-- [Transcendencia Modal] (post cap 1000)
                                +-- [Ascensao Cosmica Modal] (post-transcendencia)
                                +-- [Settings] -- [Audio/Video/Gameplay/Notif/Conta/Idioma]
                                +-- [Mercador Itinerante popup] (random encounter)
```

---

## 1. Splash Screen

```
+-----------------------------------------------------------+
|                                                           |
|                                                           |
|                                                           |
|                    [   LOGO DO JOGO   ]                   |
|                                                           |
|                  [ NOME DO JOGO IN PT ]                   |
|                                                           |
|                                                           |
|                                                           |
|                  Pressione qualquer tecla                 |
|                                                           |
|                                                           |
|                                                           |
|              v0.1.0          (c) Carlos Henrique          |
+-----------------------------------------------------------+
```

Fluxo: 2-3 segundos exibindo o logo, fade-in da musica menu_main. Qualquer input -> Title Screen. Em mobile, tap. Skip habilitado apos primeiro carregamento.

Botoes/inputs: nenhum visivel (pressionar tecla).

---

## 2. Title Screen (mostrada antes de Tela de Conta)

```
+-----------------------------------------------------------+
| [   LOGO   ]                                              |
|                                                           |
|                                                           |
|                       [   JOGAR   ]                       |
|                                                           |
|                       [ Continuar ]                       |
|                                                           |
|                       [   Opcoes  ]                       |
|                                                           |
|                       [   Sair    ]                       |
|                                                           |
|                                                           |
|              [bg parallax animado da Floresta]            |
|                                                           |
|        Versao 0.1.0     Build 20260506     [Creditos]     |
+-----------------------------------------------------------+
```

Fluxo: jogador clica Jogar/Continuar -> Tela de Conta. Opcoes -> Settings (modo limitado). Sair -> fechar. Background animado discreto.

---

## 3. Tela de Conta

```
+----------------------------------------------------------------+
| [<] Voltar                                Jogador: <Nome>     |
+----------------------------------------------------------------+
|                                                                |
|  +-----------------------+  +-------------------------------+  |
|  |  ESTATISTICAS DA      |  |    SELOS DE CONTA             |  |
|  |  CONTA                |  |  +---+ +---+ +---+ +---+ +---+|  |
|  |  Tempo total: 23h     |  |  | s1| | s2| | s3| | s4| | + ||  |
|  |  Ouro: 2.450          |  |  +---+ +---+ +---+ +---+ +---+|  |
|  |  Gemas Eternid.: 12   |  |  Total: 4 / 50                |  |
|  |  Achievements: 18/120 |  +-------------------------------+  |
|  |  Cards: 6/87          |                                     |
|  |  Pets: 1/30           |  +-------------------------------+  |
|  |  Ascensoes: 0         |  |    CRONICAS DO MUNDO          |  |
|  +-----------------------+  |  Save criado em: 2026-04-12   |  |
|                             |  Memoria do Tempo: 24 dias    |  |
|  [Selos] [Cronicas]         |  Proximo marco: 30 dias       |  |
|  [Achievements]             |  [Trilha de bonus]            |  |
|  [Configuracoes]            +-------------------------------+  |
|                                                                |
|             [          ROSTER (entrar)           ]             |
+----------------------------------------------------------------+
```

Fluxo: pos-login. Mostra estatisticas globais + acessos a meta-sistemas de conta. Botao principal "Roster" leva pra hub.

Botoes principais:
- Selos -> modal de selos
- Cronicas -> modal de cronicas do mundo
- Achievements -> lista de achievements
- Configuracoes -> Settings
- Roster -> Roster Overview

---

## 4. Roster Overview (HUB CENTRAL)

```
+----------------------------------------------------------------+
| [<] Conta              ROSTER                  Ouro 2.450 [G]  |
| [Cidade] [Codex] [Quests]      [Vel: 1x 2x 4x 8x]   [Settings] |
+----------------------------------------------------------------+
| +-----------+ +-----------+ +-----------+ +-----------+        |
| | [retr   ] | | [retr   ] | | [retr   ] | | [+      ] |  +----+
| | Warrior   | | Mage      | | Ranger    | | Recrutar  |  | 5  |
| | Lv 47     | | Lv 32     | | Lv 28     | | Slot livre|  | 6  |
| | XP [###--]| | XP [#----]| | XP [##---]| |           |  | 7  |
| | HP [######| | HP [###--]| | HP [#####]| |           |  | 8  |
| | Atividade:| | Atividade:| | Atividade:| |           |  | 9  |
| | Combate   | | Mining    | | Pesca     | |           |  | 10 |
| | Floresta  | | Caverna   | | Lago      | |           |  +----+
| | st 3 a 4  | | spot 2    | | spot 1    | |           |        |
| | [Camera]  | | [Camera]  | | [Camera]  | | [Recrutar]|        |
| +-----------+ +-----------+ +-----------+ +-----------+        |
|                                                                |
| Notificacoes: 2 itens disponiveis (warrior tem upgrade)        |
+----------------------------------------------------------------+
```

Fluxo: tela inicial pos-conta. Mostra todos os personagens com status atual. "Camera" leva ao Battle View focado naquele personagem. Slots livres tem botao Recrutar (Taverna do acampamento).

Botoes principais:
- Cidade -> Camp View
- Codex -> Codex
- Quests -> Quest Log
- Vel x/2x/4x/8x -> alterna Engine.time_scale
- Settings -> Settings
- Camera (por card) -> Battle View
- Recrutar -> Taverna no Camp View

---

## 5. Battle View (refinada)

```
+----------------------------------------------------------------+
| [<-] Roster   Floresta > Estagio 3 > Area 4 > Wave 2/8         |
| Personagem: Warrior Lv 47    Vel: 1x 2x 4x 8x                  |
+----------------------------------------------------------------+
|                                                                |
|     [parallax bg Floresta]                                     |
|                                                                |
|    HP [#####-----] 320/500                                     |
|                                                                |
|       [Inimigo Slime Verde Lv 5]   HP [###-------] 18/30       |
|       [Inimigo Slime Verde Lv 5]   HP [##########] 30/30       |
|                                                                |
|    [Player Warrior (sprite)]   ATK in 0.4s                     |
|                                                                |
|    Status: [ATKup] [Shielded(8)]                               |
+----------------------------------------------------------------+
| [Mapa] [Inventario] [Skills(8)] [BattleLog]   Drops: 2  G+45   |
+----------------------------------------------------------------+
```

Fluxo: cena principal de combate. Header mostra zona/estagio/area/wave. Footer com botoes de acoes/info. Player + inimigo no centro com HP bars.

Botoes principais:
- Voltar -> Roster
- Mapa -> Map View (modal)
- Inventario -> Inventory modal
- Skills -> Skill loadout modal
- BattleLog -> slide-up panel (existe `battle_log_panel.tscn`)

---

## 6. Map View

```
+----------------------------------------------------------------+
| [X] Fechar              MAPA - Mundo                           |
+----------------------------------------------------------------+
|                                                                |
|  +------------------+  +-------------------+                   |
|  | [Floresta]       |  | [Deserto]         |                   |
|  | st 1 [###] 100%  |  | st 1 [#--] bloq   |                   |
|  | st 2 [###] 80%   |  | (Requer Florest 5)|                   |
|  | st 3 [#--] 30%   |  +-------------------+                   |
|  | [Entrar]         |                                          |
|  +------------------+  +-------------------+                   |
|                        | [Caverna]         |                   |
|  +------------------+  | bloqueada         |                   |
|  | [Pantano]        |  +-------------------+                   |
|  | bloqueada        |                                          |
|  +------------------+  +-------------------+                   |
|                        | [Tundra]   [Templo]                   |
|                        | bloqueada  bloqueada                  |
+----------------------------------------------------------------+
| Spots de Coleta: [Mining 3] [Wood 2] [Fishing 4] [Herb 1]      |
+----------------------------------------------------------------+
```

Fluxo: ao clicar em zona, expande estagios. Estagios destravados: clicar para entrar. Spots de coleta listados como atalho.

Modal de info da area/estagio/zona (popup ao hover/click longo): inimigos presentes, drops, recomendacao de stat, NPCs, completude.

---

## 7. Inventory

```
+----------------------------------------------------------------+
| [X] Inventario - Warrior          Capacidade 142/200 [G]old    |
+----------------------------------------------------------------+
| Filtros: [Todos][Equip][Materiais][Consum][Quest]  Ord: [Tier] |
| Search: <             >                       [Lupa]           |
+----------------------------------------------------------------+
| +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+    |
| | I |R| I | | I | | I | | I | | I | | I | | I | | I | | I |   |
| +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+    |
| (sword Common) (shield Rare) (slime_goo x12) ...               |
| +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+    |
| | I | | I | | I | | I | | I | | I | | I | | I | | I | | I |   |
| +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+ +---+    |
|                                                                |
| Tooltip de item:                                               |
| +-----------------------------------+                          |
| | Espada de Treino (Common +0)      |                          |
| | ATK +5    Tipo: Slash             |                          |
| | "Uma espada simples..."           |                          |
| | [Equipar][Vender][Reforjar]       |                          |
| +-----------------------------------+                          |
+----------------------------------------------------------------+
```

Fluxo: grid 10x6+. Filtros + search + ordenacao. Click em slot abre tooltip rico com botoes de acao.

Botoes principais:
- Equipar -> aplica item, atualiza paperdoll do personagem
- Vender -> dialogo de confirmacao + adiciona gold
- Reforjar -> abre Crafting Hub na aba Reforjar com item pre-selecionado

---

## 8. Equipment Screen (Paperdoll)

```
+----------------------------------------------------------------+
| [X] Equipamento - Warrior Lv 47                                |
+----------------------------------------------------------------+
| +------------+              +-------------------------------+  |
| | [Capacete] |              | STATS DERIVADOS               |  |
| | Cap Couro  |              | HP 500/500   ATK 145          |  |
| +------------+              | MP 80/80     M.ATK 12         |  |
| | [Peito  ]  |              | DEF 32       M.DEF 8          |  |
| +------------+              | CRIT% 12     ATK SPD 1.2/s    |  |
| | [Calcas ]  | [Arma vis]   | DODGE% 5     LUCK 7           |  |
| +------------+ [Skin Comp]  +-------------------------------+  |
| | [Botas  ]  | [Asas    ]                                     |
| +------------+              +-------------------------------+  |
| | [Colar  ]  |              | RESISTENCIAS                  |  |
| +------------+              | Fire 0%   Ice 5%   Elec 0%    |  |
| | [Brincos]  |              | Stat resist (poison 10%, ...) |  |
| +------------+              +-------------------------------+  |
| | [Anel1] [Anel2]                                              |
| +------------+              +-------------------------------+  |
| | [Bracelete]|              | CARDS EQUIPADOS (3/15)        |  |
| +------------+              | [s1][s2][ ][ ][ ][ ][ ][ ][ ] |  |
| | [Arma   ]  |              +-------------------------------+  |
| +------------+                                                 |
| | [Picareta] [Machado] [Vara]                                  |
| +------------+                                                 |
+----------------------------------------------------------------+
```

Fluxo: paperdoll com 13 slots de equipamento + 3 ferramentas + slots visuais (arma visual, skin completa, asas). Cards equipados em grid lateral.

Botoes principais:
- Click slot -> abre Inventory filtrado pra aquele slot
- Click stats -> tooltip detalhado da formula
- Click cards -> abre Cards Album

---

## 9. Crafting Hub

```
+----------------------------------------------------------------+
| [X] Forja & Oficinas       Acampamento Estagio 2 - Vilarejo    |
+----------------------------------------------------------------+
| Sub-abas: [Smith][Smelt][Sawmill][Leather][Alch][Cook][Ench]   |
+----------------------------------------------------------------+
| Aba SMITHING (selecionada):                                    |
|                                                                |
| Receitas conhecidas:                                           |
| +-------------------+ +-------------------+ +----------------+ |
| | Espada de Bronze  | | Capacete Couro    | | Escudo Madeira | |
| | Mat: 5 Bronze     | | Mat: 3 Couro      | | Mat: 4 Tora    | |
| | 2 Madeira         | | 1 Linha           | |                | |
| | [Craftar]         | | [Craftar]         | | [Craftar]      | |
| +-------------------+ +-------------------+ +----------------+ |
|                                                                |
| Refinar / Reforjar / Quebra de Limite:                         |
| Selecione um item: <slot vazio>  [Selecionar]                  |
|                                                                |
| Tempo de craft: instant (estagio 1) / 30s (estagio 2+)         |
+----------------------------------------------------------------+
```

Fluxo: 7 sub-abas. Cada uma lista receitas conhecidas + acoes especiais (Refinar/Reforjar). Tempo de craft pode ser instant ou real-time conforme upgrade.

---

## 10. Codex

```
+----------------------------------------------------------------+
| [X] Codex                                                      |
+----------------------------------------------------------------+
| Sub-abas:                                                      |
| [Bestiario][Materiais][NPCs][Zonas][Receitas][Cards][Pets]     |
+----------------------------------------------------------------+
| Aba BESTIARIO (selecionada):                                   |
|                                                                |
| +----+ +----+ +----+ +----+ +----+ +----+ +----+ +----+        |
| | sl | | sl | | sl | | go | | wf | | rt | | ?? | | ?? |        |
| | gv | | sb | | sr | | bl | | wf | | rt | | un | | un |        |
| +----+ +----+ +----+ +----+ +----+ +----+ +----+ +----+        |
| Slime Verde 100k kills [#####] Buff +50% dmg vs Slime Verde    |
|                                                                |
| Detalhe selecionado:                                           |
| Slime Verde - Slime, Aquatico, Caster, Water                   |
| HP 30, ATK 8, DEF 1                                            |
| Drops: Slime Goo (60%), Aqua Drop (5%)                         |
| Mob Slaughter: 100k / 1M (atual: 23.450)                       |
| [Ir ao mapa] [Ver Card] [Ver no Album]                         |
+----------------------------------------------------------------+
```

Fluxo: 7 sub-abas. Bestiario mostra grid de inimigos descobertos + detalhe + Mob Slaughter progress. Inimigos nao encontrados aparecem como `??`.

---

## 11. Camp View

```
+----------------------------------------------------------------+
| [<] Roster        ACAMPAMENTO - Vilarejo (Estagio 2)           |
+----------------------------------------------------------------+
|                                                                |
|     [bg isometrico do vilarejo, parallax]                      |
|                                                                |
|     [Forja]   [Alquimia]   [Cozinha]                           |
|                                                                |
|     [Fogueira]   [Bancada]   [Plantio]                         |
|                                                                |
|     [Currais]   [Taverna]                                      |
|                                                                |
|     (personagens andam livremente entre estruturas)            |
|                                                                |
+----------------------------------------------------------------+
| [Crafting] [Quests] [Mercado] [Lojas] [Forja Cosmica?]         |
+----------------------------------------------------------------+
```

Fluxo: vista 2D/isometrica do acampamento. Personagens desbloqueados andam aleatoriamente (nao manuais). Estruturas desbloqueadas estao visiveis e clicaveis. Footer da acesso rapido aos sub-sistemas.

Estruturas adicionais aparecem em estagios maiores (Forja Cosmica em Reino+, etc.).

---

## 12. Settings

```
+----------------------------------------------------------------+
| [X] Configuracoes                                              |
+----------------------------------------------------------------+
| Abas: [Audio][Video][Gameplay][Notif][Conta][Idioma]           |
+----------------------------------------------------------------+
| Aba AUDIO:                                                     |
|   Master volume:  [-----o------] 70%                           |
|   Musica:         [-----o------] 60%                           |
|   SFX combate:    [-----o------] 80%                           |
|   SFX UI:         [-----o------] 50%                           |
|   Ambient:        [-----o------] 40%                           |
|   Voz:            [---o--------] 30%                           |
|                                                                |
| Aba GAMEPLAY (preview):                                        |
|   Velocidade default: [1x] [2x] [4x] [8x]                      |
|   Auto-equip melhor: ( )                                       |
|   Auto-loot: (X)                                               |
|   Mostrar numeros HP no inimigo: (X)                           |
|   Confirmar venda de itens Rare+: (X)                          |
|                                                                |
| [Backup manual agora]   [Carregar backup...]                   |
+----------------------------------------------------------------+
```

Fluxo: 6 abas de configuracoes. Backup manual disponivel.

---

## 13. Dungeon Lobby

```
+----------------------------------------------------------------+
| [X] Dungeon - Cripta dos Antigos                               |
+----------------------------------------------------------------+
| Dificuldade: [Normal] [Hard] [Heroic] [Mythic]                 |
| Tokens disponiveis: 12     Recompensa: 3-5 tokens / set piece  |
+----------------------------------------------------------------+
| Formacao 3x2 (frente -> tras):                                 |
|                                                                |
|   [Front L]   [Mid L]   [Back L]                               |
|   Warrior     Cleric     Mage                                  |
|   Lv 47       Lv 30      Lv 32                                 |
|                                                                |
|   [Front R]   [Mid R]   [Back R]                               |
|   <vazio>     Ranger     <vazio>                               |
|                                                                |
| Layouts salvos: [Tank+DPS] [Burst] [Sustain] [+ Salvar atual]  |
|                                                                |
| Sinergias detectadas:                                          |
| - Warrior aura: +20% def adjacentes                            |
| - Mage aura: +15% magic dmg coluna trás                        |
+----------------------------------------------------------------+
| [Iniciar Dungeon]                                              |
+----------------------------------------------------------------+
```

Fluxo: jogador escolhe dungeon, dificuldade, monta party na grade 3x2 arrastando personagens. Sinergias atualizam em tempo real. Layouts salvos pra trocar rapido.

---

## 14. Arena Lobby

```
+----------------------------------------------------------------+
| [X] Arena dos Gladiadores       Rank atual: Prata III          |
+----------------------------------------------------------------+
| [Banner do rank] [Glory] 145                                   |
|                                                                |
| Oponentes do dia (rotacao 4h):                                 |
| +------------------+ +------------------+ +------------------+ |
| | Inimigo A        | | Inimigo B        | | Inimigo C        | |
| | Lv 50, dificil   | | Lv 45, medio     | | Lv 55, hard      | |
| | Recomp: 25 Glory | | Recomp: 15 Glory | | Recomp: 40 Glory | |
| | [Lutar]          | | [Lutar]          | | [Lutar]          | |
| +------------------+ +------------------+ +------------------+ |
|                                                                |
| Recompensas semanais (rank Prata): 200 Glory + cosmetico       |
|                                                                |
| Loja da Arena: [Abrir]                                         |
+----------------------------------------------------------------+
```

Fluxo: lista de 3 oponentes do dia + recompensas semanais. Loja vende cosmeticos exclusivos por Glory.

---

## 15. Quest Log

```
+----------------------------------------------------------------+
| [X] Quests                                                     |
+----------------------------------------------------------------+
| Abas: [Main][Side][Daily][Weekly]                              |
+----------------------------------------------------------------+
| Aba DAILY:                                                     |
|                                                                |
| [#] Mate 50 Slimes Verdes        [######-] 32/50  [Reivindic]  |
| [#] Colete 20 Madeira de Carvalho [#####-] 18/20  [Reivindic]  |
| [#] Pesque 5 Trutas               [###---]  3/5   [Reivindic]  |
| [#] Craft 3 Pocoes de Cura        [######] 3/3    [REIVINDICAR]|
|                                                                |
| Reset em: 14h 23m                                              |
+----------------------------------------------------------------+
```

Fluxo: 4 tabs. Cada quest tem progresso visivel + botao Reivindicar quando completa.

---

## 16. Cards Album

```
+----------------------------------------------------------------+
| [X] Album de Cards            Total: 6/87 (Reg) 0/3 (Cor) 0(Gd)|
+----------------------------------------------------------------+
| Abas: [Regular] [Corrupted] [Greedy]                           |
+----------------------------------------------------------------+
| Pagina 1 / 6 (Categoria: Slime)                 [<] [>]        |
|                                                                |
| +------+ +------+ +------+ +------+ +------+                   |
| | sl_v | | sl_b | | sl_r | | ???  | | ???  |                   |
| | C ★3 | | C ★1 | | U ★2 | | unkn | | unkn |                   |
| +------+ +------+ +------+ +------+ +------+                   |
|                                                                |
| Bonus de set (5 cards Slime): +10% dmg vs Slime                |
| Bonus de pagina completa: +1% gold permanente                  |
|                                                                |
| Card selecionado: Slime Verde [C] ★3                           |
| Buff: +1.5% drop rate vs Slimes                                |
| [Equipar em slot vazio]                                        |
+----------------------------------------------------------------+
```

Fluxo: 3 abas (Regular/Corrupted/Greedy). Paginas por categoria de inimigo. Cards desbloqueados visiveis, restantes como `???`.

---

## 17. Bestiario (sub-aba de Codex)

```
+----------------------------------------------------------------+
| [X] Codex > Bestiario                                          |
+----------------------------------------------------------------+
| Filtro: [Floresta] [Deserto] [Caverna] [...] [Todos]           |
+----------------------------------------------------------------+
| Slime Verde (Slime, Aquatic, Water)                            |
| Kills: 23.450 / 100.000 next milestone                         |
| Buff atual: +20% dmg vs Slime Verde                            |
| Drops: Slime Goo 60%, Aqua Drop 5% (1k+ desbloqueado)          |
|                                                                |
| Goblin de Cobre (Humanoid, Grounded, Melee, Earth)             |
| Kills: 8.200 / 10.000                                          |
| Buff atual: +5% dmg vs Goblin                                  |
| Drops: Cobre 40%, Couro Bruto 20%                              |
|                                                                |
| ??? (nao descoberto)                                           |
+----------------------------------------------------------------+
```

---

## 18. Skill Tree

```
+----------------------------------------------------------------+
| [X] Skill Tree - Warrior                Pontos: 12 disponiveis |
+----------------------------------------------------------------+
| Ramos: [Berserker] [Defender] [Tactician]                      |
+----------------------------------------------------------------+
|                                                                |
|         (no inicial)                                           |
|              |                                                 |
|       [+ATK 5%] o ---- o [+HP 50]                              |
|              |              |                                  |
|       [Cleave]              [Shield Wall]                      |
|              |              |                                  |
|       [Rage  ] o------------o [Counter]                        |
|                                                                |
| Pre-req visiveis em hover. Desbloqueio com pontos.             |
| [Reset com pergaminho] [Confirmar mudancas]                    |
+----------------------------------------------------------------+
```

Fluxo: visualizacao de nos por classe. Cores: cinza (locked), branco (disponivel), dourado (ativo). Pre-req em hover.

---

## 19. Constelacao

```
+----------------------------------------------------------------+
| [X] Constelacoes (desbloqueado apos Renascimento #1)           |
+----------------------------------------------------------------+
| Abas: [Cacador] [Coletor] [Forjador] [Andarilho] [Sortudo]     |
+----------------------------------------------------------------+
|                                                                |
|   *  Cacador (5/15 nodes)                                      |
|     /                                                          |
|    *--- *                                                      |
|    |                                                           |
|    *                                                           |
|     \                                                          |
|      *--*--*  (pendente: 800 Slime Goo + 200 Madeira)          |
|                                                                |
| Pontos disponiveis: 3                                          |
| Para desbloquear node "Olho de Aguia": 100 Pontos + 50 ervas   |
+----------------------------------------------------------------+
```

Fluxo: vista cosmica das 5 constelacoes. NPC "O Transcendido" disponibiliza progresso. Cada node pede recursos especificos.

---

## 20. Renascimento Modal

```
+----------------------------------------------------------------+
|                                                                |
|         RENASCIMENTO - Warrior (Lv 100)                        |
|                                                                |
| Voce esta prestes a renascer.                                  |
|                                                                |
| Estrelas atuais: ★★★★☆☆☆☆☆☆ (4/10)                              |
| Apos renascer: ★★★★★☆☆☆☆☆ (5/10)                                |
|                                                                |
| Em ★5, voce desbloqueia o no de escolha:                       |
|   [Cavaleiro Sagrado] -- foco em defesa, healing               |
|   [Berserker do Caos] -- foco em DPS bruto, autodano           |
|                                                                |
| O que e RESETADO:                                              |
| - Nivel, XP, equipamento, inventario                           |
| - Skill tree, mastery, kill counts pessoais                    |
| - Codex de materiais deste personagem                          |
|                                                                |
| O que e MANTIDO:                                               |
| - Codex (Bestiario, NPCs, Zonas, Receitas, Cards)              |
| - Pets, Album, Selos, Compras da Loja Eterna                   |
|                                                                |
| Voce vai ganhar acesso ao "Chakra" (loja de renascimento).     |
|                                                                |
|     [Cancelar]    [Renascer e escolher ramo]                   |
+----------------------------------------------------------------+
```

---

## 21. Transcendencia Modal

```
+----------------------------------------------------------------+
|         TRANSCENDENCIA - Warrior (Lv 1000)                     |
|                                                                |
| Voce completou o codex pre-transcendido. Pronto para           |
| transcender.                                                   |
|                                                                |
| Calculo de Transcended Points:                                 |
|   Base do level cap        : 100                               |
|   Bonus por estrelas (10★) : 200                               |
|   Bonus por achievements   : 30                                |
|   Total convertido         : 330                               |
|                                                                |
| Apos transcender:                                              |
| - Personagem inicia Lv 1 com escala maior (+200% stats base)   |
| - Codex evolui para Codex Transcendido (novos inimigos)        |
| - Acesso a Arvore de Transcendencia                            |
|                                                                |
| Mantido: pets, codex, conquistas, compras Loja Eterna          |
| Resetado: nivel, XP, equip, materiais, skill points            |
|                                                                |
|     [Cancelar]    [Transcender]                                |
+----------------------------------------------------------------+
```

---

## 22. Ascensao Cosmica Modal

```
+----------------------------------------------------------------+
|         ASCENSAO COSMICA                                       |
|                                                                |
| Voce reseta TODA a conta.                                      |
|                                                                |
| Multiplicador Cosmico atual: 1.0x                              |
| Apos ascender: 1.5x (todos personagens, todos os stats)        |
|                                                                |
| Moedas Galacticas a serem creditadas: 12                       |
|                                                                |
| Mantido: Cards, Bestiario, Pets, Compras Loja Eterna,          |
|          Conquistas, pontos de Constelacao.                    |
| Resetado: TODO o resto - personagens, niveis, equipamentos,    |
|          gathering, mastery, gold, etc.                        |
|                                                                |
| Voce desbloqueia a "Forja Galactica" e dificuldade NG+.        |
|                                                                |
|     [Cancelar]    [Ascender]                                   |
+----------------------------------------------------------------+
```

---

## 23. Forja Cosmica

```
+----------------------------------------------------------------+
| [X] Forja Cosmica (desbloqueada apos Renascimento #1)          |
+----------------------------------------------------------------+
| Esquirlas Estelares disponiveis: 23                            |
+----------------------------------------------------------------+
| Upgrades:                                                      |
| - Crafting success rate +1% por level (atual: Lv 5/20)         |
|   [Custo: 5 esquirlas] [Aplicar]                               |
| - Custo de craft -2% por level (atual Lv 2/15)                 |
|   [Custo: 8 esquirlas] [Aplicar]                               |
| - Receitas exclusivas:                                         |
|   - Espada Estelar (200 esquirlas) -- Mythic                   |
+----------------------------------------------------------------+
```

---

## 24. Biblioteca dos Antigos

```
+----------------------------------------------------------------+
| [X] Biblioteca dos Antigos (Cidade+)                           |
+----------------------------------------------------------------+
| Conhecimento depositado: 4.520                                 |
|                                                                |
| Tomos disponiveis:                                             |
| - Tomo do Combate (custo 1000) [Lido]                          |
|   Bonus: +5% damage permanente                                 |
| - Tomo da Coleta (custo 1500) [Comprar e Ler]                  |
|   Bonus: +10% gathering speed                                  |
| - Tomo da Sorte (custo 3000) [Comprar e Ler]                   |
|   Bonus: +5% drop rate                                         |
+----------------------------------------------------------------+
```

---

## 25. Espelho dos Gemeos

```
+----------------------------------------------------------------+
| [X] Espelho dos Gemeos (Reino+)        Cooldown: 18h restantes |
+----------------------------------------------------------------+
| Voce pode criar uma sombra 1x por dia (24h).                   |
| Sombra ativa: nenhuma                                          |
|                                                                |
| Selecione um personagem:                                       |
| ( ) Warrior Lv 47                                              |
| ( ) Mage Lv 32                                                 |
| ( ) Ranger Lv 28                                               |
|                                                                |
| Sombra: 50% dos stats, dura 24h, farma em paralelo.            |
| [Criar Sombra]                                                 |
+----------------------------------------------------------------+
```

---

## 26. Loja Eterna

```
+----------------------------------------------------------------+
| [X] Loja Eterna     Gemas da Eternidade: 47                    |
+----------------------------------------------------------------+
| Abas: [Slots][Automacao][Melhorias][Cosmeticos][Resets][Tempo] |
+----------------------------------------------------------------+
| Aba SLOTS:                                                     |
| - Slot de inventario (+10): 5 Gemas [Comprar]                  |
| - Slot de personagem (+1, max 11): 100 Gemas [Comprar]         |
| - Slot de card extra (+1): 20 Gemas [Comprar]                  |
|                                                                |
| Aba TEMPO OFFLINE:                                             |
| - Cap 12h -> 24h: 50 Gemas [Comprar]                           |
| - Cap 24h -> 48h: 200 Gemas [Comprar]                          |
+----------------------------------------------------------------+
```

---

## 27. Loja com Gold

```
+----------------------------------------------------------------+
| [X] Mercado da Cidade            Ouro: 2.450                   |
+----------------------------------------------------------------+
| Abas: [Diaria] [Permanente]                                    |
+----------------------------------------------------------------+
| Aba DIARIA (rotacao em 14h 23m):                               |
| - Pocao de Cura Pequena x10: 50g [Comprar]                     |
| - Pergaminho de Protecao: 200g [Comprar]                       |
| - Cobre x20: 80g [Comprar]                                     |
| - Carne de Lobo x5: 60g [Comprar]                              |
| - Pet Cao Comum: 5000g [Comprar]                               |
|                                                                |
| Aba PERMANENTE:                                                |
| - Equipamento Common (varios): 30-150g                         |
| - Pocoes regen base: 10-50g                                    |
+----------------------------------------------------------------+
```

---

## 28. Mercador Itinerante (popup)

```
+----------------------------------------------------------------+
|        MERCADOR ITINERANTE                                     |
|                                                                |
| "Tenho mercadorias raras. Olhe rapido."                        |
|                                                                |
| Itens (rotacao desta visita):                                  |
| - Pergaminho de Encantamento Refinado: 800g [Comprar]          |
| - Pedra de Stat Tier 5: 1500g [Comprar]                        |
| - Pet Misterioso (50% chance Rare+): 2000g [Comprar]           |
|                                                                |
| O Mercador parte em: 12 minutos                                |
|                                                                |
|     [Fechar]                                                   |
+----------------------------------------------------------------+
```

Fluxo: popup random encounter no Camp View. Rotacao limitada por sessao.

---

## Decisoes pendentes consolidadas

1. **[DECISAO PENDENTE: tela orientacao]** — desktop landscape ou mobile portrait?
2. ~~[DECISAO PENDENTE: drag-and-drop ou click-click no inventory/equipment].~~ **[RESOLVIDO 2026-05-13: click-to-place estilo Minecraft/Terraria. Click pega item (slot esvazia, ghost gruda no cursor), click no destino solta. ESC/backdrop cancelam. Dominios isolados: inventory<->equipment livre com filtro slot_type; artifact pool nao mistura. Ver `scenes/ui/drag/drag_manager.gd`].**
3. **[DECISAO PENDENTE: Cidade tem walking-mode no Camp ou e UI hub estatica?].**
4. **[DECISAO PENDENTE: Battle View tem botao Pausar?]** — para idle puro nao faz sentido pausar; mas para readability de boss faz.
5. **[DECISAO PENDENTE: Mercador Itinerante usa real-time clock ou trigger de evento?].**
6. **[DECISAO PENDENTE: dungeons - solo permitido com 1 personagem ou minimo 3?].**
7. **[DECISAO PENDENTE: salvar layouts de formacao com nomes customizaveis].**
