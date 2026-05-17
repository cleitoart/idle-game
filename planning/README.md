# Planning Hub - Idle Game

> Hub central de planejamento documental do projeto. Tudo aqui e' referencia viva entre sessoes.
> **Antes de qualquer trabalho neste projeto, leia `00_meta/progress-log.md` e `00_meta/self-instructions.md`.**

---

## Estrutura

### `00_meta/` - Processo e memoria

| Arquivo | O que contem |
|---|---|
| `self-instructions.md` | Contrato comigo (Claude). O que ler, quando atualizar, o que evitar. |
| `phase-navigation.md` | Visao macro: o que vem primeiro, o que e' meu, o que e' do usuario, qual juicy quando. |
| `progress-log.md` | Estado rolante do projeto. Atualizado a cada sessao com mudanca relevante. |
| `glossary.md` | Terminologia oficial do projeto. |
| `pending-decisions.md` | Lista mestre de 40 decisoes pendentes do usuario (numeradas, ranqueadas). |
| `psd-workflow.md` | Pipeline canonico para reconstruir tela do Photoshop como .tscn. |
| `release-plan.md` | MVP, beta, 1.0, 2.0, 3.0 e expansoes. |
| `localization-plan.md` | Estrategia de i18n (PT-BR, EN, ES). |

### `01_design/` - Conteudo de gameplay

| Arquivo | O que contem |
|---|---|
| `graphics-needs.md` | Catalogo completo de assets visuais a serem entregues pelo usuario. |
| `audio-needs.md` | Catalogo de SFX, musica e voz. |
| `ui-ux-wireframes.md` | Mockups ASCII e fluxos de navegacao por tela. |
| `account-vs-character.md` | Boundary de dados: o que fica na conta vs no personagem. |
| `classes-and-characters.md` | 10 classes + estados de awakening. |
| `skills-catalog.md` | Skills ativas/passivas por classe. |
| `equipment-catalog.md` | Itens equipaveis por slot e tier. |
| `enemies-catalog.md` | Catalogo completo de inimigos com drops. |
| `crafting-catalog.md` | Receitas de Smithing, Alchemy, Cooking, Sawmill, Leather, Enchanting. |
| `gathering-materials.md` | Materiais por skill de coleta e por zona. |
| `npcs-catalog.md` | NPCs do acampamento, quest givers, lore figures. |
| `quests-catalog.md` | Main, side, daily, weekly. |
| `pets-catalog.md` | Pets de combate, buff, expedicao. |
| `cards-catalog.md` | Cards regulares, corrupted, greedy + sets. |
| `events-catalog.md` | Eventos sazonais, invasoes, festivais. |
| `save-offline-spec.md` | Formato de save, offline progression, recovery. |

### `02_math/` - Formulas, curvas e tabelas

| Arquivo | O que contem |
|---|---|
| `progression-curves.md` | XP, gold, mob HP/ATK/DEF, level cap. |
| `damage-formula.md` | Formula de dano com crit, mitigacao, elementos. |
| `drop-rates.md` | Tabelas de drop por tier e raridade. |
| `balance-tables.md` | Stats recomendados zona-a-zona. |
| `ascension-multipliers.md` | Curvas de renascimento, transcendencia, ascensao cosmica. |
| `time-to-progress.md` | Estimativa em horas por marco. |

### `03_research/` - Referencias externas

| Arquivo | O que contem |
|---|---|
| `reference-games.md` | Catalogo de jogos pesquisados com sistemas aplicaveis. |
| `idle-genre-patterns.md` | Padroes do genero idle. |
| `gacha-patterns.md` | Padroes de gacha (filtrados pra nao-pay-to-win). |
| `wiki-reference-list.md` | Lista de wikis para consulta. |
| `ui-screenshots-references.md` | Capturas de UI notaveis com comentario. |

### `04_phases/` - Planos de fase

| Arquivo | O que contem |
|---|---|
| `phase-00-foundation.md` | Combate, stats, inventario, save, gold (base do que ja tem). |
| `phase-01-core-loops.md` | Mapa, skill tree basica, coleta inicial, crafting basico, acampamento estagio 1. |
| `phase-02-expansion.md` | Multi-personagem, classes, mais skills, vilarejo, status, pets, cards. |
| `phase-03-mid-game.md` | Cidade, dungeons, bosses, raids, arena, encantamentos, renascimento. |
| `phase-04-late-game.md` | Reino, transcendencia, constelacoes, NG+. |
| `phase-05-end-game.md` | Imperio, forja cosmica, biblioteca, espelho, selos de lideranca. |

### `05_juicy/` - Gamefeel

| Arquivo | O que contem |
|---|---|
| `juicy-catalog.md` | 60+ tecnicas de gamefeel com gatilhos de aplicacao. |
| `feedback-language.md` | Linguagem visual/audio coesa (cores, easing, tempos). |

---

## Convencoes globais

- **Zero emojis** em qualquer arquivo deste hub e em qualquer codigo do projeto.
- **PT-BR** como idioma principal.
- Cross-references entre arquivos via `[ver: caminho/arquivo.md#secao]`.
- `[PLACEHOLDER: descricao]` para conteudo visual/audio que o usuario ainda vai entregar.
- `[DECISAO PENDENTE: descricao]` para escolhas que ainda dependem do usuario.

---

## Origem dos dados

A fonte primaria e' `roadmap-sistemas.md` (raiz do projeto). Tudo aqui expande, detalha ou resolve ambiguidade dele. Quando houver conflito, este hub vence (porque contem decisoes mais recentes).

---

## Avisos importantes

- **`03_research/` precisa rerun**: na sessao inicial, `mcp__brave-search__*` foi negado, entao o Agente 4 trabalhou com conhecimento previo (jan/2026). Todas as URLs estao marcadas `[VERIFICAR]`. Antes de validar referencias externas, rodar nova passada com brave-search aprovado.
- **`00_meta/pending-decisions.md`**: 40 itens precisando palavra final do usuario. Os top 10 bloqueiam Fase 0 de implementacao.
