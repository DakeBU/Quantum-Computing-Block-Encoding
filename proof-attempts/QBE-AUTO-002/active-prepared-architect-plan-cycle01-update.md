# Proof Architect Plan: Active/Prepared Composition Closure — Updated

Task: QBE-AUTO-002, Cycle 1
Target: `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`
Date: 2026-06-07
Status: updated after two-path infrastructure compiled

## 1. Source-Paper Fragment

Unchanged from prior plan. The GHL2025 paper (arXiv:2506.20478) provides the
seven-gate construction at the operator level but not the explicit finite
matrix-entry computation for `[0,0]`. Classification: not a source-contract gap.

## 2. Current Compiled State

### Already compiled and available

| Declaration | Line | Role |
|---|---|---|
| `SevenGateTwoPath_n3` | 7590 | two-path decomposition for `[0,0]` |
| `PrefixCol0Support_n3` | 7445 | prefix at col 0 nonzero only at rows {96,97} |
| `DaggerRow0_support_n3` | 7546 | dagger at row 0 nonzero only at col 96 |
| `SwapRow96_image_n3` | 7574 | `swapOracleImage p 96 = 12` |
| `ODBSImage0_n3` | 7345 | `bandedSparseAccessPaperImage p 0 = 96` |
| `ODBSImage1_n3` | 7369 | `bandedSparseAccessPaperImage p 1 = 97` |
| `evalWith_mul_two_path` (CircuitSemantics) | 328 | two-path matrix product reducer |
| `foldl_add_two_of_nodup` (CircuitSemantics) | 235 | foldl extracts two nonzero terms |
| `PreparedCompositeCleanEntryEval_eq_backend_n3` | 18866 | prepared clean entry = backend fold (under HWKappa) |
| `ActivePreparedCompositeEvalStatement_iff_uncast_n3` | 18351 | target ↔ uncast |
| `UncastActivePreparedCompositeEval_iff_preparedSandwich_n3` | 18368 | uncast ↔ sandwich |
| `SourcePreparedProjectionTarget_activeEval_iff_backendFold_n3` | 19269 | active eval ↔ backend fold (under HWKappa) |
| `EvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3` | 19378 | backend fold ↔ uncast active entry = fold |
| `EvaluatedBackendFoldStatement_of_activePreparedEval_n3` | 20745 | source-correct route (needs `hActive`) |

### Sorry-guarded

| Declaration | Line | Blocker |
|---|---|---|
| `EvalGateMatrices_eq_sevenGateMatrix_n3` | 20834 | needs `Matrix.mul_assoc` |
| `UnitaryEntry_eq_backendFold_n3` | 20803 | H-free raw fold (frozen per directive) |

## 3. Natural-Language Proof of the Target

### Target

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

i.e.:
```
Coeff.evalWith env (evalGateMatrices(placeholders)[0, 0]) =
Coeff.evalWith env (preparedComposite.matrix[clean, clean])
```

### Proof route (fully compiled chain)

**Step 0.** `ActivePreparedCompositeEvalStatement H env ↔ UncastActivePreparedCompositeEvalStatement H env`
(compile: `ActivePreparedCompositeEvalStatement_iff_uncast_n3`, line 18351).
So it suffices to prove the uncast form.

**Step 1.** The uncast form is:
```
evalGateMatrices(placeholders)[0,0] evalWith = preparedComposite.matrix[clean,clean] evalWith
```

**Step 2.** Under HWKappa, `preparedComposite.matrix[clean,clean] evalWith = backendFold evalWith`
(compile: `PreparedCompositeCleanEntryEval_eq_backend_n3`, line 18866).

So the target reduces to:
```
evalGateMatrices(placeholders)[0,0] evalWith = backendFold evalWith
```

**Step 3.** The `EvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3` (line 19378)
shows that this is exactly `EvaluatedBackendFoldStatement_n3 env`.

