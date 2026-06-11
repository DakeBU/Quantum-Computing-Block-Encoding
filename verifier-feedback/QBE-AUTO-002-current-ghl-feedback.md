# Verifier Feedback: QBE-AUTO-002 Current GHL Leaf

Task: `QBE-AUTO-002`

Mode: `faithfulPaper`

Scope: Guseynov--Huang--Liu 2025 one-term Robin block-encoding circuit
semantics, currently focused on the finite `n = 3` matrix-entry bridge needed
for the theorem-facing Fig. 4 route.

## Current Diagnosis

The current useful feedback layers are not hardware or timeline layers.  The
active blocker is a Lean symbolic/evaluated-semantics bridge over a finite
matrix-entry decomposition.

Typed status:

```json
{
  "task": "QBE-AUTO-002",
  "leaf": "active-uncast-entry-or-remaining-slot-3-vanish",
  "mode": "faithfulPaper",
  "source_correspondence_ok": true,
  "lean_parse_ok": true,
  "lean_build_ok": null,
  "finite_matrix_ok": true,
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": null,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove an evalWith-level entry bridge or a full-index-48 diagonal-factor lemma feeding slot-3 evaluated vanish"
}
```

`lean_build_ok` is `null` here because this packet records the intended
classification, not a fresh build run.  The latest build status must be taken
from `python3 tools/qbe.py check` and `runs/trials_summary.csv`.

## Applicable Feedback Checks

| Check | Useful now? | Reason |
|---|---:|---|
| Lean parser/build | yes | catches new proof-script or declaration failures. |
| finite `n = 3` matrix-entry check | yes | current route is finite matrix semantics before general theorem reuse. |
| support/vanish/cancellation by backend slot | yes | remaining slots `3` through `6` must be evaluated or cancelled, not only support-noted. |
| raw `Coeff` constructor equality | no | previous route showed this is not the right semantic equality level. |
| evaluated `evalWith` bridge | yes | current route should connect evaluated gate products to the named Lean entry theorem. |
| output distribution test | no | block encoding requires operator entry equality, not only sampled output behavior. |
| timeline/pulse/hardware scheduling | no | GHL current blocker is not OpenQASM timing or hardware compilation. |
| reward score/pass@k | advisory only | can rank lower proof routes, but cannot close a theorem. |

## Lower-Agent Split

Natural-language proof architect:

- classify the exact source branch and the active Lean leaf;
- produce a dependency table for slot `3` or the active uncast entry;
- identify whether the missing statement is support, finite-eval, or symbolic
  bridge.

Lean implementation worker:

- edit only the narrow target file and one active leaf;
- prefer either `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`
  or a full-index `48` diagonal-factor feeder;
- run `python3 tools/qbe.py check` after Lean edits;
- log typed feedback with `trial-log --feedback-field ...`.

Reviewer:

- reject continued work on the raw `Coeff` constructor equality route as theorem
  closure;
- reject any handoff that does not classify the failure into one of the typed
  feedback classes;
- reject promotions of external primitives, oracle contracts, normalizers, or
  final block-encoding theorem status unless a named Lean declaration closes the
  exact target.

