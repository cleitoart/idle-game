class_name Juicy
extends RefCounted

# Juicy helpers - animacoes padrao reutilizaveis (Fase 01 / Bloco B+).
#
# Atualmente cobre apenas modal_appear / modal_disappear (fade + scale com
# pivot central). Button pulse (squash-on-press) foi REMOVIDO na Fase B+
# por decisao do usuario: a UI agora tem visual "solido", botoes nao
# mudam de escala — feedback visual fica com stylebox 3-state (normal /
# hover / pressed PNGs).
#
# Tempos calibrados conforme `planning/05_juicy/feedback-language.md`:
#   fast=0.15s, normal=0.25s, slow=0.45s.
# Easing: BACK_OUT pra "pop" (overshoot leve), CUBIC_IN pra desaparecer.

const MODAL_APPEAR_DURATION: float = 0.22
const MODAL_DISAPPEAR_DURATION: float = 0.16
const MODAL_SCALE_FROM: float = 0.85
const MODAL_SCALE_TO: float = 1.0
const MODAL_FADE_TO_OUT: float = 0.0

# --- Modal Appear / Disappear --------------------------------------------

# Mata um tween armazenado em meta com o key dado, se ainda ativo.
static func _kill_meta_tween(node: Node, meta_key: String) -> void:
	if node == null or not node.has_meta(meta_key):
		return
	var prev := node.get_meta(meta_key, null) as Tween
	if prev != null and is_instance_valid(prev) and prev.is_valid():
		prev.kill()

# Anima o `panel_root` (tipicamente o Center/Panel ou similar) com fade+scale.
# Funciona em qualquer Control que tenha `pivot_offset` configuravel.
# Se `panel_root` for null, anima o proprio modal.
#
# IMPORTANTE: mata qualquer disappear tween em andamento no mesmo modal
# antes de iniciar — caso contrario o callback `t.finished -> visible=false`
# do disappear esconde o modal logo apos ele aparecer (caso de "abre e
# fecha sozinho" quando user reclica o mesmo modal).
static func modal_appear(modal: Control, panel_root: Control = null) -> void:
	if modal == null:
		return
	# Mata disappear pendente (se houver) — previne callback de visible=false.
	_kill_meta_tween(modal, "_juicy_disappear_tween")
	# Mata appear anterior (se houver) — evita acumular.
	_kill_meta_tween(modal, "_juicy_appear_tween")
	var target: Control = panel_root if panel_root != null else modal
	# Pivot ao centro. Quando o modal abre pela primeira vez, `target.size`
	# pode estar (0,0) porque o layout do CenterContainer ainda nao rodou.
	# Fallback pro `custom_minimum_size` que e' o que o PanelContainer
	# eventualmente usa de tamanho. Sem isso o pivot fica em (0,0) e o
	# scale acontece a partir do canto top-left, dando a impressao de que
	# nao escalou.
	var pivot_size: Vector2 = target.size
	if pivot_size.x <= 0.0 or pivot_size.y <= 0.0:
		pivot_size = target.custom_minimum_size
	target.pivot_offset = pivot_size * 0.5
	target.scale = Vector2.ONE * MODAL_SCALE_FROM
	modal.modulate.a = MODAL_FADE_TO_OUT
	var t := modal.create_tween()
	t.set_parallel(true)
	t.tween_property(modal, "modulate:a", 1.0, MODAL_APPEAR_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(target, "scale", Vector2.ONE * MODAL_SCALE_TO, MODAL_APPEAR_DURATION).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	modal.set_meta("_juicy_appear_tween", t)

# Reverso do appear. NAO esconde o modal — chamador faz isso quando o tween
# terminar (ou via callback). Retorna o tween pra encadear.
static func modal_disappear(modal: Control, panel_root: Control = null) -> Tween:
	if modal == null:
		return null
	# Mata appear pendente (se houver) — evita conflito de scale/modulate.
	_kill_meta_tween(modal, "_juicy_appear_tween")
	# Mata disappear anterior (se houver) — evita callback duplo de visible=false.
	_kill_meta_tween(modal, "_juicy_disappear_tween")
	var target: Control = panel_root if panel_root != null else modal
	# Mesmo fallback de pivot do appear (caso disappear seja chamado antes
	# do layout finalizar — improvavel mas defensivo).
	var pivot_size: Vector2 = target.size
	if pivot_size.x <= 0.0 or pivot_size.y <= 0.0:
		pivot_size = target.custom_minimum_size
	target.pivot_offset = pivot_size * 0.5
	var t := modal.create_tween()
	t.set_parallel(true)
	t.tween_property(modal, "modulate:a", MODAL_FADE_TO_OUT, MODAL_DISAPPEAR_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t.tween_property(target, "scale", Vector2.ONE * MODAL_SCALE_FROM, MODAL_DISAPPEAR_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	modal.set_meta("_juicy_disappear_tween", t)
	return t
