extends Node

# SaveManager - autoload de persistencia (Fase 0).
# Salva o GameState + roster + inventario por personagem em JSON.
# Usa rotacao de backup (3 slots) + hash sha256 de integridade.
# Ver `planning/01_design/save-offline-spec.md`.

const CURRENT_SAVE_VERSION: int = 3

const SAVE_PATH: String = "user://save_slot_1.json"
const BAK_PATH: String = "user://save_slot_1.json.bak"
const BAK2_PATH: String = "user://save_slot_1.json.bak2"

const AUTOSAVE_INTERVAL_SECONDS: int = 60

# Bloqueia gravacao recursiva durante o load (evita autosave imediato apos
# carga, que ainda nao tem GameState pronto).
var _is_loading: bool = false
# Timestamp REAL (unix) do ultimo autosave bem-sucedido. Usado em `_process`
# pra disparar autosave a cada N segundos REAIS, independente de
# `Engine.time_scale` (decisao #14: speed 2x nao deve dobrar a frequencia
# do autosave).
var _last_autosave_unix: int = 0

func _ready() -> void:
	# Inicializa em zero — primeira chamada de _process so dispara apos a
	# game state existir (owned_characters preenchido) e ter passado o
	# intervalo desde a abertura do jogo.
	_last_autosave_unix = int(Time.get_unix_time_from_system())

func _process(_delta: float) -> void:
	# Usa unix time pra ignorar `Engine.time_scale`. Save dispara a cada
	# AUTOSAVE_INTERVAL_SECONDS REAIS, mesmo em 2x.
	var now: int = int(Time.get_unix_time_from_system())
	if now - _last_autosave_unix < AUTOSAVE_INTERVAL_SECONDS:
		return
	if GameState.owned_characters.is_empty():
		return
	if save_game():
		_last_autosave_unix = now

# --- Public API -----------------------------------------------------------

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH) or FileAccess.file_exists(BAK_PATH)

func save_game() -> bool:
	if _is_loading:
		return false
	if GameState.owned_characters.is_empty():
		return false
	var data: Dictionary = build_save_snapshot()
	var ok: bool = _write_with_rotation(data)
	if ok:
		EventBus.save_completed.emit()
	else:
		EventBus.save_failed.emit("write_failed")
	return ok

func load_game() -> bool:
	_is_loading = true
	var data: Dictionary = _read_save_with_recovery()
	if data.is_empty():
		_is_loading = false
		return false
	if int(data.get("save_version", 1)) < CURRENT_SAVE_VERSION:
		data = _migrate_save(data, int(data.get("save_version", 1)))
	_deserialize_into_game_state(data)
	_is_loading = false
	EventBus.save_loaded.emit()
	# Disparo do offline progression e' feito por OfflineSimulator+main.gd na E5.
	# Aqui apenas guardamos `last_offline_at_unix` em memoria pra usar la.
	_last_loaded_save_dict = data
	return true

# Cache do save carregado, para offline progression na E5 ler `last_offline_at_unix`.
var _last_loaded_save_dict: Dictionary = {}

func get_last_loaded_save() -> Dictionary:
	return _last_loaded_save_dict

func backup_manual() -> String:
	if not FileAccess.file_exists(SAVE_PATH):
		# nada pra fazer backup
		return ""
	var ts: int = int(Time.get_unix_time_from_system())
	var path: String = "user://save_slot_1.json.manual_%d.bak" % ts
	var err: int = DirAccess.copy_absolute(SAVE_PATH, path)
	if err != OK:
		return ""
	return path

# --- Serializacao ---------------------------------------------------------

func build_save_snapshot() -> Dictionary:
	var characters_array: Array = []
	for c in GameState.owned_characters:
		if c == null:
			continue
		characters_array.append(_serialize_character(c))
	var now_unix: int = int(Time.get_unix_time_from_system())
	return {
		"save_version": CURRENT_SAVE_VERSION,
		"saved_at_unix": now_unix,
		"last_offline_at_unix": now_unix,
		"integrity_hash": "",  # populado em _write_with_rotation
		"account_data": {
			"currencies": {
				"gold": GameState.gold,
			},
			"configuracoes": {
				"show_enemy_hp_numbers": GameState.show_enemy_hp_numbers,
				"auto_collect_enabled": GameState.auto_collect_enabled,
				"gameplay_default_speed": GameState.game_speed,
			},
			"loja_eterna_compras": {
				"offline_cap_hours": 12,  # decisao #18
			},
			"ascension_count": 0,
			"bestiary": Bestiary.serialize(),
			"last_area_clears": GameState.last_area_clears.duplicate(true),
		},
		"characters": characters_array,
		"active_character_index": GameState.active_character_index,
	}

