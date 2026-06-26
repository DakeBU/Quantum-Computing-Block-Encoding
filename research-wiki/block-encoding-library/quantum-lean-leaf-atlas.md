# Quantum Lean Leaf Atlas

This atlas connects ABEIS block-encoding leaves with nearby Lean quantum
libraries.  It is an agent memory file, not the public module graph and not a
dependency manifest: agents may read these projects for API and proof-style
inspiration, but a theorem counts for ABEIS only when the corresponding local
Lean declaration compiles.

The public ABEIS module/leaf graph is
[`lean-leaf-module-graph.md`](lean-leaf-module-graph.md), with the rendered PNG
at `docs/assets/abeis_lean_leaf_module_graph.png`.

## Reference Libraries

| Library | Useful surface | ABEIS relationship |
| --- | --- | --- |
| Mathlib | finite types, matrices, finite sums, extensionality, algebraic rewriting | upstream quality target for generic leaves; every reusable ABEIS lemma should be small enough to plausibly become a Mathlib-style theorem |
| [duckki/quantum-computing-lean](https://github.com/duckki/quantum-computing-lean) | finite-dimensional matrix API, named states, basic gates, projectors, gate actions, decompositions, theorem examples such as unitarity and no-cloning | reference for public module organization and small gate/action lemmas; not copied into ABEIS because the inspected checkout has no top-level license file |
| [Timeroot/Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo) | finite-dimensional quantum-information formalization style | reference for quantum states, measurements, and matrix-level proof organization |
| [Hayata-Yamasaki-Group/lean-quantum](https://github.com/Hayata-Yamasaki-Group/lean-quantum) | broader quantum states, channels, qudits, entropy, trace inequalities, operator-theoretic conventions | reference for larger quantum-information APIs and future high-level semantics |

The detailed index card for `quantum-computing-lean` is
[`../external-lean-libraries/quantum-computing-lean.md`](../external-lean-libraries/quantum-computing-lean.md).

## ABEIS Leaf Map

| ABEIS leaf family | Current declarations | Nearby external reference surface | Reusable intuition |
| --- | --- | --- | --- |
| Clean-block extraction | `cleanBlockBy_permMatrix_entry`, `cleanBlockBy_permMatrix_eq_target_of_entry`, `cleanBlockProduct_permMatrix_entry` | duckki matrix/projection style; Mathlib matrix extensionality | reduce a block encoding to entries of `U(clean,row)(clean,col)` |
| Permutation and reversible images | `partialPermutationCertificate`, `permMatrix_isRationalOrthogonal_of_bijective` | duckki gate unitarity examples such as `X_isUnitary`, `CNOT_isUnitary`, `SWAP_isUnitary` | prove the finite image table once, then reuse it for clean-block equality and unitarity |
| Gate-action examples | main-case transfer-operator lemmas and Qiskit exports | duckki action lemmas such as `X_mul_ket0`, `CNOT_mul_ket10`, `TOFFOLI_mul_basis`, `SWAP_kron` | keep basis-state action lemmas separate from matrix equality and resource accounting |
| One-sparse and sparse access | `oneSparseMatrix_entry_if`, `oneSparse_from_support`, `sparseColumnCleanEntry_unique_slot`, `rowColumnSparseDeltaEntry` | Lin 2201.08309 textbook route; Mathlib finite sums | write the sparse proof as a delta-collapse leaf, not as a monolithic circuit expansion |
| LCU and product arithmetic | `oneTermLCU_cleanBlock`, `twoTermLCUCertificate`, `productExactCleanBlockCertificate`, `matrix_mul_congr_pointwise` | Mathlib matrix multiplication and finite sums; future quantum-library composition APIs | separate component certificates from the algebraic product/weighted-sum bridge |
| Dilation and Hermitian contracts | `scalarDilation_cleanEntry`, row-norm and row-orthogonality leaves, `HermitianDilationContract` | Mathlib real/algebraic identities; lean-quantum operator style | first prove scalar/diagonal contractions, then promote to matrix-level dilation |
| QSVT consumers | `QSVTConsumerContract`, `QubitizationChebyshevContract`, Chebyshev recurrence leaves | GSLW/Low-Chuang/Lin proof patterns; future polynomial APIs | QSVT consumes a proved block encoding; it must not hide the original oracle construction |
| Approximate block encoding | `exactAsZeroErrorApproxCleanBlock` and epsilon-tier task records | norm APIs from Mathlib and quantum libraries | exact certificates become epsilon-zero incumbents before approximate search starts |

## Proof-DAG View

```text
Mathlib finite algebra
  -> clean-block extensionality
  -> finite image / permutation matrix leaves
  -> one-sparse, sparse, LCU, product, dilation leaves
  -> exact block-encoding certificates
  -> approximate epsilon-tier certificates
  -> paper/user-facing LaTeX proof and executable Qiskit/QASM export

duckki quantum-computing-lean
  -> named states, gates, projectors, action/unitarity proof style
  -> ABEIS finite gate-action packets and future gate-library alignment

Lean-QuantumInfo / lean-quantum
  -> quantum-information semantic style
  -> future channels, measurements, trace/norm, and higher-level semantics
```

## Mathlib-Quality Leaf Policy

Agents should treat persistent failure as information about the statement, not
as a reason to churn tactics.  Use this checklist before assigning a leaf:

- Search Mathlib before inventing generic infrastructure.  The standard command
  is `python3 tools/qbe.py mathlib-search "<keyword-or-theorem-name>"`.
  Record useful hits under `research-wiki/mathlib-lemmas/`.
- Decompose aggressively.  A target theorem should fit in one agent context
  and usually one local API surface.
- Specify more than the theorem.  Include intended definitions, local helper
  lemmas, and the proof route.
- Keep the statement stable.  Do not repeatedly change a proof target unless
  the reviewer or upper layer has identified a real missing assumption or
  counterexample.
- Make hidden regularity reusable.  Nonemptiness, boundedness, cleanup,
  support uniqueness, reversibility, and norm side conditions should become
  named contracts.
- Separate proof layers.  Clean-block equality, unitarity, circuit realization,
  resource score, and executable export are different leaves.
- Prefer theorem names and hypotheses that would still make sense in Mathlib.

If a Mathlib theorem exists but the project cannot import it yet, the proof
packet should still name the theorem and module.  The local Lean worker should
then prove only the narrow adapter needed by ABEIS, not a broad replacement for
Mathlib.

## Agent Usage

Upper agents read this atlas to choose plausible proof routes and to avoid
starting from zero.  Middle agents turn the chosen route into small proof-DAG
packets and maintain the insight pool.  Lower Lean workers prove one leaf at a
time.  Natural-language workers may propose a construction or proof sketch,
but reviewer agents promote it only after the Lean leaf compiles or after it is
recorded explicitly as a contract or obligation.

This atlas is intentionally not a rigid detector.  Block-encoding construction
often needs the same kind of brainstorming, mutation, recombination, and
selection used in evolutionary search.  The atlas supplies reusable moves; the
harness decides which move is worth trying for the current oracle.
