# 2026-06-13 ChatGPT Pro Finite-Path Feeder Deployment

Task: `QBE-AUTO-002`  
Mode: `faithfulPaper`  
Status: accepted as next 6h proof plan, with implementation-name calibration required.

## Verdict

The ChatGPT Pro response is mathematically aligned with the current ABEIS
diagnosis.

Accepted core idea:

- Stop attacking the whole one-term Robin block-encoding theorem directly.
- Stop trying raw symbolic `Coeff` constructor equality.
- Prove the strict finite evaluated feeder:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

and then consume the already compiled bridge

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
```

to obtain

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

which is then consumed by the already compiled source-prepared bridge under the
explicit sparse-preparation contract:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
  H env hUniform hFold
```

This is source-faithful to GHL2025 Fig. 4, Eq. `ROBIN clarified`, and Definition
`def:block-encoding`, and it does not change oracle contracts, normalizers,
theorem assumptions, or gate order.

## Important Calibration

The ChatGPT Pro answer uses illustrative names such as `G_UIndic`, `p1`,
`p2`, `TailAfterRy`, and `FocusedPathEval`.  Lower agents must not paste those
names blindly.

Instead, lower agents must first map them to existing declarations in
`QuantumBlockEncoding/RobinMatrix.lean`, especially the existing prefix/suffix,
seven-gate, focused-slot, branch-contribution, and `evalWith` bridge lemmas.
New abbreviations are allowed only as thin aliases around existing indices or
matrix entries.

Existing useful declarations include:

```lean
oneTermRobinGamma3BoundaryPrefixRow0_n3
oneTermRobinGamma3BoundaryPrefixMatrix_n3
oneTermRobinGamma3BoundarySuffixMatrix_n3
oneTermRobinGamma3BoundarySevenGateMatrix_n3
oneTermRobinGamma3BoundaryBackendBranchContribution_n3
oneTermRobinGamma3BoundaryBranchContributionFocusedSlot
oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
```

Existing matrix tools include:

```lean
Matrix.evalWith_mul_apply
Matrix.evalWith_mul_unique_path
Matrix.evalWith_mul_two_path
Matrix.evalWith_mul_eq_zero_of_all_paths_zero
Matrix.evalWith_mul_identity_right_apply
```

## Accepted Proof-DAG

### Node A: optional local matrix wrappers

Owner: lower2 if needed.  
Classification: QBE-local finite matrix semantics.

Optional helper lemmas:

- `Matrix.evalWith_mul_unique_column`
- `Matrix.evalWith_mul_two_path_drop_second`

These are convenience wrappers only.  If adding them causes more churn than
using the existing `Matrix.evalWith_mul_unique_path` and
`Matrix.evalWith_mul_two_path`, skip them.

### Node B: focused finite-path map

Owner: lower1 and lower3 before lower2 edits a large proof.  
Classification: QBE-local finite matrix semantics tied to GHL2025 Fig. 4.

Produce a compact table:

| Symbolic role | Existing Lean declaration or new alias | Source role |
|---|---|---|
| input/output selected clean row | `oneTermRobinGamma3BoundaryPrefixRow0_n3` | selected block-entry row/column |
| focused backend slot | `oneTermRobinGamma3BoundaryBranchContributionFocusedSlot` | gamma3 selected branch |
| focused backend full index | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 focusedSlot` | backend branch diagonal entry |
| active seven-gate entry | `evalGateMatrices ... prefixRow0 prefixRow0` | Fig. 4 active backend component |
| backend selected contribution | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution` | Eq. `ROBIN clarified` clean branch |

If lower agents introduce `p0 ... p7`, each must be tied to an existing Lean
index and to one Fig. 4 gate transition.  Do not introduce broad new register
encodings in this batch.

### Node C: selected-column gate facts

Owner: lower2, one lemma at a time.  
Classification: GHL source instantiated as QBE-local finite entry semantics.

Prove only entry/column facts needed for the selected path.  Do not prove full
matrix equality.

Possible targets, depending on existing names:

- indicator boundary column: selected boundary packet remains in indicator-zero
  state;
- inactive `O^S_{D^T}` boundary column: bulk sparse-amplitude oracle does not
  supply the boundary coefficient on the boundary branch;
- boundary `R_y` selected entry: selected zero branch carries the Robin boundary
  coefficient already encoded in the current symbolic matrix;
- `O^{BS}_{D^T}` selected sparse-access column;
- `O_f` selected clean-ancilla column;
- SWAP selected column;
- `(O_D^{BS})^\dagger` selected cleanup column.

If `R_y` or `O_f` has an orthogonal branch, lower2 must prove the later tail
kills that branch for the selected final row, rather than pretending the column
is unique.

