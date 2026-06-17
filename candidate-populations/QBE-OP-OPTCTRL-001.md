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
active reduced register `(aux,time,type)`.  The state register is passive and
therefore does not affect the finite synthesis search.  Hardware decomposition
of Toffoli is deliberately left as a later backend task.

| Generation | Agent route | Candidate | Lean declarations / verifier | Expanded score | Selection result |
|---:|---|---|---|---|---|
| 0 | upper baseline | `one-ancilla-permutation-completion-example` | `OptimalControl.exampleVerified` | oracle tier `(1, 1, 1, 1)` | correctness baseline only |
| 1 | lower-searcher BFS | sequential logical expansion `X2; CCX012; CX01; X0; CX10; CX01` | finite Python verifier | `(6, 6, 1, 0)` | accepted into expanded tier |
| 2 | lower-searcher depth scheduler + Lean worker | depth-5 expansion `CCX012; CX01; CX10; X0; {X2, CX01}` | `OptimalControl.reducedDepth5Image_eq_target`, `OptimalControl.reducedDepth5_lifts_exampleImage`, `OptimalControl.reducedDepth5Cost_gateCount` | `(5, 6, 1, 0)` | current finite logical expanded witness |
| 3 | mutation: zero extra ancilla | direct system-register unitary attempt | rejected by necessary condition: target operator is not unitary on the system register | none | rejected |
| 4 | mutation: add workspace ancilla | two-ancilla workspace completion | finite score no better: auxiliary qubits increase without depth/gate decrease | `(≥5, ≥6, 2, 0)` | rejected |
| 5 | crossover/collaboration | split source-target cycles by state bit | same active reduced permutation after factoring passive state bit | `(5, 6, 1, 0)` | no strict improvement |

Current short-run convergence claim:

```text
Under the current logical reversible library and the concrete one-time,
one-type, one-state instance, no strict expanded-tier improvement was found
after three post-champion explore generations.
```

This is not a global optimality theorem and it is not yet a full gate-matrix
block-encoding certificate.  It is a population-management decision for the
next agent cycle: future work should either prove lower bounds for the reduced
permutation, generalize the construction to arbitrary state dimension, or
switch to a hardware-decomposed gate library.

## Metric Curve Artifact

- CSV: `candidate-populations/QBE-OP-OPTCTRL-001-metrics.csv`
- PNG: `candidate-populations/QBE-OP-OPTCTRL-001-metrics.png`

## Reviewer Notes

- The target operator is a partial isometry, not a system-register unitary.
  A one-ancilla block encoding is therefore a natural first baseline.
- The current score is oracle-level.  It should not be compared against a
  fully decomposed circuit as if the unresolved oracle call were free.
- The expanded generation currently has a Lean-checked finite reduced
  permutation certificate and a full-register passive-state lift certificate.
  It is still not a full matrix-semantics proof of every elementary gate.
  This is the next refinement if this task continues.

## Next Mutations

1. Generalize the Lean operator from the concrete `time=1`, `type=1`,
   `state=1`, `k=1` instance to arbitrary state-qubit count.
2. Package the lifted depth-5 logical circuit as a proper expanded candidate
   once the project has a resource model for Toffoli/logical reversible gates.
3. Test whether a zero-extra-ancilla implementation is impossible under
   exact block-entry and unitarity constraints, so the search does not waste
   generations on `a = 0`.
4. Add a Toffoli-decomposition backend and re-score depth/gate count in the
   chosen elementary quantum gate library.
5. Add a finite necessary-condition verifier that checks the clean block and
   permutation bijectivity for generated candidates before Lean proof search.