func _serialize_character(c: CharacterInstance) -> Dictionary:
	# Inventory v2: array slot-indexed. Cada elemento e' null OU
	# {"item_id": String, "qty": int}. Preserva nulls pra manter slot order
	# (sort destrutivo + drag/drop manual).
	var inv_array: Array = []
	for slot in c.inventory_slots:
		if slot == null:
			inv_array.append(null)
		else:
			var entry: Dictionary = {
				"item_id": String(slot.get("item_id", &"")),
				"qty": int(slot.get("qty", 0)),
			}
			# So persiste favorited quando true — minimiza tamanho do save
			# pros saves antigos sem o campo.
			if bool(slot.get("favorited", false)):
				entry["favorited"] = true
			inv_array.append(entry)
	# Artifacts: array slot-indexed, 16 slots. Cada slot null OU
	# {"item_id": String}. Artifacts sempre qty=1, nao stackam.
	var artifacts_array: Array = []
	for slot in c.artifact_slots:
		if slot == null:
			artifacts_array.append(null)
		else:
			artifacts_array.append({
				"item_id": String(slot.get("item_id", &"")),
			})
	# Equipment: {slot_str -> item_id_str_or_null}
	var equipment_dict: Dictionary = {}
	for slot in c.equipment.keys():
		var item: ItemData = c.equipment[slot]
		if item == null:
			equipment_dict[String(slot)] = null
		else:
			equipment_dict[String(slot)] = String(item.id)
	# Equipment favorites: array de slot_id strings que estao favoritados.
	var equipment_favorites_arr: Array = []
	for slot in c.equipment_favorites.keys():
		if bool(c.equipment_favorites[slot]):
			equipment_favorites_arr.append(String(slot))
	# Stat bonus: stringify keys
	var stat_bonus_dict: Dictionary = {}
	for k in c.stat_bonus.keys():
		stat_bonus_dict[String(k)] = int(c.stat_bonus[k])
	# Fase Exploration AQW: simplificado pra current_area_id + lista de areas
	# visitadas (substitui o sistema antigo de zone/area_index/stage_index).
	var unlocked_areas_arr: Array = []
	for aid in c.unlocked_areas:
		unlocked_areas_arr.append(String(aid))
	return {
		"data_id": String(c.data.id) if c.data != null else "",
		"level": c.level,
		"current_xp": c.current_xp,
		"current_hp": c.current_hp,
		"current_mp": c.current_mp,
		"stat_bonus": stat_bonus_dict,
		"unspent_stat_points": c.unspent_stat_points,
		"skill_points_unspent": c.skill_points_unspent,
		"unlocked_skill_nodes": _serialize_string_name_array(c.unlocked_skill_nodes),
		"current_area_id": String(c.current_area_id),
		"unlocked_areas": unlocked_areas_arr,
		"equipment": equipment_dict,
		"equipment_favorites": equipment_favorites_arr,
		"inventory_slots": inv_array,
		"artifact_slots": artifacts_array,
	}

func _deserialize_into_game_state(data: Dictionary) -> void:
	# Account
	var acc: Dictionary = data.get("account_data", {})
	var currencies: Dictionary = acc.get("currencies", {})
	GameState.gold = int(currencies.get("gold", 0))
	var cfg: Dictionary = acc.get("configuracoes", {})
	GameState.show_enemy_hp_numbers = bool(cfg.get("show_enemy_hp_numbers", true))
	GameState.auto_collect_enabled = bool(cfg.get("auto_collect_enabled", false))
	# Game speed — persistir e re-aplicar via setter pra atualizar Engine.time_scale.
	GameState.set_game_speed(int(cfg.get("gameplay_default_speed", 1)))
	# Bestiary (Fase 01 / B1)
	Bestiary.deserialize(acc.get("bestiary", {}))
	# Area clears comparativos (Fase 01 / B3)
	var last_clears: Dictionary = acc.get("last_area_clears", {})
	GameState.last_area_clears = last_clears.duplicate(true) if last_clears != null else {}
	# Characters
	GameState.owned_characters.clear()
	for char_dict in data.get("characters", []):
		var inst := _deserialize_character(char_dict)
		if inst != null:
			GameState.owned_characters.append(inst)
	GameState.active_character_index = int(data.get("active_character_index", 0))
	# NAO emitimos signals aqui — o `GameState._ready` faz `call_deferred`
	# em `_emit_initial_state` por padrao (sem-save) e o mesmo fluxo continua
	# valido quando carregamos: a Main scene ainda nao terminou de ser
	# instanciada quando este metodo roda durante o autoload bootstrap, entao
	# emitir agora seria perdido pelos listeners ainda nao conectados.

