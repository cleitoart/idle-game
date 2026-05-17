extends Node

const WARRIOR_DATA_PATH: String = "res://data/characters/warrior.tres"

var owned_characters: Array[CharacterInstance] = []
var active_character_index: int = 0
var gold: int = 0
# Ultimo summary de cada (zone, area, stage) para o modal de resultados
# mostrar comparativo "X segundos mais rapido". Chave:
# `<zone_id>_<area_idx>_<stage_idx>` (ver `AreaClearTracker.make_key`).
# Persistido em `account_data.last_area_clears`.
var last_area_clears: Dictionary = {}
# Hook for the future auto-collect skill. When true, item drops skip the
# physical drop and go straight to the active character's inventory.
var auto_collect_enabled: bool = false

# Settings toggles (defaults). When the Settings view exposes UI controls, it
# reads/writes these via the public getters/setters below.
var show_enemy_hp_numbers: bool = true
# Game speed (Fase 01 / B2). Decisao #14: 1x e 2x sao default desde inicio.
# 4x e 8x sao unlocks futuros (Renascimento / Loja Eterna).
var game_speed: int = 1

func _ready() -> void:
	# Tenta carregar save existente. Se houver, ele popula owned_characters,
	# gold, settings, etc. Caso contrario, cria o Warrior default.
	var loaded: bool = false
	if SaveManager.has_save():
		loaded = SaveManager.load_game()
	if not loaded:
		var warrior_data: CharacterData = load(WARRIOR_DATA_PATH)
		if warrior_data != null:
			owned_characters.append(CharacterInstance.create(warrior_data))
	# Sempre emitir refresh inicial em deferred — a Main scene ainda nao
	# terminou de instanciar quando este _ready roda (somos autoload), entao
	# os listeners da UI so estarao prontos no proximo frame.
	call_deferred("_emit_initial_state")
	# Hooks para autosave em momentos chave. Autosave periodico ja roda no
	# proprio SaveManager via Timer.
	EventBus.character_leveled_up.connect(_on_character_event_for_save.unbind(2))

func _emit_initial_state() -> void:
	EventBus.gold_changed.emit(gold)
	var active: CharacterInstance = get_active_character()
	if active != null:
		EventBus.active_character_changed.emit(active)

func get_active_character() -> CharacterInstance:
	if owned_characters.is_empty():
		return null
	if active_character_index < 0 or active_character_index >= owned_characters.size():
		return null
	return owned_characters[active_character_index]

func set_active_character(index: int) -> void:
	if index < 0 or index >= owned_characters.size():
		return
	active_character_index = index
	var active: CharacterInstance = get_active_character()
	if active != null:
		EventBus.active_character_changed.emit(active)

# Future-proofing para multi-personagem (Fase 02+). Permite buscar um
# personagem pelo `data.id` quando o roster tiver mais de um. Ainda nao usado
# em chamadas existentes; existe para que codigo novo nao assuma "single
# character" e sim "lookup explicito por id".
func get_character_by_id(character_id: StringName) -> CharacterInstance:
	for c in owned_characters:
		if c != null and c.data != null and c.data.id == character_id:
			return c
	return null

func add_gold(amount: int) -> void:
	if amount <= 0:
		return
	gold += amount
	EventBus.gold_changed.emit(gold)

func is_auto_collect_enabled() -> bool:
	return auto_collect_enabled

func is_show_enemy_hp_numbers_enabled() -> bool:
	return show_enemy_hp_numbers

func set_show_enemy_hp_numbers(value: bool) -> void:
	if show_enemy_hp_numbers == value:
		return
	show_enemy_hp_numbers = value
	EventBus.show_enemy_hp_numbers_changed.emit(value)

# Velocidade do jogo (1x ou 2x na Fase 01). Aplica direto em
# `Engine.time_scale`, que afeta animacoes, cooldowns e Timers do node tree.
# Timers reais (offline simulator, autosave) usam unix time e NAO sao
# afetados — ver `save_manager.gd::_process` e `offline_simulator.gd`.
func set_game_speed(speed: int) -> void:
	speed = clamp(speed, 1, 2)
	if game_speed == speed:
		return
	game_speed = speed
	Engine.time_scale = float(speed)
	EventBus.game_speed_changed.emit(speed)

func get_game_speed() -> int:
	return game_speed

func add_item_to_character(character: CharacterInstance, item: ItemData, qty: int) -> int:
	if character == null:
		return 0
	var added: int = character.add_item(item, qty)
	if added > 0:
		EventBus.character_inventory_changed.emit(character)
		EventBus.item_picked_up.emit(item, added)
	return added

func add_xp_to_character(character: CharacterInstance, xp: int) -> void:
	if character == null or xp <= 0:
		return
	character.add_xp(xp)
	EventBus.character_xp_changed.emit(character, character.current_xp)

func register_kill_for_character(character: CharacterInstance, enemy: EnemyData) -> void:
	if character == null:
		return
	character.register_kill()
	# Bestiary global tracking — sempre, independente do personagem.
	Bestiary.register_kill(enemy)
	EventBus.enemy_killed.emit(character, enemy)

# Hook para gravacao oportunista. Marcado como `deferred` para nao gravar
# durante a chain de signals do level-up (e' barato mas o file I/O pode dar
# stutter visivel se acontecer dentro do mesmo frame). O autosave Timer
# (60s) cobre o caso geral; este garante que level-ups (eventos significantes)
# nao sejam perdidos por crash entre ticks.
func _on_character_event_for_save() -> void:
	call_deferred("_save_now")

func _save_now() -> void:
	if has_node("/root/SaveManager"):
		SaveManager.save_game()
