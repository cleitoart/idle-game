class_name SkillTree
extends RefCounted

# Skill Tree (Fase 01 / Bloco B - placeholder textual).
#
# Cada nó: {id, branch, name, desc, prereq, bonuses}
# - id: StringName unico
# - branch: "berserker" / "defender" / "tactician"
# - name: rotulo curto
# - desc: explicacao 1-linha
# - prereq: id de outro nó (string vazia = sem pre-req, raiz do ramo)
# - bonuses: dict de stats a somar em CombatStats
#
# Custos sao 1 skill point por nó. Ganha 1 skill point por level.
# Nós nao sao resetaveis ainda — pergaminho de reset chega na Fase 02.
#
# Em Fase 02+: vira `SkillTreeData` Resource com edicao visual no editor +
# skills ativas (cooldown) em vez de so passivas.

const NODES_WARRIOR: Array = [
	# --- Berserker (DPS) ---
	{
		"id": "berserk_atk_1",
		"branch": "berserker",
		"name": "Berserker: Forca Crescente I",
		"desc": "+2 ATK",
		"prereq": "",
		"bonuses": {"atk": 2},
	},
	{
		"id": "berserk_atk_2",
		"branch": "berserker",
		"name": "Berserker: Forca Crescente II",
		"desc": "+3 ATK",
		"prereq": "berserk_atk_1",
		"bonuses": {"atk": 3},
	},
	{
		"id": "berserk_crit_1",
		"branch": "berserker",
		"name": "Berserker: Olho do Predador",
		"desc": "+5% Crit Chance",
		"prereq": "berserk_atk_1",
		"bonuses": {"crit_chance": 0.05},
	},
	{
		"id": "berserk_crit_2",
		"branch": "berserker",
		"name": "Berserker: Golpe Devastador",
		"desc": "+0.25x Crit Damage",
		"prereq": "berserk_crit_1",
		"bonuses": {"crit_damage": 0.25},
	},
	{
		"id": "berserk_speed",
		"branch": "berserker",
		"name": "Berserker: Furia",
		"desc": "+0.10/s Attack Speed",
		"prereq": "berserk_atk_2",
		"bonuses": {"attack_speed": 0.10},
	},
	{
		"id": "berserk_lifesteal",
		"branch": "berserker",
		"name": "Berserker: Sede de Sangue",
		"desc": "+5% Life Steal",
		"prereq": "berserk_speed",
		"bonuses": {"life_steal": 0.05},
	},
	# --- Defender (TANK) ---
	{
		"id": "def_hp_1",
		"branch": "defender",
		"name": "Defender: Vitalidade I",
		"desc": "+15 HP Max",
		"prereq": "",
		"bonuses": {"max_hp": 15},
	},
	{
		"id": "def_def_1",
		"branch": "defender",
		"name": "Defender: Pele de Aco I",
		"desc": "+2 DEF",
		"prereq": "def_hp_1",
		"bonuses": {"def": 2},
	},
	{
		"id": "def_hp_2",
		"branch": "defender",
		"name": "Defender: Vitalidade II",
		"desc": "+30 HP Max",
		"prereq": "def_hp_1",
		"bonuses": {"max_hp": 30},
	},
	{
		"id": "def_block",
		"branch": "defender",
		"name": "Defender: Postura Solida",
		"desc": "+10% Block Chance",
		"prereq": "def_def_1",
		"bonuses": {"block_chance": 0.10},
	},
	{
		"id": "def_regen",
		"branch": "defender",
		"name": "Defender: Recuperacao",
		"desc": "+1.0/s HP Regen",
		"prereq": "def_hp_2",
		"bonuses": {"hp_regen": 1.0},
	},
	{
		"id": "def_def_2",
		"branch": "defender",
		"name": "Defender: Pele de Aco II",
		"desc": "+4 DEF",
		"prereq": "def_block",
		"bonuses": {"def": 4},
	},
	# --- Tactician (UTIL) ---
	{
		"id": "tact_dodge_1",
		"branch": "tactician",
		"name": "Tactician: Reflexos",
		"desc": "+5% Dodge Chance",
		"prereq": "",
		"bonuses": {"dodge_chance": 0.05},
	},
	{
		"id": "tact_loot",
		"branch": "tactician",
		"name": "Tactician: Olho de Aguia",
		"desc": "+15% Loot Gain",
		"prereq": "tact_dodge_1",
		"bonuses": {"loot_gain_pct": 15.0},
	},
	{
		"id": "tact_xp",
		"branch": "tactician",
		"name": "Tactician: Experiencia",
		"desc": "+10% EXP Gain",
		"prereq": "tact_dodge_1",
		"bonuses": {"exp_gain_pct": 10.0},
	},
	{
		"id": "tact_gold",
		"branch": "tactician",
		"name": "Tactician: Mercador",
		"desc": "+15% Gold Gain",
		"prereq": "tact_loot",
		"bonuses": {"gold_gain_pct": 15.0},
	},
	{
		"id": "tact_dodge_2",
		"branch": "tactician",
		"name": "Tactician: Reflexos II",
		"desc": "+5% Dodge Chance",
		"prereq": "tact_xp",
		"bonuses": {"dodge_chance": 0.05},
	},
	{
		"id": "tact_extra_hit",
		"branch": "tactician",
		"name": "Tactician: Golpe Sutil",
		"desc": "+5% Extra Hit",
		"prereq": "tact_gold",
		"bonuses": {"extra_hit": 0.05},
	},
]

