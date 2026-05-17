class_name SkillData
extends Resource

# SkillData (Fase Exploration AQW — placeholder pra auto-combat).
#
# Skills sao a granularidade de a-c-tion em combate auto/manual. Cada skill
# tem damage_mult (multiplicador sobre ATK do caster) ou heal_mult (sobre
# max_hp do caster, quando `is_heal` true), cooldown, e custo de MP.
#
# Skill tree real (com tier/prerequisitos/etc) vem em fase posterior. Por
# enquanto esses .tres servem so pra simular uso automatico em CD.

@export var id: StringName = &""
@export var display_name: String = ""
@export var description: String = ""
# Tipo de efeito.
@export var is_heal: bool = false
# damage_mult: multiplicador sobre atk do caster.
# heal_mult (quando is_heal=true): fracao de max_hp do caster.
@export var damage_mult: float = 1.0
@export var heal_mult: float = 0.0
@export var cooldown_seconds: float = 5.0
@export var mp_cost: int = 0

@export_group("Visual")
@export var icon: Texture2D
@export var vfx_sprite: Texture2D
@export var vfx_pattern: VfxEffect.Pattern = VfxEffect.Pattern.BLINK
@export var vfx_scale: float = 1.5
