#!/usr/bin/env python3
"""Guard the reader-facing README/figure typography and formula surface.

The public README intentionally uses a small set of academic-style SVG figures.
This check prevents regenerated assets from silently falling back to UI/sans
fonts, ASCII pseudo-mathematics, glossy dashboard decoration, or fragile README
math patterns that known renderers reject.
"""

from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
SITE_JS = ROOT / "website" / "static" / "site.js"
DIAGRAM_DIR = ROOT / "website" / "diagrams"
MPL_RC = ROOT / "matplotlibrc"

MARKDOWN_IMAGE_RE = re.compile(r"!\[[^\]]*\]\((docs/assets/[^)]+\.svg)\)")
HTML_IMAGE_RE = re.compile(r"<img\s+[^>]*src=[\"'](docs/assets/[^\"']+\.svg)[\"']", re.I)
FORBIDDEN_FONTS = (
    "Arial",
    "DejaVu Sans",
    "system-ui",
    "ui-sans-serif",
    "sans-serif",
)
FORBIDDEN_DECORATION = (
    "linearGradient",
    "radialGradient",
    "drop-shadow",
    "filter=",
)
ASCII_MATH_TOKENS = re.compile(
    r"(?i)(?:\|psi>|<psi\||\bpsi\b|\balpha\b|\bepsilon\b|\btensor\b|\bdagger\b|\bPi\b|\|0\^[a-z0-9]+>)"
)
FORBIDDEN_README_TEX = (
    r"\operatorname",
)


def fail(message: str) -> None:
    print(f"figure-style check failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def read(path: Path) -> str:
    if not path.is_file():
        fail(f"missing required file: {path.relative_to(ROOT)}")
    return path.read_text(encoding="utf-8")


def readme_svg_refs(readme: str) -> list[str]:
    refs = set(MARKDOWN_IMAGE_RE.findall(readme))
    refs.update(HTML_IMAGE_RE.findall(readme))
    return sorted(refs)


def check_readme_math_surface(readme: str) -> None:
    for macro in FORBIDDEN_README_TEX:
        if macro in readme:
            fail(f"README contains renderer-fragile TeX macro {macro!r}")

    for line_number, line in enumerate(readme.splitlines(), start=1):
        stripped = line.lstrip()
        if re.match(r"^#{1,6}\s", stripped) and "$" in stripped:
            fail(f"README line {line_number} puts inline math in a heading")
        if stripped.startswith("|") and "$" in stripped:
            fail(
                f"README line {line_number} puts TeX inside a Markdown table; "
                "ket/bra bars can be parsed as column separators"
            )


def check_readme_svgs(readme: str) -> None:
    refs = readme_svg_refs(readme)
    if len(refs) < 5:
        fail(f"README should remain figure-first; found only {len(refs)} SVG figures")

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
        for token in FORBIDDEN_DECORATION:
            if token in source:
                fail(f"{ref} contains dashboard-style SVG decoration {token!r}")
        if ASCII_MATH_TOKENS.search(source):
            fail(f"{ref} contains ASCII pseudo-mathematics; use Unicode symbols")


def check_mermaid_math_labels() -> None:
    diagrams = sorted(DIAGRAM_DIR.glob("*.mmd"))
    if not diagrams:
        fail("website/diagrams contains no Mermaid sources")
    for path in diagrams:
        source = read(path)
        match = ASCII_MATH_TOKENS.search(source)
        if match:
            fail(
                f"{path.relative_to(ROOT)} contains ASCII pseudo-math {match.group(0)!r}; "
                "use Unicode mathematical labels"
            )


def check_website_runtime_figures() -> None:
    source = read(SITE_JS)
    required = (
        '"Times New Roman"',
        ".diagram-panel .mermaid",
        ".quantikz-preview text",
        "box-shadow: none",
        '.replace(/\\balpha\\b/g, "α")',
        '.replace(/\\btheta\\b/g, "θ")',
        '.replace(/\\bperp\\b/g, "⊥")',
        '"|$1⟩"',
        "MutationObserver",
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
    readme = read(README)
    check_readme_math_surface(readme)
    check_readme_svgs(readme)
    check_mermaid_math_labels()
    check_website_runtime_figures()
    check_matplotlib_defaults()
    print("public README typography/formula checks passed")


if __name__ == "__main__":
    main()
