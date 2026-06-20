# Middle Memory Retrieval: DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`  
Updated: 2026-06-20 12:54 JST

## Stale Lower Targets To Retire

`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` is closed as an interface-only
leaf.  The compiled declarations are `ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness`.

Do not reassign the closed arithmetic and rotation transparent leaves:
`DIAG-ARITH-FIXED-DENOM-BACKEND-001`,
`DIAG-ARITH-ROUTE-TRANSPARENT-001`,
`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001`,
`DIAG-RY-TRANSPARENT-INTERFACE-001`, and
`DIAG-RY-TRANSPARENT-CONTRACT-001`.

Do not send lower workers to direct bridge retries for
`fixedDenomCubicArithmeticBackend_bridge_iff` or
`expandedControlledRyBackendBridge_iff_of_standardTier`.  Those normal forms
reduce the work to opaque route predicates.

## Rejected Routes To Remember

The rank-one cubic state-preparation route and normalized cubic-vector route do
not match the diagonal operator target.

The exact standard `Rat` one-signal/no-workspace primitive witness remains
rejected by determinant-square diagnostics for `n = 1, 2, 3`.

Opaque semantic predicates must not be closed by `trivial`, by an axiom, or by
setting a semantic proposition to `True`.  Executable exports remain blocked
until a named Lean certificate exists.

## Active Proof-DAG Leaf

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Instantiate `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` for fixed-denominator modular add/sub cleanup. | `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`; `fixedDenomCubicArithmeticBackend`; `fixedDenomCubicArithmeticBackend_computes`; `fixedDenomCubicPayload_lt_capacity`; `fixedDenomCubicAmplitude_eq`; modular add/sub arithmetic | lower-2 Lean worker | planned witness of `ExpandedArithmeticCleanUncomputeWitness n (3 * n)` plus derived theorem through `expandedWorkspaceCleanUncomputedTransparent_of_witness` | `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md`; `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md` | `python3 tools/qbe.py check` | active leaf |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled signal rotation reads the payload and does not modify workspace or system index. | transparent rotation bookkeeping; route register semantics | lower architect/verifier before route cleanup closure | no current declaration | same files | `python3 tools/qbe.py check` | blocked internal dependency |
| `DIAG-EXP-UNCOMP-001` | Route-level clean uncompute. | fixed-denominator transparent cleanup witness plus rotation workspace-readonly semantics | future lower worker | opaque target `expandedWorkspaceCleanUncomputed` or later explicit contract refactor | proof-obligation ledger | `python3 tools/qbe.py check` | blocked parent |

## Missing Typed Fields Or Memory Cards

The next lower implementation feedback should include
`finite_mod_add_sub_cleanup_ok`, `rotation_workspace_readonly_ok`, and
`lean_rotation_workspace_readonly_statement_present`.

Keep `block_entry_ok`, `clean_block_extraction_ok`, `unitarity_ok`,
`root_certificate_ok`, and `exports_ok` null or false until the corresponding
Lean declarations exist.

The run directory needed compact `memory_digest.md` and `todo.md` refreshes;
this middle pass adds them.

## Next-Cycle Retrieval Packet

Read first:

- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001.middle-source-contract-20260620-1244.md`
- `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md`
- `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md`
- `candidate-populations/QBE-OP-CUBIC-DIAGONAL-001.md`
- `proof-blueprints/QBE-OP-CUBIC-DIAGONAL-001.md`

Lower 2 should implement exactly the fixed-denominator transparent cleanup
witness.  Lower 3 should run only modular add/sub cleanup and rotation
workspace-readonly diagnostics.  There is no scaling increase recommendation;
schedule lower 4 only after a concrete Lean failure.
