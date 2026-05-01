extends ModalBase

const EQUIP_LABELS: Dictionary = {
	&"weapon": "Weapon",
	&"helmet": "Helmet",
	&"armor": "Armor",
	&"boots": "Boots",
	&"accessory": "Accessory",
}

@onready var name_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/NameRow
@onready var level_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/LevelRow
@onready var xp_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/XpRow
@onready var hp_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/HpRow
@onready var atk_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/AtkRow
@onready var def_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/DefRow
@onready var speed_row: Label = $Center/Panel/Margin/Box/Content/Columns/Stats/SpeedRow
@onready var equipment_box: VBoxContainer = $Center/Panel/Margin/Box/Content/Columns/Equipment/Slots
@onready var portrait: ColorRect = $Center/Panel/Margin/Box/Content/Columns/Equipment/Portrait

func _ready() -> void:
	title_text = "Character"
	super._ready()
	EventBus.active_character_changed.connect(_refresh_if_visible)
	EventBus.character_xp_changed.connect(_refresh_if_visible)
	EventBus.character_hp_changed.connect(_refresh_if_visible)
	EventBus.character_inventory_changed.connect(_refresh_if_visible)

func _on_open() -> void:
	_refresh()

func _refresh_if_visible() -> void:
	if visible:
		_refresh()

func _refresh() -> void:
	var character := GameState.get_active_character()
	if character == null:
		return
	title_label.text = "Character: %s" % character.display_name()
	name_row.text = "Name: %s" % character.display_name()
	level_row.text = "Level: %d" % character.level
	xp_row.text = "XP: %d" % character.current_xp
	hp_row.text = "HP: %d / %d" % [character.current_hp, character.stats.max_hp]
	atk_row.text = "ATK: %d" % character.stats.atk
	def_row.text = "DEF: %d" % character.stats.def
	speed_row.text = "Attack Speed: %.2f / s" % character.stats.attack_speed
	for child in equipment_box.get_children():
		child.queue_free()
	for slot in CharacterInstance.EQUIP_SLOTS:
		var row := Label.new()
		var slot_label: String = EQUIP_LABELS.get(slot, String(slot))
		var item: ItemData = character.get_equipment(slot)
		if item == null:
			row.text = "%s: -" % slot_label
		else:
			row.text = "%s: %s" % [slot_label, item.display_name]
		equipment_box.add_child(row)
	if character.data != null:
		portrait.color = character.data.portrait_color
