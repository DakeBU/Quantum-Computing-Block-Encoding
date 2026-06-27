# ABEIS Lean Leaf Module Graph

This file is the textual ledger behind the public Lean leaf module graph
`docs/assets/abeis_lean_leaf_module_graph.svg`.  It lists the Lean files that
form the current block-encoding proof-weapon library and records which compiled
leaf families they provide.

For the complete generated declaration list, see
[`compiled-lean-leaf-index.md`](compiled-lean-leaf-index.md) and the
machine-readable [`compiled-lean-leaf-index.json`](compiled-lean-leaf-index.json).

The graph is intentionally organized like a library map, not like a run log.
It should help a quantum-computing reader answer:

1. where the reusable Lean proof leaves live;
2. which leaves are generic enough to become Mathlib-quality infrastructure;
3. which leaves are ABEIS-specific block-encoding/circuit contracts;
4. which examples and paper baselines consume the leaves.

## Rendered Graph Layers

The rendered graph has six layers.

| Layer | Meaning | Examples shown in the graph |
| --- | --- | --- |
| Reference surfaces | searchable memories, not hidden dependencies | Mathlib finite matrix/sum APIs; `quantum-computing-lean` states, gates, projectors, actions; `Lean-QuantumInfo`; `lean-quantum`; Lin/GSLW/LCU/QSVT texts |
| ABEIS file tree | local Lean files that compile in this project | `Core.lean`, `Resources.lean`, `Circuit.lean`, `BlockEncoding.lean`, `CircuitSemantics.lean`, `BlockEncodingClassics.lean`, `Automation.lean` |
| Reusable compiled leaves | textbook proof moves that agents should retrieve before reproving | clean-entry extraction, permutation matrices, sparse delta contractions, value-oracle contracts, LCU/product/tensor arithmetic, dilation, Hermitian, Chebyshev/QSVT, approximate BE, `evalWith` path lemmas |
| Consumers | examples and paper wrappers that instantiate the leaves | `MainCase.lean`, `CubicStatePreparation.lean`, `GHL2025.lean`, `RobinHeat.lean`, exports |
| Export/user surfaces | post-Lean artifacts and human proof products | LaTeX proof exports, Qiskit/QASM files, circuit storyboards, proof-DAG figures |
| Retrieval and proof-engineering discipline | memory used by upper/middle/reviewer agents | `compiled-lean-leaf-index.md/json`, `route-selector.md`, `qsvt-hard-hint-route.md`, `failure-memory/`, `mathlib-lemmas/`, reviewer judge packets |

The detailed declaration ledger is generated, not handwritten.  It currently
records 965 declarations across the local Lean tree; the important point for
agents is not to memorize that number, but to consult the index before creating
another local lemma.

## Public Module Tree

```text
QuantumBlockEncoding
├── Core.lean
│   └── Matrix, Resource, basic project data
├── Resources.lean
│   └── gate count, depth, layered schedule metadata
├── Circuit.lean
│   └── gate and circuit syntax
├── BlockEncoding.lean
│   └── targets, candidates, verified records, approximate policy
├── CircuitSemantics.lean
│   └── evalWith path lemmas, block extraction, projection/backend contracts
├── BlockEncodingClassics.lean
│   ├── clean-block and product-index leaves
│   ├── permutation and rational-orthogonality leaves
│   ├── one-sparse and sparse-access delta leaves
│   ├── LCU, product, tensor, and resource-composition leaves
│   ├── scalar dilation and Hermitian leaves
│   ├── Chebyshev / QSVT consumer contracts
│   └── exact-to-approximate incumbent leaves
├── MainCase.lean
│   └── transfer-operator certificates and candidate comparisons
├── CubicStatePreparation.lean
│   └── formula-oracle / diagonal-cubic construction records
├── GHL2025.lean, Examples/RobinHeat.lean, Papers/GHL2025.lean
│   └── paper-baseline wrappers and contribution ledgers
├── TechnicalLemmas.lean
│   └── re-export surface for common technical facts
└── Literature.lean, OpenProblems.lean, Automation.lean
    └── registry and harness-side metadata
```

