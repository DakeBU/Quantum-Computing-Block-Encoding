#!/usr/bin/env python3
"""Validate every generated commit-pinned declaration source link."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[2]
SOURCE_RE = re.compile(
    r"^https://github\.com/(?P<repo>[^/]+/[^/]+)/blob/"
    r"(?P<sha>[0-9a-f]{40})/(?P<path>.+)#L(?P<line>[1-9][0-9]*)$"
)


def git_ok(*args: str) -> bool:
    return (
        subprocess.run(
            ["git", *args],
            cwd=ROOT,
            check=False,
            capture_output=True,
        ).returncode
        == 0
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT / "_site")
    args = parser.parse_args()
    inventory = json.loads(
        (args.root / "library" / "declarations.json").read_text(encoding="utf-8")
    )
    metadata = json.loads(
        (args.root / "site-metadata.json").read_text(encoding="utf-8")
    )
    errors: list[str] = []
    checked = 0
    committed_files: dict[tuple[str, str], list[str] | None] = {}
    for declaration in inventory["declarations"]:
        url = declaration.get("sourceUrl")
        if not url:
            continue
        match = SOURCE_RE.match(url)
        if not match:
            errors.append(f"malformed source URL: {url}")
            continue
        source = unquote(match.group("path"))
        sha = match.group("sha")
        line = int(match.group("line"))
        if sha != metadata["commit"]:
            errors.append(f"source URL SHA differs from site metadata: {url}")
        if source != declaration["source"] or line != declaration["line"]:
            errors.append(f"source URL target differs from inventory: {url}")
        key = (sha, source)
        if key not in committed_files:
            if not git_ok("cat-file", "-e", f"{sha}:{source}"):
                committed_files[key] = None
            else:
                committed_files[key] = subprocess.run(
                    ["git", "show", f"{sha}:{source}"],
                    cwd=ROOT,
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout.splitlines()
        lines = committed_files[key]
        if lines is None:
            errors.append(f"source file absent from commit: {url}")
        elif line > len(lines):
            errors.append(f"source line exceeds file length: {url}")
        checked += 1
    if checked != metadata["sourceLinkCount"]:
        errors.append("checked source-link count differs from site metadata")
    if metadata["publishedRef"] and checked == 0:
        errors.append("published ref produced no commit-pinned source links")
    if errors:
        print("Source-link checks failed:")
        for error in errors:
            print(f"  {error}")
        return 1
    print(
        f"source-link checks passed: {checked} commit-pinned links across "
        f"{len(committed_files)} files; "
        f"publishedRef={metadata['publishedRef']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
