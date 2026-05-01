extends PanelContainer

const MODE_STATS: StringName = &"stats"
const MODE_CHARACTER_SELECT: StringName = &"character_select"

@onready var stats_view: Control = $Modes/FooterStats
@onready var char_select_view: Control = $Modes/FooterCharacterSelect

var _current_mode: StringName = MODE_STATS

func _ready() -> void:
	EventBus.footer_mode_requested.connect(_on_mode_requested)
	_apply_mode(MODE_STATS)

func _on_mode_requested(mode_id: StringName) -> void:
	_apply_mode(mode_id)

func _apply_mode(mode_id: StringName) -> void:
	if mode_id != MODE_STATS and mode_id != MODE_CHARACTER_SELECT:
		return
	_current_mode = mode_id
	stats_view.visible = mode_id == MODE_STATS
	char_select_view.visible = mode_id == MODE_CHARACTER_SELECT
