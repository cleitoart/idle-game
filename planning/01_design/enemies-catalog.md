# Enemies Catalog - Catalogo Completo de Inimigos

> Catalogo exaustivo dos inimigos por zona. Fonte: `roadmap-sistemas.md` secoes 3.1, 3.4, 3.15. Termos: ver `00_meta/glossary.md`.

---

## 1. Convencoes

- **6 zonas oficiais.** Cada zona contem 8-12 inimigos comuns + 2 elites + 1 boss.
- **Tags por inimigo:** Raca, Comportamento, Tipo de combate, Elemento, Tipo de ataque.
- **Stats base:** valores no nivel medio da zona (ver `02_math/balance-tables.md` quando criada).
- **Marcadores:** `[ELITE]` antes do nome para elite, `[BOSS]` para boss de zona.
- **Card associado:** todo inimigo gera um card. Variacoes Shiny (raríssimas, douradas) e Transcendido (apos transcendencia) — ver placeholders no fim de cada zona.
- **Skills:** cada inimigo tem 1-3 skills com cooldown em segundos.
- **Drops:** tabela por inimigo. Quantidades base; multiplicar por stats de loot do jogador.

---

## 2. Zona 1 — Floresta

Tema visual: bosque verde, fogueira distante, riacho. NPCs do Acampamento estao aqui. Bioma de mid-temp.

### 2.1 Comuns

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Slime Verde | Slime | Grounded | Melee | Water | Blunt | 30 | 5 | 1 | 0.8/s | Espirro Acido (cd 6s, dano + Poison 5s) | Goo Verde 60% (1-2), Cobre 10% (1) |
| 2 | Slime Azul | Slime | Grounded | Melee | Water | Blunt | 45 | 6 | 2 | 0.8/s | Banho Frio (cd 8s, Slowed 4s) | Goo Azul 60%, Fragmento Aquatico 5% |
| 3 | Coelho Selvagem | Animal | Grounded | Melee | None | Slash | 25 | 8 | 0 | 1.2/s | Investida (cd 5s, +50% dano) | Pelo de Coelho 70%, Carne Crua 30% |
| 4 | Lobo Faminto | Animal | Grounded | Melee | None | Lacerate | 70 | 14 | 3 | 1.0/s | Mordida Lacerante (cd 5s, Bleeding stack +3), Uivo (cd 12s, ATK Up 5s) | Pele de Lobo 50%, Presa Afiada 25% |
| 5 | Goblin Recruta | Human | Grounded | Melee | None | Stab | 60 | 12 | 4 | 0.9/s | Espetada Rapida (cd 4s) | Adaga Enferrujada 15%, Cobre 40% (1-3) |
| 6 | Goblin Arqueiro | Human | Grounded | Ranged | None | Pierce | 50 | 16 | 2 | 0.7/s | Tiro Multiplo (cd 8s, 3 flechas), Flecha Envenenada (cd 14s, Poison) | Flecha Comum 50%, Couro Cru 30% |
| 7 | Cogumelo Andante | Plant | Grounded | Caster | Water | Magic | 55 | 10 | 5 | 0.6/s | Esporos (cd 7s, Confused 3s, AoE) | Cogumelo Falante 40%, Esporo Verde 25% |
| 8 | Vespa Gigante | Insect | Flying | Melee | Wind | Stab | 35 | 14 | 1 | 1.4/s | Ferrao Toxico (cd 6s, Poison + DoT) | Ferrao 30%, Mel Selvagem 15% |
| 9 | Urso Pardo Jovem | Animal | Grounded | Tank | None | Crush | 110 | 18 | 8 | 0.6/s | Patada (cd 5s, Stun chance), Rugido (cd 15s, Atk Up self) | Pele de Urso 40%, Garra de Urso 20% |
| 10 | Espirito Folha | Spirit | Ethereal | Caster | Wind | Magic | 40 | 13 | 3 | 0.8/s | Cortina de Folhas (cd 9s, Blind 4s) | Folha Encantada 35%, Essencia do Vento 10% |
| 11 | Boneca de Trapo Possuida | Construct | Grounded | Melee | None | Slash | 65 | 11 | 4 | 0.9/s | Risada Estridente (cd 10s, Curse 6s) | Tecido Antigo 50%, Botao Magico 8% |

