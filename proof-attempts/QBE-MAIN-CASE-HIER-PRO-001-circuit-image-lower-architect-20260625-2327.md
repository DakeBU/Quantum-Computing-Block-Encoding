# Lower Proof Packet: QBE-MAIN-CASE-HIER-PRO-001

Active leaf: `MAINCASE-PRO-CIRCUIT-IMAGE-001`

Role: lower natural-language proof architect

Timestamp: `2026-06-25 23:27 JST`

## Source Fragment

No local paper-source archive was detected for this task.  The source fragment
is the external Pro construction packet
`task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md`.

The fixed target is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The required block contract is

$$
(\langle 0|_a \otimes I) U (|0\rangle_a \otimes I) = E_1.
$$

The Pro transcript to translate is

```text
CCX012; CX21; CX20; X2
```

with reduced bits `0 = tau`, `1 = T`, `2 = a`, and full Lean basis

```text
fullIndex = 8 * a + 4 * T + 2 * tau + S.
```

The corresponding task-local circuit metadata already exists as
`mainCaseProCircuit` and `mainCaseProSchedule` in
`QuantumBlockEncoding/MainCase.lean`.  The compiled finite-permutation clean
block uses `mainCaseProCandidateImage`, but no Lean theorem yet proves that
the Pro transcript realizes that image.

## Definitions For The Local Proof

Let `a`, `T`, `tau`, and `S` be bits.  Let the reduced active index be
`4 * a + 2 * T + tau`, matching the old read-only route memory
`OptimalControl.reducedOfFull`.

Define the Pro transcript image `p_pro` by applying the four reduced gates in
order:

1. `CCX012` changes `a` to `a xor (T and tau)`.
2. `CX21` changes `T` to `T xor a1`, where `a1 = a xor (T and tau)`.
3. `CX20` changes `tau` to `tau xor a1`.
4. `X2` changes `a1` to `a1 xor 1`.

Thus the closed-form branch map is

```text
a'   = a xor (T and tau) xor 1
T'   = T xor a xor (T and tau)
tau' = tau xor a xor (T and tau)
S'   = S.
```

The full lifted image is

```text
mainCaseProCircuitImage(8*a + 4*T + 2*tau + S)
  = 8*a' + 4*T' + 2*tau' + S.
```

This is the image induced by the advertised transcript.  It is not identical
to the current table `mainCaseProCandidateImage` on all full basis states.

## Branch Table

| Column | Input `(a,T,tau,S)` | Pro transcript image | Current candidate image | Status |
|---:|---|---:|---:|---|
| `0` | `(0,0,0,0)` | `8` | `8` | match |
| `1` | `(0,0,0,1)` | `9` | `9` | match |
| `2` | `(0,0,1,0)` | `10` | `10` | match |
| `3` | `(0,0,1,1)` | `11` | `11` | match |
| `4` | `(0,1,0,0)` | `12` | `12` | match |
| `5` | `(0,1,0,1)` | `13` | `13` | match |
| `6` | `(0,1,1,0)` | `0` | `0` | match |
| `7` | `(0,1,1,1)` | `1` | `1` | match |
| `8` | `(1,0,0,0)` | `6` | `2` | mismatch |
| `9` | `(1,0,0,1)` | `7` | `3` | mismatch |
| `10` | `(1,0,1,0)` | `4` | `4` | match |
| `11` | `(1,0,1,1)` | `5` | `5` | match |
| `12` | `(1,1,0,0)` | `2` | `6` | mismatch |
| `13` | `(1,1,0,1)` | `3` | `7` | mismatch |
| `14` | `(1,1,1,0)` | `14` | `14` | match |
| `15` | `(1,1,1,1)` | `15` | `15` | match |

The mismatch set is exactly `{8, 9, 12, 13}`.  These are dirty input columns
with `a = 1`.  All clean input columns `0` through `7` match the current
candidate image.

## Natural-Language Proof

The full equality theorem

```lean
theorem mainCaseProCircuitImage_eq_candidate :
    forall x : Fin 16,
      mainCaseProCircuitImage x = mainCaseProCandidateImage x
```

is mathematically false.  Column `8` is a counterexample: the Pro transcript
sends `8` to `6`, while `mainCaseProCandidateImage` sends `8` to `2`.

The correct local theorem for the Pro transcript is a clean-entry theorem, not
full equality with the arbitrary finite completion already in
`mainCaseProCandidateImage`.

