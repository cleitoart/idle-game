class_name Crafting
extends RefCounted

# Helper de Crafting (Fase 01 / Bloco B - placeholder).
#
# Receitas vivem como constantes aqui por enquanto. Em Fase 02+, viram
# `RecipeData` Resources em `data/recipes/` carregados de disco e
# referenciam `01_design/crafting-catalog.md`.
#
# Hoje craft e' INSTANTANEO. Timer + fila de craft entra na Fase 02.

# Cada receita: {id, name, station, inputs[{item_id, qty}], output{item_id, qty}}.
const RECIPES_SMELTING: Array = [
	{
		"id": "smelt_copper_bar",
		"name": "Copper Bar",
		"inputs": [{"item_id": "copper_ore", "qty": 2}],
		"output": {"item_id": "copper_bar", "qty": 1},
	},
]

const RECIPES_SMITHING: Array = [
	{
		"id": "smith_bronze_sword",
		"name": "Bronze Sword",
		"inputs": [
			{"item_id": "copper_bar", "qty": 2},
			{"item_id": "pine_log", "qty": 1},
		],
		"output": {"item_id": "bronze_sword", "qty": 1},
	},
]

# Verifica se o personagem ativo tem todos os inputs disponiveis.
static func can_craft(recipe: Dictionary) -> bool:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		return false
	for input in recipe.get("inputs", []):
		var have: int = character.get_item_qty(StringName(String(input["item_id"])))
		if have < int(input["qty"]):
			return false
	return true

# Executa o craft: consome inputs, adiciona output. Retorna true se sucedeu.
static func craft(recipe: Dictionary) -> bool:
	if not can_craft(recipe):
		return false
	var character: CharacterInstance = GameState.get_active_character()
	# Consumir inputs via API publica de inventory (slot-indexed).
	for input in recipe.get("inputs", []):
		var item_id_str: String = String(input["item_id"])
		var qty_needed: int = int(input["qty"])
		var input_item: ItemData = _resolve_item(item_id_str)
		if input_item != null:
			character.remove_item(input_item, qty_needed)
	# Adicionar output.
	var output: Dictionary = recipe.get("output", {})
	var output_item: ItemData = _resolve_item(String(output["item_id"]))
	if output_item == null:
		return false
	var output_qty: int = int(output["qty"])
	GameState.add_item_to_character(character, output_item, output_qty)
	# Notificar UI do consumo de inputs (add_item_to_character ja emite).
	EventBus.character_inventory_changed.emit(character)
	BattleLog.add("[Craft] +%d %s" % [output_qty, output_item.display_name], &"craft")
	return true

# Helper: descreve a receita em texto pra UI.
static func describe_inputs(recipe: Dictionary) -> String:
	var parts: Array[String] = []
	for input in recipe.get("inputs", []):
		var item_id: String = String(input["item_id"])
		var qty: int = int(input["qty"])
		var item: ItemData = _resolve_item(item_id)
		var name: String = item.display_name if item != null else item_id
		parts.append("%dx %s" % [qty, name])
	return ", ".join(parts)

static func describe_output(recipe: Dictionary) -> String:
	var output: Dictionary = recipe.get("output", {})
	var item: ItemData = _resolve_item(String(output["item_id"]))
	var name: String = item.display_name if item != null else String(output["item_id"])
	return "%dx %s" % [int(output["qty"]), name]

static func _resolve_item(id: String) -> ItemData:
	return ItemRegistry.get_by_id(StringName(id))
