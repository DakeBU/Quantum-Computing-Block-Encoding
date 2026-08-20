#!/usr/bin/env python3
"""Apply the integrated Lean-graph, Robin-math, and Pages patch once.

This file is intentionally temporary.  It exists because the main site builder
is large, while the actual changes are small anchored edits plus generated
static assets already committed beside it.
"""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def write(path: str, text: str) -> None:
    (ROOT / path).write_text(text, encoding="utf-8", newline="\n")


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected one anchor, found {count}")
    return text.replace(old, new, 1)


def patch_build_site() -> None:
    path = "website/scripts/build_site.py"
    text = read(path)

    text = replace_once(
        text,
        "from case_assets import STAGE_CIRCUITS, stage_circuit_latex  # noqa: E402\n",
        "from case_assets import STAGE_CIRCUITS, stage_circuit_latex  # noqa: E402\n"
        "from lean_graph import build_lean_graph_payload, render_lean_graph_body  # noqa: E402\n",
        "lean graph import",
    )
    text = replace_once(
        text,
        '    ("Lean library", "library/"),\n    ("Implementation map", "implementation-map/"),\n',
        '    ("Lean library", "library/"),\n'
        '    ("Underlying Lean Graph of Libraries", "lean-graph/"),\n'
        '    ("Implementation map", "implementation-map/"),\n',
        "sidebar graph navigation",
    )
    text = replace_once(
        text,
        "    extra_scripts: tuple[str, ...] = (),\n) -> str:\n",
        "    extra_scripts: tuple[str, ...] = (),\n"
        "    extra_styles: tuple[str, ...] = (),\n"
        ") -> str:\n",
        "page template style argument",
    )
    text = replace_once(
        text,
        "    extra_script_html = \"\".join(\n"
        "        f'<script src=\"{prefix}{html.escape(path)}\"></script>' for path in extra_scripts\n"
        "    )\n"
        "    return f\"\"\"<!doctype html>\n",
        "    extra_script_html = \"\".join(\n"
        "        f'<script src=\"{prefix}{html.escape(path)}\"></script>' for path in extra_scripts\n"
        "    )\n"
        "    extra_style_html = \"\".join(\n"
        "        f'<link rel=\"stylesheet\" href=\"{prefix}{html.escape(path)}\">'\n"
        "        for path in extra_styles\n"
        "    )\n"
        "    return f\"\"\"<!doctype html>\n",
        "page template style rendering",
    )
    text = replace_once(
        text,
        '  <link rel="stylesheet" href="{prefix}static/site.css">\n',
        '  <link rel="stylesheet" href="{prefix}static/site.css">\n  {extra_style_html}\n',
        "page head extra stylesheet",
    )

    graph_renderer = '''\n\ndef render_lean_graph(\n    payload: dict[str, object],\n    coverage: dict[str, object],\n    gate: dict[str, object],\n    context: dict[str, object],\n) -> str:\n    route = "lean-graph/"\n    return page_template(\n        title="Underlying Lean Graph of Libraries",\n        route=route,\n        current=route,\n        body=render_lean_graph_body(payload),\n        coverage=coverage,\n        gate=gate,\n        context=context,\n        toc=[\n            ("graph-purpose", "Purpose"),\n            ("graph-methodology", "Methodology"),\n            ("interactive-graph", "Interactive graph"),\n            ("graph-compression", "Proof-graph compression"),\n        ],\n        description=(\n            "Interactive QuantumComputinglib Lean module and declaration graph, "\n            "with textbook, paper, example-case, and proof-compression context."\n        ),\n        extra_scripts=("static/lean-graph.js",),\n        extra_styles=("static/lean-graph.css",),\n    )\n'''
    text = replace_once(
        text,
        "\ndef render_ide(\n",
        graph_renderer + "\n\ndef render_ide(\n",
        "Lean graph renderer insertion",
    )

    text = replace_once(
        text,
        '        ("Lean Library Explorer", "Search the complete public declaration inventory", "library/index.html"),\n',
        '        ("Lean Library Explorer", "Search the complete public declaration inventory", "library/index.html"),\n'
        '        ("Underlying Lean Graph of Libraries", "Explore generated Lean import topology and declaration branches", "lean-graph/index.html"),\n',
        "search index graph entry",
    )

    text = replace_once(
        text,
        "    EXAMPLE_CASE_NAV = [\n"
        "        (str(case[\"shortTitle\"]), str(case[\"slug\"])) for case in example_cases\n"
        "    ]\n\n"
        "    output: Path = args.output\n",
        "    EXAMPLE_CASE_NAV = [\n"
        "        (str(case[\"shortTitle\"]), str(case[\"slug\"])) for case in example_cases\n"
        "    ]\n"
        "    lean_graph_payload = build_lean_graph_payload(\n"
        "        ROOT, declarations, CHAPTERS, example_cases\n"
        "    )\n\n"
        "    output: Path = args.output\n",
        "Lean graph payload build",
    )
    text = replace_once(
        text,
        "    data = output / \"data\"\n"
        "    data.mkdir(parents=True, exist_ok=True)\n"
        "    (data / \"public-case-replay.json\").write_text(\n",
        "    data = output / \"data\"\n"
        "    data.mkdir(parents=True, exist_ok=True)\n"
        "    (data / \"lean-graph.json\").write_text(\n"
        "        json.dumps(lean_graph_payload, ensure_ascii=False, indent=2) + \"\\n\",\n"
        "        encoding=\"utf-8\",\n"
        "    )\n"
        "    (data / \"public-case-replay.json\").write_text(\n",
        "Lean graph data output",
    )
    text = replace_once(
        text,
        '    write_page(output, "library", render_library(inventory, coverage, gate, context))\n',
        '    write_page(output, "library", render_library(inventory, coverage, gate, context))\n'
        '    write_page(\n'
        '        output, "lean-graph",\n'
        '        render_lean_graph(lean_graph_payload, coverage, gate, context),\n'
        '    )\n',
        "Lean graph page output",
    )
    text = replace_once(
        text,
        '        "diagramCount": len(list((WEBSITE_ROOT / "diagrams").glob("*.mmd"))),\n'
        '        "modulePageCount": len(by_source),\n',
        '        "diagramCount": len(list((WEBSITE_ROOT / "diagrams").glob("*.mmd"))),\n'
        '        "leanGraphModuleCount": lean_graph_payload["stats"]["moduleCount"],\n'
        '        "leanGraphDeclarationCount": lean_graph_payload["stats"]["declarationCount"],\n'
        '        "leanGraphImportEdgeCount": lean_graph_payload["stats"]["importEdgeCount"],\n'
        '        "modulePageCount": len(by_source),\n',
        "Lean graph build metadata",
    )

    prose_replacements = {
        "fixed (N=8) benchmark": r"fixed \(N=8\) benchmark",
        "fixed (N=8),": r"fixed \(N=8\),",
        "(M=12A) integral": r"\(M=12A\) integral",
        "rows and columns of (A).": r"rows and columns of \(A\).",
        "homogeneous <code>f=1</code>": r"homogeneous \(f=1\)",
    }
    for old, new in prose_replacements.items():
        if old not in text:
            raise RuntimeError(f"Robin prose anchor missing: {old}")
        text = text.replace(old, new)

    write(path, text)


