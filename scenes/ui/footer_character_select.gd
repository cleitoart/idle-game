extends MarginContainer

const PICK_BUTTON_SCENE: PackedScene = preload("res://scenes/ui/character_pick_button.tscn")

@onready var title_label: Label = $Box/TitleLabel
@onready var list: HBoxContainer = $Box/List

func _ready() -> void:
	EventBus.active_character_changed.connect(_on_active_character_changed)
	_refresh()

func _refresh() -> void:
	for child in list.get_children():
		child.queue_free()
	title_label.text = "Select Character"
	for i in GameState.owned_characters.size():
		var character: CharacterInstance = GameState.owned_characters[i]
		var btn: Button = PICK_BUTTON_SCENE.instantiate()
		list.add_child(btn)
		btn.bind(i, character, i == GameState.active_character_index)
		btn.picked.connect(_on_picked)
	if GameState.owned_characters.is_empty():
		var note := Label.new()
		note.text = "No characters available."
		list.add_child(note)

func _on_picked(index: int) -> void:
	GameState.set_active_character(index)

func _on_active_character_changed(_character: CharacterInstance) -> void:
	_refresh()