### 2.2 Elites

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E1 | [ELITE] Lider Goblin Sangrento | Human | Grounded | Berserker | Fire | Slash + Lacerate | 280 | 32 | 10 | 1.0/s | Berserk (cd 25s, Berserker self 12s), Corte Sangrento (cd 8s, Bleeding stack +5) | Drop comum x3 garantido + Capacete de Couro Cru (Rare) 20%, Card Lider Goblin Sangrento 1.5% |
| E2 | [ELITE] Mae Vespa | Insect | Flying | Summoner | Wind | Stab | 240 | 28 | 6 | 0.9/s | Convoca Vespas (cd 20s, +2 vespas), Veneno Real (cd 10s, Poison forte) | Geleia Real 60%, Aguilhao Real 25%, Card Mae Vespa 1.5% |

### 2.3 Boss

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B1 | [BOSS] Espirito Ancião da Floresta | Spirit | Ethereal | Caster | Wind | Magic | 1500 | 60 | 25 | 0.6/s | Raizes Famintas (cd 12s, Stun 3s + DoT), Cura da Floresta (cd 30s, +20% HP), Furacao Verde (cd 25s, AoE) | Coracao Antigo 100%, Vara da Floresta (Epic) 25%, Card Espirito Ancião 100%, chance Pet "Filhote do Bosque" 3% |

[PLACEHOLDER: Shiny variants — Slime Verde Shiny, Lobo Faminto Shiny, Espirito Ancião Shiny — versoes douradas]
[PLACEHOLDER: Transcendido variants pos-Transcendencia — todos os 14 inimigos da Floresta ganham versao transcendida com novo elemento e tag]

---

## 3. Zona 2 — Deserto

Tema: dunas, ruinas enterradas, sol intenso. Cidade Beduina abandonada.

### 3.1 Comuns

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 12 | Escorpiao do Deserto | Insect | Burrowing | Melee | None | Pierce | 90 | 22 | 5 | 0.9/s | Cauda Toxica (cd 6s, Poison + DoT) | Casca de Escorpiao 50%, Veneno de Cauda 25% |
| 13 | Coiote | Animal | Grounded | Melee | None | Lacerate | 100 | 26 | 4 | 1.1/s | Bote em Grupo (cd 8s, +50% dano se 2+ coiotes) | Pele Seca 40%, Dente de Coiote 20% |
| 14 | Mumia Recente | Undead | Grounded | Melee | None | Crush | 130 | 24 | 8 | 0.6/s | Bandagem Faminta (cd 7s, Lifesteal self) | Bandagem Antiga 60%, Resina Funeraria 15% |
| 15 | Cobra das Areias | Animal | Burrowing | Melee | None | Stab | 75 | 28 | 3 | 1.0/s | Bote Veloz (cd 4s, Pierce), Olhar Hipnotico (cd 12s, Confused) | Pele de Cobra 45%, Veneno de Serpe 20% |
| 16 | Bandido das Dunas | Human | Grounded | Ranged | None | Pierce | 110 | 20 | 5 | 0.8/s | Tiro de Besta (cd 5s), Bomba de Areia (cd 14s, Blind AoE) | Couro Bandido 40%, Cobre 50% |
| 17 | Espirito de Areia | Spirit | Ethereal | Caster | Wind | Magic | 95 | 32 | 4 | 0.7/s | Sopro de Tempestade (cd 9s, Slowed AoE) | Cristal de Areia 30%, Essencia Calida 12% |
| 18 | Caranguejo Gigante | Animal | Grounded | Tank | Water | Crush | 160 | 28 | 14 | 0.5/s | Pinca Esmagadora (cd 7s, Stun) | Casca Quebradica 50%, Carne de Caranguejo 35% |
| 19 | Abutre de Penas Negras | Bird | Flying | Ranged | None | Lacerate | 80 | 30 | 4 | 1.0/s | Mergulho (cd 6s, +80% dano), Grito Estridente (cd 12s, Silence) | Pena Negra 55%, Bico de Abutre 20% |
| 20 | Mago Bandido | Human | Grounded | Caster | Fire | Magic | 100 | 36 | 6 | 0.7/s | Bola de Fogo (cd 5s, Burning), Escudo de Areia (cd 18s, Shielded) | Tomo Riscado 25%, Po de Brasa 30% |
| 21 | Aranha do Cripta | Insect | Climbing | Melee | None | Stab | 85 | 26 | 5 | 1.1/s | Teia (cd 8s, Slowed), Mordida Toxica (cd 5s, Poison) | Seda de Aranha 50%, Glandula de Veneno 15% |
| 22 | Salamandra Solar | Elemental | Grounded | Caster | Fire | Magic | 130 | 34 | 7 | 0.7/s | Lufada Quente (cd 6s, Burning), Pele de Brasa (cd 18s, Thorns) | Pele de Salamandra 60%, Pedra do Fogo 25% |

