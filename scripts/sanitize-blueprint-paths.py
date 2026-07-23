#!/usr/bin/env python3
"""Normalize Blueprint source locations before publishing the generated site."""

from __future__ import annotations

import argparse
import json
from pathlib import Path, PurePosixPath, PureWindowsPath
from typing import Any


def _is_absolute(path: str) -> bool:
    return PurePosixPath(path).is_absolute() or PureWindowsPath(path).is_absolute()


def _relative_source_path(source_path: str, repo_root: Path) -> str:
    """Return a portable repository-relative source path.

    Verso records the source file supplied by Lean.  On some platforms that is
    an absolute path, so strip the current repository root without ever baking
    that root into a tracked file.  Absolute paths outside the repository are
    rejected rather than published.
    """

    normalized = source_path.replace("\\", "/")
    normalized_root = str(repo_root).replace("\\", "/").rstrip("/")

    # Windows drive paths are case-insensitive.  Using casefold for the prefix
    # comparison is harmless for the repository root on the other platforms.
    prefix = normalized_root + "/"
    if normalized.casefold().startswith(prefix.casefold()):
        relative = normalized[len(prefix) :]
    elif normalized.casefold() == normalized_root.casefold():
        raise ValueError("a Blueprint source path resolves to the repository root")
    elif _is_absolute(normalized) or normalized.startswith("file://"):
        raise ValueError("a Blueprint source path points outside the repository")
    else:
        relative = normalized

    portable = PurePosixPath(relative)
    if portable.is_absolute() or ".." in portable.parts:
        raise ValueError("a Blueprint source path is not repository-relative")
    return portable.as_posix()


def _normalize_source_paths(value: Any, repo_root: Path) -> tuple[Any, int, int]:
    """Normalize every structured ``sourcePath`` field in a JSON value."""

    if isinstance(value, dict):
        normalized: dict[str, Any] = {}
        changed = 0
        seen = 0
        for key, child in value.items():
            if key == "sourcePath":
                if not isinstance(child, str):
                    raise TypeError("Blueprint sourcePath must be a string")
                replacement = _relative_source_path(child, repo_root)
                normalized[key] = replacement
                changed += int(replacement != child)
                seen += 1
            else:
                replacement, child_changed, child_seen = _normalize_source_paths(
                    child, repo_root
                )
                normalized[key] = replacement
                changed += child_changed
                seen += child_seen
        return normalized, changed, seen

    if isinstance(value, list):
        normalized_items: list[Any] = []
        changed = 0
        seen = 0
        for child in value:
            replacement, child_changed, child_seen = _normalize_source_paths(
                child, repo_root
            )
            normalized_items.append(replacement)
            changed += child_changed
            seen += child_seen
        return normalized_items, changed, seen

    return value, 0, 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Make generated Blueprint source locations repository-relative."
    )
    parser.add_argument(
        "output",
        nargs="?",
        default="_out/blueprint",
        help="Blueprint output directory (default: _out/blueprint)",
    )
    args = parser.parse_args()

    repo_root = Path.cwd().resolve()
    xref_path = Path(args.output) / "html-multi" / "xref.json"
    if not xref_path.is_file():
        raise FileNotFoundError("generated Blueprint xref.json was not found")

    data = json.loads(xref_path.read_text(encoding="utf-8"))
    normalized, changed, seen = _normalize_source_paths(data, repo_root)
    if seen == 0:
        raise ValueError("generated Blueprint xref.json has no sourcePath fields")

    xref_path.write_text(
        json.dumps(normalized, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(f"Normalized {changed} of {seen} Blueprint source paths.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
