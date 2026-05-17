# Graphics Needs - Catalogo de Assets Visuais

> Lista exaustiva de TODOS os assets graficos que o usuario precisa entregar para que o projeto chegue do MVP ao end-game.
> Cada entrada possui: nome / dimensoes recomendadas / formato / prioridade / referencia de estilo.
> Prioridades: P0 (MVP, fase 0-1) | P1 (beta, fase 2-3) | P2 (full release, fase 4-5+).
> Conexoes: este arquivo cruza com `enemies-catalog.md`, `equipment-catalog.md`, `skills-catalog.md`, `pets-catalog.md`, `npcs-catalog.md`, `cards-catalog.md`, `events-catalog.md`.

---

## Convencoes globais

- **Formato base:** PNG 32-bit com alpha. Sprite-sheets em PNG ou Aseprite (.ase) caso o usuario prefira animar la e exportar.
- **Pixel-perfect.** Estilo de referencia atual (`assets/sprites/enemies/slime.png`, `assets/sprites/characters/warrior.png`) sugere pixel-art chibi com paleta de ~16-32 cores.
- **Sprite-sheet layout padrao:** uma linha por animacao, frames horizontais, todos do mesmo tamanho de celula.
- **Background parallax:** 3 layers separadas (sky / mid / fg). Cada layer 2-3x a largura da viewport para loop.
- **VFX e particulas:** PNG com fundo transparente, idealmente em sprite-sheet de 4-8 frames horizontal.
- **Naming convention:** `snake_case`, prefixo por categoria (`ui_`, `vfx_`, `enemy_`, `char_`, `item_`, etc.).
- **Tamanho do tile de combate (RESOLVIDO 2026-05-06):** VARIAVEL por inimigo. Cada inimigo declara seu tamanho no proprio `.tres`. Faixas oficiais:
  - Pequenos (slimes, ratos, criaturas baixas): 16-24 px.
  - Medios (humanoides comuns, lobos, goblins): 32-48 px.
  - Grandes (ogros, golems, elites): 64-96 px.
  - Mini-bosses e bosses: 128 px (ou maior caso o boss exija).
- **Orientacao de tela (RESOLVIDO 2026-05-06):** LANDSCAPE (desktop primeiro, Steam). Toda UI assume razao de aspecto wide. Portrait/mobile NAO sao alvo do Release 1.0.
- **[DECISAO PENDENTE: paleta global oficial].** Sugestao: criar `feedback-language.md` com paleta de 32 cores HEX e impor a todos os assets para coesao visual.

---

## 1. UI - Botoes

### 1.1 Botoes retangulares (texto + icone)

Estados (4): normal / hover / pressed / disabled.
Tamanhos (6): xs (60x24), s (90x32), m (140x40), l (200x52), xl (280x64), xxl (380x80).
Estilos (3): primary (acao positiva), secondary (neutro), danger (acao destrutiva/quebra).

Total: 4 x 6 x 3 = 72 sprites de botao retangular.

| Nome | Dimensoes | Formato | Prioridade | Referencia |
|---|---|---|---|---|
| ui_btn_rect_primary_xs_*4estados* | 60x24 | PNG 9-slice | P0 | `assets/sprites/ui/button_*.png` |
| ui_btn_rect_primary_s_*4estados* | 90x32 | PNG 9-slice | P0 | idem |
| ui_btn_rect_primary_m_*4estados* | 140x40 | PNG 9-slice | P0 | idem |
| ui_btn_rect_primary_l_*4estados* | 200x52 | PNG 9-slice | P0 | idem |
| ui_btn_rect_primary_xl_*4estados* | 280x64 | PNG 9-slice | P1 | idem |
| ui_btn_rect_primary_xxl_*4estados* | 380x80 | PNG 9-slice | P2 | idem |
| ui_btn_rect_secondary_*6tam_4est* | conforme | PNG 9-slice | P0/P1 | idem |
| ui_btn_rect_danger_*6tam_4est* | conforme | PNG 9-slice | P0 (m e l), P1 resto | idem |

### 1.2 Botoes circulares (icon-only)

Tamanhos (4): s (32), m (48), l (64), xl (96).
Estados (4): normal / hover / pressed / disabled.

Total: 16 sprites de moldura circular vazia. Usuario tambem precisara entregar os icones internos (ver secao 5).

[PLACEHOLDER: ui_btn_circle_<tamanho>_<estado>.png]

### 1.3 Toggle buttons

Estados (4): off-normal / off-hover / on-normal / on-hover.
Tamanhos (2): m (60x32), l (90x40).

Total: 8 sprites.

### 1.4 Tab buttons

