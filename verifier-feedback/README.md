# Verifier Feedback

This directory stores typed verifier-feedback packets for QBE lower-agent
attempts.  The pattern is inspired by non-Lean quantum-circuit benchmarks such
as QASM-Eval and Qiskit QuantumKatas, but QBE uses these diagnostics only as
pre-Lean search guidance.  Lean theorem closure remains the acceptance gate.

Use this when a lower attempt fails or partially succeeds.  Record small,
machine-readable fields instead of only prose:

```json
{
  "task": "QBE-AUTO-002",
  "leaf": "slot-three-branch-vanish",
  "mode": "faithfulPaper",
  "source_correspondence_ok": true,
  "lean_parse_ok": true,
  "lean_build_ok": false,
  "finite_matrix_ok": true,
  "block_entry_ok": false,
  "ancilla_cleanup_ok": null,
  "normalizer_ok": true,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "prove evalWith-level entry bridge for full index 48"
}
```

Suggested classes:

- `source_translation_gap`
- `shape_or_register_gap`
- `finite_matrix_counterexample`
- `symbolic_bridge_gap`
- `lean_tactic_gap`
- `external_contract_gap`
- `stale_leaf`
- `invalid_route`

Scores and booleans are diagnostics.  They must not be promoted into
paper-theorem status unless a named Lean declaration closes the exact target.
