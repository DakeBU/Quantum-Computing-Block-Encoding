# Middle Memory Retrieval: Cycle 2

## Stale Lower Targets

`MAIN-CLEAN-ENTRY-001`, `MAIN-PERM-UNITARY-001`,
`MAIN-BLOCK-PROJECTION-001`, `MAIN-RESOURCE-001`, and
`MAIN-CANDIDATE-PACKAGE-001` are closed or stale.  A Lean worker should not
edit `QuantumBlockEncoding/MainCase.lean` for the current export leaf.

## Rejected Routes

Reject Pro-arm evidence, prior executable exports, target mutation,
simulator-only theorem claims, and using logical label order as Qiskit integer
wire order.  LCU, sparse access, QSVT, dilation, and approximate search remain
insight-pool alternatives only; they are not active repairs.

## Active Leaf

The active leaf is `MAIN-EXPORT-MAP-001`, then
`MAIN-EXPORT-IMPLEMENT-001`, then `MAIN-EXPORT-VERIFY-001`.  Its Lean
dependencies are `mainCaseColdPartialPermVerified`,
`mainCaseColdPartialPermCandidate_cost`,
`mainCaseColdCircuitImage_eq_partialPermImage`, `mainCaseColdPartialPermImage`,
`mainCaseColdTarget`, and `mainCaseColdPartialPermCost_*`.

The export map must compare basis actions with the Lean index
`8*signal + 4*T + 2*tau + S`.  Thus Qiskit integer wires are `q[0]=S`,
`q[1]=tau`, `q[2]=T`, and `q[3]=signal`.

## Missing Typed Fields

The previous export feedback correctly recorded artifact absence, but the next
accepted export verifier should also record `gate_count=5`, `depth=5`,
`auxiliary_qubits=1`, `oracle_calls=0`, `qasm3_ok`, `forbidden_reference_ok`,
and the actual export wire map.  The old `T=0,tau=1,S=2,signal=3` integer-map
route is a `shape_or_register_gap`.

## Next Retrieval Packet

Lower export workers should read the corrected export plan, the lower architect
packet, the export verifier script, and the compiled COLD declarations.  Write
only under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/` and
`verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`, then run the export checker
and the project gates.
