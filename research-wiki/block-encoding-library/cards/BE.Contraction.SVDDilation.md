# BE.Contraction.SVDDilation

Priority: P1

Source: unitary dilation of contractions; useful as a theoretical fallback and
as a scalar/diagonal rotation template.

## Detect When

The target matrix satisfies $\|A\| \le 1$ and no cheaper problem-specific
structure has been found.

## Construction

The generic dilation has the form

$$
U_A =
\begin{bmatrix}
A & (I-AA^\dagger)^{1/2}\\
(I-A^\dagger A)^{1/2} & -A^\dagger
\end{bmatrix}
$$

or a sign variant.  For Lean, start with diagonal/scalar special cases:

$$
\begin{bmatrix}
x & \sqrt{1-x^2}\\
\sqrt{1-x^2} & -x
\end{bmatrix}.
$$

## Lean Proof Shape

```lean
theorem scalarDilation_unitary (hx : 0 <= x) (hx1 : x <= 1) :
  IsUnitary (scalarDilation x)

theorem scalarDilation_cleanEntry :
  scalarDilation x 0 0 = x
```

## Proof-DAG Leaves

- contraction bound;
- square-root nonnegativity;
- row/column orthogonality;
- clean entry.

## Resource Notes

General dilation proves existence but often gives poor resource scores.  Use it
as a seed or fallback, then evolve more structured circuits.
