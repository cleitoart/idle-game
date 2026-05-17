class_name TreeTarget
extends Node2D

# TreeTarget (Fase 01 / Bloco B+).
#
# Alvo de coleta de woodcutting. Visualmente: 4 sprites empilhados.
# Ordem de tras pra frente (= ordem de add_child):
#   1. base    — raizes/chao (atras)
#   2. trunk   — tronco
#   3. leaves_back  (leaf000 — mais escura/menor)
#   4. leaves_front (leaf001 — mais clara/maior, na frente)
#
# Hit anima TRONCO + AMBAS AS FOLHAS (shake horizontal + pulse scale). Base
# fica imovel — vira "toco" quando a arvore cai.
#
# Estados:
#   - alive (current_hits > 0): pode ser cortada.
#   - broken (current_hits == 0): trunk + leaves somem; base fica como toco.
#                                 Inicia respawn_timer.
#   - respawning (interno): trunk + leaves reaparecem apos `respawn_seconds`.
#
# Drop: igual ao OreTarget — emite `hit_resolved` e o controller spawna o
# ItemDrop visual.
#
# IMPORTANTE: a interface (signals, is_alive, take_hit) e' duck-compatible
# com OreTarget, entao o combat_controller trata os dois iguais.

signal hit_resolved(drop_item: ItemData, qty: int, world_position: Vector2)
signal broken()
signal respawned()

const SHAKE_OFFSET_PX: float = 2.0
const SHAKE_DURATION: float = 0.12
const PULSE_SCALE_PEAK: float = 1.05
const PULSE_DURATION: float = 0.12
const BREAK_FADE_DURATION: float = 0.30
# Folhas balancam mais que o tronco (mais flexivel visualmente).
const LEAVES_SHAKE_MULT: float = 1.6
const LEAVES_PULSE_MULT: float = 1.10

@export var data: TreeTargetData

var current_hits: int = 0
var is_alive: bool = false

var _base: Sprite2D
var _trunk: Sprite2D
var _leaves_back: Sprite2D
var _leaves_front: Sprite2D
var _hp_bar: ProgressBar
var _trunk_shake_tween: Tween
var _trunk_pulse_tween: Tween
var _leaves_back_shake_tween: Tween
var _leaves_back_pulse_tween: Tween
var _leaves_front_shake_tween: Tween
var _leaves_front_pulse_tween: Tween
var _respawn_timer_unix: float = 0.0  # unix time alvo do respawn

func _ready() -> void:
	if data == null:
		push_warning("TreeTarget without data; will be invisible")
		return
	# Ordem dos filhos define z-order: filho 0 atras, filho N na frente.
	# Conforme requisicao do design: base atras, depois trunk, depois leaves
	# back (leaf000), depois leaves front (leaf001) na frente.
	_base = _make_sprite(data.base_texture, data.base_x_offset_px, data.base_y_offset_px)
	add_child(_base)
	_trunk = _make_sprite(data.trunk_texture, data.trunk_x_offset_px, data.trunk_y_offset_px)
	add_child(_trunk)
	_leaves_back = _make_sprite(data.leaves_back_texture, data.leaves_back_x_offset_px, data.leaves_back_y_offset_px)
	add_child(_leaves_back)
	_leaves_front = _make_sprite(data.leaves_front_texture, data.leaves_front_x_offset_px, data.leaves_front_y_offset_px)
	add_child(_leaves_front)
	# HP bar acima das folhas frontais (parte mais alta da arvore).
	_hp_bar = ProgressBar.new()
	_hp_bar.custom_minimum_size = Vector2(80, 8)
	_hp_bar.size = Vector2(80, 8)
	var hp_bar_x: float = float(data.leaves_front_x_offset_px) * data.sprite_scale - 40.0
	var hp_bar_y: float = (float(data.leaves_front_y_offset_px) - 14.0) * data.sprite_scale
	_hp_bar.position = Vector2(hp_bar_x, hp_bar_y)
	_hp_bar.show_percentage = false
	_hp_bar.max_value = float(data.max_hits)
	_hp_bar.value = float(data.max_hits)
	add_child(_hp_bar)
	# Inicia viva.
	current_hits = data.max_hits
	is_alive = true

# Helper: cria um Sprite2D ja configurado pra pixel art (NEAREST + scale +
# offset em pixels da arte 1x multiplicado por sprite_scale).
func _make_sprite(texture: Texture2D, offset_x_px: float, offset_y_px: float) -> Sprite2D:
	var spr := Sprite2D.new()
	spr.texture = texture
	spr.scale = Vector2.ONE * data.sprite_scale
	spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	spr.position = Vector2(offset_x_px * data.sprite_scale, offset_y_px * data.sprite_scale)
	return spr

func _process(_delta: float) -> void:
	# Respawn check: se broken e o alvo unix passou, revive.
	if is_alive:
		return
	if _respawn_timer_unix <= 0.0:
		return
	if Time.get_unix_time_from_system() >= _respawn_timer_unix:
		_respawn()

