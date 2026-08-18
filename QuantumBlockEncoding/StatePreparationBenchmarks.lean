import QuantumBlockEncoding.StatePreparationBenchmarksCoreFixed

/-!
# Representative state-preparation benchmarks

Stable public entrypoint for the state-preparation benchmark suite.

* `StatePreparationBenchmarksCoreFixed` contains exact finite target,
  normalization, unitarity, and state-action certificates plus paper resource
  arithmetic.
* `StatePreparationPrimitiveRoutes` (imported here once its exact route proofs are
  closed) contains typed primitive-circuit semantics and same-target resource
  comparisons.

Keeping these layers separate prevents a resource transcript from being
mistaken for a proof that the transcript implements the certified state.
-/
