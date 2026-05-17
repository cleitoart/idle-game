extends Control

const NOTIFICATION_SCENE: PackedScene = preload("res://scenes/ui/notification_item.tscn")

const MAX_NOTIFICATIONS: int = 6
const NOTIF_WIDTH: float = 260.0
const NOTIF_HEIGHT: float = 50.0
const SPACING: float = 6.0
const SLIDE_OFFSCREEN_PADDING: float = 30.0

var _notifications: Array = [] # ordered oldest -> newest

func _ready() -> void:
	custom_minimum_size = Vector2(NOTIF_WIDTH, MAX_NOTIFICATIONS * NOTIF_HEIGHT + (MAX_NOTIFICATIONS - 1) * SPACING)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	EventBus.item_picked_up.connect(_on_item_picked_up)

func _on_item_picked_up(item: ItemData, qty: int) -> void:
	if item == null or qty <= 0:
		return
	# Try merging into the most recent active notification of the same item.
	for i in range(_notifications.size() - 1, -1, -1):
		var existing: NotificationItem = _notifications[i]
		if existing.is_active and existing.item_id == item.id:
			existing.add_qty(qty)
			return
	_add_new_notification(item, qty)

func _add_new_notification(item: ItemData, qty: int) -> void:
	var notif: NotificationItem = NOTIFICATION_SCENE.instantiate()
	add_child(notif)
	_notifications.append(notif)
	notif.bind(item, qty)
	notif.expired.connect(_on_notification_expired.bind(notif))
	# Initial position: bottom slot, off the right edge so it slides in.
	notif.position = Vector2(NOTIF_WIDTH + SLIDE_OFFSCREEN_PADDING, _slot_y(0))
	# When over capacity, expire the oldest active one (it slides up + fades).
	if _notifications.size() > MAX_NOTIFICATIONS:
		var oldest: NotificationItem = _notifications.pop_front()
		oldest.expire_now()
	_layout()

func _slot_y(slot_index: int) -> float:
	return size.y - NOTIF_HEIGHT - slot_index * (NOTIF_HEIGHT + SPACING)

func _layout() -> void:
	var total: int = _notifications.size()
	for i in total:
		var notif: NotificationItem = _notifications[i]
		# Newest (last in array) sits at slot 0 (bottom).
		var slot_index: int = total - 1 - i
		var target: Vector2 = Vector2(0, _slot_y(slot_index))
		notif.tween_to(target)

func _on_notification_expired(notif: NotificationItem) -> void:
	_notifications.erase(notif)
	_layout()
