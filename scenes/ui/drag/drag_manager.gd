extends CanvasLayer

# DragManager (Fase B+) — autoload singleton.
#
# Implementa click-to-pick-and-place estilo Minecraft/Terraria entre slots de
# inventory, equipment e artifact. NAO usa drag-and-drop tradicional (hold +
# move + release); o player CLICA num slot pra pegar, e CLICA em outro pra
# soltar.
#
# Dominios isolados (NAO se misturam):
#   - "inventory" <-> "equipment": livre, com filtro de slot_type ao dropar
#     em equipment.
#   - "artifact": pool isolado; so interage com outros artifact slots.
#
# Modificadores suportados (via target["modifier"]):
#   - "left"  (default): pega full stack / dropa todo o held.
#   - "right" : pega meio stack / dropa 1 item.
#   - "shift" : quick-move (inv -> equip ou equip -> inv).
#
# Favorited items (Alt+click pra toggle):
#   - Carregam o flag durante drag/drop.
#   - Equipment favoritado: pickup BLOCKED (nao pode desequipar).
#   - Inventory favoritado: pickup/drop ok; shift-pra-chest BLOCKED.
#   - Discard BLOCKED.
#
# API publica:
#   is_holding() -> bool
#   get_held_item() -> ItemData
#   is_held_favorited() -> bool
#   handle_slot_click(target: Dictionary) -> void
#   handle_shift_click(target: Dictionary) -> void
#   cancel() -> void
#   discard_held() -> bool
#
# Shape de `target`:
#   {
#     "pool": "inventory" | "equipment" | "artifact",
#     "key":  int (slot_index) | StringName (equip slot_id),
#     "character": CharacterInstance,
#     "accept_slot_type": int  # ItemData.SlotType (so quando pool=="equipment")
#     "modifier": "left" | "right" | "shift"  # default "left"
#   }

const GHOST_SIZE: float = 64.0

@onready var _ghost_root: Control = $GhostRoot
@onready var _ghost_icon: TextureRect = $GhostRoot/GhostIcon
@onready var _ghost_qty: Label = $GhostRoot/GhostQty

# Estado.
var _held_item: ItemData = null
var _held_qty: int = 0
var _held_favorited: bool = false
var _held_source: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ghost_root.visible = false
	_ghost_root.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta: float) -> void:
	if not is_holding():
		return
	var mp: Vector2 = get_viewport().get_mouse_position()
	_ghost_root.position = mp - _ghost_root.size * 0.5

# --- Public API -----------------------------------------------------------

func is_holding() -> bool:
	return _held_item != null

func get_held_item() -> ItemData:
	return _held_item

func is_held_favorited() -> bool:
	return _held_favorited

func handle_slot_click(target: Dictionary) -> void:
	if target.is_empty():
		return
	var character: CharacterInstance = target.get("character", null)
	if character == null:
		return
	var modifier: String = String(target.get("modifier", "left"))
	if not is_holding():
		if modifier == "right":
			_try_pickup(target, character, true)  # half-stack
		else:
			_try_pickup(target, character, false)
	else:
		if modifier == "right":
			_try_drop_one(target, character)
		else:
			_try_drop(target, character)

# Shift+click: quick-move da slot pro destino logico.
#   inventory item + slot_type -> equip slot correspondente (se vazio).
#   equipment item -> primeiro inventory slot vazio.
#   artifact -> no-op (artifacts ficam no slot fixo).
func handle_shift_click(target: Dictionary) -> void:
	if is_holding():
		return  # shift-click while holding: no-op por enquanto
	var character: CharacterInstance = target.get("character", null)
	if character == null:
		return
	var pool: String = String(target.get("pool", ""))
	var key = target.get("key", null)
	match pool:
		"inventory":
			_quick_move_inv_to_equip(character, int(key))
		"equipment":
			_quick_move_equip_to_inv(character, key)
		_:
			return  # artifact ignora shift

func cancel() -> void:
	if not is_holding():
		return
	var src_pool: String = String(_held_source.get("pool", ""))
	_write_to(_held_source, _held_item, _held_qty, _held_favorited)
	_clear_held()
	_emit_for_pool(src_pool)

# Descarta o item segurado permanentemente. Bloqueia se favoritado.
# Retorna true se descartou, false se foi rejeitado (favoritado ou nao segurando).
func discard_held() -> bool:
	if not is_holding():
		return false
	if _held_favorited:
		return false
	# Source ja foi esvaziado no pickup. Limpar held sem write back.
	# Mas precisamos refresh do pool de origem porque o slot ja esta vazio
	# e nao temos garantia de que o signal foi processado.
	var src_pool: String = String(_held_source.get("pool", ""))
	_clear_held()
	_emit_for_pool(src_pool)
	return true

