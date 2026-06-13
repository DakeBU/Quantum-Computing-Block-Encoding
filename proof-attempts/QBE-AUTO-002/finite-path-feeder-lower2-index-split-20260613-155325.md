# 2026-06-13 Lower2 Attempt: Finite Path Feeder Index Split

Task: `QBE-AUTO-002`  
Run: `20260613-155325-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`  
Leaf: `finite_path_feeder`

## Closed Lean Declaration

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3
```

This compiled guard records the current strict-feeder index calibration:

- the active `evalGateMatrices` entry is the full-basis entry `[0,0]`;
- the selected backend contribution is focused sparse slot `2`, whose full
  basis index is `32`;
- the selected contribution is the seven-gate diagonal entry at `[32,32]`
  multiplied by the existing projection-amplitude factor.

This is not a proof of:

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

and it does not prove:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

## Failed Route

The preferred strict feeder remains blocked.  The current compiled path data
does not yet contain a focused evaluated path-normal-form theorem connecting
the active signal-zero entry `[0,0]` to the selected slot-`2` backend
contribution at `[32,32]`.

I did not use the diagnostic declarations
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` or
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as closure.  Reusing
that route would be a diagnostic H-free fold route with the known
slot-`0`/slot-`2` shape risk, not the accepted strict feeder.

## Next Route

Lower1/lower3 should finish the finite path calibration requested by
`finite-path-feeder-middle-packet-20260613-1600.md`: map the path names to
existing declarations and determine whether `R_y` and `O_f` are unique-column
or two-path-with-tail-kill.  Lower2 can then prove one selected-column,
tail-kill, or focused-normal-form lemma feeding the strict feeder.

## Verifier Feedback

```text
leaf=finite_path_feeder
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=index_split_guard_compiled
block_entry_ok=false
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=prove the focused evaluated path normal form for the active [0,0] entry, or first complete lower1/lower3 path-support calibration
```
