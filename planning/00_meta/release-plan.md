# Release Plan - MVP, Beta, 1.0, 2.0, 3.0+

> Plano de releases com criterios de "ready to ship", risco e estimativa de tempo. Cross-ref `phase-navigation.md` para timeline detalhada.
>
> **Premissa:** "release" aqui e' um marco interno que pode (ou nao) ser publicizado. Decisao final de quando publicar fica com o usuario.

---

## Decisoes de release fechadas (2026-05-06)

- **Plataforma (#34):** STEAM (PC primeiro). Multi-plataforma (mobile, console, web) fica para updates pos-1.0. Steam Cloud, Steam Achievements e overlay sao alvo nativo desde o MVP.
- **Monetizacao (#33):** FREE no Steam + Gemas pagas via Loja Eterna para cosmeticos, slots de inventario/personagem, automacoes de QoL e melhorias permanentes nao pay-to-win. Gemas tambem sao ganhas in-game (prestige, achievements, eventos, quests, free-gift, tempo de jogo) — comprar acelera mas nao desbloqueia poder unico.
- **Alfa (#35):** SOLO ate o jogo ter 30h+ de conteudo jogavel. Apos esse marco, alfa fechada com 5-15 convidados (ciclo de feedback). Beta publica vem depois da alfa. 1.0 vem depois da beta.
- **Idiomas R1.0 (#36):** PT-BR + EN. Outros idiomas (ES, FR, JP, KR, ZH) entram em updates pos-1.0. Cross-ref `localization-plan.md`.

### Timeline de publicacao oficial

| Marco | Audiencia | Pre-requisito | Estimativa |
|---|---|---|---|
| Solo dev | so o usuario | nada | ate ter 30h+ de gameplay sustentavel (estimativa: 6-9 meses solo apos hoje) |
| Alfa fechada | 5-15 convidados | 30h+ de conteudo + save robusto | 1-3 ciclos de feedback (1-2 meses cada) |
| Beta publica | comunidade aberta | alfa concluida + bugs P0 zerados | Steam Early Access OU Discord aberto, ~3-6 meses antes do 1.0 |
| Release 1.0 | publico Steam | beta concluida + criterios de 1.0 abaixo | release oficial na Steam |

---

## MVP - Alfa Interna (Fase 00 + parte da Fase 01)

**Objetivo:** ter o jogo jogavel em sessoes autonomas de **5 horas continuas** sem crash, sem necessidade de reset.

**Conteudo:**
- Combate funcional em 1 zona (Floresta) com 5 estagios.
- 1 personagem (Warrior) com level cap 100 (mas level 30+ ja e' suficiente para alfa).
- Save/Load + Offline progression ate 12h.
- Inventario com 10 slots equipaveis funcionais.
- Sistema de stats expandido (todos os campos, mesmo zerados).
- Mapa basico (textual, sem arte fina).
- Codex/Bestiario simples (apenas listagem).
- Tela de resultados pos-clear de area.
- Sistema de velocidade 1x/2x.

**Criterio "ready to ship" (alfa interna):**
- 5h de jogo continuo sem crash.
- Save persistente entre sessoes (Steam Cloud opcional ja).
- Offline progression entrega recursos coerentes.
- Loop curto (combate -> drop) e medio (area clear -> resultado) funcionais.
- Audiencia: SOLO (so o usuario). Alfa convidados so apos 30h+ de gameplay (#35).

**Risco:** baixo. Features ja em codigo + completar essenciais.

**Tempo estimado:** 2-3 meses a partir de hoje (2026-05-06).

---

## Beta Fechada (Fase 01 completa + parte da Fase 02)

**Objetivo:** **30 horas** de gameplay sustentavel para tester escolhido. Loop de gathering+crafting+combate completo.

**Conteudo adicional ao MVP:**
- 2 zonas completas (Floresta + Z2 - sugerido: Caverna).
- Mining + Woodcutting + Fishing funcionais (com mastery por item).
- Smithing + Smelting + Cooking basico.
- Acampamento estagio 1 visivel e funcional.
- Skill tree textual com 3 ramos do Warrior.
- 3 personagens jogaveis (Warrior + Mage + Ranger sugeridos).
- Vilarejo (estagio 2 do Acampamento).
- Pets de buff (3-5 pets desbloqueaveis).
- Cards regulares (drop e album).
- Encantamentos basicos (mundane tier).
- Refinamento basico (+1 ate +5).
- Status effects iniciais (Poison, Burning, Slowed, Stun, ATK Up!).
- Loja basica de gold.
- Eventos rotativos basicos (Festivais).

**Criterio "ready to ship" (beta fechada):**
- Tester chegando organicamente a level 50+ em 1 personagem em ~20-25h.
- 3 personagens em paralelo nao crashando.
- Save robustez (fechar e abrir 50+ vezes sem perder dados).
- 0 bugs P0 conhecidos.
- Audiencia: 5-15 convidados (alfa fechada conforme #35). Recrutamento via Discord pessoal/comunidade idle.

**Risco:** medio. Multi-personagem em paralelo introduz complexidade tecnica.

**Tempo estimado:** 6-9 meses a partir de hoje.

---

## Release 1.0 (Fase 02 completa + Fase 03 completa)

**Objetivo:** **100h+** de conteudo. Primeira release publica.

**Conteudo adicional ao Beta:**
- Cidade (estagio 3 do Acampamento) + Mercado + Guilda + Armazem.
- Dungeons jogaveis (1-2 dungeons em Normal, 1 em Hard).
- Formacao 3x2 com auras.
- Bosses no estagio 10 de cada zona (3-4 zonas).
- Mini-bosses + inimigos elites + raros casos de Shiny.
- Sistema de prioridade de skills (modo simples; avancado via Loja Eterna).
- Renascimento (★1-★3 jogavel).
- Awakening: 1 ramo por classe disponivel (★3).
- Constelacoes: introduzidas (1 constelacao desbloqueavel).
- Arena: ate Diamante.
- Gemas da Eternidade + Loja Eterna.
- Codex completo (todas abas).
- Selos de Conta + Titulos.
- Itens usaveis: pocoes, comida, pergaminhos.
- Raids ocasionais.
- 4-5 personagens completos.
- 5 classes balanceadas.
- 5 zonas (cross-ref `01_design/enemies-catalog.md`).

**Criterio "ready to ship" (1.0 publica):**
- 100h de gameplay sem repetir o "mesmo conteudo todo dia".
- 5 classes equilibradas (nenhuma OP, nenhuma vazia).
- Tutorial in-game para Renascimento.
- Localizacao PT-BR + EN (cross-ref `localization-plan.md`).
- Sistema de bug-report in-game (sugerido).
- Politicas de privacidade e termos prontos (Steam exige).
- **Plataforma:** Steam (PC). Multi-plataforma fica para 1.x+ se demanda confirmar.
- **Monetizacao:** Free + Loja Eterna (Gemas) ativa. Catalogo inicial: cosmeticos, slots extras, automacoes QoL, expansao de offline cap (24h/48h/72h).
- Steam achievements implementados (>=20 achievements core).
- Steam Cloud sync funcionando.
- Beta publica concluida com >=2 ciclos de patch.

**Risco:** alto. Renascimento + Awakening + Dungeons = 3 sistemas grandes que interagem.

**Tempo estimado:** 12-18 meses a partir de hoje.

---

## Patch 1.1 (Pos-launch, ajustes)

**Objetivo:** corrigir o que vier no feedback do publico de 1.0.

**Conteudo:**
- Bug fixes prioritarios.
- Balance pass: classes, drop rates, dungeon dificuldade.
- Pequenos QoL pedidos pela comunidade.
- Eventos sazonais leves (Halloween, Natal) se data permitir.

**Tempo estimado:** 1-3 meses pos-1.0.

---

## Patch 1.2 - 1.3 (Conteudo lateral)

**Objetivo:** adicionar zonas Z3 e Z4 + classes adicionais (chegar a 7-8 classes total).

**Conteudo:**
- 2 zonas novas com inimigos, bestiario, gathering spots.
- 2-3 classes novas (cross-ref `01_design/classes-and-characters.md`).
- Mais skills de coleta (Herbalism aprofundado, Hunting).
- Awakening expandido (★5 disponivel).
- Mais dungeons.

**Tempo estimado:** 3-6 meses cada patch.

---

## Release 2.0 (Fase 04 completa)

**Objetivo:** Late-game profundo. Primeiro grande update.

**Conteudo adicional a 1.x:**
- Reino (estagio 4 do Acampamento) + Academia (evolucao de skills).
- Transcendencia (com Codex Transcendido e Arvore de Transcendencia).
- Constelacoes completas (5 constelacoes).
- Ascensao Cosmica (primeira) + NG+1.
- World Tree + Titanica encontradas na Floresta.
- 2 zonas novas (Z5, Z6).
- Eventos sazonais robustos.
- Awakening: ate ★7-9 jogavel.
- Forja Cosmica (introduzida).
- Multiplos NG+ (ate NG+3).

**Criterio "ready to ship" (2.0):**
- Transcendencia jogavel em 2-3 ciclos sem quebrar economia.
- Constelacoes balanceadas.
- 200h+ de conteudo.
- Tutoriais para Transcendencia e Ascensao.

**Risco:** muito alto. Curva de prestigio compostas.

**Tempo estimado:** 16-24 meses a partir de hoje.

---

## Release 3.0 (Fase 05 inicial)

**Objetivo:** End-game e estrutura de seasons.

**Conteudo adicional a 2.x:**
- Imperio (estagio 5 do Acampamento).
- Forja Cosmica completa.
- Biblioteca dos Antigos.
- Espelho dos Gemeos.
- Pacto com Espiritos / Faccoes mutuamente exclusivas.
- Cronicas do Mundo.
- Selos de Lideranca.
- Arena Grao-Mestre+.
- Framework de seasons.
- Awakening completo (★10 acessivel).

**Criterio "ready to ship" (3.0):**
- Faccoes balanceadas (3 caminhos viaveis).
- Sistema de season pronto para receber conteudo recorrente.
- 500h+ de conteudo total.

**Risco:** muito alto. Triplicacao parcial de conteudo via faccoes.

**Tempo estimado:** 20-30 meses a partir de hoje.

---

## Release 3.x (Seasons recorrentes)

**Objetivo:** longevidade contínua.

**Conteudo:**
- A cada 60-90 dias: nova season tematica.
- Cada season pode trazer:
  - 1 zona temporaria.
  - 1 boss exclusivo.
  - 1 conjunto de cosmeticos exclusivos.
  - Eventos cross-zona.
  - Raids especiais.
  - Conteudo PvE competitivo (leaderboards).

**Risco:** burnout de criacao de conteudo. Mitigacao: pipeline de assets reutilizaveis.

**Tempo estimado:** 60-90 dias por season.

---

## Resumo - Tabela de Releases

| Release | Pre-requisito | Conteudo principal | Tempo total ate |
|---|---|---|---|
| MVP (alfa) | nada | F00 + parte F01 | 2-3 meses |
| Beta fechada | MVP | F01 + parte F02 | 6-9 meses |
| Release 1.0 | Beta | F02 + F03 | 12-18 meses |
| Patch 1.1 | 1.0 | bug fixes + balance | +1-3 meses |
| Patch 1.2-1.3 | 1.1 | Z3/Z4 + classes | +6-12 meses |
| Release 2.0 | 1.x | F04 | 16-24 meses |
| Release 3.0 | 2.x | F05 inicial | 20-30 meses |
| Release 3.x | 3.0 | seasons | recorrente |

---

## Decisoes pendentes deste plano

Todas as decisoes criticas de release foram resolvidas em 2026-05-06. Ver secao "Decisoes de release fechadas" no topo deste documento.

Pendencias residuais:
- Definir cronograma exato (semanas) entre alfa fechada -> beta publica -> 1.0.
- Decidir se beta publica usa Steam Early Access ou Discord aberto (favoravel: Steam EA para gerar wishlists).
- Catalogo inicial detalhado da Loja Eterna (cross-ref `01_design/account-vs-character.md`).

---

## Cross-references

- `phase-navigation.md`
- `progress-log.md`
- `localization-plan.md`
- `04_phases/phase-XX-*.md`
- `roadmap-sistemas.md`
