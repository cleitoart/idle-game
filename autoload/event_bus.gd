extends Node

signal gold_changed(new_amount: int)
signal active_character_changed(character: CharacterInstance)
signal character_inventory_changed(character: CharacterInstance)
signal character_xp_changed(character: CharacterInstance, current_xp: int)
signal character_hp_changed(character: CharacterInstance, current_hp: int, max_hp: int)
signal character_stage_changed(character: CharacterInstance, stage: StageData)
signal enemy_killed(character: CharacterInstance, enemy: EnemyData)
signal view_requested(view_id: int)
signal modal_requested(modal_id: StringName)
signal footer_mode_requested(mode_id: StringName)
