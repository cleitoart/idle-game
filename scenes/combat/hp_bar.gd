extends VBoxContainer

const MAIN_DURATION: float = 0.10
const TRAIL_DELAY: float = 0.05
const TRAIL_DURATION: float = 0.22

const TRAIL_BLINK_PHASE: float = 0.07
const TRAIL_RED: Color = Color(0.78, 0.32, 0.30, 1.0)
const TRAIL_WHITE: Color = Color(0.92, 0.92, 0.86, 1.0)

const SHAKE_LOW_THRESHOLD: float = 0.40
const SHAKE_HIGH_THRESHOLD: float = 0.80
const SHAKE_MIN_PIXELS: float = 1.5
const SHAKE_MAX_PIXELS: float = 6.0
const SHAKE_DURATION: float = 0.22
const SHAKE_FREQ_HZ: float = 32.0

@onready var bar_holder: Control = $BarHolder
@onready var main_bar: ProgressBar = $BarHolder/MainBar
@onready var trail_bar: ProgressBar = $BarHolder/TrailBar
@onready var label: Label = $BarHolder/Label
@onready var cooldown_bar: ProgressBar = get_node_or_null("CooldownBar")

var _main_tween: Tween
var _trail_tween: Tween
var _blink_tween: Tween
var _shake_tween: Tween
var _trail_fill_style: StyleBoxFlat

func _ready() -> void:
	# Duplicate the shared style so we can animate this instance's fill color
	# without affecting other HpBars.
	var original: StyleBoxFlat = trail_bar.get_theme_stylebox("fill") as StyleBoxFlat
	if original != null:
		_trail_fill_style = original.duplicate()
		trail_bar.add_theme_stylebox_override("fill", _trail_fill_style)

func set_hp(current: int, maximum: int) -> void:
	var new_max: int = max(1, maximum)
	var new_value: int = clamp(current, 0, maximum)
	label.text = "%s / %s" % [_format_hp(max(0, current)), _format_hp(maximum)]
	# If max changed, snap both bars (initial setup or character switch)
	if int(main_bar.max_value) != new_max:
		main_bar.max_value = new_max
		trail_bar.max_value = new_max
		main_bar.value = new_value
		trail_bar.value = new_value
		_kill_blink_and_shake()
		return
	var old_value: float = main_bar.value
	var damage: float = old_value - new_value
	# Animate main bar (Ease Out Cubic, fast)
	if _main_tween != null and _main_tween.is_valid():
		_main_tween.kill()
	_main_tween = create_tween()
	_main_tween.tween_property(main_bar, "value", float(new_value), MAIN_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if damage > 0.0:
		# Trail follows the main bar shortly after, always chasing the latest value
		if _trail_tween != null and _trail_tween.is_valid():
			_trail_tween.kill()
		_trail_tween = create_tween()
		_trail_tween.tween_interval(TRAIL_DELAY)
		_trail_tween.tween_property(trail_bar, "value", float(new_value), TRAIL_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_trail_tween.tween_callback(_stop_blink)
		_start_blink()
		_trigger_shake(damage / float(new_max))
	else:
		# Heal or no change: snap trail to current value
		if _trail_tween != null and _trail_tween.is_valid():
			_trail_tween.kill()
		trail_bar.value = float(new_value)
		_stop_blink()

# Toggles the "cur / max" text overlay. The bars themselves keep working.
func set_show_numbers(enabled: bool) -> void:
	if label != null:
		label.visible = enabled

# Cooldown bar (yellow, thin, below the HP bar). progress 0..1 — caller fills
# in based on attack timer elapsed. set_cooldown_visible(false) hides it.
func set_cooldown_visible(v: bool) -> void:
	if cooldown_bar != null:
		cooldown_bar.visible = v

func set_cooldown_progress(progress: float) -> void:
	if cooldown_bar == null:
		return
	cooldown_bar.value = clamp(progress, 0.0, 1.0)

# Compact display so big late-game HP values still fit in the 120-wide bar.
# 999 -> "999", 1234 -> "1.2k", 12_345_678 -> "12M", etc.
func _format_hp(value: int) -> String:
	var v: int = max(0, value)
	if v < 1000:
		return str(v)
	if v < 1_000_000:
		return "%.1fk" % (float(v) / 1000.0)
	if v < 1_000_000_000:
		return "%.1fM" % (float(v) / 1_000_000.0)
	if v < 1_000_000_000_000:
		return "%.1fB" % (float(v) / 1_000_000_000.0)
	return "%.1fT" % (float(v) / 1_000_000_000_000.0)

func _start_blink() -> void:
	if _blink_tween != null and _blink_tween.is_valid():
		_blink_tween.kill()
	if _trail_fill_style == null:
		return
	_blink_tween = create_tween()
	_blink_tween.set_loops()
	_blink_tween.tween_property(_trail_fill_style, "bg_color", TRAIL_WHITE, TRAIL_BLINK_PHASE)
	_blink_tween.tween_property(_trail_fill_style, "bg_color", TRAIL_RED, TRAIL_BLINK_PHASE)

func _stop_blink() -> void:
	if _blink_tween != null and _blink_tween.is_valid():
		_blink_tween.kill()
	if _trail_fill_style != null:
		_trail_fill_style.bg_color = TRAIL_RED

func _trigger_shake(damage_pct: float) -> void:
	var t: float = clamp((damage_pct - SHAKE_LOW_THRESHOLD) / (SHAKE_HIGH_THRESHOLD - SHAKE_LOW_THRESHOLD), 0.0, 1.0)
	t = t * t * (3.0 - 2.0 * t)
	var amplitude: float = lerp(SHAKE_MIN_PIXELS, SHAKE_MAX_PIXELS, t)
	if _shake_tween != null and _shake_tween.is_valid():
		_shake_tween.kill()
	bar_holder.position = Vector2.ZERO
	_shake_tween = create_tween()
	var step_count: int = max(1, int(SHAKE_DURATION * SHAKE_FREQ_HZ))
	var step_duration: float = SHAKE_DURATION / float(step_count)
	for i in step_count:
		var dx: float = randf_range(-amplitude, amplitude)
		var dy: float = randf_range(-amplitude * 0.4, amplitude * 0.4)
		_shake_tween.tween_property(bar_holder, "position", Vector2(dx, dy), step_duration)
	_shake_tween.tween_property(bar_holder, "position", Vector2.ZERO, step_duration)

func _kill_blink_and_shake() -> void:
	_stop_blink()
	if _shake_tween != null and _shake_tween.is_valid():
		_shake_tween.kill()
	bar_holder.position = Vector2.ZERO
