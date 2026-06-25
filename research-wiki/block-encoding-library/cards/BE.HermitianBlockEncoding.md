# Card: BE.HermitianBlockEncoding

## Detection

Use when the target is Hermitian and a downstream qubitization or polynomial
transform expects a Hermitian block encoding.

## Mathematical Pattern

A Hermitian block encoding is an ordinary clean-block certificate plus a
Hermitian or symmetric condition on the larger unitary/circuit representation.

## Lean Anchors

- `BlockEncodingClassics.IsSymmetric`
- `BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric`
- `BlockEncodingClassics.HermitianDilationContract`

## Source Memory

Lin 2201.08309 Hermitian block-encoding discussion; Low-Chuang qubitization for
the projected-unitary consumer route.
