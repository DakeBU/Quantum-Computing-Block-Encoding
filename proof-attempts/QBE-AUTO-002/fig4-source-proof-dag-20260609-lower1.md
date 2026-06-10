# QBE-AUTO-002 Fig. 4 Source Proof-DAG Packet

Date: 2026-06-09
Role: lower 1, natural-language proof architect
Mode: faithfulPaper
Lean edit status: no Lean edits

## 1. Source Fragment Being Translated

The local source fragment is the one-term Robin theorem route in GHL2025:

| Source anchor | Translated fragment | Proof role |
|---|---|---|
| `main.tex:948-955` | The sparse-register preparation is $H_W^{(\kappa)} \ket{0} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$. | External preparation contract for the two visible $H_W^{(\kappa)}$ sides. |
| `main.tex:1098-1109` | The theorem claims an $(N_D N_f \kappa,\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of $A_k \sim f(x)\partial^m/\partial x^m$. | Root theorem target. |
| `main.tex:1111-1119` | The displayed $\ket{\gamma_3}$ boundary branch carries coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}/(N_DN_f\kappa)$ on the clean ancillas, with other branches hidden in `$+\dots$`. | Focused boundary coefficient target for row $i=0$, column $j=0$, slot $s=2$. |
| `main.tex:1122-1164` | Fig. `1 term ROBIN` applies sparse preparation, `U_indic`, derivative-amplitude or boundary rotation logic, pre-SWAP $O_{D^T}^{BS}$, explicit `U_indic^dagger` cleanup, $O_f$, SWAP, post-SWAP $(O_D^{BS})^\dagger$, and sparse-preparation cleanup. | Theorem-facing circuit transcript. |
| `main.tex:2027-2035` | The block-encoding definition extracts the clean signal block after internal pure-ancilla cleanup. | Projection semantics target. |

The TeX fragment is a theorem statement plus wavefunction/circuit proof sketch,
not a complete finite-entry algebra proof.  The missing finite-entry equality is
therefore a QBE-local semantic bridge, not an external cited theorem.

## 2. Definitions Before Claims

Fix `p = oneTermParameters 3`.  Let `env : String -> Rat` interpret symbolic
`Coeff` expressions.

Let
`U_active = evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)`.
This is the current seven-gate active backend product.  It is not the full
theorem-facing Fig. 4 transcript because it omits the two
$H_W^{(\kappa)}$ sides and the explicit `U_indic^dagger` slot.

Let `H : Matrix 8 8 Coeff` be the sparse-register preparation matrix, and let
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
be the typed all-slot clean-column contract for $H_W^{(\kappa)}$.

Let `clean = oneTermRobinGamma3BoundarySparseCleanIndex_n3` and
`U_prepared = (oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix`.
The theorem-facing prepared clean entry is `U_prepared clean clean`.

Let `B = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.
The compiled bridge
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`
proves `Coeff.evalWith env (U_prepared clean clean) = Coeff.evalWith env B`.

## 3. Natural-Language Proof Of The Active Local Theorem

The local theorem should be stated with the existing clean-column contract.  An
unconditional theorem over arbitrary `H` is not source-faithful.

Target shape for the Lean worker:

```lean
theorem oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_selectedEntryBridge_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env := by
  ...
```

Proof design:

1. Reduce the active side to the uncast active `[0,0]` entry of `U_active`.
   Existing declarations already do this:
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`
   and `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`.

2. Reduce the prepared side to the sparse prepared-sandwich fold.  Existing
   declarations already do this:
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`,
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`,
   and `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.

3. Prove the selected-entry bridge at `Coeff.evalWith` level only.  The active
   entry must be expanded by path isolation, not by raw `Coeff` associativity.
   The compiled two-path lemma
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`
   reduces the explicit seven-gate matrix entry to the two intermediate rows
   `96` and `97`.  The private suffix lemmas
   `oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3` and
   `oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3` identify the suffix
   factors as `O_f[12,96]` and `O_f[12,97]`.

4. The failed gate after this packet exposed a source-index mismatch in the
   in-progress Lean leaf.  The following two statements should **not** be used
   as active leaves:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPrefixMatrix_n3
    (⟨96, by native_decide⟩) oneTermRobinGamma3BoundaryPrefixRow0_n3)
  = env "boundary_cos_half_0_2"

Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPrefixMatrix_n3
    (⟨97, by native_decide⟩) oneTermRobinGamma3BoundaryPrefixRow0_n3)
  = env "boundary_sin_half_0_2"
```

   They are false for the current matrix/register convention: column `0` has
   sparse-register value `0`, so the `Ry_boundary` entries at that column are
   the slot-`0` half-angle symbols, not the slot-`2` symbols used by the
   displayed boundary branch.  This means the active seven-gate `[0,0]` entry is
   not the same object as the prepared all-slot clean entry.

