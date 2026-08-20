#!/usr/bin/env python3
"""Finalize the public Papers / Example Cases sidebar as a two-level tree.

The earlier publishers build the content pages.  This final pass is intentionally
small and presentation-focused: it removes duplicate case records introduced by
legacy extension overlap, rebuilds the case landing/topic pages from the unique
catalog, and replaces the old flat sidebar lists with

    Papers -> SP / BE -> papers
    Example Cases -> SP / BE -> cases

so a paper/case never appears beside its own category.
"""

from __future__ import annotations

import argparse
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from website.scripts import build_site  # noqa: E402
from website.scripts import publish_extensions  # noqa: E402
from website.scripts import publish_taxonomy  # noqa: E402


PAPER_NAV_LABELS = {
    "ghl2025-robin": "GHL Robin PDE",
    "mottonen-2005-state-preparation": "Möttönen UCRY",
    "grover-rudolph-2002": "Grover–Rudolph",
    "li-luo-sparse-state-2025": "Li–Luo sparse",
    "low-kliuchnikov-schaeffer-2018": "Low–Kliuchnikov–Schaeffer",
}


def load_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def dedupe_cases(cases: list[dict[str, object]]) -> list[dict[str, object]]:
    order: list[str] = []
    by_slug: dict[str, dict[str, object]] = {}
    for case in cases:
        slug = str(case["slug"])
        if slug not in by_slug:
            order.append(slug)
        # Prefer the later record: extension publishers generally carry the richer
        # theorem/circuit metadata when a legacy base record overlaps.
        by_slug[slug] = case
    return [by_slug[slug] for slug in order]


def paper_identifier(item: dict[str, object]) -> str:
    return str(item.get("slug") or item.get("key") or build_site.slug(str(item["title"])))


def paper_nav_label(item: dict[str, object]) -> str:
    return PAPER_NAV_LABELS.get(paper_identifier(item), str(item["title"]))


def case_nav_label(case: dict[str, object]) -> str:
    label = str(case.get("shortTitle") or case.get("title") or case["slug"])
    for prefix in ("State prep: ", "BE "):
        if label.startswith(prefix):
            return label[len(prefix) :]
    return label


def current_attr(current: str, target: str) -> str:
    return ' aria-current="page"' if current == target else ""


def render_papers_navigation(prefix: str, current: str, papers: dict[str, object]) -> str:
    items = [dict(x) for x in papers.get("featured", [])] + [
        dict(x) for x in papers.get("queue", [])
    ]
    parts = [
        '<strong class="nav-group-label">Papers</strong>',
        f'<a href="{prefix}papers/index.html"{current_attr(current, "papers/index.html")}>All papers</a>',
        '<div class="taxonomy-nav" data-taxonomy-nav="papers">',
    ]
    for topic_key, topic in publish_taxonomy.TOPICS.items():
        topic_slug = str(topic["slug"])
        topic_title = str(topic["title"])
        topic_code = "SP" if topic_key == "statePreparation" else "BE"
        topic_target = f"papers/{topic_slug}/index.html"
        selected = [item for item in items if item.get("category") == topic_key]
        parts.extend(
            [
                f'<div class="taxonomy-topic" data-topic="{topic_slug}">',
                '<div class="chapter-nav topic-nav">',
                f'<a href="{prefix}{topic_target}"{current_attr(current, topic_target)}><span>{topic_code}</span><span>{html.escape(topic_title)}</span></a>',
                '</div>',
                '<div class="chapter-nav paper-nav taxonomy-children" style="margin:2px 0 12px 20px;padding-left:10px;border-left:1px solid var(--line);">',
            ]
        )
        child_index = 0
        for item in selected:
            route = str(item.get("route", ""))
            if not route:
                continue
            child_index += 1
            target = f"{route}index.html"
            item_key = paper_identifier(item)
            parts.append(
                f'<a href="{prefix}{html.escape(target)}" data-paper="{html.escape(item_key)}" data-topic="{topic_slug}"{current_attr(current, target)}>'
                f'<span>{child_index:02d}</span><span>{html.escape(paper_nav_label(item))}</span></a>'
            )
        parts.extend(["</div>", "</div>"])
    parts.extend(
        [
            "</div>",
            f'<a class="taxonomy-utility" href="{prefix}papers/index.html#reproduction-queue">Paper reproduction queue →</a>',
        ]
    )
    return "".join(parts)


def render_examples_navigation(
    prefix: str, current: str, cases: list[dict[str, object]]
) -> str:
    parts = [
        '<strong class="nav-group-label">Example Cases</strong>',
        f'<a href="{prefix}example-cases/index.html"{current_attr(current, "example-cases/index.html")}>All examples</a>',
        '<div class="taxonomy-nav" data-taxonomy-nav="example-cases">',
    ]
    for topic_key, topic in publish_taxonomy.TOPICS.items():
        topic_slug = str(topic["slug"])
        topic_title = str(topic["title"])
        topic_code = "SP" if topic_key == "statePreparation" else "BE"
        topic_target = f"example-cases/{topic_slug}/index.html"
        selected = [case for case in cases if publish_taxonomy.case_topic(case) == topic_key]
        parts.extend(
            [
                f'<div class="taxonomy-topic" data-topic="{topic_slug}">',
                '<div class="chapter-nav topic-nav">',
                f'<a href="{prefix}{topic_target}"{current_attr(current, topic_target)}><span>{topic_code}</span><span>{html.escape(topic_title)}</span></a>',
                '</div>',
                '<div class="chapter-nav example-nav taxonomy-children" style="margin:2px 0 12px 20px;padding-left:10px;border-left:1px solid var(--line);">',
            ]
        )
        for index, case in enumerate(selected, start=1):
            slug = str(case["slug"])
            target = f"example-cases/{slug}/index.html"
            parts.append(
                f'<a href="{prefix}{target}" data-case="{html.escape(slug)}" data-topic="{topic_slug}"{current_attr(current, target)}>'
                f'<span>{index:02d}</span><span>{html.escape(case_nav_label(case))}</span></a>'
            )
        parts.extend(["</div>", "</div>"])
    parts.append("</div>")
    return "".join(parts)


