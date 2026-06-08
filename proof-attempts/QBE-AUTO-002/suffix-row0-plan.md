# Suffix-Side Row-0 Support Lemmas and Two-Path Decomposition Plan

Task: QBE-AUTO-002, Cycle 1
Date: 2026-06-07
Status: plan — awaiting implementation

## Overview

The [0,0] entry of `sevenGateMatrix = suffixMatrix * prefixMatrix` has a two-path
structure through intermediate rows {96, 97}, unlike [32,32] which has a unique path
through row 0. The prefix side is already compiled: `prefix[i, Row0] evalWith = 0`
for `i.val ∉ {96, 97}`. This plan covers the suffix-side support lemmas and the
two-path decomposition theorem.

## New Infrastructure Lemma Required in CircuitSemantics.lean

### L0: `foldl_add_two_of_nodup` (private helper)

Analogous to `foldl_add_unique_of_nodup` at CircuitSemantics.lean:145.

```lean
private theorem foldl_add_two_of_nodup {β : Type u} [DecidableEq β]
    (ks : List β) (f : β → Rat) (k0 k1 : β)
    (hk0_ne_k1 : k0 ≠ k1)
    (hnodup : ks.Nodup)
    (hk0_mem : k0 ∈ ks)
    (hk1_mem : k1 ∈ ks)
    (hzero : ∀ k, k ∈ ks → k ≠ k0 → k ≠ k1 → f k = 0) :
    ks.foldl (fun acc k => acc + f k) 0 = f k0 + f k1 := by
```

**Proof strategy**: Induction on `ks` with the same pattern as `foldl_add_unique_of_nodup`.
At each `cons k ks` step, case-split on whether `k = k0`, `k = k1`, or neither.
- If `k = k0`: accumulate `f k0`, recurse on `ks` with `k1` as the unique survivor,
  using `foldl_add_unique_of_nodup` on the tail (all terms in `ks` except `k1` are zero).
- If `k = k1`: symmetric.
- If neither: `f k = 0` by `hzero`, drop it, recurse.

An alternative simpler proof: rewrite `foldl` as `foldl ... 0 = foldl ... (f k0) + (remaining sum after skipping k0)`,
then use `foldl_add_unique_of_nodup` for the second path. The cleanest approach:

```
have h1 := foldl_add_unique_of_nodup ks f k1 hnodup hk1_mem (by
  intro k hkmem hk_ne
  exact hzero k hkmem (by contrapose! hk_ne; rintro rfl; exact hk_ne) hk_ne)
-- but we need to handle k0 too, so instead:
-- Prove: foldl ... 0 = (List.erase ks k0).foldl ... 0 + f k0
-- Then apply foldl_add_unique_of_nodup to (List.erase ks k0) with k1
```

Actually the cleanest approach mirrors the structure of `foldl_add_unique_of_nodup` exactly,
just with two distinguished elements instead of one:

