extends Control

# Codex view (Fase 01).
# Hub minimo de subsecoes. Hoje so o Bestiario funciona; outras subsecoes
# (Materiais, NPCs, Zonas, Receitas, Cards, Pets) abrem nas fases seguintes.

@onready var bestiary_btn: Button = $Margin/Box/ButtonsRow/BestiaryBtn

func _ready() -> void:
	bestiary_btn.pressed.connect(_on_bestiary_pressed)

func _on_bestiary_pressed() -> void:
	EventBus.modal_requested.emit(&"bestiary")
