extends CanvasLayer

# TooltipManager (Fase B+) — autoload singleton.
#
# Apresenta tooltips de items quando o usuario hover-a em slots (inventory,
# equipment, etc). Singleton vive em CanvasLayer com `layer = 20` pra
# renderizar acima de qualquer modal.
#
# Comportamento (Fase B+ tooltips PSD):
#   - Tooltip segue o cursor enquanto visivel.
#   - Layout fiel ao PSD (`psd-files/weapon_tooltip_export` e
#     `item_tooltip_export`): panel 207 wide fixo, altura cresce com conteudo.
#   - Cores e fontes copiadas direto do PSD.
#
# API:
#   show_item_tooltip(item: ItemData, owner: Node = null)
#     - `owner` (slot que mostrou) eh checado por hide_tooltip_if_owner
#       pra evitar race em transicoes rapidas de cursor entre slots.
#   show_text_tooltip(text: String, owner: Node = null)
#   hide_tooltip()
#   hide_tooltip_if_owner(owner: Node) — so esconde se owner == current_owner.

# Cores extraidas do PSD.
const COLOR_TITLE: Color = Color("#C9BD93")
const COLOR_TYPE: Color = Color("#474439")
const COLOR_DESC: Color = Color("#C9BD93")
const COLOR_STAT_POSITIVE: Color = Color("#94A657")
const COLOR_STAT_NEGATIVE: Color = Color("#A66257")

# Font sizes do PSD.
const FONT_SIZE_TITLE: int = 24
const FONT_SIZE_TYPE: int = 14
const FONT_SIZE_DESC: int = 18
const FONT_SIZE_STAT: int = 20

# Layout (fixed dimensions matching PSD).
const PANEL_WIDTH: int = 207
const CURSOR_OFFSET: Vector2 = Vector2(16, 12)
const VIEWPORT_PADDING: float = 4.0
const FADE_IN_DURATION: float = 0.10

# Background do panel (mesma textura pra weapon e items).
const PANEL_PATH: String = "res://assets/sprites/ui/tooltips/weapon_tooltip_panel.png"
# Divider — textura unica de 1px de altura usada nos dois dividers.
const DIVIDER_PATH: String = "res://assets/sprites/ui/tooltips/h_divider_tooltip_sep.png"

# Map de item_type -> string mostrada como subtitle.
const TYPE_LABELS: Dictionary = {
	0: "Material",
	1: "Weapon",
	2: "Consumable",
	3: "Armor",
	4: "Accessory",
	5: "Tool",
	6: "Artifact",
}

@onready var _panel: NinePatchRect = $TooltipPanel
@onready var _name_label: Label = $TooltipPanel/Margin/Content/HeaderBox/NameLabel
@onready var _type_label: Label = $TooltipPanel/Margin/Content/HeaderBox/TypeLabel
@onready var _divider_top: TextureRect = $TooltipPanel/Margin/Content/DividerTop
@onready var _stats_container: VBoxContainer = $TooltipPanel/Margin/Content/StatsContainer
@onready var _divider_bottom: TextureRect = $TooltipPanel/Margin/Content/DividerBottom
@onready var _description_label: Label = $TooltipPanel/Margin/Content/DescriptionLabel

var _fade_tween: Tween
# True enquanto o tooltip esta visivel — _process atualiza posicao seguindo
# o cursor.
var _is_following: bool = false
# Owner do tooltip atual — usado por slots pra hide-if-owner. Quando slot
# A poll-detecta cursor saindo, so esconde se o tooltip ainda for dele.
# Evita race condition em que slot A esconde tooltip que slot B acabou de
# mostrar (no mesmo frame).
var _current_owner: Node = null

func _ready() -> void:
	_panel.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Pre-load divider (mesma textura pros dois dividers).
	if ResourceLoader.exists(DIVIDER_PATH):
		var divider_tex: Texture2D = load(DIVIDER_PATH)
		_divider_top.texture = divider_tex
		_divider_bottom.texture = divider_tex

func _process(_delta: float) -> void:
	if _is_following and _panel.visible:
		_position_at_cursor()

