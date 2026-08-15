# GHL Theorem 4 source audit

This note records the publication-facing interpretation checked by
`QuantumBlockEncoding/GHLHamiltonian.lean`.

The source paper explicitly constructs the one-dimensional Hamiltonian route

\[
A=\sum_k A_k,\qquad
S_1=\begin{pmatrix}(A+A^\dagger)/2&B/2\\B/2&0\end{pmatrix},\qquad
S_2=\begin{pmatrix}(A-A^\dagger)/(2i)&B/(2i)\\-B/(2i)&0\end{pmatrix},
\]

followed by

\[
H=S_1\otimes x_\xi+S_2\otimes I_\xi.
\]

ASPBE therefore does **not** list the Hamiltonian composition itself as open.
The finite-sum adjoint bridge, Hermitian split, final Hamiltonian, source
normalization/layout/resource records, and LCU clean-block algebra all have
named Lean roots.

## Printed phase audit

Eq. (29) defines both controlled source operators with a filler
`I exp(i phi)`. The first line of Eq. (30) then uses `L1(pi)` and `L2(-pi)`.
On a literal full-clean-matrix reading,

\[
e^{i\pi}=e^{-i\pi}=-1,
\]

so the two filler contributions add to `-N_A I` rather than the displayed zero
lower-right block. This is recorded rather than silently repaired:

- `QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_lowerRight`
- `QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PrintedClean_ne_S1`

A phase-balanced correction, with opposite filler phases, is then proved to
produce exactly `S1`:

- `QuantumBlockEncoding.GHL2025.Hamiltonian.eq29PhaseBalancedClean_eq_S1`

The second `S2` LCU line closes with the printed zero phases:

- `QuantumBlockEncoding.GHL2025.Hamiltonian.eq30Clean_eq_S2`

The aggregate source-audited closure is:

- `QuantumBlockEncoding.GHL2025.Hamiltonian.theorem4_source_lcu_route_closed`

The existing reusable LCU kernel separately proves unitarity and exact clean
projection for PREPARE/SELECT/UNPREPARE constructions in
`Robin/ComplexLCU.lean` and `Robin/ComplexLCUProjection.lean`.

## Publication mapping

QuantumComputinglib exposes this result as a **Compiled** Theorem-4 route and a
separate compiled phase-audit row. The textbook chapters use the new
**Concept / Math / Lean** reader modes so the source-level issue can be read
first as circuit intuition, then as matrix algebra, and finally through the
named Lean declarations.

## Remaining frontier

The remaining GHL item is a different layer: a uniform arbitrary-width
primitive compiler that expands every Theorem-3 source oracle into the chosen
primitive gate set while proving the paper-facing resource bounds. That
compiler frontier should not be conflated with the already-closed Theorem-4
Hamiltonian composition.