### Node D: active entry to focused normal form

Owner: lower2.  
Classification: QBE-local finite matrix semantics.

Target shape:

```lean
theorem oneTermRobinGamma3BoundaryActiveEntryEval_eq_focusedPathEval_n3
    (env : String → Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    oneTermRobinGamma3BoundaryFocusedPathEval_n3 env := by
  ...
```

The exact name is flexible.  The proof should use `Matrix.evalWith_mul_*`
path-collapse lemmas and selected entry facts, not raw constructor equality.

### Node E: backend selected contribution to same normal form

Owner: lower2.  
Classification: QBE-local finite matrix semantics.

Target shape:

```lean
theorem oneTermRobinGamma3BoundaryBackendFocusedContributionEval_eq_focusedPathEval_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        oneTermRobinGamma3BoundaryBranchContributionFocusedSlot) =
    oneTermRobinGamma3BoundaryFocusedPathEval_n3 env := by
  ...
```

If a new normal form creates unnecessary churn, the backend side may be taken as
the normal form directly.  The important invariant is that both active and
backend sides reduce to the same evaluated scalar without unfolding the full
matrix.

### Node F: strict feeder

Owner: lower2.  
Classification: QBE-local finite matrix semantics.

Preferred theorem:

```lean
theorem oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3
    (env : String → Rat) :
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

Then:

```lean
theorem oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_holds_n3
    (env : String → Rat) :
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env := by
  exact
    (oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
      env).mp
      (oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env)
```

### Node G: truthful diagnostic-sorry cleanup

Owner: lower2 only after Node F compiles.  
Classification: proof hygiene, not mathematical closure.

The two current raw diagnostic `sorry` declarations should not be proved by
brute force.  Once Node F compiles, lower2 may replace them with honest
diagnostic propositions such as `_goal : Prop`, and add evaluated semantic
theorems instead.  Do not claim raw full-matrix equality unless it is actually
proved.

## Next 6h Agent Split

### lower1: natural-language proof architect

Write a fresh proof-DAG packet that maps the ChatGPT Pro plan to existing Lean
declarations.  Required artifact:

```text
proof-attempts/QBE-AUTO-002/finite-path-feeder-lower1-dag-<timestamp>.md
```

The packet must include:

- exact existing Lean names for the active entry, focused backend slot, and
  selected contribution;
- which selected-column facts already exist and which are missing;
- whether `R_y` and `O_f` are unique-column or two-path-with-tail-kill in the
  current implementation;
- one recommended lower2 lemma.

### lower3: necessary-condition verifier

Before lower2 starts a large proof, run finite/path/support diagnostics.  Required
artifact:

```text
verifier-feedback/QBE-AUTO-002/finite-path-feeder-lower3-<timestamp>.json
```

Typed fields:

```json
{
  "leaf": "finite_path_feeder",
  "finite_matrix_ok": "checked|blocked|not_checked",
  "path_indices_mapped": true,
  "ry_branch_shape": "unique|two_path|unknown",
  "of_branch_shape": "unique|two_path|unknown",
  "raw_coeff_route_rejected": true,
  "next_route": "..."
}
```

### lower2: Lean implementation worker

Edit only `QuantumBlockEncoding/RobinMatrix.lean` unless a small generic wrapper
belongs in `QuantumBlockEncoding/CircuitSemantics.lean`.

Allowed first Lean target:

1. a selected-column lemma for one gate;
2. a tail-kills-bad-branch lemma for `R_y` or `O_f`;
3. an active-entry-to-focused-normal-form lemma;
4. the strict feeder itself if the lower1/lower3 packets show it is already
   ready.

After Lean edits, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

### reviewer

Reject any attempt that:

- attacks raw symbolic equality as the main theorem;
- changes GHL assumptions, gate order, oracle contracts, or normalizers;
- treats the active seven-gate backend as the whole source-prepared Fig. 4
  circuit;
- adds `hUniform` to the strict feeder;
- marks oracle, `H_W`, `R_y`, LCU/QSVT, unitarity, or final block correctness
  as proved.

## Why This Should Improve The Next 6h Batch

Earlier runs repeatedly spent time on broad route wiring, arbitrary-`H`
prepared targets, backend slot vanishing, and diagnostic raw equality.  This
deployment narrows the next batch to one finite evaluated path-comparison
problem and makes the expected proof shape explicit:

```text
selected active entry
  -> focused evaluated path normal form
  <- backend selected contribution
  -> strict feeder
  -> evaluated backend fold
  -> source-prepared bridge under explicit hUniform
```

That is the smallest source-faithful path currently visible.
