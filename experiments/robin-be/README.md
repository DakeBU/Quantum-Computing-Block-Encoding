# Robin block-encoding evolution benchmark

This experiment compares two isolated ASPBE runs against one frozen finite
Robin-boundary operator contract.

- `cold`: receives the operator entries and acceptance contract, but not the
  paper construction or any Robin-specific proof memory.
- `warm`: receives the same contract plus the source construction and the
  compiled Robin memory cards, including the counterexample that rejects the
  historical H-free raw-fold route.

The two arms use the same normalizer, projector, register order, Lean gate,
Qiskit acceptance checks, and score order.  A result is not an improvement when
it changes semantic tier or replaces an expanded circuit with an unresolved
oracle call.

Run both arms from isolated worktrees:

```bash
python3 tools/run_robin_repro.py prepare
python3 tools/run_robin_repro.py run --arm cold
python3 tools/run_robin_repro.py run --arm warm
python3 tools/run_robin_repro.py audit
```

The task builder exposes the same two presets.  Its local API runner creates
the corresponding task packet; users supply their own agent profile and API
credentials.  GitHub Pages itself never executes a model or Lean.

Generated run data belongs under `experiments/robin-be/results/`.  Figures and
paper tables must be generated from the audited summary there.  An empty or
non-certified population is a reported outcome, not a plotting error.

The current outcome is therefore presented as a source-faithful formalization
baseline. `website/robin-paper-map.json` maps the paper's LaTeX statements to
the compiled `GHL2025.lean` and `RobinMatrix.lean` structures and labels the
paper-wide route separately. The generated website page is
`/case-studies/robin/`.

## Discarded pilot runs

The 2026-08-12 pilot was not used as result evidence.  Its first cold attempt
performed a repository-wide lookup and therefore contaminated the isolated
arm.  The subsequent masked attempt consumed an estimated 37,727 input tokens
over two controller cycles, produced only a compiled target-contract skeleton,
and had no accepted Lean root or Qiskit export.  One middle-agent pass spent
most of its time rebuilding generated Blueprint and website files.  This pilot
motivated the source mask, task-local inner gate, persistent cycle numbering,
typed population return gate, and content-hashed mutation allowlist now enforced
by `tools/run_robin_repro.py` and `tools/qbe_codex_agent.sh`.