**Step 4.** The `SourcePreparedProjectionTarget_activeEval_iff_backendFold_n3` (line 19269)
shows this is equivalent to `activeToPreparedSingletonEvalStatement` under HWKappa,
and the route through `EvaluatedBackendFoldStatement_of_activePreparedEval_n3` (line 20745)
uses the hypothesis `hActive : ActivePreparedCompositeEvalStatement H env` directly.

**Step 5 (OPEN — the core gap).** What remains is to prove:
```
Coeff.evalWith env (evalGateMatrices(placeholders)[0, 0]) =
Coeff.evalWith env (blockExtractionBranchContributionSum backendBranchContribution)
```

This is `EvaluatedBackendFoldStatement_n3 env`, equivalently:
```
evalGateMatrices(placeholders)[0,0] evalWith = backendFold evalWith
```

### How to close the gap using the two-path decomposition

The compiled two-path theorem gives:
```
sevenGateMatrix[0,0] evalWith =
  suffix[0, 96] evalWith * prefix[96, 0] evalWith +
  suffix[0, 97] evalWith * prefix[97, 0] evalWith
```

The associativity bridge `EvalGateMatrices_eq_sevenGateMatrix_n3` (sorry-guarded)
connects `evalGateMatrices(placeholders)` to `sevenGateMatrix`. If we accept
this bridge (which is a pure matrix-associativity fact, not a scientific claim),
then the gap reduces to showing the two-path RHS equals the backend fold.

The backend fold is:
```
sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)] * kappa_inv
```

So we need:
```
suffix[0,96] * prefix[96,0] + suffix[0,97] * prefix[97,0]
= kappa_inv * sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)]
```

### Two possible routes to close this

**Route A: Via the sorry-guarded associativity bridge + diagonal uniformity.**

1. Accept the sorry bridge to replace `evalGateMatrices` with `sevenGateMatrix`.
2. Prove diagonal uniformity: all 7 sparse-slot diagonal entries are equal.
3. Then `sevenGateMatrix[0,0] = (1/7) * sum_{s} sevenGateMatrix[fullIndex(s), fullIndex(s)]`.
4. The backend fold = `kappa_inv * sum = kappa_inv * 7 * sevenGateMatrix[0,0]`.
5. So `sevenGateMatrix[0,0] = backendFold / (7 * kappa_inv)`.
6. This requires computing `7 * kappa_inv = 1` for the n=3 parameters.

**Route B: Direct coefficient computation.**

1. Evaluate both suffix entries `suffix[0,96]` and `suffix[0,97]` through the
   dagger-SWAP-O_f chain.
2. Evaluate both prefix entries `prefix[96,0]` and `prefix[97,0]` through the
   O_D^BS-Ry-O_DT^S-U_indic chain.
3. Compute the two products and their sum as a concrete Coeff expression.
4. Separately expand the backend fold to a concrete Coeff expression.
5. Show the two Coeff expressions evaluate to the same Rat under any env.

Route B avoids the associativity sorry and the diagonal uniformity proof, but
requires explicit computation of the O_f entries and the Ry rotation entries.

## 4. Dependency-Ordered Proof Plan (Route B — Recommended)

Route B is recommended because:
- It avoids the sorry-guarded associativity bridge.
- It avoids the diagonal uniformity proof (which needs 7 position analyses).
- It directly computes the [0,0] entry through the two-path decomposition.

### L1: Suffix entry evaluation lemmas

**L1a: `SuffixRow0Col96_eval_n3`**

```
Coeff.evalWith env (suffix[0, 96]) =
  Coeff.evalWith env (dagger[0, 96]) * Coeff.evalWith env (OfSwap[96, 96])
```

Wait — the suffix is `dagger * OfSwap`, so `suffix[0, 96]` is a full matrix product
row-column dot product. However, the dagger at row 0 concentrates at column 96
(unique path), so:

```
suffix[0, k] = dagger[0, 96] * OfSwap[96, k]
```

Using `evalWith_mul_unique_path` with `DaggerRow0_support_n3`:
- `dagger[0, j] evalWith = 0` for `j ≠ 96`
- `dagger[0, 96] = Coeff.rat 1` (native_decide)

So:
```
suffix[0, k] evalWith = 1 * OfSwap[96, k] evalWith = OfSwap[96, k] evalWith
```

