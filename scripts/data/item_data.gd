class_name ItemData
extends Resource

enum ItemType { MATERIAL, WEAPON, CONSUMABLE, ARMOR, ACCESSORY, TOOL, ARTIFACT }

# Tiers de raridade (decisao #12: 6 tiers).
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC }

# Slot que o item ocupa quando equipavel. NONE = item nao equipavel
# (materiais, consumiveis, etc.). Decisao #20: equip e' por personagem;
# Bau Compartilhado vira so na Fase 03.
enum SlotType {
	NONE,
	HELMET, CHEST, LEGS, BOOTS,
	NECKLACE, EARRINGS, RING, BRACELET,
	WEAPON,
	PICKAXE, AXE, FISHING_ROD,
	SCYTHE,  # Harvesting (Fase B+)
	STAR_NET, SCOUTER,  # Fase 04+ (Star Catching, Robotics)
	# Slots visuais (transmog) — Fase 02-03+ com UI completa.
	WEAPON_VISUAL, SKIN_FULL, WINGS,
}

@export var id: StringName = &""
@export var display_name: String = ""
@export var description: String = ""
@export var stackable: bool = true
@export var item_type: ItemType = ItemType.MATERIAL

# --- Raridade e classificacao (Fase 0) -------------------------------------
@export var rarity: Rarity = Rarity.COMMON
@export var slot_type: SlotType = SlotType.NONE
@export var item_level: int = 1

# --- Stats fixos do equip --------------------------------------------------
# bonus_atk e bonus_attack_speed sao legados (so armas usam hoje). Adicionando
# bonus_def, bonus_max_hp, bonus_max_mp para suportar armaduras/acessorios
# simples ja na Fase 0. Fases posteriores adicionam todos os stats da
# secao 3.2 do roadmap conforme equip ganhar UI completa.
@export var bonus_atk: int = 0
@export var bonus_attack_speed: float = 0.0
@export var bonus_def: int = 0
@export var bonus_max_hp: int = 0
@export var bonus_max_mp: int = 0

# --- Estrutura zerada para Fase 02+ ----------------------------------------
# Affixes sao stats aleatorios rolados no drop. Encantamentos sao buffs
# aplicados via pergaminho. Gemas viram em slots especificos de Mythic.
# Os campos abaixo sao apenas RESERVADOS — toda logica de aplicacao vem em
# fases posteriores.
@export var max_affix_slots: int = 0
@export var max_enchant_slots: int = 0
@export var max_gem_slots: int = 0

# --- Bonus de ferramentas (Fase 01 / Bloco B+) -----------------------------
# Pickaxes, axes e fishing rods somam efficiency pra atividade equivalente.
# Cobertos por `Efficiency.compute(character, activity)` quando a ferramenta
# esta no slot correspondente.
@export var bonus_mining_efficiency: int = 0
@export var bonus_woodcutting_efficiency: int = 0
@export var bonus_fishing_efficiency: int = 0
@export var bonus_harvesting_efficiency: int = 0

@export_group("Sprite")
@export var sprite: Texture2D
@export var drop_icon: Texture2D
@export var drop_scale: float = 3.0

@export_group("Attack VFX")
@export var vfx_sprite: Texture2D
@export var vfx_pattern: VfxEffect.Pattern = VfxEffect.Pattern.BLINK
@export var vfx_scale: float = 3.0

func get_sprite() -> Texture2D:
	if sprite != null:
		return sprite
	var path: String = "res://assets/sprites/%s.png" % String(id)
	if ResourceLoader.exists(path):
		return load(path)
	return null

func get_drop_icon() -> Texture2D:
	if drop_icon != null:
		return drop_icon
	var fallback: String = "res://assets/sprites/effects/elipse_vfx000.png"
	if ResourceLoader.exists(fallback):
		return load(fallback)
	return null