# Aplica 1 hit. Roll de drop pela Efficiency. Anima tronco + ambas folhas.
# Retorna true se ainda esta viva apos o hit, false se quebrou.
func take_hit(player_efficiency: int) -> bool:
	if not is_alive:
		return false
	# Roll de drop ANTES de decrementar hits — drop pertence a este hit.
	var roll: Dictionary = Efficiency.roll_drop(player_efficiency, data.eff_req)
	if bool(roll.get("did_drop", false)) and data.drop_item != null:
		var qty: int = int(roll.get("qty", 1))
		if qty > 0:
			hit_resolved.emit(data.drop_item, qty, global_position)
	# Anima tronco e as duas camadas de folhas.
	_play_hit_animation()
	# Decrementa hits.
	current_hits = max(0, current_hits - 1)
	if _hp_bar != null:
		_hp_bar.value = float(current_hits)
	if current_hits <= 0:
		_break()
		return false
	return true

func _play_hit_animation() -> void:
	# Tronco: shake leve + pulse normal.
	_animate_layer_shake_and_pulse(
		_trunk,
		float(data.trunk_x_offset_px) * data.sprite_scale,
		SHAKE_OFFSET_PX,
		PULSE_SCALE_PEAK,
		"_trunk_shake_tween",
		"_trunk_pulse_tween",
	)
	# Folhas back e front: shake mais forte + pulse mais agressivo (galhos
	# balancam mais). Ambas as camadas pulsam juntas pra parecer uma copa
	# coesa (parallax visual: a layer da frente cobre uns pixels a mais da
	# back, mas no movimento sao um soh).
	var leaves_shake: float = SHAKE_OFFSET_PX * LEAVES_SHAKE_MULT
	var leaves_peak: float = 1.0 + (PULSE_SCALE_PEAK - 1.0) * LEAVES_PULSE_MULT
	_animate_layer_shake_and_pulse(
		_leaves_back,
		float(data.leaves_back_x_offset_px) * data.sprite_scale,
		leaves_shake,
		leaves_peak,
		"_leaves_back_shake_tween",
		"_leaves_back_pulse_tween",
	)
	_animate_layer_shake_and_pulse(
		_leaves_front,
		float(data.leaves_front_x_offset_px) * data.sprite_scale,
		leaves_shake,
		leaves_peak,
		"_leaves_front_shake_tween",
		"_leaves_front_pulse_tween",
	)

# Helper: shake horizontal + pulse scale numa camada. tween_field_* sao os
# nomes dos campos que armazenam os tweens, pra reset. Usa get/set pra
# alinhar com a forma como o codigo original do ore_target trabalhava (sem
# Tween reuse manual).
func _animate_layer_shake_and_pulse(
	sprite: Sprite2D,
	base_x: float,
	shake_amount: float,
	pulse_peak: float,
	shake_field: String,
	pulse_field: String,
) -> void:
	if sprite == null:
		return
	# Shake horizontal em torno de base_x (preserva offset original).
	var prev_shake := get(shake_field) as Tween
	if prev_shake != null and prev_shake.is_valid():
		prev_shake.kill()
	var shake_t := create_tween()
	shake_t.tween_property(sprite, "position:x", base_x - shake_amount, SHAKE_DURATION * 0.33).set_trans(Tween.TRANS_QUAD)
	shake_t.tween_property(sprite, "position:x", base_x + shake_amount, SHAKE_DURATION * 0.33).set_trans(Tween.TRANS_QUAD)
	shake_t.tween_property(sprite, "position:x", base_x, SHAKE_DURATION * 0.34).set_trans(Tween.TRANS_QUAD)
	set(shake_field, shake_t)
	# Pulse scale.
	var prev_pulse := get(pulse_field) as Tween
	if prev_pulse != null and prev_pulse.is_valid():
		prev_pulse.kill()
	var base_scale: Vector2 = Vector2.ONE * data.sprite_scale
	var pulse_t := create_tween()
	pulse_t.tween_property(sprite, "scale", base_scale * pulse_peak, PULSE_DURATION * 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pulse_t.tween_property(sprite, "scale", base_scale, PULSE_DURATION * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	set(pulse_field, pulse_t)

func _break() -> void:
	is_alive = false
	# Fade out do tronco e ambas folhas — base fica visivel como "toco".
	_fade_out(_trunk)
	_fade_out(_leaves_back)
	_fade_out(_leaves_front)
	if _hp_bar != null:
		_hp_bar.visible = false
	# Agendar respawn por unix-time (independente de Engine.time_scale).
	_respawn_timer_unix = Time.get_unix_time_from_system() + data.respawn_seconds
	broken.emit()

func _respawn() -> void:
	current_hits = data.max_hits
	is_alive = true
	_respawn_timer_unix = 0.0
	if _hp_bar != null:
		_hp_bar.value = float(current_hits)
		_hp_bar.visible = true
	# Fade-in suave do tronco e ambas folhas.
	_fade_in(_trunk)
	_fade_in(_leaves_back)
	_fade_in(_leaves_front)
	respawned.emit()

func _fade_out(sprite: Sprite2D) -> void:
	if sprite == null:
		return
	var t := create_tween()
	t.tween_property(sprite, "modulate:a", 0.0, BREAK_FADE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _fade_in(sprite: Sprite2D) -> void:
	if sprite == null:
		return
	sprite.modulate.a = 0.0
	var t := create_tween()
	t.tween_property(sprite, "modulate:a", 1.0, BREAK_FADE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
