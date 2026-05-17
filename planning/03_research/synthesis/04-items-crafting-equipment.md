# Sintese: Items, Crafting e Equipment

> Pesquisa cross-game para informar decisoes sobre tiers de equip, drop rates,
> grafo de crafting, sistemas de upgrade pos-drop (gems/enchants/evolution) e
> consumables. Fontes citadas com `arquivo:linha` ou `arquivo#secao`. Conflitos
> com o hub atual marcados `[DECISAO PENDENTE]`.
>
> Estado atual do projeto (relembrando):
> - 18 slots equip (armadura 4, acessorio 4, weapon, 4 tools, 2 locked, 3 transmog).
>   [ver: planning/01_design/equipment-catalog.md#1-slots-oficiais]
> - 6 raridades fixas: Common, Uncommon, Rare, Epic, Legendary, Mythic.
>   [ver: planning/01_design/equipment-catalog.md#2-tiers-raridades]
> - Reserva pra affix/enchant/gem slots em ItemData (Fase 02+).
> - Crafting placeholder com 4 abas (Smithing/Smelting/Cooking/Alchemy).
> - Sistema de Eficiencia para gathering (ratio eff/eff_req).
>   [ver: planning/01_design/gathering-materials.md#1-convencoes]

---

## 1. Como cada jogo faz

### 1.1 Cookie Clicker (CC)

Cookie Clicker NAO tem equipamento direto. O analogo de "equipment progression"
e' o sistema de **Upgrades por Building** + **Cookie flavor upgrades**. Mesmo
assim ha padroes muito relevantes pra um idle medieval.

#### 1.1.1 Tiers de upgrade por building

Cada building tem **15 tiers nomeados** (Plain, Berrylium, Blueberrylium, ...,
Glimmeringue) + 1 fortune especial.
Fonte: `references/cookie-clicker-dump/04-upgrades.md:84-102`.

| Tier  | Nome          | Unlock (qtd. predios) | Mult preco | Cor      |
|-------|---------------|-----------------------|------------|----------|
| 1     | Plain         | 1                     | x10        | #ccb3ac  |
| 2     | Berrylium     | 5                     | x50        | #ff89e7  |
| 3     | Blueberrylium | 25                    | x500       | #00deff  |
| 4     | Chalcedhoney  | 50                    | x50.000    | #ffcc2f  |
| 5     | Buttergold    | 100                   | x5.000.000 | #e9d673  |
| ...   | ...           | ...                   | ...        | ...      |
| 15    | Glimmeringue  | 600                   | x5*10^40   | #fffaa8  |
| synergy1 | Synergy I  | 15                    | x200.000   | (special)|
| synergy2 | Synergy II | 75                    | x2*10^11   | (special)|
| fortune  | Fortune    | -1 (news ticker)      | x7.7*10^28 | (special)|

Cada tiered upgrade **dobra o CPS** do building (formula em
`04-upgrades.md:112-123`):

```
para cada tieredUpgrade nao-special comprado:
  tierMult = 2
  se Unshackled: tierMult += (id==1? 0.5 : (20-id)*0.1)
  mult *= tierMult
```

**Padrao chave:** dobrar e' a "unidade" de upgrade. Cada tier "pre-dobra" e o
preco esta calibrado pra que o jogador SEMPRE possa eventualmente pagar.

#### 1.1.2 Cookie flavor upgrades

246 cookies, agrupados por `power` (% adicionado ao multiplicador global de
producao):
- +1%: 3 cookies (Plain/Sugar/Oatmeal raisin)
- +2%: ~40 cookies (Peanut butter, Coconut, Macadamia, etc.)
- +3%: ~20 cookies (Dark/White chocolate, Macaron set)
- +4%: ~25 cookies (Gingersnaps, Cinnamon, Vanity, ...)
- +5%: ~75+ cookies (Dragon, Mini, Whoopie pies, etc.)
- +10%: 11 cookies (Butter biscuits chain)

Fonte: `04-upgrades.md:514-543`.

A maioria desbloqueia automaticamente em `Game.UnlockAt[]` por threshold de
cookies bakeados. Cookies sazonais tem `season:'halloween'|'christmas'|...` e
`locked:1` (precisam drop ativo).

**Padrao chave: mesma mecanica (+X% CPS) com nomes/aparencias diferentes cria
ilusao de profundidade.** O jogador sente que tem "centenas de upgrades" mas
mecanicamente sao todos um numero somando ao multiplicador.

#### 1.1.3 Synergy upgrades

37 sinergias (pares de buildings). Funcao
`Game.SynergyUpgrade(name, desc, b1, b2, tier)`:

- `b1` (menor) ganha **+5% CPS por unidade de b2** (multiplicativo).
- `b2` (maior) ganha **+0.1% CPS por unidade de b1**.

Fonte: `04-upgrades.md:630-636`.

O building "menor" recebe muito mais buff por unidade do "maior" — incentiva
comprar pilhas do prédio maior pra beneficiar o menor.

#### 1.1.4 Garden minigame (drops de planta = drops de cookie)

Cookie Clicker tem um minigame de jardim. Plantas dropam **upgrades** ao serem
colhidas maduras com chance baixa.
Fonte: `references/cookie-clicker-dump/11-minigame-garden.md:140-162`.

| Planta         | Drop                       | Rate por colheita |
|----------------|----------------------------|-------------------|
| Baker's wheat  | Wheat slims (+1% CPS)      | 0.1%              |
| Bakeberry      | Bakeberry cookies (+2%)    | 1.5%              |
| Elderwort      | Elderwort biscuits (+2%)   | 1%                |
| Duketater      | Duketater cookies (+10%)   | 0.5%              |
| Green rot      | Green yeast digestives     | 0.5%              |
| Ichorpuff      | Ichor syrup (+7% offline)  | 0.5%              |

Aplica `Game.dropRateMult()` + 5% se tiver achievement `Seedless to nay`.

**Mutacao por vizinhanca (50 entradas de mutacao)** em
`11-minigame-garden.md:216-269` — 2 baker's wheat maduros podem virar
thumbcorn (5%), bakeberry (0.1%), e cascatas profundas (queenbeet ≥ 8 -> Juicy
queenbeet -> 1 sugar lump).

**Padrao chave:** grafo de "evolucao" passivo. Voce nao escolhe diretamente
crafting de planta tier X — voce planta combinacoes e espera mutacoes.
Idle puro.

#### 1.1.5 Stock market minigame (economia + retencao)

18 commodities (uma por building exceto cursor). Preco oscila em 6 modes
(stable/slow rise/slow fall/fast rise/fast fall/chaotic). Tick = 60s real.
Fonte: `references/cookie-clicker-dump/12-minigame-market.md:1-100`.

- **Stock max** depende de `building.highest + officeLevel + building.level*10`
  (`12-minigame-market.md:63-72`).
- Brokers reduzem overhead de compra **multiplicativamente** (0.95^brokers
  partindo de +20%) — `12-minigame-market.md:121`.
- Loans com 50% downpayment + buff temporario + penalidade pos-buff.

**Padrao chave:** o minigame de mercado tem **suas proprias raridades e taxas
mas usa as mesmas building stats**. Multipl uso da mesma data.

#### 1.1.6 Drop rate em CC

CC NAO tem drop rate "kill-based". Os "drops" vem de:
- **Golden cookies**: spawn aleatorio na tela com cooldown.
- **Reindeer** (season christmas): spawn aleatorio.
- **Garden drops**: chance por colheita madura.
- **Achievement-based unlocks**: chave do unlock e' acumulado total.

Fonte: `04-upgrades.md:870-878`.

Modificador unificado: `Game.dropRateMult()` aplica em todos.

---

### 1.2 Legends of IdleOn

#### 1.2.1 Schema universal de itens (2409 entradas)

Cada item tem o mesmo schema, com campos opcionais por tipo:

```json
"EquipmentHats1": {
  "displayName": "Farmer_Brim",
  "sellPrice": 175,
  "typeGen": "aHelmet",        // display-grouping
  "ID": 4,                      // ordem dentro do tipo
  "Type": "HELMET",             // Type enum
  "lvReqToCraft": 1,
  "lvReqToEquip": 1,
  "Class": "ALL",
  "Speed": 0, "Reach": 0,
  "Weapon_Power": 0,
  "STR": 2, "AGI": 1, "WIS": 1, "LUK": 0,
  "Defence": 3,
  "UQ1txt": 0, "UQ1val": 0,    // stat extra ("%_DROP_RATE", etc.)
  "UQ2txt": 0, "UQ2val": 0,
  "Upgrade_Slots_Left": 1,
  "itemType": "Equip",
  "rawName": "EquipmentHats1"
}
```

Fonte: `references/idleon-reference/02_ITEMS_CRAFTING_DROPS.md:11-33`.

**Padroes chave:**
- `itemType` enum: "Equip" / "Consumable" / "Quest" — define quais campos extras
  o item tem (`02_ITEMS_CRAFTING_DROPS.md:62-67`).
- `UQ1txt/UQ1val` + `UQ2txt/UQ2val` = ate 2 "Unique stats" extras por item.
  Ex: trophy Lucky_Lad tem `UQ1txt: "%_DROP_RATE", UQ1val: 7`.
- `Upgrade_Slots_Left` = quantos upgrades stones podem ser aplicados.

#### 1.2.2 Distribuicao de equip por slot

Top contagens em `02_ITEMS_CRAFTING_DROPS.md:36-57`:

| Slot/Prefixo                   | Qtd | Tier-equiv aprox |
|-------------------------------|----:|------------------|
| EquipmentHats (Capacetes)     | 138 | ~10 tiers x N variantes |
| EquipmentShirts (Camisas)     |  41 | ~5-6 tiers x N |
| EquipmentShoes (Botas)        |  41 | ~5-6 tiers |
| EquipmentRings (Aneis)        |  37 | ~6 tiers |
| EquipmentNametag (Cosmeticos) |  37 | endgame-only |
| EquipmentPendant (Pingentes)  |  36 | ~5-6 tiers |
| EquipmentPants (Calcas)       |  31 | ~5-6 tiers |
| EquipmentKeychain             |  30 | account-wide |

IdleOn usa **T1-T10+ por slot** (especificamente capacetes vao mais fundo que
camisas). Nao e' uniforme — slot principal (capacete) ganha mais variantes.

#### 1.2.3 Crafts (420 receitas) — recursivas

Cada receita aponta pra item resultante + lista de materiais.
Fonte: `02_ITEMS_CRAFTING_DROPS.md:73-89`.

```json
"Boxing_Gloves": {
  "rawName": "EquipmentPunching1",
  "type": "Equip",
  "subType": "FISTICUFF",
  "itemName": "Boxing_Gloves",
  "itemQuantity": 1,
  "materials": [
    { "itemName": "Crimson_String", "rawName": "CraftMat2", "itemQuantity": 1 },
    { "itemName": "Cue_Tape",       "rawName": "CraftMat3", "itemQuantity": 1 }
  ]
}
```

**Materiais sao recursivos** — `Crimson_String` e' em si um craft de algo
mais basico. Forma um **DAG** com **3-5 niveis de profundidade** em
mid/late-game. 420 receitas geram **milhares de caminhos de progressao**.

#### 1.2.4 Anvil (sistema de producao idle)

`anvilProducts` (14 slots): cada slot define um material produzido, com
`requiredAmount` (custo + XP), `levelReq` e `exp` por produto.
Fonte: `02_ITEMS_CRAFTING_DROPS.md:96-104`.

```json
"0": { "rawName": "CraftMat1", "requiredAmount": 100, "levelReq": 1, "exp": 6 }
"1": { "rawName": "CraftMat5", "requiredAmount": 200, "levelReq": 5, "exp": 10 }
"2": { "rawName": "CraftMat6", "requiredAmount": 350, "levelReq": 12, "exp": 16 }
```

`anvilUpgradeCost` (26 niveis): cada nivel pede `costThreshold` unidades de
item especifico, escalando — primeiro 5 spore caps, depois 15 frog legs, etc.
(`02_ITEMS_CRAFTING_DROPS.md:108-114`).

**Padrao chave:** producao **idle continua** que voce nao tem que clicar
manualmente, mas voce **DEVE** voltar pra trocar slots (gameplay loop).

#### 1.2.5 Equipment Sets (19 conjuntos)

Padrao **flexivel**: voce precisa de TODAS as armaduras + `requiredTools >= N`
(pelo menos N tools quaisquer equipadas).
Fonte: `02_ITEMS_CRAFTING_DROPS.md:120-131`.

```json
{
  "setName": "COPPER_SET",
  "armors": ["EquipmentHats17", "EquipmentShirts11", "EquipmentPants2"],
  "tools": ["EquipmentTools2", "EquipmentToolsHatchet3", "FishingRod2", ...],
  "weapons": [],
  "requiredTools": 1,
  "requiredWeapon": 0,
  "bonusValue": 60,
  "description": "+{%_Mining_and|Chopping_Efficiency"
}
```

Permite combos: Armadura set A + ferramentas/armas soltas de set B = ativa
ambos parcialmente.

#### 1.2.6 Drop tables em IdleOn (formato array ordenado)

364 monstros. Cada um tem um **array ordenado** de drops. Exemplo `mushG`
(Green Mushroom):

```
[0]  COIN          qty=5      chance=0.5      <- coins
[1]  Spore_Cap     qty=1      chance=0.22     <- drop comum
[2]  CardsA0       qty=1      chance=0.002    <- card (0.2%)
[3]  Spore_Tee     qty=1      chance=0.00035  <- raro
[4]  TalentBook1   qty=3.6M   chance=0.001    <- 1 every ~3.6M kills
...
[14] Trophy2       qty=1      chance=0.0003   <- Lucky_Lad
[20] StoneZ1       qty=2      chance=0.85     <- Mystery_Upgrade_Stone
```

Fonte: `02_ITEMS_CRAFTING_DROPS.md:200-220`.

**Padroes chave do drop system de IdleOn:**

1. **Array ordenado por raridade** — order matters (UI iteration). Mostra "top
   5 drops" do mob sem precisar sortear.
2. **`quantity` como kill count requirement** para drops super-raros — em vez
   de `chance: 0.000001`, usar `quantity: 1000000 chance: 0.001` = "1 chance em
   1000 a cada 1M kills" (`02_ITEMS_CRAFTING_DROPS.md:222-227`).
3. **Slots vazios com chance=0** = placeholder para adicao futura.
4. **`questLink: "Mutton4"`** — drops que so liberam apos quest especifica.

#### 1.2.7 Obols — sistema de affix por slot com shape

```json
{
  "0": { "shape": "Square", "levelReq": 32 },
  "1": { "shape": "Circle", "levelReq": 0 },
  "2": { "shape": "Hexagon", "levelReq": 105 },
  "10": { "shape": "Sparkle", "levelReq": 250 }
}
```

Fonte: `02_ITEMS_CRAFTING_DROPS.md:254-269`.

Cada slot aceita **forma especifica** (Square/Circle/Hexagon/Sparkle). Cada
forma tem suas raridades.
- Character obols (especifico por personagem)
- Family obols (account-wide)

**Padrao chave:** combina **chance + level + slot shape** = tres eixos de
progressao com escassez diferente.

#### 1.2.8 Stamps, Bubbles, Cards (sistemas de upgrade complementares)

- **Stamps**: 57 (combat) + 57 (skill) — upgrade permanente, scaling caro.
- **Cards**: 1 por mob (~364 cards). Stack ate 5 niveis. Equipa-se em set ate 9.
  `CardsF` (W5) = 51 entries (`02_ITEMS_CRAFTING_DROPS.md:42`).
- **Bubbles** (Alchemy): 100+ bubbles tradicionais com curva escalavel.

Esses 3 sistemas + Obols + Sets formam **camadas paralelas** de upgrade. O
jogador nao precisa "evoluir" um item — ele coleta cards/stamps que vivem em
paralelo.

#### 1.2.9 Traps (gathering passivo)

Fonte: `02_ITEMS_CRAFTING_DROPS.md:142-156`.

```json
[
  { "trapTime": 1200,  "quantity": 1,  "exp": 1, "trapType": 0 },
  { "trapTime": 3600,  "quantity": 2,  "exp": 2 },
  { "trapTime": 28800, "quantity": 10, "exp": 8 }
]
```

Recompensa **super-linear no tempo**: 8h da 10 critters vs 1h da 2. Estimula
"deixe overnight".

---

### 1.3 Incremental Epic Hero 2 (IEH2)

#### 1.3.1 Slots e raridades

Fonte: `references/ieh2_dump/docs/04-equipment.md:5-9`.

```csharp
public enum EquipmentPart   { Weapon, Armor, Jewelry }
public enum EquipmentRarity { Common, Uncommon, Rare, SuperRare, Epic }
```

Apenas **3 partes** (Weapon/Armor/Jewelry) e **5 raridades**. EquipmentKind
lista ~180 itens nominados.

#### 1.3.2 Sistema de level per-item per-hero

Cada heroi tem array **separado** de levels por item:

```csharp
Main.main.SR.equipmentLevelsWarrior[(int)kind]   // 0..maxLevel
Main.main.SR.equipmentLevelsWizard[(int)kind]
// idem para Angel, Thief, Archer, Tamer
```

Fonte: `04-equipment.md:22-26`.

**Cap padrao: 50** (`maxEQLevelPerHero`). Subir level ate 10 marca o item como
`isMaxed`, que da **dictionary point** (collection / codex bonus).

#### 1.3.3 Curva de proficiencia (XP do item)

```csharp
num = 3^rarity × (1 + 1.5 × rarity) × 300 × (level × (1 + rarity) + 1)
num /= 2
if (rarity >= Epic) num *= 10_000 × 10^(level / 10)
if (level > 10) num *= 2^(level - 10)
if (level > 20) num *= 5^(level - 10)
if (level > 30) num *= 10^(level - 30)
```

Fonte: `04-equipment.md:42-53`.

| Raridade  | Mult base | Comentario |
|-----------|----------:|------------|
| Common    | 1x        | trivial |
| Uncommon  | 7.5x      | tutorial |
| Rare      | ~37x      | midgame |
| SuperRare | ~150x     | mid-late |
| Epic      | ~450x × 10.000 | endgame gate |

**Explode a partir do level 20+** — forca jogador a completar Rare antes de
tocar Epic. Gating natural sem checklist.

#### 1.3.4 Slots equipados upgradable

3 partes (Weapon/Armor/Jewelry), mas **numero de slots por parte** sobe via
Rebirth:

```csharp
RebirthUpgradeKind.EQWeaponSlot:    initCost=250, base=5, max=5
RebirthUpgradeKind.EQArmorSlot:     ditto
RebirthUpgradeKind.EQJewelrySlot:   ditto
```

Fonte: `04-equipment.md:69-73`. Custo cresce com `5^level` — 5 slots de cada
parte custa progressivamente 1250, 6250, ..., ~7.8M no quinto.

Itens "Globais" ocupam slot que aplica pra **todos** os herois (visto em
`isGlobalEQSlot`).

#### 1.3.5 Effects, Forge effects, Option effects (3 camadas de afixos)

Cada `Equipment` tem **3 listas paralelas** de afixos:

| Camada        | Origem                  | Como modifica |
|---------------|-------------------------|---------------|
| Effects       | Fixo por item-kind      | Stats base — nao mexivel |
| ForgeEffects  | Catalyst + Forge        | Buffs do blacksmith |
| OptionEffects | RNG no drop, modificavel via Enchant | Afixos aleatorios estilo Diablo |

**Max 7 afixos por camada** (`maxOptionEffectNum = 7`, `maxForgeEffectNum = 7`).
Fonte: `04-equipment.md:80-90`.

#### 1.3.6 EnchantKind — 36 verbos de modificacao

Sistema profundo de manipulacao de afixos:

| Familia | Verbos | O que fazem |
|---------|--------|-------------|
| **Option** | Add, Delete, Extract, Lottery, Levelup, LevelMax, Copy, DeleteAll, ExtractAll, LotteryAll, LevelupAll, LevelMaxAll, CopyAll | Manipula a lista de OptionEffects |
| **Forge**  | Add, Delete, Extract, ExtractAll | Idem ForgeEffects |
| **Slot**   | ExpandEnchantSlot | Aumenta capacidade |
| **Misc**   | InstantProf | Pula barra de proficiencia |
| **Artifact** | versoes ArtifactX | Segundo sistema de afixos pra itens elevados |

Fonte: `04-equipment.md:92-104`.

**Padrao chave: pares opostos (Add/Delete, Extract/Copy, Levelup/Lottery)
viram economia interna.** O jogador "comercia" verbos via crafting.

#### 1.3.7 Talismans

Categoria especial de equipamento com efeitos passivos especiais
(`MultiplierKind.Talisman` e `TalismanPassive`). Forjado via Alchemy +
TalismanFragment. Endgame de subsistema.
Fonte: `04-equipment.md:108-110` e `15-consumables.md:175-178`.

#### 1.3.8 Drop chance em IEH2

```csharp
public static double areaUniqueDropChanceBase = 1E-05;   // 1 em 100k
```

Drop multiplicado por stat `EquipmentDropChance` (cap 100%, mas pode ser
influenciada por Stat × EQDrop_per_LUK^(2/3)).
Fonte: `04-equipment.md:114-118`.

#### 1.3.9 Currencies hierarquicas

Fonte: `references/ieh2_dump/docs/18-economy.md:7-25`.

```
=== Generated em combate ===
Gold              <- drop generico
Stone, Crystal, Leaf (3 ResourceKind) <- drop por area
Materials (26 MaterialKind) <- drop por mob species

=== Saved as "meta" (cumulativo, nao reseta) ===
MetaResource[3]   <- copia "saved" de Stone/Crystal/Leaf

=== Currencies premium / endgame ===
SlimeCoin, DungeonCoin, Ruby, PortalOrb, Essence,
TalismanFragment, MysteriousWater, EpicCoin
```

#### 1.3.10 Materials (26 tipos, 1 por mob species)

```csharp
public enum MaterialKind {
  // === Mob drops basicos (1 por species) ===
  MonsterFluid, SpiderSilk, BatWing, FairyDust, FoxTail, FishScales,
  CarvedBranch, ThickFur, UnicornHorn, SlimeBall, BlackPearl,
  // === Element shards ===
  FlameShard, FrostShard, LightningShard, NatureShard, PoisonShard,
  // === Crafting basics ===
  OilOfSlime, EnchantedCloth,
  // === Endgame ===
  ManaSeed, UnmeltingIce, EternalFlame, AncientBattery,
  Ectoplasm, Stardust, VoidEgg, EnchantedShard
}
```

Fonte: `18-economy.md:117-132`. **Padrao: 1 material por species** =
identidade clara, voce sabe pra onde grindar (Spider -> SpiderSilk).

#### 1.3.11 Town materials (categoria separada)

```
townMatBricks[10]  = {Mud, Mud, Limestone, Limestone, Marble, Marble, Granite, Granite, Basalt, Basalt}
townMatLogs[10]    = {Pine, Pine, Maple, Maple, Ash, Ash, Mahogany, Mahogany, Rosewood, Rosewood}
townMatShards[10]  = {Jasper, Jasper, Opal, Opal, ...}
```

Fonte: `18-economy.md:139-143`. **Town materials sao categoria separada de
Materials** — 5 tipos de Brick, 5 de Log, 5 de Shard. Tier por area. Dao
exclusivamente pra subir buildings.

#### 1.3.12 Catalyst (ascende equipamento)

```csharp
public enum CatalystKind { Slime, Mana, Frost, Flame, Storm, Soul, Sun, Void }
```

Fonte: `18-economy.md:149-151`. Versao "elemental"/raríssima dos materials.
Usados em Forge (`EquipmentForgeEffect`).

#### 1.3.13 Potions — 85 tipos, condicao de auto-consumo

Fonte: `references/ieh2_dump/docs/15-consumables.md:19-65`.

```csharp
public enum PotionKind {
  // === Heal ===
  MinorHealthPotion, ChilledHealthPotion,
  MinorRegenerationPoultice, ChilledRegenerationPoultice,
  // === Resource ===
  MinorResourcePoultice,
  // === Stat Elixir (basic) ===
  BasicElixirOfBrawn, BasicElixirOfBrains, BasicElixirOfFortitude, ...
  // === Defesa elemental ===
  FrostyDefensePotion, BurningDefensePotion, ElectricDefensePotion,
  // === Aura (alta tier elemental) ===
  IcyAuraDraught, BlazingAuraDraught, WhirlingAuraDraught,
  // === Slayer Oils ===
  FrostySlayersOil, FierySlayersOil, ShockingSlayersOil, ...
  // === Ropes (captura) ===
  ThrowingNet, IceRope, ThunderRope, FireRope, LightRope, DarkRope,
  // === Boss/Pet Dolls ===
  HitanDoll, RingoldDoll, NuttyDoll, ...
  // === Badges (taming) ===
  SlimeBadge, MagicslimeBadge, ..., AncientSlimeBadge, ...
}
```

**Padrao: familia × tier × elemento = explosao de variedade sem complexidade
logica.** Cada nova "potion" e' so um nome + valores.

#### 1.3.14 Slots de potion (equipped) + condicao de auto-consumo

Potions sao **equipadas** em slots (nao usados manualmente). Cada potion
equipped tem `kind`, `stackNum`, `slotId` e:

```csharp
public enum PotionConsumeConditionKind {
  Nothing,        // nao consome auto (manual)
  HpHalf,         // quando HP <= 50%
  AreaComplete,   // ao zerar uma area
  Defeat,         // ao matar mob (cada N?)
  Move,           // ao mover X
  Capture         // ao capturar
}
```

Fonte: `15-consumables.md:77-86`.

**Padrao genial pra idle:** o jogador **configura quando** a potion dispara.
Nao precisa hotkey. Idle puro.

#### 1.3.15 Alchemy (crafting de potions)

Fonte: `15-consumables.md:91-115`.

3 resources de Alchemy:
- **AlchemyPoint** — currency principal, gasta nos upgrades
- **TalismanFragment** — sub-currency pra forjar Talisman
- **MysteriousWater** — gerado **passivamente** (`...PerSec`), com cap
  expansivel

**MysteriousWater = "moeda do tempo".** Voce acumula AFK e gasta nas receitas.
**Cap expansivel:** primeira coisa que o jogador compra.

10 Alchemy Upgrades:

```csharp
public enum AlchemyUpgradeKind {
  Purification,    DeeperCapacity, CharmedLife,  Catalystic,
  EssenceHoarder,  PotentPotables, Aurumology,   WaterPreservation,
  MaterialThrift,  NitrousExtraction
}
```

**Apenas 10 upgrades — sistema enxuto.** Cada um tem identidade clara.

#### 1.3.16 Blessings (8 buffs temporarios)

```csharp
public enum BlessingKind {
  Hp, Atk, MAtk, MoveSpeed,
  SkillProficiency, EquipProficiency,
  GoldGain, ExpGain
}
```

Fonte: `15-consumables.md:138-145`.

Apenas 8 — versao simples de "boost temporario". Cada um cobre uma stat
global importante.

Padrao: `startTime = -86400.0` (24h atras) = "inativa". Simples e funciona —
sem campo `bool isActive`.

#### 1.3.17 Multibuy (QoL)

```csharp
public static long[] multibuyNums = {
  1L, 5L, 10L, 25L, 50L, 100L, 250L, 1000L, 2500L, 10000L,
  100000L, 1000000L, 100000000L, 1000000000L, 1000000000000L, 1e15
};
```

Fonte: `18-economy.md:158-161`. 16 valores com saltos exponenciais nos
extremos.

#### 1.3.18 Upgrade queue (automation)

Cada upgrade tem `upgradeQueues[]` no save. Jogador pode **enfileirar**
upgrades — o jogo compra automaticamente quando tiver currency. Endgame de QoL.
Fonte: `18-economy.md:172-176`.

---

## 2. Convergencias

Os 3 jogos concordam em varios padroes apesar de generos diferentes (clicker
puro, idle RPG MMO, idle RPG single-player). Os pontos comuns sao bom guia
pra Idle Medieval.

### 2.1 Schema universal de item

CC, IdleOn e IEH2 usam um schema base com discriminator (`itemType` em IdleOn,
`Part`+`Rarity` em IEH2, `pool` em CC). Permite UI/inventario genericos sem
codigo novo por tipo.

Aplicacao: Idle Medieval ja tem isso em `ItemData`
(`scripts/data/item_data.gd`). Confirma decisao.

### 2.2 Raridades em 5-6 tiers

| Jogo    | Quantos | Nomes |
|---------|---------|-------|
| IEH2    | 5       | Common, Uncommon, Rare, SuperRare, Epic |
| Idle Medieval | 6 | Common, Uncommon, Rare, Epic, Legendary, Mythic |
| IdleOn  | implicito ~6 | via prefixos e drop chance |
| CC tiers | 15 + special | mas tiers sao "tier de building" nao raridade per se |

Convergencia: **5-6 raridades** e' o sweet spot para RPG. Mais que 6 vira
confuso, menos que 5 e' raso.

**Hub atual (6 raridades) esta validado pelo consenso.**

### 2.3 Stats com pesos variando ate ~6x entre Common e topo

| Jogo   | Mult Common -> Top |
|--------|--------------------|
| IEH2 (XP req) | 1x -> 450x (Epic gate é 10.000x) |
| Idle Medieval | 1x -> 6.5x (faixa de stats) |
| IdleOn | varia, ~5x tipico |

IEH2 e' caso extremo (XP de level, nao stat base). Para **stats base** (que e'
o que Idle Medieval define em equipment-catalog), a faixa 1x-6.5x esta
alinhada.

### 2.4 Drops como dropchance independente por entry

Idleon: cada entry em `loot_table` rola independente
(`02_ITEMS_CRAFTING_DROPS.md:225-241`). IEH2: similar via `EquipmentDropChance`
stat. Idle Medieval: ja implementado em `02_math/drop-rates.md` secao 3.

Convergencia validada.

### 2.5 Sistema de "upgrade-stones" / encantamentos / forge

Os tres jogos tem **camadas adicionais de upgrade pos-drop**:

- **CC**: tiered upgrades por building (15 niveis), cada um dobra CPS.
- **IdleOn**: `Upgrade_Slots_Left` em cada item + Stamps/Cards/Bubbles/Obols
  paralelos.
- **IEH2**: 3 camadas de afixos (Effects/Forge/Option) + Enchant verbs +
  Talismans + Catalysts.

**Padrao chave:** "drop em si nao e' suficiente". Sempre ha **camada de
investimento** pra fazer o drop melhorar.

### 2.6 Materials = 1 por species

IEH2: `MaterialKind` 26 tipos, mob -> material 1-pra-1. IdleOn: `Quest` items
+ `CraftMat*` por mob. Idle Medieval: `gathering-materials.md` lista 15 mining,
12 wood, 14 fish... + drops de mob.

**Convergencia: material identitario por inimigo cria gameplay direcionado.**
"Vou farmar X mob pra Y material" e' fundamental.

### 2.7 Consumables com auto-trigger

IEH2 tem `PotionConsumeConditionKind` (HpHalf, AreaComplete, etc.). Idle
Medieval ja prevê pocoes em `crafting-catalog.md#82-pocoes-de-buff`. CC nao tem
combate, mas tem "auto-click" upgrades equivalentes.

Convergencia: **idle game = potion auto-trigger MANDATORIO.** Jogador nao
pode ser obrigado a clicar pocao.

### 2.8 Cap em chance final (drop nunca 100%)

- IEH2: cap em `EquipmentDropChance` 100%.
- IdleOn: chance clampada a 1.0 apos modifiers
  (`02_ITEMS_CRAFTING_DROPS.md:240-246`).
- Idle Medieval: `Per-entry chance cap = 0.99`
  (`02_math/drop-rates.md` secao 9).

**Convergencia 100%: cap mole em 99% e' essencial pra manter "perdi um drop"
no late.**

### 2.9 Set bonuses flexiveis

IdleOn: armaduras-completas + `requiredTools >= N` tools quaisquer
(`02_ITEMS_CRAFTING_DROPS.md:131`). IEH2: `EquipmentSetKind` (implementacao
nao detalhada). Cookie Clicker: synergies entre buildings.

**Padrao: nao forcar set 100% match.** Permitir hibridismo (armadura set A +
tools/weapons soltos) aumenta o espaco de build.

### 2.10 Pool/queue de upgrades automaticos

IEH2: `upgradeQueues[]` no save. CC: `Game.storeBuyAll()` com Inspired
checklist. IdleOn: anvil products produzem AFK.

**Convergencia: automacao de compras/producao no late game e' obrigatoria.**

---

## 3. Divergencias / Decisoes pendentes

### 3.1 Quantos tiers de equipment por slot?

| Jogo   | Tiers por slot principal |
|--------|--------------------------|
| IEH2   | 50 levels x 5 raridades por item (~250 estados por item-kind), mas so ~36 nomes distintos por part |
| IdleOn | ~10 tiers (138 capacetes / 14 tiers) |
| Idle Medieval (atual) | 6 (Common -> Mythic) + variantes por slot |
| CC     | 15 tiered upgrades por building |

**Conflito:** IEH2 evita "tiers" e investe em **level-per-item**. IdleOn vai
no "muitos tiers nomeados". Cookie Clicker forca 15 tiers fixos.

[DECISAO PENDENTE: Idle Medieval mantem 6 raridades + ~3 variantes nomeadas
por raridade (~18 itens por slot) ou expande pra 8-10 raridades?]

**Recomendacao da pesquisa:** manter as 6 raridades (ja decidido). Para
**variedade**, usar **3 variantes nomeadas por raridade** (ex: 3 Capacetes
Common diferentes — Capuz de Linho, Capacete de Couro Cru, Tiara de
Aprendiz). Total: 6 x 3 = 18 capacetes (alinha com IdleOn 138/14 = ~10/raridade
e CC 15 tiers). **Ver `equipment-catalog.md` secao 4.1 — ja esta nesse padrao.**

### 3.2 Drop rate model: per-kill chance vs per-kill quantity

| Modelo            | IdleOn | IEH2 | CC | Idle Medieval |
|-------------------|--------|------|----|---------------|
| chance per kill   | sim    | sim  | nao | sim |
| quantity-as-kill-count | sim (drops ultra-raros) | nao | nao | nao |
| pity/streak       | nao    | nao  | nao | sim (Mythic) |
| timer-based drop  | nao    | nao  | sim (golden cookies) | nao |

**Conflito:** quantity-as-kill-count (IdleOn) e' elegante porque mostra
**feedback** do que falta. Em vez de `chance: 0.000001`, mostrar
"voce precisa matar 1M slimes pra ter chance" (`02_ITEMS_CRAFTING_DROPS.md:285`).

[DECISAO PENDENTE: Adicionar campo `unlocks_at_kill_count_quantity` em
`LootEntry` para drops ultra-raros tipo Trophy? Ja existe
`unlocks_at_kill_count` mas como gate binario, nao como progress bar.]

Idle Medieval ja tem mecanica de **Mob Slaughter** que aumenta card chance
linear (`drop-rates.md` secao 8). Padrao similar — confirma o sistema.

### 3.3 Crafting graph: profundidade

| Jogo   | Profundidade tipica | Total receitas |
|--------|---------------------|----------------|
| CC     | 1 nivel (cookie = comprado direto) | 246 cookies |
| IdleOn | 3-5 niveis (DAG recursivo) | 420 |
| IEH2   | 2-3 niveis (Material -> Potion -> Buff) | ~85 potions + 36 enchant verbs |
| Idle Medieval (atual) | 2-3 niveis (Smithing tem 38, Smelting 12, etc.) | ~150 |

**Convergencia: 2-3 niveis e' o ideal pra evitar "esqueci pra que servia esse
material".** IdleOn vai 3-5 mas isso e' parte do problema dele — sentir-se
overwhelmed.

[DECISAO PENDENTE: Mantemos 2-3 niveis (escolha atual) ou empurramos pra 3-4
em endgame para conteudo de fase tardia?]

**Recomendacao:** Mantemos 2-3 niveis pra **MVP/Fase 02**. Em fase tardia
(Fase 04+), adicionar **"Master Recipes"** que sao 4-niveis (descobertas via
quest, NPCs ou achievement).

### 3.4 Upgrade pos-drop: enchant vs gem vs evolution

| Sistema | IEH2 | IdleOn | CC | Idle Medieval (atual) |
|---------|------|--------|----|------------------------|
| Encantamento (verbo) | sim (36) | parcial (Obols, Cards) | nao | sim (`crafting-catalog.md` secao 9) |
| Gem socket | nao (mas tem ArtifactEnchant) | nao | nao | sim (tabela 2 do equipment-catalog) |
| Level-up item | sim (max 50/60) | nao | nao | NAO |
| Stamps/Cards (paralelo) | nao | sim (extenso) | sim (sinergias) | parcial (cards-catalog.md) |
| Forge (catalyst) | sim (8 catalysts) | nao | nao | NAO |
| Star Power | nao explicito mas Forge | nao | nao | NAO |
| Evolution | parcial (ArtifactKind = item elevado) | nao | nao | NAO |

**Conflito:** IEH2 nao usa gems mas tem 3 camadas de afixos + level-per-item.
IdleOn usa **camadas paralelas** (cards, stamps, bubbles, obols). Idle
Medieval atual prevê **enchant + gem socket** mas nao level-per-item.

[DECISAO PENDENTE: Adicionar level-per-item (IEH2-style) na Idle Medieval ou
manter so enchant + gem?]

**Recomendacao da pesquisa (proposta na secao 4):**
- **MVP/Fase 02:** enchant (ja decidido) + gem socket (ja decidido). Sem
  level-per-item.
- **Fase 03+:** adicionar **Level de Maestria** ao item (max 10, igual
  `isMaxed` do IEH2) que da um **Codex bonus permanente** ao desbloquear.
  Codex ja existe em Idle Medieval (`equipment-catalog.md` secao 5).
- **Fase 04+:** adicionar **Forge** com 4-6 catalysts elementais (subset do
  IEH2). Forge produz "Star Power" do item — bonus permanente quando aplicado.

### 3.5 Consumables: stack-equipados vs inventario livre

| Jogo   | Modelo |
|--------|--------|
| IEH2   | Slots de potion **equipados** com auto-trigger por condicao |
| IdleOn | Potions/Food no inventario, dispara em combate (auto via talents) |
| CC     | Nao aplicavel |
| Idle Medieval | Nao decidido ainda |

[DECISAO PENDENTE: Pocoes ficam no inventario e disparam automaticamente
quando condicao bate? Ou ha "slots de pocoes equipadas" estilo IEH2?]

**Recomendacao:** **Slots equipados** (IEH2-style). Razoes:
1. UI mais clara — o jogador VE qual pocao vai disparar.
2. Limita "spam" (nao da pra carregar 50 pocoes diferentes e disparar todas).
3. Cria decisao de build (qual pocao priorizar?).
4. Auto-consumo por condicao (HpHalf, AreaComplete, Defeat, Move, Capture).

[DECISAO PENDENTE: Quantos slots de pocao equipada? IEH2 nao expoe numero
direto; sugerir 4 slots na Fase 02 (1 heal, 1 mana, 1 buff, 1 utility),
expandir para 6 em Fase 04+.]

### 3.6 Drop rate base por raridade: comparacao

| Raridade  | Idle Medieval | IEH2 (item base) | IdleOn (drop tipico) |
|-----------|---------------|------------------|-----------------------|
| Common    | 60%           | -                | ~22% (Spore_Cap)      |
| Uncommon  | 25%           | -                | ~7%                   |
| Rare      | 10%           | -                | ~2%                   |
| Epic      | 3.5%          | -                | ~0.2% (Trophy)        |
| Legendary | 1.2%          | -                | ~0.03% (raras 1 em ~3k) |
| Mythic    | 0.3%          | 1E-05 (unique base) | ~0.0001% (mega rare) |

IEH2 usa **1E-05** como base unique, depois multiplicado por
`EquipmentDropChance` que pode chegar a 100%. Idle Medieval e' mais generoso
em Mythic — apropriado pra um idle de 3-5 anos. Confirma decisao atual.

### 3.7 Currencies: quantas e quais?

| Jogo   | Currencies principais |
|--------|------------------------|
| CC     | Cookies + Sugar Lumps + Heavenly Chips + Prestige (3 layers) |
| IdleOn | Gold + Stamps levels + Bubbles + Cards + Account Bonus + Talents/Skills |
| IEH2   | Gold + 3 ResourceKind + 26 MaterialKind + SlimeCoin + DungeonCoin + Ruby + Essence + TalismanFragment + MysteriousWater + EpicCoin |
| Idle Medieval (atual) | Gold + Materiais + (ainda em definicao) |

IEH2 tem ~10 currencies separadas. Cookie Clicker tem 3 layers + sugar lumps.
IdleOn tem ~5 layers principais.

[DECISAO PENDENTE: Quais currencies "premium/endgame" Idle Medieval tera?]

**Recomendacao:** comecar com **3 currencies** em MVP:
1. **Gold** (drop generico, gasta em vendor/upgrades).
2. **Material count** (cada material e' currency propria).
3. **Token de Festival** (raro, dropa em events).

Adicionar conforme fases:
- Fase 03+: **Essencia de Encantamento** (currency pra enchant).
- Fase 04+: **Fragmento de Talisma** (TalismanFragment-style, gerado por
  Alchemy).
- Fase 05+: **Po Cosmico** (prestige currency).

### 3.8 Material por species vs material generico

| Modelo | IEH2 | IdleOn | Idle Medieval (atual) |
|--------|------|--------|------------------------|
| 1 material por species | sim (26 species) | sim | sim (mob -> drop especifico) |
| Materiais agrupados por bioma | parcial | nao | parcial (T1=Floresta, etc.) |

Convergencia. Idle Medieval ja segue isso. **Confirma.**

### 3.9 Set bonus: forcar full set vs flexivel

| Jogo   | Modelo |
|--------|--------|
| IdleOn | Flexivel (armaduras + N tools quaisquer) |
| IEH2   | `EquipmentSetKind` (implementacao nao detalhada — assumido full set) |
| Idle Medieval | Nao decidido ainda |

[DECISAO PENDENTE: Sets em Idle Medieval seguem IdleOn (flexivel, "armadura
completa + N tools") ou WoW-classic (full match)?]

**Recomendacao:** **IdleOn-style flexivel.** Permite combos entre sets, evita
"set fechado" que penaliza experimentacao.

---

## 4. Proposta para o Idle Medieval

### 4.1 Tiers por slot — FINALIZAR

**Decisao:** 6 raridades x ~3 variantes nomeadas por raridade x ~9 slots
principais = **~162 itens por categoria principal** (capacetes, peitorais).
Para slots secundarios (acessorios, ferramentas): ~10-15 variantes totais.

Total estimado catalogavel:
- 4 slots de armadura x 6 raridades x 3 variantes = **72 itens**
- 4 slots de acessorio x 6 raridades x 3 variantes = **72 itens**
- Arma: 6 raridades x ~5 familias x 3 variantes = **~90 itens**
- 3 ferramentas x 6 raridades x 3 variantes = **54 itens**
- Total: **~288 itens equipaveis** (catalogavel em `equipment-catalog.md` ja).

Ja esta no padrao — equipment-catalog.md tem ~3 variantes por (slot, tier).
**Confirma o estado atual.**

### 4.2 Pipeline de upgrade pos-drop: gems + enchants + level-de-maestria

Tres camadas sequenciais conforme jogador progride:

#### 4.2.1 Camada 1: Enchant (Fase 02+, ja decidido)

- 26 encantamentos catalogados em `crafting-catalog.md#9-estacao-enchanting`.
- Cada tier de equip suporta ate N enchants
  (`equipment-catalog.md#21-tabela-de-regras-de-encantamento-por-tier`).
- **Niveis I-X** alcancados via combinar pergaminhos do mesmo tipo.

Adaptar IEH2: usar **verbos** como Add (pergaminho normal), Reroll (resetar
afixo), Lock (bloquear afixo antes de reroll), Combine (fundir 3 pergaminhos
pra subir nivel).

[DECISAO PENDENTE: Adicionar 4 verbos extras (Reroll/Lock/Extract/Copy)
inspirados no IEH2 ja na Fase 02, ou esperar Fase 03+?]

#### 4.2.2 Camada 2: Gems socket (Fase 02+, ja decidido)

- Common/Uncommon = 0 gems.
- Rare/Epic = 1 gem.
- Legendary = 2 gems.
- Mythic = 2 gems + 1 slot fixo mythic.
- 7 gemas brutas listadas em `gathering-materials.md#21-gemas-brutas`.

Adicionar **Jewelcrafting** (`gathering-materials.md` ja mentioned) como
estacao especifica de lapidacao em fase posterior.

#### 4.2.3 Camada 3: Level de Maestria do item (Fase 03+, NOVA)

Inspirado em IEH2 `equipmentLevelsHero` + `isMaxed`:

- Cada item tem **level 0-10**.
- XP de level vem de **usar o item em combate**.
- Curva: `xp_req(level) = base × 1.3^level`, onde `base = 100 × rarity_mult`.
  - Common: 100, 130, 169, 220, 286, 372, 484, 629, 818, 1063 (level 0-9).
  - Mythic: 100 × 6.5 = 650 base, dobrando ate 1300 base em Mythic level 0 = 650
    em vez de 100. (`02_math/drop-rates.md` tabela de mult.)
- **Level 10 marca `is_maxed`**, libera o slot do **Codex de Maestria**.
- Codex de Maestria da **stat fixo por (slot, tier)** ja definido em
  `equipment-catalog.md#51-tabela-de-bonus-por-tipotier-oficial`.

**Diferenca com IEH2:** IEH2 tem level per-item-per-hero (cada heroi sobe seu
proprio). Em Idle Medieval com multi-personagem, **level per-item global**
(qualquer personagem leveling o item conta) — simplifica e alinha com
Codex que ja e' account-wide.

[DECISAO PENDENTE: Level global ou per-personagem? Recomendacao: global, pra
nao penalizar swap de personagem.]

#### 4.2.4 Camada 4: Forge (Fase 04+, NOVA)

Inspirado em IEH2 `ForgeEffectKind` + `CatalystKind`:

- 4 catalysts elementais (Slime/Mana/Frost/Flame) + 2 advanced (Soul/Void).
- **Cada catalyst aplica 1 ForgeEffect ao item** (max 3 ForgeEffects por
  item).
- Drop de catalyst e' raro (~0.5%).
- ForgeEffect e' **permanente** (nao removivel sem perder o item).

Cria **decisao estrategica** ("guardo esse Catalyst pra um item Epic ou gasto
no Rare ja?"). Drop rate baixo evita uso indiscriminado.

#### 4.2.5 Camada 5: Star Power / Evolution (Fase 05+, NOVA)

Inspirado em **IEH2 ArtifactKind** + IdleOn **Star Stamps**:

- Item com Codex maxed pode ser **"evolved"** consumindo cópia adicional do
  mesmo item-id.
- Cada evolucao **dobra stats base do item** + adiciona 1 affix slot adicional.
- Max 5 evolucoes por item.
- Apenas Legendary e Mythic suportam evolucao.

Cria **uso pra duplicatas de high-tier drops** (que sao frustrantes em outros
idle games).

### 4.3 Crafting graph: 2-3 niveis (MVP) + 4 niveis (Master Recipes em Fase 04+)

Profundidade tipica em MVP/Fase 02:

```
T1 Material (Minerio de Ferro) -> Barra de Ferro (Smelting) -> Espada de Treino (Smithing)
```

3 niveis para tier alto:

```
T2 Material (Minerio de Mithril) -> Barra de Mithril -> Cabo Premium de Ebano + Tendao -> Greatsword do Comandante
```

Em Fase 04+, adicionar **Master Recipes**:

```
T6 Material (Po de Estrela) -> Barra Estelar -> [...] -> [...] -> Lamina do Vazio (Mythic)
```

Master Recipes descobertas via:
- NPC (quest line),
- Drop raro (1% em bosses de zona),
- Achievement (mat 1000 enemies in Pantano).

### 4.4 Como expor consumables: slots equipados + auto-trigger

**Slots equipados** (NAO inventario livre):

- **4 slots em Fase 02**: 1 heal, 1 mana, 1 buff, 1 utility.
- **6 slots em Fase 04+**: + 1 elemental defense, + 1 oil/special.

Cada slot tem:
- `kind` (qual pocao),
- `stack_num` (quantas tem em estoque),
- `consume_condition` (Nothing/HpHalf/AreaComplete/Defeat/Move/Capture —
  copiado direto do IEH2 `PotionConsumeConditionKind`).

UI: tela `Character` ja tem 5 paineis (`equipment-catalog.md` secao 0). Adicionar
painel **"Consumables"** ao lado dos paineis de equipment, com os 4-6 slots.

#### 4.4.1 Curva de duracao de pocao

Inspirado em IEH2 `Blessings`:

| Pocao         | Duracao tipica |
|---------------|----------------|
| Pocao de HP   | instantaneo |
| Pocao do Forjador | 30min real (`crafting-catalog.md` secao 8.2) |
| Oleo de Lamina | 60min real |
| Banquete | 60min real |
| Pocao Cosmica | 30min (mas mais potente) |

Convergencia: **30-60min real** para pocoes de buff e' o padrao certo. 5min e'
curto demais (jogador perde antes de combinar com sessao), 4h e' longo demais
(domina build).

### 4.5 Drop tables: adotar formato array ordenado do IdleOn

Atualmente Idle Medieval usa `loot_table: Array[LootEntry]` em `EnemyData`
(`02_math/drop-rates.md` secao 2). Ja e' formato compativel com IdleOn.

**Adicao recomendada:** suportar 3 features do IdleOn:

1. **Quantity-as-kill-count**: campo `kill_count_threshold` em `LootEntry` que
   permite drops tipo "1 chance em N a cada M kills".
   - Diferente do `unlocks_at_kill_count` atual (gate binario).
   - Util pra Trophys ultra-raros e Card-specific.

2. **Slots vazios placeholder** com `chance=0` pra futura adicao.

3. **`questLink`** field pra drops que so liberam apos quest especifica.

[DECISAO PENDENTE: Implementar `kill_count_threshold` ja na Fase 02 ou Fase 03+?]

### 4.6 Set bonuses: IdleOn-style flexivel

Para Idle Medieval:

```
Set "Ferro do Reino":
  armaduras_required: [Elmo de Ferro Reforçado, Peitoral de Ferro Lapidado, Polainas de Ferro, Botas de Ferro Espinhadas]
  tools_required_count: 1   # qualquer tool de tier >= 2
  weapon_required: false    # qualquer arma
  bonus: "+10% DEF, +5% Resist Status"
```

Permite usar **Espada Larga de Ferro** + Picareta de Mithril + set de Ferro
completo = ainda ativa bonus (porque tem >= 1 tool).

### 4.7 Currencies em Idle Medieval (proposta de fases)

| Fase | Currencies adicionadas |
|------|------------------------|
| 02   | Gold + Materiais + Festival Tokens |
| 03   | + Essencia de Encantamento (Alchemy by-product) |
| 04   | + Fragmento de Talisma + Catalysts (drop raro) |
| 05   | + Po Cosmico (prestige) |

Total endgame: **~6 currencies separadas + materiais**. Suficiente sem virar
o caos de IEH2 (~10).

### 4.8 Padroes complementares a adotar

#### 4.8.1 Multibuy bar (de IEH2)

```python
multibuy_nums = [1, 5, 10, 25, 50, 100, 250, 1000, 2500, 10000,
                 100000, 1000000, 100000000]
```

Adicionar em Crafting + Vendor + Upgrades. Fase 02.

#### 4.8.2 Upgrade queue (de IEH2)

Permitir enfileirar compras em Vendor/Crafting. Comprar automaticamente quando
tem currency. Fase 03+.

#### 4.8.3 Inventario com `Upgrade_Slots_Left` (de IdleOn)

Cada item tem campo `enchant_slots_remaining` indicando quantos encantamentos
ainda podem ser aplicados. Permite **degrade gradual** de items (cada
encantamento "gasta" 1 slot).

[DECISAO PENDENTE: Encantamentos consomem slot permanentemente ou podem ser
removidos via `Delete` enchant verb?]

**Recomendacao:** consumir slot. Cria **decisao consciente** ("vou gastar slot
nesse enchant ou guardar?"). Verbo `Delete` apaga o enchant **mas nao
restaura o slot** — alinhado com Diablo/PoE.

#### 4.8.4 Drop rate multiplicador global (de Cookie Clicker)

Idle Medieval ja tem `loot_gain_pct` (`02_math/drop-rates.md` tabela 5).
Validado pelos 3 jogos.

#### 4.8.5 Mob slaughter / kill count progression (de IdleOn)

Ja implementado em `drop-rates.md` secao 8 (cards aumentam com kill count).
Confirma.

---

## 5. Hooks com docs existentes

### 5.1 Arquivos que ja cobrem topicos desta sintese

| Topico desta sintese | Arquivo do hub | Status |
|----------------------|----------------|--------|
| 6 raridades | `01_design/equipment-catalog.md#2` | ja definido |
| 18 slots | `01_design/equipment-catalog.md#1` | ja definido (mas atual lista 10+3, sintese sugere recometer ate 18) |
| Stats por slot/tier | `01_design/equipment-catalog.md#4` + `#5.1` | ja completo |
| Crafting graph | `01_design/crafting-catalog.md` | ja completo (Smithing/Smelting/Cooking/Alchemy + Sawmill/Leather/Enchanting) |
| Drop rates por raridade | `02_math/drop-rates.md#1` | ja definido |
| Loot Gain stat | `02_math/drop-rates.md#5` | ja definido |
| Pity Mythic | `02_math/drop-rates.md#6` | ja definido |
| Materials | `01_design/gathering-materials.md` | ja completo (15 mining, 12 wood, 14 fish + planejado) |
| Cards | `01_design/cards-catalog.md` (citado, nao lido nesta sessao) | confirmar |
| Encantamentos | `01_design/crafting-catalog.md#9` | ja completo (26 encantamentos) |
| Codex de Power | `01_design/equipment-catalog.md#5` | ja definido (stat fixo por slot+tier) |

### 5.2 Hooks que esta sintese sugere ADICIONAR aos docs

1. **`01_design/equipment-catalog.md`** — adicionar secao 7 "Level de Maestria"
   com curva XP/level e regra de `is_maxed` -> Codex.

2. **`01_design/crafting-catalog.md`** — adicionar secao 10 "Forge" com 6
   catalysts + ForgeEffects.

3. **`01_design/crafting-catalog.md`** — adicionar secao 11 "Evolution / Star
   Power" (Fase 05+) com merge de items duplicados.

4. **Novo arquivo:** `01_design/consumables-catalog.md` — lista de pocoes
   equipaveis com slots + condicoes de auto-trigger. Atualmente pocoes estao
   misturadas em `crafting-catalog.md#8`.

5. **`02_math/drop-rates.md`** — adicionar secao 11 "Quantity-as-kill-count"
   pra drops ultra-raros (Trophys, Cards de boss).

6. **`02_math/drop-rates.md`** — adicionar secao 12 "Forge Catalyst drop rate"
   (0.5% por boss/elite kill em Fase 04+).

7. **Atualizar `00_meta/glossary.md`** com termos novos:
   - `Forge` / `Catalyst` / `ForgeEffect`
   - `Star Power` / `Evolution`
   - `Level de Maestria` / `is_maxed`
   - `Consumable Slot` / `Auto-trigger Condition`
   - `Master Recipe`

### 5.3 Conflitos com `roadmap-sistemas.md`

Nao detectados nesta sessao — esta sintese amplia o que o hub ja tem sem
contradizer. Se houver conflito futuro, **o hub vence**
(`00_meta/self-instructions.md:32`).

### 5.4 Cross-refs cruciais (criar nos docs existentes apos esta sintese)

- `equipment-catalog.md` -> link pra `consumables-catalog.md` (novo).
- `equipment-catalog.md` -> link pra **Camada 3 (Level de Maestria)** quando
  criada.
- `crafting-catalog.md#9-estacao-enchanting` -> link pra `drop-rates.md#11`
  (kill-count quantity).
- `drop-rates.md#11` -> link pra `references/idleon-reference/02_ITEMS_CRAFTING_DROPS.md:222-227`
  (fonte do padrao).

---

## 6. Resumo executivo

### 6.1 O que JA esta no hub e foi VALIDADO pela pesquisa

- 6 raridades (Common -> Mythic).
- ~18 slots equipaveis incluindo 4 ferramentas.
- Stat fixo por (slot, tier) no Codex.
- Drop rates base por raridade alinhadas com IdleOn.
- Per-entry chance cap em 0.99.
- Pity de Mythic em 100 legendary streak.
- Crafting com Smithing/Smelting/Cooking/Alchemy + Sawmill/Leather/Enchanting.
- 26 encantamentos com niveis I-X.
- Gemas brutas com 7 tipos.

### 6.2 O que esta sintese RECOMENDA ADICIONAR (em ordem de fase)

**Fase 02 (MVP+):**
- Multibuy bar (saltos exponenciais).
- 4 slots de consumables equipados com `consume_condition` enum (Nothing,
  HpHalf, AreaComplete, Defeat, Move, Capture).

**Fase 03:**
- Level de Maestria do item (0-10, `is_maxed` -> Codex).
- 4 verbos de enchant extras (Add ja existe; adicionar Reroll, Lock, Combine,
  Delete).
- Upgrade queue.
- `kill_count_threshold` em LootEntry pra drops ultra-raros.

**Fase 04:**
- Forge + 6 Catalysts (Slime, Mana, Frost, Flame, Soul, Void).
- ForgeEffects (max 3 por item).
- Master Recipes (4-niveis de craft).
- 2 slots adicionais de consumables (totalizando 6).

**Fase 05+:**
- Evolution / Star Power (merge de items duplicados, max 5 evolucoes).
- Po Cosmico como prestige currency.

### 6.3 Decisoes pendentes para esta sintese resolver com o usuario

[DECISAO PENDENTE 1]: Mantemos 6 raridades x ~3 variantes por slot (decisao
atual implicita no `equipment-catalog.md`)? **Resposta proposta: SIM,
manter.**

[DECISAO PENDENTE 2]: Adicionar `kill_count_threshold` (quantity-as-kill-count
do IdleOn) em `LootEntry` ja na Fase 02 ou esperar Fase 03+? **Resposta
proposta: Fase 03+ pra nao sobrecarregar MVP.**

[DECISAO PENDENTE 3]: 4 slots de consumables na Fase 02 + 2 extras na Fase
04+ (total 6) ou comecar com 3 e expandir? **Resposta proposta: 4 + 2 = 6.**

[DECISAO PENDENTE 4]: Level de Maestria do item e' **global** (account-wide)
ou **per-personagem** (IEH2-style)? **Resposta proposta: global, alinhado com
Codex.**

[DECISAO PENDENTE 5]: Encantamento consome slot permanente ou pode ser
removido sem custo? **Resposta proposta: consome slot permanente. Verbo
`Delete` apaga enchant mas slot fica indisponivel.**

[DECISAO PENDENTE 6]: Forge / Catalysts entra na Fase 04 ou pula direto pra
Evolution na Fase 05? **Resposta proposta: Forge na Fase 04, Evolution na
Fase 05 — duas adicoes separadas pra evitar overwhelm.**

[DECISAO PENDENTE 7]: Sets em Idle Medieval seguem IdleOn-style flexivel
(armaduras-completas + N tools quaisquer) ou WoW-classic full-match?
**Resposta proposta: IdleOn-style flexivel.**

[DECISAO PENDENTE 8]: Quantas currencies endgame Idle Medieval tera? **Resposta
proposta: 6 total (Gold + Festival Tokens + Essencia de Encant + Fragmento
de Talisma + Catalysts as currency + Po Cosmico).**

[DECISAO PENDENTE 9]: Master Recipes (craft 4-niveis) descobertas via NPC
quest, drop raro em boss ou achievement de slaughter? **Resposta proposta:
mix dos 3 — variety por receita.**

[DECISAO PENDENTE 10]: Tier de potion segue familia × tier × elemento (IEH2
85 potions) ou consolida em ~30 pocoes nomeadas? **Resposta proposta: ~30
pocoes nomeadas (alinha com tamanho atual de `crafting-catalog.md#8`).
Expandir conforme demanda.**

---

## 7. Linhas-ancora de referencia (para verificacao futura)

### 7.1 Cookie Clicker
- Tabela de Tiers (15 tiered upgrades): `04-upgrades.md:84-102`
- Cookie flavor upgrades (246, agrupados por +%): `04-upgrades.md:514-543`
- Synergy upgrades formula: `04-upgrades.md:630-636`
- Garden drops (plantas -> upgrades): `11-minigame-garden.md:140-162`
- Garden mutacoes (50 entries): `11-minigame-garden.md:216-269`
- Stock market modes (6 estados): `12-minigame-market.md:84-94`

### 7.2 IdleOn
- Schema universal item: `02_ITEMS_CRAFTING_DROPS.md:11-33`
- Distribuicao por slot: `02_ITEMS_CRAFTING_DROPS.md:36-57`
- Crafts recursivos (DAG): `02_ITEMS_CRAFTING_DROPS.md:73-89`
- Anvil products: `02_ITEMS_CRAFTING_DROPS.md:96-114`
- Sets flexiveis: `02_ITEMS_CRAFTING_DROPS.md:120-131`
- Drop table format: `02_ITEMS_CRAFTING_DROPS.md:200-241`
- Quantity-as-kill-count: `02_ITEMS_CRAFTING_DROPS.md:225-227`
- Obols com shape: `02_ITEMS_CRAFTING_DROPS.md:254-269`
- Traps super-lineares: `02_ITEMS_CRAFTING_DROPS.md:142-156`

### 7.3 IEH2
- Slots/raridades enum: `04-equipment.md:5-9`
- Levels per-hero: `04-equipment.md:22-26`
- Curva XP item: `04-equipment.md:42-53`
- Slots upgradable via Rebirth: `04-equipment.md:69-73`
- 3 camadas de afixos: `04-equipment.md:80-90`
- 36 enchant verbs: `04-equipment.md:92-104`
- Drop chance base: `04-equipment.md:114-118`
- Hierarquia de currencies: `18-economy.md:7-25`
- 26 Materials: `18-economy.md:117-132`
- Town materials separados: `18-economy.md:139-143`
- 8 Catalysts: `18-economy.md:149-151`
- Multibuy bar: `18-economy.md:158-161`
- Upgrade queue: `18-economy.md:172-176`
- 85 Potion kinds: `15-consumables.md:19-65`
- PotionConsumeCondition: `15-consumables.md:77-86`
- Alchemy currencies tripla: `15-consumables.md:91-115`
- 10 AlchemyUpgrades: `15-consumables.md:117-130`
- 8 Blessings: `15-consumables.md:138-145`
- Talisman = endgame Alchemy: `15-consumables.md:175-178`

### 7.4 Hub Idle Medieval (estado consultado)
- Equipment catalog completo: `01_design/equipment-catalog.md`
- Crafting catalog completo: `01_design/crafting-catalog.md`
- Drop rates math: `02_math/drop-rates.md`
- Gathering materials: `01_design/gathering-materials.md`
- Self-instructions: `00_meta/self-instructions.md`
