extends PanelContainer

@onready var name_label: Label = $Margin/Box/NameLabel
@onready var qty_label: Label = $Margin/Box/QtyLabel

func set_empty() -> void:
	name_label.text = "Empty"
	qty_label.text = ""

func set_item(item: ItemData, qty: int) -> void:
	if item == null:
		set_empty()
		return
	name_label.text = item.display_name
	qty_label.text = "x%d" % qty
