class_name TreeTargetData
extends GatherTargetData

# TreeTargetData (Fase 01 / Bloco B+).
#
# Define um tipo de arvore (birch, pine, oak, etc.) que vira alvo de
# woodcutting no BattleView. Reutiliza a mesma logica de hit/respawn dos
# ore targets — diferenca e' visual: 4 camadas em vez de 2.
#
# Ordem de renderizacao (de tras pra frente):
#   1. base_texture       — raizes/chao (mais atras)
#   2. trunk_texture      — tronco
#   3. leaves_back_texture  — folhagem interna (leaf000 — mais escura/menor)
#   4. leaves_front_texture — folhagem externa (leaf001 — mais clara/maior)
#
# OBS: A ordem de filhos no Node2D define o z-order. Filho 0 atras, filho N
# na frente. O hit anima TRONCO + AMBAS AS FOLHAS (shake+pulse). A base
# fica imovel — vira "toco" quando a arvore cai.
#
# Cada camada tem offset X e Y independente (em pixels da arte original 1x,
# multiplicado por `sprite_scale`). Ajustar no Inspector pra alinhar.
#
# Campos comuns (id, drop_item, eff_req, max_hits, respawn_seconds, level,
# sprite_scale) vivem em `GatherTargetData`.

const TREE_TARGET_SCRIPT: Script = preload("res://scenes/combat/tree_target.gd")

@export_group("Sprites")
@export var base_texture: Texture2D
@export var trunk_texture: Texture2D
# Folhagem traseira (leaf000 — geralmente mais escura, menor area).
@export var leaves_back_texture: Texture2D
# Folhagem frontal (leaf001 — geralmente mais clara, sobreposta a back).
@export var leaves_front_texture: Texture2D

@export_group("Offsets (px @ 1x)")
# Base: chao/raizes — referencia (default 0,0).
@export var base_x_offset_px: float = 0.0
@export var base_y_offset_px: float = 0.0
# Tronco — fica acima da base; default negativo (pra cima).
@export var trunk_x_offset_px: float = 0.0
@export var trunk_y_offset_px: float = -8.0
# Folhagem traseira — bem acima do tronco.
@export var leaves_back_x_offset_px: float = 0.0
@export var leaves_back_y_offset_px: float = -22.0
# Folhagem frontal — geralmente mesma altura que a back (overlaying).
@export var leaves_front_x_offset_px: float = 0.0
@export var leaves_front_y_offset_px: float = -22.0

func instantiate_node() -> Node2D:
	var tree: Node2D = TREE_TARGET_SCRIPT.new()
	tree.data = self
	return tree
