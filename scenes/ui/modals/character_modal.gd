extends Control

# Character Modal — tela unificada (Hero + Equipment + Inventory +
# Attributes + Artifacts). Fase B+ rebuild fiel ao PSD em
# `psd-files/char_screen_export/` (1920x1080).
#
# Layout INTEIRO declarado em character_modal.tscn — este script SO faz:
#   1. Conectar signals (close, hero buttons, attribute add, sort/page,
#      toggle equipment/tools).
#   2. Atualizar conteudo dinamico (labels, slot data, hero buttons).
#   3. Lidar com open()/close() + ESC handling.
#
# API publica (duck-typed ModalBase): open() / close().

const HERO_BUTTON_SCENE: PackedScene = preload("res://scenes/ui/modals/panels/hero_button.tscn")

# View modes do equipment panel.
const VIEW_EQUIPMENT: StringName = &"equipment"
const VIEW_TOOLS: StringName = &"tools"

const SLOTS_PER_PAGE: int = 15  # 5 cols x 3 rows
const ARTIFACT_SLOTS: int = 16  # 4x4

# Map slot_id -> node name no .tscn. Usado pra montar `_equip_slot_refs` em
# _ready. Mantemos como Dictionary pq alguns slot_ids tem nomes diferentes
# do node (ex: tbd1 -> Tbd1Slot).
const EQUIP_SLOT_NODES: Dictionary = {
	&"helmet": "HelmetSlot", &"chest": "ChestSlot", &"legs": "LegsSlot", &"boots": "BootsSlot",
	&"necklace": "NecklaceSlot", &"earrings": "EarringsSlot", &"bracelet": "BraceletSlot", &"ring": "RingSlot",
	&"weapon": "WeaponSlot", &"tbd1": "Tbd1Slot", &"tbd2": "Tbd2Slot",
	&"pickaxe": "PickaxeSlot", &"axe": "AxeSlot", &"fishing_rod": "FishingRodSlot", &"scythe": "ScytheSlot",
	&"star_net": "StarNetSlot", &"scouter": "ScouterSlot",
	&"tbd_tool1": "TbdTool1Slot", &"tbd_tool2": "TbdTool2Slot",
}

const EQUIPMENT_VIEW_SLOTS: Array[StringName] = [
	&"helmet", &"chest", &"legs", &"boots",
	&"necklace", &"earrings", &"bracelet", &"ring",
	&"weapon", &"tbd1", &"tbd2",
]
const TOOLS_VIEW_SLOTS: Array[StringName] = [
	&"pickaxe", &"axe", &"fishing_rod", &"scythe",
	&"star_net", &"scouter", &"tbd_tool1", &"tbd_tool2",
]
const TOOLS_LOCKED: Array[StringName] = [&"star_net", &"scouter", &"tbd_tool1", &"tbd_tool2"]

# Icones decorativos pra slots de equipamento vazios. Mostram qual tipo de
# item vai naquele slot quando nao ha nada equipado. Hidden quando ha item.
# So slots de equip aqui — slots de ferramenta + tbd nao tem icones (ainda).
const SLOT_ICON_BY_ID: Dictionary = {
	&"helmet": "res://assets/sprites/ui/character_screen/icons/helmet_slot_icon.png",
	&"chest": "res://assets/sprites/ui/character_screen/icons/chestplate_slot_icon.png",
	&"legs": "res://assets/sprites/ui/character_screen/icons/leggings_slot_icon.png",
	&"boots": "res://assets/sprites/ui/character_screen/icons/boots_slot_icon.png",
	&"necklace": "res://assets/sprites/ui/character_screen/icons/necklace_slot_icon.png",
	&"earrings": "res://assets/sprites/ui/character_screen/icons/earrings_slot_icon.png",
	&"bracelet": "res://assets/sprites/ui/character_screen/icons/bracelet_slot_icon.png",
	&"ring": "res://assets/sprites/ui/character_screen/icons/ring_slot_icon.png",
	&"weapon": "res://assets/sprites/ui/character_screen/icons/weapon_slot_icon.png",
	&"pickaxe": "res://assets/sprites/ui/character_screen/icons/pickaxe_slot_icon.png",
	&"axe": "res://assets/sprites/ui/character_screen/icons/axe_slot_icon.png",
	&"fishing_rod": "res://assets/sprites/ui/character_screen/icons/fishing_rod_slot_icon.png",
	&"scythe": "res://assets/sprites/ui/character_screen/icons/scythe_slot_icon.png",
}

