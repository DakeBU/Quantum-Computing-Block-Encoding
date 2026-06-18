# LLM4AD_Next Reference Notes

Reference:

- GitHub: <https://github.com/Optima-CityU/LLM4AD_Next>
- Online demo linked by the project: <http://8.163.71.37/>
- Local checkout: `../outer_repos/automation_systems/LLM4AD_Next`

ABEIS uses LLM4AD_Next as a similar pattern for lowering the barrier between a
domain expert and an automated search system.  The useful pattern is:

```text
human problem description
-> interactive task clarification
-> runnable/searchable task configuration
-> automated loop
```

ABEIS adapts this to quantum block encodings:

```text
LaTeX or natural-language oracle description
-> web task packet with report language and operator contract
-> upper/middle/lower/reviewer prompt deck
-> Lean-checked block-encoding certificate
```

Important boundary:

- LLM4AD_Next targets automated algorithm design and empirical evaluation.
- ABEIS targets Lean-checked quantum query-operator/block-encoding
  certificates.
- The ABEIS web page therefore generates a task packet only.  It does not run
  agents, does not certify candidate circuits, and does not replace the Lean
  gate.

Current implementation in ABEIS:

- `web/index.html`
- `web/styles.css`
- `web/app.js`
- `web/README.md`

The page asks for an operator/oracle description, normalizer, block projector,
baseline construction, constraints, and preferred report language.  It emits a
Markdown packet that records the ABEIS resource policy:

1. compare asymptotic tiers first;
2. inside one tier compare `(gateCount, depth, auxiliaryQubits, oracleCalls)`;
3. accept a candidate only after Lean proves unitarity and the block-entry
   theorem.
