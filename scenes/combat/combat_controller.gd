extends Node

const COMBATANT_SCENE: PackedScene = preload("res://scenes/combat/combatant.tscn")

const PLAYER_COLOR: Color = Color(0.30, 0.55, 0.85)
const ENEMY_COLOR: Color = Color(0.55, 0.80, 0.45)

const RESPAWN_DELAY: float = 0.6
const XP_PER_ENEMY_LEVEL: int = 5

@export var enemy_slot: NodePath
@export var player_slot: NodePath

var _enemy_slot_node: Node
var _player_slot_node: Node
var _player: Combatant
var _enemy: Combatant
var _current_enemy_data: EnemyData
var _active_character: CharacterInstance

signal enemy_changed(enemy: Combatant, data: EnemyData)
signal player_changed(player: Combatant, character: CharacterInstance)

func _ready() -> void:
	_enemy_slot_node = get_node(enemy_slot)
	_player_slot_node = get_node(player_slot)
	EventBus.active_character_changed.connect(_on_active_character_changed)
	_active_character = GameState.get_active_character()
	if _active_character != null:
		_rebuild_for_character()

func _on_active_character_changed(character: CharacterInstance) -> void:
	if character == _active_character:
		return
	_active_character = character
	_rebuild_for_character()

func _rebuild_for_character() -> void:
	_clear_combatants()
	if _active_character == null:
		return
	_spawn_player()
	_spawn_enemy()
	EventBus.character_stage_changed.emit(_active_character, _active_character.current_stage)

func _clear_combatants() -> void:
	if _player != null:
		_player.queue_free()
		_player = null
	if _enemy != null:
		_enemy.queue_free()
		_enemy = null
	_current_enemy_data = null

func _spawn_player() -> void:
	var character := _active_character
	if character == null:
		return
	_player = COMBATANT_SCENE.instantiate()
	_player_slot_node.add_child(_player)
	var data := character.data
	var color: Color = data.portrait_color if data != null else PLAYER_COLOR
	var sheet: Texture2D = data.get_sprite_sheet() if data != null else null
	var frame_size: Vector2i = Vector2i(data.sprite_frame_width, data.sprite_frame_height) if data != null else Vector2i.ZERO
	var frame_count: int = data.sprite_frame_count if data != null else 0
	var sprite_scale: int = data.sprite_scale if data != null else 1
	var sprite_fps: float = data.sprite_fps if data != null else 6.0
	_player.setup(character.display_name(), character.stats, color, sheet, frame_size, frame_count, sprite_scale, sprite_fps)
	if character.current_hp > 0 and character.current_hp < character.stats.max_hp:
		_player.current_hp = character.current_hp
		_player.hp_bar.set_hp(character.current_hp, character.stats.max_hp)
	_player.attack_ready.connect(_on_player_attack)
	_player.died.connect(_on_player_died)
	_player.hp_changed.connect(_on_player_hp_changed)
	player_changed.emit(_player, character)

func _spawn_enemy() -> void:
	if _active_character == null:
		return
	var stage: StageData = _active_character.current_stage
	if stage == null or stage.enemy_pool.is_empty():
		return
	var data: EnemyData = stage.enemy_pool[randi() % stage.enemy_pool.size()]
	_current_enemy_data = data
	_enemy = COMBATANT_SCENE.instantiate()
	_enemy_slot_node.add_child(_enemy)
	var stats := CombatStats.from_enemy(data)
	var sheet: Texture2D = data.get_sprite_sheet()
	var frame_size: Vector2i = Vector2i(data.sprite_frame_width, data.sprite_frame_height)
	_enemy.setup(
		"%s [LVL %d]" % [data.display_name, data.level],
		stats,
		ENEMY_COLOR,
		sheet,
		frame_size,
		data.sprite_frame_count,
		data.sprite_scale,
		data.sprite_fps
	)
	_enemy.attack_ready.connect(_on_enemy_attack)
	_enemy.died.connect(_on_enemy_died)
	enemy_changed.emit(_enemy, data)

func _on_player_attack(_attacker: Combatant) -> void:
	if _enemy == null or _enemy.is_dead:
		return
	_enemy.take_damage(_player.stats.atk)

func _on_enemy_attack(_attacker: Combatant) -> void:
	if _player == null or _player.is_dead:
		return
	_player.take_damage(_enemy.stats.atk)

func _on_player_hp_changed(current: int, _max_hp: int) -> void:
	if _active_character != null:
		_active_character.current_hp = current
		EventBus.character_hp_changed.emit(_active_character, current, _active_character.stats.max_hp)

func _on_enemy_died(enemy: Combatant) -> void:
	var data := _current_enemy_data
	var character := _active_character
	GameState.add_gold(LootRoller.roll_gold(data))
	for drop in LootRoller.roll(data):
		GameState.add_item_to_character(character, drop.item, drop.qty)
	if character != null and data != null:
		GameState.add_xp_to_character(character, data.level * XP_PER_ENEMY_LEVEL)
	GameState.register_kill_for_character(character, data)
	enemy.queue_free()
	_enemy = null
	_current_enemy_data = null
	await get_tree().create_timer(RESPAWN_DELAY).timeout
	if is_inside_tree():
		_spawn_enemy()

func _on_player_died(_player_combatant: Combatant) -> void:
	if _enemy != null:
		_enemy.stop()
	await get_tree().create_timer(RESPAWN_DELAY).timeout
	if not is_inside_tree():
		return
	if _player != null:
		_player.heal_full()
		if _active_character != null:
			_active_character.current_hp = _player.current_hp
	if _enemy != null:
		_enemy.heal_full()

func get_player_combatant() -> Combatant:
	return _player

func get_enemy_combatant() -> Combatant:
	return _enemy

func get_current_enemy_data() -> EnemyData:
	return _current_enemy_data
