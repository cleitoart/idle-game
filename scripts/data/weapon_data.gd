class_name WeaponData
extends ItemData

# WeaponData — extende ItemData com campos de renderizacao in-world.
# Usada pelo PlayerWorldRigged para popular o Sprite2D "weapon" do rig
# dinamicamente baseado na arma equipada.
#
# Convencao de pivot: bottom-right da textura no node origin. Ajustes finos
# (cabo deslocado, etc.) via world_offset. World_rotation e' somado ao
# rotation base do node weapon no .tscn (rest pose da mao). World_scale
# multiplica o tamanho final.

@export_group("World visual")
@export var world_sprite: Texture2D
@export var world_offset: Vector2 = Vector2.ZERO
@export var world_rotation: float = 0.0
@export var world_scale: float = 1.0

# Retorna a textura in-world (fallback: sprite do inventory).
func get_world_sprite() -> Texture2D:
	if world_sprite != null:
		return world_sprite
	return sprite
