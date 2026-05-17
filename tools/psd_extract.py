"""
psd_extract.py - Extrai metadados e PNGs de cada camada de um arquivo PSD.

Uso:
    python tools/psd_extract.py caminho/para/arquivo.psd [pasta_saida]

Saida (em `pasta_saida` ou em `<nome_psd>_export/` por padrao):
    layers.json     -> hierarquia + bbox + texto + estilo de cada camada
    png/<nome>.png  -> sprite individual de cada camada rasterizavel

Pre-requisitos:
    pip install psd-tools

Convencao de nomenclatura sugerida (faca isso no Photoshop antes de exportar):
    Prefixos por categoria, tudo em snake_case:
        bg_*       -> backgrounds
        panel_*    -> paineis
        btn_*      -> botoes (ex: btn_save_normal, btn_save_hover)
        slot_*     -> slots de inventario
        icon_*     -> icones
        txt_*      -> textos
        sep_*      -> separadores
    Hierarquia (grupos do PS) e' preservada em `path` no JSON.

Notas sobre limitacoes:
- Camadas com effects (drop shadow, outer glow, etc.) sao rasterizadas com
  o efeito ja aplicado no PNG. Os params do efeito ficam em `effects`.
- Smart objects sao rasterizados como imagem normal.
- Text layers extraem font/size/color via engine_dict + aplicam o scale_y
  da matriz de transformacao da camada (Free Transform). `size` no JSON
  e' o tamanho VISIVEL no painel Character do Photoshop. `size_raw` e'
  o FontSize bruto do engine_dict (pra debug).
- Blend modes que o Godot nao suporta direto vao precisar de ajuste manual.
"""

from __future__ import annotations

import json
import math
import re
import sys
from pathlib import Path
from typing import Any

try:
    from psd_tools import PSDImage
    from psd_tools.api.layers import Group
except ImportError:
    sys.stderr.write(
        "Erro: psd-tools nao instalado. Rode: pip install psd-tools\n"
    )
    sys.exit(1)


# --- Helpers ---------------------------------------------------------------

_SAFE_NAME_RE = re.compile(r"[^a-zA-Z0-9_\-]+")


def safe_filename(name: str) -> str:
    """Normaliza nome de camada para nome de arquivo seguro."""
    cleaned = _SAFE_NAME_RE.sub("_", name.strip())
    cleaned = cleaned.strip("_")
    return cleaned or "unnamed"


def layer_path(layer) -> str:
    """Caminho legivel da camada na hierarquia, separado por '/'."""
    parts = []
    cur = layer
    # parent walk ate raiz (PSDImage nao tem nome utilizavel aqui)
    while cur is not None and getattr(cur, "name", None) is not None:
        parts.append(cur.name)
        cur = cur.parent
    parts.reverse()
    return "/".join(parts)


def bbox_to_dict(bbox) -> dict | None:
    """psd-tools BBox -> {x, y, width, height} em coordenadas do documento."""
    if bbox is None:
        return None
    # BBox do psd-tools: (left, top, right, bottom)
    try:
        left, top, right, bottom = bbox
    except (TypeError, ValueError):
        return None
    return {
        "x": int(left),
        "y": int(top),
        "width": int(right - left),
        "height": int(bottom - top),
    }


def opacity_to_float(value) -> float:
    """psd-tools entrega opacity 0..255; converter para 0..1."""
    if value is None:
        return 1.0
    try:
        return round(int(value) / 255.0, 4)
    except (TypeError, ValueError):
        return 1.0


def blend_mode_to_str(value) -> str:
    """BlendMode enum -> string lowercase legivel."""
    if value is None:
        return "normal"
    name = getattr(value, "name", None)
    if name:
        return name.lower()
    return str(value).lower()


# --- Extracao de texto -----------------------------------------------------

