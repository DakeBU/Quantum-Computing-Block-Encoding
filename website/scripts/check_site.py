#!/usr/bin/env python3
"""Check the assembled static site, internal links, fragments, and indexes."""

from __future__ import annotations

import argparse
import json
import re
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit


ROOT = Path(__file__).resolve().parents[2]


class PageParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.ids: set[str] = set()
        self.references: list[tuple[str, str]] = []
        self.base_href: str | None = None

    def handle_starttag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        values = dict(attrs)
        identifier = values.get("id") or values.get("name")
        if identifier:
            self.ids.add(identifier)
        if tag == "base" and values.get("href") and self.base_href is None:
            self.base_href = values["href"]
        if tag in {"a", "link"} and values.get("href"):
            self.references.append(("href", values["href"]))
        if tag in {"script", "img", "source"} and values.get("src"):
            self.references.append(("src", values["src"]))


def parse_page(path: Path) -> PageParser:
    parser = PageParser()
    parser.feed(path.read_text(encoding="utf-8", errors="replace"))
    return parser


def relative_url(path: Path, site: Path) -> str:
    return path.relative_to(site).as_posix()


def target_file(
    site: Path, current: Path, raw_url: str, base_href: str | None
) -> tuple[Path, str]:
    parsed = urlsplit(raw_url)
    current_url = relative_url(current, site)
    base_url = urljoin(current_url, base_href) if base_href else current_url
    joined = urlsplit(urljoin(base_url, parsed.path))
    relative = unquote(joined.path).lstrip("/")
    target = site / relative
    if not parsed.path:
        target = site / unquote(urlsplit(base_url).path).lstrip("/")
        if target.is_dir() or str(base_url).endswith("/"):
            target /= "index.html"
    elif parsed.path.endswith("/"):
        target /= "index.html"
    elif target.is_dir():
        target /= "index.html"
    return target, unquote(parsed.fragment)


def check_links(site: Path) -> list[str]:
    errors: list[str] = []
    page_cache: dict[Path, PageParser] = {}

    def cached_page(path: Path) -> PageParser:
        if path not in page_cache:
            page_cache[path] = parse_page(path)
        return page_cache[path]

    pages = sorted(site.rglob("*.html"))
    for page in pages:
        parser = cached_page(page)
        for attribute, url in parser.references:
            parsed = urlsplit(url)
            if parsed.scheme in {"http", "https", "mailto", "data", "javascript"}:
                continue
            if url.startswith("//"):
                continue
            target, fragment = target_file(site, page, url, parser.base_href)
            if not target.exists():
                errors.append(
                    f"{relative_url(page, site)}: missing {attribute} target {url}"
                )
                continue
            if fragment and target.suffix.lower() == ".html":
                target_parser = cached_page(target)
                if fragment not in target_parser.ids:
                    errors.append(
                        f"{relative_url(page, site)}: missing fragment {url}"
                    )
    return errors


def require(path: Path, errors: list[str]) -> None:
    if not path.exists():
        errors.append(f"missing required artifact: {path}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT / "_site")
    parser.add_argument("--require-blueprint", action="store_true")
    args = parser.parse_args()
    site = args.root.resolve()
    errors: list[str] = []

    required = [
        "index.html",
        "implementation-map/index.html",
        "learning/index.html",
        "library/index.html",
        "roadmap/index.html",
        "workflow/index.html",
        "ide/index.html",
        "ide-data.json",
        "ecosystem/index.html",
        "community/index.html",
        "community/contribution.schema.json",
        "community/translation-response.schema.json",
        "organizers/index.html",
        "attribution/index.html",
        "blueprint/index.html",
        "task-builder/index.html",
        "search-index.json",
        "library/declarations.json",
        "site-metadata.json",
        "build-report.json",
        "static/site.css",
        "static/site.js",
        "static/workspace.js",
        "static/favicon.svg",
    ]
    for item in required:
        require(site / item, errors)
    if args.require_blueprint:
        require(site / "blueprint" / "html-multi" / "index.html", errors)

    if errors:
        print("\n".join(errors))
        return 1

    inventory = json.loads(
        (site / "library" / "declarations.json").read_text(encoding="utf-8")
    )
    search = json.loads((site / "search-index.json").read_text(encoding="utf-8"))
    metadata = json.loads((site / "site-metadata.json").read_text(encoding="utf-8"))
    declaration_count = int(inventory["publicDeclarationCount"])
    if search["declarationEntryCount"] != declaration_count:
        errors.append("search declarationEntryCount differs from inventory")
    declaration_entries = sum(
        entry.get("type") == "declaration" for entry in search["entries"]
    )
    if declaration_entries != declaration_count:
        errors.append("search declaration entries differ from inventory")
    if search["entryCount"] != len(search["entries"]):
        errors.append("search entryCount differs from entries length")
    if metadata["declarationCount"] != declaration_count:
        errors.append("site metadata declarationCount differs from inventory")

    diagrams = sorted((site / "diagrams").glob("*.mmd"))
    if len(diagrams) < 7:
        errors.append(f"expected at least 7 editable diagrams, found {len(diagrams)}")
    unified_pages = [
        site / "index.html",
        site / "implementation-map" / "index.html",
        site / "learning" / "index.html",
        site / "library" / "index.html",
        site / "roadmap" / "index.html",
        site / "workflow" / "index.html",
        site / "ide" / "index.html",
        site / "community" / "index.html",
    ]
    combined = "\n".join(path.read_text(encoding="utf-8") for path in unified_pages)
    for marker in (
        "mathjax@3",
        "mermaid@11",
        'data-theme-choice="blueprint"',
        'data-theme-choice="modern"',
        'data-theme-choice="bold"',
        'name="viewport"',
        'class="site-sidebar"',
        "Quantumlib",
        "ASPBE",
    ):
        if marker not in combined:
            errors.append(f"missing frontend marker: {marker}")
    css = (site / "static" / "site.css").read_text(encoding="utf-8")
    for marker in (
        ':root[data-theme="modern"]',
        ':root[data-theme="bold"]',
        "@media (max-width: 760px)",
        "@media (prefers-reduced-motion: reduce)",
        ".site-sidebar",
        ".workspace-grid",
    ):
        if marker not in css:
            errors.append(f"missing CSS marker: {marker}")
    if re.search(r"(?:file://|/home/|[A-Za-z]:\\\\Users\\\\)", combined):
        errors.append("local filesystem path leaked into unified HTML")

    errors.extend(check_links(site))
    if errors:
        print("Site checks failed:")
        for error in errors:
            print(f"  {error}")
        return 1
    print(
        f"site checks passed: {len(list(site.rglob('*.html')))} HTML pages, "
        f"{declaration_count} declaration search entries, {len(diagrams)} diagrams"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
