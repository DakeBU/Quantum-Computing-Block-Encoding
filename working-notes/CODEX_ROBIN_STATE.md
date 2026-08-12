# CODEX ROBIN STATE

- Branch: `agent/robin-t2-verified`
- Base: `main@159d2b8047707a5cbe45c8d1fa6b2a861bb278a8`
- Baseline CI: current Robin T1 modules and exporter pass on Actions run 31617871357.
- Current proof root: `warmRobinSymmetryPlusFourShiftDecomposition` and `warmRobinSymmetryMinusFourShiftDecomposition` pending compile.
- Current failing leaf: no concrete complex-unitary PREPARE/amplitude/SELECT/unprepare theorem.
- Accepted candidates: five-shift structural LCU; Hadamard-8 structural LCU; centrosymmetric four-slot sector decomposition.
- Rejected claims: source/candidate resource dominance before same-tier primitive expansion.
- Resource convention: logical one-qubit rotations plus CNOT; SWAP = 3 CNOT; expand PREPARE, SELECT, truth-table logic, and uncompute.
- Next action: compile the symmetry decomposition, then add a reusable finite complex LCU semantics kernel.
