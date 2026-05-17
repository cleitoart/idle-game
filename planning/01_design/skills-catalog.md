# Skills Catalog - 200 Skills (20 por classe)

> 20 skills por classe x 10 classes = 200 skills. Mistura de active e passive. Fonte: `roadmap-sistemas.md` secao 3.11, 3.12. Termos: ver `00_meta/glossary.md`.

---

## 1. Convencoes

- **Active** = tem cooldown e mana cost. Disparada automaticamente pelo sistema (auto-battle).
- **Passive** = tem trigger condition (sem cooldown explicito; alguns tem cooldown interno).
- **Tipo de ataque** quando aplicavel (ver `equipment-catalog.md#3-tabela-oficial-de-tipos-de-ataque-por-arma`).
- **Cooldown (cd)** em segundos.
- **Mana cost** flat (nao escalavel pelo nivel da skill).
- **Dano** em formula simplificada com scaling stat.
- **Status aplicado** quando relevante.
- **Awakening unlock** = ramo onde a skill e' desbloqueada (vinculado a `classes-and-characters.md`). "Base" = pre-Awakening.

---

## 2. Warrior (20 skills)

| # | Nome | Active/Passive | Tipo ataque | CD | MP | Dano | Status | Scaling | Awakening unlock |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Golpe Forte | Active | Slash | 4s | 5 | 150% ATK | - | STR | Base |
| 2 | Investida | Active | Crush | 7s | 12 | 200% ATK + Stun chance 30% | Stun 1.5s | STR | Base |
| 3 | Provocar | Active | - | 12s | 8 | - | aggro alvo | - | Base |
| 4 | Bater Escudo | Active | Blunt | 6s | 10 | 100% ATK + Block | Shielded self 3s | STR/VIT | Base |
| 5 | Postura Defensiva | Passive | - | - | - | - | DEF +15% sempre | VIT | Base |
| 6 | Pele Dura | Passive | - | - | - | - | HP +10% sempre | VIT | Base |
| 7 | Grito de Guerra | Active | - | 25s | 20 | - | ATK Up self 8s | STR | Base |
| 8 | Decapitar | Active | Slash | 18s | 25 | 350% ATK, +500% se HP < 20% | - | STR/LUK | Base |
| 9 | Cura Sagrada | Active | - | 20s | 30 | - | +30% HP self | INT | Cavaleiro Sagrado ★3A |
| 10 | Aura de Luz | Passive | - | - | - | - | aliados em party +5% Health Regen | INT | Cavaleiro Sagrado ★3A |
| 11 | Escudo Sagrado | Active | - | 30s | 40 | - | Shielded self 6s e em 1 aliado | INT/VIT | Cavaleiro Sagrado ★3A |
| 12 | Berserker do Caos | Active | - | 45s | 0 | - | Berserker self 12s | STR | Berserker do Caos ★3B |
| 13 | Frenesi Sangrento | Passive | - | - | - | - | dano +5% por Bleeding stack no alvo | STR | Berserker do Caos ★3B |
| 14 | Autodano Permitido | Passive | - | - | - | - | Lifesteal +20% mas sofre 5% HP por hit | STR | Berserker do Caos ★3B |
| 15 | Coracao Imortal | Passive | - | - | - | - | Quando morreria, fica vivo com 1 HP (cd 120s) | VIT | Templario ★5A1 |
| 16 | Vingança Divina | Active | Slash | 25s | 50 | 500% ATK em alvo que matou aliado | dano amplificado | STR | Paladino ★5A2 |
| 17 | Dilacerador | Active | Slash + Lacerate | 6s | 15 | 200% ATK, Lacerate stack +5 | Bleeding stack | STR | Carniceiro ★5B2 |
| 18 | Forma da Guerra | Passive | - | - | - | - | a cada 100 kills: +1% ATK permanente | STR | Senhor da Guerra ★7B1 |
| 19 | Bencao do Imperador | Passive (aura) | - | - | - | - | party: +30% HP, +20% DEF, +10% Health Regen | - | Skill assinatura ★10A1 |
| 20 | Carnificina Final | Passive | - | - | - | - | kill com Bleeding 20 stacks: +1 Bleeding em todos os inimigos no range | STR | Skill assinatura ★10B2 |

