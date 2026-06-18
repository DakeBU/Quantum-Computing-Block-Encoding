# LexElim Scheduler Notes

Reference:

- Bo Xue, Yuanyu Wan, Zhichao Lu, Qingfu Zhang, "Beyond the Lower Bound:
  Bridging Regret Minimization and Best Arm Identification in Lexicographic
  Bandits", AAAI 2026 preprint.
- PDF: <https://xueb1996.github.io/pdf/AAAI-2026-Xue.pdf>
- Local copy:
  `../outer_papers/automation_systems/lexicographic_bandits_2026/AAAI-2026-Xue.pdf`

ABEIS does not inherit the paper's stochastic-bandit assumptions or sample
complexity theorem.  Candidate block encodings are generated dynamically, and
the strongest feedback is often deterministic: Lean either proves a theorem or
does not.  The useful pattern is the control logic for lexicographic,
multi-objective selection.

## Mapping To ABEIS

```text
bandit arm
  -> candidate block encoding, circuit schedule, or proof route

pulling an arm
  -> assigning lower agents or verifier tools to that candidate

reward vector
  -> Lean status, necessary diagnostics, asymptotic tier, gate count, depth,
     auxiliary qubits, oracle calls, proof progress, token/time cost

best-arm identification
  -> find the current best certified block encoding for a fixed operator target

regret minimization
  -> spend fewer cycles on candidates that cannot beat the current certified
     frontier or cannot satisfy necessary conditions
```

## Two Scheduler Modes

`LexElim-Out` is the faithful theorem-closure mode.  It filters candidates and
proof routes layer by layer:

1. source/operator target is fixed;
2. Lean statement is the right statement;
3. necessary diagnostics do not refute it;
4. proof route makes local progress;
5. resource comparison is reported after correctness.

This is the right mode for paper-benchmark work such as GHL2025.  It prevents
agents from optimizing a circuit that is no longer the paper construction.

`LexElim-In` is the exploratory operator-construction mode.  Every candidate
keeps a vector of feedback fields each round, and lower-priority fields can
help prioritize proof work, but they cannot override higher-priority gates:

```text
hard Lean correctness
> necessary-condition diagnostics
> asymptotic tier
> (gateCount, depth, auxiliaryQubits, oracleCalls)
> reusable proof progress
> token/time cost
```

This is the right mode for the `E_k` transfer-operator task.  It lets lower
agents use finite checks and resource scores to avoid poor candidates, while
still requiring Lean promotion before a candidate can become an evolutionary
parent.

## Agent Count Rule

ABEIS does not assume that more agents are always better.

- Use 1 upper, 1 middle, 1 lower, and 1 reviewer for a simple local Lean leaf.
- Use 1 upper, 1 middle, 3 lower agents, and 1 reviewer for ordinary
  exploratory block-encoding search:
  - lower 1: natural-language construction/proof architect;
  - lower 2: Lean implementation worker;
  - lower 3: necessary-condition verifier.
- Use the upper/middle panels only for stale, high-risk, or closeout states:
  source/target audit, proof-DAG strategy, process/memory audit, and director
  synthesis; source correspondence, memory/retrieval, report/export, and
  coordinator synthesis.
- Add a fourth lower agent only after a concrete Lean failure needs a reducer
  or refiner.

This keeps the LBG-style hierarchy, the EoH-style candidate population, and the
LeanMarathon/Lean4Agent-style process control from becoming expensive
ceremony during a productive inner proof loop.
