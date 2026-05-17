extends Control

# Modal de resultados pos-clear de area (Fase 01 / B3).
# Aberto por `EventBus.area_cleared` quando o personagem limpa todas as
# waves do stage atual. Mostra XP/Gold/Kills/Time + drops + comparativo
# com o ultimo clear (se houver). Auto-close apos N segundos pra nao
# interromper o loop idle por muito tempo.

const AUTO_CLOSE_SECONDS: float = 8.0
# Cores por raridade — alinhadas com `inventory_slot.gd`.
const RARITY_COLORS: Dictionary = {
	0: Color("#B0B0B0"),  # Common
	1: Color("#4DD24D"),  # Uncommon
	2: Color("#4D9DFF"),  # Rare
	3: Color("#C46BFF"),  # Epic
	4: Color("#FF9D4D"),  # Legendary
	5: Color("#FF4D6B"),  # Mythic
}

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Center/Panel
@onready var title_label: Label = $Center/Panel/Margin/Box/TitleLabel
@onready var stage_label: Label = $Center/Panel/Margin/Box/StageLabel
@onready var comparison_label: Label = $Center/Panel/Margin/Box/ComparisonLabel
@onready var xp_value: Label = $Center/Panel/Margin/Box/StatsGrid/XpValue
@onready var gold_value: Label = $Center/Panel/Margin/Box/StatsGrid/GoldValue
@onready var kills_value: Label = $Center/Panel/Margin/Box/StatsGrid/KillsValue
@onready var time_value: Label = $Center/Panel/Margin/Box/StatsGrid/TimeValue
@onready var drops_list: VBoxContainer = $Center/Panel/Margin/Box/DropsScroll/DropsList
@onready var continue_btn: Button = $Center/Panel/Margin/Box/ButtonRow/ContinueBtn

var _close_timer: SceneTreeTimer

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	continue_btn.pressed.connect(close)
	backdrop.gui_input.connect(_on_backdrop_input)

func open_with_summary(summary: Dictionary, previous: Dictionary = {}) -> void:
	_render(summary, previous)
	visible = true
	Juicy.modal_appear(self, panel)
	# Auto-close — usa SceneTreeTimer, que ESCALA com Engine.time_scale.
	# Em 2x o usuario quer fechar mais rapido, entao isso faz sentido.
	if _close_timer != null:
		# Tween anterior ainda em andamento; ignora.
		pass
	_close_timer = get_tree().create_timer(AUTO_CLOSE_SECONDS)
	_close_timer.timeout.connect(_on_auto_close)

func close() -> void:
	if not visible:
		_close_timer = null
		return
	var t: Tween = Juicy.modal_disappear(self, panel)
	if t != null:
		t.finished.connect(func(): visible = false)
	else:
		visible = false
	_close_timer = null

func _on_auto_close() -> void:
	# Pode ter sido fechado manualmente antes; verificar.
	if visible:
		close()

# --- Render --------------------------------------------------------------

func _render(summary: Dictionary, previous: Dictionary) -> void:
	# Header
	var zone_id: String = String(summary.get("zone_id", ""))
	var area_idx: int = int(summary.get("area_index", -1))
	var stage_idx: int = int(summary.get("stage_index", -1))
	stage_label.text = "%s — Area %d, Stage %d" % [
		_pretty_zone_name(zone_id),
		area_idx + 1,
		stage_idx + 1,
	]
	# Stats
	xp_value.text = "+%d" % int(summary.get("xp_total", 0))
	gold_value.text = "+%d" % int(summary.get("gold_total", 0))
	kills_value.text = "%d" % int(summary.get("kills_total", 0))
	var elapsed: int = int(summary.get("elapsed_seconds", 0))
	time_value.text = _format_time(elapsed)
	# Comparativo
	if previous != null and not previous.is_empty():
		var prev_elapsed: int = int(previous.get("elapsed_seconds", 0))
		if prev_elapsed > 0:
			var diff: int = elapsed - prev_elapsed
			if diff < 0:
				comparison_label.text = "%ds mais rapido!" % -diff
				comparison_label.modulate = Color(0.6, 0.85, 0.6)
			elif diff > 0:
				comparison_label.text = "%ds mais lento" % diff
				comparison_label.modulate = Color(0.85, 0.55, 0.55)
			else:
				comparison_label.text = "Mesmo tempo"
				comparison_label.modulate = Color(0.7, 0.7, 0.7)
		else:
			comparison_label.text = ""
	else:
		comparison_label.text = "Primeiro clear"
		comparison_label.modulate = Color(0.85, 0.66, 0.22)
	# Drops
	for child in drops_list.get_children():
		child.queue_free()
	var drops: Array = summary.get("drops", [])
	if drops.is_empty():
		var empty := Label.new()
		empty.text = "Sem drops desta vez."
		empty.modulate.a = 0.5
		drops_list.add_child(empty)
	else:
		for drop in drops:
			drops_list.add_child(_build_drop_row(drop))

func _build_drop_row(drop: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	var name_label := Label.new()
	name_label.text = String(drop.get("name", "?"))
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_color_override("font_color", RARITY_COLORS.get(int(drop.get("rarity", 0)), Color(1, 1, 1)))
	var qty_label := Label.new()
	qty_label.text = "x%d" % int(drop.get("qty", 0))
	qty_label.custom_minimum_size = Vector2(80, 0)
	qty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(name_label)
	row.add_child(qty_label)
	return row

func _format_time(seconds: int) -> String:
	if seconds < 60:
		return "%ds" % seconds
	var m: int = seconds / 60
	var s: int = seconds % 60
	return "%dm %02ds" % [m, s]

func _pretty_zone_name(zone_id: String) -> String:
	if zone_id == "":
		return "?"
	return zone_id.capitalize().replace("_", " ")

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()
		get_viewport().set_input_as_handled()