---

## 3. Mage (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Bola de Fogo | Active | Magic | 3s | 8 | 130% Magic ATK | Burning chance 25% | INT | Base |
| 2 | Raio Gelido | Active | Magic | 4s | 12 | 110% Magic ATK | Slowed 3s | INT | Base |
| 3 | Choque Eletrico | Active | Magic | 5s | 14 | 160% Magic ATK | Stun chance 20% | INT | Base |
| 4 | Escudo Magico | Active | - | 18s | 20 | - | Shielded self 5s | INT | Base |
| 5 | Reflexao Arcana | Passive | - | - | - | - | Cast Speed +10% | INT | Base |
| 6 | Foco Mental | Passive | - | - | - | - | MP Max +25% | INT | Base |
| 7 | Bola de Fogo Maior | Active | Magic | 8s | 25 | 250% Magic ATK AoE | Burning forte | INT | Base |
| 8 | Tempestade de Gelo | Active | Magic | 14s | 35 | 200% Magic ATK AoE | Slowed AoE 5s | INT | Base |
| 9 | Pirômano | Passive | - | - | - | - | Burning ignora 20% Fire Resist | INT | Pirômano ★3A |
| 10 | Meteoro | Active | Magic | 25s | 60 | 400% Magic ATK AoE | Burning forte | INT | Pirômano ★3A |
| 11 | Sussurro do Tempo | Active | - | 30s | 40 | - | proximas 2 skills cd-0 | INT | Cronomante ★3B |
| 12 | Slow Maximo | Active | Magic | 12s | 30 | 100% Magic ATK | Slowed forte 8s, stack para Freeze | INT | Cronomante ★3B |
| 13 | Solar Plenipotente | Passive | - | - | - | - | Burning +50% dano e ignora 30% Fire Resist | INT | Senhor das Chamas ★5A1 |
| 14 | Mar de Magma | Passive (aura) | - | - | - | - | terreno embaixo de inimigos vira pool de magma | INT | Mestre do Magma ★5A2 |
| 15 | Sussurro do Final dos Tempos | Active | - | 60s | 100 | - | para o tempo 4s, so o Mage age | INT | Senhor do Tempo ★5B1 |
| 16 | Coracao Eterno do Inverno | Passive (aura) | - | - | - | - | inimigos no range: 1% chance/s de Freeze | INT | Mestre da Estagnacao ★5B2 |
| 17 | Bola de Fogo Cosmica | Active | Magic | 12s | 50 | 300% Magic ATK + Burning permanente nessa luta | Burning eterno | INT | Senhor das Chamas Maior ★7A1 |
| 18 | Tempo Quebrado | Passive | - | - | - | - | Cooldown Reduction +20% global | INT | Senhor do Tempo Maior ★7B1 |
| 19 | Sol Caido | Active | Magic | 90s | 150 | 1000% Magic ATK AoE | Burning eterno area | INT | Skill assinatura ★10A1 |
| 20 | Reverso Cronico | Active | - | 120s | 200 | - | reverte HP do alvo a 50% se acima de 50% | INT | Skill assinatura ★10B1 |

---

