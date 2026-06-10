# QBE-AUTO-002 Finite Active-To-Prepared Composition DAG

Date: 2026-06-09
Role: lower 1, natural-language proof architect
Mode: faithfulPaper
Run: `20260609-154329-QBE-AUTO-002-cycle01`
Lean edit status: no Lean edits

## 1. Source Fragment Being Translated

This packet uses the local GHL2025 TeX source at the public anchors below.  The
machine-local archive path was only used for reading; public proof maps should
cite the arXiv paper and these source anchors.

| Source anchor | Source fragment or equation | Translation role |
|---|---|---|
| `main.tex:948-955` | Eq. `arbitrary sparcity`: $H_W^{(\kappa)} |0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle$, with Shukla--Vedula cited for $O(\log \kappa)$ implementation cost. | External all-slot sparse-register clean-column contract. |
| `main.tex:1098-1109` | Theorem `1 term robin`: constructs an $(N_D N_f \kappa,\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of $A_k$. | Root theorem target; not closed in Lean. |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`: the boundary part of $|\gamma_3\rangle$ has coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}/(N_D N_f \kappa)$ and is summed over $s=0,\ldots,\kappa-1$. | Backend fold and slot-`2` branch map; denominator $\kappa$ comes from both sparse-preparation sides. |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`: theorem-facing circuit includes both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}$, post-SWAP $(O_D^{BS})^\dagger`, and cleanup. | Transcript guard; the active seven-gate backend is not the full theorem-facing prepared circuit. |
| `main.tex:2027-2035` | Definition `def:block-encoding`: the clean signal block is projected after pure-ancilla cleanup. | Justifies selecting the prepared clean entry; does not delete the two $H_W$ sides. |

The active local Lean frontier is:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

or the smaller fields

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

The source fragment being translated does not contain a proof that the H-free
active seven-gate `[0,0]` entry already equals the all-slot prepared
$H_W^\dagger U H_W$ clean entry.  It contains the full prepared transcript.

## 2. Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and

```lean
hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The hypothesis `hUniform` is the typed Lean contract for Eq. `arbitrary
sparcity`; it is not a Lean proof of the Shukla--Vedula preparation circuit.

Let `Uactive` be

```lean
evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))
```

and let `Active00(env)` be

