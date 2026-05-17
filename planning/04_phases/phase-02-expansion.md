# Fase 02 - Expansion

> Saida do "demo idle solo" para o **paradigma multi-personagem IdleOn-style**. E' aqui que o jogo finalmente "pega" a personalidade do roadmap (`roadmap-sistemas.md` secao 1.2).
>
> **Pre-condicao:** Fase 01 concluida. Loop de gathering+crafting estavel.
> **Pos-condicao:** ate 5 personagens em paralelo, multi-classe, vilarejo, status effects e elementos no combate, pets de buff, cards regulares, kill stack ativo.

---

## Visao geral

A Fase 02 e' a maior em volume. Recomendo dividir em sub-marcos (02a, 02b, 02c) para playtest incremental. O risco aqui e' querer fazer tudo junto e nada ficar polido.

Sub-divisao sugerida:
- **02a (Multi-personagem):** F02.01, F02.02 - multi-roster + classes.
- **02b (Profundidade de combate):** F02.05 status/elementos, F02.07 cards, F02.08 kill stack, F02.09 encantamentos.
- **02c (Aprofundamento de coleta+camp):** F02.03 mais skills, F02.04 vilarejo, F02.06 pets buff, F02.10 refinamento, F02.11 loja.

---

## Itens da fase

### F02.01 Multiplos personagens (3-5 no roster)

- **Status atual:** roster ja e' array (Fase 00.05) mas tamanho 1.
- **O que falta:**
  - Aquisicao via Taverna do Acampamento (NPC contratante).
  - Aquisicao via niveis somados (cross-ref roadmap 3.10: a cada 50 niveis gerais, 1 personagem novo).
  - Tela de Roster Overview como tela inicial.
  - Cada personagem em paralelo: 1 em combate + outros em gathering simultaneamente.
  - Trocar personagem = trocar camera, nao pausar o resto.
  - Cap inicial: 10. Sera apresentado gradualmente; comecamos com 5 desbloqueaveis na Fase 02.
- **Ordem sugerida:**
  1. Backend de paralelismo (cada personagem ticka independente).
  2. UI de roster.
  3. Recrutamento via Taverna.
- **Dependencias:** Fase 00 e Fase 01 inteiras.
- **O que EU entrego em codigo:**
  - Refatoracao em `autoload/game_state.gd` para tickar todos personagens.
  - Novo `scripts/systems/character_activity.gd` (combat / gathering / idle / dungeon / etc.).
  - Nova `scenes/views/roster_overview_view.tscn`.
  - Manutencao em todas UIs para receberem "active character index".
- **O que o USUARIO entrega:**
  - Sprites dos personagens 2-5. Cross-ref `01_design/graphics-needs.md`.
  - NPC Taverneiro - sprite + dialogo. Cross-ref `01_design/npcs-catalog.md`.
  - Validacao do gameplay 4 personagens em paralelo.
- **Criterio de aceite:** 3 personagens em atividades diferentes ao mesmo tempo, todos progridem em paralelo. Save persiste tudo.
- **Riscos:**
  - **Critico:** performance se cada personagem instanciar cena de combate. Mitigacao: combate "off-screen" e' uma simulacao headless (so visualizar quando o player troca camera).
  - UI confusa com 5 personagens. Mitigacao: tela de roster bem desenhada (cross-ref `01_design/ui-ux-wireframes.md`).

### F02.02 Multiplas classes (cada uma com arvore propria)

- **Status atual:** so Warrior (textual em F01.02).
- **O que falta:**
  - 4 classes adicionais para inicio (cross-ref `01_design/classes-and-characters.md`). Sugestao para Fase 02: Warrior, Mage, Ranger, Rogue, Cleric.
  - Cada classe com sua arvore textual.
  - Afinidade de classe com gathering skills (cross-ref roadmap 1.2: "Guerreiro eficiente em mineracao", etc.).
- **Ordem sugerida:** depois de F02.01 (roster precisa existir).
- **Dependencias:** F02.01.
- **O que EU entrego em codigo:**
  - Recursos `data/characters/<classe>.tres` para cada nova classe.
  - Refatoracao em `scripts/data/skill_tree_data.gd` para suportar arvore por classe.
  - Stats base e afinidade em cada `.tres`.
- **O que o USUARIO entrega:**
  - Sprites de cada classe. Idle + walking + ataque.
  - Lista oficial de skills por classe (cross-ref `01_design/skills-catalog.md`).
  - Decisao de balance: o quanto a afinidade impacta? `[DECISAO PENDENTE: bonus de afinidade e' +20% velocidade ou +20% mastery gain?]`.
