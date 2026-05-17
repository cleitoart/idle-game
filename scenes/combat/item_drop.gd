class_name ItemDrop
extends Control

const DROP_DURATION: float = 0.55
const DROP_APEX_HEIGHT: float = 90.0

const COLLECT_DURATION: float = 0.22
const COLLECT_RISE: float = 32.0

const ICON_SCALE_FALLBACK: float = 3.0
const FALLBACK_ICON_SIZE: Vector2 = Vector2(32, 32)

const MERGE_RADIUS: float = 64.0
const MERGE_POP_DURATION: float = 0.18
const MERGE_POP_SCALE: float = 1.35

const ITEM_DROP_GROUP: StringName = &"item_drops"

signal collected(item: ItemData, qty: int)

@onready var sprite: Sprite2D = $Sprite

var item: ItemData
var qty: int = 0
var _collected: bool = false
var _merged: bool = false
var _base_sprite_scale: Vector2 = Vector2.ONE
var _arc_start: Vector2
var _arc_target: Vector2

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_entered.connect(_on_mouse_entered)
	add_to_group(ITEM_DROP_GROUP)

func setup(p_item: ItemData, p_qty: int) -> void:
	item = p_item
	qty = p_qty
	var scale_value: float = ICON_SCALE_FALLBACK
	var tex_size: Vector2 = FALLBACK_ICON_SIZE
	if p_item != null:
		sprite.texture = p_item.get_drop_icon()
		if p_item.drop_scale > 0.0:
			scale_value = p_item.drop_scale
		if sprite.texture != null:
			tex_size = sprite.texture.get_size()
	_base_sprite_scale = Vector2(scale_value, scale_value)
	sprite.scale = _base_sprite_scale
	# The Control's rect IS the hit-box for hover collection. Size it to the
	# visible sprite so anywhere the icon shows up triggers mouse_entered.
	var hit_size: Vector2 = tex_size * scale_value
	custom_minimum_size = hit_size
	size = hit_size
	# Place the Sprite2D at the center of the Control so the visible icon and
	# the hit-box share the same center.
	sprite.position = hit_size * 0.5

func play_drop(start_pos: Vector2, target_pos: Vector2) -> void:
	_arc_start = start_pos
	_arc_target = target_pos
	_apply_arc(0.0)
	# True parabola via tween_method: x lerps linearly while y follows
	# y(t) = lerp(start, target) - 4 * H * t * (1 - t). Two sequential
	# segments would only give a piecewise-linear "cone".
	var tween := create_tween()
	tween.tween_method(_apply_arc, 0.0, 1.0, DROP_DURATION)
	tween.tween_callback(_try_merge_into_neighbor)

func _apply_arc(t: float) -> void:
	var x: float = lerp(_arc_start.x, _arc_target.x, t)
	var line_y: float = lerp(_arc_start.y, _arc_target.y, t)
	var y: float = line_y - 4.0 * DROP_APEX_HEIGHT * t * (1.0 - t)
	var visual_center: Vector2 = Vector2(x, y)
	position = visual_center - size * 0.5

func _on_mouse_entered() -> void:
	_collect()

func _collect() -> void:
	if _collected or _merged:
		return
	_collected = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var end_pos: Vector2 = position + Vector2(0, -COLLECT_RISE)
	var tween := create_tween()
	tween.tween_property(self, "position", end_pos, COLLECT_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, COLLECT_DURATION)
	tween.tween_callback(_on_collect_done)

func _on_collect_done() -> void:
	collected.emit(item, qty)
	queue_free()

# When an incoming drop finishes its arc, look for a same-item drop nearby
# and fold qty into it. Cuts visual noise + node count when many of the same
# item drop in quick succession.
func _try_merge_into_neighbor() -> void:
	if _collected or _merged or item == null:
		return
	var my_id: StringName = item.id
	var nodes: Array = get_tree().get_nodes_in_group(ITEM_DROP_GROUP)
	for node in nodes:
		if node == self:
			continue
		if not (node is ItemDrop):
			continue
		var other: ItemDrop = node
		if other._collected or other._merged or other.item == null:
			continue
		if other.item.id != my_id:
			continue
		if position.distance_to(other.position) > MERGE_RADIUS:
			continue
		# Found a buffer: hand off our qty and self-destruct silently.
		other.qty += qty
		other._play_merge_pop()
		_merged = true
		queue_free()
		return

func _play_merge_pop() -> void:
	# Brief scale punch + brightness flash to signal the merge visually.
	var peak_scale: Vector2 = _base_sprite_scale * MERGE_POP_SCALE
	var t := create_tween()
	t.tween_property(sprite, "scale", peak_scale, MERGE_POP_DURATION * 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(sprite, "scale", _base_sprite_scale, MERGE_POP_DURATION * 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	var flash := create_tween()
	flash.tween_property(sprite, "modulate", Color(1.5, 1.5, 1.5, 1.0), MERGE_POP_DURATION * 0.3)
	flash.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), MERGE_POP_DURATION * 0.7)
