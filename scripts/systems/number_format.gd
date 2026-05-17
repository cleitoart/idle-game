class_name NumberFormat
extends RefCounted

# NumberFormat (Fase B+).
#
# Helpers staticos pra abreviar numeros grandes com sufixos de 1000 em 1000.
# Usado em TODA UI que mostra numero do jogador (HP, gold, drops, etc).
#
# Comportamento (default — sem decimais quando ha sufixo, truncado pra int):
#   format(0)         -> "0"
#   format(999)       -> "999"
#   format(1000)      -> "1K"
#   format(1234)      -> "1K"     (decimais truncados — fica integer)
#   format(1500)      -> "1K"
#   format(1_000_000) -> "1M"
#   format(1_234_567) -> "1M"
#   format(113_050)   -> "113K"
#   format(-1234)     -> "-1K"
#   format(0.5)       -> "0.5"    (< 1.0 mostra decimais sem sufixo)
#
# Se o caller quiser decimais (ex: relatorios), passar `max_decimals = 2`:
#   format(1234, 2)   -> "1.23K"
#
# Sufixos (cada um e' 1000x do anterior, cap em Dc = 10^33):
#   "", K, M, B, T, Qa, Qi, Sx, Sp, Oc, No, Dc

const SUFFIXES: Array[String] = [
	"",    # 1
	"K",   # 10^3
	"M",   # 10^6
	"B",   # 10^9
	"T",   # 10^12
	"Qa",  # 10^15  (Quadrillion)
	"Qi",  # 10^18  (Quintillion)
	"Sx",  # 10^21  (Sextillion)
	"Sp",  # 10^24  (Septillion)
	"Oc",  # 10^27  (Octillion)
	"No",  # 10^30  (Nonillion)
	"Dc",  # 10^33  (Decillion — cap)
]

# Formata um numero com sufixo. Para valores < 1000, mostra inteiro (ou
# decimais se < 1.0). Para >= 1000, divide por 1000^n ate o valor ficar entre
# 1 e 999.999..., truncando pra int e aplicando o sufixo correspondente.
#
# `max_decimals` controla quantas casas decimais aparecem no sufixo path.
# Default 0 = sem decimais (113.5K -> 113K). Passar 2 pra ver 113.5K.
static func format(value: float, max_decimals: int = 0) -> String:
	if is_nan(value) or is_inf(value):
		return "?"
	# Sinal preservado, formatamos o modulo.
	var neg: bool = value < 0.0
	var abs_v: float = abs(value)
	# Sub-1: mostra decimais sem sufixo (ex: attack_speed 0.5 -> "0.5").
	# Forca pelo menos 1 decimal pra nao truncar pra "0".
	if abs_v < 1.0 and abs_v > 0.0:
		var dec_sub1: int = max(1, max_decimals)
		return ("-%s" if neg else "%s") % _trim_decimals(abs_v, dec_sub1)
	# 0..999: inteiro direto (sem decimais, sem sufixo).
	if abs_v < 1000.0:
		return ("-%d" if neg else "%d") % int(abs_v)
	# >= 1000: dividir ate ficar no range [1, 1000), aplicar sufixo.
	var idx: int = 0
	while abs_v >= 1000.0 and idx < SUFFIXES.size() - 1:
		abs_v /= 1000.0
		idx += 1
	var prefix: String = "-" if neg else ""
	# Com max_decimals = 0, trunca decimais (113.5K -> 113K).
	return "%s%s%s" % [prefix, _trim_decimals(abs_v, max_decimals), SUFFIXES[idx]]

# Helper: formata um inteiro (wrapping format()).
static func format_int(value: int, max_decimals: int = 0) -> String:
	return format(float(value), max_decimals)

# Helper: "curr / max" formatado (ex: HP bar). Cada lado independente.
static func format_pair(curr: float, max_v: float, max_decimals: int = 0) -> String:
	return "%s / %s" % [format(curr, max_decimals), format(max_v, max_decimals)]

# Float fixo (sem sufixo, decimais fixos). Util pra attack_speed=1.25.
static func format_float(value: float, decimals: int = 2) -> String:
	return "%.*f" % [decimals, value]

# Trim trailing zeros e ponto decimal pendente. Aceita float, retorna string
# legivel:
#   1.5 -> "1.5"; 1.25 -> "1.25"; 1.0 -> "1"; 0.5 -> "0.5"
#   max_decimals = 0: trunca tudo pra int (1.234 -> "1").
static func _trim_decimals(v: float, max_decimals: int) -> String:
	if max_decimals <= 0:
		return "%d" % int(v)
	var raw: String = "%.*f" % [max_decimals, v]
	# Remove zeros finais de decimal, e o ponto se sobrar isolado.
	if raw.contains("."):
		raw = raw.rstrip("0").rstrip(".")
	return raw
