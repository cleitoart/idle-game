extends VBoxContainer

@onready var bar: ProgressBar = $Bar
@onready var label: Label = $Label

func set_hp(current: int, maximum: int) -> void:
	bar.max_value = max(1, maximum)
	bar.value = clamp(current, 0, maximum)
	label.text = "%d / %d" % [max(0, current), maximum]
