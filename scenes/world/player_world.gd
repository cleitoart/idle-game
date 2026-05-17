class_name PlayerWorld
extends CharacterBody2D

# PlayerWorld — character world entity (Fase Exploration AQW).
#
# CharacterBody2D com NavigationAgent2D pra pathfinding click-to-move.
# Logica de combate (timer attack, damage, animacoes) reusa pattern do
# Combatant antigo mas adaptado pra mundo 2D ao inves de UI slot.
#
# Estados:
#   - IDLE: sem target, anim idle.
#   - MOVING_TO_POINT: caminhando pra posicao clicada no chao.
#   - MOVING_TO_TARGET: caminhando pra um enemy alvo (combat trigga quando
#     entra em attack_range).
#   - COMBAT: parado, batendo no target ate ele morrer ou sair de range.
#
# API:
#   setup(character: CharacterInstance, character_data: CharacterData)
#   move_to_point(world_pos: Vector2) — click no chao
#   set_target(enemy: Node) — click no inimigo
#   clear_target() — termina o engajamento

signal attack_landed(target: Node, damage: int)
signal died()

enum State { IDLE, MOVING_TO_POINT, MOVING_TO_TARGET, COMBAT }

const ATTACK_RANGE: float = 70.0   # distancia minima pra iniciar combat
const MOVE_SPEED: float = 220.0    # pixels/sec
const ATTACK_PERIOD_FALLBACK: float = 1.0  # se attack_speed do char = 0

# NavigationAgent2D fica no .tscn pra uso futuro (pathfinding em mapas
# complexos). Por enquanto o movimento eh direto via _step_toward.
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hp_bar: Node = $HpBar
@onready var _attack_timer: Timer = $AttackTimer

var character: CharacterInstance
var data: CharacterData
var current_hp: int = 0
var is_dead: bool = false

var _state: int = State.IDLE
var _target: Node = null
# Posicao destino quando movendo livre (ground click). Atualizado quando o
# player clica num ponto sem inimigo.
var _move_target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("player")
	_attack_timer.timeout.connect(_on_attack_timer_timeout)

func setup(character_inst: CharacterInstance, character_data: CharacterData) -> void:
	character = character_inst
	data = character_data
	current_hp = character.current_hp if character.current_hp > 0 else character.stats.max_hp
	is_dead = false
	# Aplica o SpriteFrames configurado no CharacterData (anims/FPS editaveis
	# no editor). Substitui o SpriteFrames placeholder do .tscn.
	_apply_sprite_sheet()
	if _hp_bar != null and _hp_bar.has_method("set_hp"):
		_hp_bar.set_hp(current_hp, character.stats.max_hp)
	_apply_attack_timer()

# Aplica o SpriteFrames do CharacterData no AnimatedSprite2D. As anims
# (idle/walk/attack) e suas FPS sao configuradas no editor, dentro do
# .tres do personagem.
func _apply_sprite_sheet() -> void:
	if data == null or _animated_sprite == null:
		return
	if data.sprite_frames == null:
		_animated_sprite.visible = false
		push_warning("PlayerWorld: %s nao tem sprite_frames configurado" % data.id)
		return
	_animated_sprite.sprite_frames = data.sprite_frames
	_animated_sprite.scale = Vector2(data.sprite_scale, data.sprite_scale)
	_animated_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_animated_sprite.visible = true
	# Toca idle se essa anim existir, senao a primeira disponivel.
	var first_anim: StringName = &"idle"
	if not data.sprite_frames.has_animation(first_anim):
		var names: PackedStringArray = data.sprite_frames.get_animation_names()
		if names.is_empty():
			return
		first_anim = StringName(names[0])
	_animated_sprite.play(first_anim)

func _apply_attack_timer() -> void:
	if character == null:
		return
	var spd: float = character.stats.attack_speed
	if spd <= 0.0:
		_attack_timer.wait_time = ATTACK_PERIOD_FALLBACK
	else:
		# attack_speed eh "ataques/seg". period = 1/spd.
		_attack_timer.wait_time = max(0.25, 1.0 / spd)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	match _state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.MOVING_TO_POINT:
			_step_toward(_move_target_pos)
			if global_position.distance_to(_move_target_pos) < 4.0:
				_state = State.IDLE
				velocity = Vector2.ZERO
		State.MOVING_TO_TARGET:
			if not is_instance_valid(_target) or _target.get("is_dead"):
				_target = null
				_state = State.IDLE
				return
			var target_pos: Vector2 = (_target as Node2D).global_position
			if global_position.distance_to(target_pos) <= ATTACK_RANGE:
				_enter_combat_state()
				return
			_step_toward(target_pos)
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

# Movimento direto linear toward `target`. Move_and_slide resolve colisoes
# com obstaculos. Sem pathfinding por enquanto (suficiente pro prototype
# sem corredores). NavigationAgent2D fica no .tscn pra usar quando os
# cenarios ficarem mais complexos.
func _step_toward(target: Vector2) -> void:
	var to_target: Vector2 = target - global_position
	if to_target.length() < 4.0:
		velocity = Vector2.ZERO
		return
	velocity = to_target.normalized() * MOVE_SPEED
	if _animated_sprite != null and velocity.x != 0:
		_animated_sprite.flip_h = velocity.x < 0

# Sincroniza AnimatedSprite2D com o estado atual. Chamado a cada physics tick.
func _update_animation() -> void:
	if _animated_sprite == null or _animated_sprite.sprite_frames == null:
		return
	var desired: StringName = &"idle"
	match _state:
		State.IDLE:
			desired = &"idle"
		State.MOVING_TO_POINT, State.MOVING_TO_TARGET:
			desired = &"walk"
		State.COMBAT:
			desired = &"attack"
	if _animated_sprite.animation != desired:
		_animated_sprite.play(desired)

# Click no chao — anda livre, sem combat engaja.
func move_to_point(world_pos: Vector2) -> void:
	if is_dead:
		return
	_target = null
	_attack_timer.stop()
	_move_target_pos = world_pos
	_state = State.MOVING_TO_POINT

# Click no inimigo — caminha ate ele e troca pra combat ao chegar em range.
func set_target(enemy: Node) -> void:
	if is_dead or enemy == null:
		return
	_target = enemy
	_state = State.MOVING_TO_TARGET
	# Se ja em range, entra direto em combat sem 1 tick walking.
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

# API chamada por inimigos quando atacam o player.
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
	died.emit()
