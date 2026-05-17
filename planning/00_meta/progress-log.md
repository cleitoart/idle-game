# Progress Log

> Estado rolante do projeto. Append-only (no maximo 30 linhas por entrada). Cada sessao com mudanca relevante adiciona uma entrada nova ao TOPO.
> **Ler isto antes de qualquer trabalho.**

---

## 2026-05-14 - Sintese profunda das 3 referencias (Cookie Clicker, IdleOn, IEH2)

Rodada de 6 agentes paralelos analisando os dumps em `references/` e
produzindo mescla informada em `planning/03_research/synthesis/`:

- `01-stats-and-progression.md` (1254 linhas) — 12 decisoes pendentes
- `02-active-vs-idle-balance.md` (~650 linhas) — 6 decisoes
- `03-combat-classes-skills.md` (~680 linhas) — 15 decisoes
- `04-items-crafting-equipment.md` (~590 linhas) — 10 decisoes
- `05-zones-enemies-quests-npcs.md` (~720 linhas) — 10 decisoes
- `06-meta-progression-and-mechanics.md` (1313 linhas) — 9 decisoes

Cada doc segue template: como cada jogo faz (com citacao arquivo+linha) ->
convergencias (mescla recomendada) -> divergencias com [DECISAO PENDENTE] ->
proposta concreta pro Idle Medieval -> hooks com docs existentes.

Consolidado: `synthesis/decisions-needed.md` com ~60 decisoes priorizadas
(P0/P1/P2). 22 P0 que bloqueiam Fase 02 listadas no apendice.

Highlights da proposta merged:
- Quinteto STR/DEX/INT/VIT/LUK ja alinhado com IEH2; falta DEF/MDEF/MP
  hibridos por 2 atributos e cap de crit em ~75%.
- Curva XP atual funcional; recomendado walls em L100/250/500/1000.
- 70% offline rate para combat, 85% gathering, 100% crafting.
- Golden-Pulse: buff curto (30-60s) com spawn 10-20min, cap 6/sessao.
- 3 classes R1.0 (Warrior/Mage/Ranger); skill tree branched 3 ramos x 6
  nodes x 3 ranks = 54 SP/classe.
- 8 elementos no codigo, gating por zona.
- 5 camadas de upgrade de item (Enchant F02 / Gems F02 / Maestria F03 /
  Forge F04 / Evolution F05).
- 6 zonas pra R1.0 (Zona 6 stretch); 30 main quests (5 por zona); 25 Steam
  achievements + 20 titulos com bonus 1-5%.
- 3 camadas de prestige (Renascimento F03 / Transcendencia F04 / Ascensao
  Cosmica F05); 1o rebirth em L100.
- Pets skipados pra R1.1+; Cards na F03; Cristal Eterno (calendar currency)
  em F04; Loja Eterna MVP com 11 items.

Nada implementado em codigo ainda — material e' research/sintese. Proximo
passo: usuario revisa decisoes-needed.md, resolve P0, migra resolvidos pra
`00_meta/pending-decisions.md`.

---

## 2026-05-14 - Exploration AQW: reformulacao da gameplay

Reformulacao completa da Battle View pra modelo Adventure Quest Worlds:
visao 2.5D side-scroll, click-to-move via NavigationAgent2D, inimigos
posicionados no mundo selecionaveis por click, combate trigga em range,
respawn por timer, telas conectadas por portais, auto-combat opcional com
skills em CD. Premissa: prototipo com background cinza pra validar mecanica
antes de pensar em servidor online.

**Files novos (additivos):**
- `scripts/data/area_scene_data.gd` — Resource que liga area_id a um
  PackedScene + pool de enemies + max_concurrent + respawn_seconds.
- `scripts/data/skill_data.gd` — placeholder pra skills (damage_mult/heal_mult,
  cd, mp_cost, VFX).
- `scripts/systems/world_controller.gd` — orquestra area load/unload, spawn
  inicial, respawn timers, click routing, combat trigger, auto-combat ticks,
  player death recovery. Substitui combat_controller.gd.
- `scripts/systems/skill_runtime.gd` — gerencia cooldowns por caster +
  apply de damage/heal por skill.
- `scenes/world/player_world.gd/.tscn` — CharacterBody2D + NavigationAgent2D
  + HpBar2D + AttackTimer. Estados: IDLE / MOVING_TO_POINT / MOVING_TO_TARGET /
  COMBAT. Reusa hp_bar.tscn existente.
- `scenes/world/enemy_world.gd/.tscn` — CharacterBody2D + ClickArea
  (Area2D pra targeting) + HpBar + AttackTimer. Detecta player em range e
  ataca de volta. Drop loot/xp/gold via WorldController on defeat.
- `scenes/world/portal.gd` — Area2D que emite area_change_requested ao
  receber body do player.
- `scenes/world/spawn_point.gd` — Marker2D que hospeda 1 inimigo + tracka
  respawn_at_unix.
- `scenes/world/areas/prototype_area_1.tscn` — 1920x720 cinza com
  NavigationRegion2D, 2 walls top/bottom, 2 obstaculos centrais, 3 spawn
  points, 1 PlayerSpawn, 1 portal direita, Camera2D estatica.
- `scenes/views/exploration_view.gd/.tscn` — root Control com WorldRoot +
  WorldController + Overlay (AutoCombat button). `_unhandled_input` faz
  ground click (clicks em enemy Area2D consomem antes).
- `data/areas/prototype_area_1.tres` — AreaSceneData apontando pro tscn,
  pool=[green_slime], max=3, respawn=8s.
- `data/skills/power_strike.tres` (2x atk, cd 5s) +
  `data/skills/quick_heal.tres` (20% heal, cd 15s, 10 MP).

**Files modificados:**
- `autoload/event_bus.gd`: signals novos (area_change_requested, area_loaded,
  enemy_clicked, world_target_changed, auto_combat_toggled, skill_cast,
  dev_spawn_enemy_requested). Removidos signals stage/wave-based.
- `scripts/data/character_data.gd`: substituido starting_zone/starting_stage
  por starting_area: AreaSceneData.
- `scripts/systems/character_instance.gd`: removido current_stage/wave/zone
  + last_completed_*+ unlocked_progress/unlocked_zones. Novo current_area_id
  e unlocked_areas. equipped_skills auto-popula com power_strike + quick_heal
  no create().
- `autoload/save_manager.gd`: CURRENT_SAVE_VERSION=3 + migration v2->v3 que
  descarta campos legacy e usa starting_area.id como default.
- `scenes/main.tscn` + `main.gd`: swap BattleView -> ExplorationView.
- `scenes/ui/modals/map_modal.gd`: tab "Exploration" lista AreaSceneDatas
  em data/areas/ pra fast-travel via area_change_requested.
- `scenes/ui/modals/dev_modal.gd`: botao Spawn Wave -> Re-spawn enemies
  (emite dev_spawn_enemy_requested). Unlock all map agora no-op (sem zones).
- `scenes/ui/modals/modal_layer.gd`: _on_area_cleared usa area_id ao inves
  de zone_id+area_index+stage_index.
- `data/characters/warrior.tres`: starting_area aponta pra
  prototype_area_1.tres.

**Files stubbed (DEPRECATED, podem ser deletados manualmente):**
- `scenes/views/battle_view.gd` (vazio)
- `scenes/combat/combat_controller.gd` (vazio)
- `scripts/systems/stage_roster.gd` (vazio)
- `scripts/systems/area_clear_tracker.gd` (vazio)
- `scripts/data/zone_data.gd` (so id/display_name)
- `scripts/data/area_data.gd` (so id/display_name)
- `scripts/data/stage_data.gd` (so id/display_name)
- `scripts/data/wave_data.gd` (vazio)

**Files orphan que ainda existem:**
- `scenes/views/battle_view.tscn` (so ext_resources, nao usado)
- `data/zones/forest.tres`, `desert.tres` (ZoneData stub agora — irrelevantes)
- `data/stages/` (pasta vazia)

