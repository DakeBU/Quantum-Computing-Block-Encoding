# QBE-AUTO-002 Middle Packet: Backend Expansion Versus Raw Prepared Sandwich

Created: 2026-06-09 18:01 JST

Role split: lower 1 owns the natural-language proof map; lower 2 owns one
Lean implementation leaf. This packet is a middle synchronization artifact, not
a Lean proof.

## 1. Source-Contract Audit

This packet uses the local GHL2025 TeX archive only for reading. Public proof
maps should cite the source anchors below and the arXiv paper, not a local
absolute path.

| Source anchor | Paper fragment | Lean-facing contract | Classification | Lower decision |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the uniform sparse-register clean column and cites Shukla--Vedula for implementation. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | keep as explicit `hUniform`; do not recursively prove state preparation |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. | theorem route through the source-prepared projection target | GHL-internal root theorem | still open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | displayed $\gamma_3$ boundary branch has denominator $\mathcal{N}_D\mathcal{N}_f\kappa$. | backend branch fold and selected slot-`2` branch lemmas | GHL-internal plus QBE-local index bridge | compiled branch map; keep slot-`0` diagnostics separate |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit contains both $H_W^{(\kappa)}$ sides, explicit $U_{\mathrm{indic}}^\dagger$, pre-SWAP $O_{D^T}^{BS}$, and post-SWAP $(O_D^{BS})^\dagger$. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; prepared-sandwich contracts | GHL-internal transcript | compiled guard; active seven-gate backend remains H-free |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean projection extracts the encoded operator entry. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local semantic bridge | backend expansion/projection fold is the next mathematical leaf |

The missing ingredient is QBE-local finite matrix/projection work. It is not a
new Shukla--Vedula, Gilyen/LCU, sparse-oracle, function-oracle, `R_y`, or
block-projection dependency.

## 2. Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and the existing sparse
preparation contract

```lean
hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The active backend-expansion leaf is

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

The raw prepared-sandwich route leaf is

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H)
  .rawEntryPreparedSandwichStatement
```

The generic prepared-entry route leaf is

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The evaluated fold target is

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

## 3. Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | all-slot sparse-register clean column for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; Shukla--Vedula citation | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | `python3 tools/qbe.py check` | contract-only |
| `fig4_transcript_guard` | theorem-facing Fig. 4 order with both `H_W` sides and explicit `U_indic^dagger` | Fig. `fig:1 term ROBIN`; self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | same gate | compiled |
| `slot2_backend_branch` | displayed gamma3 slot `2` contributes the selected backend summand | Eq. `ROBIN clarified`; branch index map | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | source-prepared DAG | same gate | compiled |
| `prepared_entry_backend_eval` | prepared clean entry evaluates to the backend fold under `hUniform` | `src_hw_uniform`; prepared singleton semantics | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | status notes | same gate | compiled conditional |
| `active_prepared_eval_equiv_evaluated_fold` | active/prepared eval field is equivalent to the evaluated backend fold under `hUniform` | source-prepared target equivalence; prepared clean-entry backend bridge | lower 2 | `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3 H env hUniform` | `proof-attempts/QBE-AUTO-002/active-prepared-eval-iff-evaluated-fold-20260609-lower2.md` | focused Lean gate plus project gates | compiled conditional; neither side proved |
| `backend_expansion_core` | raw seven-slot branch/projection expansion | branch contribution target; projection summation target | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active mathematical leaf |
| `raw_prepared_sandwich_leaf` | active signal-zero entry equals the prepared $H_W^\dagger U H_W$ sandwich fold | raw field/backend equivalence; `hUniform` for downstream route | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | this packet | same gates | accepted equivalent leaf |
| `generic_entry_leaf` | active signal-zero entry equals the prepared sparse clean entry | prepared entry target; backend-expansion equivalence under `hUniform` | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | same gates | accepted route leaf |
| `hfree_uncast_eval_route` | H-free active `[0,0]` equals weighted backend fold after `Coeff.evalWith` | support partition plus all-slot matching | none unless explicitly reassigned | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | 17:18 route check | none | retired as source closure |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for the H-free fold | deep `Coeff` syntax | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

## 4. Lower Packets

Lower 1 proof architect:

- Write only a narrow addendum if the worker needs it.
- Map `backendExpansionStatement`, the raw prepared-sandwich field, and the
  generic prepared-entry field through the existing equivalence lemmas.
- Keep `hUniform` explicit and do not restart broad source search.

Lower 2 Lean worker:

- Edit only `QuantumBlockEncoding/RobinMatrix.lean`.
- Prove exactly one leaf, preferably
  `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
- Accepted equivalents are
  `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`
  or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.
- Do not try to prove the arbitrary-`H`
  `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`
  as an unconditional paper theorem.
- If the proof collapses to column-`0`/slot-`0`, record obstruction memory and
  leave the source-prepared backend-expansion leaf open.

Required gates after any Lean edit:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, ODBS, ODTS, or `O_f` flag is promoted by this packet.
