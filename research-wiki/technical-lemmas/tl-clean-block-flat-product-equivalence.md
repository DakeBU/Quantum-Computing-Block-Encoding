# Block Encoding: Flat And Product Projection

- `id`: `tl-clean-block-flat-product-equivalence`
- `source`: independently proved in ABEIS after auditing QBench Base APIs
- `lean_decl`: `QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct`
- `lean_status`: `formalized`
- `local_declaration_status`: `complete`
- `broader_route_status`: `partial route`

## Statement

Under ABEIS's signal-register-first ordering, the generic flattened
signal-system projection and the classic rational `cleanBlockProduct` are
pointwise the same matrix.

## Use

Retrieve this card when one module has proved a circuit-semantics block
projection and another consumer expects `cleanBlockProduct`.  Tests cover two
different signal/system dimensions and the actual BE Case 1 COLD matrix.

This bridge does not prove that the full matrix is unitary, that the clean
block equals a requested target, or that an approximation satisfies a norm
bound.

## Attribution

The implementation is an ABEIS proof.  Lean-QAlg-Bench's projected-block API
was consulted as an Apache-2.0 design reference; no benchmark source or
unresolved task statement was copied.