# --- Pickup / Drop --------------------------------------------------------

func _try_pickup(target: Dictionary, character: CharacterInstance, half: bool) -> void:
	var pool: String = String(target.get("pool", ""))
	var key = target.get("key", null)
	var existing_item: ItemData
	var existing_qty: int = 0
	var existing_favorited: bool = false
	match pool:
		"inventory":
			var slot_dict: Dictionary = character.get_slot(int(key))
			if slot_dict.is_empty():
				return
			existing_item = slot_dict.get("item", null) as ItemData
			existing_qty = int(slot_dict.get("qty", 0))
			existing_favorited = bool(slot_dict.get("favorited", false))
		"equipment":
			existing_item = character.get_equipment(key)
			existing_qty = 1 if existing_item != null else 0
			existing_favorited = character.is_equipment_favorited(key)
		"artifact":
			existing_item = character.get_artifact(int(key))
			existing_qty = 1 if existing_item != null else 0
		_:
			return
	if existing_item == null or existing_qty <= 0:
		return
	# Equipment favoritado: left-click pickup ALLOWED (player pode trocar de
	# slot manualmente). Apenas shift-click (quick-unequip) e' bloqueado em
	# _quick_move_equip_to_inv.
	# Quanto pegar?
	var pickup_qty: int = existing_qty
	if half and existing_item.stackable and existing_qty > 1:
		pickup_qty = int(ceil(float(existing_qty) / 2.0))
	# Esvazia OU reduz qty no source.
	var remaining: int = existing_qty - pickup_qty
	if remaining > 0:
		# So acontece pra inventory stackable. Manter favorited.
		character.set_slot(int(key), existing_item, remaining, existing_favorited)
	else:
		_write_to({"pool": pool, "key": key, "character": character}, null, 0, false)
	_held_item = existing_item
	_held_qty = pickup_qty
	_held_favorited = existing_favorited
	_held_source = {"pool": pool, "key": key, "character": character}
	if pool == "equipment":
		_held_source["accept_slot_type"] = int(target.get("accept_slot_type", -1))
	_show_ghost()
	if has_node("/root/TooltipManager"):
		TooltipManager.hide_tooltip()
	_emit_for_pool(pool)

func _try_drop(target: Dictionary, character: CharacterInstance) -> void:
	var pool: String = String(target.get("pool", ""))
	var key = target.get("key", null)
	var src_pool: String = String(_held_source.get("pool", ""))
	# 1. Domain check.
	if pool == "artifact" and src_pool != "artifact":
		return
	if pool != "artifact" and src_pool == "artifact":
		return
	# 2. Slot type check pra equipment.
	if pool == "equipment":
		var accept_type: int = int(target.get("accept_slot_type", -1))
		if accept_type == -1:
			return
		if int(_held_item.slot_type) != accept_type:
			return
	var src_character: CharacterInstance = _held_source.get("character", null)
	if src_character != character:
		return
	# 3. Inspect target.
	var target_item: ItemData
	var target_qty: int = 0
	var target_favorited: bool = false
	match pool:
		"inventory":
			var slot_dict: Dictionary = character.get_slot(int(key))
			if not slot_dict.is_empty():
				target_item = slot_dict.get("item", null) as ItemData
				target_qty = int(slot_dict.get("qty", 0))
				target_favorited = bool(slot_dict.get("favorited", false))
		"equipment":
			target_item = character.get_equipment(key)
			target_qty = 1 if target_item != null else 0
			target_favorited = character.is_equipment_favorited(key)
		"artifact":
			target_item = character.get_artifact(int(key))
			target_qty = 1 if target_item != null else 0
	if target_item == null:
		# Place. NAO consolida automaticamente — duplicados so se juntam
		# quando o player chamar Sort.
		_write_to({"pool": pool, "key": key, "character": character}, _held_item, _held_qty, _held_favorited)
		_clear_held()
		_emit_for_pool(pool)
		if src_pool != pool:
			_emit_for_pool(src_pool)
		return
	if target_item == _held_item and _held_item.stackable and pool == "inventory":
		# Merge stacks (target == held = mesmo item; mesclar manualmente
		# clicando do mesmo item em cima ainda funciona — Sort eh adicional).
		# Manter favorited do target (se ele ja era favoritado, permanece).
		var merged_qty: int = target_qty + _held_qty
		character.set_slot(int(key), _held_item, merged_qty, target_favorited or _held_favorited)
		_clear_held()
		_emit_for_pool(pool)
		if src_pool != pool:
			_emit_for_pool(src_pool)
		return
	# Equipment swap BLOCKED (decisao do usuario): pra trocar equipamentos, o
	# player precisa primeiro desequipar manualmente, depois equipar o novo.
	# Nao importa se target eh favoritado ou nao — sem auto-swap em equip.
	if pool == "equipment":
		return
	# Artifact swap idem (1 por slot, sem swap automatico).
	if pool == "artifact":
		return
	# Inventory swap mantido (player ainda pode reorganizar inventory livremente).
	if not _is_compatible_with_source(target_item, src_pool):
		return
	# Place held no target; target item vira held.
	_write_to({"pool": pool, "key": key, "character": character}, _held_item, _held_qty, _held_favorited)
	_held_item = target_item
	_held_qty = target_qty
	_held_favorited = target_favorited
	# _held_source mantido (origem original) — chain swaps consistentes.
	_show_ghost()
	_emit_for_pool(pool)
	if src_pool != pool:
		_emit_for_pool(src_pool)

