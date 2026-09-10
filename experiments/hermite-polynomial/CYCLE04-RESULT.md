# Cycle 04: source, normalization and local emission cost interfaces

Date: 2026-09-10. Base: `d638f725b7ed07fc471c25730cdf3bcfebe00510`.
This packet extends the [cycle-03 result](CYCLE03-RESULT.md); it does not
replace its exact quantum-resource root or the frozen scientific target.
The base main commit's deployment subsequently completed successfully; the
[public verification record](evidence/cycle03-publication.json) is separate
from this new research packet's integration status.

## Result and acceptance boundary

The new interfaces remove specific implementation gaps: source coefficients
are generated from cached tables, the source cutoff is found by binary
search, finite bond indexing is explicit, local norm environments are stored,
and the recursive rotation trace has a charged producer with exact list
refinement. These are composable interfaces, **not yet a composed classical
compiler-cost theorem**. They do not change the existing quantum circuit,
Python/QASM backend, acceptance anchors, verifier, scoring or task split.

The exact quantum bound remains `48*n_p*(2*k+6)^3`. Uniform finite-bit cost,
rounding and whole-backend refinement remain open. In particular, an
exact-real comparison primitive is not an implementation on arbitrary
finite-error names of real inputs.

## Named producers and precise claims

All module names below follow `QuantumBlockEncoding`. The corresponding
`ABEISTests/<module>.lean` file supplies checked applications and edge cases.
The eight ordinary counters retain the scope reviewed in
[CYCLE03-COST-REVIEW.md](CYCLE03-COST-REVIEW.md).

| Module / producer | Strong correctness bridge | Cost and scope |
| --- | --- | --- |
| `HermiteBinaryCutoff.compute n L` | `compute_value`: exactly the existing `HermiteBoundaryInjection.cutIndex n L`, for every `L>0` | Exactly `n+1` real comparisons and `2*n+2` field operations, where `n_p=n+1`. No ceiling or grid enumeration is executed by the producer. Natural address/power bookkeeping and finite-bit comparisons are excluded. |
| `HermiteExplicitBond.bondEquiv k`, `rawSourceChain` | Executable sum/option layout; `same_literal_source` proves equality of every observable raw sample, and `rawSourceChain_norm` gives the original source norm | Removes cardinality-choice indexing from this alternative representation. It does not assert old/new matrix-entry equality, nor a source scalar-evaluation cost. The published circuit constructor is unchanged. |
| `StoredHermiteCoefficients.compile k` | `compile_value` equals every original `sourceBernsteinCoefficient`; `compile_pos` proves all returned entries strictly positive | Cached factorial, source and left-coefficient tables. Ordinary counter total at most `864*(k+1)^2`, **plus exactly one separately counted exponential call**. The reusable `fromConstant` instead receives that constant explicitly. |
| `StoredTensorTrainNorm.gram C`, `norm C` | `gram_value` / `norm_value` exactly equal the existing local Gram and norm semantics | For a scalar-boundary `StoredChain n 1 1` with all bonds at most `D`, norm counter total at most `n*(24*D^3+25*D^2+20*D+6)+5*D^2+4*D+9`. Two matrix passes per physical bit, stored intermediate matrices and one final square root are charged; source-core production is excluded. |
| `StoredSelectedRyTrace.compile`, `selected` | `compile_value` / `selected_value` give exact ordered instruction-list equality; `*_refines` connects instantiated primitive semantics | For **local** control width `q` and `S=2^q`, compile total plus `5q+4` equals `(16q+7)S`. Including stored selected-bit encoding and one-hot production, total is at most `(16q+12)S+5q^2+3q`. This is not polynomial in `q` alone, nor a table over the data register. |

The trace module's `encode` conservatively tags two integer-word operations
per bit as extra `field` charges. `encodingIndexOperations` and
`selected_field_tag_split` isolate those extra `2q` charges. They do not
redefine the shared real/rational field counter or claim to count every
natural-number address operation. Rational bit growth, actual angle
evaluation/approximation and final serialization remain outside this trace
producer's cost interface.

## Evidence and independent review

