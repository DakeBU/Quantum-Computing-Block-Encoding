# Proof Attempt: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower Lean refiner/reducer
Timestamp: 2026-06-20 09:20 JST

## Failed Route Being Repaired

Failed theorem or route:

```lean
expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)
```

Recorded error inherited from the prior bridge attempt:

```text
<stdin>:7:68: error: unsolved goals;
goal: expandedArithmeticComputesCubicAmplitude n workspaceQubits
```

Rejected route: proving the direct backend bridge by only introducing the
fixed-denominator compute proof.  The compiled normal form
`fixedDenomCubicArithmeticBackend_bridge_iff` shows that route reduces to the
old opaque predicate `expandedArithmeticComputesCubicAmplitude n (3 * n)`, so
another direct tactic retry would not add semantic content.

## Refiner Patch

The repair is a smaller contract-boundary patch.  The existing definition
`expandedAmplitudeOracleCleanBlockContract` now uses:

```lean
expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits
```

as its arithmetic conjunct.  The target matrix, normalizer, layout, diagonal
contract, controlled-rotation obligation, clean-uncompute obligation, and
clean-block extraction obligation are unchanged.

Because the conjunct order after the arithmetic field is unchanged,
`expandedAmplitudeOracleCleanBlockContract_diagonal` and
`expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` keep their
existing projections.  For `workspaceQubits = 3 * n`, the arithmetic conjunct
is supplied by `fixedDenomCubicArithmeticRouteTransparent n`.

## Gate

`python3 tools/qbe.py check` passed.  The command also ran `lake build` and
`lake build Tests`.

## Verdict

Keep the refactor.  Do not retry the direct opaque bridge unless upper or
middle introduces a named nontrivial route-semantics bridge.  This patch closes
only the transparent arithmetic contract leaf; it does not close
`expandedControlledRyUsesCubicAngle`, `expandedWorkspaceCleanUncomputed`,
`expandedAmplitudeOracleCleanBlockExtracts`, unitarity, `DIAG-ROOT-001`, or
the requested executable exports.

## Typed Feedback

```text
leaf=DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
resource_score=null
auxiliary_qubits=null
gate_count=null
depth=null
oracle_calls=null
closed_theorem_ok=false
closed_leaf_ok=true
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=keep this refactor; next lower work must target a separately assigned rotation backend witness, clean-uncompute, or extraction leaf
```