# Map slot_id -> ItemData.SlotType (filtro do drop-target em equipment slots).
# Slots locked / tbd_* nao aparecem aqui — drop neles eh sempre rejeitado.
const SLOT_TYPE_BY_ID: Dictionary = {
	&"helmet": ItemData.SlotType.HELMET,
	&"chest": ItemData.SlotType.CHEST,
	&"legs": ItemData.SlotType.LEGS,
	&"boots": ItemData.SlotType.BOOTS,
	&"necklace": ItemData.SlotType.NECKLACE,
	&"earrings": ItemData.SlotType.EARRINGS,
	&"bracelet": ItemData.SlotType.BRACELET,
	&"ring": ItemData.SlotType.RING,
	&"weapon": ItemData.SlotType.WEAPON,
	&"pickaxe": ItemData.SlotType.PICKAXE,
	&"axe": ItemData.SlotType.AXE,
	&"fishing_rod": ItemData.SlotType.FISHING_ROD,
	&"scythe": ItemData.SlotType.SCYTHE,
	&"star_net": ItemData.SlotType.STAR_NET,
	&"scouter": ItemData.SlotType.SCOUTER,
	# tbd1, tbd2, tbd_tool1, tbd_tool2 — sem tipo, locked.
}

const SORT_OPTIONS: Array = [
	{"id": &"rarity", "label": "Rarity"},
	{"id": &"quantity", "label": "Quantity"},
	{"id": &"type", "label": "Type"},
	{"id": &"level", "label": "Level"},
]

# Theme padrao do projeto (PT Serif Bold) — aplicado a controles criados
# programaticamente (ConfirmationDialog, PopupMenu, sub-rows).
const DEFAULT_THEME_PATH: String = "res://assets/themes/default_theme.tres"

# --- @onready refs ao .tscn ---------------------------------------------

@onready var _backdrop: ColorRect = $Backdrop
@onready var _close_button: TextureButton = $CloseButton

# Hero panel.
@onready var _hero_list_vbox: VBoxContainer = $HeroPanel/HeroScroll/HeroList

# Equipment panel.
@onready var _name_label: Label = $EquipmentPanel/CharNameLabel
@onready var _level_label: Label = $EquipmentPanel/LevelLabel
@onready var _exp_bar: ProgressBar = $EquipmentPanel/XpHolder/XpBar
@onready var _exp_numbers_label: Label = $EquipmentPanel/XpHolder/XpValue
@onready var _hp_value_label: Label = $EquipmentPanel/HPValueLabel
@onready var _mp_value_label: Label = $EquipmentPanel/MPValueLabel
@onready var _char_image: TextureRect = $EquipmentPanel/CharImage
@onready var _equip_slots_root: Control = $EquipmentPanel/EquipSlots
@onready var _equipment_toggle_btn: TextureButton = $EquipmentPanel/EquipmentToggleBtn
@onready var _tools_toggle_btn: TextureButton = $EquipmentPanel/ToolsToggleBtn
@onready var _power_value_label: Label = $EquipmentPanel/PowerValueLabel
@onready var _atk_value_label: Label = $EquipmentPanel/ATKValueLabel
@onready var _def_value_label: Label = $EquipmentPanel/DEFValueLabel
@onready var _spd_value_label: Label = $EquipmentPanel/SPDValueLabel
@onready var _luk_value_label: Label = $EquipmentPanel/LUKValueLabel
@onready var _details_btn: TextureButton = $EquipmentPanel/DetailsBtn
@onready var _skill_tree_btn: TextureButton = $EquipmentPanel/SkillTreeBtn

# Inventory panel.
@onready var _inventory_slots_root: Control = $InventoryPanel/InventorySlots
@onready var _sort_dropdown_btn: TextureButton = $InventoryPanel/SortDropdownBtn
@onready var _sort_dropdown_label: Label = $InventoryPanel/SortDropdownBtn/SortDropdownLabel
@onready var _sort_btn: TextureButton = $InventoryPanel/SortBtn
@onready var _prev_page_btn: TextureButton = $InventoryPanel/PrevPageBtn
@onready var _next_page_btn: TextureButton = $InventoryPanel/NextPageBtn
@onready var _page_number_label: Label = $InventoryPanel/PageNumberLabel