Then OfSwap is `SWAP * O_f`. At row 96, SWAP concentrates at column 12
(because `swapOracleImage p 12 = 96`):

```
OfSwap[96, k] = SWAP[96, 12] * O_f[12, k]
```

Using `evalWith_mul_unique_path` with `SwapRow96_support_n3` (needs compilation):
- `SWAP[96, j] evalWith = 0` for `j ≠ 12`
- `SWAP[96, 12] = Coeff.rat 1` (native_decide)

So:
```
suffix[0, k] evalWith = O_f[12, k] evalWith
```

Specifically:
- `suffix[0, 96] evalWith = O_f[12, 96] evalWith`
- `suffix[0, 97] evalWith = O_f[12, 97] evalWith`

**Dependencies**: `DaggerRow0_support_n3` (compiled), `SwapRow96_support_n3` (needs compilation),
`evalWith_mul_unique_path` (existing infrastructure).

**New Lean declarations needed**:

L1a.1: `oneTermRobinGamma3BoundarySwapRow96_support_n3` (private)
  - `SWAP[96, j] evalWith = 0` for `j.val ≠ 12`
  - Pattern: `rw [swapOracleMatrix_eq_image]`, use involution + `SwapRow96_image_n3`
  - ~20 lines

L1a.2: `oneTermRobinGamma3BoundaryOfSwapRow96_uniquePath_n3` (private)
  - `OfSwap[96, k] evalWith = O_f[12, k] evalWith`
  - Uses `evalWith_mul_unique_path` + `SwapRow96_support_n3`
  - ~15 lines

L1a.3: `oneTermRobinGamma3BoundarySuffixRow0Col_eval_n3` (private, general)
  - `suffix[0, k] evalWith = O_f[12, k] evalWith`
  - Uses `evalWith_mul_unique_path` + `DaggerRow0_support_n3` + L1a.2
  - ~15 lines

### L2: Prefix entry evaluation lemmas

**L2a: `PrefixRow96Col0_eval_n3` and `PrefixRow97Col0_eval_n3`**

The prefix is `O_D^BS * (Ry * (O_DT^S * U_indic))`. At column 0:

The Ry rotation at column 0 is a 2×2 rotation matrix `[cos θ, -sin θ; sin θ, cos θ]`
applied to the first two rows. Since `O_D^BS` maps row 0 → 96 and row 1 → 97:

```
prefix[96, 0] = O_D^BS[96, :] * (Ry * rest)[:, 0]
             = O_D^BS[96, 0] * (Ry * rest)[0, 0] + O_D^BS[96, 1] * (Ry * rest)[1, 0] + ...
```

Since `bandedSparseAccessPaperImage p 0 = 96`, `O_D^BS` at column 0 is nonzero only at
row 96. Similarly `image(p, 1) = 97`. The inverse: `O_D^BS[i, 0]` is nonzero only if
`image(p, i) = 0`, but that's not what we need. We need the *forward* direction:
`O_D^BS` entry formula is `if j.val = image(p, i.val) then 1 else 0`, so at column `j`
with `j.val = 0`, only rows `i` with `image(p, i.val) = 0` contribute. But this requires
knowing which `i` maps to 0 under the image function, which is the *preimage*.

Actually, let me reconsider. The prefix is:
```
prefixMatrix = O_D^BS * RDU_prefix
```
where `RDU_prefix = Ry * (O_DT^S * U_indic)` (via `RDUPrefixMatrix`).

The prefix column-0 support already tells us `prefix[i, 0] evalWith = 0` for `i ∉ {96, 97}`.
We need the actual values at rows 96 and 97.

For the prefix entry at [96, 0]:
```
prefix[96, 0] = sum_j O_D^BS[96, j] * RDU_prefix[j, 0]
```
`O_D^BS[96, j] = if j = image_inv(96) then 1 else 0`. But the image function maps *source
indices to target indices*. `O_D^BS[i, j] = 1` iff `j.val = image(p, i.val)`. So
`O_D^BS[96, j] = 1` iff `j.val = image(p, 96)`. We need `image(p, 96)`.

