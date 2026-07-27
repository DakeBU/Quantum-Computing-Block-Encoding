#!/usr/bin/env python3
"""Materialize Verso's page-level logical fragments as real HTML anchors."""

from __future__ import annotations

import argparse
import html
import re
from collections import defaultdict
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit


ROOT = Path(__file__).resolve().parents[2]


class Parser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.base_href: str | None = None
        self.ids: set[str] = set()
        self.links: list[str] = []

    def handle_starttag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        values = dict(attrs)
        if tag == "base" and values.get("href") and self.base_href is None:
            self.base_href = values["href"]
        identifier = values.get("id") or values.get("name")
        if identifier:
            self.ids.add(identifier)
        if tag == "a" and values.get("href"):
            self.links.append(values["href"])


def parse(path: Path) -> Parser:
    parser = Parser()
    parser.feed(path.read_text(encoding="utf-8", errors="replace"))
    return parser


def resolve(
    root: Path, current: Path, base_href: str | None, raw_url: str
) -> tuple[Path, str] | None:
    parsed = urlsplit(raw_url)
    if parsed.scheme or raw_url.startswith("//") or not parsed.fragment:
        return None
    current_url = current.relative_to(root).as_posix()
    base_url = urljoin(current_url, base_href) if base_href else current_url
    resolved = urlsplit(urljoin(base_url, parsed.path))
    target = root / unquote(resolved.path).lstrip("/")
    if not parsed.path:
        target = root / unquote(urlsplit(base_url).path).lstrip("/")
    if target.is_dir() or parsed.path.endswith("/") or str(base_url).endswith("/"):
        target /= "index.html"
    try:
        target.resolve().relative_to(root.resolve())
    except ValueError:
        return None
    if target.suffix.lower() != ".html" or not target.exists():
        return None
    return target, unquote(parsed.fragment)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "root",
        nargs="?",
        type=Path,
        default=ROOT / "_out" / "blueprint" / "html-multi",
    )
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    root = args.root.resolve()
    pages = sorted(root.rglob("*.html"))
    parsed = {page: parse(page) for page in pages}
    missing: dict[Path, set[str]] = defaultdict(set)
    for page, document in parsed.items():
        for link in document.links:
            target = resolve(root, page, document.base_href, link)
            if target is None:
                continue
            target_page, fragment = target
            if fragment not in parsed[target_page].ids:
                missing[target_page].add(fragment)

    count = sum(len(fragments) for fragments in missing.values())
    if args.check:
        if count:
            print(f"Blueprint has {count} logical fragments without DOM anchors.")
            return 1
        print(f"Blueprint fragment anchors checked across {len(pages)} pages.")
        return 0

    for page, fragments in missing.items():
        text = page.read_text(encoding="utf-8")
        anchors = "".join(
            f'<span id="{html.escape(fragment, quote=True)}" hidden></span>'
            for fragment in sorted(fragments)
        )
        body = re.search(r"<body(?:\s[^>]*)?>", text, flags=re.I)
        if not body:
            raise SystemExit(f"Blueprint page has no body element: {page}")
        text = text[: body.end()] + anchors + text[body.end() :]
        page.write_text(text, encoding="utf-8", newline="\n")
    print(
        f"Materialized {count} Verso logical fragment anchors across "
        f"{len(missing)} pages."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

