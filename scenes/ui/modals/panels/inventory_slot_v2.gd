class_name InventorySlotV2
extends Control

# Slot reutilizavel pra inventory + equipment slots (Fase B+).
#
# Visualmente: TextureRect de fundo (varia por raridade) + TextureRect de
# imagem do item dentro + Label de quantidade no canto. Hover dispara o
# TooltipManager.
#
# Estados:
#   - empty (item == null, locked == false): mostra textura "common" vazia.
#   - locked (locked == true): mostra textura "locked", nao responde a hover.
#   - filled (item != null): mostra textura da raridade + sprite + qty.

# Map de raridade -> texture path.
const RARITY_TEXTURES: Dictionary = {
	0: "res://assets/sprites/ui/character_screen/slots/inventory_slot_common.png",
	1: "res://assets/sprites/ui/character_screen/slots/inventory_slot_uncommon.png",
	2: "res://assets/sprites/ui/character_screen/slots/inventory_slot_rare.png",
	3: "res://assets/sprites/ui/character_screen/slots/inventory_slot_epic.png",
	4: "res://assets/sprites/ui/character_screen/slots/inventory_slot_legendary.png",
	5: "res://assets/sprites/ui/character_screen/slots/inventory_slot_mythic.png",
}
const LOCKED_TEXTURE_PATH: String = "res://assets/sprites/ui/character_screen/slots/inventory_slot_locked.png"
const EMPTY_TEXTURE_PATH: String = "res://assets/sprites/ui/character_screen/slots/inventory_slot_common.png"

# Margem (em pixels) do item dentro do slot. Usuario especificou 7px.
const ITEM_MARGIN_PX: float = 7.0

const LOCK_ICON_PATH: String = "res://assets/sprites/ui/character_screen/icons/lock_icon.png"

@onready var _bg: TextureRect = $Bg
@onready var _icon: TextureRect = $Bg/IconMargin/Icon
@onready var _qty_label: Label = $Bg/QtyLabel
@onready var _slot_icon: TextureRect = $Bg/SlotIcon
@onready var _lock_icon: TextureRect = $Bg/LockIcon

var _item: ItemData
var _qty: int = 0
var _locked: bool = false
var _favorited: bool = false
# Polling-based hover state — mouse_entered/exited eh fragil quando o slot
# muda visibilidade ou eh re-criado durante refresh do modal. _process
# checa cursor a cada frame e mantem o tooltip sincronizado.
var _hover_active: bool = false

# Metadata pra drag/drop (setados pelo character_modal):
#   - Modo inventory: slot_index >= 0, equip_slot_id == &""
#   - Modo equipment: equip_slot_id != &"", accept_slot_type definido
var slot_index: int = -1
var equip_slot_id: StringName = &""
var accept_slot_type: int = -1  # ItemData.SlotType (so usado em modo equipment)
var character: CharacterInstance = null

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)
	# Pre-carrega o lock icon (sempre o mesmo, refletindo favorited state).
	if _lock_icon != null and ResourceLoader.exists(LOCK_ICON_PATH):
		_lock_icon.texture = load(LOCK_ICON_PATH)
	_apply_visual()

# API publica.

func set_item(item: ItemData, qty: int, favorited: bool = false) -> void:
	_item = item
	_qty = qty
	_locked = false
	_favorited = favorited
	if is_inside_tree():
		_apply_visual()

func set_empty() -> void:
	_item = null
	_qty = 0
	_locked = false
	_favorited = false
	if is_inside_tree():
		_apply_visual()

func set_locked() -> void:
	_item = null
	_qty = 0
	_locked = true
	_favorited = false
	if is_inside_tree():
		_apply_visual()

# Define o icone decorativo do slot (capacete, peitoral, arma, etc.).
# So aparece quando o slot esta vazio (sem item) e nao locked. Setado pelo
# character_modal em _build_slot_refs com base no slot_id de equipamento.
# Slots de inventory nao chamam isto, entao icone permanece null/invisivel.
func set_slot_icon(tex: Texture2D) -> void:
	if _slot_icon == null:
		return
	_slot_icon.texture = tex
	_slot_icon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if is_inside_tree():
		_apply_visual()

# Internals.