Since the banded sparse access oracle is a permutation of source indices into the sparse
register, and the image function maps each source index to a sparse register position.
For n=3 with 7 sparse entries, the first few source indices map as:
- `image(p, 0) = 96` (compiled: ODBSImage0_n3)
- `image(p, 1) = 97` (compiled: ODBSImage1_n3)

So `image(p, 96)` would need to be computed. Let me think about this differently.

Actually, `O_D^BS` is a permutation matrix. `O_D^BS[i, j]` is nonzero iff `j` is the
*source* index that maps to position `i` in the sparse register. Wait, the formula is:
```
bandedSparseAccessPaperMatrix p i j = if j.val = bandedSparseAccessPaperImage p i.val then 1 else 0
```

So `O_D^BS[i, j] = 1` iff `j = image(p, i)`. The column `j` stores the source index
corresponding to sparse position `i`. For row `i = 96`:
`O_D^BS[96, j] = 1` iff `j = image(p, 96)`.

But we need `image(p, 96)`. Since the image function maps Fin n values to positions in
a larger space, and there are only 7 sparse entries, the image values are multiples of
`2^(clog2(7)) = 16`. So `image(p, s) = s * 16` for `s < 7`, and `image(p, s) = s` for
`s >= 7` (identity on the complement). Thus `image(p, 96)` = 96 (identity, since 96 is
not a sparse slot index, i.e., 96/16 = 6 which IS a sparse slot).

Wait, 96/16 = 6, and s = 6 < 7, so `image(p, 6) = 6 * 16 = 96`. So row `i = 96` in
`O_D^BS` maps to source index `j = image(p, 96)`.

`image(p, 96)`: since `image(p, s) = s * 16` for `s < 7`, the inverse is: the source
index `j` such that `image(p, j) = 96` is `j = 6` (since `6 * 16 = 96`). But that's the
inverse image, not the forward image.

The forward image `image(p, 96)`: the function takes a source index (Fin 128 for n=3)
and maps it. For indices beyond the sparse range, it should be the identity.
`image(p, i)` for `i >= 7` = ... hmm, the exact definition depends on the GHL code.

This is getting into detailed numerical territory. The key point is: to compute
`prefix[96, 0]` and `prefix[97, 0]`, we need to trace through the O_D^BS matrix.

### Alternative approach: avoid computing prefix entries explicitly

Instead of computing each factor individually, use the full two-path theorem
(`SevenGateTwoPath_n3`) and try to relate the sum directly to the backend fold.

The backend fold is:
```
sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)] * kappa_inv
```

The two-path gives `sevenGateMatrix[0,0]` as a sum of two products. We need
`sevenGateMatrix[0,0] evalWith = backendFold evalWith`.

Since the [0,0] entry is `sevenGateMatrix[0,0]` and `fullIndex(0) = 0`, the slot-0
contribution to the backend fold is `sevenGateMatrix[0,0] * kappa_inv`. So:

```
backendFold evalWith = sevenGateMatrix[0,0] evalWith * kappa_inv evalWith
                     + sum_{s=1}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)] * kappa_inv evalWith
```

For `sevenGateMatrix[0,0] evalWith = backendFold evalWith`, we need:
```
sevenGateMatrix[0,0] = kappa_inv * sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)]
```

This is the diagonal uniformity requirement again. The two-path decomposition
does not bypass it — it just makes the [0,0] entry structure explicit.

### Revised route: two-path + entry computation → backend fold equality

The only way to avoid diagonal uniformity is to compute both sides to concrete
Coeff expressions and show they are equal. Let me outline this:

**LHS**: `sevenGateMatrix[0,0] evalWith = suffix[0,96] * prefix[96,0] + suffix[0,97] * prefix[97,0]`
evaluated through the gate chain to concrete Coeff terms.

**RHS**: `backendFold evalWith` expanded as 7 terms, each requiring the diagonal
entry at a different sparse slot.

Both sides ultimately reduce to the same O_f entries times rotation coefficients.
The paper's block-encoding property guarantees this equality at the operator level.

