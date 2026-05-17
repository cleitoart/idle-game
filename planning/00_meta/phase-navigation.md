# Phase Navigation - Visao Macro do Roadmap

> Mapa de navegacao entre as 6 fases do projeto. Diagrama de dependencias, timeline aproximada, juicy a aplicar por fase, e divisao de responsabilidades Claude vs Usuario.
>
> **Pre-requisito:** ler `progress-log.md` e cada `phase-XX-*.md`.

---

## 1. Diagrama de fases

```
+------------------+
| Fase 00          |  Foundation: combate, stats, inventario, save, gold
| Foundation       |  Pre-condicao: nada
+--------+---------+
         |
         v
+------------------+
| Fase 01          |  Mapa, gathering basico, crafting basico, acampamento estagio 1
| Core Loops       |  Pre-condicao: F00 estavel + save persistente
+--------+---------+
         |
         v
+------------------+
| Fase 02          |  Multi-personagem (3-5), classes, status+elementos, pets buff,
| Expansion        |  cards, kill stack, encantamentos, refinamento, vilarejo, loja
+--------+---------+
         |
         v
+------------------+
| Fase 03          |  Cidade, dungeons (3x2), bosses, raids, arena,
| Mid-Game         |  skills cooldown+prioridade, codex, eventos rotativos,
|                  |  selos, titulos, itens usaveis, pets combat+expedition,
|                  |  Renascimento (★1-★10) + Awakening, Gemas + Loja Eterna
+--------+---------+
         |
         v
+------------------+
| Fase 04          |  Reino, World Tree+Titanica, Transcendencia, Constelacoes,
| Late-Game        |  Ascensao Cosmica, NG+, eventos sazonais
+--------+---------+
         |
         v
+------------------+
| Fase 05          |  Imperio, Forja Cosmica, Biblioteca dos Antigos, Espelho
| End-Game         |  dos Gemeos, Faccoes, Cronicas, Selos de Lideranca,
|                  |  Colecao Mythic, Arena Grao-Mestre+, Seasons
+------------------+
```

---

## 2. Timeline aproximada

**Premissa:** 1 dev solo (usuario) + agente Claude. Trabalho part-time (~20h/semana). Numeros sao **estimativas** sujeitas a revisao a cada fase concluida.

| Fase | Duracao estimada | Notas |
|---|---|---|
| Fase 00 | 1-2 meses | Boa parte ja existe. Save+offline e' o gargalo. |
| Fase 01 | 2-3 meses | Depende muito de assets visuais (mapa, acampamento). |
| Fase 02 | 4-6 meses | Maior fase. Recomendado dividir em 02a/02b/02c. |
| Fase 03 | 5-7 meses | Renascimento + Dungeons sao gigantes. |
| Fase 04 | 4-6 meses | Transcendencia delicada matematicamente. |
| Fase 05 | aberto | Pos-launch, conteudo de season recorrente. |

**Total ate Release 1.0 (Fase 03 completa):** ~12-18 meses.
**Total ate Release 2.0 (Fase 04 completa):** ~16-24 meses.
**Total ate Release 3.0 (Fase 05 inicial):** ~20-30 meses.

Cross-ref `release-plan.md`.

---

## 3. Top 3-5 features por fase

### Fase 00 - Foundation
1. Save/Load + Offline progression.
2. Expansao de stats (todos os campos da secao 3.2 do roadmap).
3. Inventario+Equipamento estruturado (10 slots equipaveis + 3 ferramentas).
4. Roster como array (preparar multi-personagem).

### Fase 01 - Core Loops
1. Coleta basica (Mining + Woodcutting) com mastery.
2. Crafting basico (Smithing + Smelting).
3. Acampamento estagio 1 com personagens andando.
4. Tela de resultados pos-clear.
5. Sistema de velocidade (1x/2x).

### Fase 02 - Expansion
1. Multi-personagem 3-5 em paralelo.
2. 5 classes com builds diferentes.
3. Status effects + elementos no combate.
4. Cards regulares + kill stack ativo.
5. Vilarejo + encantamentos + refinamento.

### Fase 03 - Mid-Game
1. Renascimento + Awakening (★1-★10).
2. Dungeons com formacao 3x2 e auras.
3. Cidade + Arena dos Gladiadores.
4. Skills com cooldown + prioridade.
5. Gemas da Eternidade + Loja Eterna.

### Fase 04 - Late-Game
1. Transcendencia (com codex transcendido).
2. Constelacoes (5 constelacoes, ate 75 nos).
3. Reino + Academia (evolucao de skills).
4. Ascensao Cosmica + NG+.
5. World Tree + Titanica (in-Floresta).

### Fase 05 - End-Game
1. Imperio.
2. Forja Cosmica + Biblioteca dos Antigos.
3. Espelho dos Gemeos.
4. Pacto com Espiritos / Faccoes mutuamente exclusivas.
5. Framework de seasons.

---

## 4. O que vem na proxima sprint

> Atualizado a cada conclusao de fase. Hoje (2026-05-06):

