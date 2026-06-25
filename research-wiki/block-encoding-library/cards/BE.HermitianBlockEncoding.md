# Card: BE.HermitianBlockEncoding

## When To Try This Route

Use when the target is Hermitian and a downstream qubitization or polynomial
transform expects a Hermitian block encoding.

## Mathematical Pattern

A Hermitian block encoding is an ordinary clean-block certificate plus a
Hermitian or symmetric condition on the larger unitary/circuit representation.

## Intuition and Caveat

There are three different statements that agents must not conflate:

1. the target matrix $A$ is Hermitian;
2. the extracted clean block is Hermitian;
3. the full block-encoding unitary has the Hermitian/reflection structure
   required by a downstream qubitization theorem.

The current Lean anchors formalize a finite symmetric surrogate and the fact
that symmetry of the full matrix transfers to the extracted clean block.  They
do not yet prove a general Hermitian block-encoding theorem for arbitrary
complex matrices.

## Lean Anchors

- `BlockEncodingClassics.IsSymmetric`
- `BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric`
- `BlockEncodingClassics.HermitianDilationContract`

## Source Memory

Lin 2201.08309 Hermitian block-encoding discussion; Low-Chuang qubitization for
the projected-unitary consumer route.