## 4. Ranger (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Tiro Certeiro | Active | Pierce | 3s | 6 | 130% ATK + Crit Up | - | DEX | Base |
| 2 | Tiro Multiplo | Active | Pierce | 7s | 15 | 80% ATK x3 alvos | - | DEX | Base |
| 3 | Flecha Envenenada | Active | Pierce | 6s | 12 | 100% ATK | Poison 6s | DEX/LUK | Base |
| 4 | Esquiva Rapida | Active | - | 14s | 10 | - | Dodge 100% por 2s | DEX | Base |
| 5 | Olho de Aguia | Passive | - | - | - | - | Hit Chance +15% | DEX | Base |
| 6 | Mira Calma | Passive | - | - | - | - | Crit Damage +20% | DEX | Base |
| 7 | Tiro Precisao | Active | Pierce | 10s | 20 | 250% ATK + Crit garantido | - | DEX | Base |
| 8 | Camuflagem | Active | - | 25s | 25 | - | Untouchable 4s, proximo ataque +200% dano | DEX | Base |
| 9 | Caçada de Bestas | Passive | - | - | - | - | dano vs Animal/Beast +30% | DEX | Caçador de Sombras ★3A |
| 10 | Furtividade Maior | Active | - | 30s | 30 | - | Untouchable 6s, todos pets aliados ganham Crit Up | DEX | Caçador de Sombras ★3A |
| 11 | Convocar Lobo Fiel | Active | - | 40s | 40 | - | invoca Lobo familiar (50% dos stats do mage) por 30s | DEX/INT | Druida ★3B |
| 12 | Convocar Urso Guardian | Active | - | 60s | 60 | - | invoca Urso familiar (Tank, agro all) | DEX/INT | Druida ★3B |
| 13 | Execute Sombrio | Active | Pierce | 8s | 18 | 800% ATK se alvo HP < 30%, normal se acima | - | DEX | Assassino de Bestas ★5A1 |
| 14 | Lança da Lenda | Active | Pierce | 25s | 60 | dano fixo igual a 50% HP atual do alvo | - | DEX | Skill assinatura ★10A2 |
| 15 | Convocacao Selvagem | Active | - | 90s | 100 | - | invoca Filhote do Bosque temporario por 60s | DEX/INT | Skill assinatura ★10B1 |
| 16 | Senhor dos Ceus | Passive (aura) | - | - | - | - | party: +20% Atk Speed enquanto Aguia familiar viva | DEX | Skill assinatura ★10B2 |
| 17 | Aguia de Combate | Active | Pierce | 35s | 35 | - | invoca Aguia familiar (DPS aereo, Pierce + 30% Hit) | DEX/INT | Druida Avian ★5B2 |
| 18 | Aura Selvagem | Passive | - | - | - | - | familiares ganham 50% dos stats do mestre | DEX/INT | Druida Bestial ★5B1 |
| 19 | Tiro de Ressaca | Active | Pierce | 12s | 22 | 200% ATK + 100% se Crit no hit anterior | - | DEX | Caçador de Caça Maior ★5A2 |
| 20 | Familiar Eterno | Passive | - | - | - | - | familiares respawn em 5s se mortos | DEX | Druida Bestial ★9B1 |

---

## 5. Rogue (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Apunhalar | Active | Slash + Stab | 3s | 6 | 140% ATK | - | DEX | Base |
| 2 | Backstab | Active | Stab | 8s | 18 | 300% ATK + Crit garantido | - | DEX/LUK | Base |
| 3 | Lancar Adaga | Active | Pierce | 4s | 8 | 100% ATK ranged | - | DEX | Base |
| 4 | Esquiva | Active | - | 12s | 10 | - | Dodge 100% por 2s | DEX | Base |
| 5 | Critico Reflexivo | Passive | - | - | - | - | Crit Chance +10% | LUK | Base |
| 6 | Combate Sujo | Passive | - | - | - | - | dano +5% se atacando do lado/atras | DEX | Base |
| 7 | Veneno na Lamina | Active | Stab | 10s | 15 | 100% ATK + Poison forte | Poison 8s | DEX | Base |
| 8 | Olhos do Caos | Passive | - | - | - | - | Hit Chance +10%, Crit Damage +15% | DEX | Base |
| 9 | Apunhalada Sangrenta | Active | Slash | 6s | 14 | 180% ATK + Bleeding stack +3 | Bleeding | DEX | Assassino ★3A |
| 10 | Mestre dos Cortes | Passive | - | - | - | - | Bleeding stack +1 a cada hit | DEX | Assassino ★3A |
| 11 | Mestre dos Venenos | Passive | - | - | - | - | Poison stack ate 8x, ignora resist 20% | DEX | Trapaceiro ★3B |
| 12 | Trapa de Veneno | Active | - | 18s | 25 | - | armadilha em area, Poison forte stackavel | DEX | Trapaceiro ★3B |
| 13 | Sangue do Inimigo | Passive | - | - | - | - | Lifesteal +15% em alvos sangrando | DEX | Assassino de Sangue ★5A1 |
| 14 | Espreitar | Active | Stab | 15s | 30 | 500% ATK Crit garantido + Bleeding 5 | - | DEX | Espreitador ★5A2 |
| 15 | Veneno do Cosmo | Active | - | 30s | 40 | - | aplica Poison stack 8x instant em todos inimigos area | DEX | Mestre dos Venenos ★5B1 |
| 16 | Lança de Trapa | Active | - | 12s | 20 | - | trapa magica que aplica Slowed + Broken Armor area | DEX | Engenheiro Trapeiro ★5B2 |
| 17 | Caçador da Madrugada | Passive | - | - | - | - | Crit Damage +50% nos primeiros 3s de combate | DEX | Espreitador ★5A2 |
| 18 | Veneno Devorador | Passive | - | - | - | - | Poison stacks tambem reduzem MP regen do alvo | DEX | Mestre dos Venenos ★7B1 |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Active | - | 60s | 80 | - | - | DEX | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Passive | - | - | - | - | - | DEX | Skill assinatura ★10B |

