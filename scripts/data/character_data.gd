class_name CharacterData
extends Resource

@export var id: StringName = &""
@export var display_name: String = ""
@export var base_hp: int = 10
@export var base_atk: int = 1
@export var base_def: int = 0
@export var base_attack_speed: float = 1.0
@export var starting_weapon: ItemData
@export var starting_stage: StageData
@export var inventory_max_slots: int = 16
@export var portrait_color: Color = Color(0.30, 0.55, 0.85, 1)

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
