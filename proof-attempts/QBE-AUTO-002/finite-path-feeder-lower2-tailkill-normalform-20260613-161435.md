# 2026-06-13 Lower2 Attempt: Active Column-0 Tail-Kill Normal Form

Task: `QBE-AUTO-002`  
Run: `20260613-161435-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf: `finite_path_feeder`

## Closed Lean Declaration

```lean
oneTermRobinGamma3BoundaryActiveColumn0TailKillNormalForm_n3
```

The theorem packages the existing evaluated two-path expansion for the explicit
seven-gate `[0,0]` entry:

- the active column-`0` path has two `R_y` branches with factors
  `boundary_cos_half_0_0` and `boundary_sin_half_0_0`;
- the suffix sends those branches through `O_f[12,96]` and `O_f[12,97]`;
- both function-oracle entries are zero in the focused finite witness;
- therefore the explicit seven-gate `[0,0]` entry evaluates to zero;
- if a future proof supplies
  `ActiveEval(env) = ExplicitSevenGate[0,0](env)`, then `ActiveEval(env) = 0`.

This is a focused normal-form/tail-kill lemma.  It does not prove
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`, does not use
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`, and does
not promote oracle, `H_W`, `R_y`, product, LCU, block, final-extraction, or
normalizer flags.

## Remaining Lean Goal

The next narrow Lean bridge is still:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySevenGateMatrix_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

It should be proved at `evalWith` level or by direct support for the exact
`evalGateMatrices` fold shape, not by the diagnostic raw `Coeff` equality.

## Gate

Passed:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

The only warnings are the pre-existing diagnostic `sorry` declarations now at
`QuantumBlockEncoding/RobinMatrix.lean:24436` and
`QuantumBlockEncoding/RobinMatrix.lean:24467`.

## Typed Feedback

```text
leaf=finite_path_feeder
source_correspondence_ok=true_for_active_column0_tail_kill; false_for_strict_hfree_slot2_feeder
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true_for_explicit_seven_gate_column0_tail
block_entry_ok=false
ancilla_cleanup_ok=null
normalizer_ok=null
closed_theorem_ok=false_for_strict_feeder
error_class=shape_or_register_gap
next_route=prove evalWith-level bridge from evalGateMatrices active [0,0] to explicit sevenGateMatrix [0,0], then use the tail-kill normal form only as a diagnostic unless middle retargets the selected-slot feeder
```
