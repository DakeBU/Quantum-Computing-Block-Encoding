# 2026-06-13 Lower1 DAG: Finite Path Feeder Shape Audit

Task: `QBE-AUTO-002`  
Run: `20260613-155325-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`

## Source Fragment

The translated source fragment is the GHL2025 boundary Robin paragraph around
Eq. `angles for Ry`, Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`,
Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`.

Definitions from the source fragment:

- Eq. `angles for Ry` defines the boundary rotation angle by
  $\theta_j^s = \arccos(D_j^{(s)} / \mathcal{N}_D)$ for sparse slot
  $s = 0,\dots,\kappa-1$ and boundary indices
  $j < K_1$ or $K_2 < j < 2^n$.
- Eq. `ROBIN clarified` says the displayed boundary part of
  $\ket{\gamma_3}$ carries the clean-ancilla contribution
  $f(x_i) (D)_i^{(s)} \sigma^{(s)} / (\mathcal{N}_D \mathcal{N}_f \kappa)$,
  with the non-displayed branches hidden in the trailing `+ ...`.
- Fig. `fig:1 term ROBIN` contains both sparse-register preparation sides
  $H_W^{(\kappa)}$ and $(H_W^{(\kappa)})^\dagger$, plus the backend gates
  `U_indic`, `O_DT^S`, `Ry_boundary`, `O_D^BS`, `O_f`, `SWAP`,
  and `(O_D^BS)^dagger`.
- Definition `def:block-encoding` is the clean signal projection target.

The active Lean packet extracts only the H-free seven-gate backend component.
It may be consumed by the theorem-facing Fig. 4 route only through the explicit
`Uniform(H)` bridge
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`.

## Definitions

Let

- `row0 := oneTermRobinGamma3BoundaryPrefixRow0_n3`, with value `0`;
- `row1 := oneTermRobinGamma3BoundaryPrefixRow1_n3`, with value `1`;
- `src := oneTermRobinGamma3BoundaryPrefixSource_n3`, with value `32`;
- `P := oneTermRobinGamma3BoundaryPrefixMatrix_n3`;
- `S := oneTermRobinGamma3BoundarySuffixMatrix_n3`;
- `M7 := oneTermRobinGamma3BoundarySevenGateMatrix_n3 = S * P`;
- `ActiveEval(env)` be
  `Coeff.evalWith env ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    row0 row0)`;
- `SelectedContribution(env)` be
  `Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`.

The source slot selected by Eq. `ROBIN clarified` is
`oneTermRobinGamma3BoundaryBranchContributionFocusedSlot = 2`, and the compiled
full-index map sends it to `src = 32` by
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`.

## Path-Name Calibration

| Illustrative name | Existing Lean declaration or thin alias | Status |
|---|---|---|
| `G_UIndic` | `(GHL2025.oneTermRobinGate_U_indic (oneTermParameters 3)).matrix`, or the first matrix inside `GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)` | existing |
| `G_ODTS` | `(GHL2025.oneTermRobinGate_O_DT_S (oneTermParameters 3)).matrix` | existing |
| `G_Ry` | `(GHL2025.oneTermRobinGate_Ry_boundary (oneTermParameters 3)).matrix` | existing |
| `G_ODBS` | `(GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters 3)).matrix` | existing |
| `G_Of` | `(GHL2025.oneTermRobinGate_O_f (oneTermParameters 3)).matrix` | existing |
| `G_SWAP` | `(GHL2025.oneTermRobinGate_SWAP (oneTermParameters 3)).matrix` | existing |
| `G_ODBS_dagger` | `(GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters 3)).matrix` | existing |
| `p0` | active input column `row0` | existing alias |
| `p1` | after `U_indic`, still `row0` for active column `0` | existing support |
| `p2` | after `O_DT^S`, still `row0` for active column `0` | existing support |
| `p3a`, `p3b` | after `Ry_boundary`, rows `row0` and `row1` | two-path |
| `p4a`, `p4b` | after `O_D^BS`, full rows `96` and `97` | two-path |
| `p5a`, `p5b` | `O_f` entries needed by the tail: `O_f[12,96]` and `O_f[12,97]` | both zero in active `[0,0]` path |
| `p6` | after `SWAP`, row `96` on the suffix row-`0` tail | existing support |
| `p7` | final row `row0` after `(O_D^BS)^dagger` | existing support |
| `TailAfterRy` | the compiled suffix/tail support from rows `96` and `97`, especially `oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3`, `oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3`, and `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | existing, mostly private feeders plus public zero theorem |
| `FocusedPathEval` | for active `[0,0]`, the existing normal form is `0`, proved by `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; for source slot `2`, the normal form is the selected contribution from `[32,32]` | split, not one shared normal form |

