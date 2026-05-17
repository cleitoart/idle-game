extends PanelContainer

# View IDs are also referenced from main.gd. Keep both in sync.
# VIEW_TOWN and VIEW_GATHERING are kept in main.gd's view config for now —
# Town is reserved for the future "Settlement → Town → Kingdom" evolution
# and Gathering is being absorbed into map spots in Exploring. The buttons
# are removed from this side menu but the view IDs stay defined.
const VIEW_EXPLORATION: int = 0
const VIEW_TOWN: int = 1
const VIEW_GATHERING: int = 2
const VIEW_QUESTS: int = 3
const VIEW_CODEX: int = 4
const VIEW_SETTLEMENT: int = 5
const VIEW_SETTINGS: int = 6
const VIEW_HELP: int = 7

@onready var exploration_button: Button = $Margin/Box/TopButtons/ExplorationButton
@onready var quests_button: Button = $Margin/Box/TopButtons/QuestsButton
@onready var codex_button: Button = $Margin/Box/TopButtons/CodexButton
@onready var settlement_button: Button = $Margin/Box/TopButtons/SettlementButton
@onready var settings_button: Button = $Margin/Box/BottomButtons/SettingsButton
@onready var help_button: Button = $Margin/Box/BottomButtons/HelpButton

func _ready() -> void:
	var bindings: Array = [
		[exploration_button, VIEW_EXPLORATION],
		[quests_button, VIEW_QUESTS],
		[codex_button, VIEW_CODEX],
		[settlement_button, VIEW_SETTLEMENT],
		[settings_button, VIEW_SETTINGS],
		[help_button, VIEW_HELP],
	]
	for entry in bindings:
		var button: Button = entry[0]
		var view_id: int = entry[1]
		button.pressed.connect(func(): EventBus.view_requested.emit(view_id))
