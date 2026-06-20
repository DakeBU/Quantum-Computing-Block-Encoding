# Proof Attempt: DIAG-RY-BACKEND-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower Lean refiner/reducer
Timestamp: 2026-06-20 10:04 JST

## Failed Route Being Repaired

Failed theorem or route:

```lean
expandedControlledRyBackendBridge tier n (3 * n)
```

Rejected direct proof script:

```lean
theorem rejected_ry_backend_bridge_route
    (tier : StandardRyCleanEntryScalarTier)
    (n : Nat) :
    expandedControlledRyBackendBridge tier n (3 * n) := by
  intro _hScalar
```

Lean error:

```text
<stdin>:9:56: error: unsolved goals
tier : StandardRyCleanEntryScalarTier
n : Nat
_hScalar : expandedRyCleanEntryForCubicAmplitudes tier n
|- expandedControlledRyUsesCubicAngle n (3 * n)
```

Rejected route: retrying the backend witness by introducing only the compiled
scalar-tier premise.  That leaves the opaque route predicate
`expandedControlledRyUsesCubicAngle n (3 * n)` with no transparent backend
semantics.

## Refiner Patch

Added the proof-reduction theorem:

```lean
expandedControlledRyBackendBridge_iff_of_standardTier
```

It proves, for any `tier`, `n`, and `workspaceQubits`, that

```lean
expandedControlledRyBackendBridge tier n workspaceQubits <->
  expandedControlledRyUsesCubicAngle n workspaceQubits
```

because `expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`
already supplies the scalar clean-entry premise.  This mirrors the arithmetic
bridge normal forms and records the remaining gap without supplying a backend
witness.

No theorem statement drift was introduced.  The patch does not prove
`expandedControlledRyUsesCubicAngle`, does not set any semantic proposition to
`True`, does not add an axiom, and does not change the diagonal target or
normalizer.

## Gate

`python3 tools/qbe.py check` passed.  The command also ran `lake build` and
`lake build Tests`.

## Verdict

Keep the normal-form theorem.  Treat direct search for
`expandedControlledRyBackendBridge tier n (3 * n)` as a stale symbolic bridge
retry until a transparent controlled-`R_y` backend-semantics interface is
introduced.  `DIAG-EXP-UNCOMP-001`, clean-block extraction, unitarity,
`DIAG-ROOT-001`, and executable exports remain blocked.

## Typed Feedback

```text
leaf=DIAG-RY-BACKEND-WITNESS-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
theta_convention_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem=expandedControlledRyBackendBridge_iff_of_standardTier
closed_theorem_ok=false
normal_form_compiled=true
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=state a transparent backend-semantics interface for expandedControlledRyUsesCubicAngle, or keep DIAG-RY-BACKEND-WITNESS-001 blocked and do not assign clean uncompute
```
