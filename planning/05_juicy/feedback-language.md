# Feedback Language - Linguagem Visual e Audio Coesa

> Vocabulario de tempos, cores, easing e tempos para que o jogo "fale" de forma uniforme. Toda nova UI/feature **deve** consultar este documento antes de definir tempos/cores/easing.
>
> Cross-ref obrigatorio em `juicy-catalog.md` (categoria por categoria).

---

## 1. Tempos padrao de tween

| Categoria | Duracao | Quando |
|---|---|---|
| **fast** | 0.15s | UI hover, button click, micro-feedback. |
| **normal** | 0.25s | Modal open, tab change, card flip. |
| **slow** | 0.45s | Tela de resultados, level-up text, drop arc. |
| **cinematic** | 1.20s | Boss appear, ascension, ritual de prestigio. |

**Constantes em codigo:**
```gdscript
# Sugerido em autoload/feedback_constants.gd
const TWEEN_FAST := 0.15
const TWEEN_NORMAL := 0.25
const TWEEN_SLOW := 0.45
const TWEEN_CINEMATIC := 1.2
```

---

## 2. Easing por contexto

| Contexto | Easing | Justificativa |
|---|---|---|
| Hover / click | cubic_out | suave, decisivo |
| Pop in (modal, drop) | back_out | "entra e estabiliza" |
| Drop arc (item caindo) | quad_in_out | gravidade visual |
| HP bar damage | quad_out | rapido no comeco, suaviza no fim |
| Big celebration (level-up, achievement) | elastic_out | exagero saudavel |
| Tab slide | sine_in_out | natural |
| Cinematic | expo_in_out | impacto |

---

## 3. Cores por elemento

Conforme `roadmap-sistemas.md` secao 3.2 (elementos do jogo):

| Elemento | Cor primary | Cor accent |
|---|---|---|
| Fire | #FF4D2A | #FFD24D |
| Ice | #6FD8FF | #FFFFFF |
| Electric | #FFE74C | #C46BFF |
| Water | #2A8FFF | #4DD2FF |
| Wind | #B8FFD2 | #6FFF94 |
| Rock | #B58A4D | #6F4F1F |
| Light | #FFF7B8 | #FFE74C |
| Dark | #6B3FA0 | #2A0F4F |

**Aplicacao:** dano elemental, particulas, frame de skill, tint de status correspondente.

---

## 4. Cores por raridade

Conforme decisao de 6 tiers (cross-ref `01_design/equipment-catalog.md`):

| Raridade | Cor frame | Cor brilho |
|---|---|---|
| Common | #B0B0B0 | - |
| Uncommon | #4DD24D | leve |
| Rare | #4D9DFF | medio |
| Epic | #C46BFF | forte |
| Legendary | #FF9D4D | forte + particula |
| Mythic | #FF4D6B | maximo + particula constante |

**Aplicacao:** card frame de itens, glow halo no chao (J03.03), particulas de drop (J03.06).

---

## 5. Cores por status

Cobertura inicial dos status mais comuns. Lista completa em `02_math/damage-formula.md`.

| Status | Cor | Icone style | Categoria |
|---|---|---|---|
| Poison | #6FD24D + #6B3FA0 | drop verde-roxo | DoT |
| Burning | #FF4D2A + #FFD24D | flame | DoT |
| Bleeding | #C92D2D + #B0B0B0 | drop vermelho rasgado | DoT/stack |
| Slowed | #6FD8FF + #B0B0B0 | engrenagem azul | debuff |
| Blind | #2A0F4F + #B0B0B0 | olho fechado | debuff |
| Freeze | #6FD8FF + #FFFFFF | cristal | debuff/disabling |
| Curse | #6B3FA0 + #2A0F4F | caveira roxa | debuff |
| Stun | #FFE74C + #FFFFFF | estrelas | disabling |
| Petrified | #B58A4D + #6F4F1F | pedra | disabling |
| Silence | #B0B0B0 + #2A8FFF | nota rasgada | disabling |
| Disarm | #B58A4D + #B0B0B0 | espada partida | debuff |
| Weakness | #6F4F1F + #B0B0B0 | seta para baixo | debuff |
| Broken Armor | #C92D2D + #B58A4D | escudo rachado | debuff |
| Health Regen | #4DD24D + #FFFFFF | cruz verde | buff |
| Mana Regen | #2A8FFF + #FFFFFF | cruz azul | buff |
| ATK Up! / Up!! / Up!!! | #FFD24D escala | espada amarela | buff |
| DEF Up! / Up!! / Up!!! | #B0B0B0 escala azulada | escudo prateado | buff |
| Shielded | #6FD8FF + #FFFFFF | bolha | buff |
| Thorns | #C92D2D + #B58A4D | espinhos | buff |
| Reflect | #C46BFF + #6FD8FF | espelho | buff |
| Berserker | #FF4D2A + #C92D2D | raiva | buff special |
| Extasis | #FFF7B8 + #C46BFF | aura | buff disabling |
| Confused | #C46BFF + #FFFFFF | espiral | debuff |

