extends PanelContainer

@onready var character_button: Button = $Margin/Box/Modals/CharacterButton
@onready var map_button: Button = $Margin/Box/Modals/MapButton
@onready var inventory_button: Button = $Margin/Box/Modals/InventoryButton
@onready var stats_button: Button = $Margin/Box/FooterModes/StatsButton
@onready var party_button: Button = $Margin/Box/FooterModes/PartyButton

func _ready() -> void:
	character_button.pressed.connect(func(): EventBus.modal_requested.emit(&"character"))
	map_button.pressed.connect(func(): EventBus.modal_requested.emit(&"map"))
	inventory_button.pressed.connect(func(): EventBus.modal_requested.emit(&"inventory"))
	stats_button.pressed.connect(_select_stats)
	party_button.pressed.connect(_select_party)
	_set_footer_mode(&"stats")

func _select_stats() -> void:
	_set_footer_mode(&"stats")

func _select_party() -> void:
	_set_footer_mode(&"character_select")

func _set_footer_mode(mode_id: StringName) -> void:
	stats_button.button_pressed = mode_id == &"stats"
	party_button.button_pressed = mode_id == &"character_select"
	EventBus.footer_mode_requested.emit(mode_id)
