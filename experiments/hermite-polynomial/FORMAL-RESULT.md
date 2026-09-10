# Hermite preparation: the polynomial quantum-resource result

Date: 2026-09-10. Task: `SP-HERMITE-POLY-002`.

Historical scope: this is the preserved cycle-02 existence-result snapshot.
Its remaining-work table describes that checkpoint. The
[cycle-03 result](CYCLE03-RESULT.md) supersedes the producer/backend frontier
with deterministic construction and stored local cost refinements; full
classical and uniform finite-precision certificates remain open.

## Result and scope

The search has produced a **Lean-checked exact-real quantum-gate family**,
not merely a low-rank conjecture or a fitted scaling curve. For every smoothing
order $k\in\mathbb N$, data width $n_p\ge1$ and $L>0$, the literal normalized
Hermite sample state has a primitive circuit with

$$
D=2k+6,\qquad q=\lceil\log_2 D\rceil,\qquad
\operatorname{depth}\le G\le48n_pD^3.
$$

Here $G$ counts **every instruction**, not just selected gate categories. The
circuit uses $n_p$ data wires and $q$ bond wires, has no oracle instructions,
is unitary on the entire register, and returns every bond wire to zero.
There is no measurement, postselection, free initial bond state, or supplied
target-action certificate. For fixed $k$ the proved gate bound is linear in
$n_p$; it is also polynomial jointly in $n_p$ and $k$.

The root is
[`HermitePolynomialPreparation.exists_polynomial_preparation`](../../QuantumBlockEncoding/HermitePolynomialPreparation.lean).
It takes only `k`, `n`, real `L` and `0<L`, where its Lean parameter `n+1`
equals $n_p$. Its audited axioms are only `propext`, `Classical.choice` and
`Quot.sound`. The audited source SHA256 is
`96D73E4A22F26E51E4D9D2B124547A45D2A63145DD75288ED3711B5384F13D7D`.

[`HermitePolynomialPreparation.exists_polynomial_resources`](../../QuantumBlockEncoding/HermitePolynomialResources.lean)
adds the **actual wire-scheduled depth** bound, using the independently proved
`PrimitiveCircuit.resource_depth_le_gateCount`, not a newly defined proxy for
depth. Its scoped build and axiom audit passed too.

**Not yet proved:** total classical compiler cost, finite-bit input/angle
complexity, uniform floating-point error, or an instruction-level refinement
of the Python exporter to the Lean backend. Exact-real circuit existence must
not be advertised as a fully certified executable compiler. The frozen full
task remains open; the old exponential baseline is preserved unchanged.

## Why the construction is smaller

The old reference computes a generic rotation tree with $2^{n_p}-1$ RY gates.
The new construction exploits the source formula: two exponential tails and
one degree-at-most $2k+1$ polynomial interval. It does not accept an arbitrary
table of $2^{n_p}$ amplitudes as free input.

Read the binary grid index from most-significant to least-significant bit.
A partially resolved interval needs only one boundary state. When its branch
enters the polynomial region, that state injects the appropriate Bernstein
coefficients into shared subdivision states. The two exponential regions use
small multiplicative state machines. Their block sum has exactly $D=2k+6$
states, independent of the number of samples.

```text
Literal Hermite samples
  -> finite kernel: D = 2k+6 states; every path equals its source sample
  -> n_p local tensor cores, scalar initial/final boundaries
  -> exact right-canonical cores, without increasing the bond
  -> active columns completed to small real unitaries
  -> adjacent Givens planes -> Gray-selected RY/CX instructions
  -> actual wire placement -> public little-endian data + zero bond
```

This is a source-specific chain, not an assumption that a convenient MPS has
already been supplied. For each stage let $S=2^q\le2D$. Its physical dimension
is $2S$. At most $(2S)(2S-1)/2$ adjacent planes are needed. The proved recursive
controlled-rotation backend uses $S+2(S-1)$ instructions per plane, hence at
most $6S^3$ per stage and at most $48n_pD^3$ overall. Data-wire relabeling acts
on each actual instruction; it is not an uncharged physical SWAP operation.

The last active rank is one. The proof covers **all** output bond labels, not
just a projected clean block. The signed initial residual is absorbed into
the first row-isometric core, so the register truly starts in computational
zero without a free state-preparation primitive.

## Reusable proof assets

| Interface | Source module | Independently checked use |
| --- | --- | --- |
| Literal three-branch finite kernel and width | `HermiteBoundaryInjection` | `ABEISTests/HermiteBoundaryInjection.lean` |
| Small kernels to real scalar-boundary chains | `MatrixProductChain` | `ABEISTests/MatrixProductChain.lean` |
| Thin LQ and all-length canonicalization | `ThinLQ`, `TensorTrainCanonical` | rank-deficient and zero-rank tests |
| Preserve prescribed active columns in SO | `RealIsometryCompletion` | arbitrary column placement; spare-column counterexample |
| Construct and compile adjacent real planes | `AdjacentGivens`, `GrayBasis`, `GrayGivensCompiler` | orientation, negative identity, exact count tests |
| Local active-column circuit to complete state preparation | `TensorTrainLocalCompiler`, `TensorTrainSchedule`, `TensorTrainPrimitivePreparation` | signed residual, varying ranks and cleanup |
| Actual placement and MSB-to-LE public correspondence | `SequentialPrimitiveAssembly`, `TensorTrainWord` | nontrivial placement and non-palindromic words |
| Hermite family root | `HermiteFiniteChain`, `HermitePolynomialPreparation` | all-parameter statement and one-data-qubit boundary case |
| Local Gram norm supplier | `TensorTrainNormEnvironment`, `HermiteFiniteNorm` | zero trains, varying bonds, 3-4 norm, target adapter |