But computing both sides explicitly requires:
1. Evaluating `suffix[0,96]`, `suffix[0,97]` → O_f[12, 96], O_f[12, 97]
2. Evaluating `prefix[96,0]`, `prefix[97,0]` → Ry rotation coefficients
3. Evaluating `sevenGateMatrix[16,16]`, ..., `sevenGateMatrix[96,96]` → each needs
   its own support analysis
4. Summing 7 terms with kappa_inv

This is essentially the full diagonal analysis, just written differently.

### Pivotal observation: the route through the uncast statement

Wait — re-reading the target more carefully:

The target is `UncastActivePreparedCompositeEvalStatement_n3 H env`, which is:
```
evalGateMatrices(placeholders)[0,0] evalWith = preparedComposite.matrix[clean,clean] evalWith
```

The source-correct route in `EvaluatedBackendFoldStatement_of_activePreparedEval_n3`
(line 20745) already shows how to derive `EvaluatedBackendFoldStatement_n3 env`
from `ActivePreparedCompositeEvalStatement H env`. It uses:
1. The hypothesis `hActive` (the target itself)
2. `PreparedCompositeCleanEntryEval_eq_backend_n3` (compiled)

But this is the wrong direction — it uses the target as a hypothesis, not a conclusion.

The *reverse* direction would close the target: if we can prove
`EvaluatedBackendFoldStatement_n3 env`, then combined with the prepared-side
bridge, we get the active-prepared equality.

Let me trace the reverse:

`EvaluatedBackendFoldStatement_n3 env` says:
```
signalUnitaryEntry evalWith = backendFold evalWith
```

Via `EvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`, this is:
```
evalGateMatrices(placeholders)[0,0] evalWith = backendFold evalWith
```

Via `PreparedCompositeCleanEntryEval_eq_backend_n3` (under HWKappa), we know:
```
preparedComposite.matrix[clean,clean] evalWith = backendFold evalWith
```

So if `EvaluatedBackendFoldStatement_n3 env` holds, then:
```
evalGateMatrices(placeholders)[0,0] evalWith
= backendFold evalWith                                    (by backend fold statement)
= preparedComposite.matrix[clean,clean] evalWith          (by prepared bridge, reversed)
```

This is exactly `UncastActivePreparedCompositeEvalStatement_n3 H env`!

So the **entire target reduces to proving `EvaluatedBackendFoldStatement_n3 env`**,
i.e., `evalGateMatrices(placeholders)[0,0] evalWith = backendFold evalWith`.

This is the same as the frozen H-free fold at the evaluation level.

## 5. Updated Dependency-Ordered Proof Plan

### Goal: `EvaluatedBackendFoldStatement_n3 env`

This says: `evalGateMatrices(placeholders)[0,0] evalWith = backendFold evalWith`

**Strategy**: Use the two-path decomposition to express the LHS, and the
backend fold expansion to express the RHS, then show equality.

### L0: `EvalGateMatrices_eq_sevenGateMatrix_n3` (sorry-guarded, infrastructure)

The sorry-guarded theorem at line 20834. Needed to replace `evalGateMatrices`
with `sevenGateMatrix` in the LHS.

**Status**: Blocked on `Matrix.mul_assoc` for custom Matrix type.
**Alternative**: Can we avoid this bridge?

Yes, if we work directly with `evalGateMatrices(placeholders)` as the folded
7-gate product. The `[0,0]` entry of the folded product is the same as
`sevenGateMatrix[0,0]` by associativity. But without the bridge theorem, we
cannot rewrite in Lean.

**Decision**: The sorry bridge is acceptable as a hypothesis for the target
proof. The target theorem can use `EvalGateMatrices_eq_sevenGateMatrix_n3`
(with its sorry) to simplify the LHS, or we can prove the target using
`sevenGateMatrix` directly and connect later.

Actually, looking at the uncast statement definition (line 18329), it uses
`evalGateMatrices(...)` directly. So we need the bridge.

