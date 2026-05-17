class_name CharacterData
extends Resource

@export var id: StringName = &""
@export var display_name: String = ""
# Class label exibido no hero button da tela Character (linha do meio).
# Default vazio = nao mostra a linha de class no botao. Ex: "Warrior",
# "Wizard", "Mage".
@export var class_label: String = ""
@export var base_hp: int = 10
@export var base_mp: int = 0
@export var base_atk: int = 1
@export var base_def: int = 0
@export var base_attack_speed: float = 1.0
@export var starting_weapon: ItemData
# Fase Exploration AQW: area inicial onde o personagem aparece quando criado.
# Substitui o sistema antigo de starting_zone/starting_stage.
@export var starting_area: AreaSceneData
@export var inventory_max_slots: int = 16
@export var portrait_color: Color = Color(0.30, 0.55, 0.85, 1)

# --- Expansao da Fase 0 / B0 ----------------------------------------------
# Stats da secao 3.2 do roadmap. Cada classe declara seu valor base; equip,
# skill, encantamento etc. somam por cima em fases posteriores.

@export_group("Primary Stats")
@export var base_str: int = 0
@export var base_dex: int = 0
@export var base_int: int = 0
@export var base_vit: int = 0
@export var base_luk: int = 0

@export_group("Combat Derived")
@export var base_magic_atk: int = 0
@export var base_magic_def: int = 0
@export var base_hit_number: int = 1
@export var base_cast_speed: float = 1.0
@export var base_cooldown_reduction: float = 0.0

@export_group("Regen & Leech")
@export var base_hp_regen: float = 0.0
@export var base_mp_regen: float = 0.0
@export var base_life_steal: float = 0.0
@export var base_mp_leech: float = 0.0

@export_group("Crit & Evasion")
@export var base_crit_chance: float = 0.05
@export var base_magic_crit_chance: float = 0.05
@export var base_crit_damage: float = 1.5
@export var base_block_chance: float = 0.0
@export var base_dodge_chance: float = 0.05
@export var base_hit_chance: float = 1.0
@export var base_accuracy: float = 1.0
@export var base_extra_hit: float = 0.0

# Elementais — decisao #13: zerados na base. Equip/skill/encantamento populam.
# Mantidos como campos pra permitir override por personagem em fases
# posteriores (ex: Mage de Fogo pode ter +5% Fire base na proxima fase).
@export_group("Elemental Damage")
@export var base_fire_dmg: float = 0.0
@export var base_ice_dmg: float = 0.0
@export var base_electric_dmg: float = 0.0
@export var base_water_dmg: float = 0.0
@export var base_wind_dmg: float = 0.0
@export var base_rock_dmg: float = 0.0
@export var base_light_dmg: float = 0.0
@export var base_dark_dmg: float = 0.0

@export_group("Elemental Resist")
@export var base_fire_resist: float = 0.0
@export var base_ice_resist: float = 0.0
@export var base_electric_resist: float = 0.0
@export var base_water_resist: float = 0.0
@export var base_wind_resist: float = 0.0
@export var base_rock_resist: float = 0.0
@export var base_light_resist: float = 0.0
@export var base_dark_resist: float = 0.0

@export_group("Acquisition Modifiers")
@export var base_exp_gain_pct: float = 0.0
@export var base_gold_gain_pct: float = 0.0
@export var base_loot_gain_pct: float = 0.0
@export var base_equip_drop_chance_pct: float = 0.0
@export var base_material_drop_chance_pct: float = 0.0
@export var base_card_drop_chance_pct: float = 0.0

@export_group("Meta Modifiers")
@export var base_skill_exp_gain_pct: float = 0.0
@export var base_mastery_exp_gain_pct: float = 0.0

@export_group("Sprite")
# SpriteFrames configurado no editor com anims idle / walk / attack. Cada
# animacao pode ter sua propria FPS, loop e ate textura distinta — toda a
# configuracao visual fica concentrada neste recurso (sem flags duplicados
# de sprite-sheet legado).
@export var sprite_frames: SpriteFrames
# Escala aplicada no AnimatedSprite2D em runtime (multiplica o tamanho dos
# frames). Ajusta o "tamanho fisico" do personagem na tela.
@export var sprite_scale: int = 6

@export_group("Character Image")
# Imagem grande do personagem mostrada no Character Modal (10x scale em UI).
# Se null, fallback pra `default_char_image.png`.
@export var char_image: Texture2D

@export_group("Weapon Hold")
@export var weapon_anchor: Vector2 = Vector2(-28, -6)
@export var weapon_scale: float = 5.0
@export var weapon_rotation_deg: float = 0.0

@export_group("Shadow")
@export var shadow_offset: Vector2 = Vector2.ZERO
@export var shadow_radius: Vector2 = Vector2(46, 8)
@export var shadow_color: Color = Color(0, 0, 0, 0.35)
@export var shadow_pixelize: bool = false
@export var shadow_pixel_size: int = 4

# Imagem grande do personagem (usada no Character Modal). Fallback default
# se nao configurado no .tres do personagem.
func get_char_image() -> Texture2D:
	if char_image != null:
		return char_image
	var fallback: String = "res://assets/sprites/characters/default_char_image.png"
	if ResourceLoader.exists(fallback):
		return load(fallback)
	return null