---

## 6. Cleric (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Cura Menor | Active | - | 4s | 12 | - | +30% HP em 1 aliado | INT | Base |
| 2 | Bencao | Active | - | 25s | 20 | - | ATK Up + DEF Up em aliado 10s | INT | Base |
| 3 | Lança Sagrada | Active | Magic | 5s | 15 | 130% Magic ATK Light | Burning Light | INT | Base |
| 4 | Aura de Cura | Passive | - | - | - | - | aliados +5 Health Regen | INT | Base |
| 5 | Foco Espiritual | Passive | - | - | - | - | MP Max +20% | INT | Base |
| 6 | Resistencia Divina | Passive | - | - | - | - | Resist (todos status) +5% | INT/VIT | Base |
| 7 | Cura Maior | Active | - | 12s | 35 | - | +60% HP em 1 aliado | INT | Base |
| 8 | Banimento | Active | Magic | 18s | 40 | 200% Magic ATK Light + dano vs Undead +200% | - | INT | Base |
| 9 | Aura de Vida | Passive (aura) | - | - | - | - | aliados +10% Health Regen | INT | Sacerdote da Vida ★3A |
| 10 | Cura Massiva | Active | - | 30s | 80 | - | +50% HP em toda a party | INT | Sacerdote da Vida ★3A |
| 11 | Inquisicao | Active | Magic | 6s | 18 | 180% Magic ATK Light + dano vs Caster +50% | Silence | INT | Inquisidor ★3B |
| 12 | Luz Cegante | Active | Magic | 14s | 30 | 100% Magic ATK Light AoE | Blind 4s | INT | Inquisidor ★3B |
| 13 | [PLACEHOLDER: skill ★5A1 Patriarca] | Active | - | 20s | 60 | - | cura +100% HP em 1 aliado | INT | Patriarca ★5A1 |
| 14 | [PLACEHOLDER: skill ★5A2 Mediador] | Passive | - | - | - | - | cura escala com tempo de combate | INT | Mediador ★5A2 |
| 15 | [PLACEHOLDER: skill ★5B1 Inquisidor Radiante] | Active | Magic | 8s | 22 | 250% Magic ATK Light, dano vs Undead +100% | Burning Light | INT | Inquisidor Radiante ★5B1 |
| 16 | [PLACEHOLDER: skill ★5B2 Caçador de Hereges] | Active | Magic | 7s | 20 | 200% Magic ATK Light + Silence 4s | Silence | INT | Caçador de Hereges ★5B2 |
| 17 | [PLACEHOLDER: skill ★7A] | Active | - | 35s | 100 | - | ressurita 1 aliado morto com 50% HP | INT | ★7A |
| 18 | [PLACEHOLDER: skill ★9A] | Passive | - | - | - | - | toda cura tambem aplica Shielded equivalente a 50% do healing | INT | ★9A |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Passive (aura) | - | - | - | - | aliados em party tem 50% chance de receber heal toda vez que cleric usa skill | INT | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Active | Magic | 60s | 150 | 1500% Magic ATK Light + dano vs Undead +500% AoE | Burning Light eterno | INT | Skill assinatura ★10B |

