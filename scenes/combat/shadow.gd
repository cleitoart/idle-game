class_name Shadow
extends Sprite2D

const FALLBACK_TEXTURE_PATH: String = "res://assets/sprites/effects/elipse_vfx000.png"

@export var radius: Vector2 = Vector2(46, 8) :
	set(value):
		radius = value
		_update_scale()
@export var color: Color = Color(0, 0, 0, 0.35) :
	set(value):
		color = value
		if is_node_ready():
			modulate = value
@export var pixelize: bool = false :
	set(value):
		pixelize = value
		if is_node_ready():
			texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if pixelize else CanvasItem.TEXTURE_FILTER_LINEAR
@export var pixel_size: int = 4 # kept for backward compatibility; no longer used

func _ready() -> void:
	if texture == null and ResourceLoader.exists(FALLBACK_TEXTURE_PATH):
		texture = load(FALLBACK_TEXTURE_PATH)
	modulate = color
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if pixelize else CanvasItem.TEXTURE_FILTER_LINEAR
	_update_scale()

func _update_scale() -> void:
	if not is_node_ready():
		return
	if texture == null:
		return
	var tex_size: Vector2 = texture.get_size()
	if tex_size.x <= 0 or tex_size.y <= 0:
		return
	scale = Vector2((radius.x * 2.0) / tex_size.x, (radius.y * 2.0) / tex_size.y)
