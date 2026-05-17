# Tabelas de Balanceamento

> Tabela mestra: 6 zonas x 10 estagios x 8 areas = 480 linhas. Para legibilidade, agrupado por zona com sub-tabela por estagio (estagio = 1 linha consolidada com area baixa/media/alta + boss).

## 0. Recommended Player Level por Zona

| Zona | Bioma | Player Level | T-level minimo |
|---:|---|---:|---:|
| Z1 | Floresta | 1 - 25 | T0 |
| Z2 | Deserto | 25 - 75 | T0 |
| Z3 | Caverna | 75 - 150 | T0 |
| Z4 | Pantano | 150 - 300 | T0 |
| Z5 | Vulcao | 300 - 600 | T0 |
| Z6 | Ruinas Antigas | 600 - 1000 | T0 |

Pos-Transcendencia (T1+), todas as zonas ganham versao "Corrupted" com stats do inimigo x4 e drops com chance de versao "transcended".

---

## 1. Formula que Gera a Tabela

Para regerar em planilha (Google Sheets, Excel) ou em script, esta e a formula que produz cada linha:

```gdscript
func generate_balance_row(zone: int, stage: int, area: int) -> Dictionary:
    # Nivel do inimigo na area
    var enemy_level = enemy_level_for_area(zone, stage, area)
    # Stats do inimigo na area (formula de progression-curves.md)
    var hp = enemy_hp(zone, stage, area, enemy_level)
    var atk = enemy_atk(zone, stage, area, enemy_level)
    var def = enemy_def(zone, stage, area, enemy_level)
    # Numero de inimigos na area (waves * inimigos_por_wave)
    var enemies_per_wave = waves_per_area(zone, stage, area)
    var enemies_total = enemies_per_wave * 5  # 5 inimigos por wave em media
    # Recommended player stats (DPS para clear em ~30s, HP para sobreviver 2 hits)
    var rec_player_lvl = recommended_player_level(zone, stage, area)
    var rec_dps = ceil(hp / 30.0)
    var rec_hp = atk * 4
    # Recompensas
    var gold_per_kill = gold_per_kill_for_zone(zone, enemy_level)
    var xp_per_kill = enemy_xp_reward(enemy_level)
    var gold_per_clear = gold_per_kill * enemies_total
    var xp_per_clear = xp_per_kill * enemies_total
    var clear_time_sec = enemies_total / (rec_dps / hp * 60.0)  # estimativa simplista
    return {
        "zone": zone, "stage": stage, "area": area,
        "enemy_level": enemy_level,
        "rec_player_level": rec_player_lvl,
        "rec_dps": int(rec_dps),
        "rec_hp": int(rec_hp),
        "enemy_hp": hp, "enemy_atk": atk, "enemy_def": def,
        "gold_per_clear": int(gold_per_clear),
        "xp_per_clear": int(xp_per_clear),
        "clear_time_sec": int(clear_time_sec),
    }

func enemy_level_for_area(zone: int, stage: int, area: int) -> int:
    var base = recommended_player_level_min(zone)
    var range_size = recommended_player_level_max(zone) - base
    var progress = ((stage - 1) * 8 + (area - 1)) / 79.0  # 0..1 ao longo da zona
    return int(base + range_size * progress)

func recommended_player_level_min(zone: int) -> int:
    return [1, 25, 75, 150, 300, 600][zone - 1]

func recommended_player_level_max(zone: int) -> int:
    return [25, 75, 150, 300, 600, 1000][zone - 1]
```

`waves_per_area(zone, stage, area)` retorna entre 3-8 waves; areas mais avancadas tem mais waves. Por simplicidade aqui, assumimos 5 waves x 5 inimigos = 25 kills/area.

---

## 2. Zona 1: Floresta (Z1)

Bioma inicial. Tutorial de progressao. Inimigos: slimes, goblins, lobos, plantas.

### 2.1 Por estagio (resumo)

| Stage | Area baixa (A1) | Area media (A4) | Area alta (A8) | Boss A8 |
|---:|---|---|---|---|
| S1 | enemy lvl 1, HP 21, ATK 3, DEF 1 | lvl 2, HP 25, ATK 4, DEF 1 | lvl 3, HP 30, ATK 5, DEF 1 | mini-boss S1 (HP 60, drop garantido) |
| S2 | lvl 4, HP 30, ATK 5, DEF 1 | lvl 5, HP 36, ATK 6, DEF 1 | lvl 6, HP 43, ATK 7, DEF 2 | mini-boss S2 |
| S3 | lvl 7, HP 41, ATK 7, DEF 2 | lvl 9, HP 50, ATK 9, DEF 2 | lvl 10, HP 60, ATK 11, DEF 2 | mini-boss S3 |
| S5 | lvl 13, HP 70, ATK 13, DEF 3 | lvl 15, HP 84, ATK 16, DEF 3 | lvl 17, HP 100, ATK 19, DEF 3 | mini-boss S5 |
| S10 | lvl 22, HP 156, ATK 32, DEF 5 | lvl 24, HP 184, ATK 38, DEF 5 | lvl 25, HP 215, ATK 44, DEF 5 | **Boss Z1** (HP 4.300, ATK 88, DEF 10) |

