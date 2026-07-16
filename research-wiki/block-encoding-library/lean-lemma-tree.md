# ABEIS Lean Lemma Tree

This ledger is the textual companion to `docs/assets/abeis_lean_lemma_tree.svg`.
It presents mathematical dependencies rather than Lean import order. The
generated `compiled-lean-leaf-index.md` remains the exhaustive declaration and
line-number index.

## Layer 1: foundations

- `Core.lean`: finite `Matrix`, `PointwiseEq`, grid arithmetic, and coefficient
  evaluation.
- `CircuitSemantics.lean`: evaluated products, path collapse, signal indices,
  and clean-block extraction.
- `Circuit.lean`: gates, circuits, and layered schedules.
- `Resources.lean`: gate count, depth, auxiliary qubits, and oracle calls.

## Layer 2: semantic certificates

- State preparation: `StatePreparationTarget`, `FirstColumnMatches`, exact and
  approximate verified records.
- Exact block encoding: `BlockEncodingClassics.ExactCleanBlock` and
  `ExactCleanBlock.clean_eq_target`.
- Approximate block encoding: verified approximate records and zero-error
  promotion from exact certificates.
- Candidate selection: target fidelity is a gate; `Resource` fields are
  compared only among semantically valid candidates.

## Layer 3: reusable routes

- Permutations: `permMatrix`, row/column inner products, rational
  orthogonality from bijectivity, and partial-permutation certificates.
- Householder completion: rational clean-entry and orthogonality leaves,
  followed by branchwise controlled direct sums.
- Sparse/value oracles: one-sparse support, row/column delta collapse, and
  compute-rotate-uncompute contracts.
- LCU/product: weighted sums, matrix-product congruence, exact clean-block
  products, and resource composition.
- QSVT/dilation: typed polynomial consumers and scalar contraction fallbacks;
  a consumer contract never supplies its own missing input oracle.

## BE Case 1 path

```text
coldE1CandidateImage_permutation_certificate
  + coldE1Candidate_blockProjection
  -> isolated no-Pro certificate (4,4,1,0)

evolvedEqFlipUnitary_isRationalOrthogonal
  + evolvedEqFlipUnitary_cleanBlock
  -> evolvedEqFlipVerified
  -> evolvedEqFlipZeroErrorApprox
  -> certified champion (4,2,1,0)
```

The source module remains `MainCase.lean` for compatibility, while the
reader-facing name is BE Case 1.

## BE Case 2 linear path

```text
Nat.sum_four_squares
  -> linearDiagonalRationalCompletion_exists
  -> linearDiagonalFourSquareBranchVector_clean
  +  linearDiagonalFourSquareBranchVector_unit
  -> householder8_clean_entry
  +  householder8_isRationalOrthogonal
  -> controlledHouseholder8DirectSum_clean_entry
  +  controlledHouseholder8DirectSum_isRationalOrthogonal
  -> linearDiagonalRationalCompletion_backendSupport
  -> linearDiagonalHouseholderInputBEContract_complete
```

## BE Case 2 cubic path

```text
Nat.sum_four_squares
  -> cubicDiagonalRationalCompletion_exists
  -> cubicDiagonalFourSquareBranchVector_clean
  +  cubicDiagonalFourSquareBranchVector_unit
  -> householder8_clean_entry
  +  householder8_isRationalOrthogonal
  -> controlledHouseholder8DirectSum_clean_entry_of_branchValue
  +  controlledHouseholder8DirectSum_isRationalOrthogonal
  -> cubicDiagonalRationalCompletion_backendSupport
  -> cubicDiagonalHouseholderExactBEContract_complete
```

The hinted identity `O_0^3 = D_n` and the QSVT consumer route remain retrieval
edges. They are not needed to close the direct exact cubic root.

## Acceptance layer

1. Compile every task-declared root anchor.
2. Run the task-declared executable command under its source and environment
   digest.
3. Require every declared Qiskit/QASM artifact.
4. Promote to `complete` only when both gates pass.

Finite Qiskit checks validate declared instances; they do not replace the
symbolic Lean roots.