### 3.2 Elites

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E3 | [ELITE] Senhor Bandido das Dunas | Human | Grounded | Berserker | Fire | Lacerate + Pierce | 480 | 60 | 14 | 1.0/s | Tiro Trovejante (cd 8s, Stun chance), Reagrupar (cd 25s, summon 2 bandidos) | Drop comum x3 + Adagas Gemeas Sussurrantes (Epic) 12%, Card Senhor Bandido 1.5% |
| E4 | [ELITE] Salamandra Real | Elemental | Grounded | Caster | Fire | Magic | 520 | 65 | 18 | 0.7/s | Coluna de Magma (cd 12s, AoE Burning), Pele de Brasa Maior (cd 20s, Thorns + Reflect) | Coracao da Salamandra 60%, Pedra Vulcanica 30%, Card Salamandra Real 1.5% |

### 3.3 Boss

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B2 | [BOSS] Faraó Esquecido | Undead | Grounded | Caster | Fire | Magic + Crush | 3200 | 95 | 40 | 0.6/s | Praga Real (cd 14s, Curse + DoT AoE), Bandagens Estrangulantes (cd 10s, Stun + Lifesteal), Convoca Mumias (cd 30s, +3 mumias), Olhar do Faraó (cd 25s, Petrified 4s alvo unico) | Coroa do Faraó 100%, Cetro Real (Epic) 30%, Card Faraó 100%, chance Pet "Escaravelho de Ouro" 3% |

[PLACEHOLDER: Shiny variants Zona 2]
[PLACEHOLDER: Transcendido variants Zona 2]

---

## 4. Zona 3 — Caverna

Tema: galerias subterraneas, gemas brutas no teto, lava distante, ecos. Mineracao acelerada.