**Verificacao end-to-end (apos editor recompilar):**
1. Fresh save: deleta `user://save_slot_1.json`.
2. Abre game -> ExplorationView com bg cinza, player no PlayerSpawn (200, 440).
3. 3 green_slimes spawnam nos SpawnPoints.
4. Click no chao -> player anda (NavigationAgent2D).
5. Click num slime -> player walka ate em range, ataca via AttackTimer.
   HP do slime cai. Damage acima do slime.
6. Slime morre -> drop slime_goo + gold + xp. 8s depois respawna.
7. Toggle Auto -> apos kill auto-walka pro proximo. Power Strike fires em CD.
8. Player morre -> reset HP + reload area.
9. Map modal -> lista areas, click "Viajar" -> recarrega area.
10. Inventory funciona (Character modal abre, slime_goo no slot).

**Riscos/Open:**
- Player sprite ainda nao renderiza (AnimatedSprite2D sem SpriteFrames). HP
  bar e movement funcionam mas player eh invisivel ate user setar sprites.
- Enemy sprite tambem precisa AnimatedSprite2D setup.
- NavigationPolygon do prototype area NAO tem holes pros obstaculos — agent
  pode rotear atraves de wall (player vai bater fisicamente). Cosmetic
  apenas pra prototype.
- Old battle_view.tscn / data/zones/forest.tres permanecem orfaos. Deletar
  manualmente.
- Online: ainda nao implementado (premissa do prototype).

---

## 2026-05-13 - Drag/drop avancado: right-click, shift-click, Alt favorite, discard

Extensao do DragManager pra suportar features estilo Minecraft/Terraria:

**Right-click** (modifier="right" via `_on_gui_input`):
- Mao vazia + slot com item stackable qty>=2: pega `ceil(qty/2)`. Slot fica
  com a outra metade.
- Mao vazia + slot com qty=1 ou nao-stackable: pega o item inteiro (igual
  left-click).
- Mao com item + slot vazio: dropa 1 do held. Held qty--.
- Mao com item + slot com mesmo stackable: merge 1.
- Mao com item + slot com item diferente: no-op (sem swap pelo right-click).

**Shift-click** (`DragManager.handle_shift_click`):
- Em inventory item: tenta equipar no slot correspondente
  (`_slot_id_for_slot_type` mapeia slot_type -> slot_id). Swap se equip ja
  tem item nao-favoritado.
- Em equipment item: desequipa pro primeiro inventory slot vazio.
- Bloqueia se equip slot esta favoritado.
- Materiais (slot_type=NONE): no-op (no chests yet).

**Alt+left-click** (toggle favorite):
- Direto via `character.toggle_inventory_slot_favorited(idx)` ou
  `toggle_equipment_favorited(slot_id)` (bypass DragManager).
- So funciona em slot com item.

**Favorited storage**:
- Inventory: `inventory_slots[i].favorited` (bool no dict do slot, default
  false). Drag carrega o flag.
- Equipment: `equipment_favorites: Dictionary` (slot_id -> true). `set_slot` e
  `set_equipment` ganharam param opcional `favorited` (default false).
- Serializado no save (`equipment_favorites: Array[String]` + slot dicts
  ganham `"favorited": true` quando aplicavel). Save antigo = sem favorites.

**Discard ("jogar no chao")**:
- Click no backdrop com mao segurando + item NAO favoritado: abre
  `ConfirmationDialog` ("Descartar item?" / "Voltar pra origem").
- Item favoritado: silent cancel (volta pra origem direto).
- `DragManager.discard_held()` apaga o held permanentemente (sem write back).

**Visual lock icon**:
- Novo `LockIcon` TextureRect em `inventory_slot_v2.tscn`, top-center, 24x24,
  `mouse_filter=IGNORE`. Texture pre-carregada de `icons/lock_icon.png` no
  `_ready`. Visible quando `_favorited == true` e ha item.

**Sort behavior**:
- `sort_inventory(mode)` agora pula slots favoritados (pinned). Items
  moveable sao re-ordenados nos slots NAO-pinned.

**Bloqueios em items favoritados**:
- Equipment favoritado: pickup BLOCKED (`_try_pickup` early return).
- Equipment favoritado como target de swap: drop BLOCKED.
- Discard: BLOCKED.
- Sort: nao move.
- Shift-pra-chest: BLOCKED (N/A ainda).
- Shift-pra-equip ainda funciona (acao positiva, preserva flag).
- Right-click drop 1 numa equip favoritada: bloqueado pelo mesmo target_item != null check.

---

## 2026-05-13 - Item templates + dev menu "Add Item to Inventory"

**Templates base** (`data/items/templates/*.tres`) — 16 arquivos placeholder
pra duplicar quando criar items novos: helmet/chest/legs/boots, necklace/
earrings/ring/bracelet, weapon, pickaxe/axe/fishing_rod/scythe, material/
consumable/artifact. Cada um pre-configurado com `item_type`, `slot_type`,
sprite placeholder e bonus exemplo. README.md no folder explica como
duplicar + tabelas de enums (ItemType, SlotType, Rarity).

**Dev menu novo**: section "Add item to inventory" no `dev_modal.tscn`/.gd:
- Panel ampliado pra 600x700.
- Scaneia `res://data/items/*.tres` no `_on_open` (re-le a cada abertura,
  reflete items novos adicionados durante a sessao).
- Filtros: ignora subpasta `templates/` (DirAccess nao recursivo); ignora
  items cujo `id` comeca com `template_` (double-safety).
- Cada item: icon 32x32 + nome `[Tipo]` + botao "+1" + "+10" (so stackable).
- LineEdit de busca filtra a lista por substring no display_name (case-
  insensitive).
- Adicao: items normais via `GameState.add_item_to_character` (inventory).
  Artifacts vao pro primeiro slot vazio de artifact via `set_artifact`.

WaveGrid passou de 3 cols x 3 rows pra 5 cols x 2 rows pra economizar espaco
vertical no modal. Buttons menores (28px height).

---

## 2026-05-13 - Hotfixes pos drag/drop (equipamento, artifacts, fallback weapon)

Bugs descobertos no playtest do drag/drop e corrigidos no mesmo dia:

- **CombatStats double-counting da starting_weapon:** `_from_data_only` somava o bonus da `starting_weapon` direto na base, e `_from_instance` tinha um caso especial pra NAO somar se a arma equipada == starting_weapon. Resultado: desequipar a starting_weapon NAO removia o bonus dela; equipa-la de novo nao adicionava (ja estava pre-baked). FIX: starting_weapon bonus removido de `_from_data_only`. `_from_instance` agora itera UNIFORMEMENTE todos EQUIP_SLOTS aplicando bonus_atk/spd/def/hp/mp — sem casos especiais. Equipamento agora produz a diferenca correta.
- **Weapon sprite nao atualizava ao trocar equipamento:** `combat_controller._on_character_stats_changed` so refresh-ava HP bar e attack timer. Faltava re-aplicar `apply_weapon(item, anchor, scale, rotation)` no Player quando equipment mudava. FIX: novo handler `_on_character_equipment_changed` conectado a `EventBus.character_equipment_changed` -> chama `_player.apply_weapon(weapon, data.weapon_anchor, ...)`. Desequipar agora esconde a arma; equipar mostra a nova.
- **Fallback weapon (maos vazias) sem VFX:** Player ja damageava com base ATK quando sem arma, mas `_attack_vfx_texture = null` deixava o ataque sem feedback visual. FIX: constante `FALLBACK_VFX_PATH = "res://assets/sprites/effects/cut_vfx000.png"` + `FALLBACK_VFX_SCALE = 1.5` em `player.gd`. `apply_weapon(null)` agora carrega o fallback VFX com pattern BLINK. Player atacando com maos: stats base, sem sprite de arma, com VFX generico.
- **Artifacts NAO devem ser movidos:** decisao do usuario — cada artifact fica no seu slot fixo (populado por sistemas futuros, nao pelo player). REVERT: `_refresh_artifacts_panel` volta a esconder slots sem item (`visible = false`). `artifact_slot.gd` perde o `gui_input` handler + metadata fields (slot_index, character) + import implicito de DragManager. `_build_slot_refs` nao seta `slot_index` em artifact slots. DragManager mantem o codigo dead-branch pra "artifact" pool por defensa (nunca chamado).
- **Fonte do ghost qty label:** estava usando fonte default do sistema Godot. FIX: `drag_manager.tscn` ganha `theme = default_theme.tres` no GhostRoot (PT Serif Bold 700, padrao do projeto). Propaga via theme inheritance pro GhostQty Label.