Estados (3): normal / selected / hover.
Tamanhos (2): m (120x40), l (180x56).

Total: 6 sprites. Variantes para tabs verticais (sidebar) e horizontais (top-of-modal).

### 1.5 Botoes de paginacao

- ui_btn_page_prev (4 estados, 32x32)
- ui_btn_page_next (4 estados, 32x32)
- ui_btn_page_first (4 estados, 32x32)
- ui_btn_page_last (4 estados, 32x32)

Total: 16 sprites. P1.

---

## 2. UI - Sliders e inputs

### 2.1 Sliders

| Nome | Descricao | Prioridade |
|---|---|---|
| ui_slider_h_style1 | trilha + handle, estilo limpo | P0 |
| ui_slider_h_style2 | trilha + handle, estilo decorado | P1 |
| ui_slider_h_style3 | trilha com fill (range double) | P2 |
| ui_slider_v | vertical | P1 |

3 estilos x (trilha + handle 4 estados) = ~15 sprites.

### 2.2 Stepper +/-

- ui_stepper_minus (4 estados, 24x24)
- ui_stepper_plus (4 estados, 24x24)
- ui_stepper_input_frame (1 estado, 9-slice)

Total: 9 sprites. P0.

### 2.3 Search bar

- ui_searchbar_frame (9-slice 200x32) — P0
- ui_searchbar_icon_lupa (16x16) — P0
- ui_searchbar_icon_clear (16x16) — P0

### 2.4 Dropdown

- ui_dropdown_closed (9-slice) — P0
- ui_dropdown_open (9-slice) — P0
- ui_dropdown_arrow (12x12, 2 estados: down/up) — P0
- ui_dropdown_item_hover (9-slice) — P0

### 2.5 Checkbox e radio

- ui_checkbox_off / on / hover-off / hover-on / disabled (24x24 cada) — P0
- ui_radio_off / on / hover-off / hover-on / disabled (24x24 cada) — P0

Total: 10 sprites.

### 2.6 Spinner / loader

- ui_spinner_8frames (sprite-sheet 32x32 x 8) — P0
- ui_loader_circular_progress (sprite-sheet 16 frames 64x64) — P1

---

## 3. UI - Frames e bordas

### 3.1 Frames de modal

3 tamanhos: small (320x240), medium (520x400), large (800x600).
4 variantes de tema: combate / loja / codex / configuracoes.

Total: 12 frames 9-slice. P0 = combate small e medium; resto P1/P2.

### 3.2 Frames de slot (item / skill / card / pet) por raridade

6 raridades: Common / Uncommon / Rare / Epic / Legendary / Mythic.
4 tipos de slot: item / skill / card / pet.

Total: 24 frames 64x64 9-slice ou fixos. P0 = item Common-Rare; P1 = resto + skill + card; P2 = pet + Mythic completo.

Adicionais especiais:
- ui_slot_item_elite (frame corrupted, paleta roxa-corrosao) — P1
- ui_slot_item_greedy (frame dourado com brilho animado) — P2
- ui_slot_empty (placeholder vazio) — P0
- ui_slot_locked (placeholder cadeado) — P0

### 3.3 Tooltip

- ui_tooltip_frame (9-slice, fundo escuro semi-transparente) — P0
- ui_tooltip_arrow (12x8, aponta pra cima/baixo/esq/dir, 4 versoes) — P0

### 3.4 Banner / breadcrumb

- ui_banner_top (9-slice horizontal full-width) — P0
- ui_breadcrumb_separator (8x16) — P1

### 3.5 Header de painel

- ui_panel_header_frame (9-slice 100% width x 40px alt) — P0
- ui_panel_header_decor (ornamento opcional para titulos importantes, ex: nome de zona) — P1

### 3.6 Divider

- ui_divider_h_style1 (linha horizontal simples) — P0
- ui_divider_h_style2 (com ornamento central) — P1
- ui_divider_v_style1 — P1

### 3.7 Progress bars

3 estilos por tipo. Tipos: HP / MP / XP / kill_stack / mastery / evento / generic.

| Tipo | Cores sugeridas | Prioridade |
|---|---|---|
| ui_progressbar_hp_*3estilos* | vermelho-verde gradient + glow critico | P0 |
| ui_progressbar_mp_*3estilos* | azul-ciano | P0 |
| ui_progressbar_xp_*3estilos* | dourado/amarelo | P0 |
| ui_progressbar_kill_stack_*3estilos* | laranja com chamas | P1 |
| ui_progressbar_mastery_*3estilos* | esmeralda | P1 |
| ui_progressbar_event_*3estilos* | roxo/magenta com sparkle | P2 |
| ui_progressbar_generic_*3estilos* | branco neutro | P0 |