---

## 6. Decibeis de SFX por categoria

| Categoria | Volume | Justificativa |
|---|---|---|
| Music background | -22dB | sempre presente, nao competir |
| UI click | -18dB | discreto |
| UI hover | -22dB | quase subliminar |
| Combat hit (mob comum) | -10dB | claro mas nao agressivo |
| Crit | -6dB | destacar |
| Boss hit | -3dB | impactante |
| Status applied | -10dB | claro |
| Pickup Common | -14dB | nao chamar atencao |
| Pickup Uncommon-Rare | -10dB | medio |
| Pickup Epic-Legendary | -6dB | celebrativo |
| Pickup Mythic | -3dB | quase como achievement |
| Achievement / unlock | -3dB | momento maior |
| Cinematic stinger | 0dB | impactante (mas raro) |

**Tip:** todos os valores sao relativos ao master. Music ducking durante eventos importantes (cross-ref J04.03).

---

## 7. Naming conventions

### Particulas / VFX
- **Padrao:** `vfx_<nome>_<numero>.png` (numero e' frame em sequencia se animado).
- **Exemplos:** `vfx_burst_fire_01.png`, `vfx_levelup_glow_03.png`.

### Sounds
- **Padrao:** `sfx_<categoria>_<nome>.ogg`.
- **Categorias:** ui, combat, pickup, ambient, status, cinematic.
- **Exemplos:** `sfx_ui_hover.ogg`, `sfx_combat_crit.ogg`, `sfx_pickup_legendary.ogg`.

### Music
- **Padrao:** `bgm_<contexto>_<nome>.ogg`.
- **Contextos:** menu, settlement, combat, dungeon, boss, cinematic.
- **Exemplos:** `bgm_settlement_camp.ogg`, `bgm_combat_zone1.ogg`, `bgm_boss_intro.ogg`.

### Sprites
- Convencao geral em `01_design/graphics-needs.md`. Linha geral: `<categoria>_<nome>_<estado>.png`.

---

## 8. Tipografia (proposta inicial)

**[DECISAO PENDENTE: fonte oficial do projeto.]**

Sugestao para inicio:
- Fonte UI: monoespacada bold (legivel, "techy idle").
- Fonte numero de dano: bold caps com leve tracking.
- Fonte titulo de modal: serif simples ou pixel medieval.
- Tamanhos: 14 (body), 18 (subtitle), 24 (title), 32 (hero text).

---

## 9. Sintese - regras de ouro

1. Todo tween usa um dos 4 tempos padrao (1).
2. Todo elemento tem cor (3).
3. Toda raridade tem cor (4).
4. Todo status tem cor + icone (5).
5. Toda categoria de SFX tem decibel default (6).
6. Naming convention sempre seguida (7).
7. Quando em duvida: **fast + cubic_out** para UI, **slow + back_out** para celebracao, **cinematic + expo_in_out** para ritual.

---

## Cross-references

- `juicy-catalog.md` (60+ tecnicas que consomem este vocabulario)
- `01_design/graphics-needs.md`
- `01_design/audio-needs.md`
- `02_math/damage-formula.md` (lista de status)
- `01_design/equipment-catalog.md` (raridades)
- `roadmap-sistemas.md` secao 3.2