func _deserialize_character(d: Dictionary) -> CharacterInstance:
	var data_id: String = String(d.get("data_id", ""))
	if data_id == "":
		return null
	var path: String = "res://data/characters/%s.tres" % data_id
	if not ResourceLoader.exists(path):
		push_warning("SaveManager: missing CharacterData at %s" % path)
		return null
	var char_data: CharacterData = load(path)
	var inst: CharacterInstance = CharacterInstance.create(char_data)
	# Persisted scalars
	inst.level = int(d.get("level", 1))
	inst.current_xp = int(d.get("current_xp", 0))
	inst.current_hp = int(d.get("current_hp", inst.stats.max_hp))
	inst.current_mp = int(d.get("current_mp", inst.stats.max_mp))
	# Stat bonus
	inst.stat_bonus.clear()
	var sb_dict: Dictionary = d.get("stat_bonus", {})
	for k in sb_dict.keys():
		inst.stat_bonus[StringName(k)] = int(sb_dict[k])
	inst.unspent_stat_points = int(d.get("unspent_stat_points", 0))
	# Skill tree (Fase 01 / Bloco B)
	inst.skill_points_unspent = int(d.get("skill_points_unspent", 0))
	inst.unlocked_skill_nodes.clear()
	for raw in d.get("unlocked_skill_nodes", []):
		inst.unlocked_skill_nodes.append(StringName(String(raw)))
	# Fase Exploration AQW: area-based navigation.
	inst.current_area_id = StringName(String(d.get("current_area_id", "")))
	inst.unlocked_areas.clear()
	for aid in d.get("unlocked_areas", []):
		inst.unlocked_areas.append(StringName(String(aid)))
	# Inventory v2: array slot-indexed. Cada slot e' null OU dict com
	# {item_id, qty}. CharacterInstance.create() ja inicializa o array com
	# nulls no tamanho de max_inventory_slots(); aqui sobrescrevemos os
	# slots que tem item no save.
	inst._ensure_inventory_initialized()
	for i in inst.inventory_slots.size():
		inst.inventory_slots[i] = null
	var inv_array: Array = d.get("inventory_slots", [])
	for i in inv_array.size():
		if i >= inst.inventory_slots.size():
			break
		var entry = inv_array[i]
		if entry == null or not (entry is Dictionary):
			continue
		var item_id_str: String = String(entry.get("item_id", ""))
		var qty: int = int(entry.get("qty", 0))
		if item_id_str == "" or qty <= 0:
			continue
		var item_data: ItemData = _resolve_item_by_id(item_id_str)
		if item_data == null:
			continue
		inst.inventory_slots[i] = {
			"item_id": StringName(item_id_str),
			"item": item_data,
			"qty": qty,
			"favorited": bool(entry.get("favorited", false)),
		}
	# Equipment
	inst.equipment.clear()
	var eq_dict: Dictionary = d.get("equipment", {})
	for slot in eq_dict.keys():
		var eq_id_raw = eq_dict[slot]
		if eq_id_raw == null:
			continue
		var eq_id: String = str(eq_id_raw)
		if eq_id == "":
			continue
		var item: ItemData = _resolve_item_by_id(eq_id)
		if item != null:
			inst.equipment[StringName(slot)] = item
	# Equipment favorites — save antigo sem o campo = vazio (todos unfav).
	inst.equipment_favorites.clear()
	for slot_id_str in d.get("equipment_favorites", []):
		var sid: StringName = StringName(String(slot_id_str))
		if inst.equipment.has(sid):
			inst.equipment_favorites[sid] = true
	# Artifacts (Fase B+ drag/drop). Save antigo sem o campo -> init 16 nulls
	# (ja feito por _ensure_artifacts_initialized em create()).
	inst._ensure_artifacts_initialized()
	for i in inst.artifact_slots.size():
		inst.artifact_slots[i] = null
	var art_array: Array = d.get("artifact_slots", [])
	for i in art_array.size():
		if i >= inst.artifact_slots.size():
			break
		var entry = art_array[i]
		if entry == null or not (entry is Dictionary):
			continue
		var item_id_str: String = String(entry.get("item_id", ""))
		if item_id_str == "":
			continue
		var item_data: ItemData = _resolve_item_by_id(item_id_str)
		if item_data == null:
			continue
		inst.artifact_slots[i] = {
			"item_id": StringName(item_id_str),
			"item": item_data,
		}
	# Refresh stats apos restaurar equipment / stat_bonus.
	inst._refresh_stats()
	return inst