**Alternative**: Prove the EvaluatedBackendFoldStatement using the two-path
theorem (which works on `sevenGateMatrix`), then use the bridge to connect
back. The target proof would be:

```lean
theorem uncastActivePreparedEval_n3 H env hUniform :
    UncastActivePreparedCompositeEvalStatement_n3 H env := by
  -- Reduce to EvaluatedBackendFoldStatement
  have h := EvaluatedBackendFoldStatement_n3_proof env  -- new lemma below
  -- Use SourcePreparedProjectionTarget_activeEval_iff_backendFold reverse
  -- Or directly: evalGateMatrices[0,0] = backendFold = preparedComposite[clean,clean]
  ...
```

But we still need `evalGateMatrices[0,0] = sevenGateMatrix[0,0]` somewhere.

### L1 (New smallest target): `sevenGateEntry00_eq_backendFold_eval_n3`

```
theorem sevenGateEntry00_eq_backendFold_eval_n3 (env : String → Rat) :
    Coeff.evalWith env (sevenGateMatrix[0, 0]) =
      Coeff.evalWith env (blockExtractionBranchContributionSum backendBranchContribution) := by
```

This is the seven-gate version of the backend fold equality. Combined with the
sorry-guarded bridge, it gives `EvaluatedBackendFoldStatement_n3 env`.

**Proof strategy**: Expand both sides.

**LHS** (via two-path):
```
sevenGateMatrix[0,0] evalWith
= suffix[0,96] * prefix[96,0] + suffix[0,97] * prefix[97,0]
= O_f[12,96] * prefix[96,0] + O_f[12,97] * prefix[97,0]
```

**RHS** (via backend fold expansion):
```
sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)] * kappa_inv
```

Each term `sevenGateMatrix[fullIndex(s), fullIndex(s)]` has a unique-path or
two-path structure. For s=2 (fullIndex=32), we have the compiled unique-path
giving `suffix[32,0] * prefix[0,32]`. For s=0 (fullIndex=0), the two-path gives
`suffix[0,96] * prefix[96,0] + suffix[0,97] * prefix[97,0]`.

The diagonal uniformity argument (all entries equal) would immediately give the
result. But proving it requires analyzing all 7 positions.

### Recommended smallest achievable step

Given the analysis above, the smallest new lemma that makes progress is:

**L-NEW: `sevenGateEntry00_expanded_n3`**

Expand `sevenGateMatrix[0,0] evalWith` through the two-path decomposition AND
evaluate the suffix entries through the dagger-SWAP chain to get O_f entries:

```lean
theorem sevenGateEntry00_expanded_n3 (env) :
    Coeff.evalWith env (sevenGateMatrix PrefixRow0 PrefixRow0) =
      Coeff.evalWith env (functionOraclePaperMatrix p ⟨12, _⟩ ⟨96, _⟩) *
        Coeff.evalWith env (prefixMatrix ⟨96, _⟩ PrefixRow0) +
      Coeff.evalWith env (functionOraclePaperMatrix p ⟨12, _⟩ ⟨97, _⟩) *
        Coeff.evalWith env (prefixMatrix ⟨97, _⟩ PrefixRow0) := by
```

This combines the two-path theorem with the suffix evaluation lemmas.

**Dependencies**:
1. `SevenGateTwoPath_n3` (compiled, line 7590)
2. `SwapRow96_support_n3` (needs compilation)
3. `SuffixRow0Col_eval_n3` → suffix[0,k] = O_f[12,k] (needs compilation)
4. `DaggerRow0_support_n3` (compiled)

**Proof**:
```
rw [SevenGateTwoPath_n3]
rw [SuffixRow0Col_eval_n3 env ⟨96, _⟩]  -- suffix[0,96] = O_f[12,96]
rw [SuffixRow0Col_eval_n3 env ⟨97, _⟩]  -- suffix[0,97] = O_f[12,97]
```

## 6. Recommended Lean Worker Targets (Updated Priority Order)

### Priority 1: Compile `SwapRow96_support_n3`

