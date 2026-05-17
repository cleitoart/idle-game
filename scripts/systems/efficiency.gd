class_name Efficiency
extends RefCounted

# Efficiency / Drop Formula (Fase 01 / Bloco B+).
#
# Inspirado no IdleOn MMO. Cada atividade (mining, woodcutting, fishing,
# combat) tem seu pool proprio de "efficiency". Cada alvo (ore_target,
# tree_target, fish_target, enemy) tem um `eff_req` (efficiency required).
#
# Per-hit drop calculation:
#   ratio = eff / eff_req
#   - ratio < 0.05  -> 0% chance (muito fraco; nem dropa)
#   - 0.05 <= ratio < 1.0  -> chance = ratio (linear), qty = 1
#   - ratio >= 1.0  -> chance = 100%, qty = clamp(floor(ratio), 1, 5)
#
# Cap em 5x mantem o late-game progredindo via `eff_req` maior em ores
# avancados, nao via stack infinito de eficiencia.
#
# **Como cada atividade calcula sua eficiencia base** (placeholders ate
# arvore de talentos / picaretas / etc. existirem):
#   - mining: STR + ferramenta_pickaxe.bonus_mining_eff (futuro)
#   - woodcutting: STR + ferramenta_axe.bonus_woodcutting_eff (futuro)
#   - fishing: DEX + ferramenta_fishing_rod.bonus_fishing_eff (futuro)
#   - combat: DEX (precisao) — usado nos enemies, separado de hit_chance.
#
# Em fases posteriores, isto vira data-driven via `efficiency_recipe.gd` ou
# similar — e cada classe tem afinidade base.

const MIN_RATIO_FOR_CHANCE: float = 0.05
const MAX_DROP_MULTIPLIER: int = 5

# IDs canonicos das atividades.
const ACTIVITY_MINING: StringName = &"mining"
const ACTIVITY_WOODCUTTING: StringName = &"woodcutting"
const ACTIVITY_FISHING: StringName = &"fishing"
const ACTIVITY_HARVESTING: StringName = &"harvesting"
const ACTIVITY_COMBAT: StringName = &"combat"

# Calcula a eficiencia atual do personagem em uma atividade.
# Stub conservador — populado por equip/skill/awakening em fases posteriores.
static func compute(character: CharacterInstance, activity: StringName) -> int:
	if character == null:
		return 0
	var s: CombatStats = character.stats
	if s == null:
		return 0
	var base: int = 0
	match activity:
		ACTIVITY_MINING:
			# STR pesado + DEX leve. +5 baseline pra player ter chance minima
			# nos ores T1.
			base = 5 + s.str_stat * 3 + s.dex
			# Bonus de pickaxe equipada.
			var pickaxe: ItemData = character.get_equipment(CharacterInstance.EQUIP_PICKAXE)
			if pickaxe != null:
				base += pickaxe.bonus_mining_efficiency
		ACTIVITY_WOODCUTTING:
			base = 5 + s.str_stat * 2 + s.dex * 2
			var axe: ItemData = character.get_equipment(CharacterInstance.EQUIP_AXE)
			if axe != null:
				base += axe.bonus_woodcutting_efficiency
		ACTIVITY_FISHING:
			base = 5 + s.dex * 3 + s.luk * 2
			var rod: ItemData = character.get_equipment(CharacterInstance.EQUIP_FISHING_ROD)
			if rod != null:
				base += rod.bonus_fishing_efficiency
		ACTIVITY_HARVESTING:
			# Harvesting: STR (forca pra colher rapido) + DEX (precisao
			# pra nao danificar a colheita).
			base = 5 + s.str_stat * 2 + s.dex
			var scythe: ItemData = character.get_equipment(CharacterInstance.EQUIP_SCYTHE)
			if scythe != null:
				base += scythe.bonus_harvesting_efficiency
		ACTIVITY_COMBAT:
			# Precisao de combate — separada de hit_chance/accuracy do
			# CombatStats. Aqui e' o "valor cru" comparado com eff_req do
			# inimigo (nao implementado ainda; futuro).
			base = 5 + s.dex * 2 + s.luk
		_:
			base = 0
	return max(0, base)

# Roll de drop para um hit. Retorna {qty, chance, mult, did_drop}.
#   qty: numero de items que efetivamente dropam (0..MAX_DROP_MULTIPLIER).
#   chance: 0..1, probabilidade que foi rolada.
#   mult: 1..5 (relevante so quando ratio >= 1.0).
#   did_drop: bool, se ouve drop.
static func roll_drop(eff: int, eff_req: int) -> Dictionary:
	if eff_req <= 0:
		return {"qty": 1, "chance": 1.0, "mult": 1, "did_drop": true}
	var ratio: float = float(eff) / float(eff_req)
	if ratio < MIN_RATIO_FOR_CHANCE:
		return {"qty": 0, "chance": 0.0, "mult": 0, "did_drop": false}
	if ratio < 1.0:
		# Sub-cap: chance linear de ratio. Drop, se rolou, vem em qty=1.
		var rolled: bool = randf() < ratio
		return {
			"qty": 1 if rolled else 0,
			"chance": ratio,
			"mult": 1,
			"did_drop": rolled,
		}
	# Sobre-cap: drop garantido com multiplicador inteiro (ate 5x).
	var mult: int = clamp(int(floor(ratio)), 1, MAX_DROP_MULTIPLIER)
	return {
		"qty": mult,
		"chance": 1.0,
		"mult": mult,
		"did_drop": true,
	}

# Helper de UI: descreve a chance/mult em string legivel.
static func describe_chance(eff: int, eff_req: int) -> String:
	if eff_req <= 0:
		return "100%"
	var ratio: float = float(eff) / float(eff_req)
	if ratio < MIN_RATIO_FOR_CHANCE:
		return "Muito fraco (<5%)"
	if ratio < 1.0:
		return "%.0f%%" % (ratio * 100.0)
	var mult: int = clamp(int(floor(ratio)), 1, MAX_DROP_MULTIPLIER)
	return "100%% x%d" % mult
