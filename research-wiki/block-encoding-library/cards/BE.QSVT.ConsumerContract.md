# BE.QSVT.ConsumerContract

Priority: P2

Sources: Gilyen--Su--Low--Wiebe; Low--Chuang qubitization; QSVT expository and
application papers; Lin 2201.08309.

## Detect When

The target is not just a block encoding of $A$, but a downstream transformation
such as $p(A)$, inverse, sign, projector, filter, Hamiltonian simulation, or
singular-value transformation.

## Construction

First prove a block encoding of $A$.  Then state the QSVT theorem as an
external consumer contract unless the task explicitly asks to formalize QSVT.

## Lean Proof Shape

```lean
structure QSVTContract where
  inputBE : IsBlockEncodingApprox alpha a U A eps
  polynomial : Polynomial C
  parity_ok : ...
  bounded_on_interval : ...
  outputBE : IsBlockEncodingApprox alpha' a' Uout (p.evalMatrix A) eps'
```

## Proof-DAG Leaves

- input block encoding;
- polynomial side conditions;
- error budget propagation;
- resource accounting.

Compiled Lean declaration:

- `BlockEncodingClassics.QSVTConsumerContract`
- `BlockEncodingClassics.QubitizationChebyshevContract`
- `BlockEncodingClassics.chebyshevT`

## Reviewer Warning

Do not use QSVT to hide an unproved block encoding.  QSVT is a consumer of a
certificate, not a substitute for one.
