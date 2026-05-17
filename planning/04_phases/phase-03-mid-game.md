# Fase 03 - Mid-Game

> Saida do "core idle competente" para o **idle denso**. E' aqui que entra o conteudo de party (Dungeons), prestigio inicial (Renascimento) e a moeda meta (Gemas). Pos-Fase 03, o jogo tem **longevidade real**.
>
> **Pre-condicao:** Fase 02 completa.
> **Pos-condicao:** Cidade desbloqueada. Dungeons jogaveis. Primeira camada de prestigio (Renascimento + Awakening) ativa. Sistema de prioridade de skills. Codex completo.

---

## Visao geral

A Fase 03 e' onde se concentra a maior parte da magia do `roadmap-sistemas.md`. Recomendo dividir em 03a (conteudo de party + bosses), 03b (sistemas de skill avancados + colecao), 03c (prestigio + meta-loja).

Risco principal: querer tudo isso pronto em 1 sprint. Cada item abaixo merece 1-2 semanas de polish.

---

## Itens da fase

### F03.01 Acampamento estagio 3 (Cidade) + Bau Compartilhado

- **Status atual:** so Vilarejo (Fase 02).
- **O que falta:**
  - Background novo (Cidade).
  - Estruturas adicionais: Mercado (loja maior), Guilda (quests diarias/semanais), **Bau Compartilhado / Armazem** (slots compartilhados entre personagens).
  - Boost global de Cidade `[DECISAO PENDENTE: +15% gold gain ou +1 slot de inventario por personagem?]`.
