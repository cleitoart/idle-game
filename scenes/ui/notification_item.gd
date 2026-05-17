class_name NotificationItem
extends Control

const VISIBLE_DURATION: float = 2.6
const FADE_OUT_DURATION: float = 0.40
const FADE_OUT_RISE: float = 24.0
const SLIDE_DURATION: float = 0.28

signal expired

@onready var icon: TextureRect = $Panel/Margin/Row/Icon
@onready var name_label: Label = $Panel/Margin/Row/NameLabel
@onready var qty_label: Label = $Panel/Margin/Row/QtyLabel
@onready var expire_timer: Timer = $ExpireTimer

var item_id: StringName = &""
var item: ItemData
var qty: int = 0
var is_active: bool = true

var _move_tween: Tween
var _expiring: bool = false

func _ready() -> void:
	expire_timer.wait_time = VISIBLE_DURATION
	expire_timer.one_shot = true
	expire_timer.timeout.connect(_on_expire_timeout)

func bind(p_item: ItemData, p_qty: int) -> void:
	item = p_item
	if p_item != null:
		item_id = p_item.id
		icon.texture = p_item.get_drop_icon()
		name_label.text = p_item.display_name
	qty = p_qty
	qty_label.text = "x%d" % qty
	expire_timer.start()

func add_qty(extra: int) -> void:
	if not is_active:
		return
	qty += extra
	qty_label.text = "x%d" % qty
	# Refresh expire timer so the merged notification stays visible longer.
	expire_timer.stop()
	expire_timer.start(VISIBLE_DURATION)

func tween_to(target: Vector2, duration: float = SLIDE_DURATION) -> void:
	if _move_tween != null and _move_tween.is_valid():
		_move_tween.kill()
	_move_tween = create_tween()
	_move_tween.tween_property(self, "position", target, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_expire_timeout() -> void:
	expire_now()

func expire_now() -> void:
	if _expiring:
		return
	_expiring = true
	is_active = false
	expire_timer.stop()
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_OUT_DURATION)
	tween.parallel().tween_property(self, "position:y", position.y - FADE_OUT_RISE, FADE_OUT_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_on_fade_done)

func _on_fade_done() -> void:
	expired.emit()
	queue_free()
