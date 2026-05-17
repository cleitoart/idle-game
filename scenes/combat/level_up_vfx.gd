extends Node2D

# Tunables — adjust here to retime the whole VFX. The pulse + particles +
# label all run in parallel so total time = max(text, particles).
const PULSE_DURATION_IN: float = 0.1
const PULSE_DURATION_OUT: float = 0.1
const PULSE_START_SCALE: float = 0.2
const PULSE_END_SCALE: float = 0.5

const TEXT_DURATION: float = 1.1
const TEXT_RISE: float = 140.0
const TEXT_FADE_IN: float = 0.15
const TEXT_FADE_OUT: float = 0.4

@onready var pulse: Sprite2D = $Pulse
@onready var particles: GPUParticles2D = $Particles
@onready var label: Label = $Label

func _ready() -> void:
	# Stay invisible until play() actually fires the tweens. Prevents a single-
	# frame blink when the scene is added before play().
	pulse.scale = Vector2(PULSE_START_SCALE, PULSE_START_SCALE)
	pulse.modulate.a = 0.0
	label.modulate.a = 0.0
	particles.emitting = false

func play() -> void:
	# Pulse: scale up AND fade out IN PARALLEL — looks like a shockwave going
	# outward and dissipating, instead of growing-then-fading sequentially.
	pulse.scale = Vector2(PULSE_START_SCALE, PULSE_START_SCALE)
	pulse.modulate = Color(1, 1, 1, 1)
	var pulse_total: float = PULSE_DURATION_IN + PULSE_DURATION_OUT
	var t := create_tween().set_parallel(true)
	t.tween_property(pulse, "scale", Vector2(PULSE_END_SCALE, PULSE_END_SCALE), pulse_total).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(pulse, "modulate:a", 0.0, pulse_total).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# Fire the cross particles at the same instant the shockwave starts.
	particles.restart()
	# Label "Level Up" floats up while fading.
	label.position.y = -90.0
	label.modulate = Color(1, 1, 1, 0)
	var t2 := create_tween().set_parallel(true)
	t2.tween_property(label, "modulate:a", 1.0, TEXT_FADE_IN)
	t2.tween_property(label, "position:y", -TEXT_RISE, TEXT_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t2.tween_interval(max(0.0, TEXT_DURATION - TEXT_FADE_OUT))
	t2.chain().tween_property(label, "modulate:a", 0.0, TEXT_FADE_OUT)
	# Self-cleanup once everything is done.
	await get_tree().create_timer(TEXT_DURATION + 0.3).timeout
	queue_free()
