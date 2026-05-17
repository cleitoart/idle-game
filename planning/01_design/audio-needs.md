# Audio Needs - Catalogo de Audio

> Lista exaustiva de SFX, musica e voz que o usuario precisa entregar.
> Cada entrada possui: nome / duracao estimada / loop ou one-shot / prioridade (P0/P1/P2).
> Convencoes: arquivos OGG (musica) ou WAV (SFX curtos). Estrutura sugerida: `assets/audio/music/`, `assets/audio/sfx/`, `assets/audio/ambient/`, `assets/audio/voice/`.

---

## Convencoes globais

- **Musica:** OGG Vorbis 128-192 kbps stereo, normalizada -14 LUFS.
- **SFX:** WAV 44.1kHz mono (estereo se for spatial). Pico nao ultrapassar -6dB. Normalizacao por categoria para o jogo nao ter SFX que estoure outros.
- **Loops:** indicar pontos de loop no proprio arquivo (Vorbis comment LOOPSTART/LOOPLENGTH).
- **Naming:** `snake_case`, prefixo por categoria (`mus_`, `sfx_`, `amb_`, `voice_`).
- **[DECISAO PENDENTE: motivos musicais reutilizaveis]**: definir 1-2 leitmotifs que aparecam em musicas diferentes para coesao narrativa.
- **[DECISAO PENDENTE: existe voice acting?]** Padrao recomendado: nao no MVP (caro e dificil em PT-BR). P2 se tiver budget.

---

## 1. Musica

### 1.1 Tema por zona (loops longos)

6 zonas. Duracao ~2-3 minutos cada com loop perfeito.

| Nome | Zona | Tom sugerido | Prioridade |
|---|---|---|---|
| mus_zone_floresta | Floresta | flautas, cordas leves, percurso aventureiro | P0 |
| mus_zone_deserto | Deserto | sopros do oriente medio, percussao seca | P1 |
| mus_zone_caverna | Caverna | ambient com graves, ressonancia | P1 |
| mus_zone_pantano | Pantano | sintetico, atmosferico, sinistro | P2 |
| mus_zone_tundra | Tundra | piano + cordas, melancolico | P2 |
| mus_zone_templo | Templo | coro etereo, pads sagrados | P2 |

### 1.2 Tema de boss