# Attributes panel.
@onready var _available_points_value_label: Label = $AttributesPanel/AvailablePointsValueLabel
@onready var _strength_value_label: Label = $AttributesPanel/StrengthValueLabel
@onready var _dexterity_value_label: Label = $AttributesPanel/DexterityValueLabel
@onready var _intelligence_value_label: Label = $AttributesPanel/IntelligenceValueLabel
@onready var _vitality_value_label: Label = $AttributesPanel/VitalityValueLabel
@onready var _luck_value_label: Label = $AttributesPanel/LuckValueLabel
@onready var _strength_add_btn: TextureButton = $AttributesPanel/StrengthAddBtn
@onready var _dexterity_add_btn: TextureButton = $AttributesPanel/DexterityAddBtn
@onready var _intelligence_add_btn: TextureButton = $AttributesPanel/IntelligenceAddBtn
@onready var _vitality_add_btn: TextureButton = $AttributesPanel/VitalityAddBtn
@onready var _luck_add_btn: TextureButton = $AttributesPanel/LuckAddBtn

# Artifacts panel.
@onready var _artifact_slots_root: Control = $ArtifactsPanel/ArtifactSlots

# --- State ---------------------------------------------------------------

var _current_view: StringName = VIEW_EQUIPMENT
var _current_page: int = 0
var _current_sort: StringName = &"rarity"

# Populated in _ready (lookup tables apontando pros nodes do .tscn).
var _equip_slot_refs: Dictionary = {}       # slot_id -> InventorySlotV2
var _inventory_slot_refs: Array = []         # 15 InventorySlotV2
var _artifact_slot_refs: Array = []          # 16 InventorySlotV2

var _sort_dropdown_popup: PopupMenu
var _discard_dialog: ConfirmationDialog

# --- Lifecycle -----------------------------------------------------------

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	# Conectar input.
	_backdrop.gui_input.connect(_on_backdrop_input)
	_close_button.pressed.connect(close)
	# Equipment toggle.
	_equipment_toggle_btn.pressed.connect(_set_view_equipment)
	_tools_toggle_btn.pressed.connect(_set_view_tools)
	# Details + Skill Tree.
	_details_btn.pressed.connect(_on_details_pressed)
	_skill_tree_btn.pressed.connect(_on_skill_tree_pressed)
	# Inventory: sort + pagination.
	_sort_btn.pressed.connect(_apply_sort)
	_sort_dropdown_btn.pressed.connect(_show_sort_dropdown)
	_prev_page_btn.pressed.connect(_on_prev_page)
	_next_page_btn.pressed.connect(_on_next_page)
	_setup_sort_popup()
	_setup_discard_dialog()
	# Attribute add buttons.
	_strength_add_btn.pressed.connect(func(): _on_attr_add(&"str"))
	_dexterity_add_btn.pressed.connect(func(): _on_attr_add(&"dex"))
	_intelligence_add_btn.pressed.connect(func(): _on_attr_add(&"int"))
	_vitality_add_btn.pressed.connect(func(): _on_attr_add(&"vit"))
	_luck_add_btn.pressed.connect(func(): _on_attr_add(&"luk"))
	# Game state signals. NAO escutamos character_hp_changed — o modal so
	# mostra max_hp, que muda em level-up/stat-spend/equip (cobertos por
	# character_stats_changed + character_leveled_up + character_equipment_changed).
	# Escutar hp_changed causa refresh por tick de regen, gerando flicker
	# em hover de slots equipados.
	EventBus.active_character_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.character_inventory_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.character_stats_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.character_equipment_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.character_xp_changed.connect(_refresh_if_visible.unbind(2))
	EventBus.character_leveled_up.connect(_refresh_if_visible.unbind(2))
	# Resolver lookups dos slot nodes que ficam no .tscn.
	_build_slot_refs()

