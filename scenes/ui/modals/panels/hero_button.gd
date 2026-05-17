class_name HeroButton
extends TextureButton

# HeroButton — botao individual de heroi no Hero panel.
#
# Visualmente: 242x91 com class_icon + name + divider + class + level. Todos
# os elementos sao declarados no .tscn (estatico) e este script so popula os
# Labels via `setup()`. Toggle_mode: o heroi selecionado fica em pressed.

signal hero_selected(index: int)

@onready var class_icon: TextureRect = $ClassIcon
@onready var char_name_label: Label = $CharNameLabel
@onready var divider: TextureRect = $Divider
@onready var char_class_label: Label = $CharClassLabel
@onready var char_level_label: Label = $CharLevelLabel

var _hero_index: int = -1

func _ready() -> void:
	pressed.connect(_on_pressed)

# Popula o botao com os dados de um CharacterInstance.
func setup(char_inst: CharacterInstance, is_active: bool, index: int) -> void:
	_hero_index = index
	button_pressed = is_active
	if not is_inside_tree():
		await ready
	char_name_label.text = char_inst.display_name()
	var class_text: String = ""
	if char_inst.data != null and char_inst.data.get("class_label") != null:
		class_text = String(char_inst.data.get("class_label"))
	if class_text != "":
		char_class_label.text = class_text
		char_class_label.visible = true
		divider.visible = true
	else:
		# Sem class label — esconde a linha de classe e o divider.
		char_class_label.visible = false
		divider.visible = false
	char_level_label.text = "LV. %d" % char_inst.level

func _on_pressed() -> void:
	hero_selected.emit(_hero_index)
