#!/usr/bin/env python3

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "research-wiki" / "technical-lemmas" / "registry.json"
REQUIRED_FIELDS = {
    "id",
    "theorem",
    "fully_qualified_name",
    "source_file",
    "required_imports",
    "category",
    "semantic_layer",
    "assumptions",
    "conclusion",
    "exact_signature",
    "related_leaves",
    "compatible_shapes",
    "known_successful_uses",
    "failed_uses",
    "external_source",
    "license_attribution",
    "lean_version",
    "verification_status",
    "local_declaration_status",
    "broader_route_status",
}


def main() -> int:
    payload = json.loads(REGISTRY.read_text(encoding="utf-8"))
    entries = payload.get("entries")
    if not isinstance(entries, list):
        raise SystemExit("technical lemma registry: entries must be a list")

    errors: list[str] = []
    seen_ids: set[str] = set()
    seen_names: set[str] = set()
    for index, entry in enumerate(entries):
        if not isinstance(entry, dict):
            errors.append(f"entry {index}: expected an object")
            continue
        missing = sorted(REQUIRED_FIELDS - set(entry))
        if missing:
            errors.append(f"entry {index}: missing {', '.join(missing)}")
            continue
        lemma_id = str(entry["id"])
        full_name = str(entry["fully_qualified_name"])
        if lemma_id in seen_ids:
            errors.append(f"{lemma_id}: duplicate id")
        if full_name in seen_names:
            errors.append(f"{lemma_id}: duplicate fully qualified name")
        seen_ids.add(lemma_id)
        seen_names.add(full_name)

        source = ROOT / str(entry["source_file"])
        if not source.is_file():
            errors.append(f"{lemma_id}: source does not exist: {entry['source_file']}")
            continue
        text = source.read_text(encoding="utf-8")
        theorem = re.escape(str(entry["theorem"]))
        if not re.search(rf"\b(?:theorem|lemma)\s+{theorem}\b", text):
            errors.append(
                f"{lemma_id}: declaration {entry['theorem']} not found in "
                f"{entry['source_file']}"
            )
        if entry["verification_status"] != "compiled":
            errors.append(f"{lemma_id}: promoted entry is not marked compiled")
        if entry["local_declaration_status"] != "complete":
            errors.append(f"{lemma_id}: promoted entry is not locally complete")

    if errors:
        print("technical lemma registry check failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(
        "technical lemma registry: "
        f"{len(entries)} unique compiled declarations, source references valid"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