def patch_robin_math_data() -> None:
    path = ROOT / "website" / "case-teaching.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    robin = data["cases"]["robin-ghl-one-term"]
    theorem3 = next(
        item for item in robin["theorems"] if "Theorem 3" in item["label"]
    )
    theorem4 = next(
        item for item in robin["theorems"] if "Theorem 4" in item["label"]
    )

    theorem3["statementProse"] = theorem3["statementProse"].replace(
        "a 2^n by 2^n kappa-sparse",
        r"a \(2^n\times 2^n\) \(\kappa\)-sparse",
    )
    theorem3["statementProse"] = theorem3["statementProse"].replace(
        "with 2n pure ancillas", r"with \(2n\) pure ancillas"
    )
    theorem3["formalizationScope"] = theorem3["formalizationScope"].replace(
        "N=8", r"\(N=8\)"
    )
    for step in theorem3["proofSteps"]:
        step[1] = step[1].replace(
            "A_k/(N_D N_f kappa)",
            r"\(A_k/(\mathcal N_D\mathcal N_f\kappa)\)",
        )
        step[1] = step[1].replace("2^n", r"\(2^n\)")

    theorem4["statementProse"] = theorem4["statementProse"].replace(
        "O(kappa ||H||_max)", r"\(O(\kappa\lVert H\rVert_{\max})\)"
    )
    theorem4["statementProse"] = theorem4["statementProse"].replace(
        "2n+2", r"\(2n+2\)"
    )
    theorem4["formalizationScope"] = theorem4["formalizationScope"].replace(
        "N=8", r"\(N=8\)"
    )

    # Catch the two exact regressions reported by the public page without
    # rewriting canonical statementFormula fields, which already contain TeX.
    def fix_prose(value: object, key: str = "") -> object:
        if isinstance(value, dict):
            return {name: fix_prose(item, name) for name, item in value.items()}
        if isinstance(value, list):
            return [fix_prose(item, key) for item in value]
        if not isinstance(value, str) or "Formula" in key or key.endswith("latex"):
            return value
        value = value.replace(
            "A_k/(N_D N_f kappa)",
            r"\(A_k/(\mathcal N_D\mathcal N_f\kappa)\)",
        )
        value = value.replace("N=2^n", r"\(N=2^n\)")
        return value

    data["cases"]["robin-ghl-one-term"] = fix_prose(robin)
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def patch_build_script() -> None:
    path = "scripts/build-website.sh"
    text = read(path)
    text = replace_once(
        text,
        "  website/scripts/build_site.py \\\n  website/scripts/enrich_teaching_site.py \\\n",
        "  website/scripts/build_site.py \\\n  website/scripts/lean_graph.py \\\n  website/scripts/enrich_teaching_site.py \\\n",
        "build script lean graph compile",
    )
    text = replace_once(
        text,
        "test -f _site/.nojekyll\n\necho \"QuantumComputinglib assembled at _site/index.html\"\n",
        "test -f _site/lean-graph/index.html\n"
        "test -f _site/data/lean-graph.json\n"
        "test -f _site/static/lean-graph.js\n"
        "test -f _site/static/lean-graph.css\n"
        "grep -q 'Underlying Lean Graph of Libraries' _site/lean-graph/index.html\n"
        "grep -q 'Underlying Lean Graph of Libraries' _site/case-studies/robin/index.html\n"
        "grep -Fq '\\(N=8\\)' _site/case-studies/robin/index.html\n"
        "grep -Fq '\\(A_k/(\\mathcal N_D\\mathcal N_f\\kappa)\\)' _site/case-studies/robin/index.html\n"
        "! grep -Fq 'A_k/(N_D N_f kappa)' _site/case-studies/robin/index.html\n"
        "test -f _site/.nojekyll\n\n"
        "echo \"QuantumComputinglib assembled at _site/index.html\"\n",
        "build script graph and math contract",
    )
    write(path, text)


