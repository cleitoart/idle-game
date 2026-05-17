# Classes and Characters - 10 Classes + Awakening Trees

> 10 classes oficiais + arvores de Awakening (estrelas 1, 3, 5, 7, 9, 10 com escolha de ramo). Fonte: `roadmap-sistemas.md` secao 3.10, 3.19. Termos: ver `00_meta/glossary.md`.

> **NOTA IMPORTANTE (RESOLVIDO 2026-05-06 #13): Stats elementais NAO TEM AFINIDADE BASE POR CLASSE.** Nenhuma classe comeca com bonus de Fire/Ice/Water/Wind/Rock/Electric/Light/Dark. Mage NAO ganha +Fire por padrao, Ranger NAO ganha +Wind, etc. Todos os elementos comecam ZERADOS no `CombatStats.from_character()`. Afinidade elemental emerge da ESCOLHA DE BUILD via equipamento, skills aprendidas e encantamentos. Ver `00_meta/pending-decisions.md` #13 e `02_math/damage-formula.md`.

---

## 1. Convencoes

- **Roster inicial:** 1 personagem (Warrior). Maximo inicial 10 personagens.
- **Aquisicao** de novo personagem: a cada 50 niveis somados entre todos os personagens, libera novo slot recrutavel (gratis na Taverna). Tambem via achievements e eventos.
- **Stats base** sao em Lv 1, sem equipamento.
- **Afinidade gathering** = qual skill recebe +25% XP gain inato pra essa classe.
- **Awakening:** apos primeiro Renascimento (Lv 100). Ganha estrelas (max 10).
  - 1 estrela: nao tem escolha, e uma melhoria das skills atuais
  - 3 estrelas: escolha de ramo (2 opcoes mutualmente exclusivas)
  - 5 estrelas: escolha de ramo (2 opcoes mutualmente exclusivas, vinculadas a escolha de 3)
  - 7 estrelas: 1 no fixo, upgrade da escolha feita em 5
  - 9 estrelas: 1 no fixo, upgrade adicional da escolha feita em 5
  - 10 estrelas: 1 no fixo, skill assinatura final do ramo escolhido
- Escolhas em 3 e em 5 sao independentes em texto, mas em 5 estao **vinculadas** a escolha de 3 (ver matriz por classe).

---

## 2. As 10 classes

| # | Classe | Role | Afinidade gathering | Stats base Lv1 |
|---|---|---|---|---|
| 1 | Warrior (Guerreiro) | DPS / Tank hibrido | Mining | HP 120, MP 20, ATK 14, DEF 8, STR 10, DEX 5, INT 3, VIT 8, LUK 4 |
| 2 | Mage (Mago) | DPS magico | Alchemy | HP 70, MP 100, Magic ATK 18, DEF 3, STR 3, DEX 4, INT 12, VIT 4, LUK 5 |
| 3 | Ranger | DPS ranged / Hibrido | Herbalism | HP 90, MP 50, ATK 12, DEF 5, STR 6, DEX 12, INT 5, VIT 5, LUK 8 |
| 4 | Rogue (Ladino) | DPS critico | Hunting (futuro) / Mining alt | HP 80, MP 40, ATK 16, DEF 4, STR 7, DEX 11, INT 4, VIT 4, LUK 10 |
| 5 | Cleric (Clerigo) | Healer / Support | Cooking | HP 100, MP 80, ATK 8, DEF 6, STR 5, DEX 5, INT 9, VIT 8, LUK 5 |
| 6 | Berserker | DPS bruto / Risco | Woodcutting | HP 140, MP 10, ATK 22, DEF 4, STR 14, DEX 4, INT 2, VIT 6, LUK 4 |
| 7 | Necromancer | DPS DoT / Summoner | Alchemy (alt) | HP 75, MP 90, Magic ATK 16, DEF 4, STR 3, DEX 4, INT 11, VIT 5, LUK 6 |
| 8 | Monk (Monge) | DPS / Tank hibrido | Cooking (alt) / Herbalism | HP 110, MP 60, ATK 14, DEF 6, STR 9, DEX 9, INT 5, VIT 7, LUK 5 |
| 9 | Bard (Bardo) | Support / Buffer | Fishing | HP 85, MP 70, ATK 10, DEF 4, STR 4, DEX 9, INT 8, VIT 5, LUK 9 |
| 10 | Summoner (Conjurador) | Summon-DPS / Pet master | Herbalism / Hunting | HP 80, MP 95, Magic ATK 14, DEF 4, STR 3, DEX 6, INT 10, VIT 5, LUK 7 |

[PLACEHOLDER: sprites Lv1 de cada classe + 4 retratos por classe (uma para cada combinacao de ramo 3+5)]

---

## 3. Awakening Trees por classe

Cada arvore tem o formato:
- **★1** (no fixo, melhora skills do kit base)
- **★3** (escolha A vs B)
- **★5** (escolha vinculada a 3: A->A1/A2 ou B->B1/B2)
- **★7** (no fixo, upgrade da escolha de 5)
- **★9** (no fixo, upgrade adicional)
- **★10** (no fixo, skill assinatura)

### 3.1 Warrior

| Estrela | Ramo / No | Descricao | Mecanica | Status aplicado |
|---|---|---|---|---|
| ★1 | Veterano | Skills base ganham +20% dano. HP +200 flat. | Buff de stats | - |
| ★3 ramo A | Cavaleiro Sagrado | Foco em defesa, healing aliado, status Shielded. Cura aliados em party. | Tank/Support | Shielded em si + aliados |
| ★3 ramo B | Berserker do Caos | Foco em DPS bruto, autodano permitido, Bleeding/Vulnerable em alvos. | DPS risco | Bleeding em alvos, autodano |
| ★5 ramo A1 | Templario | Cavaleiro Sagrado focado em magia branca. Aura de cura em party. | Hibrido tank+heal | Health Regen aura |
| ★5 ramo A2 | Paladino | Cavaleiro Sagrado focado em retaliacao. Thorns + Reflect altos. | Tank reativo | Thorns aura |
| ★5 ramo B1 | Senhor da Guerra | Berserker que entra em Berserker permanente em low HP. | DPS escalavel | Auto-Berserker abaixo 30% HP |
| ★5 ramo B2 | Carniceiro | Berserker focado em Bleeding stack. Lacerate +10/hit. | DPS DoT | Bleeding stack acelerado |
| ★7 (A1) | Templario Real | Aura de cura em party +50%. | Buff escalonado | - |
| ★7 (A2) | Paladino Vingador | Reflect 30%, Thorns 20%. | Buff defensivo | - |
| ★7 (B1) | Senhor de Mil Guerras | Stacks de "Furia" ate 50 que aumentam ATK em 1% cada. | Stack visivel | Furia (custom) |
| ★7 (B2) | Carniceiro Faminto | Lifesteal +20% baseado em Bleeding stacks. | DPS sustento | - |
| ★9 (A1) | Hino do Sagrado | Sempre que aliado morreria, e curado pra 30% HP (cd 60s). | Salvavidas | - |
| ★9 (A2) | Sentinela Eterna | Aura de Stun resist +50% pra party. | Defesa em party | - |
| ★9 (B1) | Avatar da Guerra | Cada kill da +5% atk speed por 5s, stack ilimitado. | DPS escalavel | - |
| ★9 (B2) | Carniceiro de Almas | Bleeding em qualquer alvo cria explosao em 25s = 200% dano area. | DPS aoe latente | - |
| ★10 (A1) | Skill assinatura: "Bencao do Imperador" | Aura passiva: party ganha +30% HP, +20% DEF, +10% Health Regen. | Aura permanente | - |
| ★10 (A2) | Skill assinatura: "Coracao do Bastao" | Quando o Paladino bloqueia, devolve 100% do dano. Block Chance +25%. | Counter total | Shielded |
| ★10 (B1) | Skill assinatura: "Forma da Guerra" | A cada 100 kills: +1% ATK permanente do save. | Progresso eterno | - |
| ★10 (B2) | Skill assinatura: "Carnificina Final" | Kill com Bleeding stack maximo da +1 stack a todos os inimigos no range. | DPS contagioso | Bleeding em massa |

### 3.2 Mage

| Estrela | Ramo / No | Descricao | Mecanica | Status |
|---|---|---|---|---|
| ★1 | Sabio | Skills base +20% dano. MP Max +100. | Buff stats | - |
| ★3 ramo A | Pirômano | Foco em Burning, AoE de fogo, dano sobre tempo. | DPS DoT | Burning |
| ★3 ramo B | Cronomante | Foco em Slowed, controle de tempo, cooldown reduction. | Controlador | Slowed |
| ★5 ramo A1 | Senhor das Chamas | Pirômano focado em explosoes maiores. | DPS burst | Burning forte |
| ★5 ramo A2 | Mestre do Magma | Pirômano focado em DoT permanente em terreno. | DPS area continua | Pools de Burning |
| ★5 ramo B1 | Senhor do Tempo | Cronomante que ganha turnos extras. | Atk speed extrema | Atk Speed Up |
| ★5 ramo B2 | Mestre da Estagnacao | Cronomante que congela inimigos com stacks de Slowed -> Freeze. | Lockdown | Slowed -> Freeze |
| ★7 (A1) | Senhor das Chamas Maior | Burning stack ate 5x. | DoT mais forte | - |
| ★7 (A2) | Mestre do Magma Maior | Pools de magma duram 2x mais. | Area control | - |
| ★7 (B1) | Senhor do Tempo Maior | Cooldown Reduction +20%. | QoL | - |
| ★7 (B2) | Mestre da Estagnacao Maior | Slowed dura 2x mais; 5 Slowed = Freeze. | Lockdown maior | - |
| ★9 (A1) | Solar Plenipotente | Burning ignora 30% Fire Resist do alvo. | Anti-resistencia | - |
| ★9 (A2) | Geologo do Caos | Pools magma destroem 5% DEF do alvo permanentemente naquela luta. | Debuff acumulativo | Broken Armor |
| ★9 (B1) | Sussurro do Tempo | A cada skill usada, proximas 2 skills cd-0. | Combo | - |
| ★9 (B2) | Coracao Congelado | Freeze em alvo da +30% dano nas proximas hits do mage. | Combo | - |
| ★10 (A1) | "Solar Final" | Skill assinatura: Sol Caido — 5s de canalizacao, AoE gigante, Burning forte permanente naquele combat. | Boss-killer | - |
| ★10 (A2) | "Mar de Magma" | Aura passiva: terreno embaixo de inimigos vira pool de magma. | Area total | - |
| ★10 (B1) | "Sussurro do Final dos Tempos" | Skill assinatura: para o tempo 4s. So o Mage age. | Boss-killer | - |
| ★10 (B2) | "Coracao Eterno do Inverno" | Aura passiva: todos os inimigos em range tem 1% chance/s de Freeze. | Lockdown total | - |

### 3.3 Ranger

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Patrulheiro | Skills base +20%. Crit Damage +10%. |
| ★3 ramo A | Caçador de Sombras | Crit + dano vs racas Animal/Beast. Furtividade. |
| ★3 ramo B | Druida | Invocar familiares (Lobo, Urso, Aguia). Buffs naturais. |
| ★5 ramo A1 | Assassino de Bestas | Caçador focado em finalizar inimigos com baixo HP. Execute. |
| ★5 ramo A2 | Caçador de Caça Maior | Caçador focado em dano cumulativo vs alvos pesados (Boss/Tank). |
| ★5 ramo B1 | Druida Bestial | Invoca Urso (Tank) e Lobo (DPS) simultaneamente. |
| ★5 ramo B2 | Druida Avian | Invoca Aguia (DPS aereo) + buff de Atk Speed em si. |
| ★7 (A1) | Execute < 30% HP da kill instantaneo | |
| ★7 (A2) | dano +50% se alvo HP > 50% | |
| ★7 (B1) | familiares ganham 50% dos seus stats | |
| ★7 (B2) | Aguia ganha Pierce + 30% Hit | |
| ★9 (A1) | Execute em qualquer % se Crit | |
| ★9 (A2) | dano +100% se alvo HP > 75% | |
| ★9 (B1) | familiares respawn em 5s se mortos | |
| ★9 (B2) | Aguia chama Aguia Filhote em cada kill | |
| ★10 (A1) | "Caçada Eterna" Aura: bonus de execute aplica a todos da party | |
| ★10 (A2) | "Lança da Lenda" Skill: dano fixo igual a 50% do HP atual do alvo | |
| ★10 (B1) | "Convocacao do Reino Selvagem" Skill: invoca um Filhote do Bosque temporario | |
| ★10 (B2) | "Senhor dos Ceus" Aura: party ganha +20% Atk Speed enquanto Aguia vivo | |

### 3.4 Rogue

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Veterano da Sombra | Skills base +20%. Crit Chance +5%. |
| ★3 ramo A | Assassino | Foco em backstab, Bleeding. |
| ★3 ramo B | Trapaceiro | Foco em armadilhas, Poison, debuffs. |
| ★5 ramo A1 | Assassino de Sangue | Bleeding stack +5/hit. Lifesteal em alvos sangrando. |
| ★5 ramo A2 | Espreitador | Crit Damage +50% nos primeiros 3s de combate. |
| ★5 ramo B1 | Mestre dos Venenos | Poison stack ate 8x, ignora resist 20%. |
| ★5 ramo B2 | Engenheiro Trapeiro | Trapas no chao causam debuffs em area. |
| ★7+ | [PLACEHOLDER: nos detalhados ★7/★9/★10 para Rogue — seguir padrao Warrior/Mage] |

### 3.5 Cleric

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Iniciado da Luz | Skills base +20%. Health Regen +2/s. |
| ★3 ramo A | Sacerdote da Vida | Foco em cura forte, Health Regen aura. |
| ★3 ramo B | Inquisidor | Foco em dano radiante, anti-undead, Burning Light. |
| ★5 ramo A1 | Patriarca | Cura em massa instantanea baseada em MP. |
| ★5 ramo A2 | Mediador | Cura escalavel com tempo de combate. |
| ★5 ramo B1 | Inquisidor Radiante | Light damage +50%, dano vs Undead +100%. |
| ★5 ramo B2 | Caçador de Hereges | Dano vs Caster +50%, Silence on hit. |
| ★7+ | [PLACEHOLDER: nos detalhados ★7/★9/★10 para Cleric] |

### 3.6 Berserker

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Sangue Quente | Skills base +20%. ATK +20 flat. |
| ★3 ramo A | Senhor da Furia | Stacks de Furia escalando ate 100, +1% ATK por stack. |
| ★3 ramo B | Avatar da Carnificina | Lacerate +5/hit, lifesteal alto se Bleeding stack alto. |
| ★5 ramo A1 | Brutamonte da Tempestade | Furia da +1% Atk Speed por stack tambem. |
| ★5 ramo A2 | Imortal Sangrento | Furia stacks dao Health Regen escalavel. |
| ★5 ramo B1 | Açougueiro do Caos | Bleeding explode automatico em 15 stacks (sem precisar de 20). |
| ★5 ramo B2 | Senhor da Lacerada | Lacerate stack ate 30 (em vez de 20). |
| ★7+ | [PLACEHOLDER: nos detalhados] |

### 3.7 Necromancer

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Aprendiz dos Mortos | Skills base +20%. MP Max +80. |
| ★3 ramo A | Lich | Foco em DoT (Curse, Poison) e drenagem. |
| ★3 ramo B | Senhor dos Esqueletos | Foco em invocar undeads (esqueletos, ghouls). |
| ★5 ramo A1 | Lich do Gelo | Curse + Slowed + Freeze chance. |
| ★5 ramo A2 | Lich Putrefato | Curse + Poison + Bleeding stack. |
| ★5 ramo B1 | Senhor dos Cadaveres | Esqueletos invocados ganham +50% stats e Bleeding aura. |
| ★5 ramo B2 | Senhor dos Esqueletos Magos | Invoca Esqueleto Mago + Esqueleto Tank simultaneamente. |
| ★7+ | [PLACEHOLDER: nos detalhados] |

### 3.8 Monk

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Disciplina | Skills base +20%. Atk Speed +5%. |
| ★3 ramo A | Mestre do Ki | Foco em combos, dano fisico amplificado. |
| ★3 ramo B | Andarilho do Tao | Foco em Dodge, contra-ataque, Reflect. |
| ★5 ramo A1 | Mil Punhos | Atk Speed +30%, ATK +30%, mas DEF -10%. |
| ★5 ramo A2 | Punho Estelar | Crit Damage +100%, Crit Chance +20%. |
| ★5 ramo B1 | Mestre da Esquiva | Dodge +25%, contra ataca a cada esquiva. |
| ★5 ramo B2 | Reflexo Eterno | Reflect 50%, Thorns 20%. |
| ★7+ | [PLACEHOLDER: nos detalhados] |

### 3.9 Bard

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Trovador | Skills base +20%. Atk Speed +5%. |
| ★3 ramo A | Bardo da Inspiracao | Buffs em party (ATK, DEF, Atk Speed). |
| ★3 ramo B | Bardo da Discordia | Debuffs no inimigo (Slowed, Confused, Silence). |
| ★5 ramo A1 | Maestro da Guerra | Buffs aplicam +50% mais forte. |
| ★5 ramo A2 | Cantor da Cura | Inspiracao tambem aplica Health Regen. |
| ★5 ramo B1 | Vilao Cantante | Debuffs duram 2x mais. |
| ★5 ramo B2 | Sussurrador do Caos | Confused tambem reduz Magic Resist do alvo. |
| ★7+ | [PLACEHOLDER: nos detalhados] |

### 3.10 Summoner

| Estrela | Ramo / No | Descricao |
|---|---|---|
| ★1 | Convocador | Skills base +20%. Pet ATK +15%. |
| ★3 ramo A | Senhor das Bestas | Foco em pets de combate (acompanham, dao dano). |
| ★3 ramo B | Senhor das Esferas | Foco em invocacoes magicas (totens, esferas, faiscas). |
| ★5 ramo A1 | Mestre Tribal | Pets ganham +50% HP/ATK e Bleeding aura. |
| ★5 ramo A2 | Mestre Aviar | Pets aereos com Pierce e Atk Speed. |
| ★5 ramo B1 | Mestre dos Totens | Totens fixos ficam ativos durante toda a luta. |
| ★5 ramo B2 | Mestre das Esferas | Esferas magicas perseguem o inimigo. |
| ★7+ | [PLACEHOLDER: nos detalhados] |

---

## 4. Personagem inicial

**Warrior** ja existe no projeto: `data/characters/warrior.tres`. Ele e' o ponto de partida de todo save novo. Lv 1, com Espada de Treino.

[ver: planning/01_design/skills-catalog.md#warrior]

---

## 5. Pendencias

- Detalhar nos ★7/★9/★10 para Rogue, Cleric, Berserker, Necromancer, Monk, Bard, Summoner. Marcado como `[PLACEHOLDER]`.
- [DECISAO PENDENTE: Skill assinatura do ★10 — qual escala em endgame? E uma skill ativa, uma passiva ou aura permanente? Padrao adotado: aura permanente em escolhas A1/A2, skill ativa em B1/B2 — confirmar.]
- [DECISAO PENDENTE: Apos ★10, o personagem pode comprar nos extras com Transcended Points? ou para ali ate Transcendencia?]

---

## Termos novos introduzidos neste arquivo

- "Furia" — stack custom do ramo Senhor da Furia.
- "Familiar" — invocacao ativa de Druida (Lobo, Urso, Aguia).
- "Pool de magma" / "Pool de Burning" — mecanica de Mestre do Magma (terreno).
- "Skill assinatura" — skill final no ★10, identidade da build.
- "Mediador" — sub-ramo Cleric.
- "Inquisidor" — sub-ramo Cleric.
