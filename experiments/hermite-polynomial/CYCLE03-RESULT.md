# Cycle 03: a deterministic polynomial-gate Hermite compiler

Task: `SP-HERMITE-POLY-002`. Date: 2026-09-10.

## Certified result

For the unchanged literal Hermite sample amplitudes, every `n_p >= 1`,
`k : Nat` and real `L > 0` now has a named, deterministic exact-real circuit
producer, not only an existence theorem:

```lean
ConstructiveHermitePreparation.prepare k n L
ConstructiveHermitePreparation.prepare_spec k n L hL
```

Here `n + 1 = n_p`. Put `D = 2*k+6` and `q = ceil(log2 D)`. The specification
proves, for this same produced circuit:

- gate count and actual scheduled depth at most `48*n_p*D^3`;
- `n_p` data wires, `q` clean bond wires, and zero oracle calls;
- unitarity on the whole register;
- the required normalized amplitude on every public little-endian data word,
  with zero amplitude in every nonzero final bond sector.

The target is `g(p_j) / sqrt(sum_j g(p_j)^2)`, not its square root, and neither
the grid nor the polynomial/splice was changed. There is no postselection,
dense amplitude-table loader, free initial bond state, or target-action oracle.
For fixed smoothing order the bound is linear in data width; jointly it is
polynomial in width and smoothing order. This is **not** a claim about arbitrary
input amplitude tables.

The checked construction proceeds through the positive Bernstein boundary
kernel, local contraction norm, rectangular Givens LQ, right-canonical tensor
train, signed boundary absorption, active-column SO completion, Gray Givens
and recursive selected rotations, then physical wire placement and cleanup.
The original exponential reference and earlier existence roots are retained.

## Stored classical kernels: useful but not a whole-runtime certificate

The following bounds charge the actual stored producers in the declared
exact-real scalar-operation model. Read/write and copying costs are included
where specified by the producer; these are not bit-operation counts.

| Producer | Checked upper bound | Refinement |
| --- | --- | --- |
| `StoredRectangularGivens.compile` | `N*M*(22*M+30*N+29)+5*N^2+4*N+M+1` | stored reduction and orthogonal transform |
| `StoredThinLQ.compile` | `n*m*(22*m+30*n+41)+5*n^2+6*m^2+8*n+9*m+2` | exact `ConstructiveThinLQ.factor` outputs |
| `StoredIsometryCompletion.complete` | `N*r*(22*r+30*N+43)+20*N^2+27*N+5*r+3` | exact deterministic completion |
| `StoredTensorTrain.canonicalize` | `n*(176*D^3+116*D^2+29*D+8)+5*D^2+4*D+6` | equality of the actual canonicalization result |
| `StoredBernstein.restrict` | `20*d^3+42*d^2+32*d+13` | exact positive-coefficient restriction |

Dimensions and shape assumptions are those of each Lean theorem. Input
production is not silently free: these local bounds start with stored inputs;
the `completeFrom` interface explicitly adds its suppliers' reported costs.
See the [bounded cost review](CYCLE03-COST-REVIEW.md). In particular, the
counter type itself cannot prevent an author from hiding computation in a
zero-cost pure expression. The charged bodies require review; this is not a
machine-level operational-semantics or allocation proof.

Still open are source coefficient/cutoff/exponential generation, a composed
stored norm-and-adapter pipeline, charged primitive emission, and a theorem
for the entire classical compiler. These local polynomials must not be added
and advertised as a completed end-to-end runtime theorem.

## Executable evidence and the exact boundary

`SelectedRyTrace` is a computable rational-coefficient instruction producer
with all-width Lean refinement to the recursive selected-rotation semantics.
Python agrees instruction-for-instruction on 129 exported cases (4,521
instructions). Empty, missing, duplicate and corrupted trace inputs fail.
This tests that local emitter; it does not refine floating-point LQ or the
whole Python compiler to Lean.

Saved recursive-backend QASM was independently replayed against the analytic
Hermite source, without importing the MPS construction code:

| Instance `(n_p,k,L)` | RY / CX | Clean bond wires | State error | Depth |
| --- | --- | --- | --- | --- |
| `(8,8,10)` | 764 / 1,146 | 2 | `2.63e-15` | 1,878 |
| `(8,8,300)` | 90 / 90 | 1 | `4.34e-15` | 180 |

The first recursive circuit is larger than the earlier Walsh-backend circuit.
Backend correspondence is a reliability gain, not an observed gate-count win.
The 128-bit streaming example belongs to the earlier backend and remains a
syntax/resource/spot-check result, not a full-state acceptance record.
See [reproduction commands and hashes](RECURSIVE-BACKEND-REVIEW.md) and the
immutable `evidence/cycle03-*.json` observations.

## Harness and memory handoff

Natural-language exploration, direct Lean work and implementation/cost review
contributed distinct artifacts. Workers exchanged concrete kernel interfaces:
stored LQ fed stored TT; deterministic SO completion supplied its stored
refinement; the parent integrated the actual quantum root and independent
backend replay. Failures and the exponential baseline remain available.

The Harness now asks for bounded, anchor-first context packs, exact signatures
and imports, evidence-labelled crossovers, shared cost interfaces and a frozen
digest before integration. Tests cover the retrieval boundary. No verifier,
scientific target, acceptance anchor, scoring or benchmark split was weakened.
There is no controlled comparison establishing which worker style is fastest;
missing call/token telemetry is not replaced by invented numbers.

## Remaining scientific frontier

The **exact-real polynomial quantum-resource sub-root is closed**. The full
frozen task is not closed: uniform finite-precision error, finite-bit cost,
whole classical preprocessing, and whole executable-backend refinement still
need certificates. Exact cutoff classification at special real inputs also
requires a stated input representation/separation policy. A finite replay
does not remove that issue and is not an impossibility proof for approximate
state preparation.

The [live proof frontier](../../proof-obligations/SP-HERMITE-POLY-002.md) is
authoritative for those open nodes. [FORMAL-RESULT.md](FORMAL-RESULT.md) is the
preserved cycle-02 existence-result snapshot, not the current producer status.
