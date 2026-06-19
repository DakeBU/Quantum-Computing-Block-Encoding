# CUBIC-HCOUNT-COUNT-001 Middle Packet

Task: `QBE-OP-CUBIC-STATEPREP-001`
Mode: exploratory construction
Updated: `2026-06-19 17:25:22 JST`

## Source Anchor

There is no paper-source archive for this task.  The source is the user/task
operator target

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

The Hadamard-counting candidate keeps
`alpha = conservativeNormalizer n = gridSize n`.  Its clean first-column entry
should be

$$
B_n[j,0] = {j^3 \over (gridSize\, n)^4}.
$$

The ratio bridge from this entry to `cubicAmplitude n j / alpha` is already
compiled as `cubicAmplitude_div_conservativeNormalizer_eq`.

## Active Leaf

The next Lean leaf is `CUBIC-HCOUNT-COUNT-001`.  It proves the pure counting
part of the Hadamard route before any full matrix or unitary theorem is
attempted.

For fixed `n : Nat`, write `N = gridSize n`.  The path register is split into
`r : Fin N` and `t : Fin (gridSize (3 * n))`.  For a fixed output row
`j : Fin N`, the accepted threshold values are those satisfying
`t.val < j.val ^ 3`.  The target count is exactly `j.val ^ 3`.

## Lean Packet

Target file: `QuantumBlockEncoding/CubicStatePreparation.lean`.

Allowed write scope:

- new helper declarations named `gridSize_three_mul_eq_cube`,
  `gridSize_four_mul_eq_fourth`, or beginning with
  `hadamardCountingCubic_threshold`;
- focused tests in `Tests/Basic.lean` that mention only those new helpers.

Forbidden changes:

- do not edit `cubicOperator`, `gridPoint`, `cubicAmplitude`,
  `rankOneCleanBlockContract`, the Hadamard-counting circuit transcript,
  normalizer, resource tuple, ratio lemma, or reject-repair theorem;
- do not introduce a normalized state-preparation target;
- do not package a block-encoding certificate.

Planned declarations:

```lean
theorem gridSize_three_mul_eq_cube (n : Nat) :
    gridSize (3 * n) = gridSize n ^ 3 := by
  ...

theorem gridSize_four_mul_eq_fourth (n : Nat) :
    gridSize (4 * n) = gridSize n ^ 4 := by
  ...

theorem hadamardCountingCubic_threshold_le_pathCapacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 <= gridSize (3 * n) := by
  ...

theorem hadamardCountingCubic_thresholdPathCount
    (n : Nat) (j : Fin (gridSize n)) :
    ((List.finRange (gridSize (3 * n))).filter
        (fun t => t.val < j.val ^ 3)).length = j.val ^ 3 := by
  ...
```

The lower worker may split off a smaller helper if Lean needs it, but the
mathematical statement should stay on this count leaf.

Required gate after edits:

```bash
python3 tools/qbe.py check
```

## Dependency Map

| Node | Status for this leaf |
|---|---|
| `CUBIC-TGT-001` | compiled target operator entries |
| `CUBIC-ALPHA-001` | compiled conservative normalizer bound |
| `CUBIC-HCOUNT-IFACE-001` | compiled layout, transcript, normalizer, resource tuple, and contract bridge |
| `CUBIC-HCOUNT-RATIO-001` | compiled as `cubicAmplitude_div_conservativeNormalizer_eq` |
| `CUBIC-HCOUNT-REJECT-REPAIR-001` | compiled as `hadamardCountingCubicCircuit_rejectSignalRepair`; finite semantic check passes for `n = 1, 2` |
| `CUBIC-HCOUNT-COUNT-001` | active leaf |
| `CUBIC-HCOUNT-UNITARY-001` | later semantic/unitary leaf |
| `CUBIC-HCOUNT-BLOCK-001` | blocked until count and unitary/Hadamard-sandwich leaves compile |

## Verifier Feedback

The existing finite path diagnostic
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-path.md`
passes for `n = 1..4`.  It constrains the same count formula but is not a
Lean certificate.

Do not rerun the stale `candidate_interface_gap` diagnostic.  Only rerun
`cubic_ver_cand_001_hcount_path_check.py` if the Lean worker changes the
threshold register size, path denominator, or accepted-path predicate.

If blocked, log:

```bash
python3 tools/qbe.py trial-log --task QBE-OP-CUBIC-STATEPREP-001 \
  --role lower --kind attempt --status failed \
  --artifact proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-COUNT-001.md \
  --feedback-field leaf=CUBIC-HCOUNT-COUNT-001 \
  --feedback-field source_correspondence_ok=true \
  --feedback-field lean_parse_ok=<bool> \
  --feedback-field lean_build_ok=<bool> \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=true \
  --feedback-field ancilla_cleanup_ok=null \
  --feedback-field normalizer_ok=true \
  --feedback-field unitarity_ok=null \
  --feedback-field closed_theorem_ok=false \
  --feedback-field error_class=<symbolic_bridge_gap|lean_tactic_gap> \
  --feedback-field next_route="<one narrow count/helper repair>"
```

## Next Route

After `CUBIC-HCOUNT-COUNT-001` compiles, schedule `CUBIC-HCOUNT-UNITARY-001` or
a Hadamard-sandwich semantic bridge.  Do not jump directly to
`CUBIC-HCOUNT-BLOCK-001`.