func _setup_sort_popup() -> void:
	_sort_dropdown_popup = PopupMenu.new()
	# Theme PT Serif Bold pro popup nao usar font default do sistema.
	if ResourceLoader.exists(DEFAULT_THEME_PATH):
		_sort_dropdown_popup.theme = load(DEFAULT_THEME_PATH)
	for option in SORT_OPTIONS:
		_sort_dropdown_popup.add_item(String(option.label))
	_sort_dropdown_popup.id_pressed.connect(_on_sort_option_selected)
	add_child(_sort_dropdown_popup)

# Confirmacao pra descartar item segurado. Aparece quando user clica no
# backdrop (fora do modal) segurando item nao-favoritado.
func _setup_discard_dialog() -> void:
	_discard_dialog = ConfirmationDialog.new()
	# Theme PT Serif Bold — ConfirmationDialog eh Window, nao herda do Control parent.
	if ResourceLoader.exists(DEFAULT_THEME_PATH):
		_discard_dialog.theme = load(DEFAULT_THEME_PATH)
	_discard_dialog.title = "Descartar item"
	_discard_dialog.dialog_text = "Descartar o item segurado?\nEsta acao nao pode ser desfeita."
	_discard_dialog.ok_button_text = "Descartar"
	_discard_dialog.get_cancel_button().text = "Voltar pra origem"
	_discard_dialog.confirmed.connect(_on_discard_confirmed)
	_discard_dialog.canceled.connect(_on_discard_canceled)
	add_child(_discard_dialog)

func _on_discard_confirmed() -> void:
	DragManager.discard_held()

func _on_discard_canceled() -> void:
	if DragManager.is_holding():
		DragManager.cancel()

func _build_slot_refs() -> void:
	# Equipment slots — lookup por slot_id usando o node name do .tscn.
	_equip_slot_refs.clear()
	for slot_id in EQUIP_SLOT_NODES.keys():
		var node_name: String = EQUIP_SLOT_NODES[slot_id]
		var node = _equip_slots_root.get_node_or_null(node_name)
		if node != null:
			_equip_slot_refs[slot_id] = node
			# Metadata pra drag/drop.
			node.equip_slot_id = slot_id
			node.accept_slot_type = int(SLOT_TYPE_BY_ID.get(slot_id, -1))
			# Icone decorativo do slot vazio (helmet/chest/weapon/etc).
			# Aparece so quando slot esta vazio e nao locked.
			if SLOT_ICON_BY_ID.has(slot_id):
				var icon_path: String = SLOT_ICON_BY_ID[slot_id]
				if ResourceLoader.exists(icon_path):
					node.set_slot_icon(load(icon_path))
	# Inventory slots — todos os children do InventorySlots container, em
	# ordem (Slot0..Slot14). slot_index sera atualizado por pagina em
	# _refresh_inventory_panel.
	_inventory_slot_refs.clear()
	for child in _inventory_slots_root.get_children():
		_inventory_slot_refs.append(child)
	# Artifact slots — sem drag/drop wiring (artifacts ficam no slot fixo).
	_artifact_slot_refs.clear()
	for child in _artifact_slots_root.get_children():
		_artifact_slot_refs.append(child)

func open() -> void:
	_current_view = VIEW_EQUIPMENT
	_current_page = 0
	visible = true
	_refresh()

func close() -> void:
	if not visible:
		return
	# Cancela drag/drop antes de fechar — devolve item pra origem se segurando.
	if DragManager.is_holding():
		DragManager.cancel()
	visible = false
	TooltipManager.hide_tooltip()

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		return
	_refresh_hero_panel(character)
	_refresh_equipment_panel(character)
	_refresh_inventory_panel(character)
	_refresh_attributes_panel(character)
	_refresh_artifacts_panel(character)

# --- Input handlers ------------------------------------------------------

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Click no backdrop com mao segurando:
		#  - Item favoritado -> silent cancel (volta pra origem).
		#  - Item normal -> abre confirmacao de descarte ("jogar no chao").
		# Sem segurar -> fecha o modal.
		if DragManager.is_holding():
			if DragManager.is_held_favorited():
				DragManager.cancel()
			else:
				_discard_dialog.popup_centered()
			return
		close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		# ESC com mao segurando: cancela o drag, mantem modal aberto.
		if DragManager.is_holding():
			DragManager.cancel()
		else:
			close()
		get_viewport().set_input_as_handled()

