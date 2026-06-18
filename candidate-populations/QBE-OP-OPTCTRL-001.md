# Candidate Population: QBE-OP-OPTCTRL-001

Task: `operator of optimal control paper`

Target operator:

```text
E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n
```

Primary score order for expanded, non-oracle candidates:

```text
asymptotic tier first, then (gateCount, depth, auxiliaryQubits, oracleCalls)
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

## LexElim-In Scheduler Rule

For this exploratory operator-construction task, ABEIS uses a LexElim-In style
scheduler inspired by lexicographic bandits.  Each candidate receives a feedback
vector, but higher-priority fields cannot be overridden by lower-priority
signals:

```text
Lean-certified target correctness
> necessary-condition diagnostics
> asymptotic tier
> (gateCount, depth, auxiliaryQubits, oracleCalls)
> reusable proof-progress gain
> token/time cost
```

The scheduler uses all feedback fields to choose the next lower-agent pull, but
only two events can remove a candidate from the active set:

1. **Hard rejection**: a Lean theorem, exact necessary-condition verifier, or
   target/semantic-tier audit proves that the candidate cannot satisfy the
   fixed operator contract.
2. **Certified domination**: another candidate in the same semantic tier has
   Lean certificates and is lexicographically no worse in
   `(gateCount, depth, auxiliaryQubits, oracleCalls)`, with at least one strict
   improvement.

Soft failures, token cost, or an agent's inability to prove a lemma may lower
priority but do not delete an insightful candidate.  Such candidates stay in
the insight pool or in the proof-route backlog.

Plotting rule: final metric curves plot only candidates whose block-encoding
certificate has been closed at the task's required semantic tier.  For this
task the approved final tier is the concrete logical reversible
permutation-matrix tier: Lean must name an actual rational orthogonal matrix,
prove the clean block equals the requested operator, and connect the logical
gate transcript to the underlying basis permutation.  This tier is final for
the concrete `r = 1, k = 1` logical-library instance, but it is not a hardware
decomposition theorem and not a general `k,n` theorem.

## Adaptive Exact-To-Approximate Rule

The population now has two search phases.

1. **Exact phase.**  Search for candidates satisfying the exact clean-block
   equation.  These candidates have `epsilon = 0`.
2. **Approximate phase.**  After exact convergence, or after exact search
   stalls beyond the configured budget, search for candidates satisfying
   `||A - alpha * block(U_A)|| <= epsilon`.  Approximate candidates may be
   selected only if their approximation inequality, unitarity, and resource
   score are certified at the task's chosen norm/backend tier.

For this concrete main case, Scenario 1 is active: exact search produced the
Lean-certified champion `evolved-eq-flip-r1-k1`.  Lean declaration
`OptimalControl.evolvedEqFlipZeroErrorApprox` packages that same construction
as a zero-error approximate certificate.  The post-convergence approximate
phase therefore starts with a correct epsilon-zero incumbent.  No cheaper
approximate candidate has been promoted.

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
| 2 | lower-searcher depth scheduler + Lean worker | depth-5 expansion `CCX012; CX01; CX10; X0; {X2, CX01}` | `OptimalControl.reducedDepth5Verified`, `OptimalControl.reducedDepth5Unitary_isRationalOrthogonal`, `OptimalControl.reducedDepth5Unitary_cleanBlock`, `OptimalControl.reducedDepth5GateImages_eval`, `OptimalControl.reducedDepth5Cost_gateCount` | `(6, 5, 1, 0)` | concrete logical permutation-matrix BE certificate |
| 3 | mutation from certified Gen 2 | direct system-register unitary attempt | rejected by necessary condition: target operator is not unitary on the system register | none | rejected |
| 4 | mutation from certified Gen 2 | two-ancilla workspace completion | finite score no better: auxiliary qubits increase without depth/gate decrease | `(>=5, >=6, 2, 0)` | insight only; not promoted |
| 5 | crossover/collaboration from certified Gen 2 | split source-target cycles by state bit | same active reduced permutation after factoring passive state bit | `(6, 5, 1, 0)` | no strict improvement |

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
| 6 | Pro injection | `pro-eq-transfer-r1-k1` = `CCX012; CX21; CX20; X2` | `OptimalControl.proEqTransferVerified`, `OptimalControl.proEqTransferUnitary_isRationalOrthogonal`, `OptimalControl.proEqTransferUnitary_cleanBlock`, `OptimalControl.proEqTransferGateImages_eval`, `OptimalControl.proEqTransferCost_betterThan_depth5` | `(4, 4, 1, 0)` | concrete logical permutation-matrix BE certificate; strictly improves depth-5 |
| 7 | EoH mutation/collaboration from certified Gen 6 plus insight-pool simplification | `evolved-eq-flip-r1-k1` = `CCX012; {X0, X1, X2}` | `OptimalControl.evolvedEqFlipVerified`, `OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal`, `OptimalControl.evolvedEqFlipUnitary_cleanBlock`, `OptimalControl.evolvedEqFlipGateImages_eval`, `OptimalControl.evolvedEqFlipCandidate_cost` | `(4, 2, 1, 0)` | current concrete logical champion |
| 8 | approximate phase entry after exact convergence | reuse `evolved-eq-flip-r1-k1` as epsilon-zero approximate incumbent | `OptimalControl.evolvedEqFlipZeroErrorApprox` plus the exact certificates above | `(4, 2, 1, 0)`, `epsilon = 0` | Scenario 1 incumbent; approximate search may continue but has no promoted improvement |
| 9 | adaptive agent-count audit | do not add agents for this closed finite reduced target | exact finite verifier still rejects `<=3` gates and depth-1 with `<=4` gates | unchanged | stopped for this concrete logical tier; next useful work is generalization or a different backend |

LexElim-In active-set status after Generation 7:

| Candidate | Pool after Gen 7 | Reason |
|---|---|---|
| `reduced-depth5-fixed-completion` | certified archive, not active champion | certified and correct, but dominated by Gen 6 and Gen 7 in the same concrete logical tier. |
| `pro-eq-transfer-r1-k1` | certified archive, useful parent memory | certified and structurally useful, but dominated by Gen 7 on depth with equal gate count. |
| `evolved-eq-flip-r1-k1` | certified champion | Lean-certified, same gate count as Gen 6, lower depth, same auxiliary count and oracle calls. |
| zero-auxiliary whole-matrix attempt | rejected | `OptimalControl.exampleOperator_not_rationalOrthogonal` rules out using the target operator itself as the whole unitary in this exact model. |
| two-ancilla workspace variants | insight/backlog only | no certified resource improvement over the current champion. |

Current certified-search status:

```text
Under the concrete one-time, one-type, one-state target and the logical
{X,CNOT,Toffoli} library with disjoint-qubit layers, the current verified
logical reversible permutation-matrix block encoding is the evolved depth-2
clean-block completion, with record fields `depth = 2`, `gateCount = 4` and
comparison tuple `(4, 2, 1, 0)`.
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

