extends Control

const PANEL_HEIGHT: float = 220.0
const SLIDE_DURATION: float = 0.22
const MAX_VISIBLE_HINT: int = 7  # we let ScrollContainer show ~7 lines via its size

# Per-kind text colors so kills/xp/dmg are easy to skim.
const KIND_COLORS: Dictionary = {
	&"generic": Color(0.92, 0.92, 0.86, 1.0),
	&"damage_dealt": Color(0.95, 0.95, 0.95, 1.0),
	&"damage_received": Color(0.95, 0.55, 0.55, 1.0),
	&"kill": Color(0.95, 0.85, 0.40, 1.0),
	&"xp": Color(0.55, 0.85, 1.00, 1.0),
	&"gold": Color(0.95, 0.82, 0.45, 1.0),
	&"skill": Color(0.78, 0.65, 0.95, 1.0),
	&"level_up": Color(0.55, 0.95, 0.55, 1.0),
	&"wave": Color(0.85, 0.85, 1.00, 1.0),
}

@onready var panel: Control = $Panel
@onready var backdrop: ColorRect = $Backdrop
@onready var scroll: ScrollContainer = $Panel/Margin/Scroll
@onready var message_list: VBoxContainer = $Panel/Margin/Scroll/MessageList

var _open: bool = false
var _slide_tween: Tween
var _closed_y: float = 0.0
var _open_y: float = 0.0
var _layout_ready: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.visible = false
	backdrop.gui_input.connect(_on_backdrop_input)
	EventBus.battle_log_added.connect(_on_log_added)
	EventBus.battle_log_cleared.connect(_on_log_cleared)
	EventBus.battle_log_toggle_requested.connect(_toggle)
	resized.connect(_recompute_layout)
	_recompute_layout()
	# Start collapsed below the viewport.
	panel.position.y = _closed_y

func _recompute_layout() -> void:
	# Anchor the panel to the bottom of the parent control. _closed_y puts the
	# panel fully off-screen; _open_y reveals PANEL_HEIGHT pixels.
	var parent_size: Vector2 = size
	if parent_size.y <= 0.0:
		parent_size = get_viewport_rect().size
	panel.size = Vector2(parent_size.x, PANEL_HEIGHT)
	panel.position.x = 0.0
	_closed_y = parent_size.y
	_open_y = parent_size.y - PANEL_HEIGHT
	if not _open:
		panel.position.y = _closed_y
	else:
		panel.position.y = _open_y
	_layout_ready = true

func _toggle() -> void:
	if _open:
		_close()
	else:
		_open_panel()

func _open_panel() -> void:
	if _open:
		return
	_open = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.visible = true
	_rebuild_messages()
	if _slide_tween != null and _slide_tween.is_valid():
		_slide_tween.kill()
	_slide_tween = create_tween()
	_slide_tween.tween_property(panel, "position:y", _open_y, SLIDE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_slide_tween.tween_callback(_scroll_to_bottom)

func _close() -> void:
	if not _open:
		return
	_open = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if _slide_tween != null and _slide_tween.is_valid():
		_slide_tween.kill()
	_slide_tween = create_tween()
	_slide_tween.tween_property(panel, "position:y", _closed_y, SLIDE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_slide_tween.tween_callback(func(): backdrop.visible = false)

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_close()

# Wipe and repopulate the visible list when opening — keeps panel state in sync
# with whatever messages BattleLog accumulated while closed.
#
# Uses remove_child + queue_free instead of bare queue_free because queue_free
# is deferred to end-of-frame; without remove_child the old labels would still
# be counted in get_child_count() while we're appending the new ones, which
# causes the cap loop in _append_label to spin forever (the "freeze on second
# open" bug).
func _rebuild_messages() -> void:
	for child in message_list.get_children():
		message_list.remove_child(child)
		child.queue_free()
	for entry in BattleLog.get_messages():
		_append_label(entry)

func _on_log_added(entry: Dictionary) -> void:
	if not _open:
		return
	_append_label(entry)
	_scroll_to_bottom()

func _on_log_cleared() -> void:
	for child in message_list.get_children():
		child.queue_free()

func _append_label(entry: Dictionary) -> void:
	var label := Label.new()
	label.text = entry.get("text", "")
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 13)
	var kind: StringName = entry.get("kind", &"generic")
	var color: Color = KIND_COLORS.get(kind, KIND_COLORS[&"generic"])
	label.add_theme_color_override("font_color", color)
	message_list.add_child(label)
	# Trim oldest visual rows past the autoload's cap (defensive — autoload
	# already trims `messages`, but we may have rendered older ones first).
	# remove_child first so get_child_count() reflects the removal immediately
	# (queue_free is deferred and would loop forever otherwise).
	while message_list.get_child_count() > BattleLog.max_messages:
		var oldest: Node = message_list.get_child(0)
		message_list.remove_child(oldest)
		oldest.queue_free()

func _scroll_to_bottom() -> void:
	# Defer one frame so the new label has been laid out.
	await get_tree().process_frame
	var v_scroll: VScrollBar = scroll.get_v_scroll_bar()
	if v_scroll != null:
		scroll.scroll_vertical = int(v_scroll.max_value)
