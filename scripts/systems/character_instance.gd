class_name CharacterInstance
extends Resource

# Slots equipaveis na Fase 0 (decisao #20: tudo por personagem).
# 10 slots de equip + 3 slots de ferramenta + 3 slots visuais (transmog).
# Nomes alinham com `ItemData.SlotType` e com o serializer do save.
const EQUIP_HELMET: StringName = &"helmet"
const EQUIP_CHEST: StringName = &"chest"
const EQUIP_LEGS: StringName = &"legs"
const EQUIP_BOOTS: StringName = &"boots"
const EQUIP_NECKLACE: StringName = &"necklace"
const EQUIP_EARRINGS: StringName = &"earrings"
# Anel — slot unico desde Fase B+. RING1/RING2 ficam DEPRECATED so pra detection
# no save migration v1->v2 (drop ring2 contents pro inventory).
const EQUIP_RING: StringName = &"ring"
const EQUIP_RING1: StringName = &"ring1"  # DEPRECATED: detectado no save migration
const EQUIP_RING2: StringName = &"ring2"  # DEPRECATED: detectado no save migration
const EQUIP_BRACELET: StringName = &"bracelet"
const EQUIP_WEAPON: StringName = &"weapon"
# Ferramentas (Picareta/Machado/Vara/Foice/etc). Slots existem ja na Fase 0;
# logica de uso em Gathering vem na Fase 01.
const EQUIP_PICKAXE: StringName = &"pickaxe"      # Mining
const EQUIP_AXE: StringName = &"axe"              # Chopping
const EQUIP_FISHING_ROD: StringName = &"fishing_rod"  # Fishing
const EQUIP_SCYTHE: StringName = &"scythe"        # Harvesting (Fase B+)
# Ferramentas futuras (Fase 04+) — slots existem so visualmente como locked.
const EQUIP_STAR_NET: StringName = &"star_net"    # Star Catching
const EQUIP_SCOUTER: StringName = &"scouter"      # Robotics
# Slots visuais (transmog) — UI completa vem na Fase 02-03.
const EQUIP_WEAPON_VISUAL: StringName = &"weapon_visual"
const EQUIP_SKIN_FULL: StringName = &"skin_full"
const EQUIP_WINGS: StringName = &"wings"

# Aliases legados — codigo antigo (ex: dados Resources existentes) pode
# referenciar EQUIP_ARMOR ou EQUIP_ACCESSORY. Mantidos para nao quebrar
# saves/cenas pre-existentes. Nenhum codigo NOVO deve usa-los.
const EQUIP_ARMOR: StringName = &"chest"      # DEPRECATED: usar EQUIP_CHEST
const EQUIP_ACCESSORY: StringName = &"necklace"  # DEPRECATED: usar EQUIP_NECKLACE/RING/etc

const EQUIP_SLOTS: Array[StringName] = [
	EQUIP_HELMET,
	EQUIP_CHEST,
	EQUIP_LEGS,
	EQUIP_BOOTS,
	EQUIP_NECKLACE,
	EQUIP_EARRINGS,
	EQUIP_RING,
	EQUIP_BRACELET,
	EQUIP_WEAPON,
	EQUIP_PICKAXE,
	EQUIP_AXE,
	EQUIP_FISHING_ROD,
	EQUIP_SCYTHE,
	EQUIP_STAR_NET,
	EQUIP_SCOUTER,
	EQUIP_WEAPON_VISUAL,
	EQUIP_SKIN_FULL,
	EQUIP_WINGS,
]

# Valid stat ids for spend_stat_point. Keep in sync with CombatStats.
# Os 5 antigos (HP/MP/ATK/DEF/ATK_SPEED) ficam DEPRECATED — saves antigos
# com pontos investidos neles continuam funcionando (CombatStats ainda aplica),
# mas a UI nova so expoe STR/DEX/INT/VIT/LUK.
const STAT_HP: StringName = &"hp"
const STAT_MP: StringName = &"mp"
const STAT_ATK: StringName = &"atk"
const STAT_DEF: StringName = &"def"
const STAT_ATTACK_SPEED: StringName = &"attack_speed"

# Atributos primarios (Fase B+ — UI expoe so estes pra spend).
const STAT_STR: StringName = &"str"
const STAT_DEX: StringName = &"dex"
const STAT_INT: StringName = &"int"
const STAT_VIT: StringName = &"vit"
const STAT_LUK: StringName = &"luk"