```lean
Coeff.evalWith env
  (Uactive oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `Pprepared(H)` be

```lean
(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
```

and let `Prepared00(H, env)` be its clean-clean evaluated entry:

```lean
Coeff.evalWith env
  (Pprepared(H)
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `Sandwich(H)` be

```lean
oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H
```

and let `BackendFold` be

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled slot map names the displayed source branch:

```lean
oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3
oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3
```

It maps source slot `2` to full basis `[32,32]`.  This is not the column-`0`
slot-`0` diagnostic path.

## 3. Natural-Language Proof Status

### Proven Prepared-Entry Route

Claim: under `hUniform`, the theorem-facing prepared clean entry evaluates to
the backend fold.

Proof: the prepared singleton clean entry is definitionally connected to the
prepared sparse-register clean entry by
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
The prepared sparse-register clean entry unfolds to `Sandwich(H)` by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.  The
all-slot clean-column contract specializes `Sandwich(H)` to `BackendFold` by
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
The route is packaged at the source-prepared target by
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`
and at the evaluated target by
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3`.

This is the source-correct use of Eq. `arbitrary sparcity` and Definition
`def:block-encoding`.

### Current Active-To-Prepared Target

Claim requested by the current Lean frontier:

```text
Active00(env) = Prepared00(H, env)
```

This target has no direct source-paper proof in the fragment above.  The paper
uses both sparse-preparation side gates in the theorem-facing Fig. 4 circuit.
The Lean active backend list is guarded by
`oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`, so `Active00`
is the H-free seven-gate `[0,0]` entry.

Existing Lean already proves the key reduction:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
```

Under `hUniform`, the uncast active/prepared statement is equivalent to

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Therefore the active-to-prepared target is not a smaller theorem than the
H-free evaluated backend fold.  It is another interface for the same finite
projection/summation obstruction.

### Consequence For The Lean Worker

A Lean proof of
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`
would need to prove the evaluated backend fold, or an equivalent raw-entry
prepared-sandwich field.  Column-`0` slot-`0` diagnostics are insufficient,
because Eq. `ROBIN clarified` is represented in the current proof map by the
slot-`2` branch at `[32,32]`, while the active `[0,0]` path omits the
preparation sum over all seven sparse slots.

The source-faithful classification is:

```text
finite_active_to_prepared_composition = blocked internal QBE-local finite matrix semantics
```

It is not an external Shukla--Vedula, Gilyen/LCU, sparse-oracle,
function-oracle, or block-projection gap.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Dependency class | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | The theorem-facing transcript exposes both $H_W$ sides, `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, post-SWAP $(O_D^{BS})^\dagger`, and cleanup. | `main.tex:1122-1164`; indicator self-inverse bridge. | GHL-internal transcript plus QBE-local bridge | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window; middle packet | `python3 tools/qbe.py check` | proved transcript guard |
| `active_backend_hfree_guard` | Active backend is the seven-gate product and omits both $H_W$ side gates. | active gate matrix placeholder list. | QBE-local semantic guard | lower 2 | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` | active mismatch note | `python3 tools/qbe.py check` | proved mismatch witness |
| `slot2_branch_map` | Displayed gamma3 slot `2` is the selected backend branch at full basis `[32,32]`. | Eq. `ROBIN clarified`; backend branch index map. | GHL-internal branch plus QBE-local index bridge | lower 1 | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | prepared-entry lower-1 packet | `python3 tools/qbe.py check` | proved |
| `prepared_entry_backend_eval` | Under `hUniform`, `Prepared00(H, env)` evaluates to `BackendFold`. | Eq. `arbitrary sparcity`; prepared sparse matrix and sandwich fold. | external-cited-contract plus QBE-local semantic bridge | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedProjectionEntryBackendEval_n3` | prepared-entry LHS repair note | `python3 tools/qbe.py check` | proved conditional; LHS repair retired |
| `active_to_prepared_reduction` | The uncast active/prepared target is equivalent to the evaluated backend fold under `hUniform`, with the active gate list still H-free. | prepared-sandwich equivalence; prepared fold specialization; sparse-preparation absence guard. | QBE-local obligation alignment | lower 2 | `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3` | this packet and lower2 handoff | `python3 tools/qbe.py check` | compiled guard; shows target is not smaller |
| `raw_entry_prepared_sandwich_field` | Raw signal-zero entry equals `Sandwich(H)`. | prepared sandwich target; active raw entry source. | QBE-local finite matrix semantics | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | proof-obligations ledger | `python3 tools/qbe.py check` | open; equivalent obstruction |
| `active_prepared_entry_field` | Active seven-gate signal-zero entry equals prepared sparse-register clean entry. | prepared sparse matrix; raw active entry source. | QBE-local finite matrix semantics | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | proof-obligations ledger | `python3 tools/qbe.py check` | open; equivalent obstruction |
| `evaluated_backend_fold` | `Coeff.evalWith env signalUnitaryEntry = Coeff.evalWith env BackendFold`. | active uncast entry; seven-slot backend family. | QBE-local finite projection/summation theorem | lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | diagnostic/backlog plus this packet | `python3 tools/qbe.py check` | open; true active mathematical leaf if closure is attempted |
| `column0_slot0_diagnostic` | Active `[0,0]` expands through column-`0` slot-`0` diagnostics. | two-path support lemmas. | QBE-local diagnostic | none | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | diagnostic notes | none | retired; not a source proof |
| `raw_coeff_constructor_route` | Raw symbolic constructor equality for the H-free fold. | old raw `Coeff` route. | stale diagnostic | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign as main theorem |

Compiled lower2 guard:

```lean
oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3
```

The compiled theorem has the intended interface:

```lean
theorem ... (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Gate.oracleCall "H_W^(kappa)" ∉
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)).map (fun gateMatrix => gateMatrix.gate) ∧
    Gate.oracleCall "(H_W^(kappa))^dagger" ∉
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)).map (fun gateMatrix => gateMatrix.gate) ∧
    (oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env ↔
      oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env)
```

This leaf should compile from existing declarations and should keep every proof
flag false.  If lower 2 instead attempts theorem closure, the real leaf is
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`,
not a slot-`0` diagnostic.

## 5. Ordered Intermediate Lean Lemmas To Reuse

1. Transcript and absence guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`,
   and `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.

2. Active-entry source reductions:
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
   `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`, and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`.

3. Prepared-entry and sandwich reductions:
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

4. Active/prepared interface alignments:
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`,
   `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3`,
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3`, and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedCircuitField_n3`.

5. Smaller field interfaces:
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_statement_n3`,
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`, and
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`.

6. Slot-`2` source branch map:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

7. Diagnostic-only routes:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, and
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.
   These should not be used as source closure for the slot-`2` prepared branch.

## 6. Failure Analysis

The current target is mathematically under-specified as a faithful source
translation if it is read as a direct proof that the active seven-gate `[0,0]`
entry already contains the two $H_W^{(\kappa)}$ side gates.  The source Fig. 4
transcript includes those side gates; the active Lean backend list omits them.
The target can still be a valid QBE-local finite theorem, but it must be proved
as the evaluated backend fold or raw prepared-sandwich field.  It cannot be
closed by citing Eq. `arbitrary sparcity` alone.

The clean-column contract says the prepared entry uses all seven sparse slots.
For a general preparation matrix `H`, the clean entry of
$H_W^\dagger U H_W$ is a sparse-register sandwich sum, not simply the active
slot-`0` entry of `Uactive`.  Additional conditions such as a delta clean
column, all nonzero slot contributions vanishing, or slot-independent diagonal
entries would be new assumptions; none appears in the source fragment or in the
Lean contract.

The compiled equivalence
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3`
is the strongest current guide: the active-to-prepared target is exactly the
evaluated backend fold under `hUniform`.  Therefore the finite active-to-
prepared frontier should be classified as an internal finite projection theorem
or target-shape repair, not as an external cited-contract gap.

## 7. Handoff

Lower 1 re-read the source anchors and the synchronized Lean interfaces.  The
prepared-entry backend evaluator is source-correct and retired.  The remaining
finite active-to-prepared target has no separate paper proof: under `hUniform`
it is already equivalent to the evaluated backend fold.  The next Lean worker
should either compile a small route-packaging theorem that records this
reduction plus the absence of both `H_W` side gates, or directly attack the
true finite backend fold.  Do not revive column-`0` slot-`0` diagnostics as a
proof of the displayed slot-`2` gamma3 branch, and do not promote oracle,
`H_W`, `R_y`, LCU, product-to-coefficient, block, unitarity, normalized-equality,
or final-extraction flags.
