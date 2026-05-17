class_name Player
extends Combatant

# DEPRECATED (Fase Exploration AQW). Use `player_world.gd`. Stub pra parse.

# Mantemos esse fallback path so pra evitar erro no .gd que carregava na
# Fase B+ (fallback VFX). PlayerWorld vai migrar pra outro mecanismo de VFX.
const FALLBACK_VFX_PATH: String = "res://assets/sprites/effects/punch_vfx000.png"
