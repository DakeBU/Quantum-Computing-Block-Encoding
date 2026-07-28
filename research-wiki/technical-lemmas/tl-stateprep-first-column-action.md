# State Preparation: First Column To State Action

- `id`: `tl-stateprep-first-column-action`
- `source`: independently proved in ABEIS after auditing QBench Base APIs
- `lean_decl`: `QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet`
- `lean_status`: `formalized`
- `local_declaration_status`: `complete`
- `broader_route_status`: `partial route`

## Statement

For a finite matrix `U`, saying that its first computational-basis column is
the target vector is equivalent to the concrete action equation
`U |0^n> = |psi>`.

## Use

Retrieve this card when a state-preparation proof has already established
`FirstColumnMatches` but a consumer expects matrix-vector action.  It has
compiled uses for a bit-flip preparation, the cubic rank-one target, and the
complex certificate wrapper.

This lemma does not prove normalization or unitarity.  Those remain separate
acceptance obligations and must not be inferred from first-column equality.

## Attribution

The implementation is an ABEIS proof over Mathlib.  Lean-QAlg-Bench and
Lean-QIT-Bench were consulted as Apache-2.0 design references; no benchmark
source or unresolved task statement was copied.
