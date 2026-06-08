# Proof Architect Plan: Active/Prepared Composition Closure

Task: QBE-AUTO-002, Cycle 1
Target: `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`
Date: 2026-06-07
Status: updated proof architect analysis

## 1. Source-Paper Fragment

The GHL2025 paper (arXiv:2506.20478) provides:
- Seven-gate circuit construction: Fig. `1 term ROBIN`
- Block-encoding definition: Definition `def:block-encoding`
- Robin boundary coefficient formula: Eq. `ROBIN clarified`
- Sparse-register amplitude construction: Eq. `arbitrary sparcity`

The paper does NOT provide an explicit matrix-entry computation showing that
the `[0,0]` entry of the seven-gate product equals the block encoding
coefficient.  The equality follows from the operator-level block encoding
definition and the uniform sparse-register preparation.  QBE must verify this
finite matrix identity at n=3.

**Classification**: Not a source-contract gap.  The paper provides the
construction and the target equation at the operator level.

## 2. Natural-Language Proof of the Active/Prepared Target

### Target statement (after compiled reductions)

The uncast active/prepared composite eval statement is:

> For all `env : String → Rat` and `H` satisfying the HWKappa uniform column
> contract, `Coeff.evalWith env (evalGateMatrices(placeholders)[0, 0])` equals
> `Coeff.evalWith env (preparedSandwichSum(H))`.

### Definitions used

**D1.** `PrefixRow0 = 0` — the clean signal-zero basis index.
**D2.** `PrefixSource = 32` — the boundary source column index.
**D3.** `fullIndex(s) = s * 2^clog2(7) = s * 16` for `s : Fin 7` — maps sparse
        slot `s` to the full circuit matrix index.  In particular,
        `fullIndex(0) = 0 = PrefixRow0` and `fullIndex(2) = 32 = PrefixSource`.
**D4.** `sevenGateMatrix = suffixMatrix * prefixMatrix` where
        `prefixMatrix = bandedSparseAccessPaper * RDUPrefix` and
        `suffixMatrix = bandedSparseAccessPaperDagger * OfSwapMatrix`.
**D5.** `projectionAmplitudeFactor = sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv`
        (compiled, line 9854).
**D6.** `backendBranchContribution(s) = sevenGateMatrix[fullIndex(s), fullIndex(s)] * kappa_inv`.
**D7.** `backendFold = sum_{s=0}^{6} backendBranchContribution(s)`.
**D8.** Under HWKappa uniform column:
        `preparedSandwichSum(H) = backendFold` (compiled, line 16500).
**D9.** The prepared composite clean entry evaluates to the backend fold under
        HWKappa (compiled, line 18679).

### Proof route

**Step 0 (Compiled).** Reduce `ActivePreparedCompositeEvalStatement` to
`UncastActivePreparedCompositeEvalStatement` via
`ActivePreparedCompositeEvalStatement_iff_uncast_n3` (line 18164).

**Step 1 (Compiled).** Reduce `UncastActivePreparedCompositeEvalStatement` to
`UncastPreparedSandwichEvalStatement` via
`UncastActivePreparedCompositeEval_iff_preparedSandwich_n3` (line 18301).
The remaining target is:
```
evalGateMatrices(placeholders)[PrefixRow0, PrefixRow0] evalWith
= preparedSandwichSum(H) evalWith
```

**Step 2 (Compiled, conditional on HWKappa).** Under HWKappa,
`preparedSandwichSum(H) = backendFold` (line 16500) and
`preparedComposite.matrix[clean, clean] evalWith = backendFold evalWith` (line 18679).
So the target under HWKappa reduces to:
```
evalGateMatrices(placeholders)[PrefixRow0, PrefixRow0] evalWith
= backendFold evalWith
```

**Step 3 (Compiled partial).** The slot-0 backend summand is the active
`[0,0]` entry times `kappa_inv`:
```
backendBranchContribution(0) = sevenGateMatrix[PrefixRow0, PrefixRow0] * kappa_inv
```
(Compiled, `BackendBranchContribution_slotZero_n3`, line 14815.)

Therefore the backend fold expands to:
```
backendFold = sevenGateMatrix[0, 0] * kappa_inv
           + sum_{s=1}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)] * kappa_inv
```

**Step 4 (OPEN — the core obstruction).** The remaining equality is:
```
sevenGateMatrix[0, 0] = kappa_inv * sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)]
```
Since `fullIndex(0) = 0`, this simplifies to:
```
7 * sevenGateMatrix[0, 0] = sum_{s=0}^{6} sevenGateMatrix[fullIndex(s), fullIndex(s)]
```
which requires **diagonal uniformity**: all 7 sparse-slot diagonal entries of
the seven-gate matrix must be equal.

