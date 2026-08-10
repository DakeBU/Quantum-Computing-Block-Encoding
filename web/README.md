# QuantumComputinglib Task Builder

This is a browser interface for researchers who do not want to start from raw
GitHub commands.  The GitHub Pages workflow publishes it together with the
Verso Lean Blueprint and searchable Lean Library Explorer.  The public web
surface has three roles:

1. build an ASPBE task packet and agent profile from a target-state,
   oracle/operator, or matrix description;
2. render runner outputs such as `dashboard.json`, `evolution.json`,
   certified circuit storyboards, and post-Lean Qiskit/QuantumKatas/QASM
   status;
3. let readers search every explicit public Lean declaration by name, catalog,
   kind, explanation, source note, or bounded Lean preview.

The header links to `library/` for search and to `blueprint/html-multi/`, where
users can browse the Lean
contracts, proof routes, case studies, and exhaustive declaration catalog in
the Blueprint, Modern, or Bold style.  The static task builder itself does not
certify proofs.  Lean remains the verifier.
Model execution either happens in a downloaded local checkout through Codex,
Claude, GLM, Gemini, Minimax, or custom wrappers, or through a user-owned
self-hosted runner/API endpoint.

For an operational local button rather than packet generation alone, build the
unified site and run:

```bash
python3 website/scripts/ide_server.py \
  --directory _site \
  --runner-command "python3 website/scripts/qbe_task_runner.py --execute --cycles 1"
```

Open `http://127.0.0.1:8000/task-builder/` and choose **Run with my API**. The
loopback server passes the key to the selected runner process through the
provider-specific environment variable and does not log or persist it. The
runner writes normal ASPBE task/run artifacts, so this mode should be enabled
only in a checkout where the user intends those writes.

## Deploy As A Normal Website

For GitHub Pages, keep the workflow in `.github/workflows/pages.yml` enabled
and set the repository's Pages source to GitHub Actions.  The deployed URL will
usually have this shape:

```text
https://<github-user>.github.io/<repo-name>/
```

For other static hosts, run `bash scripts/build-all.sh` and publish `_site/`.
The build reuses this task builder, the declaration inventory, and the Verso
Blueprint as inputs to the unified website; do not publish `web/` as a separate
competing documentation root.

## Development Preview

Build `_site/`, set `ASPBE_PREVIEW_USERNAME` and `ASPBE_PREVIEW_PASSWORD` in the
process environment, then run:

```bash
python3 website/scripts/serve_preview.py --root _site --port 8765
```

Open the local URL printed by the server.  This authenticated preview includes
the unified reading site, Library Explorer, Blueprint, and task builder.

The page turns a pasted target-state/operator/oracle description, baseline construction, constraints, preferred report language, and agent backend preferences into a Markdown task packet that can be given to ASPBE agents. It is the web equivalent of `python3 tools/qbe.py ingest-user-problem ...`: the raw user language must remain visible as a source artifact, and the generated packet should be runnable by the same local `sleep-run` harness.

The deployed website should follow the same practical model as low-entry automated-design web front ends: users can prepare a task without installing the repository, but model execution must use a configured backend owned by the user or by the deployment operator. ASPBE should not silently change models between web, CLI, and chat-window modes. To make runs comparable, use the same agent profile, report language, active-time budget, adaptive scaling policy, and Lean gate across all entrypoints.

Progress for a web-created task is inspected in the same artifacts as local
runs: `runs/<run-id>/dialogue.md`, selected-language summary files,
`chatgpt_pro_prompt.md`, `todo.md`, `memory_digest.md`,
`paper-notes/problem-exports/<task-id>/latest.tex`, and optional
`reports/<task-id>/dashboard.json`, `evolution.json`, and
`circuit_storyboard.json` files for the web dashboard.

The scoring policy shown on the page is the repository policy:

1. compare asymptotic tiers first;
2. inside one tier, rank by `(gateCount, depth, auxiliaryQubits, oracleCalls)`;
3. accept correctness only after Lean proves unitarity and the requested
   state-action or block-entry certificates.

Agent backend preferences are vendor-neutral.  The generated profile can map
upper, middle, lower, and reviewer roles to Codex, Claude, GPT/OpenAI wrappers,
Gemini, GLM, Minimax, or local scripts.
