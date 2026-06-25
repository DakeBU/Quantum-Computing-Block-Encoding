# Middle Cycle 2 Memory Retrieval: QBE-MAIN-CASE-HIER-PRO-001

## Stale Lower Targets

- Retire `MAINCASE-PRO-CIRCUIT-IMAGE-001` as an implementation target.  The
  candidate split is compiled, and `mainCaseProCircuitImage_eq_candidate` is
  refuted by `mainCaseProCircuitImage_not_pointwise_candidate`.
- Retire broad rediscovery of `MAINCASE-PRO-BLOCK-001`; the clean-block package
  is already compiled through `mainCaseProExactCleanBlock_correct` and
  `mainCaseProCandidate_blockProjection`.
- Keep `MAINCASE-PRO-EXPORT-001` blocked until the accepted Lean semantic tier
  is named.  Do not start Qiskit or QASM3 artifacts in the next lower cycle.

## Rejected Routes To Remember

- The route "Pro transcript equals `mainCaseProCandidateImage` on all 16
  states" is false.  The dirty columns are `8`, `9`, `12`, and `13`; the clean
  block remains correct.
- Importing `OptimalControl.proEqTransfer...` or cold-start declarations as a
  proof for this isolated task is not allowed.
- LCU, sparse-access, dilation, and QSVT routes remain archived alternatives;
  they should not displace the partial-permutation route unless the current
  bridge is falsified.

## Active Proof-DAG Leaf

| Node | Interface | Dependencies | Owner | Lean declaration | Gate | Status |
|---|---|---|---|---|---|---|
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Promote the finite bijection certificates for `permMatrix` to rational orthogonality. | `MAINCASE-PRO-PERM-UNITARY-001`, `MAINCASE-PRO-CIRCUIT-IMAGE-001`, compiled clean-block/resource leaves | lower 2/refiner, with lower 1 proof packet and lower 3 finite Gram checks | `mainCaseProRationalOrthogonalBridgeObligation` | `python3 tools/qbe.py check` plus `lake build && lake build Tests` | active next bridge |

The intended proof split is column Gram from injectivity and row Gram from
surjectivity.  No external cited theorem is needed for this active leaf.

## Missing Typed Feedback Fields

The next lower attempt should record a fresh cycle-2 feedback row for
`MAINCASE-PRO-ORTHO-BRIDGE-001` with these fields:

- `leaf=MAINCASE-PRO-ORTHO-BRIDGE-001`
- `source_correspondence_ok=true`
- `lean_parse_ok`
- `lean_build_ok`
- `finite_matrix_ok`
- `block_entry_ok=true`
- `ancilla_cleanup_ok=true`
- `normalizer_ok=true`
- `unitarity_ok`
- `resource_score=(4,4,1,0)`
- `auxiliary_qubits=1`
- `gate_count=4`
- `depth=4`
- `oracle_calls=0`
- `closed_theorem_ok`
- `error_class=symbolic_bridge_gap` until the bridge closes
- `next_route` naming one reusable theorem or one task-local fallback

## Next-Cycle Retrieval Packet

Read these artifacts first in the next cycle:

1. `runs/20260625-234024-QBE-MAIN-CASE-HIER-PRO-001-cycle02/todo.md`
2. `proof-obligations/QBE-MAIN-CASE-HIER-PRO-001.md`
3. `conversion-windows/QBE-MAIN-CASE-HIER-PRO-001.md`
4. `candidate-populations/QBE-MAIN-CASE-HIER-PRO-001.md`
5. `verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/middle-cycle02-memory-retrieval.feedback.json`

Recommended split: lower 1 writes the orthogonality proof-DAG packet, lower 2
implements one bridge leaf only, and lower 3 checks finite row and column Gram
diagnostics before any broad Lean search.