## Natural-Language Proof

Claim 1: The branch-correct slot-`2` source contribution is the `[32,32]`
seven-gate entry with two sparse-register projection amplitudes attached.

Reason: `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` maps
slot `2` to full basis index `32`.  The selected contribution is defined in
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3` as
`M7[32,32] * sqrt_kappa_inv * sqrt_kappa_inv`.  The selected backend fold
collapses to that contribution by
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`.

Claim 2: The active H-free seven-gate `[0,0]` entry follows a different path.

Reason: At column `0`, `U_indic` and `O_DT^S` are identity on `row0`.
`Ry_boundary` has two support rows, `row0` and `row1`, with factors
`boundary_cos_half_0_0` and `boundary_sin_half_0_0`.  Then `O_D^BS` maps those
rows to full indices `96` and `97`.  On the suffix side, the row-`0` tail
passes through the dagger row support and SWAP to the two function-oracle
entries `O_f[12,96]` and `O_f[12,97]`.  Both entries are zero in the current
finite witness.  This is exactly the content of
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` followed by
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`.

Claim 3: The preferred strict feeder, as currently stated, is not ready for a
Lean closure attempt.

Reason: The strict feeder asks for `ActiveEval(env) = SelectedContribution(env)`
for every `env`.  If `ActiveEval(env)` is bridged to the explicit active
seven-gate entry `M7[0,0]`, the existing support theorem gives
`ActiveEval(env) = 0`.  The selected contribution is instead the branch-correct
slot-`2` object `M7[32,32] * sqrt_kappa_inv * sqrt_kappa_inv`; its compiled
branch evaluation exposes the slot-`2` factor `boundary_cos_half_0_2`, not the
active column-`0` factors.  The paper fragment justifies a prepared sparse-slot
projection/summation route, not a direct H-free equality between slot `0` and
slot `2`.

Therefore the current lower2 target should not be the strict feeder itself.
The next useful Lean leaf is a small evaluated diagnostic bridge that confirms
the active `evalGateMatrices` entry is the same active column-`0` entry already
proved zero.  After that, middle should retarget the theorem-facing route to a
source-prepared projection/summation theorem, or explicitly explain why
`ActiveEval(env)` is not the H-free `M7[0,0]` entry.

## Branch Shape

| Gate or block | Active `[0,0]` shape | Source slot-`2` shape | Consequence |
|---|---|---|---|
| `U_indic` | unique column at `row0` | unique column at `src` | compiled support exists |
| `O_DT^S` | unique column at `row0` | unique column at `src` | compiled support exists |
| `Ry_boundary` | two-path: `row0`, `row1` | two-path before `O_D^BS`: `32`, `33` | do not model `R_y` as unique-column |
| `O_D^BS` | maps `row0,row1` to `96,97` | maps `32,33` to `row0,row1` | branch-dependent indices |
| `O_f` plus tail | active row-`0` tail kills both `96` and `97` through `O_f[12,96] = 0` and `O_f[12,97] = 0` | selected slot-`2` path uses the clean function factor on the surviving branch, while the adjacent branch is killed by `oneTermRobinGamma3BoundarySuffixRow32Col1_zero_n3` | there is no shared focused normal form for active `[0,0]` and selected slot `2` |

