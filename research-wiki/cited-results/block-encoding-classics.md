# Block-Encoding Classics for ABEIS Memory

This file records classic or reusable sources as memory entries.  Status values
follow the technical-lemma vocabulary: `paper-cited`, `classic-unformalized`,
`contract-only`, `obligation`, `formalized`.

| id | source | reusable asset | status | ABEIS retrieval role |
| --- | --- | --- | --- | --- |
| be-lin-lecture-2022 | Lin Lin, "Lecture Notes on Quantum Algorithms for Scientific Computation", arXiv:2201.08309 | textbook proof routes for clean-block entries, value-to-amplitude, sparse oracles, dilation, LCU, Hermitian BE, qubitization, QSVT | paper-cited | backbone memory pack for route selection and entrywise proof style |
| be-gslw-qsvt-2018 | Gilyen, Su, Low, Wiebe, "Quantum singular value transformation and beyond", arXiv:1806.01838 | modern block-encoding definition, LCU, product, sparse-access, density block encoding, QSVT consumer theorem | classic-unformalized | canonical source for block-encoding arithmetic and downstream QSVT contracts |
| be-low-chuang-qubitization-2019 | Low and Chuang, "Hamiltonian Simulation by Qubitization", Quantum 2019 / arXiv:1610.06546 | projected-unitary/standard-form Hamiltonian simulation | classic-unformalized | useful when a paper states Hamiltonian as projected unitary |
| be-childs-wiebe-lcu-2012 | Childs and Wiebe, "Hamiltonian Simulation Using Linear Combinations of Unitary Operations", arXiv:1202.5822 | LCU idea and near-deterministic implementation of linear combinations | classic-unformalized | source memory for PREPARE-SELECT-PREPARE routes |
| be-berry-childs-cleve-kothari-somma-2014 | Berry, Childs, Cleve, Kothari, Somma, "Simulating Hamiltonian dynamics with a truncated Taylor series", arXiv:1412.4687 | LCU as a practical Hamiltonian-simulation primitive with logarithmic precision dependence | classic-unformalized | motivates LCU resource accounting and select/prepare separation |
| be-childs-kothari-somma-hhl-2015 | Childs, Kothari, Somma, "Quantum algorithm for systems of linear equations with exponentially improved dependence on precision", arXiv:1511.02306 | matrix-function route using Fourier/Chebyshev series | classic-unformalized | downstream consumer when BE feeds inverse/linear-system algorithms |
| be-camps-lin-vanbeeumen-yang-2022 | Camps, Lin, Van Beeumen, Yang, "Explicit Quantum Circuits for Block Encodings of Certain Sparse Matrices", arXiv:2203.10236 | explicit circuits for well-structured sparse matrices | paper-cited | source of concrete sparse construction tactics and benchmarks |
| be-fable-2022 | Camps and Van Beeumen, "FABLE: Fast Approximate Quantum Circuits for Block-Encodings", arXiv:2205.00081 | approximate dense block-encoding synthesis and compression | paper-cited | approximate candidate generator and post-Lean software comparison |
| be-sunderhauf-campbell-camps-2023 | Suenderhauf, Campbell, Camps, "Block-encoding structured matrices for data input in quantum computing", arXiv:2302.10949 | arithmetic descriptions of sparsity and repeated values | paper-cited | route for structured sparse targets without dense loading |
| be-tang-tian-qsvt-guide-2023 | Tang and Tian, "A CS guide to the quantum singular value transformation", arXiv:2302.14324 | simplified QSVT exposition | paper-cited | human-facing explanation memory, not primary formal theorem source |
| be-martyn-grand-unification-2021 | Martyn et al., "Grand unification of quantum algorithms", arXiv:2105.02859 | QSVT/QSP unification perspective | paper-cited | conceptual background for downstream algorithm cases |

## Policy

Use these as memory sources and citation anchors.  Do not claim a theorem is
formalized until the corresponding Lean declaration compiles in
`QuantumBlockEncoding/`.

## Current Lean Translation Status

| source id | translated Lean leaves | current status |
| --- | --- | --- |
| `be-lin-lecture-2022` | `productIndex`, `cleanBlockProduct_permMatrix_entry`, `cleanBlockProduct_eq_target_of_entry`, `kroneckerRat`, `oneSparseMatrix_entry_if`, `oneSparse_from_support`, `sparseColumnCleanEntry`, `SparseColumnCertificate`, `ValueToAmplitudeContract`, `IsSymmetric`, `scalarDilation_cleanEntry`, `chebyshevT`, `QubitizationChebyshevContract` | textbook proof skeleton and several reusable leaves formalized; full row-column sparse, full PREPARE-SELECT, SVD unitarity, and full QSVT remain obligations |
| `be-gslw-qsvt-2018` | `LCUCertificate`, `matrix_mul_congr_pointwise`, `productCleanBlockCertificate`, `QSVTConsumerContract` | partial reusable leaves formalized; full QSVT theorem remains contract-only |
| `be-childs-wiebe-lcu-2012` | `oneTermLCU_cleanBlock`, `LCUCertificate` | LCU base/proof-carrying interface formalized; full PREPARE-SELECT pair algebra remains next leaf |
| `be-berry-childs-cleve-kothari-somma-2014` | `LCUCertificate`, `productResourceCost` | resource/proof-carrying leaves formalized; algorithmic Taylor-series theorem not formalized |
| `be-low-chuang-qubitization-2019` | `QSVTConsumerContract` | downstream projected-unitary consumer interface recorded; qubitization theorem not formalized |
| `be-camps-lin-vanbeeumen-yang-2022` | `permMatrix`, `cleanBlockBy_permMatrix_entry`, `matrix_mul_congr_pointwise`, `tensorResourceCost` | reusable sparse/shift/permutation leaves formalized; paper-specific circuits remain planned |
| `be-fable-2022` | `exactAsZeroErrorApproxCleanBlock` | exact-to-approximate incumbent bridge formalized; FABLE compression theorem remains planned |
| `be-sunderhauf-campbell-camps-2023` | `matrix_mul_congr_pointwise`, `tensorResourceCost`, `productResourceCost` | structured-circuit arithmetic leaves formalized; paper-specific arithmetic patterns remain planned |