**Foco atual:** **completar Fase 00**. Subitens em ordem:
1. F00.02 Stats expandidos
2. F00.03 Inventario+Equipamento expandido
3. F00.05 Roster como array
4. F00.04 Save/Load + Offline (e' o trabalho mais critico)

Apos Fase 00 estavel, iniciar Fase 01 comecando por **F01.06 Bestiario simples** (rapido, ja prepara tracker para Fase 02).

---

## 5. Quais juicy se aplicam em qual momento

Mapeamento de tecnicas do `juicy-catalog.md` para fase onde sao **primeiro aplicadas**. Reutilizadas em todas seguintes.

### Fase 00
- J02.02 Flash on hit (ja temos parcial)
- J02.05 Damage number pop (ja temos)
- J02.06 Floating text (ja temos)
- J05.05 Damage trail in HP bar (ja temos)
- J09.01 Level-up burst (ja temos)

### Fase 01
- J01.04 Easing curves (padronizar tudo aqui)
- J01.08 Tempo de tween padrao (definir e aplicar)
- J05.01 Botao com hover scale + sound
- J05.02 Modal abrir com fade + scale
- J05.04 Progress bar com fill suave + delay (gathering)
- J07.01 Pickup arc
- J07.03 Pickup sound + particle
- J10.04 Toggle X/2X com indicator visual
- J10.05 Speed indicator no HUD
- J03.04 Particles em level-up (ja temos)

### Fase 02
- J01.01 Anticipation
- J01.02 Follow-through
- J02.07 Crit text maior + colorido
- J02.08 Miss / Dodge / Block textos
- J02.09 Combo counter
- J02.10 Kill streak meter
- J02.11 Hit-spark
- J02.12 Element tints
- J02.13 Squash and stretch
- J03.01 Burst em kill (refinar)
- J03.05 Particles por elemento
- J04.01 Layering de SFX
- J04.04 SFX por raridade de drop
- J05.03 Tab change com slide
- J05.06 Slot empty com pulse
- J05.07 Notification stack
- J07.04 Stack count flash em pickup

### Fase 03
- J01.05 Hit-stop em crit (em party/dungeon e bosses)
- J01.06 Slow-mo em kill final do boss
- J02.01 Screen shake (com intensidades)
- J02.04 Outline glow em interativo (loja eterna)
- J03.02 Trail em projetil
- J03.03 Glow halo em pickup (Rare+)
- J03.06 Particle por raridade de drop (refinado)
- J04.02 Stinger antes de boss
- J04.03 Music duck em boss intro
- J05.08 Achievement popup com fade + sound stinger
- J06.01 Zoom in em boss
- J06.04 Vignette em low HP
- J07.02 Magnetic attract para player (auto-pickup unlocked)
- J08.01 Cast bar suave
- J08.02 Skill ready glow
- J08.03 Skill icon flash em ready
- J09.02 Star added animation (Awakening)
- J09.05 Renascimento ritual loop
- J10.01 Auto-collect com radial accumulator
- J10.02 Auto-equip flash
- J10.03 Auto-craft progress

### Fase 04
- J01.07 Frame skip em alta velocidade (4x/8x)
- J06.02 Pan para mostrar drop (Legendary+)
- J06.03 Camera shake em explosao
- J08.04 Combo skill chain
- J09.03 Constelacao node light-up
- J09.04 Awakening transformation cinematic (refinado)
- J09.06 Transcendencia super-cinematic
- J09.07 Ascensao Cosmica ultra-cinematic

### Fase 05
- (Polimento de tudo acima + cinematicas de season)

---

## 6. O que e' MEU (Claude) vs SEU (usuario)

**Divisao recorrente em todas as fases:**

### Claude entrega
- Codigo (.gd, .tscn, .tres).
- Arquitetura de classes e signals.
- Formulas matematicas baseadas em `02_math/`.
- Integracao entre sistemas (eventbus, gamestate).
- Refatoracao de codigo existente.
- Manutencao de cross-references entre docs do hub.
- Testes manuais via Godot (rodar cena, validar).
- Atualizacao do `progress-log.md`.

### Usuario entrega
- Sprites e arte (cross-ref `01_design/graphics-needs.md`).
- VFX e animacoes finais.
- SFX e musica (cross-ref `01_design/audio-needs.md`).
- Decisoes finais de balance (Claude propoe, usuario confirma).
- Decisoes de jogabilidade real ("isso esta divertido?", "esta lento demais?").
- Validacao final em sessoes de 1+ hora.
- Decisoes marcadas `[DECISAO PENDENTE]`.
- Aprovacao de novas features fora do roadmap.
- Lore, narrativa, dialogos.

### Compartilhado (com peso variavel)
- UI/UX wireframes: Claude propoe layout textual; usuario polish visual.
- Naming de conteudo: Claude pode sugerir; usuario confirma.
- Curvas matematicas: Claude calcula com base em referencia; usuario valida em playtest.

---

## 7. Anti-padroes - sinais de que perdemos o fio

- Implementar feature sem entry em `01_design/` -> PARAR.
- Inventar numero novo sem checar `02_math/` -> PARAR.
- Replicar texto entre arquivos -> usar cross-reference.
- Pular fase (ex: implementar Constelacoes sem ter Renascimento) -> PARAR.
- Usar emoji em qualquer arquivo -> remover imediatamente.

---

## Cross-references

- `progress-log.md` (estado atual)
- `self-instructions.md` (regras de operacao)
- `release-plan.md` (marcos de release)
- `localization-plan.md` (i18n)
- `04_phases/phase-XX-*.md` (detalhes por fase)
- `05_juicy/juicy-catalog.md` (tecnicas de gamefeel)
- `roadmap-sistemas.md` (fonte primaria)
