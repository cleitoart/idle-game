extends PanelContainer

const VIEW_BATTLE: int = 0
const VIEW_TOWN: int = 1
const VIEW_GATHERING: int = 2

@onready var battle_button: Button = $Margin/Buttons/BattleButton
@onready var town_button: Button = $Margin/Buttons/TownButton
@onready var gathering_button: Button = $Margin/Buttons/GatheringButton

func _ready() -> void:
	battle_button.pressed.connect(func(): EventBus.view_requested.emit(VIEW_BATTLE))
	town_button.pressed.connect(func(): EventBus.view_requested.emit(VIEW_TOWN))
	gathering_button.pressed.connect(func(): EventBus.view_requested.emit(VIEW_GATHERING))
