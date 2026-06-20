# QBE-OP-CUBIC-DIAGONAL-001 DIAG-ARITH-FIXED-DENOM-ALG-001 Lower Refiner

Updated: 2026-06-20 06:11 JST

Role: lower Lean refiner/reducer.

## Failed Parent Route

Exact failed theorem route:

```lean
expandedArithmeticBackendBridge
  (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
```

and, for the concrete fixed-denominator route, the analogous future bridge:

```lean
expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)
```

Rejected route: direct bridge proof search.  The compiled normal forms
`expandedArithmeticBackendBridge_iff_of_computes` and
`symbolicExpandedCubicArithmeticBackend_bridge_iff` reduce a bridge proof, once
pointwise backend computation is known, to the opaque route predicate

```lean
expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

There is no constructor or accepted semantic witness for that opaque predicate
in the current Lean surface.  Retrying the bridge would add an unstated
semantic assumption, so the repair route stays on the fixed-denominator
representation leaves.

## Patch

The capacity leaf `fixedDenomCubicPayload_lt_capacity` was already present in
the working tree.  This refiner added the next planned leaf:

```lean
theorem fixedDenomCubicAmplitude_eq
    (n : Nat) (j : Fin (gridSize n)) :
    (j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j
```

The proof rewrites `gridSize (3 * n)` by
`CubicStatePreparation.gridSize_three_mul_eq_cube`, unfolds
`gridPoint` and `cubicAmplitude`, and normalizes the rational identity
`a^3 / b^3 = (a / b)^3` with `Rat.div_def`, `Rat.pow_succ`,
`Rat.inv_mul_rev`, and associativity/commutativity.

No target, normalizer, semantic predicate, or bridge statement was changed.

## Gate

`python3 tools/qbe.py check` passed after the Lean edit.  The command ran
`lake build` and `lake build Tests`.

## Typed Feedback

```text
leaf=DIAG-ARITH-FIXED-DENOM-ALG-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=null
finite_arithmetic_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=true
lean_declaration=CubicDiagonalOracle.fixedDenomCubicAmplitude_eq
error_class=symbolic_bridge_gap
next_route=define fixedDenomCubicArithmeticBackend and prove its pointwise compute contract; keep expandedArithmeticBackendBridge blocked until a transparent route-semantics witness exists
```

Verdict: keep the refiner patch.  The next active Lean leaf is
`DIAG-ARITH-FIXED-DENOM-BACKEND-001`, not the opaque bridge.
