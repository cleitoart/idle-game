# Fase 01 - Core Loops

> Estabelece os tres loops aninhados do `roadmap-sistemas.md` secao 1.1: curto (combate), medio (area clear), longo (zona/skill). Sem isso, o jogo nao tem "alma idle".
>
> **Pre-condicao:** Fase 00 concluida.
> **Pos-condicao:** loop completo de combate -> coleta -> crafting -> volta ao combate. Acampamento basico visivel. Mapa funcional. Sistema de velocidade 1x/2x.
>
> **Status (2026-05-07):**
> - Bloco A FECHADO: F01.06 Bestiario, F01.07 Tela de resultados, F01.08 Velocidade 1x/2x.
> - Bloco B IMPLEMENTADO COM PLACEHOLDERS: F01.02 Skill tree textual (18 nos, 3 ramos Warrior), F01.03 Coleta basica (Mining/Wood/Fish, 1 ativa), F01.04 Crafting (Smithing+Smelting, instantaneo), F01.05 Acampamento (4 botoes + walker), F01.01 Mapa (so bg novo). Sprites placeholders usando `forest-bg000.png`, elipses VFX, warrior.png e iron-sword.png. Sera repaginado quando user entregar PSDs definitivos.

---

## Visao geral

A Fase 01 transforma o jogo de "demo de combate" em "idle real". O jogador:
1. Combate em uma zona, ganha materiais.
2. Volta ao acampamento, vai ate o mapa, escolhe spot de Mining ou Woodcutting.
3. Coleta -> faz craft em Smithing -> equipa -> volta ao combate mais forte.
4. Ve o personagem andando aleatoriamente pelo Acampamento entre atividades.

E' a primeira fase com **multi-loop perceptivel**.

---

## Itens da fase

### F01.01 Mapa + navegacao entre zonas

- **Status atual:** map modal existe. Dev unlock all zones disponivel. Ver `progress-log.md`.
- **O que falta:**
  - Visual real de mapa (placeholder hoje).
  - Spots de Gathering posicionados no mapa de cada zona (substituem o antigo botao Gathering, conforme glossary).
  - Tooltip/modal de informacao por area (cross-ref Combate 3.1 do roadmap).
- **Ordem sugerida:** estrutura primeiro, arte depois. Spots como nodes na cena de mapa.
- **Dependencias:** F00.04 (save persiste qual zona desbloqueada).
- **O que EU entrego em codigo:**
  - Refatoracao em `scenes/ui/modals/map_modal.gd` para suportar lista de spots por zona.
  - Novo recurso `scripts/data/spot_data.gd` (tipo: gathering_skill, item_pool, dificuldade).
  - Tooltip nodes em cada area/spot do mapa.
  - Manutencao em `autoload/game_state.gd` para tracking de unlocks.
- **O que o USUARIO entrega:**
  - Arte do mapa da Zona 1 (Floresta). Cross-ref `01_design/graphics-needs.md` (P0).
  - Icones de spot por skill. `[PLACEHOLDER: icone Mining, Woodcutting]`
  - Decisao sobre posicionamento manual vs gerado.
- **Criterio de aceite:** abrir mapa, escolher spot, iniciar coleta. Voltar pro combate sem reabrir.
- **Riscos:** mapa lindo demais cedo demais consome tempo. Mitigacao: comecar com mapa esquematico, polir na Fase 03.

### F01.02 Skill tree basica (1 personagem, lista textual)

- **Status atual:** stat points distribuiveis em level up existe (HP, MP, ATK, DEF, AtkSpeed). Skill tree em si: nao existe.
- **O que falta:** primeira versao **textual** da skill tree do Warrior. Sem visual de nos. Apenas lista de unlocks.
- **Ordem sugerida:**
  1. Definir o conteudo (cross-ref `01_design/skills-catalog.md`).
  2. UI lista com botoes "Unlock".
  3. Skill points ganhos por level (1 por nivel).
  4. Skill points permitem destravar nos da lista.
