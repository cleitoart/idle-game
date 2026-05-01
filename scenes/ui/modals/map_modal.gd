extends ModalBase

@onready var stage_name_row: Label = $Center/Panel/Margin/Box/Content/StageNameRow
@onready var kills_row: Label = $Center/Panel/Margin/Box/Content/KillsRow
@onready var enemies_title: Label = $Center/Panel/Margin/Box/Content/EnemiesTitle
@onready var enemies_box: VBoxContainer = $Center/Panel/Margin/Box/Content/EnemiesBox

func _ready() -> void:
	title_text = "Map"
	super._ready()
	EventBus.active_character_changed.connect(_refresh_if_visible)
	EventBus.character_stage_changed.connect(_refresh_if_visible)
	EventBus.enemy_killed.connect(_refresh_if_visible)

func _on_open() -> void:
	_refresh()

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	for child in enemies_box.get_children():
		child.queue_free()
	var character := GameState.get_active_character()
	if character == null:
		stage_name_row.text = "No active character."
		kills_row.text = ""
		enemies_title.text = ""
		return
	var stage: StageData = character.current_stage
	if stage == null:
		stage_name_row.text = "Location: unknown"
		kills_row.text = "Kills: 0"
		enemies_title.text = ""
		return
	stage_name_row.text = "Location: %s" % stage.display_name
	kills_row.text = "Kills on this stage: %d" % character.current_stage_kills
	enemies_title.text = "Enemies in this area:"
	for enemy_res in stage.enemy_pool:
		var enemy: EnemyData = enemy_res
		if enemy == null:
			continue
		var line := Label.new()
		line.text = "- %s [LVL %d]" % [enemy.display_name, enemy.level]
		enemies_box.add_child(line)