func show_item_tooltip(item: ItemData, owner: Node = null, _anchor_global_rect: Rect2 = Rect2()) -> void:
	if item == null:
		hide_tooltip()
		return
	_current_owner = owner
	# Panel eh o mesmo pra todos os tipos (texture ja setada no .tscn).
	# Texto.
	_name_label.text = item.display_name
	_name_label.add_theme_color_override("font_color", COLOR_TITLE)
	_name_label.add_theme_font_size_override("font_size", FONT_SIZE_TITLE)
	_type_label.text = String(TYPE_LABELS.get(int(item.item_type), "Item"))
	_type_label.add_theme_color_override("font_color", COLOR_TYPE)
	_type_label.add_theme_font_size_override("font_size", FONT_SIZE_TYPE)
	_description_label.text = item.description
	_description_label.add_theme_color_override("font_color", COLOR_DESC)
	_description_label.add_theme_font_size_override("font_size", FONT_SIZE_DESC)
	# Reset stats container.
	for child in _stats_container.get_children():
		child.queue_free()
	# Layout depende do tipo do item e da presenca de desc/stats.
	var has_stats: bool = _item_has_visible_stats(item)
	var has_desc: bool = item.description != ""
	_description_label.visible = has_desc
	if has_stats:
		_stats_container.visible = true
		_divider_top.visible = true  # entre name/type e stats
		_divider_bottom.visible = has_desc  # entre stats e desc, so se ha desc
		_populate_stats(item)
	else:
		_stats_container.visible = false
		_divider_top.visible = has_desc  # entre name/type e desc, so se ha desc
		_divider_bottom.visible = false
	_show_with_fade()

func show_text_tooltip(text: String, owner: Node = null, _anchor_global_rect: Rect2 = Rect2()) -> void:
	# Texture do panel ja foi setada no .tscn.
	_current_owner = owner
	_name_label.text = text
	_name_label.add_theme_color_override("font_color", COLOR_TITLE)
	_name_label.add_theme_font_size_override("font_size", FONT_SIZE_TITLE)
	_type_label.visible = false
	_divider_top.visible = false
	_stats_container.visible = false
	_divider_bottom.visible = false
	_description_label.visible = false
	_show_with_fade()

func hide_tooltip() -> void:
	_is_following = false
	_current_owner = null
	if _fade_tween != null and _fade_tween.is_valid():
		_fade_tween.kill()
	_panel.visible = false

# Esconde o tooltip APENAS se o owner solicitante for o atual dono. Usado
# pelos slots no _process pra evitar que slot A esconda tooltip que slot B
# acabou de mostrar (race em transicoes rapidas de cursor entre slots).
func hide_tooltip_if_owner(owner: Node) -> void:
	if _current_owner == owner:
		hide_tooltip()

# --- Internals ------------------------------------------------------------

