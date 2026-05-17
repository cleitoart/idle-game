# Fase 00 - Foundation

> Base ja existente em codigo + complementos essenciais para sustentar todas as demais fases. Conforme `roadmap-sistemas.md` secao 6 (Matriz de Dependencias).
>
> **Pre-condicao:** nenhuma. Esta e' a primeira fase.
> **Pos-condicao:** projeto suporta 1 personagem completo, com combate funcional, save/load, offline progression e inventario+equipamento expandido.
>
> **Status: FECHADA em 2026-05-06.** Validacao end-to-end pendente em playtest do usuario. Detalhes em `00_meta/progress-log.md`.

---

## Visao geral

Foundation **NAO e' um MVP jogavel sozinho**. E' a camada de fundacao tecnica e de loop curto. Tudo aqui serve a regra "stat invisivel morre" do `roadmap-sistemas.md` secao 1.1: cada item daqui sera referenciado/expandido em fases posteriores.

O criterio macro: ao final desta fase, **um jogador consegue ficar 1h no jogo, fechar e abrir sem perder progresso**.

---

## Decisoes aplicaveis a Fase 0 (todas confirmadas 2026-05-06)

Lista DEFINITIVA de premissas que valem para qualquer codigo desta fase. Cada item abaixo ja foi resolvido em `00_meta/pending-decisions.md`.