(RESOLVIDO 2026-05-06 #6): **1 musica de boss POR ZONA**, compartilhada entre todos os bosses (estagio + zona + mini-bosses) daquela zona. 6 zonas = 6 musicas de boss totais no R1.0. NAO existe musica unica por boss individual.

- mus_boss_zone_floresta (~3min loop) — P1
- mus_boss_zone_deserto (~3min loop) — P1
- mus_boss_zone_caverna (~3min loop) — P1
- mus_boss_zone_pantano (~3min loop) — P2
- mus_boss_zone_tundra (~3min loop) — P2
- mus_boss_zone_templo (~3min loop) — P2

Total: 6 musicas de boss. (Boss final climatico, se for separado, entra como P2 unico ou e' substituido pelo `mus_boss_zone_templo`.)

### 1.3 Tema de dungeon

[DECISAO PENDENTE: 1 por dungeon ou tema generico?] Recomendacao: **1 tema generico de dungeon + 1 climatico para mythic**.

- mus_dungeon_generic (~3min loop) — P1
- mus_dungeon_mythic_climatic — P2

### 1.4 Tema de acampamento

[DECISAO PENDENTE: varia por estagio?] Recomendacao: **sim, um tema mais rico por estagio** — melhor sensacao de progresso.

- mus_camp_stage1_campsite (~2min, fogueira intima) — P0
- mus_camp_stage2_vilarejo (~2min, mais alegre, multidao leve) — P1
- mus_camp_stage3_cidade (~3min, urbano com mercado) — P2
- mus_camp_stage4_reino (~3min, marcial, glorioso) — P2
- mus_camp_stage5_imperio (~4min, epico, coros) — P2

### 1.5 Tema de menu / loja

- mus_menu_main (loop ~2min, calmo, identidade do jogo) — P0
- mus_shop_general (loop ~2min, comercial e amigavel) — P1
- mus_shop_eternidade (loop ~2min, misterioso, sugere premium) — P2
- mus_arena_lobby (loop ~2min, competitivo, percussivo) — P1

### 1.6 Tema de evento sazonal

4 eventos: Halloween / Natal / Carnaval / Aniversario.

- mus_event_halloween (~2min) — P2
- mus_event_natal (~2min) — P2
- mus_event_carnaval (~2min) — P2
- mus_event_aniversario (~2min) — P2

### 1.7 Combate climatico

- mus_combat_normal (~2min loop, energetico mas neutro) — P0
- mus_combat_kill_streak (variacao up-tempo do mus_combat_normal, dispara quando kill streak alta) — P1
- mus_combat_raid (~3min, marcial, frenetico) — P1
- mus_boss_final (climax do roadmap, ~5min, tematico) — P2

### Resumo musica

Total: ~25 faixas. P0 = 4 (mus_zone_floresta, mus_camp_stage1, mus_menu_main, mus_combat_normal). P1 = 8. P2 = 13.

---

## 2. SFX de combate

### 2.1 Hit por tipo de ataque

Cada um com 3-4 variacoes (para nao soar repetitivo).

| Nome | Variacoes | Duracao | Prioridade |
|---|---|---|---|
| sfx_hit_slash_a/b/c | 3 | 0.3s | P0 |
| sfx_hit_stab_a/b/c | 3 | 0.3s | P0 |
| sfx_hit_crush_a/b/c | 3 | 0.4s | P0 |
| sfx_hit_blunt_a/b/c | 3 | 0.3s | P0 |
| sfx_hit_magic_a/b/c | 3 | 0.5s | P0 |
| sfx_hit_pierce_a/b/c | 3 | 0.3s | P1 |
| sfx_hit_lacerate_a/b/c | 3 | 0.4s | P1 |

Total: 21 SFX.

### 2.2 Eventos de combate

| Nome | Duracao | Prioridade |
|---|---|---|
| sfx_crit_a/b | 0.4s | P0 |
| sfx_kill_a/b | 0.5s | P0 |
| sfx_block_a/b | 0.3s | P1 |
| sfx_dodge_a/b | 0.3s | P1 |
| sfx_hurt_player_a/b | 0.4s | P0 |
| sfx_hurt_enemy_humanoid | 0.3s | P0 |
| sfx_hurt_enemy_slime | 0.3s | P0 |
| sfx_hurt_enemy_beast | 0.3s | P1 |
| sfx_hurt_enemy_undead | 0.3s | P1 |
| sfx_death_player | 1s | P0 |
| sfx_death_enemy_humanoid | 0.6s | P0 |
| sfx_death_enemy_slime | 0.5s | P0 |
| sfx_death_enemy_beast | 0.7s | P1 |
| sfx_death_boss_climax | 2s | P1 |

### 2.3 Cast por elemento

8 elementos x 1 SFX cast curto (0.5s) + 1 SFX impacto (0.6s) = 16 SFX.

| Nome | Prioridade |
|---|---|
| sfx_cast_fire / sfx_impact_fire | P0 |
| sfx_cast_ice / sfx_impact_ice | P1 |
| sfx_cast_electric / sfx_impact_electric | P1 |
| sfx_cast_water / sfx_impact_water | P1 |
| sfx_cast_wind / sfx_impact_wind | P1 |
| sfx_cast_rock / sfx_impact_rock | P1 |
| sfx_cast_light / sfx_impact_light | P2 |
| sfx_cast_dark / sfx_impact_dark | P2 |

### 2.4 Status applied

| Nome | Duracao | Prioridade |
|---|---|---|
| sfx_status_poison_apply | 0.4s | P1 |
| sfx_status_burning_apply | 0.4s | P1 |
| sfx_status_freeze_apply | 0.5s | P1 |
| sfx_status_stun_apply | 0.4s | P1 |
| sfx_status_silence_apply | 0.4s | P2 |
| sfx_status_curse_apply | 0.5s | P2 |
| sfx_status_bleeding_tick | 0.2s | P1 |
| sfx_status_atk_up_apply | 0.4s | P1 |
| sfx_status_def_up_apply | 0.4s | P1 |
| sfx_status_shielded_apply | 0.5s | P1 |
| sfx_status_thorns_proc | 0.3s | P2 |
| sfx_status_reflect_proc | 0.3s | P2 |
| sfx_status_berserker_apply | 0.6s | P2 |
| sfx_status_extasis_apply | 0.7s | P2 |

### 2.5 Skills e combo

- sfx_skill_ready (notificacao, 0.3s) — P0
- sfx_skill_used_generic (0.4s) — P0
- sfx_skill_used_ult (1s, mais grandioso) — P1
- sfx_counter_proc (0.4s) — P2
- sfx_combo_finisher (1.2s) — P2
- sfx_buff_applied_generic (0.4s) — P0

### Resumo SFX combate

Total: ~70-80 entradas. P0 = ~25. P1 = ~35. P2 = ~20.

---

## 3. SFX de UI

### 3.1 Cliques

- sfx_ui_click_primary (0.1s) — P0
- sfx_ui_click_secondary (0.1s) — P0
- sfx_ui_click_cancel (0.1s) — P0
- sfx_ui_click_disabled_buzz (0.15s) — P0

### 3.2 Hover e modais

- sfx_ui_hover (0.05s, sutil) — P0
- sfx_ui_modal_open (0.3s) — P0
- sfx_ui_modal_close (0.3s) — P0

### 3.3 Navegacao

- sfx_ui_tab_change (0.15s) — P0
- sfx_ui_page_change (0.2s) — P1

### 3.4 Inputs

- sfx_ui_slider_drag (loop 0.05s) — P1
- sfx_ui_toggle_on (0.15s) — P0
- sfx_ui_toggle_off (0.15s) — P0
- sfx_ui_dropdown_open (0.2s) — P0

### 3.5 Notificacoes

- sfx_ui_notification_info (0.4s) — P0
- sfx_ui_notification_warning (0.4s, mais alerta) — P0
- sfx_ui_notification_error (0.5s, distintivo grave) — P0
- sfx_ui_reward_popup (1s, satisfacao) — P0
- sfx_ui_achievement_unlocked (1.5s, fanfarra curta) — P1

### 3.6 Inventario / itens

- sfx_ui_inventory_open (0.3s) — P0
- sfx_ui_inventory_close (0.3s) — P0
- sfx_ui_item_pickup (0.2s) — P0
- sfx_ui_item_pickup_rare (0.5s, sparkle) — P0
- sfx_ui_item_pickup_epic (0.7s) — P1
- sfx_ui_item_pickup_legendary (1s, sino + brilho) — P1
- sfx_ui_item_pickup_mythic (1.5s, coral curto) — P2
- sfx_ui_item_equipped (0.3s) — P0
- sfx_ui_item_unequipped (0.3s) — P0
- sfx_ui_item_sold (0.4s, moeda) — P0
- sfx_ui_item_destroyed (0.5s) — P1

### 3.7 Crafting

- sfx_ui_craft_start (0.5s) — P1
- sfx_ui_craft_success (1s) — P1
- sfx_ui_craft_fail (0.7s, melancolico) — P1
- sfx_ui_smelting_loop (loop 1s) — P1
- sfx_ui_sawmill_loop (loop 1s) — P1
- sfx_ui_alchemy_loop (loop 1s) — P1
- sfx_ui_cooking_loop (loop 1s) — P1

### Resumo SFX UI

Total: ~35 entradas. P0 = ~22. P1/P2 = restante.

---

## 4. SFX de loops curtos / eventos especiais

| Nome | Duracao | Prioridade |
|---|---|---|
| sfx_levelup | 1.5s | P0 |
| sfx_skill_point_gained | 0.4s | P0 |
| sfx_star_gained | 1s | P1 |
| sfx_awakening_unlock | 2s | P1 |
| sfx_renascimento_ritual | 5s (com fade) | P1 |
| sfx_transcendencia_ritual | 8s | P2 |
| sfx_ascensao_cosmica_ritual | 15s | P2 |
| sfx_constelacao_node_unlock | 1s | P1 |
| sfx_quest_accepted | 0.6s | P0 |
| sfx_quest_completed | 1.5s | P0 |
| sfx_achievement_unlocked | 1.5s | P1 |
| sfx_daily_reset | 0.8s | P1 |
| sfx_daily_reward_claim | 1.2s | P1 |
| sfx_codex_entry_unlocked | 0.5s | P1 |
| sfx_card_unlocked | 0.7s | P1 |
| sfx_card_corrupted_unlocked | 1s | P2 |
| sfx_card_greedy_unlocked | 2s | P2 |
| sfx_pet_egg_hatch | 1.5s | P2 |

Total: ~18 entradas.

---

## 5. SFX de gathering

| Nome | Duracao | Prioridade |
|---|---|---|
| sfx_mining_hit_a/b/c | 0.4s | P1 |
| sfx_mining_break_ore | 0.6s | P1 |
| sfx_woodcutting_chop_a/b/c | 0.4s | P1 |
| sfx_woodcutting_tree_fall | 1.2s | P1 |
| sfx_fishing_cast | 0.5s | P1 |
| sfx_fishing_nibble | 0.3s | P1 |
| sfx_fishing_catch | 0.7s | P1 |
| sfx_fishing_miss | 0.4s | P1 |
| sfx_herbalism_pluck_a/b | 0.3s | P1 |
| sfx_cooking_sizzle (loop) | 1s loop | P1 |
| sfx_cooking_boil (loop) | 1s loop | P2 |
| sfx_cooking_done_bell | 0.5s | P1 |
| sfx_alchemy_bubble (loop) | 1s loop | P2 |
| sfx_smithing_anvil_a/b | 0.4s | P1 |

Total: ~22 entradas. Maioria P1.

---

## 6. Ambient (loops longos para imersao)

Loops de 30-60 segundos sem ponto perceptivel.

| Nome | Prioridade |
|---|---|
| amb_forest_birds_wind | P0 (Floresta) |
| amb_desert_wind_dunes | P1 |
| amb_cave_drips_echo | P1 |
| amb_swamp_insects_water | P2 |
| amb_tundra_wind_cold | P2 |
| amb_temple_drone_pads | P2 |
| amb_camp_stage1_fire_crickets | P0 |
| amb_camp_stage2_village_chatter | P1 |
| amb_camp_stage3_city_market | P2 |
| amb_camp_stage4_kingdom_bells | P2 |
| amb_camp_stage5_imperio_grand | P2 |
| amb_dungeon_generic_creepy | P1 |
| amb_dungeon_mythic_climatic | P2 |
| amb_crowd_city_market_busy | P2 |

Total: ~14 entradas.

---

## 7. Stingers (cinematicos curtos)

Stingers de 1-3s para momentos transitorios.

| Nome | Duracao | Prioridade |
|---|---|---|
| sting_boss_appears | 2s | P1 |
| sting_raid_trigger | 2s | P1 |
| sting_elite_appears | 1.5s | P1 |
| sting_shiny_encounter | 2s (raro, marcante) | P2 |
| sting_critical_victory | 2.5s | P1 |
| sting_game_over_player_died | 3s | P2 |
| sting_daily_reset | 1.5s | P1 |
| sting_zone_first_clear | 2s | P1 |
| sting_dungeon_clear | 2.5s | P1 |
| sting_seasonal_event_starts | 2.5s | P2 |

Total: 10 stingers.

---

## 8. Voz (opcional, P2)

[DECISAO PENDENTE: jogo tera voice acting? Em PT-BR e custo significativo].

Caso sim, escopo minimo:

### 8.1 Frases curtas de NPCs principais

5-10 NPCs principais x 3-5 falas curtas = 15-50 clips.

Exemplos:
- voice_taverneiro_greeting_a/b/c
- voice_ferreiro_greeting_a/b/c
- voice_alquimista_greeting_a/b/c
- voice_quest_giver_intro_main_a-e
- voice_o_transcendido_intro

### 8.2 Reacoes de personagem

Por classe x 5 reacoes (level up, hurt, death, victory, idle-bark).
10 classes x 5 = 50 clips.

### 8.3 Bosses (lines de cinematic)

Cada boss x 2-4 falas. ~10 bosses x 3 = 30 clips.

Total voz (caso aprovado): ~100-130 clips. **Tudo P2** ou descartado.

---

## Resumo de prioridades

### P0 (MVP)

- Musica: 4 (mus_zone_floresta, mus_camp_stage1, mus_menu_main, mus_combat_normal).
- SFX combate: ~25 (hit basicos, crit, kill, hurt player/inimigo, death basicos, cast fogo, skill ready/used).
- SFX UI: ~22 (cliques, hover, modais, tabs, dropdown, toggles, notificacoes basicas, inventario, item pickup ate Rare).
- SFX especiais: levelup, skill_point_gained, quest_accepted, quest_completed.
- Ambient: 2 (amb_forest, amb_camp_stage1).

**Total P0: ~55-60 audio assets.**

### P1 (beta)

- 8 musicas (zonas adicionais, boss, dungeon, arena, vilarejo, kill streak, raid, eventos).
- SFX combate elemental + status applied + skills avancadas (~35).
- SFX gathering (~22).
- Ambient (~6).
- Stingers (~7).
- Especiais: renascimento, awakening, achievement, daily, codex.

**Total P1: ~120 entradas.**

### P2 (full)

- Musicas eventos sazonais + boss final + ambient cidade/imperio.
- SFX shiny/greedy + transcendencia + ascensao.
- Voice acting (se aprovado).

**Total P2: ~80+ entradas (mais voice se aprovado).**

---

## Total geral estimado

**~250-280 audio assets** (sem voice acting).
**~350-410** (com voice acting completo).

Recomendacao: contratar musico para pacote tematico (musicas + ambient + stingers de uma zona como entrega unica) e SFX em librarie comercial (Synty, GameDev Market) para preencher rapido.

---

## Decisoes pendentes consolidadas

1. **[DECISAO PENDENTE: leitmotifs reutilizaveis]** — definir 1-2 motivos centrais.
2. **[DECISAO PENDENTE: voice acting]** — sim/nao? Em PT-BR, EN ou ambos?
3. ~~Tema de boss compartilhado por zona ou unico~~ (RESOLVIDO 2026-05-06 #6: 1 musica por zona, compartilhada. 6 musicas de boss totais no R1.0).
4. **[DECISAO PENDENTE: tema de dungeon generico ou por dungeon]**.
5. **[DECISAO PENDENTE: tema de acampamento varia por estagio]** — recomendado sim.
6. **[DECISAO PENDENTE: SFX de element-locked] - cada arma elemental tem hit-sfx proprio ou compartilha?**