Cada um tem: frame_back + fill_layer + (opcional) shine_overlay. Total: ~21 sprites + variantes. **Referencia atual:** `scenes/combat/hp_bar.tscn`.

---

## 4. Particulas

Cada particula em PNG 32x32 (ou sprite-sheet 4-8 frames horizontal).

| Nome | Uso | Prioridade |
|---|---|---|
| vfx_particle_cross | hit basico | P0 (existe `cross_vfx000.png`) |
| vfx_particle_elipse | impacto | P0 (existe `elipse_vfx*.png`) |
| vfx_particle_spark | crit | P0 |
| vfx_particle_smoke_8f | dust em walk/dodge | P1 |
| vfx_particle_glow_halo | aura passiva | P1 |
| vfx_particle_damage_cross | dano grande | P0 |
| vfx_particle_heal_cross | cura | P0 |
| vfx_particle_crit_star | crit super | P0 |
| vfx_particle_levelup_burst_8f | level up | P0 |
| vfx_particle_drop_sparkle | item drop | P0 |
| vfx_particle_element_fire_8f | DoT/cast fogo | P1 |
| vfx_particle_element_ice_8f | freeze | P1 |
| vfx_particle_element_electric_8f | shock | P1 |
| vfx_particle_element_water_8f | water | P1 |
| vfx_particle_element_wind_8f | wind | P1 |
| vfx_particle_element_rock_8f | rock | P1 |
| vfx_particle_element_light_8f | light | P2 |
| vfx_particle_element_dark_8f | dark | P2 |

Total estimado: ~18 entradas (varias com 8 frames).

---

## 5. Efeitos de ataque (VFX)

Tamanho recomendado: 96x96 ou 128x128, sprite-sheet horizontal de 6-8 frames.

| Nome | Frames | Prioridade |
|---|---|---|
| vfx_atk_slash_v1 | 6 | P0 (existe `cut_vfx000.png`) |
| vfx_atk_slash_v2 | 6 | P1 |
| vfx_atk_slash_v3 | 6 | P1 |
| vfx_atk_stab | 5 | P0 |
| vfx_atk_crush | 6 | P0 |
| vfx_atk_blunt | 5 | P0 |
| vfx_atk_pierce | 5 | P1 |
| vfx_atk_lacerate | 7 | P1 |
| vfx_atk_magic_proj_fire | 6 | P0 |
| vfx_atk_magic_proj_ice | 6 | P1 |
| vfx_atk_magic_proj_electric | 6 | P1 |
| vfx_atk_magic_proj_water | 6 | P1 |
| vfx_atk_magic_proj_wind | 6 | P1 |
| vfx_atk_magic_proj_rock | 6 | P1 |
| vfx_atk_magic_proj_light | 6 | P2 |
| vfx_atk_magic_proj_dark | 6 | P2 |
| vfx_atk_combo_finisher_a | 10 | P2 |
| vfx_atk_combo_finisher_b | 10 | P2 |
| vfx_atk_aoe_explosion | 10 | P1 |
| vfx_def_shield_block | 6 | P1 |
| vfx_def_dodge_afterimage | 4 | P1 |

### 5.1 Status applied VFX

| Nome | Frames | Prioridade |
|---|---|---|
| vfx_status_poison_cloud | loop 6 | P1 |
| vfx_status_freeze_ice | loop 4 | P1 |
| vfx_status_burning_dot | loop 6 | P1 |
| vfx_status_bleeding_drip | loop 4 | P1 |
| vfx_status_stun_stars | loop 6 | P1 |
| vfx_status_silence_seal | loop 4 | P2 |
| vfx_status_petrified_grey | static overlay | P2 |
| vfx_status_curse_skull | loop 6 | P2 |
| vfx_status_shielded_aura | loop 8 | P1 |
| vfx_status_thorns_spikes | loop 6 | P2 |
| vfx_status_reflect_mirror | loop 6 | P2 |
| vfx_status_berserker_red_aura | loop 8 | P2 |
| vfx_status_extasis_white_glow | loop 8 | P2 |
| vfx_status_confused_swirl | loop 6 | P2 |
| vfx_status_atk_up | loop 4 | P1 |
| vfx_status_def_up | loop 4 | P1 |
| vfx_status_atk_up2 | loop 4 | P2 |
| vfx_status_atk_up3 | loop 4 | P2 |

Total VFX de ataque + status: ~38.

---

## 6. Icones

### 6.1 Skill icons (200+)