### 4.1 Comuns

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 23 | Morcego Sanguineo | Animal | Flying | Melee | None | Pierce | 100 | 35 | 5 | 1.5/s | Drenagem (cd 5s, Lifesteal +20%) | Asa Coriacea 50%, Sangue de Morcego 25% |
| 24 | Aranha de Cristal | Insect | Climbing | Caster | None | Magic + Stab | 120 | 40 | 7 | 1.0/s | Teia Cristalina (cd 8s, Slowed + Reflect), Picada Cristal (cd 6s, Bleeding) | Cristal Bruto 30%, Glandula de Cristal 15% |
| 25 | Anão Mineiro Possuido | Human | Grounded | Melee | None | Crush | 180 | 45 | 12 | 0.7/s | Picareta Furiosa (cd 6s, Crit chance up) | Picareta Velha 30%, Ferro Bruto 35% |
| 26 | Golem de Pedra | Golem | Grounded | Tank | Rock | Crush | 280 | 50 | 25 | 0.4/s | Punho de Pedra (cd 8s, Stun chance), Couraca Mineral (cd 18s, DEF Up) | Fragmento de Pedra 70%, Nucleo Pequeno 20% |
| 27 | Slime de Acido | Slime | Grounded | Melee | None | Blunt | 160 | 38 | 10 | 0.7/s | Ondulacao Acida (cd 7s, Broken Armor) | Goo Acido 60%, Fragmento Corrosivo 20% |
| 28 | Verme Cego | Aberration | Burrowing | Melee | None | Crush | 220 | 48 | 15 | 0.5/s | Investida Subterranea (cd 9s, Stun) | Pele de Verme 40%, Mucosa Cega 25% |
| 29 | Caverna Espreitadora | Aberration | Climbing | Melee | None | Lacerate | 150 | 52 | 8 | 1.1/s | Salto Predador (cd 6s), Mordida Crocante (cd 5s, Bleeding) | Olho de Espreitadora 30%, Garra Faminta 35% |
| 30 | Goblin Engenheiro | Human | Grounded | Ranged | Fire | Pierce + Lacerate | 130 | 50 | 9 | 0.9/s | Bomba (cd 12s, AoE Burning), Trabuco (cd 5s) | Engrenagem 40%, Polvora Bruta 25% |
| 31 | Espirito de Mina | Spirit | Ethereal | Caster | Rock | Magic | 140 | 55 | 8 | 0.7/s | Lanca de Pedra (cd 6s), Choradeira (cd 15s, Curse) | Lampião Antigo 25%, Essencia da Pedra 15% |
| 32 | Salamandra de Magma | Elemental | Grounded | Melee | Fire | Lacerate | 200 | 56 | 14 | 0.8/s | Cauda Flamejante (cd 6s, Burning), Sopro de Magma (cd 14s, AoE) | Pele Vulcanica 50%, Pedra de Magma 20% |
| 33 | Troll Subterraneo | Human | Grounded | Tank | Rock | Crush | 320 | 55 | 22 | 0.4/s | Pancada Pesada (cd 9s, Stun), Regenera (cd 25s, Health Regen forte) | Pele de Troll 45%, Sangue de Troll 25% |

### 4.2 Elites

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E5 | [ELITE] Golem do Cristal Maior | Golem | Grounded | Tank | None | Crush + Magic | 880 | 95 | 45 | 0.5/s | Salva de Cristais (cd 10s, AoE Pierce), Couraca Cristalina (cd 22s, Reflect + Shielded) | Cristal Maior 60%, Nucleo Cristalino 30%, Card Golem do Cristal Maior 1.5% |
| E6 | [ELITE] Verme Devorador | Aberration | Burrowing | Berserker | None | Crush + Lacerate | 950 | 105 | 35 | 0.6/s | Dilaceracao (cd 5s, Bleeding stack +6), Mergulho na Terra (cd 18s, Untouchable 4s) | Mucosa Real 60%, Glandula Devoradora 30%, Card Verme Devorador 1.5% |

### 4.3 Boss

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B3 | [BOSS] Senhor das Profundezas | Dragon | Grounded | Caster | Fire | Magic + Crush | 5800 | 140 | 60 | 0.5/s | Sopro Vulcanico (cd 12s, AoE Burning), Cauda Trituradora (cd 8s, Stun + Crush), Convoca Salamandras (cd 25s, +3), Erupção Plena (cd 35s, AoE forte + Burning longo) | Escama Vulcanica 100%, Cajado do Magma (Epic) 30%, Card Senhor das Profundezas 100%, chance Pet "Drago de Bolso" 3% |

[PLACEHOLDER: Shiny variants Zona 3]
[PLACEHOLDER: Transcendido variants Zona 3]

---

## 5. Zona 4 — Pantano

Tema: agua estagnada, neblina, raizes torcidas, doencas. Crafters de Alquimia tem afinidade.