func _apply_visual() -> void:
	if _bg == null:
		return
	if _locked:
		_bg.texture = load(LOCKED_TEXTURE_PATH)
		_icon.texture = null
		_qty_label.visible = false
		if _slot_icon != null:
			_slot_icon.visible = false
		if _lock_icon != null:
			_lock_icon.visible = false
		return
	if _item == null:
		_bg.texture = load(EMPTY_TEXTURE_PATH)
		_icon.texture = null
		_qty_label.visible = false
		# Slot vazio + sem locked: mostra icone decorativo se houver textura
		# definida (so equip slots — inventory slots nao tem icone setado).
		if _slot_icon != null:
			_slot_icon.visible = _slot_icon.texture != null
		# Sem item = sem favorite icon.
		if _lock_icon != null:
			_lock_icon.visible = false
		return
	# Slot ocupado.
	var rarity_path: String = String(RARITY_TEXTURES.get(int(_item.rarity), EMPTY_TEXTURE_PATH))
	_bg.texture = load(rarity_path)
	_icon.texture = _item.get_sprite() if _item.has_method("get_sprite") else _item.sprite
	if _icon.texture != null:
		_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	# Icone decorativo escondido quando ha item equipado.
	if _slot_icon != null:
		_slot_icon.visible = false
	# Lock icon: mostra se favoritado.
	if _lock_icon != null:
		_lock_icon.visible = _favorited and _lock_icon.texture != null
	# Quantidade: so mostra se > 1 e item stackable.
	if _qty > 1 and _item.stackable:
		_qty_label.text = "x%s" % NumberFormat.format_int(_qty)
		_qty_label.visible = true
	else:
		_qty_label.visible = false

# Tooltip via polling: a cada frame, checa cursor vs bbox. Evita os bugs
# de mouse_entered/exited durante refresh do modal (slots toggle visibilidade)
# e garante re-show apos drop sem precisar tirar o mouse do slot.
func _process(_delta: float) -> void:
	# is_visible_in_tree checa a hierarquia inteira (modal fechado tambem
	# desabilita o tooltip dos slots dentro).
	if not is_inside_tree() or not is_visible_in_tree():
		if _hover_active:
			_hover_active = false
			TooltipManager.hide_tooltip_if_owner(self)
		return
	var should_show: bool = (
		not _locked
		and _item != null
		and not DragManager.is_holding()
		and get_global_rect().has_point(get_global_mouse_position())
	)
	if should_show and not _hover_active:
		TooltipManager.show_item_tooltip(_item, self)
		_hover_active = true
	elif not should_show and _hover_active:
		TooltipManager.hide_tooltip_if_owner(self)
		_hover_active = false

func _on_gui_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if not event.pressed:
		return
	if _locked or character == null:
		return
	var btn: int = event.button_index
	# Alt+left -> toggle favorite (bypass DragManager, mutate state direto).
	if btn == MOUSE_BUTTON_LEFT and event.alt_pressed:
		_toggle_favorite()
		accept_event()
		return
	# Construir target base.
	var target: Dictionary = _build_target()
	if target.is_empty():
		return
	# Shift+left -> quick-move (inv <-> equip).
	if btn == MOUSE_BUTTON_LEFT and event.shift_pressed:
		DragManager.handle_shift_click(target)
		accept_event()
		return
	# Right click -> half-stack pickup / drop 1.
	if btn == MOUSE_BUTTON_RIGHT:
		target["modifier"] = "right"
		DragManager.handle_slot_click(target)
		accept_event()
		return
	# Left click padrao.
	if btn == MOUSE_BUTTON_LEFT:
		target["modifier"] = "left"
		DragManager.handle_slot_click(target)
		accept_event()

func _build_target() -> Dictionary:
	if equip_slot_id != &"":
		return {
			"pool": "equipment",
			"key": equip_slot_id,
			"character": character,
			"accept_slot_type": accept_slot_type,
		}
	if slot_index < 0:
		return {}
	return {
		"pool": "inventory",
		"key": slot_index,
		"character": character,
	}

# Alt+click: toggle favorited do item neste slot (so se houver item).
# Equip favoritado lock contra desequipar; inventory favoritado lock contra
# discard/sort. So permite favoritar slots com item — slots vazios ignoram.
func _toggle_favorite() -> void:
	if _item == null:
		return  # nao da pra favoritar slot vazio
	if equip_slot_id != &"":
		character.toggle_equipment_favorited(equip_slot_id)
	elif slot_index >= 0:
		character.toggle_inventory_slot_favorited(slot_index)