Dimensoes: 64x64 (com 4 estados de moldura: ready/cooldown/disabled/active).
Cada skill em `skills-catalog.md` precisa de 1 icone. Estimativa: 200+ skills considerando 10 classes x ~10 skills base + ~10 awakening por ramo.

Prioridade:
- P0: ~30 (skills basicas das primeiras 1-2 classes para MVP)
- P1: ~80 (todas classes base + primeiros ramos)
- P2: ~100+ (awakening completo, especialmente alta estrela)

[PLACEHOLDER: icone individual para cada skill — referenciar `skills-catalog.md`]

### 6.2 Status effect icons

Dimensoes: 32x32, com versao "stack count" (numero embutido).
Lista (baseada em roadmap 3.3): poison, burning, slowed, blind, bleeding, freeze, curse, stun, petrified, silence, disarm, weakness, broken_armor, hp_regen, mp_regen, atk_up, atk_up2, atk_up3, def_up, def_up2, def_up3, mag_atk_up, mag_def_up, vit_up, hit_up, crit_up, shielded, thorns, reflect, berserker, extasis, confused.

Total: ~32 icones. P0 = ~10 essenciais (poison, burning, atk_up, def_up, shielded, freeze, stun, hp_regen, weakness, broken_armor). P1 = restante.

### 6.3 Item icons (500+)

- Materiais (ver `gathering-materials.md`): minerios (~20), madeiras (~15), peixes (~25), ervas (~20), couros (~15), drops de inimigos (100+), ingredientes de cooking (~30) — ~225.
- Equipamento (ver `equipment-catalog.md`): cada arma/armadura unica = sprite proprio. Estimativa: 300+ equips.
- Consumiveis: pocoes (HP/MP curta/media/longa/full = ~10), buff (XP/drop/dano/dropele = ~12), comidas (~30), pergaminhos (~15), oleos (~10) = ~80.
- Cards: 60-90 (1 por inimigo unico).
- Ferramentas: 1 picareta + 1 machado + 1 vara por tier (~6 tiers cada) = 18.

Estimativa final: ~600 icones de item. Dimensoes: 32x32 ou 48x48.

Prioridade: P0 = 20 itens MVP (minerios basicos, madeira basica, slime goo, training_sword, basic_armor); P1 = 200; P2 = 400+.

### 6.4 Class icons

10 classes. 64x64. Versoes com moldura por estado de awakening (5+ ramos cada).
Total: 10 base + ~30 ramos = ~40 icones. P0 = 1 (warrior). P1 = 5. P2 = 40.

### 6.5 Zone icons

6 zonas (Floresta, Deserto, Caverna, Pantano, Tundra, Templo) — 64x64.
Total: 6. P0 = 2 (Floresta, Deserto, ja temos backgrounds). P1 = restante.

### 6.6 Element icons

8 elementos: Fire, Ice, Electric, Water, Wind, Rock, Light, Dark. 32x32.
Total: 8. P0 = 6 (sem Light/Dark). P2 = Light/Dark.

### 6.7 Attack-type icons

7 tipos: slash, stab, crush, blunt, magic, pierce, lacerate. 32x32.
Total: 7. P0 todos.

### 6.8 Stat icons

~20 stats: STR, DEX, INT, VIT, LUK, HP, MP, P.ATK, M.ATK, P.DEF, M.DEF, ATK_SPD, CAST_SPD, CDR, CRIT_CHANCE, CRIT_DMG, BLOCK, DODGE, HIT, ACC. 24x24.
Total: 20. P0 todos (stats expostos no UI).

### 6.9 Resource icons

- icon_gold (24x24) — P0
- icon_gems_eternidade (24x24) — P1
- icon_glory (24x24) — P1 (Arena)
- icon_dungeon_token (24x24) — P1
- icon_moeda_galactica (24x24) — P2
- icon_transcended_point (24x24) — P2
- icon_selo (24x24) — P1
- icon_chakra_point (24x24) — P1 (renascimento)

Total: 8 icones de moeda.

---

## 7. Sprites - Inimigos

Para cada inimigo em `enemies-catalog.md` (60-90 inimigos previstos):

### 7.1 Sprite-sheet padrao por inimigo comum

| Animacao | Frames | Notas |
|---|---|---|
| idle | 4 | loop |
| attack | 6 | one-shot |
| hurt | 2 | flash |
| death | 4 | one-shot, ultimo frame opaco-fade |

Dimensoes (RESOLVIDO 2026-05-06: tamanho VARIAVEL por inimigo):
- Pequenos (slimes, ratos, insetos): 16x16 a 24x24.
- Medios (goblins, lobos, humanoides comuns): 32x32 a 48x48.
- Grandes (golems, dragoes filhotes, elites pesados): 64x64 a 96x96.
- Mini-bosses e bosses: 128x128 (ou maior caso o boss exija).

