#!/usr/bin/env python3
"""Guard the reader-facing figure typography and formula surface.

The README intentionally uses a small set of academic-style SVG figures.  This
check prevents regenerated assets from silently falling back to UI/sans fonts or
ASCII pseudo-mathematics.  Website Mermaid and grouped-register SVGs are styled
at runtime by ``website/static/site.js``; that override is checked here too.
"""

from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
SITE_JS = ROOT / "website" / "static" / "site.js"
MPL_RC = ROOT / "matplotlibrc"

IMAGE_RE = re.compile(r"!\[[^\]]*\]\((docs/assets/[^)]+\.svg)\)")
FORBIDDEN_FONTS = (
    "Arial",
    "DejaVu Sans",
    "system-ui",
    "ui-sans-serif",
    "sans-serif",
)
ASCII_MATH_TOKENS = re.compile(r"(?i)(?:\|psi>|\bpsi\b|\balpha\b|\btensor\b|\bdagger\b|\bPi\b)")


def fail(message: str) -> None:
    print(f"figure-style check failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def read(path: Path) -> str:
    if not path.is_file():
        fail(f"missing required file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def check_readme_svgs() -> None:
    readme = read(README)
    refs = sorted(set(IMAGE_RE.findall(readme)))
    if not refs:
        fail("README has no reader-facing SVG figures")

    for ref in refs:
        path = ROOT / ref
        source = read(path)
        try:
            ET.fromstring(source)
        except ET.ParseError as exc:
            fail(f"invalid SVG XML in {ref}: {exc}")

        if "Times New Roman" not in source:
            fail(f"{ref} does not declare Times New Roman")
        for font in FORBIDDEN_FONTS:
            if font in source:
                fail(f"{ref} contains forbidden UI font {font!r}")
        if ASCII_MATH_TOKENS.search(source):
            fail(f"{ref} contains ASCII pseudo-mathematics; use TeX/Unicode symbols")


def check_website_runtime_figures() -> None:
    source = read(SITE_JS)
    required = (
        '"Times New Roman"',
        ".diagram-panel .mermaid",
        ".quantikz-preview text",
        "box-shadow: none",
    )
    for needle in required:
        if needle not in source:
            fail(f"website figure override is missing {needle!r}")


def check_matplotlib_defaults() -> None:
    source = read(MPL_RC)
    required = (
        "font.family: serif",
        "Times New Roman",
        "mathtext.fontset: stix",
        "svg.fonttype: none",
    )
    for needle in required:
        if needle not in source:
            fail(f"matplotlibrc is missing {needle!r}")


def main() -> None:
    check_readme_svgs()
    check_website_runtime_figures()
    check_matplotlib_defaults()
    print("public figure typography/formula checks passed")


if __name__ == "__main__":
    main()
