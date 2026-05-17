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
# SpriteFrames configurado no editor com anims idle / walk / attack. Cada
# animacao com sua propria FPS, loop e frames. Configuracao visual unica
# (sem sprite-sheet legado separado).
@export var sprite_frames: SpriteFrames
@export var sprite_scale: int = 6

@export_group("Shadow")
@export var shadow_offset: Vector2 = Vector2.ZERO
@export var shadow_radius: Vector2 = Vector2(46, 8)
@export var shadow_color: Color = Color(0, 0, 0, 0.35)
@export var shadow_pixelize: bool = false
@export var shadow_pixel_size: int = 4
