class_name CombatStats
extends Resource

# How much each invested stat point contributes. Tweak here to retune the
# value of a single level-up point across the whole game.
#
# DEPRECATED (HP/MP/ATK/DEF/ATK_SPEED): a Fase B+ migra spending para
# atributos primarios (STR/DEX/INT/VIT/LUK). Estes constants ficam pra
# saves antigos com pontos investidos nos antigos stats continuarem
# valendo. UI nova nao expoe spend nestes.
const HP_PER_POINT: int = 5
const MP_PER_POINT: int = 2
const ATK_PER_POINT: int = 1
const DEF_PER_POINT: int = 1
const ATK_SPEED_PER_POINT: float = 0.05

# Atributos primarios (Fase B+): cada ponto investido contribui pra derived
# stats conforme a formula confirmada com o usuario.
const STR_PER_POINT_ATK: int = 1            # +1 ATK por ponto de Strength
const DEX_PER_POINT_SPD: float = 0.02       # +0.02 attack_speed por ponto de Dexterity
const INT_PER_POINT_MATK: int = 1           # +1 magic_atk por ponto de Intelligence
const VIT_PER_POINT_HP: int = 5             # +5 max_hp por ponto de Vitality
const LUK_PER_POINT_CRIT: float = 0.005     # +0.5% crit_chance por ponto de Luck

@export var max_hp: int = 1
@export var max_mp: int = 0
@export var atk: int = 0
@export var def: int = 0
@export var attack_speed: float = 1.0

# --- Expansao da Fase 0 (decisao Fase 0 / roadmap secao 3.2) ----------------
# Todos os campos abaixo comecam zerados. So sao populados via equip/skill/
# encantamento/awakening em fases posteriores. UI esconde stats em zero ate
# que tenham significado real para o jogador (progressive reveal).

# Stats primarios (STR/DEX/INT/VIT/LUK). Sufixo "_stat" em str/int para evitar
# colisao com keywords do GDScript.
@export var str_stat: int = 0
@export var dex: int = 0
@export var int_stat: int = 0
@export var vit: int = 0
@export var luk: int = 0

# Stats derivados de combate alem do quinteto base.
@export var magic_atk: int = 0
@export var magic_def: int = 0
@export var hit_number: int = 1  # quantos hits por golpe; 1 = ataque normal
@export var cast_speed: float = 1.0
@export var cooldown_reduction: float = 0.0  # 0..1 (% reducao de cooldown)

# Regen e leech.
@export var hp_regen: float = 0.0  # HP/s
@export var mp_regen: float = 0.0  # MP/s
@export var life_steal: float = 0.0  # 0..1 (% do dano causado virando HP)
@export var mp_leech: float = 0.0   # 0..1

# Chance e precisao.
@export var crit_chance: float = 0.0       # 0..1
@export var magic_crit_chance: float = 0.0 # 0..1
@export var crit_damage: float = 1.5       # multiplicador (1.5 = 150%)
@export var block_chance: float = 0.0
@export var dodge_chance: float = 0.0
@export var hit_chance: float = 1.0  # base; reduzido por accuracy gap em zonas avancadas
@export var accuracy: float = 1.0
@export var extra_hit: float = 0.0   # chance adicional de proc de golpe extra
# Resistencia a status: status_id (StringName) -> 0..1. Vazio = sem resist.
@export var resist_status: Dictionary = {}

# Stats elementais (decisao #13: ZERADOS na base; vem de equip/skill).
@export var elem_dmg: Dictionary = {
	"fire": 0.0, "ice": 0.0, "electric": 0.0, "water": 0.0,
	"wind": 0.0, "rock": 0.0, "light": 0.0, "dark": 0.0,
}
@export var elem_resist: Dictionary = {
	"fire": 0.0, "ice": 0.0, "electric": 0.0, "water": 0.0,
	"wind": 0.0, "rock": 0.0, "light": 0.0, "dark": 0.0,
}

# Aquisicao (modificadores % em ganhos do mundo).
@export var exp_gain_pct: float = 0.0
@export var gold_gain_pct: float = 0.0
@export var loot_gain_pct: float = 0.0
@export var equip_drop_chance_pct: float = 0.0
@export var material_drop_chance_pct: float = 0.0
@export var card_drop_chance_pct: float = 0.0

# Meta (afetam progressao de skills nao-combate e mastery).
@export var skill_exp_gain_pct: float = 0.0
@export var mastery_exp_gain_pct: float = 0.0

# Accepts the CharacterInstance directly so it can layer in stat-point bonuses
# on top of base + weapon. Backwards-compatible with callers that still pass a
# CharacterData (data-only path skips the bonuses).
static func from_character(source) -> CombatStats:
	if source is CharacterInstance:
		return _from_instance(source)
	if source is CharacterData:
		return _from_data_only(source)
	push_warning("CombatStats.from_character: unsupported source type")
	return CombatStats.new()

