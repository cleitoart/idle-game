class_name CharacterInstance
extends Resource

const EQUIP_WEAPON: StringName = &"weapon"
const EQUIP_HELMET: StringName = &"helmet"
const EQUIP_ARMOR: StringName = &"armor"
const EQUIP_BOOTS: StringName = &"boots"
const EQUIP_ACCESSORY: StringName = &"accessory"

const EQUIP_SLOTS: Array[StringName] = [
	EQUIP_WEAPON,
	EQUIP_HELMET,
	EQUIP_ARMOR,
	EQUIP_BOOTS,
	EQUIP_ACCESSORY,
]

@export var data: CharacterData
@export var stats: CombatStats
@export var current_hp: int = 0
@export var level: int = 1
@export var current_xp: int = 0
@export var current_stage: StageData
@export var current_stage_kills: int = 0
@export var equipment: Dictionary = {}
@export var inventory: Dictionary = {}
@export var inventory_item_lookup: Dictionary = {}

static func create(character_data: CharacterData) -> CharacterInstance:
	var inst := CharacterInstance.new()
	inst.data = character_data
	if character_data.starting_weapon != null:
		inst.equipment[EQUIP_WEAPON] = character_data.starting_weapon
	inst.stats = CombatStats.from_character(character_data)
	inst.current_hp = inst.stats.max_hp
	inst.current_stage = character_data.starting_stage
	return inst

func id() -> StringName:
	if data == null:
		return &""
	return data.id

func display_name() -> String:
	if data == null:
		return ""
	return data.display_name

func max_inventory_slots() -> int:
	if data == null:
		return 0
	return data.inventory_max_slots

func get_equipment(slot: StringName) -> ItemData:
	return equipment.get(slot, null)

func add_item(item: ItemData, qty: int) -> int:
	if item == null or qty <= 0:
		return 0
	var key: StringName = item.id
	var current: int = inventory.get(key, 0)
	if current == 0 and inventory.size() >= max_inventory_slots():
		return 0
	current += qty
	inventory[key] = current
	inventory_item_lookup[key] = item
	return qty

func get_item_qty(item_id: StringName) -> int:
	return inventory.get(item_id, 0)

func get_item_data(item_id: StringName) -> ItemData:
	return inventory_item_lookup.get(item_id, null)

func get_inventory_entries() -> Array:
	var entries: Array = []
	for key in inventory.keys():
		var qty: int = inventory[key]
		if qty <= 0:
			continue
		var item: ItemData = inventory_item_lookup.get(key, null)
		if item == null:
			continue
		entries.append({"item": item, "qty": qty, "id": key})
	return entries

func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	current_xp += amount

func register_kill() -> void:
	current_stage_kills += 1
