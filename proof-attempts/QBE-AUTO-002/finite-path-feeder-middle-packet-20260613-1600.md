# 2026-06-13 Middle Packet: Finite Path Feeder Calibration

Task: `QBE-AUTO-002`  
Run: `20260613-155325-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`

## Source Anchors

Use GHL2025 Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Eq. `angles for Ry`, and Definition
`def:block-encoding`.  The local Fig. 4 audit is
`paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`.

The full Fig. `fig:1 term ROBIN` transcript is not the active seven-gate
backend list.  The full transcript includes both `H_W^(kappa)` sides and the
explicit `U_indic^dagger` source slot.  The active lower leaf is the H-free
seven-gate backend entry and may be consumed by the source-prepared theorem
only through the explicit `hUniform` bridge.

## Definitions

- `ActiveSelectedEval(env)` is
  `Coeff.evalWith env ((evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3)`.
- `SelectedContribution(env)` is
  `Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`.
- `StrictFeeder(env)` is the theorem
  `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env` proving
  `ActiveSelectedEval(env) = SelectedContribution(env)`.
- `EvaluatedBackendFold(env)` is
  `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
- `Uniform(H)` is
  `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

The accepted route is:

```text
selected active seven-gate entry
  -> focused evaluated path normal form
  <- backend selected contribution
  -> strict feeder
  -> evaluated backend fold
  -> source-prepared Fig. 4 bridge under explicit hUniform
```

## Lean Name Map

| Symbolic role | Existing Lean declaration | Source role |
|---|---|---|
| full Fig. 4 transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit`; `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | source circuit audit with `H_W` sides and explicit cleanup |
| active backend circuit | `GHL2025.oneTermRobinCircuit`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | H-free seven-gate matrix component |
| active gate matrices | `GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)` | matrices consumed by `evalGateMatrices` |
| selected row and column | `oneTermRobinGamma3BoundaryPrefixRow0_n3` | active `[0,0]` entry |
| source selected slot | `oneTermRobinGamma3BoundaryBranchContributionFocusedSlot` | sparse slot `2` for the boundary gamma3 branch |
| source selected full index | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | slot `2` maps to full index `32` |
| selected contribution | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution` | Eq. `ROBIN clarified` selected contribution |
| backend selected fold | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | compiled backend fold collapse |
| strict feeder bridge | `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env` | feeder to evaluated backend fold |
| source-prepared bridge | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold` | theorem-facing recovery under `Uniform(H)` |

## Lower-Agent Split

### lower1: Natural-Language Proof Architect

Write:

```text
proof-attempts/QBE-AUTO-002/finite-path-feeder-lower1-dag-<timestamp>.md
```

Required content:

| Required item | Expected output |
|---|---|
| path-name calibration | map `p0...p7`, `G_UIndic`, `TailAfterRy`, and `FocusedPathEval` to existing Lean declarations or thin aliases |
| selected-column inventory | list selected-column facts already compiled and the first missing fact |
| branch-shape statement | say whether `R_y` and `O_f` are unique-column or two-path-with-tail-kill in the current implementation |
| lower2 recommendation | name exactly one next Lean theorem target |

Do not edit Lean.  Do not introduce a second register layout.

### lower3: Necessary-Condition Verifier

Write:

```text
verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower3-<timestamp>.json
```

Required fields:

```json
{
  "leaf": "finite_path_feeder",
  "source_correspondence_ok": true,
  "finite_matrix_ok": "checked|blocked|not_checked",
  "path_indices_mapped": true,
  "ry_branch_shape": "unique|two_path|unknown",
  "of_branch_shape": "unique|two_path|unknown",
  "raw_coeff_route_rejected": true,
  "block_entry_ok": false,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "..."
}
```

The check must explicitly reject using
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` or
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as theorem closure.
Those are diagnostic routes, and the current verifier memory records a
`shape_or_register_gap` risk for them.

### lower2: Lean Implementation Worker

Edit only `QuantumBlockEncoding/RobinMatrix.lean`, unless a tiny generic
matrix wrapper genuinely belongs in `QuantumBlockEncoding/CircuitSemantics.lean`.

Allowed first targets:

1. one selected-column lemma for the active path;
2. one tail-kills-bad-branch lemma for `R_y` or `O_f`;
3. one active-entry-to-focused-normal-form lemma;
4. the strict feeder itself, but only if lower1 and lower3 show it is ready.

Preferred theorem:

```lean
theorem oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution := by
  ...
```

Then the evaluated fold is recovered by:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_holds_n3
    (env : String -> Rat) :
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env := by
  exact
    (oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
      env).mp
      (oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env)
```

After any Lean edit, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

## Reject Routes

Reviewer should reject any attempt that:

- attacks raw symbolic `Coeff` constructor equality as theorem closure;
- proves the diagnostic seven-gate raw equality route instead of the active
  `evalGateMatrices` selected-slot feeder;
- changes the paper circuit, gate order, oracle contracts, normalizer, or
  theorem assumptions;
- adds `hUniform` to the strict feeder;
- treats the H-free seven-gate backend component as the full Fig. 4 circuit;
- promotes oracle, `H_W`, `R_y`, LCU/QSVT, unitarity, block-projection,
  product-to-coefficient, final-extraction, or normalizer flags.

The first-case-study one-term theorem remains open.
