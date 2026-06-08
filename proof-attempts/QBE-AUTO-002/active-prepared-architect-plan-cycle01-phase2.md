# Phase 2 Dependency-Ordered Proof Plan for EvaluatedBackendFoldStatement_n3

Task: QBE-AUTO-002
Date: 2026-06-07
Target: Close `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`
Status: plan

## Architecture

The iff chain compiles to: `EvaluatedBackendFoldStatement_n3 env` is equivalent to
`evalWith(evalGateMatrices(...)[0,0]) = evalWith(backendFold)`.

The backendFold is `Sum_{s:Fin 7} sevenGateMatrix[idx(s),idx(s)] * projFactor`
where `idx(s) = s * 16`, so slots 0..6 use diagonal entries at positions
`0, 16, 32, 48, 64, 80, 96`.

The route:
1. Bridge evalGateMatrices[0,0] to sevenGateMatrix[0,0] via associativity
2. Two-path decompose sevenGateMatrix[0,0] through rows {96, 97}
3. Evaluate suffix side to O_f[12,96] and O_f[12,97]
4. Evaluate prefix side to cos/sin boundary rotation terms
5. Show the two-path expression equals the seven-slot backend fold

## Dependency-Ordered Lemma Plan

### Step 0 (Infrastructure): `matrix_mul_assoc` and `matrix_mul_identity_right`

**File**: `QuantumBlockEncoding/Core.lean` or `CircuitSemantics.lean`

These are reusable infrastructure for the project's custom `Matrix` type.

- `theorem Matrix.mul_assoc {m n p q} (A : Matrix m n Coeff) (B : Matrix n p Coeff) (C : Matrix p q Coeff) : (A * B) * C = A * (B * C)`
  - Proof: Unfold `Matrix.mul`, rearrange the `finRange` sum using additive commutativity/associativity on `Coeff`, swap inner/outer summations. Use `Coeff.add_assoc`, `Coeff.add_comm`, `Coeff.mul_assoc`.

- `theorem Matrix.mul_identity_right {m n} (A : Matrix m n Coeff) : A * (Matrix.identity n) = A`
  - Proof: Unfold, the identity matrix selects the diagonal, Kronecker delta simplifies the sum to a single term.

**Dependencies**: Only `Coeff` ring axioms and `Matrix.mul` definition.
**Strategy**: Direct computation from Matrix.mul definition + finRange folding.

### Step 1: `EvalGateMatrices_eq_sevenGateMatrix_n3` (close the sorry at line 21049)

**Statement**: `evalGateMatrices (oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)) = sevenGateMatrix_n3`

**Dependencies**: Step 0 (`Matrix.mul_assoc`, `Matrix.mul_identity_right`)

**Proof strategy**: The existing `simp only [...]` at line 21052-21059 already unfolds all definitions. After simp, the remaining goal is a re-parenthesization of a 7-matrix product (foldl evaluated left-to-right vs. the grouped suffix*prefix decomposition). Apply `Matrix.mul_assoc` repeatedly (6 rewrites) to match parenthesization, then `Matrix.mul_identity_right` to eliminate any identity matrices from the fold seed.

Concretely:
```lean
theorem ... := by
  simp only [evalGateMatrices, sevenGateMatrix_n3, suffixMatrix_n3, prefixMatrix_n3,
    ofSwapMatrix_n3, rduPrefixMatrix_n3, duPrefixMatrix_n3,
    oneTermRobinGateMatrixPlaceholders, ...]
  -- After simp, goal is fold-evaluated product = grouped product
  rw [Matrix.mul_assoc, Matrix.mul_assoc, ...]  -- re-parenthesize
  -- May need List.foldl evaluation lemmas
```

Alternative: prove a general lemma `evalGateMatrices_eq_foldl` that evaluates the foldl to explicit matrix products, then use associativity to match.

### Step 2: `evalGateMatrices_entry_eq_sevenGate_entry_n3`

**Statement**: `evalGateMatrices(...)[Row0, Row0] = sevenGateMatrix_n3[Row0, Row0]`

**Dependencies**: Step 1

**Proof strategy**: Congruence on matrix equality: `congr 1; exact EvalGateMatrices_eq_sevenGateMatrix_n3`.

### Step 3: `PrefixRow96Col0_eval_n3`

