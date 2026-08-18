import QuantumBlockEncoding.StatePreparationBenchmarksCoreFixed
import QuantumBlockEncoding.StatePreparationPrimitiveRoutes

/-!
# Representative state-preparation benchmarks

Stable public entrypoint for the state-preparation benchmark suite.

* `StatePreparationBenchmarksCoreFixed` contains exact finite target,
  normalization, unitarity, and state-action certificates plus paper resource
  arithmetic.
* `StatePreparationPrimitiveRoutes` contains typed primitive-circuit semantics
  and same-target resource comparisons. A scored route is accepted only after
  the very same primitive circuit proves `U |0^n> = |psi>`.

Keeping these layers separate prevents a resource transcript from being
mistaken for a proof that the transcript implements the certified state.
-/