# Juicy Catalog - Tecnicas de Gamefeel

> Catalogo de 60+ tecnicas para deixar cada acao do jogo "responsiva e gostosa". Quando aplicar, quando NAO aplicar, tempo padrao, asset necessario.
>
> Cross-references constantes: `feedback-language.md` (tempos/cores/easing), `01_design/graphics-needs.md` (sprites e VFX), `01_design/audio-needs.md` (SFX e music).
>
> **Regra geral:** "muito juicy = nao-juicy". Combate idle assistido precisa ser legivel. Adicionar com moderacao e medir impacto.

---

## Categoria 1 - Movimento e timing

### J01.01 Anticipation
- **O que faz:** frame curto de "preparar" antes de um ataque (recuar pe, levantar bracos).
- **Quando aplicar:** ataques basicos de inimigos e player. Skills com cast.
- **Quando NAO aplicar:** efeitos instantaneos (status tick, dot dano por segundo).
- **Tempo padrao:** 0.10-0.15s (cross-ref `feedback-language.md` "fast").
- **Asset necessario:** sprite com 1 frame de antecipacao (cross-ref `01_design/graphics-needs.md`).

### J01.02 Follow-through
- **O que faz:** frame de recuperacao apos ataque (volta a pose neutra com easing).
- **Quando aplicar:** skills pesadas, golpes finais, criticos.
- **Quando NAO aplicar:** ataques rapidos em sequencia (cancelar follow-through).
- **Tempo padrao:** 0.15-0.20s.
- **Asset necessario:** sprite com 1 frame de descida.

### J01.03 Squash-and-stretch
- **O que faz:** sprite "achata" no impacto e "estica" no recuo.
- **Quando aplicar:** pickup de item, level-up, hit em inimigo, botao clicado.
- **Quando NAO aplicar:** bosses serios (perde peso visual).
- **Tempo padrao:** 0.15s ida + 0.15s volta.
- **Asset necessario:** nada extra (Tween de scale).

### J01.04 Easing curves (cubic, back, elastic, expo, bounce)
- **O que faz:** trajetorias nao-lineares de tween.
- **Quando aplicar:** sempre que houver tween. Default: cubic_out para UI, back_out para pop-in.
- **Quando NAO aplicar:** hitstop (precisa ser duro).
- **Tempo padrao:** depende do contexto (cross-ref `feedback-language.md` tabela "Easing por contexto").
- **Asset necessario:** nada.

### J01.05 Hit-stop / time freeze em crit
- **O que faz:** mundo congela 0.05-0.1s no momento do crit.
- **Quando aplicar:** apenas em criticos significativos (player crit em boss; boss crit em player).
- **Quando NAO aplicar:** em DoTs, ticks, dano comum.
- **Tempo padrao:** 0.06s.
- **Asset necessario:** logica de pause; opcional flash branco no momento.

### J01.06 Slow-mo em kill final do boss
- **O que faz:** Engine.time_scale=0.3 nos ultimos 0.5s antes do boss morrer.
- **Quando aplicar:** APENAS bosses (e mini-bosses, opcional).
- **Quando NAO aplicar:** mob comum.
- **Tempo padrao:** 0.5s.
- **Asset necessario:** nada extra.

### J01.07 Frame skip em alta velocidade
- **O que faz:** em 4x/8x, pula frames intermediarios para evitar sopa visual.
- **Quando aplicar:** velocidade >= 4x.
- **Quando NAO aplicar:** 1x/2x.
- **Tempo padrao:** quanto menor o frame skip melhor (alvo: ainda legivel).
- **Asset necessario:** logica.

### J01.08 Tempo de tween padrao
- **O que faz:** padronizar duracoes para um vocabulario coeso.
- **Quando aplicar:** sempre.
- **Quando NAO aplicar:** so em casos justificados (cinematics).
- **Tempo padrao:** ver `feedback-language.md` (fast=0.15s, normal=0.25s, slow=0.45s, cinematic=1.2s).

---

## Categoria 2 - Visual feedback

