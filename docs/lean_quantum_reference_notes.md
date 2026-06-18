# lean-quantum Reference Notes

Reference repository:
[Hayata-Yamasaki-Group/lean-quantum](https://github.com/Hayata-Yamasaki-Group/lean-quantum)

Local checkout:
`../outer_repos/quantum/lean-quantum`

## What It Contains

`lean-quantum` is a Lean formalization project for quantum information and
quantum computation.  The checkout currently exposes modules for:

- quantum states, qudits, density operators, projections, and unitary
  operators;
- quantum channels and partial traces;
- Naimark extension;
- quantum entropy and trace inequalities, including sandwiched Renyi relative
  entropy and operator inequalities.

It is Apache-2.0 licensed.  ABEIS should cite the upstream repository when it
uses the project as a style or lemma reference.

## What ABEIS Should Borrow

- Use its `Qudit`, linear-map, trace, density, and unitary conventions as a
  reference when ABEIS moves beyond finite matrix toy semantics to
  Hilbert-space/operator-theoretic statements.
- Compare its notation for adjoints, traces, tensor products, and completely
  positive maps with ABEIS notation before introducing new public APIs.
- Use it as a memory library for future tasks that need quantum information
  facts rather than gate-list combinatorics.

## What ABEIS Should Not Borrow Blindly

- Do not treat `lean-quantum` as an imported dependency until the lake
  dependency and Mathlib versions are audited.
- Do not replace ABEIS finite circuit/block-encoding predicates with
  operator-theoretic definitions without proving a bridge between the two
  semantic levels.
- Do not claim a block-encoding theorem is proved because a related
  quantum-state or channel fact exists in the external project.

## Current ABEIS Status

`lean-quantum` is a reference library, not a compiled dependency of ABEIS.  The
next useful integration step is a small bridge note comparing:

1. ABEIS finite matrix unitarity;
2. `lean-quantum` unitary linear-map conventions;
3. the theorem needed to move a finite gate matrix into an operator statement.

