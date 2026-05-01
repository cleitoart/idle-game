extends MarginContainer

@onready var name_label: Label = $Row/NameBox/NameLabel
@onready var level_label: Label = $Row/NameBox/LevelLabel
@onready var hp_bar: ProgressBar = $Row/HpBox/HpBar
@onready var hp_label: Label = $Row/HpBox/HpLabel
@onready var gold_label: Label = $Row/GoldLabel
@onready var xp_label: Label = $Row/XpLabel
@onready var atk_label: Label = $Row/StatsBox/AtkLabel
@onready var def_label: Label = $Row/StatsBox/DefLabel
@onready var speed_label: Label = $Row/StatsBox/SpeedLabel
@onready var portrait: ColorRect = $Row/Portrait

func _ready() -> void:
	EventBus.gold_changed.connect(_on_gold_changed)
	EventBus.active_character_changed.connect(_on_active_character_changed)
	EventBus.character_xp_changed.connect(_on_character_xp_changed)
	EventBus.character_hp_changed.connect(_on_character_hp_changed)
	_refresh()

func _refresh() -> void:
	_refresh_gold()
	_refresh_active()

func _refresh_gold() -> void:
	gold_label.text = "Gold: %d" % GameState.gold

func _refresh_active() -> void:
	var character := GameState.get_active_character()
	if character == null:
		name_label.text = "No active character"
		level_label.text = ""
		hp_bar.max_value = 1
		hp_bar.value = 0
		hp_label.text = "0 / 0"
		xp_label.text = "EXP: 0"
		atk_label.text = "ATK: -"
		def_label.text = "DEF: -"
		speed_label.text = "Speed: -"
		portrait.color = Color(0.3, 0.3, 0.3, 1)
		return
	name_label.text = character.display_name()
	level_label.text = "Lv. %d" % character.level
	_set_hp(character.current_hp, character.stats.max_hp)
	xp_label.text = "EXP: %d" % character.current_xp
	atk_label.text = "ATK: %d" % character.stats.atk
	def_label.text = "DEF: %d" % character.stats.def
	speed_label.text = "Speed: %.2f / s" % character.stats.attack_speed
	if character.data != null:
		portrait.color = character.data.portrait_color

func _set_hp(current: int, maximum: int) -> void:
	hp_bar.max_value = max(1, maximum)
	hp_bar.value = clamp(current, 0, maximum)
	hp_label.text = "HP %d / %d" % [max(0, current), maximum]

func _on_gold_changed(_amount: int) -> void:
	_refresh_gold()

func _on_active_character_changed(_character: CharacterInstance) -> void:
	_refresh_active()

func _on_character_xp_changed(character: CharacterInstance, current_xp: int) -> void:
	if character != GameState.get_active_character():
		return
	xp_label.text = "EXP: %d" % current_xp

func _on_character_hp_changed(character: CharacterInstance, current_hp: int, max_hp: int) -> void:
	if character != GameState.get_active_character():
		return
	_set_hp(current_hp, max_hp)