```lean
private theorem foldl_add_two_of_nodup {β : Type u} [DecidableEq β]
    (ks : List β) (f : β → Rat) (k0 k1 : β)
    (hk0_ne_k1 : k0 ≠ k1)
    (hnodup : ks.Nodup)
    (hk0_mem : k0 ∈ ks)
    (hk1_mem : k1 ∈ ks)
    (hzero : ∀ k, k ∈ ks → k ≠ k0 → k ≠ k1 → f k = 0) :
    ks.foldl (fun acc k => acc + f k) 0 = f k0 + f k1 := by
  induction ks with
  | nil => cases hk0_mem
  | cons k ks ih =>
      rw [List.nodup_cons] at hnodup
      rcases hnodup with ⟨hk_not_mem, hks_nodup⟩
      rw [List.mem_cons] at hk0_mem
      rw [List.mem_cons] at hk1_mem
      rcases hk0_mem with hk0_head | hk0_tail
      rcases hk1_mem with hk1_head | hk1_tail
      -- Case: k = k0, k = k1 (impossible)
      · exfalso; exact hk0_ne_k1 (hk0_head.trans hk1_head.symm)
      -- Case: k = k0, k1 ∈ ks
      · subst k
        have htail_zero : ∀ k', k' ∈ ks → k' ≠ k1 → f k' = 0 := by
          intro k' hk' hk_ne
          exact hzero k' (by simp [hk']) (by rintro rfl; exact hk_not_mem hk') hk_ne
        calc
          (k0 :: ks).foldl (fun acc k => acc + f k) 0 =
              ks.foldl (fun acc k => acc + f k) (0 + f k0) := rfl
          _ = ks.foldl (fun acc k => acc + f k) (f k0) := by rw [Rat.zero_add]
          _ = f k0 + f k1 := by
              have h := foldl_add_unique_of_nodup ks f k1 hks_nodup hk1_tail htail_zero
              rw [h]
              ring
      -- Case: k1 ∈ ks_head, k ∈ ks_tail (impossible by hk0_head)
      · exfalso; cases hk0_head
      -- Case: k0 ∈ ks, k1 ∈ ks (neither is head)
      · have hk_zero : f k = 0 := by
          have hne0 : k ≠ k0 := by rintro rfl; exact hk_not_mem hk0_tail
          have hne1 : k ≠ k1 := by rintro rfl; exact hk_not_mem hk1_tail
          exact hzero k (by simp) hne0 hne1
        have htail_zero : ∀ k', k' ∈ ks → k' ≠ k0 → k' ≠ k1 → f k' = 0 := by
          intro k' hk' hk_ne0 hk_ne1
          exact hzero k' (by simp [hk']) hk_ne0 hk_ne1
        calc
          (k :: ks).foldl (fun acc k => acc + f k) 0 =
              ks.foldl (fun acc k => acc + f k) (0 + f k) := rfl
          _ = ks.foldl (fun acc k => acc + f k) 0 := by rw [hk_zero, Rat.zero_add]
          _ = f k0 + f k1 := ih hks_nodup hk0_tail hk1_tail htail_zero
```

Wait -- this misses the symmetric case `k = k1, k0 ∈ ks`. The `rcases` on `hk0_mem` and `hk1_mem`
gives four combinations. The first two handle `(head, *)`. The third `(tail, head)` handles
`k = k1, k0 ∈ ks` (symmetric to case 2). The fourth `(tail, tail)` handles neither at head.
So:

```
rcases hk0_mem with hk0_head | hk0_tail
rcases hk1_mem with hk1_head | hk1_tail
-- 1. k = k0, k = k1: impossible
-- 2. k = k0, k1 ∈ ks: accumulate f(k0), unique-path on tail for k1
-- 3. k0 ∈ ks, k = k1: accumulate f(k1), unique-path on tail for k0
-- 4. k0 ∈ ks, k1 ∈ ks: f(k)=0, recurse
```

### L0b: `evalWith_mul_two_path` (public theorem in CircuitSemantics.lean)

```lean
theorem evalWith_mul_two_path
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) (k0 k1 : Fin mid)
    (hk0_ne_k1 : k0 ≠ k1)
    (hzero : ∀ k : Fin mid, k ≠ k0 → k ≠ k1 →
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      Coeff.evalWith env (A i k0) * Coeff.evalWith env (B k0 j) +
      Coeff.evalWith env (A i k1) * Coeff.evalWith env (B k1 j) := by
  rw [evalWith_mul_apply]
  exact foldl_add_two_of_nodup (List.finRange mid)
    (fun k => Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j))
    k0 k1 hk0_ne_k1 (finRange_nodup mid) (List.mem_finRange k0) (List.mem_finRange k1)
    (by intro k _hmem hk_ne0 hk_ne1; exact hzero k hk_ne0 hk_ne1)
```

---

## New Lean Declarations (RobinMatrix.lean)

### L1: `oneTermRobinGamma3BoundaryDaggerRow0_support_n3` (private)

