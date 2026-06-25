# Card: BE.EntrywiseExact.CleanBlock

## When To Try This Route

Use this card whenever a candidate unitary has a concrete clean ancilla state
and the target can be checked entry by entry.

## Mathematical Pattern

For exact block encoding, prove:

$$
\langle 0^a,i|U|0^a,j\rangle = A_{ij}/\alpha.
$$

Then the clean block equals $A/\alpha$ by matrix extensionality.

## Lean Anchors

- `BlockEncodingClassics.cleanBlockBy_permMatrix_entry`
- `BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry`
- `BlockEncodingClassics.cleanBlockProduct_permMatrix_entry`
- `BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry`

## Proof Leaves

1. Define the clean embedding.
2. Prove the entry formula for every row and column.
3. Package the result as `ExactCleanBlock` or a task-specific certificate.

## Source Memory

Lin 2201.08309, block-encoding definition and entrywise examples.