Cada inimigo declara seu tamanho no proprio `.tres`. Sprite-sheet vertical: cada linha = uma animacao, 6 frames de largura. Total cell varia conforme dimensao escolhida.

### 7.2 Variacoes Elite

Para cada inimigo: paleta alternativa (mesmo sprite, hue-shifted +cor sangue/corrupcao) + overlay de aura (vfx_status_elite_aura, sprite-sheet loop 8 frames).

Total: 60-90 paletas Elite + 1 aura compartilhada.

### 7.3 Variacoes Shiny

Cada inimigo: paleta dourada + sparkle overlay (vfx_status_shiny_sparkle).

Total: 60-90 paletas Shiny + 1 sparkle compartilhado.

### 7.4 Bosses e mini-bosses

Bosses (1 por zona x 6 zonas + bosses de dungeon ~4) = 10. Cada um:
- idle (6f), attack_a (8f), attack_b (10f), special (12f), hurt (3f), death (8f).
- Dimensoes: 192x192 ou 256x256.

Mini-bosses (~3 por zona x 6 zonas) = ~18. Sprites ~96x96 com mesma estrutura mais simples.

### Resumo Inimigos

- Inimigos comuns: 60-90 sprite-sheets.
- Elite paletas: 60-90.
- Shiny paletas: 60-90.
- Mini-bosses: ~18.
- Bosses: ~10.

**Total entradas:** ~250 conjuntos.

Prioridade:
- P0: 4-6 sprite-sheets (slimes verde/roxo/vermelho ja existem como PNG estatico — precisam virar sprite-sheet animado; goblin; lobo; rato).
- P1: 30 inimigos completos com Elite.
- P2: catalogo completo + Shiny + bosses.

[PLACEHOLDER: animar slime_*.png ja existentes em sprite-sheet com 4 frames idle + 6 frames attack + 2 hurt + 4 death]

---

## 8. Sprites - Personagens

### 8.1 Sprite-sheet de combate por classe

10 classes: Warrior, Mage, Ranger, Rogue, Cleric, Monk, Berserker, Necromancer, Paladin, Bard. **[DECISAO PENDENTE: lista final de classes — `classes-and-characters.md` deve fechar isso].**

Por classe x ~5 estados de awakening (base + ramos 3* / 5* / 7* / 9* / 10*) = 50+ sprite-sheets.

Animacoes por sprite-sheet: idle (4f) / walk (6f) / attack_basic (6f) / cast (8f) / hurt (2f) / death (5f).

Dimensoes: 64x64 (mesma referencia do `warrior.png` atual).

Total: 10 classes x 5 estados = 50 sprite-sheets de combate.

### 8.2 Retratos (portraits) para UI

Dimensoes: 128x128 (versao detalhada para character_modal e roster overview).

10 classes x 5 estados = 50+ retratos. Versoes:
- portrait_<classe>_base
- portrait_<classe>_ramo_a_3star, portrait_<classe>_ramo_b_3star
- portrait_<classe>_ramo_a_5star, etc.

Versoes mini (32x32) para footer e roster compact.

### 8.3 Sprites de andar livremente no Acampamento

Cada classe precisa de uma versao "overworld" 4 direcoes (N/S/L/O) com walk loop. 24x24 ou 32x32 isometrico.

10 classes x 4 direcoes x 4 frames = 160 frames (16 sprite-sheets).

Prioridade: P1 (acampamento estagio Vilarejo).

### Resumo Personagens

- Combat sprite-sheets: 50.
- Portraits 128x128: 50.
- Portraits 32x32 mini: 50.
- Overworld walk sprites: 16 sprite-sheets.

**Total:** ~166 conjuntos.

Prioridade:
- P0: warrior base (existe), 1 ramo simbolico.
- P1: 5 classes base + ramos 3*.
- P2: catalogo completo.

---

## 9. Backgrounds

### 9.1 Zonas

6 zonas (parallax 3 layers cada): Floresta, Deserto, Caverna, Pantano, Tundra, Templo.

Por zona:
- bg_zone_<nome>_sky_layer (largura 2-3x viewport, altura full)
- bg_zone_<nome>_mid_layer
- bg_zone_<nome>_fg_layer

Total: 18 imagens.

P0: Floresta + Deserto (existem como `forest-bg000.png` e `desert-bg000.png` — precisam ser separados em layers ou refeitos em parallax).
P1: Caverna + Pantano.
P2: Tundra + Templo.

### 9.2 Boss arenas

1 por zona = 6 backgrounds especiais (dramatico, particulas ambientais).
Prioridade: P1 (Floresta/Deserto), P2 resto.

