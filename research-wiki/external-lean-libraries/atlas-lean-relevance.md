# ATLAS v1 Relevance Review

This review records which evaluated-clean ATLAS surfaces may help ASPBE and
which similarly named results are not quantum-computing lemmas.

Every row remains `external-memory-only` until a current ASPBE obligation needs it and a narrow local theorem passes `lake build && lake build Tests`.

| Upstream declaration | ASPBE decision | Reason |
| --- | --- | --- |
| [`HilbertSpace.bessel_inequality`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/IntroductionToFunctionalAnalysis/code/HilbertSpace.lean#L98) | Candidate for state-preparation analysis | Upstream scores: faithfulness 5, integrity 4, quality 4, with no reported `sorry` dependency. It may support truncation and amplitude-mass bounds; prefer Mathlib directly when possible. |
| [`SymmetricMatrixProperties.proposition2_symmetric_matrix`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/AnAlgorithmistsToolkit/code/SymmetricMatrices.lean#L76) | Candidate for real symmetric block encodings | Its spectral result is relevant, but the scalar and symmetry conventions differ from the complex-unitary ASPBE interface. |
| [`SelbergExpansion.l2NormSq_convOp_le`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/ProjectionTheory/code/SelbergExpansion.lean#L200) | Future contraction supplier | Useful for stochastic or convolution operators; it does not construct a unitary or prove an ancilla projection. |
| [`Probabilistic.polynomial_roots_le_degree`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/TheoryOfComputation/code/Probabilistic.lean#L64) and [`Probabilistic.schwartz_zippel_book`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/TheoryOfComputation/code/Probabilistic.lean#L117) | Diagnostic suppliers | They may justify randomized identity screening. Screening can reject bad candidates but cannot replace exact Lean certification. |
| [`FiniteFieldArith.fq_add_complexity_linear`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/EllipticCurves/code/FiniteFieldArith.lean#L104) | Reference only | Its bit-operation model is not the ASPBE gate/depth/ancilla/oracle tuple. |
| [`BilinearForms.exists_normalized_orthogonal_basis`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/AlgebraNotes/code/BilinearForms.lean#L64) | Reject for state preparation | It concerns real quadratic forms with weights in `{-1,0,1}`, not complex quantum-state normalization. |
| [`FourierBound.fourier_bound_finite_field`](https://github.com/facebookresearch/atlas-lean/blob/e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6/v1/Atlas/ProjectionTheory/code/FourierBoundFF.lean#L233) | Reject for QFT memory | It is a finite-field projection bound, not quantum Fourier-transform semantics. |

## Admission Priorities

1. Search ASPBE and Mathlib first.
2. Use ATLAS to discover theorem families or proof shapes.
3. Prefer direct Mathlib declarations over importing an ATLAS book.
4. Add an adapter only when it closes an active proof-DAG edge.
5. Preserve scalar, index, normalization, and resource conventions.
6. Keep randomized identities in diagnostics; Lean remains the promotion gate.
