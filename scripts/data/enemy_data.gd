class_name EnemyData
extends Resource

@export var id: StringName = &""
@export var display_name: String = ""
@export var level: int = 1
@export var hp: int = 10
@export var atk: int = 1
@export var def: int = 0
@export var attack_speed: float = 0.5
@export var loot_table: Array = []
@export var gold_min: int = 0
@export var gold_max: int = 0

@export_group("Sprite")
@export var sprite_sheet: Texture2D
@export var sprite_frame_width: int = 16
@export var sprite_frame_height: int = 16
@export var sprite_frame_count: int = 4
@export var sprite_scale: int = 6
@export var sprite_fps: float = 6.0

func get_sprite_sheet() -> Texture2D:
	if sprite_sheet != null:
		return sprite_sheet
	var path: String = "res://assets/sprites/%s.png" % String(id)
	if ResourceLoader.exists(path):
		return load(path)
	return null
