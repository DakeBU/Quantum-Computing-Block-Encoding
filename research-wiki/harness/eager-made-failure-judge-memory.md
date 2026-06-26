# EAGER/MADE-Inspired Failure and Judge Memory

This card is for upper, middle, and reviewer agents.  It records useful
patterns from recent agent-system papers, but ABEIS keeps Lean theorem closure
as the only hard certificate.

## Local Sources

- `outer_papers/automation_systems/failure_judge_systems/2603.21522/EAGER_reasoning_trace_failure_management.pdf`
- `outer_papers/automation_systems/failure_judge_systems/2511.19489/MADE_evolution_without_oracle.pdf`

No public code repository was found during the local inspection for these two
papers.  If a repository later appears, clone it under
`outer_repos/automation_systems/` and add a retrieval card.

## ABEIS Counterpart Design

### Reasoning-Trace Failure Memory

Do not store only long dialogue logs.  Convert repeated failures into typed
packets:

```json
{
  "task": "QBE-...",
  "leaf": "clean-entry-bridge",
  "trace_scope": "fine",
  "failure_class": "symbolic_bridge_gap",
  "local_symptom": "raw syntax equality does not rewrite",
  "root_cause": "the intended theorem is evaluated semantic equality",
  "rejected_route": "prove raw constructor equality",
  "repair_route": "prove evalWith-level entry equality",
  "reusable_lesson": "separate circuit syntax from evaluated semantics",
  "mathlib_queries": ["Matrix.mul_apply"],
  "promote_to_card": false
}
```

Use `trace_scope = fine` when only one proof leaf is affected.  Use
`trace_scope = coarse` when the target statement, access model, source
correspondence, external contract, or harness allocation is wrong.

### Decomposed Judge Vector

The reviewer should not issue a single vague score.  For each candidate, route,
or proof attempt, judge independent requirements:

| Requirement | Hard or soft? | Meaning |
| --- | --- | --- |
| `target_contract` | hard | same operator, block projector, and semantic tier |
| `unitarity` | hard for exact candidate | stated `U_A` is unitary or has a precise contract |
| `clean_block` | hard | clean block equals/approximates the target |
| `normalizer_error` | hard | `alpha` and epsilon match the theorem |
| `resource_tuple` | soft until proved | gates, depth, ancillas, oracle calls |
| `proof_reuse` | soft | route uses reusable textbook/Mathlib leaves |
| `source_faithfulness` | hard in paper mode | no hidden assumptions or circuit drift |
| `exportability` | soft | can produce human proof and Qiskit/QASM export |

Only Lean-closed hard requirements can promote a candidate into the certified
population.  Soft scores guide mutation, recombination, and scheduling.

## Agent Rules

1. Before retrying a repeated proof, retrieve `failure-memory/` and
   `verifier-feedback/<task-id>/`.
2. If a route repeats a rejected route, reviewer must ask what changed.
3. If a failure is coarse, upper/middle must repair the statement or route
   before lower agents continue.
4. If a failure is fine, assign exactly one smaller proof leaf.
5. If the route needs a generic algebra/matrix lemma, search Mathlib before
   adding a local theorem.

## Why This Matters for Block Encodings

Many ABEIS failures are not "bad tactics".  They are route mistakes:

- trying to prove syntax-level equality for circuit expressions instead of
  semantic matrix equality;
- forgetting workspace cleanup;
- treating a QSVT theorem as proved when it is only an external contract;
- using a finite simulator pass as if it were a symbolic family proof;
- sending lower agents to prove a high theorem while the active leaf is still
  undefined.

Typed failure packets make those mistakes searchable and prevent future agents
from spending another full cycle on the same wrong proof shape.
