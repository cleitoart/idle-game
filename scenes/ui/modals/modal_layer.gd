extends CanvasLayer

const MODAL_CHARACTER: StringName = &"character"
const MODAL_MAP: StringName = &"map"
const MODAL_INVENTORY: StringName = &"inventory"

@onready var character_modal: ModalBase = $CharacterModal
@onready var map_modal: ModalBase = $MapModal
@onready var inventory_modal: ModalBase = $InventoryModal

func _ready() -> void:
	EventBus.modal_requested.connect(_on_modal_requested)

func _on_modal_requested(modal_id: StringName) -> void:
	_close_all()
	match modal_id:
		MODAL_CHARACTER:
			character_modal.open()
		MODAL_MAP:
			map_modal.open()
		MODAL_INVENTORY:
			inventory_modal.open()

func _close_all() -> void:
	character_modal.close()
	map_modal.close()
	inventory_modal.close()
