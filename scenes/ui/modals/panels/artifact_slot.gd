class_name ArtifactSlot
extends Control

# Artifact slot reutilizavel pro artifacts panel do character_modal.
#
# Visualmente: TextureRect com `artifact_slot.png` (64x64) como bg fixo +
# TextureRect interno pra icone do artifact. Quantity nao se aplica
# (artifacts nao stackam). Visivel apenas quando ha um artifact equipado.
#
# Hover dispara TooltipManager (placeholder ate Fase 04+).

const ARTIFACT_BG_PATH: String = "res://assets/sprites/ui/character_screen/slots/artifact_slot.png"
const ITEM_MARGIN_PX: float = 5.0

@onready var _bg: TextureRect = $Bg
@onready var _icon: TextureRect = $Bg/IconMargin/Icon

var _artifact: ItemData
var _hover_active: bool = false

# NOTA: artifacts NAO podem ser movidos pelo player. Cada um fica no seu slot
# fixo (populado via drops/quests/sistemas futuros). Sem drag/drop wiring.
# Slots so aparecem quando ha um artifact equipado (visibility controlada
# pelo character_modal).

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_apply_visual()

func set_artifact(artifact: ItemData) -> void:
	_artifact = artifact
	if is_inside_tree():
		_apply_visual()

func set_empty() -> void:
	_artifact = null
	if is_inside_tree():
		_apply_visual()

func _apply_visual() -> void:
	if _bg == null:
		return
	if _artifact == null:
		_icon.texture = null
		return
	if _artifact.has_method("get_sprite"):
		_icon.texture = _artifact.get_sprite()
	else:
		_icon.texture = _artifact.sprite
	if _icon.texture != null:
		_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

# Tooltip via polling (mesmo padrao do InventorySlotV2).
func _process(_delta: float) -> void:
	if not is_inside_tree() or not is_visible_in_tree():
		if _hover_active:
			_hover_active = false
			TooltipManager.hide_tooltip_if_owner(self)
		return
	var should_show: bool = (
		_artifact != null
		and not DragManager.is_holding()
		and get_global_rect().has_point(get_global_mouse_position())
	)
	if should_show and not _hover_active:
		TooltipManager.show_item_tooltip(_artifact, self)
		_hover_active = true
	elif not should_show and _hover_active:
		TooltipManager.hide_tooltip_if_owner(self)
		_hover_active = false