---

## 2026-05-13 - Drag & Drop click-to-place entre slots (character modal)

**Modelo de interacao:** click pega item (slot esvazia, ghost gruda no cursor), click no destino solta. Inspirado em Minecraft/Terraria — NAO hold-and-drag.

**Dominios isolados (decisao do usuario):**
- Inventory <-> Equipment: livre. Equipment slot filtra `item.slot_type == accept_slot_type`.
- Artifact <-> Artifact: pool isolado. Artifact NAO se mistura com inventory/equipment.

**Files novos:**
- `scenes/ui/drag/drag_manager.gd/.tscn` — autoload CanvasLayer layer 25. API publica: `is_holding()`, `get_held_item()`, `handle_slot_click(target)`, `cancel()`. Ghost segue cursor via `_process`. Estado em `_held_item/_held_qty/_held_source`. Source guarda `pool, key, character` (+ `accept_slot_type` quando equipment).
- Registrado em `project.godot` como autoload.

**Files modificados:**
- `character_instance.gd`: API nova `set_equipment(slot, item) -> ItemData`, `clear_equipment(slot)`, `get_artifact(idx)`, `set_artifact(idx, item)`. Campo novo `artifact_slots: Array[Dictionary?]` (16 fixos). `_ensure_artifacts_initialized()` em `create()`.
- `event_bus.gd`: signal novo `character_equipment_changed(character)`.
- `save_manager.gd`: serialize/deserialize `artifact_slots`. Save antigo sem campo -> init 16 nulls. SEM bump de save_version (campo novo opcional).
- `item_data.gd`: `ItemType.ARTIFACT` adicionado ao enum (idx 6).
- `tooltip_manager.gd`: `TYPE_LABELS[6] = "Artifact"`.
- `inventory_slot_v2.gd`: campos novos `slot_index, equip_slot_id, accept_slot_type, character`. Conecta `gui_input` pra MOUSE_BUTTON_LEFT -> `DragManager.handle_slot_click`. Suprime tooltip enquanto `DragManager.is_holding()`. Funciona em modo inventory (slot_index) OU equipment (equip_slot_id != &"").
- `inventory_slot_v2.tscn`: `QtyLabel.mouse_filter = 2` (IGNORE) — antes default STOP capturava cliques no canto top-right e bloqueava gui_input do root.
- `artifact_slot.gd`: campos novos `slot_index, character`. Conecta `gui_input` pra MOUSE_BUTTON_LEFT.
- `character_modal.gd`: const `SLOT_TYPE_BY_ID` (mapa slot_id -> ItemData.SlotType). `_build_slot_refs` popula metadata estatica (`equip_slot_id`, `accept_slot_type`, `slot_index` artifact). Refresh handlers setam `character` (e `slot_index` no inventory) em cada slot. `close()`, `_on_backdrop_input`, `_unhandled_input` (ESC), `_on_hero_pressed` cancelam drag se segurando. Listener novo pra `character_equipment_changed`. Artifacts panel agora 16 slots SEMPRE visiveis (antes invisible quando vazios — necessario pra drop funcionar).

**Logica de swap (DragManager._try_drop):**
- Domain check primeiro: artifact isolado.
- Slot type check pra equipment target.
- Se target vazio: place. Se mesmo item stackable em inventory: merge. Senao: swap.
- Swap PRESERVA `_held_source` original — chain swaps funcionam (A->B->C->ESC poe C onde A estava, mantendo cadeia consistente).
- `_is_compatible_with_source` valida se target item caberia no source slot (pra equipment usa accept_slot_type guardado no pickup).

**Cancel semantics:** ESC, click no backdrop, hero swap, ou modal close cancelam drag. Item volta pra `_held_source`. `_emit_for_pool` so emite pra inventory (equipment/artifact ja emitem via APIs do CharacterInstance).

**Decisoes resolvidas:**
- N3 (drag/drop entre slots) -> click-to-place, dominios isolados.
- Wireframe #2 (drag-and-drop vs click-click) -> click-click.

**Fora de escopo v1:**
- Right-click pra half-stack split.
- Shift-click pra quick-move (inv -> equip auto).
- Highlight visual de slot valido/invalido durante hold.
- Drop "no chao" (fora do modal pra descartar item).
- Touch input nao testado.

---

## 2026-05-11 - Character Modal redesign (unified char + inventory + char select)

**Onda 1 — Data foundations:**
- `character_instance.gd`: ring2 REMOVIDO de `EQUIP_SLOTS`. `EQUIP_RING1`/`EQUIP_RING2` ficam como deprecated consts (apenas pra detection no save migration). Novo `EQUIP_RING = "ring"`. Adicionado `EQUIP_SCYTHE` (harvesting), `EQUIP_STAR_NET` (Fase 04), `EQUIP_SCOUTER` (Fase 04). Novos `STAT_STR/DEX/INT/VIT/LUK` em `VALID_STAT_IDS` — atributos primarios sao agora os spendables; STAT_HP/MP/ATK/DEF/ATK_SPEED ficam deprecated mas funcionais pra saves antigos.
- `item_data.gd`: `SlotType` ganha `SCYTHE`, `STAR_NET`, `SCOUTER`. Campo `bonus_harvesting_efficiency`.
- `efficiency.gd`: nova `ACTIVITY_HARVESTING` — formula `5 + STR*2 + DEX + scythe.bonus`.
- `combat_stats.gd`: aplica bonuses STR/DEX/INT/VIT/LUK no derived. STR→+1 ATK/pt | DEX→+0.02 attack_speed/pt | INT→+1 magic_atk/pt | VIT→+5 max_hp/pt | LUK→+0.005 crit_chance/pt. Stats antigos (HP/MP/ATK/DEF/ATK_SPEED) ainda aplicam pra saves antigos.
- `character_data.gd`: novo `char_image: Texture2D` com helper `get_char_image()` que fallback pra `default_char_image.png`.

**Onda 2 — NumberFormat:**
- `scripts/systems/number_format.gd` novo (RefCounted static). Sufixos K/M/B/T/Qa/Qi/Sx/Sp/Oc/No/Dc, max 2 decimais. Usado em todo HP/MP/exp/power/stats/qty labels.

**Onda 3 — Inventory refactor + Save Migration v1->v2:**
- `character_instance.gd`: `inventory: Dictionary` REMOVIDO. Novo `inventory_slots: Array` slot-indexed. API: `add_item`, `remove_item`, `get_slot`, `set_slot`, `sort_inventory(mode)` (rarity/quantity/type/level — destrutivo). `get_inventory_entries()` mantido pra back-compat (dedup por id).
- `crafting.gd`: usa `character.remove_item(item, qty)` agora.
- `save_manager.gd`: `CURRENT_SAVE_VERSION = 2`. Migration v1→v2:
  1. equipment.ring2 → drop pro inventory dict (qty=1).
  2. equipment.ring1 → renomeia pra "ring".
  3. inventory dict → inventory_slots Array dimensionado pra `inventory_max_slots`.
- Edge case warned: se inventory cheio na migration + ring2 ocupado, ring2 item descarta (raro).

**Onda 4 — Tooltip system:**
- `scenes/ui/tooltips/tooltip_manager.tscn/.gd` novo (autoload via CanvasLayer layer 20). API: `show_item_tooltip(item, anchor)`, `show_text_tooltip(text, anchor)`, `hide_tooltip()`.
- NinePatchRect com 9-slice 3px borders (texturas em `assets/sprites/ui/tooltips/`). Layout dinamico: weapon items mostram ATK+SPD rows (com icons), outros so name+type+description. Reposiciona pra direita do slot, flip se sair viewport. Fade-in 0.10s.