The full names, imports and checked applications are indexed in
[the structured-source memory card](../../research-wiki/state-preparation-library/SP.Hermite.Structured.md).
The generic tensor-train/compiler assets can be reused for another source
only after that source supplies its actual core action and bond bound.
This run demonstrates interface reuse within the construction; it does not
establish held-out cross-task synthesis gains.

## Classical normalization: a closed subproblem

`HermiteFiniteNorm.rawSourceChain` has no division by a precomputed norm.
Starting from the terminal identity, the local recursion is

$$
E_t=\sum_{b\in\{0,1\}} A_{t,b}E_{t+1}A_{t,b}^{\mathsf T},
\qquad \|g\|_2=\sqrt{E_0[0,0]}.
$$

`gram_eq_sum` proves that this equals the full squared-amplitude sum. The sum
over exponentially many words occurs in the specification, not the supplier
recursion. Each tail environment is shared across its two updates.
`localSampleNorm_eq_sampleNorm` and `sourceChain_eq_local` connect this supplier
to the literal Hermite normalization and the actual normalized source cores.

The formal budgets are at most $2n_pD^2$ stored core entries, $(n_p+1)D^2$
stored environment entries, and $9n_pD^3$ real additions/multiplications,
plus one square root. This is the explicitly stated local matrix-evaluation
schedule, **not** a cost semantics for a compiled external program. It does
not charge generation of the core entries or the rest of the compiler.

## Remaining classical and precision obligations

| Stage | What is currently supported | What remains |
| --- | --- | --- |
| Source core generation | Exact formula/path proof; polynomial number of stored local entries | Charged coefficient/exp/cutoff algorithm and finite input model |
| Norm | Exact local Gram semantics and polynomial schedule budget | Finite-bit arithmetic and rounding analysis |
| Canonicalization | All-length LQ/isometry existence and bond nonincrease | Deterministic basis choices and total operation-count theorem |
| SO completion | Correct prescribed-column existence with orientation correction | Costed completion algorithm, not arbitrary basis extension |
| Givens/angles | Explicit exact recursion; matrix semantics and output list count | Materialized/cached computation cost, zero-pivot and real angle evaluation model |
| QASM | Finite independent replays of actual saved files | Backend refinement, input/core/QR/angle error propagation and epsilon budget |

A minimal next formalization reuses rectangular Givens elimination: materialize
and cache each small matrix update; derive thin LQ and active-column completion
from the same costed kernel; then lift its costs through the tensor chain.
Deterministic column permutations and parity tracking can avoid treating an
arbitrary basis extension or a specification-level determinant as a free
algorithm. Square roots, angles and exact comparisons must be distinct charged
operations. An operation bound for that proposed implementation is not claimed
here before it exists and is checked.

There is also a genuine **input-model restriction**, not just missing code.
The exact cutoff is a clamped ceiling of $M-M/(\pi L)$, where $M=2^{n_p-1}$.
For $0\le m<M$, set $L_m=M/(\pi(M-m))$. At $L_m$ the cutoff is $m$, while
for every sufficiently small positive $\delta$ it is $m+1$ at $L_m+\delta$.
A procedure using only finite-error rational approximations to an arbitrary
real $L$ cannot both terminate on every legal Cauchy name and decide that exact
cutoff correctly: choose a name with slack in every error bound; a terminating
run sees finitely many answers, all also valid for some $L_m+\delta$, so it
must give the same answer on two different cutoffs. This is a mathematical
argument about that exact classifier, not a Lean theorem in this packet.
It does **not** forbid exact-real circuit existence, approximate state
preparation, finite rational input, or an explicitly charged comparison oracle.

The Python prototype accepts positive rational $L$ and refines rational pi
bounds with a fixed cap, failing closed if undecided. A uniform polynomial
separation bound is not proved. Decimal setup followed by float64 does not
provide a $k,L,\epsilon$-dependent error budget; stored-zero pruning can remove
underflowed nonzero real values. These remain explicit, testable limitations.

## Executable evidence, separate from the symbolic root

Independent current-source revalidation passed 18 MPS tests and 7 MASS tests.
The old monomial cancellation/overflow failures remain regression fixtures.
Actual saved QASM files were opened and independently replayed against the
MASS implementation of the original target, without importing the MPS cores.

