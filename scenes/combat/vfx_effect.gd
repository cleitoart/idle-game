class_name VfxEffect
extends Node2D

enum Pattern { BLINK, STOCK, UPHEAD, SLASH }

# Blink: appears on the mob, slight random offset and rotation, grows
# horizontally while fading out. Good for cuts and direct magic.
const BLINK_DURATION: float = 0.15
const BLINK_INITIAL_ALPHA: float = 0.85
const BLINK_SCALE_GROWTH_X: float = 1.30
const BLINK_OFFSET_RANGE: float = 10.0

# Stock: travels from below up to the mob (arrows, fireballs).
const STOCK_TRAVEL: float = 90.0
const STOCK_DURATION: float = 0.20

# Uphead: drops onto the mob from above (rain of arrows, lightning).
const UPHEAD_TRAVEL: float = 90.0
const UPHEAD_DURATION: float = 0.20

# Slash: passes through the mob horizontally, random direction.
const SLASH_TRAVEL: float = 120.0
const SLASH_DURATION: float = 0.16

@onready var sprite: Sprite2D = $Sprite

func play(texture: Texture2D, pattern: Pattern, vfx_scale: float) -> void:
	if texture == null:
		queue_free()
		return
	sprite.texture = texture
	match pattern:
		Pattern.BLINK:
			_play_blink(vfx_scale)
		Pattern.STOCK:
			_play_stock(vfx_scale)
		Pattern.UPHEAD:
			_play_uphead(vfx_scale)
		Pattern.SLASH:
			_play_slash(vfx_scale)
		_:
			queue_free()

func _play_blink(vfx_scale: float) -> void:
	sprite.position = Vector2(
		randf_range(-BLINK_OFFSET_RANGE, BLINK_OFFSET_RANGE),
		randf_range(-BLINK_OFFSET_RANGE, BLINK_OFFSET_RANGE)
	)
	sprite.rotation = randf_range(-PI, PI)
	var base_scale := Vector2(vfx_scale, vfx_scale)
	var end_scale := Vector2(vfx_scale * BLINK_SCALE_GROWTH_X, vfx_scale)
	sprite.scale = base_scale
	sprite.modulate = Color(1, 1, 1, BLINK_INITIAL_ALPHA)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", end_scale, BLINK_DURATION)
	tween.tween_property(sprite, "modulate:a", 0.0, BLINK_DURATION)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

func _play_stock(vfx_scale: float) -> void:
	sprite.position = Vector2(0, STOCK_TRAVEL)
	sprite.rotation = 0
	sprite.scale = Vector2(vfx_scale, vfx_scale)
	sprite.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(sprite, "position", Vector2.ZERO, STOCK_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "modulate:a", 0.0, STOCK_DURATION * 0.6)
	tween.tween_callback(queue_free)

func _play_uphead(vfx_scale: float) -> void:
	sprite.position = Vector2(0, -UPHEAD_TRAVEL)
	sprite.rotation = 0
	sprite.scale = Vector2(vfx_scale, vfx_scale)
	sprite.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(sprite, "position", Vector2.ZERO, UPHEAD_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "modulate:a", 0.0, UPHEAD_DURATION * 0.6)
	tween.tween_callback(queue_free)

func _play_slash(vfx_scale: float) -> void:
	var direction: float = 1.0 if randf() < 0.5 else -1.0
	sprite.position = Vector2(-direction * SLASH_TRAVEL, 0)
	sprite.rotation = 0
	# Mirror sprite to point in motion direction
	sprite.scale = Vector2(vfx_scale * direction, vfx_scale)
	sprite.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(sprite, "position", Vector2(direction * SLASH_TRAVEL, 0), SLASH_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, SLASH_DURATION).set_delay(SLASH_DURATION * 0.4)
	tween.tween_callback(queue_free)
