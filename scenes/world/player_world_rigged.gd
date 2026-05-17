class_name PlayerWorldRigged
extends CharacterBody2D

# Variante riggada do PlayerWorld — usa Skeleton2D + Bone2D + Polygon2D
# (cutout animation) em vez de AnimatedSprite2D. Mesma API publica de
# PlayerWorld pra ser drop-in replacement no WorldController quando o
# teste validar.
#
# Estrutura visual em $Skeleton2D:
#   root (hip)
#     ├── torso ── head, shoulder_l, shoulder_r
#     └── hip_l, hip_r (pernas)
#
# Cada Bone2D tem Polygon2D filhos (placeholders coloridos). Animacoes em
# $AnimationPlayer: idle / walk / attack / hurt.
#
# Flip lateral: muda Skeleton2D.scale.x (-1 = virado pra esquerda).

signal attack_landed(target: Node, damage: int)
signal died()

enum State { IDLE, MOVING_TO_POINT, MOVING_TO_TARGET, COMBAT }

const ATTACK_RANGE: float = 70.0
const MOVE_SPEED: float = 220.0
const ATTACK_PERIOD_FALLBACK: float = 1.0

@onready var _skeleton: Skeleton2D = $Skeleton2D
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _hp_bar: Node = $HpBar
@onready var _attack_timer: Timer = $AttackTimer
@onready var _weapon_sprite: Sprite2D = $Skeleton2D/root/torso/shoulder_l/weapon
@onready var _nav_agent: NavigationAgent2D = $NavigationAgent2D

# Rotacao base do node weapon (rest pose da mao). WeaponData.world_rotation
# eh somada a este valor. Capturada do .tscn no _ready pra ficar sincronizada
# se voce ajustar a pose la depois.
var _weapon_base_rotation: float = 0.0

var character: CharacterInstance
var data: CharacterData
var current_hp: int = 0
var is_dead: bool = false

var _state: int = State.IDLE
var _target: Node = null
var _move_target_pos: Vector2 = Vector2.ZERO
var _facing_left: bool = false
# Magnitude do scale.x do Skeleton2D capturada no _ready. O flip lateral
# multiplica por +/- isso, em vez de fixar +/-1.0 (que zerava o scale
# visual configurado no .tscn).
var _skeleton_scale_x: float = 1.0

func _ready() -> void:
	add_to_group("player")
	_attack_timer.timeout.connect(_on_attack_timer_timeout)
	_anim_player.animation_finished.connect(_on_anim_finished)
	EventBus.character_equipment_changed.connect(_on_character_equipment_changed)
	_skeleton_scale_x = absf(_skeleton.scale.x)
	if _weapon_sprite != null:
		_weapon_base_rotation = _weapon_sprite.rotation
	# Agent radius bate com o capsule (radius 7 atual) + pequena folga.
	# Se voce mudar o capsule no .tscn, atualize aqui pra evitar o player
	# parando longe das paredes.
	_nav_agent.radius = 10.0
	_nav_agent.path_desired_distance = 4.0
	_nav_agent.target_desired_distance = 3.0
	_play_anim(&"idle")

func setup(character_inst: CharacterInstance, character_data: CharacterData) -> void:
	character = character_inst
	data = character_data
	current_hp = character.current_hp if character.current_hp > 0 else character.stats.max_hp
	is_dead = false
	if _hp_bar != null and _hp_bar.has_method("set_hp"):
		_hp_bar.set_hp(current_hp, character.stats.max_hp)
	_apply_skeleton_scale()
	_apply_attack_timer()
	_refresh_weapon_visual()

# Aplica o scale visual do personagem ao Skeleton2D (analogo ao
# _apply_sprite_sheet do PlayerWorld original). O rig vive em 1:1 no
# editor pra facilitar keyframing — scale eh runtime via data.sprite_scale.
func _apply_skeleton_scale() -> void:
	if data == null or _skeleton == null:
		return
	var s: float = float(data.sprite_scale) if data.sprite_scale > 0 else 1.0
	_skeleton.scale = Vector2(s, s)
	# Atualiza cache usado pelo flip lateral (_step_toward).
	_skeleton_scale_x = s
	# Reaplica direcao caso ja estivesse virado pra esquerda.
	if _facing_left:
		_skeleton.scale.x = -s