Analog of `oneTermRobinGamma3BoundaryDaggerRow32_support_n3` (line 6865).

The dagger at row 0 concentrates at column `image(0) = 96`.

```lean
private theorem oneTermRobinGamma3BoundaryDaggerRow0_support_n3
    (k : Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
    (hk : k.val ≠ 96) :
    GHL2025.bandedSparseAccessPaperDaggerMatrix
        oneTermRobinGamma3BoundaryPrefixParameters_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3 k = Coeff.rat 0 := by
```

**Proof strategy**: Identical to `DaggerRow32_support_n3`.
```
rw [GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image]
have himage :
    GHL2025.bandedSparseAccessPaperImage
        oneTermRobinGamma3BoundaryPrefixParameters_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3.val = 96 := by
  native_decide   -- or use oneTermRobinGamma3BoundaryODBSImage0_n3
simp [himage, hk]
```

Note: `bandedSparseAccessPaperDaggerMatrix p i j = if j.val = image(p, i.val) then 1 else 0`.
For row `i = Row0` (= 0), `image(p, 0) = 96`, so the dagger at row 0 is nonzero only at
column `j` with `j.val = 96`. The hypothesis `hk : k.val ≠ 96` gives the negated condition.

**Dependencies**: none (uses only GHL2025 infrastructure + ODBSImage0 which is already compiled).

### L2: `oneTermRobinGamma3BoundarySwapRow96_image_n3` (private)

```lean
private theorem oneTermRobinGamma3BoundarySwapRow96_image_n3 :
    GHL2025.swapOracleImage
        oneTermRobinGamma3BoundaryPrefixParameters_n3 12 = 96 := by
  native_decide
```

**Proof strategy**: `native_decide`. This computes `swapOracleImage(p, 12) = 96`
for the n=3 parameters. This is the key numerical fact: SWAP maps row 12 (the swap
of row 96) back to row 96.

**Dependencies**: none.

### L3: `oneTermRobinGamma3BoundarySwapRow96_support_n3` (private)

Analog of `oneTermRobinGamma3BoundarySwapRow0_support_n3` (line 6834).

```lean
private theorem oneTermRobinGamma3BoundarySwapRow96_support_n3
    (k : Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
    (hk : k ≠ ⟨12, by native_decide⟩) :
    GHL2025.swapOracleMatrix
        oneTermRobinGamma3BoundaryPrefixParameters_n3
        ⟨96, by native_decide⟩ k = Coeff.rat 0 := by
```

Wait -- we need to be careful about the direction. `swapOracleMatrix p i j = if i.val = swapOracleImage(p, j.val) then 1 else 0`.
For row `i` with `i.val = 96`, the entry is nonzero only when `96 = swapOracleImage(p, j.val)`,
i.e., when `j = swapOraclePreimage(p, 96)`. Since `swapOracleImage` is an involution
(`swapOracleImage_self_inverse`), `swapOracleImage(p, swapOracleImage(p, 96)) = 96`,
and `swapOracleImage(p, 96) = 12`, so the only nonzero column is `j.val = 12`.

But for the suffix-side support we actually need the opposite direction: at which rows
does the SWAP matrix have nonzero entries when the row index is 96? That is,
`swapOracleMatrix p ⟨96, _⟩ k ≠ 0` iff `96 = swapOracleImage(p, k.val)`, i.e., `k.val = 12`
(since swapOracleImage is an involution and swapOracleImage(p, 12) = 96).

