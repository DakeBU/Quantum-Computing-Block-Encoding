# Robin completion state

- Baseline commit: `cf32d3518090953b08ac993c1377c4515975fb9a`.
- Branch: `fix/robin-ghl-example-cases`.
- Toolchain: Python 3.12.3; Lake 5.0.0 / Lean 4.29.1; Codex CLI 0.145.0.
- Current proof roots: `Robin.warmRobinFiveShiftCleanFormula_eq_target` and `Robin.warmRobinHadamard8CleanFormula_eq_target` (T1 exact structural LCU).
- Currently failing leaf: construct matching complex-unitary PREPARE/amplitude/SELECT/unprepare semantics and prove its clean projection is the compiled formula.
- Last gates: whole `lake build`, `lake build Tests`, public replay, exporter, Blueprint, and assembled-site checks passed; `lake build ABEISTests` is not a Lake target.
- Accepted candidates: five-shift, seven-slot control, and Hadamard-8 at T1 only; none at T2+.
- Rejected candidate: historical H-free raw-fold equality (compiled counterexample; never retry).
- Resource convention: logical one-qubit rotations plus CNOT; SWAP is three CNOTs; expand PREPARE, SELECT, amplitude logic, cleanup, and truth-table logic before comparison.
- Frozen target: `A = warmRobinTarget`, `alpha = 56/3`, `M = 12 A`, `A / alpha = M / 224`.
- Next action: close the matching complex-unitary circuit leaf before any evolutionary rerun or resource-dominance claim.
