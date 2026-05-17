# Equipment Catalog - Catalogo Completo de Equipamentos

> Catalogo exaustivo de itens equipaveis. Fonte primaria: `roadmap-sistemas.md` secoes 3.5, 3.6, 3.7, 3.8. Termos oficiais: ver `00_meta/glossary.md`.

---

## 0. Como o jogador equipa items (Fase B+)

Tela `Character` tem 5 paineis. Para equipar/desequipar, o jogador usa
**click-to-place** estilo Minecraft/Terraria:

1. Click em item no inventory -> pega (slot vazia, item gruda no cursor).
2. Click no slot de equipamento correspondente -> equipa.
   - Filtro: slot so aceita items do `item.slot_type` certo (helmet slot so
     aceita HELMET, weapon slot so aceita WEAPON, etc.).
3. Click num slot que ja tem item -> swap (item antigo vai pra mao).
4. ESC ou click no backdrop -> cancela, item volta pra origem.

Slots de artifacts (Fase 04+) NAO sao movidos pelo player — cada artifact
fica no seu slot fixo, populado por drops/quests/sistemas futuros. Pool
totalmente isolado de inventory/equipment.

Implementacao: `scenes/ui/drag/drag_manager.gd` (autoload).

---

## 1. Slots oficiais

Total: 10 slots de equipamento + 3 slots de ferramentas = 13 slots ativos.

| Slot | Categoria | Notas |
|---|---|---|
| Capacete | Armadura | Stats defensivos primarios + chance de status mental (resist Confused/Silence) |
| Peitoral | Armadura | Maior contribuicao a HP/Defesa |
| Calcas | Armadura | Defesa media + bonus de Atk Speed em alguns sets |
| Botas | Armadura | Defesa baixa + Movement / Dodge / Hit Chance |
| Colar | Acessorio | Stats magicos, MP, regen |
| Brincos | Acessorio | Crit Chance / Crit Damage / Magic Crit |
| Anel (slot 1) | Acessorio | Stats elementais + Lifesteal |
| Anel (slot 2) | Acessorio | Stats elementais + Lifesteal (configuracao independente) |
| Bracelete | Acessorio | Hit Chance / Atk Speed / Cast Speed |
| Arma | Arma principal | Define tipo de ataque (ver tabela 4) |
| Picareta | Ferramenta | Ataque 0. Boost em Mining + tier de mineracao acessivel. |
| Machado | Ferramenta | Ataque 0. Boost em Woodcutting + tier de arvore acessivel. |
| Vara de Pesca | Ferramenta | Ataque 0. Boost em Fishing + tier de zona aquatica acessivel. |

