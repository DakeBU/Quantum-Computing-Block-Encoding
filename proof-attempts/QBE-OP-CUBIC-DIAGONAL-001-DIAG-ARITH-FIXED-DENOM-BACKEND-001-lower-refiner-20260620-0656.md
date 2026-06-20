# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-FIXED-DENOM-BACKEND-001 Lower Refiner

Updated: 2026-06-20 06:56 JST

Role: lower Lean refiner/reducer.

## Failed Parent Route

Exact rejected theorem route:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

and its concrete fixed-denominator analogue:

```lean
expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)
```

Verifier error class: `symbolic_bridge_gap`.

The rejection is not a Lean parser error.  The compiled normal form
`expandedArithmeticBackendBridge_iff_of_computes` says that once a backend
pointwise compute proof is available, the bridge goal is equivalent to the
opaque proposition:

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

No constructor or accepted route-semantics witness for that opaque proposition
exists in the current Lean surface.  Direct bridge proof search is therefore
rejected.

## Repair

Before defining anything new, this refiner searched the scoped Lean file and
found the assigned backend leaf already present in the local working tree:

```lean
def fixedDenomCubicArithmeticBackend (n : Nat) :
    ExpandedCubicArithmeticBackend n (3 * n)

theorem fixedDenomCubicArithmeticBackend_computes
    (n : Nat) :
    expandedArithmeticBackendComputesCubicAmplitude
      (fixedDenomCubicArithmeticBackend n)
```

The backend uses workspace `Fin (gridSize (3 * n))`, clean workspace `0`,
payload `j.val ^ 3`, and amplitude projection
`(payload.val : Rat) / (gridSize (3 * n) : Rat)`.  The compute proof reuses
`fixedDenomCubicPayload_lt_capacity` and `fixedDenomCubicAmplitude_eq`.

No target, normalizer, semantic predicate, bridge statement, root certificate,
or executable export was changed.  The proof-obligation DAG was updated to mark
`DIAG-ARITH-FIXED-DENOM-BACKEND-001` as proved and keep
`DIAG-ARITH-BACKEND-BRIDGE-001` blocked.

## Gate

`lake env lean QuantumBlockEncoding/CubicStatePreparation.lean` passed.

`python3 tools/qbe.py check` passed and ran:

```bash
lake build
lake build Tests
```

## Typed Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-BACKEND-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
qbe_check_ok=true
finite_matrix_ok=null
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=true
lean_declaration=CubicDiagonalOracle.fixedDenomCubicArithmeticBackend_computes
error_class=symbolic_bridge_gap
next_route=do not retry the opaque bridge directly; define or accept a transparent backend-to-route semantics interface before another bridge attempt
```

Verdict: keep the fixed-denominator backend leaf.  The next route is not a
broader Lean proof against the opaque bridge; it is a middle/upper interface
decision for transparent route semantics, after which a lower worker can try
one named bridge leaf.
