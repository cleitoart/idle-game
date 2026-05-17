class_name DamageNumber
extends Node2D

const NORMAL_COLOR: Color = Color(0.96, 0.96, 0.90, 1.0)
const CRIT_COLOR: Color = Color(0.92, 0.32, 0.30, 1.0)

const NORMAL_FONT_SIZE: int = 22
const CRIT_FONT_SIZE: int = 30

const RISE_DISTANCE: float = 60.0
const HORIZONTAL_VARIANCE: float = 28.0
const ANIM_DURATION: float = 0.7
const FADE_DELAY: float = 0.25

@onready var label: Label = $Label

func play(amount: int, is_crit: bool = false) -> void:
	label.text = "%d" % amount
	if is_crit:
		label.modulate = CRIT_COLOR
		label.add_theme_font_size_override("font_size", CRIT_FONT_SIZE)
	else:
		label.modulate = NORMAL_COLOR
		label.add_theme_font_size_override("font_size", NORMAL_FONT_SIZE)
	# Random horizontal scatter so consecutive numbers don't overlap exactly.
	position += Vector2(randf_range(-HORIZONTAL_VARIANCE, HORIZONTAL_VARIANCE), 0)
	var end_pos: Vector2 = position + Vector2(0, -RISE_DISTANCE)
	var tween := create_tween()
	tween.tween_property(self, "position", end_pos, ANIM_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label, "modulate:a", 0.0, ANIM_DURATION - FADE_DELAY).set_delay(FADE_DELAY)
	tween.tween_callback(queue_free)
