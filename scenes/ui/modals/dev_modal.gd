extends ModalBase

# Developer cheats / sandbox tools. Lives behind a Dev button on the
# BattleView; opening it routes through the standard modal pipeline so it
# inherits Esc-to-close + backdrop click-out.

const STARTING_AREA_ID: StringName = &"prototype_area_1"

# Diretorio de items. Scaneado a cada open pra refletir items novos
# adicionados em runtime. Subpasta `templates/` eh ignorada (templates
# nao devem aparecer no dev menu).
const ITEMS_DIR: String = "res://data/items/"

@onready var unlock_btn: Button = $Center/Panel/Margin/Box/Content/UnlockMapBtn
@onready var unlock_status: Label = $Center/Panel/Margin/Box/Content/UnlockStatus
@onready var wave_grid: GridContainer = $Center/Panel/Margin/Box/Content/WaveGrid
@onready var simulate_offline_btn: Button = $Center/Panel/Margin/Box/Content/SimulateOfflineBtn
@onready var items_search_edit: LineEdit = $Center/Panel/Margin/Box/Content/ItemsSearchEdit
@onready var items_list: VBoxContainer = $Center/Panel/Margin/Box/Content/ItemsScroll/ItemsList

const OFFLINE_SIM_SECONDS: int = 3600  # 1h

# Cache da ultima leitura dos items, pra filtro nao precisar reler de disco.
var _all_items: Array[ItemData] = []

func _ready() -> void:
	title_text = "Developer Tools"
	super._ready()
	unlock_btn.pressed.connect(_on_unlock_all_pressed)
	simulate_offline_btn.pressed.connect(_on_simulate_offline_pressed)
	# Spawn enemy: forca o WorldController a re-spawnar inimigos nos pontos
	# disponiveis da area atual (util pra resetar). Antes era wave-based.
	var spawn_btn := Button.new()
	spawn_btn.text = "Re-spawn enemies"
	spawn_btn.custom_minimum_size = Vector2(0, 28)
	spawn_btn.pressed.connect(func(): EventBus.dev_spawn_enemy_requested.emit())
	wave_grid.add_child(spawn_btn)
	# Filtro do items list.
	items_search_edit.text_changed.connect(_on_items_search_changed)

func _on_open() -> void:
	_refresh_status()
	# Re-scan items a cada abertura — refleta items novos adicionados em
	# data/items/ depois do ultimo open.
	_all_items = _load_all_items()
	_rebuild_items_list(items_search_edit.text)

func _on_unlock_all_pressed() -> void:
	var character := GameState.get_active_character()
	if character == null:
		return
	# Fase Exploration: agora desbloqueia todas areas conhecidas via
	# helper do CharacterInstance (placeholder — areas sao independentes
	# de zones por enquanto). Por enquanto so faz refresh.
	_refresh_status()

func _refresh_status() -> void:
	var character := GameState.get_active_character()
	if character == null:
		unlock_status.text = "No active character."
		return
	unlock_status.text = "Character: %s (Lv %d)" % [character.display_name(), character.level]

# Simula `OFFLINE_SIM_SECONDS` (1h) sem fechar o jogo. Cria um save_dict
# fake a partir do estado atual do GameState com `last_offline_at_unix`
# rebobinado e dispara o sinal que o ModalLayer ja escuta.
func _on_simulate_offline_pressed() -> void:
	var now: int = int(Time.get_unix_time_from_system())
	# Snapshot leve do estado, sem gravar em disco.
	var save_dict: Dictionary = SaveManager.build_save_snapshot()
	save_dict["last_offline_at_unix"] = now - OFFLINE_SIM_SECONDS
	var summary: Dictionary = OfflineSimulator.simulate(save_dict, now)
	if int(summary.get("delta_t_seconds", 0)) >= 60:
		close()  # fecha o dev modal antes de abrir o offline modal
		EventBus.offline_progress_calculated.emit(summary)

# === Items list ============================================================

# Delegado pro ItemRegistry (autoload), que escaneia ITEMS_DIR recursivamente
# e filtra templates/. Mantido como wrapper pra preservar tipo Array[ItemData]
# usado pelo filtro local.
func _load_all_items() -> Array[ItemData]:
	return ItemRegistry.get_all()

func _on_items_search_changed(new_text: String) -> void:
	_rebuild_items_list(new_text)

# Reconstroi a UI de items, opcionalmente filtrando por substring no
# display_name (case-insensitive).
func _rebuild_items_list(filter: String) -> void:
	# Limpar children existentes.
	for child in items_list.get_children():
		child.queue_free()
	var query: String = filter.to_lower().strip_edges()
	for item in _all_items:
		if query != "" and not String(item.display_name).to_lower().contains(query):
			continue
		items_list.add_child(_make_item_row(item))
	# Empty state.
	if items_list.get_child_count() == 0:
		var empty := Label.new()
		empty.text = "Nenhum item encontrado." if query != "" else "Nenhum item em data/items/."
		empty.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1))
		empty.add_theme_font_size_override("font_size", 12)
		items_list.add_child(empty)

# Constroi uma linha pra um item: [icon] [nome (type)] [+1] [+10 se stackable].
func _make_item_row(item: ItemData) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Icon.
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(32, 32)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if item.has_method("get_sprite"):
		icon.texture = item.get_sprite()
	else:
		icon.texture = item.sprite
	row.add_child(icon)
	# Nome + tipo.
	var name_label := Label.new()
	name_label.text = "%s  [%s]" % [item.display_name, _item_type_label(item)]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 14)
	row.add_child(name_label)
	# +1 button.
	var add1 := Button.new()
	add1.text = "+1"
	add1.custom_minimum_size = Vector2(44, 28)
	add1.pressed.connect(func(): _on_add_item_pressed(item, 1))
	row.add_child(add1)
	# +10 button so pra stackable.
	if item.stackable:
		var add10 := Button.new()
		add10.text = "+10"
		add10.custom_minimum_size = Vector2(48, 28)
		add10.pressed.connect(func(): _on_add_item_pressed(item, 10))
		row.add_child(add10)
	return row

# Texto curto pro tipo do item (e.g. "Weapon", "Material").
func _item_type_label(item: ItemData) -> String:
	match int(item.item_type):
		0: return "Material"
		1: return "Weapon"
		2: return "Consumable"
		3: return "Armor"
		4: return "Accessory"
		5: return "Tool"
		6: return "Artifact"
	return "?"

# Adiciona o item ao personagem ativo. Artifacts vao pro primeiro slot vazio
# de artifact (NAO entram no inventory); resto vai pro inventory normal.
func _on_add_item_pressed(item: ItemData, qty: int) -> void:
	var character: CharacterInstance = GameState.get_active_character()
	if character == null:
		push_warning("DevModal: no active character")
		return
	if int(item.item_type) == int(ItemData.ItemType.ARTIFACT):
		# Primeiro artifact slot vazio.
		character._ensure_artifacts_initialized()
		for i in character.artifact_slots.size():
			if character.get_artifact(i) == null:
				character.set_artifact(i, item)
				return
		push_warning("DevModal: nenhum artifact slot vazio.")
		return
	# Inventory normal (qualquer outro tipo).
	GameState.add_item_to_character(character, item, qty)