# Right-click drop: deposita 1 do held no target (place, merge ou no-op).
# Item diferente no target = no-op (sem swap pelo right-click).
func _try_drop_one(target: Dictionary, character: CharacterInstance) -> void:
	var pool: String = String(target.get("pool", ""))
	var key = target.get("key", null)
	var src_pool: String = String(_held_source.get("pool", ""))
	# 1. Domain check.
	if pool == "artifact" and src_pool != "artifact":
		return
	if pool != "artifact" and src_pool == "artifact":
		return
	# 2. Slot type check pra equipment.
	if pool == "equipment":
		var accept_type: int = int(target.get("accept_slot_type", -1))
		if accept_type == -1:
			return
		if int(_held_item.slot_type) != accept_type:
			return
	var src_character: CharacterInstance = _held_source.get("character", null)
	if src_character != character:
		return
	# Para equipment/artifact: place de 1 = comportamento normal.
	if pool != "inventory":
		# So permite se target vazio (nao stackam).
		var target_item_eq: ItemData = character.get_equipment(key) if pool == "equipment" else character.get_artifact(int(key))
		if target_item_eq != null:
			return  # nao stack
		_write_to({"pool": pool, "key": key, "character": character}, _held_item, 1, _held_favorited)
		# Held qty decrementa por 1.
		_held_qty -= 1
		if _held_qty <= 0:
			_clear_held()
		else:
			_show_ghost()
		_emit_for_pool(pool)
		return
	# Inventory: place 1 num slot vazio OU merge 1 num slot do mesmo item.
	var slot_dict: Dictionary = character.get_slot(int(key))
	if slot_dict.is_empty():
		character.set_slot(int(key), _held_item, 1, _held_favorited)
		_held_qty -= 1
		if _held_qty <= 0:
			_clear_held()
		else:
			_show_ghost()
		_emit_for_pool(pool)
		return
	var target_item: ItemData = slot_dict.get("item", null) as ItemData
	var target_qty: int = int(slot_dict.get("qty", 0))
	var target_favorited: bool = bool(slot_dict.get("favorited", false))
	if target_item == _held_item and _held_item.stackable:
		# Merge 1.
		character.set_slot(int(key), _held_item, target_qty + 1, target_favorited)
		_held_qty -= 1
		if _held_qty <= 0:
			_clear_held()
		else:
			_show_ghost()
		_emit_for_pool(pool)
		return
	# Item diferente: right-click nao faz swap.
	return

# --- Quick move (shift+click) ---------------------------------------------

# Inventory item -> equip slot apropriado pelo slot_type.
# Comportamento:
#   - target equip slot VAZIO: equipa, inv slot esvazia.
#   - target equip slot OCUPADO: BLOCKED (no auto-swap em equipment, por
#     decisao do usuario — player precisa desequipar manualmente primeiro).
#   - inv slot tem qty > 1 (stackable raro pra equipamento): equipa 1, reduz inv.
# Items favoritados NO INVENTORY: o flag eh preservado ao equipar (so na ultima
# unidade pra stacks).
# Materiais/consumables (slot_type=NONE): no-op.
func _quick_move_inv_to_equip(character: CharacterInstance, idx: int) -> void:
	var slot_dict: Dictionary = character.get_slot(idx)
	if slot_dict.is_empty():
		return
	var item: ItemData = slot_dict.get("item", null) as ItemData
	if item == null:
		return
	var slot_type: int = int(item.slot_type)
	if slot_type == int(ItemData.SlotType.NONE):
		return
	var slot_id: StringName = _slot_id_for_slot_type(slot_type)
	if slot_id == &"":
		return
	# Equip slot ja ocupado: bloqueado (regra "no auto-swap").
	if character.get_equipment(slot_id) != null:
		return
	var inv_fav: bool = bool(slot_dict.get("favorited", false))
	var qty: int = int(slot_dict.get("qty", 1))
	# Equipa o item (favorited preservado se for a ultima unidade).
	character.set_equipment(slot_id, item, inv_fav if qty == 1 else false)
	# Ajusta inv slot: decrementa stack ou esvazia.
	if qty > 1:
		character.set_slot(idx, item, qty - 1, inv_fav)
	else:
		character.set_slot(idx, null, 0)
	EventBus.character_inventory_changed.emit(character)

