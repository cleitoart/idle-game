class_name CombatStats
extends Resource

@export var max_hp: int = 1
@export var atk: int = 0
@export var def: int = 0
@export var attack_speed: float = 1.0

static func from_character(data: CharacterData) -> CombatStats:
	var s := CombatStats.new()
	s.max_hp = data.base_hp
	s.atk = data.base_atk
	s.def = data.base_def
	s.attack_speed = data.base_attack_speed
	if data.starting_weapon != null:
		s.atk += data.starting_weapon.bonus_atk
		s.attack_speed += data.starting_weapon.bonus_attack_speed
	return s

static func from_enemy(data: EnemyData) -> CombatStats:
	var s := CombatStats.new()
	s.max_hp = data.hp
	s.atk = data.atk
	s.def = data.def
	s.attack_speed = data.attack_speed
	return s
