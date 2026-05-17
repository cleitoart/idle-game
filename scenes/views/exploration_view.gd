extends Control

# ExplorationView (Fase Exploration AQW) — substitui o BattleView antigo.
#
# Root Control fullscreen pra integrar no ViewContainer do main. Filhos:
#   - WorldRoot (Node2D): onde a area scene eh instanciada.
#   - WorldController (Node): orquestra spawn / combat / portais.
#   - Overlay (Control com AutoCombatToggle).
#
# Input flow:
#   - Click em Overlay (botoes) -> consumed by Control.
#   - Click em enemy Area2D -> enemy.input_event handler chama
#     set_input_as_handled() pra evitar que _unhandled_input dispare ground move.
#   - Click em outro lugar -> _unhandled_input -> ground click.

const STARTING_AREA_ID: StringName = &"prototype_area_1"

@onready var _world_root: Node2D = $WorldRoot
@onready var _world_controller: Node = $WorldController
@onready var _auto_combat_btn: Button = $Overlay/AutoCombatBtn

var _loaded_initial: bool = false

func _ready() -> void:
	# STOP captura clicks dentro da view; gui_input dispara ground-click.
	# Enemy Area2D fire ANTES do gui_input via input_event signal e chama
	# set_input_as_handled — Godot pula gui_input nesses casos.
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)
	_world_controller.set_world_root(_world_root)
	_auto_combat_btn.toggled.connect(_on_auto_combat_toggled)
	visibility_changed.connect(_on_visibility_changed)
	call_deferred("_try_initial_load")

func _try_initial_load() -> void:
	if _loaded_initial:
		return
	if GameState.get_active_character() == null:
		return
	_loaded_initial = true
	# Tenta carregar a area do save; fallback pra starting area.
	var character: CharacterInstance = GameState.get_active_character()
	var target_id: StringName = character.current_area_id
	if target_id == &"":
		if character.data != null and character.data.starting_area != null:
			target_id = character.data.starting_area.id
		else:
			target_id = STARTING_AREA_ID
	EventBus.area_change_requested.emit(target_id)

func _on_visibility_changed() -> void:
	if visible and not _loaded_initial:
		_try_initial_load()

# Captura clicks (Control STOP). Pra cada click esquerdo:
#   1. Query no espaco fisico 2D pra ver se ha enemy ClickArea sob o cursor.
#   2. Se sim -> enemy_clicked (player vai engajar combate).
#   3. Senao -> ground click (player anda ate a posicao livre).
#
# Centralizar tudo aqui evita race entre Area2D.input_event e gui_input do
# Control, que antes podia consumir o evento antes do Area2D processar.
func _on_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	if not (event is InputEventMouseButton):
		return
	if not event.pressed:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	var world_pos: Vector2 = get_global_mouse_position()
	var clicked_enemy: Node = _find_enemy_at(world_pos)
	if clicked_enemy != null:
		EventBus.enemy_clicked.emit(clicked_enemy)
	elif _world_controller.has_method("handle_ground_click"):
		_world_controller.handle_ground_click(world_pos)
	accept_event()

# Busca o enemy mais proximo do click dentro de um raio. Distance check
# simples — mais robusto que physics_point_query (que dependia da Area2D
# estar registrada no servidor de fisica no momento do click).
const CLICK_RADIUS: float = 80.0

func _find_enemy_at(world_pos: Vector2) -> Node:
	var nearest: Node = null
	var nearest_dist: float = CLICK_RADIUS
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy) or enemy.get("is_dead"):
			continue
		var d: float = world_pos.distance_to((enemy as Node2D).global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = enemy
	return nearest

func _on_auto_combat_toggled(pressed: bool) -> void:
	EventBus.auto_combat_toggled.emit(pressed)
