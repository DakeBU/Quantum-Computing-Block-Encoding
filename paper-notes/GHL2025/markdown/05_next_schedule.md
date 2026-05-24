# Suggested Schedule After This Export

For the next runs, use fewer reviewer agent calls and keep the Lean build gate.

Recommended inner loop for a 5-hour batch:

- Run upper and middle every cycle.
- Run one lower agent per cycle.
- Skip reviewer agent for ordinary proof-DAG continuation cycles.
- Keep `python3 tools/qbe.py check` after each cycle.
- Run one full reviewer/proof-export cycle at the end of the batch.

Reason: the current work is mostly local Lean proof-DAG closure.  Full reviewer
LLM calls after every small lemma cost many tokens and have diminishing returns.
The build gate plus forbidden-pattern grep catches most immediate regressions.

Use full reviewer cycles when:

- a proof flag changes from `false` to `true`;
- an oracle contract changes;
- a cited result changes status;
- a final block-extraction or unitarity claim is promoted;
- Markdown/LaTeX proof export is updated.

## Current Source-Contract Gate

The SWAP finite-domain permutation bridge is complete.  The accepted Lean
declarations are `GHL2025.swapOracleImage_injective`,
`GHL2025.swapOracleImage_bijective`, the row and column uniqueness lemmas for
`GHL2025.swapOracleMatrix`, and `GHL2025.swapOracleMatrix_is_permutation`.
The gate-level field `(GHL2025.oneTermRobinGate_SWAP p).unitary.proved` is now
`true`.

The remaining critical-path gate is the corrected global-slot $O_D^{BS}$
source contract.  GHL2025 Lemma 1 gives

$$
\hat O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
= |r_{si}\rangle^n|i\rangle^n,
$$

and Fig. 1-term Robin requires $(O_D^{BS})^\dagger$ to restore the padded
zero register after SWAP.  The active Lean address now uses
`oneTermRobinGlobalSparseAddress`, and the active clean source predicate is
`bandedSparseAccessPaperGlobalSlotSource`: padded clean input with sparse slot
$s<\kappa$.  The old row-dependent unused-branch collision is retained only as
rejected-model memory under `QBE.ODBS.UnusedZeroBranchExtension`.

The compiled local route now includes
`oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven`,
`bandedSparseAccessPaperImage_injective_on_globalSlotSource`, and
`bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource`.
The last theorem proves that any active global-source preimage of the
post-SWAP target is the named candidate.  This is still not a semantic cleanup
proof: `BandedSparseAccessGlobalSlotInverseOnRangeContract` keeps its inverse,
unique-preimage, image-injectivity, cleanup, and unitary-extension fields
false.

The current cleanup-route bridges also include
`defaultBandedSparseAccessPaperContract_cleanupRouteBridge`,
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup`,
`bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`,
and the theorem-route wrapper
`oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator`.
The first bridge exposes the candidate post-SWAP cleanup route through the
default Lemma 1 paper contract.  The restricted column theorem packages the
candidate entry `Coeff.rat 1` and zero entries for every other active
global-source row into the same contract post-SWAP column.  The indicator
theorem restates that column as a single if-then-else formula, and the route
wrapper exposes it through `oneTermRobinBlockEncodingProofRoute`.  This is
clean-domain evidence only; all semantic cleanup, unitarity, LCU,
circuit-unitary, projection, and block-correctness flags remain false.

## Next Allowed Lower Packets

Do not assign proof search for $O_D^{BS}$ injectivity, dagger cleanup,
unitarity, or final block extraction against the row-dependent helper
predicates.  The reviewed bridge
`bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge`
now connects the compiled global-source unique-preimage theorem to the
cleanup-route contract fields while keeping every semantic flag false.

Completed narrow packet:

- `bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator`
  now states the non-promoting active-domain indicator theorem.
- `oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator`
  exposes the same theorem through the theorem route while keeping
  `blockProjection.proved`, `blockCorrect.proved`, circuit-unitarity,
  block-extraction, and LCU flags false.
- `bandedSparseAccessPaperValidCleanSource` and
  `bandedSparseAccessPaperUnusedSparseBranch` remain rejected-model or audit
  helpers only.

Completed guard packets:

- `oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface`
  packages the restricted indicator with
  `oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision` and keeps all
  semantic flags false.
- `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard`
  records the prior PDE sparse-access source as transcript-only data: the
  resource claim is unproved, no Robin-specific reversible-extension image rule
  is selected, and lower proof search remains disabled.

Next allowed packet:

- Keep O_D^BS cleanup, injectivity, unitarity, LCU, projection, and
  block-correctness proof search blocked until the full clean-domain or
  full-space contract is sharpened.
- If a full-space extension is needed, add a cited-results row with an exact
  statement and a matching Lean contract before lower work depends on it.
- If no such statement is available, move to another fixed Phase 1 transcript
  block, such as O_DT^S normalizer obligations or O_f source contracts.

Disallowed packets: $O_D^{BS}$ permutation or unitarity over the old
row-dependent image, $O_f$ analytic closure without a formalized cited theorem,
LCU closure, and final block extraction.

## Source Decision Recorded

Middle's 2026-05-24 cleanup-scope packet records the next theorem domain as
active global-source only.  This is a scheduling decision, not a semantic
cleanup proof.  The faithful route still needs one of the following before
O_D^BS work can promote a semantic flag:

| Decision | Effect |
|---|---|
| Completed active global-source interface | compiled guard; still insufficient for semantic cleanup or unitarity promotion |
| Supply a named reversible-extension theorem | add a cited-results row with exact statement and Lean target before lower uses it |
| Approve exploratory work | create a separate exploratory task; do not change the faithful route |
| Supply no proof | keep O_D^BS cleanup, unitarity, and block flags false |

Until then, `QBE.ODBS.UnusedZeroBranchExtension` remains historical
rejected-model memory, not the active lower target.

The block-projection normalizer audit, source-gate freeze guard,
wrapper-slot freeze guard, global-source inverse interface, seven-slot
reverse-address uniqueness block, active-image injectivity block,
post-SWAP unique-preimage block, restricted dagger-column cleanup block,
active-global-source cleanup interface, and prior-PDE transcript guard are now
compiled.  They are scheduling constraints for future work, not permission to
promote O_D^BS cleanup, unitarity, LCU closure, or final block extraction.
