extends Node

signal gold_changed(new_amount: int)
signal active_character_changed(character: CharacterInstance)
signal character_inventory_changed(character: CharacterInstance)
signal character_xp_changed(character: CharacterInstance, current_xp: int)
signal character_hp_changed(character: CharacterInstance, current_hp: int, max_hp: int)
signal enemy_killed(character: CharacterInstance, enemy: EnemyData)
signal item_picked_up(item: ItemData, qty: int)
signal view_requested(view_id: int)
signal modal_requested(modal_id: StringName)

# Settings toggles
signal show_enemy_hp_numbers_changed(enabled: bool)

# Battle log
signal battle_log_added(entry: Dictionary)
signal battle_log_cleared()
signal battle_log_toggle_requested()

# Dev tools
signal dev_spawn_enemy_requested()

# Levels & stats
signal character_leveled_up(character: CharacterInstance, new_level: int)
signal character_stats_changed(character: CharacterInstance)
# Equipment slot / artifact slot mudou (set_equipment / set_artifact). Emitido
# alem do character_stats_changed (que tambem dispara em cascata via
# _refresh_stats). UI pode escutar so este pra refresh do equip layout.
signal character_equipment_changed(character: CharacterInstance)

# Save/Load + Offline progression (Fase 0).
signal save_loaded()
signal save_completed()
signal save_failed(reason: String)
signal offline_progress_calculated(summary: Dictionary)

# Bestiary (Fase 01 / B1).
signal bestiary_updated(enemy_id: StringName, total_kills: int)

# Game speed toggle (Fase 01 / B2).
signal game_speed_changed(speed: int)

# Area cleared / killed-out (futuro: AQW pode dar bonus por clear total).
signal area_cleared(character: CharacterInstance, summary: Dictionary)

# Gathering battle (Fase 01 / Bloco B+ - mining as battle).
# Emitido pelo map_modal quando o jogador escolhe um spot de coleta. O
# WorldController escuta e troca pra gather mode (ainda na arquitetura antiga
# do gathering_view; refactor posterior).
signal gathering_spot_requested(spot_data: GatheringSpotData)

# --- Exploration AQW (Fase atual) ----------------------------------------
# Carregar uma area (via portal ou via map modal). WorldController escuta.
signal area_change_requested(area_id: StringName)
# WorldController confirma carga e popula spawn points.
signal area_loaded(area_data: AreaSceneData)
# Click do player num inimigo no mundo. Capturado pelo WorldController pra
# definir alvo e mover player ate ele.
signal enemy_clicked(enemy: Node)
# Alvo ativo do player mudou (UI pode highlight, etc).
signal world_target_changed(target: Node)
# UI toggle "Auto" — quando ativo, player auto-seleciona proximo inimigo
# apos kill + dispara skills em CD.
signal auto_combat_toggled(enabled: bool)
# Skill foi cast (UI pode mostrar feedback).
signal skill_cast(skill_id: StringName, caster: CharacterInstance, target: Node)