### J02.01 Screen shake (intensidades)
- **O que faz:** camera tremula brevemente.
- **Quando aplicar:** crit grande, skill AoE, boss hit pesado.
- **Quando NAO aplicar:** dano comum (vira ruido).
- **Tempo padrao:** 0.10-0.20s, amplitude 2-8 pixels.
- **Asset necessario:** Tween em camera.position.

### J02.02 Flash on hit
- **O que faz:** sprite do alvo pisca em branco por 1 frame.
- **Quando aplicar:** todo hit (player e inimigo).
- **Quando NAO aplicar:** DoT ticks (poluiria).
- **Tempo padrao:** 1-2 frames (~0.03s).
- **Asset necessario:** Shader simples ou modulate.

### J02.03 Color flash em crit
- **O que faz:** sprite pisca em amarelo/vermelho (depende do tipo).
- **Quando aplicar:** crit.
- **Quando NAO aplicar:** dano comum.
- **Tempo padrao:** 2-3 frames.
- **Asset necessario:** mesmo de J02.02 mas com cor.

### J02.04 Outline glow em interativo
- **O que faz:** botao/interativo pulsa contorno luminoso.
- **Quando aplicar:** novo item disponivel, action ready, hover.
- **Quando NAO aplicar:** elementos sempre visiveis (poluem).
- **Tempo padrao:** ciclo de pulse a cada 1.0-1.5s.
- **Asset necessario:** Shader outline.

### J02.05 Damage number pop com easing
- **O que faz:** numero aparece com scale 0->1.2->1.0 com back_out.
- **Quando aplicar:** todo dano significativo.
- **Quando NAO aplicar:** dano fracional repetido (DoT). Use floating text condensado.
- **Tempo padrao:** 0.20s scale + 0.5-0.8s float.
- **Asset necessario:** ja temos `damage_number.tscn`.

### J02.06 Floating text que sobe e desaparece
- **O que faz:** numero/texto sobe ~30px com fade-out.
- **Quando aplicar:** dano, cura, pickup, status applied.
- **Quando NAO aplicar:** mensagens informativas (use Battle Log).
- **Tempo padrao:** 0.6-1.0s total.
- **Asset necessario:** ja temos.

### J02.07 Crit text maior + colorido
- **O que faz:** crit aparece com fonte 1.5x e cor amarelo/laranja.
- **Quando aplicar:** crit.
- **Quando NAO aplicar:** dano comum.
- **Tempo padrao:** mesmo de J02.05.
- **Asset necessario:** font size variavel.

### J02.08 Miss / Dodge / Block textos diferenciados
- **O que faz:** "MISS" em cinza, "DODGE" em azul, "BLOCK" em prata.
- **Quando aplicar:** quando o evento ocorre.
- **Quando NAO aplicar:** dano normal.
- **Tempo padrao:** mesmo de damage number.
- **Asset necessario:** font + cor (cross-ref `feedback-language.md`).

### J02.09 Combo counter
- **O que faz:** contador "x2", "x5", "x10" que pula no canto da tela.
- **Quando aplicar:** sequencia de hits sem interrupcao.
- **Quando NAO aplicar:** combate calmo (1 hit cada 2s).
- **Tempo padrao:** reset apos 1.5s sem hit.
- **Asset necessario:** Label dinamico.

### J02.10 Kill streak meter
- **O que faz:** barra que enche ao matar inimigos seguidos; estoura -> buff temporario.
- **Quando aplicar:** mid-game+ (Fase 02-03).
- **Quando NAO aplicar:** Fase 00-01 (sobrecarrega UI).
- **Tempo padrao:** decai em 5s sem kill.
- **Asset necessario:** UI progress bar + VFX de "estouro".

### J02.11 Hit-spark (Street Fighter style)
- **O que faz:** estrela/explosao curta no ponto de impacto.
- **Quando aplicar:** todo hit melee.
- **Quando NAO aplicar:** ataques magicos (substituir por VFX elemental).
- **Tempo padrao:** 0.10s.
- **Asset necessario:** sprite de hit-spark animado (cross-ref `01_design/graphics-needs.md`).

