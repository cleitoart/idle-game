class_name AreaSceneData
extends Resource

# AreaSceneData (Fase Exploration AQW) — descreve uma area navegavel no mundo.
#
# Cada area tem uma scene .tscn dedicada (com background, NavigationRegion2D,
# obstaculos manuais, SpawnPoints, Portals, Camera limits). O WorldController
# instancia a scene apontada por `scene` quando o player carrega a area.
#
# O pool de `enemies` define quais inimigos podem ser spawnados nos
# SpawnPoints da scene. SpawnPoint individual pode tambem override o tipo
# (campo `enemy_data` no marker), caso contrario sorteia do pool.

@export var id: StringName = &""
@export var display_name: String = ""
@export var scene: PackedScene
@export var enemies: Array[EnemyData] = []
# Quantos inimigos podem estar vivos ao mesmo tempo. Spawn vai parando quando
# atinge o cap; respawn so ocorre quando algum morre.
@export var max_concurrent_enemies: int = 5
# Tempo (segundos reais) entre kill e respawn do mesmo SpawnPoint.
@export var respawn_seconds: float = 8.0
# Texture do fundo (placeholder/cinza pode ser ColorRect na cena, esta linha
# fica opcional pra quando user importar arte real).
@export var background_texture: Texture2D