func _show_with_fade() -> void:
	# Restore visibility default — text tooltip pode ter escondido.
	if _name_label != null:
		_name_label.visible = true
	# Forca o panel a largura fixa 207. Altura ajusta apos layout.
	_panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0)
	_panel.size.x = PANEL_WIDTH
	# Posiciona ja na primeira frame pra evitar flash em (0,0) ao trocar de slot.
	_position_at_cursor()
	_is_following = true
	# So fade-in se o panel ainda nao estiver visivel (transicao entre slots
	# mantem o mesmo panel, apenas atualiza conteudo).
	var first_show: bool = not _panel.visible
	_panel.visible = true
	if first_show:
		_panel.modulate.a = 0.0
	# Aguarda 1 frame pra labels com autowrap calcularem altura na largura 207.
	await get_tree().process_frame
	_resize_to_content()
	_position_at_cursor()
	if first_show:
		if _fade_tween != null and _fade_tween.is_valid():
			_fade_tween.kill()
		_fade_tween = create_tween()
		_fade_tween.tween_property(_panel, "modulate:a", 1.0, FADE_IN_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

# Recalcula a altura do panel apos o conteudo estabilizar (autowrap nas
# labels com width=PANEL_WIDTH).
func _resize_to_content() -> void:
	var content: VBoxContainer = $TooltipPanel/Margin/Content
	var margin: MarginContainer = $TooltipPanel/Margin
	var content_h: float = content.get_combined_minimum_size().y
	var pad_top: int = margin.get_theme_constant("margin_top")
	var pad_bottom: int = margin.get_theme_constant("margin_bottom")
	_panel.size = Vector2(PANEL_WIDTH, content_h + pad_top + pad_bottom)

# Posiciona o panel proximo do cursor. Default: bottom-right do cursor.
# Se sair da viewport, flippa pra outro lado.
func _position_at_cursor() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var mp: Vector2 = get_viewport().get_mouse_position()
	var panel_size: Vector2 = _panel.size
	var pos: Vector2 = mp + CURSOR_OFFSET
	# Flip horizontal se sair pela direita.
	if pos.x + panel_size.x > viewport_size.x - VIEWPORT_PADDING:
		pos.x = mp.x - panel_size.x - CURSOR_OFFSET.x
	# Flip vertical se sair pelo bottom.
	if pos.y + panel_size.y > viewport_size.y - VIEWPORT_PADDING:
		pos.y = mp.y - panel_size.y - CURSOR_OFFSET.y
	# Clamp defensive.
	pos.x = clamp(pos.x, VIEWPORT_PADDING, viewport_size.x - panel_size.x - VIEWPORT_PADDING)
	pos.y = clamp(pos.y, VIEWPORT_PADDING, viewport_size.y - panel_size.y - VIEWPORT_PADDING)
	_panel.position = pos

func _item_has_visible_stats(item: ItemData) -> bool:
	return (
		item.bonus_atk != 0 or item.bonus_attack_speed != 0.0
		or item.bonus_def != 0 or item.bonus_max_hp != 0 or item.bonus_max_mp != 0
		or item.bonus_mining_efficiency != 0
		or item.bonus_woodcutting_efficiency != 0
		or item.bonus_fishing_efficiency != 0
		or item.bonus_harvesting_efficiency != 0
	)

func _populate_stats(item: ItemData) -> void:
	if item.bonus_atk != 0:
		_stats_container.add_child(_make_stat_row("ATK", item.bonus_atk, "atk_icon"))
	if item.bonus_attack_speed != 0.0:
		_stats_container.add_child(_make_stat_row_float("SPD", item.bonus_attack_speed, "spd_icon"))
	if item.bonus_def != 0:
		_stats_container.add_child(_make_stat_row("DEF", item.bonus_def, ""))
	if item.bonus_max_hp != 0:
		_stats_container.add_child(_make_stat_row("HP", item.bonus_max_hp, ""))
	if item.bonus_max_mp != 0:
		_stats_container.add_child(_make_stat_row("MP", item.bonus_max_mp, ""))
	if item.bonus_mining_efficiency != 0:
		_stats_container.add_child(_make_stat_row("Mining Eff", item.bonus_mining_efficiency, ""))
	if item.bonus_woodcutting_efficiency != 0:
		_stats_container.add_child(_make_stat_row("Wood Eff", item.bonus_woodcutting_efficiency, ""))
	if item.bonus_fishing_efficiency != 0:
		_stats_container.add_child(_make_stat_row("Fish Eff", item.bonus_fishing_efficiency, ""))
	if item.bonus_harvesting_efficiency != 0:
		_stats_container.add_child(_make_stat_row("Harvest Eff", item.bonus_harvesting_efficiency, ""))

func _make_stat_row(label_text: String, value: int, icon_id: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	if icon_id != "":
		var icon_path: String = "res://assets/sprites/ui/tooltips/%s.png" % icon_id
		if ResourceLoader.exists(icon_path):
			var icon_rect := TextureRect.new()
			icon_rect.texture = load(icon_path)
			icon_rect.custom_minimum_size = Vector2(15, 15)
			icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			row.add_child(icon_rect)
	var name_label := Label.new()
	name_label.text = label_text
	name_label.add_theme_font_size_override("font_size", FONT_SIZE_STAT)
	name_label.add_theme_color_override("font_color", COLOR_TITLE)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(name_label)
	var value_label := Label.new()
	value_label.text = ("+ %s" if value > 0 else "- %s") % NumberFormat.format_int(abs(value))
	value_label.add_theme_font_size_override("font_size", FONT_SIZE_STAT)
	value_label.add_theme_color_override("font_color", COLOR_STAT_POSITIVE if value > 0 else COLOR_STAT_NEGATIVE)
	row.add_child(value_label)
	return row

func _make_stat_row_float(label_text: String, value: float, icon_id: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	if icon_id != "":
		var icon_path: String = "res://assets/sprites/ui/tooltips/%s.png" % icon_id
		if ResourceLoader.exists(icon_path):
			var icon_rect := TextureRect.new()
			icon_rect.texture = load(icon_path)
			icon_rect.custom_minimum_size = Vector2(15, 15)
			icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			row.add_child(icon_rect)
	var name_label := Label.new()
	name_label.text = label_text
	name_label.add_theme_font_size_override("font_size", FONT_SIZE_STAT)
	name_label.add_theme_color_override("font_color", COLOR_TITLE)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(name_label)
	var value_label := Label.new()
	value_label.text = ("+ %s" if value > 0.0 else "- %s") % NumberFormat.format_float(abs(value), 2)
	value_label.add_theme_font_size_override("font_size", FONT_SIZE_STAT)
	value_label.add_theme_color_override("font_color", COLOR_STAT_POSITIVE if value > 0.0 else COLOR_STAT_NEGATIVE)
	row.add_child(value_label)
	return row