### J02.12 Element tints
- **O que faz:** sprite ganha tom da cor do elemento ao sofrer dano daquele tipo.
- **Quando aplicar:** dano elemental.
- **Quando NAO aplicar:** dano fisico puro.
- **Tempo padrao:** 0.20s.
- **Asset necessario:** cores em `feedback-language.md`.

### J02.13 Squash and stretch em sprites em hit
- **O que faz:** sprite achata na horizontal por 1 frame ao receber hit.
- **Quando aplicar:** todo hit fisico.
- **Quando NAO aplicar:** bosses solidos.
- **Tempo padrao:** 0.05s.
- **Asset necessario:** Tween scale.

---

## Categoria 3 - Particulas

### J03.01 Burst em kill
- **O que faz:** explosao curta de particulas no ponto da morte.
- **Quando aplicar:** todo kill.
- **Quando NAO aplicar:** wave de muitos kills simultaneos (vira sopa). Limitar a 1 burst grande + restantes pequenos.
- **Tempo padrao:** 0.4s.
- **Asset necessario:** `vfx_burst_<elemento>_<numero>.png` (cross-ref convencao em `feedback-language.md`).

### J03.02 Trail em projetil
- **O que faz:** rastro luminoso atras de projetil.
- **Quando aplicar:** ataques ranged, magias.
- **Quando NAO aplicar:** ataques melee.
- **Tempo padrao:** 0.3-0.5s de fade-out apos saida.
- **Asset necessario:** sprite de particula simples (1-2 cores).

### J03.03 Glow halo em pickup
- **O que faz:** halo orbita o item dropado no chao.
- **Quando aplicar:** drops de Rare+.
- **Quando NAO aplicar:** Common (poluiria).
- **Tempo padrao:** loop infinito ate pickup.
- **Asset necessario:** `vfx_pickup_glow_<raridade>.png`.

### J03.04 Particles em level-up
- **O que faz:** particulas verticais subindo do personagem.
- **Quando aplicar:** level-up de personagem ou skill.
- **Quando NAO aplicar:** outros eventos.
- **Tempo padrao:** 0.8-1.2s.
- **Asset necessario:** ja temos VFX de level-up.

### J03.05 Particles por elemento
- **O que faz:** cada elemento tem suas particulas (chama, gelo, raio...).
- **Quando aplicar:** skill/dano elemental.
- **Quando NAO aplicar:** ataque fisico.
- **Tempo padrao:** depende da skill.
- **Asset necessario:** set por elemento (cross-ref `01_design/graphics-needs.md`).

### J03.06 Particle por raridade de drop
- **O que faz:** drop de tier maior gera particulas mais densas.
- **Quando aplicar:** sempre em drops Rare+.
- **Quando NAO aplicar:** Common.
- **Tempo padrao:** 0.5s no momento do drop.
- **Asset necessario:** intensidade variavel da mesma sprite.

### J03.07 Hover particle em UI
- **O que faz:** botao hover gera particulas suaves.
- **Quando aplicar:** botoes principais (atacar, comprar).
- **Quando NAO aplicar:** UI densa (botoes pequenos em modais).
- **Tempo padrao:** loop enquanto hover.
- **Asset necessario:** particula sutil.

---

## Categoria 4 - Som (cross-ref `audio-needs.md`)

### J04.01 Layering de SFX
- **O que faz:** combinar hit + crit + status applied em um momento como SFX em camadas.
- **Quando aplicar:** crit que aplica status.
- **Quando NAO aplicar:** hit comum.
- **Tempo padrao:** SFX se sobrepoem; cada um 0.2-0.4s.
- **Asset necessario:** SFXs separados (cross-ref `01_design/audio-needs.md`).

### J04.02 Stinger antes de boss
- **O que faz:** musica corta, stinger curto, music de boss entra.
- **Quando aplicar:** spawn de boss.
- **Quando NAO aplicar:** mob comum.
- **Tempo padrao:** stinger 1.5-2.0s.
- **Asset necessario:** `bgm_combat_boss_stinger.ogg`.

