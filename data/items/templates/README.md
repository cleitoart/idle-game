# Item Templates

Templates base pra criar items novos. Duplique o arquivo certo e customize.

## Como duplicar

No FileSystem dock do Godot:
1. Click direito no template (ex: `template_helmet.tres`).
2. "Duplicate" -> nomeia o novo arquivo (ex: `iron_helmet.tres`).
3. Move pra `data/items/` (sai da pasta `templates/` pra o item aparecer no
   menu do dev modal).
4. Abre o arquivo duplicado e edita:
   - `id` (StringName unico, ex: `&"iron_helmet"`)
   - `display_name` (string mostrada na UI, ex: `"Iron Helmet"`)
   - `description`
   - `sprite` (path da textura)
   - `bonus_*` (valores dos bonuses)
   - `rarity` (0..5: common/uncommon/rare/epic/legendary/mythic)
   - `item_level` (level do item)

## Tabela de enums

### ItemType (item_type)
| Valor | Tipo       |
| ----- | ---------- |
| 0     | MATERIAL   |
| 1     | WEAPON     |
| 2     | CONSUMABLE |
| 3     | ARMOR      |
| 4     | ACCESSORY  |
| 5     | TOOL       |
| 6     | ARTIFACT   |

### SlotType (slot_type)
| Valor | Slot         | Tipo apropriado |
| ----- | ------------ | --------------- |
| 0     | NONE         | Materiais / Consumables / Artifacts |
| 1     | HELMET       | Armor |
| 2     | CHEST        | Armor |
| 3     | LEGS         | Armor |
| 4     | BOOTS        | Armor |
| 5     | NECKLACE     | Accessory |
| 6     | EARRINGS     | Accessory |
| 7     | RING         | Accessory |
| 8     | BRACELET     | Accessory |
| 9     | WEAPON       | Weapon |
| 10    | PICKAXE      | Tool |
| 11    | AXE          | Tool |
| 12    | FISHING_ROD  | Tool |
| 13    | SCYTHE       | Tool |
| 14    | STAR_NET     | Tool (Fase 04+) |
| 15    | SCOUTER      | Tool (Fase 04+) |

### Rarity (rarity)
| Valor | Tier      |
| ----- | --------- |
| 0     | COMMON    |
| 1     | UNCOMMON  |
| 2     | RARE      |
| 3     | EPIC      |
| 4     | LEGENDARY |
| 5     | MYTHIC    |

## Bonuses disponiveis

- `bonus_atk` (int) - dano fisico
- `bonus_attack_speed` (float) - velocidade de ataque
- `bonus_def` (int) - defesa
- `bonus_max_hp` (int) - HP maximo
- `bonus_max_mp` (int) - MP maximo
- `bonus_mining_efficiency` (int) - so pra picaretas
- `bonus_woodcutting_efficiency` (int) - so pra machados
- `bonus_fishing_efficiency` (int) - so pra varas de pesca
- `bonus_harvesting_efficiency` (int) - so pra foices

## Stackable

- `true` - materiais, consumables (empilham no inventory)
- `false` - equipment, weapons, tools, artifacts (1 por slot)

## Templates excluidos do dev menu

Items com `id` comecando com `template_` ficam fora do dev menu de "Add Item"
mesmo se estiverem em `data/items/`. Os arquivos nesta pasta `templates/`
tambem nao sao scaneados (pasta filtrada). Use ambas as protecoes pra
seguranca.
