class_name WorldController
extends Node

# WorldController (Fase Exploration AQW) — substitui o combat_controller
# antigo. Orquestra:
#   - Load/unload de area scenes via EventBus.area_change_requested.
#   - Spawn de inimigos nos SpawnPoints da area com pool de EnemyData.
#   - Respawn por timer (unix-based pra ignorar pause/time_scale).
#   - Click handling: chao -> player.move_to_point; enemy -> player.set_target.
#   - Auto-combat: apos kill, busca _nearest_alive e seleciona automatico.
#   - Skills automaticas em CD via SkillRuntime quando auto-combat ativo.
#
# Vive como filho da ExplorationView. Recebe ref ao container WorldRoot
# (Node2D onde area scene eh instanciada) via `set_world_root`.

# Toggle pra testar a variante riggada (Skeleton2D + Bone2D + cutout/textura)
# em vez do AnimatedSprite2D original. Se algo quebrar in-game, flip pra
# false e volta ao comportamento legacy sem mexer em mais nada.
const USE_RIGGED_PLAYER: bool = true
const PLAYER_SCENE: PackedScene = preload("res://scenes/world/player_world.tscn")
const PLAYER_SCENE_RIGGED: PackedScene = preload("res://scenes/world/player_world_rigged.tscn")

@export var world_root_path: NodePath  # configurado no .tscn parent

var _world_root: Node2D
var _current_area_data: AreaSceneData
var _current_area_scene: Node = null
var _player: CharacterBody2D = null
var _active_character: CharacterInstance = null
var _spawn_points: Array[SpawnPoint] = []
var _auto_combat: bool = false
var _skill_runtime: SkillRuntime = null

func _ready() -> void:
	if world_root_path != NodePath(""):
		_world_root = get_node_or_null(world_root_path) as Node2D
	EventBus.area_change_requested.connect(_on_area_change_requested)
	EventBus.enemy_clicked.connect(_on_enemy_clicked)
	EventBus.auto_combat_toggled.connect(_on_auto_combat_toggled)
	EventBus.active_character_changed.connect(_on_active_character_changed)
	_active_character = GameState.get_active_character()
	if _active_character != null:
		_skill_runtime = SkillRuntime.new(_active_character)

func set_world_root(root: Node2D) -> void:
	_world_root = root

func _process(_delta: float) -> void:
	_tick_respawns()
	if _auto_combat:
		_tick_auto_combat()
		_tick_auto_skills()

# --- Area loading --------------------------------------------------------

func _on_area_change_requested(area_id: StringName) -> void:
	var area_data: AreaSceneData = _resolve_area_data(area_id)
	if area_data == null:
		push_warning("WorldController: area '%s' nao encontrada" % area_id)
		return
	load_area(area_data)

func load_area(area_data: AreaSceneData) -> void:
	if _world_root == null:
		return
	_current_area_data = area_data
	# Limpa area anterior.
	if _current_area_scene != null and is_instance_valid(_current_area_scene):
		_current_area_scene.queue_free()
	_current_area_scene = null
	_spawn_points.clear()
	# Instancia nova area.
	if area_data.scene == null:
		push_warning("AreaSceneData '%s' sem scene" % area_data.id)
		return
	_current_area_scene = area_data.scene.instantiate()
	_world_root.add_child(_current_area_scene)
	# Coleta spawn points (marker2Ds com script SpawnPoint).
	for node in _current_area_scene.find_children("*", "Marker2D", true, false):
		if node is SpawnPoint:
			_spawn_points.append(node as SpawnPoint)
	# Spawna player no PlayerSpawn da area (Marker2D com nome "PlayerSpawn").
	_spawn_player()
	# Spawna inimigos.
	_spawn_enemies_initial()
	EventBus.area_loaded.emit(area_data)

func _spawn_player() -> void:
	if _player != null and is_instance_valid(_player):
		_player.queue_free()
	var scene: PackedScene = PLAYER_SCENE_RIGGED if USE_RIGGED_PLAYER else PLAYER_SCENE
	_player = scene.instantiate()
	_world_root.add_child(_player)
	# Posicionar no PlayerSpawn marker (procura recursivamente).
	var spawn_marker: Node = _current_area_scene.find_child("PlayerSpawn", true, false)
	if spawn_marker is Node2D:
		_player.global_position = (spawn_marker as Node2D).global_position
	# Setup com character ativo.
	_active_character = GameState.get_active_character()
	if _active_character != null:
		_player.setup(_active_character, _active_character.data)
	_player.died.connect(_on_player_died)

func _spawn_enemies_initial() -> void:
	if _current_area_data == null or _current_area_data.enemies.is_empty():
		return
	var slots: int = min(_spawn_points.size(), _current_area_data.max_concurrent_enemies)
	for i in slots:
		_spawn_at_point(_spawn_points[i])

func _spawn_at_point(point: SpawnPoint) -> void:
	if point == null or point.is_occupied():
		return
	var enemy_data: EnemyData = point.override_enemy
	if enemy_data == null:
		# Sorteia do pool da area.
		var pool: Array[EnemyData] = _current_area_data.enemies
		if pool.is_empty():
			return
		enemy_data = pool[randi() % pool.size()]
	var enemy: Node = point.spawn(enemy_data)
	if enemy != null:
		enemy.defeated.connect(_on_enemy_defeated)

