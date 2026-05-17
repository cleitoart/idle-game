extends Control

# Modal de boas-vindas offline (Fase 0).
# Aberto pelo `main.gd` quando `EventBus.offline_progress_calculated` dispara
# com `delta_t_seconds >= 60`. Mostra resumo dos ganhos e aplica via
# "Coletar tudo".

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Center/Panel
@onready var duration_label: Label = $Center/Panel/Margin/Box/DurationLabel
@onready var char_list: VBoxContainer = $Center/Panel/Margin/Box/Scroll/CharList
@onready var collect_btn: Button = $Center/Panel/Margin/Box/ButtonRow/CollectBtn

var _summary: Dictionary = {}

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	collect_btn.pressed.connect(_on_collect_pressed)
	backdrop.gui_input.connect(_on_backdrop_input)

func open_with_summary(summary: Dictionary) -> void:
	_summary = summary
	_render_summary()
	visible = true
	Juicy.modal_appear(self, panel)

func close() -> void:
	if not visible:
		return
	var t: Tween = Juicy.modal_disappear(self, panel)
	if t != null:
		t.finished.connect(func(): visible = false)
	else:
		visible = false

# --- Render ---------------------------------------------------------------

func _render_summary() -> void:
	var delta_t: int = int(_summary.get("delta_t_seconds", 0))
	var capped: bool = bool(_summary.get("capped", false))
	duration_label.text = _format_duration(delta_t, capped)
	# Limpar lista de personagens.
	for child in char_list.get_children():
		child.queue_free()
	var characters: Array = _summary.get("characters", [])
	if characters.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Sem ganhos para coletar."
		char_list.add_child(empty_label)
		return
	for char_summary in characters:
		_add_character_block(char_summary)

func _add_character_block(char_summary: Dictionary) -> void:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	# Nome do personagem (resolve display_name pelo data_id, fallback no proprio id).
	var data_id: String = String(char_summary.get("data_id", "?"))
	var display_name: String = _resolve_display_name(data_id)
	var name_label := Label.new()
	name_label.text = "%s" % display_name
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.modulate = Color(0.85, 0.66, 0.22)
	box.add_child(name_label)
	# XP / Gold / Kills
	var xp: int = int(char_summary.get("xp_gained", 0))
	var gold: int = int(char_summary.get("gold_gained", 0))
	var kills: int = int(char_summary.get("kills", 0))
	var stats_label := Label.new()
	stats_label.text = "  +%d XP    +%d Gold    %d kills" % [xp, gold, kills]
	stats_label.add_theme_font_size_override("font_size", 14)
	box.add_child(stats_label)
	# Materiais
	var materials: Dictionary = char_summary.get("materials", {})
	if not materials.is_empty():
		var mat_lines: Array = []
		for item_id in materials.keys():
			mat_lines.append("+%d %s" % [int(materials[item_id]), _resolve_item_display_name(String(item_id))])
		var mat_label := Label.new()
		mat_label.text = "  " + ", ".join(mat_lines)
		mat_label.add_theme_font_size_override("font_size", 14)
		mat_label.modulate = Color(0.6, 0.85, 0.6)
		box.add_child(mat_label)
	char_list.add_child(box)

func _format_duration(seconds: int, capped: bool) -> String:
	var hours: int = seconds / 3600
	var minutes: int = (seconds % 3600) / 60
	var base: String
	if hours > 0:
		base = "%dh %dmin" % [hours, minutes]
	else:
		base = "%dmin" % minutes
	if capped:
		base += " (capped 12h)"
	return "Voce ficou offline por: %s" % base

# --- Coletar -------------------------------------------------------------

func _on_collect_pressed() -> void:
	var characters: Array = _summary.get("characters", [])
	for char_summary in characters:
		_apply_to_character(char_summary)
	close()

func _apply_to_character(char_summary: Dictionary) -> void:
	var data_id: String = String(char_summary.get("data_id", ""))
	var character: CharacterInstance = GameState.get_character_by_id(StringName(data_id))
	if character == null:
		# Fallback: aplicar no active character.
		character = GameState.get_active_character()
	if character == null:
		return
	# Gold e' por conta — vai pro pool global.
	var gold: int = int(char_summary.get("gold_gained", 0))
	if gold > 0:
		GameState.add_gold(gold)
	# XP e' por personagem (faz level-ups internos).
	var xp: int = int(char_summary.get("xp_gained", 0))
	if xp > 0:
		GameState.add_xp_to_character(character, xp)
	# Drops viram items no inventario do personagem.
	var materials: Dictionary = char_summary.get("materials", {})
	for item_id_str in materials.keys():
		var qty: int = int(materials[item_id_str])
		if qty <= 0:
			continue
		var item: ItemData = _resolve_item_by_id(String(item_id_str))
		if item != null:
			GameState.add_item_to_character(character, item, qty)

# --- Helpers de resolucao ------------------------------------------------

func _resolve_display_name(data_id: String) -> String:
	if data_id == "":
		return "Personagem"
	var path: String = "res://data/characters/%s.tres" % data_id
	if not ResourceLoader.exists(path):
		return data_id
	var data: CharacterData = load(path)
	if data == null:
		return data_id
	return data.display_name

func _resolve_item_display_name(id: String) -> String:
	var item: ItemData = _resolve_item_by_id(id)
	if item == null:
		return id
	return item.display_name

func _resolve_item_by_id(id: String) -> ItemData:
	if id == "":
		return null
	return ItemRegistry.get_by_id(StringName(id))

# --- Input ---------------------------------------------------------------

func _on_backdrop_input(event: InputEvent) -> void:
	# Fechar clicando fora do panel descarta os ganhos sem coletar.
	# Considerar pedir confirmacao em fase posterior.
	if event is InputEventMouseButton and event.pressed:
		close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()
		get_viewport().set_input_as_handled()
