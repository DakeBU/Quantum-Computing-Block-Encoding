#!/usr/bin/env python3
"""Normalize topic-card links emitted on taxonomy landing pages.

The topic subchapter publisher operates one directory below the site root.  Its
landing-page injection historically received ``..`` instead of ``../``; this
small, idempotent post-build pass repairs only those two generated landing pages
before the site/link gate runs.  Source URLs and other navigation are untouched.
"""

from __future__ import annotations

import argparse
from pathlib import Path


def repair(root: Path) -> None:
    replacements = {
        'href="..example-cases/': 'href="../example-cases/',
        'href="..papers/': 'href="../papers/',
    }
    for relative in (Path("example-cases/index.html"), Path("papers/index.html")):
        path = root / relative
        if not path.is_file():
            raise RuntimeError(f"taxonomy landing page missing: {path}")
        text = path.read_text(encoding="utf-8")
        for old, new in replacements.items():
            text = text.replace(old, new)
        path.write_text(text, encoding="utf-8")

    for relative in (Path("example-cases/index.html"), Path("papers/index.html")):
        text = (root / relative).read_text(encoding="utf-8")
        if 'href="..example-cases/' in text or 'href="..papers/' in text:
            raise RuntimeError(f"malformed taxonomy link survived repair: {relative}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    repair(args.root.resolve())


if __name__ == "__main__":
    main()
