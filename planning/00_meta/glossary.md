# Glossario - Terminologia Oficial do Projeto

> Quando introduzir termo novo em qualquer doc ou codigo, adicionar aqui. Termo unico, definicao curta, link pro arquivo onde foi introduzido (se aplicavel).

---

## Estrutura de mundo

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Zona** | Bioma macro (Floresta, Deserto, Caverna...). Cada zona tem N estagios. | `enemies-catalog.md` |
| **Estagio** | Subdivisao de uma zona. Cada estagio tem N areas. | `enemies-catalog.md` |
| **Area** | Subdivisao de um estagio. Cada area contem N waves. | `enemies-catalog.md` |
| **Wave** | Conjunto de 1 a 8 inimigos que aparecem juntos. | `enemies-catalog.md` |
| **Spot** | Ponto especifico no mapa de uma zona usado para Gathering (substitui o antigo botao Gathering). | `gathering-materials.md` |

## Personagem e progressao

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Roster** | Conjunto de todos os personagens do jogador (start: 1, max inicial: 10). | `account-vs-character.md` |
| **Classe** | Tipo de personagem (Warrior, Mage, etc.). Define skills base e afinidades. | `classes-and-characters.md` |
| **Awakening / Estrela (1-10)** | Nos de evolucao apos primeiro Renascimento. Cada estrela libera/melhora skills, em 3/5/7/9/10 abre escolha de ramo. | `classes-and-characters.md` |
| **Ramo de evolucao** | Caminho mutuamente exclusivo escolhido em uma estrela (ex: Cavaleiro Sagrado vs Berserker do Caos). | `classes-and-characters.md` |
| **Renascimento** | Reset do personagem ao atingir level cap. Ganha estrelas + acesso ao Chakra (loja de renascimento). | `ascension-multipliers.md` |
| **Transcendencia** | Reset profundo apos cap 1000 + completude de codex. Converte progresso em Transcended Points. | `ascension-multipliers.md` |
| **Ascensao Cosmica** | Reset de conta-toda. Ganha Moedas Galacticas + multiplicador Cosmico. | `ascension-multipliers.md` |
| **Transcended Points** | Moeda da Arvore de Transcendencia. | `ascension-multipliers.md` |
| **Moeda Galactica** | Moeda da Forja Galactica, dropada apos primeira Ascensao. | `ascension-multipliers.md` |

## Combate

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Tipo de ataque** | Slash, Stab, Crush, Blunt, Magic, Pierce, Lacerate. Define resistencia/fraqueza vs inimigo. | `damage-formula.md` |
| **Status** | Buff/debuff aplicado em batalha (Poison, Burning, Slowed, Bleeding, etc.). | `damage-formula.md` |
| **Bleeding stack** | Acumulo de Lacerate ate 20x; explode em dano massivo. | `damage-formula.md` |
| **Elite** | Versao mais forte e rara de um inimigo comum. Drop x3 + drop raro garantido. | `enemies-catalog.md` |
| **Shiny** | Versao dourada ultra-rara. Card unico desbloqueia aba "GREEDY" do album. | `enemies-catalog.md` |
| **Mob Slaughter** | Sistema de marcos de kill (10/100/1k/10k/100k/1M) que liberam buffs e info do bestiario. | `enemies-catalog.md` |

## Coleta e crafting

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Mastery** | Nivel proprio de cada item dentro de uma skill (ex: "Pescar Truta" 1-99 separado de "Pescar Tubarao"). | `gathering-materials.md` |
| **Smelting** | Refinamento de minerios em barras. | `crafting-catalog.md` |
| **Sawmill** | Refinamento de toras em pranchas. | `crafting-catalog.md` |
| **Leatherworking** | Refinamento de couro. | `crafting-catalog.md` |
| **Smithing** | Forja de equipamento metalico. | `crafting-catalog.md` |
| **Reforjar** | Re-rolar affixes de um equipamento. | `crafting-catalog.md` |
| **Refinar (+N)** | Subir stats base do item, com chance de falha. | `crafting-catalog.md` |
| **Quebra de Limite** | Combinar 3 itens do mesmo tier para tentar 1 item de tier superior. | `crafting-catalog.md` |
| **Pedra de Stat** | Material 1-8 que adiciona valor flat a um stat especifico da arma. | `crafting-catalog.md` |