def get_layer_transform_scale_y(layer) -> float:
    """Le a matriz de transformacao da camada e retorna o scale_y efetivo.

    Em PSD, texto pode ser escalado de duas formas:
    1. Mudando o tamanho no painel Character -> altera `engine_dict.FontSize`.
    2. Usando Free Transform (Ctrl+T) na camada -> aplica uma matriz affine
       por cima. `engine_dict.FontSize` continua o original, mas a camada
       tem uma `transform = (xx, xy, yx, yy, tx, ty)` com scale != 1.

    O tamanho VISIVEL no Photoshop e' `FontSize * scale_y` do transform.
    Aqui calculamos `scale_y` a partir da magnitude do vetor (yx, yy).
    Retorna 1.0 se nao houver transform (camada nao redimensionada via
    Free Transform).
    """
    transform = getattr(layer, "transform", None)
    if transform is None:
        return 1.0
    try:
        seq = list(transform)
    except TypeError:
        return 1.0
    if len(seq) < 4:
        return 1.0
    try:
        yx = float(seq[2])
        yy = float(seq[3])
    except (TypeError, ValueError):
        return 1.0
    scale_y = math.sqrt(yx * yx + yy * yy)
    # Sanity: scale 0 nao faz sentido, tratar como 1.0.
    if scale_y <= 0.0001:
        return 1.0
    return scale_y


def extract_text_styles(layer) -> dict:
    """Extrai estilo do primeiro run de texto. Pode falhar silenciosamente.

    `size` retornado e' o TAMANHO EFETIVO (engine_dict.FontSize * scale_y
    da matriz de transformacao da camada). Esse e' o valor que o painel
    Character do Photoshop mostra — direto utilizavel como font_size do
    Godot (arredondado pro inteiro mais proximo).

    `size_raw` (chave extra) e' o FontSize bruto do engine_dict, pra debug.
    """
    result: dict = {
        "content": getattr(layer, "text", None),
        "font": None,
        "size": None,
        "size_raw": None,
        "color": None,
        "alignment": None,
    }
    try:
        engine = layer.engine_dict
    except Exception:
        return result
    if not engine:
        return result
    # Tentar pegar StyleRun do primeiro run.
    try:
        style_data = engine["StyleRun"]["RunArray"][0]["StyleSheet"]["StyleSheetData"]
    except (KeyError, IndexError, TypeError):
        style_data = None
    if style_data:
        try:
            raw_size = float(style_data.get("FontSize", None) or 0) or None
            result["size_raw"] = raw_size
            if raw_size is not None:
                # Aplicar scale_y da transformacao de camada (Free Transform).
                # Texto sem transform retorna 1.0 -> size == size_raw.
                scale_y = get_layer_transform_scale_y(layer)
                result["size"] = round(raw_size * scale_y, 2)
        except (TypeError, ValueError):
            pass
        # Cor: FillColor.Values e' [a, r, g, b] em 0..1
        try:
            values = style_data["FillColor"]["Values"]
            if len(values) >= 4:
                a, r, g, b = values[0], values[1], values[2], values[3]
                result["color"] = "#{:02X}{:02X}{:02X}".format(
                    max(0, min(255, int(round(r * 255)))),
                    max(0, min(255, int(round(g * 255)))),
                    max(0, min(255, int(round(b * 255)))),
                )
        except (KeyError, TypeError, ValueError):
            pass
        # Font: indice na FontSet
        try:
            font_idx = style_data.get("Font", None)
            font_set = engine["ResourceDict"]["FontSet"]
            if font_idx is not None and 0 <= int(font_idx) < len(font_set):
                font_name = font_set[int(font_idx)].get("Name", None)
                if font_name:
                    result["font"] = str(font_name).strip("\x00")
        except (KeyError, TypeError, ValueError, IndexError):
            pass
    # Alignment: pode estar em ParagraphRun
    try:
        para = engine["ParagraphRun"]["RunArray"][0]["ParagraphSheet"]["Properties"]
        justification = para.get("Justification", 0)
        # 0=left, 1=right, 2=center, 3=justify
        result["alignment"] = ["left", "right", "center", "justify"].get(
            int(justification), "left"
        ) if isinstance(justification, int) else "left"
    except (KeyError, TypeError, ValueError, IndexError, AttributeError):
        pass
    return result


# --- Extracao recursiva ----------------------------------------------------

def export_png(layer, png_path: Path) -> bool:
    """Compoe a camada como PNG individual. Retorna True se gravou."""
    try:
        image = layer.composite()
    except Exception as exc:
        sys.stderr.write(
            f"Aviso: falha ao compor '{layer.name}' como PNG: {exc}\n"
        )
        return False
    if image is None:
        return False
    png_path.parent.mkdir(parents=True, exist_ok=True)
    try:
        image.save(png_path, format="PNG")
    except Exception as exc:
        sys.stderr.write(
            f"Aviso: falha ao salvar PNG de '{layer.name}': {exc}\n"
        )
        return False
    return True