## Compiled Leaf Families

| File | Leaf family | Representative declarations | Mathlib-quality status |
| --- | --- | --- | --- |
| `BlockEncodingClassics.lean` | clean block and index bridges | `cleanBlockBy_permMatrix_entry`, `cleanBlockProduct_permMatrix_entry`, `cleanBlockBy_permMatrix_eq_target_of_entry`, `cleanBlockProduct_eq_target_of_entry`, `productIndex` | generic finite-matrix extraction lemmas; should be stated with minimal block-encoding vocabulary when upstreamed |
| `BlockEncodingClassics.lean` | permutation matrices and orthogonality | `permMatrix`, `columnInner`, `rowInner`, `permMatrix_columnInner_of_injective`, `permMatrix_rowInner_of_bijective`, `permMatrix_isRationalOrthogonal_of_bijective` | good Mathlib candidate after generalizing from `Rat` and local `Matrix` aliases |
| `BlockEncodingClassics.lean` | one-sparse support | `kroneckerRat`, `oneSparseMatrix_entry_if`, `oneSparse_from_support`, `OneSparseCertificate.correct` | quantum-specific packaging, but the delta lemmas should be reusable finite-support lemmas |
| `BlockEncodingClassics.lean` | sparse access | `sparseColumnCleanEntry`, `sparseColumnCleanEntry_no_hit`, `sparseColumnCleanEntry_unique_slot`, `rowColumnSparseDeltaEntry`, `SparseColumnCertificate.correct`, `RowColumnSparseCertificate.correct` | keep sparse-oracle contracts in ABEIS; upstream only the finite-sum/delta collapse lemmas if generalized |
| `BlockEncodingClassics.lean` | value-to-amplitude contracts | `ValueToAmplitudeContract`, `ValueToAmplitudeContract.correct` | ABEIS-specific until circuit/state semantics are richer |
| `BlockEncodingClassics.lean` | Hermitian and dilation leaves | `IsSymmetric`, `cleanBlockBy_symmetric_of_symmetric`, `scalarDilation`, `scalarDilation_cleanEntry`, row-norm and row-orthogonality lemmas | scalar algebra and row-dot facts are Mathlib-style after generalization; block-encoding contract remains ABEIS-specific |
| `BlockEncodingClassics.lean` | Chebyshev / QSVT consumer | `chebyshevT`, `chebyshevT_succ_succ`, `QubitizationChebyshevContract`, `QSVTConsumerContract` | recurrence facts may be upstreamable; QSVT contract is domain-specific |
| `BlockEncodingClassics.lean` | exact clean-block packages | `ExactCleanBlock`, `ExactCleanBlock.clean_eq_target`, `partialPermutationCertificate` | ABEIS-specific certificate layer |
| `BlockEncodingClassics.lean` | LCU and product arithmetic | `oneTermLCU_cleanBlock`, `weightedSum2`, `weightedSum2_entry`, `weightedSum2_congr_pointwise`, `LCUCertificate.correct`, `twoTermLCUCertificate_cleanBlock_entry`, `matrix_mul_congr_pointwise`, `productExactCleanBlockCertificate` | matrix algebra bridge lemmas can be Mathlib-quality; LCU certificate packaging is ABEIS-specific |
| `BlockEncodingClassics.lean` | resource and approximate bridges | `tensorResourceCost`, `tensorResourceCost_gateCount`, `productResourceCost`, `productResourceCost_depth`, `ZeroErrorApproxCleanBlock`, `exactAsZeroErrorApproxCleanBlock`, `exactAsZeroErrorApproxCleanBlock_bound` | resource tuples are ABEIS-specific; exact-to-approx bridge becomes useful once norm APIs are generalized |
| `CircuitSemantics.lean` | evaluated matrix product support | `evalWith_foldl_add_mul`, `evalWith_mul_apply`, `evalWith_mul_eq_zero_of_all_paths_zero`, `evalWith_mul_unique_path`, `evalWith_mul_two_path`, identity and cast lemmas | good Mathlib/Std-style candidates after extracting from circuit names and generalizing algebraic assumptions |
| `CircuitSemantics.lean` | block extraction contracts | `BlockExtractionTarget`, `selectedBranchStatement`, `projectionSummationStatement`, `backendExpansionStatement`, bridge theorems between them | ABEIS-specific semantic contract layer |
| `CircuitSemantics.lean` | signal-system indexing | `signalSystemBlockRowIndex`, `signalSystemBlockColIndex`, `_lt` lemmas, `signalSystemBlockProjection` | reusable finite-index arithmetic after generalization |
| `BlockEncoding.lean` | construction records and cost order | `RegisterLayout`, `BlockEncodingSpec`, `BlockEncodingCost`, `QueryOperatorTarget`, `OperatorBlockEncodingCandidate`, `VerifiedOperatorBlockEncoding`, approximate variants, `AdaptiveBlockEncodingPolicy` | ABEIS public API; not Mathlib material except generic order/resource helper lemmas |
| `MainCase.lean` | transfer-operator certificates | `mainCaseProCircuitVerified`, `mainCaseProCircuit_blockProjection`, `mainCaseColdPartialPerm_clean_eq_target`, resource-cost theorems | example consumers of reusable leaves; not upstream targets |

