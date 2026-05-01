extends Control

@onready var stage_label: Label = $Layout/Header/StageLabel
@onready var enemy_label: Label = $Layout/Header/EnemyLabel
@onready var combat_controller: Node = $CombatController

func _ready() -> void:
	EventBus.character_stage_changed.connect(_on_character_stage_changed)
	EventBus.active_character_changed.connect(_on_active_character_changed)
	combat_controller.enemy_changed.connect(_on_enemy_changed)
	_refresh_for_active()
	var existing_enemy: Node = combat_controller.get_enemy_combatant()
	if existing_enemy != null:
		_on_enemy_changed(existing_enemy, combat_controller.get_current_enemy_data())

func _on_active_character_changed(_character: CharacterInstance) -> void:
	_refresh_for_active()

func _on_character_stage_changed(character: CharacterInstance, _stage: StageData) -> void:
	if character == GameState.get_active_character():
		_refresh_for_active()

func _refresh_for_active() -> void:
	var active := GameState.get_active_character()
	if active == null or active.current_stage == null:
		stage_label.text = "Current Stage:"
		enemy_label.text = ""
		return
	stage_label.text = "Current Stage: %s" % active.current_stage.display_name

func _on_enemy_changed(_enemy: Node, data: EnemyData) -> void:
	if data == null:
		enemy_label.text = ""
		return
	enemy_label.text = "%s [LVL %d]" % [data.display_name, data.level]
