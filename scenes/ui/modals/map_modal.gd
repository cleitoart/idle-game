extends ModalBase

# Map modal — agora com 2 abas: Exploration (zona/area pra fast-travel via
# `EventBus.area_change_requested`) e Gathering (lista de spots).
# Refactor da Fase Exploration AQW: stages foram removidos; cada area carrega
# uma scene world e o player navega via portais. Map serve so como atalho.

const TAB_EXPLORATION: StringName = &"exploration"
const TAB_GATHERING: StringName = &"gathering"
const SPOTS_DIR: String = "res://data/gathering/"
const AREAS_DIR: String = "res://data/areas/"

@onready var tab_combat_btn: Button = $Center/Panel/Margin/Box/Content/Tabs/TabCombat
@onready var tab_gathering_btn: Button = $Center/Panel/Margin/Box/Content/Tabs/TabGathering
@onready var combat_pane: VBoxContainer = $Center/Panel/Margin/Box/Content/CombatPane
@onready var gathering_pane: VBoxContainer = $Center/Panel/Margin/Box/Content/GatheringPane
@onready var zones_row: HBoxContainer = $Center/Panel/Margin/Box/Content/CombatPane/ZonesRow
@onready var areas_box: VBoxContainer = $Center/Panel/Margin/Box/Content/CombatPane/AreasScroll/AreasBox
@onready var spots_list: VBoxContainer = $Center/Panel/Margin/Box/Content/GatheringPane/GatheringScroll/SpotsList

var _active_tab: StringName = TAB_EXPLORATION
var _all_spots_cache: Array = []
var _all_areas_cache: Array = []

func _ready() -> void:
	title_text = "Map"
	super._ready()
	EventBus.active_character_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.area_loaded.connect(_refresh_if_visible.unbind(1))
	tab_combat_btn.text = "Exploration"
	tab_combat_btn.pressed.connect(func(): _set_tab(TAB_EXPLORATION))
	tab_gathering_btn.pressed.connect(func(): _set_tab(TAB_GATHERING))

func _on_open() -> void:
	_refresh()

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _set_tab(tab: StringName) -> void:
	_active_tab = tab
	tab_combat_btn.button_pressed = (tab == TAB_EXPLORATION)
	tab_gathering_btn.button_pressed = (tab == TAB_GATHERING)
	combat_pane.visible = (tab == TAB_EXPLORATION)
	gathering_pane.visible = (tab == TAB_GATHERING)
	_refresh()

func _refresh() -> void:
	if _active_tab == TAB_EXPLORATION:
		_refresh_exploration_tab()
	else:
		_refresh_gathering_tab()

# --- Exploration tab ----------------------------------------------------

func _refresh_exploration_tab() -> void:
	_clear_children(zones_row)
	_clear_children(areas_box)
	zones_row.visible = false
	if _all_areas_cache.is_empty():
		_all_areas_cache = _load_all_areas()
	if _all_areas_cache.is_empty():
		var empty := Label.new()
		empty.text = "Nenhuma area disponivel."
		empty.modulate.a = 0.5
		areas_box.add_child(empty)
		return
	for area in _all_areas_cache:
		areas_box.add_child(_build_area_row(area))

func _build_area_row(area: AreaSceneData) -> Control:
	var row := PanelContainer.new()
	row.custom_minimum_size = Vector2(0, 56)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 8)
	row.add_child(margin)
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	margin.add_child(hbox)
	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(info)
	var title := Label.new()
	title.text = area.display_name
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.85, 0.66, 0.22))
	info.add_child(title)
	var btn := Button.new()
	btn.text = "Viajar"
	btn.custom_minimum_size = Vector2(96, 40)
	var captured_id := area.id
	btn.pressed.connect(func(): _on_area_pressed(captured_id))
	hbox.add_child(btn)
	return row

func _on_area_pressed(area_id: StringName) -> void:
	EventBus.area_change_requested.emit(area_id)
	close()

# --- Gathering tab ------------------------------------------------------

func _refresh_gathering_tab() -> void:
	_clear_children(spots_list)
	if _all_spots_cache.is_empty():
		_all_spots_cache = _load_all_spots()
	if _all_spots_cache.is_empty():
		var empty := Label.new()
		empty.text = "Nenhum spot de coleta disponivel."
		empty.modulate.a = 0.5
		spots_list.add_child(empty)
		return
	for spot in _all_spots_cache:
		spots_list.add_child(_build_spot_row(spot))

func _build_spot_row(spot: GatheringSpotData) -> Control:
	var character := GameState.get_active_character()
	var row := PanelContainer.new()
	row.custom_minimum_size = Vector2(0, 80)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 8)
	row.add_child(margin)
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	margin.add_child(hbox)
	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 2)
	hbox.add_child(info)
	var title := Label.new()
	title.text = "%s  (Lv. %d)" % [spot.display_name, spot.level]
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.85, 0.66, 0.22))
	info.add_child(title)
	var desc := Label.new()
	desc.text = spot.description
	desc.add_theme_font_size_override("font_size", 12)
	desc.modulate.a = 0.85
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_child(desc)
	if character != null and not spot.targets.is_empty():
		var first_target: GatherTargetData = spot.targets[0]
		if first_target != null:
			var eff: int = Efficiency.compute(character, spot.activity)
			var line := Label.new()
			line.text = "Eff: %d / %d  -  Drop: %s" % [
				eff, first_target.eff_req, Efficiency.describe_chance(eff, first_target.eff_req)
			]
			line.add_theme_font_size_override("font_size", 12)
			line.add_theme_color_override("font_color", Color(0.7, 0.85, 0.7))
			info.add_child(line)
	var enter_btn := Button.new()
	enter_btn.text = "Entrar"
	enter_btn.custom_minimum_size = Vector2(96, 56)
	enter_btn.pressed.connect(func(): _on_spot_pressed(spot))
	hbox.add_child(enter_btn)
	return row

func _on_spot_pressed(spot: GatheringSpotData) -> void:
	if spot == null:
		return
	EventBus.gathering_spot_requested.emit(spot)
	close()

func _load_all_areas() -> Array:
	var out: Array = []
	var dir := DirAccess.open(AREAS_DIR)
	if dir == null:
		return out
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".tres"):
			var path: String = AREAS_DIR + fname
			var data = load(path)
			if data is AreaSceneData:
				out.append(data)
		fname = dir.get_next()
	dir.list_dir_end()
	out.sort_custom(func(a, b): return String(a.display_name) < String(b.display_name))
	return out

func _load_all_spots() -> Array:
	var out: Array = []
	var dir := DirAccess.open(SPOTS_DIR)
	if dir == null:
		return out
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with("_spot.tres"):
			var path: String = SPOTS_DIR + fname
			var data: GatheringSpotData = load(path) as GatheringSpotData
			if data != null:
				out.append(data)
		fname = dir.get_next()
	dir.list_dir_end()
	return out

func _clear_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
