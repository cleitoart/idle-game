extends Node

const DEFAULT_MAX_MESSAGES: int = 100

# Tunables exposed as variables instead of constants so a future Settings UI
# (or a save migration) can rewire them without touching this file.
var max_messages: int = DEFAULT_MAX_MESSAGES
var show_timestamps: bool = false  # hook for future Settings toggle

# entry shape: { text: String, kind: StringName, timestamp: float }
var messages: Array = []

func add(text: String, kind: StringName = &"generic") -> void:
	if text.is_empty():
		return
	var entry: Dictionary = {
		"text": text,
		"kind": kind,
		"timestamp": Time.get_unix_time_from_system(),
	}
	messages.append(entry)
	while messages.size() > max_messages:
		messages.pop_front()
	EventBus.battle_log_added.emit(entry)

func clear() -> void:
	messages.clear()
	EventBus.battle_log_cleared.emit()

func get_messages() -> Array:
	return messages.duplicate()

func set_max_messages(n: int) -> void:
	max_messages = max(1, n)
	while messages.size() > max_messages:
		messages.pop_front()

func set_show_timestamps(b: bool) -> void:
	show_timestamps = b

# --- Formatting helpers (keep templates in one place) -----------------------

func log_damage_dealt(attacker: String, target: String, dmg: int) -> void:
	add("%s causou %d de dano em %s" % [attacker, dmg, target], &"damage_dealt")

func log_damage_received(target: String, attacker: String, dmg: int) -> void:
	add("%s recebeu %d de dano de %s" % [target, dmg, attacker], &"damage_received")

func log_skill_used(actor: String, skill_name: String, target: String) -> void:
	if target.is_empty():
		add("%s usou %s" % [actor, skill_name], &"skill")
	else:
		add("%s usou %s em %s" % [actor, skill_name, target], &"skill")

func log_kill(killer: String, victim: String) -> void:
	add("%s derrotou %s" % [killer, victim], &"kill")

func log_xp_gained(actor: String, xp: int) -> void:
	add("%s recebeu %d EXP" % [actor, xp], &"xp")

func log_gold_gained(actor: String, gold_amount: int) -> void:
	add("%s recebeu %d gold" % [actor, gold_amount], &"gold")

func log_level_up(actor: String, new_level: int) -> void:
	add("%s subiu para nivel %d" % [actor, new_level], &"level_up")

func log_wave_cleared(wave_number: int) -> void:
	add("Wave %d concluida" % wave_number, &"wave")
