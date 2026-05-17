class_name MenuListItem
extends Button

# A side-menu row: ornate-framed button (4-state PNG styleboxes) with a
# square icon slot on the left and a text label filling the rest. Renamed
# from "MenuButton" because Godot reserves that name for its built-in
# popup-menu button class.

# Text colors. Enabled covers normal/hover/pressed because the user cares
# about a single "enabled vs disabled" distinction here, not per-state shifts.
const TEXT_COLOR_ENABLED: Color = Color("#c9bd93")
const TEXT_COLOR_DISABLED: Color = Color("#424039")

@export var menu_text: String = "":
	set(value):
		menu_text = value
		_apply_text()

@export var menu_icon: Texture2D:
	set(value):
		menu_icon = value
		_apply_icon()

var _last_disabled: bool = false

func _ready() -> void:
	# Suppress the built-in icon/text rendering — we use our own child Label
	# and TextureRect so we can control the icon-slot size precisely.
	text = ""
	icon = null
	# Re-fit the icon whenever the slot is laid out (initial frame, resize on
	# different button widths, etc).
	var slot: Control = get_node_or_null("Margin/Row/IconSlot")
	if slot != null and not slot.resized.is_connected(_refit_icon):
		slot.resized.connect(_refit_icon)
	_apply_text()
	_apply_icon()
	_last_disabled = disabled
	_refresh_label_color()
	# Fase B+: button pulse REMOVIDO. UI mais "solida" — usuario nao quer
	# scale flicker nos botoes. Visual feedback fica so no stylebox 3-state
	# (normal/hover/pressed PNGs).

func _process(_delta: float) -> void:
	# Polling for `disabled` since Button doesn't emit a signal on that
	# property change. Cheap enough for an 8-button menu.
	if disabled != _last_disabled:
		_last_disabled = disabled
		_refresh_label_color()

func _apply_text() -> void:
	var label: Label = get_node_or_null("Margin/Row/Label")
	if label != null:
		label.text = menu_text

func _apply_icon() -> void:
	var icon_rect: TextureRect = get_node_or_null("Margin/Row/IconSlot/IconRect")
	if icon_rect == null:
		return
	icon_rect.texture = menu_icon
	_refit_icon()

# Snap the icon to an INTEGER scale of its native pixel dimensions when it
# fits, so pixel art doesn't end up with blown-up / mismatched pixels at
# fractional scales. When the texture is bigger than the slot we fall back to
# a fractional fit so it doesn't overflow the button. Always centered.
func _refit_icon() -> void:
	var icon_rect: TextureRect = get_node_or_null("Margin/Row/IconSlot/IconRect")
	var slot: Control = get_node_or_null("Margin/Row/IconSlot")
	if icon_rect == null or slot == null or menu_icon == null:
		return
	var tex_size: Vector2 = menu_icon.get_size()
	if tex_size.x <= 0 or tex_size.y <= 0:
		return
	var slot_size: Vector2 = slot.size
	if slot_size.x <= 0 or slot_size.y <= 0:
		slot_size = slot.custom_minimum_size
	var fit_scale: float = min(slot_size.x / tex_size.x, slot_size.y / tex_size.y)
	var draw_size: Vector2
	if fit_scale >= 1.0:
		# Upscale path: snap to the largest integer multiple that still fits.
		draw_size = tex_size * float(int(fit_scale))
	else:
		# Texture larger than slot — fall back to fractional fit so the icon
		# stays inside the button. Pixel-art icons that need this should be
		# resized in the source asset to a slot-friendly resolution.
		draw_size = tex_size * fit_scale
	icon_rect.size = draw_size
	icon_rect.position = (slot_size - draw_size) * 0.5

func _refresh_label_color() -> void:
	var label: Label = get_node_or_null("Margin/Row/Label")
	if label == null:
		return
	label.add_theme_color_override(
		"font_color",
		TEXT_COLOR_DISABLED if disabled else TEXT_COLOR_ENABLED,
	)
