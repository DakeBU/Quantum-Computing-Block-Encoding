# Middle Memory Retrieval: QBE-MAIN-CASE-HIER-PRO-001 Cycle 1

## Active Leaf

`MAINCASE-PRO-CIRCUIT-IMAGE-001`

The refreshed blueprint, proof-obligation ledger, candidate population, and
retrieval index now agree that the next active leaf is circuit/resource contract
alignment for the Pro transcript
`CCX012; CX21; CX20; X2`.

## Retire Or Defer

- Retire repeated lower work on `MAINCASE-PRO-SOURCE-001`,
  `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-PERM-UNITARY-001`,
  `MAINCASE-PRO-CLEANENTRY-001`, `MAINCASE-PRO-BLOCK-001`, and
  `MAINCASE-PRO-RESOURCE-001`; the corresponding task-local Lean artifacts
  already compile.
- Defer `MAINCASE-PRO-ORTHO-BRIDGE-001` and its subleaf
  `MAINCASE-PRO-PERMMATRIX-COL-001` until the advertised transcript is either
  proved to realize `mainCaseProCandidateImage` or demoted to a separate
  gate-derived candidate.
- Keep `MAINCASE-PRO-EXPORT-001` blocked until a named Lean semantic tier is
  accepted.

## Rejected Routes To Remember

- Do not import `OptimalControl.proEqTransfer...` or cold-arm declarations as
  certificates for this isolated Pro task.
- Do not change `mainCaseProTarget`, `mainCaseProSignalIndex`, or
  `mainCaseProExactNormalizer`.
- Do not start Qiskit/QASM3 export, approximate search, depth-2 mutation,
  LCU, sparse-access, dilation, or QSVT work before circuit-image alignment.

## Next-Cycle Packet

Lower 1 should write a branch table for all 16 basis states under the reduced
Pro bits `tau,T,a = 0,1,2`, mapped back to full basis
`signal*8 + 4*T + 2*tau + S`.

Lower 2 should implement exactly one task-local Lean leaf in
`QuantumBlockEncoding/MainCase.lean`: either a theorem connecting the Pro
transcript image to `mainCaseProCandidateImage`, or a clean split between the
finite-permutation clean-block candidate and a corrected gate-derived
candidate.

Lower 3 should run the finite all-state image diagnostic first, with special
attention to dirty columns `8`, `9`, `12`, and `13`, then log the typed fields
listed in the companion JSON packet.
