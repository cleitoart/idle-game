class_name ToolData
extends ItemData

# ToolData — extende ItemData com campos de renderizacao in-world. Espelha
# WeaponData (mesma estrutura) mas separada pra type-tagging semantico:
# pickaxes, axes, fishing rods, scythes, etc.
#
# Convencao de pivot: bottom-right da textura no node origin (mesma do
# WeaponData). Ajustes finos via world_offset. World_rotation e' somado
# ao rotation base do node de render do rig. World_scale multiplica.
#
# Render runtime: o PlayerWorldRigged faz duck-typing nos campos world_*,
# entao qualquer subclasse com esses campos funciona automaticamente.

@export_group("World visual")
@export var world_sprite: Texture2D
@export var world_offset: Vector2 = Vector2.ZERO
@export var world_rotation: float = 0.0
@export var world_scale: float = 1.0

func get_world_sprite() -> Texture2D:
	if world_sprite != null:
		return world_sprite
	return sprite