## Proof DAG

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_fragment_boundary_gamma3` | paper boundary branch and block-encoding projection | Eq. `angles for Ry`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding` | none | source only | this file | none | read |
| `fig4_backend_split` | distinguish theorem-facing Fig. 4 from H-free seven-gate backend | source audit | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | fig4 visual audit | project gate | proved transcript guard |
| `slot2_selected_contribution` | selected branch contribution is `M7[32,32] * sqrt_kappa_inv^2` | branch index map; projection amplitude packet | none | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | proof obligations | project gate | compiled |
| `backend_fold_to_slot2` | evaluated seven-slot backend fold collapses to selected slot `2` | nonselected slot vanish family | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | proof obligations | project gate | proved |
| `active_col0_explicit_path` | explicit H-free `M7[0,0]` active path is zero | column-`0` prefix support; suffix tail zero | none | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env`; `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3 env` | this file | project gate | proved |
| `eval_gate_matrices_entry_bridge` | evaluated `evalGateMatrices` active `[0,0]` entry equals evaluated explicit `M7[0,0]` | `evalGateMatrices` fold; matrix associativity at `evalWith` level; no raw `Coeff` equality | lower2 | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3 env` | this file | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active diagnostic leaf |
| `active_eval_zero_diagnostic` | `ActiveEval(env) = 0` | `eval_gate_matrices_entry_bridge`; `active_col0_explicit_path` | lower2 after bridge | proposed `oneTermRobinGamma3BoundaryActiveEvalGateMatricesColumn0_zero_n3 env` | this file | same | blocked on bridge |
| `strict_selected_slot_feeder` | `ActiveEval(env) = SelectedContribution(env)` | would need a source-prepared sparse projection/summation bridge, not only H-free active column `0` | none until retargeted | proposed packet name `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env` | middle packet | none | blocked internal, `shape_or_register_gap` |
| `source_prepared_recovery` | recover Fig. 4 source-prepared field under `Uniform(H)` | correct finite feeder; explicit `hUniform` | none until feeder corrected | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | conversion window | project gate after feeder | compiled conditional |

Next active leaf for a Lean worker:

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Then:

```lean
theorem oneTermRobinGamma3BoundaryActiveEvalGateMatricesColumn0_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) = 0
```

This is a diagnostic leaf, not theorem closure.

## Lemma Order

Reuse these existing declarations in order:

1. `GHL2025.oneTermRobinGateMatrixPlaceholders_gateList` and
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
2. `oneTermRobinGamma3BoundaryPrefixRow0_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow1_n3`, and
   `oneTermRobinGamma3BoundaryPrefixSource_n3`.
3. Active column-`0` prefix support:
   `oneTermRobinGamma3BoundaryDUPrefixCol0Support_n3`,
   `oneTermRobinGamma3BoundaryRDUPrefixCol0Support_n3`,
   `oneTermRobinGamma3BoundaryPrefixCol0Support_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3`, and
   `oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3`.
4. Active column-`0` suffix support:
   `oneTermRobinGamma3BoundarySevenGateTwoPath_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`, and
   `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`.
5. Slot-`2` selected contribution support:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`,
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`, and
   `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`.
6. Feeder packaging, only after the target is corrected:
   `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3`
   and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`.

New Lean lemmas, if assigned, should be ordered as:

1. `oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3`.
2. `oneTermRobinGamma3BoundaryActiveEvalGateMatricesColumn0_zero_n3`.
3. Optional diagnostic:
   `oneTermRobinGamma3BoundaryStrictFeeder_forcesSelectedContributionZero_n3`,
   using the existing
   `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`.

Do not add `hUniform` to the strict feeder.  Do not use
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` or
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as theorem closure.

## Failure Analysis

The current strict feeder is a `shape_or_register_gap`.

The paper branch being translated is the prepared sparse-register boundary
branch with selected slot `2`.  The active Lean entry in the strict feeder is
the H-free backend entry at full basis `[0,0]`.  Existing support theorems show
that the explicit seven-gate `[0,0]` entry is a slot-`0` diagnostic path and
evaluates to zero.  Existing selected-contribution definitions show that the
slot-`2` contribution is the `[32,32]` branch entry with sparse projection
amplitudes attached.  These are not the same focused path.

The next route is to certify the evaluated `evalGateMatrices` active entry
against the explicit column-`0` normal form, then have middle retarget the
finite feeder through the source-prepared sparse projection/summation statement
under explicit `Uniform(H)`.  A lower worker should not attempt to prove
`ActiveEval(env) = SelectedContribution(env)` for arbitrary `env` without a new
source-backed register/projection theorem.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `finite_path_feeder` |
| `source_correspondence_ok` | `false_for_strict_hfree_feeder; true_for_source_prepared_route_with_hUniform` |
| `lean_parse_ok` | `not_applicable_no_Lean_edit` |
| `lean_build_ok` | `not_applicable_no_Lean_edit_before_gate` |
| `finite_matrix_ok` | `checked_from_existing_Lean_support_theorems` |
| `block_entry_ok` | `false` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `not_promoted` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `prove evalWith-level evalGateMatrices [0,0] to explicit seven-gate [0,0] bridge, derive active zero diagnostic, then retarget finite feeder through source-prepared projection/summation instead of equating active slot 0 with selected slot 2` |