const VALID_STAT_IDS: Array[StringName] = [
	STAT_HP,
	STAT_MP,
	STAT_ATK,
	STAT_DEF,
	STAT_ATTACK_SPEED,
	STAT_STR,
	STAT_DEX,
	STAT_INT,
	STAT_VIT,
	STAT_LUK,
]

@export var data: CharacterData
@export var stats: CombatStats
@export var current_hp: int = 0
@export var current_mp: int = 0
@export var level: int = 1
@export var current_xp: int = 0

# --- Navegacao no mundo (Fase Exploration AQW) ----------------------------
# Substitui o sistema antigo de zones/areas/stages. Agora cada "lugar" eh
# uma AreaSceneData identificada por id. Map modal lista todas as areas
# disponiveis pra fast-travel.
@export var current_area_id: StringName = &""
# Set de area_ids que o personagem ja visitou. Map modal pode usar pra
# gating "ja viu" (futuro). Por enquanto descritivo so.
@export var unlocked_areas: Array[StringName] = []
@export var equipment: Dictionary = {}
# Inventory slot-indexed (Fase B+). Cada elemento eh null (vazio) ou um
# Dictionary {"item_id": StringName, "item": ItemData, "qty": int}.
# Tamanho do array == max_inventory_slots(). Init em create() e
# _ensure_inventory_initialized().
@export var inventory_slots: Array = []
# Artifacts (pool isolado de inventory/equipment) — 16 slots fixos.
# Cada slot eh null (vazio) ou Dictionary {"item_id": StringName, "item": ItemData}.
# Artifacts sempre qty=1, nao stackam. Init em create() e
# _ensure_artifacts_initialized().
@export var artifact_slots: Array = []
const ARTIFACT_SLOTS_COUNT: int = 16
# Favoritos por slot de equipamento. Chave eh o slot_id (StringName); valor
# bool. Slots ausentes do dict = nao favoritado. Itens favoritados nao podem
# ser desequipados / descartados / shift-movidos / movidos pelo sort.
# Inventory tem favoritado embutido no proprio dict do slot ("favorited").
@export var equipment_favorites: Dictionary = {}
# How many stat points are waiting to be spent. Earned via _level_up().
@export var unspent_stat_points: int = 0
# Per-stat investments. Read by CombatStats.from_character to bake bonuses
# into the live stat block. Keys are STAT_* StringNames; values are int counts.
@export var stat_bonus: Dictionary = {}
# Skill tree (Fase 01 / Bloco B). `skill_points_unspent` ganha 1 por level
# alem do `unspent_stat_points`. `unlocked_skill_nodes` lista os nós ja
# destravados; `SkillTree.apply_bonuses` aplica os efeitos em CombatStats.
@export var skill_points_unspent: int = 0
@export var unlocked_skill_nodes: Array[StringName] = []
# Slots de skills equipadas (Fase Exploration AQW). SkillRuntime usa pra
# auto-combat (dispara em CD quando "Auto" ligado). Tamanho fixo de 2 slots
# por enquanto — UI futuro permitira swap.
@export var equipped_skills: Array[SkillData] = []

static func create(character_data: CharacterData) -> CharacterInstance:
	var inst := CharacterInstance.new()
	inst.data = character_data
	if character_data.starting_weapon != null:
		inst.equipment[EQUIP_WEAPON] = character_data.starting_weapon
	# Inventory slot-indexed init com null em todos os slots.
	inst._ensure_inventory_initialized()
	inst._ensure_artifacts_initialized()
	inst.stats = CombatStats.from_character(inst)
	inst.current_hp = inst.stats.max_hp
	inst.current_mp = inst.stats.max_mp
	# Fase Exploration AQW: area inicial vem do CharacterData.starting_area.
	if character_data.starting_area != null:
		inst.current_area_id = character_data.starting_area.id
		if not inst.unlocked_areas.has(inst.current_area_id):
			inst.unlocked_areas.append(inst.current_area_id)
	# Skills placeholder: equipa as 2 default pra auto-combat testar de cara.
	# UI futuro permitira swap.
	var ps_path: String = "res://data/skills/power_strike.tres"
	var qh_path: String = "res://data/skills/quick_heal.tres"
	if ResourceLoader.exists(ps_path):
		inst.equipped_skills.append(load(ps_path))
	if ResourceLoader.exists(qh_path):
		inst.equipped_skills.append(load(qh_path))
	return inst