### 9.3 Dungeons

4 layouts iniciais: Cripta, Mina Profunda, Templo Submerso, Torre do Mago.
Cada um: 1 background tile + 3 layers parallax + arena de boss.

Total: 4 x 4 = 16 imagens. Prioridade P1/P2.

### 9.4 Acampamento

5 estagios: campsite / vilarejo / cidade / reino / imperio.
Cada estagio: 1 mapa isometrico ou top-down (1024x768 ou maior, com pontos de interacao marcados).

Total: 5 mapas. Cada estrutura individual e desenhada como sprite isolado para sobrepor:
- Fogueira, Bancada de Trabalho, Fornalha, Cozinha Simples (estagio 1) — 4 sprites.
- Forja, Alquimia, Casa de Plantio, Currais, Taverna (estagio 2 adicionais) — 5 sprites.
- Mercado, Guilda, Armazem (estagio 3 adicionais) — 3 sprites.
- Embaixadas, Catedral, Academia (estagio 4 adicionais) — 3 sprites.
- Portais, Fortaleza, Torre dos Sabios (estagio 5 adicionais) — 3 sprites.

Total estruturas: 18 sprites isolados + 5 mapas-base.

Prioridade: P0 = mapa-base estagio 1 + 4 estruturas. P1 = estagio 2-3. P2 = estagios 4-5.

---

## 10. Sprites - Pets

30+ pets em `pets-catalog.md`.

Por pet:
- sprite-sheet idle (4f) + 1 acao (6f). 32x32 ou 48x48.

Total: 30 pets x 2 anim = 30 sprite-sheets.

### 10.1 Egg sprites

8 variantes para hatching (paletas/padroes diferentes) + sprite-sheet hatching (6f). 32x32.

Total: 8 ovos + 1 hatching anim = 9 entradas.

Prioridade: P1 (pets sao mid-game).

---

## 11. Sprites - NPCs

25+ NPCs em `npcs-catalog.md`.

Por NPC:
- portrait 128x128 (modal de dialogo)
- sprite walking 32x32 (4 direcoes x 4 frames)
- sprite idle 32x32 (2 frames)

Total: 25 NPCs x 3 = 75 entradas.

Prioridade:
- P0: 3-5 NPCs do Acampamento estagio 1 (taverneiro, ferreiro, alquimista basico).
- P1: 15.
- P2: 25+.

---

## 12. Sprites - Items (equipamentos, materiais, consumiveis)

Coberto parcialmente em "Item icons" (secao 6.3). Repeticoes esperadas pois itens precisam de:

### 12.1 Equipamento equipavel (visual no personagem)

(RESOLVIDO 2026-05-06): SO A ARMA altera visualmente o personagem em batalha. Armaduras (capacete, peitoral, calcas, botas, acessorios) NAO TEM peca visual no personagem — aparecem somente no portrait do menu/inventario/character_modal. Personagem muda visual completo via SKIN COMPLETA (substitui sprite inteiro + retrato). Isso reduz drasticamente o volume de arte vs. o plano anterior layered.

Camadas oficiais:
- char_<classe>_base (corpo + animacoes idle/walk/atk/cast/hurt/death)
- equip_weapon_<id> (overlay simples por arma equipada, ancorado na mao do `char_<classe>_base`)
- equip_skin_full_<id> (skin completa que SUBSTITUI o `char_<classe>_base` + portrait correspondente)

