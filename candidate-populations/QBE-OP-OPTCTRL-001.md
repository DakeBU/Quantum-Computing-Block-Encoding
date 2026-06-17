# Candidate Population: QBE-OP-OPTCTRL-001

Task: `operator of optimal control paper`

Target operator:

```text
E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n
```

Primary score order for expanded, non-oracle candidates:

```text
(depth, gateCount, auxiliaryQubits, oracleCalls)
```

The oracle-level baseline and the expanded logical-gate population are kept in
separate tiers.  A candidate with one unresolved oracle call is useful as a
correctness baseline, but it is not treated as a one-gate hardware circuit.

## Generation 0

| Candidate | Lean declarations | Status | Score | Notes |
|---|---|---|---|---|
| `one-ancilla-permutation-completion-example` | `OptimalControl.exampleVerified`, `OptimalControl.example_cleanBlock`, `OptimalControl.exampleImage_isPermutation` | compiled | `(1, 1, 1, 1)` | Concrete instance with one time qubit, one type qubit, one state qubit, and `k = 1`.  The candidate uses one unresolved oracle-call layer for the reversible 4-cycle completion. |

## Explore Run 1: Expanded Logical Reversible Population

Gate library for this run: logical reversible gates `{X, CNOT, Toffoli}` on the
active reduced register.  Lean bit order is `bit 0 = type`, `bit 1 = time`,
and `bit 2 = auxiliary`.  The state register is passive and therefore does not
affect the finite synthesis search.  Hardware decomposition of Toffoli is
deliberately left as a later backend task.

| Generation | Agent route | Candidate | Lean declarations / verifier | Expanded score | Selection result |
|---:|---|---|---|---|---|
| 0 | upper baseline | `one-ancilla-permutation-completion-example` | `OptimalControl.exampleVerified` | oracle tier `(1, 1, 1, 1)` | correctness baseline only |
| 1 | lower-searcher BFS | sequential logical expansion `X2; CCX012; CX01; X0; CX10; CX01` | finite Python verifier | `(6, 6, 1, 0)` | accepted into expanded tier |
| 2 | lower-searcher depth scheduler + Lean worker | depth-5 expansion `CCX012; CX01; CX10; X0; {X2, CX01}` | `OptimalControl.reducedDepth5Image_eq_target`, `OptimalControl.reducedDepth5_lifts_exampleImage`, `OptimalControl.reducedDepth5Cost_gateCount` | `(5, 6, 1, 0)` | finite logical expanded witness for the old completion |
| 3 | mutation: zero extra ancilla | direct system-register unitary attempt | rejected by necessary condition: target operator is not unitary on the system register | none | rejected |
| 4 | mutation: add workspace ancilla | two-ancilla workspace completion | finite score no better: auxiliary qubits increase without depth/gate decrease | `(≥5, ≥6, 2, 0)` | rejected |
| 5 | crossover/collaboration | split source-target cycles by state bit | same active reduced permutation after factoring passive state bit | `(5, 6, 1, 0)` | no strict improvement |

## Explore Run 2: Pro Injection and Evolved Completion

ChatGPT Pro injected a structured construction:

```text
O_eq(k,1) ; controlled transfer V_k ; final X_a
```

For the concrete `r = 1, k = 1` Lean bit order, this becomes:

```text
CCX(type,time;aux); CX(aux,time); CX(aux,type); X(aux)
```

This construction does not realize the old permutation `exampleImage`, but it
does not need to.  A block encoding only constrains the clean block.  Lean
therefore checks it against `exampleOperator` directly.

| Generation | Agent route | Candidate | Lean declarations / verifier | Expanded score | Selection result |
|---:|---|---|---|---|---|
| 6 | Pro injection | `pro-eq-transfer-r1-k1` = `CCX012; CX21; CX20; X2` | `OptimalControl.proEqTransfer_cleanBlock`, `OptimalControl.proEqTransferFull_isPermutation`, `OptimalControl.proEqTransferCost_betterThan_depth5` | `(4, 4, 1, 0)` | strictly improves depth-5 witness |
| 7 | EoH mutation/collaboration | `evolved-eq-flip-r1-k1` = `CCX012; {X0, X1, X2}` | `OptimalControl.evolvedEqFlip_cleanBlock`, `OptimalControl.evolvedEqFlipFull_isPermutation`, `OptimalControl.evolvedEqFlipCost_betterThan_pro`, `OptimalControl.evolvedEqFlipCost_betterThan_depth5` | `(2, 4, 1, 0)` | current finite logical champion |

Current finite-search status:

```text
Under the concrete one-time, one-type, one-state target and the logical
{X,CNOT,Toffoli} library with disjoint-qubit layers, the current champion is
the evolved depth-2 clean-block completion (2, 4, 1, 0).
```

This is not a global optimality theorem and it is not yet a full gate-matrix
block-encoding certificate.  It is a Lean-checked finite function/permutation
certificate plus clean-block proof.  The next agent cycle should either reflect
the finite lower-bound search into Lean, generalize the construction to
arbitrary state dimension/time width, or switch to a hardware-decomposed gate
library.

## Metric Curve Artifact

- CSV: `candidate-populations/QBE-OP-OPTCTRL-001-metrics.csv`
- PNG: `candidate-populations/QBE-OP-OPTCTRL-001-metrics.png`

## Reviewer Notes

- The target operator is a partial isometry, not a system-register unitary.
  A one-ancilla block encoding is therefore a natural first baseline.
- The current score is oracle-level.  It should not be compared against a
  fully decomposed circuit as if the unresolved oracle call were free.
- The expanded generation currently has a Lean-checked finite reduced
  permutation certificate, a full-register passive-state lift certificate for
  the old completion, and direct clean-block/permutation certificates for the
  Pro and evolved completions.  It is still not a full matrix-semantics proof
  of every elementary gate.

## Next Mutations

1. Generalize the Lean operator from the concrete `time=1`, `type=1`,
   `state=1`, `k=1` instance to arbitrary state-qubit count.
2. Package `evolvedEqFlipImage` as a proper expanded candidate once the project
   has a resource model for Toffoli/logical reversible gates.
3. Reflect the finite depth lower-bound search into Lean or keep it as a
   verifier-feedback certificate.
4. Test whether a zero-extra-ancilla implementation is impossible under
   exact block-entry and unitarity constraints, so the search does not waste
   generations on `a = 0`.
5. Add a Toffoli-decomposition backend and re-score depth/gate count in the
   chosen elementary quantum gate library.
6. Add a finite necessary-condition verifier that checks the clean block and
   permutation bijectivity for generated candidates before Lean proof search.