func get_xp_to_next_level() -> int:
	return XpCurve.xp_to_next(level)

func id() -> StringName:
	if data == null:
		return &""
	return data.id

func display_name() -> String:
	if data == null:
		return ""
	return data.display_name

func max_inventory_slots() -> int:
	if data == null:
		return 0
	return data.inventory_max_slots

func get_equipment(slot: StringName) -> ItemData:
	return equipment.get(slot, null)

# Poe/troca o item no slot. Retorna o item que estava antes (ou null).
# Trigga refresh de stats + emit character_equipment_changed e
# character_stats_changed pra UI atualizar. Aceita item=null pra clear
# (alias de clear_equipment).
func set_equipment(slot: StringName, item: ItemData, favorited: bool = false) -> ItemData:
	var previous: ItemData = equipment.get(slot, null)
	if item == null:
		equipment.erase(slot)
		equipment_favorites.erase(slot)
	else:
		equipment[slot] = item
		if favorited:
			equipment_favorites[slot] = true
		else:
			equipment_favorites.erase(slot)
	_refresh_stats()
	EventBus.character_equipment_changed.emit(self)
	EventBus.character_stats_changed.emit(self)
	return previous

# Remove o item equipado no slot. Retorna o item removido (ou null).
func clear_equipment(slot: StringName) -> ItemData:
	return set_equipment(slot, null)

# Artifact pool — 16 slots fixos, isolados de inventory/equipment.

func _ensure_artifacts_initialized() -> void:
	if artifact_slots.size() == ARTIFACT_SLOTS_COUNT:
		return
	if artifact_slots.size() < ARTIFACT_SLOTS_COUNT:
		var prev_size: int = artifact_slots.size()
		artifact_slots.resize(ARTIFACT_SLOTS_COUNT)
		for i in range(prev_size, ARTIFACT_SLOTS_COUNT):
			artifact_slots[i] = null
	else:
		artifact_slots.resize(ARTIFACT_SLOTS_COUNT)

func get_artifact(index: int) -> ItemData:
	_ensure_artifacts_initialized()
	if index < 0 or index >= artifact_slots.size():
		return null
	var slot = artifact_slots[index]
	if slot == null:
		return null
	return slot.get("item", null) as ItemData

# Poe/troca um artifact no slot. Retorna o anterior (ou null).
func set_artifact(index: int, item: ItemData) -> ItemData:
	_ensure_artifacts_initialized()
	if index < 0 or index >= artifact_slots.size():
		return null
	var previous: ItemData = get_artifact(index)
	if item == null:
		artifact_slots[index] = null
	else:
		artifact_slots[index] = {"item_id": item.id, "item": item}
	EventBus.character_equipment_changed.emit(self)
	return previous

# Garante que inventory_slots tem o tamanho correto (max_inventory_slots).
# Preserva slots existentes se ja inicializado. Chamado em create() e antes
# de operacoes de inventory.
func _ensure_inventory_initialized() -> void:
	var needed: int = max_inventory_slots()
	if inventory_slots.size() == needed:
		return
	# Resize preserva os primeiros N slots. Novos slots iniciam null.
	if inventory_slots.size() < needed:
		var prev_size: int = inventory_slots.size()
		inventory_slots.resize(needed)
		for i in range(prev_size, needed):
			inventory_slots[i] = null
	else:
		# Shrink — descarta excedente (raro; max_inventory_slots so cresce).
		inventory_slots.resize(needed)

# Adiciona qty de um item ao inventario. Procura primeiro um slot stackavel
# com mesmo item_id; se nao tem, primeiro slot vazio. Retorna qty
# efetivamente adicionada (0 se cheio e nao stackavel).
func add_item(item: ItemData, qty: int) -> int:
	if item == null or qty <= 0:
		return 0
	_ensure_inventory_initialized()
	var key: StringName = item.id
	# 1. Tenta empilhar em slot existente do mesmo item (se stackable).
	if item.stackable:
		for i in inventory_slots.size():
			var slot = inventory_slots[i]
			if slot == null:
				continue
			if slot.get("item_id", &"") == key:
				slot["qty"] = int(slot.get("qty", 0)) + qty
				inventory_slots[i] = slot
				return qty
	# 2. Primeiro slot vazio.
	for i in inventory_slots.size():
		if inventory_slots[i] == null:
			inventory_slots[i] = {"item_id": key, "item": item, "qty": qty}
			return qty
	# 3. Sem espaco.
	return 0

