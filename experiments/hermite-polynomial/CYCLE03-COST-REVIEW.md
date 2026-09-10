# Cycle 03: independent stored-cost review

Reviewed on 2026-09-10. Scope: `StoredGivens`, `StoredRectangularGivens`,
`StoredThinLQ`, and `StoredBernstein`. Paths and line numbers below are
repository-relative. This review did not modify production Lean source.

## Verdict

No blocking error was found in the four concrete producers' numerical
refinements or their stated bounds on the defined counters. Their bounds are
substantive: they count the named producers' charged operations, not merely
matrix dimensions or rotation-list lengths. Stored intermediate values,
repeated Bernstein row calculations, persistent vector copies, transform
replay, and factor extraction are included as described below.

These are nevertheless **bounds in the declared extended exact-real cost
model**, not whole-machine runtime theorems. The cost interface does not
automatically establish honest charging of an arbitrary callback. Source
generation and whole-pipeline cost closure must not be inferred from these
four modules or from the completed quantum gate-count theorem.

## Producer-by-producer inspection

| Producer / source anchor | Actual computation reviewed | Certified result and boundary |
| --- | --- | --- |
| `StoredGivens.angle`, `:88`; `coefficients`, `:110` | Charged squares, addition, square root, zero test, division, arccos, sign test, signed/doubled angle; then charged half-angle and sine/cosine. The angle and coefficient triple are shared across a row update. | `angle_value` / `coefficients_value` match the exact elimination formulas. Square root, angle, trigonometric calls, and comparisons have separate counters; none is silently counted as field arithmetic. These are exact-real primitives, not finite-precision implementations. |
| `StoredGivens.rowPair`, `:141`; `rotate`, `:161`; `eliminate`, `:192` | Both old rows are read from nested vectors. A vector of computed entry pairs is materialized, then projected into two stored rows. Persistent row replacements charge copying the outer vector of row references. Pivot/row rereads are charged. | `rowPair_cost` (`:272`) and `rotate_cost` (`:279`) give exact modeled counts. `rotate_value` / `eliminate_matrix` refine the functional semantics; there is no dense multiplication used to perform the update. Row references are treated as stored words, not deep-copied row contents. |
| `StoredGivens.columnSweep`, `:219` | One recursion returns both updated matrix and rotation log. It does not rerun elimination to obtain the next matrix. | `columnSweep_cost_le` (`:313`) bounds every operation category; `columnSweep_action` (`:361`) links the same returned matrix and log. `stepBudget_fields` (`:328`) expands the budget. |
| `StoredRectangularGivens.sweep`, `:24`; `compile`, `:150` | Every column dispatch is charged. `append` (`:21`) charges copying the left list spine. A stored identity is constructed (`:92`), then the logged rotations are replayed with stored two-row updates (`:110`), rather than evaluating `stepsMatrix` as dense products. Replay includes its terminal read and recomputation of half-angle/trigonometric values. | `compile_reduced`, `compile_steps`, and `compile_transform` (`:156`, `:161`, `:166`) separately refine the actual outputs. `replay_cost` (`:135`) and `compile_total_cost_le` (`:240`) charge the producer. Determinant one (`:201`) is a proved property, not an evaluated determinant branch. |
| `StoredThinLQ.wide`, `:74`; `compileBody`, `:111`; `compile`, `:122` | Wide input is transposed through charged entry reads/materialization, eliminated, and both factors extracted through charged reads/materialization. The tall branch shares the input as `R` and materializes identity `Q`. Dispatch adds a comparison. | `transpose_cost`, `extractR_cost`, `extractQ_cost` (`:43`, `:64`, `:69`) account for these passes. `compile_R` / `compile_Q` (`:145`, `:153`) refine the particular deterministic factors; `compile_correct` (`:162`) proves factorization and orthonormal rows. The tall branch does not promise an independent deep copy of `R`. |
| `StoredBernstein.step`, `:31`; `rows`, `:42`; `left` / `right`, `:93` / `:99`; `restrict`, `:154` | Each de Casteljau row is stored before the next. Each edge entry recomputes the required rows; the edge budget counts those repetitions. Restriction charges two subtractions and a division between the two edge computations. | `rows_value` (`:53`), `left_value` / `right_value` (`:105`, `:111`), and `restrict_value` (`:162`) refine the existing coefficient formulas. `restrict_total_cost_le` (`:178`) bounds the actual restriction producer, starting from a supplied coefficient vector and supplied parameters. |

## Precisely proved cost bounds

Let the matrix dimensions be as stated; `total` is the sum of the eight
explicit counters, as defined in `StoredRectangularGivens.lean:236`.

- `StoredGivens.columnSweep_cost_le`: at most `count` times the per-step
  budget. For an `N × M` stored matrix, that budget is field `6M+8`, sqrt `1`,
  arccos/angle `1`, trig `2`, compare `2`, read `10M+2N+6`, write `6M+2N`,
  and emit `1`. This is an upper bound; zero pivots can use fewer operations.
- `StoredRectangularGivens.compile_total_cost_le`: for `N × M` input,
  `total cost ≤ NM(22M+30N+29) + 5N² + 4N + M + 1`.
- `StoredThinLQ.compile_total_cost_le` (`:190`): for `m × n` input,
  `total cost ≤ nm(22m+30n+41) + 5n² + 6m² + 8n + 9m + 2`.
- `StoredBernstein.restrict_total_cost_le`: for `d+1` stored coefficients,
  `total cost ≤ 20d³ + 42d² + 32d + 13`.