# Lookup por id (cacheado).
static var _nodes_by_id: Dictionary = {}

static func _ensure_cache() -> void:
	if _nodes_by_id.is_empty():
		for node in NODES_WARRIOR:
			_nodes_by_id[StringName(String(node["id"]))] = node

# Busca um nó por id. Retorna {} se nao existe.
static func get_node(node_id: StringName) -> Dictionary:
	_ensure_cache()
	return _nodes_by_id.get(node_id, {})

# Lista todos os nós de um ramo.
static func get_nodes_by_branch(branch: String) -> Array:
	var out: Array = []
	for node in NODES_WARRIOR:
		if String(node["branch"]) == branch:
			out.append(node)
	return out

# Lista TODOS os nós (planos, todos os ramos).
static func get_all_nodes() -> Array:
	return NODES_WARRIOR

# Pode desbloquear? Verifica skill points + prereq.
static func can_unlock(character: CharacterInstance, node_id: StringName) -> bool:
	if character == null:
		return false
	var node: Dictionary = get_node(node_id)
	if node.is_empty():
		return false
	if character.unlocked_skill_nodes.has(node_id):
		return false  # ja desbloqueado
	if character.skill_points_unspent <= 0:
		return false
	var prereq: String = String(node.get("prereq", ""))
	if prereq != "" and not character.unlocked_skill_nodes.has(StringName(prereq)):
		return false
	return true

# Desbloqueia o nó. Retorna true se sucedeu. Aplica os bonuses via _refresh_stats.
static func unlock(character: CharacterInstance, node_id: StringName) -> bool:
	if not can_unlock(character, node_id):
		return false
	character.unlocked_skill_nodes.append(node_id)
	character.skill_points_unspent -= 1
	character._refresh_stats()
	EventBus.character_stats_changed.emit(character)
	return true

# Aplica bonuses de TODOS os nós desbloqueados em um CombatStats. Chamado
# por `CombatStats._from_instance` durante `_refresh_stats`.
static func apply_bonuses(character: CharacterInstance, s: CombatStats) -> void:
	if character == null or s == null:
		return
	for node_id in character.unlocked_skill_nodes:
		var node: Dictionary = get_node(node_id)
		if node.is_empty():
			continue
		var bonuses: Dictionary = node.get("bonuses", {})
		_apply_bonus_dict(s, bonuses)

# Soma cada chave do dict no campo correspondente do CombatStats.
static func _apply_bonus_dict(s: CombatStats, bonuses: Dictionary) -> void:
	for key in bonuses.keys():
		var val = bonuses[key]
		match String(key):
			"max_hp":
				s.max_hp += int(val)
			"max_mp":
				s.max_mp += int(val)
			"atk":
				s.atk += int(val)
			"def":
				s.def += int(val)
			"attack_speed":
				s.attack_speed += float(val)
			"crit_chance":
				s.crit_chance += float(val)
			"crit_damage":
				s.crit_damage += float(val)
			"block_chance":
				s.block_chance += float(val)
			"dodge_chance":
				s.dodge_chance += float(val)
			"hit_chance":
				s.hit_chance += float(val)
			"life_steal":
				s.life_steal += float(val)
			"hp_regen":
				s.hp_regen += float(val)
			"loot_gain_pct":
				s.loot_gain_pct += float(val)
			"exp_gain_pct":
				s.exp_gain_pct += float(val)
			"gold_gain_pct":
				s.gold_gain_pct += float(val)
			"extra_hit":
				s.extra_hit += float(val)
			_:
				push_warning("SkillTree.apply_bonuses: unknown stat key '%s'" % String(key))
