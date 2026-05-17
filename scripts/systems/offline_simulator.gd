class_name OfflineSimulator
extends RefCounted

# OfflineSimulator (Fase 0).
#
# Calcula o progresso simulado de cada personagem durante o tempo que o
# jogo ficou fechado. Resultado e' um sumario que o `offline_summary_modal`
# apresenta e o usuario aceita via "Coletar tudo".
#
# Decisoes da Fase 0 que estao codificadas aqui:
#   - cap default 12h (decisao #18). Loja Eterna desbloqueia 24/48/72h em
#     fases posteriores via campo `offline_cap_hours` no save.
#   - simulacao NAO avanca areas/zonas durante offline. Personagem so farma
#     onde parou (default sugerido em save-offline-spec D5).
#   - clamp `delta_t` em zero se `now < last` (anti-cheating de relogio).
#   - drops simulados consolidam em qty (nao gera item-por-item).
#
# Valores de kills/s, xp/kill e gold/kill sao PLACEHOLDERS conservadores e
# devem ser substituidos por estimativas reais a partir de `02_math/balance-tables.md`
# em fases posteriores.

# Fallback de farm rate quando nao temos estimativa real do estagio.
const KILLS_PER_SECOND_FALLBACK: float = 0.5  # 30 kills/min
# Placeholders ate Fase 02+ ler valores de zone/stage/area.
const PLACEHOLDER_XP_PER_KILL: int = 5
const PLACEHOLDER_GOLD_PER_KILL: int = 1
# Drop consolidado base. Fase 02+ deriva de current_zone.area.enemies.loot_table.
const PLACEHOLDER_DROP_TABLE: Array = [
	{"item_id": "slime_goo", "chance": 0.6},
]

# Resultado:
# {
#   "delta_t_seconds": int,
#   "capped": bool,
#   "characters": [
#     {
#       "data_id": String,
#       "activity": "combat",
#       "xp_gained": int,
#       "gold_gained": int,
#       "kills": int,
#       "materials": { "slime_goo": qty, ... },
#     }
#   ]
# }
static func simulate(save_dict: Dictionary, now_unix: int) -> Dictionary:
	var last_unix: int = int(save_dict.get("last_offline_at_unix", now_unix))
	var account: Dictionary = save_dict.get("account_data", {})
	var loja: Dictionary = account.get("loja_eterna_compras", {})
	var cap_hours: int = int(loja.get("offline_cap_hours", 12))
	# Anti-relogio: se now < last (clock manipulado para tras), trata como 0.
	var raw_delta: int = max(0, now_unix - last_unix)
	var cap_seconds: int = cap_hours * 3600
	var capped: bool = raw_delta > cap_seconds
	var delta_t: int = min(raw_delta, cap_seconds)
	if delta_t < 60:
		# Pouco tempo offline — nao mostrar modal.
		return {
			"delta_t_seconds": delta_t,
			"capped": false,
			"characters": [],
		}
	var per_char_summary: Array = []
	for char_dict in save_dict.get("characters", []):
		per_char_summary.append(_simulate_character(char_dict, delta_t))
	return {
		"delta_t_seconds": delta_t,
		"capped": capped,
		"characters": per_char_summary,
	}

static func _simulate_character(char_dict: Dictionary, delta_t: int) -> Dictionary:
	# Fase 0: assume combate na current_stage. Activity field e' Fase 02+.
	var kps: float = _kills_per_second_estimate(char_dict)
	var total_kills: int = int(kps * float(delta_t))
	var xp_per_kill: int = _avg_xp_per_kill(char_dict)
	var gold_per_kill: int = _avg_gold_per_kill(char_dict)
	var xp_total: int = total_kills * xp_per_kill
	var gold_total: int = total_kills * gold_per_kill
	# Drops materiais consolidados em qty.
	var materials: Dictionary = {}
	var drop_table: Array = _drop_table_for(char_dict)
	for entry in drop_table:
		var chance: float = float(entry.get("chance", 0.0))
		var expected: float = float(total_kills) * chance
		if expected >= 1.0:
			# Variacao leve para nao parecer deterministico.
			var qty: int = int(round(expected * randf_range(0.85, 1.15)))
			if qty > 0:
				materials[String(entry.get("item_id", ""))] = qty
	return {
		"data_id": String(char_dict.get("data_id", "unknown")),
		"activity": "combat",
		"xp_gained": xp_total,
		"gold_gained": gold_total,
		"kills": total_kills,
		"materials": materials,
	}

# --- Estimadores (placeholders conservadores) -----------------------------

static func _kills_per_second_estimate(_char_dict: Dictionary) -> float:
	# Fase 02+: derivar de balance-tables.md baseado em (zone, stage, area).
	return KILLS_PER_SECOND_FALLBACK

static func _avg_xp_per_kill(_char_dict: Dictionary) -> int:
	return PLACEHOLDER_XP_PER_KILL

static func _avg_gold_per_kill(_char_dict: Dictionary) -> int:
	return PLACEHOLDER_GOLD_PER_KILL

static func _drop_table_for(_char_dict: Dictionary) -> Array:
	# Fase 02+: ler enemy.loot_table de current_zone+area e consolidar.
	return PLACEHOLDER_DROP_TABLE
