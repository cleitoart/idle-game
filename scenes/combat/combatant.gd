class_name Combatant
extends VBoxContainer

signal attack_ready(combatant: Combatant)
signal died(combatant: Combatant)
signal hp_changed(current: int, maximum: int)

@onready var name_label: Label = $NameLabel
@onready var body_stage: Control = $BodyStage
@onready var body_fallback: ColorRect = $BodyStage/Body
@onready var animated_sprite: AnimatedSprite2D = $BodyStage/AnimatedSprite2D
@onready var hp_bar: Node = $HpBar
@onready var attack_timer: Timer = $AttackTimer

var stats: CombatStats
var current_hp: int = 0
var display_name: String = ""
var is_dead: bool = false

func setup(p_display_name: String,
		p_stats: CombatStats,
		body_color: Color,
		sprite_sheet: Texture2D = null,
		frame_size: Vector2i = Vector2i.ZERO,
		frame_count: int = 0,
		sprite_scale: int = 1,
		sprite_fps: float = 6.0) -> void:
	display_name = p_display_name
	stats = p_stats
	current_hp = stats.max_hp
	is_dead = false
	if is_node_ready():
		_apply_setup(body_color, sprite_sheet, frame_size, frame_count, sprite_scale, sprite_fps)
	else:
		ready.connect(_apply_setup.bind(body_color, sprite_sheet, frame_size, frame_count, sprite_scale, sprite_fps), CONNECT_ONE_SHOT)

func _apply_setup(body_color: Color,
		sprite_sheet: Texture2D,
		frame_size: Vector2i,
		frame_count: int,
		sprite_scale: int,
		sprite_fps: float) -> void:
	name_label.text = display_name
	body_fallback.color = body_color
	_apply_sprite(sprite_sheet, frame_size, frame_count, sprite_scale, sprite_fps)
	hp_bar.set_hp(current_hp, stats.max_hp)
	hp_changed.emit(current_hp, stats.max_hp)
	_restart_attack_timer()

func _apply_sprite(sheet: Texture2D, frame_size: Vector2i, frame_count: int, sprite_scale: int, sprite_fps: float) -> void:
	if sheet == null or frame_count <= 0 or frame_size.x <= 0 or frame_size.y <= 0:
		body_fallback.visible = true
		animated_sprite.visible = false
		return
	body_fallback.visible = false
	animated_sprite.visible = true
	var frames := SpriteFrames.new()
	frames.add_animation(&"idle")
	frames.set_animation_loop(&"idle", true)
	frames.set_animation_speed(&"idle", sprite_fps)
	for i in frame_count:
		var atlas := AtlasTexture.new()
		atlas.atlas = sheet
		atlas.region = Rect2(i * frame_size.x, 0, frame_size.x, frame_size.y)
		frames.add_frame(&"idle", atlas)
	animated_sprite.sprite_frames = frames
	animated_sprite.scale = Vector2(sprite_scale, sprite_scale)
	animated_sprite.play(&"idle")
	_position_sprite()

func _position_sprite() -> void:
	if body_stage == null or animated_sprite == null:
		return
	if not is_inside_tree():
		return
	var size: Vector2 = body_stage.size
	if size.x <= 0 or size.y <= 0:
		size = body_stage.custom_minimum_size
	animated_sprite.position = Vector2(size.x * 0.5, size.y * 0.7)

func _on_body_stage_resized() -> void:
	_position_sprite()

func _restart_attack_timer() -> void:
	var speed: float = max(0.05, stats.attack_speed)
	attack_timer.wait_time = 1.0 / speed
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	if is_dead:
		return
	attack_ready.emit(self)

func take_damage(raw: int) -> void:
	if is_dead:
		return
	var dmg: int = max(1, raw - stats.def)
	current_hp = max(0, current_hp - dmg)
	hp_bar.set_hp(current_hp, stats.max_hp)
	hp_changed.emit(current_hp, stats.max_hp)
	if current_hp <= 0:
		_die()

func heal_full() -> void:
	current_hp = stats.max_hp
	is_dead = false
	hp_bar.set_hp(current_hp, stats.max_hp)
	hp_changed.emit(current_hp, stats.max_hp)
	_restart_attack_timer()

func _die() -> void:
	is_dead = true
	attack_timer.stop()
	died.emit(self)

func stop() -> void:
	attack_timer.stop()
