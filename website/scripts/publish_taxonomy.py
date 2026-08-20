#!/usr/bin/env python3
"""Publish topic taxonomies and paper-source anchors for public case reading.

This post-build pass keeps the main site renderer stable while enforcing two
parallel public trees:

* Example Cases -> State Preparation / Block Encoding
* Papers        -> State Preparation / Block Encoding

Paper-derived example cases also receive a visible source-anchor card naming
exact equations, theorems, figures, tables, or sections.  The card explicitly
separates what the source paper states from what ASPBE specializes or improves.
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

ANCHORS_PATH = ROOT / "website" / "case-source-anchors.json"
PAPERS_PATH = ROOT / "website" / "papers.json"

TOPICS = {
    "statePreparation": {
        "slug": "state-preparation",
        "title": "State Preparation",
        "eyebrow": "Prepare |psi> from |0...0>",
        "description": (
            "State-preparation examples and papers: target amplitudes, exact unitary "
            "certificates, circuit realizations, and resource-aware improvements."
        ),
    },
    "blockEncoding": {
        "slug": "block-encoding",
        "title": "Block Encoding",
        "eyebrow": "Embed A/alpha into a unitary block",
        "description": (
            "Block-encoding examples and papers: clean-block semantics, oracle access, "
            "source constructions, and same-target circuit improvements."
        ),
    },
}

REQUIRED_ANCHORED_CASES = {
    "bell-state-preparation",
    "mottonen-dense-state-preparation",
    "grover-rudolph-product-state-preparation",
    "sparse-three-state-preparation",
    "robin-ghl-one-term",
}

SOURCE_TOKEN = re.compile(
    r"(?:Eq\.|Equation|Theorem|Thm\.|Lemma|Alg\.|Algorithm|Fig\.|Figure|Sec\.|Section|Table)"
)


def load_json(path: Path) -> dict[str, object]:
    return json.loads(path.read_text(encoding="utf-8"))


def validate_catalogs() -> tuple[dict[str, object], dict[str, object]]:
    anchors = load_json(ANCHORS_PATH)
    papers = load_json(PAPERS_PATH)
    if anchors.get("schemaVersion") != 1:
        raise RuntimeError("case source-anchor schema changed")
    records = dict(anchors.get("cases", {}))
    missing = sorted(REQUIRED_ANCHORED_CASES - set(records))
    if missing:
        raise RuntimeError(f"paper-derived cases lack source anchors: {missing}")
    for slug, raw in records.items():
        record = dict(raw)
        for key in (
            "sourceKind",
            "paperTitle",
            "authors",
            "year",
            "url",
            "anchorLabel",
            "anchors",
            "sourceMeaning",
            "caseRelation",
        ):
            if not record.get(key):
                raise RuntimeError(f"source anchor lacks {key}: {slug}")
        if not str(record["url"]).startswith("https://arxiv.org/"):
            raise RuntimeError(f"source anchor must use a stable arXiv source: {slug}")
        anchor_items = [str(item) for item in list(record["anchors"])]
        if not anchor_items or not any(SOURCE_TOKEN.search(item) for item in anchor_items):
            raise RuntimeError(f"source anchor lacks a numbered source location: {slug}")
        if not SOURCE_TOKEN.search(str(record["anchorLabel"])):
            raise RuntimeError(f"source anchor label is not source-locatable: {slug}")

    if papers.get("schemaVersion") != 1:
        raise RuntimeError("papers schema changed")
    paper_items = [dict(item) for item in papers.get("featured", [])] + [
        dict(item) for item in papers.get("queue", [])
    ]
    categories = {str(item.get("category", "")) for item in paper_items}
    if categories != set(TOPICS):
        raise RuntimeError(f"Papers must expose both State Preparation and Block Encoding: {categories}")
    for item in paper_items:
        category = str(item.get("category", ""))
        if category not in TOPICS:
            raise RuntimeError(f"unknown Papers category: {item.get('title')}: {category}")
        # Once a paper has any formalized surface, demand source locations. Queued
        # papers may remain anchor-free until reproduction work starts.
        if str(item.get("status")) != "queued":
            source_anchors = [str(x) for x in item.get("sourceAnchors", [])]
            if not source_anchors or not any(SOURCE_TOKEN.search(x) for x in source_anchors):
                raise RuntimeError(f"formalized paper lacks source anchors: {item.get('title')}")
    return anchors, papers


def case_topic(case: dict[str, object]) -> str:
    return "statePreparation" if case.get("kind") == "statePreparation" else "blockEncoding"


def category_cards(prefix: str, parent: str) -> str:
    cards = []
    for topic in TOPICS.values():
        cards.append(
            f'''<article class="case-card">
  <p class="eyebrow">{html.escape(str(topic['eyebrow']))}</p>
  <h2><a href="{prefix}{parent}/{topic['slug']}/index.html">{html.escape(str(topic['title']))}</a></h2>
  <p>{html.escape(str(topic['description']))}</p>
  <p><a class="text-link" href="{prefix}{parent}/{topic['slug']}/index.html">Open subchapter →</a></p>
</article>'''
        )
    return "".join(cards)


def inject_topic_cards(path: Path, *, prefix: str, parent: str, label: str) -> None:
    text = path.read_text(encoding="utf-8")
    marker = f'id="{parent}-topic-subchapters"'
    if marker in text:
        return
    section = f'''<section class="content-section" id="{parent}-topic-subchapters">
  <div class="section-heading">
    <p class="eyebrow">Two reading tracks</p>
    <h2>{html.escape(label)} by quantum interface</h2>
    <p>Use the same split everywhere: State Preparation asks for a unitary that prepares a target state; Block Encoding asks for a larger unitary whose selected clean block equals a target operator up to normalization.</p>
  </div>
  <div class="case-grid">{category_cards(prefix, parent)}</div>
</section>'''
    hero = re.search(r'(<section class="hero"[^>]*>.*?</section>)', text, flags=re.S)
    if not hero:
        raise RuntimeError(f"cannot find hero in {path}")
    text = text[: hero.end()] + "\n" + section + text[hero.end() :]
    path.write_text(text, encoding="utf-8")


def render_case_topic_page(
    topic_key: str,
    cases: list[dict[str, object]],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    topic = TOPICS[topic_key]
    selected = [case for case in cases if case_topic(case) == topic_key]
    cards = "".join(
        f'''<article class="case-card">
  <p class="eyebrow">{html.escape(str(case.get('semanticTier', 'certified case')))}</p>
  <h2><a href="../{html.escape(str(case['slug']))}/index.html">{html.escape(str(case['title']))}</a></h2>
  <p>{html.escape(str(case.get('summary', case.get('problem', ''))))}</p>
  <p>{build_site.badge('Lean certified' if case.get('status') == 'certified' else str(case.get('status', 'case')))}</p>
</article>'''
        for case in selected
    )
    body = f'''<section class="hero" id="example-{topic['slug']}">
  <p class="eyebrow">Example Cases · {html.escape(str(topic['title']))}</p>
  <h1>{html.escape(str(topic['title']))} example cases</h1>
  <p class="lede">{html.escape(str(topic['description']))} Paper-derived cases identify the exact source equation, theorem, figure, table, or section before the ASPBE specialization.</p>
</section>
<section class="content-section" id="case-list">
  <div class="section-heading"><p class="eyebrow">Certified examples</p><h2>Read the contract, source anchor, proof story, circuit, and Lean evidence</h2></div>
  <div class="case-grid">{cards}</div>
</section>'''
    return build_site.page_template(
        title=f"Example Cases · {topic['title']}",
        route=f"example-cases/{topic['slug']}/",
        current=f"example-cases/{topic['slug']}/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[(f"example-{topic['slug']}", str(topic["title"])), ("case-list", "Cases")],
    )


def paper_anchor_summary(item: dict[str, object]) -> str:
    anchors = [str(x) for x in item.get("sourceAnchors", [])]
    return ", ".join(anchors) if anchors else "Source anchors queued with reproduction"


def render_paper_topic_page(
    topic_key: str,
    papers: dict[str, object],
    coverage: dict[str, object],
    gate: dict[str, object],
    context: dict[str, object],
) -> str:
    topic = TOPICS[topic_key]
    items = [dict(x) for x in papers.get("featured", [])] + [dict(x) for x in papers.get("queue", [])]
    selected = [item for item in items if item.get("category") == topic_key]
    cards = []
    for item in selected:
        route = str(item.get("route", ""))
        if route:
            action = f'<a class="button" href="../../{html.escape(route)}index.html">Read reproduction</a>'
        else:
            action = f'<a class="button secondary" href="{html.escape(str(item["url"]))}">Open source paper ↗</a>'
        cards.append(
            f'''<article class="result">
  <div class="result-header"><div><p class="eyebrow">{html.escape(publish_extensions.status_label(str(item['status'])))}</p><h2>{html.escape(str(item['title']))}</h2><p>{html.escape(str(item['authors']))} · {int(item['year'])}</p></div></div>
  <p><strong>Source anchors.</strong> {html.escape(paper_anchor_summary(item))}</p>
  <p><strong>Formalized now.</strong> {html.escape(str(item.get('formalized', item.get('summary', 'See reproduction page.'))))}</p>
  <p><strong>Remaining paper-wide scope.</strong> {html.escape(str(item.get('remaining', 'See the full reproduction page for the exact boundary.')))}</p>
  <p>{action} <a class="text-link" href="{html.escape(str(item['url']))}">Source paper ↗</a></p>
</article>'''
        )
    body = f'''<section class="hero" id="papers-{topic['slug']}">
  <p class="eyebrow">Papers · {html.escape(str(topic['title']))}</p>
  <h1>{html.escape(str(topic['title']))} papers</h1>
  <p class="lede">{html.escape(str(topic['description']))} A finite benchmark, a resource lemma, and a full paper reproduction remain distinct statuses.</p>
</section>
<section class="content-section" id="paper-list">
  <div class="section-heading"><p class="eyebrow">Source-facing queue</p><h2>Paper → numbered source anchor → public formalization boundary</h2></div>
  <div class="result-list">{''.join(cards)}</div>
</section>'''
    return build_site.page_template(
        title=f"Papers · {topic['title']}",
        route=f"papers/{topic['slug']}/",
        current=f"papers/{topic['slug']}/",
        body=body,
        coverage=coverage,
        gate=gate,
        context=context,
        toc=[(f"papers-{topic['slug']}", str(topic["title"])), ("paper-list", "Papers")],
    )


def source_anchor_card(record: dict[str, object]) -> str:
    chips = " ".join(
        f'<span class="status status-compiled">{html.escape(str(anchor))}</span>'
        for anchor in record["anchors"]
    )
    return f'''<section class="content-section source-anchor" id="paper-source-anchor">
  <div class="section-heading">
    <p class="eyebrow">Source paper · {html.escape(str(record['sourceKind']))}</p>
    <h2>Where this example comes from</h2>
    <p><strong>{html.escape(str(record['paperTitle']))}</strong><br>{html.escape(str(record['authors']))} · {int(record['year'])}</p>
  </div>
  <article class="result">
    <p><strong>Source anchor.</strong> {html.escape(str(record['anchorLabel']))}</p>
    <p>{chips}</p>
    <p><strong>What the paper says.</strong> {html.escape(str(record['sourceMeaning']))}</p>
    <p><strong>What ASPBE does here.</strong> {html.escape(str(record['caseRelation']))}</p>
    <p><a class="text-link" href="{html.escape(str(record['url']))}">Open source paper ↗</a></p>
  </article>
</section>'''


def inject_source_anchor(page: Path, record: dict[str, object]) -> None:
    text = page.read_text(encoding="utf-8")
    if 'id="paper-source-anchor"' in text:
        return
    card = source_anchor_card(record)
    tutorial = re.search(r'<section[^>]*id="case-tutorial"', text)
    if tutorial:
        text = text[: tutorial.start()] + card + "\n" + text[tutorial.start() :]
    else:
        hero = re.search(r'(<section class="hero"[^>]*>.*?</section>)', text, flags=re.S)
        if not hero:
            raise RuntimeError(f"cannot inject source anchor into {page}")
        text = text[: hero.end()] + "\n" + card + text[hero.end() :]
    page.write_text(text, encoding="utf-8")


def enhance_navigation(root: Path) -> None:
    # First give newly generated pages the same Papers peer group as the extension publisher.
    publish_extensions.rewrite_navigation(root)
    for path in root.rglob("*.html"):
        text = path.read_text(encoding="utf-8")
        prefix = publish_extensions.relative_prefix(root, path)
        current = path.relative_to(root).as_posix()

        if 'data-topic-links="papers"' not in text:
            papers_all = re.search(r'(<a href="[^"]*papers/index\.html"[^>]*>All papers</a>)', text)
            if papers_all:
                links = (
                    '<div class="chapter-nav topic-nav" data-topic-links="papers">'
                    f'<a href="{prefix}papers/state-preparation/index.html"' + (' aria-current="page"' if current == 'papers/state-preparation/index.html' else '') + '><span>SP</span><span>State Preparation</span></a>'
                    f'<a href="{prefix}papers/block-encoding/index.html"' + (' aria-current="page"' if current == 'papers/block-encoding/index.html' else '') + '><span>BE</span><span>Block Encoding</span></a>'
                    '</div>'
                )
                text = text[: papers_all.end()] + links + text[papers_all.end() :]

        if 'data-topic-links="example-cases"' not in text:
            examples_all = re.search(r'(<a href="[^"]*example-cases/index\.html"[^>]*>All examples</a>)', text)
            if examples_all:
                links = (
                    '<div class="chapter-nav topic-nav" data-topic-links="example-cases">'
                    f'<a href="{prefix}example-cases/state-preparation/index.html"' + (' aria-current="page"' if current == 'example-cases/state-preparation/index.html' else '') + '><span>SP</span><span>State Preparation</span></a>'
                    f'<a href="{prefix}example-cases/block-encoding/index.html"' + (' aria-current="page"' if current == 'example-cases/block-encoding/index.html' else '') + '><span>BE</span><span>Block Encoding</span></a>'
                    '</div>'
                )
                text = text[: examples_all.end()] + links + text[examples_all.end() :]
        path.write_text(text, encoding="utf-8")


def publish(root: Path) -> None:
    anchors, papers = validate_catalogs()
    case_payload = load_json(root / "data" / "example-cases.json")
    cases = [dict(case) for case in case_payload.get("cases", [])]
    if not cases:
        raise RuntimeError("published example-case catalog is empty")
    categories = {case_topic(case) for case in cases}
    if categories != set(TOPICS):
        raise RuntimeError(f"Example Cases must expose both State Preparation and Block Encoding: {categories}")

    build_site.EXAMPLE_CASE_NAV = [
        (str(case["shortTitle"]), str(case["slug"])) for case in cases
    ]
    report = load_json(root / "build-report.json")
    coverage = dict(report["coverage"])
    gate = dict(report["leanGate"])
    context = build_site.git_context()

    for key, topic in TOPICS.items():
        build_site.write_page(
            root,
            f"example-cases/{topic['slug']}",
            render_case_topic_page(key, cases, coverage, gate, context),
        )
        build_site.write_page(
            root,
            f"papers/{topic['slug']}",
            render_paper_topic_page(key, papers, coverage, gate, context),
        )

    inject_topic_cards(
        root / "example-cases" / "index.html",
        prefix="..",
        parent="example-cases",
        label="Example Cases",
    )
    inject_topic_cards(
        root / "papers" / "index.html",
        prefix="..",
        parent="papers",
        label="Papers",
    )

    for slug, raw in dict(anchors["cases"]).items():
        page = root / "example-cases" / str(slug) / "index.html"
        if not page.is_file():
            raise RuntimeError(f"anchored example case is not published: {slug}")
        inject_source_anchor(page, dict(raw))

    data = root / "data"
    data.mkdir(parents=True, exist_ok=True)
    (data / "case-source-anchors.json").write_text(
        json.dumps(anchors, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    enhance_navigation(root)
    validate_published(root, anchors)


def validate_published(root: Path, anchors: dict[str, object]) -> None:
    for parent in ("example-cases", "papers"):
        landing = (root / parent / "index.html").read_text(encoding="utf-8")
        for topic in TOPICS.values():
            route = root / parent / str(topic["slug"]) / "index.html"
            if not route.is_file():
                raise RuntimeError(f"missing topic subchapter: {route}")
            if str(topic["title"]) not in landing:
                raise RuntimeError(f"{parent} landing lost {topic['title']} topic card")
    for slug, raw in dict(anchors["cases"]).items():
        text = (root / "example-cases" / str(slug) / "index.html").read_text(encoding="utf-8")
        record = dict(raw)
        for token in ("Where this example comes from", "Source anchor.", str(record["anchorLabel"]), "What the paper says.", "What ASPBE does here."):
            if token not in text:
                raise RuntimeError(f"source-facing case lost {token!r}: {slug}")
    sample = (root / "index.html").read_text(encoding="utf-8")
    for marker in ('data-topic-links="papers"', 'data-topic-links="example-cases"'):
        if marker not in sample:
            raise RuntimeError(f"global navigation lost topic split: {marker}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path)
    parser.add_argument("--check-data", action="store_true")
    args = parser.parse_args()
    validate_catalogs()
    if args.check_data:
        print("Example Cases/Papers taxonomy and source-anchor data valid")
        return
    if args.root is None:
        parser.error("--root is required unless --check-data is used")
    publish(args.root)


if __name__ == "__main__":
    main()