**Onda 5 — Character Modal rebuild:**
- 138 PSD assets copiados pra `assets/sprites/ui/character_screen/` (panels, slots, buttons, icons, dividers).
- `character_modal.tscn` REBUILT: 1536x1024 fullscreen com 5 zonas (Hero panel esq, Equipment centro-esq, Inventory centro-dir, Attributes baixo-esq, Artifacts baixo-dir). Posicoes baseadas em `psd-files/char_screen_export/layers.json`.
- `character_modal.gd` REBUILT (extends Control, nao mais ModalBase): coordena os 5 paineis programaticamente.
  - Hero panel: lista personagens com botoes toggle (selecionado fica pressed).
  - Equipment panel: name+lvl+exp+HP+MP+char_image (10x), 12 slots posicionados absolutamente. Toggle Equipment/Tools view (sempre abre em Equipment). Tools view substitui slots laterais por pickaxe/axe/fishing_rod/scythe + star_net/scouter/2x tbd LOCKED; weapon+2 tbd somem.
  - Inventory panel: GridContainer 5x3=15 slots, sort dropdown (Rarity/Quantity/Type/Level), paginacao prev/next.
  - Attributes panel: 5 rows (STR/DEX/INT/VIT/LUK) com "+" + Available Points label.
  - Artifacts panel: 4x4 grid (16 slots), placeholders invisible ate Fase 04.
- `inventory_slot_v2.tscn/.gd` novo: slot reutilizavel pra equipment + inventory + artifacts. NinePatchRect background trocado por raridade. Icon margin 7px (especificado pelo usuario). Quantity label canto inferior-direito. Hover dispara TooltipManager.
- Power formula: `(HP/10) + ATK*2 + DEF*2 + (attack_speed*20) + (crit_chance*100) + (LUK*5)`.

**Onda 6 — Cleanup:**
- `juicy.gd`: REMOVIDAS `button_click_pulse`, `wire_button_press`, `_button_pulse_down/up`, `_kill_button_tween`. Constants `BUTTON_PULSE_*`. Mantido `modal_appear`/`modal_disappear`. UI mais "solida" — botoes nao mudam escala.
- Call sites limpos: `menu_list_item.gd` (linha 43), `crafting_modal.gd` (linha 126), `map_modal.gd` (linha 189).
- `inventory_modal.tscn/.gd/.uid`, `inventory_slot.tscn/.gd/.uid`, `char_select_modal.tscn/.gd/.uid`, `character_pick_button.tscn/.gd/.uid` — TODOS REMOVIDOS.
- `right_panel.tscn/.gd`: `InventoryButton` e `CharSelectButton` REMOVIDOS (funcionalidade absorvida pelo character_modal).
- `modal_layer.tscn/.gd`: instances inventory_modal e char_select_modal removidas. Constants `MODAL_INVENTORY`, `MODAL_CHAR_SELECT` removidas. character_modal tipo Control (nao ModalBase).

**Decisoes confirmadas com usuario (AskUserQuestion):**
- Attribute formula: STR→ATK, DEX→Speed, INT→MagicATK, VIT→HP, LUK→Crit (com numeros especificados).
- Inventory model: Array[Dictionary] slot-indexed.
- Sort behavior: destrutivo (modifica ordem real).
- Power score: somatorio ponderado de combat stats + crit.

**Arquivos novos:**
- `scripts/systems/number_format.gd`
- `scenes/ui/tooltips/tooltip_manager.tscn`, `tooltip_manager.gd`
- `scenes/ui/modals/panels/inventory_slot_v2.tscn`, `inventory_slot_v2.gd`
- `assets/sprites/ui/tooltips/*.png` (4 assets)
- `assets/sprites/ui/character_screen/{panels,slots,buttons,icons,dividers}/*.png` (60+ assets)

**Arquivos removidos:**
- 4 sets de arquivos antigos (inventory_modal, inventory_slot, char_select_modal, character_pick_button) — .tscn/.gd/.uid cada.

**Riscos / TODO:**
- Drag/drop entre slots NAO implementado (slot tem `set_slot` API pronta).
- Class label (Warrior/Wizard/etc) nao mostrado nos hero buttons — campo `class_label` em CharacterData ainda nao adicionado.
- Equipment view: TBD1/TBD2 ficam locked. Definir feature antes de Fase 02.
- 3-state textures para buttons ainda nao styleboxed — Buttons usam Label simples. Refinar visual no proximo polish.
- Save migration testada apenas mentalmente — testar com save real.

---

## 2026-05-07 - Mining como BATALHA + UI polish + Efficiency system

**Onda 1 - UI/UX cleanup:**
- `scripts/systems/juicy.gd` novo. API:
  - `Juicy.modal_appear(modal, panel)` — fade+scale com BACK_OUT.
  - `Juicy.modal_disappear(modal, panel)` — reverso, retorna Tween pra encadear `visible = false`.
  - `Juicy.button_click_pulse(button)` — squash 0.92 -> 1.0 com TRANS_BACK.
- `modal_base.gd` aplica `Juicy.modal_appear/disappear` em todo `open()/close()` — todos os modais herdeiros (CharacterModal, MapModal, InventoryModal, BestiaryModal, etc.) ganham anim de graca. Modais nao-herdeiros (offline, area_results, crafting, skill_tree, character_details) tambem aplicam manualmente.
- `menu_list_item.gd` conecta `pressed -> Juicy.button_click_pulse(self)` automaticamente. Side menu agora "pulsa" ao clicar.
- `area_results_modal` NAO fecha outros modais ao abrir. So sobrepoe (z-order natural). Usuario pode abrir Inventory enquanto stage termina sem perder o modal de combate.
- `smithing_modal` + `smelting_modal` REMOVIDOS. Substituidos por `crafting_modal.tscn` unico com 4 abas (Smithing/Smelting/Cooking/Alchemy — Cooking e Alchemy disabled ate Fase 02).
- `settlement_view` agora so tem 1 botao: "Crafting" (era 4). Coleta foi pro Map. Skill Tree foi pro Character.
- `character_modal.tscn` LIMPO. So mostra header + HP/MP/ATK/DEF/AtkSpeed (com botoes +) + Equipment + Portrait + 2 botoes ("Details" e "Skill Tree"). As 7 secoes detalhadas movidas pra novo modal.
- `character_details_modal.tscn/.gd` NOVO. Mostra Primary, **Activity Efficiency** (mining/wood/fishing/combat), Combat Extras, Crit & Evasion, Regen & Leech, Elemental, Acquisition, Meta. Aberto via botao Details. Stackavel — sobrepoe character_modal sem fechar.
- `modal_layer` ganhou conceito de "stackable" pra Skill Tree e Character Details: abrem sem fechar os outros modais.

**Onda 2 - Mining as BATTLE com Efficiency (IdleOn-style):**
- `scripts/systems/efficiency.gd` novo. Formula:
  - `ratio = eff / eff_req`
  - `ratio < 5%` -> 0% drop (muito fraco)
  - `5% <= ratio < 100%` -> drop chance = ratio (linear), qty=1
  - `ratio >= 100%` -> 100% drop, qty = `clamp(floor(ratio), 1, 5)` (multiplicador inteiro ate 5x, conforme pedido)
  - Compute por atividade: mining (STR*3+DEX), woodcutting (STR*2+DEX*2), fishing (DEX*3+LUK*2), combat (DEX*2+LUK).
  - Bonus de pickaxe/axe/fishing rod equipada (campo `bonus_<activity>_efficiency` em ItemData).
