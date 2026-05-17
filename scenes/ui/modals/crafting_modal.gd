extends Control

# Modal unificado de Crafting (Fase 01 / Bloco B+).
# Sub-divide em abas (Smithing/Smelting/Cooking/Alchemy). Cooking e Alchemy
# ficam disabled ate suas receitas existirem. Substituiu os antigos
# `smithing_modal.tscn` e `smelting_modal.tscn` separados.

const TAB_SMITHING: StringName = &"smithing"
const TAB_SMELTING: StringName = &"smelting"
const TAB_COOKING: StringName = &"cooking"
const TAB_ALCHEMY: StringName = &"alchemy"

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Center/Panel
@onready var title_label: Label = $Center/Panel/Margin/Box/Header/TitleLabel
@onready var close_btn: Button = $Center/Panel/Margin/Box/Header/CloseButton
@onready var tab_smithing: Button = $Center/Panel/Margin/Box/Tabs/TabSmithing
@onready var tab_smelting: Button = $Center/Panel/Margin/Box/Tabs/TabSmelting
@onready var tab_cooking: Button = $Center/Panel/Margin/Box/Tabs/TabCooking
@onready var tab_alchemy: Button = $Center/Panel/Margin/Box/Tabs/TabAlchemy
@onready var recipe_list: VBoxContainer = $Center/Panel/Margin/Box/Scroll/RecipeList

var _current_tab: StringName = TAB_SMITHING

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	close_btn.pressed.connect(close)
	backdrop.gui_input.connect(_on_backdrop_input)
	EventBus.character_inventory_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.active_character_changed.connect(_refresh_if_visible.unbind(1))
	tab_smithing.pressed.connect(func(): _set_tab(TAB_SMITHING))
	tab_smelting.pressed.connect(func(): _set_tab(TAB_SMELTING))
	tab_cooking.pressed.connect(func(): _set_tab(TAB_COOKING))
	tab_alchemy.pressed.connect(func(): _set_tab(TAB_ALCHEMY))

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

func _set_tab(tab: StringName) -> void:
	_current_tab = tab
	tab_smithing.button_pressed = (tab == TAB_SMITHING)
	tab_smelting.button_pressed = (tab == TAB_SMELTING)
	tab_cooking.button_pressed = (tab == TAB_COOKING)
	tab_alchemy.button_pressed = (tab == TAB_ALCHEMY)
	_refresh()

func _refresh() -> void:
	for child in recipe_list.get_children():
		child.queue_free()
	var recipes: Array = _get_recipes_for_tab()
	if recipes.is_empty():
		var empty := Label.new()
		empty.text = "Nenhuma receita disponivel nesta categoria."
		empty.modulate.a = 0.5
		recipe_list.add_child(empty)
		return
	for recipe in recipes:
		recipe_list.add_child(_build_recipe_row(recipe))

func _get_recipes_for_tab() -> Array:
	match _current_tab:
		TAB_SMITHING:
			return Crafting.RECIPES_SMITHING
		TAB_SMELTING:
			return Crafting.RECIPES_SMELTING
		TAB_COOKING:
			return []  # placeholder ate Fase 02
		TAB_ALCHEMY:
			return []  # placeholder ate Fase 02
		_:
			return []

func _build_recipe_row(recipe: Dictionary) -> Control:
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
	# Coluna esquerda: nome + receita
	var info_box := VBoxContainer.new()
	info_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_box.add_theme_constant_override("separation", 2)
	hbox.add_child(info_box)
	var name_label := Label.new()
	name_label.text = String(recipe.get("name", "?"))
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.add_theme_color_override("font_color", Color(0.85, 0.66, 0.22))
	info_box.add_child(name_label)
	var inputs_label := Label.new()
	inputs_label.text = "Inputs: %s" % Crafting.describe_inputs(recipe)
	inputs_label.add_theme_font_size_override("font_size", 13)
	info_box.add_child(inputs_label)
	var output_label := Label.new()
	output_label.text = "Output: %s" % Crafting.describe_output(recipe)
	output_label.add_theme_font_size_override("font_size", 13)
	output_label.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
	info_box.add_child(output_label)
	# Botao Craft
	var craft_btn := Button.new()
	craft_btn.text = "Craft"
	craft_btn.custom_minimum_size = Vector2(96, 56)
	craft_btn.disabled = not Crafting.can_craft(recipe)
	craft_btn.pressed.connect(func(): _on_craft_pressed(recipe))
	hbox.add_child(craft_btn)
	return row

func _on_craft_pressed(recipe: Dictionary) -> void:
	if Crafting.craft(recipe):
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
