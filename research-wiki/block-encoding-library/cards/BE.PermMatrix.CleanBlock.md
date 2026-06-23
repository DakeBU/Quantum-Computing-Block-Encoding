# BE.PermMatrix.CleanBlock

Priority: P0

Source: finite-dimensional linear algebra; used as ABEIS's first exact proof
template for reversible logical circuits.

## Detect When

The candidate unitary is represented by a finite permutation $p$ on an
auxiliary-system index space.

## Construction

For a permutation matrix

$$
U_p[y,x] =
\begin{cases}
1, & p(x)=y,\\
0, & \text{otherwise},
\end{cases}
$$

the clean block at auxiliary value $0_a$ satisfies

$$
(\langle 0_a| \otimes I)U_p(|0_a\rangle \otimes I)[r,c]
=
1
\quad\Longleftrightarrow\quad
p(0_a,c)=(0_a,r).
$$

## Lean Proof Shape

```lean
theorem cleanBlock_permMatrix_entry :
  cleanBlock zeroAux (permMatrix p) row col =
    if p (cleanIndex col) = cleanIndex row then 1 else 0 := by
  unfold cleanBlock permMatrix cleanIndex
  simp
```

Compiled Lean declarations:

- `BlockEncodingClassics.cleanBlockBy_permMatrix_entry`
- `BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry`

## Proof-DAG Leaves

- define `cleanIndex`;
- prove the candidate finite map is a permutation;
- prove the image of every clean input;
- rewrite clean-block entries through the image theorem.

## Resource Notes

The resource score comes from the circuit realizing $p$, not from the matrix
proof.  Count logical gates before hardware decomposition.

## ABEIS Examples

`QBE-OP-OPTCTRL-001` and `QBE-OP-OPTCTRL-COLD-CLEAN-001` use this as the core
entrywise bridge.
