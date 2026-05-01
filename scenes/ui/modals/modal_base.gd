class_name ModalBase
extends Control

@export var title_text: String = "Modal"

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Center/Panel
@onready var title_label: Label = $Center/Panel/Margin/Box/Header/TitleLabel
@onready var content_host: Node = $Center/Panel/Margin/Box/Content
@onready var close_button: Button = $Center/Panel/Margin/Box/Header/CloseButton

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.gui_input.connect(_on_backdrop_input)
	close_button.pressed.connect(close)
	if title_label != null:
		title_label.text = title_text

func open() -> void:
	visible = true
	_on_open()

func close() -> void:
	visible = false
	_on_close()

func _on_open() -> void:
	pass

func _on_close() -> void:
	pass

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()
		get_viewport().set_input_as_handled()
