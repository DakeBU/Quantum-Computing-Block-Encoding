#!/usr/bin/env python3
"""Idempotent, explicit integration of the authored research extension.

Used once to perform the reviewed text edits in the remote development runner;
not executed during normal builds, and never writes Lean source or proof reports.
"""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[2]
changes = {}


def contents(name):
    return changes.get(name, (ROOT / name).read_text(encoding="utf-8"))


def insert_after(name, anchor, text, marker):
    old = contents(name)
    if marker in old:
        return
    if old.count(anchor) != 1:
        raise SystemExit(f"integration anchor changed: {name}: {anchor!r}")
    changes[name] = old.replace(anchor, anchor + text, 1)


def append(name, heading, body):
    old = contents(name)
    if heading not in old:
        changes[name] = old.rstrip() + "\n\n" + heading + "\n\n" + body.rstrip() + "\n"


insert_after("AGENTS.md", "## Canonical Harness Protocol\n", "\nThe mandatory quantum-specific publication, source-blind review, graph and\nreader gate is [docs/theorem-publication-protocol.md](docs/theorem-publication-protocol.md).\nRead it before changing a production Lean module or publishing a new source claim.\nUse the bounded mechanism/route packet rather than dumping the complete graph.\n", "The mandatory quantum-specific publication")
append("AGENTS.md", "## Mathematical structure and research routes", """The canonical authored records are `website/research/atlas.json`,
`website/research/state-preparation-wiki.json` and `website/research/sources.json`.
Current Progress is generated from these and the existing textbook/implementation
records. Do not create a competing completion ledger.

Before choosing a construction, run:

```bash
python3 website/scripts/research_atlas.py context --route spw-envelope
python3 website/scripts/research_atlas.py context --query \"polynomial rank norm\"
```

Every changed production module requires a current publication record binding
its entire source, toolchain/manifest, source statement, lesson, assumptions,
source-blind decoder and distinct independent reviewer, and graph delta.
Unchanged historical audit debt is not retroactively cleared. The mechanical
admission checker is `website/scripts/check_research_publications.py --base BASE`.

Keep actual Lean imports/ownership distinct from conceptual transports. Retain
complete AND tails and explicit failure maps. A contribution may be add-node,
shortcut, reorganisation or bridge; this is not an automatic novelty judgement.
Preserve SP/BE directionality and charge SELECT, input preparation, postselection
and amplification as appropriate. Read the full protocol for aesthetic,
finite-bit, source-fidelity and independent-review requirements.
""")
append("HARNESS.md", "## Publication and mathematical mechanism extension", """The operational protocol now also includes
[the theorem-publication and graph contract](docs/theorem-publication-protocol.md).
It refines, rather than replaces, the Master–Worker source/semantic/Lean/
integration/exposition gates. Reuse the bounded packet from
`website/scripts/research_atlas.py context`; keep whole-module independent
encoder–denoiser evidence in the admission registry and a typed graph delta in
the same contribution packet. A conceptual hyperedge is not a Lean implication.
No existing module is newly source-reviewed merely by this protocol's adoption.
""")
append("CONTRIBUTING.md", "## Source-faithful lessons and graph contributions", """Read [the ASPBE publication protocol](docs/theorem-publication-protocol.md) and
[the contributor packet](.agents/prompts/mathematical-contribution.md).
New or changed production modules need exact source/lesson bindings, assumption
comparisons, source-blind reconstruction, independent anti-anchored review, and
add-node/shortcut/reorganisation/bridge metadata. Local proof, full source-route
closure and experimental evidence must be kept separate. StatePreparationWiki
routes and Current Progress are generated from the canonical records, not from
manual percentages. Mobile/desktop, MathJax, theme, graph-label, source-link and
AND-tail checks are part of publication, not optional visual polish.
""")
append(".github/PULL_REQUEST_TEMPLATE.md", "## Publication / structure gate", """- [ ] Source version/anchor, full mathematical statement/proof and exact Lean disclosure are bound once.
- [ ] Changed production modules have current whole-module publication packets, or this change adds no production Lean claim.
- [ ] Decoder is source-blind; reviewer is distinct and anti-anchored; no independent review is invented.
- [ ] Assumption differences, register/phase/oracle/ancilla/error/resource contracts and residuals are explicit.
- [ ] Graph delta has a pinned baseline and add-node/shortcut/reorganisation/bridge roles; conceptual tails remain AND.
- [ ] Research targets and unavailable sources are not promoted to achieved bounds or novelty claims.
- [ ] Final site, links, MathJax, mobile/desktop, themes and graph interactions pass the declared checks.

Publication record / source-blind evidence / graph delta / exact CI commit:
""")
for name in (".agents/skills/qbe-math-writing/SKILL.md", ".agents/skills/qbe-proof-export/SKILL.md"):
    append(name, "## Required publication refinement", """Read `docs/theorem-publication-protocol.md`. Author mathematics once; show
separate folded exact Lean statement/proof; bind the full changed module and
ambient/toolchain context to independent source-blind reconstruction and review.
Reuse exact graph identities and retain assumption/failure maps. A passing Lean
substrate does not promote a conceptual family or downstream research target.
""")
sh_check = """
# Research views and publication packets use the same source-of-truth inventory.
python3 website/scripts/research_atlas.py check
python3 -m unittest website.scripts.test_research_atlas
publication_base="${ASPBE_PUBLICATION_BASE:-origin/main}"
if [[ "${CI:-}" == "true" && "${GITHUB_REF:-}" == "refs/heads/main" ]]; then
  publication_base="HEAD^1"
fi
python3 website/scripts/check_research_publications.py --base "$publication_base"
"""
insert_after("scripts/build-website.sh", "python3 scripts/generate-aspbe-catalog.py --check\n", sh_check, "# Research views and publication packets")
insert_after("scripts/build-website.sh", "python3 website/scripts/enrich_hermite_insight.py --root _out/site\n", "python3 website/scripts/research_atlas.py publish --root _out/site\n", "research_atlas.py publish")
insert_after("scripts/build-website.sh", "python3 website/scripts/check_site.py --root _site --require-blueprint\n", """python3 website/scripts/research_atlas.py check-site --root _site
if [[ "${CI:-}" == "true" ]]; then
  python3 -m pip install --quiet playwright
  python3 -m playwright install --with-deps chromium
  python3 website/scripts/test_research_browser.py --root _site
  cp _out/research-browser/browser-report.json _site/data/research/browser-report.json
fi
""", "test_research_browser.py --root")
ps_check = """
# Research views and publication packets use the same source-of-truth inventory.
& $PythonCommand website/scripts/research_atlas.py check
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand -m unittest website.scripts.test_research_atlas
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
$publicationBase = if ($env:ASPBE_PUBLICATION_BASE) { $env:ASPBE_PUBLICATION_BASE } else { "origin/main" }
if ($env:CI -eq "true" -and $env:GITHUB_REF -eq "refs/heads/main") { $publicationBase = "HEAD^1" }
& $PythonCommand website/scripts/check_research_publications.py --base $publicationBase
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
"""
insert_after("scripts/build-website.ps1", "& $PythonCommand scripts/generate-aspbe-catalog.py --check\nif ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }\n", ps_check, "# Research views and publication packets")
insert_after("scripts/build-website.ps1", "& $PythonCommand website/scripts/repair_taxonomy_links.py --root _out/site\nif ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }\n", """& $PythonCommand website/scripts/enrich_hermite_insight.py --root _out/site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand website/scripts/research_atlas.py publish --root _out/site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
""", "research_atlas.py publish")
insert_after("scripts/build-website.ps1", "& $PythonCommand website/scripts/check_site.py --root _site --require-blueprint\nif ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }\n", """& $PythonCommand website/scripts/research_atlas.py check-site --root _site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ($env:CI -eq "true") {
  & $PythonCommand -m pip install --quiet playwright
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $PythonCommand -m playwright install chromium
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $PythonCommand website/scripts/test_research_browser.py --root _site
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  Copy-Item _out/research-browser/browser-report.json _site/data/research/browser-report.json
}
""", "test_research_browser.py --root")
contract_name = "website/lean-graph-contract.json"
contract = json.loads(contents(contract_name))
contract["curatedResearchViews"] = {"source": "website/research/atlas.json", "publisher": "website/scripts/research_atlas.py", "views": ["mathematical-methods/", "functor-hypergraph/", "state-preparation-wiki/", "progress/"], "identityPolicy": "exact generated module/declaration ids reused by curated concept/family/transport ids", "hyperedgeSemantics": "all tails required together; conceptual incidence, not separate Lean implication", "contributionClasses": ["add-node", "shortcut", "reorganisation", "bridge"], "claimBoundary": "curated proposals with explicit hypothesis/conclusion/failure maps; no certified categorical functor, elaborated theorem dependency, automatic quotient or novelty judgement"}
changes[contract_name] = json.dumps(contract, ensure_ascii=False, indent=2) + "\n"
for name, text in changes.items():
    (ROOT / name).write_text(text, encoding="utf-8")
    print(name)
print(f"Integrated {len(changes)} source files; no Lean source or proof report changed.")
