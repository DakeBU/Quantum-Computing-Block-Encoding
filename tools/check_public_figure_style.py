#!/usr/bin/env python3
"""Guard the reader-facing README/figure typography and formula surface.

The public README is deliberately figure-first and uses conservative GitHub math
syntax. This check prevents regressions to fragile TeX, broken hierarchy assets,
UI/sans typography, or glossy dashboard-style SVG decoration.
"""

from __future__ import annotations

import re
import struct
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
SITE_JS = ROOT / "website" / "static" / "site.js"
DIAGRAM_DIR = ROOT / "website" / "diagrams"
MPL_RC = ROOT / "matplotlibrc"
HIERARCHY_SVG = ROOT / "docs" / "assets" / "aspbe_hierarchical_harness_v4.svg"
HIERARCHY_V5_PNG = ROOT / "docs" / "assets" / "aspbe_hierarchical_harness_v5.png"
HIERARCHY_CURRENT_PNG = ROOT / "docs" / "assets" / "ASPBE.png"

MARKDOWN_IMAGE_RE = re.compile(r"!\[[^\]]*\]\((docs/assets/[^)]+\.svg)\)")
HTML_SVG_RE = re.compile(r"<img\s+[^>]*src=[\"'](docs/assets/[^\"']+\.svg)[\"']", re.I)
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
FORBIDDEN_README_TOKENS = (
    "$$",
    r"\operatorname",
    r"\begin{cases}",
    r"\dfrac",
    r"\mathrm{diag}",
    'src="docs/assets/aspbe_hierarchical_harness_v4.webp"',
    'src="docs/assets/aspbe_hierarchical_harness.png"',
    'src="docs/assets/aspbe_hierarchical_harness_display.jpg"',
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
    refs.update(HTML_SVG_RE.findall(readme))
    return sorted(refs)


def png_dimensions(path: Path) -> tuple[int, int]:
    if not path.is_file():
        fail(f"missing hierarchy PNG: {path.relative_to(ROOT)}")
    data = path.read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        fail(f"invalid PNG signature: {path.relative_to(ROOT)}")
    if len(data) < 24 or data[12:16] != b"IHDR":
        fail(f"missing PNG IHDR: {path.relative_to(ROOT)}")
    return struct.unpack(">II", data[16:24])


def check_hierarchy_asset(readme: str) -> None:
    current_ref = 'src="docs/assets/ASPBE.png"'
    legacy_ref = 'src="docs/assets/aspbe_hierarchical_harness_v5.png"'
    if current_ref in readme:
        selected = HIERARCHY_CURRENT_PNG
    elif legacy_ref in readme:
        selected = HIERARCHY_V5_PNG
    else:
        fail("README must use ASPBE.png or the stable hierarchy v5 PNG")

    size = selected.stat().st_size
    if size > 2_000_000:
        fail(f"hierarchy PNG is too large for the README: {size} bytes > 2000000")
    width, height = png_dimensions(selected)
    if width < 1000 or height < 500 or width <= height:
        fail(f"hierarchy PNG must remain a readable landscape figure: {(width, height)}")

    # Keep the old public SVG URL alive as a lightweight compatibility wrapper.
    if HIERARCHY_SVG.is_file():
        svg_source = read(HIERARCHY_SVG)
        try:
            ET.fromstring(svg_source)
        except ET.ParseError as exc:
            fail(f"invalid hierarchy SVG wrapper: {exc}")
        if "aspbe_hierarchical_harness_v5.png" not in svg_source:
            fail("hierarchy SVG wrapper must point to the stable v5 PNG")
        if HIERARCHY_SVG.stat().st_size > 5_000:
            fail("hierarchy SVG compatibility wrapper should remain lightweight")


def check_readme_math_surface(readme: str) -> None:
    for token in FORBIDDEN_README_TOKENS:
        if token in readme:
            fail(f"README contains renderer-fragile token {token!r}")

    if readme.count("```math") < 6:
        fail("README should use fenced `math` blocks for its public display equations")

    for line_number, line in enumerate(readme.splitlines(), start=1):
        stripped = line.lstrip()
        if re.match(r"^#{1,6}\s", stripped) and "$" in stripped:
            fail(f"README line {line_number} puts inline math in a heading")
        if stripped.startswith("|") and "$" in stripped:
            fail(
                f"README line {line_number} puts TeX inside a Markdown table; "
                "ket/bra bars can be parsed as column separators"
            )

    order = (
        "ASPBE is designed for a quantum-computing researcher",
        "## ASPBE harness — from contract to checked evidence",
        "## Why a hierarchical harness?",
        "## Route I — State Preparation",
        "## Route II — Block Encoding",
        "## Certified block-encoding cases",
    )
    positions = [readme.find(marker) for marker in order]
    if any(position < 0 for position in positions) or positions != sorted(positions):
        fail("README reader order must be intro → public workflow → hierarchy → SP → BE → cases")

    check_hierarchy_asset(readme)


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
        'replace(/\\\\operatorname\\{([^{}]+)\\}/g, "\\\\mathrm{$1}")',
        "normalizeFragileMath",
        "MutationObserver",
    )
    for needle in required:
        if needle not in source:
            fail(f"website figure/math override is missing {needle!r}")


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
    print("public README typography/formula/layout checks passed")


if __name__ == "__main__":
    main()