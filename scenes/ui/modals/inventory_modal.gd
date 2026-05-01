extends ModalBase

const SLOT_SCENE: PackedScene = preload("res://scenes/ui/modals/inventory_slot.tscn")
const COLUMNS: int = 4

@onready var summary_row: Label = $Center/Panel/Margin/Box/Content/SummaryRow
@onready var grid: GridContainer = $Center/Panel/Margin/Box/Content/Grid

func _ready() -> void:
	title_text = "Inventory"
	super._ready()
	EventBus.active_character_changed.connect(_refresh_if_visible)
	EventBus.character_inventory_changed.connect(_refresh_if_visible)

func _on_open() -> void:
	_refresh()

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	for child in grid.get_children():
		child.queue_free()
	var character := GameState.get_active_character()
	if character == null:
		summary_row.text = "No active character."
		return
	title_label.text = "Inventory: %s" % character.display_name()
	var slots: int = character.max_inventory_slots()
	var entries: Array = character.get_inventory_entries()
	summary_row.text = "Used %d / %d slots" % [entries.size(), slots]
	grid.columns = COLUMNS
	for i in slots:
		var slot := SLOT_SCENE.instantiate()
		grid.add_child(slot)
		if i < entries.size():
			slot.set_item(entries[i]["item"], entries[i]["qty"])
		else:
			slot.set_empty()