### J04.03 Music duck em boss intro
- **O que faz:** abaixa volume da BGM enquanto VO/SFX de intro toca.
- **Quando aplicar:** boss intro com VO.
- **Quando NAO aplicar:** combate normal.
- **Tempo padrao:** 1.5s.
- **Asset necessario:** logica de mixer.

### J04.04 SFX por raridade de drop
- **O que faz:** Common = "tic", Uncommon = "ding", Rare = "ding+coro", Epic+ = stinger curto.
- **Quando aplicar:** drop.
- **Quando NAO aplicar:** drops em massa (limitar 1 SFX por wave).
- **Tempo padrao:** 0.3-1.0s.
- **Asset necessario:** SFXs por raridade.

### J04.05 Volume de UI vs combate
- **O que faz:** UI -18dB, combate hit -10dB, crit -6dB, boss hit -3dB, music -22dB.
- **Quando aplicar:** sempre (default global).
- **Quando NAO aplicar:** so override em casos especificos.
- **Asset necessario:** mixer config (cross-ref `feedback-language.md`).

---

## Categoria 5 - UI / UX

### J05.01 Botao com hover scale + sound
- **O que faz:** scale 1.0 -> 1.05 + SFX `sfx_ui_hover.ogg`.
- **Quando aplicar:** botoes principais.
- **Quando NAO aplicar:** items de listas longas.
- **Tempo padrao:** 0.10s.
- **Asset necessario:** SFX hover.

### J05.02 Modal abrir com fade + scale
- **O que faz:** modal aparece com alpha 0->1 + scale 0.95->1.0.
- **Quando aplicar:** todo modal.
- **Quando NAO aplicar:** tooltips rapidos.
- **Tempo padrao:** 0.25s (cross-ref `feedback-language.md` "normal").
- **Asset necessario:** logica de Tween.

### J05.03 Tab change com slide
- **O que faz:** novo conteudo desliza horizontalmente.
- **Quando aplicar:** abas principais (codex, inventario).
- **Quando NAO aplicar:** abas pequenas (filtros).
- **Tempo padrao:** 0.20s.
- **Asset necessario:** logica.

### J05.04 Progress bar com fill suave + delay
- **O que faz:** barra enche com easing, com pequeno delay para parecer "respeitar" o evento.
- **Quando aplicar:** XP gain, gathering progress.
- **Quando NAO aplicar:** HP em combate (precisa ser instantaneo).
- **Tempo padrao:** 0.30s.
- **Asset necessario:** Tween.

### J05.05 Damage trail in HP bar (ja temos)
- **O que faz:** barra atras anima ate o novo valor com delay.
- **Quando aplicar:** HP do player e bosses.
- **Quando NAO aplicar:** HP de mob comum (UI poluida).
- **Tempo padrao:** 0.4s delay + 0.3s tween.
- **Asset necessario:** ja temos.

### J05.06 Slot empty com pulse
- **O que faz:** slot vazio importante (pet, card) pulsa ate ser preenchido.
- **Quando aplicar:** primeiro acesso a feature.
- **Quando NAO aplicar:** apos primeira ativacao.
- **Tempo padrao:** ciclo 1.5s.
- **Asset necessario:** Tween scale ou alpha.

### J05.07 Notification stack com slide
- **O que faz:** notificacoes empilham deslizando para cima.
- **Quando aplicar:** achievements, level-ups.
- **Quando NAO aplicar:** drops massivos (use Battle Log).
- **Tempo padrao:** 0.30s slide-in, 3s display, 0.30s slide-out.
- **Asset necessario:** layout dedicado.

### J05.08 Achievement popup com fade + sound stinger
- **O que faz:** banner achievement entra com fade + SFX especial.
- **Quando aplicar:** achievement desbloqueado.
- **Quando NAO aplicar:** outros eventos.
- **Tempo padrao:** 4s display total.
- **Asset necessario:** sprite banner + SFX `sfx_ui_achievement.ogg`.

---

## Categoria 6 - Camera