## Formal LexElim-In Convergence Run: 2026-06-18

The human-interaction top module audited whether the current champion had
converged under the task's corrected resource priority:

```text
asymptotic tier first, then (gateCount, depth, auxiliaryQubits, oracleCalls)
```

The lower necessary-condition verifier performed an exact finite enumeration
over the reduced three-bit logical gate library

```text
{X0,X1,X2,
 CX01,CX02,CX10,CX12,CX20,CX21,
 CCX120,CCX021,CCX012}
```

with bit order `bit 0 = type`, `bit 1 = time`, and `bit 2 = auxiliary`.
The clean-block predicate was the exact branch predicate used by the Lean
development: source branch `3` must map to clean target `0`, and all other
clean input branches `0,1,2` must leave the clean block.

Verifier result:

| Search question | Exact finite result | Status |
|---|---|---|
| Any correct clean-block candidate with at most 3 logical gates? | no | hard necessary-condition rejection for gate-count improvement inside this library |
| Any correct 4-gate candidate? | yes, 36 ordered transcripts | confirms the current gate count is attainable |
| Any depth-1 layered candidate with at most 4 gates? | no | rejects depth-1 improvement inside this library |
| Any depth-2 layered candidate with at most 4 gates? | yes: `CCX012` followed by parallel `{X0,X1,X2}` | matches the current Lean-certified champion |

This verifier is exact for the finite logical library that it enumerates, but
the corresponding lower-bound statement has not yet been formalized in Lean.
It is therefore a trusted scheduling diagnostic and convergence signal, not a
published theorem.  The achieved candidate remains the Lean-certified
`evolved-eq-flip-r1-k1` construction.

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
  separate tier.  The evolved score `(4, 2, 1, 0)` is an expanded logical
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
