class_name EnemyWorld
extends CharacterBody2D

# EnemyWorld — inimigo no mundo 2D (Fase Exploration AQW).
#
# CharacterBody2D porque pode (no futuro) wander/patrulhar. Por enquanto fica
# stationary. ClickArea (Area2D filho) capta click do player pra targeting.
#
# Estados:
#   - IDLE: parado no spawn point.
#   - COMBAT: player em range; atacando de volta no timer.
#   - DEAD: aguardando queue_free apos drop.
#
# API:
#   setup(enemy_data: EnemyData)
#   take_damage(amount: int)
#   is_dead -> bool (campo publico pra player checar)

signal defeated(enemy: Node, enemy_data: EnemyData)

const ATTACK_RANGE: float = 80.0

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hp_bar: Node = $HpBar
@onready var _click_area: Area2D = $ClickArea
@onready var _attack_timer: Timer = $AttackTimer

var data: EnemyData
var spawn_point: Node  # SpawnPoint que originou (pra notify no death).
var current_hp: int = 0
var is_dead: bool = false
var _player: Node = null

func _ready() -> void:
	add_to_group("enemies")
	# NOTA: ClickArea NAO conecta input_event. ExplorationView faz um
	# physics_point_query no gui_input pra detectar clicks em enemies de
	# forma robusta (independente da ordem de input do Godot).
	_attack_timer.timeout.connect(_on_attack_timer_timeout)
	_apply_setup()

# Setup eh chamado pelo SpawnPoint via `enemy.set("data", enemy_data)` antes
# de adicionar ao tree. Quando _ready dispara, ja temos data.
func _apply_setup() -> void:
	if data == null:
		return
	current_hp = data.hp
	is_dead = false
	_apply_sprite_sheet()
	if _hp_bar != null and _hp_bar.has_method("set_hp"):
		_hp_bar.set_hp(current_hp, data.hp)
	var spd: float = data.attack_speed if data.attack_speed > 0.0 else 0.5
	_attack_timer.wait_time = max(0.5, 1.0 / spd)

# Aplica o SpriteFrames do EnemyData no AnimatedSprite2D. Anims e FPS
# configuradas no .tres do inimigo via editor.
func _apply_sprite_sheet() -> void:
	if data == null or _animated_sprite == null:
		return
	if data.sprite_frames == null:
		_animated_sprite.visible = false
		push_warning("EnemyWorld: %s nao tem sprite_frames configurado" % data.id)
		return
	_animated_sprite.sprite_frames = data.sprite_frames
	_animated_sprite.scale = Vector2(data.sprite_scale, data.sprite_scale)
	_animated_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_animated_sprite.visible = true
	var first_anim: StringName = &"idle"
	if not data.sprite_frames.has_animation(first_anim):
		var names: PackedStringArray = data.sprite_frames.get_animation_names()
		if names.is_empty():
			return
		first_anim = StringName(names[0])
	_animated_sprite.play(first_anim)
	# Ajusta a ClickArea pra cobrir o sprite visivel (cada inimigo tem tamanho
	# de frame diferente; click area fixa 64x64 do .tscn fica pequena demais
	# pra sprites grandes ou grande demais pra pequenos).
	_resize_click_area_to_sprite(first_anim)

func _resize_click_area_to_sprite(anim_name: StringName) -> void:
	if _click_area == null or data == null or data.sprite_frames == null:
		return
	if not data.sprite_frames.has_animation(anim_name):
		return
	var tex: Texture2D = data.sprite_frames.get_frame_texture(anim_name, 0)
	if tex == null:
		return
	var click_shape: CollisionShape2D = _click_area.get_node_or_null("ClickShape")
	if click_shape == null:
		return
	# Cria um RectangleShape2D novo pra evitar compartilhar a instancia entre
	# enemies (SubResource do .tscn eh shared por default).
	var visible_size: Vector2 = tex.get_size() * float(data.sprite_scale)
	var new_shape := RectangleShape2D.new()
	new_shape.size = visible_size * 1.2  # 20% padding na borda
	click_shape.shape = new_shape

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	# Detecta player em range e ataca de volta.
	if _player == null:
		_player = get_tree().get_first_node_in_group("player")
	var in_combat: bool = false
	if _player != null and not _player.get("is_dead"):
		var dist: float = global_position.distance_to((_player as Node2D).global_position)
		if dist <= ATTACK_RANGE:
			in_combat = true
			if _attack_timer.is_stopped():
				_attack_timer.start()
		else:
			_attack_timer.stop()
	# Sincroniza animacao com estado. Inimigos sao stationary -> idle ou
	# attack (sem walk por enquanto).
	if _animated_sprite != null and _animated_sprite.sprite_frames != null:
		var desired: StringName = &"attack" if in_combat else &"idle"
		if _animated_sprite.animation != desired:
			_animated_sprite.play(desired)

func _on_attack_timer_timeout() -> void:
	if is_dead or _player == null or _player.get("is_dead"):
		return
	var dist: float = global_position.distance_to((_player as Node2D).global_position)
	if dist > ATTACK_RANGE * 1.2:
		return
	var dmg: int = max(1, data.atk)
	if _player.has_method("take_damage"):
		_player.take_damage(dmg)

func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_hp = max(0, current_hp - amount)
	if _hp_bar != null and _hp_bar.has_method("set_hp"):
		_hp_bar.set_hp(current_hp, data.hp)
	if current_hp <= 0:
		_die()

func _die() -> void:
	is_dead = true
	_attack_timer.stop()
	defeated.emit(self, data)
	# WorldController processara drop/xp/respawn signaling. Fade-out simples
	# antes de queue_free.
	var tween: Tween = create_tween()
	tween.tween_property(_animated_sprite, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
