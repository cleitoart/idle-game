extends PanelContainer

@onready var key_label: Label = $Margin/Row/KeyLabel
@onready var value_label: Label = $Margin/Row/ValueLabel

@export var key_text: String = "ATK"
@export var value_text: String = "0"

func _ready() -> void:
	key_label.text = key_text
	value_label.text = value_text

func set_value(new_value: String) -> void:
	value_text = new_value
	if value_label != null:
		value_label.text = new_value

func set_key(new_key: String) -> void:
	key_text = new_key
	if key_label != null:
		key_label.text = new_key