REMOVIDO / NAO-NECESSARIO (decisao #3 resolvida):
- equip_helmet_<id> (sem visual no personagem)
- equip_chest_<id> (sem visual no personagem)
- equip_legs_<id> (sem visual no personagem)
- equip_boots_<id> (sem visual no personagem)
- equip_wings_<id> (sem visual no personagem; "asas" se existirem viram skin completa ou cosmetico de portrait)

Estimativa REVISADA:
- Armas com sprite distinto (overlay simples): ~30-60 sprites no R1.0 (1 por arma "icone visualmente distinta", varias armas reusam mesmo overlay).
- Skins completas: 1 por classe x ~5 estados de awakening + skins cosmeticas da Loja Eterna. Ver secao 8.
- Portraits de awakening: ver secao 8.2.

Prioridade no MVP: nao se preocupar com equipamento visual no personagem alem da arma; armaduras sao apenas icones de inventario/portrait.

### 12.2 Cards (frame + ilustracao)

Cada inimigo unico tem 1 card com:
- Frame por raridade (cobertos em 3.2)
- Ilustracao central 96x128 (estilo retrato do inimigo — pode reusar sprite com background colorido)

60-90 ilustracoes de card. Versao Corrupted (paleta) e Greedy (paleta dourada) reusam ilustracao.

---

## 13. Molduras de raridade

6 tiers x molduras (cobertos em 3.2 mas explicitando):

| Tier | Cor predominante | Borda |
|---|---|---|
| Common | Cinza-claro | linha simples |
| Uncommon | Verde | linha dupla |
| Rare | Azul | linha + ornamento |
| Epic | Roxo | linha + glow estatico |
| Legendary | Laranja-dourado | linha + glow animado |
| Mythic | Vermelho-ciano gradient | full ornamento + particulas |

Frames especiais:
- Frame Elite (Corrupted): paleta roxa-corrosao com fissuras animadas. P1.
- Frame Greedy (Shiny): dourado puro com sparkle animado constante. P2.

---

## 14. Banners / Logos / Splash

| Nome | Dimensoes | Prioridade |
|---|---|---|
| logo_jogo_main | 800x400 | P0 |
| logo_jogo_small | 200x100 | P0 |
| splash_screen_full | 1920x1080 | P0 |
| title_screen_bg | 1920x1080 | P0 |
| banner_evento_halloween | 800x300 | P2 |
| banner_evento_natal | 800x300 | P2 |
| banner_evento_carnaval | 800x300 | P2 |
| banner_evento_aniversario | 800x300 | P2 |
| loading_screen_lore_a | 1920x1080 | P1 |
| loading_screen_lore_b | 1920x1080 | P1 |
| loading_screen_lore_c | 1920x1080 | P2 |
| loading_screen_lore_d | 1920x1080 | P2 |
| loading_screen_lore_e | 1920x1080 | P2 |

Total: 13 entradas.

---

## 15. UI elementos especiais

### 15.1 Rankings / leaderboards

10 tiers da Arena: Bronze, Silver, Gold, Platinum, Diamond, Master, Gladiador, Lendario, Mitico, Eternizado.

Por tier:
- icon_rank_<tier> (64x64)
- icon_rank_<tier>_small (24x24)
- frame_rank_<tier> (banner para perfil)

Total: 10 x 3 = 30 entradas. P1 (Bronze-Master), P2 (Gladiador+).

### 15.2 Achievements

- ui_achievement_icon_default (64x64) — P1
- ui_achievement_frame_normal (9-slice) — P1
- ui_achievement_frame_secret (9-slice escuro) — P2
- ui_achievement_unlocked_burst (sprite-sheet 8f) — P1

### 15.3 Title plate

- ui_title_plate_frame (banner de titulo, 9-slice) — P1
- 5 estilos de plate (basic / rare / epic / legendary / mythic) — P1/P2

### 15.4 Friend list

[DECISAO PENDENTE: jogo tera componente social? Roadmap nao confirma multiplayer no curto prazo. Por padrao, P2.]

### 15.5 Notification toast

- ui_toast_info (frame azul) — P0 (existe `notification_item.tscn`)
- ui_toast_warning (amarelo) — P0
- ui_toast_error (vermelho) — P0
- ui_toast_success (verde) — P0
- ui_toast_reward (dourado, com brilho animado) — P0
- ui_toast_critical (com tela tremendo, ex: morte de personagem em permadeath modo) — P2

### 15.6 Daily reward popup

- ui_daily_reward_calendar (28 slots, 7x4) — P1
- ui_daily_reward_slot_locked / unlocked / claimed (32x32 cada) — P1
- ui_daily_reward_anim_open (10f) — P1

### 15.7 Damage number frames

- ui_damage_num_regular (texto branco, fonte 24px) — P0 (existe via `damage_number.tscn`)
- ui_damage_num_crit (vermelho, 30px, com glow) — P0
- ui_damage_num_critical_crit (roxo, 36px, com glow + sparkle) — P1
- ui_damage_num_miss (cinza, "Missed") — P0
- ui_damage_num_dodged (azul, "Dodged") — P1
- ui_damage_num_blocked (cinza-azul, "Blocked") — P1
- ui_damage_num_heal (verde, com cruz) — P0

### 15.8 Combat overlay

- ui_kill_streak_counter (numero grande no canto + chamas) — P1
- ui_combo_meter_frame (barra horizontal com tier de combo) — P2

---

## 16. VFX especiais (eventos pontuais grandes)

| Nome | Frames | Prioridade |
|---|---|---|
| vfx_event_levelup_burst | 12 | P0 (existe `level_up_vfx.tscn`) |
| vfx_event_class_change_transformation | 24 | P2 |
| vfx_event_awakening_ritual_loop | loop 16 | P1 |
| vfx_event_renascimento_ritual | 30 (ciclo completo) | P1 |
| vfx_event_transcendencia_ritual | 40 | P2 |
| vfx_event_ascensao_cosmica_ritual | 60 (cosmica grande) | P2 |
| vfx_event_dungeon_clear | 20 | P1 |
| vfx_event_boss_defeat_slowmo | 30 (overlay tela toda) | P1 |
| vfx_event_critical_super | 12 | P1 |
| vfx_event_multikill_kill_streak | 8 | P1 |
| vfx_event_first_clear_zone | 30 | P1 |
| vfx_event_codex_unlock | 8 | P1 |
| vfx_event_card_unlock | 12 | P1 |
| vfx_event_card_corrupted_unlock | 16 | P2 |
| vfx_event_card_greedy_unlock | 24 | P2 |
| vfx_event_pet_egg_hatch | 20 | P2 |

Total: 16 VFX especiais.

---

## Resumo de prioridades

### P0 (MVP, fase 0-1)

Estimativa: ~150 entradas para fechar o MVP jogavel com qualidade visual coesa.

Cluster denso para inicio:
1. **UI essencial:** ~70 botoes + sliders + frames basicos + tooltips + progress bars HP/MP/XP/generic.
2. **VFX basico:** cross/elipse/spark + slash/stab/crush/blunt + particulas crit/heal/levelup/drop.
3. **Inimigos animados:** 4-6 sprite-sheets (slimes ja em PNG, animar; 2-3 inimigos novos).
4. **Personagem:** warrior sprite-sheet completo (idle/walk/atk/cast/hurt/death) + portrait + miniportrait.
5. **Backgrounds:** Floresta + Deserto em parallax 3-layer.
6. **Icones:** stat icons (20), atk-type (7), element (6), resource gold + chakra, status core (10), skill core (~30).
7. **Frames de slot:** Common/Uncommon/Rare item.
8. **Logo + splash + title screen.**
9. **Damage numbers + toasts.**

### P1 (beta, fase 2-3)

Estimativa: ~350 entradas adicionais.

- Catalogo de inimigos expandido (30 inimigos com Elite).
- 5 classes com awakening 3*.
- 4 zonas adicionais.
- Pets, NPCs, cards (60-90).
- Loja UI completa.
- Dungeons backgrounds + bosses 1-2.
- Crafting stations sprites (forja, alquimia, etc.).

### P2 (full release, fase 4-5+)

Estimativa: ~300+ entradas.

- Awakening completo de todas classes ate 10*.
- Skin completas.
- Wings.
- Mythic frames.
- Eventos sazonais.
- Constelacoes UI.
- Forja Cosmica, Biblioteca, Espelho dos Gemeos.
- VFX rituais (renascimento/transcendencia/ascensao).

---

## Total geral estimado

**~800+ entradas** distribuidas em:
- UI: ~150
- VFX: ~75
- Icones: ~700 (item icons sao a maioria)
- Sprites de inimigos: ~250 conjuntos (= ~250 sprite-sheets)
- Sprites de personagens: ~166 conjuntos
- Backgrounds: ~50
- Pets/NPCs/Cards: ~120
- Banners/Logos/Splash: ~13
- Especiais: ~50

Para idle game ambicioso de 3-5 anos, a estimativa e razoavel. **Recomendacao:** o usuario deve focar no cluster P0 primeiro e considerar comissionar pacotes tematicos (ex: pacote completo "Floresta" com inimigos + boss + bg + materiais) em vez de assets soltos.

---

## Decisoes pendentes consolidadas

1. ~~Tamanho-padrao do tile de combate~~ (RESOLVIDO 2026-05-06: VARIAVEL — pequenos 16-24, medios 32-48, grandes 64-96, mini-bosses/bosses 128). Ver `00_meta/pending-decisions.md` #1.
2. **[DECISAO PENDENTE: paleta global oficial]** — 32 cores HEX.
3. ~~Equipamentos layered ou substituicao~~ (RESOLVIDO 2026-05-06: so a ARMA altera o personagem em batalha; armaduras nao tem peca visual; personagem muda via SKIN COMPLETA). Ver `00_meta/pending-decisions.md` #3.
4. **[DECISAO PENDENTE: lista final de classes]** — depende de `classes-and-characters.md`.
5. ~~Orientacao de tela~~ (RESOLVIDO 2026-05-06: Landscape, desktop primeiro). Ver `00_meta/pending-decisions.md` #5.
6. **[DECISAO PENDENTE: UI de friend list]** — multiplayer-social existira?
7. **[DECISAO PENDENTE: backgrounds 2D parallax ou cena 3D simples com sprites 2D na frente?]** — afeta esforco de arte.