### 5.1 Comuns

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 34 | Sapo Toxico | Animal | Aquatic | Caster | Water | Magic | 200 | 60 | 10 | 0.6/s | Cuspe Acido (cd 7s, Broken Armor), Salto Toxico (cd 9s, Poison) | Pele de Sapo 60%, Veneno Verde 25% |
| 35 | Lobisomem do Pantano | Animal | Grounded | Berserker | None | Lacerate | 280 | 70 | 14 | 1.0/s | Uivo Lunar (cd 14s, Berserker self), Mordida (cd 5s, Bleeding stack) | Pelo Encharcado 45%, Garra Lupina 30% |
| 36 | Necromante Errante | Undead | Grounded | Summoner | None | Magic | 220 | 65 | 12 | 0.7/s | Convoca Esqueleto (cd 18s, +2), Drenar Vida (cd 8s, Lifesteal) | Robe Funebre 40%, Po de Esqueleto 30% |
| 37 | Fungo Putrido | Plant | Grounded | Caster | None | Magic | 180 | 55 | 10 | 0.6/s | Esporo Putrido (cd 8s, Poison + Confused), Raizes (cd 12s, Slowed AoE) | Cogumelo Putrido 60%, Esporo Negro 20% |
| 38 | Crocodilo Pantanal | Animal | Aquatic | Tank | Water | Crush + Lacerate | 380 | 70 | 22 | 0.5/s | Mordida Esmagadora (cd 8s, Stun + Bleeding) | Couro de Crocodilo 50%, Dente Curvo 25% |
| 39 | Caracol de Limo | Slime | Grounded | Tank | Water | Blunt | 320 | 50 | 28 | 0.3/s | Concha Reflectora (cd 18s, Reflect 50%) | Concha Espessa 45%, Limo Espesso 30% |
| 40 | Erva Daninha Carnivora | Plant | Grounded | Melee | None | Lacerate | 240 | 68 | 12 | 0.8/s | Mordida Floral (cd 6s), Cipó Estrangulador (cd 10s, Stun) | Cipó Faminto 50%, Polen Vermelho 20% |
| 41 | Ghoul do Brejo | Undead | Grounded | Berserker | None | Slash | 260 | 75 | 13 | 1.0/s | Garra Putrida (cd 5s, Bleeding + Poison) | Pele Putrida 50%, Garra de Ghoul 25% |
| 42 | Larva Gigante | Insect | Grounded | Melee | None | Crush | 200 | 60 | 16 | 0.6/s | Mordida Espessa (cd 6s) | Casulo Verde 50%, Geleia Larval 25% |
| 43 | Espirito do Brejo | Spirit | Ethereal | Caster | Water | Magic | 220 | 75 | 11 | 0.8/s | Maldição da Brisa (cd 10s, Curse), Cura Negra (cd 18s, Self Lifesteal) | Essencia Sombria 30%, Velo do Brejo 15% |
| 44 | Hidra Pequena | Dragon | Aquatic | Caster | Water | Magic + Stab | 350 | 80 | 18 | 0.7/s | Tres Sopros (cd 12s, AoE Water), Mordida Tripla (cd 6s, Bleeding stack +3) | Escama Verde 50%, Dente de Hidra 30% |
| 45 | Bruxa do Pantano | Human | Grounded | Caster | None | Magic | 230 | 78 | 12 | 0.7/s | Caldeirao Borbulhante (cd 10s, AoE Poison), Maldição Maior (cd 16s, Curse forte) | Caldeirao Quebrado 25%, Po Bruxesco 35% |

### 5.2 Elites

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E7 | [ELITE] Lobisomem Alpha | Animal | Grounded | Berserker | None | Lacerate + Crush | 1300 | 145 | 35 | 1.1/s | Uivo da Alcateia (cd 18s, +2 lobisomens), Frenesi Sangrento (cd 12s, Berserker forte), Mordida Devastadora (cd 5s, Bleeding stack +8) | Pelo Alpha 70%, Coracao Lupino 40%, Card Lobisomem Alpha 1.5% |
| E8 | [ELITE] Hidra Tripla | Dragon | Aquatic | Caster | Water | Magic + Stab | 1450 | 155 | 40 | 0.7/s | Tres Sopros Maiores (cd 10s, AoE), Regeneracao da Cabeça (cd 25s, +30% HP), Mordida Tripla Maior (cd 6s, Bleeding stack +6) | Escama Real 70%, Coracao Multiple 35%, Card Hidra Tripla 1.5% |

