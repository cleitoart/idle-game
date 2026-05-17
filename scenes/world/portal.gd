class_name Portal
extends Area2D

# Portal — Area2D que disparara troca de area quando o player entrar.
#
# Posicionado nas bordas da scene (left/right edge tipicamente). Quando o
# Player CharacterBody2D entra na area, emite `area_change_requested` no
# EventBus com o `target_area_id`. WorldController escuta e carrega a area
# nova.
#
# Pra uso visual: filho TextureRect/Sprite2D opcional pode mostrar uma seta
# indicando direcao. Aqui so a logica.

@export var target_area_id: StringName = &""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if target_area_id == &"":
		push_warning("Portal at %s sem target_area_id setado" % name)
		return
	# So responde ao player. Inimigos nao acionam portais.
	if not body.is_in_group("player"):
		return
	EventBus.area_change_requested.emit(target_area_id)
