class_name GatheringSpotData
extends Resource

# GatheringSpotData (Fase 01 / Bloco B+).
#
# Define um "spot" no mapa: lista de gather targets (ore, tree, fish, etc.)
# a spawnar quando o jogador entra. Por enquanto homogeneo (todos do mesmo
# tipo) mas o array suporta mistura — desde que sejam GatherTargetData.

@export var id: StringName = &""
@export var display_name: String = ""
@export var description: String = ""
# Atividade da skill (mining/woodcutting/fishing/etc.). Define qual eff
# usar em `Efficiency.compute(character, activity)`.
@export var activity: StringName = &"mining"
# Lista dos alvos que aparecem no spot. Maximo recomendado: 5 (layout
# suporta ate isso). Aceita qualquer GatherTargetData (OreTargetData,
# TreeTargetData, etc.) — o controller dispatch via `instantiate_node()`.
@export var targets: Array[GatherTargetData] = []
# Zona onde o spot vive (UI usa pra agrupar). Pode ser StringName livre
# por enquanto (futuramente: ZoneData ref).
@export var zone_id: StringName = &"forest"
@export var level: int = 1
