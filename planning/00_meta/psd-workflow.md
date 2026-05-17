# Pipeline PSD -> Godot - Workflow Oficial

> Pipeline canonico para reconstruir uma tela do Photoshop (PSD) como cena (.tscn) no Godot 4.6.
> Validado em 2026-05-07 com o Footer. Aplicar a TODA tela futura.

---

## Quando usar

Sempre que o usuario fizer uma tela nova (ou refizer uma existente) no Photoshop e quiser que o Claude reconstrua no Godot.

## Pre-requisitos

- `psd-tools` instalado: `pip install psd-tools`.
- Script de extracao em `tools/psd_extract.py` (ja no projeto).

---

## Convencao de nomenclatura no Photoshop

Antes de exportar, o usuario nomeia as camadas com **snake_case + prefixo por categoria**. Isso facilita a leitura do JSON e a montagem da `.tscn`.

| Prefixo | Categoria | Exemplo |
|---|---|---|
| `bg_*` | Backgrounds | `bg_settings_panel` |
| `panel_*` | Paineis | `panel_resources` |
| `btn_*` | Botoes | `btn_save_normal`, `btn_save_hover` |
| `slot_*` | Slots | `slot_inventory`, `slot_skill_000` |
| `icon_*` | Icones | `icon_compass` |
| `txt_*` ou `*_txt` | Textos | `txt_title`, `health_txt` |
| `sep_*` ou `*_sep` | Separadores | `divider_001_sep` |

**Regra crítica:** camadas com `_txt` no fim sao TEXTO. O PNG renderizado nao deve ser usado — recriar como `Label` no Godot, com a fonte do projeto e o texto puro.

Hierarquia (grupos do Photoshop) e' preservada em `path` no JSON e ajuda a identificar relacao entre elementos (ex: tudo dentro de `Header` vai para um Control filho `Header` no Godot).

---

## Comando de export

No terminal, na raiz do projeto:

```bash
python tools/psd_extract.py path/to/file.psd
```

Saida na pasta `<arquivo>_export/`:

```
<arquivo>_export/
├── _composite.png       <- composicao final (referencia visual)
├── layers.json          <- hierarquia + bbox + texto + estilo
└── png/
    ├── bg_panel.png
    ├── btn_save_normal.png
    └── ...
```

Saida customizada:
```bash
python tools/psd_extract.py file.psd path/to/output_dir
```

---

## Como o Claude consome

1. **Le `_composite.png`** para ver visualmente o resultado-alvo.
2. **Le `layers.json`** para extrair posicoes/dimensoes/textos/cores/blend modes.
3. **Decide quais PNGs viram assets reutilizaveis** (botoes com states, frames decorativos, slots de inventario que reaparecem em multiplas telas).
4. **Constroi a `.tscn` com posicionamento absoluto:**
   - `Control` raiz fullscreen (`anchors_preset = 15`).
   - `Control` agrupadores tambem fullscreen (organizacionais; nao impoem offset).
   - Cada elemento como `TextureRect` / `Label` / `ProgressBar` etc., com `layout_mode = 0` e `offset_left/top/right/bottom` na coord ABSOLUTA do PSD.

---

## Padrao: PSD-absolute coords + panels fullscreen organizacionais (Fase B+ — Character Modal)

**Aprendido na construcao do `character_modal.tscn`:** quando a tela tem
multiplos paineis (Hero/Equipment/Inventory/etc.), e' MELHOR posicionar
cada elemento na coord ABSOLUTA do PSD (1920x1080) ao inves de relativa
ao seu painel pai.

**Por que:**
- Erro em qualquer offset de painel compounda nos filhos
- Mais facil de verificar contra `layers.json` (basta comparar numeros)
- Move um node no Inspector da Godot e o valor que aparece JA e' a coord PSD
- Sem nenhuma matematica mental "ah, esse e' panel-relativo entao soma X"

**Como aplicar:**
1. Painel raiz da tela (ex: `CharacterModal`): fullscreen anchored
   (`anchors_preset = 15`, sem offsets).
2. Sub-paineis organizacionais (ex: `HeroPanel`, `EquipmentPanel`):
   tambem fullscreen anchored, **sem offset**. Apenas estruturam a scene
   tree no editor.
3. Containers internos (ex: `EquipSlots`, `InventorySlots`): tambem
   fullscreen anchored.
4. Cada elemento concreto (Label, TextureRect, Button, slot instance):
   `layout_mode = 0` e `offset_left/top/right/bottom` na **coord ABSOLUTA
   do PSD** (ex: `offset_left = 685` pra um texto que esta em PSD x=685).

**Quando NAO usar (manter coord relativa):**
- Filhos diretos de `TextureButton` que devem se mover JUNTO com o botao
  (ex: icone interno + label centralizado dentro de um btn que tem
  `anchors_preset = 15` no filho — anchored ao parent).

**Exemplo:**