## Encantamentos

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Encantamento** | Buff aplicado em equipamento (slot adicional). | `equipment-catalog.md` |
| **Tier de Encantamento** | mundane (cap 3), refined (cap 6), unreal (cap 9), eternal (cap 10). | `equipment-catalog.md` |
| **Nivel de Encantamento** | I-X (1-10) em algoritimos romanos. Trava por tier. | `equipment-catalog.md` |

## Pets, cards, codex

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Pet de combate** | Acompanha personagem na luta. Da apenas dano. | `pets-catalog.md` |
| **Pet de buff** | Equipado em slot proprio. Da bonus passivo. | `pets-catalog.md` |
| **Pet de expedicao** | Atribuido a missao com timer real. | `pets-catalog.md` |
| **Card** | Drop colecionavel. Equipavel em slots, dao buff ativo. | `cards-catalog.md` |
| **Card Corrupted** | Card de inimigo Elite. Desbloqueia aba propria do album. | `cards-catalog.md` |
| **Card Greedy** | Card de inimigo Shiny. Desbloqueia aba "GREEDY". | `cards-catalog.md` |
| **Set de Cards** | Equipar 3, 5 ou 7 da mesma categoria ativa bonus. | `cards-catalog.md` |
| **Codex** | Referencia interna do jogo. Subsecoes: Bestiario, Materiais, NPCs, Zonas, Receitas, Cards, Pets. | `01_design/` (varios) |

## Acampamento e meta

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Acampamento** | Hub. Evolui para Vilarejo -> Cidade -> Reino -> Imperio. | `phase-XX-*.md` |
| **Selo** | Passiva de conta ganha por achievement global. | `account-vs-character.md` |
| **Titulo** | Buff passivo unico ganho por achievement. Todos os titulos ficam ativos simultaneamente. | `account-vs-character.md` |
| **Constelacao** | Segunda arvore de talentos, late-game. Desbloqueada apos Renascimento #1. | `phase-04-late-game.md` |
| **Forja Cosmica** | Forja gigante destrancada apos Renascimento #1. Alimentada por Esquirla Estelar. | `phase-05-end-game.md` |
| **Biblioteca dos Antigos** | Estrutura do estagio Cidade+. Conhecimento depositado por completar codex pages. | `phase-05-end-game.md` |
| **Espelho dos Gemeos** | Estrutura do estagio Reino+. 1x/dia cria sombra de personagem que farma 24h em paralelo. | `phase-05-end-game.md` |
| **Cronicas do Mundo** | Sistema de tempo real-time desde criacao do save com bonus por milestone. | `phase-05-end-game.md` |
| **Selo de Lideranca** | Bonus de party ativo so em dungeon/boss com outros personagens. | `phase-05-end-game.md` |

## Moedas

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Gold** | Moeda primaria. | - |
| **Gemas da Eternidade** | Moeda premium nao-pay-to-win. Ganha por prestige/achievements/eventos/quest/free-gift/tempo-jogo. | `account-vs-character.md` |
| **Glory** | Moeda da Arena. | `04_phases/` |
| **Tokens de Dungeon** | Moeda de dungeons. | `04_phases/` |
| **RP / Pontos de Renascimento** | Moeda do Chakra (loja de Renascimento), gerada ao renascer. | `02_math/ascension-multipliers.md` |
| **TP / Transcended Points** | Moeda da Arvore de Transcendencia. | `02_math/ascension-multipliers.md` |
| **Energia Cosmica (EC)** | Recurso de uso do Acelerador Cosmico. | `02_math/ascension-multipliers.md` |
| **Po Demoniaco / Po Elemental** | Moedas de invasao (eventos). | `01_design/events-catalog.md` |

