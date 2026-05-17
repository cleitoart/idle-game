extends Control

# Tiny launcher: a single Dev button on the BattleView. Pressing it opens the
# DevModal which holds the actual cheats / wave-spawn options.

@onready var open_btn: Button = $OpenBtn

func _ready() -> void:
	open_btn.pressed.connect(_on_open_pressed)

func _on_open_pressed() -> void:
	EventBus.modal_requested.emit(&"dev")
