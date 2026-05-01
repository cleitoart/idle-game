class_name LootEntry
extends Resource

@export var item: ItemData
@export_range(0.0, 1.0, 0.01) var chance: float = 1.0
@export var qty_min: int = 1
@export var qty_max: int = 1
