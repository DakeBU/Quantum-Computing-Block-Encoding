# Guseynov-Huang-Liu 2025 Notes

The paper's contribution, for this project, is the move from oracle-query
complexity to explicit gate-level construction for PDE block encodings.

## Pipeline

1. Discretize a linear PDE:
   `du/dt = A u + v`, with `A = sum_k A_k`.
2. Homogenize the inhomogeneous term with an added register:
   `S = [[A, B], [0, 0]]`.
3. Schrodingerise the non-Hermitian system:
   `H = S1 tensor x_xi + S2 tensor I_xi`.
4. If coefficients depend on time, add a clock dimension:
   `H' = p_s tensor I + H(t -> x_s)`.
5. Construct block encodings of the pieces using explicit circuits.
6. Feed the Hamiltonian block encoding to QSVT/QSP simulation.

## Key Circuit Ingredients

- Banded sparse access: converts sparse diagonal index `s` and row `i` into
  the corresponding column index.
- Sparse-amplitude oracle: encodes constant-per-band derivative entries for
  periodic/bulk rows.
- Piecewise-polynomial amplitude oracle: encodes diagonal coefficient
  functions `f(x)` and `v(x)`.
- Robin boundary extension: use an indicator/comparator to separate bulk rows
  from boundary rows, then handle the finite number of boundary deviations by
  controlled rotations.
- LCU composition: combine `A_k`, `A_k^dagger`, `B`, `S1`, `S2`, and finally
  `H`.

## First Formal Targets

- `GHL2025.oneTermRobinClaim`
- `GHL2025.oneDimHamiltonianClaim`
- `GHL2025.multiDimHamiltonianClaim`

These are currently Lean data and resource formulas.  The next step is to give
the circuit IR concrete matrix semantics and replace the placeholder proof
obligations in `VerifiedBlockEncoding` with actual unitary and block-correctness
predicates.
