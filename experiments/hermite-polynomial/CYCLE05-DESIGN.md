# Next bounded experiment: stored source composition and angle-error analysis

Status: **design only**, prepared during cycle-04 integration on 2026-09-10.
No result below is promoted to a compiled theorem unless an existing source
anchor is explicitly named. The scientific target and acceptance boundaries
remain those of `SP-HERMITE-POLY-002`.

## A. Actual stored raw source

Let `N=n+1`, `d=2k+1`, `P=d+1` and `D=2k+6`. The next implementation should
return a `SourceRun (StoredChain N 1 1)`, with exponential calls kept separate
from the ordinary eight counters. Its preferred strong refinement target is

```lean
denoteChain (raw k n L).run.value = HermiteExplicitBond.rawSourceChain k n L
```

under `0 < L`. This supplies the literal source action via
`HermiteExplicitBond.rawSourceChain_contract`, then the original observable
source through `same_literal_source`. It does not require an unsupported
entrywise equality to the earlier cardinality-choice layout.

| Proposed component | Actual stored data | Required proof bridge |
| --- | --- | --- |
| `sourceCache` | one `StoredHermiteCoefficients.compile` vector | original `sourceBernsteinCoefficient` entries |
| `sharedTables` | two `P`-by-`P` matrices; factorial and inverse-power caches | `HermiteBoundaryInjection.sharedCore` using its false/true closed forms |
| `geometry` | cutoff, per-level integer boundary starts, matching real coordinates and dyadic widths | existing `cutIndex`, `boundarySchedule`, `selectedChild` and `affinePoint` |
| `middleRow` | at most two stored restricted coefficient rows per level | the boundary-to-Bernstein part of `injectionCore` |
| `tailFactors` | one shared `exp(-step*2^r)` per level and only enabled left injections | `leftFree`, `rightFree/rightCore`, `leftInject` |
| `kernelTable` | `N` stored two-slice `D`-by-`D` local cores | every entry of `HermiteExplicitBond.kernel` |
| `fromKernelTable` | last-core terminal contraction, first-core initial contraction, shared interior cores | exact `MatrixProductChain.ofKernel` chain equality |

The explicit layout is: left boundary `0`, left free state `1`, middle
boundary `2`, Bernstein state `j` at `3+j`, right free state `D-1`.
Only initial entries `0,2,D-1` can be nonzero; terminal entries `1,3,D-1`
are one. Source-side branch guards must be retained.

Carry real coordinates along the integer dyadic schedule. Do not silently
treat converting an exponentially large natural address to a real as one
free arithmetic step. A first implementation may charge persistent geometry
vector extensions by full copying, giving a conservative quadratic term in
`N`. Index-word and bit costs remain separately stated.

The shared matrices should use closed forms, not independently evaluate the
recursive semantic subdivision for every entry. Regenerating one factorial
cache is acceptable if its cost is included. A left injection is evaluated
only when the child interval is `Full`; use its last included coordinate,
`childLower + childWidth - step`, to keep the exponential bounded. Existing
`leftInject_bounds`, `leftFree_bounds` and `rightFree_bounds` are available.
For a full middle child, prove `0 <= u < v <= 1` before consuming the
restriction interpretation, including its nonzero `1-u` denominator.

At `n=0`, the first core is also the last core. Terminal contraction must
precede initial contraction; neither may be dropped.

### Planned cost target, not a result

Existing proved supplier bounds contribute

```text
864*(k+1)^2 + (3*n+3) + 2*N*(20*d^3+42*d^2+32*d+13).
```

The new producer must also charge shared tables, geometry/cache copying,
every local core materialization, boundary contractions and chain records.
A conservative proposed ordinary-operation target is
`O(N*(k+1)^3 + N^2 + (k+1)^2)`, plus at most `3*N+1` explicit exponential
calls. These are design bounds, not currently proved costs of `raw`.

Suggested independent tasks are geometry/tails, Bernstein/kernel caches and
generic stored boundary-chain assembly. The parent should compose their
actual returned values and counters before connecting the stored norm.
Tests must include `k=0`, `n=0`, cutoff zero/midpoint, a sample exactly at
`-1`, empty middle intervals and the right-tail first-stage selection.

## B. Conditional angle-error composition

This is a separate proposed analysis lemma, not a finite-precision compiler.
Use the Euclidean induced operator norm (`Matrix.Norms.L2Operator`), not the
default entrywise matrix norm. Two RY/CX circuits must have identical ordered
gate types and physical wire labels. CX gates are unchanged. A positional
`List.Forall2`-style relation should align each pair of RY angles; do not
deduplicate repeated angles with a set.

Writing exact and approximate angles as `theta_j` and `thetaHat_j`, the
proposed bound is

```text
||eval(cHat) - eval(c)||_(2->2)
  <= (1/2) * sum_over_RY_positions |thetaHat_j - theta_j|.
```

The local ingredient is
`||RY(a)-RY(b)|| = 2*|sin((a-b)/4)| <= |a-b|/2`, with no spectator-register
dimension factor. Telescope using the actual chronological convention
`eval(g::rest)=eval(rest)*eval(g)` and unitary norm preservation.

Candidate verified library locations are `PrimitiveSemantics.lean` for the
half-angle matrices, lifted one-qubit actions and unitarity; Mathlib's
`Analysis.CStarAlgebra.Matrix`, `Analysis.CStarAlgebra.Basic` and
`Analysis.SpecialFunctions.Trigonometric.Bounds` for `Matrix.toEuclideanCLM`,
`Matrix.l2_opNorm_mulVec`, unitary multiplication norm lemmas and
`Real.abs_sin_le_abs`. Retrieve exact signatures before implementation.

For the existing Hermite bound `B=48*N*D^3`, certified per-angle error
`delta=2*epsilon/B=epsilon/(24*N*D^3)` would imply total operator and zero-input
state error at most `epsilon`. This entails total non-clean ancillary
probability at most `epsilon^2`, **not exact ancillary cleanup after rounding**.
If a real exporter proves angle error at most `2^(-p)`, the condition
`2^(-p) <= epsilon/(24*N*D^3)` is a precision budget; it is not a proof that
the exporter can compute those angles in polynomial time.

Minimal tests: empty/pure-CX circuits, zero physical width, one RY with the
correct half-angle constant, arbitrary spectator wires, noncommuting
RY-CX-RY sequences, and rejection of mismatched physical labels. The
`0 -> 2*pi` angle example has operator distance `2`, so a raw `2*pi` phase
identification must not invalidate the operator theorem.

### Missing input-to-angle link

The final source normalization is not known to be arbitrarily small:
`HermiteIntervalMass.sampled_mass_ge_one` already proves it is at least one.
The difficult conditioning issues are internal: zero/sign branches, tiny
pivots and denominators, inverse-trigonometric endpoints and source rounding.
For example, the existing Givens angle convention jumps from zero at `(0,0)`
to `2*pi` at `(-t,0)` for positive `t`. Thus small source perturbations need
not give small errors in each **chosen raw angle**. This is an obstruction to
that particular angle-comparison strategy, not to approximate preparation of
the original state.

The full goal still needs an explicit finite input representation, certified
scalar approximations and propagation through the actual algorithm, a
cutoff/separation or tolerant-boundary policy, and binding to exported angle
literals and their computation cost. Neither rational-approximation existence
nor a successful finite Qiskit replay closes those obligations.
