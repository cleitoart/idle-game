class_name SkillRuntime
extends RefCounted

# SkillRuntime — gerencia cooldowns + aplicacao das skills em runtime.
#
# Usa unix_time pra cooldown (independente de Engine.time_scale). Cada
# caster tem o proprio dicionario de cooldowns indexado por skill_id.
#
# API:
#   SkillRuntime.new(caster: CharacterInstance)
#   is_ready(skill: SkillData) -> bool
#   try_cast(skill: SkillData, target: Node) -> bool
#       Faz validacoes (cd + mp), aplica efeito (damage ou heal), inicia cd.
#       Retorna true se executou.
#   time_until_ready(skill: SkillData) -> float
#       Para UI mostrar cooldown progress.

var _caster: CharacterInstance
# skill_id -> ready_at_unix_seconds
var _cooldowns: Dictionary = {}

func _init(caster: CharacterInstance) -> void:
	_caster = caster

func is_ready(skill: SkillData) -> bool:
	if skill == null:
		return false
	var now: float = Time.get_unix_time_from_system()
	var ready_at: float = float(_cooldowns.get(skill.id, 0.0))
	return now >= ready_at

func time_until_ready(skill: SkillData) -> float:
	if skill == null:
		return 0.0
	var now: float = Time.get_unix_time_from_system()
	var ready_at: float = float(_cooldowns.get(skill.id, 0.0))
	return max(0.0, ready_at - now)

# target: Node combatant alvo (pode ser null pra self-heal).
# Retorna true se a skill executou (cd OK + mp OK + target valido).
func try_cast(skill: SkillData, target: Node) -> bool:
	if skill == null or _caster == null:
		return false
	if not is_ready(skill):
		return false
	if _caster.current_mp < skill.mp_cost:
		return false
	# Consome MP.
	if skill.mp_cost > 0:
		_caster.current_mp -= skill.mp_cost
	# Aplica efeito.
	if skill.is_heal:
		var heal_amount: int = int(round(_caster.stats.max_hp * skill.heal_mult))
		_caster.current_hp = min(_caster.stats.max_hp, _caster.current_hp + heal_amount)
		EventBus.character_hp_changed.emit(_caster, _caster.current_hp, _caster.stats.max_hp)
	elif target != null and target.has_method("take_damage"):
		var dmg: int = max(1, int(round(_caster.stats.atk * skill.damage_mult)))
		target.take_damage(dmg)
	# Inicia cooldown.
	var now: float = Time.get_unix_time_from_system()
	_cooldowns[skill.id] = now + skill.cooldown_seconds
	EventBus.skill_cast.emit(skill.id, _caster, target)
	return true
