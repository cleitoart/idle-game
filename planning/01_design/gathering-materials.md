# Gathering Materials - Catalogo de Materiais por Skill de Coleta

> Materiais por skill de coleta, organizados por tier (T1-T6 alinhado com zonas). Fonte: `roadmap-sistemas.md` secao 3.9. Termos: ver `00_meta/glossary.md`.

---

## 1. Convencoes

- **Tier de material (T1-T6)** alinhado com zona de origem:
  - T1 = Floresta (Zona 1)
  - T2 = Deserto (Zona 2)
  - T3 = Caverna (Zona 3)
  - T4 = Pantano (Zona 4)
  - T5 = Tundra (Zona 5)
  - T6 = Templo Celestial (Zona 6)
- **Mastery por item** (modelo Melvor): cada material tem 1-99 progressao individual. Mastery alta da: speed up, drop chance, drop duplo.
- **XP por hit** = base na primeira coleta sem mastery.
- **Tempo base** = segundos por hit base.
- **Spot** = ponto fixo no mapa da zona (substitui antigo botao Gathering). [ver: glossary.md#spot]

[DECISAO PENDENTE: Livestock, Planting/Gardening, Hunting e Archaeology nao sao MVP. Entram em fases posteriores. Esses sistemas geram materiais especificos (carne fresca, leite, ovos, sementes, fosseis) que aparecem como `[fonte futura: Livestock]`, `[fonte futura: Hunting]` etc nos catalogos que dependem deles.]

---

## 2. Mining (Mineracao) - 14 materiais

[PLACEHOLDER: sprite de spot de mineracao por tier (rocha pequena, veio brilhante, geodo)]

| Material              | Tier  | Zona origem                | XP/hit | Tempo base | Notas                        |
| --------------------- | ----- | -------------------------- | ------ | ---------- | ---------------------------- |
| Pedra Bruta           | T1    | Floresta                   | 5      | 3.0s       | Material base de construcao  |
| Minerio de Cobre      | T1    | Floresta                   | 8      | 3.5s       | Funde em Barra de Cobre      |
| Minerio de Estanho    | T1    | Floresta (raro)            | 10     | 4.0s       | Combina com Cobre = Bronze   |
| Carvao                | T1    | Caverna inicial / Deserto  | 12     | 3.5s       | Insumo critico de Smelting   |
| Minerio de Ferro      | T2    | Deserto / Caverna inicial  | 15     | 4.5s       | Funde em Barra de Ferro      |
| Minerio de Prata      | T3    | Caverna media              | 22     | 5.5s       | Acessorios                   |
| Minerio de Ouro       | T3    | Caverna profunda           | 30     | 6.5s       | Acessorios + UI gold sink    |
| Minerio de Mithril    | T3-T4 | Caverna profunda / Pantano | 45     | 8.0s       | Tier alta de armas/armaduras |
| Minerio de Adamantita | T4    | Pantano profundo           | 65     | 10s        | Endgame de mid               |
| Minerio de Orichalcum | T5    | Tundra                     | 90     | 12s        | Endgame de tundra            |
| Cristal Bruto         | T3    | Caverna                    | 50     | 8.5s       | Crafting magico              |
| Cristal Cantante      | T5    | Tundra                     | 110    | 14s        | Componente de magia avancada |
| Pedra Vulcanica       | T3-T4 | Caverna profunda           | 55     | 9s         | Smelting tier alta           |
| Pedra Glacial         | T5    | Tundra                     | 100    | 13s        | Anel da Geleira, etc.        |
| Po de Estrela         | T6    | Templo Celestial           | 140    | 16s        | Smelting Estelar             |

Total: 15 itens. (12+ requeridos satisfeito.)

### 2.1 Gemas brutas (sub-categoria de Mining)

| Material | Tier | Drop chance ao minerar | Notas |
|---|---|---|---|
| Esmeralda Bruta | T2 | 1% | Engastes verdes |
| Rubi Bruto | T3 | 0.7% | Engastes vermelhos |
| Safira Bruta | T4 | 0.5% | Engastes azuis |
| Topazio Bruto | T2 | 1% | Engastes amarelos |
| Diamante Bruto | T5 | 0.2% | Top tier |
| Cristal de Ametista | T3 | 0.6% | Encantamento mid |
| Pedra do Coracao | T6 | 0.05% | Mythic only |

[PLACEHOLDER: arvore de Jewelcrafting / lapidacao — fase posterior]

---

## 3. Woodcutting (Lenha) - 12 tipos de madeira

[PLACEHOLDER: sprite de spot de woodcutting por tier (arvore comum, arvore lustrosa, arvore antiga)]

| Material                | Tier  | Zona origem                        | XP/hit | Tempo base | Notas                         |
| ----------------------- | ----- | ---------------------------------- | ------ | ---------- | ----------------------------- |
| Tora de Pinheiro        | T1    | Floresta                           | 6      | 2.8s       | Inicial. Pranchas de Pinheiro |
| Tora de Carvalho Novo   | T1    | Floresta                           | 9      | 3.5s       | Comum mid-zona1               |
| Tora de Carvalho        | T1-T2 | Floresta tardia / Deserto Oasis    | 14     | 4.2s       | Padrao de cabos               |
| Tora de Bambu           | T2    | Deserto Oasis                      | 12     | 4.0s       | Vara de Bambu, decoracao      |
| Tora de Bordo           | T2-T3 | Deserto / Caverna                  | 22     | 5.0s       | Cabo de Bordo                 |
| Tora de Cedro Branco    | T3    | Caverna superficial / Pantano alto | 28     | 5.8s       | Pranchas de Cedro             |
| Tora de Salgueiro Negro | T4    | Pantano                            | 38     | 7.0s       | Encantamentos sombrios        |
| Tora de Ebano           | T4    | Pantano profundo                   | 50     | 8.5s       | Cabo premium (Epic+)          |
| Tora de Ironwood        | T5    | Tundra                             | 70     | 10s        | Estruturas militares          |
| Tora de Ebano Nobre     | T5    | Tundra (raro)                      | 85     | 11s        | Legendary craft               |
| Tora de Carvalho Antigo | T5-T6 | Templo Celestial                   | 100    | 13s        | Constelacao do Lenhador       |
| Tora de Madeira Estelar | T6    | Templo Celestial                   | 130    | 15s        | Mythic only                   |

Total: 12 madeiras.

---

## 4. Fishing (Pescaria) - 14 peixes

[PLACEHOLDER: sprite de spot de pesca por bioma (riacho, lago, mar, abismo)]

| Peixe            | Tier  | Zona aquatica                   | XP/hit | Tempo base | Notas                        |
| ---------------- | ----- | ------------------------------- | ------ | ---------- | ---------------------------- |
| Sardinha         | T1    | Floresta (riacho)               | 5      | 3.0s       | Inicial                      |
| Truta            | T1    | Floresta (riacho)               | 8      | 3.5s       | Receita basica               |
| Carpa Dourada    | T1    | Floresta (lago)                 | 12     | 4.0s       | Decoracao + comida           |
| Bagre            | T2    | Deserto (oasis)                 | 16     | 4.5s       | Carne pesada                 |
| Salmao           | T2    | Floresta tardia / Deserto Oasis | 22     | 5.0s       | Salmao ao Mel                |
| Atum             | T3    | Caverna (lago subterraneo)      | 30     | 6.0s       | Sushi                        |
| Tubarao Costeiro | T3-T4 | Pantano costeiro                | 45     | 8.0s       | Carne agressiva              |
| Lula Gigante     | T3-T4 | Pantano profundo                | 50     | 8.5s       | Drop tinta                   |
| Polvo Profundo   | T4    | Pantano (abismo)                | 65     | 10s        | 8 tentaculos = 8 cozinhas    |
| Tubarao Branco   | T4    | Pantano (mar profundo)          | 80     | 11s        | Sushi de Tubarao             |
| Bagre Glacial    | T5    | Tundra (lagos congelados)       | 90     | 11.5s      | Carne ardente paradoxalmente |
| Megalodon Jovem  | T5-T6 | Tundra (mar polar)              | 130    | 14s        | Mid-end                      |
| Kraken Jovem     | T6    | Templo Celestial (mar etereo)   | 170    | 16s        | Endgame                      |
| Peixe Estelar    | T6    | Templo Celestial (mar do ceu)   | 200    | 17s        | Endgame raro                 |

Total: 14 peixes.

---

## 5. Herbalism (Coleta de Ervas) - 12 ervas e flores

[PLACEHOLDER: sprite de spot de erva por tier (mato baixo, arbusto floral, flor radiante)]

| Erva | Tier | Zona origem | XP/hit | Tempo base | Notas |
|---|---|---|---|---|---|
| Folha Verde | T1 | Floresta | 4 | 2.5s | Pocao Menor de HP |
| Folha Encantada | T1-T2 | Floresta tardia / Deserto | 10 | 3.5s | Buff alquimico |
| Cogumelo Falante | T1 | Floresta (zonas sombreadas) | 8 | 3.0s | Sopa de Cogumelos |
| Polen Vermelho | T2 | Deserto | 12 | 3.8s | Pocao Media |
| Trigo | T2 | Deserto (oasis) | 7 | 3.0s | Farinha [fonte futura: Planting] |
| Cogumelo Putrido | T4 | Pantano | 22 | 5.5s | Pocao Maior MP |
| Folha Sagrada | T6 | Templo Celestial | 60 | 9s | Pocao Suprema |
| Flor de Cristal | T3 | Caverna | 25 | 5.5s | Po de Cristal indireto |
| Erva da Tundra | T5 | Tundra | 40 | 7.5s | Resist gelo |
| Lirio do Pantano | T4 | Pantano | 28 | 6.5s | Antidoto Maior |
| Flor de Magma | T3 | Caverna profunda | 30 | 6.5s | Resist fogo |
| Rosa Estelar | T6 | Templo Celestial (raro) | 80 | 11s | Mythic alquimia |

Total: 12 ervas.

---

## 6. Cooking (Skill de cozinha)

Cooking tem dois aspectos:
1. **Skill que processa ingredientes em refeicoes** — receitas em `crafting-catalog.md#estacao-cooking`.
2. **Skill que precisa de ingredientes vindos de outras skills** — listados aqui como referencia.

### 6.1 Ingredientes que Cooking precisa

| Ingrediente | Fonte | Notas |
|---|---|---|
| Carne Crua | Drops de Animal/Insect | Coelho, Lobo, Crocodilo, etc. (combate) |
| Carne de Lobo | Drop especifico Lobo | [ver: enemies-catalog.md#z1-lobo-faminto] |
| Carne de Crocodilo | Drop Pantano | [ver: enemies-catalog.md] |
| Carne de Dragao | Drop Boss Dragon | [ver: enemies-catalog.md] |
| Ovo Cru | [fonte futura: Livestock] | Curral; antes do Vilarejo, drop raro de Bird |
| Leite | [fonte futura: Livestock] | Curral; antes do Vilarejo, comprado em NPC com limite/dia |
| Manteiga | Cooking processa Leite | |
| Trigo | Herbalism (T2) ou [fonte futura: Planting] | |
| Farinha | Cooking processa Trigo | |
| Cenoura | [fonte futura: Planting] | Antes do Vilarejo, drop raro Coelho ou compra NPC |
| Cebola | [fonte futura: Planting] | Idem |
| Vegetais Picados | Cooking processa Cenoura+Cebola | |
| Mel Selvagem | Drop de Vespa Gigante | [ver: enemies-catalog.md#z1-vespa-gigante] |
| Sal | Comprado no Mercador Itinerante (limite/dia) | [DECISAO PENDENTE: vem tambem de Mining como sub-drop?] |
| File de Truta | Cooking processa Truta | Idem para qualquer peixe |
| Carne Assada | Cooking processa Carne Crua | |
| Carne Defumada | Cooking processa Carne Assada + Sal | |
| Massa Crua | Cooking processa Farinha + Ovo + Leite | |
| Agua Pura | Spot dedicado em Floresta (Mining-adjacente?) ou Fishing T1 | [DECISAO PENDENTE: definir fonte primaria de Agua Pura] |

### 6.2 Notas

- Antes de o Acampamento virar Vilarejo: ingredientes de Livestock/Planting sao **drops raros de combate** ou **comprados no Mercador Itinerante** com limite diario.
- Apos Vilarejo: Curral (Livestock) e Casa de Plantio (Planting) entram em operacao.
- [ver: roadmap-sistemas.md secao 3.16 — evolucao do Acampamento]

---

## 7. Fontes futuras (pos-MVP)

[DECISAO PENDENTE: Livestock, Planting/Gardening, Hunting, Archaeology entram em fase posterior. Esta secao apenas preview para garantir cross-reference.]

### 7.1 Livestock (Curral) — Vilarejo+

| Animal | Output | Tempo real |
|---|---|---|
| Galinha | Ovo Cru x1 | 4h real (timer) |
| Vaca | Leite x1 | 6h real |
| Ovelha | La x1 | 8h real |
| Carneiro | Carne Crua x1 | 12h real |
| Galinha Magica | Ovo de Pocao x1 | 24h real, raro |

### 7.2 Planting/Gardening (Casa de Plantio) — Vilarejo+

| Semente | Output | Tempo real |
|---|---|---|
| Semente de Cenoura | Cenoura x3 | 4h |
| Semente de Cebola | Cebola x3 | 4h |
| Semente de Trigo | Trigo x6 | 6h |
| Semente de Mandragora | Mandragora x1 | 24h, raro |
| Semente Estelar | Cogumelo Estelar x2 | 48h, mythic |

### 7.3 Hunting (Caca) — Cidade+

Skill que persegue animais especificos por timer real, retorna couros raros, ossos, peles.

| Caca | Output | Tempo real |
|---|---|---|
| Caca de Lobo | Pele de Lobo x2-5, Tendao de Lobo x1 | 2h |
| Caca de Urso | Pele de Urso x2-5, Garra de Urso x1 | 4h |
| Caca de Mamute | Marfim x3, Pelo Lanudo x5 | 8h |
| Caca de Drago | Escama x10, Coracao Brilhante x1 | 24h |

### 7.4 Archaeology (Arqueologia) — Reino+

Escavar sites em zonas para fragmentos. Montar pecas concede buffs permanentes pequenos.

| Site | Drops |
|---|---|
| Ruina Goblin | Fragmento Goblin x N (montar Esqueleto Goblin) |
| Tumba do Faraó | Fragmento de Faraó x N (montar Estatua) |
| Naufragio | Fragmento de Mastro x N (montar Barco Antigo) |
| Pico Astral | Fragmento Estelar x N (montar Constelacao Solar) |

[PLACEHOLDER: sistema completo de Archaeology — fase 5]

---

## 8. Mastery (curva por item)

| Mastery Lv | Speed bonus | Drop chance bonus | XP bonus | Drop duplo |
|---|---|---|---|---|
| 1-9 | 0% | 0% | 0% | 0% |
| 10-29 | +5% | +1% | +5% | 0% |
| 30-49 | +10% | +3% | +10% | +1% |
| 50-69 | +20% | +6% | +20% | +3% |
| 70-89 | +35% | +10% | +35% | +6% |
| 90-98 | +50% | +15% | +50% | +10% |
| 99 | +75% | +25% | +75% | +20% |

[ver: 02_math/progression-curves.md quando criada — formula final de Mastery]

---

## 9. Sistema de Eficiencia (estilo IdleOn MMO) — RESOLVIDO 2026-05-06 #15

> Mecanica oficial que substitui o conceito ingenuo de "afinidade de classe = +XP gain". A afinidade de classe agora se traduz em mais EFICIENCIA na skill afim, e EFICIENCIA determina se um node de gathering DROPA ou nao.

### 9.1 Conceito

Cada NODE de gathering (Spot) tem um valor `eficiencia_minima` por tier. Cada PERSONAGEM tem um valor `eficiencia[skill]` calculado dinamicamente. Comparacao:

- Se `personagem.eficiencia[skill] >= node.eficiencia_minima`: drop GARANTIDO (100%) a cada hit bem-sucedido.
- Se `personagem.eficiencia[skill] < node.eficiencia_minima`: chance de drop = `eficiencia / eficiencia_minima` (clamp 0..1). A animacao do swing/cast acontece normalmente, mas o `qty` fica em 0 nas vezes que falha. Mastery XP ainda conta (parcial), porque o personagem esta praticando.

Este e' o motivo pelo qual a "classe certa para a skill" importa: ela bate o threshold de tiers maiores mais cedo.

### 9.2 Eficiencia minima por tier do node (proposta)

| Tier do node | Zona origem | `eficiencia_minima` |
|---:|---|---:|
| T1 | Floresta | 10 |
| T2 | Deserto | 25 |
| T3 | Caverna | 50 |
| T4 | Pantano | 100 |
| T5 | Tundra | 200 |
| T6 | Templo Celestial | 400 |

`[a tunar em playtest]` — valores tunaveis sem refator.

### 9.3 Formula de Eficiencia do Personagem

```gdscript
func eficiencia(personagem: CharacterInstance, skill_id: String) -> int:
    var base: float = 0.0
    base += personagem.mastery.get(skill_id, 0) * 1.0           # 1 por nivel de Mastery
    base += personagem.level * 0.5                              # 0.5 por nivel do personagem
    base += class_affinity_bonus(personagem.character_class, skill_id)  # 0..50 (ver 9.4)
    base += tool_efficiency(personagem.equipped_tool[skill_id])  # 0..200 (ver 9.5)
    return int(base)
```

Ver tambem `02_math/progression-curves.md` secao "Eficiencia de Gathering" para o ponto unico de verdade da formula.

### 9.4 Bonus de classe afim

Classes com afinidade na skill ganham +20 a +50 de eficiencia base. Tabela inicial proposta:

| Classe | Skill afim | Bonus de eficiencia base |
|---|---|---:|
| Warrior | Mining | +30 |
| Mage | Alchemy | +30 |
| Ranger | Herbalism | +30 |
| Rogue | Hunting (futuro) / Mining alt | +20 |
| Cleric | Cooking | +30 |
| Berserker | Woodcutting | +30 |
| Necromancer | Alchemy (alt) | +20 |
| Monk | Cooking (alt) / Herbalism | +20 |
| Bard | Fishing | +30 |
| Summoner | Herbalism / Hunting | +20 |

Classe NAO afim: bonus = 0.

### 9.5 Bonus de ferramenta

Cada tier de ferramenta (Picareta T1-T6, Machado T1-T6, Vara T1-T6) adiciona eficiencia FLAT, na ordem da tabela em `equipment-catalog.md` secoes 4.10/4.11/4.12:

| Tier de ferramenta | Bonus de eficiencia FLAT |
|---:|---:|
| T1 (Common) | +5 |
| T2 (Uncommon) | +20 |
| T3 (Rare) | +50 |
| T4 (Epic) | +100 |
| T5 (Legendary) | +180 |
| T6 (Mythic) | +300 |

`[a tunar em playtest]` — escala em curva potencia de ~2.

### 9.6 Pseudo-codigo do drop

```gdscript
func roll_gathering_drop(personagem: CharacterInstance, node: GatheringNode) -> Dictionary:
    var efic = eficiencia(personagem, node.skill_id)
    var min_efic = node.eficiencia_minima
    var drop_chance: float = 1.0
    if efic < min_efic:
        drop_chance = clamp(float(efic) / float(min_efic), 0.0, 1.0)
    var dropped = randf() < drop_chance
    return {
        "animation": true,                                # sempre toca animacao
        "drop": dropped,
        "qty": (node.base_qty if dropped else 0),
        "mastery_xp": (node.mastery_xp_per_hit if dropped else int(node.mastery_xp_per_hit * 0.3)),
    }
```

### 9.7 Implicacoes de design

- **Falha visivel**: jogador ve o swing/cast, ouve o SFX, mas o "ploft" do drop nao acontece. Comunica o que esta faltando (mais Mastery, mais level, melhor ferramenta, ou trocar para classe afim).
- **Onboarding**: T1 tem `eficiencia_minima = 10`. Personagem Lv 1 sem ferramenta e sem mastery tem eficiencia ~0.5; com Picareta T1 Common (+5) chega ~5.5 = ~55% drop chance. Ja e jogavel desde o inicio.
- **Gating natural**: T6 exige 400 eficiencia, o que demanda ferramenta T6 + Mastery alta + classe afim + algum level. Mantem progressao.
- **Multi-personagem**: o jogador pode mandar Warrior pra Mining e Berserker pra Woodcutting, e cada um vai ser bom no seu fronte. Idle-friendly.

### 9.8 Cross-references

- Formula matematica unica de verdade: `02_math/progression-curves.md` secao "Eficiencia de Gathering".
- Bonus de Colecao para ferramentas (Picareta, Machado, Vara) usa `Mining/Woodcutting/Fishing Eficiencia` como stat fixo: ver `equipment-catalog.md` secao 5.1.
- Decisao original em `00_meta/pending-decisions.md` #15.

---

## Termos novos introduzidos neste arquivo

- "Spot" — ja no glossario, expandido com nota de tier visual.
- "Agua Pura" — material gathered, fonte ainda em decisao pendente.
- "[fonte futura: X]" — convencao para itens que dependem de skill nao-MVP.
- "Eficiencia" (gathering) — atributo dinamico do personagem por skill que determina se um node dropa.
- "eficiencia_minima" — campo do `GatheringNode.tres` com o threshold do node.
