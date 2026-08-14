# Block-Encoding Route-Intuition Guide

Given an operator target $A$, use this file as a textbook memory, not a rigid
classifier.  Block-encoding construction is a design-search problem: upper
agents should read the target, recall similar classic constructions, and
propose several plausible routes rather than follow the first matching row.
Middle agents then turn selected routes into small proof-DAG leaves, run them
in parallel when useful, and store failed but insightful candidates in the
insight pool.

If the user-level task is only "prepare this target state from $|0^n\rangle$",
route it first through
[`research-wiki/state-preparation-library/route-selector.md`](../state-preparation-library/route-selector.md).
State preparation is the smaller target: prove `U |0^n> = |psi>` or first-column
equality before using the prepared state as a PREPARE primitive in a later
block-encoding proof.

Separate three kinds of memory before assigning lower work:

| Memory type | Status | How to use it |
| --- | --- | --- |
| Idea card | mathematical inspiration | mutate, recombine, compare, or reject during upper/middle brainstorming |
| Compiled Lean leaf | theorem already available in ABEIS | instantiate it or write a small adapter; do not reprove it |
| Contract-only card | known external theorem or planned formalization | keep it explicit in the proof DAG; do not present it as Lean-closed |

For QSVT-style tasks, this distinction is crucial.  If the current task only
needs to consume an already proved input block encoding, retrieve the QSVT
consumer route and reuse/adapt the existing `QSVTConsumerContract` or
Chebyshev leaves.  Reprove the full QSVT theorem only when the task is
explicitly about foundational QSVT formalization.

## Route-Intuition Matrix

Upper and middle agents should record why a route is worth trying, what proof
leaf it would reduce to, and which competing routes remain useful for
population diversity.

| Target/access model | Route worth trying | Normalizer intuition | Main proof leaf | Deprioritize when |
| --- | --- | --- | --- | --- |
| explicit matrix unit, projector, reset, partial injection | partial permutation | usually $\alpha=1$ | finite image theorem plus clean-block entry | target has nontrivial amplitudes or non-basis action |
| one possible nonzero row per column | one-sparse permutation | value bound or one-sparse amplitude scale | Kronecker delta support collapse | support map is not functional or not reversible enough |
| column slots and value oracle | sparse column oracle | usually slot count times value bound | finite slot-sum collapse | row access is required for reversibility/cleanup |
| row and column location oracles | row-column sparse oracle | sparsity $s$ and value bound | double-delta uniqueness collapse | locations are not unique or value oracle lacks cleanup |
| reversible formula/value oracle | value-to-amplitude | value bound or rotation scale | compute--rotate--uncompute cleanup | workspace is not uncomputed |
| finite weighted sum of encoded blocks | LCU | $\sum_j |\alpha_j|$ or prepared norm | PREPARE--SELECT projection | coefficients/signs/phases are not represented |
| product or tensor of encoded blocks | arithmetic product/tensor | product of normalizers or tensor scale | matrix multiplication/tensor entry bridge | component certificates are missing |
| dense contraction with no better structure | dilation fallback | contraction scaling | 2-by-2 dilation orthogonality | efficient circuit is required but no implementation is supplied |
| polynomial transform/inverse/sign/filter | QSVT/qubitization consumer | inherited from input BE and polynomial theorem | consume a proved BE | no input BE has been certified |
| diagonal grid value then polynomial, e.g. $x_j \mapsto x_j^3$ | first prove diagonal/value BE, then QSVT consumer | input normalizer plus polynomial contract | `O_0 BE -> QSVT side conditions -> polynomial BE` | the input BE is unproved or QSVT is being used to hide the original oracle |
| controlled conjugation with costly clean workspace | promise-register ancilla tradeoff | unchanged mathematical normalizer | promise, restoration, involution, and same-tier cost leaves | the input promise is unproved or workspace is not restored |

After at least one route is made precise, certified candidates are ranked
lexicographically at the same semantic tier:

```text
valid operator contract
> exact before approximate unless Scenario 2 is active
> most specific structure before generic fallback
> better normalizer / fewer oracle calls
> (gateCount, depth, auxiliaryQubits, oracleCalls)
> lower proof burden and reusable leaves
```

Each route note should name the required access model, normalizer, clean
ancilla, workspace cleanup, and whether the route is `formalized`,
`contract-only`, or `obligation`.  A `contract-only` route may guide
brainstorming, but it cannot become a parent in the certified population until
the required Lean theorem is present.

## Route 1: Partial Permutation

Use when $A$ is a matrix unit, projector, reset-on-subspace map, partial
injection, or a tensor of one of these with an identity register.

Typical form:

$$
A = |u\rangle\langle v| \otimes I.
$$

Cards:

- `BE.PartialPermutation.MatrixUnitTensorId`
- `BE.PermMatrix.CleanBlock`
- `BE.Tensor.PassiveRegister`

Rejected first routes: LCU, sparse-access, QSVT.  They are more general but
obscure the proof and resource score.

## Route 2: One-Sparse Permutation

Use when each column has one possible nonzero row.  This is the sparse route
closest to partial permutation.

Card: `BE.Sparse.OneSparsePermutation`.

## Route 3: LCU / PREPARE-SELECT

Use when the target is a finite weighted sum:

$$
A = \sum_j \alpha_j A_j
$$

where each $A_j$ is unitary or already block-encoded.

Card: `BE.LCU.PrepareSelect`.

## Route 4: Product/Tensor Arithmetic

Use when $A$ is built from already encoded parts:

$$
A = AB,\qquad A = A_1 \otimes A_2.
$$

Cards:

- `BE.Arithmetic.Product`
- `BE.Arithmetic.Tensor`

Direct-sum composition is a planned sibling route, not a compiled card in the
current memory library.  Do not assign a direct-sum lower task unless a
task-local theorem statement is added first.

## Route 5: Value-To-Amplitude Query Oracle

Use when the matrix value or angle is computed reversibly and then loaded into
a signal-qubit amplitude by controlled rotation plus uncompute.

Card: `BE.QueryModel.ValueToAmplitude`.

## Route 6: Sparse Access / Gram Construction

Use when the target comes with row/column/value oracles and a sparse-access
contract.  The proof should reduce a clean block entry to an inner product of
two prepared states.

Cards:

- `BE.Sparse.ColumnOracle`
- `BE.Sparse.RowColumnOracle`
- `BE.SparseAccess.GramConstruction`

## Route 7: Density / Purification

Use when the target is a density matrix or Gram matrix induced by a state
preparation.  The clean block often comes from a partial trace or swap test
calculation.

Card: `BE.Density.FromPurification`.

## Route 8: Dilation Fallback

Use when $A$ is a contraction and no better structure is found.  Prefer a
diagonal or 2-by-2 scalar rotation special case before general SVD dilation.
This is an existence fallback and a source of seeds; it is not automatically an
efficient gate-level construction.

Cards:

- `BE.Contraction.SVDDilation`
- `BE.HermitianDilation`

## Route 9: Hermitian / Qubitization / QSVT Consumer

Use only after a block encoding has been proved and the target algorithm needs
a polynomial transformation, inverse, sign, filter, or Hamiltonian simulation.

Cards:

- `BE.HermitianBlockEncoding`
- `BE.Qubitization.Chebyshev`
- `BE.QSVT.ConsumerContract`

For tasks where the useful hint is "construct the block encoding of
$O_0=\sum_j x_j |j\rangle\langle j|$ and then use QSVT for $x^3$", read
[`qsvt-hard-hint-route.md`](qsvt-hard-hint-route.md).  That card prevents the
harness from wasting a cycle rediscovering the proof-DAG shape:

```text
diagonal/value BE for O_0
-> QSVT admissibility of P(x)=x^3
-> QSVT consumer contract
-> BE of O_0^3
```

If QSVT is only a contract, the report must say so.  Do not plot the final
polynomial candidate as Lean-certified unless the QSVT node has a compiled
Lean certificate or the task explicitly accepts a contract skeleton.

## Route 10: Approximate Dense / Structured Circuits

Use when exact construction is not required or has stalled, and the task accepts
an explicit epsilon.

Cards:

- `BE.FABLE.ApproxDense`
- `BE.StructuredSparse.ExplicitCircuits`

## Route 11: Promise-Register Ancilla Tradeoff

Use this only after a correct candidate exposes a controlled conjugation
$W=V^\dagger U V$ or conditionally clean workspace.  The card
`BE.Circuit.PromiseAncillaTradeoff` adapts the promise-gate construction of
arXiv:2603.12917 as a population mutation. Retrieve the compiled generic roots
`controlledConjugation_matrix` and `dirtyControlledInvolution_action` instead
of reproving their branch algebra. Upper must keep the original
candidate as a baseline; middle opens separate leaves for the promise
predicate, compute-uncompute restoration, involution before any dirty-ancilla
variant, and a same-tier resource comparison.  Until those leaves compile,
the mutation remains exploratory.

## Mandatory Route Note

Every upper/middle route decision should write one sentence explaining why the
chosen route is the main attempt and which alternatives are preserved or
deprioritized.  Example:

```text
For E_k, partial permutation is the main route because the target is a matrix
unit tensor identity.  LCU and QSVT are preserved only as background routes:
they are more general, but would obscure the exact clean-block proof and
resource score for this target.
```
