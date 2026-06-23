# BE.PartialPermutation.MatrixUnitTensorId

Priority: P0

Source: partial-isometry completion; matrix-unit block-encoding template.

## Detect When

The target is a partial transfer:

$$
A = |u\rangle\langle v| \otimes I_S
$$

or a sum of disjoint such transfers.

## Construction

Use one clean flag/auxiliary branch.  On the source subspace $|v\rangle$, map
the clean branch to $|u\rangle$ and keep the auxiliary clean.  Send all other
clean inputs to a dirty auxiliary branch.  Complete the map to a bijection on
the whole finite basis.

## Lean Proof Shape

1. Define a finite function `p`.
2. Prove `p` is a permutation.
3. Prove for clean inputs:

```lean
p (clean, v, s) = (clean, u, s)
p (clean, x, s) has dirtyAux if x != v
```

4. Apply `BE.PermMatrix.CleanBlock`.

Compiled Lean declarations:

- `BlockEncodingClassics.partialPermutationCertificate`
- `BlockEncodingClassics.cleanBlockBy_permMatrix_entry`
- `BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry`

## Resource Notes

This route often gives exact $(\alpha,a,\epsilon)=(1,1,0)$.  Optimize gates and
depth by simplifying the predicate that detects the source subspace.

## Rejected Routes

Do not route a pure matrix-unit target through LCU or QSVT first; they add
unneeded coefficient and polynomial machinery.

## ABEIS Examples

For

$$
E_k = |0\rangle\langle k|_T \otimes |0\rangle\langle 1|_\tau \otimes I_S,
$$

this is the primary card.
