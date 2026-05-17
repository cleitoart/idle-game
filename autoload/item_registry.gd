extends Node

# ItemRegistry — autoload que escaneia recursivamente res://data/items/
# e indexa todos os ItemData por `id`. Permite resolver itens sem amarrar
# ao path de disco (resiliente a reorganizacoes de pasta).
#
# Uso:
#   ItemRegistry.get_by_id(&"training_sword") -> ItemData ou null
#   ItemRegistry.get_all() -> Array[ItemData] sorted por display_name
#
# Templates (id comecando com "template_") sao filtrados — nao aparecem
# nas listagens nem como resultado de get_by_id.

const ITEMS_ROOT: String = "res://data/items/"

var _by_id: Dictionary = {}  # StringName -> ItemData
var _all_sorted: Array[ItemData] = []

func _ready() -> void:
	rescan()

# Reescaneia o diretorio. Chamado no boot e pode ser chamado em runtime
# (ex: dev_modal apos hot-reload de assets) pra refletir items novos.
func rescan() -> void:
	_by_id.clear()
	_all_sorted.clear()
	_scan_dir(ITEMS_ROOT)
	_all_sorted.sort_custom(func(a, b): return String(a.display_name) < String(b.display_name))

func get_by_id(id: StringName) -> ItemData:
	return _by_id.get(id, null)

func get_all() -> Array[ItemData]:
	return _all_sorted.duplicate()

# DFS recursivo. Subpastas chamadas `templates` sao ignoradas integralmente.
func _scan_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_warning("ItemRegistry: cannot open %s" % path)
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if dir.current_is_dir():
			if entry != "." and entry != ".." and entry != "templates":
				_scan_dir(path + entry + "/")
		elif entry.ends_with(".tres"):
			var res: Resource = load(path + entry)
			if res is ItemData:
				var item: ItemData = res as ItemData
				var id_str: String = String(item.id)
				if id_str != "" and not id_str.begins_with("template_"):
					_by_id[item.id] = item
					_all_sorted.append(item)
		entry = dir.get_next()
	dir.list_dir_end()
