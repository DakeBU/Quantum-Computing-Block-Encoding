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

The page turns a pasted operator/oracle description, baseline construction,
constraints, preferred report language, and agent backend preferences into a
Markdown task packet that can be given to ABEIS agents.

The scoring policy shown on the page is the repository policy:

1. compare asymptotic tiers first;
2. inside one tier, rank by `(gateCount, depth, auxiliaryQubits, oracleCalls)`;
3. accept correctness only after Lean proves the unitarity and block-entry
   certificates.

Agent backend preferences are vendor-neutral.  The generated profile can map
upper, middle, lower, and reviewer roles to Codex, Claude, GPT/OpenAI wrappers,
Gemini, GLM, Minimax, or local scripts.