## Dependency Shape

```text
Core / Resources / Circuit / BlockEncoding
  -> CircuitSemantics
  -> BlockEncodingClassics
  -> MainCase, CubicStatePreparation, GHL wrappers, paper examples
  -> problem exports and executable Qiskit/QASM artifacts

research-wiki/block-encoding-library/
  -> card-level intuition
  -> proof-network.md
  -> lean-leaf-module-graph.md
  -> mathlib-lemmas/
```

## External Reference Cards

External Lean code is preserved as local checkouts and memory cards, not copied
into ABEIS source unless the license and dependency policy explicitly permit
it.

| Reference | Local memory card | What agents should retrieve |
| --- | --- | --- |
| `duckki/quantum-computing-lean` | `research-wiki/external-lean-libraries/quantum-computing-lean.md` | finite matrix, state, gate, projector, unitarity, and action-proof organization |
| `Timeroot/Lean-QuantumInfo` | `research-wiki/external-lean-libraries/lean-quantuminfo.md` | finite-dimensional quantum-information proof style |
| `Hayata-Yamasaki-Group/lean-quantum` | `research-wiki/external-lean-libraries/lean-quantum.md` | states, channels, qudits, entropy, trace/norm, and operator-style conventions |
| Mathlib | `research-wiki/mathlib-lemmas/` | reusable generic theorems found by `python3 tools/qbe.py mathlib-search` |

## Agent Rule

Upper agents use this graph to choose the likely proof family.  Middle agents
turn the selected family into one or two small proof-DAG leaves and must search
Mathlib before assigning generic infrastructure.  Lower Lean workers prove one
stable leaf at a time.  If the same leaf repeatedly fails, the reviewer should
treat it as a mathematical signal and ask whether the statement needs a hidden
regularity contract, a missing support hypothesis, or a counterexample audit.

For Mathlib-quality local leaves:

- decompose aggressively into lemmas that fit one agent context window;
- specify more than the theorem: local APIs, intended proof route, and the
  exact parent theorem served by the leaf;
- treat persistent failure as mathematical signal, not just a tactic problem;
- promote hidden regularity conditions such as cleanup, boundedness,
  nonemptiness, injectivity, and support uniqueness into reusable contracts;
- do not frequently change the proof route once reviewer has accepted a
  well-typed local statement.  If the route changes, write a failure-memory
  packet explaining why.
