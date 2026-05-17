class_name LootEntry
extends Resource

@export var item: ItemData
@export_range(0.0, 1.0, 0.01) var chance: float = 1.0
@export var qty_min: int = 1
@export var qty_max: int = 1
# Tier de raridade do drop. Default Common (alinha com `ItemData.Rarity.COMMON`).
# Em fases posteriores, modula chance via `loot_gain_pct` e o dropt rate base
# da raridade (ver `02_math/drop-rates.md`). Hoje e' so estrutura.
@export var rarity: ItemData.Rarity = ItemData.Rarity.COMMON