```lean
private theorem oneTermRobinGamma3BoundarySwapRow96_support_n3
    (k : Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
    (hk : k.val ≠ 12) :
    GHL2025.swapOracleMatrix
        oneTermRobinGamma3BoundaryPrefixParameters_n3
        ⟨96, by native_decide⟩ k = Coeff.rat 0 := by
  rw [GHL2025.swapOracleMatrix_eq_image]
  have hnot :
      ¬ 96 = GHL2025.swapOracleImage
          oneTermRobinGamma3BoundaryPrefixParameters_n3 k.val := by
    intro himage
    have hkval : k.val =
        GHL2025.swapOracleImage
          oneTermRobinGamma3BoundaryPrefixParameters_n3
          (GHL2025.swapOracleImage
            oneTermRobinGamma3BoundaryPrefixParameters_n3 k.val) := by
      exact (GHL2025.swapOracleImage_self_inverse
        oneTermRobinGamma3BoundaryPrefixParameters_n3 k.val).symm
    have hk12 : k.val = 12 := by
      calc k.val = _ := hkval
        _ = GHL2025.swapOracleImage
              oneTermRobinGamma3BoundaryPrefixParameters_n3 96 := by rw [← himage]
        _ = 12 := by
              have := oneTermRobinGamma3BoundarySwapRow96_image_n3
              -- swapOracleImage p 12 = 96, and involution gives swapOracleImage p 96 = 12
              native_decide
    exact hk (Fin.eq_of_val_eq hk12)
  simp [hnot]
```

Actually, this proof needs the fact that `swapOracleImage(p, 96) = 12`. We can get this
from the involution property and `swapOracleImage(p, 12) = 96`:
`swapOracleImage(p, swapOracleImage(p, 12)) = 12`, so `swapOracleImage(p, 96) = 12`.

But `native_decide` should handle this directly. The proof pattern mirrors `SwapRow0_support_n3`.

**Dependencies**: L2.

### L4: `oneTermRobinGamma3BoundaryOfSwapRow96Col97_nonzero_n3` (fact lemma)

We need to know what `OfSwap[96, 97]` evaluates to. Let us compute the OfSwap entry:
`OfSwap[96, 97] = SWAP[96, :] * O_f[:, 97]`. Since `SWAP` at row 96 is nonzero only at
column 12 (by L3), this is `O_f[12, 97]`.

Actually, for the suffix support lemma we do not need this computation. We need to show
that the suffix has support at exactly {96, 97} at row 0, column 0. Let me re-examine.

The suffix is `(O_D^BS)^dagger * OfSwap`. At row 0:
- `(O_D^BS)^dagger[0, k]` is nonzero only at `k = 96` (by L1).
- `OfSwap[96, j]` needs to be evaluated at columns j = 96 and j = 97 to see the two paths.

So the suffix support at row 0 says: `suffixMatrix[0, k] evalWith = 0` for `k ∉ {96, 97}`.

The suffix entry `suffixMatrix[0, k]` expands as:
```
suffixMatrix[0, k] = (O_D^BS)^dagger[0, :] * OfSwap[:, k]
```
By L1, `(O_D^BS)^dagger[0, j] ≠ 0` only at `j = 96`. So:
```
suffixMatrix[0, k] = (O_D^BS)^dagger[0, 96] * OfSwap[96, k] = 1 * OfSwap[96, k]
```
And `OfSwap[96, k]` itself is:
```
OfSwap[96, k] = SWAP[96, :] * O_f[:, k]
```
By L3, `SWAP[96, j] ≠ 0` only at `j = 12`. So:
```
OfSwap[96, k] = SWAP[96, 12] * O_f[12, k] = 1 * O_f[12, k]
```

So `suffixMatrix[0, k] = O_f[12, k]`, and the suffix has nonzero entries at row 0
wherever `O_f[12, k] ≠ 0`. The function oracle is full (not sparse in general), so
the suffix at row 0 does NOT have sparse support in general.

Wait -- this means the suffix-side support lemma is not about the *suffix matrix itself*
being sparse at row 0, but about the *evaluated product contribution* to the [0,0] entry.
Since the prefix already restricts to {96, 97}, we only need the suffix values at columns
96 and 97. The two-path decomposition theorem handles this.

Let me reconsider. The `sevenGateEntry00_twoPath_n3` theorem needs to show:

```
Coeff.evalWith env (sevenGateMatrix[0, 0]) =
  Coeff.evalWith env (suffixMatrix[0, 96]) * Coeff.evalWith env (prefixMatrix[96, 0]) +
  Coeff.evalWith env (suffixMatrix[0, 97]) * Coeff.evalWith env (prefixMatrix[97, 0])
```

This requires `evalWith_mul_two_path` with the prefix-side support that
`prefixMatrix[k, 0] evalWith = 0` for `k.val ∉ {96, 97}`.

So we need the **prefix** column-0 support (already compiled as `PrefixCol0Support_n3`)
applied in the two-path direction. The suffix values at columns 96 and 97 do not need
to be zero -- they are the nonzero contributions.

The key insight: the two-path decomposition comes from the prefix side (not the suffix).
The prefix at column 0 has support at rows {96, 97}. The suffix at row 0 can be nonzero
at any column. The product `suffix[0, :] * prefix[:, 0]` has exactly two nonzero terms
at k=96 and k=97 because the prefix zeros out all other k.

This means:
- **No suffix support lemma is needed** for the two-path decomposition.
- We only need `PrefixCol0Support_n3` (already compiled) and `evalWith_mul_two_path`.

### L4 (revised): `oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3`

After the two-path decomposition, we need to evaluate the suffix entries at columns
96 and 97.

```lean
private theorem oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3
    (env : String → Rat) :
    Coeff.evalWith env
        (oneTermRobinGamma3BoundarySuffixMatrix_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          ⟨96, by native_decide⟩) =
      Coeff.evalWith env
        (GHL2025.functionOraclePaperMatrix
          oneTermRobinGamma3BoundaryPrefixParameters_n3
          ⟨12, by native_decide⟩
          ⟨96, by native_decide⟩) := by
```

**Proof strategy**: Unique-path through dagger (concentrates at column 96), then
unique-path through SWAP (at row 96 concentrates at column 12).

```lean
  unfold oneTermRobinGamma3BoundarySuffixMatrix_n3
  -- Unique path through dagger at row 0: only column 96 survives
  rw [Matrix.evalWith_mul_unique_path ... ⟨96, _⟩]
  -- ... prove all other columns zero using DaggerRow0_support_n3
  -- Then evaluate the dagger entry as 1 (native_decide)
  -- Then unfold OfSwap and unique-path through SWAP at row 96: only column 12 survives
  rw [Matrix.evalWith_mul_unique_path ... ⟨12, _⟩]
  -- ... prove all other columns zero using SwapRow96_support_n3
  -- Then evaluate the SWAP entry as 1 (native_decide)
  -- Remaining: Coeff.evalWith env (O_f[12, 96])
  simp [native_decide dagger entry, native_decide swap entry]
```

Actually, we should compose this more carefully. The proof mirrors
`oneTermRobinGamma3BoundarySuffixEntryEval_n3` (line 7191) and
`oneTermRobinGamma3BoundaryOfSwapEntryEval_n3` (line 7140).

### L5: `oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3`

Identical structure to L4 but at column 97.

```lean
private theorem oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3
    (env : String → Rat) :
    Coeff.evalWith env
        (oneTermRobinGamma3BoundarySuffixMatrix_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          ⟨97, by native_decide⟩) =
      Coeff.evalWith env
        (GHL2025.functionOraclePaperMatrix
          oneTermRobinGamma3BoundaryPrefixParameters_n3
          ⟨12, by native_decide⟩
          ⟨97, by native_decide⟩) := by
```

Same proof strategy as L4. The dagger at row 0 is nonzero at any column `j`
where `j.val = image(p, 0) = 96`, so it is 1 at j=96 and 0 elsewhere.
For the suffix at column 97, the dagger at row 0 has a zero at column 97
(since `97 ≠ 96`). Wait -- that means `suffixMatrix[0, 97]` is also zero!

