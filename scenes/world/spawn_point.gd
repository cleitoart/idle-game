class_name SpawnPoint
extends Marker2D

# SpawnPoint — Marker2D que hospeda 1 inimigo. Posicionado manualmente na
# area scene. WorldController consulta para popular inimigos no load.
#
# Logica:
#   - spawn(enemy_data): instancia um EnemyWorld nessa posicao.
#   - is_occupied(): retorna true se um EnemyWorld vivo esta como filho.
#   - on_enemy_died(): inicia respawn timer (unix-based pra ignorar pausa).
#
# Override de tipo: se `override_enemy` setado, ignora o pool da area e usa
# este enemy_data especifico (util pra elites/uniques em posicoes fixas).

const ENEMY_SCENE: PackedScene = preload("res://scenes/world/enemy_world.tscn")

# Opcional: trava o tipo de inimigo desse spawn point. Se null, WorldController
# escolhe do pool da area.
@export var override_enemy: EnemyData

var _current_enemy: Node = null
# Unix time em que o respawn ficara pronto. 0 = imediato.
var _respawn_at_unix: float = 0.0

func is_occupied() -> bool:
	return _current_enemy != null and is_instance_valid(_current_enemy)

func is_ready_to_respawn() -> bool:
	if is_occupied():
		return false
	if _respawn_at_unix <= 0.0:
		return true
	return Time.get_unix_time_from_system() >= _respawn_at_unix

# Instancia EnemyWorld na posicao do SpawnPoint. Owner do spawn fica memorizado
# pra start_respawn no died.
func spawn(enemy_data: EnemyData) -> Node:
	if enemy_data == null:
		return null
	if is_occupied():
		return _current_enemy
	var enemy: Node = ENEMY_SCENE.instantiate()
	enemy.global_position = global_position
	enemy.set("spawn_point", self)
	enemy.set("data", enemy_data)
	# Adiciona ao parent — WorldController decidira sob qual node colocar.
	get_parent().add_child(enemy)
	_current_enemy = enemy
	return enemy

func notify_enemy_died(respawn_seconds: float) -> void:
	_current_enemy = null
	_respawn_at_unix = Time.get_unix_time_from_system() + respawn_seconds

func clear() -> void:
	if is_occupied():
		_current_enemy.queue_free()
	_current_enemy = null
	_respawn_at_unix = 0.0
