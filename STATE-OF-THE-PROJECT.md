# Estado do Projeto — Idle Medieval

> Snapshot das funcionalidades implementadas em **2026-05-14**.
> Cobre apenas o que esta pronto + portas de expansao. Conteudo futuro
> (zonas, items, skills nao implementadas) NAO esta listado aqui.

Engine: **Godot 4.6** (GL Compatibility renderer)
Viewport: 1920x1080, stretch mode `canvas_items`
Idioma do projeto: pt-BR (codigo + comentarios), strings de UI em PT/EN mistas

---

## 1. Arquitetura

### Autoloads (singletons globais)

| Autoload | Responsabilidade |
|---|---|
| `EventBus` | Hub de signals (~25 signals: gold/xp/hp/inventory/equipment/wave/area/save/etc) |
| `GameState` | Roster de personagens, gold, settings, game_speed (1x/2x), active character |
| `SaveManager` | Persistencia JSON com 3 backups rotacionais + hash sha256, autosave 60s, migration v1->v2 |
| `Bestiary` | Tracking global de kills por enemy_id (persistido no save) |
| `BattleLog` | Buffer de eventos de combate pro panel lateral |
| `TooltipManager` | CanvasLayer 20 que segue cursor; layout PSD weapon vs item (217 wide, altura dinamica) |
| `DragManager` | CanvasLayer 25 que implementa click-to-place estilo Minecraft/Terraria |

### Fluxo de cena

`scenes/main.tscn` (Control root)
- `RootHBox`
  - `ViewColumn`
    - `ViewContainer` — comuta entre 8 views (Battle/Town/Gathering/Quests/Codex/Settlement/Settings/Help)
    - `Footer` — XP bar + Speed toggle + char info (so na Exploration view)
  - `RightPanel` — Character/Map/Speed buttons (so na Exploration)
- `SideMenu` — botoes de navegacao entre views
- `ModalLayer` — CanvasLayer 10 com 9 modais (z-order corrigido pra CharacterModal ficar acima de AreaResults)
- `NotificationStack` — toasts de drops/level-up
- `DevPanel` — botao "Dev" pra abrir DevModal

---

## 2. Combat Core

### Battle loop (`scenes/combat/combat_controller.gd`)

- Spawn de waves baseado em `StageData.waves` (configurado por zona/area/stage). Fallback pra `enemy_pool` legado.
- Player + 1 enemy ativo por vez. Player ataca em timer baseado em `attack_speed`. Damage = `max(1, atk * mult)`.
- Enemy ataca em timer proprio. Damage taken aplica em current_hp.
- Player morre -> regride pro `last_completed_stage`.
- Enemy morre -> next wave OR avanca pro proximo stage.
- Game speed multiplier via `Engine.time_scale` (1x ou 2x).
- VFX de attack (BLINK/SLASH patterns) configuravel por arma. Hand-attack (sem weapon) usa fallback `punch_vfx000.png`.
- Damage numbers float-up + level-up VFX prontos.

### CombatStats (`scripts/systems/combat_stats.gd`)

- Stat block completo: quinteto base (HP/MP/ATK/DEF/SPD) + 5 atributos primarios (STR/DEX/INT/VIT/LUK) + 30+ stats derivados (crit/dodge/elem/regen/leech/gain%/etc).
- Computado por `from_character(inst)`:
  - Base do `CharacterData` (sem starting_weapon hard-coded — equipamento ativo eh somado uniformemente).
  - Loop por `EQUIP_SLOTS` somando `bonus_atk/spd/def/max_hp/max_mp` de cada item equipado.
  - Bonus de stat points investidos (DEPRECATED HP/MP/ATK/DEF/SPD ainda aplicam pra saves antigos; UI nova so expoe STR/DEX/INT/VIT/LUK).
  - Formulas: STR +1 ATK/pt, DEX +0.02 SPD/pt, INT +1 MATK/pt, VIT +5 HP/pt, LUK +0.5% crit/pt.
  - SkillTree.apply_bonuses no final (Fase 01 hook).

### Player & Enemy (`scenes/combat/player.gd`, `enemy.gd`)

