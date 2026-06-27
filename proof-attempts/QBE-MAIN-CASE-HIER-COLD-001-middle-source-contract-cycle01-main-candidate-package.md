# Middle Source Contract: MAIN-CANDIDATE-PACKAGE-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01`

## Source Anchor

The source object is the task packet operator contract:

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The benchmark instance fixes one qubit each for `T`, `tau`, and passive `S`,
one clean signal qubit at value `0`, normalizer `1`, and exact error `0`.
The system flattening is `4*T + 2*tau + S`; the full signal-system flattening
is `8*signal + 4*T + 2*tau + S`.

No local paper-source archive exists for this task.  No cited theorem,
external oracle, QSVT primitive, LCU theorem, or sparse-access subroutine is
needed for this packaging leaf.

## Ownership

| Item | Owner class | Rule for lower work |
|---|---|---|
| `mainCaseColdTarget`, clean signal `0`, `alpha = 1`, exact error `0` | active user/operator target | fixed; do not mutate |
| `mainCaseColdPartialPermImage` and `mainCaseColdPartialPermMatrix` | QBE-local candidate completion | consume as compiled evidence |
| `mainCaseColdCircuit`, `mainCaseColdSchedule`, `mainCaseColdHighLevelResource` | QBE-local resource schema | consume as compiled evidence |
| `BlockEncodingClassics.partialPermutationCertificate` and `permMatrix` | QBE-local reusable semantic glue | already consumed by prior leaves |
| `mainCasePro*` declarations and previous Qiskit/QASM exports | separate/prohibited evidence for this arm | do not use |

## Active Leaf

Leaf id: `MAIN-CANDIDATE-PACKAGE-001`.

Human rationale: the target matrix, finite permutation, clean-block equality,
block projection, finite-permutation proof, circuit image, and resource tuple
already compile.  The remaining exact-certificate step is to package those
fields in the project record interface so later export work can cite one named
verified COLD declaration.

Allowed Lean write scope:

- `QuantumBlockEncoding/MainCase.lean`
- `Tests/Basic.lean`, only if a focused import or smoke test is needed

Allowed memory scope:

- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-*`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`
- `runs/20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01/`

Required gate after Lean edits:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

## Lean Contract

Add the COLD package under task-local names:

```lean
def mainCaseColdPartialPermCandidate :
    OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := mainCaseColdQueryTarget
  unitary := mainCaseColdPartialPermMatrix
  layout := mainCaseColdSourceLayout
  circuit := mainCaseColdCircuit
  schedule := mainCaseColdSchedule
  resource := mainCaseColdHighLevelResource
  layoutMatches := mainCaseColdSourceLayout_auxiliaryQubits
  isUnitary := mainCaseColdPartialPermImageIsPermutation
  blockContainsTarget := mainCaseColdBlockProjection mainCaseColdPartialPermMatrix

def mainCaseColdPartialPermVerified :
    VerifiedOperatorBlockEncoding Rat 3 where
  candidate := mainCaseColdPartialPermCandidate
  unitaryProof := by
    unfold mainCaseColdPartialPermCandidate
    exact mainCaseColdPartialPermImage_bijective
  blockProof := by
    unfold mainCaseColdPartialPermCandidate
    exact mainCaseColdPartialPerm_blockProjection
```

Also prove the cost field if it remains a small `native_decide` theorem:

```lean
theorem mainCaseColdPartialPermCandidate_cost :
    mainCaseColdPartialPermCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 5, depth := 5, oracleCalls := 0 } := by
  native_decide
```

The lower worker may adjust the proof script for record unfolding, but not the
target, resource tuple, or semantic fields.

## Dependencies

| Needed declaration | Status |
|---|---|
| `mainCaseColdQueryTarget` | compiled |
| `mainCaseColdPartialPermMatrix` | compiled |
| `mainCaseColdSourceLayout` | compiled |
| `mainCaseColdCircuit` | compiled |
| `mainCaseColdSchedule` | compiled |
| `mainCaseColdHighLevelResource` | compiled |
| `mainCaseColdSourceLayout_auxiliaryQubits` | compiled |
| `mainCaseColdPartialPermImage_bijective` | proved |
| `mainCaseColdPartialPerm_blockProjection` | proved |
| `mainCaseColdPartialPermCost_*` | proved as `(5, 5, 1, 0)` |

## Feedback Contract

If this leaf closes, log structured feedback with
`closed_theorem_ok=true`, `lean_build_ok=true`,
`resource_score=(5,5,1,0)`, and `next_route=MAIN-EXPORT-001 blocked until
middle creates the post-Lean export packet`.

If it fails, use one primary class:

| Failure | Error class | Narrow next route |
|---|---|---|
| record field type mismatch | `shape_or_register_gap` | expose the unfolded field type and add only the needed bridge |
| proof term mismatch after unfolding candidate | `lean_tactic_gap` | prove the exact unfolded proposition |
| stronger matrix-unitary predicate required by reviewer | `symbolic_bridge_gap` | create a separate rational-orthogonality bridge obligation |
| target mutation, Pro-arm evidence, hidden oracle, or export-before-Lean | `invalid_route` | reject and restart from this contract |

Do not reopen clean-entry, finite-bijection, block-projection, or resource
search unless the COLD target, table, or circuit schema changes.
