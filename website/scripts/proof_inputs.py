"""Content identity of the local Lean source and pinned build configuration."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

CONFIG = ("QuantumBlockEncoding.lean", "Tests.lean", "lakefile.lean", "lake-manifest.json", "lean-toolchain")
SOURCE_DIRS = ("QuantumBlockEncoding", "ABEISTests")


def lean_module_targets(root: Path) -> list[str]:
    """Every catalogued source is a build target, not just imported roots."""
    proof_input_digest(root)
    return sorted(".".join(path.relative_to(root).with_suffix("").parts)
                  for name in SOURCE_DIRS for path in (root / name).rglob("*.lean"))


def proof_input_digest(root: Path) -> str:
    root = root.resolve()
    paths = [root / name for name in CONFIG]
    for name in SOURCE_DIRS:
        directory = root / name
        if not directory.is_dir():
            raise RuntimeError(f"required proof directory missing: {name}")
        paths.extend(directory.rglob("*.lean"))
    records = {}
    for path in sorted(paths):
        if not path.is_file() or not path.resolve().is_relative_to(root):
            raise RuntimeError(f"required proof input missing or external: {path.name}")
        # Git may check out LF as CRLF on Windows. Source identity must be
        # reproducible across the local build and Linux Pages runners.
        source = path.read_bytes().replace(b"\r\n", b"\n")
        records[path.relative_to(root).as_posix()] = hashlib.sha256(source).hexdigest()
    canonical = json.dumps(records, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(canonical).hexdigest()
