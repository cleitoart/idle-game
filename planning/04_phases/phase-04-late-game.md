# Fase 04 - Late-Game

> Camada de prestigio profundo (Transcendencia + Constelacoes), expansao do mundo (mecanicas de bonus encontradas in-zona), e chegada da Ascensao Cosmica.
>
> **Pre-condicao:** Fase 03 completa, Renascimento ★1+ testado.
> **Pos-condicao:** Reino desbloqueado. Transcendencia jogavel. Constelacoes ativas. Primeira Ascensao Cosmica acessivel. Multiplos NG+. Eventos sazonais funcionais.

---

## Visao geral

Fase 04 e' a primeira fase **pos-jogo principal**. Quem chega aqui ja gastou 50-100h+. As mecanicas precisam parecer recompensadoras MAS ter horizonte de 500h+. Cuidado com inflacao de stats: Transcendencia e Ascensao usam expoentes sub-lineares (cross-ref roadmap 3.19).

---

## Itens da fase

### F04.01 Acampamento estagio 4 (Reino)

- **Status atual:** so Cidade (Fase 03).
- **O que falta:**
  - Background Reino.
  - Estruturas adicionais: Embaixadas (eventos cross-zona), Catedral (mecanicas de bonus tipo World Tree), Academia (auto-treinos de skill com tempo real para evoluir tier de skills - "Fireball" -> "Meteor Shoot" - cross-ref roadmap 3.16).
  - Boost global de Reino.
- **Dependencias:** F03.01.
- **O que EU entrego em codigo:**
  - Expansao em settlement_view com Reino.
  - `scripts/systems/skill_evolution.gd` (Academia).
  - Sistema de Embaixadas (evento cross-zona).
- **O que o USUARIO entrega:**
  - Background do Reino.
  - Lista de evolucoes de skills por classe (cross-ref `01_design/skills-catalog.md`).
- **Criterio de aceite:** evoluir Cidade para Reino. Academia evolui 1 skill base do Warrior em 24h reais.
- **Riscos:** evolucao de skill quebrando balance. Mitigacao: evolucao = +30% potencia + visual novo, nao multiplicar.

### F04.02 Mecanicas de bonus encontradas in-zona (World Tree, Titanica)

- **Status atual:** nao existem.
- **O que falta:**
  - World Tree e Titanica encontrados na **Floresta** (Zona 1) - cross-ref roadmap secao 6.
  - World Tree: arvore gigante interativa com nos de bonus globais.
  - Titanica: estrutura/personagem que da quests de longo prazo.
  - Acessadas como spots especiais no mapa.
- **Dependencias:** F01.01 (mapa com spots).
- **O que EU entrego em codigo:**
  - Novos spots especiais com cena dedicada (`scenes/views/world_tree_view.tscn`, etc.).
  - Sistema de "no de bonus" similar a constelacao mas mais visual.
- **O que o USUARIO entrega:**
  - Arte de World Tree (peca-chave).
  - Lista de bonus por no.
- **Criterio de aceite:** acessar World Tree pela Floresta, depositar materiais, desbloquear no de bonus, aplicado globalmente.
- **Riscos:** posicionamento do bonus muito bom no early. Mitigacao: gating por progresso (bosses derrotados, etc.).

### F04.03 Transcendencia

- **Status atual:** nao existe.
- **O que falta:**
  - Trigger: level cap 1000 + completude de codex pre-transcendido (cross-ref roadmap 3.19 ponto 2).
  - Consome experiencia ganhada ate agora, itens, album (com excecoes).
  - Mantem: compras Loja Eterna, pets, codex transcendido (que evolui), conquistas.
  - Converte progresso em **Transcended Points** (pouquissimos, sinalizando reset profundo).
  - Niveis pos-transcendencia exibidos via Arvore de Transcendencia.
  - Stats continuam crescendo a cada nivel de transcendencia.
  - Codex evolui para Codex Transcendido com versoes "transcendidas" de inimigos (novo aspecto, comportamento, tipo).
  - 1 nivel de transcendencia = no minimo 2x do personagem level 1000.
- **Ordem sugerida:** **mais critico da fase**. Mecanica matematica delicada (cross-ref `02_math/ascension-multipliers.md`).
- **Dependencias:** F03.15 (Renascimento estavel), F03.10 (Codex completo).
- **O que EU entrego em codigo:**
  - `scripts/systems/transcendence.gd`.
  - Calculo de conversao para Transcended Points.
  - Modal de Transcendencia (preview drastico do que se perde).
  - Arvore de Transcendencia (similar a skill tree mas global do personagem).
- **O que o USUARIO entrega:**
  - Lista oficial dos nos da Arvore de Transcendencia.
  - Lista de inimigos transcendidos (cross-ref `01_design/enemies-catalog.md`).
  - Animacao cinematica de Transcendencia `[PLACEHOLDER: cinematic transcendencia]`.
- **Criterio de aceite:** atingir cap 1000 + codex 100%, transcender, ver Transcended Points minimos, gastar em no, ver poder dobrar.
- **Riscos:**
  - **Critico:** matematica de conversao errada quebra economia. Mitigacao: simular em planilha antes (`02_math/ascension-multipliers.md`).
  - Curva de level pos-transcendencia plana ou exponencial demais.

### F04.04 Constelacoes

- **Status atual:** nao existem.
- **O que falta:**
  - Desbloqueada apos Renascimento #1.
  - NPC "O Transcendido" aparece no Acampamento desde o inicio, mas requisitos abrem apos prestigio.
  - Pede materiais de cada zona para desbloquear constelacao correspondente.
  - 5 constelacoes: Cacador (drop+XP combate), Coletor (gathering), Forjador (crafting), Andarilho (velocidade+offline), Sortudo (luck+rare drops).
  - 5-15 nos por constelacao.
