# Quantumlib website

Quantumlib is the textbook and browsing surface for **ASPBE: Automatic State
Preparation and Block Encoding for Quantum Computing**. It is generated from
the repository's current Lean inventory; it is not a second theorem database.

## Information architecture

The desktop layout uses a persistent book navigation on the left. Mobile
readers receive the same navigation as a drawer. Stable existing URLs are
preserved, including `library/`, `blueprint/html-multi/`, and `task-builder/`.

| Route | Purpose |
| --- | --- |
| `/` | Quantumlib overview and the two ASPBE contracts |
| `/learning/` | Book map and reading order |
| `/chapters/<slug>/` | Formula, natural-language reading, proof idea, Lean statement, and source |
| `/library/` | Exhaustive generated ASPBE declaration inventory |
| `/implementation-map/` | Mathematical goal → declaration → source → status → missing work |
| `/ecosystem/` | Honest atlas of local, imported, and reference-only quantum Lean libraries |
| `/ide/` | LaTeX/Lean workspace and local compiler client |
| `/community/` | Contribution guide and packet contract |
| `/organizers/` | Current authors and contributor-credit policy |
| `/blueprint/html-multi/` | Existing Verso Blueprint |

State Preparation and Block Encoding remain separate teaching tracks and have
different acceptance predicates. A prepared state may become a dependency of
a later block-encoding construction, but this does not merge their certificates.

## Generated inputs

- `QuantumBlockEncoding/**/*.lean`: authoritative declarations.
- `web/library/declarations.json`: generated declaration inventory.
- `docs/blueprint-coverage.json`: generated coverage and exclusion audit.
- `website/content.py`: reviewed chapter order, explanations, and route status.
- `website/diagrams/*.mmd`: editable diagrams.
- `website/community/contribution.schema.json`: contributor handoff contract.

All declaration counts, statuses, source lines, module pages, and search entries
are generated. The site builder fails when reviewed content names a declaration
that is absent from the inventory.

## Live formalization workspace

The static site supports formula rendering, reviewed LaTeX↔Lean mappings,
dependency navigation, Lean editing, packet export, and a prefilled GitHub
submission request. GitHub Pages does **not** execute Lean.

After building `_site`, start the loopback-only companion server:

```bash
python3 website/scripts/ide_server.py --directory _site
```

Open `http://127.0.0.1:8000/ide/`. The server invokes
`lake env lean` on temporary files, serializes compiler requests, applies size
and time limits, removes temporary snippets, and never writes project source.
Do not expose this compiler endpoint through a public tunnel.

An optional local AI translator can be connected without baking a provider or
credential into Quantumlib:

```bash
python3 website/scripts/ide_server.py \
  --directory _site \
  --translator-command "python3 website/scripts/codex_translator.py"
```

The adapter uses the locally authenticated Codex CLI in an ephemeral,
read-only session. It follows the current Codex configuration by default. Set
`ASPBE_CODEX_MODEL` only when a particular available model is required; no
model name or credential is stored in the website.

The adapter reads one JSON request on stdin and returns JSON with string fields
`code` and `plain`. Its output is labeled **agent draft**. It must still compile
and receive mathematical review. Without an adapter, the workspace offers an
explicit `True` scaffold that is labeled as a placeholder, never as a semantic
translation.

## Contribution boundary

The browser exports one versioned lemma packet containing:

- plain-language and LaTeX statements;
- imports, Lean code, proposed name, and dependencies;
- source provenance and contributor credit;
- compiler diagnostics tied to the exact editor text;
- license consent state.

The GitHub button opens a review request; it does not write to the repository or
mark a result integrated. Only maintainers assign `integrated` after the exact
declaration enters the inventory and passes the full ASPBE gate.

## Build

Linux/macOS:

```bash
bash scripts/build-all.sh
```

Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-all.ps1
```

Website-only assembly requires a current `_out/lean-gate.json` and Blueprint:

```bash
bash scripts/build-website.sh
```

The final artifact is `_site/`. `website/scripts/check_site.py` checks required
routes, search counts, internal links, fragments, MathJax/Mermaid markers,
responsive/theme markers, and local-path leakage. Source links use a commit SHA
only when that source exists at a published ref and is clean in the checkout.

For a password-protected static preview, use `serve_preview.py`; credentials
come only from `ASPBE_PREVIEW_USERNAME` and `ASPBE_PREVIEW_PASSWORD` (the old
`ABEIS_PREVIEW_*` names remain accepted for compatibility). A
TryCloudflare URL is temporary preview infrastructure, not production hosting.