5. The next Lean worker should first record the actual column-`0` prefix
   entries or move the in-progress lemmas after their support lemmas only if the
   statements are corrected to slot `0`:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPrefixMatrix_n3
    (⟨96, by native_decide⟩) oneTermRobinGamma3BoundaryPrefixRow0_n3)
  = env "boundary_cos_half_0_0"

Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPrefixMatrix_n3
    (⟨97, by native_decide⟩) oneTermRobinGamma3BoundaryPrefixRow0_n3)
  = env "boundary_sin_half_0_0"
```

   These corrected lemmas are diagnostic/support only.  They do not close the
   source-prepared gamma3 slot-`2` theorem.

6. If the source-prepared route still needs the slot-`2` branch, the active
   entry must be reindexed to the slot-`2` column, already represented by the
   branch source index used in
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`, or
   the theorem-facing matrix must use the prepared sandwich with explicit
   $H_W^{(\kappa)}$ sides.  Do not prove a bridge from seven-gate column `0` to
   the all-slot prepared clean entry by assuming slot `2` at column `0`.

7. After the index alignment is fixed, a selected-entry bridge can be attempted
   by rewriting the two-path expression:

```text
U_active[0,0]
  = O_f[12,96] * prefix[96,0]
  + O_f[12,97] * prefix[97,0]
```

   This expression is a column-`0` diagnostic unless the target theorem is
   explicitly about sparse slot `0`.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_slots` | Source-facing transcript exposes $H_W^{(\kappa)}$, `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, post-SWAP $(O_D^{BS})^\dagger`, and final $(H_W^{(\kappa)})^\dagger`. | Fig. `1 term ROBIN`; `indicatorOracleImage_self_inverse`. | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`, `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | `conversion-windows/QBE-AUTO-002.md` | `python3 tools/qbe.py check` | proved |
| `active_backend_guard` | Active backend remains seven gates and is not called the full Fig. 4 transcript. | Existing `oneTermRobinCircuit` and placeholders. | middle | `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | `conversion-windows/QBE-AUTO-002.md` | `python3 tools/qbe.py check` | proved |
| `hw_uniform_contract` | $H_W^{(\kappa)}$ clean column is uniform on the seven paper slots. | `main.tex:948-955`; Shukla--Vedula cited preparation. | external | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results `Shukla--Vedula` row | no recursive proof this batch | blocked external, typed contract |
| `prepared_clean_to_backend_eval` | Prepared singleton clean entry evaluates to backend branch fold under `hUniform`. | `hw_uniform_contract`; prepared sandwich definitions. | QBE | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | `conversion-windows/QBE-AUTO-002.md` | `python3 tools/qbe.py check` | proved |
| `active_uncast_reduction` | Signal-zero block entry reduces to uncast `U_active[0,0]`. | block-extraction index bridge. | QBE | `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3` | `conversion-windows/QBE-AUTO-002.md` | `python3 tools/qbe.py check` | proved |
| `active_two_path_eval` | Explicit seven-gate product `[0,0]` has only intermediate rows `96` and `97`. | `Matrix.evalWith_mul_two_path`; prefix support. | QBE | `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3` | `proof-attempts/QBE-AUTO-002/column0-two-path-analysis.md` | `python3 tools/qbe.py check` | proved |
| `suffix_96_97_eval` | Suffix entries reduce to `O_f[12,96]` and `O_f[12,97]`. | dagger row-0 support; SWAP row-96 support. | QBE | private `oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3`, private `oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3` | this packet | focused Lean build | proved, private |
| `prefix_96_slot2_eval` | Prefix entry `prefix[96,0]` evaluates to `boundary_cos_half_0_2`. | Assumes slot `2` at column `0`. | none | in-progress `oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3` | this packet | `python3 tools/qbe.py check` | contract drift; false as stated |
| `prefix_97_slot2_eval` | Prefix entry `prefix[97,0]` evaluates to `boundary_sin_half_0_2`. | Assumes slot `2` at column `0`. | none | in-progress `oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3` | this packet | `python3 tools/qbe.py check` | contract drift; false as stated |
| `prefix_col0_actual_slot_audit` | Record actual column-`0` prefix entries as slot-`0` cosine/sine, or choose the source slot-`2` entry instead. | `boundaryRotationMatrix` definition; support lemmas. | lower 2 | proposed diagnostic audit theorem or corrected leaf | this packet | `python3 tools/qbe.py check` | next active leaf |
| `selected_evalwith_bridge` | `Coeff.evalWith env U_active[0,0]` equals the prepared sandwich selected entry. | Requires source-index alignment first. | lower 2 | proposed theorem feeding `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` | this packet | `python3 tools/qbe.py check` | blocked internal |
| `active_prepared_eval` | Preferred uncast active/prepared statement. | `selected_evalwith_bridge`. | lower 2 | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | conversion window active leaf | `python3 tools/qbe.py check` | blocked internal |
| `evaluated_backend_fold` | Source-correct evaluated backend fold follows from active/prepared statement. | `active_prepared_eval`, `prepared_clean_to_backend_eval`, `hUniform`. | QBE | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3` | conversion window | `python3 tools/qbe.py check` | proved as conditional |
| `raw_coeff_fold_route` | Raw constructor equality for matrix associativity. | symbolic `Coeff` associativity that does not hold. | none | `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `evalGateMatrices-associativity-attempt.md` | none | stale diagnostic |

Next active leaf for the Lean worker:
repair the source-index alignment by proving the actual column-`0` prefix
entries as slot `0`, or by switching the selected active entry to the existing
slot-`2` branch source.  Do not continue with the current slot-`2` statements
for column `0`.

## 5. Ordered Lean Lemmas For The Worker

1. Reuse `Matrix.evalWith_mul_unique_path`,
   `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`, and
   `Matrix.evalWith_mul_two_path` from `CircuitSemantics.lean`.
2. Reuse `oneTermRobinGamma3BoundaryDUPrefixCol0Support_n3`,
   `oneTermRobinGamma3BoundaryRDUPrefixCol0Support_n3`, and
   `oneTermRobinGamma3BoundaryPrefixCol0Support_n3`.
3. If retaining column `0`, add corrected diagnostic lemmas for
   `boundary_cos_half_0_0` and `boundary_sin_half_0_0`, after the support
   declarations they reuse.  The current worktree placed those lemmas before
   `oneTermRobinGamma3BoundaryIndicatorCol0_support_n3`,
   `oneTermRobinGamma3BoundaryDUPrefixCol0Support_n3`,
   `oneTermRobinGamma3BoundaryODBSCol0_support_n3`, and
   `oneTermRobinGamma3BoundaryODBSCol1_support_n3`, which makes the build fail.
4. If the target is the displayed gamma3 slot `2`, reuse the existing slot-`2`
   branch source path around
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`
   instead of column `0`.
