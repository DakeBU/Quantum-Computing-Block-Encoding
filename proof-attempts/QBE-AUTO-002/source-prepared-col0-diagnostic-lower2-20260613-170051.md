# 2026-06-13 Lower2 Attempt: Source-Prepared Column-0 Diagnostic Guard

Task: `QBE-AUTO-002`  
Run: `20260613-163714-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf: `active_eval_gate_matrices_column0_bridge`

## Closed Lean Declaration

```lean
oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
```

The theorem proves the evaluated active `[0,0]` entry of
`evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))`
equals the evaluated explicit
`oneTermRobinGamma3BoundarySevenGateMatrix_n3[0,0]` entry.

Proof route:

- unfold the seven active gate placeholders at `evalWith` level only;
- prove the active folded entry vanishes by finite support through
  `U_indic`, `O_DT^S`, `R_y`, `O_D^BS`, `O_f`, `SWAP`, and
  `(O_D^BS)^dagger`;
- use the existing compiled theorem
  `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` for the explicit
  seven-gate side.

This is diagnostic only.  It does not use
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`, does not
prove `ActiveEval(env) = selectedSlotContribution(env)`, and does not promote
oracle, `H_W`, `R_y`, product, LCU, block, final-extraction, or normalizer
flags.

## Remaining Lean Goal

The source-faithful theorem route still needs the source-prepared sparse-clean
field under explicit
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
The strict H-free selected-slot feeder remains retired as
`shape_or_register_gap`.

## Gate

Passed:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

Known diagnostic `sorry` warnings remain in `RobinMatrix.lean` at the
pre-existing raw H-free diagnostic declarations.
