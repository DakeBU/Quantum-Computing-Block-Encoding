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

## Intuition

A contraction is missing some norm compared with a unitary.  Dilation stores
that missing norm in an orthogonal branch.  This makes it an excellent
existence seed and a useful small-dimensional exact construction, but it
usually does not explain how to implement a scalable gate-level data-loading
oracle.

## Lean Proof Shape

```lean
def scalarDilation (x y : Rat) : Matrix 2 2 Rat

theorem scalarDilation_cleanEntry (x y : Rat) :
  scalarDilation x y fin2Zero fin2Zero = x
```

Compiled Lean leaves currently include all four scalar entries, row dot
products, unit row norms under the explicit witness `x*x + y*y = 1`, and row
orthogonality.  The full unitary package still needs a richer backend or a
small matrix-orthogonality wrapper, and a real square-root version still needs
an analytic witness.

## Proof-DAG Leaves

- contraction bound;
- square-root nonnegativity;
- row/column orthogonality;
- clean entry.

## Resource Notes

General dilation proves existence but often gives poor resource scores.  Use it
as a seed or fallback, then evolve more structured circuits.
