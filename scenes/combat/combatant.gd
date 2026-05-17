class_name Combatant
extends VBoxContainer

# DEPRECATED (Fase Exploration AQW). Substituido por player_world.gd /
# enemy_world.gd que sao CharacterBody2D e usam SpriteFrames direto do
# data resource. Stub minimo pra parse compatibility — pode deletar.

signal attack_ready(combatant)
signal died(combatant)
signal hp_changed(current: int, maximum: int)
signal damage_taken(amount: int)