```
CharacterModal (anchors fullscreen, root)
├── Backdrop (fullscreen ColorRect)
├── ModalBg (TextureRect at PSD coords 192,23 size 1536x1031)
├── TitleLabel (Label at PSD coords 236,60)
├── HeroPanel (fullscreen, organizational, NO offset)
│   ├── HeroesTitleLabel (Label at PSD coords 317,176)  ← absolute
│   └── HeroScroll (Control at PSD coords 241,238)      ← absolute
└── EquipmentPanel (fullscreen, organizational, NO offset)
    ├── CharNameLabel (Label at PSD coords 685,230)      ← absolute
    └── EquipSlots (fullscreen, organizational)
        └── HelmetSlot (at PSD coords 544,290)           ← absolute
```

**Conversao de coordenadas (LEGADO — quando painel pai TEM offset):**

Pra cenas mais simples sem multiplos sub-paineis (ex: footer, modais
pequenos), ainda eh OK posicionar painel raiz na sua bbox real e usar
coords relativas nos filhos. Formula:

```
local_x = psd_x - origem_x_da_cena
local_y = psd_y - origem_y_da_cena
```

Footer (validado): bbox (395, 857, 1129x219). Origem = (395, 857).
Elemento PSD em (415, 876) -> local (20, 19).

---

## Compensacao de padding nos PNGs

`psd-tools` exporta o PNG **incluindo efeitos** (drop shadow, outer glow, etc.). O tamanho REAL do PNG geralmente e' maior que o `bbox` declarado no JSON. Resultado: se posicionar pelo bbox do JSON, o PNG aparece deslocado.

Compensacao:

```
padding_x = (png_width - bbox_width) / 2
padding_y = (png_height - bbox_height) / 2
posicao_final_x = bbox_local_x - padding_x
posicao_final_y = bbox_local_y - padding_y
```

Verificar dimensoes reais via:
```bash
cd <export_dir>/png && python -c "import struct
def png_size(p):
    with open(p, 'rb') as f:
        f.read(8); f.read(4); f.read(4); w, h = struct.unpack('>II', f.read(8))
    return w, h
import os; [print(f, png_size(f)) for f in os.listdir('.') if f.endswith('.png')]"
```

---

## Conversao de font sizes

A partir de 2026-05-11, o `psd_extract.py` aplica automaticamente a matriz
de transformacao da camada (Free Transform) ao FontSize bruto. O campo
**`size` no JSON eh diretamente o tamanho VISIVEL** no painel Character do
Photoshop (em pt).

**Regra atual:** `font_size_godot = round(json.text.size)`.
- Exemplo: `size: 41.56` -> Godot `font_size = 42`.
- Exemplo: `size: 20.0` -> Godot `font_size = 20`.

O campo `size_raw` fica no JSON pra debug (eh o `engine_dict.FontSize`
direto, sem transform). Quando `size != size_raw`, significa que a
camada foi redimensionada via Free Transform (Ctrl+T) — ratio entre
os dois e' o scale_y aplicado.

**Regra antiga (Fase footer, OBSOLETA):** dividia FontSize raw por ~3.27.
Funcionava porque o footer tinha um scale_y consistente (~0.30) em todas
as camadas de texto. NAO usar mais.

User pode confirmar olhando "Caracter > tamanho real" no painel de
propriedades do Photoshop — o valor que aparece DEVE bater com `size`
no JSON (talvez com 1-2 pt de arredondamento por causa do round).

---

## Camadas `_txt` (texto)

**NAO** importar o PNG. Recriar como Label no Godot:

