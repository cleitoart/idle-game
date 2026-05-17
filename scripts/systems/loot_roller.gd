class_name LootRoller
extends RefCounted

class Drop:
	var item: ItemData
	var qty: int
	func _init(p_item: ItemData, p_qty: int) -> void:
		item = p_item
		qty = p_qty

# TODO Fase 02+: modular `entry.chance` por:
#   - `player.loot_gain_pct` (modificador global de loot)
#   - `player.material_drop_chance_pct` se entry.item.item_type == MATERIAL
#   - `player.equip_drop_chance_pct` se entry.item.slot_type != NONE
#   - tier base da raridade (ver `02_math/drop-rates.md` tabela base)
#   - pity Mythic threshold 100 (decisao #8)
# Hoje a chance e' flat conforme declarado no LootEntry.
static func roll(enemy: EnemyData) -> Array:
	var drops: Array = []
	if enemy == null:
		return drops
	for entry in enemy.loot_table:
		if entry == null or entry.item == null:
			continue
		if randf() <= entry.chance:
			var qty: int = randi_range(entry.qty_min, max(entry.qty_min, entry.qty_max))
			if qty > 0:
				drops.append(Drop.new(entry.item, qty))
	return drops

static func roll_gold(enemy: EnemyData) -> int:
	if enemy == null:
		return 0
	if enemy.gold_max <= 0:
		return 0
	return randi_range(enemy.gold_min, max(enemy.gold_min, enemy.gold_max))
