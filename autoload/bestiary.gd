extends Node

# Bestiary - autoload de tracking de kills (Fase 01 / B1).
#
# Conta kills por inimigo de forma GLOBAL (somatorio entre todos os
# personagens do roster). Tambem mantem lista de "discovered" — inimigos
# vistos pelo menos 1 vez. Inimigos nao descobertos aparecem como "?????"
# na UI ate o jogador ter encontrado/derrotado.
#
# Fase 01: so tracking + visualizacao. Sem buffs.
# Fase 02-03 (Mob Slaughter): marcos de 10/100/1k/10k/100k/1M kills
# desbloqueiam buffs permanentes, info adicional do bestiario, etc.

# Mapeamento enemy_id (StringName) -> total de kills (int).
var kills_by_enemy: Dictionary = {}
# Lista de inimigos descobertos (vistos ao menos 1 vez).
var discovered_enemies: Array[StringName] = []

# --- Public API ----------------------------------------------------------

func register_kill(enemy_data: EnemyData) -> void:
	if enemy_data == null or enemy_data.id == &"":
		return
	var id: StringName = enemy_data.id
	kills_by_enemy[id] = int(kills_by_enemy.get(id, 0)) + 1
	if not discovered_enemies.has(id):
		discovered_enemies.append(id)
	EventBus.bestiary_updated.emit(id, kills_by_enemy[id])

func get_kills(enemy_id: StringName) -> int:
	return int(kills_by_enemy.get(enemy_id, 0))

func is_discovered(enemy_id: StringName) -> bool:
	return discovered_enemies.has(enemy_id)

func get_all_discovered() -> Array[StringName]:
	return discovered_enemies.duplicate()

# Total de kills somando TODOS inimigos. Util pra Selos / achievements globais.
func get_total_kills() -> int:
	var total: int = 0
	for v in kills_by_enemy.values():
		total += int(v)
	return total

# --- Save integration ---------------------------------------------------

# Serializa em formato amigavel ao JSON (chaves String).
func serialize() -> Dictionary:
	var kills_dict: Dictionary = {}
	for id in kills_by_enemy.keys():
		kills_dict[String(id)] = int(kills_by_enemy[id])
	var discovered_arr: Array = []
	for id in discovered_enemies:
		discovered_arr.append(String(id))
	return {
		"kills": kills_dict,
		"discovered": discovered_arr,
	}

func deserialize(data: Dictionary) -> void:
	kills_by_enemy.clear()
	discovered_enemies.clear()
	var kills_dict: Dictionary = data.get("kills", {})
	for k in kills_dict.keys():
		kills_by_enemy[StringName(k)] = int(kills_dict[k])
	var discovered_arr: Array = data.get("discovered", [])
	for k in discovered_arr:
		var sn: StringName = StringName(k)
		if not discovered_enemies.has(sn):
			discovered_enemies.append(sn)