# === HERO PANEL =========================================================

func _refresh_hero_panel(_active_character: CharacterInstance) -> void:
	if _hero_list_vbox == null:
		return
	for child in _hero_list_vbox.get_children():
		child.queue_free()
	for i in GameState.owned_characters.size():
		var char_inst: CharacterInstance = GameState.owned_characters[i]
		if char_inst == null:
			continue
		var btn: HeroButton = HERO_BUTTON_SCENE.instantiate()
		_hero_list_vbox.add_child(btn)
		btn.hero_selected.connect(_on_hero_pressed)
		btn.setup(char_inst, i == GameState.active_character_index, i)

func _on_hero_pressed(index: int) -> void:
	if index < 0 or index >= GameState.owned_characters.size():
		return
	# Auto-cancel drag — devolve item pro slot original do char atual antes
	# de trocar, pra nao deixar item "perdido" entre personagens.
	if DragManager.is_holding():
		DragManager.cancel()
	GameState.set_active_character(index)

# === EQUIPMENT PANEL ====================================================

func _refresh_equipment_panel(character: CharacterInstance) -> void:
	_name_label.text = character.display_name()
	_level_label.text = "LV. %d" % character.level
	# XpBar usa padrao do footer: max_value = 1.0, value = ratio normalizado.
	var max_xp: int = character.get_xp_to_next_level()
	_exp_bar.max_value = 1.0
	_exp_bar.value = float(character.current_xp) / float(max(1, max_xp))
	_exp_numbers_label.text = NumberFormat.format_pair(character.current_xp, max_xp)
	var s: CombatStats = character.stats
	_hp_value_label.text = NumberFormat.format_int(s.max_hp)
	_mp_value_label.text = NumberFormat.format_int(s.max_mp)
	if character.data != null:
		_char_image.texture = character.data.get_char_image()
	# Slots visibility por view. NAO faz toggle desnecessario — so altera
	# visibility quando o estado desejado difere do atual. Toggle false->true
	# entre frames gera mouse_exited/entered fantasma (causava flicker no
	# tooltip de items equipados durante refresh por signals frequentes).
	var active_slots: Array = EQUIPMENT_VIEW_SLOTS if _current_view == VIEW_EQUIPMENT else TOOLS_VIEW_SLOTS
	for slot_id in _equip_slot_refs.keys():
		var slot: InventorySlotV2 = _equip_slot_refs[slot_id]
		var should_be_visible: bool = active_slots.has(slot_id)
		if slot.visible != should_be_visible:
			slot.visible = should_be_visible
		if not should_be_visible:
			continue
		slot.character = character
		if TOOLS_LOCKED.has(slot_id) or ((slot_id == &"tbd1" or slot_id == &"tbd2") and _current_view == VIEW_EQUIPMENT):
			slot.set_locked()
		else:
			var equipped: ItemData = character.get_equipment(slot_id)
			if equipped == null:
				slot.set_empty()
			else:
				slot.set_item(equipped, 1, character.is_equipment_favorited(slot_id))
	_equipment_toggle_btn.button_pressed = _current_view == VIEW_EQUIPMENT
	_tools_toggle_btn.button_pressed = _current_view == VIEW_TOOLS
	_power_value_label.text = NumberFormat.format_int(_compute_power(s))
	_atk_value_label.text = NumberFormat.format_int(s.atk)
	_def_value_label.text = NumberFormat.format_int(s.def)
	_spd_value_label.text = NumberFormat.format_float(s.attack_speed, 2)
	_luk_value_label.text = NumberFormat.format_int(s.luk)

func _compute_power(s: CombatStats) -> int:
	return int(
		s.max_hp / 10.0
		+ s.atk * 2.0
		+ s.def * 2.0
		+ s.attack_speed * 20.0
		+ s.crit_chance * 100.0
		+ s.luk * 5.0
	)

func _set_view_equipment() -> void:
	_current_view = VIEW_EQUIPMENT
	_refresh_if_visible()

func _set_view_tools() -> void:
	_current_view = VIEW_TOOLS
	_refresh_if_visible()

