class_name OreTarget
extends Node2D

# OreTarget (Fase 01 / Bloco B+).
#
# Alvo de coleta. Visualmente: 2 sprites (Cluster atras, Base na frente).
# Hit: anima APENAS o cluster (shake horizontal + pulse scale). Base fica
# imovel.
#
# Estados:
#   - alive (current_hits > 0): pode ser atacado.
#   - broken (current_hits == 0): cluster some, inicia respawn_timer.
#   - respawning (interno): aparece de novo apos `respawn_seconds`.
#
# Drop: o ore_target NAO instancia o ItemDrop sozinho — ele EMITE
# `hit_resolved(drop_item, qty, world_position)` e o controller (gather
# mode) cuida de spawnar o drop visual usando o mesmo helper que combate.

signal hit_resolved(drop_item: ItemData, qty: int, world_position: Vector2)
signal broken()
signal respawned()

const SHAKE_OFFSET_PX: float = 2.0
const SHAKE_DURATION: float = 0.12
const PULSE_SCALE_PEAK: float = 1.05
const PULSE_DURATION: float = 0.12
const BREAK_FADE_DURATION: float = 0.30

@export var data: OreTargetData

var current_hits: int = 0
var is_alive: bool = false

var _cluster: Sprite2D
var _base: Sprite2D
var _hp_bar: ProgressBar
var _shake_tween: Tween
var _pulse_tween: Tween
var _respawn_timer_unix: float = 0.0  # unix time alvo do respawn

func _ready() -> void:
	if data == null:
		push_warning("OreTarget without data; will be invisible")
		return
	# CLUSTER vai PRIMEIRO (atras na ordem visual). Em Node2D, ordem dos
	# filhos define z-order: filho 0 atras, filho N na frente.
	_cluster = Sprite2D.new()
	_cluster.texture = data.cluster_texture
	_cluster.scale = Vector2.ONE * data.sprite_scale
	# Pixel art: NEAREST evita borrao em escalas inteiras maiores.
	_cluster.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	# Offsets em pixels da arte original (1x); multiplica pelo sprite_scale.
	# X compensa larguras diferentes de PNG entre cobre/ferro/ouro
	# (Sprite2D centraliza por PNG individual, entao PNGs com larguras
	# diferentes ficam deslocados se nao houver offset).
	_cluster.position = Vector2(
		float(data.cluster_x_offset_px) * data.sprite_scale,
		float(data.cluster_y_offset_px) * data.sprite_scale,
	)
	add_child(_cluster)
	_base = Sprite2D.new()
	_base.texture = data.base_texture
	_base.scale = Vector2.ONE * data.sprite_scale
	_base.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_base.position = Vector2(
		float(data.base_x_offset_px) * data.sprite_scale,
		float(data.base_y_offset_px) * data.sprite_scale,
	)
	add_child(_base)
	# Pequena HP bar acima do cluster (mostra hits restantes). Posicionada
	# relativa aos offsets do cluster pra acompanhar a arte.
	_hp_bar = ProgressBar.new()
	_hp_bar.custom_minimum_size = Vector2(80, 8)
	_hp_bar.size = Vector2(80, 8)
	var hp_bar_x: float = float(data.cluster_x_offset_px) * data.sprite_scale - 40.0
	var hp_bar_y: float = (float(data.cluster_y_offset_px) - 14.0) * data.sprite_scale
	_hp_bar.position = Vector2(hp_bar_x, hp_bar_y)
	_hp_bar.show_percentage = false
	_hp_bar.max_value = float(data.max_hits)
	_hp_bar.value = float(data.max_hits)
	add_child(_hp_bar)
	# Inicia vivo.
	current_hits = data.max_hits
	is_alive = true

func _process(_delta: float) -> void:
	# Respawn check: se broken e o alvo unix passou, revive.
	if is_alive:
		return
	if _respawn_timer_unix <= 0.0:
		return
	if Time.get_unix_time_from_system() >= _respawn_timer_unix:
		_respawn()

# Aplica 1 hit. Roll de drop pela Efficiency. Anima cluster (shake+pulse).
# Retorna true se ainda esta vivo apos o hit, false se quebrou.
func take_hit(player_efficiency: int) -> bool:
	if not is_alive:
		return false
	# Roll de drop ANTES de decrementar hits — drop pertence a este hit.
	var roll: Dictionary = Efficiency.roll_drop(player_efficiency, data.eff_req)
	if bool(roll.get("did_drop", false)) and data.drop_item != null:
		var qty: int = int(roll.get("qty", 1))
		if qty > 0:
			hit_resolved.emit(data.drop_item, qty, global_position)
	# Anima o cluster.
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
	if _cluster == null:
		return
	# Shake horizontal em torno do offset_x do cluster (nao em torno de 0,
	# senao o shake reseta o cluster_x_offset_px pra zero — bug visual).
	var base_x: float = float(data.cluster_x_offset_px) * data.sprite_scale
	if _shake_tween != null and _shake_tween.is_valid():
		_shake_tween.kill()
	_shake_tween = create_tween()
	_shake_tween.tween_property(_cluster, "position:x", base_x - SHAKE_OFFSET_PX, SHAKE_DURATION * 0.33).set_trans(Tween.TRANS_QUAD)
	_shake_tween.tween_property(_cluster, "position:x", base_x + SHAKE_OFFSET_PX, SHAKE_DURATION * 0.33).set_trans(Tween.TRANS_QUAD)
	_shake_tween.tween_property(_cluster, "position:x", base_x, SHAKE_DURATION * 0.34).set_trans(Tween.TRANS_QUAD)
	# Pulse scale: so do cluster, base fica fixa.
	if _pulse_tween != null and _pulse_tween.is_valid():
		_pulse_tween.kill()
	var base_scale: Vector2 = Vector2.ONE * data.sprite_scale
	_pulse_tween = create_tween()
	_pulse_tween.tween_property(_cluster, "scale", base_scale * PULSE_SCALE_PEAK, PULSE_DURATION * 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_pulse_tween.tween_property(_cluster, "scale", base_scale, PULSE_DURATION * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _break() -> void:
	is_alive = false
	# Fade out so do cluster — base fica visivel como "rocha vazia".
	if _cluster != null:
		var t := create_tween()
		t.tween_property(_cluster, "modulate:a", 0.0, BREAK_FADE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
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
	if _cluster != null:
		# Fade-in suave.
		_cluster.modulate.a = 0.0
		var t := create_tween()
		t.tween_property(_cluster, "modulate:a", 1.0, BREAK_FADE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	respawned.emit()