Production and test sources are the primary evidence, not declaration counts.
Scoped successful builds have been observed for all five modules and their
tests. The full Lean gate has also passed, with proof-input digest
`448914e875837c53a5b2a5d08260c9eab4009eb75fd6a9e60503b66aeaf1866a`.
Unchanged MPS and independent mass regressions passed 26 and 7 tests.
The complete local publication pipeline subsequently passed: 318 HTML pages,
4201 declaration-search entries, commit-pinned source links, required download
and publication artifacts, preview and local-path scans. The
[local integration record](evidence/cycle04-local-integration.json) binds this
result to the proof-input digest above. Remote CI/deployment is a separate
observation; this local record does not predeclare its outcome.

- Cutoff tests include the one-cell case, strict equality at `p=-1`, the
  legal boundary input `L=1/pi`, and counts for 128 data qubits.
- Explicit-layout tests reduce actual maps at `k=0` and `k=3`, check inverse
  behavior, all-word source equality and positive source normalization.
- Coefficient tests include cached `4!=24`, `choose(5,2)=10`, degree-one
  endpoints and nontrivial degree-three/five coefficients, plus all-parameter
  refinement, positivity and costs.
- Trace tests execute rational instruction construction, preserve zero-angle
  rotations, test non-prefix/nonmonotone physical layouts, verify actual
  ledgers and cover zero controls. They do not replace the symbolic theorem.
- Norm tests cover signed amplitudes `(-3,4)`, a zero state, cancellation
  through a repeated-row bond, empty matrices and a genuine `1 -> 0 -> 1`
  internal bond. The latter still charges outer row materialization.
- A separate worker reviewed the cutoff and explicit layout without edits:
  no blocking finding, with exact-comparison and observable-source boundaries
  preserved. Another worker reviewed the trace producer and reran its tests;
  no blocking finding. The stored norm received a separate read-only cost
  review, also with no blocking finding. The parent read all five bodies.

Use these commands from the repository root for focused reproduction:

```text
lake build ABEISTests.HermiteBinaryCutoff ABEISTests.HermiteExplicitBond
lake build ABEISTests.StoredHermiteCoefficients ABEISTests.StoredSelectedRyTrace
lake build ABEISTests.StoredTensorTrainNorm
python -m unittest tools.test_blueprint_catalog
```

Full integration additionally requires `lake build`, `lake build Tests`, and
the normal `scripts/build-all.sh` pipeline (or its Windows PowerShell
equivalent). The catalog registers every new module explicitly; missing,
duplicate or stale membership still fails closed.

## Remaining composition obligations

1. Build the **stored raw source chain** from the coefficient/cutoff/layout
   interfaces, including bounded tail exponentials, interval scheduling and
   both boundary contractions. A vector of source coefficients is not that
   whole producer.
2. Feed that same stored chain through stored normalization and
   canonicalization, then stored local completion and primitive generation.
   Charge supplier work, physical placement and serialization once through
   the actual returned result; do not sum unrelated dimensional budgets.
   The existing `ConstructiveHermitePreparation.normalizedSource` already
   uses `HermiteFiniteNorm.localSampleNorm`; the missing step is its charged
   stored-producer composition, not replacing an alleged dense norm call.
3. State the finite input model and prove the required approximation budget.
   The exact cutoff discontinuity does not rule out approximate preparation;
   a finite Qiskit replay does not establish uniform correctness either.
4. Complete independent family-level executable refinement before promoting
   the full scientific root. The exponential reference and prior numerical
   failures remain preserved.

## Workflow observation

This cycle reused a shared stored-operation interface, assigned bounded
mathematical interfaces to parallel workers and exchanged exact theorem
signatures and independent reviews. No new agent layer or reward rule was
introduced. There is still no controlled evidence that natural-language,
direct-Lean or mixed workers are intrinsically faster; missing call/token
telemetry is not replaced by estimates presented as measurements.

Two useful repair records are retained in this packet: the cutoff proof first
failed on guessed Boolean/namespace names and a cast-normalization mismatch;
source lookup and explicit cast normalization repaired it. The norm proof
hit a definitional-equality heartbeat while expanding a nested `Run.bind`.
Small private value-projection lemmas and targeted rewrites resolved it
without increasing the heartbeat limit or changing the algorithm. These
are observed proof-engineering repairs, not a workflow-speed experiment.

The changes are additive modules, tests and catalog/frontier documentation.
Removing their imports and catalog entries together with the new modules
rolls back this packet without changing the published scientific target,
historical logs or existing acceptance mechanism.