# Equipment item -> primeiro inventory slot vazio (se nao favoritado).
func _quick_move_equip_to_inv(character: CharacterInstance, slot_id) -> void:
	var item: ItemData = character.get_equipment(slot_id)
	if item == null:
		return
	if character.is_equipment_favorited(slot_id):
		return  # favoritado: nao pode desequipar
	# Procura primeiro slot vazio.
	var inv_size: int = character.inventory_slots.size()
	for i in inv_size:
		if character.get_slot(i).is_empty():
			character.clear_equipment(slot_id)
			character.set_slot(i, item, 1, false)
			EventBus.character_inventory_changed.emit(character)
			return
	# Sem espaco — silent no-op.

# Reverso de SLOT_TYPE_BY_ID no character_modal. Quick-move usa o slot_id
# canonico do slot type. Retorna &"" se slot_type nao tem mapping.
func _slot_id_for_slot_type(slot_type: int) -> StringName:
	match slot_type:
		int(ItemData.SlotType.HELMET): return &"helmet"
		int(ItemData.SlotType.CHEST): return &"chest"
		int(ItemData.SlotType.LEGS): return &"legs"
		int(ItemData.SlotType.BOOTS): return &"boots"
		int(ItemData.SlotType.NECKLACE): return &"necklace"
		int(ItemData.SlotType.EARRINGS): return &"earrings"
		int(ItemData.SlotType.RING): return &"ring"
		int(ItemData.SlotType.BRACELET): return &"bracelet"
		int(ItemData.SlotType.WEAPON): return &"weapon"
		int(ItemData.SlotType.PICKAXE): return &"pickaxe"
		int(ItemData.SlotType.AXE): return &"axe"
		int(ItemData.SlotType.FISHING_ROD): return &"fishing_rod"
		int(ItemData.SlotType.SCYTHE): return &"scythe"
		int(ItemData.SlotType.STAR_NET): return &"star_net"
		int(ItemData.SlotType.SCOUTER): return &"scouter"
	return &""

# --- Helpers de write -----------------------------------------------------

func _write_to(target: Dictionary, item: ItemData, qty: int, favorited: bool) -> void:
	var character: CharacterInstance = target.get("character", null)
	if character == null:
		return
	var pool: String = String(target.get("pool", ""))
	var key = target.get("key", null)
	match pool:
		"inventory":
			character.set_slot(int(key), item, qty, favorited)
		"equipment":
			character.set_equipment(key, item, favorited)
		"artifact":
			character.set_artifact(int(key), item)

func _is_compatible_with_source(item: ItemData, source_pool: String) -> bool:
	if item == null:
		return true
	match source_pool:
		"inventory":
			return true
		"equipment":
			var accept: int = int(_held_source.get("accept_slot_type", -1))
			if accept == -1:
				return false
			return int(item.slot_type) == accept
		"artifact":
			return int(item.item_type) == int(ItemData.ItemType.ARTIFACT)
	return true

# --- Helpers de estado ----------------------------------------------------

func _clear_held() -> void:
	_held_item = null
	_held_qty = 0
	_held_favorited = false
	_held_source = {}
	_hide_ghost()

func _show_ghost() -> void:
	if _held_item == null:
		_hide_ghost()
		return
	_ghost_icon.texture = _held_item.get_sprite() if _held_item.has_method("get_sprite") else _held_item.sprite
	_ghost_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if _held_qty > 1 and _held_item.stackable:
		_ghost_qty.text = "x%s" % NumberFormat.format_int(_held_qty)
		_ghost_qty.visible = true
	else:
		_ghost_qty.visible = false
	_ghost_root.visible = true

func _hide_ghost() -> void:
	_ghost_root.visible = false
	_ghost_icon.texture = null

func _emit_for_pool(pool: String) -> void:
	# Para equipment/artifact, character.set_equipment/set_artifact ja emitem
	# character_equipment_changed (+ stats). Aqui so emitimos pra inventory,
	# que mexe direto em inventory_slots sem emit.
	if pool != "inventory":
		return
	var character: CharacterInstance = _held_source.get("character", null) if not _held_source.is_empty() else GameState.get_active_character()
	if character == null:
		return
	EventBus.character_inventory_changed.emit(character)