### 2.2 Recompensas tipicas

| Stage | Gold/clear (area media) | XP/clear (area media) | Clear time est. (s) |
|---:|---:|---:|---:|
| S1 | 50 | 125 | 30 |
| S5 | 75 | 4.000 | 45 |
| S10 | 100 | 50.000 | 75 |

---

## 3. Zona 2: Deserto (Z2)

Inimigos: escorpioes, bandidos, dragoes-de-areia, golems de cristal.

### 3.1 Por estagio (resumo)

| Stage | Area baixa (A1) | Area media (A4) | Area alta (A8) | Boss A8 |
|---:|---|---|---|---|
| S1 | lvl 25, HP 295, ATK 47, DEF 5 | lvl 31, HP 355, ATK 56, DEF 6 | lvl 36, HP 425, ATK 67, DEF 6 | mini-boss S1 |
| S5 | lvl 50, HP 1.700, ATK 92, DEF 11 | lvl 56, HP 2.040, ATK 110, DEF 12 | lvl 62, HP 2.450, ATK 130, DEF 13 | mini-boss S5 |
| S10 | lvl 70, HP 7.000, ATK 240, DEF 19 | lvl 73, HP 8.400, ATK 285, DEF 21 | lvl 75, HP 10.000, ATK 340, DEF 22 | **Boss Z2** (HP 200.000, ATK 680, DEF 44) |

### 3.2 Recompensas

| Stage | Gold/clear (A4) | XP/clear (A4) | Clear est. (s) |
|---:|---:|---:|---:|
| S1 | 175 | 350.000 | 60 |
| S5 | 250 | 8M | 90 |
| S10 | 350 | 250M | 150 |

---

## 4. Zona 3: Caverna (Z3)

Inimigos: morcegos, mineradores, golems, dragoes de pedra, cogumelos venenosos.

### 4.1 Por estagio

| Stage | Area baixa (A1) | Area media (A4) | Area alta (A8) | Boss |
|---:|---|---|---|---|
| S1 | lvl 75, HP 1.800, ATK 280, DEF 22 | lvl 84, HP 2.200, ATK 335, DEF 24 | lvl 92, HP 2.640, ATK 400, DEF 27 | mini-boss S1 |
| S5 | lvl 110, HP 19.500, ATK 590, DEF 38 | lvl 116, HP 23.400, ATK 700, DEF 41 | lvl 122, HP 28.000, ATK 840, DEF 44 | mini-boss S5 |
| S10 | lvl 140, HP 80.000, ATK 1.520, DEF 65 | lvl 145, HP 96.000, ATK 1.820, DEF 70 | lvl 150, HP 115.000, ATK 2.180, DEF 75 | **Boss Z3** (HP 2,3M, ATK 4.360, DEF 150) |

### 4.2 Recompensas

| Stage | Gold/clear (A4) | XP/clear (A4) | Clear est. (s) |
|---:|---:|---:|---:|
| S1 | 600 | 50M | 120 |
| S5 | 900 | 1B | 180 |
| S10 | 1.300 | 30B | 240 |

---

## 5. Zona 4: Pantano (Z4)

Inimigos: trolls, espectros, plantas carnivoras, hidras, abominacoes.

### 5.1 Por estagio

| Stage | Area baixa (A1) | Area media (A4) | Area alta (A8) | Boss |
|---:|---|---|---|---|
| S1 | lvl 150, HP 18.000, ATK 1.620, DEF 75 | lvl 168, HP 22.000, ATK 1.940, DEF 82 | lvl 184, HP 26.500, ATK 2.330, DEF 90 | mini-boss S1 |
| S5 | lvl 225, HP 199.000, ATK 3.444, DEF 109 | lvl 240, HP 239.000, ATK 4.130, DEF 119 | lvl 254, HP 287.000, ATK 4.960, DEF 130 | mini-boss S5 |
| S10 | lvl 285, HP 800.000, ATK 8.700, DEF 175 | lvl 292, HP 960.000, ATK 10.400, DEF 191 | lvl 300, HP 1.150.000, ATK 12.500, DEF 209 | **Boss Z4** (HP 23M, ATK 25.000, DEF 418) |

---

## 6. Zona 5: Vulcao (Z5)

