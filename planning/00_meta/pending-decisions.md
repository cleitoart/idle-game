# Decisoes Pendentes - Consolidado pos-agentes

> Lista mestre de tudo que precisa de palavra final do usuario antes de virar codigo. Cada item aponta para o(s) arquivo(s) onde aparece detalhado.
> **Ler `00_meta/progress-log.md` para contexto. Ler arquivo individual para detalhe.**

---

## Decisoes que bloqueiam producao de arte / audio

| #   | Decisao                                                           | Onde discutido                                                 | Impacto                                                      |
| --- | ----------------------------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------ |
| 1   | ~~**Tamanho-padrao do tile de combate**~~ [RESOLVIDO 2026-05-06: tamanho variavel — pequenos 16-24, medios 32-48, grandes 64-96, mini-boss/boss 128] | `01_design/graphics-needs.md`                                  | Afeta TODA producao de sprites de inimigos. P0.              |
| 2   | **Paleta global oficial (32 cores HEX)**                          | `01_design/graphics-needs.md`, `05_juicy/feedback-language.md` | Sem isso, assets futuros vao colidir visualmente. P0.        |
| 3   | ~~**Equipamentos: Layered sprites OU substituicao total?**~~ [RESOLVIDO 2026-05-06: SO ARMA altera visualmente o personagem. Armadura NAO tem peca visual. Personagem muda visual via SKIN COMPLETA (substitui sprite inteiro + retrato). Arma e' camada simples sobre o personagem-base.] | `01_design/graphics-needs.md`                                  | Multiplica trabalho de arte 3-10x dependendo da escolha. P0. |
| 4   | **Voice acting em PT-BR: sim ou nao?**                            | `01_design/audio-needs.md`                                     | Custo alto. P2 se sim.                                       |
| 5   | ~~**Orientacao de tela**~~ [RESOLVIDO 2026-05-06: Landscape (desktop primeiro)] | `01_design/graphics-needs.md`                                  | Reflow de TODA UI. P0.                                       |
| 6   | ~~**Tema musical: boss compartilhado por zona, OU unico por boss?**~~ [RESOLVIDO 2026-05-06: 1 musica de boss POR ZONA (compartilhada). 6 musicas de boss total.] | `01_design/audio-needs.md`                                     | Audio P1.                            |
| 7   | **Camp music: varia por estagio (5x mais musica) ou nao?**        | `01_design/audio-needs.md`                                     | -                                                            |

## Decisoes que afetam matematica / balance

| # | Decisao | Onde discutido | Impacto |
|---|---|---|---|
| 8 | ~~**Pity em drops Mythic**~~ [RESOLVIDO 2026-05-06: SIM, threshold 100] | `02_math/drop-rates.md` | Reduz frustracao endgame. |
| 9 | **GROWTH (XP) = 1.07: validar em playtest** | `02_math/progression-curves.md` | Pode ser 1.075 ou 1.08 se progressao estiver rapida. |
| 10 | **TP cap (50 inicial, +25 por T)** | `02_math/ascension-multipliers.md` | Curva de Transcendencia. |
| 11 | **waves_per_area: 3-8?** | `02_math/balance-tables.md` | Assumido 5 medio; precisa definir por zona. |
| 12 | ~~**Tiers de raridade: 5 ou 6?**~~ [RESOLVIDO 2026-05-06: 6 tiers - Common, Uncommon, Rare, Epic, Legendary, Mythic] | `01_design/equipment-catalog.md` | 6 confirmado. |
| 13 | ~~**Stats elementais: classe tem afinidade base ou tudo zera?**~~ [RESOLVIDO 2026-05-06: tudo zerado. Afinidade vem de equip/skill/encantamento. Build emerge da escolha de equip, não da classe.] | `04_phases/phase-02-expansion.md` | Build flexível. |
| 14 | ~~**Velocidade 2x: default ou unlock da Loja Eterna?**~~ [RESOLVIDO 2026-05-06: 1x e 2x desde o inicio. 4x e 8x ficam como unlock progressivo (Renascimento / Loja Eterna).] | `04_phases/phase-01-core-loops.md` | Default. |
| 15 | ~~**Bonus de afinidade de classe**~~ [RESOLVIDO 2026-05-06: sistema de EFICIENCIA estilo IdleOn. Drops de gathering NAO sao garantidos enquanto a Eficiencia do personagem nao atingir o requisito do node. Classe certa = mais Eficiencia base para certa skill = maior taxa de drop garantida vs node de mesmo tier. Falha = animacao acontece mas nao recebe drop. Mecanica de Eficiencia precisa secao propria em `02_math/` ou em `01_design/gathering-materials.md`.] | `04_phases/phase-02-expansion.md` | Mecanica nova a documentar. |
| 16 | **Boost global por estagio do Acampamento: valor exato** | `04_phases/phase-03-mid-game.md` | - |
| 17 | **Curva de chance de falha em Refinamento** | `01_design/crafting-catalog.md` | Afeta sink de materiais. |
| 18 | ~~**Cap inicial de tempo offline: 12h, 8h ou outro?**~~ [RESOLVIDO 2026-05-06: 12h. Loja Eterna desbloqueia 24h/48h/72h depois.] | `01_design/save-offline-spec.md` | 12h. |

## Decisoes de Conta vs Personagem

| # | Decisao | Onde discutido | Impacto |
|---|---|---|---|
| 19 | ~~**Gold: por conta ou por personagem?**~~ [RESOLVIDO 2026-05-06: por CONTA — pool unico compartilhado] | `01_design/account-vs-character.md` | Critico. Afeta economia inteira. |
| 20 | ~~**Equipamento no inventario: por conta ou por personagem?**~~ [RESOLVIDO 2026-05-06: equip E inventario POR PERSONAGEM. Bau Compartilhado fica como feature do Reino+ (decisao #21).] | `01_design/account-vs-character.md` | Idem critico. |
| 21 | ~~**Bau Compartilhado para equipamentos**~~ [RESOLVIDO 2026-05-06: SIM, libera na FASE 03 (Mid-Game / Cidade). Materiais entram primeiro, equipamentos depois conforme codex desbloqueado.] | `01_design/account-vs-character.md` | Fase 03. |
| 22 | ~~**Skins de personagem deletado continuam disponiveis?**~~ [RESOLVIDO 2026-05-06: SIM. Tudo da Loja Eterna e itens cosmeticos ficam vinculados a CONTA, nao ao personagem. Reduz medo de deletar/recriar.] | `01_design/account-vs-character.md` | - |

## Decisoes de mecanica especifica

| # | Decisao | Onde discutido | Impacto |
|---|---|---|---|
| 23 | ~~**Item de Colecao de Equipamento: stat fixo ou aleatorio?**~~ [RESOLVIDO 2026-05-06: STAT FIXO por tipo+tier. Espada Common = +1 ATK fixo, Rare = +5 ATK fixo, etc.] | `01_design/equipment-catalog.md` | Previsivel. |
| 24 | **Sal vem de Mining como sub-drop?** | `01_design/gathering-materials.md` | - |
| 25 | **Fonte primaria de Agua Pura: Spot proprio ou Fishing T1?** | `01_design/gathering-materials.md` | - |
| 26 | **Pets capturados via Hunting: stats menores ou alternativa equivalente?** | `01_design/pets-catalog.md` | - |
| 27 | **Skill assinatura ★10: aura, ativa ou passiva?** | `01_design/classes-and-characters.md` | Padrao adotado, a confirmar. |
| 28 | **Apos ★10: TP compram nos extras?** | `01_design/classes-and-characters.md` | - |
| 29 | **Eventos sazonais: drops afetam todas as zonas ou so a do personagem?** | `01_design/events-catalog.md` | - |
| 30 | **Quais inimigos tem drop adicional pos-100k Mob Slaughter?** | `01_design/enemies-catalog.md` | Lista a definir. |
| 31 | **3 ramos definitivos do Warrior pre-awakening** | `01_design/classes-and-characters.md` | - |
| 32 | **Espelho dos Gemeos: sombra herda equip ou nao?** | `04_phases/phase-05-end-game.md` | - |

## Decisoes de release / monetizacao

| # | Decisao | Onde discutido | Impacto |
|---|---|---|---|
| 33 | ~~**Release 1.0: monetizacao**~~ [RESOLVIDO 2026-05-06: FREE no Steam + Gemas pagas para cosmeticos/slots/conveniencia (Loja Eterna). NAO pay-to-win. Gemas tambem ganhas in-game.] | `00_meta/release-plan.md` | Modelo de negocio. |
| 34 | ~~**Plataforma**~~ [RESOLVIDO 2026-05-06: STEAM (PC primeiro). Multi-plataforma fica para release 1.0+] | `00_meta/release-plan.md` | Confirma desktop landscape, Steam Cloud, achievements. |
| 35 | ~~**Alfa fechada com convidados ou usuario solo?**~~ [RESOLVIDO 2026-05-06: SOLO ate ter conteudo de 30h+. Apos: alfa fechada com 5-15 convidados.] | `00_meta/release-plan.md` | - |

## Decisoes de localizacao

| # | Decisao | Onde discutido | Impacto |
|---|---|---|---|
| 36 | ~~**Lista oficial de idiomas no Release 1.0**~~ [RESOLVIDO 2026-05-06: PT-BR + EN. ES e outros entram em updates pos-1.0.] | `00_meta/localization-plan.md` | i18n minimo. |
| 37 | **Pronome neutro suportado desde inicio?** | `00_meta/localization-plan.md` | PT-BR delicado em genero. |
| 38 | **Tradutor profissional ou voluntario para EN/ES?** | `00_meta/localization-plan.md` | Custo. |
| 39 | ~~**Termos do dominio: traduzir ou ingles?**~~ [RESOLVIDO 2026-05-06: MISTO. Termos universais do genero (DPS, Tank, AoE) ficam em ingles. Termos narrativos (Acordar, Carnificina, Maestria) traduzem. Decidir caso-a-caso conforme feedback de player.] | `00_meta/localization-plan.md` | Identidade hibrida. |

## Tarefa critica nao-decisao

| # | Item | Onde |
|---|---|---|
| 40 | **Re-rodar Agente 4 (External Research) com `mcp__brave-search__*` aprovado** | `03_research/*.md` | Todas as URLs estao marcadas `[VERIFICAR]`. Conhecimento previo do agente foi limitado a jan/2026. |

## Defaults adotados na Fase 0 (revisitar quando necessario)

Estes nao sao bloqueios para implementacao mas valem como decisoes-default que precisam ser revisitadas se virarem problema.

| # | Default | Origem | Quando revisitar |
|---|---|---|---|
| D1 | **NAO ofuscar save** — so hash sha256 de integridade | `01_design/save-offline-spec.md` secao 1.1 | Fase 02+ se aparecer cheating problematico |
| D3 | **1 slot de save apenas** na Fase 0 | `01_design/save-offline-spec.md` secao 1.2 | Fase 03 (Loja Eterna libera slots extras) |
| D5 | **Offline NAO avanca areas/zonas** automaticamente | `01_design/save-offline-spec.md` secao 7.5 | Fase 02+ apos balanceamento |
| D7 | **Detectar relogio para tras** — clamp `delta_t` em zero | `01_design/save-offline-spec.md` secao 7.7 | Validar com playtest |
| D-Tile | **Sistema de tile size variavel implementado** apenas via convencao do .tres do inimigo (nao ha enforcement de codigo) | Decisao #1 | Fase 02+ se virar bagunca visual |
| D-Mig | ~~**Migracao de save versao 1 -> 2** ainda nao implementada~~ [RESOLVIDO 2026-05-11: v1->v2 implementada — ring2 contents drop pro inventory, inventory dict→Array slot-indexed] | `autoload/save_manager.gd::_migrate_v1_to_v2` | - |

---

## Decisoes resolvidas na Fase B+ (Character Modal redesign 2026-05-11)

| #   | Decisao                                                          | Resolucao                                                                                          |
| --- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| R1  | **Quantos rings o personagem pode equipar?**                     | **1 ring soh.** EQUIP_RING1/RING2 viraram deprecated; migration drop ring2 contents pro inventory. |
| R2  | **Quais tools sao slots oficiais no personagem?**                | Pickaxe (Mining), Axe (Chopping), Fishing Rod (Fishing), Scythe (Harvesting) — Fase B+. Star Net (Star Catching), Scouter (Robotics) — Fase 04+. |
| R3  | **Harvesting e' atividade real ou cosmetica?**                   | **Real.** `Efficiency.ACTIVITY_HARVESTING` = `5 + STR*2 + DEX + scythe.bonus`. Item field `bonus_harvesting_efficiency`. |
| R4  | **Formula de atributos primarios spend → derived**               | STR→+1 ATK/pt. DEX→+0.02 attack_speed/pt. INT→+1 magic_atk/pt. VIT→+5 max_hp/pt. LUK→+0.005 crit_chance/pt. |
| R5  | **Inventory data model: dict vs array slot-indexed?**            | **Array[Dictionary] slot-indexed.** Cada slot = `{item_id, item, qty}` ou null. |
| R6  | **Sort do inventory: destrutivo ou display-only?**               | **Destrutivo.** Sort compromete a ordem real, vazios pra direita. |
| R7  | **Power score formula**                                          | `(HP/10) + ATK*2 + DEF*2 + (attack_speed*20) + (crit_chance*100) + (LUK*5)`. |
| R8  | **char_image: por personagem ou compartilhado?**                 | **Por personagem.** Campo `char_image` em CharacterData + fallback `default_char_image.png`. Escala 10x na UI. |
| R9  | **Juicy button pulses: manter ou remover?**                      | **Remover.** UI mais "solida"; visual feedback fica so com 3-state PNGs. |
| R10 | **Inventory + Char Select: modais separados ou integrados?**     | **Integrados** no character_modal redesenhado (5 paineis). |

## Decisoes pendentes novas (pos-Fase B+)

| #   | Decisao                                                          | Onde aparece                                                |
| --- | ---------------------------------------------------------------- | ----------------------------------------------------------- |
| N1  | **TBD1/TBD2 slots do equipment view: qual feature ocupa?**       | character_modal — atualmente locked. Decidir antes de Fase 02. |
| N2  | **class_label em CharacterData (Warrior/Wizard/etc)?**           | Hero panel — hoje so mostra nome + level. Adicionar campo + .tres. |
| ~~N3~~  | ~~**Drag/drop entre slots do inventory?**~~ [RESOLVIDO 2026-05-13: click-to-place estilo Minecraft/Terraria; inventory<->equipment com filtro slot_type; artifact pool isolado] | inventory_slot_v2 — slot.set_slot API pronta, falta wiring UI. |
| N4  | **3-state styleboxes para buttons via TextureButton vs Theme?**  | Visual polish dos botoes do character_modal pos-MVP. |

---

## Como usar este arquivo

1. Quando o usuario quiser implementar uma feature que toca uma das decisoes acima, eu (Claude) **paro e pergunto**.
2. Apos decidir, mover o item para `progress-log.md` em "Decisoes tomadas" da entrada do dia.
3. Atualizar o arquivo de origem (`01_design/...md` ou `02_math/...md`) com a decisao final, removendo `[DECISAO PENDENTE]`.
4. Riscar o item daqui (manter na lista mas marcar `~~[RESOLVIDO YYYY-MM-DD: descricao]~~`).
