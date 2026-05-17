extends Control

# Settlement view (Fase 01 / Bloco B - placeholder).
#
# Estagio 1 do Acampamento. Ainda placeholder visual; estruturas viraram
# botoes simples.
#
# Coleta foi MOVIDA para o map_modal (aba Gathering). Skill Tree foi MOVIDA
# para o character_modal (botao). Forja+Fornalha unificadas em "Crafting"
# (tab).
#
# Random walker: o sprite do Warrior caminha aleatoriamente pela tela.

# Walker config
const WALKER_SPEED: float = 50.0
const WALKER_PAUSE_MIN: float = 1.0
const WALKER_PAUSE_MAX: float = 3.0
const WALKER_AREA_MIN_X: float = 200.0
const WALKER_AREA_MAX_X: float = 1200.0
const WALKER_AREA_MIN_Y: float = 500.0
const WALKER_AREA_MAX_Y: float = 800.0

@onready var crafting_btn: Button = $Margin/Box/Structures/CraftingBtn
@onready var walker: Sprite2D = $WalkerLayer/WarriorWalker

var _walker_target: Vector2 = Vector2.ZERO
var _walker_pause_timer: float = 0.0

func _ready() -> void:
	crafting_btn.pressed.connect(_on_crafting_pressed)
	# Posicao inicial do walker.
	walker.position = _random_walker_pos()
	_walker_target = _random_walker_pos()

func _process(delta: float) -> void:
	if not visible:
		return
	if _walker_pause_timer > 0.0:
		_walker_pause_timer -= delta
		return
	var to_target: Vector2 = _walker_target - walker.position
	var dist: float = to_target.length()
	if dist <= 2.0:
		_walker_pause_timer = randf_range(WALKER_PAUSE_MIN, WALKER_PAUSE_MAX)
		_walker_target = _random_walker_pos()
		return
	var step: float = WALKER_SPEED * delta
	walker.position += to_target.normalized() * min(step, dist)
	if to_target.x < 0:
		walker.flip_h = true
	elif to_target.x > 0:
		walker.flip_h = false

func _random_walker_pos() -> Vector2:
	return Vector2(
		randf_range(WALKER_AREA_MIN_X, WALKER_AREA_MAX_X),
		randf_range(WALKER_AREA_MIN_Y, WALKER_AREA_MAX_Y),
	)

func _on_crafting_pressed() -> void:
	EventBus.modal_requested.emit(&"crafting")
