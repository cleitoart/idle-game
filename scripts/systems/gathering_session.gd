class_name GatheringSession
extends Node

# Sessao de Gathering (Fase 01 / Bloco B - F01.03 placeholder).
#
# Loop simples:
#   1. Personagem ativo escolhe um SKILL (mining/woodcutting/fishing).
#   2. Cada tick (intervalo `cycle_seconds`) tenta uma coleta:
#       a. Anima a barra de progresso de 0 a 1.
#       b. No fim do ciclo, roll de drop conforme `drop_chance` da skill.
#       c. Se drop OK -> add item ao inventario do personagem.
#       d. Mastery xp += 1 (Fase 02 expande).
#   3. Repete enquanto `is_running` for true.
#
# **Sistema de Eficiencia (decisao #15):** ainda nao implementado neste
# placeholder — assumimos eficiencia >= minima (sempre dropa). Vai entrar
# quando os spots reais do mapa forem implementados na fase de assets.
#
# Mastery: por enquanto so mantem contador int. Fase 02 expande pra niveis,
# bonus de drop, etc.

signal cycle_started(skill_id: StringName, cycle_seconds: float)
signal cycle_completed(skill_id: StringName, dropped_item: ItemData, qty: int)
signal session_started(skill_id: StringName)
signal session_stopped()

const SKILL_MINING: StringName = &"mining"
const SKILL_WOODCUTTING: StringName = &"woodcutting"
const SKILL_FISHING: StringName = &"fishing"

# Configuracao de cada skill placeholder. Em Fase 02+ isto vira data-driven
# via SpotData / GatheringMaterial em `data/gathering/`.
const SKILL_CONFIG: Dictionary = {
	SKILL_MINING: {
		"display_name": "Mining",
		"item_id": "copper_ore",
		"cycle_seconds": 4.0,
		"drop_chance": 0.85,
		"qty_min": 1,
		"qty_max": 2,
	},
	SKILL_WOODCUTTING: {
		"display_name": "Woodcutting",
		"item_id": "pine_log",
		"cycle_seconds": 3.5,
		"drop_chance": 0.9,
		"qty_min": 1,
		"qty_max": 2,
	},
	SKILL_FISHING: {
		"display_name": "Fishing",
		"item_id": "river_trout",
		"cycle_seconds": 5.0,
		"drop_chance": 0.7,
		"qty_min": 1,
		"qty_max": 1,
	},
}

var _active_skill: StringName = &""
var _is_running: bool = false
var _elapsed: float = 0.0
var _cycle_seconds: float = 0.0

func is_running() -> bool:
	return _is_running

func get_active_skill() -> StringName:
	return _active_skill

# Fracao 0..1 do ciclo atual (pra ProgressBar).
func get_progress() -> float:
	if not _is_running or _cycle_seconds <= 0.0:
		return 0.0
	return clamp(_elapsed / _cycle_seconds, 0.0, 1.0)

func start(skill_id: StringName) -> bool:
	if not SKILL_CONFIG.has(skill_id):
		return false
	if _is_running:
		stop()
	_active_skill = skill_id
	_cycle_seconds = float(SKILL_CONFIG[skill_id]["cycle_seconds"])
	_elapsed = 0.0
	_is_running = true
	session_started.emit(skill_id)
	cycle_started.emit(skill_id, _cycle_seconds)
	set_process(true)
	return true

func stop() -> void:
	if not _is_running:
		return
	_is_running = false
	_active_skill = &""
	_elapsed = 0.0
	set_process(false)
	session_stopped.emit()

func _process(delta: float) -> void:
	if not _is_running:
		return
	_elapsed += delta
	if _elapsed >= _cycle_seconds:
		_complete_cycle()
		_elapsed = 0.0
		# Inicia proximo ciclo automaticamente (loop continuo).
		cycle_started.emit(_active_skill, _cycle_seconds)

func _complete_cycle() -> void:
	var cfg: Dictionary = SKILL_CONFIG[_active_skill]
	var drop_chance: float = float(cfg["drop_chance"])
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		stop()
		return
	if randf() <= drop_chance:
		var item_id: String = String(cfg["item_id"])
		var item: ItemData = _resolve_item(item_id)
		if item != null:
			var qty: int = randi_range(int(cfg["qty_min"]), int(cfg["qty_max"]))
			GameState.add_item_to_character(character, item, qty)
			cycle_completed.emit(_active_skill, item, qty)
			BattleLog.add("[%s] +%d %s" % [
				cfg["display_name"], qty, item.display_name
			], &"gathering")
			return
	# Drop falhou.
	cycle_completed.emit(_active_skill, null, 0)

func _resolve_item(id: String) -> ItemData:
	return ItemRegistry.get_by_id(StringName(id))
