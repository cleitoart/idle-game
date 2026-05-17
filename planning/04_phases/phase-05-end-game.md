# Fase 05 - End-Game

> Camada de longevidade extrema: 500h+ de jogo. Conteudo de season e expansao. **NAO PRECISA estar pronto no Release 1.0.** E' o roadmap pos-launch.
>
> **Pre-condicao:** Fase 04 completa. Pelo menos uma Ascensao Cosmica jogada.
> **Pos-condicao:** Imperio. Sistemas de longevidade extrema. Infraestrutura de season.

---

## Visao geral

Fase 05 e' onde o jogo "vira franchise". Quem chega aqui e' fa hardcore, jogou 200h+. Cada feature aqui precisa parecer "a recompensa pelo grind". Nada de mecanica simples ou padrao.

---

## Itens da fase

### F05.01 Acampamento estagio 5 (Imperio)

- **Status atual:** so Reino (Fase 04).
- **O que falta:**
  - Background Imperio (escala epica).
  - Estruturas: Portais para outros mundos, Fortaleza (raids epicas), Torre dos Sabios (constelacoes).
- **Dependencias:** F04.01.
- **O que EU entrego em codigo:**
  - Expansao em settlement.
  - Portais como acessos a mini-zonas especiais.
- **O que o USUARIO entrega:**
  - Background do Imperio.
  - Sprites de cada nova estrutura.
- **Criterio de aceite:** evoluir Reino para Imperio. Acessar portal, entrar em mini-zona.
- **Riscos:** assets de qualidade epica consomem tempo. Mitigacao: escopo controlado.

### F05.02 Forja Cosmica

- **Status atual:** nao existe.
- **O que falta:** forja gigante destrancada apos Renascimento #1 (cross-ref roadmap 4.1; aqui no end-game expandida e populada).
  - Alimentada por **Esquirla Estelar** (drop de Mythic + completar Colecao).
  - Bonus globais de crafting (success rate, qualidade, custo reduzido).
  - Receitas unicas so forjaveis na Forja Cosmica.
- **Dependencias:** F03.15, F03.08, F04.05.
- **O que EU entrego em codigo:**
  - `scripts/systems/cosmic_forge.gd` (no nivel da conta).
  - Modal proprio.
  - Drop de Esquirla Estelar.
- **O que o USUARIO entrega:**
  - Lista de bonus globais por nivel da Forja.
  - Lista de receitas unicas.
- **Criterio de aceite:** dropar Mythic, alimentar Forja, subir nivel, ver bonus de crafting global.
- **Riscos:** baixo.

### F05.03 Biblioteca dos Antigos

- **Status atual:** nao existe.
- **O que falta:** estrutura na Cidade+ que ja existe desde Fase 03; aqui populada (cross-ref roadmap 4.2).
  - Cada pagina de Codex completada deposita "Conhecimento".
  - Conhecimento desbloqueia Tomos.
  - Cada Tomo lido da pequeno boost permanente em categoria de stat.
- **Dependencias:** F03.10 (Codex completo).
- **O que EU entrego em codigo:**
  - `scripts/systems/library.gd`.
  - Tomos como entidades com requisitos de Conhecimento.
- **O que o USUARIO entrega:**
  - Lista de Tomos.
  - Sprites de livros/tomos.
- **Criterio de aceite:** completar pagina de Bestiario, ver +X Conhecimento, comprar Tomo, ver bonus.
- **Riscos:** baixo.

### F05.04 Espelho dos Gemeos

- **Status atual:** nao existe.
- **O que falta:** estrutura no Reino+ (cross-ref roadmap 4.4).
  - 1x/dia (real-time) o jogador escolhe um personagem.
  - Aquele personagem ganha "sombra" com 50% dos stats por 24h.
  - Sombra farma em paralelo (efetivamente um 9o personagem temporario).
  - Limite: 1 sombra ativa por vez.
- **Dependencias:** F04.01.
- **O que EU entrego em codigo:**
  - `scripts/systems/twin_mirror.gd`.
  - Sombra como CharacterInstance temporario.
- **O que o USUARIO entrega:**
  - Sprite do Espelho.
  - Decisao sobre se a sombra herda equip ou nao `[DECISAO PENDENTE]`.
- **Criterio de aceite:** ativar Espelho com Warrior, ver sombra de Warrior aparecer no Acampamento, farmando.
- **Riscos:** dobrar contagem de farm explode economia. Mitigacao: 50% stats e cap de 1 sombra.

### F05.05 Pacto com Espiritos / Faccoes mutuamente exclusivas

- **Status atual:** nao existe.
- **O que falta:**
  - 3 faccoes mutuamente exclusivas (cross-ref roadmap 4.6, inspiracao Realm Grinder).
  - Cada faccao reformula buildings, spells (skills?), bonus de research.
  - Reincarnacao permite trocar.
- **Dependencias:** F04.05 (Ascensao - reset profundo).
- **O que EU entrego em codigo:**
  - `scripts/systems/faction.gd`.
  - Substituicao condicional de bonus em todo lugar relevante.
- **O que o USUARIO entrega:**
  - Definicao oficial das 3 faccoes (proposta inicial: Bem / Mal / Neutro).
  - Lista de buildings/skills/bonus por faccao.
  - Sprites tematicos por faccao.