- **Dependencias:** F03.15.
- **O que EU entrego em codigo:**
  - `scripts/systems/constellation.gd` no nivel da conta.
  - Modal grande com nos posicionados visualmente como estrelas.
  - NPC dialogo + entrega de materiais.
- **O que o USUARIO entrega:**
  - Arte da tela de Constelacoes.
  - Lista de nos por constelacao.
  - Sprite/portrait de O Transcendido.
- **Criterio de aceite:** entregar materiais Z1, desbloquear primeira constelacao, gastar ponto, ver bonus aplicado.
- **Riscos:** UI complexa. Mitigacao: tutorial in-game.

### F04.05 Ascensao Cosmica (primeira)

- **Status atual:** nao existe.
- **O que falta:**
  - Reset profundo (incluindo gathering, equip).
  - Mantem: Cards, Bestiario, Pets, Conquistas, Loja Eterna, Constelacoes.
  - Multiplicador "Cosmico" permanente (1.5x na primeira, escalando 2x, 3x, 5x).
  - Desbloqueia NG+ (dificuldade elevada).
  - Desbloqueia novos inimigos, novas zonas (1-2 inicialmente), variacoes pos-ascensao.
  - Dropa **Moedas Galacticas** (raras) que alimentam a Forja Galactica/Cosmica (Fase 05).
  - Acelerador Cosmico / Dobra Cosmica: multiplica clears de area baseando-se em 1 (cross-ref roadmap 3.19 ponto 3).
- **Ordem sugerida:** ultima feature antes de polimento. **Critica.**
- **Dependencias:** F04.03, F03.15.
- **O que EU entrego em codigo:**
  - `scripts/systems/cosmic_ascension.gd`.
  - Modal de Ascensao com aviso forte.
  - Sistema de NG+ (overlay no mundo).
  - Acelerador Cosmico com matematica de proporcoes para elites/shiny.
- **O que o USUARIO entrega:**
  - Cinematica `[PLACEHOLDER: cinematic ascensao cosmica]`.
  - Decisao sobre o multiplicador inicial (proposto: 1.5x).
  - Lista de novos inimigos pos-ascensao.
- **Criterio de aceite:** transcender uma vez, ascender cosmicamente, ver mundo NG+ com tudo zerado, mas multiplicador ativo.
- **Riscos:**
  - **Critico:** ascensao desincentivada se prestigio anterior parecer melhor. Mitigacao: simular curva.

### F04.06 Multiplos NG+ de dificuldade

- **Status atual:** nao existe.
- **O que falta:**
  - Cada Ascensao desbloqueia uma camada NG+ (NG+1, NG+2, NG+3...).
  - Inimigos com stats elevados, mas drops elevados tambem.
- **Dependencias:** F04.05.
- **O que EU entrego em codigo:**
  - Multiplicador de stats inimigo por NG+ ativo.
  - Toggle de NG+ no mundo.
- **O que o USUARIO entrega:**
  - Curva de elevacao por NG+ `[DECISAO PENDENTE: cada NG+ aumenta 2x ou 3x stats?]`.
- **Criterio de aceite:** entrar em NG+1, ver inimigos com HP/dano elevado, drops melhores.
- **Riscos:** baixo.

### F04.07 Eventos sazonais

- **Status atual:** so eventos rotativos (F03.11).
- **O que falta:** Halloween, Natal, etc. Visual + drops + boss unico + recompensas exclusivas.
- **Dependencias:** F03.11.
- **O que EU entrego em codigo:**
  - Sistema de evento sazonal com data trigger (real-time).
  - Overlay visual da zona durante evento.
- **O que o USUARIO entrega:**
  - Cada evento = pacote de assets (sprite tematico, SFX, music).
  - Lista de eventos a implementar (cross-ref `01_design/events-catalog.md`).
- **Criterio de aceite:** chegar em outubro, ver Halloween ativo, derrotar boss exclusivo, ganhar item de evento.
- **Riscos:** assets sazonais consumirem muito tempo. Mitigacao: minimo viavel inicial (so visuals leves), expandir.

---

## Ordem global recomendada

1. F04.01 Reino
2. F04.04 Constelacoes (depende de Renascimento da Fase 03)
3. F04.02 World Tree + Titanica
4. F04.03 Transcendencia (mais critico)
5. F04.07 Eventos sazonais
6. F04.05 Ascensao Cosmica
7. F04.06 NG+

---

## Criterio de aceite global da Fase 04

- Reino funcional, Academia evoluindo skills.
- 5 constelacoes configuradas com pelo menos 5 nos cada.
- Transcendencia testada em 1 personagem ate 5 niveis.
- Primeira Ascensao Cosmica jogavel com NG+1 ativo.
- 1 evento sazonal completo testado.

---

## Riscos transversais

- **Mais critico:** inflacao de poder com Transcendencia + Constelacoes + Ascensao + NG+ acumulando. Mitigacao: simular em planilha antes de codigo (`02_math/ascension-multipliers.md`), expoentes sub-lineares confirmados.
- **Critico:** save bloating com tantas camadas de progresso. Mitigacao: serializacao versionada.
- **Medio:** UI overload. Mitigacao: tabs claras, busca em modais.

## Cross-references

- `02_math/ascension-multipliers.md`
- `02_math/balance-tables.md`
- `01_design/events-catalog.md`
- `01_design/enemies-catalog.md`
- `roadmap-sistemas.md` secoes 3.16, 3.19, 3.20, 3.26
