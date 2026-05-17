extends PanelContainer

@onready var character_button: Button = $Margin/Box/Modals/CharacterButton
@onready var map_button: Button = $Margin/Box/Modals/MapButton
@onready var speed_toggle: Button = $Margin/Box/SpeedRow/SpeedToggle

# Fase B+: InventoryButton e CharSelectButton foram REMOVIDOS — sua
# funcionalidade foi absorvida pelo character_modal redesenhado (com 5
# paineis incluindo Hero list + Inventory grid).

func _ready() -> void:
	character_button.pressed.connect(func(): EventBus.modal_requested.emit(&"character"))
	map_button.pressed.connect(func(): EventBus.modal_requested.emit(&"map"))
	# Game speed (Fase 01 / B2) — toggle 1x/2x. 4x e 8x sao unlocks futuros.
	speed_toggle.pressed.connect(_on_speed_toggle_pressed)
	EventBus.game_speed_changed.connect(_refresh_speed_label.unbind(1))
	_refresh_speed_label()

func _on_speed_toggle_pressed() -> void:
	var current: int = GameState.get_game_speed()
	var next_speed: int = 2 if current == 1 else 1
	GameState.set_game_speed(next_speed)

func _refresh_speed_label() -> void:
	speed_toggle.text = "%dx" % GameState.get_game_speed()
