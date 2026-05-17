extends CanvasLayer

# ModalLayer: orchestrates all modal show/hide based on EventBus.modal_requested.
#
# Fase B+: inventory_modal e char_select_modal foram REMOVIDOS — sua
# funcionalidade foi absorvida pelo character_modal redesenhado (com 5
# paineis incluindo Hero list + Inventory grid).

const MODAL_CHARACTER: StringName = &"character"
const MODAL_MAP: StringName = &"map"
const MODAL_DEV: StringName = &"dev"
const MODAL_BESTIARY: StringName = &"bestiary"
const MODAL_CRAFTING: StringName = &"crafting"
const MODAL_SKILL_TREE: StringName = &"skill_tree"
const MODAL_CHARACTER_DETAILS: StringName = &"character_details"

# Character modal foi rebuildado sem extender ModalBase (estrutura propria
# 1536x1024). Tipado como Control com API duck-typed (open/close).
@onready var character_modal: Control = $CharacterModal
@onready var map_modal: ModalBase = $MapModal
@onready var dev_modal: ModalBase = $DevModal
@onready var bestiary_modal: ModalBase = $BestiaryModal
# Crafting/skill-tree/character-details modais usam estrutura propria.
@onready var crafting_modal: Control = $CraftingModal
@onready var skill_tree_modal: Control = $SkillTreeModal
@onready var character_details_modal: Control = $CharacterDetailsModal
# Offline e AreaResults nao herdam de ModalBase. Abertos via EventBus.
@onready var offline_summary_modal: Control = $OfflineSummaryModal
@onready var area_results_modal: Control = $AreaResultsModal

func _ready() -> void:
	EventBus.modal_requested.connect(_on_modal_requested)
	EventBus.offline_progress_calculated.connect(_on_offline_progress_calculated)
	EventBus.area_cleared.connect(_on_area_cleared)

# Hotkey B: toggle do character modal. Placeholder ate ter input map proprio.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event: InputEventKey = event as InputEventKey
		if key_event.keycode == KEY_B:
			if character_modal.visible:
				character_modal.close()
			else:
				EventBus.modal_requested.emit(MODAL_CHARACTER)
			get_viewport().set_input_as_handled()

func _on_modal_requested(modal_id: StringName) -> void:
	# Modais "stackable" (sobreposicao) — abrem sem fechar os anteriores.
	var stackable: bool = (
		modal_id == MODAL_CHARACTER_DETAILS
		or modal_id == MODAL_SKILL_TREE
	)
	if not stackable:
		_close_all()
	match modal_id:
		MODAL_CHARACTER:
			character_modal.open()
		MODAL_MAP:
			map_modal.open()
		MODAL_DEV:
			dev_modal.open()
		MODAL_BESTIARY:
			bestiary_modal.open()
		MODAL_CRAFTING:
			crafting_modal.open()
		MODAL_SKILL_TREE:
			skill_tree_modal.open()
		MODAL_CHARACTER_DETAILS:
			character_details_modal.open()

func _on_offline_progress_calculated(summary: Dictionary) -> void:
	# Nao reabrir se ja visivel; e ignorar se nao houver characters com ganhos.
	if int(summary.get("delta_t_seconds", 0)) < 60:
		return
	if (summary.get("characters", []) as Array).is_empty():
		return
	_close_all()
	offline_summary_modal.open_with_summary(summary)

func _on_area_cleared(_character: CharacterInstance, summary: Dictionary) -> void:
	# Fase Exploration AQW: area_cleared continua existindo como concept
	# (player matou todos enemies da area, futuro reward bonus etc.). Por
	# enquanto so trackamos last_area_clears por area_id.
	var key: String = String(summary.get("area_id", ""))
	if key == "":
		return
	var previous: Dictionary = GameState.last_area_clears.get(key, {})
	GameState.last_area_clears[key] = summary
	area_results_modal.open_with_summary(summary, previous)

func _close_all() -> void:
	character_modal.close()
	map_modal.close()
	dev_modal.close()
	bestiary_modal.close()
	crafting_modal.close()
	skill_tree_modal.close()
	offline_summary_modal.close()
	area_results_modal.close()