- [x] **Orientacao de tela:** landscape desktop (#5). Layout: sidebar + painel central + painel direito + footer. Sem suporte portrait nem mobile.
- [x] **Tile size:** variavel (#1). Pequenos 16-24px, medios 32-48px, grandes 64-96px, mini-boss/boss 128px. Cada inimigo declara seu proprio tamanho.
- [x] **Gold:** por CONTA (#19). Pool unico compartilhado entre todos personagens.
- [x] **Equipamento + inventario:** POR PERSONAGEM (#20). Cada personagem tem seu equip e seu inventario proprio. Bau Compartilhado entra na Fase 03.
- [x] **Tiers de raridade:** 6 (#12). Common, Uncommon, Rare, Epic, Legendary, Mythic. Item Common ja sai com slot estruturado para os 6 tiers.
- [x] **Velocidade de jogo:** 1x e 2x desde o inicio (#14). 4x e 8x sao unlocks futuros (Renascimento / Loja Eterna). Apesar do toggle so entrar na Fase 01, os Timers da Fase 0 ja respeitam `Engine.time_scale`.
- [x] **Offline cap:** 12h base (#18). 24h/48h/72h sao unlocks da Loja Eterna (Fase 03+).
- [x] **Plataforma:** Steam (PC) (#34). Sem suporte mobile/console/web ate 1.0+. Save em `user://save_<slot>.json` compativel com Steam Cloud.
- [x] **Idiomas:** PT-BR + EN (#36). Strings hardcoded toleradas na Fase 0 (proto), mas marcar `[TODO: localizar]` quando aparecerem. Migracao para `tr()` na Fase 02.
- [x] **Stats elementais:** zerados na base (#13). Cada classe comeca com 0 em Fire/Ice/Electric/Water/Wind/Rock/Light/Dark. Afinidade vem so via equip/skill/encantamento (Fase 02+). `CombatStats.from_character()` aplica zeros.
- [x] **Termos:** mistos (#39). DPS/Tank/Buff/Debuff/HP/MP/ATK/DEF em ingles em ambas versoes. Maestria/Renascimento/Acordar/Bestiario traduzem. Cross-ref `00_meta/localization-plan.md` secao 4.1.

Todas as decisoes acima sao CONGELADAS para a Fase 0. Mudanca exige novo registro em `progress-log.md`.

---

## Itens da fase

### F00.01 Combate (zona/estagio/area/wave)

- **Status atual:** funcional. Slimes verde/azul/roxo/vermelho com stats em ordem ascendente. Battle scene shifted up 64px. HP bar com toggle de numeros internos. Ver `progress-log.md` 2026-05-06.
- **O que falta:**
  - Tela de resultados pos-clear de area (move para Fase 01, ja referenciado em `01_design/ui-ux-wireframes.md`).
  - Modal de info de zona/estagio/area (move para Fase 01).
- **Ordem sugerida:** ja existe; nada a fazer aqui.
- **Dependencias:** nenhuma.
- **O que EU (Claude) entrego em codigo:**
  - Manutencao em `scenes/combat/combat_controller.gd` se aparecerem bugs.
  - Manutencao em `scenes/combat/combatant.gd` e `enemy.gd`.
  - Pequenos ajustes em `autoload/event_bus.gd` se novas signals forem necessarias para offline/save.
- **O que o USUARIO entrega:**
  - Validacao de jogabilidade em sessoes de 30+ minutos.
  - Decisao final sobre o pacing de cada slime (ja em `02_math/balance-tables.md` mas pode ajustar).
- **Criterio de aceite:** combate roda 1h sem crash. HP bar do inimigo nao "engasga".
- **Riscos:** nenhum critico identificado nesta camada. Refatoracao prematura e' anti-padrao aqui.

### F00.02 Stats basicos do jogador (expansao)

- **Status atual:** base existe (HP, MP, ATK, DEF, AtkSpeed). Stat points distribuiveis em level up. Ver `progress-log.md`.
- **O que falta:** estrutura para suportar TODOS os stats da secao 3.2 do roadmap, mesmo que muitos comecem zerados:
  - Stats primarios: STR, DEX, INT, VIT, LUK
  - Stats derivados de combate: Magic Attack, Magic Defense, Hit Number, Cast Speed, Cooldown Reduction
  - Stats de regen: HP Regen, MP Regen, Life Steal, MP Leech
  - Stats de chance: Crit Chance, Magic Crit Chance, Crit Damage, Block Chance, Dodge Chance, Hit Chance, Resist Status (% por status), Extra Hit, Accuracy
  - Stats elementais por elemento (Fire/Ice/Electric/Water/Wind/Rock/Light/Dark): Elemental Damage %, Elemental Resistance %
  - Stats de aquisicao: EXP Gain %, Gold Gain %, Loot Gain %, Equip Drop Chance %, Material Drop Chance %, Card Drop Chance %
  - Stats meta: Skill EXP Gain %, Mastery EXP Gain %
- **Ordem sugerida:** primeiro estruturar `combat_stats.gd` para conter todos os campos (com defaults sensatos), depois UI mostra apenas os relevantes hoje.
- **Dependencias:** F00.01.
- **O que EU entrego em codigo:**
  - Refatoracao em `scripts/systems/combat_stats.gd` para incluir todos os stats. Defaults: 0 ou 1.0 conforme tipo.
  - Adicao de campos correspondentes em `scripts/systems/character_instance.gd`.
  - Manutencao em `data/characters/warrior.tres` e demais .tres (placeholders ate balanceamento real).
  - Manutencao em `scenes/ui/modals/character_modal.gd` para esconder stats em zero ate serem relevantes.
- **O que o USUARIO entrega:**
  - Decisao final sobre os valores base de cada stat por classe (cross-ref `02_math/progression-curves.md`).
  - Stats elementais: ZERADOS na base (decidido #13). Afinidade vem de equip/skill/encantamento.
- **Criterio de aceite:** struct de stats persiste em save sem warning. Modal de personagem renderiza sem nan/null.
- **Riscos:** explosao de UI se mostrar tudo de uma vez. Mitigacao: progressive reveal (so mostrar stats ja relevantes para a fase atual do jogador).

### F00.03 Inventario + Equipamento (expansao)

- **Status atual:** base existe (inventario com merge de drops, slot de arma, alguns equipamentos em `data/items/`). Ver `progress-log.md`.
- **O que falta:**
  - Estrutura de slots completa: 4 armadura (Capacete, Peitoral, Calcas, Botas), 1 Colar, 1 Brincos, 2 Aneis, 1 Bracelete, 1 Arma. Ferramentas: Picareta, Machado, Vara de Pesca (apenas slots, ferramentas chegam na Fase 01).
  - Tier de raridade no item (Common por enquanto; Uncommon-Mythic em fases posteriores).
  - Stats fixos + slot para affixes aleatorios (vazio na Fase 00).
  - Slots visuais (transmog) - apenas estrutura, UI vem na Fase 02-03.
  - Slot de gema/runa - estrutura zerada.
- **Ordem sugerida:** estruturar `item_data.gd` antes de mexer na UI; depois `inventory_modal.gd` lista e modal de equipamento.
- **Dependencias:** F00.02 (stats precisam estar prontos para o equip aplicar).
- **O que EU entrego em codigo:**
  - Refatoracao em `scripts/data/item_data.gd` para incluir todos os campos (rarity, tier, slot type, stats fixos, lista de affixes vazia, encantamentos vazio).
  - Novo `scripts/systems/equipment_slots.gd` (ou expansao do existente) com 10 slots equipaveis + 3 slots de ferramenta.
  - Refatoracao em `scenes/ui/modals/inventory_modal.gd` para ler novos campos.
  - Novo `scenes/ui/modals/equipment_modal.gd` (se ja nao existir junto com character_modal).
  - Manutencao em `data/items/training_sword.tres` e demais para incluir os novos campos como placeholder.
- **O que o USUARIO entrega:**
  - Sprites dos slots vazios e cards de item. Cross-ref `01_design/graphics-needs.md` (P0).
  - Tiers de raridade: 6 confirmados (#12) — Common, Uncommon, Rare, Epic, Legendary, Mythic.
- **Criterio de aceite:** equipar/desequipar muda stats no character_modal sem crash. Save inclui todos os slots.
- **Riscos:** designer change de slots quebra saves antigos. Mitigacao: usar versao do save (cross-ref F00.04).

### F00.04 Save/Load + Offline progression

- **Status atual:** **PENDENTE.** Hoje o jogo nao salva.
- **O que falta:** tudo. Ver detalhes em `01_design/save-offline-spec.md`.
  - Formato de save (JSON em `user://save_<slot>.json` para inicio, migrar para binario depois se necessario).
  - Versionamento do save para futura migracao.
  - Save automatico: a cada 60s + a cada area clear + ao fechar o jogo.
  - Save manual: botao em Settings.
  - Multi-slot (3 slots de inicio, expansiveis via Loja Eterna).
  - Offline progression: ao abrir o jogo, calcular delta de tempo desde o ultimo save e simular ate cap (12h base).
- **Ordem sugerida:**
  1. Estrutura do dicionario de save (lista todos os campos a salvar).
  2. Implementar save/load basico.
  3. Testar perda/recovery (corrompendo arquivo).
  4. Implementar offline simulator.
  5. Tela de "voce ficou ausente por X" ao reabrir.
- **Dependencias:** F00.02, F00.03 (precisa saber o que salvar).
- **O que EU entrego em codigo:**
  - Novo autoload `autoload/save_manager.gd` com `save_game()`, `load_game()`, `simulate_offline()`.
  - Versionamento de schema dentro do save.
  - Integracao em `autoload/game_state.gd` para hook em area clear / level up / settings.
  - Nova tela `scenes/ui/modals/offline_summary_modal.gd` com pop ao reabrir.
  - Botao manual em `scenes/ui/right_panel.gd` ou settings (cross-ref `01_design/ui-ux-wireframes.md`).
- **O que o USUARIO entrega:**
  - Cap inicial: 12h (decidido #18). 24h/48h/72h sao unlocks da Loja Eterna (Fase 03+).
  - Validacao real: deixar o jogo fechado uma noite, abrir e ver se a recompensa parece justa.
  - Sprites do modal de "bem-vindo de volta" `[PLACEHOLDER: bg do modal offline summary]`.
- **Criterio de aceite:** fechar com 1000 gold, reabrir 30 min depois, ver gold + drops simulados. Save corrompido nao crasha o jogo (volta a save backup).
- **Riscos:**
  - **Critico:** offline simulator pode dar muito ou pouco recurso, quebrando o balance. Mitigacao: simular em chunks de 1 minuto, usar a mesma drop table do farm online (sem multipliers ate balancear).
  - Save corrompido sem backup: implementar backup rotativo (ultimos 3 saves).

### F00.05 Roster (1 personagem)

- **Status atual:** ja temos 1 personagem (Warrior). Ver `data/characters/warrior.tres`.
- **O que falta:** estrutura de "roster" preparada para multi-personagem (Fase 02), mesmo que so tenha 1 slot ativo.
- **Ordem sugerida:** ja temos; so estruturar.
- **Dependencias:** F00.02, F00.03.
- **O que EU entrego em codigo:**
  - Refatoracao em `autoload/game_state.gd` para guardar `roster: Array[CharacterInstance]` em vez de single character. Tamanho 1 por enquanto.
  - Tela de "roster overview" minimal `[PLACEHOLDER: ainda nao precisa visualmente]`. Pode ser apenas o character_modal ja existente, mas com estrutura de array.
- **O que o USUARIO entrega:**
  - Sprite do Warrior atualizado se quiser (ja temos placeholder). Ver `01_design/graphics-needs.md`.
- **Criterio de aceite:** save persiste roster como array. Codigo nao assume "single character" em mais nenhum lugar.
- **Riscos:** baixo. So um refactor preventivo.

### F00.06 Gold + Loot basico

- **Status atual:** funcional. Drops dao gold + items. Merge automatico de itens iguais funciona.
- **O que falta:** preparar a tabela de loot para suportar tiers, mesmo que so use Common na Fase 00.
- **Ordem sugerida:** baixa prioridade, alinhar com F00.03.
- **Dependencias:** F00.03.
- **O que EU entrego em codigo:**
  - Refatoracao em `data/enemies/slime.tres` para incluir drop table com peso por raridade.
  - Refatoracao em `scripts/data/enemy_data.gd` se necessario.
- **O que o USUARIO entrega:**
  - Validacao das drop rates iniciais (cross-ref `02_math/drop-rates.md`).
- **Criterio de aceite:** matar 100 slimes da uma quantidade de drops dentro do esperado da tabela.
- **Riscos:** drop rate frustrante na Fase 00 desmotiva playtest. Mitigacao: comecar generoso e apertar nas fases seguintes.

---

## Ordem global recomendada da fase

1. F00.02 Stats (base de tudo)
2. F00.03 Inventario+Equip (precisa de stats)
3. F00.05 Roster (refactor preventivo)
4. F00.06 Gold/Loot (alinha com novos itens)
5. F00.04 Save/Load+Offline (precisa de tudo acima estavel)
6. F00.01 manutencao continua

---

## Criterio de aceite global da Fase 00

Saida desta fase = jogabilidade autonoma sustentavel por 5h.

- Jogador consegue criar save, jogar 30 min, fechar, reabrir, continuar. Sem crash.
- Inventario suporta os 10 slots equipaveis + 3 ferramentas (POR PERSONAGEM, decisao #20).
- Gold compartilhado por CONTA (decisao #19).
- Stats de personagem incluem todos os campos da secao 3.2 do roadmap, mesmo que muitos zerados (incluindo elementais zerados, decisao #13).
- Save versionado, em formato compativel com Steam Cloud (decisao #34).
- Offline progression entrega recursos coerentes para 1h fechado, cap em 12h (decisao #18).
- Layout landscape desktop (decisao #5) — sem testar portrait/mobile.
- Tile size variavel respeitado pelos sprites de inimigos (decisao #1).
- 6 tiers de raridade ja estruturados em `item_data.gd`, mesmo que so Common esteja em uso (decisao #12).
- Codigo ja preparado para `Engine.time_scale` em 1x e 2x (decisao #14), mesmo que toggle so apareca na Fase 01.
- Strings novas marcam `[TODO: localizar]` para futura migracao a `tr()` (decisao #36).

---

## Riscos transversais

- **Mais critico:** offline progression mal calibrado. Pode tornar o jogo "melhor fechado" e desmotivar engajamento.
- **Medio:** super-engenharia de stats que nunca serao usados. Mitigacao: deixar struct mas nao implementar logica que custa CPU para zeros.
- **Baixo:** mudanca de schema de save no meio da fase. Mitigacao: ja comecar versionado.

## Cross-references

- `02_math/progression-curves.md` (curvas de XP/gold/HP)
- `02_math/balance-tables.md` (stats recomendados zona-a-zona)
- `01_design/save-offline-spec.md`
- `01_design/graphics-needs.md` (P0 desta fase)
- `01_design/ui-ux-wireframes.md`
- `roadmap-sistemas.md` secoes 1.1, 3.1, 3.2, 3.5, 3.10
