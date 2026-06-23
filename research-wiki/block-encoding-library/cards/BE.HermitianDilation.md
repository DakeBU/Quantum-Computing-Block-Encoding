# BE.HermitianDilation

Priority: P1

Source: standard Hermitian dilation used before applying Hermitian algorithms
or QSVT/QSP-style transformations.

## Detect When

The target $A$ is non-Hermitian but the downstream algorithm expects a
Hermitian block encoding.

## Construction

Use

$$
H(A) =
\begin{bmatrix}
0 & A\\
A^\dagger & 0
\end{bmatrix}.
$$

## Lean Proof Shape

```lean
def hermitianDilation A := fromBlocks 0 A A.conjTranspose 0

theorem hermitianDilation_isHermitian :
  (hermitianDilation A).conjTranspose = hermitianDilation A
```

Then connect a block encoding of $A$ to a block encoding of $H(A)$ through one
selector qubit.

Compiled Lean declaration:

- `BlockEncodingClassics.HermitianDilationContract`

## Proof-DAG Leaves

- block matrix entry cases;
- conjugate-transpose simplification;
- selector-qubit clean block theorem;
- downstream QSVT contract if used.

## Resource Notes

Adds one selector qubit and controlled uses of the original block encoding.