# Sincroniza o Sprite2D "weapon" com a arma equipada no character. Chamado
# no setup e quando character_equipment_changed dispara. Sem WeaponData /
# sem arma equipada -> esconde o node (suporta combate desarmado / socos).
func _refresh_weapon_visual() -> void:
	if _weapon_sprite == null:
		return
	if character == null:
		_weapon_sprite.visible = false
		return
	var equipped: ItemData = character.get_equipment(CharacterInstance.EQUIP_WEAPON)
	if equipped == null:
		_weapon_sprite.visible = false
		return
	# Duck typing: qualquer subclasse de ItemData que exporte os campos
	# world_sprite/world_offset/world_rotation/world_scale (WeaponData,
	# ToolData, etc.) usa os ajustes. ItemData base sem esses campos cai
	# no fallback (textura = sprite do inventory, sem ajustes).
	var has_visual: bool = "world_sprite" in equipped
	var tex: Texture2D = null
	if has_visual:
		tex = equipped.get("world_sprite")
	if tex == null:
		tex = equipped.sprite
	if tex == null:
		_weapon_sprite.visible = false
		return
	_weapon_sprite.visible = true
	_weapon_sprite.texture = tex
	_weapon_sprite.centered = false
	var size: Vector2 = tex.get_size()
	var extra_offset: Vector2 = equipped.get("world_offset") if has_visual else Vector2.ZERO
	var extra_rot: float = equipped.get("world_rotation") if has_visual else 0.0
	var scale_mult: float = equipped.get("world_scale") if has_visual else 1.0
	# Pivot bottom-right + ajuste fino do .tres.
	_weapon_sprite.offset = Vector2(-size.x, -size.y) + extra_offset
	_weapon_sprite.rotation = _weapon_base_rotation + extra_rot
	_weapon_sprite.scale = Vector2(scale_mult, scale_mult)

func _on_character_equipment_changed(c: CharacterInstance) -> void:
	if c == character:
		_refresh_weapon_visual()

func _apply_attack_timer() -> void:
	if character == null:
		return
	var spd: float = character.stats.attack_speed
	if spd <= 0.0:
		_attack_timer.wait_time = ATTACK_PERIOD_FALLBACK
	else:
		_attack_timer.wait_time = max(0.25, 1.0 / spd)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	match _state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.MOVING_TO_POINT:
			# NavAgent recalcula path se _move_target_pos mudou. Aqui so
			# pedimos o proximo waypoint e seguimos. is_navigation_finished
			# vira true quando chegamos perto do alvo (target_desired_distance).
			if _nav_agent.is_navigation_finished():
				_state = State.IDLE
				velocity = Vector2.ZERO
			else:
				_step_along_path()
		State.MOVING_TO_TARGET:
			if not is_instance_valid(_target) or _target.get("is_dead"):
				_target = null
				_state = State.IDLE
				return
			var target_pos: Vector2 = (_target as Node2D).global_position
			if global_position.distance_to(target_pos) <= ATTACK_RANGE:
				_enter_combat_state()
				return
			# Atualiza alvo do agent toda physics tick (target pode se mover).
			# NavAgent so re-planeja se o destino mudar significativamente.
			_nav_agent.target_position = target_pos
			_step_along_path()
		State.COMBAT:
			velocity = Vector2.ZERO
			if not is_instance_valid(_target) or _target.get("is_dead"):
				_attack_timer.stop()
				_target = null
				_state = State.IDLE
				return
			var dist: float = global_position.distance_to((_target as Node2D).global_position)
			if dist > ATTACK_RANGE * 1.5:
				_attack_timer.stop()
				_state = State.MOVING_TO_TARGET
	move_and_slide()
	_update_animation()

