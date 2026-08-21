# Vandaele / Gidney Gate-Level Bridge — Evidence Map

- `source`: Vivien Vandaele, *Asymptotically Optimal Quantum Circuits for Comparators and Incrementers* (2026), with the Gidney incrementer used in the Lemma-7 / Figure-9 construction
- `branch_status`: `obligation` until the focused Vandaele Lean admission report is green
- `purpose`: separate the now-real arbitrary-width Gidney gate proof from the still-open source-specific Figure-8/Figure-9 low-depth decomposition

## What now has an actual gate list on the proof branch

`QuantumBlockEncoding/GidneyZeroedSourceProgram.lean` defines one arbitrary-width zeroed-workspace incrementer directly over ASPBE's reversible `{X,CX,CCX}` IR.  For `c` workspace bits it acts on `c+2` target bits and uses the nested chronological core

```text
compute carry_j
  -> higher carry core
  -> consume carry_j on target j+2
  -> uncompute carry_j
```

followed by `CX(x0 -> x1); X(x0)`.

The same source program has two exactly equal presentations:

- ascending carry computation + descending consume/uncompute sweep;
- nested compute/use/uncompute recursion used by the Lean induction.

The logical source size is exactly `3c+2 = 3n-4` for `n=c+2` target bits.

## Proof-bearing semantic chain now present

The following branch roots are intended source-gate evidence, subject to Lean admission:

1. `ReversibleProgramInverse.*` — reverse chronological gate lists implement inverse permutations.
2. `ReversibleProgramSupport.*` — untouched wires are preserved; gate action depends only on touched wires.
3. `PrimitiveBasisLENumeric.primitiveBasisLEEquiv_value_eq_sum` — arbitrary-width little-endian numeric expansion.
4. `BinaryCarryTelescoping.increment_weighted_sum_nat` — subtraction-free binary carry telescoping.
5. `GidneyZeroedWorkspaceRestoration.carryLayer_restores_current_workspace` — one dirty compute/use/uncompute layer restores its workspace bit.
6. `GidneyZeroedWorkspaceRestorationGlobal.runSource_restores_workspace` — the complete source circuit restores **arbitrary** workspace contents at every width.
7. `GidneyZeroedCarryCompute.computeCarryProgram_clean_semantics` — on zero workspace the ascending ladder computes the canonical prefix carry chain.
8. `GidneyZeroedDescendingAction.fullDescendingSweep_target_action` — the descending sweep consumes each stored carry exactly once on its high target bit.
9. `GidneyZeroedCleanTargetAction.cleanSourceResult_target_bit` — every clean target output bit equals the canonical binary increment output bit.
10. `GidneyZeroedSourceCorrectness.runSource_clean_correct` — the actual gate list performs `x -> x+1 mod 2^n` on the clean branch.
11. `GidneyZeroedSourceStrongPromise.strongPromiseSpec` — the same actual gate list is a strong promise incrementer: arbitrary promise/workspace is restored, while the zero-promise branch performs exact modular increment.
12. `GidneyZeroedScheduledFamily.family` / `strongPromiseRefinement` — intended direct inhabitation of the repository's existing proof-bearing Gidney family interface.

A focused branch workflow, `vandaele-source-admission-report.yml`, records `lake build` results into `_out/vandaele-source-smoke-report.md`; these roots must not be promoted to the formal registry until that report is green.

## Source-fidelity boundary: what this does **not** yet prove

The gate-level family above is a canonical zeroed-ancilla Gidney-style realization with the same target/workspace semantics and the expected linear logical size.  ASPBE has **not yet proved that this exact chronological gate ordering is identical to the particular drawing/order used in Vandaele Figure 8(b)**.

That distinction matters because Vandaele Figure 9 obtains logarithmic depth by a source-specific four-slice replacement:

```text
slice 1 (CCX ladder)
-> slice 2 (independent layer)
-> slice 3 (uncompute ladder)
-> slice 4 (independent layer),
```

and leaves slices 1/3 uncontrolled while controlling only 2/4 via the controlled-conjugation identity.  The current branch already formalizes the abstract/source-facing Figure-9 theorem and its strong-promise transport, but a concrete `FourSliceDecomposition` of the **source drawing** with admitted low-depth Lemma-4/Lemma-5 implementations remains open.

Therefore do not describe the current gate family as a completed Figure-9 reproduction or as an `O(log n)`-depth implementation.

## Resource evidence currently safe to state on the branch

For target width `n=c+2`, the serial source family has intended exact logical counts from the same gate list:

\[
N_X=1,
\qquad
N_{CX}=c+1=n-1,
\qquad
N_{CCX}=2c=2n-4,
\]

hence total logical gates `3n-4`.

These counts are a **serial/source baseline**.  Vandaele's logarithmic-depth result comes from the Lemma-4/Lemma-5/Figure-9 replacements, not from treating this serial schedule as already optimal.

## How this connects to Lemma 7 and Theorem 4

The branch already has the surrounding formal graph:

```text
actual Gidney gate semantics
  -> strong promise refinement
  -> predicate-controlled / promise-register embedding
  -> Eq. (36)-(38) resource and dirty-ancilla machinery
  -> Lemma 7 contract/resource closure
  -> Lemma 8 block schedule / square-root resource composition
  -> Theorem 4 recurrences
  -> conditional gate/depth/ancilla optimality closure.
```

The next source-specific bottleneck is no longer "what should increment mean?".  It is:

1. admit the new gate-level Gidney source chain in Lean;
2. encode/verify the exact Figure-8/Figure-9 four-slice source ordering;
3. instantiate the admitted Lemma-4 ladder and Lemma-5 controlled independent-layer implementations in those slices;
4. prove the resulting schedule has the local `O(n)` gate / `O(log n)` depth bounds required by Lemma 7;
5. propagate those bounds through Lemma 8 / Theorem 4 and only then promote the source `Theta` / optimality statements.
