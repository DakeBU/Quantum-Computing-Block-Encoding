# Robin block-encoding evolution benchmark

This benchmark freezes one finite Robin-boundary operator contract. The
reported August 2026 experiment is the paper-seeded `warm` arm only.

- `cold`: receives the operator entries and acceptance contract, but not the
  paper construction or any Robin-specific proof memory.
- `warm`: receives the same contract plus the source construction and the
  compiled Robin memory cards, including the counterexample that rejects the
  historical H-free raw-fold route.

The two arms use the same normalizer, projector, register order, Lean gate,
Qiskit acceptance checks, and score order.  A result is not an improvement when
it changes semantic tier or replaces an expanded circuit with an unresolved
oracle call.

Reproduce the reported warm protocol with the pinned model family:

```bash
export CODEX_MODEL=gpt-5.6-sol
python3 tools/run_robin_repro.py prepare --arm warm --force
python3 tools/run_robin_repro.py run --arm warm --cycles 7 --minutes 100
python3 tools/run_robin_repro.py audit --arm warm
```

The recorded run used Codex CLI 0.145.0. Model sampling is not bitwise
deterministic, so reproduction means replaying the same frozen contract,
controller policy, gates, and model identifier; every promoted result must
still pass the local Lean and executable acceptance gates.

The task builder exposes the same two presets.  Its local API runner creates
the corresponding task packet; users supply their own agent profile and API
credentials.  GitHub Pages itself never executes a model or Lean.

Generated run data belongs under `experiments/robin-be/results/`.  Figures and
paper tables must be generated from the audited summary there.  An empty or
non-certified population is a reported outcome, not a plotting error.

The current warm run completed six controller cycles and was stopped during a
seventh after the upper agent repeated the same source-contract scan. It
produced compiled certificates for the fixed target, the source-ordered
ten-block transcript and register arithmetic, and the indicator permutation.
It did not produce `RobinEvolution.warmRobinBestVerified`, a deterministic
Qiskit export, or a same-tier resource tuple. Consequently, no lexicographic
improvement is claimed. `website/robin-paper-map.json` maps the paper's LaTeX statements to
the compiled `GHL2025.lean` and `RobinMatrix.lean` structures and labels the
paper-wide route separately. The generated website page is
`/case-studies/robin/`.

The cold arm remains defined for a future controlled comparison, but it is not
part of the paper result reported here.

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