- `text` = string do JSON.
- `theme_override_font_sizes/font_size` = `round(json.text.size)` direto
  (psd_extract.py ja aplica o scale_y do transform — ver "Conversao de
  font sizes" acima).
- `theme_override_colors/font_color` = cor do JSON (`#C9BD93` etc.).
- **Outline:** NAO usar por default (decisao do usuario na Fase B+).
  Apenas adicionar outline em Labels que ficam SOBRE barras coloridas
  (ex: `XpValue` em cima da barra dourada — outline preto 2px pra
  contraste).
- Fonte: usa o default_theme do projeto (PT Serif Bold). Sem override
  de font.

---

## Bars com track decorativo (HP/MP/EXP/etc.)

Quando o PNG do "track" (a moldura da barra) tem opacidade nas areas onde a barra deve aparecer, a ordem do z-stack dentro do Holder e':

1. `TrailBar` (mais atras — efeito de trail vermelho ao tomar dano)
2. `Bar` (em cima do trail — barra principal)
3. `Track` (PNG do frame, **por cima** das barras — opacidade do PSD deixa as barras aparecerem nos lugares certos)
4. `Value` (Label com numeros, sempre por cima de tudo)

Holder tipicamente tem `clip_contents = true` pra evitar overflow.

**ProgressBar config:**
- `max_value = 1.0` (normalizado 0..1)
- `value = float(curr) / float(max(1, max_v))` no .gd
- `show_percentage = false`
- `theme_override_styles/background = StyleBoxFlat com bg_color = Color(0,0,0,0)` (transparente)
- `theme_override_styles/fill = StyleBoxFlat com a cor da barra`

**Cores oficiais do projeto (sub_resources reutilizaveis):**
- HpFill: `Color(0.42, 0.65, 0.42, 1)` (verde)
- HpTrailFill: `Color(0.78, 0.32, 0.3, 1)` (vermelho trail)
- MpFill: `Color(0.45, 0.58, 0.78, 1)` (azul)
- XpFill: `Color(0.949, 0.819, 0.298, 1)` (dourado)
- TransparentBg: `Color(0, 0, 0, 0)` (sempre o bg)

**Mesma estrutura no footer e no character_modal** — reutilizar quando
possivel (sub_resources iguais, paths similares pra Bar/Track/Value).

---

## Backgrounds bakeados (panels decorativos)

**Padrao Fase B+ (Character Modal):** quando uma tela tem MUITOS panels
decorativos e dividers entre eles, e' mais limpo **bakear tudo num unico
PNG** ao inves de manter cada panel/divider como TextureRect separado.

**Por que bakear:**
- Reduz dezenas de ext_resources pra 1
- Elimina risco de divider sair de alinhamento (ja faz parte do bg)
- Performance (1 draw call vs N)
- Cena fica muito mais limpa de inspecionar

**Como bakear no Photoshop:**
1. Cria um grupo "background_baked" contendo TODAS as camadas
   decorativas que nao mudam em runtime (modal_background, panel bgs,
   dividers estaticos, frames).
2. Esconde os elementos interativos/dinamicos (buttons, slots, icons,
   textos).
3. Exporta o grupo como **um unico PNG** (ex: `modal_background.png`)
   na resolucao da viewport (1920x1080 pra fullscreen).
4. No `.tscn`, usa esse PNG **como o ModalBg base**:

   ```
   [node name="ModalBg" type="TextureRect" parent="."]
   layout_mode = 0
   offset_left = 192   # PSD x absoluto onde o frame comeca
   offset_top = 23
   offset_right = 1728
   offset_bottom = 1054
   texture = ExtResource("modal_background")
   stretch_mode = 0   # SCALE — PNG renderiza 1:1
   ```

**O que mantem como PNG separado** (porque muda em runtime):
- Botoes 3-state
- Slot frames (mudam com raridade)
- Icones internos
- Texturas que precisam de stylebox stretching
- Bars (track + fill)

**No `layers.json` apos bakear:** as bbox das camadas que foram bakeadas
**continuam existindo** como referencia — use elas pra posicionar
elementos interativos relativos aos pontos visuais (ex: divider entre
HP/MP fica em y=322, entao a row de HP/MP deve estar em y=300-315).

---

## Portrait / Slots colorados

PNG do slot (com bordas decorativas) **fica intacto** — sem `modulate`.

ColorRect filho recebe a cor (do personagem, do tier, etc.), com offsets internos pra nao cobrir a borda decorativa:

```
Portrait (TextureRect com PNG do slot, sem modulate)
└── PortraitFill (ColorRect, anchor full + offsets de 14px em cada lado)
```

So o ColorRect recebe `color = char.portrait_color`. Quando o user fizer um retrato real, substitui o ColorRect por um TextureRect filho.

---

## Removidos legitimos

Se o PSD nao tem certo elemento que existia na cena anterior (ex: BattleLogBtn que foi removido no design novo), **remover** do `.tscn`. Documentar a remocao no `progress-log.md` e mencionar pro user. Signal/codigo associado pode ser mantido ate o user reorganizar onde colocar.

---

## Stretch mode do projeto

Pra garantir que o layout absoluto NAO mude com tamanho de janela, o `project.godot` deve ter:

```
window/stretch/mode = "canvas_items"
window/stretch/aspect = "keep"
```

`keep` mantem 16:9 sempre (com pillarbox/letterbox preto se a janela tiver outro aspect). Posicoes absolutas ficam intactas.

---

## Checklist final

Antes de considerar uma tela "pronta":

- [ ] PNGs importados em `assets/sprites/ui/<categoria>/`.
- [ ] `.tscn` reconstruida com posicionamento absoluto.
- [ ] Stretch mode do projeto e' `keep` (validar uma vez).
- [ ] Camadas `_txt` viraram Labels com outline.
- [ ] Bars com z-stack correto (track por cima).
- [ ] Cores extraidas do JSON aplicadas (font_color, fill).
- [ ] Sem `modulate` em PNGs com bordas decorativas (usar ColorRect filho).
- [ ] Compensacao de padding aplicada.
- [ ] Combate / Save continua funcionando (sem regressao).
- [ ] User valida visualmente que ficou igual ao `_composite.png`.
