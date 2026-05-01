class_name ItemData
extends Resource

enum ItemType { MATERIAL, WEAPON, CONSUMABLE }

@export var id: StringName = &""
@export var display_name: String = ""
@export var description: String = ""
@export var stackable: bool = true
@export var item_type: ItemType = ItemType.MATERIAL
@export var bonus_atk: int = 0
@export var bonus_attack_speed: float = 0.0