# Remove qty de um item (itera slots subtraindo). Retorna qty efetivamente
# removida (pode ser < qty se nao havia o suficiente).
func remove_item(item: ItemData, qty: int) -> int:
	if item == null or qty <= 0:
		return 0
	_ensure_inventory_initialized()
	var key: StringName = item.id
	var remaining: int = qty
	for i in inventory_slots.size():
		if remaining <= 0:
			break
		var slot = inventory_slots[i]
		if slot == null:
			continue
		if slot.get("item_id", &"") != key:
			continue
		var slot_qty: int = int(slot.get("qty", 0))
		if slot_qty <= remaining:
			remaining -= slot_qty
			inventory_slots[i] = null
		else:
			slot["qty"] = slot_qty - remaining
			inventory_slots[i] = slot
			remaining = 0
	return qty - remaining

# Soma qty de todos os slots com aquele item_id (back-compat com call sites
# antigos que precisam do total agregado, nao por slot).
func get_item_qty(item_id: StringName) -> int:
	var total: int = 0
	for slot in inventory_slots:
		if slot == null:
			continue
		if slot.get("item_id", &"") == item_id:
			total += int(slot.get("qty", 0))
	return total

# Retorna o ItemData do primeiro slot que tem aquele item_id. Util pra
# tooltips/UI que precisa do ref do item.
func get_item_data(item_id: StringName) -> ItemData:
	for slot in inventory_slots:
		if slot == null:
			continue
		if slot.get("item_id", &"") == item_id:
			return slot.get("item", null) as ItemData
	return null

# Legacy-format: returns dedup entries by id (soma de todos os slots por id).
# Mantido pra crafting_modal e area_results que esperam esse shape.
func get_inventory_entries() -> Array:
	var seen: Dictionary = {}
	for slot in inventory_slots:
		if slot == null:
			continue
		var key: StringName = slot.get("item_id", &"")
		if key == &"":
			continue
		if seen.has(key):
			seen[key]["qty"] += int(slot.get("qty", 0))
		else:
			seen[key] = {
				"item": slot.get("item", null),
				"qty": int(slot.get("qty", 0)),
				"id": key,
			}
	return seen.values()

# Direct slot access (pra UI renderizar grid). Retorna {} se vazio ou index
# fora dos limites.
func get_slot(index: int) -> Dictionary:
	if index < 0 or index >= inventory_slots.size():
		return {}
	var slot = inventory_slots[index]
	if slot == null:
		return {}
	return slot

# Drag/drop futuro: poe item especifico em slot especifico, sobrescrevendo.
# favorited persistido no proprio dict do slot — drag/drop carrega o flag.
func set_slot(index: int, item: ItemData, qty: int, favorited: bool = false) -> void:
	_ensure_inventory_initialized()
	if index < 0 or index >= inventory_slots.size():
		return
	if item == null or qty <= 0:
		inventory_slots[index] = null
		return
	inventory_slots[index] = {
		"item_id": item.id,
		"item": item,
		"qty": qty,
		"favorited": favorited,
	}

# --- Favorites ----------------------------------------------------------
# Favoritos lockam o item — protege de discard, sort, shift-move, e (pra
# equipment) de desequipar. Sao toggleados via Alt+click na UI.

func is_inventory_slot_favorited(index: int) -> bool:
	if index < 0 or index >= inventory_slots.size():
		return false
	var slot = inventory_slots[index]
	if slot == null:
		return false
	return bool(slot.get("favorited", false))

func set_inventory_slot_favorited(index: int, fav: bool) -> bool:
	if index < 0 or index >= inventory_slots.size():
		return false
	var slot = inventory_slots[index]
	if slot == null:
		return false  # nao pode favoritar slot vazio
	slot["favorited"] = fav
	inventory_slots[index] = slot
	EventBus.character_inventory_changed.emit(self)
	return true

