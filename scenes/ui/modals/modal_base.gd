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
	# Animacao juicy padrao de aparicao (fade + scale do panel).
	# Usa o panel container como alvo pra o scale parecer com pop centralizado.
	Juicy.modal_appear(self, panel)
	_on_open()

func close() -> void:
	# Early return se ja invisivel — evita disparar tween de disappear
	# sobre um modal escondido, cujo callback `t.finished -> visible=false`
	# pode rodar DEPOIS de um open() concorrente e bagunçar tudo.
	if not visible:
		return
	# Animacao juicy de desaparecimento, depois esconde de fato.
	var t: Tween = Juicy.modal_disappear(self, panel)
	if t != null:
		t.finished.connect(func(): visible = false)
	else:
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
