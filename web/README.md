# ABEIS Web Task Builder

This is a static website for researchers who do not want to start from GitHub
commands.  It can be deployed by GitHub Pages, Cloudflare Pages, Netlify, or
any static-file host.  The page runs entirely in the browser: it generates an
ABEIS Markdown task packet and optional agent-profile JSON, but it does not
call model APIs and does not certify proofs.

## Deploy As A Normal Website

For GitHub Pages, keep the workflow in `.github/workflows/pages.yml` enabled
and set the repository's Pages source to GitHub Actions.  The deployed URL will
usually have this shape:

```text
https://<github-user>.github.io/<repo-name>/
```

For other static hosts, publish the contents of this `web/` directory.

## Development Preview

```bash
cd /path/to/Auto-Quantum-Computing-Bloack-Encoding-In-Sleep
python3 -m http.server 8080 -d web
```

Open the URL printed by the development server only while editing the page.
The intended user-facing entry is the deployed static website.

The page turns a pasted operator/oracle description, baseline construction, constraints, preferred report language, and agent backend preferences into a Markdown task packet that can be given to ABEIS agents.  It is the web equivalent of `python3 tools/qbe.py ingest-user-problem ...`: the raw user language must remain visible as a source artifact, and the generated packet should be runnable by the same local `sleep-run` harness.

The deployed website should follow the same practical model as low-entry automated-design web front ends: users can prepare a task without installing the repository, but model execution must use a configured backend owned by the user or by the deployment operator.  ABEIS should not silently change models between web, CLI, and chat-window modes.  To make runs comparable, use the same agent profile, report language, active-time budget, adaptive scaling policy, and Lean gate across all entrypoints.

Progress for a web-created task is inspected in the same artifacts as local runs: `runs/<run-id>/dialogue.md`, selected-language summary files, `chatgpt_pro_prompt.md`, `todo.md`, `memory_digest.md`, and `paper-notes/problem-exports/<task-id>/latest.tex`.

The scoring policy shown on the page is the repository policy:

1. compare asymptotic tiers first;
2. inside one tier, rank by `(gateCount, depth, auxiliaryQubits, oracleCalls)`;
3. accept correctness only after Lean proves the unitarity and block-entry
   certificates.

Agent backend preferences are vendor-neutral.  The generated profile can map
upper, middle, lower, and reviewer roles to Codex, Claude, GPT/OpenAI wrappers,
Gemini, GLM, Minimax, or local scripts.