func toggle_inventory_slot_favorited(index: int) -> bool:
	return set_inventory_slot_favorited(index, not is_inventory_slot_favorited(index))

func is_equipment_favorited(slot_id: StringName) -> bool:
	return bool(equipment_favorites.get(slot_id, false))

func set_equipment_favorited(slot_id: StringName, fav: bool) -> bool:
	if not equipment.has(slot_id):
		return false  # nao pode favoritar slot vazio
	if fav:
		equipment_favorites[slot_id] = true
	else:
		equipment_favorites.erase(slot_id)
	EventBus.character_equipment_changed.emit(self)
	return true

func toggle_equipment_favorited(slot_id: StringName) -> bool:
	return set_equipment_favorited(slot_id, not is_equipment_favorited(slot_id))

# Junta todos os slots com o mesmo item_id (stackable) no slot de menor index.
# Items nao-stackable ficam intactos (1 por slot). Favorited eh preservado:
# se qualquer slot do mesmo item_id estava favoritado, o slot consolidado fica.
# Idempotente. Chamado pelo DragManager apos drops em inventory pra evitar
# stacks espalhadas, e pelo sort_inventory.
func consolidate_inventory() -> void:
	_ensure_inventory_initialized()
	var seen: Dictionary = {}  # item_id -> first slot index
	for i in inventory_slots.size():
		var slot = inventory_slots[i]
		if slot == null:
			continue
		var item: ItemData = slot.get("item", null) as ItemData
		if item == null or not item.stackable:
			continue
		var key: StringName = item.id
		if seen.has(key):
			var first_idx: int = seen[key]
			var first_slot = inventory_slots[first_idx]
			first_slot["qty"] = int(first_slot.get("qty", 0)) + int(slot.get("qty", 0))
			# Preserva favorited (se qualquer um dos dois estava marcado).
			if bool(slot.get("favorited", false)):
				first_slot["favorited"] = true
			inventory_slots[first_idx] = first_slot
			inventory_slots[i] = null
		else:
			seen[key] = i

# Sort destrutivo: reordena slots nao-favoritados. Items favoritados ficam
# pinned no slot original (nao sao tocados pelo sort).
# Modes: &"rarity" (DESC), &"quantity" (DESC), &"type" (ASC), &"level" (DESC).
func sort_inventory(mode: StringName) -> void:
	_ensure_inventory_initialized()
	# Consolida duplicados antes de sortear (junta stacks espalhadas).
	consolidate_inventory()
	var size: int = inventory_slots.size()
	# Coletar pinned positions (favorited) + moveable entries separadamente.
	var pinned: Dictionary = {}  # idx -> slot dict
	var moveable: Array = []
	for i in size:
		var slot = inventory_slots[i]
		if slot == null:
			continue
		if bool(slot.get("favorited", false)):
			pinned[i] = slot
		else:
			moveable.append(slot)
	# Sortear moveable conforme mode.
	match mode:
		&"rarity":
			moveable.sort_custom(func(a, b): return a.get("item", null).rarity > b.get("item", null).rarity)
		&"quantity":
			moveable.sort_custom(func(a, b): return int(a.get("qty", 0)) > int(b.get("qty", 0)))
		&"type":
			moveable.sort_custom(func(a, b): return a.get("item", null).item_type < b.get("item", null).item_type)
		&"level":
			moveable.sort_custom(func(a, b): return a.get("item", null).item_level > b.get("item", null).item_level)
	# Re-popular: pinned ficam no slot original; moveable preenche os outros
	# slots na ordem sorteada; null no resto.
	var moveable_idx: int = 0
	for i in size:
		if pinned.has(i):
			inventory_slots[i] = pinned[i]
		elif moveable_idx < moveable.size():
			inventory_slots[i] = moveable[moveable_idx]
			moveable_idx += 1
		else:
			inventory_slots[i] = null

# Adds XP and consumes as many level-up thresholds as fit. Big chunks
# (offline progress, big mob, multipliers) can produce multiple level ups in
# one call — the while loop handles that.
func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	current_xp += amount
	while current_xp >= get_xp_to_next_level():
		current_xp -= get_xp_to_next_level()
		_level_up()

