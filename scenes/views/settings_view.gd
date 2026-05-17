extends Control

@onready var hp_numbers_check: CheckBox = $Margin/Box/HpNumbersCheck
@onready var save_now_btn: Button = $Margin/Box/SaveNowBtn
@onready var backup_btn: Button = $Margin/Box/BackupManualBtn
@onready var save_status_label: Label = $Margin/Box/SaveStatusLabel

func _ready() -> void:
	hp_numbers_check.button_pressed = GameState.is_show_enemy_hp_numbers_enabled()
	hp_numbers_check.toggled.connect(_on_hp_numbers_toggled)
	save_now_btn.pressed.connect(_on_save_now)
	backup_btn.pressed.connect(_on_backup_manual)
	EventBus.save_completed.connect(_on_save_completed)
	EventBus.save_failed.connect(_on_save_failed)

func _on_hp_numbers_toggled(pressed: bool) -> void:
	GameState.set_show_enemy_hp_numbers(pressed)

func _on_save_now() -> void:
	SaveManager.save_game()

func _on_backup_manual() -> void:
	var path: String = SaveManager.backup_manual()
	if path == "":
		save_status_label.text = "Backup falhou (sem save existente?)"
		save_status_label.modulate = Color(0.95, 0.55, 0.55)
	else:
		save_status_label.text = "Backup criado: %s" % path
		save_status_label.modulate = Color(0.6, 0.85, 0.6)

func _on_save_completed() -> void:
	if not is_visible_in_tree():
		return
	save_status_label.text = "Save completo."
	save_status_label.modulate = Color(0.6, 0.85, 0.6)

func _on_save_failed(reason: String) -> void:
	if not is_visible_in_tree():
		return
	save_status_label.text = "Save falhou: %s" % reason
	save_status_label.modulate = Color(0.95, 0.55, 0.55)