- **Criterio de aceite:** 5 classes jogaveis. Trocar de classe na criacao impacta combate visivelmente.
- **Riscos:** desbalanceamento entre classes. Mitigacao: comecar conservador, balancear apos playtest.

### F02.03 Mais skills de coleta (Fishing, Cooking, Herbalism)

- **Status atual:** so Mining e Woodcutting.
- **O que falta:**
  - Fishing (precisa de spot aquatico no mapa).
  - Cooking (estrutura no Vilarejo).
  - Herbalism (spots terrestres em zonas com flora).
- **Ordem sugerida:** Cooking depende de Vilarejo (F02.04); Fishing/Herbalism podem vir antes.
- **Dependencias:** F01.03 (sistema de gathering existe).
- **O que EU entrego em codigo:**
  - Items para cada skill em `data/items/`.
  - Spots adicionais nas zonas existentes.
  - Modal de Cooking similar a Smithing.
- **O que o USUARIO entrega:**
  - Sprites: peixes, pratos, ervas. Cross-ref `01_design/gathering-materials.md`.
  - Receitas de comida iniciais (cross-ref `01_design/crafting-catalog.md`).
- **Criterio de aceite:** todas 5 skills coletando funciona. Comida produz buff (cross-ref F02.05).
- **Riscos:** muitas skills cedo demais saturando UI de inventario. Mitigacao: filtros por categoria.

### F02.04 Acampamento estagio 2 (Vilarejo)

- **Status atual:** so estagio 1 (Acampamento basico).
- **O que falta:**
  - Background novo do Vilarejo.
  - Estruturas adicionais: Forja completa (substitui Bancada), Alquimia, Casa de Plantio, Currais (Livestock - so estrutura, mecanica em fase posterior), Taverna (recrutamento - F02.01).
  - Custo de evolucao: acumulo de materiais (cross-ref roadmap 3.16). Decidido em playtest.
  - Boost global: "Vilarejo desbloqueado: +10% gold gain global" `[DECISAO PENDENTE: valor do boost]`.
- **Ordem sugerida:** apos F02.01 e F02.03.
- **Dependencias:** F02.01, F01.05.
- **O que EU entrego em codigo:**
  - Cena `scenes/views/settlement_village.tscn` ou expansao da existente com troca de bg/estruturas baseada em estagio.
  - Sistema de "evolucao do acampamento" com materiais consumidos.
- **O que o USUARIO entrega:**
  - Background do Vilarejo. `[PLACEHOLDER: bg vilarejo]`.
  - Sprites de novas estruturas. Cross-ref `01_design/graphics-needs.md`.
- **Criterio de aceite:** acumular materiais, evoluir, ver Vilarejo no lugar do Acampamento. Estruturas novas funcionais.
- **Riscos:** transicao visual brusca. Mitigacao: animacao de transformacao curta `[PLACEHOLDER: animacao de evolucao]`.

### F02.05 Status effects + Elementos

- **Status atual:** nao existem.
- **O que falta:**
  - Implementar todos os status da secao 3.3 do roadmap (Poison, Burning, Slowed, Blind, Bleeding, Freeze, Curse, Stun, Petrified, Silence, Disarm, Weakness, Broken Armor, Health Regen, Mana Regen, ATK/DEF Up!, Up!! Up!!!, Shielded, Thorns, Reflect, Berserker, Extasis, Confused).
  - Stack de Bleeding ate 20 (Lacerate explosion).
  - Sistema de chance de aplicacao vs resistencia.
  - Elementos no combate (Fire/Ice/Electric/Water/Wind/Rock/Light/Dark) com damage % e resistance %.
- **Ordem sugerida:** **comecar com 5 status iniciais** (Poison, Burning, Slowed, Stun, ATK Up!) e expandir.
- **Dependencias:** F00.02 (stats elementais ja estruturados).
- **O que EU entrego em codigo:**
  - Novo `scripts/systems/status_effect.gd` (timer + stack + tick).
  - Novo `scripts/data/status_effect_data.gd`.
  - Cores e icones por status, cross-ref `05_juicy/feedback-language.md`.
  - Integracao em formula de dano (cross-ref `02_math/damage-formula.md`).
- **O que o USUARIO entrega:**
  - Icones de cada status. Cross-ref `01_design/graphics-needs.md`.
  - Decisao final sobre stacking vs renewing por status (cross-ref roadmap 3.3 - "defina por status, nao global").