**Statement**: `prefixMatrix[<96>, Row0] evalWith = env "boundary_cos_half_0_2"`

**Dependencies**: `ODBSCol0_support_n3` (line 7353), `RDUPrefixCol0Support_n3` (line 7422)

**Proof strategy**: The prefix is `O_D^BS * RDU`. At column Row0, RDU has support at rows {Row0, Row1}. Since `image(0) = 96`, `O_D^BS[96, Row0] = 1` and `O_D^BS[96, Row1] = 0`. So prefix[96, Row0] is a unique path through row Row0 of RDU. Then RDU[Row0, Row0] = Ry[Row0, Row0] * DU[Row0, Row0] = cos_half * 1 = `env "boundary_cos_half_0_2"`.

```lean
theorem PrefixRow96Col0_eval_n3 (env : String -> Rat) :
    Coeff.evalWith env (prefixMatrix (<96, by native_decide>) Row0) =
      env "boundary_cos_half_0_2" := by
  unfold prefixMatrix_n3
  -- unique path through Row0 in RDU
  apply Matrix.evalWith_mul_unique_path
  intro q hq
  by_cases hq0 : q = Row0
  · subst q; simp [ODBSCol0_support_n3 _ (by native_decide : (96:Fin _).val ≠ 96 |>.elim)]
    -- actually O_D^BS[96, Row0] = 1, not 0, so this case is the surviving path
    sorry -- need the positive case
  · by_cases hq1 : q = Row1
    · subst q; simp [ODBSCol1_support_n3 _ (by native_decide)]
    · simp [RDUPrefixCol0Support_n3 env q hq0 hq1]
  -- Then: O_D^BS[96, Row0] = 1 (native_decide), RDU[Row0, Row0] = boundary_cos_half_0_2
```

### Step 4: `PrefixRow97Col0_eval_n3`

**Statement**: `prefixMatrix[<97>, Row0] evalWith = env "boundary_sin_half_0_2"`

**Dependencies**: `ODBSCol1_support_n3` (line 7377), `RDUPrefixCol0Support_n3` (line 7422)

**Proof strategy**: Symmetric to Step 3 but through row Row1. `O_D^BS[97, Row1] = 1` (since image(1)=97), `O_D^BS[97, Row0] = 0`. RDU[Row1, Row0] = Ry[Row1, Row0] * DU[Row0, Row0] = sin_half * 1 = `env "boundary_sin_half_0_2"`.

### Step 5: `SevenGateEntry00_two_path_evaluated_n3`

**Statement**:
```
evalWith env (sevenGateMatrix[Row0, Row0]) =
  evalWith env (O_f[12, 96]) * env "boundary_cos_half_0_2"
  + evalWith env (O_f[12, 97]) * env "boundary_sin_half_0_2"
```

**Dependencies**: `SevenGateTwoPath_n3` (line 7590), `SuffixRow0Col96_eval_n3` (line 7658), `SuffixRow0Col97_eval_n3` (line 7751), Step 3, Step 4

**Proof strategy**: Chain the two-path decomposition with the suffix and prefix evaluations:
```
sevenGateMatrix[0,0] = suffix[0,96]*prefix[96,0] + suffix[0,97]*prefix[97,0]
                     = O_f[12,96] * boundary_cos_half + O_f[12,97] * boundary_sin_half
```

### Step 6: `BackendFold_slotZero_expanded_n3`

**Statement** (already compiled as `BackendBranchFold_expandedSlotZero_n3` at line 15239):
The backend fold's slot-0 term is `sevenGateMatrix[Row0, Row0] * projFactor`.

This is already compiled. No new work needed.

### Step 7: `BackendFold_slots1to6_eval_n3` (key missing piece)

**Statement**: For each s in {1,...,6}, either:
- `sevenGateMatrix[s*16, s*16] = 0` (slot vanishes), or
- `sevenGateMatrix[s*16, s*16] evalWith` has a concrete form that combines with the projection weight

**Dependencies**: Support theorems for each diagonal position s*16.

**Proof strategy**: For each slot s, analyze the two-path (or unique-path) structure at position [s*16, s*16]. The seven-gate matrix is `suffix * prefix`. The prefix at column s*16 maps through O_D^BS and the RDU prefix. The suffix at row s*16 maps through the dagger and OfSwap. Most slots likely vanish or reduce to a single O_f entry times a concrete coefficient.

