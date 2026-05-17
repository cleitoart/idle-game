extends NavigationRegion2D

# Auto-bake do NavigationPolygon na entrada da scene. Usado em areas pra
# evitar manter polygons/vertices hand-coded no .tscn.
#
# Workflow esperado em novas areas:
#   1. NavigationRegion2D com NavigationPolygon
#   2. NavigationPolygon define apenas `outlines`, `agent_radius`, e
#      `parsed_geometry_type = 1` (STATIC_COLLIDERS) pra incluir walls +
#      obstacles no carving
#   3. Attach este script no NavigationRegion2D
#   4. Obstaculos: StaticBody2D + CollisionShape2D (suficiente — o
#      parsed_geometry_type captura). NavigationObstacle2D opcional pra
#      controle explicito de carving.
#
# Aguarda 1 physics frame antes do bake pra garantir que os siblings
# StaticBody2D ja foram registrados no NavigationServer.

func _ready() -> void:
	await get_tree().physics_frame
	bake_navigation_polygon(false)
	# Forca sync do navigation map pra queries de path funcionarem
	# no proximo frame sem race condition.
	await get_tree().physics_frame