---

## 7. Berserker (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Pancada Brutal | Active | Crush | 4s | 5 | 180% ATK | - | STR | Base |
| 2 | Furia | Active | - | 30s | 0 | - | Berserker self 15s | STR | Base |
| 3 | Investida Selvagem | Active | Crush | 8s | 10 | 250% ATK + Stun chance 40% | Stun | STR | Base |
| 4 | Pele de Aco | Passive | - | - | - | - | DEF +20% | VIT | Base |
| 5 | Sangue Quente | Passive | - | - | - | - | Lifesteal +5% | STR | Base |
| 6 | Atk Speed Crescente | Passive | - | - | - | - | Atk Speed escala com low HP (max +50% em 1% HP) | STR | Base |
| 7 | Esmagar | Active | Crush | 10s | 18 | 350% ATK + Broken Armor | Broken Armor | STR | Base |
| 8 | Rugido | Active | - | 18s | 12 | - | ATK Up self 10s + Atk Speed Up self 10s | STR | Base |
| 9 | Furia Permanente | Passive | - | - | - | - | Stacks de Furia ate 100, +1% ATK por stack | STR | Senhor da Furia ★3A |
| 10 | Avatar da Carnificina | Passive | - | - | - | - | Lacerate +5/hit | STR | Avatar da Carnificina ★3B |
| 11 | Brutamonte | Passive | - | - | - | - | Furia stacks dao +1% Atk Speed cada | STR | Brutamonte da Tempestade ★5A1 |
| 12 | Imortal Sangrento | Passive | - | - | - | - | Furia stacks dao +0.5/s Health Regen cada | STR | Imortal Sangrento ★5A2 |
| 13 | Açougueiro do Caos | Passive | - | - | - | - | Bleeding explode em 15 stacks (em vez de 20) | STR | Açougueiro do Caos ★5B1 |
| 14 | Senhor da Lacerada | Passive | - | - | - | - | Lacerate stack ate 30 (em vez de 20) | STR | Senhor da Lacerada ★5B2 |
| 15 | [PLACEHOLDER: skill ★7A] | Active | Crush + Lacerate | 15s | 25 | 400% ATK + Lacerate +10 | - | STR | ★7A |
| 16 | [PLACEHOLDER: skill ★7B] | Passive | - | - | - | - | Bleeding stack tambem reduz Atk Speed do alvo 1% por stack | STR | ★7B |
| 17 | [PLACEHOLDER: skill ★9A] | Passive | - | - | - | - | a cada 50 stacks de Furia, +5% Crit Damage permanente naquele combat | STR | ★9A |
| 18 | [PLACEHOLDER: skill ★9B] | Active | Crush + Lacerate | 25s | 45 | 600% ATK + explode todos os Bleeding stacks instantaneamente | - | STR | ★9B |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Active | - | 60s | 80 | - | converte 100% das Furia stacks em ATK permanente naquele combat (ate 200%) | STR | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Passive (aura) | - | - | - | - | kill com Bleeding 30 stacks: explode em area, aplica Bleeding 10 stacks em todos | STR | Skill assinatura ★10B |

---

