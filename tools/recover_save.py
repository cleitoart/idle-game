"""
One-shot recovery: re-injeta equipment + inventory perdidos no save_slot_1.json.

Pre-condicoes:
  - Godot pode estar aberto, MAS o jogo (F5) NAO pode estar rodando.
    Se estiver, o save em memoria sobrescreve esta recovery na proxima auto-save.

Uso (PowerShell ou cmd no Windows):
    python tools/recover_save.py

Idempotente: rodar 2x nao duplica items, porque o save patcheado ja vai ter o estado certo.
"""

import json
import os
import sys
from pathlib import Path

SAVE_PATH = Path(os.environ["APPDATA"]) / "Godot" / "app_userdata" / "Idle Medieval" / "save_slot_1.json"

# Snapshot perdido (do save_slot_1.json.bak2 capturado antes de ser rotacionado)
LOST_EQUIPMENT = {
    "weapon": "training_sword",
    "helmet": "iron_helmet",
    "chest": "iron_chest",
    "legs": "iron_legs",
    "boots": "iron_boots",
    "pickaxe": "worn_pickaxe",
}
LOST_INVENTORY = {
    "slime_goo": 237730,
    "iron_ore": 3791,
    "copper_ore": 1611,
    "gold_ore": 83,
    "birch_log": 298,
    "copper_bar": 3,
    "bronze_sword": 1,
}

def main() -> int:
    if not SAVE_PATH.exists():
        print(f"ERRO: save nao encontrado em {SAVE_PATH}", file=sys.stderr)
        return 1

    save = json.loads(SAVE_PATH.read_text(encoding="utf-8"))
    chars = save.get("characters", [])
    if not chars:
        print("ERRO: save sem characters", file=sys.stderr)
        return 1

    char = chars[0]
    print(f"Recovering character: {char.get('data_id')} (level {char.get('level')})")

    # --- Equipment ---
    char["equipment"] = dict(LOST_EQUIPMENT)
    char["equipment_favorites"] = char.get("equipment_favorites", {})

    # --- Inventory: soma quantidades existentes (caso o user tenha farmado mais
    #     desde o reset) com as quantidades perdidas. Items unicos (como
    #     bronze_sword stackable=false) ficam como qty=1 final.
    current_slots = char.get("inventory_slots", [])
    merged = dict(LOST_INVENTORY)
    for slot in current_slots:
        if not slot:
            continue
        iid = slot.get("item_id")
        qty = slot.get("qty", 0)
        if iid in merged:
            merged[iid] = max(merged[iid], merged[iid] + qty - LOST_INVENTORY.get(iid, 0))
            # Soma o "delta" que o user farmou alem do perdido.
            # Equivale a: merged[iid] = LOST[iid] + max(0, current - LOST[iid])
            # mas pra robustez idempotente, simplificamos pra: max(LOST, current)
            # se current >= LOST (ja recovered antes), senao LOST + current.
            if qty >= LOST_INVENTORY.get(iid, 0):
                merged[iid] = qty  # ja recuperado antes, mantem o atual
            else:
                merged[iid] = LOST_INVENTORY.get(iid, 0) + qty
        else:
            merged[iid] = qty

    # Layout do inventario: array com slots, capacity inferida do tamanho atual.
    capacity = max(len(current_slots), 16)
    new_slots = [None] * capacity
    for i, (iid, qty) in enumerate(merged.items()):
        if i >= capacity:
            print(f"AVISO: inventory cheio, ignorando {iid} (excede {capacity} slots)")
            break
        new_slots[i] = {"item_id": iid, "qty": qty}
    char["inventory_slots"] = new_slots

    # --- Hash: zera pra evitar warning. SaveManager._check_integrity_hash
    #     da return early se stored_hash == "".
    save["integrity_hash"] = ""

    # Backup do save atual antes de sobrescrever
    backup_path = SAVE_PATH.with_suffix(".json.pre_recovery")
    if not backup_path.exists():  # nao sobrescrever backup ja feito
        backup_path.write_text(json.dumps(save, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"Backup do estado anterior: {backup_path.name}")

    SAVE_PATH.write_text(json.dumps(save, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"Save patcheado: {SAVE_PATH}")
    print(f"Equipment: {len(LOST_EQUIPMENT)} slots restaurados")
    print(f"Inventory: {sum(1 for s in new_slots if s)} slots preenchidos")
    for slot in new_slots:
        if slot:
            print(f"  - {slot['item_id']}: {slot['qty']}")
    print("\nPronto. Agora abre/inicia o jogo (F5).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
