extends PanelContainer

# Footer reconstruido a partir de psd-files/footer_export/ (PSD do usuario).
# Layout absoluto: cada elemento tem offsets fixos relativos ao canvas do
# footer. Cobre portrait, name+level, HP/MP/EXP bars, ATK/DEF/SPD stats e
# 8 skill slots (4x2).
#
# NodePaths atualizados em 2026-05-07. Battle log button e toggle char/shared
# foram REMOVIDOS no design novo do PSD — se voltarem, ver historico do
# footer.tscn anterior. EventBus.battle_log_toggle_requested continua
# existindo; precisa de outro disparador (ex: header de combate).

@onready var canvas: Control = $Canvas
@onready var portrait: TextureRect = $Canvas/Portrait
# Fill interno do portrait. So este recebe a cor do personagem — o PNG do
# slot (com a borda dourada) fica intacto.
@onready var portrait_fill: ColorRect = $Canvas/Portrait/PortraitFill
@onready var name_label: Label = $Canvas/CharNameLabel
@onready var level_label: Label = $Canvas/CharLevelLabel

@onready var hp_bar: ProgressBar = $Canvas/ResourcesPanel/HpHolder/HpBar
@onready var hp_trail_bar: ProgressBar = $Canvas/ResourcesPanel/HpHolder/HpTrailBar
@onready var hp_value: Label = $Canvas/ResourcesPanel/HpHolder/HpValue
@onready var mp_bar: ProgressBar = $Canvas/ResourcesPanel/MpHolder/MpBar
@onready var mp_value: Label = $Canvas/ResourcesPanel/MpHolder/MpValue
@onready var xp_bar: ProgressBar = $Canvas/ResourcesPanel/XpHolder/XpBar
@onready var xp_value: Label = $Canvas/ResourcesPanel/XpHolder/XpValue

@onready var atk_value: Label = $Canvas/MainStatsPanel/AtkValue
@onready var def_value: Label = $Canvas/MainStatsPanel/DefValue
@onready var spd_value: Label = $Canvas/MainStatsPanel/SpdValue

@onready var skill_slots_root: Control = $Canvas/SkillSlots

# Trail bar tunables — mesmo vibe do combat HpBar.
const HP_TRAIL_DELAY: float = 0.05
const HP_TRAIL_DURATION: float = 0.22
const HP_TRAIL_BLINK_PHASE: float = 0.07
const HP_TRAIL_RED: Color = Color(0.78, 0.32, 0.30, 1.0)
const HP_TRAIL_WHITE: Color = Color(0.92, 0.92, 0.86, 1.0)

var _hp_trail_tween: Tween
var _hp_trail_blink_tween: Tween
var _hp_trail_fill_style: StyleBoxFlat

func _ready() -> void:
	# Duplicate do trail style para nao afetar outros StyleBoxes.
	var trail_orig: StyleBoxFlat = hp_trail_bar.get_theme_stylebox("fill") as StyleBoxFlat
	if trail_orig != null:
		_hp_trail_fill_style = trail_orig.duplicate()
		hp_trail_bar.add_theme_stylebox_override("fill", _hp_trail_fill_style)
	EventBus.active_character_changed.connect(_refresh_active.unbind(1))
	EventBus.character_xp_changed.connect(_refresh_active.unbind(2))
	EventBus.character_hp_changed.connect(_refresh_active.unbind(3))
	EventBus.character_stats_changed.connect(_refresh_active.unbind(1))
	EventBus.character_leveled_up.connect(_refresh_active.unbind(2))
	_refresh_active()

