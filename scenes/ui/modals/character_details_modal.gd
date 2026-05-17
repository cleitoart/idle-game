extends Control

# Modal de Stats Details (Fase 01 / Bloco B+).
# Mostra TODAS as 7 secoes do CombatStats (Primary, Activity Efficiency,
# Combat Extras, Crit & Evasion, Regen & Leech, Elemental, Acquisition,
# Meta). Aberto via botao "Details" no character_modal. Sem botoes "+"
# (somente leitura — alocacao de stats fica no character_modal limpo).

const ZERO_OPACITY: float = 0.4

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Center/Panel
@onready var close_btn: Button = $Center/Panel/Margin/Box/Header/CloseButton

# Primary
@onready var str_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/StrRow
@onready var dex_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/DexRow
@onready var int_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/IntRow
@onready var vit_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/VitRow
@onready var luk_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/LukRow
# Efficiency
@onready var mining_eff_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MiningEffRow
@onready var wood_eff_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/WoodEffRow
@onready var fish_eff_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/FishEffRow
@onready var combat_acc_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/CombatAccuracyRow
# Combat extras
@onready var magic_atk_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MagicAtkRow
@onready var magic_def_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MagicDefRow
@onready var hit_number_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/HitNumberRow
@onready var cast_speed_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/CastSpeedRow
@onready var cdr_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/CdrRow
# Crit & evasion
@onready var crit_chance_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/CritChanceRow
@onready var crit_damage_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/CritDamageRow
@onready var magic_crit_chance_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MagicCritChanceRow
@onready var block_chance_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/BlockChanceRow
@onready var dodge_chance_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/DodgeChanceRow
@onready var hit_chance_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/HitChanceRow
@onready var accuracy_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/AccuracyRow
@onready var extra_hit_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/ExtraHitRow
# Regen
@onready var hp_regen_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/HpRegenRow
@onready var mp_regen_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MpRegenRow
@onready var life_steal_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/LifeStealRow
@onready var mp_leech_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MpLeechRow
# Elemental
@onready var fire_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/FireRow
@onready var ice_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/IceRow
@onready var electric_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/ElectricRow
@onready var water_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/WaterRow
@onready var wind_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/WindRow
@onready var rock_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/RockRow
@onready var light_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/LightRow
@onready var dark_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/DarkRow
# Acquisition + Meta
@onready var exp_gain_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/ExpGainRow
@onready var gold_gain_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/GoldGainRow
@onready var loot_gain_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/LootGainRow
@onready var equip_drop_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/EquipDropRow
@onready var material_drop_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MaterialDropRow
@onready var card_drop_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/CardDropRow
@onready var skill_exp_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/SkillExpRow
@onready var mastery_exp_row: Label = $Center/Panel/Margin/Box/Scroll/StatsBox/MasteryExpRow

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	close_btn.pressed.connect(close)
	backdrop.gui_input.connect(_on_backdrop_input)
	EventBus.character_stats_changed.connect(_refresh_if_visible.unbind(1))
	EventBus.character_leveled_up.connect(_refresh_if_visible.unbind(2))
	EventBus.active_character_changed.connect(_refresh_if_visible.unbind(1))

func open() -> void:
	visible = true
	Juicy.modal_appear(self, panel)
	_refresh()