- **Dependencias:** F00.02.
- **O que EU entrego em codigo:**
  - Novo `scripts/data/skill_tree_data.gd` (definicao da arvore).
  - Novo `scripts/systems/skill_tree.gd` (estado por personagem).
  - Novo `scenes/ui/modals/skill_tree_modal.gd` (UI textual minimal).
  - Integracao em `character_instance.gd` para salvar nos desbloqueados.
- **O que o USUARIO entrega:**
  - Lista oficial de nos da arvore do Warrior. `[DECISAO PENDENTE: 3 ramos definitivos do Warrior pre-awakening (provavel: Berserker, Defender, Tactician)]`.
  - Validar se 1 ponto por nivel da boa progressao.
- **Criterio de aceite:** subir level, gastar ponto, ver o stat aplicado. Save persiste.
- **Riscos:** super-engenharia de UI visual antes de testar conteudo. Mitigacao: ficar textual ate Fase 02.

### F01.03 Coleta basica (Mining + Woodcutting)

- **Status atual:** nao existe.
- **O que falta:**
  - Sistema de "spot" que aceita um personagem por vez.
  - Loop: timer de coleta -> drop -> repete.
  - XP de skill por coleta (cross-ref `02_math/progression-curves.md`).
  - Mastery por item especifico (cross-ref glossary).
  - **Sistema de Eficiencia** (decidido #15, estilo IdleOn) — cada node do spot tem `eficiencia_minima`. Personagem com `eficiencia[skill] < minima` sofre chance de drop reduzida (`eficiencia/minima * 100%`); personagem com `>= minima` dropa sempre (100%). Animacao de coleta acontece em ambos os casos. Os primeiros spots de Mining e Woodcutting da Fase 01 ja USAM esse sistema (T1, eficiencia_minima sugerida = 10). Cross-ref completo em `01_design/gathering-materials.md` (secao Sistema de Eficiencia) e formula em `02_math/`.
- **Ordem sugerida:**
  1. Spot data (item pool + tempo base + `eficiencia_minima` por node).
  2. Loop de coleta com Timer + roll de Eficiencia.
  3. UI de spot ativo (barra de progresso, contador de drops, indicador de Eficiencia atual vs requisito).
  4. Mastery basico (so trackar contagem por enquanto, bonus na Fase 02).
- **Dependencias:** F01.01 (spot existe no mapa).
- **O que EU entrego em codigo:**
  - Nova cena `scenes/views/gathering_view.tscn` (substitui o placeholder atual).
  - Novo `scripts/systems/gathering_session.gd` (com calculo de drop por Eficiencia).
  - Novo `scripts/systems/skill_progression.gd` (por gathering skill).
  - Novo `scripts/systems/efficiency.gd` (resolve `personagem.eficiencia[skill]` a partir de mastery + level + bonus de classe + ferramenta equipada).
  - Items para drop em `data/items/` (minerios, madeiras basicas).
- **O que o USUARIO entrega:**
  - Sprites de minerios/madeiras. Cross-ref `01_design/gathering-materials.md`, `01_design/graphics-needs.md`.
  - Tempo base de coleta (sugerido: 3-5s no inicio).
  - Validacao dos thresholds de eficiencia por T (T1=10, T2=25, T3=50, T4=100, T5=200, T6=400 — propostos).
- **Criterio de aceite:** entrar em spot, ver progresso, animacao de coleta sempre ocorre, drop ocorre conforme regra de Eficiencia, ganhar XP de skill, ver level up de skill funcionando.
- **Riscos:**
  - Tempo de coleta tedioso vs rapido demais. Cross-ref `02_math/time-to-progress.md`.
  - Item gerado sem visual quebra imersao. Mitigacao: usar icone generico ate ter sprite.
  - Eficiencia confundindo player iniciante (anima mas nao dropa). Mitigacao: tooltip explicativo no spot + indicador de % de drop.

### F01.04 Crafting basico (Smithing + Smelting)

- **Status atual:** nao existe.
- **O que falta:**
  - Estacao de crafting (Forja para Smithing, Fornalha para Smelting).
  - Receita: input materials + output item + tempo.
  - UI de fila de crafting (1 slot inicial; mais slots via Loja Eterna nas fases seguintes).
  - Smelting: minerios brutos -> barras. Smithing: barras + outros -> equipamento basico.
- **Ordem sugerida:**
  1. Smelting (mais simples; 1 input -> 1 output).
  2. Smithing (multi-input).
- **Dependencias:** F01.03 (precisa de materiais).
- **O que EU entrego em codigo:**
  - Novo `scripts/data/recipe_data.gd`.
  - Novo `scripts/systems/crafting_station.gd`.
  - Novas cenas `scenes/ui/modals/smithing_modal.gd` e `smelting_modal.gd` (ou unificadas).
  - Integracao com inventory para consumir input + adicionar output.
- **O que o USUARIO entrega:**
  - Lista oficial de receitas iniciais (cross-ref `01_design/crafting-catalog.md`).
  - Sprites das estacoes de crafting. `[PLACEHOLDER: sprite forja, fornalha]`.
- **Criterio de aceite:** coletar 5 minerios -> smelt -> 5 barras -> craft -> 1 item Common. Item utilizavel.
- **Riscos:** receita desbalanceada (input caro demais). Mitigacao: comecar generoso.

### F01.05 Acampamento estagio 1 (3-5 estruturas)

- **Status atual:** nao existe (Settlement esta no menu mas vazio).
- **O que falta:**
  - Cena do Acampamento.
  - 3-5 estruturas posicionadas manualmente: Fogueira (centro), Bancada de Trabalho (Smithing), Fornalha (Smelting), Tenda Inicial (lore/NPC start), Banca de Cozinha simples.
  - Personagens desbloqueados andam aleatoriamente pelo acampamento (decisao do roadmap secao 6: sem organizacao manual).
  - Estruturas so ficam visiveis quando desbloqueadas.
- **Ordem sugerida:**
  1. Cena base com background.
  2. Posicionar nodes de estrutura.
  3. Random walker AI simples para personagens.
  4. Hook de visibilidade por unlock.
- **Dependencias:** F01.04 (estruturas correspondem a sistemas existentes).
- **O que EU entrego em codigo:**
  - Nova cena `scenes/views/settlement_view.tscn`.
  - Novo `scripts/systems/settlement_walker.gd` (random walk AI).
  - Refatoracao em `autoload/game_state.gd` para guardar estado de cada estrutura.
- **O que o USUARIO entrega:**
  - Background do acampamento estagio 1. `[PLACEHOLDER: bg acampamento]`.
  - Sprites das 3-5 estruturas. Cross-ref `01_design/graphics-needs.md`.
  - Decisao final sobre velocidade do random walk.
- **Criterio de aceite:** abrir Settlement, ver background + estruturas. Personagens andando. Clicar em estrutura abre modal correspondente (Smithing/Smelting).
- **Riscos:** random walker travando em colisao. Mitigacao: pathfinding simples ou areas livres pre-definidas.

### F01.06 Bestiario simples (info, sem buffs)

- **Status atual:** nao existe.
- **O que falta:**
  - Tracking de kills por inimigo (por personagem e global).
  - UI textual: lista de inimigos, kills, status de descoberta.
  - **Sem buffs ainda** - chega na Fase 02-03 com Mob Slaughter.
- **Ordem sugerida:** trivial, fazer cedo na fase pra ja ir tracking desde o comeco.
- **Dependencias:** F00.06.
- **O que EU entrego em codigo:**
  - Novo `scripts/systems/bestiary.gd` no game_state.
  - Hook em combate para incrementar kill count.
  - Nova `scenes/ui/modals/bestiary_modal.gd` minimal (apenas listagem).
- **O que o USUARIO entrega:**
  - Sprites/portraits dos inimigos para o codex. Cross-ref `01_design/enemies-catalog.md`.
- **Criterio de aceite:** matar 10 slimes verdes, abrir bestiario, ver "Slime Verde - 10 kills".
- **Riscos:** baixo.

### F01.07 Tela de resultados pos-clear de area

- **Status atual:** nao existe.
- **O que falta:** modal mostrando: XP ganho, drops obtidos (resumo por raridade), kill stack progresso, bestiario updates, tempo total na area, comparativo com clear anterior.
- **Ordem sugerida:** depois de F01.04 (precisa de itens decentes pra mostrar drop interessante).
- **Dependencias:** F00.04 (precisa de save para ler clear anterior).
- **O que EU entrego em codigo:**
  - Nova `scenes/ui/modals/area_results_modal.gd`.
  - Tracking em `combat_controller.gd` para acumular delta da area.
  - Sinal `area_cleared` em `event_bus.gd` (provavel ja existe; se nao, criar).
- **O que o USUARIO entrega:**
  - Layout do modal `[PLACEHOLDER: mockup detalhado em 01_design/ui-ux-wireframes.md]`.
- **Criterio de aceite:** limpar area, ver modal com numeros corretos. Botao "continuar" volta para combate.
- **Riscos:** modal interrompendo loop idle. Mitigacao: opcao de auto-fechar em N segundos.

### F01.08 Sistema de velocidade (1x/2x)

- **Status atual:** nao existe.
- **O que falta:**
  - Toggle no HUD entre 1x e 2x.
  - Implementacao via `Engine.time_scale` (cross-ref roadmap 3.29).
  - **Importante:** timers reais (offline, daily quests) usam `Time.get_unix_time_from_system()` - NAO afetar.
- **Ordem sugerida:** ultimo da fase, depois que todo loop existir.
- **Dependencias:** F01.07 (testar que tela de resultados nao quebra com 2x).
- **O que EU entrego em codigo:**
  - Botao em `scenes/ui/right_panel.gd` ou HUD principal.
  - Manager simples em `autoload/game_state.gd` (`set_game_speed(speed)`).
  - Auditoria de Timers para garantir que nenhum critico use `process` quando deveria ser real-time.
- **O que o USUARIO entrega:**
  - Validacao em sessao de uso real.
  - Decisao confirmada (#14): 1x e 2x sao DEFAULT desde o inicio da Fase 01. 4x e 8x sao unlocks futuros (Renascimento na Fase 03 / Loja Eterna). Toggle aparece como dois estados (1x / 2x), sem unlock.
- **Criterio de aceite:** toggle 1x/2x funciona em combate, gathering, crafting. Offline simulator nao afetado.
- **Riscos:** dessincronizacao de timers reais com simulados. Mitigacao: lista explicita de "real-time only" vs "scaled".

---

## Ordem global recomendada da fase

1. F01.06 Bestiario simples (rapido, ja tracker para fases futuras)
2. F01.01 Mapa (esqueleto)
3. F01.03 Coleta basica
4. F01.04 Crafting basico
5. F01.05 Acampamento estagio 1
6. F01.07 Tela de resultados
7. F01.02 Skill tree textual
8. F01.08 Velocidade

---

## Criterio de aceite global da Fase 01

- Loop completo: combate -> drop -> spot de coleta -> craft -> equip -> combate. Sem retornar ao menu.
- Acampamento visivel com 3+ estruturas funcionais.
- Skill tree textual com pelo menos 6 nos por ramo do Warrior.
- Mapa apresenta zona e seus spots.
- Velocidade 2x funcional sem quebrar offline.

---

## Riscos transversais

- **Mais critico:** acoplamento de UI a 1 personagem. Toda nova UI deve aceitar `character_index` para ficar pronta para multi-personagem na Fase 02.
- **Medio:** spot de gathering competindo com slot de combate. Mitigacao na Fase 02 (multi-personagem); por enquanto, escolha exclusiva.
- **Baixo:** texturas placeholder ofendendo o playtest. Mitigacao: avisar testers que e' WIP.

## Cross-references

- `01_design/skills-catalog.md`
- `01_design/crafting-catalog.md`
- `01_design/gathering-materials.md`
- `01_design/enemies-catalog.md`
- `01_design/ui-ux-wireframes.md`
- `02_math/progression-curves.md`
- `02_math/time-to-progress.md`
- `roadmap-sistemas.md` secoes 3.6, 3.9, 3.11, 3.16, 3.29, 3.30
