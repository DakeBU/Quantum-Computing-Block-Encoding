# Proof Attempt: evalGateMatrices Associativity Bridge

Date: 2026-06-07
Target: `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`
Status: UNPROVABLE with current definitions

## Approaches Tried

### 1. `rfl` after `simp only`
Result: `maximum recursion depth has been reached`. The simp unfolds definitions but the two sides are not definitionally equal.

### 2. `native_decide`
Result: `failed to synthesize Decidable`. The matrix dimension is 8192 x 8192 (2^13), so Decidable cannot be synthesized for equality of such large functions.

### 3. `Matrix.mul_assoc` rewrite chain
Result: `Unknown constant QuantumBlockEncoding.Matrix.mul_assoc`. The custom `Matrix` type in `Core.lean` does not have a `mul_assoc` lemma.

### 4. `simp only` with `List.foldl_cons`, `List.foldl_nil` to fully reduce the fold
Result: The foldl reduces to a fully left-nested `Matrix.mul` chain. Both sides then use the same concrete matrix functions but differ in:
- LHS innermost: `(indicatorOracleMatrix ...) * (Matrix.identity ...)`
- RHS innermost: just `(indicatorOracleMatrix ...)` (no identity multiplication)
- Different parenthesization of `Matrix.mul`

## Goal State After Full Unfolding

After `simp only` with all definition unfoldings plus `List.foldl_cons`, `List.foldl_nil`:

**LHS:**
```
(bandedSparseAccessPaperDaggerMatrix p) *
  ((swapOracleMatrix p) *
    ((functionOraclePaperMatrix p) *
      ((bandedSparseAccessPaperMatrix p) *
        ((boundaryRotationMatrix p) *
          ((sparseAmplitudeOracleDTRotationMatrix p) *
            ((indicatorOracleMatrix p) *
              (Matrix.identity _ Coeff)))))))
```

**RHS:**
```
((bandedSparseAccessPaperDaggerMatrix p) *
    ((swapOracleMatrix p) *
      (functionOraclePaperMatrix p))) *
  ((bandedSparseAccessPaperMatrix p) *
    ((boundaryRotationMatrix p) *
      ((sparseAmplitudeOracleDTRotationMatrix p) *
        (indicatorOracleMatrix p))))
```

## Root Cause: Why This Sorry Cannot Be Closed

The project uses a custom `Matrix` type defined as `Fin rows -> Fin cols -> Coeff` where `Coeff` is a symbolic expression language:

```lean
inductive Coeff where
  | rat (q : Rat)
  | symbol (name : String)
  | add (a b : Coeff)
  | mul (a b : Coeff)
  | neg (a : Coeff)
deriving DecidableEq
```

`Matrix.mul A B i j` is defined as:
```lean
(List.finRange mid).foldl (fun acc k => acc + A i k * B k j) 0
```

The `+` and `*` here are `Coeff.add` and `Coeff.mul` constructors. These are NOT the same as rational addition and multiplication; they are symbolic constructors. Consequently:

1. **`Coeff.add a (Coeff.add b c) /= Coeff.add (Coeff.add a b) c`** structurally. Matrix associativity requires distributivity and associativity of the underlying ring, which do not hold at the `Coeff` constructor level.

2. **`Matrix.mul A (identity _ _) /= A`** structurally. Multiplying by the identity matrix produces a symbolic sum-of-products expression, not the original matrix entries.

3. The existing codebase proves matrix identities at the `Coeff.evalWith` level (e.g., `evalWith_mul_identity_right_apply`), not at the raw `Coeff` level. Under `evalWith`, `Coeff.add` and `Coeff.mul` become real `Rat` operations, so ring properties hold.

## Conclusion

The theorem `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` claims raw `Coeff`-level equality of two matrix expressions that differ in parenthesization. This is **not provable** because:

- Different parenthesizations of `Matrix.mul` produce different `Coeff` expression trees.
- `Coeff` is a symbolic type where `Coeff.add` and `Coeff.mul` are not associative or commutative as constructors.

To close this sorry, the theorem would need to be restated using either:
1. `Matrix.PointwiseEq` with `Coeff.evalWith` wrappers, or
2. A quotient `Coeff` type where symbolic expressions are identified up to ring axioms.

## Verification

- Build passes with 2 sorries: lines 21022 and 21060 of `RobinMatrix.lean`
- No definitions were changed
