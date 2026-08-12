# Robin boundary block encoding, paper-seeded warm start

Task id: `QBE-ROBIN-BE-WARM-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-08-12`
Evaluation mode: `full-abeis`
Population gate: `required`
Tolerance ladder: `0`, `1e-10`, `1e-9`, `1e-8`, `1e-7`, `1e-6`
Lean acceptance anchors: `RobinEvolution.warmRobinBestVerified`
Executable acceptance command: `python3 tools/export_robin_evolution.py --task QBE-ROBIN-BE-WARM-001 --arm warm`

Baseline formalization status: `compiled local structure; broader paper route partial`
Baseline Lean gate: `lake build QuantumBlockEncoding.GHL2025 QuantumBlockEncoding.RobinMatrix`
Source-to-Lean map: `website/robin-paper-map.json`

## Fixed benchmark

Use exactly the same `N = 8`, homogeneous-Robin matrix, normalizer `alpha =
56/3`, clean projector, register order, and exact acceptance equation as
`QBE-ROBIN-BE-COLD-001`.  A cross-arm comparison is invalid if any one of these
fields differs.

## Warm seed

Seed the population with the source construction: sparse-register preparation,
bulk/boundary indication, sparse derivative-amplitude loading, controlled
boundary rotations, banded sparse access, coefficient loading, register swap,
cleanup, and the matching preparation inverse.  Existing `GHL2025.lean`,
`Examples/RobinHeat.lean`, and `RobinMatrix.lean` declarations may be retrieved
as proof memory.

The seed is not automatically a certified champion.  Every cited oracle must
be instantiated for the fixed benchmark, and its unitary, cleanup, projection,
normalization, and resource claims must pass the same Lean and Qiskit gates.
The historical false H-free raw-fold equality is forbidden; retrieve its
compiled counterexample and retire that route immediately.

Until an evolved root passes the completion gate below, report the compiled
paper baseline directly. The corresponding source theorem, equations, circuit
order, local declarations, and open obligations are maintained in
`website/robin-paper-map.json` and
`paper-notes/GHL2025/source-excerpts.tex`. Do not hide this useful partial
formalization merely because the optimization arm has not produced a champion.

## Evolution and score

First reproduce and certify the paper seed at a named semantic tier.  Then
mutate, recombine, or specialize candidates while preserving the fixed target.
Compare asymptotic/semantic tier first and then

```text
(gateCount, depth, auxiliaryQubits, oracleCalls).
```

No claimed improvement is valid until both candidates are expanded to the
same gate library and resource accounting convention.  If the run certifies
the seed but finds no dominating candidate, report that negative result.  If
the seed itself remains conditional on an external contract, report a partial
route rather than an achieved baseline.

## Completion gate

Completion requires `RobinEvolution.warmRobinBestVerified`, `lake build`,
`lake build Tests`, Qiskit unitarity and clean-block checks, a source-faithful
baseline row, candidate metrics with mutation provenance, and an export
manifest.  Figures may plot only candidates accepted by these gates.