- Combatant base com sprite-sheet animacao + shadow renderizada por shader.
- Player: weapon sprite separado com flip/tilt na animacao de attack.
- Idle resume timer pra voltar pra animacao idle apos N segundos.
- HpBar nativo no nó (mostra current/max).

---

## 3. Personagens e Progressao

### CharacterInstance (`scripts/systems/character_instance.gd`)

Tudo por personagem (decisao confirmada — sem inventory/equip compartilhado):
- `equipment: Dictionary` (slot_id -> ItemData)
- `equipment_favorites: Dictionary` (slot_id -> bool)
- `inventory_slots: Array` (slot-indexed, cada slot null ou `{item_id, item, qty, favorited}`)
- `artifact_slots: Array[16]` (pool isolado, slots fixos)
- `stat_bonus: Dictionary` (STR/DEX/INT/VIT/LUK invested points)
- `unspent_stat_points` + `skill_points_unspent` + `unlocked_skill_nodes`
- Zone/area/stage tracking + `unlocked_progress` + `unlocked_zones`

**Slots de equipamento** (18 total):
- Armadura: helmet, chest, legs, boots
- Acessorio: necklace, earrings, ring, bracelet
- Combate: weapon
- Ferramentas: pickaxe, axe, fishing_rod, scythe
- Locked (Fase 04+): star_net, scouter
- Transmog (Fase 02-03+): weapon_visual, skin_full, wings

**APIs publicas**: add_item / remove_item / get_slot / set_slot / sort_inventory / consolidate_inventory / get_equipment / set_equipment / clear_equipment / get_artifact / set_artifact / is_/set_/toggle_inventory_slot_favorited / is_/set_/toggle_equipment_favorited / level/xp/zone navigation / dev_unlock_all_zones.

### XP Curve (`scripts/systems/xp_curve.gd`)
Curva monotonica de XP por level. `add_xp` consome multiplas thresholds em loop (offline progress).

### SkillTree (`scripts/systems/skill_tree.gd`)
Apply_bonuses stub conectado em CombatStats. Skill points ganham +1 por level. Tree data ainda nao definida (porta de expansao).

---

## 4. Map / Zonas / Stages

### ZoneData + AreaData (`scripts/data/zone_data.gd`, `area_data.gd`)

- Zone tem N areas, cada area pode ter override de `top_wave_size_max` etc.
- StageRoster (`scripts/systems/stage_roster.gd`) materializa StageData on-demand a partir de (zone, area_index, stage_index). Cacheado por sessao.
- `advance_to_next_stage()` percorre stages -> areas -> next_zone.
- Unlock gating no `map_modal`: zona desbloqueada + area iniciada/anterior completada + stage <= furthest+1.

### Zonas implementadas
- **Forest** (`data/zones/forest.tres`) — 4 areas com slimes (green/blue/purple/red). Linkada a `desert.tres`.
- **Desert** (`data/zones/desert.tres`) — placeholder, pode ser populado.

### Inimigos (`data/enemies/*.tres`)
4 slimes: green_slime, blue_slime, purple_slime, red_slime. Cada um com sprite-sheet, HP/ATK/DEF/SPD, loot_table, gold range.

### Stage Data
StageData usado dinamicamente; pasta `data/stages/` vazia (gerada por StageRoster).

---

## 5. Equipamentos e Inventario

### ItemData (`scripts/data/item_data.gd`)

Campos:
- `id`, `display_name`, `description`, `stackable`, `item_type`, `rarity`, `slot_type`, `item_level`
- Bonuses: `bonus_atk`, `bonus_attack_speed`, `bonus_def`, `bonus_max_hp`, `bonus_max_mp`
- Tool bonuses: `bonus_mining_efficiency`, `bonus_woodcutting_efficiency`, `bonus_fishing_efficiency`, `bonus_harvesting_efficiency`
- Reservados pra Fase 02+: `max_affix_slots`, `max_enchant_slots`, `max_gem_slots`
- Sprite + drop_icon + drop_scale + VFX (sprite/pattern/scale)