- **Criterio de aceite:** Burning aplica DoT, mostra icone, dano por tick. Resistencia reduz duracao.
- **Riscos:**
  - **Critico:** combate vira soup de icones. Mitigacao: limite de 4 status visiveis ao mesmo tempo, resto em tooltip "+N".
  - Calculos quebrando balance da Fase 01. Mitigacao: comecar status com chance baixa.

### F02.06 Pets (papel inicial: Buff)

- **Status atual:** nao existe.
- **O que falta:**
  - Slot de pet de buff por personagem.
  - Sistema de equip/desequip pet.
  - Aquisicao via drop raro de boss (so quando bosses chegarem - Fase 03) ou via achievement basico nesta fase.
  - Pets de combate e expedicao chegam na Fase 03.
- **Ordem sugerida:** primeiro pets de buff via achievement, dropados via boss apenas na Fase 03.
- **Dependencias:** F00.03 (slots de equip).
- **O que EU entrego em codigo:**
  - Novo `scripts/data/pet_data.gd`.
  - Novo `scripts/systems/pet_inventory.gd`.
  - Slot de pet em equipment_modal.
  - Hooks para passar buff ao character_instance.
- **O que o USUARIO entrega:**
  - Sprites de pets. Cross-ref `01_design/pets-catalog.md`.
  - Lista de buffs iniciais por pet.
- **Criterio de aceite:** equipar pet, ver buff aplicado em stats.
- **Riscos:** pets sem visual ficam vazios. Mitigacao: comecar com 3-5 pets, todos com sprite.

### F02.07 Cards de inimigos (regulares)

- **Status atual:** nao existem.
- **O que falta:**
  - Drop de card por inimigo (chance baixa).
  - Album com slots desbloqueados gradualmente.
  - Equip de cards (3 cards inicialmente - 1 set de 3).
  - Buff por card (cross-ref roadmap 3.14).
- **Ordem sugerida:** apos F02.05 (combate ja tem profundidade).
- **Dependencias:** F02.05, F00.06.
- **O que EU entrego em codigo:**
  - `scripts/data/card_data.gd`.
  - `scripts/systems/card_album.gd`.
  - Novo `scenes/ui/modals/card_album_modal.gd`.
  - Drop integration em combate.
- **O que o USUARIO entrega:**
  - Sprites/portraits de card por inimigo. Cross-ref `01_design/cards-catalog.md`.
  - Buffs por card. Cross-ref `02_math/balance-tables.md`.
- **Criterio de aceite:** dropar 1 card de slime, equipar, ver buff.
- **Riscos:** drop rate frustrante. Mitigacao: pity system (50 kills garantem 1 card).

### F02.08 Kill Stack ativo (com buffs do bestiario)

- **Status atual:** bestiario textual existe (F01.06).
- **O que falta:**
  - Marcos: 10, 100, 1k, 10k, 100k, 1M (mais altos vem em fases posteriores).
  - Buff por marco: +5% / +10% / +20% / +50% dano vs aquele inimigo (cross-ref roadmap 3.15).
  - Info do bestiario revelada progressivamente.
  - Drop adicional desbloqueado em marcos altos.
- **Ordem sugerida:** depois de cards (sinergia visivel).
- **Dependencias:** F01.06.
- **O que EU entrego em codigo:**
  - Refatoracao em `bestiary.gd` para incluir buffs ativos.
  - UI atualizada do bestiario com marcos.
- **O que o USUARIO entrega:**
  - Decisao sobre drop adicional em marcos altos (cross-ref `01_design/enemies-catalog.md`).
- **Criterio de aceite:** matar 10 slimes, ver buff +5% aplicado.
- **Riscos:** baixo.

### F02.09 Encantamentos

- **Status atual:** nao existem.
- **O que falta:**
  - Slots de encantamento por equipamento (1-3 dependendo do tier).
  - Tiers: mundane, refined, unreal, eternal.
  - Niveis I-X (algorismos romanos).
  - Aplicar/remover via Enchanting station (no Vilarejo).
  - Encantamentos basicos para inicio (Combatente, Escudeiro, Vitalidade).
- **Ordem sugerida:** apos F02.04 (Vilarejo tem Enchanting).
- **Dependencias:** F02.04, F00.03.
- **O que EU entrego em codigo:**
  - `scripts/data/enchantment_data.gd`.
  - `scripts/systems/enchanting.gd`.
  - Modal de Enchanting na estrutura.
