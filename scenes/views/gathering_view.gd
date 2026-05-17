extends Control

# Gathering view (Fase 01 / Bloco B - placeholder).
# 3 cards (Mining/Woodcutting/Fishing). Apenas 1 ativa por vez por enquanto.
# Multi-skill paralelo chega na Fase 02.

const SKILL_MINING: StringName = &"mining"
const SKILL_WOODCUTTING: StringName = &"woodcutting"
const SKILL_FISHING: StringName = &"fishing"

@onready var mining_progress: ProgressBar = $Margin/Box/Skills/MiningCard/MiningMargin/MiningBox/MiningProgress
@onready var mining_button: Button = $Margin/Box/Skills/MiningCard/MiningMargin/MiningBox/MiningButton
@onready var mining_stats: Label = $Margin/Box/Skills/MiningCard/MiningMargin/MiningBox/MiningStats

@onready var wood_progress: ProgressBar = $Margin/Box/Skills/WoodcuttingCard/WoodMargin/WoodBox/WoodProgress
@onready var wood_button: Button = $Margin/Box/Skills/WoodcuttingCard/WoodMargin/WoodBox/WoodButton
@onready var wood_stats: Label = $Margin/Box/Skills/WoodcuttingCard/WoodMargin/WoodBox/WoodStats

@onready var fish_progress: ProgressBar = $Margin/Box/Skills/FishingCard/FishMargin/FishBox/FishProgress
@onready var fish_button: Button = $Margin/Box/Skills/FishingCard/FishMargin/FishBox/FishButton
@onready var fish_stats: Label = $Margin/Box/Skills/FishingCard/FishMargin/FishBox/FishStats

var _session: GatheringSession
# Per-skill counters (placeholder de mastery + total coletado).
var _collected_count: Dictionary = {
	SKILL_MINING: 0,
	SKILL_WOODCUTTING: 0,
	SKILL_FISHING: 0,
}
var _mastery_count: Dictionary = {
	SKILL_MINING: 0,
	SKILL_WOODCUTTING: 0,
	SKILL_FISHING: 0,
}

func _ready() -> void:
	_session = GatheringSession.new()
	add_child(_session)
	_session.cycle_completed.connect(_on_cycle_completed)
	_session.session_started.connect(_on_session_started)
	_session.session_stopped.connect(_on_session_stopped)
	mining_button.pressed.connect(func(): _toggle_skill(SKILL_MINING))
	wood_button.pressed.connect(func(): _toggle_skill(SKILL_WOODCUTTING))
	fish_button.pressed.connect(func(): _toggle_skill(SKILL_FISHING))
	_refresh_stats()

func _process(_delta: float) -> void:
	if _session == null or not _session.is_running():
		return
	var p: float = _session.get_progress()
	match _session.get_active_skill():
		SKILL_MINING:
			mining_progress.value = p
		SKILL_WOODCUTTING:
			wood_progress.value = p
		SKILL_FISHING:
			fish_progress.value = p

func _toggle_skill(skill_id: StringName) -> void:
	if _session.is_running() and _session.get_active_skill() == skill_id:
		_session.stop()
	else:
		_session.start(skill_id)

func _on_session_started(skill_id: StringName) -> void:
	_refresh_buttons(skill_id)
	# Reset progress bars das outras pra zero.
	if skill_id != SKILL_MINING:
		mining_progress.value = 0.0
	if skill_id != SKILL_WOODCUTTING:
		wood_progress.value = 0.0
	if skill_id != SKILL_FISHING:
		fish_progress.value = 0.0

func _on_session_stopped() -> void:
	_refresh_buttons(&"")
	mining_progress.value = 0.0
	wood_progress.value = 0.0
	fish_progress.value = 0.0

func _on_cycle_completed(skill_id: StringName, dropped_item: ItemData, qty: int) -> void:
	# Mastery sobe sempre que tenta coletar (independente de drop).
	_mastery_count[skill_id] = int(_mastery_count[skill_id]) + 1
	if dropped_item != null and qty > 0:
		_collected_count[skill_id] = int(_collected_count[skill_id]) + qty
	_refresh_stats()

func _refresh_buttons(active: StringName) -> void:
	mining_button.text = "Parar" if active == SKILL_MINING else "Iniciar"
	wood_button.text = "Parar" if active == SKILL_WOODCUTTING else "Iniciar"
	fish_button.text = "Parar" if active == SKILL_FISHING else "Iniciar"

func _refresh_stats() -> void:
	mining_stats.text = "Coletado: %d  |  Mastery: %d" % [
		int(_collected_count[SKILL_MINING]),
		int(_mastery_count[SKILL_MINING]),
	]
	wood_stats.text = "Coletado: %d  |  Mastery: %d" % [
		int(_collected_count[SKILL_WOODCUTTING]),
		int(_mastery_count[SKILL_WOODCUTTING]),
	]
	fish_stats.text = "Coletado: %d  |  Mastery: %d" % [
		int(_collected_count[SKILL_FISHING]),
		int(_mastery_count[SKILL_FISHING]),
	]