func close() -> void:
	if not visible:
		return
	var t: Tween = Juicy.modal_disappear(self, panel)
	if t != null:
		t.finished.connect(func(): visible = false)
	else:
		visible = false

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	var character := GameState.get_active_character()
	if character == null:
		return
	var s: CombatStats = character.stats
	# Primary
	_set_int(str_row, "STR", s.str_stat)
	_set_int(dex_row, "DEX", s.dex)
	_set_int(int_row, "INT", s.int_stat)
	_set_int(vit_row, "VIT", s.vit)
	_set_int(luk_row, "LUK", s.luk)
	# Efficiency (computado externo). Bonus de equip futuramente entra aqui.
	_set_int(mining_eff_row, "Mining Efficiency", Efficiency.compute(character, &"mining"))
	_set_int(wood_eff_row, "Woodcutting Efficiency", Efficiency.compute(character, &"woodcutting"))
	_set_int(fish_eff_row, "Fishing Efficiency", Efficiency.compute(character, &"fishing"))
	_set_int(combat_acc_row, "Combat Accuracy", Efficiency.compute(character, &"combat"))
	# Combat extras
	_set_int(magic_atk_row, "Magic ATK", s.magic_atk)
	_set_int(magic_def_row, "Magic DEF", s.magic_def)
	_set_int(hit_number_row, "Hit Number", s.hit_number, 1)
	_set_float(cast_speed_row, "Cast Speed", s.cast_speed, "%.2f", 1.0)
	_set_pct(cdr_row, "Cooldown Reduction", s.cooldown_reduction)
	# Crit & Evasion
	_set_pct(crit_chance_row, "Crit Chance", s.crit_chance)
	_set_float(crit_damage_row, "Crit Damage", s.crit_damage, "%.2fx", 1.5)
	_set_pct(magic_crit_chance_row, "Magic Crit Chance", s.magic_crit_chance)
	_set_pct(block_chance_row, "Block Chance", s.block_chance)
	_set_pct(dodge_chance_row, "Dodge Chance", s.dodge_chance)
	_set_pct(hit_chance_row, "Hit Chance", s.hit_chance, 1.0)
	_set_pct(accuracy_row, "Accuracy", s.accuracy, 1.0)
	_set_pct(extra_hit_row, "Extra Hit", s.extra_hit)
	# Regen & leech
	_set_float(hp_regen_row, "HP Regen", s.hp_regen, "%.1f/s")
	_set_float(mp_regen_row, "MP Regen", s.mp_regen, "%.1f/s")
	_set_pct(life_steal_row, "Life Steal", s.life_steal)
	_set_pct(mp_leech_row, "MP Leech", s.mp_leech)
	# Elemental
	_set_elem(fire_row, "Fire", s.elem_dmg.get("fire", 0.0), s.elem_resist.get("fire", 0.0))
	_set_elem(ice_row, "Ice", s.elem_dmg.get("ice", 0.0), s.elem_resist.get("ice", 0.0))
	_set_elem(electric_row, "Electric", s.elem_dmg.get("electric", 0.0), s.elem_resist.get("electric", 0.0))
	_set_elem(water_row, "Water", s.elem_dmg.get("water", 0.0), s.elem_resist.get("water", 0.0))
	_set_elem(wind_row, "Wind", s.elem_dmg.get("wind", 0.0), s.elem_resist.get("wind", 0.0))
	_set_elem(rock_row, "Rock", s.elem_dmg.get("rock", 0.0), s.elem_resist.get("rock", 0.0))
	_set_elem(light_row, "Light", s.elem_dmg.get("light", 0.0), s.elem_resist.get("light", 0.0))
	_set_elem(dark_row, "Dark", s.elem_dmg.get("dark", 0.0), s.elem_resist.get("dark", 0.0))
	# Acquisition + Meta
	_set_pct(exp_gain_row, "EXP Gain", s.exp_gain_pct / 100.0)
	_set_pct(gold_gain_row, "Gold Gain", s.gold_gain_pct / 100.0)
	_set_pct(loot_gain_row, "Loot Gain", s.loot_gain_pct / 100.0)
	_set_pct(equip_drop_row, "Equip Drop Chance", s.equip_drop_chance_pct / 100.0)
	_set_pct(material_drop_row, "Material Drop Chance", s.material_drop_chance_pct / 100.0)
	_set_pct(card_drop_row, "Card Drop Chance", s.card_drop_chance_pct / 100.0)
	_set_pct(skill_exp_row, "Skill EXP Gain", s.skill_exp_gain_pct / 100.0)
	_set_pct(mastery_exp_row, "Mastery EXP Gain", s.mastery_exp_gain_pct / 100.0)

func _set_int(label: Label, key: String, value: int, neutral: int = 0) -> void:
	label.text = "%s: %d" % [key, value]
	_apply_zero(label, value == neutral)

func _set_float(label: Label, key: String, value: float, fmt: String = "%.2f", neutral: float = 0.0) -> void:
	label.text = "%s: %s" % [key, fmt % value]
	_apply_zero(label, is_equal_approx(value, neutral))

func _set_pct(label: Label, key: String, value: float, neutral: float = 0.0) -> void:
	label.text = "%s: %.1f%%" % [key, value * 100.0]
	_apply_zero(label, is_equal_approx(value, neutral))

func _set_elem(label: Label, name_str: String, dmg: float, res: float) -> void:
	label.text = "%-9s Dmg %.1f%%   Resist %.1f%%" % [name_str, dmg * 100.0, res * 100.0]
	_apply_zero(label, is_equal_approx(dmg, 0.0) and is_equal_approx(res, 0.0))

func _apply_zero(label: Label, is_zero: bool) -> void:
	label.modulate.a = ZERO_OPACITY if is_zero else 1.0

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()
		get_viewport().set_input_as_handled()
