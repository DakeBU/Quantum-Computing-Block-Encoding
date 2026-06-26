# Failure Memory

This directory stores reusable failure packets, not raw logs.  A packet should
be small enough for the next upper/middle/reviewer pass to retrieve without
replaying an entire run.

Use it when a failure repeats or when a reviewer identifies a route-level
mistake.  Recommended fields:

```json
{
  "task": "QBE-...",
  "leaf": "clean-entry-bridge",
  "trace_scope": "fine",
  "failure_class": "symbolic_bridge_gap",
  "local_symptom": "raw constructor equality fails",
  "root_cause": "semantic evalWith equality is the correct statement",
  "rejected_route": "prove raw Coeff matrix equality",
  "repair_route": "prove evalWith-level entry equality",
  "reusable_lesson": "separate symbolic syntax from evaluated semantics",
  "mathlib_queries": ["Matrix.mul_apply"],
  "promote_to_card": false
}
```

Fine-grained packets repair one proof leaf.  Coarse-grained packets repair the
route, theorem statement, access model, source contract, or harness allocation.
Reviewer agents should reject lower work that repeats a known rejected route
without explaining why the previous failure no longer applies.
