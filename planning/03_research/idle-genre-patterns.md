# Idle Genre Patterns - Padroes Recorrentes do Genero

> **Nota metodologica:** Brave Search foi negado nesta sessao. Conteudo compilado a partir de conhecimento previo do agente. Cross-references para `reference-games.md`.

Este documento isola **padroes que aparecem em pelo menos 3 jogos** pesquisados em `reference-games.md`. Para cada padrao: descricao, jogos onde aparece, como nosso projeto aplica, riscos.

---

## Indice

1. [Offline Progression](#1-offline-progression)
2. [Prestige Reset com Multiplicador Permanente](#2-prestige-reset-com-multiplicador-permanente)
3. [Curvas de Custo Exponenciais](#3-curvas-de-custo-exponenciais)
4. [Multiplas Moedas com Conversao](#4-multiplas-moedas-com-conversao)
5. [Kill Stack / Mob Slaughter Buffs](#5-kill-stack--mob-slaughter-buffs)
6. [Mastery por Skill / Item Especifico](#6-mastery-por-skill--item-especifico)
7. [Daily/Weekly Reset Tasks](#7-dailyweekly-reset-tasks)
8. [Codex / Bestiario com Bonus por Completude](#8-codex--bestiario-com-bonus-por-completude)
9. [Auto-battle vs Idle Puro vs Active Idle](#9-auto-battle-vs-idle-puro-vs-active-idle)
10. [Time-Skip Mechanics (Stored Boost / Energy)](#10-time-skip-mechanics)
11. [Achievement-Driven Unlocks](#11-achievement-driven-unlocks)
12. [Soft-Cap / Hard-Cap em Stats](#12-soft-cap--hard-cap)
13. [Eventos Sazonais Limitados](#13-eventos-sazonais-limitados)
14. [Multi-Character / Roster](#14-multi-character--roster)
15. [Pet Systems](#15-pet-systems)
16. [Card / Collectible Systems](#16-card--collectible-systems)
17. [Affix System / Loot Roll Tiers](#17-affix-system--loot-roll-tiers)
18. [Loot Filter / Auto-Loot](#18-loot-filter--auto-loot)
19. [Dual Skill Tree (Class + Meta)](#19-dual-skill-tree)
20. [Power Spike via Awakening / Star Tiers](#20-power-spike-via-awakening--star-tiers)

---

## 1. Offline Progression

**Descricao**
O personagem continua acumulando recursos / matando inimigos quando o jogo esta fechado, ate um teto de tempo (geralmente 8h-24h). E' o "contrato social" do genero idle: o jogador pode largar o jogo e voltar com progresso.

**Jogos**
- Cookie Clicker (uso de "lullaby" mode), Melvor Idle (24h cap), NGU Idle (Time Machine), IdleOn (passive farms), Idle Skilling, Idle Slayer, AFK Arena (AFK Rewards baseline), Almost a Hero, Idle Heroes, Realm Grinder, Crusaders of the Lost Idols.

**Como nosso projeto aplica**
- Ja contemplado em `roadmap-sistemas.md` 1.2 e 3.10.
- Cap inicial: 12h. Aumenta via Loja Eterna (3.18) ate 48h+ no late-game.
- Cada personagem tem offline tracking proprio (porque cada um esta em atividade diferente).
- Offline gera log retroativo na tela de welcome-back ("seu Guerreiro matou 1.2k Goblins", "seu Mago coletou 340 Ervas").

**Riscos / Variacoes**
- **Calculo "perfeito" pode quebrar economia**: se jogador deixa 12h em zona infinita com gold-drop, pode juntar progressao desproporcional. Nossa solucao: usar valores medios estimados, nao maximos teoricos. Limitar drops por hora a um teto realista (ex: 80% do que daria jogando ativamente).
- **Stamina-cap disfarcado**: alguns jogos fingem ter offline mas na verdade tem "tickets" que esgotam (ver Resin do Genshin). NAO REPLICAR.
- **Falta de feedback ao voltar**: jogador volta e nao entende o que aconteceu. Nossa tela de welcome-back deve ser RICA.

---

## 2. Prestige Reset com Multiplicador Permanente

**Descricao**
Resetar o save do personagem ou da conta para ganhar uma moeda meta que da multiplicador permanente. Curva typically: cedo voce reseta a cada 1h, depois cada dia, depois cada semana.

**Jogos**
- Cookie Clicker (Heavenly Chips), NGU Idle (Rebirth + Sadistic), Realm Grinder (Reincarnation), Almost a Hero (Time Mage), AFK Arena (limited), Idle Heroes (Stones), Idle Slayer (Glory).

**Como nosso projeto aplica**
- 4 camadas em 3.19: Renascimento (★1-10), Awakening branches, Transcendencia, Ascensao Cosmica.
- Cada camada tem seu pacing distinto: Renascimento e' frequente (toda hora ate dia, escala), Transcendencia e' raro (semanas), Ascensao e' epico (meses).

**Riscos / Variacoes**
- **Reset que apaga "fun gear"**: jogador investiu em equipamento favorito. Nosso modelo preserva pets, codex, achievements, compras de loja eterna. Importante.
- **Curva mal calibrada faz resets sem incentivo**: se ganhar 1.05x permanente por reset que reseta 100h de progresso, ninguem reseta. Sempre dar feedback claro: "voce vai voltar a esse ponto em ~6h".
- **Reset opt-in vs forced**: idealmente opcional. Em alguns jogos (Realm Grinder) e' essencial pra avancar - frustra. **Decidir**: o quanto e' essencial?
- **[DECISAO PENDENTE]:** ate onde permitir o jogador "fugir" do prestigio. Nossa decisao atual e' forcar Renascimento em level cap, mas Transcendencia e Ascensao sao opt-in apos requisitos.

---

## 3. Curvas de Custo Exponenciais

**Descricao**
Custo do proximo upgrade = custo_atual * fator_de_crescimento. Tipicamente fator entre 1.07 (Cookie Clicker tile baixo) e 1.5 (Cookie Clicker buildings novos). Garante que sempre ha algo a comprar mas nada e' instantaneo.

**Jogos**
- Cookie Clicker (1.15 padrao), Realm Grinder, NGU Idle, Almost a Hero, Idle Heroes (level up gold), Crusaders.

**Como nosso projeto aplica**
- Custos de Acampamento (3.16) seguem 1.15-1.25 conforme estagio.
- Custos de Refinamento (3.7) variam: low-tier 1.1, high-tier 1.4 (mais sink).
- Pedras de Stat (3.7) tier 1-8: cada tier custa 5-10x material do anterior.

**Riscos / Variacoes**
- **Inflacao numerica E10000+**: visualmente alienante. Ja resolvido em 3.19 com expoentes sub-lineares apos certo ponto.
- **Curva linear vs exponencial vs polinomial**: skills de coleta (3.9) podem ser polinomial-2 (gastar 99 niveis nao deve ser X10000 do nivel 1).
- **Bottleneck vs faucet**: balancear pra que recurso tenha origem (faucet) e destino (sink). Cada moeda do nosso sistema (3.18) precisa disso.

---

## 4. Multiplas Moedas com Conversao

**Descricao**
Jogo tem 3-8+ moedas distintas (gold, gemas, stones, glory, dust, etc.). Cada moeda tem fonte unica e sink unico. Algumas convertem entre si com taxa.

**Jogos**
- Idle Heroes (Gold/Gems/Stones/Heroic Stones/Spirit/etc), AFK Arena (Gold/Diamonds/Gladiator Coins/etc), MapleStory (Mesos/NX/Maple Points), WoW (Gold/Honor/Conquest/Tokens), Lost Ark.

**Como nosso projeto aplica**
- 3.18 lista: Gold, Gemas da Eternidade, Glory, Tokens de Dungeon. Adicionar conforme features:
  - Transcended Points (3.19)
  - Moedas Galacticas (3.19)
  - Pontos de Constelacao (3.20)
- Cada moeda tem **sink dedicado**: Gold → Loja gold + Refinar; Gemas → Loja Eterna; Glory → Arena shop; Tokens → Dungeon shop.
- **Nao misturar fontes**: Glory nunca deveria ser conversivel direto em Gold (rompe a especializacao).

**Riscos / Variacoes**
- **Moeda sem sink**: jogador acumula sem usar = sentimento de waste.
- **Sink fraco**: itens da Loja Eterna devem renovar pra manter a Gema desejavel.
- **Confusion**: jogador nao sabe pra que serve cada uma. Tooltip + agrupar visualmente.

---

## 5. Kill Stack / Mob Slaughter Buffs

**Descricao**
Matar X de uma criatura libera bonus permanente: info no bestiario, dano +X% vs ela, drop adicional. Marcos em logaritmica (10/100/1k/10k/100k/1M).

**Jogos**
- Tibia (Bestiary + Charm), OSRS (Slayer log + KC), WoW (kill quests/achievements), Diablo 4 (monster encyclopedia), Melvor (Slayer monster lvls), IdleOn (skull achievements).

**Como nosso projeto aplica**
- 3.15 ja descreve em detalhe.
- **Por personagem + global**: cada personagem tem seu KC, mas global tambem soma. Bestiario completo so com global.

**Riscos**
- **Killcounters infinitos sem ceiling**: 1M kills demora demais. Nosso ultimo tier 1M deve dar bonus significativo (50%+).
- **Repetir info no bestiario para variantes**: se Goblin e Goblin Elite tem entradas separadas, e o jogador ve textinho redundante, vira chore. Solucao: Elite/Shiny aparecem na mesma pagina como sub-entradas.

---

## 6. Mastery por Skill / Item Especifico

**Descricao**
Cada acao gathering tem seu proprio nivel. Por exemplo, "Pescar Truta" 1-99 e' independente de "Pescar Tubarao" 1-99. Cria sensacao de "tudo e' grindavel".

**Jogos**
- Melvor Idle (master reference - cada item tem mastery), Tibia (skills via uso), RuneScape (Slayer/Combat tasks), Albion (mastery por item via Destiny Board), OSRS.

**Como nosso projeto aplica**
- 3.9 ja descreve. Mastery por item especifico, nao so por skill.
- Bonus de Mastery alta: tempo de coleta -%, drop dupla %, XP +%.

**Riscos**
- **Tracking massivo**: 100+ items com mastery e' overhead. UI deve agregar (mostrar so o que esta ativo, expandir on demand).
- **Mastery Late-game lentissima**: Melvor sofre disso. Nossa curva deve evitar.

---

## 7. Daily/Weekly Reset Tasks

**Descricao**
Lista de tarefas que renova diariamente/semanalmente, recompensando login ativo. Login bonus, daily quest, weekly raid lockout, etc.

**Jogos**
- Lost Ark (Una's Tasks), Genshin (Daily Commissions), AFK Arena, IdleOn (daily slots), WoW (daily/weekly), MapleStory, Idle Heroes.

**Como nosso projeto aplica**
- Quests da Guilda (3.16, estagio Cidade+).
- **MAX 5 tasks/dia, MAX 3/semana**: anti-chore.
- Recompensas: gold, materiais raros, fragmentos de Gema da Eternidade.
- **Importante:** tarefa diaria nao deve obrigar 1h+. 15-30min e' o sweet spot.

**Riscos**
- **Daily list infinita** (Lost Ark/Genshin): chore. Limitar.
- **Daily login com FOMO**: missei 1 dia → perdi recompensa. Solucao: login bonus mensal acumulativo, nao streak punitivo.
- **Daily reset em hora ruim**: se reset for as 3h da manha local, jogador acorda e tem que correr. Reset de jogo solo idle pode ser livre por personagem (calcula 24h apos ultima reivindicacao).

---

## 8. Codex / Bestiario com Bonus por Completude

**Descricao**
Pagina de "encyclopedia" do jogo onde inimigos / itens / NPCs ficam listados conforme descobertos. Completar paginas/categorias da bonus permanente.

**Jogos**
- Tibia (Bestiary + Charm), OSRS (Collection Log + Combat Achievements), WoW (Achievements completion), Albion (Destiny Board), Diablo 4 (Monster Family Bonus), AFK Arena (Library of Ascension), MapleStory (Monster Collection).

**Como nosso projeto aplica**
- 3.27 (Codex) + 3.15 (Bestiario) + 3.14 (Cards album) + 3.21 (Selos).
- **Completude tier**: 25% / 50% / 75% / 100% de cada secao da bonus crescente.
- **Visual pa Library**: estante com livros que se acendem conforme completos.

**Riscos**
- **OCD trigger**: se faltar 1 item por categoria, jogador frustra. Nossa secao "Greedy" so pode completar com Shiny - tem que ser claro pra jogador que e' opt-in/super-meta.
- **Tracking complexo**: necessario backend solido pra contagem.

---

## 9. Auto-battle vs Idle Puro vs Active Idle

**Descricao**
Tres filosofias de combate em idle:
- **Idle puro** (Cookie Clicker, Realm Grinder): nao ha combate visivel; voce assiste numero subir.
- **Auto-battle** (Idle Heroes, AFK Arena, IdleOn, Almost a Hero): o jogo automaticamente luta apos voce configurar party/skills.
- **Active idle** (Idle Slayer, RuneScape em modo manual): voce clica/aperta tecla pra atacar; o jogo idle ainda permite afastar.

**Jogos por filosofia**
- Idle puro: Cookie Clicker, Realm Grinder, NGU Idle (parcialmente), Idle Skilling.
- Auto-battle: Idle Heroes, AFK Arena, IdleOn (combat), Crusaders of the Lost Idols, Almost a Hero, Idle Champions, Melvor Idle (combat).
- Active idle: Idle Slayer, RuneScape, OSRS, Albion.

**Como nosso projeto aplica**
- 1.3 confirma: **auto-battle puro**. Build > APM. Decisao antes do combate.
- 3.12 da camada de profundidade via skill priority/conditions.
- 3.29 (multiplicador 1x/2x/4x/8x) e' QoL essencial.

**Riscos**
- **Auto-battle mal feito = entediante**: se nao houver decisao pre-combate impactante, jogador desinteressa. Nossa profundidade vem de equipment + skill priority + formacao + cards + encantamentos.
- **Jogador quer agency**: dar override manual em momentos chave (boss, dungeon final wave) sem virar action game. Sugestao: ult manual click em bosses (1 botao, sem mais).

---

## 10. Time-Skip Mechanics (Stored Boost / Energy)

**Descricao**
Recurso que acumula passivamente e e' gasto pra acelerar tempo de uma atividade ou pular timer.

**Jogos**
- NGU Idle (Time Machine), Almost a Hero (Time Skips), AFK Arena (Time Emblems / Quick Battle), Idle Heroes (Quick Quest), Realm Grinder (Time Reset).

**Como nosso projeto aplica**
- 3.29: speed multipliers ja sao base.
- **Stored Boost** (proposta): recurso que acumula a 1/min real, gasto pra simular X tempo offline em qualquer personagem. Limita jogador de "deixar 24h e voltar de boost" - cap total acumulado: ex 4h.

**Riscos**
- **Stored Boost pago**: virar moeda premium. NAO QUEREMOS. Pode ser ganhado por achievements/quests.
- **Boost que skip story content**: nao se aplica em idle, mas em jogos com narrativa cuidado.

---

## 11. Achievement-Driven Unlocks

**Descricao**
Conteudo desbloqueavel apenas por completar achievements (nao por nivel ou compra). Cria caminhos de progresso paralelos.

**Jogos**
- WoW (Mounts/Pets/Titles via achievements), MapleStory (Medals), Crusaders (Achievements de Crusaders), Idle Heroes, IdleOn, Cookie Clicker (achievements dao milk = upgrades).

**Como nosso projeto aplica**
- 3.21 (Selos) + 3.22 (Titulos) + 3.10 (recrutar personagens via achievements: "matar 10000 goblins" → Cacador de Goblins).
- Achievements **visiveis** desde inicio com progresso bar (nao "shadow").

**Riscos**
- **Shadow achievements** (escondidos sem hint): frustram. Hint sempre disponivel ("descubra o segredo da Floresta Sombria").
- **Cheevement spam** ("matou 1 goblin", "matou 2 goblins"...): limitar a marcos significativos.

---

## 12. Soft-Cap / Hard-Cap em Stats

**Descricao**
Mecanica de diminishing returns em stats: ate X o stat sobe normal, depois cresce mais devagar (soft cap), eventualmente para (hard cap).

**Jogos**
- WoW (varia por expansao), Lost Ark (Crit/Spec/Dom soft caps), Diablo 4 (Crit Cap), MapleStory (defense cap), PoE (resistance cap em 75%).

**Como nosso projeto aplica**
- Crit Chance: hard cap 100%, mas drop suave apos 60% (cada 1% custa mais ganhar).
- Resistance elemental: hard cap 80% (impede invulnerabilidade).
- HP/MP: soft cap suave, sem hard cap (sempre incrementavel).
- Cooldown Reduction: soft cap em 50%, hard cap em 75%.

**Riscos**
- **Soft cap sem comunicacao**: jogador nao entende por que stat parou. UI tem que mostrar progress visualmente.
- **Cap muito apertado**: limita criatividade. Cap solto demais: BUilds broken.

---

## 13. Eventos Sazonais Limitados

**Descricao**
Conteudo durante janela limitada (Halloween, Natal, etc.). Recompensas exclusivas, drops temáticos, boss especial.

**Jogos**
- AFK Arena, Idle Heroes, Genshin, MapleStory, WoW, Crusaders of the Lost Idols, Almost a Hero, IdleOn.

**Como nosso projeto aplica**
- 3.26 (Eventos): festivais, invasoes, sazonais.
- **Recompensas EVERGREEN**: cosmeticos sazonais retornam em janela rotativa (anual). NAO punir ausentes.
- **Mecanica sazonal opt-in**: progresso normal continua. Nao bloquear avanco regular.

**Riscos**
- **FOMO**: "missou Halloween 2025? perdeu personagem unico pra sempre". NAO. Personagens sazonais retornam em forma alternativa (drops em Crônicas do Mundo, por ex.).
- **Sobrecarga de eventos**: 5+ eventos simultaneos = ninguem foca em nada. Limitar a 1-2 ativos ao mesmo tempo.

---

## 14. Multi-Character / Roster

**Descricao**
Conta tem multiplos personagens jogaveis simultaneamente, geralmente com classes diferentes. Pode ser swap de "camera" (IdleOn) ou party de combate (AFK Arena).

**Jogos**
- IdleOn (master ref), Idle Skilling, Lost Ark (alts), MapleStory (alts), AFK Arena (party), Idle Heroes, Crusaders of the Lost Idols, WoW (alts).

**Como nosso projeto aplica**
- 3.10 ja em detalhe. Roster ate 10. Cada um farma em paralelo.
- Tela inicial = roster overview.

**Riscos**
- **Alt-paralisia**: jogador nao sabe qual personagem priorizar. Nosso roster overview com indicators ("levelup pendente", "equip melhor disponivel") combate isso.
- **Boring se classes forem identicas**: classes precisam de identidade clara, nao so "DPS A vs DPS B".

---

## 15. Pet Systems

**Descricao**
Pets como entidades que acompanham/farmam/buffam o personagem. Variantes:
- **Combat pet**: luta junto.
- **Buff pet**: equipado em slot, da bonus passivo.
- **Expedition pet**: enviado em missao com timer real.

**Jogos**
- Idle Skilling (master ref de pet raids), IdleOn, WoW (Hunter pets, Battle Pets, Mounts), Genshin (no formal mas similar), Idle Heroes (artifacts behave similar), Almost a Hero (pets), Crusaders.

**Como nosso projeto aplica**
- 3.13 ja descreve em detalhe os 3 papeis.
- Aquisicao via drop, eclosao de ovos, hunting.

**Riscos**
- **Pet meta-essencial**: se nao tem pet S, voce e' invalido. Nosso modelo: pets adicionam, nao multiplicam. Pet melhora dps em ate 30%, nao em 300%.
- **Pet collection overload**: muitos pets sem identidade. Cada pet deve ter nicho claro.

---

## 16. Card / Collectible Systems

**Descricao**
Drops colecionaveis com efeitos passivos. Equipaveis em slots OU passivos por completion.

**Jogos**
- IdleOn (master ref - cards equipaveis em sets), Idle Heroes (Artifacts), MapleStory (Monster Cards), Cookie Clicker (Stocks/Sugar Lumps - tangencial), AFK Arena (Companions/Heroes), Tibia (Charms).

**Como nosso projeto aplica**
- 3.14 ja descreve em detalhe.
- Tipos: comum/elite (Corrupted)/shiny (Greedy).

**Riscos**
- **Drop chance frustrante**: se card e' 0.01% drop, ninguem completa. Nosso modelo: 100% drop em primeiro kill, depois mascara para upgrade tier.
- **Set bonuses opacos**: jogador nao sabe combinacoes uteis. UI deve mostrar com filtros.

---

## 17. Affix System / Loot Roll Tiers

**Descricao**
Itens dropam com modifiers aleatorios em ranges. Affixes sao categorizados em prefix/sufix, e em tiers (T1 melhor, T6 pior por exemplo).

**Jogos**
- Path of Exile (master ref), Diablo 4, Last Epoch, Grim Dawn, Lost Ark, MapleStory.

**Como nosso projeto aplica**
- 3.5 (Equipamento) ja prevê affixes aleatorios.
- 3.7 (Reforjar) re-rola.
- Tiers de affix como em PoE (T1-T6 ou similar) - decisao pendente.

**Riscos**
- **Item garbage**: 90% dos drops sao lixo. Necessario crafting para "elevar" itens.
- **Trading economy** (PoE): nao se aplica em solo, mas affix complexity sim.

---

## 18. Loot Filter / Auto-Loot

**Descricao**
Sistema que filtra/destaca/oculta drops conforme regras configuraveis pelo jogador. Essencial em jogos com loot abundante.

**Jogos**
- Last Epoch (loot filter built-in), Path of Exile (filter via arquivo external), Diablo 4 (basic filter), Grim Dawn.

**Como nosso projeto aplica**
- **Auto-loot por padrao** (eficiencia idle). Loja Eterna pode oferecer "auto-loot melhor" (3.18).
- **Filtro de drops na tela de resultados** (3.30): mostrar so itens que importam. Comum/whites podem ser ocultados.
- **Auto-vendor de baixo tier**: comum -> auto-vende ou auto-disenchant para fragmentos.

**Riscos**
- **Filtro complexo demais**: late game vira programacao. Nosso filtro deve ser presets (3-5 niveis prontos: Aggressive Filter / Medium / Show All).

---

## 19. Dual Skill Tree (Class + Meta)

**Descricao**
Personagem tem 2+ arvores de talentos: uma de classe (mid-game) e outra meta-permanente (late-game).

**Jogos**
- Diablo 4 (Skill tree + Paragon Board), Grim Dawn (Mastery + Devotion), PoE (Passive Tree + Atlas Tree), Last Epoch (Mastery + Idol grid), Lost Ark (Class skills + Engravings), Idle Heroes (Hero levels + Stones).

**Como nosso projeto aplica**
- Skill Tree de classe (3.11) - mid-game.
- Constelacoes (3.20) - late-game, segunda camada.
- Arvore de Transcendencia (3.19) - terceira camada.

**Riscos**
- **Sobrecarga**: 3 arvores e' o maximo recomendado. Quarta seria visualmente exhaust.
- **Trees redundantes**: cada uma deve ter feature distinta. Skill Tree = identidade de classe; Constelacoes = bonus globais; Transcendencia = especializacao narrativa.

---

## 20. Power Spike via Awakening / Star Tiers

**Descricao**
Personagem evolui em "tiers" com saltos de poder. Cada tier exige material raro / duplicates. Tiers: 1★→10★, Common→Mythic+, Job1→Job4, etc.

**Jogos**
- Idle Heroes (1-10★ + Awakening), AFK Arena (Common-Mythic+), MapleStory (Job advancements), Genshin (Ascension caps + Constellations), Idle Champions (Specializations).

**Como nosso projeto aplica**
- 3.19 com 1★-10★ + ramos em 3★/5★/7★/9★/10★. Ja contemplado.

**Riscos**
- **Spike absurdo invalida tier anterior**: tier 5★ tem 100x stats de 4★ = sair pulando. Cuidar curva.
- **Material gating frustrante**: precisar de 50 "Stones of Awakening" e dropam 1 por semana = quit. Nossa curva precisa ser jogavel sem pay.

---

## Padroes que NAO vamos adoptar (anti-patterns que aparecem em 3+ jogos)

### A. Stamina cap diario
Genshin, HSR, AFK Arena. Bloqueia jogo apos X. **Substituido por offline progression honesto.**

### B. Energy regen comprado em premium
Idle Heroes, Idle Skilling. Premium currency acelera energy. **Nao temos energy.**

### C. Pity de 90+ rolls em premium banner
Genshin, HSR. **Nao usamos rolls premium.**

### D. Power creep entre expansoes
WoW, Diablo, AFK Arena. Cada update invalida o anterior. **Nossa Coleção de Equipamentos (3.33) preserva valor.**

### E. Trading dependente de comunidade externa
PoE, Albion. **Solo idle, nao se aplica.**

### F. Daily login streak punitivo
"Voce missou 1 dia, perdeu o premio". **Nosso modelo: cumulativo mensal, nao streak.**

### G. Random event spam de notificacao push
"VOLTE AGORA, evento em 15min". **Nao usaremos push agressivo.**

---

*Fim do documento. Ver tambem:* `reference-games.md`, `gacha-patterns.md`.
