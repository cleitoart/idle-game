# Account vs Character - Boundary de Dados

> Define o que pertence a CONTA vs o que pertence ao PERSONAGEM. Decisao critica de arquitetura para multi-personagem (IdleOn-style). Fonte: `roadmap-sistemas.md` secao 3.10, 3.16, 3.18, 3.19.

---

## 1. Tabela master

| Categoria | Fica na Conta | Fica no Personagem | Notas |
|---|---|---|---|
| Gold | SIM (pool unico) | - | RESOLVIDO 2026-05-06 #19: gold compartilhado por todos os personagens |
| Gemas da Eternidade | SIM | - | Premium currency |
| Materiais (pre-Cidade / Fase 1-2) | - | SIM | Cada personagem tem inventario proprio |
| Materiais (pos-Bau Compartilhado, Fase 03 / Cidade) | SIM (compartilhado) | - | RESOLVIDO 2026-05-06 #21: Bau libera na Fase 03. Materiais entram primeiro. So itens com codex desbloqueado pelo personagem que coletou. |
| Equipamento equipado | - | SIM | RESOLVIDO 2026-05-06 #20: cada personagem usa seus proprios equipamentos |
| Equipamento no inventario | - | SIM (default) | RESOLVIDO 2026-05-06 #20: inventario e' POR PERSONAGEM. Bau Compartilhado de equipamentos libera DEPOIS dos materiais na Fase 03 e so aceita itens com codex desbloqueado pelo personagem que coletou (#21). |
| Bau Compartilhado (Fase 03+) | SIM (compartilhado) | - | RESOLVIDO 2026-05-06 #21: libera na Fase 03 (Cidade). Materiais primeiro, equipamentos depois. |
| Skins / cosmeticos da Loja Eterna | SIM | - | RESOLVIDO 2026-05-06 #22: ficam vinculados a CONTA. Persistem mesmo apos delete de personagem. |
| Selos | SIM (passiva global) | - | Aplicam em todos os personagens |
| Mob Slaughter global | SIM | - | Total kills entre todos personagens |
| Mob Slaughter individual | - | SIM | Kill counts separados |
| Codex Bestiario (info) | SIM | - | Compartilhado |
| Codex Materiais | SIM (acumula) | - | Material desbloqueado por qualquer personagem fica disponivel |
| Codex Receitas | SIM | - | |
| Codex Inimigos transcendidos | SIM | - | Apos primeira transcendencia |
| Cards (album) | SIM | - | Album e' de conta |
| Cards equipados (3 sets de 5) | - | SIM | Cada personagem tem seus slots independentes |
| Pets (collection) | SIM | - | Pets descobertos sao da conta |
| Pets equipados (combat/buff) | - | SIM | Cada personagem equipa seus proprios |
| Acampamento e estruturas | SIM | - | Acampamento e' compartilhado |
| Conquistas / Achievements | SIM (global) | parciais | Algumas tem componente individual |
| Tempo de jogo (Cronicas do Mundo) | SIM | - | [ver: roadmap-sistemas.md secao 4.7] |
| Compras da Loja Eterna | SIM | - | Slots, automatizacoes, melhorias permanentes globais |
| Nivel | - | SIM | Cada personagem 1-100 (cap inicial) |
| Nivel total somado | SIM (calculado) | - | Usado para liberar slots de novo personagem |
| Skill tree | - | SIM | Pontos individuais, escolhas individuais |
| Mastery em gathering | - | SIM | Cada personagem tem mastery propria por item |
| Atribuicao atual (zona/atividade) | - | SIM | Cada personagem em paralelo |
| Awakening (estrelas, ramo escolhido) | - | SIM | Apos primeiro Renascimento |
| Renascimentos do personagem | - | SIM | Estrelas individuais |
| Transcended Points do personagem | - | SIM | Apos transcendencia individual |
| Moedas Galacticas | SIM | - | Apos Ascensao Cosmica (e' reset de conta) |
| Constelacoes (pontos e nodes) | SIM | - | Late-game, conta-global |
| Titulos (todos ativos simultaneos) | - | SIM | Conquistados individualmente, mas todos ativos |
| Cosmeticos / Skins | SIM | - | RESOLVIDO 2026-05-06 #22: vinculados a CONTA. Persistem apos delete de personagem. Aplicaveis a qualquer personagem que pode usar. |
| Configuracoes de UI / settings | SIM | - | |
| Cronicas do Mundo (tempo total) | SIM | - | [ver: roadmap-sistemas.md secao 4.7] |
| Forja Cosmica | SIM | - | Acumula Esquirla Estelar |
| Biblioteca dos Antigos | SIM | - | Conhecimento depositado |
| Espelho dos Gemeos (1x/dia) | SIM (cooldown) | - | |

---

## 2. Materiais antes do Armazem da Cidade

[ver: roadmap-sistemas.md secao 3.16]

- **Pre-Cidade:** cada personagem tem inventario proprio. Materiais coletados por A nao podem ser usados por B sem trade explicito (que e' caro/limitado).
- **Acampamento estagio 1 (basico) e 2 (Vilarejo):** sem compartilhamento.

## 3. Materiais apos Armazem da Cidade (estagio 3)

- **Apos Armazem da Cidade:** materiais sao compartilhados.
- **Restricao:** so itens com codice **desbloqueado pelo personagem que coletou** entram no Armazem.
  - Exemplo: Personagem A coletou Minerio de Cobre 1x. Codice de Cobre desbloqueia para A. A partir de agora, qualquer Minerio de Cobre que A coletar pode ir para o Armazem. Mas se B nunca coletou Cobre, B precisa coletar pelo menos 1x para tambem mandar Cobre para o Armazem.
- **Exclusoes do Armazem:** armas, armaduras, acessorios, equipamentos, itens de quest. Apenas materiais.

RESOLVIDO 2026-05-06 #21: SIM, Bau Compartilhado existe e libera na FASE 03 (Mid-Game / Cidade). Materiais entram primeiro, equipamentos entram depois. Restricao do Bau de equipamentos: so aceita item cujo codex foi desbloqueado pelo personagem que o coletou. Antes da Fase 03, equipamento permanece estritamente no inventario do personagem que dropou.

---

## 4. Gold por conta ou por personagem? (RESOLVIDO)

RESOLVIDO 2026-05-06 #19: **Gold por CONTA**, pool unico compartilhado por todos os personagens.

Razao: jogo e' multi-personagem em paralelo (estilo IdleOn). Forcar gold por personagem criaria friction onde a feature multi-personagem deveria reduzir friction. Compras na Loja, Mercado, Catedral, etc. saem de um pote unico. Personagem novo nao comeca pobre se a conta for rica.

---

## 5. Equipamento no inventario por conta ou personagem? (RESOLVIDO)

RESOLVIDO 2026-05-06 #20: **Equipamento e inventario por PERSONAGEM** (cada personagem tem seu inventario proprio). Compartilhamento entre personagens acontece via **Bau Compartilhado** que libera na Fase 03 (Cidade) (#21), NAO por default.

Razao: design multi-personagem com identidades distintas. Cada um faz seu farm e cuida do seu loadout. Apenas APOS a Fase 03 e' que itens com codex desbloqueado entram em pool compartilhado opt-in via Bau.

---

## 6. Mockup ASCII - Tela de Conta

```
+------------------------------------------------------------------+
|                    CONTA - [Nome do Save]                        |
+------------------------------------------------------------------+
| Personagens: 5/10            Tempo de jogo: 124h 32min            |
| Nivel total somado: 487      Cronicas: 5d 4h (proximo: 7d em 2d)  |
| Total kills: 47,283          Achievements: 142/500                |
+------------------------------------------------------------------+
|                                                                  |
|  GEMAS DA ETERNIDADE: [ 247 ]  GOLD: [ 1,247,532 g ]              |
|  MOEDAS GALACTICAS: [ 0 ]      GLORY: [ 380 ]                     |
|                                                                  |
+------------------------------------------------------------------+
| [SELOS ATIVOS] (12)                                              |
|  - Veterano de Goblins (+5% dano vs Human)                       |
|  - Mestre Mineiro (+5% Mining Speed global)                      |
|  - 100k Kills (+10% LUK global)                                  |
|  ... +9 mais                                                     |
+------------------------------------------------------------------+
| [BOTOES PRINCIPAIS]                                              |
|  [ Loja Eterna ]    [ Selos ]      [ Conquistas ]                |
|  [ Album de Cards ] [ Pets ]       [ Cronicas ]                  |
|  [ Forja Cosmica ]  [ Biblioteca ] [ Espelho Gemeos ]            |
|  [ Configuracoes de Conta ]        [ Sair / Salvar ]             |
+------------------------------------------------------------------+
| [ROSTER OVERVIEW]                                                |
|                                                                  |
|  [Warrior - Lv 87]      Floresta Z3 A2 - 1247 kills/h            |
|  [Mage - Lv 64]         Caverna Z2 A1 - mining mithril           |
|  [Ranger - Lv 71]       Pantano Z1 A3 - 891 kills/h              |
|  [Cleric - Lv 45]       Acampamento - cooking Banquete           |
|  [Berserker - Lv 38]    Floresta Z2 A4 - 612 kills/h             |
|                                                                  |
|  [+ Recrutar novo personagem (precisa nivel 500 total)]          |
+------------------------------------------------------------------+
```

---

## 7. Renascimento, Transcendencia, Ascensao - o que se preserva

### Renascimento de personagem (Lv 100 -> ★1)
- Reseta: nivel, equipamentos equipados, skills aprendidas (a maioria), inventario do personagem (materiais), codice individual (materiais)
- Mantem: Acampamento, Loja Eterna, Conquistas, Album de Cards, Pets, Codex Bestiario, slots de inventario expandidos, slots de personagem expandidos

### Transcendencia (Lv 1000 + codex completo -> Transcended Points)
- Reseta: tudo do personagem + experiencia + items + niveis
- Mantem: Loja Eterna, Pets, Codex Bestiario (e ganha aba Transcendido), Conquistas

### Ascensao Cosmica (reset de conta)
- Reseta: tudo, incluindo Acampamento e estruturas
- Mantem: Cards (album todo), Bestiario, Pets, Conquistas, Compras da Loja Eterna, Pontos de Constelacao
- Ganha: Multiplicador Cosmico permanente, Moedas Galacticas, novo conteudo desbloqueado (zonas, dificuldades)

[ver: roadmap-sistemas.md secao 3.19 — detalhes completos]

---

## 8. Pendencias

- ~~Gold por conta vs por personagem.~~ (RESOLVIDO 2026-05-06 #19: por CONTA, pool unico.)
- ~~Equipamento no inventario por conta vs por personagem.~~ (RESOLVIDO 2026-05-06 #20: por PERSONAGEM.)
- ~~Bau Compartilhado para equip.~~ (RESOLVIDO 2026-05-06 #21: SIM, libera na Fase 03 / Cidade. Materiais primeiro, equipamentos depois com restricao de codex.)
- ~~Skin/cosmetico apos delete de personagem.~~ (RESOLVIDO 2026-05-06 #22: ficam vinculados a CONTA, persistem apos delete de personagem.)
- [PLACEHOLDER: layout final da Tela de Conta — em landscape desktop (RESOLVIDO 2026-05-06 #5).]
- [PLACEHOLDER: tela de Cronicas do Mundo detalhada]

---

## Termos novos introduzidos neste arquivo

- "Roster Overview" — tela inicial de selecao de personagem.
- "Bau Compartilhado" — sub-feature em decisao pendente.
- "Trade explicito" — mecanica em decisao pendente para pre-Cidade.
