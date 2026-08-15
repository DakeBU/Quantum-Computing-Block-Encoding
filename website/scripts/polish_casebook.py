#!/usr/bin/env python3
"""Collapse technical proof/status panels after casebook enrichment.

Conceptual theorem/proof exposition stays visible.  Raw declaration inventories,
status tables, source-fidelity notes, and the detailed paper-to-Lean map remain
available through native <details> controls.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


def wrap_section(text: str, section_id: str, summary: str, intro: str) -> str:
    if f'data-collapsed-section="{section_id}"' in text:
        return text
    pattern = re.compile(
        rf'<section(?P<attrs>[^>]*\bid="{re.escape(section_id)}"[^>]*)>.*?</section>',
        re.DOTALL,
    )
    match = pattern.search(text)
    if not match:
        return text
    section = match.group(0)
    wrapped = (
        f'<details class="advanced-source-audit optional-proof-panel" '
        f'data-collapsed-section="{section_id}">'
        f'<summary>{summary}</summary>'
        f'<p class="advanced-audit-intro">{intro}</p>'
        f'{section}</details>'
    )
    return text[:match.start()] + wrapped + text[match.end():]


def polish_example_pages(root: Path) -> None:
    case_root = root / "example-cases"
    for path in case_root.glob("*/index.html"):
        text = path.read_text(encoding="utf-8")
        text = wrap_section(
            text,
            "verification-status",
            "Show machine-checked status and Lean authorities",
            "Useful when auditing the build; not required for the conceptual proof story above.",
        )
        text = wrap_section(
            text,
            "lean-certificate",
            "Show the complete Lean certificate list",
            "Open this when you want to inspect every declaration linked to the case.",
        )
        path.write_text(text, encoding="utf-8")


def polish_robin_map(root: Path) -> None:
    path = root / "case-studies" / "robin" / "index.html"
    text = path.read_text(encoding="utf-8")
    text = wrap_section(
        text,
        "how-to-read",
        "Show verification-tier/status discipline",
        "This is the formal publication policy separating a compiled declaration from a fully closed route.",
    )
    text = wrap_section(
        text,
        "correspondence",
        "Open the detailed paper-to-Lean correspondence map",
        "Each expanded row compares a source-paper anchor with the exact declaration and source location.",
    )
    path.write_text(text, encoding="utf-8")


def polish(root: Path) -> None:
    polish_example_pages(root)
    polish_robin_map(root)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    polish(args.root)


if __name__ == "__main__":
    main()