| $(n_p,k,L)$ | RY / CX | Bond wires | State error | Garbage norm | Evidence |
| --- | --- | --- | --- | --- | --- |
| $(8,8,10)$ | 764 / 764 | 2 | $2.54\times10^{-15}$ | $2.78\times10^{-16}$ | full finite replay, tolerance $10^{-9}$ |
| $(8,8,300)$ | 90 / 90 | 1 | $4.34\times10^{-15}$ | 0 | full finite replay, tolerance $10^{-9}$ |
| $(128,2,1)$ | 741936 / 741936 | 4 | not simulated | not simulated | streamed 37,333,643-byte file; syntax/count/hash only |

The saved file hashes are recorded in the archived and fresh evidence packets.
The n128 constructor stored 25,240 core scalars; it did not form the full
amplitude vector. Norm and five amplitude probes do not replace full-state
acceptance. At some small parameters this method costs more than the old
reference, so no pointwise resource dominance or optimality is claimed.

The Python compiler uses cyclic Gray/Walsh rotations; Lean uses recursive
selected rotations. Different instruction sequences and CX counts mean the
Python replay is not a replay of the Lean certificate. Both deliberately
missing-file replay and missing-file streaming scan returned nonzero exits,
with no fallback to historical success JSON.

## Search and Harness delta

The useful evolution was a concrete mutation plus complementary proof work:

- MPS-01 exposed low-dimensional algebra but failed at high order/large $L$.
- MPS-02 replaced cancellation-prone masks by positive local Bernstein
  injection and bounded tail factors, while preserving the exact target.
- MASS supplied independently implemented target/norm checks. Its coherent
  arithmetic circuit was not secretly assumed or incorporated.
- Parallel workers closed source kernels, canonicalization and primitive
  compilation; integration reused explicit local-column and word-order
  interfaces, and independent review caught the distinction between selected
  gate counts and full instruction length.

`HARNESS.md` now calls for a complementary worker portfolio, compact verified
handoffs, mutation/crossover lineage, and separate evidence tiers. The existing
CLI profile names remain compatible; worker methods can be natural-language,
Lean-first or mixed. `tools/qbe.py` prioritizes explicit root/module anchors in
bounded retrieval, preserves restricted retrieval boundaries and replaces
fixed-role proof prompts with objective-specific Universal Worker prompts.
`tools/test_qbe_context_pack.py` covers these changes. No verifier, acceptance
anchor, controller transition, score or benchmark split was weakened.

The recorded `run-cycle` calls generated prompt/context decks; actual workers
were coordinated in this app. They are not evidence that a standalone CLI
provider executed the whole evolution loop autonomously.

The run does **not** establish that one language mode or Harness is fastest:
there is no paired held-out comparison, and per-worker token/call telemetry
is incomplete. Account/goal totals are not attributed to worker methods.
The design borrows complementary population ideas from
[EoH-S](https://arxiv.org/abs/2508.03082), whose reported optimization benchmarks
are not evidence of quantum-domain gains for this implementation.

## Verification and reproduction

The complete quantum-root integration passed `lake build` (3446 jobs) and
`lake build Tests` (3472 jobs). The norm supplier and its independent tests
then passed their scoped build (3364 jobs). Job counts describe these exact
snapshots. The depth/resource corollary passed its scoped build (3373 jobs).
These are
not counts of scientific theorems or fresh compiler invocations.
Final combined integration subsequently passed `lake build` (3450 jobs) and
`lake build Tests` (3480 jobs). Harness regression ran 98 tests: 97 passed and
one pre-existing platform-dependent test was skipped. These observed results
and source hashes are retained in
[`cycle02-formal-resource-gates.json`](evidence/cycle02-formal-resource-gates.json),
which is explicitly not a full-task acceptance record. The append-only task
trial log records the integration scope separately from earlier frontiers.
Existing linter warnings and the pre-existing local Verso package patch are
not new proof failures.

Run the [README reproduction commands](README.md) from the repository root.
The detailed [classical cost audit](CLASSICAL-COST-AUDIT.md) and
[independent executable review](EXECUTABLE-REVIEW.md) preserve the next
interfaces, exact replay commands and file hashes.
The stable tests explicitly import the new root files. Missing source or
failed Lean compilation must not be replaced by a stored success record.
Ignored worker reports and raw logs are diagnostic provenance; this tracked
report, the production sources, tests, and `evidence/` packet preserve the
claim boundaries without host-specific paths. No public deployment or full
candidate acceptance is implied by this result.

## Attribution

The target follows [arXiv:2403.19123](https://arxiv.org/abs/2403.19123), with
the literal function fixed by the existing Hermite library. Sequential
finite-ancilla MPS preparation follows
[Schön et al.](https://arxiv.org/abs/quant-ph/0501096). Gray-ordered real-unitary
decomposition and uniformly controlled rotations follow
[Vartiainen, Möttönen and Salomaa](https://arxiv.org/abs/quant-ph/0312218) and
[Möttönen et al.](https://arxiv.org/abs/quant-ph/0404089).
The conservative cubic bound here is for the implemented backend, not an
attribution of an optimized general-isometry bound to this code.
