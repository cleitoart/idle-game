extends Control

# Modal de Skill Tree (Fase 01 / Bloco B - placeholder textual).
# 3 colunas (Berserker / Defender / Tactician) com lista vertical de nos.
# Cada no mostra nome + desc + status (locked/unlocked/can-unlock) + botao.

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Center/Panel
@onready var close_btn: Button = $Center/Panel/Margin/Box/Header/CloseButton
@onready var points_label: Label = $Center/Panel/Margin/Box/Header/PointsLabel

@onready var berserker_list: VBoxContainer = $Center/Panel/Margin/Box/Branches/BerserkerCol/BerserkerScroll/BerserkerList
@onready var defender_list: VBoxContainer = $Center/Panel/Margin/Box/Branches/DefenderCol/DefenderScroll/DefenderList
@onready var tactician_list: VBoxContainer = $Center/Panel/Margin/Box/Branches/TacticianCol/TacticianScroll/TacticianList

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	close_btn.pressed.connect(close)
	backdrop.gui_input.connect(_on_backdrop_input)
	EventBus.character_stats_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.character_leveled_up.connect(_refresh_if_visible.unbind(2))
	EventBus.active_character_changed.connect(_refresh_if_visible.unbind(1))

func open() -> void:
	visible = true
	Juicy.modal_appear(self, panel)
	_refresh()

func close() -> void:
	if not visible:
		return
	var t: Tween = Juicy.modal_disappear(self, panel)
	if t != null:
		t.finished.connect(func(): visible = false)
	else:
		visible = false

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		points_label.text = "Skill Points: -"
		return
	points_label.text = "Skill Points: %d" % character.skill_points_unspent
	_populate_branch(berserker_list, "berserker", character)
	_populate_branch(defender_list, "defender", character)
	_populate_branch(tactician_list, "tactician", character)

func _populate_branch(list: VBoxContainer, branch: String, character: CharacterInstance) -> void:
	for child in list.get_children():
		child.queue_free()
	for node in SkillTree.get_nodes_by_branch(branch):
		list.add_child(_build_node_row(node, character))

func _build_node_row(node: Dictionary, character: CharacterInstance) -> Control:
	var node_id: StringName = StringName(String(node["id"]))
	var is_unlocked: bool = character.unlocked_skill_nodes.has(node_id)
	var can_unlock: bool = SkillTree.can_unlock(character, node_id)
	var prereq_met: bool = true
	var prereq: String = String(node.get("prereq", ""))
	if prereq != "":
		prereq_met = character.unlocked_skill_nodes.has(StringName(prereq))
	# Container
	var row := PanelContainer.new()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 4)
	row.add_child(margin)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	margin.add_child(vbox)
	# Nome (com cor por status)
	var name_label := Label.new()
	name_label.text = String(node["name"])
	name_label.add_theme_font_size_override("font_size", 13)
	if is_unlocked:
		name_label.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
	elif not prereq_met:
		name_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	vbox.add_child(name_label)
	# Descricao
	var desc_label := Label.new()
	desc_label.text = String(node["desc"])
	desc_label.add_theme_font_size_override("font_size", 11)
	desc_label.modulate.a = 0.8
	vbox.add_child(desc_label)
	# Status / botao
	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 8)
	vbox.add_child(status_row)
	var status_label := Label.new()
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.add_theme_font_size_override("font_size", 11)
	if is_unlocked:
		status_label.text = "Desbloqueado"
		status_label.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
	elif not prereq_met:
		var pre_node: Dictionary = SkillTree.get_node(StringName(prereq))
		var pre_name: String = String(pre_node.get("name", prereq))
		status_label.text = "Bloqueado: requer %s" % pre_name
		status_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	elif character.skill_points_unspent <= 0:
		status_label.text = "Sem pontos"
		status_label.add_theme_color_override("font_color", Color(0.85, 0.55, 0.55))
	else:
		status_label.text = "Disponivel"
		status_label.add_theme_color_override("font_color", Color(0.85, 0.66, 0.22))
	status_row.add_child(status_label)
	if not is_unlocked:
		var btn := Button.new()
		btn.text = "Unlock"
		btn.disabled = not can_unlock
		btn.custom_minimum_size = Vector2(72, 28)
		btn.pressed.connect(func(): _on_unlock_pressed(node_id))
		status_row.add_child(btn)
	return row

func _on_unlock_pressed(node_id: StringName) -> void:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		return
	if SkillTree.unlock(character, node_id):
		_refresh()

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()
		get_viewport().set_input_as_handled()