Enums:
- `ItemType` (7): MATERIAL, WEAPON, CONSUMABLE, ARMOR, ACCESSORY, TOOL, ARTIFACT
- `Rarity` (6): COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC
- `SlotType` (19): NONE, HELMET, CHEST, LEGS, BOOTS, NECKLACE, EARRINGS, RING, BRACELET, WEAPON, PICKAXE, AXE, FISHING_ROD, SCYTHE, STAR_NET, SCOUTER, WEAPON_VISUAL, SKIN_FULL, WINGS

### Items implementados (`data/items/`)
- **Weapons**: training_sword, bronze_sword
- **Picaretas**: worn_pickaxe, copper_pickaxe, iron_pickaxe, gold_pickaxe
- **Armadura** (iron set): iron_helmet, iron_chest, iron_legs, iron_boots (+ pasta `armor/` adicional)
- **Materiais**: birch_log, pine_log, copper_ore, copper_bar, iron_ore, gold_ore, slime_goo, river_trout

### Templates (`data/items/templates/`)
16 templates pra duplicar: helmet/chest/legs/boots, necklace/earrings/ring/bracelet, weapon, pickaxe/axe/fishing_rod/scythe, material/consumable/artifact. README com tabelas de enums.

### Drag & Drop (DragManager autoload)

Click-to-pick-and-place estilo Minecraft/Terraria:
- **Left click**: pickup full / drop full / merge / swap (so inventory).
- **Right click**: pickup half-stack `ceil(qty/2)` / drop 1 / merge 1. Sem swap.
- **Shift+Left**: quick-move (inv -> equip se slot vazio; equip -> primeiro inv vazio).
- **Alt+Left**: toggle favorite (lock icon top-left do slot).
- **Backdrop click segurando**: ConfirmationDialog "Descartar item?" (bloqueia se favoritado).
- **ESC**: cancela drag (volta pra origem). Modal close tambem cancela.

**Dominios isolados**:
- inventory <-> equipment: livre com filtro `slot_type`.
- artifact: pool isolado (16 slots fixos, populado por sistemas externos).

**Equipment rules**:
- Pickup ALLOWED em favoritados (player pode trocar de slot).
- Shift-unequip BLOCKED em favoritados.
- Swap por drop em slot ocupado BLOCKED (player desequipa manualmente primeiro).

**Sort**:
- Modes: rarity (DESC), quantity (DESC), type (ASC), level (DESC).
- Items favoritados ficam pinned no slot original.
- Consolidate (merge de duplicados stackable) roda automaticamente antes do sort.

### Crafting (`scripts/systems/crafting.gd`)
Helper basico que consome materiais via `character.remove_item`. UI no `crafting_modal.tscn`.

---

## 6. Gathering / Coleta

### Activities suportadas
- **Mining**: picaretas + tier de minerio (`OreTargetData`, `ore_target.gd`).
- **Woodcutting**: machados + arvores 3-4 layers (`TreeTargetData`, `tree_target.gd` com base/trunk/leaves_back/leaves_front + offsets configuraveis + z-order leaf001 > leaf000 > trunk > base).
- **Fishing**: vara de pesca (estrutura pronta, gameplay nao plugado).
- **Harvesting**: foice (slot pronto, sem alvo definido ainda — porta de expansao).

### Efficiency system (`scripts/systems/efficiency.gd`)
Compute por atividade:
- Combat: STR*2 + DEX + weapon ATK
- Mining: 5 + DEX*2 + STR + pickaxe.bonus_mining_efficiency
- Woodcutting: idem com axe
- Fishing: idem com fishing_rod
- Harvesting: 5 + STR*2 + DEX + scythe.bonus_harvesting_efficiency

