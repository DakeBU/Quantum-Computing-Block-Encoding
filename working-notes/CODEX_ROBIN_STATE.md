# ROBIN PROOF STATE

- Integration target: `main` after the Robin completion branch is audited.
- Compiled structural roots: five-shift, source-like seven-slot, Hadamard-8,
  centrosymmetric four-slot sectors, and the six-slot cap-sum certificate.
- Compiled T2 roots: `warmRobinHadamard8VerifiedBlockEncoding` and
  `warmRobinFourSlotVerifiedBlockEncoding`, including original-basis clean
  blocks at normalizer `56/3`.
- Compiled comparison root:
  `warmRobinFourSlotT2Cost_betterThan_hadamard8`. Under the shared T2 schedule,
  gate count and depth tie and the four-slot route uses one fewer auxiliary.
- Open T3 leaf: give an exact primitive gate list and matrix semantics, then
  prove its product equals the corresponding T2 logical unitary.
- Rejected claim: Qiskit transpilation or floating-point agreement is not a
  Lean primitive-refinement theorem.
- Resource convention: logical one-qubit rotations plus CNOT; SWAP = 3 CNOT;
  expand PREPARE, SELECT, truth-table logic, and uncompute.