## Termos adicionais (consolidacao pos-agentes)

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **T-level** | Nivel acumulado de nos da Arvore de Transcendencia (substitui level apos transcender). | `02_math/ascension-multipliers.md` |
| **Soft cap (level)** | L100, ponto onde stats base passam a crescer em log. | `02_math/progression-curves.md` |
| **Element Matrix** | Tabela 8x8 de vantagens elementais. | `02_math/damage-formula.md` |
| **Armor Type Matrix** | Tabela 7x4 de tipo-de-ataque vs tipo-de-armadura. | `02_math/damage-formula.md` |
| **Mythic Pity Threshold** | 100 legendary sem mythic forca proximo legendary virar mythic. | `02_math/drop-rates.md` |
| **Esquirla Estelar** | Material que alimenta a Forja Cosmica. | `04_phases/phase-05-end-game.md` |
| **Memoria do Tempo** | Recompensa de Cronicas do Mundo (milestone real-time). | `04_phases/phase-05-end-game.md` |
| **Chakra** | Loja interna de Renascimento. Gasta Pontos de Renascimento. | `01_design/account-vs-character.md` |
| **offline_cap_hours** | Campo do save: limite de horas de progressao offline acumulada. | `01_design/save-offline-spec.md` |
| **integrity_hash** | Hash de validacao do save (anti-cheat soft, nao encripta). | `01_design/save-offline-spec.md` |
| **last_offline_at_unix** | Timestamp Unix do ultimo logout, base do calculo offline. | `01_design/save-offline-spec.md` |
| **Layered sprites** | Tecnica de arte: equipamento e' sobreposto ao sprite-base do personagem. [DECISAO PENDENTE] | `01_design/graphics-needs.md` |
| **Slot fixo** | Slot extra de gema que so aparece em itens Mythic. | `01_design/equipment-catalog.md` |
| **Bonus de Colecao** | Stat passivo permanente por registrar item novo na Colecao de Equipamentos. | `01_design/equipment-catalog.md` |
| **Skill assinatura** | Skill final do ramo de Awakening, liberada em 10 estrelas. | `01_design/classes-and-characters.md` |
| **Familiar** | Invocacao temporaria do Druida (com timer). | `01_design/skills-catalog.md` |
| **Pool de magma / Pool de Burning** | Terreno modificado por skill (efeito persistente em area). | `01_design/skills-catalog.md` |
| **Furia** | Stack do Senhor da Furia (Berserker). | `01_design/skills-catalog.md` |
| **Banquete** | Refeicao Cooking lv 30+ que da buff de 60 min real-time. | `01_design/crafting-catalog.md` |
| **Pomada / Po / Cha** | Categorias liquidas/solidas de Alchemy alem da Pocao classica. | `01_design/crafting-catalog.md` |
| **Pagina do album** | Sub-divisao das abas de Cards (Regular, Corrupted, Greedy). | `01_design/cards-catalog.md` |
| **Aba do album** | Sub-divisao maior do Album (3 abas: Regular, Corrupted, Greedy). | `01_design/cards-catalog.md` |
| **Card Drop Chance recursivo** | Bonus do boss Greedy do bioma 6 que aumenta a propria chance. | `01_design/cards-catalog.md` |
| **Quest giver itinerante** | NPC que aparece fora do Acampamento, em zonas. | `01_design/npcs-catalog.md` |
| **Mensageira do Cosmos** | NPC que aparece pos-Ascensao, da quests cosmicas. | `01_design/npcs-catalog.md` |
| **Pagina de Lenda** | Recompensa de quest de lore. Acumula em album proprio. | `01_design/quests-catalog.md` |
| **Roster Overview** | Tela inicial pos-login mostrando todos os personagens e suas atividades. | `01_design/ui-ux-wireframes.md` |
| **Bau Compartilhado** | Inventario partilhado entre personagens [DECISAO PENDENTE: Reino+]. | `01_design/account-vs-character.md` |
| **Spot** | Ponto de gathering no mapa (substitui o antigo botao Gathering). | `01_design/gathering-materials.md` |
| **[BOSS EVENTO] / [BOSS INVASAO]** | Categorias de boss limitado por tempo. | `01_design/events-catalog.md` |

