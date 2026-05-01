extends Button

signal picked(index: int)

@onready var portrait: ColorRect = $Layout/Portrait
@onready var name_label: Label = $Layout/Info/NameLabel
@onready var level_label: Label = $Layout/Info/LevelLabel

var _index: int = -1

func bind(index: int, character: CharacterInstance, is_active: bool) -> void:
	_index = index
	if character == null:
		name_label.text = "Empty"
		level_label.text = ""
		portrait.color = Color(0.3, 0.3, 0.3, 1)
		disabled = true
		return
	disabled = false
	name_label.text = character.display_name()
	level_label.text = "Lv. %d" % character.level
	if character.data != null:
		portrait.color = character.data.portrait_color
	button_pressed = is_active

func _ready() -> void:
	pressed.connect(_on_pressed)
	toggle_mode = true

func _on_pressed() -> void:
	if _index >= 0:
		picked.emit(_index)