Let me re-examine. The dagger matrix entry formula is:
```
bandedSparseAccessPaperDaggerMatrix p i j =
  if j.val = bandedSparseAccessPaperImage(p, i.val) then Coeff.rat 1 else Coeff.rat 0
```

For `i = Row0` (i.val = 0), `image(p, 0) = 96`, so the dagger is 1 only at `j.val = 96`.

So `suffixMatrix[0, 97]`:
```
suffixMatrix[0, 97] = (O_D^BS)^dagger[0, :] * OfSwap[:, 97]
                     = (O_D^BS)^dagger[0, 96] * OfSwap[96, 97]
                     = 1 * OfSwap[96, 97]
```

The dagger concentrates at j=96 regardless of what the outer column is. The unique path
through the dagger is always at column 96 when the row is 0. Then OfSwap[96, 97] is the
remaining product. So `suffixMatrix[0, 97]` is NOT zero -- it is `OfSwap[96, 97]`.

The unique-path argument for the dagger goes:
```
suffixMatrix[0, k] = sum_j dagger[0, j] * OfSwap[j, k]
                   = dagger[0, 96] * OfSwap[96, k]     (unique path through dagger)
                   = 1 * OfSwap[96, k]
                   = OfSwap[96, k]
```

And OfSwap[96, k] = SWAP[96, :] * O_f[:, k] = SWAP[96, 12] * O_f[12, k] = O_f[12, k].

So `suffixMatrix[0, k] = O_f[12, k]` for all k. The suffix at row 0 is just `O_f[12, :]`.

This means:
- `suffixMatrix[0, 96] evalWith = O_f[12, 96] evalWith`
- `suffixMatrix[0, 97] evalWith = O_f[12, 97] evalWith`

And the two-path decomposition gives:
```
sevenGateMatrix[0, 0] evalWith = O_f[12, 96] evalWith * prefix[96, 0] evalWith
                                + O_f[12, 97] evalWith * prefix[97, 0] evalWith
```

### L6: `sevenGateEntry00_twoPath_n3`

```lean
theorem oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateEntry00TwoPath_n3
    (env : String → Rat) :
    Coeff.evalWith env
        (oneTermRobinGamma3BoundarySevenGateMatrix_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3) =
      Coeff.evalWith env
        (oneTermRobinGamma3BoundarySuffixMatrix_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          ⟨96, by native_decide⟩) *
      Coeff.evalWith env
        (oneTermRobinGamma3BoundaryPrefixMatrix_n3
          ⟨96, by native_decide⟩
          oneTermRobinGamma3BoundaryPrefixRow0_n3) +
      Coeff.evalWith env
        (oneTermRobinGamma3BoundarySuffixMatrix_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          ⟨97, by native_decide⟩) *
      Coeff.evalWith env
        (oneTermRobinGamma3BoundaryPrefixMatrix_n3
          ⟨97, by native_decide⟩
          oneTermRobinGamma3BoundaryPrefixRow0_n3) := by
  unfold oneTermRobinGamma3BoundarySevenGateMatrix_n3
  apply Matrix.evalWith_mul_two_path
  -- k0 = ⟨96, _⟩, k1 = ⟨97, _⟩
  -- prove k0 ≠ k1: native_decide on .val
  -- prove all other k give zero product: use PrefixCol0Support_n3
  intro k hk_ne96 hk_ne97
  simp [oneTermRobinGamma3BoundaryPrefixCol0Support_n3 env k
    (by rintro rfl; exact hk_ne96 (Fin.eq_of_val_eq rfl))
    (by rintro rfl; exact hk_ne97 (Fin.eq_of_val_eq rfl))]
```

**Dependencies**: L0b (evalWith_mul_two_path), `oneTermRobinGamma3BoundaryPrefixCol0Support_n3` (compiled).

---

## Dependency Graph