The key structural observation: `idx(s) = s * 16` for s = 0..6, so the diagonal entries are at positions 0, 16, 32, 48, 64, 80, 96. Each has its own support structure through the seven-gate product.

### Step 8: `EvaluatedBackendFoldStatement_n3` (main target)

**Statement**: `evalWith env signalUnitaryEntry = evalWith env backendFold`

**Dependencies**: Steps 2, 5, 6, 7, and the iff chain

**Proof strategy**:
1. Use `EvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3` to reduce to `evalWith(evalGateMatrices[0,0]) = evalWith(backendFold)`
2. Use Step 2 to replace evalGateMatrices[0,0] with sevenGateMatrix[0,0]
3. Use Step 5 for the LHS two-path expansion
4. Use Steps 6-7 to expand the RHS backend fold
5. Match both sides term-by-term

## Smallest Lemma to Implement First

**Step 3: `PrefixRow96Col0_eval_n3`**

This is the smallest new lemma. It requires:
- Unfolding `prefixMatrix = O_D^BS * RDU`
- One unique-path reduction (O_D^BS concentrates row 96 at column Row0)
- The existing `RDUPrefixEntryEval_n3` (or the Ry/cos evaluation)
- All sub-lemmas (`ODBSCol0_support_n3`, `ODBSImage0_n3`) are already compiled

Proof skeleton (approximately 15 lines):
```lean
theorem PrefixRow96Col0_eval_n3 (env : String -> Rat) :
    Coeff.evalWith env (prefixMatrix (<96, by native_decide>) Row0) =
      env "boundary_cos_half_0_2" := by
  unfold prefixMatrix_n3
  -- evalWith_mul_unique_path through Row0
  -- O_D^BS[96, Row0] = 1 (native_decide)
  -- RDU[Row0, Row0] = env "boundary_cos_half_0_2" (from RDUPrefixEntryEval at col Row0)
```

## How EvalGateMatrices_eq_sevenGateMatrix_n3 Should Be Proved

After `simp only [...]` unfolds all definitions, the goal becomes:

```
(List.foldl (fun acc gate => gate.matrix.mul acc) identity [G1,...,G7]) = suffixMatrix * prefixMatrix
```

where `suffixMatrix = G7 * G6 * (G5 * identity)` and `prefixMatrix = G4 * (G3 * (G2 * G1))`
(parenthesization depends on the exact gate ordering).

The proof requires:
1. Evaluate the `foldl` over the 7-element list to an explicit left-nested product
2. Use `Matrix.mul_assoc` to re-parenthesize
3. Use `Matrix.mul_identity_right` to eliminate the identity seed

The `foldl` evaluation can be done by `simp [List.foldl]` or by explicit `rw [List.foldl_cons, List.foldl_nil]` steps.

After fold evaluation: `G7 * (G6 * (G5 * (G4 * (G3 * (G2 * (G1 * identity))))))`
After identity elimination: `G7 * (G6 * (G5 * (G4 * (G3 * (G2 * G1)))))`
After reassociation via mul_assoc: group as `(G7 * G6 * G5) * (G4 * G3 * G2 * G1)`
Then match the suffix/prefix decomposition.

## What Prefix[96,0] and Prefix[97,0] Evaluate To

**prefix[96, 0]**:
- `prefix = O_D^BS * RDU`, column = Row0
- RDU at column Row0 has support at rows {Row0, Row1}
- `O_D^BS[96, Row0] = 1` (since `bandedSparseAccessPaperImage(0) = 96`), `O_D^BS[96, Row1] = 0`
- So prefix[96, Row0] = RDU[Row0, Row0]
- RDU = Ry * DU. DU at column Row0 has unique path through Row0 (both indicator and O_DT^S are identity at state 0)
- DU[Row0, Row0] = 1
- RDU[Row0, Row0] = Ry[Row0, Row0] = `Coeff.symbol "boundary_cos_half_0_2"`
- **Result**: `prefix[96, 0] evalWith = env "boundary_cos_half_0_2"`

**prefix[97, 0]**:
- `O_D^BS[97, Row1] = 1` (since `bandedSparseAccessPaperImage(1) = 97`), `O_D^BS[97, Row0] = 0`
- So prefix[97, Row0] = RDU[Row1, Row0]
- RDU[Row1, Row0] = Ry[Row1, Row0] * DU[Row0, Row0] = `Coeff.symbol "boundary_sin_half_0_2"` * 1
- **Result**: `prefix[97, 0] evalWith = env "boundary_sin_half_0_2"`

