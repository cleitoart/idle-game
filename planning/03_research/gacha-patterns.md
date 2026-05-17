# Gacha Patterns - Mecanicas de Gacha Aplicaveis ao Modelo Nao-Pay-to-Win

> **Nota metodologica:** Brave Search foi negado nesta sessao. Conteudo compilado a partir de conhecimento previo do agente. Cross-references para `reference-games.md` e `idle-genre-patterns.md`.
>
> **Filosofia base:** este projeto e' nao-pay-to-win. **Nenhum** pacote de "rolls premium" sera vendido. Mas varios padroes de gacha (sem dinheiro real) tem mecanica boa que pode ser reaproveitada para drops de bestiario, eventos, e pity de drops raros.

---

## Indice

1. [Rate-Up Banners (Eventos Limitados)](#1-rate-up-banners-eventos-limitados)
2. [Pity System (Acumulo Garantido)](#2-pity-system-acumulo-garantido)
3. [Dust / Refund de Duplicatas](#3-dust--refund-de-duplicatas)
4. [Hero Shards / Character Pieces](#4-hero-shards--character-pieces)
5. [Awakening / Star Branches](#5-awakening--star-branches)
6. [Constellation-style Power-ups](#6-constellation-style-power-ups)
7. [Daily Login Rewards](#7-daily-login-rewards)
8. [Battle Pass Sazonal](#8-battle-pass-sazonal)
9. [Wishlist / Selector Tickets](#9-wishlist--selector-tickets)
10. [Spark / Mileage System](#10-spark--mileage-system)

Para cada padrao: descricao, onde aparece, aplicacao no nosso projeto (somente se alinha com nao-pay-to-win), anti-pattern correlato.

---

## 1. Rate-Up Banners (Eventos Limitados)

**Descricao**
Em uma janela de tempo (ex: 2 semanas), uma criatura/heroi/item especifico tem taxa de drop aumentada. Apos a janela, volta ao pool normal (ou some completamente em caso de "limited").

**Onde aparece**
- Genshin Impact (Character Event Wish), Honkai Star Rail (Character Event Warp), AFK Arena (Wishlist Banners), Idle Heroes (Friendship Summon Events), MapleStory (Cash Shop seasonal heroes).

**Aplicacao no nosso projeto (sem dinheiro real)**
- **Inimigos elite/shiny eventuais**: durante evento "Festival da Sombra", chance de Shiny em zonas tematicas e' 5x normal.
- **Evento de Card Drop**: cards de uma faccao/raca tem chance dobrada de drop.
- **Eventos sazonais com pet exclusivo da temporada**: pet retorna em janelas anuais (NAO some pra sempre).
- **Quest events com heroi recrutavel**: heroi do evento pode ser recrutado completando quest line; em proxima temporada anual, retorna.

**Conexao com roadmap**
- 3.26 (Eventos): Festivais do Acampamento, Invasoes, Sazonais.

**Anti-pattern correlato**
- **Limited true (NUNCA RETORNA)**: jogador que entrou tarde e' permanentemente excluido. NAO ADOTAR.
- **Banner premium pago**: dinheiro acelera pulls. NAO ADOTAR.
- **Rate-up que e' 0.6%**: o rate "aumentado" ainda e' miseravel. Nossos rate-ups devem ser perceptiveis (ex: 0.1% → 0.5% e' nada; 1% → 5% e' rate-up real).

---

## 2. Pity System (Acumulo Garantido)

**Descricao**
Apos N attempts sem sucesso, o jogador tem garantia de ganhar o objetivo. Ex: pity 90 = 90 rolls sem 5★ → 91 rolls e' 5★ garantido.

**Onde aparece**
- Genshin (90 hard pity, 75 soft pity), HSR (90 hard pity), Honkai Impact, AFK Arena (varios), Idle Heroes (Friendship Summon pity 200 - bem alto).

**Aplicacao no nosso projeto**
- **Drops raros de inimigos com pity local**: matar X de Goblin sem dropar Card raro = drop garantido em X+1. Pity = (1/drop_chance) * 1.5. Ex: drop 0.5% (1 em 200) → pity em 300 kills.
- **Refinamento de equipamento (3.7)**: ja temos pedras de protecao. Variante: apos 5 falhas seguidas em refinar (+5 → +6, por ex.), proxima tentativa e' 100% sucesso. Anti-frustracao.
- **Achievements de drop raro (Selos)**: garantia "voce derrotou o boss 50x sem ter visto o drop especial" → drop garantido.
- **Eclosao de ovos de pet (3.13)**: pity 50 ovos sem pet S → pet S garantido no proximo.

**Conexao com roadmap**
- 3.7 (Refinamento) - pedras de protecao + soft pity
- 3.13 (Pets) - pity em eclosao
- 3.14 (Cards) - pity em drops Elite/Shiny
- 3.15 (Bestiario) - kill stack ja funciona como pity natural

**Anti-pattern correlato**
- **Pity de 200+**: e' frustracao disfarcada de "garantia". Pity util e' 30-100 dependendo da raridade.
- **Pity que reseta entre versoes**: jogador acumulou 89/90 → patch reset para 0/90. NAO. Pity persiste entre updates.
- **Pity oculto**: jogador nao sabe quanto falta. Mostrar progress: "78/100 ate drop garantido".

---

## 3. Dust / Refund de Duplicatas

**Descricao**
Duplicatas (segunda copia em diante de algo unico) sao automaticamente convertidas em moeda/material que pode ser usado para upgradar/comprar.

**Onde aparece**
- Hearthstone (Arcane Dust de cards duplicados), Genshin (Stardust, Fates), AFK Arena (Hero Essence), Idle Heroes (Hero Stones), HSR (Embers), MapleStory (essencias varias).

**Aplicacao no nosso projeto**
- **Cards duplicados (3.14)** ja convertem em upgrade do card (Common → Uncommon → Rare → Epic). MUITO ALINHADO com filosofia.
- **Duplicates de pet**: 2x Slime Pet → vira "Essencia de Slime" usada pra evoluir/refinar pet existente.
- **Equipamento duplo (mesmo affix)**: pode ser desencantado em fragmentos usados em refinamento.
- **Achievement duplo (impossivel)**: nao se aplica.

**Conexao com roadmap**
- 3.14 (Cards) ja contempla
- 3.13 (Pets) - aplicar essencias de pet
- 3.7 (Disenchant gear) - vale incluir

**Anti-pattern correlato**
- **Conversao com perda absurda**: 100 duplicatas viram 1 unidade da moeda dust. Conversao deve ser 1:1 ou perto disso (talvez 2:1 com alguma perda).
- **Dust que so compra coisas premium**: dust deve abrir pelo menos um caminho de progressao concreto.

---

## 4. Hero Shards / Character Pieces

**Descricao**
Em vez de "ganhar o personagem", voce ganha N pedacos. Acumular X pedacos = unlock do personagem.

**Onde aparece**
- AFK Arena (Hero Shards), Idle Heroes (Soul Stones, Heroic Stones), MapleStory (Hero medals em alguns sistemas), HSR (Embers funcionam similar).

**Aplicacao no nosso projeto**
- **Recrutamento de personagens raros**: classe rara (ex: Necromante) requer 50 "Fragmento de Crânio" dropado de inimigos undead.
- **Pets raros via fragmentos**: 100 "Pena Doirada" de Pegasus para eclodir pet Pegasus.
- **Equipamentos lendarios via fragmentos**: 30 "Esquirla de Drakon" para forjar Espada Drakkar.

**Conexao com roadmap**
- 3.10 (Recrutamento de personagens) - via fragmentos + level milestones
- 3.13 (Pets) - via ovos OU fragmentos
- 3.6 (Crafting) - receitas com fragmentos como ingrediente

**Anti-pattern correlato**
- **Drop chance miseravel + cap diario**: 0.1% drop com cap 10 atempts/dia = anos pra unlock. Curva deve ser ratificada (~50-200 horas pra unlock major).
- **Fragmento que so dropa de premium banner**: NAO. Fragmento dropa em jogo regular.

---

## 5. Awakening / Star Branches

**Descricao**
Personagem evolui em "tiers de awakening" alem do level. Em certos tiers, escolha de ramo (mutuamente exclusivo). 

**Onde aparece**
- Idle Heroes (Awakening branches), Lost Ark (Awakening skills), Last Epoch (Mastery sub-classes), MapleStory (5th Job Hyper Stats), Idle Champions (Specializations), Crusaders of the Lost Idols (Talent trees).

**Aplicacao no nosso projeto**
- **JA APLICADO no roadmap 3.19 em detalhe.** Estrelas 1-10★, com escolhas em 3★/5★/7★/9★/10★.
- Ramos exclusivos (Cavaleiro Sagrado vs Berserker do Caos).

**Conexao com roadmap**
- 3.19 (Renascimento + Awakening branches)
- 3.11 (Skill Tree adapta-se ao ramo)

**Anti-pattern correlato**
- **Ramo escolhido que invalida outro permanentemente sem rebirth**: deve haver caminho pra trocar (custoso). Nosso reset de skill tree (3.11 - Pergaminho de Reset) deve cobrir isso, ou criar item raro especifico.
- **Ramos cosmeticamente identicos**: jogador escolhe so pelo numero. Cada ramo precisa de fantasia + visual + kit distintos.

---

## 6. Constellation-style Power-ups

**Descricao**
Power-ups passivos desbloqueados por dups do mesmo personagem (ou material specifico). Ex: Genshin C0-C6 sao 6 ranks de bonus passivo desbloqueados ao conseguir o personagem 6x.

**Onde aparece**
- Genshin Impact (Constellations C0-C6), HSR (Eidolons E0-E6), Tower of Fantasy (similar com Matrices).

**Aplicacao no nosso projeto - CUIDADO**
- A palavra "constelacao" ja tem significado diferente em nosso roadmap (3.20: arvore de talents late-game inspirada em Grim Dawn).
- **Aplicacao alternativa**: cada personagem tem 6 "Selos Pessoais" desbloqueados ao re-recrutar/duplicates. Cada selo da bonus passivo pequeno mas permanente. **Distinto** de Constelacoes do roadmap (3.20).
- Ou: trocar nome para "Selos de Persona" ou "Brasoes" para nao confundir.

**Conexao com roadmap**
- Pode ser feature nova ou refinamento de 3.21 (Selos).
- **[DECISAO PENDENTE]**: implementar Selos pessoais por personagem ou nao? Pode ser overhead com 10 personagens (60 selos a tracking).

**Anti-pattern correlato**
- **C6 = 5x mais forte que C0**: power gap absurdo entre F2P/whales no Genshin. Se aplicarmos, gap deve ser 10-30%, nao 500%.
- **Linkado a pity premium**: NAO. Selo desbloqueia por feat in-game.

---

## 7. Daily Login Rewards

**Descricao**
Cada dia logado da recompensa. Pode ser streak (dia 1, 2, 3...) ou cumulativo mensal.

**Onde aparece**
- Quase todo mobile gacha. Genshin (Welkin Moon kinda), AFK Arena, Idle Heroes, IdleOn (daily slots), Idle Champions, MapleStory.

**Aplicacao no nosso projeto**
- **Calendar mensal cumulativo**: cada dia lera um pequeno premio (gold, materiais, raramente Gemas da Eternidade). Day 7, 14, 21, 28: premio maior. Day 30: premio epico.
- **NAO STREAK PUNITIVO**: missou um dia, recupera no proximo (catch-up).
- **Free Gift na Loja Eterna (3.18)**: rotaciona daily.

**Conexao com roadmap**
- 3.18 (Loja Eterna) ja menciona "free-gift na loja".
- 3.16 (Acampamento - Guilda) cobre quests diarias.

**Anti-pattern correlato**
- **Streak break punitivo**: missou 1 dia = volta ao dia 1. NAO. Catch-up.
- **Premios premium em login bonus**: deve ser principalmente recursos in-game, com Gemas em datas raras.

---

## 8. Battle Pass Sazonal

**Descricao**
Track de progresso por XP de season (90 dias). Tier 1 → 100. Cada tier libera recompensa. Track gratis + track paga (premium).

**Onde aparece**
- Genshin (Battle Pass), HSR, Lost Ark (Adventurer's Tome), AFK Arena (Crystal Pass), MapleStory (Maple Pass), Idle Heroes (Tower Path).

**[DECISAO PENDENTE]: Implementar Battle Pass ou nao?**

**Argumentos a favor**
- Ja temos cap de tempo nos eventos sazonais (3.26).
- Pode ser TODO gratuito e ainda funcionar como track de seasonal goals.
- Batalha de objetivos diarios/semanais ja incentivada por roadmap.

**Argumentos contra**
- Ja temos calendar de daily login (item 7).
- Battle pass adiciona um "track adicional" que pode virar checklist treadmill.
- Risco de ter que monetizar isso depois (premium pass) pra ser sustentavel.

**Recomendacao do agente**
- **NAO implementar como Battle Pass tradicional.**
- **Implementar como Track Sazonal (3 meses)**: 50 tiers, todos free, com recompensas de cosmeticos e Gemas + materiais. Sem premium pass.
- Cada season tem tema (Verao, Inverno, Festival da Floresta, etc.). Diferencia-se do Calendar Mensal em escopo (3 meses vs 1 mes).

**Conexao com roadmap**
- Adicao em 3.26 (Eventos) ou nova secao 3.34 (Track Sazonal).

**Anti-pattern correlato**
- **Premium track**: paga pra ganhar mais. NAO ADOTAR.
- **Battle pass com FOMO de horas**: precisa jogar 3h/dia pra terminar antes do reset. Nosso track deve ser completavel em ~40h totais ao longo de 90 dias = 30min/dia em media.

---

## 9. Wishlist / Selector Tickets

**Descricao**
Jogador escolhe 3-5 personagens "desejados". Pulls em certos banners viesam para essa lista. Selector tickets escolhem direto 1 da lista.

**Onde aparece**
- AFK Arena (Wishlist Banner), Genshin (banners limitados, mas sem wishlist verdadeira), Idle Heroes (Heroic Miracle picks).

**Aplicacao no nosso projeto**
- **Wishlist de Cards**: jogador marca 5 cards "preferidos". Cards dessa lista tem +5% drop boost passivo (efeito sutil).
- **Selector tickets via achievements**: completar marco grande = ticket "escolha 1 pet de tier comum". Achievement de Codex 100% completo = ticket "escolha 1 equipamento Lendario".

**Conexao com roadmap**
- 3.14 (Cards) - extensao
- 3.13 (Pets) - extensao
- 3.21 (Selos / achievements) - selector como recompensa

**Anti-pattern correlato**
- **Wishlist limitada a tier baixo**: jogador escolhe so do pool de Common - irrelevante. Wishlist deve cobrir tier minimo Rare ou superior.

---

## 10. Spark / Mileage System

**Descricao**
Cada pull em qualquer banner acumula moeda spark. X sparks = comprar 1 personagem garantido (geralmente o focus do banner). Anti-pity-burn.

**Onde aparece**
- Granblue Fantasy (Spark - 300 rolls = personagem garantido), AFK Arena (Stargazer), Idle Heroes (Casino).

**Aplicacao no nosso projeto**
- **Codex Spark**: cada drop de qualquer item raro acumula 1 ponto. 500 pontos = "Esfera de Sorte" usavel pra forcar drop raro especifico.
- Implementacao mais simples: pity ja cobre. Spark e' pity-cross-banner. Em solo, e' "essencia de raridade" universal.

**Conexao com roadmap**
- Variante de pity (item 2 deste doc).

**Anti-pattern correlato**
- **Spark cross-version sem rollover**: same do pity. Persistir.

---

## Resumo: padroes ALINHADOS x ANTI-PADROES

| Padrao | Status | Onde aplicar |
|---|---|---|
| Rate-up banner (sem $$) | Aplicar | 3.26 Eventos |
| Pity system (drops/refinamento) | Aplicar | 3.7, 3.14, 3.15 |
| Dust / Refund duplicatas | Aplicar | 3.14 (ja), 3.13, 3.7 |
| Hero shards / pieces | Aplicar | 3.10, 3.13 |
| Awakening branches | Aplicar | 3.19 (ja) |
| Constellation power-ups | Cuidado/Renomear | possivel novo |
| Daily login (cumulativo) | Aplicar | 3.18 / Calendar |
| Battle Pass | Variante "Track Sazonal free" | possivel 3.34 |
| Wishlist / Selectors | Aplicar | 3.14, 3.13, 3.21 |
| Spark / Mileage | Pode pular (pity cobre) | n/a |
| **Premium banner** | **NUNCA** | n/a |
| **Pity 200+ rolls** | **NUNCA** | n/a |
| **Streak punitive** | **NUNCA** | n/a |
| **Stamina cap diario** | **NUNCA** | n/a |
| **Limited true (nunca retorna)** | **NUNCA** | n/a |
| **C6/E6 power gap absurdo** | **NUNCA** | n/a |

---

*Fim do documento. Ver tambem:* `reference-games.md`, `idle-genre-patterns.md`.
