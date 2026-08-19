import QuantumBlockEncoding.StatePreparationBenchmarksCoreFixed
import QuantumBlockEncoding.StatePreparationPrimitiveRoutes
import QuantumBlockEncoding.StatePreparationPaperRoutesFinal

/-!
# Representative state-preparation benchmarks

Stable public entrypoint for the state-preparation benchmark suite.

* `StatePreparationBenchmarksCoreFixed` contains exact finite target,
  normalization, unitarity, and state-action certificates plus paper resource
  arithmetic.
* `StatePreparationPrimitiveRoutes` provides the typed primitive-circuit
  semantics and the Grover--Rudolph same-target comparison.
* `StatePreparationPaperRoutesFinal` instantiates the same proof-bearing route
  type for Möttönen-style dense preparation and the Li--Luo sparse finite
  witness using explicit finite clean-column reductions.

A resource score is public only after the very same typed circuit proves
`U |0^n> = |psi>`.  This prevents a resource transcript from being mistaken for
a proof that the transcript implements the certified state.
-/