### Why the HWKappa contract does not resolve the obstruction

The HWKappa contract establishes the prepared-side simplification
(`preparedComposite → backendFold`), but the active side
(`evalGateMatrices(placeholders)[0, 0]`) does not depend on `H`.  Therefore the
obstruction is purely about the seven-gate matrix structure and is the same as
the frozen H-free fold.

## 3. Dependency-Ordered Intermediate Lemmas

### L0 (BLOCKING INFRASTRUCTURE): Matrix associativity bridge

```
theorem evalGateMatrices_eq_sevenGateMatrix_n3 :
    evalGateMatrices (oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)) =
      oneTermRobinGamma3BoundarySevenGateMatrix_n3
```

**Status**: sorry-guarded, compiles.  Blocked on `Matrix.mul_assoc` and
`Matrix.mul_identity_right` for the project's custom `Matrix` type.

**Dependencies**: Requires new lemmas in `Core.lean`:
- `Matrix.mul_assoc : (A * B) * C = A * (B * C)`
- `Matrix.mul_identity_right : A * 1 = A`

**Reuses**: None — these are standard linear algebra facts not yet proved for
the project's `Matrix`.

### L1 (PRIMARY NEW TARGET): Column-0 unique-path for [0, 0]

```
theorem sevenGateEntry00_uniquePath_n3 (env) :
    Coeff.evalWith env (sevenGateMatrix PrefixRow0 PrefixRow0) =
      Coeff.evalWith env (suffixMatrix PrefixRow0 k0) *
      Coeff.evalWith env (prefixMatrix k0 PrefixRow0)
```

where `k0` is the unique surviving intermediate row.

**Analog**: `gamma3BoundarySevenGateUniquePath_n3` (line 6970) proves this for
`[PrefixSource, PrefixSource] = [32, 32]` with `k0 = PrefixRow0 = 0`.

**Dependencies**: New support lemmas for position `[0, 0]`:
- `suffixMatrix[PrefixRow0, k] = 0` for all `k ≠ k0` (evalUnder env)
- `prefixMatrix[k, PrefixRow0] = 0` for all `k ≠ k0` (evalUnder env)

These require analyzing the support of `bandedSparseAccessPaperDagger`,
`swapOracleMatrix`, `indicatorOracleMatrix`, `bandedSparseAccessPaper`, and
`RDUPrefix` at row/column 0.

**Reuses**: `Matrix.evalWith_mul_unique_path` (used by the [32, 32] theorem).

### L2 (IF L1 SUCCEEDS): Diagonal entry uniformity

```
theorem sevenGateDiagonalUniform_n3 (env) (s : Fin 7) :
    Coeff.evalWith env (sevenGateMatrix (fullIndex s) (fullIndex s)) =
      Coeff.evalWith env (sevenGateMatrix PrefixRow0 PrefixRow0)
```

This would follow if all 7 positions have the same unique-path product.

**Dependencies**: Unique-path decompositions for positions 16, 32, 48, 64, 80,
96 (6 new theorems analogous to L1), plus a proof that the products are equal.

**Reuses**: L1 for position 0, existing unique-path for position 32.

### L3 (IF L2 SUCCEEDS): Active entry = backend fold

```
theorem activeEntry_eq_backendFold_n3 (env) :
    Coeff.evalWith env (sevenGateMatrix PrefixRow0 PrefixRow0) =
      Coeff.evalWith env (blockExtractionBranchContributionSum backendBranchContribution)
```

This follows from L2 by dividing the uniformity equation by kappa.

**Dependencies**: L2, `BackendBranchContribution_slotZero_n3`.

**Reuses**: `BackendBranchFold_expandedSlotZero_n3`.

### L4 (FINAL): Uncast active/prepared sandwich eval

```
theorem uncastActivePreparedSandwichEval_n3 (H env) (hUniform : HWKappa ...) :
    UncastActivePreparedCompositeEvalStatement H env
```

**Dependencies**: L0 (associativity bridge), L3 (active = backend fold),
`PreparedCompositeCleanEntryEval_eq_backend_n3` (compiled).

**Reuses**: All compiled equivalence theorems in the existing chain.

## 4. Failure Analysis

### A. Direct computation (rfl, native_decide) fails