- `scripts/data/ore_target_data.gd` novo. Resource com base_texture + cluster_texture, eff_req, max_hits (50), respawn_seconds, level.
- 3 ores criados em `data/items/`: `copper_ore`, `iron_ore`, `gold_ore`.
- 3 OreTargets em `data/gathering/`: `copper_ore_target` (eff_req 12), `iron_ore_target` (35), `gold_ore_target` (80).
- `scripts/data/gathering_spot_data.gd` novo. Resource com lista de ate 5 OreTargets + `activity` + zone_id.
- 3 spots em `data/gathering/`: `copper_spot` / `iron_spot` / `gold_spot` (cada um com 5 ores).
- `scenes/combat/ore_target.gd` novo. Node2D com 2 sprites (Cluster atras, Base na frente). Hit anima APENAS o Cluster com shake horizontal (+/-6px) + pulse scale (1.0 -> 1.10 -> 1.0). HP bar pequena. Quando hits chegam a 0, cluster fade-out e respawn agendado por unix-time. Emite `hit_resolved(item, qty, world_pos)` pro controller cuidar do drop.
- `combat_controller.gd` ganhou modo `MODE_GATHER`. `_on_player_attack` divide entre combat (atual) e gather. Em gather: `_on_player_attack_ore` chama `Efficiency.compute(character, activity)` e `ore.take_hit(eff)`. Drops vao pro mesmo `_spawn_item_drop` do combat normal — caem no chao com hover/auto-loot. `_on_gathering_spot_requested` (signal) limpa enemies + spawna ore_targets em arc layout (reuso de `_arc_layout`). `_on_combat_mode_requested` reverte.
- `EventBus`: novos signals `gathering_spot_requested(spot_data)` e `combat_mode_requested()`.
- `map_modal.tscn/.gd` ganhou 2 abas: Combat (zona/area/stage existente) e Gathering (lista de spots carregados de `data/gathering/*_spot.tres`). Cada spot mostra eff atual vs eff_req do primeiro ore + chance de drop calculada. Botao "Entrar" emite `gathering_spot_requested`.

**Decisoes implicitas:**
- 5x e' o cap MAX_DROP_MULTIPLIER em `efficiency.gd`. Ratios maiores ate 5x dao multiplicador inteiro; acima fica em 5x.
- Ore drop usa o mesmo helper de combat (`_spawn_item_drop`) — drops caem no chao na posicao do cluster, com offset natural do helper.
- Player NAO se move pra perto do minerio nesta versao (TODO de polish: aproximar player do ore alvo + escala perspectiva).
- Sem mini-game de mining ainda (TODO: quando o cluster atingir threshold de hits, abrir mini-game modal pra bonus). O `hit_resolved` ja e' o gancho.
- Auto-loot toggle continua funcionando — se ON, drops vao direto pro inventario.

**Arquivos novos:**
- `scripts/systems/juicy.gd`
- `scripts/systems/efficiency.gd`
- `scripts/data/ore_target_data.gd`
- `scripts/data/gathering_spot_data.gd`
- `scenes/combat/ore_target.gd`
- `scenes/ui/modals/crafting_modal.tscn` (substitui smithing+smelting)
- `scenes/ui/modals/character_details_modal.tscn/.gd`
- `data/items/iron_ore.tres`, `gold_ore.tres`
- `data/gathering/copper_ore_target.tres`, `iron_ore_target.tres`, `gold_ore_target.tres`
- `data/gathering/copper_spot.tres`, `iron_spot.tres`, `gold_spot.tres`

**Arquivos REMOVIDOS:**
- `scenes/ui/modals/smithing_modal.tscn`
- `scenes/ui/modals/smelting_modal.tscn`

**Arquivos editados (tocados):**
- `scenes/ui/modals/modal_base.gd`, `modal_layer.tscn/.gd`
- `scenes/ui/modals/character_modal.tscn/.gd` (limpo + botoes)
- `scenes/ui/modals/crafting_modal.gd` (substitui o helper antigo)
- `scenes/ui/modals/skill_tree_modal.gd` (juicy)
- `scenes/ui/modals/area_results_modal.gd` (juicy + nao fechar outros)
- `scenes/ui/modals/offline_summary_modal.gd` (juicy)
- `scenes/ui/modals/map_modal.tscn/.gd` (2 abas)
- `scenes/ui/menu_list_item.gd` (pulse no click)
- `scenes/views/settlement_view.tscn/.gd` (so 1 botao)
- `scenes/combat/combat_controller.gd` (gather mode + signals)
- `scripts/data/item_data.gd` (bonus_<activity>_efficiency)
- `autoload/event_bus.gd` (2 signals novos)

**Pendente / TODO de polish:**
- Player se aproximar do ore alvo (movimentacao + escala perspectiva).
- Mini-game modal pra hits criticos.
- Picaretas com `bonus_mining_efficiency > 0` ainda nao existem como items dropaveis (slot existe; receita futura).
- Combat usar Efficiency tambem (via `accuracy` separado de hit_chance) — preparado mas nao integrado ao calculo de hit ainda.

---

## 2026-05-07 - Fase 01 Bloco B implementado com placeholders

**Decisao:** usar sprites existentes como placeholders pra liberar todos os sistemas do Bloco B sem esperar arte definitiva. Cada sistema funcional + visualmente reconhecivel; sera repaginado quando user entregar PSDs.

**Mapeamento de placeholders aplicado:**
- `forest-bg000.png` -> bg de Settlement view, Gathering view e Map modal (todos com `modulate` mais escuro pra UI ficar legivel).
- `elipse_vfx000/001/002.png` + `cross_vfx000.png` -> icones de materiais (copper_ore, copper_bar, pine_log, river_trout).
- `warrior.png` -> walker do Settlement (anda aleatoriamente em uma area definida).
- `iron-sword.png` -> sprite do bronze_sword (output de Smithing).
- Buttons existentes -> usados nos modais novos (vai-vem do theme default).

**Items novos em `data/items/`:**
- `copper_ore.tres` (Material), `copper_bar.tres` (Material refinado), `pine_log.tres` (Material), `river_trout.tres` (Material), `bronze_sword.tres` (Weapon Common, slot=WEAPON, +5 ATK / +0.05 attack_speed).

**Sistemas implementados:**

- **F01.03 Coleta basica** — `scripts/systems/gathering_session.gd` (Node) com loop de coleta automatico (timer/drop_chance por skill). 3 skills: Mining (4.0s, 85%), Woodcutting (3.5s, 90%), Fishing (5.0s, 70%). Apenas 1 ativa por vez (placeholder; multi-skill paralelo chega na Fase 02).
- **F01.05 Settlement view** — `scenes/views/settlement_view.tscn/.gd` reescrito do placeholder. 4 botoes (Coleta/Forja/Fornalha/Tenda) + walker aleatorio do Warrior (sprite 2D).
- **F01.04 Crafting basico** — `scripts/systems/crafting.gd` helper estatico. Receitas inline (Smelting: 2x Copper Ore -> 1x Copper Bar; Smithing: 2x Copper Bar + 1x Pine Log -> 1x Bronze Sword). Modais reusados: `crafting_modal.gd` parametrizado por `station_id` (smithing/smelting). Craft instantaneo por enquanto; timer/queue chega na Fase 02.
- **F01.02 Skill tree textual** — `scripts/systems/skill_tree.gd` com 18 nos do Warrior em 3 ramos (Berserker DPS / Defender TANK / Tactician UTIL). 1 skill point por level (alem do stat point existente). `unlock(node_id)` valida prereq + custo. `apply_bonuses(character, stats)` chamado em `CombatStats._from_instance`. Persistido no save (`unlocked_skill_nodes`, `skill_points_unspent`).
- **F01.06 Mapa upgrade** — `map_modal.tscn` ganhou `StyleBoxTexture` com `forest-bg000.png` como bg do panel.

**Arquivos novos:**
- `scripts/systems/gathering_session.gd`
- `scripts/systems/crafting.gd`
- `scripts/systems/skill_tree.gd`
- `scenes/ui/modals/smithing_modal.tscn` + `crafting_modal.gd` (compartilhado)
- `scenes/ui/modals/smelting_modal.tscn`
- `scenes/ui/modals/skill_tree_modal.tscn/.gd`
- `data/items/copper_ore.tres`, `copper_bar.tres`, `pine_log.tres`, `river_trout.tres`, `bronze_sword.tres`

**Arquivos editados:**
- `scenes/views/gathering_view.tscn/.gd` (reescrito do placeholder)
- `scenes/views/settlement_view.tscn/.gd` (reescrito do placeholder)
- `scenes/ui/modals/modal_layer.tscn/.gd` (3 novos modais registrados)
- `scenes/ui/modals/map_modal.tscn` (bg da Floresta)
- `scripts/systems/character_instance.gd` (skill_points_unspent + unlocked_skill_nodes)
- `scripts/systems/combat_stats.gd` (`SkillTree.apply_bonuses` no _from_instance)
- `autoload/save_manager.gd` (persiste skill tree + helper _serialize_string_name_array)

