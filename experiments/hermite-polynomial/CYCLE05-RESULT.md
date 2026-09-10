# Cycle 05: actual stored source and conditional circuit accuracy

Date: 2026-09-10. Base main: `5d7e27a7faaf9465eb405db41f6cd1f323d05db2`.
The [frozen scientific target](../../tasks/SP-HERMITE-POLY-002.md) is unchanged.
This is the result of the earlier [design](CYCLE05-DESIGN.md), not a claim
that every part of that design or the complete finite-precision task is closed.

## Result and acceptance boundary

The raw source now has an actual cached producer, not an arbitrary
matrix-entry oracle. Its returned chain agrees with the literal Hermite
sample function for every allowed input. The same returned object carries
a proved polynomial ordinary-operation bound and separately counted
exponential and selected integer operations.

A second, independent result bounds the error of the actual primitive
circuit when its RY angles are perturbed. It preserves gate positions,
physical wires and order. It is a **conditional accuracy theorem**, not
an implemented finite-bit angle evaluator.

The existing exact-real quantum bound remains `48*N*D^3`, with
`N=n+1=n_p` and `D=2*k+6`. Whole normalized stored compilation, finite-input
numerics and uniform executable refinement remain open. This batch does not
replace the public circuit producer or the Python/QASM exporter.

The canonical library, tests and all production/test modules passed the full
Lean gate. The [integration record](evidence/cycle05-local-integration.json)
binds this result to proof-input digest
`1e65e7d2984e4542ca2747837d71c516847e4e987d3bbd6c48b8a803eb36806e`.
The complete website/publication pipeline also passed (exit 0): 348 HTML
pages, 4524 declaration-search entries, 138 module pages, nine chapters and
nine diagrams. Source-link, download/preview and local-path checks passed;
509 publication text files were scanned for local-path leakage. The 4201
commit-pinned links in this local build refer only to clean files at the
base commit. New declarations already have local source views; the remote
build supplies their new-commit links after publication. This local result
is not a remote deployment attestation, and the cycle-04 digest is not reused.

## What the producer actually does

1. Generate the original positive Bernstein coefficients and two shared
   subdivision tables from cached factorial and inverse-power data.
2. Find the exact source cutoff with the existing binary search. Cache tail
   widths/factors, binary-Horner real coordinates and integer dyadic spans.
3. Derive both child intervals and their original Full/Partial guards at
   each chronological stage. Compute only enabled source injections.
4. Materialize both bit slices of each small `D`-by-`D` core.
5. Contract the terminal boundary into the last core, then the initial
   boundary into the first core. When `N=1`, both operations are performed.
6. Return the stored chain and combine the ledgers of those actual suppliers
   once. No `2^N`-entry amplitude table is generated.

The explicit bond order is left boundary, left free, middle boundary,
Bernstein entries, right free. Source words are MSB-first; the previously
proved final circuit still exposes little-endian physical data wires.
Observable source equality is **not** entrywise equality to the older
cardinality-based internal bond layout.

## Checked source and resource interfaces

All import names below have the prefix `QuantumBlockEncoding.`.
Matching `ABEISTests/<module>.lean` files give checked calls and edge cases.

| Module | Interface to retrieve | Exact scope |
| --- | --- | --- |
| `StoredBinaryCoordinates` | `binaryReal_value`, `parents_lower`, `parents_cost` | Binary Horner conversion of stored addresses; selected quotient/remainder calls counted separately |
| `StoredDyadicSpans` | `spans_value`, `spans_total_cost`, `spans_integerDoublings` | Actual cached integer doublings, not a free power callback |
| `StoredHermiteGeometry` | `tailCache_value`, `atStage_rightCore`, `leftInjection_value` | Cached tail factors, first-stage selector and last-included-point injection |
| `StoredHermiteSharedTables` | `compile`, `injectionRow` and their value/cost lemmas | Actual shared matrices and stored restricted coefficient rows |
| `StoredHermiteChildGeometry` | `children_refines`, `children_cost` | Child endpoints and guards from stored parent coordinates |
| `StoredHermiteSourceCache` | `compile_source`, `compile_parents_lower`, `compile_spans`, `compile_total_cost_le` | All source cache inputs produced from `k,n,L` |
| `StoredHermiteStageInput` | `inputCorrect`, `input_certified` | Actual source cache discharges downstream supplier conditions |
| `StoredHermiteStageFields` | `two_source`, `two_total_cost_le` | Both bit-field records, with separate exponential ledger |
| `StoredHermiteKernelTable` | `assemble_source`, `assemble_total_cost_le` | Materialized local core, including explicit bond dispatch |
| `StoredHermiteBoundaries` | `initial_value`, `terminal_value` | Literal initial/terminal vectors with charged construction |
| `StoredMatrixProductChain` | `ofTable_refines`, `ofTable_total_cost_le` | Actual boundary-contracted stored chain |
| `StoredHermiteRawSource` | `raw_value`, `raw_contract` | Same returned chain equals the original unnormalized sample family |
| `StoredHermiteRawCost` | `raw_certified` | Same chain, polynomial ordinary bound and extraordinary counters |