### J06.01 Zoom in em boss
- **O que faz:** zoom 1.0 -> 1.15 ao entrar boss.
- **Quando aplicar:** boss spawn.
- **Quando NAO aplicar:** mob comum.
- **Tempo padrao:** 0.5s ida + 1.5s hold + 0.4s volta.
- **Asset necessario:** logica de camera.

### J06.02 Pan para mostrar drop
- **O que faz:** camera levemente pans para drop especial.
- **Quando aplicar:** drop Legendary+.
- **Quando NAO aplicar:** drops comuns.
- **Tempo padrao:** 0.4s.
- **Asset necessario:** logica.

### J06.03 Camera shake em explosao
- **O que faz:** ver J02.01 com amplitude maior.
- **Quando aplicar:** AoE grande, raid boss attack.
- **Tempo padrao:** 0.20s.
- **Asset necessario:** logica.

### J06.04 Vignette em low HP
- **O que faz:** bordas da tela ganham vinheta vermelha pulsante quando player HP < 20%.
- **Quando aplicar:** HP critico.
- **Quando NAO aplicar:** HP saudavel.
- **Tempo padrao:** ciclo de pulse 0.8s.
- **Asset necessario:** Shader ou sprite de vignette.

---

## Categoria 7 - Drop / pickup feel

### J07.01 Pickup arc
- **O que faz:** drop voa em arco do inimigo morto ate o inventario.
- **Quando aplicar:** drops.
- **Quando NAO aplicar:** drop em sequencia rapida (limita arc a primeiros 3-5).
- **Tempo padrao:** 0.4-0.6s.
- **Asset necessario:** logica de Tween em curva.

### J07.02 Magnetic attract para player
- **O que faz:** drops se movem em direcao ao player apos N segundos.
- **Quando aplicar:** auto-pickup desbloqueado.
- **Quando NAO aplicar:** se auto-pickup desativado.
- **Tempo padrao:** 0.5s de "espera" + 0.4s de viagem.
- **Asset necessario:** logica.

### J07.03 Pickup sound + particle
- **O que faz:** SFX + pequeno particle no momento do pickup.
- **Quando aplicar:** sempre.
- **Quando NAO aplicar:** drops massivos (use 1 SFX condensado).
- **Tempo padrao:** 0.10s.
- **Asset necessario:** SFX.

### J07.04 Stack count flash em pickup
- **O que faz:** numero da quantidade no slot pisca brevemente.
- **Quando aplicar:** ao stackar item ja existente.
- **Quando NAO aplicar:** primeiro item da stack.
- **Tempo padrao:** 0.20s.
- **Asset necessario:** Label scale ou color tween.

---

## Categoria 8 - Skills

### J08.01 Cast bar suave
- **O que faz:** barra de cast enche com easing.
- **Quando aplicar:** skills com cast time.
- **Quando NAO aplicar:** instantaneas.
- **Tempo padrao:** depende da skill.
- **Asset necessario:** UI bar.

### J08.02 Skill ready glow
- **O que faz:** icone da skill brilha ao sair do cooldown.
- **Quando aplicar:** sempre, em modo manual.
- **Quando NAO aplicar:** modo automatico (irrelevante).
- **Tempo padrao:** loop ate uso.
- **Asset necessario:** Shader de glow.

### J08.03 Skill icon flash em ready
- **O que faz:** flash branco curto no momento que fica pronta.
- **Quando aplicar:** skills com cooldown alto.
- **Quando NAO aplicar:** skills com cooldown < 2s.
- **Tempo padrao:** 0.15s.
- **Asset necessario:** Tween color.

### J08.04 Combo skill chain (X seguido de Y faz Z)
- **O que faz:** sequencia de skills ativa skill bonus.
- **Quando aplicar:** mid-game+ (Fase 03+).
- **Quando NAO aplicar:** Fase 01.
- **Tempo padrao:** janela de 3s entre skills.
- **Asset necessario:** logica + VFX bonus.

---

## Categoria 9 - Level-up / progressao