These theorems concern the `.cost` of the actual named `Run` values. Their
refinement theorems establish numerical output equality, not a separate
operational simulation theorem for Lean-generated machine code.

## Important model boundary: arbitrary expressions can enter `pure`

`StoredGivens.Run.pure` (`:33`) assigns zero cost to its argument. `Run.bind`
(`:35`) adds the supplied costs. Neither constructor checks a real-expression
syntax tree or proves that its producer charged every operation.

The following minimal examples were checked with `lake env lean --stdin`
(exit 0), without creating or changing a source file:

```lean
import QuantumBlockEncoding.StoredGivens
open QuantumBlockEncoding.StoredGivens

example (x : ℝ) : (Run.pure (x * x)).cost .field = 0 := rfl

example (x : ℝ) :
    (materialize (N := 1) (M := 1)
      (fun _ _ => Run.pure (x * x))).cost .field = 0 := by
  simp [materialize_cost, Run.pure, tick]

example (x : ℝ) :
    (materialize (N := 1) (M := 1)
      (fun _ _ => Run.pure (Real.exp x))).cost .angle = 0 := by
  simp [materialize_cost, Run.pure, tick]
```

This is not a counterexample to the four concrete cost theorems. It shows why
`materialize_cost` (`StoredGivens.lean:369`) is a composition formula for
callback-reported costs, not an automatic source-evaluation bound.
`materialize` itself documents that boundary at `:75`. A future caller must
use an audited charged producer or supply a separate evaluation-cost/refinement
contract; wrapping a large expression in `pure` is not such a contract.

For the four concrete bodies inspected, no analogous uncharged dense matrix,
determinant, sign, or exponential computation was found. All real arithmetic
used by their numerical update bodies goes through the charged scalar
operations. `Real.exp` does not occur in these four files. A determinant
appears only in the transform-property theorem, and permutation-sign
evaluation does not occur in their producers.

## Storage, casts, and runtime scope

- `collect` (`StoredGivens.lean:60`) first constructs
  `Vector (Run α) n`, then projects stored values and sums stored counters.
  `rowPair` uses that stored vector of pairs; the inspected updates are not
  nested entry callbacks disguised as cached matrices.
- `replace` (`:67`) explicitly charges a full persistent vector copy.
  Rectangular append likewise charges the left spine. Sharing immutable
  right lists, input matrices, row references, and scalar references is part
  of the representation; deep-copy ownership is not promised.
- Counter bookkeeping is explicitly outside the model. That includes costs
  of evaluating cost functions/sums and length values used only to compute
  counters. General loop/index arithmetic, record/tuple allocation, garbage
  collection, and all actual compiler/runtime overhead have no complete
  charging/simulation theorem here. Consequently the displayed numeric
  polynomials are not literal instruction-cycle counts.
- The `Eq.mpr` adapters in `StoredThinLQ.lean:127`, `:136`, and `:168` transport
  dimension-indexed types across equalities. They do not select factor data
  or recompute a matrix; the dimension branch is explicitly charged. Treating
  proof casts as erased remains part of the intended execution interpretation,
  not a proved machine-runtime result in these modules.
- Exact real inputs and scalar operations are assumed by this model. Precision,
  conditioning, representation size, and the cost of approximating sqrt,
  arccos, sine, cosine, or exact comparisons are not covered.

## Uncovered source and whole-pipeline boundaries

1. Stored matrices and Bernstein coefficient vectors are inputs to these
   algorithms. Producing them, finite indexing adapters, cutoff/interval
   selection, source constants, and any exponential evaluations need their
   own charged construction contracts.
2. Bernstein `restrict_value` refines the coefficient definition for all
   parameters using total real division. Interpreting it as polynomial
   restriction additionally uses the source-side side conditions, e.g.
   `HermiteBernstein.restrictCoefficients_eval` (`:317`) requires `u ≠ 1`.
3. No inference from these four modules closes stored normalization, full TT
   absorption/canonicalization, SO placement, or primitive emitter costs as a
   composed pipeline. Other workers' modules were not needed or audited for
   this bounded review.
4. Exact quantum gate/depth bounds do not supply classical compilation cost.
   Uniform rounding and finite-precision exported-circuit error remain
   separate obligations.

## Audit provenance

The four source files were read completely. Scoped scans found no `sorry`,
`admit`, `unsafe`, custom axiom, witness `choose`, kernel-check skipping, or
suspicious semantic-flag promotion. Existing build traces were inspected; this
review did not rerun full project gates, which belong to the parent integration
task. The only new check run here was the read-only stdin boundary example.

Audited SHA256 snapshots:

- `QuantumBlockEncoding/StoredGivens.lean`:
  `87A1F69D5B138F23C96A6F77A438AA81EDEF27427CB2581C4DEFE019079D2EE4`
- `QuantumBlockEncoding/StoredRectangularGivens.lean`:
  `F8638A6D287B3B984FA530B13EEB18E3992904543236BD0756EDA41FA6490D98`
- `QuantumBlockEncoding/StoredThinLQ.lean`:
  `ED08EF278A93268F7D9620CB2DDAFC2E3468FCC4F2543923251A3CE4E057177A`
- `QuantumBlockEncoding/StoredBernstein.lean`:
  `F8D70BC9A442DB23288D2DCF29802589CEE28B826A28D03B5A6C026D80AC0221`

Recommended report wording: “The four stored producers have checked
refinements and polynomial bounds on the explicitly defined extended
exact-real operation counters. Whole classical preprocessing/runtime and
rounding guarantees are not claimed.”