func _step_along_path() -> void:
	var next_pos: Vector2 = _nav_agent.get_next_path_position()
	var to_next: Vector2 = next_pos - global_position
	if to_next.length() < 1.0:
		velocity = Vector2.ZERO
		return
	velocity = to_next.normalized() * MOVE_SPEED
	if absf(velocity.x) > 0.1:
		_facing_left = velocity.x < 0
		_skeleton.scale.x = -_skeleton_scale_x if _facing_left else _skeleton_scale_x

func _update_animation() -> void:
	# Death trava a anim ate o personagem ser despawned/respawnado.
	if is_dead:
		return
	# Attack e' disparado pelo _on_attack_timer_timeout, deixa a anim correr.
	if _anim_player.current_animation == "attack" and _anim_player.is_playing():
		return
	var desired: StringName = &"idle"
	match _state:
		State.IDLE:
			desired = &"idle"
		State.MOVING_TO_POINT, State.MOVING_TO_TARGET:
			desired = &"walk"
		State.COMBAT:
			# Entre swings em COMBAT a anim de attack ja terminou, fica em idle.
			desired = &"idle"
	_play_anim(desired)

func _play_anim(name: StringName) -> void:
	if _anim_player == null:
		return
	if not _anim_player.has_animation(name):
		return
	if _anim_player.current_animation == String(name) and _anim_player.is_playing():
		return
	# Flush de estado: aplica RESET antes de cada anim nova pra propriedades
	# que a anim destino nao mexe voltem ao rest pose. Sem isso, valores
	# remanescentes da anim anterior (ex: torso rotacionado por attack)
	# vazam pra anim seguinte (idle).
	if name != &"RESET" and _anim_player.has_animation(&"RESET"):
		_anim_player.play(&"RESET")
		_anim_player.advance(0)
	_anim_player.play(name)

func _on_anim_finished(_anim_name: StringName) -> void:
	# Apos anims one-shot (attack), volta pra anim apropriada ao estado.
	# Death nao volta — _update_animation early-returns se is_dead.
	_update_animation()

func move_to_point(world_pos: Vector2) -> void:
	if is_dead:
		return
	_target = null
	_attack_timer.stop()
	_move_target_pos = world_pos
	_nav_agent.target_position = world_pos
	_state = State.MOVING_TO_POINT

func set_target(enemy: Node) -> void:
	if is_dead or enemy == null:
		return
	_target = enemy
	_nav_agent.target_position = (enemy as Node2D).global_position
	_state = State.MOVING_TO_TARGET
	if global_position.distance_to((enemy as Node2D).global_position) <= ATTACK_RANGE:
		_enter_combat_state()
	EventBus.world_target_changed.emit(enemy)

func clear_target() -> void:
	_target = null
	_attack_timer.stop()
	_state = State.IDLE
	EventBus.world_target_changed.emit(null)

func get_target() -> Node:
	return _target

func _enter_combat_state() -> void:
	_state = State.COMBAT
	velocity = Vector2.ZERO
	_apply_attack_timer()
	_attack_timer.start()

func _on_attack_timer_timeout() -> void:
	if is_dead or _state != State.COMBAT:
		return
	if not is_instance_valid(_target) or _target.get("is_dead"):
		_attack_timer.stop()
		_state = State.IDLE
		return
	var dmg: int = max(1, character.stats.atk)
	if _target.has_method("take_damage"):
		_target.take_damage(dmg)
	attack_landed.emit(_target, dmg)
	_play_anim(&"attack")

func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_hp = max(0, current_hp - amount)
	if character != null:
		character.current_hp = current_hp
		EventBus.character_hp_changed.emit(character, current_hp, character.stats.max_hp)
	if _hp_bar != null and _hp_bar.has_method("set_hp"):
		_hp_bar.set_hp(current_hp, character.stats.max_hp)
	if current_hp <= 0:
		_die()

func _die() -> void:
	is_dead = true
	_state = State.IDLE
	_attack_timer.stop()
	velocity = Vector2.ZERO
	_play_anim(&"death")
	died.emit()
