extends Node

const WARRIOR_DATA_PATH: String = "res://data/characters/warrior.tres"

var owned_characters: Array[CharacterInstance] = []
var active_character_index: int = 0
var gold: int = 0

func _ready() -> void:
	var warrior_data: CharacterData = load(WARRIOR_DATA_PATH)
	if warrior_data != null:
		owned_characters.append(CharacterInstance.create(warrior_data))
	call_deferred("_emit_initial_state")

func _emit_initial_state() -> void:
	EventBus.gold_changed.emit(gold)
	var active: CharacterInstance = get_active_character()
	if active != null:
		EventBus.active_character_changed.emit(active)

func get_active_character() -> CharacterInstance:
	if owned_characters.is_empty():
		return null
	if active_character_index < 0 or active_character_index >= owned_characters.size():
		return null
	return owned_characters[active_character_index]

func set_active_character(index: int) -> void:
	if index < 0 or index >= owned_characters.size():
		return
	active_character_index = index
	var active: CharacterInstance = get_active_character()
	if active != null:
		EventBus.active_character_changed.emit(active)

func add_gold(amount: int) -> void:
	if amount <= 0:
		return
	gold += amount
	EventBus.gold_changed.emit(gold)

func add_item_to_character(character: CharacterInstance, item: ItemData, qty: int) -> int:
	if character == null:
		return 0
	var added: int = character.add_item(item, qty)
	if added > 0:
		EventBus.character_inventory_changed.emit(character)
	return added

func add_xp_to_character(character: CharacterInstance, xp: int) -> void:
	if character == null or xp <= 0:
		return
	character.add_xp(xp)
	EventBus.character_xp_changed.emit(character, character.current_xp)

func register_kill_for_character(character: CharacterInstance, enemy: EnemyData) -> void:
	if character == null:
		return
	character.register_kill()
	EventBus.enemy_killed.emit(character, enemy)