# --- Helpers de resolucao -------------------------------------------------

func _serialize_string_name_array(arr: Array) -> Array:
	var out: Array = []
	for v in arr:
		out.append(String(v))
	return out

func _resolve_item_by_id(id: String) -> ItemData:
	if id == "":
		return null
	return ItemRegistry.get_by_id(StringName(id))

# --- I/O com rotacao + hash -----------------------------------------------

func _write_with_rotation(data: Dictionary) -> bool:
	# Rotaciona backups: bak -> bak2; current -> bak.
	# Cada copia falha "soft" (warn) — nao aborta a gravacao do save novo.
	if FileAccess.file_exists(BAK_PATH):
		var err1: int = DirAccess.copy_absolute(BAK_PATH, BAK2_PATH)
		if err1 != OK:
			push_warning("SaveManager: bak -> bak2 copy failed (%d)" % err1)
	if FileAccess.file_exists(SAVE_PATH):
		var err2: int = DirAccess.copy_absolute(SAVE_PATH, BAK_PATH)
		if err2 != OK:
			push_warning("SaveManager: current -> bak copy failed (%d)" % err2)
	# Recalcular hash sobre o conteudo sem o proprio campo hash.
	var hash_input: String = JSON.stringify(_dict_without_hash(data), "", false)
	data["integrity_hash"] = hash_input.sha256_text()
	var f: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_warning("SaveManager: failed to open %s for write" % SAVE_PATH)
		return false
	f.store_string(JSON.stringify(data, "  ", false))
	f.close()
	return true

func _dict_without_hash(data: Dictionary) -> Dictionary:
	var copy: Dictionary = data.duplicate(true)
	copy.erase("integrity_hash")
	return copy

func _read_save_with_recovery() -> Dictionary:
	# Tenta primary -> bak -> bak2. Primeiro que validar schema vence.
	var paths: Array = [SAVE_PATH, BAK_PATH, BAK2_PATH]
	for p in paths:
		if not FileAccess.file_exists(p):
			continue
		var f: FileAccess = FileAccess.open(p, FileAccess.READ)
		if f == null:
			continue
		var content: String = f.get_as_text()
		f.close()
		var parsed: Variant = JSON.parse_string(content)
		if not (parsed is Dictionary):
			push_warning("SaveManager: %s nao parseou como JSON" % p)
			continue
		if not _validate_schema(parsed):
			push_warning("SaveManager: %s falhou no schema" % p)
			continue
		# Validar hash de integridade. Se inconsistente, log warning mas
		# carrega assim mesmo (modo cheat tolerado na Fase 0; modal de
		# confirmacao vem na Fase 02).
		_check_integrity_hash(parsed, p)
		return parsed
	return {}

func _validate_schema(d: Dictionary) -> bool:
	return d.has("save_version") and d.has("account_data") and d.has("characters")

func _check_integrity_hash(d: Dictionary, source_path: String) -> void:
	var stored_hash: String = String(d.get("integrity_hash", ""))
	if stored_hash == "":
		return
	var hash_input: String = JSON.stringify(_dict_without_hash(d), "", false)
	var actual_hash: String = hash_input.sha256_text()
	if stored_hash != actual_hash:
		push_warning("SaveManager: integrity hash mismatch in %s (save modificado manualmente?)" % source_path)

# --- Migracao -------------------------------------------------------------

func _migrate_save(data: Dictionary, from_version: int) -> Dictionary:
	if from_version < 2:
		data = _migrate_v1_to_v2(data)
	if from_version < 3:
		data = _migrate_v2_to_v3(data)
	data["save_version"] = CURRENT_SAVE_VERSION
	return data

