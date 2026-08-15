#!/usr/bin/env python3
"""Polish theorem-first casebook pages after enrichment.

Conceptual theorem/proof exposition stays visible. Raw declaration inventories,
status tables, source-fidelity notes, and the detailed paper-to-Lean map remain
available through native <details> controls. Source-backed theorem cards also
make the boundary between source text, faithful paraphrase, and Lean explicit.
"""

from __future__ import annotations

import argparse
import html
import json
import re
from pathlib import Path


WEBSITE_ROOT = Path(__file__).resolve().parents[1]
TEXTBOOK_PATH = WEBSITE_ROOT / "textbook-lessons.json"
GHL_PDF = "https://arxiv.org/pdf/2506.20478"


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


def annotate_ghl_source_theorems(text: str) -> str:
    annotations = {
        "GHL Theorem 3 · faithful paraphrase": (
            "Theorem 3, source paper p. 17",
            f"{GHL_PDF}#page=17",
        ),
        "GHL Theorem 4 · faithful paraphrase": (
            "Theorem 4 and its proof, source paper pp. 19–20",
            f"{GHL_PDF}#page=19",
        ),
    }
    for label, (reading, url) in annotations.items():
        marker = f'<p class="eyebrow">{label}</p>'
        source_note = (
            marker
            + f'<p class="casebook-source-ref"><a href="{url}">{reading}</a>. '
            + 'The prose on this page is a faithful paraphrase; the displayed equations and theorem identifiers follow the source.</p>'
        )
        if marker in text and source_note not in text:
            text = text.replace(marker, source_note, 1)
    return text


def add_textbook_quotes(text: str) -> str:
    data = json.loads(TEXTBOOK_PATH.read_text(encoding="utf-8"))
    for key in ("ibm-basics", "ibm-circuits", "lin-notes"):
        source = data["sources"][key]
        quote = source.get("quote")
        if not quote:
            continue
        href = html.escape(str(source["url"]), quote=True)
        title = html.escape(str(source["title"]))
        authors = html.escape(str(source["authors"]))
        old = (
            f'<a class="casebook-source-link" href="{href}">'
            f'<strong>{title}</strong><span>{authors}</span></a>'
        )
        new = (
            f'<a class="casebook-source-link" href="{href}">'
            f'<strong>{title}</strong><span>{authors}</span>'
            f'<blockquote>“{html.escape(str(quote))}”</blockquote></a>'
        )
        if old in text:
            text = text.replace(old, new, 1)
    return text


def polish_example_pages(root: Path) -> None:
    case_root = root / "example-cases"
    for path in case_root.glob("*/index.html"):
        text = path.read_text(encoding="utf-8")
        text = annotate_ghl_source_theorems(text)
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
    text = annotate_ghl_source_theorems(text)
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


def polish_learning_pages(root: Path) -> None:
    for route in ("learning", "state-preparation", "block-encoding"):
        path = root / route / "index.html"
        text = path.read_text(encoding="utf-8")
        text = add_textbook_quotes(text)
        path.write_text(text, encoding="utf-8")


def polish(root: Path) -> None:
    polish_example_pages(root)
    polish_robin_map(root)
    polish_learning_pages(root)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    polish(args.root)


if __name__ == "__main__":
    main()