Inimigos: salamandras, demonios, fenix, magma elementals, dragoes de fogo.

### 6.1 Por estagio

| Stage | Area baixa (A1) | Area media (A4) | Area alta (A8) | Boss |
|---:|---|---|---|---|
| S1 | lvl 300, HP 175.000, ATK 8.500, DEF 200 | lvl 326, HP 210.000, ATK 10.200, DEF 220 | lvl 354, HP 252.000, ATK 12.300, DEF 240 | mini-boss S1 |
| S5 | lvl 450, HP 1.700.000, ATK 18.300, DEF 273 | lvl 470, HP 2.040.000, ATK 21.900, DEF 297 | lvl 488, HP 2.450.000, ATK 26.300, DEF 324 | mini-boss S5 |
| S10 | lvl 580, HP 6.700.000, ATK 45.000, DEF 437 | lvl 590, HP 8.000.000, ATK 54.000, DEF 477 | lvl 600, HP 9.700.000, ATK 65.000, DEF 521 | **Boss Z5** (HP 194M, ATK 130.000, DEF 1.040) |

---

## 7. Zona 6: Ruinas Antigas (Z6)

Inimigos: liches, golems ancestrais, sentinelas estelares, leviatas, primordials.

### 7.1 Por estagio

| Stage | Area baixa (A1) | Area media (A4) | Area alta (A8) | Boss |
|---:|---|---|---|---|
| S1 | lvl 600, HP 1.300.000, ATK 42.000, DEF 525 | lvl 632, HP 1.560.000, ATK 50.500, DEF 572 | lvl 666, HP 1.870.000, ATK 60.500, DEF 624 | mini-boss S1 |
| S5 | lvl 800, HP 12.500.000, ATK 87.000, DEF 575 | lvl 824, HP 15.000.000, ATK 105.000, DEF 627 | lvl 848, HP 18.000.000, ATK 126.000, DEF 683 | mini-boss S5 |
| S10 | lvl 980, HP 50.000.000, ATK 220.000, DEF 920 | lvl 990, HP 60.000.000, ATK 264.000, DEF 1.000 | lvl 1000, HP 72.000.000, ATK 320.000, DEF 1.090 | **Boss Final Z6** (HP 1,4B, ATK 640.000, DEF 2.180) |

---

## 8. Tabela Master Resumida (1 linha por zona)

| Zona | Player level esperado | DPS recomendado | HP recomendado | Gold/h estimado (auto, +0% bonus) | XP/h estimado |
|---:|---|---:|---:|---:|---:|
| Z1 | 1-25 | 50 | 200 | 6.000 | 1M |
| Z2 | 25-75 | 1.500 | 4.000 | 60.000 | 500M |
| Z3 | 75-150 | 30.000 | 30.000 | 500.000 | 100B |
| Z4 | 150-300 | 500.000 | 200.000 | 5M | 50T |
| Z5 | 300-600 | 8M | 1.500.000 | 50M | 50P |
| Z6 | 600-1000 | 100M | 12.000.000 | 500M | 5E |

(Sufixos: M=10^6, B=10^9, T=10^12, P=10^15, E=10^18.)

---

## 9. Justificativa de Premissas

### 9.1 5 inimigos por wave x 5 waves por area = 25 kills/area

Numero ajustavel por area mas como media basica e razoavel pra um auto-battle. Mais inimigos = clear mais lento = mais drops; menos = clear rapido = mais XP/min mas menos drops.

### 9.2 Boss = 50x stats do inimigo medio do estagio

Padrao de RPGs (Diablo, Pokemon). Boss precisa ser perceptivelmente diferente, exigir build especifico.

### 9.3 Recommended DPS = HP_medio_da_area / 30

Ou seja, jogador idealmente clear inimigo medio em 30 segundos. Auto-battle: jogador nao quer ver 3min de combate por mob comum, mas tambem nao quer 1-shot trivial. 30s da feedback de "estou progredindo".

### 9.4 Recommended HP = ATK_medio_do_inimigo * 4

Jogador deveria sobreviver 4 hits diretos. Permite que ataques ocasionais (esquiva falhar, blind) nao sejam sentence imediata.

---

## 10. Constantes para Cap

| Const | Valor | Justificativa |
|---|---:|---|
| Inimigos por wave | 3-7 (random, peso 5) | Variedade visual sem caos |
| Waves por area | 3-8 | Areas avancadas mais longas |
| Boss multiplier | 50x stat medio | Marco visual e mecanico |
| Mini-boss multiplier | 5-10x | Quebra ritmo sem gate hard |
| Elite spawn chance | 2-5% por wave | Surpresa raras, nao-bloqueante |
| Shiny spawn chance | 0.05% por wave | Ultra-raro, "pokemon shiny" |