### 5.3 Boss

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B4 | [BOSS] Mãe das Pragas | Aberration | Grounded | Summoner | None | Magic + Lacerate | 9500 | 200 | 80 | 0.5/s | Praga em Massa (cd 14s, Poison forte AoE), Convoca Larvas (cd 20s, +5), Cuspe Devorador (cd 9s, Broken Armor + Bleeding), Casulo Defensivo (cd 30s, Shielded forte 8s) | Coracao Pulsante 100%, Vara do Pescador do Abismo (Legendary) 25%, Card Mãe das Pragas 100%, chance Pet "Larva de Estimacao" 3% |

[PLACEHOLDER: Shiny variants Zona 4]
[PLACEHOLDER: Transcendido variants Zona 4]

---

## 6. Zona 5 — Tundra

Tema: gelo, neve constante, vento cortante, ruinas de civilizacao gelada.

### 6.1 Comuns

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 46 | Lobo Branco | Animal | Grounded | Melee | Ice | Lacerate | 350 | 90 | 18 | 1.0/s | Mordida Gelida (cd 5s, Slowed) | Pele Branca 50%, Presa Gelida 30% |
| 47 | Yeti Filhote | Animal | Grounded | Tank | Ice | Crush | 480 | 100 | 30 | 0.5/s | Esfregada de Neve (cd 8s, Stun chance), Bola de Neve (cd 14s, AoE Slowed) | Pelo Felpudo 50%, Bola de Gelo 25% |
| 48 | Mago do Gelo | Human | Grounded | Caster | Ice | Magic | 320 | 110 | 16 | 0.7/s | Pico Gelado (cd 6s, Pierce), Tempestade de Gelo (cd 14s, AoE + Slowed) | Tomo Gelido 30%, Po de Cristal 35% |
| 49 | Esqueleto Gelado | Undead | Grounded | Melee | Ice | Slash | 380 | 95 | 22 | 0.8/s | Lamina Gelada (cd 6s, Slowed) | Osso Congelado 60%, Espada Quebrada 20% |
| 50 | Pinguim Guerreiro | Bird | Aquatic | Melee | Ice | Stab | 280 | 105 | 20 | 0.9/s | Lança de Gelo (cd 5s, Pierce) | Pena Gelida 60%, Pequena Lança 25% |
| 51 | Urso Polar | Animal | Grounded | Tank | Ice | Crush + Lacerate | 600 | 110 | 35 | 0.5/s | Garra Branca (cd 6s, Bleeding), Rugido Gelado (cd 16s, Atk Up + Frio AoE) | Pele Polar 50%, Garra Cristalina 30% |
| 52 | Espirito Glacial | Spirit | Ethereal | Caster | Ice | Magic | 330 | 115 | 18 | 0.7/s | Sopro Antartico (cd 9s, AoE Slowed + Freeze chance) | Essencia Glacial 30%, Cristal Errante 15% |
| 53 | Mamute Pequeno | Animal | Grounded | Tank | Ice | Crush | 720 | 115 | 40 | 0.4/s | Pisao (cd 8s, Stun AoE), Trombada (cd 14s, Knockback) | Marfim 50%, Pelo Lanudo 35% |
| 54 | Caçador da Tribo do Gelo | Human | Grounded | Ranged | Ice | Pierce + Lacerate | 360 | 120 | 19 | 0.8/s | Flecha Congelante (cd 6s, Slowed), Trapa de Gelo (cd 14s, Petrified 3s) | Couro Tribal 50%, Flecha Gelada 30% |
| 55 | Lince Cristalino | Animal | Grounded | Melee | Ice | Slash | 320 | 130 | 16 | 1.2/s | Salto Gelido (cd 7s, Crit Up), Pelo Cristal (passivo: Thorns 5%) | Pelo Cristalino 45%, Garra Cristalina 25% |
| 56 | Senhor da Geleira | Elemental | Grounded | Caster | Ice | Magic | 420 | 125 | 25 | 0.6/s | Pilar de Gelo (cd 10s, Stun), Aura Congelante (passivo: Slowed em adjacentes) | Coracao Gelado 30%, Pedra Glacial 25% |