Slots visuais (transmog): Armadura completa + Arma + Asas (slot extra). Sem stats. [ver: planning/01_design/account-vs-character.md#cosmeticos]

---

## 2. Tiers / Raridades

6 tiers oficiais: Common, Uncommon, Rare, Epic, Legendary, Mythic. (RESOLVIDO 2026-05-06: confirmado em 6 tiers — long tail confirmado, ver `00_meta/pending-decisions.md` #12).

Toda tabela de raridade neste arquivo, em `02_math/drop-rates.md` e em `graphics-needs.md` lista exatamente esses 6 tiers nesta ordem.

| Tier | Cor de UI | Slots de gema | Slots de encantamento | Faixa de stats | Chance de drop base |
|---|---|---|---|---|---|
| Common | cinza | 0 | 1 | 1.0x | abundante |
| Uncommon | verde | 0 | 1 | 1.4x | comum |
| Rare | azul | 1 | 2 | 2.0x | incomum |
| Epic | roxo | 1 | 2 | 3.0x | raro |
| Legendary | laranja | 2 | 3 | 4.5x | raríssimo |
| Mythic | vermelho/dourado | 2 + slot fixo | 3 | 6.5x | endgame |

[PLACEHOLDER: paleta de cores final, gradientes e bordas para cada tier no UI]

### 2.1 Tabela de regras de encantamento por tier de equipamento

| Tier do equip | Quantos encantamentos suporta | Tier maximo de encantamento aplicavel | Nivel maximo de encantamento por slot |
|---|---|---|---|
| Common | 1 | mundane | III |
| Uncommon | 1 | refined | VI |
| Rare | 2 | refined | VI |
| Epic | 2 | unreal | IX |
| Legendary | 3 | unreal | IX |
| Mythic | 3 | eternal | X |

### 2.2 Regras de encantamento (tier do encantamento -> nivel cap)

| Tier de encantamento | Nivel cap | Como obter |
|---|---|---|
| mundane | III | drops comuns, primeiros NPCs encantadores |
| refined | VI | drops elite, achievements de mid-game |
| unreal | IX | drops boss + crafting tier 4+ |
| eternal | X | endgame, transcendido, evolucao de unreal + materiais raros |

[ver: planning/01_design/crafting-catalog.md#estacao-enchanting]

---

## 3. Tabela oficial de tipos de ataque por arma

| Familia de arma                   | Tipo(s) de ataque |
| --------------------------------- | ----------------- |
| Espadas                           | Slash             |
| Lancas, Rapieiras                 | Stab              |
| Clavas, Mocas                     | Crush             |
| Punhos, Luvas de Combate          | Blunt             |
| Machados de combate               | Lacerate          |
| Adagas                            | Slash + Stab      |
| Katanas                           | Slash + Lacerate  |
| Espadas Gigantes (Greatswords)    | Crush + Lacerate  |
| Arco e Flecha                     | Pierce            |
| Armas de Fogo (Bestas, Mosquetes) | Pierce + Lacerate |
| Tomos, Cajados, Varinhas          | Magic             |

[ver: 02_math/damage-formula.md#tipos-de-ataque-vs-resistencias]

---

## 4. Catalogo de exemplos por slot

Convencao por item: nome PT-BR | tier | tipo de ataque (se arma) | stats sugeridos (faixa) | encant max | gema | lore curta.

### 4.1 Capacete

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Capuz de Linho | DEF +3 a 6, HP +20 a 35 | mundane III | nao | Tecido grosseiro de aldeao virado batalha. |
| Common | Capacete de Couro Cru | DEF +5 a 8, HP +25 a 40, Resist Confused +2% | mundane III | nao | Couro de slime curtido na fogueira. |
| Common | Tiara de Aprendiz | DEF +2 a 4, MP +15 a 25, Cast Speed +1% | mundane III | nao | Primeira tiara dos noviços da Academia. |
| Uncommon | Elmo de Bronze | DEF +8 a 14, HP +50 a 75 | refined VI | nao | Forjado nos primeiros bronzes do Vilarejo. |
| Uncommon | Capacete de Caçador | DEF +6 a 10, HP +40 a 60, Hit Chance +2% | refined VI | nao | Pena de coruja ainda presa na lateral. |
| Uncommon | Coroa do Iniciado | DEF +5 a 9, MP +30 a 45, Magic Atk +2% | refined VI | nao | Argola encantada por feiticeiro em treino. |
| Rare | Elmo de Ferro Reforçado | DEF +18 a 28, HP +110 a 160, Resist Stun +5% | refined VI | 1 | Padrao da guarda do Reino. |
| Rare | Coif de Caçador Veterano | DEF +14 a 22, HP +90 a 130, Crit Chance +2% | refined VI | 1 | Cobre apenas o necessario. |
| Rare | Tiara de Cristal | DEF +10 a 16, MP +60 a 90, Magic Crit +3% | refined VI | 1 | Cristal de caverna engastado em prata. |
| Epic | Elmo do Comandante | DEF +35 a 55, HP +200 a 300, ATK +12 a 20 | unreal IX | 1 | Pertenceu ao primeiro general da Catedral. |
| Epic | Capuz das Sombras | DEF +25 a 40, HP +160 a 240, Dodge +6%, Crit Chance +5% | unreal IX | 1 | Tecido em silencio absoluto. |
| Epic | Diadema do Magus | DEF +20 a 32, MP +130 a 200, Cooldown Reduction +5% | unreal IX | 1 | Faisca azul flutua acima dele. |
| Legendary | Elmo do Dragao Escarlate | DEF +80 a 120, HP +500 a 720, Fire Damage +20%, Fire Resist +25% | unreal IX | 2 | [PLACEHOLDER: forjado da escama do boss da Caverna] |
| Mythic | Coroa do Imperador Eterno | [PLACEHOLDER: stats finais, ate Ascensao Cosmica] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore pos-transcendencia] |

### 4.2 Peitoral

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Camisa de Linho | DEF +5, HP +40 | mundane III | nao | Suja mas inteira. |
| Common | Peitoral de Couro Verde | DEF +8, HP +60 | mundane III | nao | Cor estranha mas funcional. |
| Common | Tunica de Aprendiz | DEF +4, HP +35, MP +20 | mundane III | nao | Cinto azul dos novicos. |
| Uncommon | Peitoral de Bronze | DEF +14, HP +90 | refined VI | nao | Da pra rolar e nao quebra. |
| Uncommon | Couraca de Couro Endurecido | DEF +12, HP +80, Atk Speed +2% | refined VI | nao | Cura no oleo de pinheiro. |
| Uncommon | Manto do Iniciado | DEF +9, HP +60, MP +40 | refined VI | nao | Borda azul costurada em fio prateado. |
| Rare | Peitoral de Ferro Lapidado | DEF +30, HP +180, Resist Bleeding +5% | refined VI | 1 | Sem brechas visiveis. |
| Rare | Couraca do Caçador Real | DEF +24, HP +140, Crit Damage +5% | refined VI | 1 | Marca real entre as costelas. |
| Rare | Vestes do Conjurador | DEF +18, HP +110, MP +90, Cooldown Reduction +3% | refined VI | 1 | Bordas brilham na escuridao. |
| Epic | Peitoral do Cavaleiro Sagrado | DEF +60, HP +330, Health Regen +3/s | unreal IX | 1 | Bencao da Catedral gravada por dentro. |
| Epic | Couraca do Bersek | DEF +40, HP +260, ATK +25, Lifesteal +3% | unreal IX | 1 | Mancha vermelha que nao sai. |
| Epic | Manto do Arcano Mestre | DEF +35, HP +200, MP +180, Magic Atk +20% | unreal IX | 1 | Voa de leve quando ele anda. |
| Legendary | Couraca do Comandante Eterno | DEF +130, HP +700, Status Resist (todos) +10%, Aura: aliados +15% DEF | unreal IX | 2 | [PLACEHOLDER: peca chave da Fortaleza do Imperio] |
| Mythic | Peitoral do Cosmos | [PLACEHOLDER: peca de Constelacao] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore — feita por O Transcendido] |

### 4.3 Calcas

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Calcas de Tecido | DEF +3, HP +25 | mundane III | nao | Confortaveis demais para combate. |
| Common | Bermuda de Couro | DEF +5, HP +35, Atk Speed +1% | mundane III | nao | Curtas, deixa correr. |
| Common | Saia da Aprendiz | DEF +3, HP +20, MP +15 | mundane III | nao | Discreta. |
| Uncommon | Calcas de Bronze | DEF +9, HP +55 | refined VI | nao | Pesadas mas duradouras. |
| Uncommon | Polainas de Couro Reforçado | DEF +8, HP +50, Atk Speed +2% | refined VI | nao | Apertadas no joelho. |
| Uncommon | Calcas do Iniciado | DEF +6, HP +40, MP +30 | refined VI | nao | Bordas marinhas. |
| Rare | Polainas de Ferro | DEF +20, HP +110, Resist Slowed +5% | refined VI | 1 | Marca de pe pesado no chao. |
| Rare | Calcas Caçadoras | DEF +16, HP +90, Atk Speed +4%, Hit Chance +2% | refined VI | 1 | Bolso para faca extra. |
| Rare | Calcas de Cristal Tecido | DEF +12, HP +75, MP +60, Cast Speed +3% | refined VI | 1 | Costura azul brilha quando se canalizam magias. |
| Epic | Polainas do Cavaleiro Sagrado | DEF +40, HP +200, Resist Curse +8% | unreal IX | 1 | Sigilos de prata. |
| Epic | Saia da Bersek | DEF +28, HP +160, ATK +15, Lifesteal +2% | unreal IX | 1 | Cheira a cinza. |
| Epic | Calcas do Arcano Mestre | DEF +24, HP +130, MP +130, Cooldown Reduction +4% | unreal IX | 1 | Costuradas com fio dimensional. |
| Legendary | Calcas do Avatar do Vento | DEF +85, HP +400, Atk Speed +12%, Dodge +10% | unreal IX | 2 | [PLACEHOLDER: drop da Tundra] |
| Mythic | Polainas do Imperador Eterno | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.4 Botas

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Sandalias de Tecido | DEF +1, Dodge +1% | mundane III | nao | Dois pares custam um cobre. |
| Common | Botas de Couro | DEF +3, HP +15, Hit Chance +1% | mundane III | nao | Cheiram a curtume. |
| Common | Soquetes do Aprendiz | DEF +1, MP +10, Cast Speed +1% | mundane III | nao | Mal aquecem. |
| Uncommon | Botas de Bronze | DEF +6, HP +30, Hit Chance +2% | refined VI | nao | Solado de placas. |
| Uncommon | Botas Caçadoras | DEF +5, HP +25, Atk Speed +2%, Dodge +3% | refined VI | nao | Solado de borracha primitiva. |
| Uncommon | Botas Tecidas em Prata | DEF +4, MP +30, Cast Speed +2% | refined VI | nao | Sussurram em altares. |
| Rare | Botas de Ferro Espinhadas | DEF +14, HP +70, Thorns +3% | refined VI | 1 | Para chutar inimigos no chao. |
| Rare | Mocassins do Caçador | DEF +10, HP +55, Atk Speed +4%, Dodge +5%, Hit Chance +3% | refined VI | 1 | Sem som ao caminhar. |
| Rare | Sapatilhas Arcanas | DEF +8, MP +60, Cooldown Reduction +3% | refined VI | 1 | Faiscas de magia presas no calcanhar. |
| Epic | Botas do Cavaleiro Sagrado | DEF +28, HP +140, Block Chance +5% | unreal IX | 1 | Bater no chao acalma aliados. |
| Epic | Botas da Bersek | DEF +20, HP +110, Atk Speed +8%, Lifesteal +2% | unreal IX | 1 | Pegada queimada no chao. |
| Epic | Botas do Arcano Mestre | DEF +18, MP +120, Cast Speed +8% | unreal IX | 1 | Flutuam um centimetro. |
| Legendary | Botas do Andarilho Cosmico | DEF +60, HP +280, Dodge +18%, Movement de patrulha em acampamento +20% | unreal IX | 2 | [PLACEHOLDER: drop da Constelacao do Andarilho] |
| Mythic | Botas do Vazio | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.5 Colar

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Pingente de Coral | HP +15, Water Resist +3% | mundane III | nao | Sai da praia da Floresta. |
| Common | Amuleto de Cobre | HP +10, MP +10 | mundane III | nao | Sorte basica. |
| Common | Colar de Dentes | ATK +1, Crit Chance +1% | mundane III | nao | Dentes de slime variados. |
| Uncommon | Pingente de Esmeralda | MP +30, Magic Atk +3% | refined VI | nao | Verde profundo do Vilarejo. |
| Uncommon | Talisma de Ferro | HP +30, DEF +5 | refined VI | nao | Pesado no peito. |
| Uncommon | Pendente do Caçador | ATK +3, Crit Chance +2%, Hit Chance +2% | refined VI | nao | Encantado pelo Caçador. |
| Rare | Colar do Olho Vigilante | MP +60, Magic Crit +4%, Hit Chance +3% | refined VI | 1 | Olho ambar pulsa. |
| Rare | Cordao do Druida | HP +50, Health Regen +2/s, Mana Regen +2/s | refined VI | 1 | Folha viva no centro. |
| Rare | Bracadeira da Caçada | ATK +8, Crit Damage +8% | refined VI | 1 | Marcas de presa. |
| Epic | Colar do Cavaleiro Sagrado | HP +120, DEF +20, Aura: aliados +5% Health Regen | unreal IX | 1 | Cruz de prata pulsando. |
| Epic | Pingente do Arcano | MP +120, Magic Atk +15%, Cooldown Reduction +4% | unreal IX | 1 | Estrela girando dentro do cristal. |
| Epic | Talisma de Sangue | ATK +20, Lifesteal +6%, Crit Damage +12% | unreal IX | 1 | Goteja sem ferida. |
| Legendary | Colar do Espirito da Tundra | HP +250, Ice Damage +25%, Ice Resist +30% | unreal IX | 2 | [PLACEHOLDER: drop boss Tundra] |
| Mythic | Colar do Vazio Estelar | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.6 Brincos

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Argolas de Cobre | Crit Chance +1%, MP +5 | mundane III | nao | Compradas no mercado. |
| Common | Brincos de Madeira | HP +8, Hit Chance +1% | mundane III | nao | Lavrados a mao. |
| Common | Pingo de Vidro | Magic Crit +1%, MP +10 | mundane III | nao | Translucidos. |
| Uncommon | Argolas de Prata | Crit Chance +3%, Crit Damage +4% | refined VI | nao | Tilintam. |
| Uncommon | Brincos do Caçador | Hit Chance +4%, Atk Speed +2% | refined VI | nao | Penas de raptor. |
| Uncommon | Pingos de Cristal | Magic Crit +3%, MP +20 | refined VI | nao | Cantantes em luas cheias. |
| Rare | Brincos de Ouro | Crit Chance +5%, Crit Damage +8% | refined VI | 1 | Real e pesados. |
| Rare | Brincos da Selva | Hit Chance +6%, Dodge +3% | refined VI | 1 | Caco de presa de besta. |
| Rare | Brincos da Maga | Magic Crit +5%, Cast Speed +4% | refined VI | 1 | Brilham com proximidade magica. |
| Epic | Brincos do Caos | Crit Chance +8%, Crit Damage +20% | unreal IX | 1 | Pulsam em vermelho ao matar. |
| Epic | Brincos da Lua Crescente | Magic Crit +10%, Cooldown Reduction +5% | unreal IX | 1 | Mudam de cor com a lua. |
| Epic | Brincos da Faminta | ATK +12, Lifesteal +4% | unreal IX | 1 | Sussurram pedindo mais. |
| Legendary | Brincos do Cosmos Refletido | Crit Chance +14%, Magic Crit +14%, Crit Damage +30% | unreal IX | 2 | [PLACEHOLDER: drop Templo Celestial] |
| Mythic | Brincos das Estrelas Mortas | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.7 Anel (slot 1 e slot 2 — mesma lista)

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Anel de Ferro | ATK +1, HP +10 | mundane III | nao | Padrao do recruta. |
| Common | Anel de Cobre | MP +10, Cast Speed +1% | mundane III | nao | Reciclavel. |
| Common | Anel de Couro | DEF +2, Hit Chance +1% | mundane III | nao | Tira fina costurada. |
| Uncommon | Anel da Brisa | Wind Damage +5%, Atk Speed +2% | refined VI | nao | Alivia o calor. |
| Uncommon | Anel de Brasa | Fire Damage +5%, ATK +3 | refined VI | nao | Quente ao toque. |
| Uncommon | Anel da Marola | Water Damage +5%, MP +20 | refined VI | nao | Goteja em luaroas. |
| Rare | Anel da Brasa Profunda | Fire Damage +10%, Fire Resist +8%, ATK +6 | refined VI | 1 | Selo de Fenix. |
| Rare | Anel da Geleira | Ice Damage +10%, Ice Resist +8%, MP +40 | refined VI | 1 | Frio mesmo no deserto. |
| Rare | Anel da Tempestade | Electric Damage +10%, Atk Speed +5% | refined VI | 1 | Trinca o ar. |
| Epic | Anel do Inferno | Fire Damage +20%, Burning Chance +8%, ATK +18 | unreal IX | 1 | Fumaça constante. |
| Epic | Anel da Vida Eterna | Health Regen +5/s, HP +180, Lifesteal +4% | unreal IX | 1 | Pulsa como coracao. |
| Epic | Anel do Pensamento | Cooldown Reduction +8%, Cast Speed +10%, MP +120 | unreal IX | 1 | Cristal flutua dentro do aro. |
| Legendary | Anel do Senhor Elemental | Todos os elementos +12%, Resist (todos) +12% | unreal IX | 2 | [PLACEHOLDER: forjado em altar de quatro elementos] |
| Mythic | Anel da Singularidade | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.8 Bracelete

| Tier | Nome | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|
| Common | Bracelete de Linho | Hit Chance +1%, MP +5 | mundane III | nao | Reforco de pulso. |
| Common | Bracadeira de Couro | ATK +1, Atk Speed +1% | mundane III | nao | Costurada com tendao. |
| Common | Faixa do Aprendiz | Cast Speed +1%, MP +10 | mundane III | nao | Marca a camara. |
| Uncommon | Bracelete de Bronze | Hit Chance +3%, ATK +3 | refined VI | nao | Boa empunhadura. |
| Uncommon | Bracadeira de Couro Reforcada | Atk Speed +4%, Crit Chance +2% | refined VI | nao | Encaixe duro. |
| Uncommon | Faixa Encantada | Cast Speed +3%, MP +25 | refined VI | nao | Brilha quando MP se esgota. |
| Rare | Bracelete de Aco | Hit Chance +5%, ATK +6, Atk Speed +3% | refined VI | 1 | Padrao de unidades de elite. |
| Rare | Punheira da Caçadora | Atk Speed +6%, Crit Chance +4% | refined VI | 1 | Marcas de mordida. |
| Rare | Faixa do Magus | Cast Speed +6%, Cooldown Reduction +3%, MP +60 | refined VI | 1 | Costuras runicas. |
| Epic | Bracelete do Combatente | ATK +18, Hit Chance +8%, Atk Speed +6% | unreal IX | 1 | Sempre quente. |
| Epic | Punheira do Caos | Crit Chance +8%, Crit Damage +18%, Lifesteal +3% | unreal IX | 1 | Veias rubras. |
| Epic | Faixa do Tempo | Cast Speed +12%, Cooldown Reduction +8% | unreal IX | 1 | Tic-tac suave. |
| Legendary | Bracelete do Espirito Tribal | ATK +35, Atk Speed +15%, dano vs Beast +20% | unreal IX | 2 | [PLACEHOLDER: drop chefe da Floresta] |
| Mythic | Bracelete do Senhor das Eras | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.9 Arma (1 slot)

Listagem agrupada por familia. Tipo de ataque vem da tabela 3.

| Tier | Nome | Familia | Tipo | Stats sugeridos | Encant max | Gema | Lore |
|---|---|---|---|---|---|---|---|
| Common | Espada de Treino | Espada | Slash | ATK +6, Hit +2% | mundane III | nao | A mesma do tutorial. |
| Common | Lanca de Madeira | Lanca | Stab | ATK +5, Pierce +5%, Hit +3% | mundane III | nao | Ponta carbonizada. |
| Common | Tomo do Aprendiz | Tomo | Magic | Magic ATK +5, MP +20 | mundane III | nao | Capa amassada. |
| Uncommon | Espada Curta de Bronze | Espada | Slash | ATK +12, Crit +2% | refined VI | nao | Brilha como cobre. |
| Uncommon | Adaga Furtiva | Adaga | Slash + Stab | ATK +10, Crit +6%, Atk Speed +5% | refined VI | nao | Cabo emborrachado. |
| Uncommon | Cajado de Carvalho | Cajado | Magic | Magic ATK +12, Cast Speed +4% | refined VI | nao | Topo torto. |
| Rare | Espada Larga de Ferro | Espada | Slash | ATK +25, Crit +4%, Bleeding chance +5% | refined VI | 1 | Ranhura no centro para sangrar. |
| Rare | Arco Composto | Arco | Pierce | ATK +22, Hit +8%, Crit Damage +10% | refined VI | 1 | Tendao tencionado. |
| Rare | Clava de Granito | Clava | Crush | ATK +30, Stun Chance +6% | refined VI | 1 | Quebra placa. |
| Rare | Katana do Estudante | Katana | Slash + Lacerate | ATK +24, Atk Speed +6%, Lacerate stack +5% | refined VI | 1 | Bainha laqueada. |
| Rare | Tomo das Frias Estrelas | Tomo | Magic | Magic ATK +28, Cooldown Reduction +4%, Ice Damage +10% | refined VI | 1 | Capa azul gelada. |
| Epic | Greatsword do Comandante | Espada Gigante | Crush + Lacerate | ATK +60, Lacerate stack +8%, Atk Speed -5% | unreal IX | 1 | Pesa para baixar braco. |
| Epic | Adagas Gemeas Sussurrantes | Adaga (par) | Slash + Stab | ATK +45, Crit +12%, Atk Speed +12% | unreal IX | 1 | Conversam em sonho. |
| Epic | Arco do Caçador Real | Arco | Pierce | ATK +50, Hit +15%, Crit Damage +25% | unreal IX | 1 | Marca real entalhada. |
| Epic | Cajado do Magma | Cajado | Magic | Magic ATK +55, Fire Damage +25%, Burning Chance +10% | unreal IX | 1 | Fumega ao canalizar. |
| Epic | Mosquete de Polvora Escura | Arma de Fogo | Pierce + Lacerate | ATK +50, Crit Damage +20%, Bleed chance +6% | unreal IX | 1 | Fumaça preta caracteristica. |
| Legendary | Espada do Avatar do Sol | Espada | Slash | ATK +130, Fire Damage +35%, Crit +15%, dano vs Undead +30% | unreal IX | 2 | [PLACEHOLDER: drop Templo Celestial] |
| Mythic | Lamina do Vazio | Greatsword | Crush + Lacerate | [PLACEHOLDER: stats finais pos-Ascensao] | eternal X | 2 + slot fixo | [PLACEHOLDER: forjada na Forja Cosmica] |

### 4.10 Picareta (ferramenta)

| Tier | Nome | Tier de minerio acessivel | Stats / Boost | Encant max | Gema | Lore |
|---|---|---|---|---|---|---|
| Common | Picareta de Bronze | T1 (Cobre, Estanho, Pedra) | Mining Speed +5%, Mining XP +5% | mundane III | nao | Comum em todos os Vilarejos. |
| Common | Picareta de Pedra | T1 | Mining Speed +3%, drop chance +1% | mundane III | nao | Lasca facil. |
| Common | Picareta Reforçada | T1 | Mining XP +8% | mundane III | nao | Dura mais que parece. |
| Uncommon | Picareta de Ferro | T2 (Ferro, Carvao) | Mining Speed +12%, Mining XP +12% | refined VI | nao | Pega bem na pedra. |
| Uncommon | Picareta de Aco | T2 | Mining Speed +15%, drop dupli +2% | refined VI | nao | Soa metalica. |
| Uncommon | Picareta do Mineiro | T2 | Mining XP +18%, Mastery +5% | refined VI | nao | Iniciais "JM" gravadas. |
| Rare | Picareta de Mithril | T3 (Prata, Ouro, Mithril) | Mining Speed +25%, drop dupli +5% | refined VI | 1 | Leve para o tamanho. |
| Rare | Picareta do Arquimineiro | T3 | Mining Speed +20%, Mastery +10%, gem chance +3% | refined VI | 1 | Da Universidade de Mineracao. |
| Rare | Picareta da Caverna | T3 | Mining XP +25%, drop chance +6% | refined VI | 1 | Encantada por Goblin. |
| Epic | Picareta de Adamantita | T4 (Adamantita, Cristal Bruto) | Mining Speed +40%, drop dupli +8%, gem chance +6% | unreal IX | 1 | Sangra fagulha azul. |
| Epic | Picareta do Anão Lendario | T4 | Mining Speed +35%, Mastery +15%, drop triplo +3% | unreal IX | 1 | Empunhadura grande demais para humanos. |
| Epic | Picareta Espelhada | T4 | Mining XP +50%, gem chance +10% | unreal IX | 1 | Reflete escuridao. |
| Legendary | Picareta do Coracao da Montanha | T5 (Orichalcum, Esmeralda Bruta) | Mining Speed +75%, drop dupli +15%, gem chance +20% | unreal IX | 2 | [PLACEHOLDER: forjada de Golem do Pantano] |
| Mythic | Picareta do Cosmo Subterraneo | T6 (todos) | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.11 Machado (ferramenta)

| Tier | Nome | Tier de arvore acessivel | Stats / Boost | Encant max | Gema | Lore |
|---|---|---|---|---|---|---|
| Common | Machado de Lenhador | T1 (Pinheiro, Carvalho Novo) | Wood Speed +5%, Wood XP +5% | mundane III | nao | Padrao de aldeao. |
| Common | Machado de Pedra | T1 | Wood Speed +3% | mundane III | nao | Cabo torcido. |
| Common | Machadinha | T1 | Wood XP +8% | mundane III | nao | Pequena, leve, eficaz. |
| Uncommon | Machado de Ferro | T2 (Carvalho, Bordo) | Wood Speed +12%, Wood XP +12% | refined VI | nao | Cabo de carvalho. |
| Uncommon | Machado Encerado | T2 | Wood Speed +15%, drop dupli +2% | refined VI | nao | Brilha apos o uso. |
| Uncommon | Machado do Carpinteiro | T2 | Wood XP +18%, Mastery +5% | refined VI | nao | Marca da guilda. |
| Rare | Machado de Mithril | T3 (Ebano, Cedro Branco) | Wood Speed +25%, drop dupli +5% | refined VI | 1 | Lamina nunca gasta. |
| Rare | Machado do Lenhador Mestre | T3 | Wood Speed +20%, Mastery +10%, log raro chance +3% | refined VI | 1 | Veterano de mil arvores. |
| Rare | Machado das Folhas Cantantes | T3 | Wood XP +25%, drop chance +6% | refined VI | 1 | Sussurra ao cortar. |
| Epic | Machado de Adamantita | T4 (Ironwood, Salgueiro Negro) | Wood Speed +40%, drop dupli +8%, log raro chance +6% | unreal IX | 1 | Resiste a magia da floresta. |
| Epic | Machado do Berserker da Madeira | T4 | Wood Speed +35%, Mastery +15%, drop triplo +3% | unreal IX | 1 | Fica vermelha quando excitada. |
| Epic | Machado do Vento Cortante | T4 | Wood XP +50%, Wood Speed +30% | unreal IX | 1 | Corta o ar antes da arvore. |
| Legendary | Machado da Arvore Ancestral | T5 (Ebano Nobre, Carvalho Antigo) | Wood Speed +75%, drop dupli +15%, log raro chance +20% | unreal IX | 2 | [PLACEHOLDER: forjada com galho do Coracao da Floresta] |
| Mythic | Machado da Constelacao do Lenhador | T6 | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

### 4.12 Vara de Pesca (ferramenta)

| Tier | Nome | Tier de pescaria acessivel | Stats / Boost | Encant max | Gema | Lore |
|---|---|---|---|---|---|---|
| Common | Vara de Galho | T1 (Truta, Sardinha) | Fishing Speed +5%, Fishing XP +5% | mundane III | nao | Galho com linha. |
| Common | Vara Simples | T1 | Fishing Speed +3% | mundane III | nao | Comprada na taverna. |
| Common | Vara Encerada | T1 | Fishing XP +8% | mundane III | nao | Cera contra agua doce. |
| Uncommon | Vara de Bambu | T2 (Salmao, Bagre) | Fishing Speed +12%, Fishing XP +12% | refined VI | nao | Importada do Deserto. |
| Uncommon | Vara Trançada | T2 | Fishing Speed +15%, drop dupli +2% | refined VI | nao | Linha em fibra dura. |
| Uncommon | Vara do Pescador | T2 | Fishing XP +18%, Mastery +5% | refined VI | nao | Cinco anos de uso. |
| Rare | Vara de Mithril | T3 (Tubarao Costeiro, Lula Gigante) | Fishing Speed +25%, drop dupli +5% | refined VI | 1 | Dobra mas nao quebra. |
| Rare | Vara do Pescador Real | T3 | Fishing Speed +20%, Mastery +10%, peixe raro chance +3% | refined VI | 1 | Selo real entalhado. |
| Rare | Vara das Mares | T3 | Fishing XP +25%, drop chance +6% | refined VI | 1 | Vibra quando a mare muda. |
| Epic | Vara de Adamantita | T4 (Tubarao Branco, Polvo Profundo) | Fishing Speed +40%, drop dupli +8%, peixe raro chance +6% | unreal IX | 1 | Linha de filamento abismal. |
| Epic | Vara do Mestre dos Mares | T4 | Fishing Speed +35%, Mastery +15%, drop triplo +3% | unreal IX | 1 | Atrai peixes sem isca. |
| Epic | Vara da Lua das Mares | T4 | Fishing XP +50%, peixe raro chance +10% | unreal IX | 1 | Brilha em luas cheias. |
| Legendary | Vara do Pescador do Abismo | T5 (Megalodon, Kraken jovem) | Fishing Speed +75%, drop dupli +15%, peixe raro chance +20% | unreal IX | 2 | [PLACEHOLDER: drop boss aquatico Pantano] |
| Mythic | Vara da Constelacao do Pescador | T6 | [PLACEHOLDER: stats finais] | eternal X | 2 + slot fixo | [PLACEHOLDER: lore] |

---

## 5. Coleção de Equipamentos (Codex de Power)

[ver: roadmap-sistemas.md secao 3.33]

Cada item registrado uma vez na conta da bonus permanente. Bonus aplica em TODOS os personagens. (RESOLVIDO 2026-05-06: STAT FIXO por TIPO+TIER. Cada combinacao slot+tier tem um stat e um valor pre-determinado, sem aleatoriedade. Espada Common = +1 ATK fixo. Sempre. Ver `00_meta/pending-decisions.md` #23.)

### 5.1 Tabela de Bonus por TIPO+TIER (oficial)

Valores ESCALONADOS por tier (1 / 2 / 5 / 12 / 30 / 80 = curva exponencial leve, com Mythic ~80x Common).

| Slot / Familia | Stat fixo | Common | Uncommon | Rare | Epic | Legendary | Mythic |
|---|---|---:|---:|---:|---:|---:|---:|
| Arma — Espada / Adaga / Katana / Greatsword | ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Arma — Lanca / Rapieira | ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Arma — Clava / Moca | ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Arma — Punhos / Luvas | ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Arma — Machado | ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Arma — Arco / Arma de Fogo | ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Arma — Tomo / Cajado / Varinha | Magic ATK | +1 | +2 | +5 | +12 | +30 | +80 |
| Capacete | DEF | +1 | +2 | +4 | +9 | +22 | +60 |
| Peitoral | HP | +5 | +10 | +25 | +60 | +150 | +400 |
| Calcas | HP | +3 | +6 | +15 | +35 | +90 | +240 |
| Botas | Dodge % | +0.1 | +0.2 | +0.5 | +1.2 | +3.0 | +8.0 |
| Colar | MP | +3 | +6 | +15 | +35 | +90 | +240 |
| Brincos | Crit Chance % | +0.1 | +0.2 | +0.5 | +1.2 | +3.0 | +8.0 |
| Anel | Hit Chance % | +0.1 | +0.2 | +0.5 | +1.2 | +3.0 | +8.0 |
| Bracelete | Atk Speed % | +0.1 | +0.2 | +0.5 | +1.2 | +3.0 | +8.0 |
| Picareta | Mining Eficiencia | +1 | +2 | +5 | +12 | +30 | +80 |
| Machado (ferramenta) | Woodcutting Eficiencia | +1 | +2 | +5 | +12 | +30 | +80 |
| Vara de Pesca | Fishing Eficiencia | +1 | +2 | +5 | +12 | +30 | +80 |

### 5.2 Regras

- Stat e valor sao FIXOS por (slot, tier). Nao varia entre dois "Capacete Rare" diferentes — registrar qualquer Capacete Rare da +4 DEF.
- Bonus aplica em TODOS os personagens da conta (e' bonus de codex, nao de equip).
- Registrar o mesmo item-id mais de uma vez NAO empilha. Cada item-id conta UMA vez.
- Tier de um item-id e fixo no `.tres`. Se o mesmo nome aparece em dois tiers (ex: "Espada de Ferro" Common e Rare), sao item-ids diferentes e cada um da seu bonus.
- Visual no personagem: so a ARMA equipada altera o sprite (RESOLVIDO 2026-05-06 #3). Os outros slots aparecem APENAS no portrait/menu/inventario, nao no sprite de combate.

### 5.3 Tunavel

Os valores acima sao ponto de partida. Marcar `[a tunar em playtest]` se a soma de bonus de Colecao virar dominante na build vs equip ativo.

---

## 6. Encantamentos disponiveis

Lista detalhada em `crafting-catalog.md#estacao-enchanting`. Resumo:

- 20+ encantamentos divididos em mundane / refined / unreal / eternal.
- Encantamentos sao especificos por categoria de equipamento (arma, armadura, acessorio).
- Niveis I-X em algoritimos romanos.

---

## Termos novos introduzidos neste arquivo

- "Slot fixo" (em Mythic) — slot de gema adicional travado para gema de tier mythic.
- "Bonus de Colecao" — refere-se ao stat permanente da Colecao.
- "Tier de minerio/arvore/pescaria acessivel" — limite de tier que a ferramenta consegue colher.
