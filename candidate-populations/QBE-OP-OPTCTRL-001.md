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

## Certified Population Rule

The evolutionary population has two explicitly separate pools.

- **Certified population**: candidates whose stated semantic tier has been
  closed by named Lean declarations.  Only these candidates may be selected as
  parents for mutation, crossover, recombination, or champion curves.
- **Insight pool**: Python searches, simulator traces, ChatGPT Pro proposals,
  reviewer suggestions, and hand-written circuit ideas that have not yet been
  Lean-certified.  These may guide the next Lean proof task, but they are not
  parents and are not plotted as achieved solutions.

This is a hard correctness invariant.  Evolution may use a non-certified idea
only by first assigning a lower-agent Lean task that proves the candidate's
unitarity/approved semantic-tier statement, clean-block equality, and resource
score.  After that proof compiles, the candidate can be promoted into the
certified population.

Plotting rule: final metric curves plot only candidates whose block-encoding
certificate has been closed at the task's required semantic tier.  For this
task the approved final tier is the concrete logical reversible
permutation-matrix tier: Lean must name an actual rational orthogonal matrix,
prove the clean block equals the requested operator, and connect the logical
gate transcript to the underlying basis permutation.  This tier is final for
the concrete `r = 1, k = 1` logical-library instance, but it is not a hardware
decomposition theorem and not a general `k,n` theorem.

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
| 1 | lower-searcher BFS | sequential logical expansion `X2; CCX012; CX01; X0; CX10; CX01` | finite Python verifier only | `(6, 6, 1, 0)` | insight pool only; not a parent and not plotted as a solution |
| 2 | lower-searcher depth scheduler + Lean worker | depth-5 expansion `CCX012; CX01; CX10; X0; {X2, CX01}` | `OptimalControl.reducedDepth5Unitary_isRationalOrthogonal`, `OptimalControl.reducedDepth5Unitary_cleanBlock`, `OptimalControl.reducedDepth5Cost_gateCount` | `(5, 6, 1, 0)` | concrete logical permutation-matrix BE certificate |
| 3 | mutation from certified Gen 2 | direct system-register unitary attempt | rejected by necessary condition: target operator is not unitary on the system register | none | rejected |
| 4 | mutation from certified Gen 2 | two-ancilla workspace completion | finite score no better: auxiliary qubits increase without depth/gate decrease | `(>=5, >=6, 2, 0)` | insight only; not promoted |
| 5 | crossover/collaboration from certified Gen 2 | split source-target cycles by state bit | same active reduced permutation after factoring passive state bit | `(5, 6, 1, 0)` | no strict improvement |

## Explore Run 2: Pro Injection and Evolved Completion

ChatGPT Pro injected a structured construction into the insight pool:

```text
O_eq(k,1) ; controlled transfer V_k ; final X_a
```

For the concrete `r = 1, k = 1` Lean bit order, this becomes:

```text
CCX(type,time;aux); CX(aux,time); CX(aux,type); X(aux)
```

This construction did not become a parent merely because it was suggested.
First Lean checked it against `exampleOperator` directly, because a block
encoding constrains the clean block rather than the irrelevant off-block
completion.  Only after `OptimalControl.proEqTransferVerified` compiled was it
promoted from insight to certified population.

| Generation | Agent route | Candidate | Lean declarations / verifier | Expanded score | Selection result |
|---:|---|---|---|---|---|
| 6 | Pro injection | `pro-eq-transfer-r1-k1` = `CCX012; CX21; CX20; X2` | `OptimalControl.proEqTransferUnitary_isRationalOrthogonal`, `OptimalControl.proEqTransferUnitary_cleanBlock`, `OptimalControl.proEqTransferCost_betterThan_depth5` | `(4, 4, 1, 0)` | concrete logical permutation-matrix BE certificate; strictly improves depth-5 |
| 7 | EoH mutation/collaboration from certified Gen 6 plus insight-pool simplification | `evolved-eq-flip-r1-k1` = `CCX012; {X0, X1, X2}` | `OptimalControl.evolvedEqFlipVerified`, `OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal`, `OptimalControl.evolvedEqFlipUnitary_cleanBlock`, `OptimalControl.evolvedEqFlipGateImages_eval`, `OptimalControl.evolvedEqFlipCandidate_cost` | `(2, 4, 1, 0)` | current concrete logical champion |

Current certified-search status:

```text
Under the concrete one-time, one-type, one-state target and the logical
{X,CNOT,Toffoli} library with disjoint-qubit layers, the current verified
logical reversible permutation-matrix block encoding is the evolved depth-2
clean-block completion (2, 4, 1, 0).
```

This is not a global optimality theorem, not a hardware-gate theorem, and not
yet a general theorem for arbitrary time width or state dimension.  It is a
Lean-checked concrete logical-library BE certificate: an actual rational
orthogonal `16 x 16` matrix, a clean-block proof for `E_1`, a logical gate
transcript, and an image-semantics bridge from that transcript to the matrix's
basis permutation.  The next agent cycle should either generalize the
construction, prove a Lean lower bound for depth 1 in the same logical library,
or switch to a hardware-decomposed gate library.

Lean also proves `OptimalControl.exampleOperator_not_rationalOrthogonal`: the
target `E_1` is not itself unitary/orthogonal, so an exact unscaled zero-auxiliary
candidate cannot simply use `E_1` as the whole unitary.  Thus one auxiliary
qubit is locally necessary in this exact concrete model.

## Metric Curve Artifact

- CSV: `candidate-populations/QBE-OP-OPTCTRL-001-metrics.csv`
- PNG: `candidate-populations/QBE-OP-OPTCTRL-001-metrics.png`
- Validation: `python3 tools/qbe.py validate-candidate-metrics QBE-OP-OPTCTRL-001`

The current metric artifact is a certified concrete logical BE curve.  Every
plotted row names Lean declarations proving a rational orthogonal matrix and
the clean-block equality.  The figure caption states the semantic tier so that
readers do not confuse this with hardware decomposition or general-family
optimality.

## Reviewer Notes

- The target operator is a partial isometry, not a system-register unitary.
  A one-ancilla block encoding is therefore a natural first baseline, and
  `OptimalControl.exampleOperator_not_rationalOrthogonal` rules out the
  zero-auxiliary whole-matrix option for this exact target.
- The baseline score `(1, 1, 1, 1)` is oracle-level and should stay in a
  separate tier.  The evolved score `(2, 4, 1, 0)` is an expanded logical
  `{X,CNOT,Toffoli}` score, not a hardware-decomposed score.
- The expanded generation currently has a Lean-checked finite reduced
  permutation certificate, rational orthogonal matrix certificates, and direct
  clean-block certificates for the depth-5, Pro, and evolved completions.
  Therefore depth 2 is now a completed concrete logical-library BE result, but
  still not a hardware-decomposed or general-family result.

## Next Mutations

1. Generalize the Lean operator from the concrete `time=1`, `type=1`,
   `state=1`, `k=1` instance to arbitrary state-qubit count.
2. Generalize `evolvedEqFlipImage` from the concrete `r = 1, k = 1` instance to
   arbitrary state dimension and time width.
3. Reflect the finite depth-1 lower-bound search into Lean or keep it as a
   verifier-feedback certificate.
4. Test whether a zero-extra-ancilla implementation is impossible under
   exact block-entry and unitarity constraints beyond the already-closed
   whole-matrix obstruction.
5. Add a Toffoli-decomposition backend and re-score depth/gate count in the
   chosen elementary quantum gate library.
6. Add a finite necessary-condition verifier that checks the clean block and
   permutation bijectivity for generated candidates before Lean proof search.
