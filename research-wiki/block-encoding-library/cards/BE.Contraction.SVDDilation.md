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
def scalarDilation (x y : Rat) : Matrix 2 2 Rat

theorem scalarDilation_cleanEntry (x y : Rat) :
  scalarDilation x y fin2Zero fin2Zero = x
```

The full unitary theorem needs a backend that can express
`y * y = 1 - x * x` or a real square-root witness.  Until then, the clean-entry
leaf is formalized and unitarity remains an explicit obligation.

## Proof-DAG Leaves

- contraction bound;
- square-root nonnegativity;
- row/column orthogonality;
- clean entry.

## Resource Notes

General dilation proves existence but often gives poor resource scores.  Use it
as a seed or fallback, then evolve more structured circuits.