## Termos da Fase 0 (codigo)

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **save_version** | Inteiro no JSON do save indicando schema version. Atual: 1. | `autoload/save_manager.gd` |
| **integrity_hash** | sha256 do conteudo do save sem o proprio campo de hash. Detecta modificacao manual. | `autoload/save_manager.gd` |
| **offline_summary** | Dictionary retornado por `OfflineSimulator.simulate()` com ganhos por personagem. Aplicado via modal "Coletar tudo". | `scripts/systems/offline_simulator.gd` |
| **build_save_snapshot** | Metodo publico do SaveManager que gera o Dictionary do save SEM gravar em disco (usado pelo Dev Modal para simular offline). | `autoload/save_manager.gd` |
| **AUTOSAVE_INTERVAL_SECONDS** | Constante do SaveManager (60s) que define o intervalo do autosave automatico. Roda via unix-time gating em `_process` para nao escalar com `Engine.time_scale` (decisao #14). | `autoload/save_manager.gd` |

## Termos da Fase 01 Bloco A (B1, B2, B3)

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Bestiary** | Autoload que rastreia kills globais por inimigo + lista descobertos. Sem buffs ainda; Mob Slaughter chega na Fase 02-03. | `autoload/bestiary.gd` |
| **bestiary_updated** | Signal `(enemy_id, total_kills)` disparado a cada kill registrado. | `autoload/event_bus.gd` |
| **game_speed** | Inteiro em GameState (1 ou 2 na Fase 01). Aplicado em `Engine.time_scale`. 4x e 8x sao unlocks futuros. | `autoload/game_state.gd` |
| **AreaClearTracker** | RefCounted que acumula XP/gold/kills/drops/tempo durante um stage. Reseta ao mudar de coords. | `scripts/systems/area_clear_tracker.gd` |
| **area_cleared** | Signal `(character, summary)` disparado quando todas as waves de um stage caem. Modal de resultados ouve isso. | `autoload/event_bus.gd` |
| **last_area_clears** | Dicionario em GameState com ultimo summary por (zone, area, stage). Permite comparativo "Xs mais rapido" no modal. | `autoload/game_state.gd` |
| **area_results_modal** | Modal pos-clear com XP/gold/kills/time + drops + comparativo. Auto-close em 8s. | `scenes/ui/modals/area_results_modal.gd` |

## Termos da Fase 01 Bloco B (placeholders)

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **GatheringSession** | Node que roda loop continuo de coleta (timer/drop) por skill ativa. Apenas 1 skill por vez no placeholder. | `scripts/systems/gathering_session.gd` |
| **Crafting (helper)** | Classe estatica com receitas inline para Smithing e Smelting. Craft instantaneo. | `scripts/systems/crafting.gd` |
| **crafting_modal** | Modal generico parametrizado por `station_id` (smithing/smelting). Lista receitas + botao Craft com validacao automatica de inputs. | `scenes/ui/modals/crafting_modal.gd` |
| **SkillTree** | Classe estatica com 18 nos do Warrior em 3 ramos (Berserker/Defender/Tactician). `apply_bonuses(character, stats)` aplica em `_from_instance`. | `scripts/systems/skill_tree.gd` |
| **skill_points_unspent** | Pool separado em CharacterInstance, +1 por level. Usado pra unlock de skill tree (nao confundir com `unspent_stat_points`). | `scripts/systems/character_instance.gd` |
| **unlocked_skill_nodes** | Array de StringName em CharacterInstance com nos da skill tree ja destravados. Persistido no save. | `scripts/systems/character_instance.gd` |
| **settlement walker** | Sprite2D do Warrior que anda aleatoriamente no Settlement view. Pickup destino aleatorio + linha reta + pause + repete. | `scenes/views/settlement_view.gd` |

## Termos da reforma de Mining-as-Battle + UI polish (2026-05-07)

| Termo | Definicao | Onde detalhado |
|---|---|---|
| **Juicy** | Helper estatico (RefCounted) com `modal_appear`, `modal_disappear`. Animacoes padrao de modais (fade+scale). Fase B+: button pulse REMOVIDO (UI solida com 3-state PNGs). | `scripts/systems/juicy.gd` |
| **NumberFormat** | Helper estatico (Fase B+) pra abreviar numeros grandes com sufixos K/M/B/T/Qa/Qi/Sx/Sp/Oc/No/Dc (max 2 decimais). Ex: `format(1250) == "1.25K"`. Usado em HP/MP/qty/power labels. | `scripts/systems/number_format.gd` |
| **TooltipManager** | Autoload (Fase B+, CanvasLayer layer 20) que apresenta tooltips de item no hover. API: `show_item_tooltip(item, anchor_rect)`. Layout dinamico: weapon mostra ATK+SPD, outros mostram so name+type+description. 9-slice 3px borders. | `scenes/ui/tooltips/tooltip_manager.gd` |
| **InventorySlotV2** | Slot reutilizavel pra inventory + equipment (Fase B+). Background trocado por raridade (common→mythic + locked). Item icon com margem 7px. Hover dispara TooltipManager. Click esquerdo dispara DragManager (modo inventory ou equipment definido por `equip_slot_id`). | `scenes/ui/modals/panels/inventory_slot_v2.gd` |
| **ArtifactSlot** | Slot pra artifacts panel (Fase B+). Usa textura propria (`artifact_slot.png` 64x64). Artifacts NAO sao movidos pelo player — cada um fica no seu slot fixo (populado por drops/quests/sistemas futuros). Slot so visivel quando ha artifact. | `scenes/ui/modals/panels/artifact_slot.gd` |
| **DragManager** | Autoload (Fase B+, CanvasLayer layer 25) que implementa click-to-pick-and-place estilo Minecraft/Terraria entre slots de inventory e equipment. Estado em `_held_item/_held_qty/_held_source`. Filtro `slot_type` ao dropar em equipment. Artifacts NAO interagem com DragManager. Ghost segue cursor. API: `is_holding()`, `handle_slot_click(target)`, `cancel()`. | `scenes/ui/drag/drag_manager.gd` |
| **Efficiency** | Sistema IdleOn-style. Cada atividade (mining/woodcutting/fishing/combat) tem sua propria eficiencia. Comparada com `eff_req` do alvo: <5% = sem drop; 5-100% = chance linear; >=100% = drop garantido com multiplicador inteiro 1-5x. | `scripts/systems/efficiency.gd` |
| **eff_req** | Efficiency Required: campo do `OreTargetData` (e futuramente outros alvos). Define a "dificuldade" do alvo pra drops. | `scripts/data/ore_target_data.gd` |
| **OreTargetData** | Resource que define um tipo de minerio: drop_item, eff_req, max_hits (50), respawn_seconds, base+cluster textures. | `scripts/data/ore_target_data.gd` |
| **OreTarget** | Node2D em `scenes/combat/ore_target.gd` que representa um veio na batalha. 2 sprites (Cluster atras, Base na frente). Hit anima so o cluster (shake+pulse). Quebra -> respawn por unix-time. | `scenes/combat/ore_target.gd` |
| **GatheringSpotData** | Resource com lista de ate 5 OreTargets + `activity` + zone_id. Spot completo. | `scripts/data/gathering_spot_data.gd` |
| **MODE_GATHER / MODE_COMBAT** | Estados do combat_controller. Determina se enemy_slot tem inimigos ou ore_targets. | `scenes/combat/combat_controller.gd` |
| **gathering_spot_requested** | Signal `(spot_data)` emitido pelo map_modal pra o controller entrar em gather mode. | `autoload/event_bus.gd` |
| **combat_mode_requested** | Signal sem args pra forcar saida do gather mode (selecionou stage de combate). | `autoload/event_bus.gd` |
| **CharacterDetailsModal** | Modal stackable com TODAS as 7 secoes de stats. Aberto via botao "Details" do character_modal. | `scenes/ui/modals/character_details_modal.gd` |
| **modal stackable** | Modal que abre sem fechar outros (z-stack). Hoje: CharacterDetails, SkillTree, AreaResults. | `scenes/ui/modals/modal_layer.gd` |
| **Eficiencia (Gathering)** | Sistema estilo IdleOn onde cada node de spot tem `eficiencia_minima` e o personagem precisa atingir esse valor para drop garantido. Abaixo do minimo: drop chance = `eficiencia/minima * 100%`. Igual ou acima: 100%. Animacao de coleta sempre ocorre. Eficiencia base cresce com mastery + level + bonus de classe + ferramenta. | `01_design/gathering-materials.md` |
| **Pity (Mythic)** | Threshold de 100 legendary sem mythic forca proximo legendary virar mythic. Reduz frustracao endgame. | `02_math/drop-rates.md` |
| **Skin** | Cosmetico que substitui sprite + retrato do personagem inteiramente. Diferente de equipamento (apenas armas alteram visual via camada). Vinculada a CONTA, nao ao personagem (decisao #22). | `01_design/equipment-catalog.md` |

## Convencoes de codigo

| Termo | Definicao |
|---|---|
| **EventBus** | Autoload de signals globais (`autoload/event_bus.gd`). |
| **GameState** | Autoload com estado de gameplay (`autoload/game_state.gd`). |
| **BattleLog** | Autoload com fila de mensagens de combate (`autoload/battle_log.gd`). |
| **CharacterInstance** | `scripts/systems/character_instance.gd`. Estado por personagem. |
| **CombatStats** | `scripts/systems/combat_stats.gd`. Stats derivados. |
| **EnemyData / StageData / ZoneData / AreaData / WaveData** | Resources em `scripts/data/`. |
