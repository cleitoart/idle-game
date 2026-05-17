extends Control

# View IDs match SideMenu's constants. Keep both in sync.
const VIEW_EXPLORATION: int = 0
const VIEW_TOWN: int = 1
const VIEW_GATHERING: int = 2
const VIEW_QUESTS: int = 3
const VIEW_CODEX: int = 4
const VIEW_SETTLEMENT: int = 5
const VIEW_SETTINGS: int = 6
const VIEW_HELP: int = 7

@onready var view_container: Node = $RootHBox/ViewColumn/ViewContainer
@onready var right_panel: Control = $RootHBox/RightPanel
@onready var footer: Control = $RootHBox/ViewColumn/Footer
@onready var exploration_view: Control = $RootHBox/ViewColumn/ViewContainer/ExplorationView
@onready var town_view: Control = $RootHBox/ViewColumn/ViewContainer/TownView
@onready var gathering_view: Control = $RootHBox/ViewColumn/ViewContainer/GatheringView
@onready var quests_view: Control = $RootHBox/ViewColumn/ViewContainer/QuestsView
@onready var codex_view: Control = $RootHBox/ViewColumn/ViewContainer/CodexView
@onready var settlement_view: Control = $RootHBox/ViewColumn/ViewContainer/SettlementView
@onready var settings_view: Control = $RootHBox/ViewColumn/ViewContainer/SettingsView
@onready var help_view: Control = $RootHBox/ViewColumn/ViewContainer/HelpView

var _config: Dictionary = {}

func _ready() -> void:
	# `right` controls RightPanel visibility, `footer` controls Footer visibility.
	# Only Exploration shows the combat HUD chrome.
	_config = {
		VIEW_EXPLORATION: { "node": exploration_view, "right": false,  "footer": true  },
		VIEW_TOWN:        { "node": town_view,       "right": false, "footer": false },
		VIEW_GATHERING:   { "node": gathering_view,  "right": false, "footer": false },
		VIEW_QUESTS:      { "node": quests_view,     "right": false, "footer": false },
		VIEW_CODEX:       { "node": codex_view,      "right": false, "footer": false },
		VIEW_SETTLEMENT:  { "node": settlement_view, "right": false, "footer": false },
		VIEW_SETTINGS:    { "node": settings_view,   "right": false, "footer": false },
		VIEW_HELP:        { "node": help_view,       "right": false, "footer": false },
	}
	# Sidebars desativadas no prototype AQW por decisao do usuario — so o
	# Footer fica visivel na Exploration. SideMenu e RightPanel ocultos.
	$RootHBox/SideMenu.visible = false
	right_panel.visible = false
	EventBus.view_requested.connect(_set_view)
	_set_view(VIEW_EXPLORATION)
	# Tratamento explicito de fechamento da janela: salvar antes de quit.
	get_tree().set_auto_accept_quit(false)
	# Verificar progressao offline em frame deferred — assegura que o
	# ModalLayer ja conectou em `EventBus.offline_progress_calculated` antes
	# do dispatch (ordem de _ready entre autoloads e cenas).
	call_deferred("_check_offline_progress")

func _check_offline_progress() -> void:
	var save_dict: Dictionary = SaveManager.get_last_loaded_save()
	if save_dict.is_empty():
		return
	var summary: Dictionary = OfflineSimulator.simulate(
		save_dict,
		int(Time.get_unix_time_from_system())
	)
	if int(summary.get("delta_t_seconds", 0)) < 60:
		return
	EventBus.offline_progress_calculated.emit(summary)

# Intercepta o fechamento da janela (botao X / alt+F4) para salvar antes de
# encerrar. NOTIFICATION_WM_CLOSE_REQUEST so e' entregue se
# `set_auto_accept_quit(false)` foi chamado primeiro.
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveManager.save_game()
		get_tree().quit()

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
