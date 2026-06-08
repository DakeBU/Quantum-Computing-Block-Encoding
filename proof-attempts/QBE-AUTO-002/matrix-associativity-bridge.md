# Proof Attempt: Matrix Associativity Bridge

Date: 2026-06-07
Target: `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`
Status: sorry-guarded intermediate (compiles)

## Attempted Proof Strategies

1. **`rfl`**: maxRecDepth exceeded. The `evalGateMatrices` fold and the
   `sevenGeneMatrix = suffixMatrix * prefixMatrix` produce different syntactic
   forms (left-nested fold vs grouped products).

2. **`simp only` with definition unfolding**: Successfully unfolds all definitions.
   The remaining goal after `simp only` is:
   ```
   foldl (fun acc gate => gate.matrix.mul acc) identity [G1,...,G7]
   =
   ((G7 * (G6 * G5)) * (G4 * (G3 * (G2 * G1))))
   ```
   This requires:
   - Fold evaluation (List.foldl over 7 elements)
   - Identity elimination (`G1 * identity = G1`)
   - Matrix multiplication associativity (re-parenthesization)

3. **`native_decide`**: Not applicable because the matrices contain symbolic
   `Coeff` values, not concrete `Rat`.

## Blocker

The project uses a custom `Matrix` type (Core.lean) with its own `Matrix.mul`
defined via `List.finRange` fold. There are no proved lemmas for:
- `Matrix.mul_assoc`: `(A * B) * C = A * (B * C)`
- `Matrix.mul_identity_right`: `A * identity = A`

These are standard linear algebra facts that need to be proved for the
project's `Matrix` type before the associativity bridge can close.

## Value of the sorry-guarded theorem

Even with sorry, the theorem:
1. Documents the exact connection between `evalGateMatrices` and `sevenGeneMatrix`
2. Reduces the remaining work to proving matrix associativity
3. Once `Matrix.mul_assoc` and `Matrix.mul_identity_right` are available,
   the proof should be a straightforward `rw` chain

## Recommendation

Add `Matrix.mul_assoc` and `Matrix.mul_identity_right` lemmas to
`QuantumBlockEncoding/Core.lean`. These are reusable infrastructure
that should have been in Phase 1. Once proved, the sorry in the
associativity bridge can be eliminated.