Write `K=k+1`, `d=2*k+1`, `N=n+1`, `D=2*k+6`. The checked
ordinary counter bound `rawBudget k n` is

```text
3200*K^2 + 256*N^2
+ N*(40*d^3 + 84*d^2 + 64*d + 200 + 576*D^2)
+ 20*D^2 + 62*D + 5*n^2 + 7*n + 37.
```

It is polynomial jointly in data width and interpolation degree. Separately:

- Exponential calls: at most `3*N+1`, with disabled injections making no call.
- Selected quotient calls: `N*(N+1)`; selected remainders: `N^2`.
- Integer span doublings: `n`; selected child-address additions: `4*N`.

The ordinary ledger uses the existing field/sqrt/angle/trig/compare/read/write/
emit model. These additional counters do **not** count every index operation,
allocation, garbage collection, arbitrary-precision bit operation or the cost
of approximating an exponential. The numerical size of `L`, required input
precision and conditioning have not disappeared from finite-bit complexity.

The raw tests also consume the actual `StoredTensorTrainNorm.norm`:
its value is the original sample norm, positive and at least one. Its
separate polynomial cost is checked. This is not yet a single costed
normalized source-to-final-instruction producer.

## Conditional angle accuracy

`PrimitiveRyPerturbation.eval_ry_distance` proves, for the actual physical
RY gate and any number of spectators,

```text
||RY(a)-RY(b)||_(2->2) = 2*abs(sin((a-b)/4)) <= abs(a-b)/2.
```

There is no exponential dimension factor. The proof retains the scalar sign,
so it does not identify a `2*pi` angle change with zero operator error.

`PrimitiveCircuitPerturbation.Aligned` is positional `List.Forall2`.
Non-RY gates are unchanged; changed RY gates keep the same physical target.
The actual evaluator order is used in the telescoping theorem:

```text
||eval(approximate)-eval(exact)||_(2->2) <= length(exact)*delta/2.
```

For the existing actual Hermite `prepare` list,
`prepare_conditional_clm_distance_le` gives operator error at most epsilon
when epsilon is nonnegative and every changed angle obeys

```text
delta = epsilon / (24*N*D^3).
```

The explicit Euclidean continuous-linear-map statement prevents accidental
use of an entrywise matrix norm. An aligned approximate circuit is still a
hypothesis. Input perturbations, discontinuous internal angle conventions,
certified scalar evaluation, gate-set synthesis and serialized literals are
not supplied by this theorem. After rounding, exact ancilla cleanup must not
be claimed from an approximate bound.

## Regressions and preserved failures

The tests cover zero/midpoint cutoffs, a sample exactly at -1, the one-stage
double boundary contraction, signed and empty stored-chain cases, both bit
slices, a nonsymmetric shared matrix, and 01/10 word-order discriminators.
A dyadic-span test evaluates an actual 128-bit-width cache entry and its
selected ledger; this is not a 128-qubit statevector test.

Precision tests retain empty and pure-CX circuits, RY-CX-RY order, zero
epsilon, the 0-to-2*pi sign case, and wrong-target/reordered-gate rejection.
Repeated gate positions cannot be deduplicated in the error budget.

A dependent vector rewrite initially failed during raw-source integration;
a value-projection lemma repaired the proof without changing the producer.
One redundant concrete Word128 elaboration exceeded the recursion limit;
the quantified all-width theorem and explicit two-bit tests were retained.
Neither incident is a scientific counterexample. The earlier monomial
numerical failures and overflow records remain unchanged.

## Next root-level interfaces

- Compose stored norm and first-core scaling, then canonicalization and
  completion, charging actual returned intermediates exactly once.
- Produce explicit selected-control ordering and the complete local
  Gray/Givens-to-instruction path. Semantic refinement is sufficient:
  requiring identical angle-expression syntax would create an unnecessary
  obstruction.
- Establish finite input representation and an actual certified numerical
  backend. Conditional angle accuracy alone does not solve internal
  conditioning or finite-bit runtime.
- Keep fresh workers on independent interfaces and freeze public proof inputs
  during integration. No evidence here establishes a general speed advantage
  of natural-language exploration over direct Lean or vice versa.

## Change scope and reproducibility

This is additive Lean mathematics, tests, catalog membership and frontier
documentation. It changes no controller policy, score, verifier, acceptance
anchor, benchmark split, old task target or historical numerical record.
Remove the new imports/modules and regenerate the catalog to roll back this
packet; no existing scientific construction needs replacement.

Required final commands are `lake build`, `lake build Tests`, and the
complete platform publication pipeline (`scripts/build-all.ps1` on Windows,
`scripts/build-all.sh` on Unix). Record their terminal outcomes and current
proof-input digest before promotion; do not infer them from scoped checks.
