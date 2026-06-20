# Middle Coordinator Packet: DIAG-RY-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: middle coordinator synthesis

Updated: 2026-06-20 10:38 JST

## Source Object

The active source is the user-provided diagonal operator:

```text
O = sum_{j=0}^{2^n-1} (j / 2^n)^3 |j><j|.
```

The Lean target remains the diagonal matrix
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise.  The
normalizer remains `exactNormalizer n = 1`.

This packet does not use a paper archive, a cited theorem, an external
construction hint, a rank-one state-preparation target, or an executable
export.

## Current Lean Status

Closed dependencies:

- `expandedRyCleanEntryForCubicAmplitudes_of_standardTier`
- `expandedControlledRyUsesCubicAngle_of_backendBridge`
- `expandedControlledRyBackendBridge_iff_of_standardTier`
- `expandedArithmeticComputesCubicAmplitudeTransparent`
- `fixedDenomCubicArithmeticRouteTransparent`
- the current `expandedAmplitudeOracleCleanBlockContract`, whose arithmetic
  conjunct already uses the transparent arithmetic predicate

The direct controlled-`R_y` backend witness is not an active tactic-search
leaf.  For any scalar tier, the normal form
`expandedControlledRyBackendBridge_iff_of_standardTier` reduces
`expandedControlledRyBackendBridge tier n workspaceQubits` to the opaque route
predicate `expandedControlledRyUsesCubicAngle n workspaceQubits`.

## Active Leaf

The active leaf is `DIAG-RY-TRANSPARENT-INTERFACE-001`.

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-RY-SCALAR-001` | Scalar-tier standard `R_y` clean-entry identity for cubic amplitudes. | `DIAG-RANGE-001` | existing Lean | `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | conversion window and verifier feedback | `python3 tools/qbe.py check` | proved scalar-tier specialization |
| `DIAG-RY-BACKEND-WITNESS-001` | Concrete backend witness for `expandedControlledRyUsesCubicAngle`. | `DIAG-RY-SCALAR-001`, backend route semantics | future lower only after a semantics object exists | `expandedControlledRyBackendBridge`; normal form `expandedControlledRyBackendBridge_iff_of_standardTier` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked symbolic bridge |
| `DIAG-RY-TRANSPARENT-INTERFACE-001` | Transparent predicate for the controlled-`R_y` angle convention plus fixed-denominator wrapper. | `DIAG-RY-SCALAR-001` | next lower roles | proposed `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent` | this packet | `python3 tools/qbe.py check` | active leaf |
| `DIAG-EXP-UNCOMP-001` | Clean uncompute of arithmetic workspace. | rotation route decision, arithmetic route | future lower | `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked downstream |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | arithmetic, rotation, uncompute, extraction, unitarity | future lower | planned expanded certificate or conditional primitive certificate | candidate population | full gate | blocked |
| `DIAG-EXPORT-001` | Qiskit, QuantumKatas-style, and QASM3 export plan tied to a named Lean certificate. | `DIAG-ROOT-001` | future export worker | planned export packet | post-Lean export bridge | export checks after Lean gate | blocked |

## Lower 1 Packet

Role: natural-language proof architect.

Write scope:

```text
proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-RY-TRANSPARENT-INTERFACE-001-lower-architect-<timestamp>.md
```

Task:

- Restate the source object as the diagonal operator with alpha `1`.
- Explain why direct `DIAG-RY-BACKEND-WITNESS-001` search is stale under
  `expandedControlledRyBackendBridge_iff_of_standardTier`.
- Prove in prose that the transparent predicate follows by introducing
  `tier : StandardRyCleanEntryScalarTier` and applying
  `expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n`.
- Do not request a proof of `expandedControlledRyUsesCubicAngle`.
- Do not touch Lean.

## Lower 2 Packet

Role: Lean implementation worker.

Write scope:

```text
QuantumBlockEncoding/CubicStatePreparation.lean
```

Allowed edit location: adjacent to the existing
`expandedControlledRyUsesCubicAngle` declarations.

Add exactly this transparent interface and fixed-denominator wrapper theorem:

```lean
def expandedControlledRyUsesCubicAngleTransparent
    (n workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n

theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n) := by
  intro tier
  exact expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n
```

Do not add a generic helper theorem in this leaf.  Do not refactor
`expandedAmplitudeOracleCleanBlockContract` yet.  Do not prove
`expandedControlledRyUsesCubicAngle`, add an axiom, set a semantic predicate
to `True`, use `trivial` to close an opaque semantic predicate, change the
target operator, or prepare executable exports.

After the edit, run:

```bash
python3 tools/qbe.py check
```

## Lower 3 Packet

Role: necessary-condition verifier.

Allowed scope:

```text
verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/
runs/20260620-101312-QBE-OP-CUBIC-DIAGONAL-001-cycle01/dialogue.md
runs/trials.jsonl through tools/qbe.py trial-log
```

Task:

- Reuse only task-local controlled-`R_y` diagnostics.
- Confirm the standard convention already recorded for the route:
  `theta_j = 2 * arccos((j / 2^n)^3)` and clean entry
  `cos(theta_j / 2) = (j / 2^n)^3`.
- Keep `block_entry_ok`, `unitarity_ok`, `ancilla_cleanup_ok`,
  `root_certificate_ok`, and export fields `null`.
- Record `error_class=symbolic_bridge_gap` unless the Lean worker closes the
  transparent predicate wrappers and the failure class becomes a downstream
  blocked-route note.
- Do not create Qiskit, QuantumKatas-style, QASM3, or other executable export
  artifacts.

Suggested feedback fields:

```text
leaf=DIAG-RY-TRANSPARENT-INTERFACE-001
source_correspondence_ok=true
theta_convention_ok=true
finite_matrix_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
root_certificate_ok=false
exports_ok=false
error_class=symbolic_bridge_gap
next_route=compile the transparent controlled-R_y predicate and fixed-denominator wrapper only; keep opaque route predicate, uncompute, extraction, root, and exports blocked
```

## Coordinator Handoff

This packet promotes one narrow implementation leaf.  It does not certify the
controlled rotation backend, the clean block, unitarity, or the requested
exports.  The next admissible Lean change is the transparent controlled-`R_y`
predicate plus the fixed-denominator wrapper theorem only.