## 8. Necromancer (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Toque Mortal | Active | Magic | 5s | 12 | 130% Magic ATK + Curse | Curse 4s | INT | Base |
| 2 | Convocar Esqueleto | Active | - | 20s | 30 | - | invoca Esqueleto (Lv = Necromancer Lv * 0.7) | INT | Base |
| 3 | Drenar Alma | Active | Magic | 7s | 18 | 100% Magic ATK + Lifesteal 50% do dano | - | INT | Base |
| 4 | Aura de Decomposicao | Passive (aura) | - | - | - | - | inimigos no range -5 Health Regen | INT | Base |
| 5 | Magia Sombria | Passive | - | - | - | - | Magic ATK +10% | INT | Base |
| 6 | Pacto Mortuario | Passive | - | - | - | - | esqueletos invocados +20% stats | INT | Base |
| 7 | Praga | Active | Magic | 14s | 35 | 200% Magic ATK AoE + Curse | Curse AoE | INT | Base |
| 8 | Convocar Ghoul | Active | - | 35s | 50 | - | invoca Ghoul (DPS Bleeding) | INT | Base |
| 9 | Lich | Passive | - | - | - | - | Curse stacks ate 5x | INT | Lich ★3A |
| 10 | Senhor dos Esqueletos | Passive | - | - | - | - | esqueletos +50% stats e Bleeding aura | INT | Senhor dos Esqueletos ★3B |
| 11 | Lich do Gelo | Passive | - | - | - | - | Curse + Slowed simultaneo, chance Freeze | INT | Lich do Gelo ★5A1 |
| 12 | Lich Putrefato | Passive | - | - | - | - | Curse + Poison + Bleeding stack juntos | INT | Lich Putrefato ★5A2 |
| 13 | Senhor dos Cadaveres | Passive | - | - | - | - | esqueletos invocados ganham Bleeding aura | INT | Senhor dos Cadaveres ★5B1 |
| 14 | Senhor dos Esqueletos Magos | Active | - | 40s | 60 | - | invoca Esqueleto Mago + Esqueleto Tank simultaneamente | INT | Senhor dos Esqueletos Magos ★5B2 |
| 15 | [PLACEHOLDER: ★7A] | Active | Magic | 18s | 40 | 300% Magic ATK + Curse 5 stacks | Curse forte | INT | ★7A |
| 16 | [PLACEHOLDER: ★7B] | Passive | - | - | - | - | esqueletos respawn em 5s se mortos | INT | ★7B |
| 17 | [PLACEHOLDER: ★9A] | Passive | - | - | - | - | a cada Curse stack: +10% dano | INT | ★9A |
| 18 | [PLACEHOLDER: ★9B] | Active | - | 60s | 80 | - | invoca exercito (5 esqueletos) | INT | ★9B |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Active | Magic | 90s | 150 | dano = 100% HP atual do alvo, ate cap | - | INT | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Passive (aura) | - | - | - | - | inimigos mortos viram esqueletos aliados por 30s | INT | Skill assinatura ★10B |

---

## 9. Monk (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Soco Veloz | Active | Blunt | 2s | 4 | 100% ATK | - | DEX/STR | Base |
| 2 | Combo Triplo | Active | Blunt | 7s | 12 | 80% ATK x3 | - | DEX | Base |
| 3 | Chute Giratorio | Active | Blunt | 9s | 15 | 200% ATK AoE | - | DEX/STR | Base |
| 4 | Esquiva Etereal | Active | - | 10s | 8 | - | Dodge 100% por 1.5s | DEX | Base |
| 5 | Atk Speed Maior | Passive | - | - | - | - | Atk Speed +15% | DEX | Base |
| 6 | Foco Interior | Passive | - | - | - | - | MP Max +15% | INT | Base |
| 7 | Punho Concentrado | Active | Blunt | 12s | 22 | 350% ATK + Stun chance 40% | Stun | DEX/STR | Base |
| 8 | Postura do Tigre | Active | - | 20s | 18 | - | ATK Up self 12s + Atk Speed Up self 12s | DEX | Base |
| 9 | Mestre do Ki | Passive | - | - | - | - | dano fisico +20%, Atk Speed +10% | DEX | Mestre do Ki ★3A |
| 10 | Andarilho do Tao | Passive | - | - | - | - | Dodge +10%, contra-ataca a cada esquiva | DEX | Andarilho do Tao ★3B |
| 11 | Mil Punhos | Passive | - | - | - | - | Atk Speed +30%, ATK +30%, mas DEF -10% | DEX | Mil Punhos ★5A1 |
| 12 | Punho Estelar | Passive | - | - | - | - | Crit Damage +100%, Crit Chance +20% | DEX/LUK | Punho Estelar ★5A2 |
| 13 | Mestre da Esquiva | Passive | - | - | - | - | Dodge +25%, contra-ataca a cada esquiva | DEX | Mestre da Esquiva ★5B1 |
| 14 | Reflexo Eterno | Passive | - | - | - | - | Reflect 50%, Thorns 20% | VIT | Reflexo Eterno ★5B2 |
| 15 | [PLACEHOLDER: ★7A] | Active | Blunt | 14s | 25 | 400% ATK Crit garantido | - | DEX | ★7A |
| 16 | [PLACEHOLDER: ★7B] | Passive | - | - | - | - | contra-ataque tambem aplica Stun | DEX | ★7B |
| 17 | [PLACEHOLDER: ★9A] | Active | Blunt | 22s | 40 | 600% ATK + 4 hits | - | DEX | ★9A |
| 18 | [PLACEHOLDER: ★9B] | Passive | - | - | - | - | a cada Dodge: ganha 20% MP | DEX | ★9B |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Active | Blunt | 60s | 100 | 100 hits em 5s, cada um 50% ATK | - | DEX | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Passive (aura) | - | - | - | - | toda hit recebida que seria Crit vira Miss | DEX | Skill assinatura ★10B |