```
Infrastructure (CircuitSemantics.lean):
  foldl_add_two_of_nodup (L0) ──► evalWith_mul_two_path (L0b)

Suffix-side support (RobinMatrix.lean):
  [compiled: ODBSImage0_n3] ──► DaggerRow0_support_n3 (L1)
  [native_decide] ──────────► SwapRow96_image_n3 (L2)
  L2 ──────────────────────► SwapRow96_support_n3 (L3)

Two-path decomposition:
  L0b + [compiled: PrefixCol0Support_n3] ──► sevenGateEntry00_twoPath_n3 (L6)

Suffix entry evaluation (optional, for later comparison with backend fold):
  L1 + L3 ──► SuffixRow0Col96_eval_n3 (L4)
  L1 + L3 ──► SuffixRow0Col97_eval_n3 (L5)

Final comparison with backend fold:
  L6 + L4 + L5 + [prefix entry eval lemmas] ──► EvaluatedBackendFoldStatement_n3
```

## Recommended Proof Order

1. **L0**: `foldl_add_two_of_nodup` in CircuitSemantics.lean (private, ~30 lines)
2. **L0b**: `evalWith_mul_two_path` in CircuitSemantics.lean (public, ~10 lines)
3. **L1**: `oneTermRobinGamma3BoundaryDaggerRow0_support_n3` (private, ~10 lines)
4. **L2**: `oneTermRobinGamma3BoundarySwapRow96_image_n3` (private, ~3 lines)
5. **L3**: `oneTermRobinGamma3BoundarySwapRow96_support_n3` (private, ~20 lines)
6. **L6**: `sevenGateEntry00_twoPath_n3` (public, ~15 lines) -- the key theorem
7. **L4**: `oneTermRobinGamma3BoundarySuffixRow0Col96_eval_n3` (private, ~20 lines)
8. **L5**: `oneTermRobinGamma3BoundarySuffixRow0Col97_eval_n3` (private, ~20 lines)

Steps 7-8 are not needed for the two-path decomposition itself but are needed
when comparing with the backend fold to compute the actual numeric/symbolic values.

## Proof Tactics Summary

| Lemma | Primary tactic | Key supporting lemmas |
|-------|---------------|----------------------|
| L0    | induction + calc | `foldl_add_zero_of_all_zero`, `foldl_add_unique_of_nodup` |
| L0b   | rw + exact | `evalWith_mul_apply`, `foldl_add_two_of_nodup`, `finRange_nodup` |
| L1    | rw + simp | `bandedSparseAccessPaperDaggerMatrix_eq_image`, `ODBSImage0_n3` |
| L2    | native_decide | none |
| L3    | rw + calc + exact | `swapOracleMatrix_eq_image`, `swapOracleImage_self_inverse`, L2 |
| L6    | apply + intro + simp | `evalWith_mul_two_path`, `PrefixCol0Support_n3` |
| L4    | calc + apply | `evalWith_mul_unique_path`, L1, L3 |
| L5    | calc + apply | `evalWith_mul_unique_path`, L1, L3 |

## Notes

- The two-path structure at [0,0] arises because `Ry_boundary` at column 0 spreads the
  prefix into rows {0, 1}, which `O_D^BS` maps to {96, 97}. The suffix at row 0 is NOT
  sparse (it concentrates via the dagger at column 96 but then passes through O_f[12, :]
  which is not sparse). The sparsity that drives the two-path decomposition comes entirely
  from the prefix side.

- The suffix-side lemmas L4 and L5 evaluate the suffix entries to concrete O_f values.
  The comparison with the backend fold then requires computing `O_f[12, 96]` and
  `O_f[12, 97]` as `native_decide`-able Coeff expressions.

- For abbrevs: since rows 96 and 97 appear as `Fin` literals throughout, the plan
  introduces them inline (`⟨96, by native_decide⟩` and `⟨97, by native_decide⟩`).
  If the Lean elaborator struggles, private abbrevs `Row96_n3` and `Row97_n3` can be
  added following the pattern of `PrefixRow0_n3` / `PrefixRow1_n3`.
