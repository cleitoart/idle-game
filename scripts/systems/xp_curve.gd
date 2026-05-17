class_name XpCurve
extends RefCounted

# Tunables. The whole curve can be reshaped by editing these three. Polynomial
# component (level^POW_EXP) keeps progression slow at low levels; exponential
# component (GROWTH^level) makes late-game scale into millions/billions/trillions
# so future ascension/prestige multipliers stay meaningful.
const BASE: float = 10.0
const POW_EXP: float = 2.0
const GROWTH: float = 1.07

# Mob XP grows a touch slower than the requirement curve so passive farming
# of low-level zones never replaces progression — but ascension multipliers
# will eventually make it viable.
const MOB_BASE: float = 5.0
const MOB_POW: float = 1.4
const MOB_GROWTH: float = 1.05

# XP needed to advance from L to L+1.
static func xp_to_next(level: int) -> int:
	var l: float = max(1, level)
	return int(floor(BASE * pow(l, POW_EXP) * pow(GROWTH, l)))

# XP an enemy of `enemy_level` rewards on kill.
static func enemy_xp_reward(enemy_level: int) -> int:
	var l: float = max(1, enemy_level)
	return int(ceil(MOB_BASE * pow(l, MOB_POW) * pow(MOB_GROWTH, l)))