func _level_up() -> void:
	level += 1
	unspent_stat_points += 1
	# Skill tree (Fase 01 / Bloco B): +1 skill point por level alem do stat point.
	skill_points_unspent += 1
	_refresh_stats()
	# Heal on level up — keeps the player alive after a long streak.
	current_hp = stats.max_hp
	current_mp = stats.max_mp
	EventBus.character_leveled_up.emit(self, level)
	EventBus.character_xp_changed.emit(self, current_xp)
	EventBus.character_hp_changed.emit(self, current_hp, stats.max_hp)

# Spend one banked stat point on `stat_id`. Returns true if the spend went
# through, false if no points are available or the id is invalid.
func spend_stat_point(stat_id: StringName) -> bool:
	if unspent_stat_points <= 0:
		return false
	if not VALID_STAT_IDS.has(stat_id):
		return false
	stat_bonus[stat_id] = int(stat_bonus.get(stat_id, 0)) + 1
	unspent_stat_points -= 1
	_refresh_stats()
	EventBus.character_stats_changed.emit(self)
	return true

# Rebuild the live CombatStats from the character base + weapon + bonuses.
# Mutates in place when possible so consumers holding the same `stats` ref
# (Player/Enemy combatants) keep seeing live values without re-syncing the ref.
func _refresh_stats() -> void:
	var fresh: CombatStats = CombatStats.from_character(self)
	if stats == null:
		stats = fresh
	else:
		# Quinteto base
		stats.max_hp = fresh.max_hp
		stats.max_mp = fresh.max_mp
		stats.atk = fresh.atk
		stats.def = fresh.def
		stats.attack_speed = fresh.attack_speed
		# Stats expandidos da Fase 0 — todos zerados na base hoje. Copiar para
		# o ref existente e' future-proofing: assim que equip/skill/encant
		# comecarem a popular, a UI/combate ja le do mesmo ref.
		stats.str_stat = fresh.str_stat
		stats.dex = fresh.dex
		stats.int_stat = fresh.int_stat
		stats.vit = fresh.vit
		stats.luk = fresh.luk
		stats.magic_atk = fresh.magic_atk
		stats.magic_def = fresh.magic_def
		stats.hit_number = fresh.hit_number
		stats.cast_speed = fresh.cast_speed
		stats.cooldown_reduction = fresh.cooldown_reduction
		stats.hp_regen = fresh.hp_regen
		stats.mp_regen = fresh.mp_regen
		stats.life_steal = fresh.life_steal
		stats.mp_leech = fresh.mp_leech
		stats.crit_chance = fresh.crit_chance
		stats.magic_crit_chance = fresh.magic_crit_chance
		stats.crit_damage = fresh.crit_damage
		stats.block_chance = fresh.block_chance
		stats.dodge_chance = fresh.dodge_chance
		stats.hit_chance = fresh.hit_chance
		stats.accuracy = fresh.accuracy
		stats.extra_hit = fresh.extra_hit
		stats.resist_status = fresh.resist_status.duplicate()
		stats.elem_dmg = fresh.elem_dmg.duplicate()
		stats.elem_resist = fresh.elem_resist.duplicate()
		stats.exp_gain_pct = fresh.exp_gain_pct
		stats.gold_gain_pct = fresh.gold_gain_pct
		stats.loot_gain_pct = fresh.loot_gain_pct
		stats.equip_drop_chance_pct = fresh.equip_drop_chance_pct
		stats.material_drop_chance_pct = fresh.material_drop_chance_pct
		stats.card_drop_chance_pct = fresh.card_drop_chance_pct
		stats.skill_exp_gain_pct = fresh.skill_exp_gain_pct
		stats.mastery_exp_gain_pct = fresh.mastery_exp_gain_pct
	if current_hp > stats.max_hp:
		current_hp = stats.max_hp
	if current_mp > stats.max_mp:
		current_mp = stats.max_mp

func register_kill() -> void:
	# Antes acumulava current_stage_kills (stage-based). Sem stages, kills
	# sao trackados via Bestiary global.
	pass

# --- Navegacao no mundo (Fase Exploration AQW) ----------------------------

# Marca a area como visitada (chama no area_loaded).
func mark_area_visited(area_id: StringName) -> void:
	current_area_id = area_id
	if not unlocked_areas.has(area_id):
		unlocked_areas.append(area_id)