def patch_pages_workflow() -> None:
    path = ".github/workflows/pages.yml"
    text = read(path)
    text = replace_once(
        text,
        "            website/scripts/build_site.py \\\n            website/scripts/enrich_teaching_site.py \\\n",
        "            website/scripts/build_site.py \\\n            website/scripts/lean_graph.py \\\n            website/scripts/enrich_teaching_site.py \\\n",
        "Pages lean graph syntax check",
    )
    text = replace_once(
        text,
        "            website/scripts/enforce_robin_reader_contract.py \\\n            website/scripts/polish_casebook.py \\\n",
        "            website/scripts/enforce_robin_reader_contract.py \\\n            website/scripts/publish_extensions.py \\\n            website/scripts/publish_paper_pages.py \\\n            website/scripts/publish_taxonomy.py \\\n            website/scripts/polish_casebook.py \\\n",
        "Pages extension syntax checks",
    )
    text = replace_once(
        text,
        "          python3 website/scripts/enforce_robin_reader_contract.py --root _out/site\n"
        "          rm -rf _site\n",
        "          python3 website/scripts/enforce_robin_reader_contract.py --root _out/site\n"
        "          python3 website/scripts/publish_extensions.py --root _out/site\n"
        "          python3 website/scripts/publish_paper_pages.py --root _out/site\n"
        "          python3 website/scripts/publish_taxonomy.py --root _out/site\n"
        "          rm -rf _site\n",
        "Pages publish full taxonomy",
    )
    text = replace_once(
        text,
        "          ! grep -q '<h2>Source interpretation decisions</h2>' _site/example-cases/robin-ghl-one-term/index.html\n"
        "          test -f _site/.nojekyll\n",
        "          ! grep -q '<h2>Source interpretation decisions</h2>' _site/example-cases/robin-ghl-one-term/index.html\n"
        "          test -f _site/lean-graph/index.html\n"
        "          test -f _site/data/lean-graph.json\n"
        "          test -f _site/static/lean-graph.js\n"
        "          test -f _site/static/lean-graph.css\n"
        "          grep -q 'Underlying Lean Graph of Libraries' _site/lean-graph/index.html\n"
        "          grep -q 'Underlying Lean Graph of Libraries' _site/case-studies/robin/index.html\n"
        "          grep -Fq '\\(N=8\\)' _site/case-studies/robin/index.html\n"
        "          grep -Fq '\\(A_k/(\\mathcal N_D\\mathcal N_f\\kappa)\\)' _site/case-studies/robin/index.html\n"
        "          ! grep -Fq 'A_k/(N_D N_f kappa)' _site/case-studies/robin/index.html\n"
        "          test -f _site/.nojekyll\n",
        "Pages graph and Robin math verification",
    )
    text = replace_once(
        text,
        "          test -f _site/library/index.html\n"
        "          test -f _site/ide/index.html\n",
        "          test -f _site/library/index.html\n"
        "          test -f _site/lean-graph/index.html\n"
        "          test -f _site/data/lean-graph.json\n"
        "          test -f _site/ide/index.html\n",
        "Pages artifact report graph entries",
    )
    write(path, text)


def main() -> None:
    patch_build_site()
    patch_robin_math_data()
    patch_build_script()
    patch_pages_workflow()
    print("applied Lean graph, Robin MathJax, and Pages integration patch")


if __name__ == "__main__":
    main()