### 6.2 Elites

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E9 | [ELITE] Yeti Adulto | Animal | Grounded | Tank | Ice | Crush + Blunt | 2200 | 220 | 75 | 0.4/s | Trovao da Tundra (cd 12s, Stun AoE), Soco de Gelo (cd 6s, Freeze chance), Pele Endurecida (cd 25s, DEF Up forte) | Pelo de Yeti 70%, Coracao Quente 40%, Card Yeti Adulto 1.5% |
| E10 | [ELITE] Mago Glacial Mestre | Human | Grounded | Caster | Ice | Magic | 1900 | 240 | 50 | 0.7/s | Tempestade Polar (cd 14s, AoE forte + Freeze), Domo de Gelo (cd 22s, Shielded + Reflect), Mil Picos (cd 11s, Multi-hit Pierce) | Tomo Glacial 70%, Po de Estrela Fria 35%, Card Mago Glacial Mestre 1.5% |

### 6.3 Boss

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B5 | [BOSS] Avatar do Inverno | Elemental | Grounded | Caster | Ice | Magic + Crush | 16000 | 300 | 110 | 0.5/s | Inverno Eterno (cd 18s, AoE Freeze 4s), Punho da Geleira (cd 8s, Stun + Crush), Convoca Espirito Glacial (cd 25s, +3), Renascimento Polar (cd 60s, +25% HP) | Coracao do Inverno 100%, Calcas do Avatar do Vento (Legendary) 25%, Card Avatar do Inverno 100%, chance Pet "Filhote Glacial" 3% |

[PLACEHOLDER: Shiny variants Zona 5]
[PLACEHOLDER: Transcendido variants Zona 5]

---

## 7. Zona 6 — Templo Celestial

Tema: nuvens douradas, mosaicos solares, anjos vigilantes, ar rarefeito. Pre-Constelacao.

### 7.1 Comuns

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 57 | Querubim Aprendiz | Angel | Flying | Caster | Light | Magic | 500 | 150 | 28 | 0.7/s | Lança Solar (cd 6s, Pierce + Light) | Pena Dourada 50%, Po de Estrela 25% |
| 58 | Cao Celestial | Animal | Grounded | Melee | Light | Slash | 480 | 160 | 25 | 1.0/s | Mordida Radiante (cd 5s, Burning Light) | Pelo Dourado 50%, Garra Sagrada 25% |
| 59 | Sentinela Cromada | Construct | Grounded | Tank | Light | Crush | 720 | 165 | 50 | 0.4/s | Punho Cromado (cd 7s, Stun), Reparo (cd 22s, Health Regen) | Placa Cromada 50%, Engrenagem Solar 25% |
| 60 | Espirito Solar | Spirit | Ethereal | Caster | Light | Magic | 460 | 175 | 28 | 0.6/s | Raio Sagrado (cd 6s, Burning), Aura Cegante (cd 16s, Blind AoE) | Essencia Solar 35%, Pingente Brilhante 12% |
| 61 | Harpia Celestial | Bird | Flying | Ranged | Light | Pierce | 420 | 180 | 22 | 1.0/s | Mergulho Solar (cd 7s, Crit Up), Grito Sagrado (cd 14s, Silence) | Pena Branca 60%, Bico Dourado 25% |
| 62 | Monge das Nuvens | Human | Grounded | Melee | Light | Blunt | 500 | 185 | 32 | 1.0/s | Soco Iluminado (cd 5s, Stun chance), Meditacao (cd 20s, MP regen + DEF Up) | Manto Sagrado 35%, Conta Brilhante 25% |
| 63 | Drago Branco Jovem | Dragon | Flying | Caster | Light | Magic + Crush | 800 | 200 | 45 | 0.6/s | Sopro de Luz (cd 12s, AoE Burning Light), Mergulho (cd 8s, Crush) | Escama Branca 60%, Coracao Brilhante 35% |
| 64 | Anjo Caido | Angel | Flying | Berserker | Dark | Slash + Lacerate | 580 | 210 | 30 | 0.9/s | Lamina Sombria (cd 5s, Bleeding), Asas Negras (cd 18s, Berserker self) | Pena Negra 50%, Coracao Caido 30% |
| 65 | Estatua Animada | Construct | Grounded | Tank | Light | Crush | 760 | 175 | 55 | 0.4/s | Pilar de Pedra Sagrada (cd 8s, Stun), Carapaça (passivo: DEF Up 5%) | Marmore Sagrado 60%, Joia Insertada 25% |
| 66 | Sacerdote Heretico | Human | Grounded | Caster | Dark | Magic | 480 | 195 | 28 | 0.7/s | Maldição Sagrada (cd 11s, Curse forte), Convoca Espirito Solar (cd 22s) | Robe Sagrado 35%, Po Heretico 30% |

