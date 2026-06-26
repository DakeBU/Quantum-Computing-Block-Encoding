# Lean Roadmap for the Block-Encoding Library

This roadmap lists reusable Lean atoms that should gradually replace ad hoc
task-local proofs.

## Core Definitions

```lean
def cleanBlock
def IsBlockEncodingExact
def IsBlockEncodingApprox
```

Target theorem style:

```lean
theorem blockEncoding_ext_entrywise :
  (forall row col, cleanBlock U row col = A row col / alpha) ->
  IsBlockEncodingExact alpha a U A
```

Exact finite examples should first use entrywise clean-block theorems.  Norm
lemmas are reserved for approximate certificates.

## Mathlib-Quality Working Rules

ABEIS leaves should be written as if they might eventually become upstream
library lemmas.  The immediate goal is local compilation; the design goal is
reuse.

- Decompose aggressively.  Prefer one small theorem that closes one proof-DAG
  edge over a large theorem that asks an agent to remember an entire circuit.
- Search Mathlib before inventing generic infrastructure.  Use
  `python3 tools/qbe.py mathlib-search "<keyword-or-theorem-name>"`, then
  record reusable hits under `research-wiki/mathlib-lemmas/`.
- Specify the local API.  A task packet should name the definitions to unfold,
  the helper lemma to prove first, and the intended proof route.
- Treat persistent failure as mathematical signal.  If the same leaf fails
  repeatedly, the upper/reviewer layer should recheck the statement for missing
  assumptions, false equalities, stale definitions, or counterexamples.
- Make hidden regularity reusable.  Cleanup, bijectivity, support uniqueness,
  boundedness, norm bounds, nonemptiness, continuity, and integrability should
  be named contracts instead of implicit prose.
- Do not frequently change the proof.  Stabilize the statement and route before
  spending lower-agent budget; change them only after a reviewer records why.
- Separate semantic layers: clean-block equality, unitarity, circuit/gate
  realization, resource metrics, and Qiskit/QASM export should be different
  leaves unless a small theorem naturally packages them.

If direct Mathlib import is temporarily blocked by dependency policy, do not
hide that fact.  The middle packet should name the Mathlib theorem/module and
assign lower work only to the smallest local adapter or bridge.

The leaf atlas
[`quantum-lean-leaf-atlas.md`](quantum-lean-leaf-atlas.md) records how these
rules connect ABEIS leaves to nearby quantum Lean libraries.

## Suggested File Structure

```text
QuantumBlockEncoding/BlockEncoding/Basic.lean
QuantumBlockEncoding/BlockEncoding/PermMatrix.lean
QuantumBlockEncoding/BlockEncoding/PartialPermutation.lean
QuantumBlockEncoding/BlockEncoding/Arithmetic.lean
QuantumBlockEncoding/BlockEncoding/LCU.lean
QuantumBlockEncoding/BlockEncoding/SparseAccess.lean
QuantumBlockEncoding/BlockEncoding/Density.lean
QuantumBlockEncoding/BlockEncoding/Dilation.lean
QuantumBlockEncoding/BlockEncoding/QSVTContract.lean
QuantumBlockEncoding/Examples/OptimalControl/Ek.lean
QuantumBlockEncoding/Examples/CubicDiagonal.lean
```

Do not move existing large files until wrappers and imports compile.  Promote
one reusable theorem at a time.

## Common Proof-DAG Leaves

| Leaf | Meaning | Typical tactic shape |
| --- | --- | --- |
| permutation image | prove the finite function sends each clean input to the claimed clean output | `fin_cases`, `decide`, `simp` |
| clean block entry | unfold clean projection and permutation matrix entry | `ext row col`; `simp [cleanBlock]` |
| product clean entry | flatten `ancilla × system`, then use product clean-block theorem | `rfl`, finite index arithmetic |
| one-sparse support | collapse a Kronecker delta at `row = c col` | `by_cases h : row = c col`; `simp [h]` |
| sparse column sum | represent a slot sum and defer uniqueness/support collapse | finite fold plus support hypotheses |
| passive register | prove active map leaves the passive coordinate unchanged | case split on product index |
| LCU coefficient | compute the prepare/select inner sum | `simp [Matrix.mul_apply]`; finite sum algebra |
| product bridge | combine two clean-block equalities under embedded product | matrix multiplication index split |
| scalar rotation | prove `cos(theta/2) = x` for chosen angle | real analysis or symbolic contract |
| uncompute | prove workspace returns to zero | reversible-function inverse theorem |

## Current Compiled Atoms

These atoms compile in `QuantumBlockEncoding/BlockEncodingClassics.lean`:

- `productIndex`
- `cleanBlockProduct_permMatrix_entry`
- `cleanBlockProduct_eq_target_of_entry`
- `kroneckerRat`
- `oneSparseMatrix_entry_if`
- `oneSparse_from_support`
- `OneSparseCertificate`
- `sparseColumnCleanEntry`
- `sparseColumnCleanEntry_no_hit`
- `sparseColumnCleanEntry_unique_slot`
- `SparseColumnCertificate`
- `rowColumnSparseDeltaEntry`
- `RowColumnSparseCertificate`
- `ValueToAmplitudeContract`
- `IsSymmetric`
- `cleanBlockBy_symmetric_of_symmetric`
- `scalarDilation_cleanEntry`
- `scalarDilation_offdiag01`
- `scalarDilation_offdiag10`
- `scalarDilation_diag11`
- `scalarDilationRowDot`
- `scalarDilation_row0_normSq`
- `scalarDilation_row1_normSq`
- `scalarDilation_row0_unit_norm_of`
- `scalarDilation_row1_unit_norm_of`
- `scalarDilation_rows01_orthogonal`
- `scalarDilation_rows10_orthogonal`
- `chebyshevT`
- `chebyshevT_succ_succ`
- `chebyshevT_three_recurrence`
- `chebyshevT_four_recurrence`
- `weightedSum2_entry`
- `twoTermLCUCertificate`
- `twoTermLCUCertificate_cleanBlock_entry`
- `ExactCleanBlock.toLCUCertificate`
- `productExactCleanBlockCertificate`
- `QubitizationChebyshevContract`

## Next Formalization Leaves

| Priority | Leaf | Why it matters |
| --- | --- | --- |
| P0 | row-column sparse delta contraction | shared by general sparse matrix BE proofs |
| P0 | full PREPARE-SELECT-PREPARE dagger clean block | shared by LCU and many paper constructions |
| P1 | scalar/diagonal dilation column orthogonality and full unitarity package | fallback exact BE for contractions |
| P1 | value-to-amplitude controlled-rotation semantic instance | needed for formula-defined diagonal oracles |
| P2 | two-dimensional qubitization/Chebyshev invariant subspace | first real step toward QSVT theorem support |

## Acceptance Status

- `planned`: desired reusable theorem, no Lean declaration.
- `contract-only`: theorem may be used as explicit external assumption.
- `obligation`: active proof-DAG leaf.
- `formalized`: Lean declaration compiles and is imported by wrappers.

Never mark a card as `formalized` because the prose proof is convincing.