## How the Two-Path Expression Compares With the Backend Fold

**Two-path LHS** (from Step 5):
```
sevenGateMatrix[0,0] evalWith = O_f[12,96] * cos_half + O_f[12,97] * sin_half
```

**Backend fold RHS**:
```
Sum_{s=0..6} sevenGateMatrix[s*16, s*16] evalWith * projFactor evalWith
```

The slot-0 term of the fold is exactly `sevenGateMatrix[0,0] * projFactor`. But the fold has 7 terms. For the equality to hold, the weighted sum of all 7 diagonal entries must equal the single [0,0] entry.

There are two possible routes:

**Route A (slot collapse)**: Show that the projection factor is `sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv`, and that under the HWKappa clean-column hypothesis, all slots collapse to the same diagonal value. Then `Sum_{s} diag[s] * kappa_inv = 7 * diag[0] * kappa_inv = diag[0]` if `7 * kappa_inv = 1`, i.e., `kappa = 7`.

**Route B (slot vanishing)**: Show that the projection weights for slots 1..6 are zero under the clean-column contract, so only slot 0 survives. This is the simpler route if the backend's `blockExtractionBranchContributionSum` structure allows it.

**Route C (direct Coeff equality)**: This is the raw `signalUnitaryEntry = backendFold` equality at the `Coeff` level. The directive says NOT to prove `UnitaryEntry_eq_backendFold_n3` standalone. Instead, we prove the evaluated form through the iff chain.

The most likely correct route: under the HWKappa uniform-column contract, the seven diagonal entries are all equal (diagonal uniformity), and the sum `kappa_inv * Sum_{s} diag[s]` equals `diag[0]` by the kappa normalization. This means we need:
1. `sevenGateMatrix[0,0] evalWith = sevenGateMatrix[s*16, s*16] evalWith` for all s (diagonal uniformity)
2. `Sum_{s=0..6} projFactor evalWith = 1` (kappa normalization)

Then `Sum_s diag[s] * projFactor = diag[0] * Sum_s projFactor = diag[0] * 1 = diag[0]`.

Proving diagonal uniformity requires the two-path structure at each diagonal position to produce the same evaluated result, which is the finite projection theorem itself. This is the deep fact that the current sorry guards encode.

**Recommended approach**: Prove `EvaluatedBackendFoldStatement_n3` by:
1. Bridging to sevenGateMatrix[0,0] (Steps 0-2)
2. Two-path expanding the [0,0] entry (Steps 3-5)
3. Showing the backend fold's slot-0 term is exactly sevenGateMatrix[0,0] * projFactor (Step 6, compiled)
4. Showing the backend fold's slots 1-6 terms each equal sevenGateMatrix[0,0] * projFactor under HWKappa (diagonal uniformity, Step 7)
5. Summing: `7 * sevenGateMatrix[0,0] * projFactor = sevenGateMatrix[0,0]` since `7 * projFactor = 1`

The hardest part is Step 7 (diagonal uniformity across all 7 slots). This likely requires a general support/evaluation framework for each slot's two-path structure, showing they all reduce to the same `O_f[12,96] * cos_half + O_f[12,97] * sin_half` expression.

## Summary of New Lemmas (in implementation order)

1. `Matrix.mul_assoc` (Core.lean infrastructure)
2. `Matrix.mul_identity_right` (Core.lean infrastructure)
3. `PrefixRow96Col0_eval_n3` (prefix evaluation, ~15 lines)
4. `PrefixRow97Col0_eval_n3` (prefix evaluation, ~15 lines)
5. `SevenGateEntry00_two_path_evaluated_n3` (combine suffix+prefix evals with two-path, ~20 lines)
6. `EvalGateMatrices_eq_sevenGateMatrix_n3` (close sorry, ~20 lines using Steps 1-2)
7. `EvalGateMatrices_entry_eq_sevenGate_entry_n3` (congruence, ~5 lines)
8. `BackendFold_slot_s_diagonal_eval_n3` for s=1..6 (7 support lemmas, ~15 lines each)
9. `EvaluatedBackendFoldStatement_n3` (main target, ~30 lines combining all above)