# --- Respawn -------------------------------------------------------------

func _tick_respawns() -> void:
	if _current_area_data == null or _spawn_points.is_empty():
		return
	# Conta vivos.
	var alive: int = 0
	for p in _spawn_points:
		if p.is_occupied():
			alive += 1
	if alive >= _current_area_data.max_concurrent_enemies:
		return
	# Spawna em pontos prontos.
	for p in _spawn_points:
		if alive >= _current_area_data.max_concurrent_enemies:
			break
		if not p.is_occupied() and p.is_ready_to_respawn():
			_spawn_at_point(p)
			alive += 1

# --- Click / target handling ---------------------------------------------

func _on_enemy_clicked(enemy: Node) -> void:
	if _player == null or _player.is_dead or enemy == null:
		return
	if enemy.get("is_dead"):
		return
	_player.set_target(enemy)

# Click no chao vem via World input area, nao via EventBus. ExplorationView
# captura InputEventMouseButton e chama esse metodo.
func handle_ground_click(world_pos: Vector2) -> void:
	if _player == null or _player.is_dead:
		return
	_player.move_to_point(world_pos)

# --- Enemy death ---------------------------------------------------------

func _on_enemy_defeated(enemy: Node, enemy_data: EnemyData) -> void:
	# Drop loot + xp + gold.
	if _active_character != null and enemy_data != null:
		# XP.
		var xp_gain: int = max(1, enemy_data.level * 5)  # placeholder
		GameState.add_xp_to_character(_active_character, xp_gain)
		# Gold (usa helper do LootRoller que cobre o caso gold_max <= 0).
		var gold_gain: int = LootRoller.roll_gold(enemy_data)
		if gold_gain > 0:
			GameState.add_gold(gold_gain)
		# Loot — LootRoller.roll recebe o enemy_data inteiro e retorna Array
		# de LootRoller.Drop (com .item e .qty).
		var drops: Array = LootRoller.roll(enemy_data)
		for drop in drops:
			if drop == null or drop.item == null or drop.qty <= 0:
				continue
			GameState.add_item_to_character(_active_character, drop.item, drop.qty)
		# Bestiary.
		GameState.register_kill_for_character(_active_character, enemy_data)
	# Inicia respawn no spawn point dele.
	var sp: SpawnPoint = enemy.get("spawn_point") as SpawnPoint
	if sp != null:
		sp.notify_enemy_died(_current_area_data.respawn_seconds if _current_area_data else 8.0)
	# Limpa target do player se era esse.
	if _player != null and _player.get_target() == enemy:
		_player.clear_target()

# --- Player death --------------------------------------------------------

func _on_player_died() -> void:
	# Por enquanto so reseta HP — sem regredir stage como era no battle_view.
	if _active_character == null:
		return
	_active_character.current_hp = _active_character.stats.max_hp
	EventBus.character_hp_changed.emit(_active_character, _active_character.current_hp, _active_character.stats.max_hp)
	# Recarrega area atual (reset rapido).
	if _current_area_data != null:
		load_area(_current_area_data)

# --- Auto-combat ---------------------------------------------------------

func _on_auto_combat_toggled(enabled: bool) -> void:
	_auto_combat = enabled

func _tick_auto_combat() -> void:
	if _player == null or _player.is_dead:
		return
	if _player.get_target() != null and is_instance_valid(_player.get_target()):
		var t = _player.get_target()
		if not t.get("is_dead"):
			return  # ja tem alvo vivo
	# Sem alvo (ou alvo morreu): busca nearest alive.
	var nearest: Node = _nearest_alive_enemy(_player.global_position)
	if nearest != null:
		_player.set_target(nearest)

func _nearest_alive_enemy(from: Vector2) -> Node:
	var best: Node = null
	var best_dist: float = INF
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		if enemy.get("is_dead"):
			continue
		var d: float = from.distance_to((enemy as Node2D).global_position)
		if d < best_dist:
			best_dist = d
			best = enemy
	return best

func _tick_auto_skills() -> void:
	if _player == null or _player.is_dead or _active_character == null:
		return
	if _skill_runtime == null:
		return
	var target: Node = _player.get_target()
	for skill in _active_character.equipped_skills:
		if skill == null:
			continue
		if not _skill_runtime.is_ready(skill):
			continue
		# Heal skills sem target — cast em self quando HP < threshold.
		if skill.is_heal:
			if _player.current_hp < int(_active_character.stats.max_hp * 0.5):
				_skill_runtime.try_cast(skill, _player)
		else:
			if target != null and not target.get("is_dead"):
				_skill_runtime.try_cast(skill, target)

# --- Misc helpers --------------------------------------------------------

func _on_active_character_changed(character: CharacterInstance) -> void:
	_active_character = character
	if character != null:
		_skill_runtime = SkillRuntime.new(character)

# Procura por todos os .tres em data/areas/ ate achar id batendo. Cached
# poderia ser feito em GameState futuramente.
func _resolve_area_data(area_id: StringName) -> AreaSceneData:
	var path: String = "res://data/areas/%s.tres" % String(area_id)
	if ResourceLoader.exists(path):
		var res = load(path)
		if res is AreaSceneData:
			return res
	return null

func get_player() -> CharacterBody2D:
	return _player
