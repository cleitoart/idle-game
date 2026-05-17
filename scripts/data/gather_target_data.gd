class_name GatherTargetData
extends Resource

# GatherTargetData (Fase 01 / Bloco B+).
#
# Parent abstrata pra qualquer "alvo de coleta" que aparece num
# gathering_spot. Concretizacoes hoje:
#   - OreTargetData (mining): base + cluster.
#   - TreeTargetData (woodcutting): base + tronco + folhas.
#
# Campos comuns ficam aqui pra evitar duplicacao. Cada subclasse implementa
# `instantiate_node()` retornando o Node2D apropriado ja com `data = self`.

@export var id: StringName = &""
@export var display_name: String = ""
@export var description: String = ""
# Item dropado em cada hit bem-sucedido (cf. Efficiency.roll_drop).
@export var drop_item: ItemData
# Eficiencia minima necessaria para 100% de drop por hit. Acima dela,
# multiplicador inteiro ate 5x. (Cf. `Efficiency`.)
@export var eff_req: int = 10
# Quantos hits o no aguenta antes de quebrar.
@export var max_hits: int = 50
# Tempo de respawn apos quebrar (segundos REAIS — nao escala com time_scale).
@export var respawn_seconds: float = 30.0
# Nivel sugerido (informativo na UI; nao trava nada hoje).
@export var level: int = 1
# Escala aplicada aos sprites quando renderizados no BattleView. Subclasses
# herdam o valor e aplicam em todas as suas camadas.
@export var sprite_scale: float = 6.0

# Cria o Node2D concreto pra spawnar no controller. Deve ser sobrescrito
# por cada subclasse retornando o seu node-de-cena ja com `data = self`.
func instantiate_node() -> Node2D:
	push_error("GatherTargetData.instantiate_node must be overriden in subclass: %s" % get_script().resource_path)
	return null
