# Candidate Populations

State-preparation, operator-construction, and exploratory modes may maintain
EoH-like populations of candidate quantum constructions.

Each candidate family should identify:

- target acceptance predicate, such as `U |0^n> = |psi>` for state
  preparation or a clean-block equation for block encoding,
- construction idea,
- normalization, normalizer, clean projector, or initial-state convention,
- Lean declarations and file scope,
- partial score such as typechecks, dimension checks, small-case state-action
  tests, block tests, normalizer progress, resource progress, and remaining
  obligations,
- status: rejected, active, promising, merged, or proved.

A score is only a search guide.  A construction is accepted only when the Lean
target and proof obligations are satisfied.
