extends Control

const VIEW_BATTLE: int = 0
const VIEW_TOWN: int = 1
const VIEW_GATHERING: int = 2

@onready var view_container: Node = $RootHBox/ViewColumn/ViewContainer
@onready var right_panel: Control = $RootHBox/RightPanel
@onready var footer: Control = $RootHBox/ViewColumn/Footer
@onready var battle_view: Control = $RootHBox/ViewColumn/ViewContainer/BattleView
@onready var town_view: Control = $RootHBox/ViewColumn/ViewContainer/TownView
@onready var gathering_view: Control = $RootHBox/ViewColumn/ViewContainer/GatheringView

var _config: Dictionary = {}

func _ready() -> void:
	_config = {
		VIEW_BATTLE:    { "node": battle_view,    "right": true,  "footer": true  },
		VIEW_TOWN:      { "node": town_view,      "right": false, "footer": false },
		VIEW_GATHERING: { "node": gathering_view, "right": false, "footer": false },
	}
	EventBus.view_requested.connect(_set_view)
	_set_view(VIEW_BATTLE)

func _set_view(view_id: int) -> void:
	if not _config.has(view_id):
		return
	for id in _config.keys():
		var node: Control = _config[id]["node"]
		var active: bool = id == view_id
		node.visible = active
		node.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
	right_panel.visible = _config[view_id]["right"]
	footer.visible = _config[view_id]["footer"]