- **O que o USUARIO entrega:**
  - Lista oficial dos encantamentos iniciais. Cross-ref `01_design/equipment-catalog.md`.
  - Sprites de pergaminhos.
- **Criterio de aceite:** aplicar "Combatente I" em arma, ver +5 ATK.
- **Riscos:** complexidade UI. Mitigacao: modal com 1 acao por vez.

### F02.10 Refinamento de equipamento

- **Status atual:** nao existe.
- **O que falta:**
  - Reforjar (re-roll affixes).
  - Refinar +1 ate +20 com chance de falha.
  - Pedras de Stat 1-8 (cross-ref glossary).
  - Quebra de Limite (3 itens -> 1 tier maior).
  - Refinar Transcendental (so liberado pos-Transcendencia, Fase 04).
- **Ordem sugerida:** Reforjar e Refinar primeiro; Pedras de Stat depois; Quebra de Limite por ultimo.
- **Dependencias:** F02.04 (Forja).
- **O que EU entrego em codigo:**
  - Modal de Refinamento na Forja.
  - Sistema de chance de falha + scrolls de protecao.
- **O que o USUARIO entrega:**
  - Receita de scrolls de protecao.
  - Curva de chance de falha por nivel `[DECISAO PENDENTE: ver 02_math/balance-tables.md]`.
- **Criterio de aceite:** refinar arma +1, +2, ver stats subindo. Tentar +5 e falhar (sem destruir, ainda).
- **Riscos:** falha destrutiva no early gera frustracao. Mitigacao: destruicao so a partir de +10.

### F02.11 Loja (gold)

- **Status atual:** nao existe.
- **O que falta:**
  - NPC Mercador no Vilarejo.
  - Categorias: equipamento basico, consumiveis, materiais (limite/dia), itens rotativos diarios.
  - Estoque rotativo a cada 24h reais (cross-ref `01_design/save-offline-spec.md`).
- **Ordem sugerida:** ultimo da fase, polimento.
- **Dependencias:** F02.04.
- **O que EU entrego em codigo:**
  - Novo `scripts/systems/shop_inventory.gd` com timer real-time.
  - Modal `scenes/ui/modals/shop_modal.gd`.
- **O que o USUARIO entrega:**
  - Pricing inicial (cross-ref `02_math/balance-tables.md`).
  - Decisao sobre o que entra no estoque rotativo.
- **Criterio de aceite:** comprar pocao com gold, ver estoque diminuir, ver reset em 24h.
- **Riscos:** baixo.

---

## Ordem global recomendada da fase

**Sub-marco 02a (Multi-personagem):**
1. F02.01 Multiplos personagens
2. F02.02 Classes
3. F02.03 Mais skills de coleta
4. F02.04 Vilarejo

**Sub-marco 02b (Profundidade de combate):**
5. F02.05 Status + Elementos
6. F02.06 Pets buff
7. F02.07 Cards regulares
8. F02.08 Kill Stack ativo

**Sub-marco 02c (Customizacao):**
9. F02.09 Encantamentos
10. F02.10 Refinamento
11. F02.11 Loja

---

## Criterio de aceite global da Fase 02

- 5 personagens jogaveis em paralelo.
- 5 classes com builds diferenciados.
- Combate com pelo menos 5 status effects funcionais e elementos basicos.
- Vilarejo desbloqueado e funcional.
- Cards e bestiario contribuindo com buffs reais.
- Encantamentos basicos aplicaveis.

---

## Riscos transversais

- **Mais critico:** sobrecarga de UI. Cada feature adiciona um modal. Mitigacao: um designer-pass de UX antes do fim da fase (cross-ref `01_design/ui-ux-wireframes.md`).
- **Critico:** balance broken pelo crescimento de stats. Mitigacao: testar zona 1 com 5 personagens equipados em final de Fase 02 - tem que ser facil mas nao banal.
- **Medio:** save bloat. Salvar cards, encantamentos, mastery por item por personagem... Mitigacao: comecar a comprimir.

## Cross-references

- `01_design/classes-and-characters.md`
- `01_design/skills-catalog.md`
- `01_design/cards-catalog.md`
- `01_design/pets-catalog.md`
- `01_design/equipment-catalog.md`
- `01_design/npcs-catalog.md`
- `01_design/ui-ux-wireframes.md`
- `02_math/damage-formula.md`
- `02_math/balance-tables.md`
- `roadmap-sistemas.md` secoes 1.2, 3.3, 3.8, 3.10, 3.13, 3.14, 3.15, 3.16, 3.17