### J09.01 Level-up burst (ja temos)
- **O que faz:** burst de particulas + flash + texto.
- **Quando aplicar:** level-up.
- **Quando NAO aplicar:** outros.
- **Tempo padrao:** 1.0s.
- **Asset necessario:** ja temos.

### J09.02 Star added animation
- **O que faz:** estrela aparece com particulas em momento de Awakening.
- **Quando aplicar:** ★1, ★3, ★5, ★7, ★9, ★10.
- **Quando NAO aplicar:** outros.
- **Tempo padrao:** 1.5s cinematic.
- **Asset necessario:** sprite estrela + VFX.

### J09.03 Constelacao node light-up
- **O que faz:** no da constelacao acende com particulas estelares.
- **Quando aplicar:** ao gastar ponto de constelacao.
- **Tempo padrao:** 0.6s.
- **Asset necessario:** VFX especifico.

### J09.04 Awakening transformation cinematic
- **O que faz:** mini-cinematica do personagem se transformando.
- **Quando aplicar:** Awakening (Fase 03+).
- **Tempo padrao:** 3-5s.
- **Asset necessario:** animacao + skin nova.

### J09.05 Renascimento ritual loop
- **O que faz:** crescente de particulas + escurecimento de tela + flash branco.
- **Quando aplicar:** Renascimento (Fase 03).
- **Tempo padrao:** 5-8s cinematic.
- **Asset necessario:** sequencia de VFX.

### J09.06 Transcendencia super-cinematic
- **O que faz:** estrelas explodem, tela escurece, surge novo logo do personagem.
- **Quando aplicar:** Transcendencia (Fase 04).
- **Tempo padrao:** 10-15s cinematic.
- **Asset necessario:** cinematica completa.

### J09.07 Ascensao Cosmica ultra-cinematic
- **O que faz:** efeito tipo "big bang" + camera afasta + universo se reforma.
- **Quando aplicar:** Ascensao Cosmica (Fase 04).
- **Tempo padrao:** 15-30s cinematic, com skip opcao.
- **Asset necessario:** maior cinematica do jogo.

---

## Categoria 10 - Quality of life "juicy"

### J10.01 Auto-collect com radial accumulator
- **O que faz:** drops voam para indicador radial que mostra qtd acumulada.
- **Quando aplicar:** auto-collect ativo.
- **Quando NAO aplicar:** drop manual.
- **Tempo padrao:** loop continuo.
- **Asset necessario:** UI radial.

### J10.02 Auto-equip flash
- **O que faz:** ao auto-equipar, slot pisca para sinalizar troca.
- **Quando aplicar:** auto-equip ativo.
- **Quando NAO aplicar:** equip manual.
- **Tempo padrao:** 0.20s.
- **Asset necessario:** Tween color.

### J10.03 Auto-craft progress
- **O que faz:** barra circular em volta do icone de crafting station, indicando progresso.
- **Quando aplicar:** crafting station auto-ativa.
- **Tempo padrao:** loop ate fim.
- **Asset necessario:** Shader radial.

### J10.04 Toggle X/2X/4X/8X com indicator visual
- **O que faz:** botao mostra velocidade atual. Particulas por nivel (1x normal, 2x quente, 4x intenso, 8x rocket).
- **Quando aplicar:** sempre que velocidade > 1x.
- **Quando NAO aplicar:** 1x.
- **Tempo padrao:** loop continuo proporcional.
- **Asset necessario:** sprite especial por nivel.

### J10.05 Speed indicator no HUD
- **O que faz:** texto "2x" ou "4x" no canto superior, sempre visivel.
- **Quando aplicar:** velocidade > 1x.
- **Quando NAO aplicar:** 1x.
- **Tempo padrao:** persistente.
- **Asset necessario:** Label.

---

## Cross-references

- `feedback-language.md` (tempos, easing, cores)
- `01_design/graphics-needs.md` (assets visuais)
- `01_design/audio-needs.md` (SFX/music)
- `04_phases/phase-XX-*.md` (qual juicy chega em qual fase, ver `00_meta/phase-navigation.md`)
