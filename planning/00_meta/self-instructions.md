# Self-Instructions - Contrato comigo (Claude)

> Este arquivo e' meu contrato pessoal. Ler no inicio de **toda** sessao deste projeto, antes de qualquer outro arquivo.

---

## Regras inegociaveis

1. **Ler `00_meta/progress-log.md` ANTES de qualquer trabalho neste projeto.** E' a foto mais recente do estado.
2. **Atualizar `00_meta/progress-log.md` no FINAL de toda sessao com mudanca relevante.** Append de no maximo 30 linhas. Nunca reescrever entradas antigas.
3. **Antes de propor qualquer feature nova:**
   - Conferir `01_design/` para ver se ja esta catalogada.
   - Conferir `04_phases/` para ver se ja esta planejada para uma fase.
   - Se ja estiver planejada -> seguir o plano existente.
   - Se NAO estiver -> ALERTAR o usuario que isso e' inedito antes de planejar.
4. **Antes de qualquer matematica nova (curva, formula, tabela):**
   - Conferir `02_math/`.
   - Se ja existe -> usar.
   - Se nao existe -> propor adicao + justificar.
5. **Zero emojis.** Em qualquer arquivo, codigo, UI, string, commit message ou resposta no chat para este projeto.
6. **Nao duplicar conteudo entre arquivos.** Usar `[ver: caminho/arquivo.md#secao]` em vez de copiar.
7. **Atualizar `glossary.md` quando introduzir termo novo.** Definicao curta, link pro arquivo onde foi introduzido.
8. **Marcar pendencias visiveis:** `[PLACEHOLDER: descricao]` para asset que falta, `[DECISAO PENDENTE: descricao]` para escolha que falta.
9. **PT-BR como idioma de tudo** que estiver em `planning/`. Strings de codigo seguem o que o `localization-plan.md` definir.

---

## Estado vs proposito

Este projeto e' um **idle RPG multi-personagem** em Godot 4.6. O paradigma e' IdleOn-style (cada personagem farma em paralelo, juntam em dungeons), auto-battle puro (build > APM), com roadmap de 3-5 anos.

A fonte primaria das decisoes e' `roadmap-sistemas.md` na raiz do projeto. Conflito com este hub -> ESTE HUB VENCE (porque agrega decisoes mais novas).

---

## Como reagir a tipos de pedido do usuario

### "Implementa X" (codigo)
1. Ler `progress-log.md`.
2. Conferir se X esta em `04_phases/` -> qual fase, qual ordem.
3. Conferir se X tem balanceamento em `02_math/`.
4. Conferir se X tem assets prontos em `01_design/graphics-needs.md` -> se nao, alertar usuario.
5. Implementar.
6. Atualizar `progress-log.md`.

### "Planeja X" (so docs)
1. Ler `progress-log.md`.
2. Conferir se ja foi planejado.
3. Se nao -> escolher o arquivo certo em `01_design/` ou `04_phases/`, expandir.
4. Atualizar `progress-log.md` mencionando que docs mudaram.

### "Adiciona inimigo/item/skill"
1. Conferir o catalogo correspondente (`enemies-catalog.md`, `equipment-catalog.md`, `skills-catalog.md`).
2. Se ja esta la -> ok, criar o `.tres`/codigo.
3. Se nao esta -> ADICIONAR ao catalogo primeiro, depois implementar.
4. Atualizar `cards-catalog.md` se for inimigo (todo inimigo tem 1 card).

### "Mudou minha ideia sobre Y"
1. Ler arquivo afetado.
2. Atualizar arquivo.
3. Procurar referencias cruzadas (`[ver: ...]`) que apontam para Y.
4. Atualizar essas referencias.
5. Atualizar `glossary.md` se a terminologia mudou.
6. Atualizar `progress-log.md`.

---

## Sinais de que estou perdendo o fio

Se eu me pegar:
- Implementando algo que nao tem entry em `01_design/` -> PARAR, alertar o usuario.
- Inventando numero do nada (HP de inimigo, drop rate) -> PARAR, ler `02_math/`.
- Replicando texto que ja vi em outro arquivo -> PARAR, refatorar pra cross-reference.
- Sem saber qual fase a feature pertence -> PARAR, ler `04_phases/`.

---

## Limites do que posso decidir sozinho

**Posso decidir sozinho:**
- Formato de tabela ou markdown.
- Nome de variaveis/classes em codigo.
- Estrutura de pastas dentro de `planning/`.
- Pequenos ajustes de balanceamento (within reason, registrar no log).

**Preciso confirmar com o usuario:**
- Mudancas de balance que impactam progressao (ex: alterar curva de XP).
- Adicao de feature nao listada no roadmap.
- Remocao de feature listada no roadmap.
- Mudanca de visual/audio sem ele ter pedido.
- Decisoes marcadas `[DECISAO PENDENTE]` em qualquer arquivo.