static func _from_instance(inst: CharacterInstance) -> CombatStats:
	var data: CharacterData = inst.data
	var s: CombatStats = _from_data_only(data)
	# Bonuses de TODOS os slots equipados (armas, armaduras, acessorios,
	# ferramentas). Iteracao uniforme: sem casos especiais por slot.
	# Bug fix Fase B+: starting_weapon NAO eh pre-baked em _from_data_only.
	# Equipar/desequipar a starting_weapon agora produz a diferenca correta
	# em ATK/SPD. Player sem weapon == base stats sem bonus de arma.
	for slot in CharacterInstance.EQUIP_SLOTS:
		var item: ItemData = inst.get_equipment(slot)
		if item == null:
			continue
		s.atk += item.bonus_atk
		s.attack_speed += item.bonus_attack_speed
		s.def += item.bonus_def
		s.max_hp += item.bonus_max_hp
		s.max_mp += item.bonus_max_mp
	# Stat-point bonuses.
	var b: Dictionary = inst.stat_bonus
	# DEPRECATED stats antigos (HP/MP/ATK/DEF/ATK_SPEED) — saves antigos com
	# pontos investidos seguem aplicando. Nova UI nao mais expoe spend neles.
	s.max_hp += int(b.get(CharacterInstance.STAT_HP, 0)) * HP_PER_POINT
	s.max_mp += int(b.get(CharacterInstance.STAT_MP, 0)) * MP_PER_POINT
	s.atk    += int(b.get(CharacterInstance.STAT_ATK, 0)) * ATK_PER_POINT
	s.def    += int(b.get(CharacterInstance.STAT_DEF, 0)) * DEF_PER_POINT
	s.attack_speed += float(b.get(CharacterInstance.STAT_ATTACK_SPEED, 0)) * ATK_SPEED_PER_POINT
	# Atributos primarios (Fase B+): incrementam o stat raw + aplicam derived.
	var inv_str: int = int(b.get(CharacterInstance.STAT_STR, 0))
	var inv_dex: int = int(b.get(CharacterInstance.STAT_DEX, 0))
	var inv_int: int = int(b.get(CharacterInstance.STAT_INT, 0))
	var inv_vit: int = int(b.get(CharacterInstance.STAT_VIT, 0))
	var inv_luk: int = int(b.get(CharacterInstance.STAT_LUK, 0))
	# Stat raw (UI le direto do s.str_stat etc).
	s.str_stat += inv_str
	s.dex      += inv_dex
	s.int_stat += inv_int
	s.vit      += inv_vit
	s.luk      += inv_luk
	# Derived (formula confirmada com o usuario).
	s.atk          += inv_str * STR_PER_POINT_ATK
	s.attack_speed += float(inv_dex) * DEX_PER_POINT_SPD
	s.magic_atk    += inv_int * INT_PER_POINT_MATK
	s.max_hp       += inv_vit * VIT_PER_POINT_HP
	s.crit_chance  += float(inv_luk) * LUK_PER_POINT_CRIT
	# Skill tree bonuses (Fase 01 / Bloco B).
	SkillTree.apply_bonuses(inst, s)
	return s

static func _from_data_only(data: CharacterData) -> CombatStats:
	var s := CombatStats.new()
	if data == null:
		return s
	# Base quinteto + arma inicial.
	s.max_hp = data.base_hp
	s.max_mp = data.base_mp
	s.atk = data.base_atk
	s.def = data.base_def
	s.attack_speed = data.base_attack_speed
	# NOTA: starting_weapon NAO eh somado aqui mais. O equipamento ativo
	# (incluindo a starting_weapon, que CharacterInstance.create() ja equipa)
	# eh somado em _from_instance via loop em EQUIP_SLOTS. Isto garante que
	# desequipar a arma realmente subtrai os bonuses dela.
	# B0: popular todos os stats expandidos a partir do CharacterData.
	# Primary
	s.str_stat = data.base_str
	s.dex = data.base_dex
	s.int_stat = data.base_int
	s.vit = data.base_vit
	s.luk = data.base_luk
	# Combat derived
	s.magic_atk = data.base_magic_atk
	s.magic_def = data.base_magic_def
	s.hit_number = data.base_hit_number
	s.cast_speed = data.base_cast_speed
	s.cooldown_reduction = data.base_cooldown_reduction
	# Regen & leech
	s.hp_regen = data.base_hp_regen
	s.mp_regen = data.base_mp_regen
	s.life_steal = data.base_life_steal
	s.mp_leech = data.base_mp_leech
	# Crit & evasion
	s.crit_chance = data.base_crit_chance
	s.magic_crit_chance = data.base_magic_crit_chance
	s.crit_damage = data.base_crit_damage
	s.block_chance = data.base_block_chance
	s.dodge_chance = data.base_dodge_chance
	s.hit_chance = data.base_hit_chance
	s.accuracy = data.base_accuracy
	s.extra_hit = data.base_extra_hit
	# Elementais (decisao #13: defaults zero, mas dado tem campos pra override)
	s.elem_dmg = {
		"fire": data.base_fire_dmg,
		"ice": data.base_ice_dmg,
		"electric": data.base_electric_dmg,
		"water": data.base_water_dmg,
		"wind": data.base_wind_dmg,
		"rock": data.base_rock_dmg,
		"light": data.base_light_dmg,
		"dark": data.base_dark_dmg,
	}
	s.elem_resist = {
		"fire": data.base_fire_resist,
		"ice": data.base_ice_resist,
		"electric": data.base_electric_resist,
		"water": data.base_water_resist,
		"wind": data.base_wind_resist,
		"rock": data.base_rock_resist,
		"light": data.base_light_resist,
		"dark": data.base_dark_resist,
	}
	# Aquisicao + meta
	s.exp_gain_pct = data.base_exp_gain_pct
	s.gold_gain_pct = data.base_gold_gain_pct
	s.loot_gain_pct = data.base_loot_gain_pct
	s.equip_drop_chance_pct = data.base_equip_drop_chance_pct
	s.material_drop_chance_pct = data.base_material_drop_chance_pct
	s.card_drop_chance_pct = data.base_card_drop_chance_pct
	s.skill_exp_gain_pct = data.base_skill_exp_gain_pct
	s.mastery_exp_gain_pct = data.base_mastery_exp_gain_pct
	return s

static func from_enemy(data: EnemyData) -> CombatStats:
	var s := CombatStats.new()
	s.max_hp = data.hp
	s.atk = data.atk
	s.def = data.def
	s.attack_speed = data.attack_speed
	return s