---

## 10. Bard (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Acorde Sonoro | Active | Magic | 4s | 8 | 100% Magic ATK + Silence chance 15% | Silence | INT | Base |
| 2 | Cancao Inspiradora | Active | - | 15s | 20 | - | ATK Up party 15s | INT | Base |
| 3 | Cancao Defensiva | Active | - | 18s | 22 | - | DEF Up party 15s | INT | Base |
| 4 | Notas Discordantes | Active | Magic | 8s | 14 | 80% Magic ATK AoE + Confused chance 25% | Confused | INT | Base |
| 5 | Carisma | Passive | - | - | - | - | LUK +5 | LUK | Base |
| 6 | Eco Magico | Passive | - | - | - | - | MP Regen +3/s | INT | Base |
| 7 | Cancao do Tempo | Active | - | 30s | 40 | - | Atk Speed Up party 12s | INT | Base |
| 8 | Hino do Vento | Active | Magic | 25s | 35 | - | Cooldown -3s em todas skills da party | INT | Base |
| 9 | Bardo da Inspiracao | Passive (aura) | - | - | - | - | aliados em party +5% ATK, +5% DEF, +5% Atk Speed | INT | Bardo da Inspiracao ★3A |
| 10 | Bardo da Discordia | Passive (aura) | - | - | - | - | inimigos no range -5% ATK, -5% Hit, -5% Atk Speed | INT | Bardo da Discordia ★3B |
| 11 | Maestro da Guerra | Passive | - | - | - | - | buffs em party +50% mais fortes | INT | Maestro da Guerra ★5A1 |
| 12 | Cantor da Cura | Passive | - | - | - | - | buffs em party tambem aplicam Health Regen | INT | Cantor da Cura ★5A2 |
| 13 | Vilao Cantante | Passive | - | - | - | - | debuffs em inimigos duram 2x mais | INT | Vilao Cantante ★5B1 |
| 14 | Sussurrador do Caos | Passive | - | - | - | - | Confused tambem reduz Magic Resist do alvo | INT | Sussurrador do Caos ★5B2 |
| 15 | [PLACEHOLDER: ★7A] | Active | - | 25s | 45 | - | aplica todos os buffs base ao mesmo tempo | INT | ★7A |
| 16 | [PLACEHOLDER: ★7B] | Active | Magic | 18s | 40 | 200% Magic ATK + Silence 5s + Confused 5s | Silence + Confused | INT | ★7B |
| 17 | [PLACEHOLDER: ★9A] | Passive | - | - | - | - | buffs em party nunca expiram enquanto bardo vivo | INT | ★9A |
| 18 | [PLACEHOLDER: ★9B] | Passive | - | - | - | - | inimigo Confused atinge proprios aliados em 100% chance | INT | ★9B |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Passive (aura) | - | - | - | - | enquanto bardo vivo, party imune a Silence | INT | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Active | Magic | 90s | 150 | - | inverte ATK e DEF de todos os inimigos por 10s | INT | Skill assinatura ★10B |