- `rfl`: maxRecDepth exceeded (different syntactic forms for fold vs product).
- `native_decide`: OOM at 19GB, killed after 780s.  The seven-gate matrix is
  at least 128x128 with symbolic `Coeff` entries; expanding 7 diagonal entries
  and checking their average exceeds available memory.

### B. The HWKappa contract alone does not resolve the obstruction

The HWKappa uniform column contract simplifies the prepared side to the backend
fold, but the active side is H-independent.  The frozen H-free fold is the
same obstruction regardless of HWKappa.

### C. The matrix associativity bridge is sorry-guarded infrastructure

The sorry-guarded theorem `evalGateMatrices_eq_sevenGateMatrix_n3` compiles but
requires `Matrix.mul_assoc` and `Matrix.mul_identity_right`.  These are
reusable infrastructure lemmas not yet proved for the project's custom `Matrix`
type.  Proving them is valuable but orthogonal to the diagonal uniformity.

### D. The diagonal uniformity may require new support lemmas for each position

The existing support analysis covers position [32, 32] (PrefixSource).  Position
[0, 0] (PrefixRow0) has a different relationship to the gates:
- `bandedSparseAccessPaper` maps `PrefixSource = 32` to `PrefixRow0 = 0`
- The inverse dagger maps `PrefixSource` back
- Position 0 might have a wider support set due to the SWAP gate acting on row 0

The SWAP gate swaps row 0 with the signal row.  This means the support of
`suffixMatrix[0, k]` might include rows other than just `k = 0`, making the
unique-path argument harder for position [0, 0].

### E. Mathematical assessment

The diagonal uniformity IS expected to hold because the seven-gate circuit is a
valid block encoding: the [0,0] entry equals the encoding coefficient, and the
sparse-register preparation with uniform amplitudes extracts this coefficient as
the average diagonal entry.  The paper implicitly relies on this property at
the operator level.  The Lean verification requires checking it at the finite
n=3 level.

## 5. Recommended Lean Worker Targets (Priority Order)

### Priority 1: Column-0 support analysis for [0, 0]

Prove support lemmas for the [0, 0] entry of the seven-gate matrix.  Specifically:
1. Analyze `suffixMatrix[0, k]` — which intermediate rows `k` contribute?
2. Analyze `prefixMatrix[k, 0]` — which intermediate columns `k` contribute?
3. If the support is a single row, prove the unique-path theorem (L1 above).
4. If the support has multiple rows, record the support structure and estimate
   feasibility.

This is the smallest investigation that determines whether the unique-path
route is viable for the [0, 0] entry.

### Priority 2 (if L1 blocked): Matrix infrastructure

Add `Matrix.mul_assoc` and `Matrix.mul_identity_right` to `Core.lean`.  These
are reusable lemmas that unblock the sorry in the associativity bridge.

### Priority 3 (if L1 succeeds): Extend to all 7 positions

Try the unique-path decomposition for position 16 (fullIndex(1)).  If this
works and gives the same product as position 0, try the remaining positions.

## Existing Declarations to Reuse

| Declaration | Line | Role |
|---|---|---|
| `Matrix.evalWith_mul_unique_path` | Core.lean | unique-path reducer |
| `gamma3BoundarySevenGateSupport_n3` | 6945 | support for [32, 32] |
| `gamma3BoundarySevenGateUniquePath_n3` | 6970 | unique-path for [32, 32] |
| `BackendBranchContribution_slotZero_n3` | 14815 | slot-0 = active * kappa_inv |
| `BackendBranchFold_expandedSlotZero_n3` | 14838 | 7-term fold expansion |
| `PreparedProjectionSandwichSum_eq_backend_n3` | 16500 | sandwich = backend under HWKappa |
| `PreparedCompositeCleanEntryEval_eq_backend_n3` | 18679 | prepared clean = backend under HWKappa |
| `ActivePreparedCompositeEvalStatement_iff_uncast_n3` | 18164 | target ↔ uncast |
| `UncastActivePreparedCompositeEval_iff_preparedSandwich_n3` | 18301 | uncast ↔ sandwich |
| `IndicatorSource_support_n3` | 6628 | U_indic column support |
| `SwapRow0_support_n3` | 6834 | SWAP row support |
| `DaggerRow32_support_n3` | 6865 | O_D^BS_dagger row support |
| `RDUPrefixSupport_n3` | 6762 | RDU prefix support |
| `SuffixRow32Col1_zero_n3` | 6921 | suffix row-32 col-1 zero |
| `gamma3BoundaryPrefixSupport_n3` | (near 6757) | prefix support excluding {0, 1} |