- **Bau Compartilhado (decidido #21, destaque desta fase):**
  - Liberado quando o Acampamento evolui para CIDADE (esta fase, F03.01).
  - **Materiais primeiro, equipamentos depois.** Materiais descobertos por qualquer personagem ja podem ser depositados/sacados livremente entre o roster.
  - Equipamentos so podem ser depositados quando o tipo+tier desse equipamento ja esta no codex desbloqueado pelo personagem que coletou. Item nao codexado fica preso no inventario do personagem que pegou.
  - Cosmeticos / skins / itens da Loja Eterna ja sao por CONTA por padrao (decisao #22) e nao precisam do Bau.
- **Dependencias:** F02.04, F02.11.
- **O que EU entrego em codigo:**
  - Expansao em `settlement_view.tscn` para o novo estagio.
  - Novo `scripts/systems/shared_storage.gd` (Bau Compartilhado: pool de materiais + pool restrito de equipamentos com regra de codex).
  - Modal do Bau (filtros por tipo: Materiais / Equipamentos / Cosmeticos).
  - Modal de Guilda com quest list (depende de quests serem catalogadas).
- **O que o USUARIO entrega:**
  - Background da Cidade.
  - Sprites de Mercado, Guilda, Bau Compartilhado.
  - Lista oficial de quests iniciais (cross-ref `01_design/quests-catalog.md`).
- **Criterio de aceite:** evoluir Vilarejo para Cidade. Estruturas novas funcionam. Bau aceita materiais imediatamente; equipamentos so apos o tipo+tier estar no codex do personagem que coletou. Trocar equipamento entre dois personagens via Bau funciona quando ambos atendem ao requisito de codex.
- **Riscos:** Bau com regras complexas (so equipamentos codexados). Mitigacao: tooltip explicativo + filtro visual do que e' depositavel.

### F03.02 Dungeons (party 3-5, formacao 3x2 com sinergias)

- **Status atual:** nao existe.
- **O que falta:**
  - Cena de dungeon (multi-character battle).
  - Formacao 3x2 com 5 slots (cross-ref roadmap 3.24, inspiracao Crusaders of the Lost Idols).
  - Auras passivas com range (adjacente, mesma coluna, mesma linha, toda party, diagonal).
  - Wave count fixo + boss final.
  - Loot exclusivo (set pieces, materiais raros).
  - Dificuldades: Normal, Hard, Heroic, Mythic (so Normal e Hard nesta fase; Heroic/Mythic na Fase 04+).
  - Pre-set de formacoes salvas (5 layouts).
- **Ordem sugerida:** primeiro a primeira dungeon Normal funcional; depois sistema de formacao; depois Hard.
- **Dependencias:** F02.01 (multi-personagem), F02.02 (classes diferentes geram sinergias).
- **O que EU entrego em codigo:**
  - Nova cena `scenes/views/dungeon_view.tscn`.
  - Novo `scripts/systems/dungeon_runner.gd`.
  - Novo `scripts/systems/formation.gd` (grade 3x2 + calculo de auras).
  - Modal de pre-dungeon (selecionar party + formacao).
  - Novo `scripts/data/dungeon_data.gd`.
- **O que o USUARIO entrega:**
  - Sprites de dungeon (background + tiles).
  - Lista oficial de auras por classe (cross-ref `01_design/skills-catalog.md`).
  - Drop tables exclusivos de dungeon.
- **Criterio de aceite:** entrar em dungeon com 3 personagens, formacao funcional, auras aplicadas, boss derrotavel, drop unico.
- **Riscos:**
  - **Critico:** balance da formacao (uma combinacao quebra tudo). Mitigacao: playtest dedicado, capear bonus em +50% por aura.
  - Tela cheia com 5 personagens fica caotica. Mitigacao: design restrito (cross-ref `01_design/ui-ux-wireframes.md`).

### F03.03 Mini-bosses e Bosses regulares

- **Status atual:** nao existem.
- **O que falta:**
  - Boss no estagio 10 de cada zona.
  - Mini-boss em areas 5-7 (cross-ref roadmap 3.1).
  - Visual diferenciado (HP bar maior, intro animation, music change).
  - Drop garantido + chance de drop unico.
- **Ordem sugerida:** mini-bosses primeiro (mais simples), bosses depois.
- **Dependencias:** F02 inteira.
- **O que EU entrego em codigo:**
  - Sub-tipo de inimigo "boss" em `enemy_data.gd`.
  - Trigger de wave especial em `combat_controller.gd`.
  - Ajustes em HP bar para bosses (barra grande embaixo).
- **O que o USUARIO entrega:**
  - Sprites + animacoes de bosses. Cross-ref `01_design/enemies-catalog.md`.
  - Music stinger de boss `[PLACEHOLDER: bgm_combat_boss_intro.ogg]`.
- **Criterio de aceite:** chegar no estagio 10, ver intro, derrotar boss, ver drop.
- **Riscos:** boss mal balanceado (rapido ou impossivel). Mitigacao: HP/dano em janela de 1.5x-3x do mob comum.

### F03.04 Inimigos elites e shiny

- **Status atual:** nao existem.
- **O que falta:**
  - Spawn aleatorio em waves: ~2-5% para Elite, ~0.05% para Shiny.
  - Multiplicador de stats (1.5-3x para Elite, ainda maior para Shiny).
  - Drop garantido + drops exclusivos (Cards Corrupted/Greedy - cross-ref glossary).
  - Visual diferenciado (border vermelho para Elite, dourado para Shiny).
- **Ordem sugerida:** apos cards regulares (F02.07) para que o sistema de cards aceite Corrupted/Greedy.
- **Dependencias:** F02.07.
- **O que EU entrego em codigo:**
  - Refatoracao em spawn de inimigo para roll de elite/shiny.
  - Refatoracao em `card_album.gd` para abas Corrupted e Greedy.
  - VFX de elite/shiny.
- **O que o USUARIO entrega:**
  - Sprites alternados (border especial).
  - Lista de buffs especiais por elite.
- **Criterio de aceite:** matar 100 inimigos comuns, encontrar 1-3 elites, derrotar, ver drop especial.
- **Riscos:** drop rate de Shiny frustrante. Mitigacao: pity counter (apos 5000 kills do mesmo inimigo, garante 1 Shiny).

### F03.05 Raids

- **Status atual:** nao existem.
- **O que falta:**
  - Trigger condicional: apos X kills no kill stack OU spawn aleatorio a cada 10-12 min reais (cross-ref roadmap 3.1).
  - 30-50 waves seguidas substituindo farm normal.
  - Drop rate aumentado (~3x).
  - Raid boss unico no final.
- **Dependencias:** F02.08, F03.03.
- **O que EU entrego em codigo:**
  - Sistema de raid trigger.
  - Substituicao temporaria de wave queue.
- **O que o USUARIO entrega:**
  - Music de raid `[PLACEHOLDER: bgm_combat_raid.ogg]`.
- **Criterio de aceite:** trigger de raid funciona, jogador escolhe ativar, raid corre, drop maior.
- **Riscos:** raid interrompendo idle automatizado. Mitigacao: opcao "auto-aceitar raid".

### F03.06 Arena dos Gladiadores (early access)

- **Status atual:** nao existe.
- **O que falta:**
  - Estrutura na Cidade (Coliseu).
  - Combates 1v1 com inimigos de stats fixos altos.
  - Ranks: Bronze, Prata, Ouro, Platina, Diamante (Mestre+, Gladiador, Lendario, Mitico, Eternizado em fases posteriores).
  - Moeda Glory.
  - Loja de Glory (cosmeticos, titulos, talentos especiais).
- **Ordem sugerida:** apos F03.01 (Cidade) - estrutura mora la.
- **Dependencias:** F03.01.
- **O que EU entrego em codigo:**
  - Cena de Arena.
  - Sistema de ranking persistente.
  - Loja Glory (similar a F02.11).
- **O que o USUARIO entrega:**
  - Sprite do Coliseu.
  - Lista de oponentes por rank.
  - Lista de cosmeticos/titulos comprareis.
- **Criterio de aceite:** entrar em Bronze, vencer 5 desafios, subir rank, comprar 1 titulo.
- **Riscos:** rank infinito sem ceiling estraga balance. Mitigacao: rank tem cap por arvore de talentos do personagem.

### F03.07 Skills com cooldown + sistema de prioridade

- **Status atual:** skills basicas (sem cooldown gerenciado).
- **O que falta:**
  - Cada personagem equipa ate 8 skills ativas.
  - Cooldown individual por skill.
  - Modo simples: dispara em ordem conforme cooldown (cross-ref roadmap 3.12).
  - Modo avancado: trigger configuravel ("HP < 50%", "3+ inimigos visiveis", "Boss presente", "Stack de buff Y >= 5").
  - Animacao de uma skill termina antes da proxima comecar.
- **Ordem sugerida:** modo simples primeiro; modo avancado como QoL desbloqueavel via Loja Eterna.
- **Dependencias:** F01.02 (skill tree), F02.05 (status).
- **O que EU entrego em codigo:**
  - Refatoracao em `combat_controller.gd` para fila de skills.
  - Novo `scripts/systems/skill_priority.gd` para regras condicionais.
  - UI de configuracao de skills equipadas.
- **O que o USUARIO entrega:**
  - VFX de cada skill `[PLACEHOLDER: vfx por skill principal]`.
  - SFX por skill.
- **Criterio de aceite:** equipar 4 skills, ver elas dispararem em ordem. Configurar 1 trigger condicional, ver funcionar.
- **Riscos:** skill spam visual. Mitigacao: buffer minimo de 0.3s entre skills (cross-ref `05_juicy/feedback-language.md`).

### F03.08 Colecao de Equipamentos

- **Status atual:** nao existe.
- **O que falta:**
  - Registro automatico ao obter item pela primeira vez.
  - Stat permanente pequeno por tier (cross-ref roadmap 3.33: Common +0.1%, Uncommon +0.3%, Rare +1%, Epic +3%, Legendary +8%, Mythic +20%).
  - Aplicado a TODOS os personagens.
  - Bonus de set (todas armas Rare+).
- **Ordem sugerida:** depois de raridades estaveis (F02 inteira).
- **Dependencias:** F00.03.
- **O que EU entrego em codigo:**
  - Novo `scripts/systems/equipment_collection.gd` (no nivel da conta, nao do personagem).
  - Modal de Colecao com filtros por slot/tier.
  - Hook em pickup de item para registrar.
- **O que o USUARIO entrega:**
  - Layout do modal Colecao.
- **Criterio de aceite:** pegar item Rare ineditol, ver Colecao registrar, ver +1% stat aplicado.
- **Riscos:** baixo.

### F03.09 Mob Slaughter expandido

- **Status atual:** kill stack ativo (Fase 02.08).
- **O que falta:**
  - Marcos altos (10k, 100k, 1M) com drops desbloqueados.
  - Kills inimigos raros / mini-bosses / bosses requerem menos kills.
- **Dependencias:** F02.08, F03.03.
- **O que EU entrego em codigo:**
  - Refatoracao em `bestiary.gd` para tier de marcos.
  - Drop adicional em wave de inimigo "elegivel" pelo marco.
- **O que o USUARIO entrega:**
  - Lista de drops adicionais por marco (cross-ref `01_design/enemies-catalog.md`).
- **Criterio de aceite:** atingir 10k de slime verde, ver drop especial dropar.
- **Riscos:** baixo.

### F03.10 Codex completo

- **Status atual:** so bestiario textual.
- **O que falta:**
  - Subsecoes: Bestiario (ja tem), Locais de coleta, Materiais, NPCs, Zonas, Receitas, Cards, Pets.
  - UI tabbed.
  - Discoveries persistentes.
- **Ordem sugerida:** consolidacao - depois de tudo da fase.
- **Dependencias:** todos os sistemas com elementos descobertos.
- **O que EU entrego em codigo:**
  - Nova `scenes/ui/modals/codex_modal.gd` com abas.
  - Hooks em todos os sistemas para registrar discovery.
- **O que o USUARIO entrega:**
  - Layout das abas.
  - Lore minimo por entry.
- **Criterio de aceite:** abrir codex, ver todas abas populadas com items descobertos.
- **Riscos:** baixo.

### F03.11 Eventos rotativos

- **Status atual:** nao existe.
- **O que falta:**
  - Festivais do Acampamento (buff global de XP/drop por X horas, ativado a cada 1-2h reais, dura varios minutos).
  - Invasoes (zona "invadida" por inimigo especifico, drops aumentados).
  - Eventos sazonais ja chegam na Fase 04.
- **Ordem sugerida:** Festivais primeiro (mais simples), Invasoes depois.
- **Dependencias:** F00.04 (timer real-time).
- **O que EU entrego em codigo:**
  - Novo `scripts/systems/event_scheduler.gd`.
  - UI de evento ativo (banner no HUD).
- **O que o USUARIO entrega:**
  - Lista oficial de festivais (cross-ref `01_design/events-catalog.md`).
- **Criterio de aceite:** abrir o jogo, ver "Festival do Sol" ativo, dropar 1.5x materiais.
- **Riscos:** baixo.

### F03.12 Selos de Conta

- **Status atual:** nao existem.
- **O que falta:** sistema de achievements globais com bonus permanente que se aplica a TODOS os personagens.
- **Dependencias:** F02 (multi-personagem).
- **O que EU entrego em codigo:**
  - `scripts/data/seal_data.gd` + `scripts/systems/seals.gd` no nivel de conta.
  - UI de Selos (Conta -> Selos).
- **O que o USUARIO entrega:**
  - Lista oficial de selos. Cross-ref `01_design/account-vs-character.md`.
- **Criterio de aceite:** atingir achievement global (100k kills totais), ver Selo desbloqueado, bonus aplicado.
- **Riscos:** baixo.

### F03.13 Itens usaveis (pocoes, comida buff)

- **Status atual:** Cooking existe (F02.03) mas nada produz buff real.
- **O que falta:**
  - Pocoes de regen (HP, MP).
  - Pocoes de buff (XP boost, drop boost, dano boost) com timer real-time.
  - Pergaminhos (encantamento, reset, teleporte).
  - Comida com buff permanente na primeira vez consumida + buff longo (1-2h real).
- **Dependencias:** F02.03 (Cooking), F02.09 (Pergaminhos vinculados a Enchanting).
- **O que EU entrego em codigo:**
  - `scripts/systems/consumables.gd`.
  - Slot de "uso rapido" no HUD.
  - Buffs com timer real-time persistente.
- **O que o USUARIO entrega:**
  - Sprites de cada pocao/comida/pergaminho.
- **Criterio de aceite:** consumir comida, ver buff +10% XP por 1h. Fechar e reabrir, buff continua descontando.
- **Riscos:** stack de buffs sem cap. Mitigacao: 1 buff ativo por categoria.

### F03.14 Pets (combat + expedition)

- **Status atual:** so buff (F02.06).
- **O que falta:**
  - Pets de combate (acompanham, lutam, 2 habilidades).
  - Pets de expedicao (atribuidos a missao com timer real, indisponiveis durante).
- **Dependencias:** F02.06.
- **O que EU entrego em codigo:**
  - Refatoracao em `pet_data.gd` para suportar 3 papeis.
  - Cena de pet no combate (lateral do player).
  - Sistema de expedicao (cross-ref F03.20).
- **O que o USUARIO entrega:**
  - Sprites animados de pets em combate.
  - Lista de pets por papel.
- **Criterio de aceite:** equipar pet de combate, ver lutando junto, dando dano. Mandar pet em expedicao 4h, recolher recompensa.
- **Riscos:** crowding visual em combate. Mitigacao: pet menor que player.

### F03.15 Renascimento (1ª camada de prestigio + estrelas + ramos de awakening)

- **Status atual:** nao existe.
- **O que falta:**
  - Personagem renasce ao atingir level cap (100).
  - Reseta nivel, equip, skills, codex de itens daquele personagem.
  - Mantem: visual desbloqueado, album, pets, codex transcendido (vem na Fase 04).
  - Ganha estrelas (★1 a ★10).
  - Cap de ★: 10 inicialmente.
  - Cada estrela aumenta level cap em +100.
  - Renasceres apos o primeiro podem ser feitos antes de level cap, gerando "pontos de renascimento" (Chakra).
  - Loja de Renascimento (Chakra) com upgrades flat/percentual/multiplicador.
  - **Awakening / Ramos de Evolucao:** em ★1, ★3, ★5, ★7, ★9, ★10 ha nos de escolha (cross-ref roadmap 3.19).
- **Ordem sugerida:** **e' o item mais critico da fase**. Reservar 2-3 sprints.
- **Dependencias:** Fase 02 inteira + F03.01 (Cidade pra ter Loja Chakra).
- **O que EU entrego em codigo:**
  - `scripts/systems/rebirth.gd`.
  - Modal de Renascimento (confirmacao + preview do que mantem/perde).
  - Modal de Awakening em cada nivel de estrela.
  - `scripts/data/awakening_branch_data.gd` por classe.
- **O que o USUARIO entrega:**
  - Lista oficial de ramos por classe (cross-ref `01_design/classes-and-characters.md`).
  - Skins exclusivas de ★5 e ★10 por classe.
  - Animacao do ritual de Renascimento `[PLACEHOLDER: animacao ritual]`.
- **Criterio de aceite:** levelar Warrior ate 100, renascer, escolher ★3 Cavaleiro Sagrado, ver kit de skills mudar.
- **Riscos:**
  - **Critico:** balance entre ramos. Mitigacao: capear bonus a niveis comparaveis, playtest extensivo.
  - Save complexo. Mitigacao: versionamento robusto (cross-ref `01_design/save-offline-spec.md`).

### F03.16 Moeda exclusiva (Gemas) + Loja Eterna

- **Status atual:** nao existe.
- **Confirmacao (decidido #33, 2026-05-06):** Loja Eterna ENTRA NA FASE 03 (apos Renascimento). Modelo: FREE no Steam + Gemas pagas para cosmeticos / slots extras / automacoes / melhorias permanentes nao pay-to-win. Gemas tambem ganhas in-game.
- **O que falta:**
  - Sistema de Gemas da Eternidade (cross-ref glossary).
  - Fontes in-game: prestige/achievements/eventos/quest diaria/free-gift na loja/tempo de jogo/quests raras/cards repetidos.
  - Compra paga via Steam (cross-ref roadmap 3.18) — DLC pack ou microtransacao via Steam Wallet.
  - Loja Eterna com guias por progresso (Guia Z1 / Guia Z10 / Guia Transcendencia 1...).
  - Categorias inicialmente expostas:
    - **Cosmeticos** (skins de personagem, retratos, efeitos de UI).
    - **Slots de inventario / personagem extra** (conveniencia, nao poder).
    - **Automacoes** (auto-coleta, auto-equip, prioridade avancada de skills, multi-craft).
    - **Expansao de offline cap** (24h / 48h / 72h, conforme decisao #18).
    - **Melhorias permanentes** sem efeito direto em DPS no early.
- **Dependencias:** F03.15 (prestige da Gemas).
- **O que EU entrego em codigo:**
  - `scripts/systems/gems.gd` no nivel da conta (decisao #22: itens vinculam a CONTA, nao ao personagem).
  - Modal de Loja Eterna (categorias acima).
  - Restricoes de "guia por progresso".
  - Hook futuro para Steam Wallet (apenas estrutura — venda real entra antes do 1.0).
- **O que o USUARIO entrega:**
  - Catalogo da Loja Eterna por guia (cross-ref `01_design/account-vs-character.md`).
  - Politica de "nao pay-to-win" reforcada por revisao de cada item antes de entrar.
- **Criterio de aceite:** ganhar 100 gemas via achievement, comprar slot extra de inventario, ver aplicado em qualquer personagem do roster.
- **Riscos:** desbalanceamento da loja (item OP cedo) ou pay-to-win acidental. Mitigacao: gating por guia + revisao manual de cada SKU pelo usuario antes de entrar no catalogo.

### F03.17 Titulos

- **Status atual:** nao existem.
- **O que falta:** todos os titulos ficam ativos simultaneamente apos desbloqueados (cross-ref roadmap 3.22).
- **Dependencias:** F03.12 (Selos sao similares).
- **O que EU entrego em codigo:**
  - `scripts/data/title_data.gd`.
  - Hook em achievements.
- **O que o USUARIO entrega:**
  - Lista oficial de titulos.
- **Criterio de aceite:** atingir achievement, ver titulo desbloquear, buff aplicado.
- **Riscos:** baixo.

### F03.18 Expedicoes

- **Status atual:** F03.14 ja implementa o esqueleto.
- **O que falta:** lista de expedicoes catalogada, recompensas, pets-vantagem.
- **Dependencias:** F03.14.
- **O que EU entrego em codigo:**
  - `scripts/data/expedition_data.gd`.
  - Modal de expedicao no Acampamento.
- **O que o USUARIO entrega:**
  - Lista oficial de expedicoes.
- **Criterio de aceite:** mandar pet, esperar 4h reais, abrir, ver recompensa.
- **Riscos:** baixo.

---

## Ordem global recomendada

**03a (Conteudo expandido):**
1. F03.01 Cidade
2. F03.03 Mini-bosses + Bosses
3. F03.04 Elites + Shiny
4. F03.06 Arena
5. F03.05 Raids

**03b (Sistemas avancados de combate):**
6. F03.07 Cooldowns + prioridade
7. F03.08 Colecao
8. F03.09 Mob Slaughter expandido
9. F03.13 Itens usaveis
10. F03.14 Pets combat+expedition
11. F03.18 Expedicoes
12. F03.02 Dungeons (depois de tudo acima)

**03c (Meta + prestigio):**
13. F03.10 Codex completo
14. F03.11 Eventos
15. F03.12 Selos
16. F03.17 Titulos
17. F03.15 Renascimento + Awakening
18. F03.16 Gemas + Loja Eterna

---

## Criterio de aceite global da Fase 03

- Cidade evoluida e funcional.
- 1 dungeon Normal jogavel com formacao 3x2 e auras.
- Bosses no estagio 10 funcionais.
- Renascimento ate ★3 testado em 1 classe.
- Loja Eterna com pelo menos 5 produtos por guia.
- Codex completo populando todas abas conforme jogador descobre.
- Sistema de cooldown e prioridade ativa.

---

## Riscos transversais

- **Mais critico:** Renascimento mal calibrado destroi engajamento. Mitigacao: ★1 deve ser facilmente alcancavel (8-15h de jogo); ★10 e' marco de 200h+.
- **Critico:** Dungeons quebram o paralelismo idle. Mitigacao: dungeons sao opt-in e curtas (10-20 min).
- **Medio:** loja Eterna virando pay-to-win. Mitigacao: gating por guia e itens sem efeito direto em DPS no early.

## Cross-references

- `01_design/account-vs-character.md`
- `01_design/classes-and-characters.md`
- `01_design/quests-catalog.md`
- `01_design/events-catalog.md`
- `02_math/ascension-multipliers.md`
- `02_math/balance-tables.md`
- `02_math/time-to-progress.md`
- `roadmap-sistemas.md` secoes 3.1, 3.7, 3.12, 3.13, 3.14, 3.16, 3.17, 3.18, 3.19, 3.21, 3.22, 3.23, 3.24, 3.25, 3.26, 3.27, 3.28, 3.30, 3.33
