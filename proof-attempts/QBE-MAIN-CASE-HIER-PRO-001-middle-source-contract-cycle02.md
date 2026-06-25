# Middle Source Contract: QBE-MAIN-CASE-HIER-PRO-001 Cycle 2

## Source Anchors

The active source object is the user task operator and the injected Pro packet:

- `tasks/QBE-MAIN-CASE-HIER-PRO-001.md`, sections `Operator Contract`,
  `Isolation Rule`, `External Pro Construction Packet`, and
  `Post-Lean Executable Exports`.
- `task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md`, the
  transcript `CCX012; CX21; CX20; X2`.
- There is no local paper-source archive for this task, so no paper citation is
  being used as an external theorem.

The fixed operator is
$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$
The reproducible instance has one time qubit, one type qubit, and one passive
state qubit.  The full basis index is `signal * 8 + 4*T + 2*tau + S`.  The
normalizer is `1`, the clean signal index is `0`, and the resource tuple is
`(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

## Lean Correspondence

The target and block predicate are already compiled:

```lean
mainCaseProTarget
mainCaseProBlockProjection
mainCaseProQueryTarget
mainCaseProExactNormalizer
mainCaseProSourceLayout
```

The finite-permutation clean-block tier is already compiled:

```lean
mainCaseProCandidateImage_permutation_certificate
mainCaseProCandidate_cleanEntry
mainCaseProExactCleanBlock_correct
mainCaseProCandidate_blockProjection
mainCaseProCandidate_cost
mainCaseProVerified
```

The Pro transcript split is already compiled:

```lean
mainCaseProCircuitImage_candidate_mismatch_set
mainCaseProCircuitImage_not_pointwise_candidate
mainCaseProCircuitImage_permutation_certificate
mainCaseProCircuit_blockProjection
mainCaseProCircuitCandidate_cost
mainCaseProCircuitVerified
```

The false target `mainCaseProCircuitImage_eq_candidate` is retired.  The dirty
columns `8`, `9`, `12`, and `13` refute equality with
`mainCaseProCandidateImage`, while the clean block remains correct.

## Ownership Boundary

The active paper/user target owns the operator `E_1`, normalizer `1`, clean
signal `0`, register order `(T,tau,S)`, exact error `0`, and the request for
Qiskit/QASM3 exports after Lean acceptance.

The external Pro packet owns only the transcript `CCX012; CX21; CX20; X2` and
its source-subspace intuition.  It does not provide a Lean certificate and does
not prove equality with `mainCaseProCandidateImage`.

QBE-local semantic glue owns `BlockEncodingClassics.permMatrix`,
`mainCaseProCandidateMatrix`, `mainCaseProCircuitMatrix`, the clean-block
projection theorem, and the optional rational Gram/orthogonality predicate.

## Active Proof-DAG Leaf

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Promote a bijective permutation matrix to a rational Gram/orthogonality predicate.  Column Gram uses injectivity; row Gram uses surjectivity. | `mainCaseProCandidateImage_permutation_certificate`, `mainCaseProCircuitImage_permutation_certificate`, `mainCaseProCandidate_blockProjection`, `mainCaseProCircuit_blockProjection` | lower 1, lower 2, lower 3 | `mainCaseProRationalOrthogonalBridgeObligation`; preferred shared theorem `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`; fallback task-local theorem `mainCaseProCircuitMatrix_isRationalOrthogonal` | this packet plus conversion window | `python3 tools/qbe.py check` and `lake build && lake build Tests` | active |

No external cited-result row is needed.  If lower work imports a theorem from
`OptimalControl.lean` as a certificate, that is contract drift.  If it promotes
the local definitions `columnInner`, `rowInner`, and `IsRationalOrthogonal`
into `BlockEncodingClassics.lean`, it should update existing references rather
than create a second shared predicate with the same meaning.

## Lower-Facing Contract

Lower 1 writes a proof-DAG packet only.  It should name the column-Gram and
row-Gram subleaves and explain why injectivity and surjectivity are the only
permutation facts needed.

Lower 2 implements exactly one Lean bridge leaf.  Preferred route:

```lean
namespace BlockEncodingClassics

theorem permMatrix_isRationalOrthogonal_of_bijective
    {n : Nat} (p : Fin n -> Fin n)
    (hinj : Function.Injective p)
    (hsurj : Function.Surjective p) :
    IsRationalOrthogonal (permMatrix p) := by
  -- column Gram from `hinj`; row Gram from `hsurj`
```

If that shared theorem is too broad for the current API, lower 2 may prove a
finite task-local fallback:

```lean
theorem mainCaseProCircuitMatrix_isRationalOrthogonal :
    BlockEncodingClassics.IsRationalOrthogonal mainCaseProCircuitMatrix := by
  native_decide
```

The fallback is acceptable only as a bridge leaf for this finite candidate; it
must not change `mainCaseProTarget`, `mainCaseProSignalIndex`,
`mainCaseProCandidateImage`, `mainCaseProCircuitImage`, or either cost theorem.

Lower 3 checks finite row and column Gram values for the selected matrix and
logs typed verifier feedback.  It must not retry the retired full-image equality
target.

Exports remain blocked until reviewer names the accepted semantic tier.