**Pendente / nao implementado nesta fase (conforme decisao):**
- F01.01 Mapa: spots de gathering como nodes interativos no mapa (so bg foi atualizado). Vai precisar de sprites de spot pra ficar ideal.
- F01.03 Sistema de Eficiencia (decisao #15) ainda nao integrado — placeholder usa drop chance flat. Implementacao real quando spots viverem no mapa.
- F01.04 Timer/queue de craft. Hoje craft e' instantaneo.
- F01.05 Multi-personagem walker (so o Warrior anda hoje).
- F01.07 ja foi feito no Bloco A (modal de results).

**Como testar:**
1. Abrir Settlement -> ver bg + warrior andando + 4 botoes.
2. Coleta -> escolher skill, ver progress bar enchendo, materiais entrando no inventario.
3. Forja/Fornalha -> receitas listadas; botao Craft ativa quando tem inputs.
4. Tenda -> 3 colunas de skill tree; clicar Unlock gasta 1 skill point e aplica bonus.
5. Inventory -> ver materiais coletados/craftados.
6. Character modal -> ver bonus da skill tree refletindo nos stats (ex: +2 ATK depois de unlock berserk_atk_1).

**Proximo passo (quando user entregar assets):**
- PSDs de spots de gathering, ferramentas (pickaxe/axe/fishing rod), estruturas do acampamento (forja/fornalha/tenda), bg do acampamento. Aplicar via pipeline PSD existente.

---

## 2026-05-07 - B0 (stats expandidos aplicados) + Fase 01 Bloco A FECHADO

**B0 — Aplicacao real dos stats expandidos:**
- `scripts/data/character_data.gd`: ~35 campos base novos (STR/DEX/INT/VIT/LUK, magic_atk/def, hit_number, cast_speed, cdr, regen, leech, crit, dodge, accuracy, 8 elementais dmg + 8 elementais resist, exp/gold/loot/equip/material/card drop pcts, skill/mastery exp pcts).
- `scripts/systems/combat_stats.gd::_from_data_only` agora popula tudo a partir de CharacterData.
- `data/characters/warrior.tres` recebeu valores razoaveis (STR=8, VIT=6, DEX=4, LUK=3, INT=2; crit_chance=0.05, dodge=0.05, hp_regen=0.5; elementais zerados).
- `scenes/ui/modals/character_modal.tscn` reescrito com ScrollContainer + 7 secoes (Primary, Combat, Crit & Evasion, Regen & Leech, Elemental, Acquisition, Meta). Stats em zero/neutral aparecem com opacity 0.4 (visual de "irrelevante por enquanto"). Botoes + so em HP/MP/ATK/DEF/AtkSpeed.

**B1 — Bestiario simples (F01.06):**
- Novo autoload `Bestiary` (entre SaveManager e GameState em `project.godot`). API: `register_kill(enemy_data)`, `get_kills`, `is_discovered`, `get_total_kills`. Persiste em `account_data.bestiary`.
- `GameState.register_kill_for_character` agora tambem chama `Bestiary.register_kill`.
- `EventBus.bestiary_updated(enemy_id, total_kills)` novo.
- `scenes/ui/modals/bestiary_modal.tscn/.gd` lista todos enemies (carregados de `data/enemies/*.tres`); descobertos primeiro, "?????" para nao vistos.
- `scenes/views/codex_view.tscn/.gd` ganhou layout com botao "Bestiario" que abre o modal.

**B2 — Sistema de velocidade 1x/2x (F01.08):**
- `GameState.game_speed: int = 1` + `set_game_speed(speed)` aplica `Engine.time_scale`.
- `EventBus.game_speed_changed(speed)` novo.
- Persistencia em `account_data.configuracoes.gameplay_default_speed`.
- `right_panel.tscn/.gd`: novo toggle "1x/2x" abaixo dos botoes de modal.
- **Refactor critico:** `SaveManager` trocou `_autosave_timer` (Timer node, afetado por time_scale) por gating em `_process` via `Time.get_unix_time_from_system()`. Autosave dispara a cada 60s REAIS — em 2x nao dobra a frequencia.

**B3 — Tela de resultados pos-clear (F01.07):**
- Novo `scripts/systems/area_clear_tracker.gd` (RefCounted): acumula xp/gold/kills/drops + coords (zone, area, stage) + elapsed_seconds.
- `combat_controller.gd`: tracker membro `_area_tracker`. Hook em `_on_enemy_died` adiciona xp/gold/drops/kill. `_advance_wave` emite `EventBus.area_cleared(character, summary)` quando todas as waves do stage terminam.
- `EventBus.area_cleared` novo.
- `GameState.last_area_clears: Dictionary` persiste o ultimo summary por (zone, area, stage). `account_data.last_area_clears` no save.
- `scenes/ui/modals/area_results_modal.tscn/.gd`: titulo, stage label, comparativo "Xs mais rapido" vs ultimo clear, grid de stats (XP/Gold/Kills/Time), drops scrolaveis com cores por raridade. Auto-close em 8s.
- `modal_layer` registra o modal e escuta `area_cleared`.

**Termos novos no glossario:**
- `Bestiary` (autoload), `area_clear_tracker`, `area_results_modal`, `game_speed`, `last_area_clears`.

**Estado atual:**
- Fase 0 + B0 + Fase 01 Bloco A: implementados.
- Fase 01 Bloco B (mapa, coleta, crafting, acampamento, skill tree): aguardando assets do user.

**Proximo passo:**
- Validacao manual no editor: matar slimes, ver bestiario popular; toggle 2x funcionando + autosave em tempo real; modal de results aparecendo ao clear stage.
- Quando estiver OK, partimos pra Bloco B conforme assets entregues.

---

## 2026-05-07 - Stretch fix + Footer via pipeline PSD + workflow estabelecido

**O que mudou:**
- `project.godot`: `window/stretch/aspect = "keep"` (era "expand"). Layout fixo em base 1920x1080, escala uniforme em qualquer tamanho de janela, pillarbox preto pra outros aspects.
- Pipeline PSD -> Godot validado com o Footer:
  - `tools/psd_extract.py` extrai layers.json + PNGs de cada camada.
  - User exportou `psd-files/footer_export/`.
  - Reconstruido `scenes/ui/footer.tscn` com posicionamento absoluto baseado nas coords do PSD (origem em (395, 857), 1129x219).
  - Bars (HP/MP/EXP) renderizam ATRAS do track PNG (track tem opacidade propria).
  - Outline preto 2px em todos os Labels.
  - Cor #C9BD93 nos labels de stat/key, branco nos numbers das bars.
  - XpFill = #F2D14C.
  - PortraitFill (ColorRect) com 14px de margem interna pra nao cobrir a borda dourada do slot.
  - Font sizes derivados do fator de escala do PSD (75pt -> 23, 58.86 -> 18).
- Removidos do footer (nao estavam no PSD): BattleLogBtn, CharSkillsBtn, SharedSkillsBtn. Signal `battle_log_toggle_requested` continua existindo.
- 9 PNGs do PSD importados em `assets/sprites/ui/footer/`.
- `skill_slot.tscn` virou Control 88x88 com TextureRect do `skill_slot_000.png`, reutilizado nas 8 posicoes do grid (4x2) do PSD.
- Workflow oficial documentado em `00_meta/psd-workflow.md`.

**Decisoes-default registradas:**
- Stretch aspect = keep, mode = canvas_items: layout permanece intacto em qualquer tamanho de janela. Pillarbox/letterbox preto em aspects nao-16:9.

**Proximo passo:**
- B0: popular stats expandidos no Warrior + exibir todos no character_modal.
- Bloco A da Fase 01 (sistemico): bestiario, velocidade 1x/2x, tela de resultados pos-clear.

---

## 2026-05-06 - Fase 0 (Foundation) FECHADA

**Estado final do codigo:**
- E1 — Stats expansion: `CombatStats` agora tem TODOS os stats da secao 3.2 do roadmap (~35 campos novos, defaults zerados). `_refresh_stats` propaga todos. Stats elementais zerados na base (decisao #13).
- E2 — Inventory + Equipment: `ItemData` ganhou enums `Rarity` (6 tiers) e `SlotType` (16 slots), campos `bonus_def`/`bonus_max_hp`/`bonus_max_mp`, e estrutura zerada para affixes/encantamentos/gemas (Fase 02+). `CharacterInstance.EQUIP_SLOTS` agora tem 16 slots. `CombatStats._from_instance` soma bonus de TODOS os equips. `inventory_slot.gd` colore por raridade.
- E3 — Roster + Loot tier: `LootEntry` ganhou campo `rarity`. `loot_roller` ganhou TODO marcando ganchos de Fase 02+ (loot_gain_pct, pity Mythic, etc.). `GameState.get_character_by_id()` adicionado para multi-char futuro. Slimes (4 .tres) tem `rarity = 0`.
- E4 — SaveManager: novo autoload em `autoload/save_manager.gd`. JSON em `user://save_slot_1.json` + 3 backups rotativos + sha256 hash de integridade + autosave a cada 60s + save em level-up + save em window-close + botoes "Salvar agora" / "Backup manual" no Settings. Versionamento (v1) com helper de migracao pronto.
- E5 — OfflineSimulator: novo `scripts/systems/offline_simulator.gd` com cap 12h (decisao #18), anti-relogio, simulacao por personagem com placeholders conservadores (0.5 kills/s, 5 XP/kill, 1 gold/kill). Modal `offline_summary_modal` mostra ganhos e aplica via "Coletar tudo". Botao "Simular 1h offline" no Dev Modal para testar sem fechar o jogo.

**Decisoes-default adotadas (nao bloqueiam mas precisam ser revisitadas):**
- Save spec D1 (ofuscar?): NAO ofuscar. So hash de integridade. Decidir definitivo na Fase 02+.
- Save spec D3 (multi-slots?): 1 slot apenas na Fase 0. Multi-slots viram unlock da Loja Eterna na Fase 03.
- Save spec D5 (offline avanca areas?): NAO. Personagem so farma onde parou.
- Save spec D7 (detectar relogio?): SIM. Clamp `delta_t` em zero se `now < last_unix`.

**Reordenacao de autoloads:** SaveManager precisa vir antes de GameState em `project.godot` para que `GameState._ready()` consiga chamar `SaveManager.has_save()` e `load_game()`.

**Total de arquivos tocados na Fase 0:** ~18 arquivos. Total de linhas adicionadas ~700. Sem refactor disruptivo do codigo de combate.

**Pendente para playtest:**
- Validar end-to-end o fluxo "fechar -> esperar -> abrir -> ver modal -> Coletar tudo".
- Confirmar que o save persiste todo o estado atual (level/gold/zona/inventario/kill_counts) sem regressao.
- Verificar se sintaxe esta OK no editor da Godot 4.6 (muitos campos novos em CombatStats podem ter algum erro pequeno).

**Proximo passo:** Fase 01 - Core Loops. Items principais:
- Mapa + navegacao entre zonas (ja em parte)
- Skill tree basica (textual no inicio)
- Coleta basica (Mining + Woodcutting com Sistema de Eficiencia ja documentado)
- Crafting basico (Smithing)
- Acampamento estagio 1 (3-5 estruturas, personagens andando)
- Bestiario simples (info, sem buffs)
- Tela de resultados pos-clear de area
- Sistema de velocidade 1x/2x toggle no UI

---

## 2026-05-06 (lote 6) - Decisoes aplicadas nos arquivos de origem

**O que mudou:**
- 2 agentes em paralelo aplicaram as 16 decisoes resolvidas nos catalogos e arquivos de fase.
- Total de 16 arquivos editados em `01_design/`, `02_math/`, `04_phases/` e `00_meta/`.
- Nova secao "Sistema de Eficiencia" criada em `01_design/gathering-materials.md` (secao 9) com formula completa.
- Nova secao identica em `02_math/progression-curves.md` (secao 7) como ponto unico de verdade matematica.
- `04_phases/phase-00-foundation.md` agora tem checkbox de 11 decisoes aplicaveis a Fase 0 marcadas. **Tudo resolvido para Fase 0 comecar.**
- Glossary expandido com Eficiencia, Pity Mythic, Skin.

**Pendencias adicionais que apareceram (nao bloqueiam Fase 0):**
- `01_design/equipment-catalog.md` precisa de subsecao explicando Skin como item de conta (pos-Loja Eterna).
- Boost global da Cidade (#16) ainda `[DECISAO PENDENTE]` — mas e' Fase 03, nao bloqueia.
- `enemies-catalog.md` nao foi tocado para tile size variavel — sera resolvido quando criar `.tres` de inimigos novos (cada inimigo declara tamanho individual).

**Status final do dia:**
- 16 / 40 decisoes resolvidas.
- 24 pendentes, todas de Fase 02+ ou cosmeticas.
- **Fase 0 tem todos os pre-requisitos definidos.**

**Proximo passo:**
- Comecar Fase 0 (Foundation). Item mais bloqueante: Save/Offline progression.

---

## 2026-05-06 (lote 5) - Audio + processo + i18n decidido

**Decisoes tomadas (lote 5):**
- **#39 Termos**: misto. Termos universais do genero (DPS, Tank, AoE, HP, MP, ATK, DEF, etc.) ficam em ingles em ambas versoes. Termos narrativos (Acordar, Carnificina, Maestria) traduzem.
- **#6 Boss music**: 1 por zona compartilhada. 6 musicas de boss total no R1.0.
- **#21 Bau Compartilhado**: libera na FASE 03 (Mid-Game / Cidade). Materiais primeiro, equipamentos depois.
- **#35 Alfa**: solo ate 30h+ de conteudo, depois alfa fechada com 5-15 convidados.

**Implicacoes:**
- `00_meta/release-plan.md`: confirmado timeline solo > alfa fechada > beta > 1.0.
- `01_design/audio-needs.md`: 6 musicas de boss + 6 musicas de zona = 12 musicas core.
- `01_design/account-vs-character.md`: Bau Compartilhado entra na lista da Fase 03.

---

## 2026-05-06 (lote 4) - Modelo de negocio fechado

**Decisoes tomadas (lote 4):**
- **#13 Elementos**: tudo zerado. Afinidade vem de equip/skill/encantamento. Mage NEUTRO, decide build via item.
- **#33 Monetizacao R1.0**: Free no Steam + Gemas pagas (Loja Eterna) para cosmeticos/slots/conveniencia. NAO pay-to-win. Gemas tambem in-game.
- **#36 Idiomas R1.0**: PT-BR + EN. ES e outros para updates pos-1.0.
- **#23 Colecao stat**: FIXO por tipo+tier (Espada Common = +1 ATK fixo, Rare = +5 ATK).

**Implicacoes:**
- Stats elementais: zerar todos no `CombatStats.from_character()`. Equip/skill/encant aplicam por cima.
- Loja Eterna pode comecar a entrar no design ja na Fase 03 (Mid-Game).
- i18n: ja preparar codigo com `tr()` desde a Fase 0 (todos textos novos), exportar pt_br.csv + en.csv.
- `equipment-catalog.md`: tabela de Bonus de Colecao confirmada.

---

## 2026-05-06 (lote 3) - Mais 4 decisoes + nova mecanica de Eficiencia

**Decisoes tomadas (lote 3):**
- **#34 Plataforma**: STEAM (PC primeiro). Multi-plataforma fica para 1.0+.
- **#8 Pity Mythic**: SIM, threshold 100 legendary sem mythic.
- **#15 Afinidade de classe em gathering**: NAO e' velocidade nem XP. E' EFICIENCIA estilo IdleOn — drops nao sao garantidos enquanto Eficiencia do personagem nao bate o requisito do node. Classe certa = mais Eficiencia base = mais drop garantido. Falha = anima mas nao dropa. Nova mecanica precisa documento proprio.
- **#22 Skins de deletado**: ficam na conta. Tudo da Loja Eterna vincula a CONTA.

**Nova mecanica a documentar:** SISTEMA DE EFICIENCIA DE GATHERING.
- Cada node tem `eficiencia_minima` (T1=10, T2=25, T3=50, T4=100, T5=200, T6=400 — propostos).
- Cada personagem tem `eficiencia[skill]` que cresce com mastery + nivel + bonus de classe + equip de ferramenta.
- Se `personagem.eficiencia[skill] < node.eficiencia_minima`: chance de drop = `eficiencia/minima * 100%` (ex: 50% se metade).
- Se `>=`: drop = 100% (sempre dropa).
- Bonus de classe (afinidade): +20-50% eficiencia base na skill afim.
- Adicionar secao em `01_design/gathering-materials.md` e formula em `02_math/`.

**Implicacoes imediatas:**
- `00_meta/release-plan.md`: confirmar Steam como target unico ate 1.0.
- `01_design/gathering-materials.md`: adicionar secao "Sistema de Eficiencia".
- `02_math/`: criar entry de formula `eficiencia_drop_chance(personagem, node)`.
- `01_design/account-vs-character.md`: skins/cosmeticos sao itens de CONTA.

---

## 2026-05-06 (lote 2) - Mais 4 decisoes destravadas

**Decisoes tomadas (lote 2):**
- **#3 Visual de equipamento**: SO ARMA altera visualmente o personagem. Armadura nao tem peca visual. Personagem muda via SKIN COMPLETA (substitui sprite + retrato). Arma e' camada simples sobre personagem-base. Reduz drasticamente o trabalho de arte.
- **#12 Tiers de raridade**: 6 (Common, Uncommon, Rare, Epic, Legendary, Mythic). Long tail confirmado.
- **#14 Velocidade**: 1x e 2x desde o inicio. 4x e 8x sao unlocks progressivos (Renascimento / Loja Eterna).
- **#18 Offline cap**: 12h base. Loja Eterna desbloqueia 24h / 48h / 72h depois.

**Implicacoes imediatas:**
- `01_design/graphics-needs.md`: drasticamente reduzir entradas de "armaduras visuais". Manter so: arma por slot equipada (varia visualmente), skin completa por personagem (substitui tudo), retrato por skin/awakening.
- `01_design/equipment-catalog.md`: confirmar 6 tiers em todos os slots.
- `01_design/save-offline-spec.md`: cap=12h confirmado.
- `04_phases/phase-01-core-loops.md`: speed toggle 1x/2x ja entra na fase 1.

**Proximo passo:**
- Continuar destravando pendentes em lote.

---

## 2026-05-06 (continuacao) - Primeiras 4 decisoes destravadas

**Decisoes tomadas (lote 1 de N):**
- **#1 Tile size**: VARIAVEL — pequenos 16-24, medios 32-48, grandes 64-96, mini-boss/boss 128. Decisao mais flexivel que o esperado, abre espaco para variedade visual.
- **#5 Orientacao**: Landscape (desktop primeiro). Layout atual (sidebar + painel central + painel direito + footer) confirmado.
- **#19 Gold**: por CONTA. Pool unico compartilhado por todos personagens.
- **#20 Equipamento e inventario**: POR PERSONAGEM cada um. Bau Compartilhado fica como feature posterior (Reino+, decisao #21 ainda pendente).

**Implicacoes imediatas:**
- `01_design/graphics-needs.md` precisa ser revisitado para refletir tile-size variavel (cada inimigo declara seu tamanho).
- `01_design/account-vs-character.md` precisa atualizar tabela final.
- `02_math/balance-tables.md` continua valido.
- Planos de `04_phases/phase-00-foundation.md` ainda compativeis.

**Proximo passo:**
- Continuar destravando pendentes em lote.

---

## 2026-05-06 - Inicio da fase de planejamento profundo

**Snapshot do projeto hoje:**
- Combate funcional (zona/estagio/area/wave). Slimes verde/azul/roxo/vermelho com stats em ordem ascendente de dificuldade.
- Side menu reorganizado: Exploration / Quests / Codex / Settlement no topo; Settings / Help no rodape. Town e Gathering removidos (Settlement vai evoluir para Town/Kingdom; Gathering vai virar spots no mapa de Exploring).
- Footer com `battle_footer.png` (1137x226). Battle scene shifted up 64px para o player nao ser cortado.
- Dev panel virou Dev Modal com cheats (unlock entire map, etc.).
- HP bar do inimigo com toggle de numeros internos (gancho em Settings).
- Item drops com merge automatico (mesmo item -> qty empilha).
- XP curve em `scripts/systems/xp_curve.gd` com componente polinomial + exponencial.
- Battle Log autoload com painel slide-up no footer.
- Level up com VFX (pulse + particulas + texto) e stat points para HP/MP/ATK/DEF/Atk Speed.
- Map modal funcional, dev unlock all zones disponivel.

**Pendencias visiveis:**
- `town_view.tscn` e `gathering_view.tscn` ainda existem como placeholders no `main.tscn` mesmo com botoes removidos.
- VIEW_TOWN e VIEW_GATHERING constantes mantidas (Town volta no futuro como evolucao do Settlement).
- Roadmap completo: ainda nao implementado (multi-personagem, classes, gathering skills, crafting, dungeons, renascimento, transcendencia, ascensao, etc.).

**O que foi feito nesta sessao:**
- Criada estrutura `planning/` com 6 subpastas e este hub.
- Adicionados arquivos seed: `README.md`, `00_meta/self-instructions.md`, `00_meta/progress-log.md`, `00_meta/glossary.md`.
- 5 agentes em paralelo despachados para preencher: catalogos de conteudo (12 arquivos), graficos+audio+UI+save (4), matematica e balance (6), pesquisa externa (5), fases+juicy+processo (8).
- Atualizada MEMORY.md do Claude apontando para este hub.

**Resultado dos 5 agentes (todos concluidos em paralelo):**
- 42 arquivos `.md` criados em `planning/` (esperado 38, alguns sub-itens viraram arquivos extras).
- Agente 1 (Content Catalogs): 12 catalogos, ~20 termos novos para o glossario.
- Agente 2 (Production): 4 docs, ~800 entradas em graphics-needs, 250 em audio-needs, 28 wireframes.
- Agente 3 (Math): 6 docs com formulas em pseudo-codigo aplicavel a GDScript.
- Agente 4 (Research): 5 docs, MAS com brave-search NEGADO. Conhecimento previo (jan/2026), URLs marcadas `[VERIFICAR]`. **Precisa rerun** com brave-search aprovado.
- Agente 5 (Phases & Juicy): 11 docs (6 phases + 2 juicy + 3 meta).

**Apos os agentes voltarem (mesma sessao):**
- Glossario expandido com ~30 termos novos consolidados.
- Criado `00_meta/pending-decisions.md` com 40 decisoes pendentes catalogadas e numeradas.
- Atualizado `README.md` mencionando nota do Agente 4.

**Decisoes pendentes mais criticas (top 10):**
1. Tamanho do tile de combate (64/96/128).
2. Paleta global oficial (32 cores HEX).
3. Layered sprites OU substituicao total para equipamento?
4. Orientacao de tela (landscape desktop / portrait mobile).
5. Gold por conta OU por personagem?
6. Equipamento no inventario por conta OU por personagem?
7. GROWTH (XP) = 1.07 — validar em playtest.
8. Pity em Mythic (threshold 100)?
9. Cap inicial de tempo offline (12h proposto).
10. Velocidade 2x: default OU unlock da Loja Eterna?

Lista completa em `00_meta/pending-decisions.md`.

**Proximo passo:**
- Usuario responde decisoes pendentes (top 10 desbloqueia Fase 0).
- (Opcional) Re-rodar Agente 4 com brave-search aprovado para validar URLs.
- So entao iniciar implementacao da Fase 0/1 conforme `04_phases/phase-00-foundation.md`.

---

## Template para entradas futuras

```
## YYYY-MM-DD - Titulo curto da sessao

**O que mudou no codigo/docs:**
- (lista curta)

**Decisoes tomadas:**
- (lista curta com justificativa)

**Bloqueios encontrados:**
- (se houver)

**Proximo passo:**
- (1-2 itens)
```
