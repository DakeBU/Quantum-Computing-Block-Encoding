# QBench External Declaration Audit

Audit date: 2026-07-29 JST

This audit was performed in isolated temporary clones.  Neither repository is
an ABEIS dependency, and no benchmark Statement proof was imported.

## Reproducible identity

| Repository | Commit | Lean | License | Isolated build |
| --- | --- | --- | --- | --- |
| `QudeLeap/Lean-QuantumAlg-Bench` | `7f964d2b34a63c8ea7cae87937ede7740abe7dda` | 4.31.0 | Apache-2.0 | pass, 2506 jobs, 515.63 s cold wall, 1,715,328 KiB peak RSS |
| `QuAIR/Lean-QIT-Bench` | `e4f0230e14c35da9c658b58c8663b3e6825e6663` | 4.30.0 | Apache-2.0 | pass, 2791 jobs; warm replay 2.33 s, 869,964 KiB peak RSS |

The first QIT build also completed, but its duration was not retained from the
combined streamed log; this report does not invent that measurement.

The full lexical declaration inventory, with source file, line, imports,
layer, proof-hole flag, and reuse status, is
[`qbench-external-declarations.json`](qbench-external-declarations.json).
The generator is `tools/generate_qbench_audit.py`.

| Repository | Base declarations | Definitions declarations | Statement declarations |
| --- | ---: | ---: | ---: |
| Lean-QuantumAlg-Bench | 431 | 160 | 44 |
| Lean-QIT-Bench | 209 | 175 | 40 |

The repositories contain 36 and 40 Definitions files respectively.  No
`Hints.lean` file exists in either audited commit.  Every Statement file is a
benchmark proof target and has at least one unresolved `sorry`; a wrapper can
therefore build while its theorem remains intentionally unsolved.

## Relevant verified surfaces

| Area | Hole-free Base/Definitions declarations inspected | ABEIS decision |
| --- | --- | --- |
| finite operator action | `QAlgBench.HilbertOperator.applyVec`, `applyVec_ket`, `ext_of_applyVec_eq`, finite sums and unitary norm/inner-product lemmas | independently add only the missing zero-ket/first-column adapter |
| tensors and adjoints | `HilbertOperator.tensor_mul_tensor`, `conjTranspose_tensor`, `tensor_mem_unitaryGroup`, `tensor_applyVec_tensor` | useful future reference; no current failure-derived adapter justified |
| block projection | `QAlgBench.projectedBlock`, `ExactBlockEncoding.projected_block_eq`, `block_entry`, `toBlockEncoding` | independently add flat/product-register projection adapters |
| resource syntax | `ResourceProfile`, its composition arithmetic, `CountedGateWord` | reference only; ABEIS still requires a local syntax-to-count theorem |
| LCU definitions | `weightedSum`, `coeffSum`, `selectOp` | definitions compile, but both LCU Statement theorems are unsolved; no theorem imported |
| pure states | `QITBench.rankOneMatrix`, `PureVector` and their matrix lemmas | reference for a future density/purification layer |
| product states | `State.partialTraceA_prod`, `State.partialTraceB_prod` | reference only; not needed by the current cubic route |
| maps/channels | `MatrixMap`, Choi/Kraus infrastructure and `Channel` | reference only; no channel claim added to ABEIS |

## LCU correction

The audited LCU `selectOp` definition contributes zero outside the injected
label image.  That operator is unitary only when labels exhaust the ancilla
basis or when the unused-label subspace is completed, for example by identity.
ABEIS therefore does not cite the unsolved LCU Statements and does not claim a
general PREPARE--SELECT--PREPARE theorem.  Its current one/two-term
clean-block arithmetic remains a partial interface.

## Trust and compatibility decision

ABEIS is pinned to Lean 4.29.1, so directly adding either QBench package would
mix incompatible toolchains and broaden the trust/build surface.  The accepted
intervention is smaller:

1. prove ABEIS adapters independently over Mathlib and existing ABEIS types;
2. test each adapter on at least two shapes or concrete consumers;
3. record exact local and broader-route status in the technical-lemma registry;
4. attribute QBench as a design reference;
5. keep every Statement theorem excluded from retrieval.

This closes representation prerequisites only.  It does not solve the old
opaque cubic arithmetic/rotation route, the general LCU theorem, an
operator-norm approximation layer, or channel semantics.