func _on_details_pressed() -> void:
	EventBus.modal_requested.emit(&"character_details")

func _on_skill_tree_pressed() -> void:
	EventBus.modal_requested.emit(&"skill_tree")

# === INVENTORY PANEL ====================================================

func _refresh_inventory_panel(character: CharacterInstance) -> void:
	var max_unlocked: int = character.max_inventory_slots()
	var total_pages: int = max(1, int(ceil(float(max_unlocked) / float(SLOTS_PER_PAGE))))
	_current_page = clamp(_current_page, 0, total_pages - 1)
	_page_number_label.text = "%d" % (_current_page + 1)
	_prev_page_btn.disabled = _current_page == 0
	_next_page_btn.disabled = _current_page >= total_pages - 1
	for i in SLOTS_PER_PAGE:
		var real_idx: int = _current_page * SLOTS_PER_PAGE + i
		if i >= _inventory_slot_refs.size():
			continue
		var slot: InventorySlotV2 = _inventory_slot_refs[i]
		slot.character = character
		slot.slot_index = real_idx
		# Modo inventory: garantir equip_slot_id vazio.
		slot.equip_slot_id = &""
		if real_idx >= max_unlocked:
			slot.set_locked()
			continue
		var data: Dictionary = character.get_slot(real_idx)
		if data.is_empty():
			slot.set_empty()
		else:
			var item: ItemData = data.get("item", null)
			var qty: int = int(data.get("qty", 0))
			var fav: bool = bool(data.get("favorited", false))
			if item != null and qty > 0:
				slot.set_item(item, qty, fav)
			else:
				slot.set_empty()

func _show_sort_dropdown() -> void:
	if _sort_dropdown_popup == null:
		return
	var btn_global_pos: Vector2 = _sort_dropdown_btn.get_screen_position()
	_sort_dropdown_popup.position = Vector2i(btn_global_pos + Vector2(0, _sort_dropdown_btn.size.y))
	_sort_dropdown_popup.size = Vector2i(207, 0)
	_sort_dropdown_popup.popup()

func _on_sort_option_selected(idx: int) -> void:
	if idx < 0 or idx >= SORT_OPTIONS.size():
		return
	var option: Dictionary = SORT_OPTIONS[idx]
	_current_sort = option.id
	_sort_dropdown_label.text = String(option.label)

func _apply_sort() -> void:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		return
	character.sort_inventory(_current_sort)
	EventBus.character_inventory_changed.emit(character)

func _on_prev_page() -> void:
	_current_page = max(0, _current_page - 1)
	_refresh_if_visible()

func _on_next_page() -> void:
	_current_page += 1
	_refresh_if_visible()

# === ATTRIBUTES PANEL ===================================================

func _refresh_attributes_panel(character: CharacterInstance) -> void:
	var s: CombatStats = character.stats
	_strength_value_label.text = NumberFormat.format_int(s.str_stat)
	_dexterity_value_label.text = NumberFormat.format_int(s.dex)
	_intelligence_value_label.text = NumberFormat.format_int(s.int_stat)
	_vitality_value_label.text = NumberFormat.format_int(s.vit)
	_luck_value_label.text = NumberFormat.format_int(s.luk)
	var has_points: bool = character.unspent_stat_points > 0
	for btn in [_strength_add_btn, _dexterity_add_btn, _intelligence_add_btn, _vitality_add_btn, _luck_add_btn]:
		btn.disabled = not has_points
	_available_points_value_label.text = NumberFormat.format_int(character.unspent_stat_points)

func _on_attr_add(stat_id: StringName) -> void:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		return
	character.spend_stat_point(stat_id)

# === ARTIFACTS PANEL ====================================================

func _refresh_artifacts_panel(character: CharacterInstance) -> void:
	# Artifacts NAO sao movidos pelo player — cada um fica no seu slot fixo.
	# Slots so aparecem quando ha artifact equipado naquele slot. Vazios
	# ficam invisible (sem clutter visual).
	for i in _artifact_slot_refs.size():
		var slot: ArtifactSlot = _artifact_slot_refs[i]
		var art: ItemData = character.get_artifact(i)
		if art == null:
			slot.visible = false
			slot.set_empty()
		else:
			slot.visible = true
			slot.set_artifact(art)