def rebuild_unique_case_surfaces(root: Path, cases: list[dict[str, object]]) -> None:
    report = load_json(root / "build-report.json")
    coverage = dict(report["coverage"])
    gate = dict(report["leanGate"])
    context = build_site.git_context()

    build_site.EXAMPLE_CASE_NAV = [
        (str(case["shortTitle"]), str(case["slug"])) for case in cases
    ]
    build_site.write_page(
        root,
        "example-cases",
        build_site.render_example_case_index(cases, coverage, gate, context),
    )
    publish_taxonomy.inject_topic_cards(
        root / "example-cases" / "index.html",
        prefix="..",
        parent="example-cases",
        label="Example Cases",
    )
    for key, topic in publish_taxonomy.TOPICS.items():
        build_site.write_page(
            root,
            f"example-cases/{topic['slug']}",
            publish_taxonomy.render_case_topic_page(key, cases, coverage, gate, context),
        )

    declarations, _ = publish_extensions.declarations_from_site(root)
    publish_extensions.rebuild_search_and_metadata(root, declarations, cases)


def rewrite_navigation(
    root: Path, cases: list[dict[str, object]], papers: dict[str, object]
) -> None:
    # Re-rendered case indexes start with the base sidebar, so normalize every page
    # through the Papers publisher first.  Then replace, rather than append to, both
    # flat groups.
    publish_extensions.rewrite_navigation(root)
    papers_pattern = re.compile(
        r'<strong class="nav-group-label">Papers</strong>.*?(?=<strong class="nav-group-label">Example Cases</strong>)',
        flags=re.S,
    )
    examples_pattern = re.compile(
        r'<strong class="nav-group-label">Example Cases</strong>.*?(?=<strong class="nav-group-label">Reference</strong>)',
        flags=re.S,
    )
    for path in root.rglob("*.html"):
        text = path.read_text(encoding="utf-8")
        prefix = publish_extensions.relative_prefix(root, path)
        current = path.relative_to(root).as_posix()
        if not papers_pattern.search(text):
            raise RuntimeError(f"cannot find Papers navigation group in {path}")
        if not examples_pattern.search(text):
            raise RuntimeError(f"cannot find Example Cases navigation group in {path}")
        text = papers_pattern.sub(
            render_papers_navigation(prefix, current, papers), text, count=1
        )
        text = examples_pattern.sub(
            render_examples_navigation(prefix, current, cases), text, count=1
        )
        path.write_text(text, encoding="utf-8")


def validate(root: Path, cases: list[dict[str, object]], papers: dict[str, object]) -> None:
    slugs = [str(case["slug"]) for case in cases]
    if len(slugs) != len(set(slugs)):
        raise RuntimeError("Example Cases remain duplicated after taxonomy finalization")

    sample = (root / "index.html").read_text(encoding="utf-8")
    for marker in ('data-taxonomy-nav="papers"', 'data-taxonomy-nav="example-cases"'):
        if sample.count(marker) != 1:
            raise RuntimeError(f"missing unique hierarchical navigation marker: {marker}")
    if 'data-topic-links=' in sample:
        raise RuntimeError("legacy flat SP/BE insertion survived final hierarchy pass")

    for case in cases:
        slug = str(case["slug"])
        topic_slug = str(
            publish_taxonomy.TOPICS[publish_taxonomy.case_topic(case)]["slug"]
        )
        marker = f'data-case="{slug}" data-topic="{topic_slug}"'
        if sample.count(marker) != 1:
            raise RuntimeError(f"case not exactly once under its SP/BE directory: {slug}")

    formalized_papers = [
        dict(item)
        for item in list(papers.get("featured", [])) + list(papers.get("queue", []))
        if item.get("route")
    ]
    for item in formalized_papers:
        item_key = paper_identifier(item)
        topic_slug = str(publish_taxonomy.TOPICS[str(item["category"])]["slug"])
        marker = f'data-paper="{item_key}" data-topic="{topic_slug}"'
        if sample.count(marker) != 1:
            raise RuntimeError(f"paper not exactly once under its SP/BE directory: {item_key}")

    if 'data-paper="ghl2025-robin" data-topic="block-encoding"' not in sample:
        raise RuntimeError("GHL Robin PDE is not nested under Papers / Block Encoding")

    all_examples = (root / "example-cases" / "index.html").read_text(encoding="utf-8")
    for slug in slugs:
        href = f'{slug}/index.html'
        # One card link can appear more than once within a card (title + button), but
        # duplicate cards would multiply the title occurrence.  The canonical JSON
        # uniqueness plus rebuilt page is the authoritative no-duplicate contract.
        if href not in all_examples:
            raise RuntimeError(f"All examples lost case after dedupe: {slug}")


def finalize(root: Path) -> None:
    payload = load_json(root / "data" / "example-cases.json")
    raw_cases = [dict(case) for case in payload.get("cases", [])]
    cases = dedupe_cases(raw_cases)
    if not cases:
        raise RuntimeError("published Example Cases catalog is empty")
    payload["cases"] = cases
    (root / "data" / "example-cases.json").write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    papers = load_json(root / "data" / "papers.json")
    rebuild_unique_case_surfaces(root, cases)
    rewrite_navigation(root, cases, papers)
    validate(root, cases, papers)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    finalize(args.root)