5. Reuse private `oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3`,
   private `oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3`, and
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`.
6. Add the selected-entry `evalWith` bridge.  The bridge should rewrite only at
   `Coeff.evalWith` level and should not attempt raw equality of
   `evalGateMatrices` and `oneTermRobinGamma3BoundarySevenGateMatrix_n3`.
7. Reuse
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`
   and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
   to feed the theorem-facing route.

## 6. Failure Analysis

The theorem
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`
should not be attempted as an unconditional theorem for arbitrary `H`.  The
source paper fixes $H = H_W^{(\kappa)}$, and the Lean route represents that by
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
Without that contract, the prepared clean entry can be an arbitrary matrix
entry and need not equal the active seven-gate entry.

The post-packet gate failure shows a sharper obstruction: the in-progress Lean
leaf tries to identify the column-`0` prefix with slot-`2` boundary half-angle
symbols.  The `boundaryRotationMatrix` definition computes the sparse value
from the input column.  For column `0`, that sparse value is `0`, so the slot-`2`
statements are false.  This is a branch/index mismatch, not a tactic failure.

The raw constructor equality
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` remains
diagnostic/backlog.  It asks symbolic `Coeff` expressions with different
parenthesization and an explicit identity multiplication to be definitionally
equal.  This is not a valid route because `Coeff.add` and `Coeff.mul` are
constructors; associativity and identity laws only hold after `Coeff.evalWith`.

The active seven-gate backend is not the full theorem-facing Fig. 4 circuit.
The corrected transcript keeps the two $H_W^{(\kappa)}$ sides and
`U_indic^dagger` visible.  Any Lean theorem that claims the full source circuit
from the seven-gate product alone should be rejected as transcript drift.

## 7. Handoff

Lower 1 completed the source-line proof-DAG packet and then ran the required
gate.  No Lean declarations were edited by lower 1.  The gate failed in
pre-existing in-progress Lean edits around `RobinMatrix.lean:7134-7372`: a tab
is present, several support lemmas are referenced before declaration, and the
slot-`2` half-angle goals at column `0` are false.  The next lower worker should
repair the index alignment before attempting the selected-entry evalWith bridge.