Compara com `eff_req` do alvo (decisao #14): <5% sem drop, 5-100% chance linear, >=100% drop garantido com multiplicador 1-5x.

### Spots de coleta (`data/gathering/`)
- copper_spot, iron_spot, gold_spot (ore spots com `OreTargetData`)
- birch_spot (tree spot com `TreeTargetData`)

### LootRoller (`scripts/systems/loot_roller.gd`)
Roleta de loot por entrada (`LootEntry`). Aplica gain modifiers de CombatStats.

---

## 7. Save / Load

### Save Manager (`autoload/save_manager.gd`)

- Path: `user://save_slot_1.json` + 2 backups rotacionais (`.bak`, `.bak2`).
- Hash sha256 de integridade.
- `CURRENT_SAVE_VERSION = 2`.
- Migration v1->v2: `inventory: Dictionary` -> `inventory_slots: Array`; `ring1/ring2` -> `ring` (ring2 contents droppam pro inventory).
- Autosave a cada 60s REAIS (unix time, ignora time_scale).
- Trigger autosave em level-up.

### Snapshot serializado
- Account: gold, settings (HP numbers/auto-collect/speed), bestiary, last_area_clears.
- Per character: data_id, level, xp, hp, mp, stat_bonus, unspent_points, skill tree, zone/area/stage, unlocked_progress, equipment, equipment_favorites, inventory_slots (com favorited flag), artifact_slots.

### Offline progression (`scripts/systems/offline_simulator.gd`)
- Cap 12h (decisao #18).
- Simula stages clearados durante o tempo offline em tempo "comprimido".
- Modal `offline_summary_modal` mostra resumo ao carregar save com delta >= 60s.

---

## 8. UI / Modais

### Character Modal (`scenes/ui/modals/character_modal.tscn/.gd`)

Tela unificada (Hero + Equipment + Inventory + Attributes + Artifacts) com layout PSD-fiel 1536x1024:

- **Hero Panel** (esquerda): lista de personagens via `hero_button.tscn`, toggle pressed = active.
- **Equipment Panel** (centro-esq): name + level + XP bar (XpHolder com fill gold #C9BD93) + HP/MP + char_image + 12 slots posicionados absolutamente + toggle Equipment/Tools view + Power label + 4 stat labels (ATK/DEF/SPD/LUK) + Details + SkillTree buttons.
- **Inventory Panel** (centro-dir): grid 5x3 (15 slots) + sort dropdown + paginacao prev/next + page indicator.
- **Attributes Panel** (baixo-esq): 5 rows STR/DEX/INT/VIT/LUK + "+" buttons + Available Points label.
- **Artifacts Panel** (baixo-dir): 16 slots fixos (so visiveis quando ha artifact).

Tools view substitui slots laterais: pickaxe/axe/fishing_rod/scythe + 4 locked (star_net/scouter/tbd_tool1/tbd_tool2). Decorative icons (`SLOT_ICON_BY_ID`) mostram silhueta no slot vazio.

Sem Juicy.modal_appear (efeito de entrada removido).

### Tooltip System

- Layout PSD-fiel (`tooltip_manager.tscn`): NinePatchRect 207 wide com 9-slice 3px.
- Cores PSD: title `#C9BD93`, type `#474439`, desc `#C9BD93`, stat+ `#94A657`, stat- `#A66257`.
- Font sizes PSD: title 24, type 14, desc 18, stat 20.
- Dividers de 1px (textura `h_divider_tooltip_sep.png` 175x1, stretch SCALE).
- Sub-VBox `HeaderBox` com separation -8 pra aproximar Name e Type.
- Segue cursor (offset 16,12, flip horizontal/vertical em overflow).
- Owner-based hiding (`hide_tooltip_if_owner`) pra evitar flicker em transicoes rapidas.
- Slots fazem polling via `_process` (robusto contra refresh de modal).

### Modais (`scenes/ui/modals/`)

| Modal | Responsabilidade |
|---|---|
| `character_modal` | Hero + Equipment + Inventory + Attributes + Artifacts (rebuild Fase B+) |
| `map_modal` | Lista zones/areas/stages com gating de unlock |
| `dev_modal` | Cheats + "Add Item to Inventory" (scaneia data/items/*.tres) |
| `bestiary_modal` | Lista de inimigos com kill count |
| `crafting_modal` | Receitas placeholder |
| `skill_tree_modal` | Skill tree placeholder (stackable em cima do character) |
| `character_details_modal` | Stats detalhados (stackable) |
| `area_results_modal` | Resumo de clear de area (xp/gold/drops, comparativo com ultimo clear) |
| `offline_summary_modal` | Resumo de ganhos offline |
| `dev_modal` | Cheats |

ModalLayer order: AreaResults/Offline/Map/Dev/Bestiary/Crafting < CharacterModal < SkillTree/CharacterDetails.

### Views (`scenes/views/`)

- **BattleView**: combat HUD + enemy slot + player slot. Unica view com Footer + RightPanel visiveis.
- **GatheringView**: tela de mining/chopping com spots ativos.
- **TownView/QuestsView/CodexView/SettlementView/SettingsView/HelpView**: placeholders prontos pra preencher.

### Footer (`scenes/ui/footer.tscn`)
- XP bar global do active character.
- Speed toggle (1x/2x).
- Char info compacto (nome + level).

### RightPanel (`scenes/ui/right_panel.tscn`)
- Character button (abre character_modal).
- Map button (abre map_modal).
- Speed toggle.

### Notifications (`scenes/ui/notification_stack.tscn`)
Toasts empilhados pra drops/level-up. Auto-fade.

### BattleLog (`scenes/ui/battle_log_panel.tscn`)
Panel lateral com historico de eventos (kill/drop/levelup/etc).

### SideMenu (`scenes/ui/side_menu.tscn`)
Navegacao entre 8 views.

---

## 9. Pipeline PSD -> Godot

### Extractor (`tools/psd_extract.py`)
Script Python que le `.psb/.psd` via `psd-tools` e exporta:
- `_composite.png`: render final.
- `png/{layer_name}.png`: cada layer individual.
- `layers.json`: bbox, opacity, blend_mode, color (pra text), font size com Free Transform `scale_y` aplicado (fix Fase B+).

### Workflow estabelecido (`planning/00_meta/psd-workflow.md`)
- PSD-absolute coords: paineis fullscreen organizacionais + slots posicionados em coords absolutas do PSD (sem panel-relative compounding).
- Backgrounds bakeados (1 PNG por painel com dividers ja embutidos).
- Font: `round(json.text.size)` direto (sem conversao /3.27 antiga).
- ProgressBar normalizado: `max_value = 1.0`, `value = curr/max`.

### Assets organizados (`assets/sprites/`)
- `background/`, `characters/`, `effects/`, `enemies/`, `gathering/`, `items/`, `ui/character_screen/`, `ui/tooltips/`.

---

## 10. Theme / Visual

### Default Theme (`assets/themes/default_theme.tres`)
- Font: **PT Serif Bold** (weight 700) com fallback Cambria/Georgia/Times.
- Default font_size: 16.

Aplicado em:
- modal_layer (via cada modal individual conforme necessario).
- Hero buttons, dev_modal (root), tooltip_manager (TooltipPanel), drag_manager (GhostRoot).
- Programatic controls (PopupMenu, ConfirmationDialog) carregam via `load(DEFAULT_THEME_PATH)` no setup.

### Juicy (`scripts/systems/juicy.gd`)
- `modal_appear`/`modal_disappear` ainda existem mas character_modal nao usa mais.
- `button_click_pulse` e `wire_button_press` REMOVIDOS (UI mais solida com 3-state PNGs).

---

## 11. Dev Tools

### Dev Modal (`scenes/ui/modals/dev_modal.tscn/.gd`)
- "Unlock entire map" — `dev_unlock_all_zones` no character ativo.
- "Spawn wave: N" — emite `dev_spawn_wave_requested` pra controller.
- "Simular 1h offline" — fake save_dict com `last_offline_at_unix` rebobinado.
- **"Add item to inventory"**:
  - Scaneia `data/items/*.tres` (nao recursivo, exclui pasta `templates/`).
  - Filtro de busca + lista scrollavel.
  - `+1` em todos / `+10` em stackables.
  - Artifacts vao pro primeiro slot vazio de artifact pool.

### Dev Panel (`scenes/ui/dev_panel.tscn`)
Botao "Dev" persistente que abre DevModal.

---

## 12. Sistemas auxiliares

### NumberFormat (`scripts/systems/number_format.gd`)
Sufixos K/M/B/T/Qa/Qi/Sx/Sp/Oc/No/Dc. Default sem decimais (`113K` ao inves de `113.05K`). Helpers `format_int`, `format_pair`, `format_float`.

### AreaClearTracker (`scripts/systems/area_clear_tracker.gd`)
Acumula xp/gold/kills/drops dentro de um stage. Reset ao mudar de stage. `make_key(zone_id, area_idx, stage_idx)` pra persistencia.

### Bestiary (`autoload/bestiary.gd`)
`register_kill(enemy_data)` -> incrementa contador. Serializa `{enemy_id: total_kills}`. `bestiary_modal` le.

---

## 13. Portas de expansao (hooks prontos)

### Data-driven
- `data/items/`: adicionar `.tres` aparece automatico no dev menu + drop tables.
- `data/enemies/`: adicionar enemy + referenciar em zone/area.
- `data/zones/`: linkar `next_zone` cria progressao.
- `data/gathering/`: spots ja modulares por activity.

### Sistemas com stubs
- **SkillTree**: `apply_bonuses(inst, stats)` recebe character + stats. Tree config no `skill_tree_modal` (UI placeholder).
- **Crafting**: receitas no `crafting_modal`.
- **Artifacts**: data layer pronto (`character.artifact_slots[16]`), populado por... (futuro: drops/quests).
- **Pets / Cards**: planning catalogs prontos (`pets-catalog.md`, `cards-catalog.md`), sem implementacao.
- **Quests**: view placeholder.
- **Town/Settlement**: views placeholder.

### Slots reservados
- Equip tbd1, tbd2 (combat view) e tbd_tool1, tbd_tool2 (tools view) — locked, sem feature definida.
- ItemData: `max_affix_slots`, `max_enchant_slots`, `max_gem_slots` reservados.
- Visual slots (weapon_visual, skin_full, wings) — slot_id existe mas UI ainda nao expoe.

### Decisoes pendentes (`planning/00_meta/pending-decisions.md`)
Lista as decisoes em aberto: TBD1/TBD2 features, class_label inicial, drag/drop refinements, etc.

---

## 14. Documentacao do projeto (`planning/`)

35 markdown files organizados em:
- `00_meta/`: progress-log (rolante), glossary, psd-workflow, pending-decisions, self-instructions, phase-navigation, release-plan, localization-plan.
- `01_design/`: 16 catalogs (classes, enemies, items, equipment, gathering, crafting, skills, quests, npcs, cards, pets, events, audio, graphics, account-vs-character, save-offline-spec, ui-ux-wireframes).
- `02_math/`: drop-rates, progression-curves, damage-formula, character-stats.
- `03_research/`: ui-screenshots-references, mecanicas de jogos referencia.
- `04_phases/`: 6 phase plans (00 Foundation, 01 Core Loops, 02 Expansion, 03 Mid-game, 04 Late-game, 05 End-game).
- `05_juicy/`: feedback-language, juicy-catalog.

---

## Resumo executivo

**Pronto pra jogar (loop minimo)**:
- Login -> Battle View ataca slimes na Forest -> dropa items + XP + gold -> level up + invest stats -> equipa items via Character modal -> usa Map pra ir pra proximo stage.
- Pode tambem ir pra Gathering View, escolher um spot (copper/iron/gold/birch), bater no alvo, lootear material.
- Save automatico a cada 60s. Offline progression ao reabrir.

**Sistemas robustos**:
- Combate em tempo real com VFX/animacao/squash-stretch/shadow.
- Drag/drop completo (left/right/shift/alt + favorites + discard).
- Tooltip dinamico seguindo cursor.
- Persistencia com backup + migration.
- Theme PT Serif Bold consistente.

**Conteudo atual**:
- 1 classe (Warrior).
- 2 zonas (Forest jogavel, Desert placeholder).
- 4 inimigos (slimes).
- ~18 items + 16 templates.
- 4 spots de gathering.
