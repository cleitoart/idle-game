class_name OreTargetData
extends GatherTargetData

# OreTargetData (Fase 01 / Bloco B+).
#
# Define um tipo de minerio (cobre, ferro, ouro, etc.) que vira "alvo de
# batalha de coleta" no BattleView.
#
# Cada nó visual e' montado por 2 sprites:
#   - `base_texture` (na camada da frente, igual entre todos os ores)
#   - `cluster_texture` (atras da base, varia por minerio — tinge a cor)
#
# Hit damage = 1 (cada hit reduz `current_hits` em 1). Ao chegar em zero,
# o ore quebra e entra em cooldown de respawn.
#
# Campos comuns (id, drop_item, eff_req, max_hits, respawn_seconds, level,
# sprite_scale) vivem em `GatherTargetData`.

const ORE_TARGET_SCRIPT: Script = preload("res://scenes/combat/ore_target.gd")

@export_group("Sprites")
@export var base_texture: Texture2D
@export var cluster_texture: Texture2D
# Offset vertical do CLUSTER em relacao ao centro do sprite, em pixels da
# arte original (escala 1x). Negativo = pra cima. Aplicado como
# `cluster.position.y = cluster_y_offset_px * sprite_scale`. Defaults pra
# -6 conforme a arte ja exportada (cluster fica acima da base).
# Ajuste manual: editar este valor no .tres no Godot editor.
@export var cluster_y_offset_px: float = -6.0
# Offset HORIZONTAL do cluster (mesma logica). Necessario quando o PNG do
# cluster tem largura diferente da base — Sprite2D centraliza pelo PNG, e
# clusters com PNG de largura diferente da base ficam visualmente
# deslocados. Ajuste por minerio. Default 0.
@export var cluster_x_offset_px: float = 0.0
# Offset vertical da BASE (mesma logica). 0 por padrao — base e' a referencia.
@export var base_y_offset_px: float = 0.0
# Offset horizontal da BASE. Default 0 (base e' a referencia).
@export var base_x_offset_px: float = 0.0

func instantiate_node() -> Node2D:
	var ore: Node2D = ORE_TARGET_SCRIPT.new()
	ore.data = self
	return ore
