# QBE-AUTO-002 Slot-2 To Signal-Zero Proof-DAG Update

Date: 2026-06-09
Role: lower 1, natural-language proof architect
Mode: faithfulPaper
Lean edit status: no Lean edits

## 1. Source Fragment Being Translated

This packet translates the source-facing one-term Robin route after the Fig. 4
transcript correction and after the column-`0` prefix facts were accepted as
slot-`0` diagnostics.

| Source anchor | Fragment | Proof role |
|---|---|---|
| `main.tex:948-955` | Eq. `arbitrary sparcity`: $H_W^{(\kappa)}|0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle$. | Supplies the clean-column preparation contract for both sparse-register sides. |
| `main.tex:1098-1109` | Theorem `1 term robin`: the circuit should be an $(N_D N_f \kappa, \lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of $A_k$. | Root theorem target, not closed in Lean. |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`: the displayed $\gamma_3$ clean boundary branch has coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}/(N_DN_f\kappa)$. | Branch-correct coefficient target.  The focused Lean slot is $s=2$, row/column full basis index `32`. |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`: the theorem-facing circuit includes $H_W^{(\kappa)}$, `U_indic`, branch derivative/rotation gates, pre-SWAP $O_{D^T}^{BS}$, explicit `U_indic^dagger`, $O_f$, SWAP, post-SWAP $(O_D^{BS})^\dagger$, and $H_W^{(\kappa)\dagger}$ cleanup. | Gate-order transcript.  The compiled seven-gate active backend is not the full theorem-facing circuit. |
| `main.tex:2027-2035` | Definition `def:block-encoding`: the clean signal block is extracted after internal pure-ancilla cleanup. | Projection target.  This is where the sparse-register sum must enter. |

The source proof fragment is not a claim about a single sparse-register column
`0`.  It first prepares a superposition over all sparse slots, applies the
branch-specific seven-gate derivative/function product, and then cleans the
sparse preparation.  Therefore the displayed slot-`2` branch at full basis
index `32` is a summand of the theorem-facing prepared projection, while the
active seven-gate entry `[0,0]` is only the slot-`0` diagnostic column.

## 2. Definitions Before Claims

Fix `p = oneTermParameters 3` and an environment `env : String -> Rat`.

Let `U7` denote the seven-gate active backend matrix
`oneTermRobinGamma3BoundarySevenGateMatrix_n3`.  This matrix omits the two
$H_W^{(\kappa)}$ sides and the explicit theorem-facing transcript label
`U_indic^dagger`, although the dagger label has a compiled self-inverse bridge
in `GHL2025`.

Let `slotIndex s` be
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s`.  The compiled selected
slot theorem says
`slotIndex oneTermRobinGamma3BoundaryBranchContributionFocusedSlot =
oneTermRobinGamma3BoundaryPrefixSource_n3`, and this full basis index has value
`32`.

Define the backend branch summand
`B s = oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s`.  By
definition,
`B s = U7[slotIndex s, slotIndex s] * sqrt_kappa_inv * sqrt_kappa_inv`.
The selected-slot theorem
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` proves the
slot-`2` summand is the accepted branch contribution.

Let
`PreparedSum H = oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`.
Under
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
the compiled theorem
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`
proves:

$$
\operatorname{eval}(PreparedSum(H))
=
\operatorname{eval}\left(\sum_{s=0}^{6} B(s)\right).
$$

Let `SignalEntry` be
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`.
The current source-facing missing bridge is not the slot-`2` branch evaluation,
which is already typed.  It is the projection/summation theorem that connects
`SignalEntry` to the seven-slot fold.

## 3. Natural-Language Proof Of The Active Local Theorem

The branch-correct local theorem should be stated at evaluation level:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Equivalently, after the compiled uncast reduction, it is:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
=
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

The source proof justifies the right-hand side as follows.  The clean
sparse-register preparation creates amplitude `sqrt_kappa_inv` for each
paper slot $s=0,\ldots,6$.  The adjoint cleanup contributes the matching bra
amplitude.  For each slot, the seven-gate derivative/function product is read
at the full branch basis index `slotIndex s`; for the displayed gamma3 branch,
slot `2` has index `32`.  Thus the theorem-facing prepared entry is the
seven-slot fold over `B s`, and the slot-`2` displayed equation is exactly one
summand of that fold.

The proof does **not** follow from the active column-`0` prefix facts.  Those
facts prove that the uncast seven-gate column `0` sees sparse slot `0`, with
symbols `boundary_cos_half_0_0` and `boundary_sin_half_0_0`.  Eq. `ROBIN
clarified` for the displayed focused branch uses slot `2`.  A proof that
identifies the slot-`2` source branch with column `0` would be a branch
mismatch.

Therefore a Lean worker has two source-faithful options:

1. Prove a genuine projection/summation backend theorem at `Coeff.evalWith`
   level, showing that the signal-zero theorem-facing entry is the evaluated
   seven-slot branch fold.
2. If the current Lean target reduces the theorem-facing entry to the raw
   seven-gate `[0,0]` entry before the $H_W^{(\kappa)}$ sides are applied,
   record this as a contract mismatch and introduce a theorem-facing prepared
   entry target instead of proving the false equality.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Class | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|---|
| `fig4_transcript_slots` | Theorem-facing gate list exposes both $H_W^{(\kappa)}$ sides, `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, post-SWAP $(O_D^{BS})^\dagger`. | Fig. `1 term ROBIN`; indicator self-inverse bridge. | GHL-internal transcript | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`, `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | `conversion-windows/QBE-AUTO-002.md` | `python3 tools/qbe.py check` | proved |
| `active_backend_guard` | Seven-gate active backend remains a finite semantics backend, not the full Fig. circuit. | Existing active placeholder list. | QBE-local semantic bridge | middle | `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | conversion window | `python3 tools/qbe.py check` | proved |
| `hw_clean_column_contract` | $H_W^{(\kappa)}$ clean column has amplitude `sqrt_kappa_inv` on all seven paper slots. | Eq. `arbitrary sparcity`; Shukla--Vedula citation. | external-cited-contract | external | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger | no recursive proof this batch | contract-only |
| `slot2_source_path` | Displayed gamma3 branch uses sparse slot `2` and full basis entry `[32,32]`. | Eq. `ROBIN clarified`; branch index map. | GHL-internal branch, QBE-local index bridge | lower | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `slot2_branch_eval` | Seven-gate entry `[32,32]`, with projection amplitudes, evaluates to the route's projected product under the corrected Ry coefficient hypothesis. | Selected branch entry; corrected coefficient interface. | QBE-local semantic bridge | lower | `oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3`, `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3` | proof obligations | `python3 tools/qbe.py check` | conditional, compiled |
| `backend_all_slot_family` | Define all seven summands `B s` from `U7[slotIndex s, slotIndex s]` and sparse projection amplitudes. | Branch full-index map; selected-slot theorem. | QBE-local semantic bridge | lower | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, `oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3_transcript` | proof obligations | `python3 tools/qbe.py check` | proved interface |
| `prepared_sum_to_backend_fold` | Under `hUniform`, `PreparedSum H` evaluates to the backend seven-slot fold. | `hw_clean_column_contract`; all-slot backend family. | QBE-local semantic bridge using external contract | lower | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`, `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | conversion window | `python3 tools/qbe.py check` | proved conditional |
| `column0_slot0_diagnostic` | Active seven-gate `[0,0]` prefix sees slot `0`, not slot `2`. | Column-`0` support and two-path lemmas. | QBE-local diagnostic | lower | `oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3`, `oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3` | conversion window post-prefix sync | `python3 tools/qbe.py check` | proved diagnostic |
| `signal_zero_branch_sum_eval` | Evaluation-level theorem: `SignalEntry` evaluates to the seven-slot backend fold. | Backend all-slot family; projection convention; prepared transcript discipline. | QBE-local semantic bridge | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or a smaller theorem feeding it | this packet and obligations ledger | `python3 tools/qbe.py check` | next active leaf, but only if LHS is theorem-facing prepared signal entry |
| `active_prepared_eval` | Under `hUniform`, evaluated backend fold is equivalent to the active/source-prepared singleton field. | `signal_zero_branch_sum_eval`; prepared sum bridge. | QBE-local route wiring | lower 2 | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3` | conversion window | `python3 tools/qbe.py check` | compiled equivalence |
| `raw_coeff_fold_route` | Raw constructor equality between symbolic `Coeff` products. | Old associativity route. | stale diagnostic | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `evalGateMatrices-associativity-attempt.md` | none | stale, do not assign |

Next active leaf for a Lean worker:
prove an evaluation-level branch-sum theorem feeding
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, or first add
a typed mismatch/obligation record if Lean still reduces the theorem-facing
left-hand side to the seven-gate column-`0` entry before the
$H_W^{(\kappa)}$ sides are applied.

## 5. Ordered Intermediate Lean Lemmas

1. Reuse the transcript guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`, and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`.
2. Reuse the slot-`2` branch path:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`,
   and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.
3. Reuse the all-slot backend family:
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_selectedClause_n3`,
   and
   `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_targetProjection_n3`.
4. Reuse the prepared-sandwich specialization:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   and
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
5. Reuse the route equivalences:
   `oneTermRobinGamma3BoundaryBackendProjectionStatement_equivBranchSum_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`,
   `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3`,
   and
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3`.
6. Do not use `oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3` or
   `oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3` to justify the
   displayed slot-`2` gamma3 branch.  They are slot-`0` diagnostics only.
7. If a worker attempts the uncast active/prepared theorem, first check whether
   the left-hand side is the theorem-facing prepared signal entry.  If it is
   only `evalGateMatrices` at `[0,0]` for the seven-gate active backend, stop
   and record the mismatch instead of proving an equality to the all-slot
   prepared fold.

## 6. Failure Analysis And Routing

The direct target
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`
is unsafe if read literally as:

```lean
eval((seven-gate active backend)[0,0]) =
eval((H_W^dagger * seven-gate backend * H_W)[clean,clean])
```

The left side has already been audited as a column-`0`/slot-`0` active entry.
The right side is an all-slot prepared sparse-register sandwich.  For arbitrary
symbolic coefficient environments, a slot-`0` entry is not the same object as
the seven-slot prepared sum.  The source paper obtains the seven-slot sum from
the two $H_W^{(\kappa)}$ sides in the theorem-facing circuit, not from the
seven-gate backend alone.

This is not an external citation gap.  The external Shukla--Vedula contract
supplies only the clean-column amplitudes.  The missing step is QBE-local:
the finite matrix semantics must expose a theorem-facing prepared signal entry
or an evaluation-level projection/summation theorem that inserts the
$H_W^{(\kappa)}$ sides before comparing to the backend fold.

The raw `Coeff` equality route remains diagnostic.  Because `Coeff` stores
symbolic sums and products as constructors, associativity and identity
normalization are valid only after `Coeff.evalWith`.

## 7. Handoff

Lower 1 updated the branch-correct proof design.  The displayed gamma3 slot
`2` path is the full basis entry `[32,32]` and is already connected to the
selected backend summand.  The column-`0` prefix lemmas are true but diagnose
slot `0`; they must not be used for the displayed slot-`2` coefficient.

Next Lean worker should target the evaluation-level branch-sum/projection
bridge only if the left-hand side is theorem-facing and includes the prepared
sparse-register semantics.  If the target still reduces to the seven-gate
`[0,0]` entry, record a typed mismatch/obligation instead of trying to prove
slot `0` equals the all-slot prepared sandwich.
