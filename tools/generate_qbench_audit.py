#!/usr/bin/env python3
"""Generate a deterministic declaration inventory for isolated QBench clones."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path

from proof_trust import scan_lean_source, strip_lean_comments_and_strings


DECL_RE = re.compile(
    r"^\s*(?P<modifiers>(?:(?:private|protected|noncomputable)\s+)*)"
    r"(def|theorem|lemma|structure|class|inductive|abbrev|opaque)\s+"
    r"([A-Za-z_][A-Za-z0-9_'.]*)",
    flags=re.M,
)
NAMESPACE_RE = re.compile(r"^\s*namespace\s+([A-Za-z_][A-Za-z0-9_'.]*)\s*$")
END_RE = re.compile(r"^\s*end(?:\s+([A-Za-z_][A-Za-z0-9_'.]*))?\s*$")
IMPORT_RE = re.compile(r"^\s*import\s+([^\s]+)", flags=re.M)


def git(root: Path, *args: str) -> str:
    return subprocess.check_output(
        ["git", *args], cwd=root, text=True, stderr=subprocess.DEVNULL
    ).strip()


def source_layer(path: Path) -> str:
    if path.name == "Statement.lean":
        return "statement"
    if path.name == "Definitions.lean":
        return "definitions"
    if "Base" in path.parts:
        return "base"
    return "wrapper"


def declarations(root: Path, source_root: str) -> list[dict[str, object]]:
    records: list[dict[str, object]] = []
    for path in sorted((root / source_root).rglob("*.lean")):
        raw = path.read_text(encoding="utf-8", errors="replace")
        stripped = strip_lean_comments_and_strings(raw)
        findings = scan_lean_source(path, raw)
        hole_names = {finding.declaration for finding in findings}
        imports = IMPORT_RE.findall(stripped)
        namespaces: list[str] = []
        for line_no, line in enumerate(stripped.splitlines(), start=1):
            namespace_match = NAMESPACE_RE.match(line)
            if namespace_match:
                namespaces.extend(namespace_match.group(1).split("."))
                continue
            end_match = END_RE.match(line)
            if end_match and namespaces:
                named = end_match.group(1)
                if not named:
                    namespaces.pop()
                else:
                    parts = named.split(".")
                    if namespaces[-len(parts) :] == parts:
                        del namespaces[-len(parts) :]
                    else:
                        namespaces.pop()
                continue
            match = DECL_RE.match(line)
            if not match:
                continue
            modifiers, kind, name = match.groups()
            private = "private" in modifiers.split()
            full_name = name if "." in name else ".".join([*namespaces, name])
            layer = source_layer(path.relative_to(root))
            has_hole = name in hole_names or full_name in hole_names
            records.append(
                {
                    "kind": kind,
                    "name": name,
                    "fully_qualified_name": full_name,
                    "file": path.relative_to(root).as_posix(),
                    "line": line_no,
                    "imports": imports,
                    "layer": layer,
                    "private": private,
                    "has_proof_hole": has_hole,
                    "reuse_status": (
                        "excluded: private declaration"
                        if private
                        else "excluded: benchmark proof target"
                        if layer == "statement"
                        else "audited candidate" if not has_hole else "excluded: proof hole"
                    ),
                }
            )
    return records


def repository_record(name: str, root: Path, source_root: str) -> dict[str, object]:
    records = declarations(root, source_root)
    counts: dict[str, int] = {}
    for record in records:
        if record["private"]:
            continue
        key = str(record["layer"])
        counts[key] = counts.get(key, 0) + 1
    return {
        "name": name,
        "repository": git(root, "remote", "get-url", "origin"),
        "commit": git(root, "rev-parse", "HEAD"),
        "branch": git(root, "branch", "--show-current"),
        "toolchain": (root / "lean-toolchain").read_text(encoding="utf-8").strip(),
        "license": "Apache-2.0",
        "declaration_count": sum(not bool(record["private"]) for record in records),
        "private_declaration_count": sum(bool(record["private"]) for record in records),
        "counts_by_layer": counts,
        "declarations": records,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--qalg-root", type=Path, required=True)
    parser.add_argument("--qit-root", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    payload = {
        "schema_version": 1,
        "trust_rule": (
            "Statement declarations are benchmark targets and are excluded. "
            "Only hole-free Base/Definitions declarations are audit candidates."
        ),
        "repositories": [
            repository_record("Lean-QuantumAlg-Bench", args.qalg_root, "QAlgBench"),
            repository_record("Lean-QIT-Bench", args.qit_root, "QITBench"),
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    for repository in payload["repositories"]:
        print(
            f"{repository['name']}: {repository['declaration_count']} declarations, "
            f"{repository['counts_by_layer']}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