### 7.2 Elites

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E11 | [ELITE] Serafim da Vigilia | Angel | Flying | Caster | Light | Magic | 3500 | 360 | 95 | 0.6/s | Coluna do Juízo (cd 12s, AoE Burning Light forte), Ressureicao (cd 28s, +1 angel comum), Lança da Verdade (cd 7s, Pierce ignorando DEF) | Pena Sagrada 70%, Sangue Dourado 40%, Card Serafim da Vigilia 1.5% |
| E12 | [ELITE] Drago Branco Adulto | Dragon | Flying | Tank | Light | Crush + Magic | 3800 | 380 | 110 | 0.5/s | Sopro de Luz Solar (cd 11s, AoE Burning Light), Cauda Cristalina (cd 8s, Stun forte), Aura Reflexiva (passivo: Reflect 30%) | Escama Real 70%, Coracao Brilhante Real 40%, Card Drago Branco Adulto 1.5% |

### 7.3 Boss

| # | Nome | Raca | Comportamento | Tipo combate | Elemento | Tipo ataque | HP | ATK | DEF | Atk Speed | Skills | Drops |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B6 | [BOSS] Arcanjo da Aurora | Angel | Flying | Caster | Light | Magic + Slash | 32000 | 500 | 180 | 0.5/s | Sentenca Final (cd 16s, dano fixo enorme single target), Coro Celestial (cd 24s, AoE Light + Burning), Asas Cegantes (cd 12s, AoE Blind + Stun), Bencao da Aurora (cd 35s, Self Health Regen forte + Shielded) | Pena Sagrada Real 100%, Espada do Avatar do Sol (Legendary) 25%, Card Arcanjo da Aurora 100%, chance Pet "Querubim Companheiro" 3% |

[PLACEHOLDER: Shiny variants Zona 6]
[PLACEHOLDER: Transcendido variants Zona 6]

---

## 8. Mob Slaughter — marcos por inimigo

| Tipo | Marcos | Bonus por marco |
|---|---|---|
| Comum | 10, 100, 1k, 10k, 100k, 1M kills | +5%, +10%, +20%, +35%, +50%, +75% dano vs ele |
| Elite | 1, 5, 25, 100, 500 | +10%, +25%, +50%, +75%, +100% dano vs ele |
| Boss | 1, 3, 10, 25, 50 | +15%, +35%, +60%, +90%, +150% dano vs ele |
| Shiny | 1 (apenas) | desbloqueia tudo do bestiario do shiny |

Em marcos altos: drop adicional desbloqueado (item exclusivo so dropa apos X kills). [DECISAO PENDENTE: definir quais inimigos tem drop adicional pos-100k]

---

## Termos novos introduzidos neste arquivo

- "Tag Transcendido" — quando criada, vira raca extra: Transcended.
- "Aura Reflexiva" — passivo que da Reflect % constante (sem cooldown).
- "Drop adicional desbloqueado" — drop exclusivo de Mob Slaughter alto.