For a clean input column, `a = 0`.  If `(T,tau) = (1,1)`, then the Toffoli
sets `a1 = 1`, the two CNOTs change `(T,tau)` to `(0,0)`, and the final `X`
returns the signal to `a' = 0`.  The passive bit `S` is unchanged.  Therefore

```text
(0,1,1,S) -> (0,0,0,S).
```

This gives the two nonzero clean-block entries

```text
6 -> 0
7 -> 1.
```

If the clean input column has `(T,tau) != (1,1)`, then the Toffoli leaves
`a1 = 0`, the two CNOTs do not change `T` or `tau`, and the final `X` sends
the output to the dirty signal branch `a' = 1`.  No clean output row can be
equal to that image.  Hence every other clean input column contributes zero to
the clean block.

For every passive bit `S`, the Pro transcript preserves `S`.  The clean block
therefore has entry `1` exactly from source `(T,tau,S) = (1,1,S)` to target
`(0,0,S)` and entry `0` elsewhere.  This is exactly
`mainCaseProTarget`, so the Pro transcript image is a valid completion for the
same target operator even though it is not the same full permutation as
`mainCaseProCandidateImage`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-CIRCUIT-FORMULA-001` | Define the task-local full image induced by `CCX012; CX21; CX20; X2` under `S=0`, `tau=1`, `T=2`, `signal=3`. | Pro packet, `mainCaseProCircuit`, full index convention | lower 2 | suggested `mainCaseProCircuitImage` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `MAINCASE-PRO-CIRCUIT-MISMATCH-001` | Prove or record that `mainCaseProCircuitImage` differs from `mainCaseProCandidateImage` on dirty columns `{8,9,12,13}`. | `MAINCASE-PRO-CIRCUIT-FORMULA-001`, `mainCaseProCandidateImage` | lower 2/lower 3 | suggested `mainCaseProCircuitImage_ne_candidate`, plus four point lemmas | this packet | `python3 tools/qbe.py check` | active diagnostic |
| `MAINCASE-PRO-CIRCUIT-PERM-001` | Prove the transcript image is a finite permutation. | `MAINCASE-PRO-CIRCUIT-FORMULA-001` | lower 2 | suggested `mainCaseProCircuitImage_permutation_certificate` | this packet | `python3 tools/qbe.py check` | open |
| `MAINCASE-PRO-CIRCUIT-CLEANENTRY-001` | Prove the clean-entry predicate for the transcript image equals `mainCaseProTarget`. | `MAINCASE-PRO-CIRCUIT-FORMULA-001`, `mainCaseProTarget`, `mainCaseProCleanEmbed` | lower 2 | suggested `mainCaseProCircuitImage_cleanEntry` | this packet | `python3 tools/qbe.py check` | open |
| `MAINCASE-PRO-CIRCUIT-BLOCK-001` | Build an exact clean-block certificate for the transcript image. | `MAINCASE-PRO-CIRCUIT-PERM-001`, `MAINCASE-PRO-CIRCUIT-CLEANENTRY-001` | lower 2/middle | suggested `mainCaseProCircuitExactCleanBlock_correct`, `mainCaseProCircuit_blockProjection` | conversion window | `python3 tools/qbe.py check` | open |
| `MAINCASE-PRO-CANDIDATE-SPLIT-001` | Keep `MAINCASE-PRO-PERM-001` as the arbitrary finite completion and add a gate-derived Pro candidate for circuit/resource claims. | `MAINCASE-PRO-CIRCUIT-BLOCK-001`, `mainCaseProHighLevelResource`, `mainCaseProCircuit`, `mainCaseProSchedule` | middle/lower 2 | suggested `mainCaseProCircuitCandidate`, `mainCaseProCircuitVerified` | proof-obligation ledger | `python3 tools/qbe.py check`; then `lake build && lake build Tests` | open |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Shared rational-orthogonality bridge for permutation matrices. | accepted finite permutation image for the selected semantic tier | refiner | `mainCaseProRationalOrthogonalBridgeObligation` remains open | older lower packet | `python3 tools/qbe.py check` | queued after split |

The next active Lean leaf is `MAINCASE-PRO-CIRCUIT-FORMULA-001` together with
`MAINCASE-PRO-CIRCUIT-MISMATCH-001`.  The Lean worker should not attempt the
false theorem `mainCaseProCircuitImage_eq_candidate`.

## Intermediate Lean Lemmas

1. `mainCaseProCircuitReducedImage`

   Define the reduced three-bit image for the transcript.  Reuse the existing
   route memory from `OptimalControl.proEqTransferImage`, `redCCX012`,
   `redCX21`, `redCX20`, `redX2`, and `proEqTransferGateImages_eval` only as
   read-only guidance.  Do not import old `OptimalControl` certificates as
   proof for this isolated task.

2. `mainCaseProCircuitImage`

   Lift the reduced image over passive `S`, using the full index convention
   already documented for `mainCaseProCandidateImage`.

3. `mainCaseProCircuitImage_dirty_mismatch_8`,
   `mainCaseProCircuitImage_dirty_mismatch_9`,
   `mainCaseProCircuitImage_dirty_mismatch_12`, and
   `mainCaseProCircuitImage_dirty_mismatch_13`

   These point lemmas should show that the full equality theorem against
   `mainCaseProCandidateImage` is false.  They are small `native_decide`
   checks after the table is defined.

4. `mainCaseProCircuitImage_clean_columns`

   Suggested statement:

   ```lean
   theorem mainCaseProCircuitImage_clean_columns :
       forall x : Fin 16,
         x.val < 8 ->
           mainCaseProCircuitImage x = mainCaseProCandidateImage x
   ```

   This records why the already compiled clean-block proof shape still applies
   to the Pro transcript.

5. `mainCaseProCircuitImage_injective` and
   `mainCaseProCircuitImage_surjective`

   Prove the transcript image is a bijection.  A table-style preimage, or a
   pointwise `native_decide` proof, is enough for the 16-state instance.

6. `mainCaseProCircuitImage_cleanEntry`

   Suggested statement:

   ```lean
   theorem mainCaseProCircuitImage_cleanEntry :
       forall row col : Fin 8,
         (if mainCaseProCleanEmbed row =
               mainCaseProCircuitImage (mainCaseProCleanEmbed col) then
             1
           else
             0) =
           mainCaseProTarget row col
   ```

   Reuse `mainCaseProCleanEmbed`,
   `BlockEncodingClassics.productIndex`, `mainCaseProTarget`, and
   `mainCaseProSystemIndex`.

7. `mainCaseProCircuit_blockProjection`

   Build the transcript-image matrix with `BlockEncodingClassics.permMatrix`
   and prove `mainCaseProBlockProjection` for it, following
   `mainCaseProCandidate_blockProjection`.

8. `mainCaseProCircuitCandidate_cost`

   Reuse `mainCaseProHighLevelSeedCost_*` and `mainCaseProHighLevelResource`.
   The resource tuple remains `(gateCount=4, depth=4, auxiliaryQubits=1,
   oracleCalls=0)` at the logical `{X,CNOT,Toffoli}` tier.

## Failure Analysis

The target operator is not mathematically wrong.  The Pro transcript also has
the correct clean block.  The failed statement is only the stronger full-image
equality between the transcript image and the currently compiled arbitrary
completion `mainCaseProCandidateImage`.

This is a `source_translation_gap` at the circuit/resource layer.  The fix is
not to change `mainCaseProTarget`, `mainCaseProSignalIndex`, alpha, or the
clean-block statement.  The fix is to split the finite-permutation completion
from the gate-derived Pro transcript candidate, then prove the clean-block and
permutation certificates for the gate-derived image.

`MAINCASE-PRO-ORTHO-BRIDGE-001` should remain queued.  It can be applied after
the selected semantic tier has a task-local image, block proof, and resource
record that agree with each other.

## Typed Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-CIRCUIT-IMAGE-001` |
| `source_correspondence_ok` | `false` for full equality with `mainCaseProCandidateImage`; `true` for clean-input branch behavior |
| `lean_parse_ok` | `true` after final project gate for this Markdown-only attempt |
| `lean_build_ok` | `true` after final project gate for this Markdown-only attempt |
| `finite_matrix_ok` | `false` for all-16-state equality; `true` for clean columns `0..7` |
| `block_entry_ok` | `true` by the branch proof above; Lean theorem still open for the transcript image |
| `ancilla_cleanup_ok` | `true` on the selected clean source branch; non-source clean inputs intentionally leave the clean block |
| `normalizer_ok` | `true`, alpha remains `1` |
| `unitarity_ok` | `true` as a finite permutation route, but the transcript image certificate is not yet Lean-named |
| `resource_score` | `(4,4,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `4` |
| `depth` | `4` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `false` |
| `error_class` | `source_translation_gap` |
| `next_route` | `Define task-local mainCaseProCircuitImage, prove the four dirty-column mismatches, then prove cleanEntry and package a separate gate-derived candidate.` |
