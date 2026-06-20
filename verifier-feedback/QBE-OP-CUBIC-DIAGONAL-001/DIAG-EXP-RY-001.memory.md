# Verifier Memory: DIAG-EXP-RY-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXP-RY-001`

This is a middle memory card, not a new finite diagnostic and not theorem
closure.  It retargets the existing expanded controlled-`R_y` finite evidence
from the stale interface leaf `DIAG-EXPANDED-CONTRACT-001` to the active
scalar-tier leaf selected by the proof DAG.

## Retire

- `DIAG-EXPANDED-CONTRACT-001` interface rebuilds.  The expanded layout,
  clean-block contract, and conditional bridge already compile.
- `DIAG-PRIM-WITNESS-001` as a standard exact `Rat`
  one-signal/no-workspace unitary.  The determinant-square diagnostic rejects
  that subroute for `n = 1, 2, 3`.
- Rank-one or normalized cubic state-preparation rewrites.
- Qiskit, QuantumKatas-style, or QASM3 exports before `DIAG-ROOT-001` names a
  Lean certificate.

## Active Leaf

The active leaf is the scalar/backend convention used by the expanded route.
For every scalar amplitude `a` with `0 <= a` and `a <= 1`, the next Lean-facing
contract should prove or explicitly expose the standard identity:

```text
cos((2 * arccos a) / 2) = a
```

For the cubic diagonal target, `a` is
`CubicStatePreparation.cubicAmplitude n j = (j / 2^n)^3`, and the compiled
range lemmas are `cubicAmplitude_nonneg` and `cubicAmplitude_le_one`.

The Lean target is `CubicDiagonalOracle.expandedControlledRyUsesCubicAngle`.
If the current scalar tier cannot express `arccos` and the standard `R_y`
matrix, the lower worker should introduce a transparent technical-lemma
interface for `tl-cubic-diagonal-ry-clean-entry` rather than proving an opaque
semantic proposition by `trivial`.

## Typed Feedback

```text
leaf=DIAG-EXP-RY-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=true
closed_theorem_ok=true
closed_theorem=CubicDiagonalOracle.expandedRyCleanEntryForCubicAmplitudes_of_standardTier
route_predicate_closed=false
error_class=symbolic_bridge_gap
next_route=Supply the backend bridge from expandedRyCleanEntryForCubicAmplitudes to expandedControlledRyUsesCubicAngle without closing opaque propositions by trivial.
```

The finite support for this memory card is the existing diagnostic
`DIAG-EXPANDED-CONTRACT-001.expanded-controlled-ry.feedback.json`, which checked
`n = 1, 2, 3, 4`.  That diagnostic remains necessary-condition evidence only.

## 2026-06-20 Lean Update

Compiled `StandardRyCleanEntryScalarTier` and
`expandedRyCleanEntryForCubicAmplitudes_of_standardTier`.  The theorem uses
`cubicAmplitude_nonneg` and `cubicAmplitude_le_one` to instantiate the
standard clean-entry contract for every cubic grid amplitude.  It does not
prove `expandedControlledRyUsesCubicAngle`; that route predicate is still a
symbolic backend bridge obligation.