func _refresh_active() -> void:
	var character := GameState.get_active_character()
	if character == null:
		name_label.text = "No character"
		level_label.text = ""
		_set_hp(0, 0)
		_set_mp(0, 0)
		_set_xp(0, 100)
		atk_value.text = "-"
		def_value.text = "-"
		spd_value.text = "-"
		portrait_fill.color = Color(0.3, 0.3, 0.3, 1)
		return
	name_label.text = character.display_name()
	level_label.text = "Lv. %d" % character.level
	_set_hp(character.current_hp, character.stats.max_hp)
	_set_mp(character.current_mp, character.stats.max_mp)
	_set_xp(character.current_xp, character.get_xp_to_next_level())
	atk_value.text = "%d" % character.stats.atk
	def_value.text = "%d" % character.stats.def
	spd_value.text = "%.2f" % character.stats.attack_speed
	# Portrait sem sprite ainda — fill colorido SO na area interna; o PNG
	# do slot (borda dourada) fica intacto. Quando tiver retrato real,
	# substitui o ColorRect por um TextureRect filho do Portrait.
	if character.data != null:
		portrait_fill.color = character.data.portrait_color
	else:
		portrait_fill.color = Color(0.3, 0.3, 0.3, 1)

func _set_hp(current: int, maximum: int) -> void:
	var new_max: int = max(1, maximum)
	var new_value: int = clamp(current, 0, maximum)
	# Snap caso max tenha mudado (level up, troca de personagem).
	if int(hp_bar.max_value) != new_max:
		hp_bar.max_value = new_max
		hp_trail_bar.max_value = new_max
		hp_bar.value = new_value
		hp_trail_bar.value = new_value
		_kill_hp_trail_blink()
		hp_value.text = "%d / %d" % [max(0, current), maximum]
		return
	var old_value: float = hp_bar.value
	var damage: float = old_value - new_value
	hp_bar.value = new_value
	hp_value.text = "%d / %d" % [max(0, current), maximum]
	if damage > 0.0:
		# Trail lags atras com cor vermelha + blink branco breve.
		if _hp_trail_tween != null and _hp_trail_tween.is_valid():
			_hp_trail_tween.kill()
		_hp_trail_tween = create_tween()
		_hp_trail_tween.tween_interval(HP_TRAIL_DELAY)
		_hp_trail_tween.tween_property(hp_trail_bar, "value", float(new_value), HP_TRAIL_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_hp_trail_tween.tween_callback(_stop_hp_trail_blink)
		_start_hp_trail_blink()
	else:
		# Heal ou sem mudanca: snap trail no value.
		if _hp_trail_tween != null and _hp_trail_tween.is_valid():
			_hp_trail_tween.kill()
		hp_trail_bar.value = float(new_value)
		_stop_hp_trail_blink()

func _start_hp_trail_blink() -> void:
	if _hp_trail_blink_tween != null and _hp_trail_blink_tween.is_valid():
		_hp_trail_blink_tween.kill()
	if _hp_trail_fill_style == null:
		return
	_hp_trail_blink_tween = create_tween()
	_hp_trail_blink_tween.set_loops()
	_hp_trail_blink_tween.tween_property(_hp_trail_fill_style, "bg_color", HP_TRAIL_WHITE, HP_TRAIL_BLINK_PHASE)
	_hp_trail_blink_tween.tween_property(_hp_trail_fill_style, "bg_color", HP_TRAIL_RED, HP_TRAIL_BLINK_PHASE)

func _stop_hp_trail_blink() -> void:
	if _hp_trail_blink_tween != null and _hp_trail_blink_tween.is_valid():
		_hp_trail_blink_tween.kill()
	if _hp_trail_fill_style != null:
		_hp_trail_fill_style.bg_color = HP_TRAIL_RED

func _kill_hp_trail_blink() -> void:
	_stop_hp_trail_blink()

func _set_mp(current: int, maximum: int) -> void:
	mp_bar.max_value = max(1, maximum)
	mp_bar.value = clamp(current, 0, maximum)
	mp_value.text = "%d / %d" % [max(0, current), maximum]

func _set_xp(current: int, maximum: int) -> void:
	xp_bar.max_value = max(1, maximum)
	xp_bar.value = clamp(current, 0, maximum)
	xp_value.text = "%d / %d" % [max(0, current), maximum]
