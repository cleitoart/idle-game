extends ModalBase

# Modal do Bestiario (Fase 01 / B1).
#
# Lista todos os inimigos conhecidos pelo projeto (carregados de
# `data/enemies/*.tres`). Para cada um:
#   - Se descoberto -> mostra nome + kill count.
#   - Se nao descoberto -> mostra "?????" + "0 kills".
#
# Sem buffs ainda. Mob Slaughter (marcos de 10/100/1k/10k/...) chega na
# Fase 02-03. Aqui apenas tracking visual.

const ENEMIES_DIR: String = "res://data/enemies/"

@onready var summary_row: Label = $Center/Panel/Margin/Box/Content/SummaryRow
@onready var list: VBoxContainer = $Center/Panel/Margin/Box/Content/Scroll/List

var _all_enemies_cache: Array[EnemyData] = []

func _ready() -> void:
	title_text = "Bestiary"
	super._ready()
	EventBus.bestiary_updated.connect(_on_bestiary_updated.unbind(2))

func _on_open() -> void:
	_refresh()

func _on_bestiary_updated() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	if _all_enemies_cache.is_empty():
		_all_enemies_cache = _load_all_enemies()
	# Sumario topo
	var discovered: int = Bestiary.get_all_discovered().size()
	var total: int = Bestiary.get_total_kills()
	summary_row.text = "Discovered: %d / %d   Total kills: %d" % [
		discovered, _all_enemies_cache.size(), total
	]
	# Limpar lista atual
	for child in list.get_children():
		child.queue_free()
	# Re-popular com 1 row por inimigo (sort: descobertos primeiro, depois alfabetico).
	var sorted: Array[EnemyData] = _all_enemies_cache.duplicate()
	sorted.sort_custom(_sort_enemies)
	for enemy in sorted:
		list.add_child(_build_row(enemy))

func _build_row(enemy: EnemyData) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	var name_label := Label.new()
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 14)
	var kills_label := Label.new()
	kills_label.add_theme_font_size_override("font_size", 14)
	kills_label.custom_minimum_size = Vector2(120, 0)
	kills_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	if Bestiary.is_discovered(enemy.id):
		name_label.text = "Lv.%d  %s" % [enemy.level, enemy.display_name]
		kills_label.text = "%d kills" % Bestiary.get_kills(enemy.id)
	else:
		name_label.text = "?????"
		name_label.modulate.a = 0.5
		kills_label.text = "-"
		kills_label.modulate.a = 0.5
	row.add_child(name_label)
	row.add_child(kills_label)
	return row

func _sort_enemies(a: EnemyData, b: EnemyData) -> bool:
	# Descobertos primeiro; dentro de cada bucket, ordenar por level asc, depois nome.
	var a_disc: bool = Bestiary.is_discovered(a.id)
	var b_disc: bool = Bestiary.is_discovered(b.id)
	if a_disc != b_disc:
		return a_disc  # descoberto vem antes
	if a.level != b.level:
		return a.level < b.level
	return a.display_name < b.display_name

# Carrega todos `.tres` em `data/enemies/`. Cache em memoria por sessao.
func _load_all_enemies() -> Array[EnemyData]:
	var out: Array[EnemyData] = []
	var dir := DirAccess.open(ENEMIES_DIR)
	if dir == null:
		return out
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".tres"):
			var path: String = ENEMIES_DIR + fname
			var data: EnemyData = load(path) as EnemyData
			if data != null:
				out.append(data)
		fname = dir.get_next()
	dir.list_dir_end()
	return out