def serialize_layer(layer, png_dir: Path, used_names: set[str]) -> dict:
    """Converte uma camada (folha) em dict para o JSON."""
    kind = getattr(layer, "kind", "unknown")
    name = layer.name or "unnamed"
    base_name = safe_filename(name)
    # Garantir unicidade do nome de arquivo dentro da pasta png/
    candidate = base_name
    suffix = 2
    while candidate in used_names:
        candidate = f"{base_name}_{suffix}"
        suffix += 1
    used_names.add(candidate)
    entry: dict[str, Any] = {
        "id": candidate,
        "name": name,
        "kind": kind,
        "path": layer_path(layer),
        "bbox": bbox_to_dict(layer.bbox),
        "opacity": opacity_to_float(getattr(layer, "opacity", 255)),
        "visible": bool(getattr(layer, "visible", True)),
        "blend_mode": blend_mode_to_str(getattr(layer, "blend_mode", None)),
    }
    # Texto
    if kind == "type":
        entry["text"] = extract_text_styles(layer)
        # Texto tambem pode ser rasterizado (util pra fontes nao-Godot)
        png_path = png_dir / f"{candidate}.png"
        if export_png(layer, png_path):
            entry["png"] = f"png/{candidate}.png"
    else:
        # Imagens, shapes, smart objects: exportar PNG.
        png_path = png_dir / f"{candidate}.png"
        if export_png(layer, png_path):
            entry["png"] = f"png/{candidate}.png"
    return entry


def walk_layers(layers, png_dir: Path, used_names: set[str]) -> list[dict]:
    """Percorre arvore preservando hierarquia. Grupos viram entries com children."""
    out: list[dict] = []
    for layer in layers:
        if isinstance(layer, Group):
            entry = {
                "id": safe_filename(layer.name or "group"),
                "name": layer.name,
                "kind": "group",
                "path": layer_path(layer),
                "bbox": bbox_to_dict(layer.bbox),
                "opacity": opacity_to_float(getattr(layer, "opacity", 255)),
                "visible": bool(getattr(layer, "visible", True)),
                "blend_mode": blend_mode_to_str(getattr(layer, "blend_mode", None)),
                "children": walk_layers(list(layer), png_dir, used_names),
            }
            out.append(entry)
        else:
            out.append(serialize_layer(layer, png_dir, used_names))
    return out


# --- Main ------------------------------------------------------------------

def main() -> int:
    if len(sys.argv) < 2:
        sys.stderr.write(__doc__ or "")
        return 2
    psd_path = Path(sys.argv[1]).expanduser().resolve()
    if not psd_path.exists():
        sys.stderr.write(f"Erro: arquivo nao encontrado: {psd_path}\n")
        return 2
    if len(sys.argv) >= 3:
        out_dir = Path(sys.argv[2]).expanduser().resolve()
    else:
        out_dir = psd_path.parent / f"{psd_path.stem}_export"
    out_dir.mkdir(parents=True, exist_ok=True)
    png_dir = out_dir / "png"
    png_dir.mkdir(parents=True, exist_ok=True)

    print(f"Lendo: {psd_path}")
    psd = PSDImage.open(psd_path)
    print(f"Documento: {psd.width}x{psd.height}, modo {psd.color_mode}")

    used_names: set[str] = set()
    layers = walk_layers(list(psd), png_dir, used_names)

    # Composite final do documento (referencia visual).
    final_path = out_dir / "_composite.png"
    try:
        composite = psd.composite()
        if composite is not None:
            composite.save(final_path, format="PNG")
            print(f"Composite final: {final_path.name}")
    except Exception as exc:
        sys.stderr.write(f"Aviso: falha ao gerar composite final: {exc}\n")

    output = {
        "document": {
            "name": psd_path.name,
            "width": psd.width,
            "height": psd.height,
            "color_mode": str(psd.color_mode),
        },
        "layers": layers,
    }
    json_path = out_dir / "layers.json"
    json_path.write_text(
        json.dumps(output, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )
    print(f"JSON: {json_path}")
    print(f"PNGs em: {png_dir}")
    print(f"Total de itens (folhas + grupos): {_count_layers(layers)}")
    return 0


def _count_layers(layers: list[dict]) -> int:
    total = 0
    for entry in layers:
        total += 1
        if entry.get("kind") == "group":
            total += _count_layers(entry.get("children", []))
    return total


if __name__ == "__main__":
    raise SystemExit(main())