# v2 -> v3 migration (Fase Exploration AQW):
#   Remove campos de stage/wave/zone (current_stage, current_wave_index,
#   current_zone, current_area_index, current_stage_index, last_completed_*,
#   unlocked_progress, unlocked_zones). Substitui por current_area_id +
#   unlocked_areas. Como nao temos mapping confiavel zone->area_id, joga
#   default pro starting_area do data correspondente (CharacterData).
func _migrate_v2_to_v3(data: Dictionary) -> Dictionary:
	for char_dict in data.get("characters", []):
		if not (char_dict is Dictionary):
			continue
		# Limpar campos antigos.
		var legacy_keys: Array = [
			"current_zone", "current_area_index", "current_stage_index",
			"current_stage_kills", "current_wave_index",
			"last_completed_zone", "last_completed_area_index",
			"last_completed_stage_index",
			"unlocked_progress", "unlocked_zones",
		]
		for key in legacy_keys:
			char_dict.erase(key)
		# Setar area inicial — descobre via CharacterData.starting_area.
		var data_id: String = String(char_dict.get("data_id", ""))
		var start_area: String = _resolve_starting_area_id(data_id)
		char_dict["current_area_id"] = start_area
		char_dict["unlocked_areas"] = [start_area] if start_area != "" else []
	return data

func _resolve_starting_area_id(data_id: String) -> String:
	if data_id == "":
		return ""
	var path: String = "res://data/characters/%s.tres" % data_id
	if not ResourceLoader.exists(path):
		return ""
	var char_data: CharacterData = load(path)
	if char_data == null or char_data.starting_area == null:
		return ""
	return String(char_data.starting_area.id)

# v1 -> v2 migration (Fase B+):
#   1. equipment.ring2 -> drop pro inventory; rename ring1 -> ring.
#   2. inventory: Dictionary {item_id: qty} -> inventory_slots: Array de
#      {item_id, qty}|null (size = max_inventory_slots do personagem).
func _migrate_v1_to_v2(data: Dictionary) -> Dictionary:
	var characters: Array = data.get("characters", [])
	for char_dict in characters:
		if not (char_dict is Dictionary):
			continue
		var inv_dict: Dictionary = char_dict.get("inventory", {})
		if not (inv_dict is Dictionary):
			inv_dict = {}
		# Equipment: ring2 vai pro inventory; ring1 -> ring.
		var eq = char_dict.get("equipment", {})
		if eq is Dictionary:
			var ring2_raw = eq.get("ring2", null)
			eq.erase("ring2")
			if eq.has("ring1"):
				# Se ring2 existia tambem, ring2 vai pro inventory abaixo;
				# ring1 vira o unico ring.
				eq["ring"] = eq["ring1"]
				eq.erase("ring1")
			if ring2_raw != null and String(ring2_raw) != "":
				var rid: String = String(ring2_raw)
				inv_dict[rid] = int(inv_dict.get(rid, 0)) + 1
			char_dict["equipment"] = eq
		# Resolver max slots do personagem pra dimensionar o array.
		var data_id: String = String(char_dict.get("data_id", ""))
		var max_slots: int = _resolve_max_slots(data_id)
		var inv_array: Array = []
		for _i in max_slots:
			inv_array.append(null)
		# Distribuir items do dict nos primeiros slots disponiveis. Ordem de
		# chegada eh ordem de iteracao das keys do dict — best-effort, sort
		# manual depois resolve.
		var slot_idx: int = 0
		for item_id in inv_dict.keys():
			if slot_idx >= max_slots:
				push_warning(
					"SaveManager: migration v1->v2 — inventory overflow para %s, descartando %s (qty=%d)"
					% [data_id, item_id, int(inv_dict[item_id])]
				)
				break
			var qty: int = int(inv_dict[item_id])
			if qty <= 0:
				continue
			inv_array[slot_idx] = {
				"item_id": String(item_id),
				"qty": qty,
			}
			slot_idx += 1
		char_dict["inventory_slots"] = inv_array
		char_dict.erase("inventory")
	return data

# Le inventory_max_slots do CharacterData .tres. Fallback 16 (default da
# Fase 0) se data_id invalido.
func _resolve_max_slots(data_id: String) -> int:
	if data_id == "":
		return 16
	var path: String = "res://data/characters/%s.tres" % data_id
	if not ResourceLoader.exists(path):
		return 16
	var char_data: CharacterData = load(path)
	if char_data == null:
		return 16
	return char_data.inventory_max_slots

# Autosave agora roda em `_process` via unix-time gating (acima). O metodo
# antigo `_on_autosave_tick` foi removido em favor desse approach pra nao
# ser afetado por `Engine.time_scale` quando o user mudar speed do jogo.
