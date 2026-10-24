#!/usr/bin/env python3
"""
unify_memory.py - Deterministic Multi-Node Memory Consolidator
Part of Engineering Team Suite (v3.0.0) - Taylor & Linus
Autore: Manuele Francescon (@tennet)

Aggrega in modo deterministico e idempotente i log di memoria isolati
(memory_*.jsonl) su Google Drive (3 Mac + 1 PC), eliminando duplicati
tramite checksum canonico SHA-256 senza generare conflitti di file.
"""

import os
import sys
import glob
import json
import hashlib
from pathlib import Path

def resolve_gdrive_brain() -> Path | None:
    # 1. Explicit override via Environment Variable
    env_brain = os.getenv("ANTIGRAVITY_BRAIN")
    if env_brain and Path(env_brain).is_dir():
        return Path(env_brain)

    home = Path.home()

    # 2. macOS CloudStorage detection
    cloud_storage = home / "Library" / "CloudStorage"
    if cloud_storage.is_dir():
        for gdrive in sorted(cloud_storage.glob("GoogleDrive-*")):
            candidate = gdrive / "Il mio Drive" / "Antigravity_Brain"
            if candidate.is_dir():
                return candidate
            candidate_en = gdrive / "My Drive" / "Antigravity_Brain"
            if candidate_en.is_dir():
                return candidate_en

    # 3. Windows drive letter detection (G:\, H:\)
    for letter in ["G", "H", "D", "E"]:
        candidate_win = Path(f"{letter}:\\Il mio Drive\\Antigravity_Brain")
        if candidate_win.is_dir():
            return candidate_win
        candidate_win_en = Path(f"{letter}:\\My Drive\\Antigravity_Brain")
        if candidate_win_en.is_dir():
            return candidate_win_en

    # 4. Fallback in ~/.gemini/Antigravity_Brain
    local_fallback = home / ".gemini" / "Antigravity_Brain"
    if local_fallback.is_dir():
        return local_fallback

    return None

def compute_checksum(obj: dict) -> str:
    """Calcola l'hash SHA-256 canonico per evitare duplicati."""
    if "checksum" in obj and obj["checksum"]:
        return obj["checksum"]

    item_type = obj.get("type", "unknown")
    if item_type == "entity":
        seed = f"entity:{obj.get('name', '')}:{obj.get('entityType', '')}"
    elif item_type == "relation":
        seed = f"rel:{obj.get('from', '')}->{obj.get('to', '')}:{obj.get('relationType', '')}"
    else:
        seed = json.dumps(obj, sort_keys=True)

    return f"sha256:{hashlib.sha256(seed.encode('utf-8')).hexdigest()}"

def consolidate_memory(brain_dir: Path, target_output: Path) -> dict:
    memory_dir = brain_dir / "memory"
    if not memory_dir.is_dir():
        print(f"[WARN] Memory directory not found at {memory_dir}")
        return {"entities": 0, "relations": 0, "files_scanned": 0}

    node_files = sorted(memory_dir.glob("memory_*.jsonl"))
    print(f"[INFO] Trovati {len(node_files)} file di memoria da aggregare su Google Drive:")
    for f in node_files:
        print(f"       -> {f.name} ({f.stat().st_size} bytes)")

    entities_by_name: dict[str, dict] = {}
    relations_by_edge: dict[str, dict] = {}
    total_raw_records = 0

    for fpath in node_files:
        try:
            with open(fpath, "r", encoding="utf-8") as f:
                for line_idx, line in enumerate(f, 1):
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        record = json.loads(line)
                        total_raw_records += 1
                    except json.JSONDecodeError:
                        continue

                    rec_type = record.get("type")
                    if rec_type == "entity":
                        name = record.get("name")
                        if not name:
                            continue
                        if name not in entities_by_name:
                            entities_by_name[name] = {
                                "type": "entity",
                                "name": name,
                                "entityType": record.get("entityType", "Generic"),
                                "observations": list(record.get("observations", [])),
                                "checksum": compute_checksum(record)
                            }
                        else:
                            # Merge observations without duplicates
                            existing_obs = set(entities_by_name[name]["observations"])
                            for obs in record.get("observations", []):
                                if obs not in existing_obs:
                                    entities_by_name[name]["observations"].append(obs)
                                    existing_obs.add(obs)

                    elif rec_type == "relation":
                        src = record.get("from")
                        dst = record.get("to")
                        rel = record.get("relationType", "RELATED_TO")
                        if not src or not dst:
                            continue
                        edge_key = f"{src}->{dst}:{rel}"
                        if edge_key not in relations_by_edge:
                            relations_by_edge[edge_key] = {
                                "type": "relation",
                                "from": src,
                                "to": dst,
                                "relationType": rel,
                                "checksum": compute_checksum(record)
                            }
        except Exception as e:
            print(f"[ERROR] Impossibile leggere {fpath.name}: {e}")

    # Write unified local output
    target_output.parent.mkdir(parents=True, exist_ok=True)
    tmp_output = target_output.with_suffix(".tmp")

    with open(tmp_output, "w", encoding="utf-8") as out:
        for ent in entities_by_name.values():
            out.write(json.dumps(ent, ensure_ascii=False) + "\n")
        for rel in relations_by_edge.values():
            out.write(json.dumps(rel, ensure_ascii=False) + "\n")

    tmp_output.replace(target_output)

    print(f"\n[OK] Memoria unificata consolidata con successo in:")
    print(f"     -> {target_output}")
    print(f"     Record grezzi letti: {total_raw_records}")
    print(f"     Entita' unificate:   {len(entities_by_name)}")
    print(f"     Relazioni unificate: {len(relations_by_edge)}")

    return {
        "entities": len(entities_by_name),
        "relations": len(relations_by_edge),
        "files_scanned": len(node_files),
        "target": str(target_output)
    }

def main():
    brain = resolve_gdrive_brain()
    if not brain:
        print("[ERROR] Google Drive Antigravity_Brain non trovato! Verifica il mount del drive.")
        sys.exit(1)

    print(f"[INFO] Individuato Antigravity_Brain su Google Drive: {brain}")

    home = Path.home()
    unified_local = home / ".gemini" / "antigravity" / "knowledge_graph_unified.jsonl"
    consolidate_memory(brain, unified_local)

if __name__ == "__main__":
    main()
