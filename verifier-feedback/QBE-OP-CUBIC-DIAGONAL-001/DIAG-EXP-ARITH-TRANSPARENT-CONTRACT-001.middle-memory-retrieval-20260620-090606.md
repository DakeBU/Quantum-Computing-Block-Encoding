# Middle Memory Retrieval: DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Timestamp: 2026-06-20 09:06 JST

## Compact Memory State

The active target remains the user-provided diagonal operator
$D_n[row,col] = (row/2^n)^3$ when `row = col` and zero otherwise, with
`exactNormalizer n = 1`.  No paper source, cited theorem, or external
construction hint is active for this cycle.

## Stale Lower Targets To Retire

- `DIAG-ARITH-FIXED-DENOM-CAP-001`, `DIAG-ARITH-FIXED-DENOM-ALG-001`,
  `DIAG-ARITH-FIXED-DENOM-BACKEND-001`, and
  `DIAG-ARITH-ROUTE-TRANSPARENT-001` are closed and must not be reassigned.
- Rebuilding `DIAG-EXPANDED-CONTRACT-001` or the scalar-tier
  `DIAG-EXP-RY-001` bridge is stale; the conditional interfaces already
  compile.
- Direct bridge retry for `fixedDenomCubicArithmeticBackend` is stale unless a
  nontrivial route-semantics bridge is first stated, because
  `fixedDenomCubicArithmeticBackend_bridge_iff` reduces the retry to the old
  opaque route predicate.

## Rejected Routes To Remember

- Rank-one cubic state preparation and normalized cubic vector state
  preparation change the operator target and remain invalid.
- The exact standard `Rat` one-signal/no-workspace primitive witness remains
  rejected by the determinant-square necessary-condition diagnostics.
- Any proof route that sets semantic propositions to `True`, uses an axiom, or
  closes the opaque route predicate by `trivial` is invalid.
- Qiskit, QuantumKatas-style, and QASM3 exports remain blocked until a named
  Lean certificate exists.

## Active Proof-DAG Leaf

`DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001` is the current active leaf.
Dependencies are the closed transparent witness
`expandedArithmeticComputesCubicAmplitudeTransparent` and
`fixedDenomCubicArithmeticRouteTransparent`, plus the existing shape of
`expandedAmplitudeOracleCleanBlockContract`.

The next Lean work is a narrow refactor in
`QuantumBlockEncoding/CubicStatePreparation.lean`: make
`expandedAmplitudeOracleCleanBlockContract` consume
`expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits` as its
arithmetic conjunct.  This does not close rotation backend semantics, clean
uncompute, clean-block extraction, unitarity, root certification, or exports.

## Missing Fields Or Memory Updates

The current typed packet for the active leaf intentionally leaves
`lean_parse_ok`, `lean_build_ok`, `finite_matrix_ok`, `block_entry_ok`,
`ancilla_cleanup_ok`, and `unitarity_ok` as `null` until lower 2 edits Lean or
lower 3 reruns diagnostics.  The next lower attempt should also record
`gate_count`, `depth`, `auxiliary_qubits`, `oracle_calls`, and
`resource_score` as `null` unless the contract refactor changes resource
accounting.

The retrieval index still has `recent_proof_attempts` empty even though the
active proof-attempt packet exists:
`proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001-middle-source-contract-20260620-0857.md`.
Next refresh should keep that path visible in the compact retrieval packet.

## Next-Cycle Retrieval Packet

Read, in order:

1. `runs/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01/memory_digest.md`
2. `runs/20260620-084234-QBE-OP-CUBIC-DIAGONAL-001-cycle01/todo.md`
3. `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001-middle-source-contract-20260620-0857.md`
4. `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXP-ARITH-TRANSPARENT-CONTRACT-001.middle-source-contract-20260620-0857.feedback.json`
5. `research-wiki/retrieval-index/QBE-OP-CUBIC-DIAGONAL-001.json`

Then assign lower 2 only the contract-refactor leaf unless the Lean refactor
fails and produces a concrete error for a refiner.