---

## 11. Summoner (20 skills)

| # | Nome | A/P | Tipo | CD | MP | Dano | Status | Scaling | Awakening |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Convocar Esfera | Active | Magic | 5s | 10 | 110% Magic ATK projecao | - | INT | Base |
| 2 | Convocar Lobo | Active | - | 18s | 25 | - | invoca Lobo familiar (DPS) por 30s | INT | Base |
| 3 | Convocar Totem de Fogo | Active | Magic | 25s | 35 | totem fixo da DoT Burning | Burning aura | INT | Base |
| 4 | Buff de Pet | Active | - | 20s | 18 | - | Pet ATK +30% por 15s | INT | Base |
| 5 | Mestre dos Pets | Passive | - | - | - | - | Pet ATK +15% sempre | INT | Base |
| 6 | Conjuracao Estavel | Passive | - | - | - | - | invocacoes duram +50% mais | INT | Base |
| 7 | Convocar Esqueleto Magico | Active | - | 30s | 40 | - | invoca Esqueleto Mago por 30s | INT | Base |
| 8 | Domo Magico | Active | - | 35s | 50 | - | Shielded em todos os pets/invocacoes 6s | INT | Base |
| 9 | Senhor das Bestas | Passive | - | - | - | - | pets de combate +20% stats | INT | Senhor das Bestas ★3A |
| 10 | Senhor das Esferas | Passive | - | - | - | - | invocacoes magicas (totem, esfera) +30% dano | INT | Senhor das Esferas ★3B |
| 11 | Mestre Tribal | Passive | - | - | - | - | pets +50% HP/ATK e Bleeding aura | INT | Mestre Tribal ★5A1 |
| 12 | Mestre Aviar | Active | - | 30s | 40 | - | invoca Aguia (Pierce + Atk Speed) | INT | Mestre Aviar ★5A2 |
| 13 | Mestre dos Totens | Passive | - | - | - | - | totens fixos ficam ativos durante toda a luta | INT | Mestre dos Totens ★5B1 |
| 14 | Mestre das Esferas | Passive | - | - | - | - | esferas magicas perseguem o inimigo | INT | Mestre das Esferas ★5B2 |
| 15 | [PLACEHOLDER: ★7A] | Passive | - | - | - | - | pets ganham passivos do summoner | INT | ★7A |
| 16 | [PLACEHOLDER: ★7B] | Active | - | 40s | 70 | - | invoca 3 totens diferentes simultaneamente | INT | ★7B |
| 17 | [PLACEHOLDER: ★9A] | Passive | - | - | - | - | pets respawn em 5s se mortos | INT | ★9A |
| 18 | [PLACEHOLDER: ★9B] | Active | Magic | 20s | 50 | 250% Magic ATK por esfera convocada (max 5 esferas) | - | INT | ★9B |
| 19 | [PLACEHOLDER: skill assinatura ★10A] | Active | - | 90s | 150 | - | invoca Avatar (versao maior do pet do summoner) por 30s | INT | Skill assinatura ★10A |
| 20 | [PLACEHOLDER: skill assinatura ★10B] | Passive (aura) | - | - | - | - | enquanto vivo, todas invocacoes ganham +100% stats | INT | Skill assinatura ★10B |

---

## Cross-reference

- Awakening unlocks vinculados a `planning/01_design/classes-and-characters.md#3-awakening-trees-por-classe`.
- Status aplicados detalhados em `roadmap-sistemas.md#33-status-de-batalha`.
- Tipos de ataque em `planning/01_design/equipment-catalog.md#3-tabela-oficial-de-tipos-de-ataque-por-arma`.

---

## Termos novos introduzidos neste arquivo

- "Pool de magma" / "Aura passiva" — categorias de skill especial que afetam terreno.
- "Skill assinatura" — skill final do ramo de Awakening.
- "Familiar" — invocacao de Druida que persiste 30s ate morrer.
- "Totem fixo" — invocacao no chao que nao se move.