- **Criterio de aceite:** escolher faccao Bem, ver buildings exclusivos, ver bonus aplicado. Reincarnar, trocar para Mal, ver mudanca.
- **Riscos:**
  - **Critico:** triplicar conteudo. Mitigacao: maior parte do conteudo e' compartilhado, faccao so muda 20%.
  - Faccao "obviamente melhor" estraga design. Mitigacao: cada faccao e' boa em algo unico.

### F05.06 Cronicas do Mundo

- **Status atual:** nao existe.
- **O que falta:** sistema de "tempo decorrido na conta" (real-time desde criacao do save) - cross-ref roadmap 4.7.
  - Milestones: 1 dia, 7 dias, 30 dias, 100 dias, 365 dias, 1000 dias.
  - Cada milestone da "Memoria do Tempo".
  - Memoria aplicada em trilha de bonus.
- **Dependencias:** F00.04 (timestamp do save).
- **O que EU entrego em codigo:**
  - `scripts/systems/chronicles.gd`.
  - Trilha de bonus visual.
- **O que o USUARIO entrega:**
  - Lista de bonus por milestone.
- **Criterio de aceite:** abrir save com 7+ dias, ver Memoria do Tempo aplicavel.
- **Riscos:** baixo.

### F05.07 Selos de Lideranca

- **Status atual:** nao existem.
- **O que falta:** ganhos por completar feitos com TODA a party em conjunto (cross-ref roadmap 4.8).
  - Bonus so ativos quando o personagem esta em dungeon/boss com outros.
- **Dependencias:** F03.02 (Dungeons), F03.12 (Selos de Conta).
- **O que EU entrego em codigo:**
  - `scripts/systems/leadership_seals.gd`.
  - Bonus condicionais ativos so em party.
- **O que o USUARIO entrega:**
  - Lista de Selos de Lideranca.
- **Criterio de aceite:** completar feita "todos personagens nivel 100", ver Selo desbloquear, bonus ativo so em dungeon.
- **Riscos:** baixo.

### F05.08 Colecao Mythic completa

- **Status atual:** F03.08 (colecao basica).
- **O que falta:** completar todas categorias em tier Mythic - meta "long tail" de 1000h+.
  - Bonus de set Mythic enorme.
  - Titulos exclusivos.
- **Dependencias:** F03.08.
- **O que EU entrego em codigo:**
  - Tracking ja existe; adicionar bonus extremos para Mythic completo.
- **O que o USUARIO entrega:**
  - Lista de itens Mythic existentes (cross-ref `01_design/equipment-catalog.md`).
- **Criterio de aceite:** simular no save um set completo Mythic e ver bonus aplicado.
- **Riscos:** baixo.

### F05.09 Arena Grao-Mestre+

- **Status atual:** F03.06 ate Diamante.
- **O que falta:** Mestre, Gladiador, Lendario, Mitico, Eternizado.
- **Dependencias:** F03.06.
- **O que EU entrego em codigo:**
  - Expansao da Arena com novos ranks.
- **O que o USUARIO entrega:**
  - Oponentes high-rank.
  - Cosmeticos exclusivos.
- **Criterio de aceite:** subir do Diamante para Mestre, ver oponente novo.
- **Riscos:** baixo.

### F05.10 Conteudo de season / expansao

- **Status atual:** infra basica de eventos (Fase 03/04).
- **O que falta:**
  - Sistema de "season pass" gratuito + premium (gated por Gemas).
  - Cada season de 60-90 dias com conteudo tematico, novas zonas temporarias, nova classe, nova faccao, etc.
- **Dependencias:** TUDO.
- **O que EU entrego em codigo:**
  - Framework de season (calendar + tracker de progresso).
- **O que o USUARIO entrega:**
  - Plano de seasons (cross-ref `00_meta/release-plan.md`).
- **Criterio de aceite:** ativar "Season 1: Floresta Sombria", ver tracker, completar 1 desafio.
- **Riscos:** burnout de criacao de conteudo. Mitigacao: pipeline de assets reutilizaveis (cross-ref `01_design/graphics-needs.md`).

---

## Ordem global recomendada

(Esta fase e' um menu de pos-launch. Pode ser reordenada conforme demanda do publico.)

1. F05.01 Imperio
2. F05.02 Forja Cosmica
3. F05.03 Biblioteca dos Antigos
4. F05.04 Espelho dos Gemeos
5. F05.06 Cronicas do Mundo
6. F05.07 Selos de Lideranca
7. F05.09 Arena Grao-Mestre+
8. F05.05 Pacto com Espiritos / Faccoes
9. F05.08 Colecao Mythic completa
10. F05.10 Conteudo de season

---

## Criterio de aceite global

- Imperio jogavel.
- Pelo menos 4 dos sistemas de bonus ativos (Forja, Biblioteca, Espelho, Cronicas).
- Faccoes funcionais (mesmo que com poucas exclusividades inicialmente).
- Framework de season pronto para receber conteudo recorrente.

---

## Riscos transversais

- **Mais critico:** burnout. Esta fase e' enorme e e' onde a maior parte dos jogos idle parou. Mitigacao: dividir em sub-releases (1 sistema por vez como expansion).
- **Critico:** balance global virando soup de multiplicadores. Mitigacao: auditoria periodica.
- **Medio:** UI saturada. Mitigacao: dashboard customizavel.

## Cross-references

- `00_meta/release-plan.md`
- `01_design/equipment-catalog.md`
- `01_design/events-catalog.md`
- `02_math/ascension-multipliers.md`
- `roadmap-sistemas.md` secao 4 (mecanicas de bonus extras)
