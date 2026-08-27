#!/usr/bin/env python3
"""Add the previous/current comic Harness comparison to the built workflow page."""

from __future__ import annotations

import argparse
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OLD_COMIC = ROOT / "docs" / "assets" / "ASPBE.png"
CURRENT_COMIC = ROOT / "docs" / "assets" / "aspbe_current_harness.webp"


NEW_LEDE = (
    "Both generations keep a frozen mathematical contract and hard verification. "
    "The previous Harness routed work through fixed strategist / Lean-tree / worker / "
    "reviewer layers; the current Harness keeps the proof DAG but lets generalist "
    "Workers own substantive frontier advances end to end under a Frontier Master."
)

COMPARISON = """
<section class="content-section" id="harness-evolution">
  <div class="section-heading">
    <p class="eyebrow">Previous → current</p>
    <h2>Same proof discipline, less cognitive role confinement</h2>
    <p>The old hierarchy made handoffs explicit. The current system keeps the hard
    gates and durable theorem graph, but parallel Workers may cross source, math,
    Lean, diagnostics, and exposition whenever that moves the root theorem.</p>
  </div>
  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(360px,1fr));gap:1.35rem;align-items:start;">
    <article class="case-card">
      <p class="eyebrow">Previous Harness</p>
      <h3>Layered roles</h3>
      <img src="../static/ASPBE.png" alt="Previous ASPBE hierarchical Harness comic" style="display:block;width:100%;height:auto;border-radius:18px;">
      <p><strong>Upper strategist → Middle Lean-tree manager → focused workers → reviewer.</strong></p>
    </article>
    <article class="case-card">
      <p class="eyebrow">Current Harness</p>
      <h3>Proof-frontier search</h3>
      <img src="../static/aspbe_current_harness.webp" alt="Current ASPBE Frontier Master and generalist Workers comic" style="display:block;width:100%;height:auto;border-radius:18px;">
      <p><strong>Frontier Master → parallel generalist Workers → hard proof gates → certified outputs.</strong></p>
    </article>
  </div>
</section>
""".strip()


def enrich(root: Path) -> None:
    page = root / "workflow" / "index.html"
    if not page.is_file():
        raise RuntimeError(f"workflow page is missing: {page}")
    if not OLD_COMIC.is_file() or not CURRENT_COMIC.is_file():
        raise RuntimeError("Harness comparison assets are missing")

    static = root / "static"
    static.mkdir(parents=True, exist_ok=True)
    shutil.copy2(OLD_COMIC, static / OLD_COMIC.name)
    shutil.copy2(CURRENT_COMIC, static / CURRENT_COMIC.name)

    text = page.read_text(encoding="utf-8")
    hero = '<h1>Search, prove, validate, and retain evidence</h1>'
    if hero not in text:
        raise RuntimeError("workflow hero marker changed")

    text, count = re.subn(
        r'(<h1>Search, prove, validate, and retain evidence</h1>\s*)<p class="lede">.*?</p>',
        lambda match: match.group(1) + f'<p class="lede">{NEW_LEDE}</p>',
        text,
        count=1,
        flags=re.S,
    )
    if count != 1:
        raise RuntimeError("workflow lede replacement did not match exactly once")

    if 'id="harness-evolution"' not in text:
        hero_pos = text.index(hero)
        hero_end = text.index("</section>", hero_pos) + len("</section>")
        text = text[:hero_end] + "\n" + COMPARISON + text[hero_end:]

    page.write_text(text, encoding="utf-8", newline="\n")
    print(f"enriched {page} with previous/current Harness comics")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    enrich(args.root)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