```lean
private theorem oneTermRobinGamma3BoundarySwapRow96_support_n3
    (k : Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
    (hk : k.val ≠ 12) :
    Coeff.evalWith env
      (GHL2025.swapOracleMatrix p ⟨96, by native_decide⟩ k) = 0 := by
```

Proof: `rw [swapOracleMatrix_eq_image]`, then show `96 ≠ swapOracleImage p k.val`
using `hk` and the involution property. ~15 lines.

### Priority 2: Compile `SuffixRow0Col_eval_n3`

```lean
private theorem oneTermRobinGamma3BoundarySuffixRow0Col_eval_n3
    (env : String → Rat) (k : Fin _) :
    Coeff.evalWith env (suffixMatrix ⟨0, _⟩ k) =
      Coeff.evalWith env (functionOraclePaperMatrix p ⟨12, _⟩ k) := by
```

Proof: Two unique-path steps through dagger then SWAP. ~20 lines.

### Priority 3: Compile `sevenGateEntry00_expanded_n3`

Combines two-path + suffix evaluation. ~10 lines.

### Priority 4: Evaluate the prefix entries at [96,0] and [97,0]

Trace through O_D^BS * RDU_prefix to compute the concrete Coeff expressions.
This requires understanding the bandedSparseAccessPaper inverse at rows 96, 97
and the Ry rotation entries.

### Priority 5: Compare with backend fold

After both sides are computed to concrete Coeff terms, show equality.

## 7. Failure Analysis

### Why the direct approach may still be blocked

The prefix entry evaluation at [96,0] requires tracing through:
1. `O_D^BS[96, j]` — nonzero only where `j = image^{-1}(96)`, i.e., the preimage
   of 96 under the sparse access map. Since `image(p, 6) = 96`, the preimage of 96
   is 6. So `O_D^BS[96, j] = 1` only at `j = 6`.
2. `RDU_prefix[6, 0]` — the Ry-rotated and indicator-gated entry.

The Ry rotation at column 0 spreads rows {0, 1}, not row 6. So `RDU_prefix[6, 0]`
might be zero, which would make `prefix[96, 0] = 0`.

Wait — if `prefix[96, 0] = 0`, then the two-path would degenerate to a single path
through row 97. Let me re-examine.

Actually, the prefix support analysis already shows `prefix[i, 0] evalWith = 0` for
`i ∉ {96, 97}`. So the prefix is nonzero at rows 96 and 97. The question is whether
both are nonzero or one might also be zero.

The Ry boundary rotation at column 0 has nonzero entries at rows 0 and 1 (it's a
2×2 rotation on the first two basis states). O_D^BS maps these to 96 and 97. The
Ry entry at [0, 0] is `cos θ` and at [1, 0] is `sin θ`. So:
- `prefix[96, 0] ∝ cos θ` (via O_D^BS mapping row 0 to row 96)
- `prefix[97, 0] ∝ sin θ` (via O_D^BS mapping row 1 to row 97)

Both are nonzero for generic θ. The two-path is genuinely two paths, not a
degenerate single path.

### Mathematical assessment

The equality `sevenGateMatrix[0,0] evalWith = backendFold evalWith` is expected
to hold because the seven-gate circuit implements a valid block encoding. The
diagonal uniformity (or its equivalent via explicit computation) is the key
mathematical fact. At n=3, this is a finite matrix identity that should be
verifiable by computation, but the 128×128 Coeff matrix is too large for
`native_decide`.

The recommended approach is to compute both sides through gate-by-gate sparse
support analysis, reducing the identity to a small number of concrete Coeff
comparisons.

## 8. Handoff to Lean Worker

The Lean worker should implement in this order:
1. `SwapRow96_support_n3` (~15 lines, pattern: `SwapRow0_support_n3`)
2. `SuffixRow0Col_eval_n3` (~20 lines, pattern: `SuffixEntryEval_n3`)
3. `sevenGateEntry00_expanded_n3` (~10 lines, combining the above)
4. Attempt prefix entry evaluation at [96,0] and [97,0]
5. Record any new blocking issues under `proof-attempts/`

Run `python3 tools/qbe.py check` after each Lean edit.
