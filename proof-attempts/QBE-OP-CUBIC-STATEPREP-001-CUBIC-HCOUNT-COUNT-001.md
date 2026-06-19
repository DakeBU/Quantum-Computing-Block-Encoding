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

## Leaf Status

`CUBIC-HCOUNT-COUNT-001` is now compiled.  It proves the pure counting part of
the Hadamard route before any full matrix or unitary theorem is attempted.

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
| `CUBIC-HCOUNT-COUNT-001` | compiled count leaf |
| `CUBIC-HCOUNT-UNITARY-001` | next semantic/unitary leaf |
| `CUBIC-HCOUNT-BLOCK-001` | blocked until count and unitary/Hadamard-sandwich leaves compile |

## Verifier Feedback

The existing finite path diagnostic
`verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-path.md`
passes for `n = 1..4`.  It constrains the same count formula but is not a
Lean certificate.

Do not rerun the stale `candidate_interface_gap` diagnostic.  Only rerun
`cubic_ver_cand_001_hcount_path_check.py` if the Lean worker changes the
threshold register size, path denominator, or accepted-path predicate.

Historical blocked-template for this leaf before it compiled:

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

## Lower Architect Addendum, 2026-06-19 17:33 JST

### Exact Source Fragment Being Translated

This task has no paper-source archive.  The source fragment is the user/task
operator equation

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

The Hadamard-counting route has already reduced the first-column clean-block
entry to the path-count equation

$$
B_n[j,0] = {|\{t : 0 \le t < N^3,\ t < j^3\}| \over N^4},
\qquad N = gridSize\ n.
$$

The active local theorem translates only the numerator:

$$
|\{t : 0 \le t < N^3,\ t < j^3\}| = j^3.
$$

The denominator and target-amplitude bridge are already represented by
`gridSize_four_mul_eq_fourth` and the compiled
`cubicAmplitude_div_conservativeNormalizer_eq`.

### Definitions Before Claims

Fix `n : Nat` and set `N = gridSize n`.  For a row
`j : Fin (gridSize n)`, the finite-index proof gives `j.val < N`.  The
threshold register has size `gridSize (3 * n)`, intended to be `N ^ 3`.  The
accepted threshold values are the elements
`t : Fin (gridSize (3 * n))` satisfying `t.val < j.val ^ 3`.

The local count claim is:

$$
\left((List.finRange (gridSize (3 * n))).filter
  (fun\ t => t.val < j.val^3)\right).length = j.val^3.
$$

### Natural-Language Proof Of The Active Local Theorem

First prove the capacity identity.  Since `gridSize m = 2^m`,
`gridSize (3 * n) = 2^(3*n)`.  The law
`2^(3*n) = (2^n)^3` gives
`gridSize (3 * n) = gridSize n ^ 3`.  The same argument with `4*n` gives
`gridSize (4 * n) = gridSize n ^ 4`.

Next prove the threshold fits inside the `3*n`-qubit register.  From
`j : Fin (gridSize n)` we have `j.val < N`, hence `j.val <= N`.  Multiplying
this inequality by `j.val` and `N` on nonnegative natural numbers, or using a
power monotonicity lemma for naturals, gives `j.val ^ 3 <= N ^ 3`.  Rewriting
`N ^ 3` by `gridSize_three_mul_eq_cube` gives
`j.val ^ 3 <= gridSize (3 * n)`.

Finally prove the filtered-list count.  Let `k = j.val ^ 3` and
`m = gridSize (3 * n)`.  The previous bound gives `k <= m`.  The list
`List.finRange m` contains each `t : Fin m` once in increasing value order.
Filtering by `t.val < k` keeps exactly the canonical elements
`0, 1, ..., k - 1`, and discards every element with value at least `k`.
Therefore the filtered list has length `k`.  No circuit semantics, ancilla
cleanup, or unitarity argument enters this leaf.

The most useful Lean route is to prove or reuse one generic helper before the
candidate-specific theorem:

```lean
theorem finRange_filter_lt_length {m k : Nat} (hk : k <= m) :
    ((List.finRange m).filter (fun t : Fin m => t.val < k)).length = k
```

Then `hadamardCountingCubic_thresholdPathCount` follows by applying this helper
with `m = gridSize (3 * n)` and `k = j.val ^ 3`, using
`hadamardCountingCubic_threshold_le_pathCapacity`.

### Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| CUBIC-TGT-001 | Rank-one operator entries for `O_n`. | none | middle/Lean target | `cubicOperator_first_column`, `cubicOperator_only_first_column` | conversion window | `python3 tools/qbe.py check` | proved |
| CUBIC-ALPHA-001 | Conservative normalizer is admissible. | CUBIC-TGT-001 | lower Lean | `cubicNormSq_le_conservativeNormalizer_sq` | proof obligations | `python3 tools/qbe.py check` | proved |
| CUBIC-HCOUNT-IFACE-001 | Hadamard-counting layout, transcript, normalizer, resource tuple, and clean-block contract bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicCleanBlockContract_pointwise_eq` | conversion window | `python3 tools/qbe.py check` | compiled interface |
| CUBIC-HCOUNT-RATIO-001 | Scaled entry identity `cubicAmplitude n j / alpha = j.val^3 / N^4`. | CUBIC-HCOUNT-IFACE-001 | lower Lean | `rat_div_cube_div_eq`, `cubicAmplitude_div_conservativeNormalizer_eq` | verifier feedback | `python3 tools/qbe.py check` | proved |
| CUBIC-HCOUNT-REJECT-REPAIR-001 | Separate nonzero-column reject signal prevents clean leakage from `c != 0`. | CUBIC-HCOUNT-IFACE-001, finite counterexample to old route | lower Lean | `hadamardCountingCubicCircuit_rejectSignalRepair`, `hadamardCountingCubicResourceTuple_n2` | repair note, verifier feedback | `python3 tools/qbe.py check` | proved dependency |
| CUBIC-HCOUNT-COUNT-001A | Path-register capacity identities for `3*n` and `4*n`. | `gridSize`, natural exponent arithmetic | lower Lean | `gridSize_three_mul_eq_cube`, `gridSize_four_mul_eq_fourth` | this addendum | `python3 tools/qbe.py check` | proved |
| CUBIC-HCOUNT-COUNT-001B | Threshold bound `j.val ^ 3 <= gridSize (3 * n)`. | CUBIC-HCOUNT-COUNT-001A, `j.isLt` | lower Lean | `hadamardCountingCubic_threshold_le_pathCapacity` | this addendum | `python3 tools/qbe.py check` | proved |
| CUBIC-HCOUNT-COUNT-001C | Filtered threshold count equals `j.val ^ 3`. | CUBIC-HCOUNT-COUNT-001B, generic `finRange` count helper | lower Lean | `hadamardCountingCubic_thresholdFilterLength`, `hadamardCountingCubic_thresholdPathCount` | this addendum | `python3 tools/qbe.py check` | proved |
| CUBIC-HCOUNT-UNITARY-001 | Repaired transcript is unitary as Hadamards plus reversible labels. | CUBIC-HCOUNT-COUNT-001, oracle-label semantics | future lower Lean | planned semantic theorem | proof obligations | `python3 tools/qbe.py check` | next symbolic bridge leaf |
| CUBIC-HCOUNT-BLOCK-001 | Clean block satisfies `hadamardCountingCubicCleanBlockContract`. | CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001, Hadamard-sandwich semantic lemma | future lower Lean | planned clean-block theorem | proof obligations | `python3 tools/qbe.py check` | blocked internal |

After the post-gate synchronization, `CUBIC-HCOUNT-COUNT-001` is compiled.
The next active leaf is `CUBIC-HCOUNT-UNITARY-001` or an equivalent
Hadamard-sandwich semantic bridge before `CUBIC-HCOUNT-BLOCK-001`.

### Intermediate Lean Lemmas In Dependency Order

1. Reuse `gridSize` from `QuantumBlockEncoding/Core.lean`, plus existing
   `gridSize_pos` and the `Fin.isLt` proof on `j`.
2. Prove `gridSize_three_mul_eq_cube (n : Nat) :
   gridSize (3 * n) = gridSize n ^ 3`.  Expected route: unfold `gridSize`,
   rewrite `Nat.pow_mul`, and normalize the numeral exponent.
3. Prove `gridSize_four_mul_eq_fourth (n : Nat) :
   gridSize (4 * n) = gridSize n ^ 4`, by the same route.
4. Prove or reuse a natural power monotonicity fact:
   if `a <= b`, then `a ^ 3 <= b ^ 3`.  If no convenient local theorem is
   available, prove this as a tiny local helper rather than expanding the full
   candidate theorem.
5. Prove `hadamardCountingCubic_threshold_le_pathCapacity
   (n : Nat) (j : Fin (gridSize n)) :
   j.val ^ 3 <= gridSize (3 * n)`, using `Nat.le_of_lt j.isLt`, the power
   monotonicity helper, and `gridSize_three_mul_eq_cube`.
6. Prove or reuse a generic list-count helper:
   `finRange_filter_lt_length {m k : Nat} (hk : k <= m)`.
   This is independent of cubic state preparation and may be placed near the
   count leaf if no shared list module exists.
7. Prove `hadamardCountingCubic_thresholdPathCount` by applying the generic
   helper with `k = j.val ^ 3` and `m = gridSize (3 * n)`.

The Lean worker should not touch `hadamardCountingCubicCircuit`,
`conservativeNormalizer`, `rankOneCleanBlockContract`, or the block theorem
while closing these lemmas.

### Failure Analysis And Routing

The current target is mathematically well shaped.  The key inequality is strict
enough because `j.val < N` implies `j.val ^ 3 < N ^ 3`; the planned theorem
only needs `<=`.  The finite path diagnostic already found no counterexample
for `n = 1..4`.

The remaining risk is a Lean-library bridge, not a scientific mismatch:
`List.finRange` over `Fin m` may not have a ready theorem for filtered lengths.
If the direct proof is awkward, route through a generic helper over
`List.range m`, then transfer to `List.finRange m` by mapping `Fin.val`.
This keeps the leaf a pure counting lemma and avoids drifting into circuit
semantics.

### Typed Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-COUNT-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true`; a focused `Tests/Basic.lean` example syntax repair was made after the shared count leaf appeared |
| `lean_build_ok` | `true`; `python3 tools/qbe.py check` passed after the proof-map sync and test repair |
| `finite_matrix_ok` | `true` for the existing finite path diagnostic, not a certificate |
| `block_entry_ok` | `true` for the path formula checked at `n = 1..4`; symbolic count leaf now compiled |
| `ancilla_cleanup_ok` | `null`; not part of this count leaf |
| `normalizer_ok` | `true`; ratio and conservative normalizer bridges are compiled |
| `unitarity_ok` | `null`; routed to `CUBIC-HCOUNT-UNITARY-001` |
| `closed_theorem_ok` | `true` for `CUBIC-HCOUNT-COUNT-001`; `false` for the clean-block/unitarity certificate |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Schedule CUBIC-HCOUNT-UNITARY-001 or the Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001.` |

## 2026-06-19 Lower Refiner Result

Reported failure being repaired:

| Field | Value |
|---|---|
| `rejected_route` | Old daggered Hadamard-counting nonzero-flag transcript from `CUBIC-VER-CAND-001:HCOUNT-SEMANTIC` |
| `error_message` | `finite_matrix_ok=false`, `block_entry_ok=false`: nonzero input columns returned to clean ancillas and leaked identity entries |
| `completed_leaf` | `CUBIC-HCOUNT-COUNT-001` after the separate reject-signal repair compiled |

Lean result:

| Declaration | Role | Status |
|---|---|---|
| `gridSize_three_mul_eq_cube` | `gridSize (3*n) = gridSize n ^ 3` path-capacity identity | compiled |
| `gridSize_four_mul_eq_fourth` | `gridSize (4*n) = gridSize n ^ 4` denominator identity | compiled |
| `hadamardCountingCubic_thresholdCountP_finRange` | reusable `List.finRange` threshold-count helper | compiled |
| `hadamardCountingCubic_thresholdFilterLength` | filter-length normal form for the threshold helper | compiled |
| `hadamardCountingCubic_threshold_le_pathCapacity` | proves `j.val ^ 3` fits in the `3*n` threshold register | compiled |
| `hadamardCountingCubic_thresholdPathCount` | closes the exact path-count leaf | compiled |

Typed feedback after rerunning `python3 tools/qbe.py check`:

| Field | Value |
|---|---|
| `leaf` | `CUBIC-HCOUNT-COUNT-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` for the finite path-count diagnostic |
| `block_entry_ok` | `true` for the path/count numerator bridge, not a full clean-block theorem |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `null` |
| `closed_theorem_ok` | `true` for this count leaf; `false` for the final block certificate |
| `error_class` | `symbolic_bridge_gap` for the remaining unitary/Hadamard-sandwich bridge |
| `next_route` | Keep this repair; schedule `CUBIC-HCOUNT-UNITARY-001` or an equivalent Hadamard-sandwich semantic bridge before `CUBIC-HCOUNT-BLOCK-001`. |
