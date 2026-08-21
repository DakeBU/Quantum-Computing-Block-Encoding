# Vandaele source Lean admission report

- commit: `33ab98a592d45db2a9fb7919d8a5f8dfadad842e`
- workflow: `vandaele-source-admission-report.yml`
- policy: each top-level spine is built by Lean; traced upstream dependencies are compiled transitively.

## PASS `QuantumBlockEncoding.PromiseGateUnitaryMux`

## PASS `QuantumBlockEncoding.PromiseGatePermutationMatrixBridge`

## FAIL `QuantumBlockEncoding.VandaeleNaiveLadderFiniteChecks`

```text
✔ [3295/3322] Built QuantumBlockEncoding.PrimitiveCircuit (4.3s)
✔ [3296/3322] Built QuantumBlockEncoding.Robin.ComplexLCUProjection (5.8s)
✔ [3297/3322] Built QuantumBlockEncoding.GHL2025 (16s)
✔ [3298/3322] Built QuantumBlockEncoding.Examples.RobinHeat (526ms)
✔ [3299/3322] Built QuantumBlockEncoding.RobinMatrix (45s)
✔ [3300/3322] Built QuantumBlockEncoding.RobinEvolution (3.3s)
✔ [3301/3322] Built QuantumBlockEncoding.Robin.FixedN3Data (3.7s)
✔ [3302/3322] Built QuantumBlockEncoding.Robin.SourceBaseline (2.8s)
✔ [3303/3322] Built QuantumBlockEncoding.Robin.WeightedPermutation (6.3s)
✔ [3304/3322] Built QuantumBlockEncoding.Robin.EvolvedCandidates (5.3s)
✔ [3305/3322] Built QuantumBlockEncoding.Robin.Hadamard8Verified (5.9s)
⚠ [3306/3322] Built QuantumBlockEncoding.PrimitiveSemantics (5.1s)
warning: QuantumBlockEncoding/PrimitiveSemantics.lean:217:10: This simp argument is unused:
  contextsEqual

Hint: Omit it from the simp argument list.
  simp [̵c̵o̵n̵t̵e̵x̵t̵s̵E̵q̵u̵a̵l̵,̵ ̵s̵p̵l̵i̵t̵P̵r̵i̵m̵i̵t̵i̵v̵e̵W̵i̵r̵e̵]̵[̲s̲p̲l̲i̲t̲P̲r̲i̲m̲i̲t̲i̲v̲e̲W̲i̲r̲e̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveSemantics.lean:218:10: This simp argument is unused:
  contextsEqual

Hint: Omit it from the simp argument list.
  simp [̵c̵o̵n̵t̵e̵x̵t̵s̵E̵q̵u̵a̵l̵,̵ ̵s̵p̵l̵i̵t̵P̵r̵i̵m̵i̵t̵i̵v̵e̵W̵i̵r̵e̵]̵[̲s̲p̲l̲i̲t̲P̲r̲i̲m̲i̲t̲i̲v̲e̲W̲i̲r̲e̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
✖ [3307/3322] Building QuantumBlockEncoding.VandaeleLadderContract (2.9s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderContract.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderContract.lean:67:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:90:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:101:2: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:141:70: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ (sorry ()).1 = state.1

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ (sorry ()).1 = state.1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:154:4: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).1 = (state.2 index).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:38: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:4: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ladderActive state index
same : ¬query = index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:157:2: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:12: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:156:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep, a̵c̵t̵i̵v̵e̵,̵ ̵Function.update_noteq same]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:157:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:164:7: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:166:33: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
✔ [3311/3322] Built QuantumBlockEncoding.PrimitiveRefinement (3.5s)
✖ [3312/3322] Building QuantumBlockEncoding.VandaeleEquation58PromiseGadget (3.7s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.setup.json --json
warning: QuantumBlockEncoding/VandaeleEquation58PromiseGadget.lean:68:17: This simp argument is unused:
  ccxToggle_involutive

Hint: Omit it from the simp argument list.
  simp [compute,̵ ̵c̵c̵x̵T̵o̵g̵g̵l̵e̵_̵i̵n̵v̵o̵l̵u̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleEquation58PromiseGadget.lean:101:2: Tactic `rfl` failed: The left-hand side
  (equation58Equiv state).1 = state.1
is not definitionally equal to the right-hand side
  (equation58Equiv state).2.1 = state.2.1 ∧ (equation58Equiv state).2.2.1 = state.2.2.1

state : GadgetState
⊢ (equation58Equiv state).1 = state.1 ∧
    (equation58Equiv state).2.1 = state.2.1 ∧ (equation58Equiv state).2.2.1 = state.2.2.1
error: Lean exited with code 1
✔ [3313/3322] Built QuantumBlockEncoding.ReversibleClassical (2.7s)
✖ [3314/3322] Building QuantumBlockEncoding.ReversibleProgramInverse (2.5s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleProgramInverse.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.setup.json --json
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:60:29: Unknown identifier `evalReversibleProgram_append`
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:73:8: Function expected at
  List.length_reverse
but this term has type
  (List.reverse ?m.7).length = List.length ?m.7

Note: Expected a function because this term is being applied to the argument
  program
error: Lean exited with code 1
✖ [3315/3322] Building QuantumBlockEncoding.ReversibleSchedule (2.6s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleSchedule.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.setup.json --json
error: QuantumBlockEncoding/ReversibleSchedule.lean:150:29: unsolved goals
case cons
qubits : ℕ
gate : ReversibleGate qubits
rest : List (ReversibleGate qubits)
induction : (sequential rest).program = rest
⊢ (List.map (fun gate => [gate]) rest).flatten = rest
warning: QuantumBlockEncoding/ReversibleSchedule.lean:152:36: This simp argument is unused:
  induction

Hint: Omit it from the simp argument list.
  simp [sequential, ScheduledReversibleProgram.program, R̵e̵v̵e̵r̵s̵i̵b̵l̵e̵S̵c̵h̵e̵d̵u̵l̵e̵.̵p̵r̵o̵g̵r̵a̵m̵,̵ ̵i̵n̵d̵u̵c̵t̵i̵o̵n̵]̵R̲e̲v̲e̲r̲s̲i̲b̲l̲e̲S̲c̲h̲e̲d̲u̲l̲e̲.̲p̲r̲o̲g̲r̲a̲m̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ReversibleSchedule.lean:156:55: unsolved goals
qubits : ℕ
program : ReversibleProgram qubits
⊢ List.length (sequential program).layers.program = List.length program
error: QuantumBlockEncoding/ReversibleSchedule.lean:186:6: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  (seq ?left ?right).program
in the target expression
  List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program

qubits : ℕ
left right : ScheduledReversibleProgram qubits
⊢ List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.VandaeleLadderContract
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ReversibleSchedule
error: build failed

```

## FAIL `QuantumBlockEncoding.RemaudVandaeleLadder1Family`

```text
  simp [̵c̵o̵n̵t̵e̵x̵t̵s̵E̵q̵u̵a̵l̵,̵ ̵s̵p̵l̵i̵t̵P̵r̵i̵m̵i̵t̵i̵v̵e̵W̵i̵r̵e̵]̵[̲s̲p̲l̲i̲t̲P̲r̲i̲m̲i̲t̲i̲v̲e̲W̲i̲r̲e̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveSemantics.lean:218:10: This simp argument is unused:
  contextsEqual

Hint: Omit it from the simp argument list.
  simp [̵c̵o̵n̵t̵e̵x̵t̵s̵E̵q̵u̵a̵l̵,̵ ̵s̵p̵l̵i̵t̵P̵r̵i̵m̵i̵t̵i̵v̵e̵W̵i̵r̵e̵]̵[̲s̲p̲l̲i̲t̲P̲r̲i̲m̲i̲t̲i̲v̲e̲W̲i̲r̲e̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
⚠ [3308/3323] Built QuantumBlockEncoding.ReversibleWireEmbedding (3.1s)
warning: QuantumBlockEncoding/ReversibleWireEmbedding.lean:86:52: This simp argument is unused:
  smallControlZero

Hint: Omit it from the simp argument list.
  simp [readEmbeddedState, mapGateWires, evalReversibleGate, cxBasisEquiv, cxBasisAction,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲c̵o̵n̵t̵r̵o̵l̵Z̵e̵r̵o̵,̵ ̵s̵m̵a̵l̵l̵C̵o̵n̵t̵r̵o̵l̵Z̵e̵r̵o̵]̵c̲o̲n̲t̲r̲o̲l̲Z̲e̲r̲o̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ReversibleWireEmbedding.lean:94:25: This simp argument is unused:
  smallControlNonzero

Hint: Omit it from the simp argument list.
  simp [readEmbeddedState, mapGateWires, evalReversibleGate, cxBasisEquiv, cxBasisAction,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲xBasisAction, c̵o̵n̵t̵r̵o̵l̵Z̵e̵r̵o̵,̵ ̵s̵m̵a̵l̵l̵C̵o̵n̵t̵r̵o̵l̵N̵o̵n̵z̵e̵r̵o̵]̵c̲o̲n̲t̲r̲o̲l̲Z̲e̲r̲o̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ReversibleWireEmbedding.lean:100:25: This simp argument is unused:
  smallControlNonzero

Hint: Omit it from the simp argument list.
  simp [readEmbeddedState, mapGateWires, evalReversibleGate, cxBasisEquiv, cxBasisAction,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲xBasisAction, controlZero, s̵m̵a̵l̵l̵C̵o̵n̵t̵r̵o̵l̵N̵o̵n̵z̵e̵r̵o̵,̵ ̵same, mappedNe]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ReversibleWireEmbedding.lean:112:20: This simp argument is unused:
  smallActive

Hint: Omit it from the simp argument list.
  simp [readEmbeddedState, mapGateWires, evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲xBasisAction, a̵c̵t̵i̵v̵e̵,̵ ̵s̵m̵a̵l̵l̵A̵c̵t̵i̵v̵e̵]̵a̲c̲t̲i̲v̲e̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ReversibleWireEmbedding.lean:118:20: This simp argument is unused:
  smallActive

Hint: Omit it from the simp argument list.
  simp [readEmbeddedState, mapGateWires, evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲xBasisAction, active, s̵m̵a̵l̵l̵A̵c̵t̵i̵v̵e̵,̵ ̵same, mappedNe]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ReversibleWireEmbedding.lean:124:49: This simp argument is unused:
  smallInactive

Hint: Omit it from the simp argument list.
  simp [readEmbeddedState, mapGateWires, evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲a̵c̵t̵i̵v̵e̵,̵ ̵s̵m̵a̵l̵l̵I̵n̵a̵c̵t̵i̵v̵e̵]̵a̲c̲t̲i̲v̲e̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
✖ [3309/3323] Building QuantumBlockEncoding.ReversibleSchedule (3.6s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleSchedule.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.setup.json --json
error: QuantumBlockEncoding/ReversibleSchedule.lean:150:29: unsolved goals
case cons
qubits : ℕ
gate : ReversibleGate qubits
rest : List (ReversibleGate qubits)
induction : (sequential rest).program = rest
⊢ (List.map (fun gate => [gate]) rest).flatten = rest
warning: QuantumBlockEncoding/ReversibleSchedule.lean:152:36: This simp argument is unused:
  induction

Hint: Omit it from the simp argument list.
  simp [sequential, ScheduledReversibleProgram.program, R̵e̵v̵e̵r̵s̵i̵b̵l̵e̵S̵c̵h̵e̵d̵u̵l̵e̵.̵p̵r̵o̵g̵r̵a̵m̵,̵ ̵i̵n̵d̵u̵c̵t̵i̵o̵n̵]̵R̲e̲v̲e̲r̲s̲i̲b̲l̲e̲S̲c̲h̲e̲d̲u̲l̲e̲.̲p̲r̲o̲g̲r̲a̲m̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ReversibleSchedule.lean:156:55: unsolved goals
qubits : ℕ
program : ReversibleProgram qubits
⊢ List.length (sequential program).layers.program = List.length program
error: QuantumBlockEncoding/ReversibleSchedule.lean:186:6: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  (seq ?left ?right).program
in the target expression
  List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program

qubits : ℕ
left right : ScheduledReversibleProgram qubits
⊢ List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program
error: Lean exited with code 1
✖ [3317/3323] Building QuantumBlockEncoding.VandaeleLadderContract (3.6s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderContract.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderContract.lean:67:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:90:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:101:2: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:141:70: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ (sorry ()).1 = state.1

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ (sorry ()).1 = state.1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:154:4: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).1 = (state.2 index).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:38: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:4: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ladderActive state index
same : ¬query = index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:157:2: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:12: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:156:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep, a̵c̵t̵i̵v̵e̵,̵ ̵Function.update_noteq same]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:157:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:164:7: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:166:33: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.VandaeleLadderContract
error: build failed

```

## FAIL `QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister`

```text
error: QuantumBlockEncoding/MultiControlledXSchedule.lean:63:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  gateAction gate state control
in the target expression
  active gate (gateAction gate state)

case mp
q : ℕ
gate : MCXGate q
state : PrimitiveBasis q
after : active gate (gateAction gate state)
control : Fin q
member : control ∈ gate.controls
preserved : gateAction gate state control = state control
⊢ state control = 1
error: QuantumBlockEncoding/MultiControlledXSchedule.lean:74:2: unsolved goals
case pos
q : ℕ
gate : MCXGate q
state : PrimitiveBasis q
h : active gate state
h' : active gate (gateAction gate state)
⊢ sorry () = state
error: QuantumBlockEncoding/MultiControlledXSchedule.lean:77:2: unsolved goals
case neg
q : ℕ
gate : MCXGate q
state : PrimitiveBasis q
h : ¬active gate state
h' : ¬active gate (gateAction gate state)
⊢ sorry () = state
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:76:10: declaration uses `sorry`
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:76:22: This simp argument is unused:
  h

Hint: Omit it from the simp argument list.
  simp [gateAction, h,̵ ̵h̵', xBasisAction_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:76:25: This simp argument is unused:
  h'

Hint: Omit it from the simp argument list.
  simp [gateAction, h, h̵'̵,̵ ̵xBasisAction_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:76:29: This simp argument is unused:
  xBasisAction_involutive

Hint: Omit it from the simp argument list.
  simp [gateAction, h, h',̵ ̵x̵B̵a̵s̵i̵s̵A̵c̵t̵i̵o̵n̵_̵i̵n̵v̵o̵l̵u̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:80:22: This simp argument is unused:
  h

Hint: Omit it from the simp argument list.
  simp [gateAction, h,̵ ̵h̵']

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:80:25: This simp argument is unused:
  h'

Hint: Omit it from the simp argument list.
  simp [gateAction, h,̵ ̵h̵'̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/MultiControlledXSchedule.lean:180:6: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  (seq ?left ?right).program
in the target expression
  List.length (scheduleProgram (left.seq right).layers) =
    List.length (scheduleProgram left.layers) + List.length (scheduleProgram right.layers)

q : ℕ
left right : ScheduledMCXProgram q
⊢ List.length (scheduleProgram (left.seq right).layers) =
    List.length (scheduleProgram left.layers) + List.length (scheduleProgram right.layers)
error: QuantumBlockEncoding/MultiControlledXSchedule.lean:195:16: invalid `▸` notation, argument
  member
has type
  query ∈ [layer]
equality expected
warning: QuantumBlockEncoding/MultiControlledXSchedule.lean:200:8: declaration uses `sorry`
error: QuantumBlockEncoding/MultiControlledXSchedule.lean:208:55: unsolved goals
q : ℕ
layer : MCXLayer q
valid : LayerValid layer
⊢ List.length (scheduleProgram (oneLayer layer valid).layers) = List.length layer
error: Lean exited with code 1
✖ [3310/3314] Building QuantumBlockEncoding.VandaeleLadderContract (2.8s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderContract.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderContract.lean:67:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:90:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:101:2: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:141:70: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ (sorry ()).1 = state.1

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ (sorry ()).1 = state.1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:154:4: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).1 = (state.2 index).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:38: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:4: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ladderActive state index
same : ¬query = index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:157:2: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:12: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:156:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep, a̵c̵t̵i̵v̵e̵,̵ ̵Function.update_noteq same]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:157:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:164:7: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:166:33: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.MultiControlledXSchedule
- QuantumBlockEncoding.VandaeleLadderContract
error: build failed

```

## FAIL `QuantumBlockEncoding.NieZiSunFigure3RecursiveFamily`

```text

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲s̵t̵e̵p̵2̵,̵ ̵step4, applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:267:52: This simp argument is unused:
  step4

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, s̵t̵e̵p̵4̵,̵applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:268:10: This simp argument is unused:
  applyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, step4, a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:268:21: This simp argument is unused:
  unapplyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, step4, applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:268:34: This simp argument is unused:
  flipHead_allOne_zero head headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, step4, applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵f̵l̵i̵p̵H̵e̵a̵d̵_̵a̵l̵l̵O̵n̵e̵_̵z̵e̵r̵o̵ ̵h̵e̵a̵d̵ ̵h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵]̵u̲n̲a̲p̲p̲l̲y̲H̲a̲l̲f̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:22: This simp argument is unused:
  step3

Hint: Omit it from the simp argument list.
  simp [protocol, s̵t̵e̵p̵3̵,̵ ̵midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:29: This simp argument is unused:
  midpoint

Hint: Omit it from the simp argument list.
  simp [protocol, step3, m̵i̵d̵p̵o̵i̵n̵t̵,̵ ̵leftActive, central, step1, step5, headActive, step2, step4, applyHalf,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:39: This simp argument is unused:
  leftActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, l̵e̵f̵t̵A̵c̵t̵i̵v̵e̵,̵ ̵central, step1, step5, headActive, step2, step4, applyHalf,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:51: This simp argument is unused:
  central

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, c̵e̵n̵t̵r̵a̵l̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:273:22: This simp argument is unused:
  headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central, step1, step5, h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵,̵ ̵step2, step4, applyHalf,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:273:34: This simp argument is unused:
  step2

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2̵,̵ ̵s̵t̵e̵p̵4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:273:41: This simp argument is unused:
  step4

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, ̵s̵t̵e̵p̵4̵,̵
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:274:8: This simp argument is unused:
  applyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:274:19: This simp argument is unused:
  unapplyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f,̵ ̵f̵lipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:274:32: This simp argument is unused:
  flipHead_allOne_zero head headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central, step1, step5, headActive, step2, step4,
          applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵f̵l̵i̵p̵H̵e̵a̵d̵_̵a̵l̵l̵O̵n̵e̵_̵z̵e̵r̵o̵ ̵h̵e̵a̵d̵ ̵h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵]̵u̲n̲a̲p̲p̲l̲y̲H̲a̲l̲f̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:279:34: This simp argument is unused:
  headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵,̵ ̵step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:279:46: This simp argument is unused:
  step3

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, s̵t̵e̵p̵3̵,̵ ̵central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:279:53: This simp argument is unused:
  central

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, c̵e̵n̵t̵r̵a̵l̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:6: This simp argument is unused:
  step2

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2̵,̵ ̵s̵t̵e̵p̵4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:13: This simp argument is unused:
  step4

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, s̵t̵e̵p̵4̵,̵ ̵applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:20: This simp argument is unused:
  applyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:31: This simp argument is unused:
  unapplyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, ̵u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:281:6: This simp argument is unused:
  flipHead_involutive

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central, step2, step4, applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵f̵l̵i̵p̵H̵e̵a̵d̵_̵i̵n̵v̵o̵l̵u̵t̵i̵v̵e̵]̵u̲n̲a̲p̲p̲l̲y̲H̲a̲l̲f̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.NieZiSunFigure3Protocol
error: build failed

```

## FAIL `QuantumBlockEncoding.NieZiSunFigure3Resource`

```text
  step2

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲s̵t̵e̵p̵2̵,̵ ̵step4, applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:267:52: This simp argument is unused:
  step4

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, s̵t̵e̵p̵4̵,̵applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:268:10: This simp argument is unused:
  applyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, step4, a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:268:21: This simp argument is unused:
  unapplyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, step4, applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:268:34: This simp argument is unused:
  flipHead_allOne_zero head headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, rightActive, central, step1, step5, headActive,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲step2, step4, applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵f̵l̵i̵p̵H̵e̵a̵d̵_̵a̵l̵l̵O̵n̵e̵_̵z̵e̵r̵o̵ ̵h̵e̵a̵d̵ ̵h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵]̵u̲n̲a̲p̲p̲l̲y̲H̲a̲l̲f̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:22: This simp argument is unused:
  step3

Hint: Omit it from the simp argument list.
  simp [protocol, s̵t̵e̵p̵3̵,̵ ̵midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:29: This simp argument is unused:
  midpoint

Hint: Omit it from the simp argument list.
  simp [protocol, step3, m̵i̵d̵p̵o̵i̵n̵t̵,̵ ̵leftActive, central, step1, step5, headActive, step2, step4, applyHalf,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:39: This simp argument is unused:
  leftActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, l̵e̵f̵t̵A̵c̵t̵i̵v̵e̵,̵ ̵central, step1, step5, headActive, step2, step4, applyHalf,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:272:51: This simp argument is unused:
  central

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, c̵e̵n̵t̵r̵a̵l̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:273:22: This simp argument is unused:
  headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central, step1, step5, h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵,̵ ̵step2, step4, applyHalf,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:273:34: This simp argument is unused:
  step2

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2̵,̵ ̵s̵t̵e̵p̵4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:273:41: This simp argument is unused:
  step4

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, ̵s̵t̵e̵p̵4̵,̵
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:274:8: This simp argument is unused:
  applyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵unapplyHalf, flipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:274:19: This simp argument is unused:
  unapplyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵step1, step5, headActive, step2, step4,
          applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f,̵ ̵f̵lipHead_allOne_zero head headActive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:274:32: This simp argument is unused:
  flipHead_allOne_zero head headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step3, midpoint, leftActive, central, step1, step5, headActive, step2, step4,
          applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵f̵l̵i̵p̵H̵e̵a̵d̵_̵a̵l̵l̵O̵n̵e̵_̵z̵e̵r̵o̵ ̵h̵e̵a̵d̵ ̵h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵]̵u̲n̲a̲p̲p̲l̲y̲H̲a̲l̲f̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:279:34: This simp argument is unused:
  headActive

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, h̵e̵a̵d̵A̵c̵t̵i̵v̵e̵,̵ ̵step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:279:46: This simp argument is unused:
  step3

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, s̵t̵e̵p̵3̵,̵ ̵central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:279:53: This simp argument is unused:
  central

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, c̵e̵n̵t̵r̵a̵l̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:6: This simp argument is unused:
  step2

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2̵,̵ ̵s̵t̵e̵p̵4, applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:13: This simp argument is unused:
  step4

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, s̵t̵e̵p̵4̵,̵ ̵applyHalf, unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:20: This simp argument is unused:
  applyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵ ̵unapplyHalf,
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:280:31: This simp argument is unused:
  unapplyHalf

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central,
  ̵  ̵ ̵ ̵ ̵ ̵step2, step4, applyHalf, ̵u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵
        flipHead_involutive]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/NieZiSunFigure3Protocol.lean:281:6: This simp argument is unused:
  flipHead_involutive

Hint: Omit it from the simp argument list.
  simp [protocol, step1, step5, headActive, step3, central, step2, step4, applyHalf, u̵n̵a̵p̵p̵l̵y̵H̵a̵l̵f̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵f̵l̵i̵p̵H̵e̵a̵d̵_̵i̵n̵v̵o̵l̵u̵t̵i̵v̵e̵]̵u̲n̲a̲p̲p̲l̲y̲H̲a̲l̲f̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.NieZiSunFigure3Protocol
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleStructuralPrimitivesFormalization`

```text

Note: This linter can be disabled with `set_option linter.unnecessarySeqFocus false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:140:10: This simp argument is unused:
  evalGlobalPhase

Hint: Omit it from the simp argument list.
  simp [e̵v̵a̵l̵G̵l̵o̵b̵a̵l̵P̵h̵a̵s̵e̵,̵ ̵ExactAngle.eval]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:141:4: 'push_cast' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:160:10: This simp argument is unused:
  evalGlobalPhase

Hint: Omit it from the simp argument list.
  simp [e̵v̵a̵l̵G̵l̵o̵b̵a̵l̵P̵h̵a̵s̵e̵,̵ ̵ExactAngle.eval]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:161:4: 'push_cast' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:359:42: This simp argument is unused:
  Ne.symm a_ne_b

Hint: Omit it from the simp argument list.
  simp [primitiveCCXMiddle, MonomialProgram.seq, MonomialProgram.cx, MonomialProgram.t,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲MonomialProgram.tdg, cxBasisEquiv, cxBasisAction, xBasisAction, flipBit, ha, hb, ht, wa, wb,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲wt, a_ne_b, a_ne_target, b_ne_target, Ne.symm a̵_̵n̵e̵_̵b̵,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵N̵e̵.̵s̵y̵m̵m̵ ̵a_ne_target, Ne.symm b_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:360:8: This simp argument is unused:
  Ne.symm a_ne_target

Hint: Omit it from the simp argument list.
  simp [primitiveCCXMiddle, MonomialProgram.seq, MonomialProgram.cx, MonomialProgram.t,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲MonomialProgram.tdg, cxBasisEquiv, cxBasisAction, xBasisAction, flipBit, ha, hb, ht, wa, wb,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲wt, a_ne_b, a_ne_target, b_ne_target, Ne.symm a_ne_b, Ne.symm a̵_̵n̵e̵_̵t̵a̵r̵g̵e̵t̵,̵ ̵N̵e̵.̵s̵y̵m̵m̵ ̵b_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:378:6: This simp argument is unused:
  Ne.symm a_ne_b

Hint: Omit it from the simp argument list.
  simp [primitiveCCXMiddle, MonomialProgram.seq, MonomialProgram.cx, MonomialProgram.t,
  ̲  ̲ ̲ ̲ ̲ ̲MonomialProgram.tdg, cxBasisEquiv, cxBasisAction, xBasisAction, flipBit, ha, hb, ht, a_ne_b,
  ̲  ̲ ̲ ̲ ̲ ̲a_ne_target, b_ne_target, Ne.symm a̵_̵n̵e̵_̵b̵,̵ ̵N̵e̵.̵s̵y̵m̵m̵ ̵a_ne_target, Ne.symm b_ne_target, ← Complex.exp_add]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:378:22: This simp argument is unused:
  Ne.symm a_ne_target

Hint: Omit it from the simp argument list.
  simp [primitiveCCXMiddle, MonomialProgram.seq, MonomialProgram.cx, MonomialProgram.t,
  ̲  ̲ ̲ ̲ ̲ ̲MonomialProgram.tdg, cxBasisEquiv, cxBasisAction, xBasisAction, flipBit, ha, hb, ht, a_ne_b,
  ̲  ̲ ̲ ̲ ̲ ̲a_ne_target, b_ne_target, Ne.symm a_ne_b, Ne.symm a̵_̵n̵e̵_̵t̵a̵r̵g̵e̵t̵,̵ ̵N̵e̵.̵s̵y̵m̵m̵ ̵b_ne_target, ← Complex.exp_add]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:378:43: This simp argument is unused:
  Ne.symm b_ne_target

Hint: Omit it from the simp argument list.
  simp [primitiveCCXMiddle, MonomialProgram.seq, MonomialProgram.cx, MonomialProgram.t,
  ̲  ̲ ̲ ̲ ̲ ̲MonomialProgram.tdg, cxBasisEquiv, cxBasisAction, xBasisAction, flipBit, ha, hb, ht, a_ne_b,
  ̲  ̲ ̲ ̲ ̲ ̲a_ne_target, b_ne_target, Ne.symm a_ne_b, Ne.symm a_ne_target, N̵e̵.̵s̵y̵m̵m̵ ̵b̵_̵n̵e̵_̵t̵a̵r̵g̵e̵t̵,̵← Complex.exp_add]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:417:31: Used `tac1 <;> tac2` where `(tac1; tac2)` would suffice

Note: This linter can be disabled with `set_option linter.unnecessarySeqFocus false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:428:31: Used `tac1 <;> tac2` where `(tac1; tac2)` would suffice

Note: This linter can be disabled with `set_option linter.unnecessarySeqFocus false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:493:10: This simp argument is unused:
  _root_.Matrix.one_apply

Hint: Omit it from the simp argument list.
  simp [cczTargetBlock, active, splitTargetNe,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵_̵r̵o̵o̵t̵_̵.̵M̵a̵t̵r̵i̵x̵.̵o̵n̵e̵_̵a̵p̵p̵l̵y̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/PrimitiveMacros.lean:578:10: This simp argument is unused:
  ccxTargetBlock

Hint: Omit it from the simp argument list.
  simp [̵c̵c̵x̵T̵a̵r̵g̵e̵t̵B̵l̵o̵c̵k̵,̵ ̵c̵o̵n̵t̵e̵x̵t̵,̵[̲c̲o̲n̲t̲e̲x̲t̲,̲ ccxBasisEquiv, actionMiss]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
✖ [3386/3394] Building QuantumBlockEncoding.ComparatorIncrementer (8.6s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ComparatorIncrementer.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.setup.json --json
error: QuantumBlockEncoding/ComparatorIncrementer.lean:84:8: unsolved goals
case nil
qubits : ℕ
⊢ 1 = equivPermutationMatrix (Equiv.refl (PrimitiveBasis qubits))
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:86:8: This simp argument is unused:
  equivPermutationMatrix

Hint: Omit it from the simp argument list.
  simp [compileReversibleProgram, evalReversibleProgram,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵e̵q̵u̵i̵v̵P̵e̵r̵m̵u̵t̵a̵t̵i̵o̵n̵M̵a̵t̵r̵i̵x̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:116:48: Invalid field `xCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.xCount`, so it is not possible to project the field `xCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:119:48: Invalid field `cxCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.cxCount`, so it is not possible to project the field `cxCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:122:48: Invalid field `toffoliCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:136:48: Invalid field `tCount`: The environment does not contain `QuantumBlockEncoding.PrimitiveGate.tCount`, so it is not possible to project the field `tCount` from an expression
  gate
of type `PrimitiveGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:155:24: Invalid field `xCount`: The environment does not contain `List.xCount`, so it is not possible to project the field `xCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:156:27: Invalid field `cxCount`: The environment does not contain `List.cxCount`, so it is not possible to project the field `cxCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:157:30: Invalid field `toffoliCount`: The environment does not contain `List.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:158:31: Invalid field `tCount`: The environment does not contain `List.tCount`, so it is not possible to project the field `tCount` from an expression
  compiled.circuit
of type `List (PrimitiveGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:223:2: Tactic `decide` failed for proposition
  compilationCost incrementer3Program =
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost incrementer3Program)
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: QuantumBlockEncoding/ComparatorIncrementer.lean:258:52: unsolved goals
state : PrimitiveBasis 3
clean : state 2 = 0
⊢ (if state 0 = 1 ∧ state 1 = 1 then state else Function.update state 2 1) 2 =
    if state 0 = 1 ∧ state 1 = 1 then 0 else 1
error: QuantumBlockEncoding/ComparatorIncrementer.lean:283:2: Tactic `decide` failed for proposition
  compilationCost comparatorLtThreeProgram =
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.MultiControlledXSchedule
- QuantumBlockEncoding.NieZiSunFigure3Protocol
- QuantumBlockEncoding.PromiseGateCircuitIdentities
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.VandaeleLadderContract
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ComparatorIncrementer
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleQuantumAdderFormalization`

```text
Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
✖ [3366/3405] Building QuantumBlockEncoding.ComparatorIncrementer (15s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ComparatorIncrementer.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.setup.json --json
error: QuantumBlockEncoding/ComparatorIncrementer.lean:84:8: unsolved goals
case nil
qubits : ℕ
⊢ 1 = equivPermutationMatrix (Equiv.refl (PrimitiveBasis qubits))
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:86:8: This simp argument is unused:
  equivPermutationMatrix

Hint: Omit it from the simp argument list.
  simp [compileReversibleProgram, evalReversibleProgram,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵e̵q̵u̵i̵v̵P̵e̵r̵m̵u̵t̵a̵t̵i̵o̵n̵M̵a̵t̵r̵i̵x̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:116:48: Invalid field `xCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.xCount`, so it is not possible to project the field `xCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:119:48: Invalid field `cxCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.cxCount`, so it is not possible to project the field `cxCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:122:48: Invalid field `toffoliCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:136:48: Invalid field `tCount`: The environment does not contain `QuantumBlockEncoding.PrimitiveGate.tCount`, so it is not possible to project the field `tCount` from an expression
  gate
of type `PrimitiveGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:155:24: Invalid field `xCount`: The environment does not contain `List.xCount`, so it is not possible to project the field `xCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:156:27: Invalid field `cxCount`: The environment does not contain `List.cxCount`, so it is not possible to project the field `cxCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:157:30: Invalid field `toffoliCount`: The environment does not contain `List.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:158:31: Invalid field `tCount`: The environment does not contain `List.tCount`, so it is not possible to project the field `tCount` from an expression
  compiled.circuit
of type `List (PrimitiveGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:223:2: Tactic `decide` failed for proposition
  compilationCost incrementer3Program =
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost incrementer3Program)
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: QuantumBlockEncoding/ComparatorIncrementer.lean:258:52: unsolved goals
state : PrimitiveBasis 3
clean : state 2 = 0
⊢ (if state 0 = 1 ∧ state 1 = 1 then state else Function.update state 2 1) 2 =
    if state 0 = 1 ∧ state 1 = 1 then 0 else 1
error: QuantumBlockEncoding/ComparatorIncrementer.lean:283:2: Tactic `decide` failed for proposition
  compilationCost comparatorLtThreeProgram =
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
✖ [3372/3405] Building QuantumBlockEncoding.PromiseGateCircuitIdentities (4.2s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/PromiseGateCircuitIdentities.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/PromiseGateCircuitIdentities.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/PromiseGateCircuitIdentities.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/PromiseGateCircuitIdentities.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/PromiseGateCircuitIdentities.setup.json --json
error: QuantumBlockEncoding/PromiseGateCircuitIdentities.lean:84:23: Application type mismatch: The argument
  firstEq
has type
  (implementation input).1 = promise
but is expected to have type
  input.1 = ?m.67
in the application
  Eq.trans source firstEq
error: Lean exited with code 1
✖ [3391/3405] Building QuantumBlockEncoding.ReversibleProgramInverse (3.7s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleProgramInverse.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.setup.json --json
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:60:29: Unknown identifier `evalReversibleProgram_append`
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:73:8: Function expected at
  List.length_reverse
but this term has type
  (List.reverse ?m.7).length = List.length ?m.7

Note: Expected a function because this term is being applied to the argument
  program
error: Lean exited with code 1
✖ [3397/3405] Building QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution (2.9s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.setup.json --json
error: QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.lean:73:7: Function expected at
  predicateControlledTargetEquiv
but this term has type
  ?m.1

Note: Expected a function because this term is being applied to the argument
  active

Hint: The identifier `predicateControlledTargetEquiv` is unknown, and Lean's `autoImplicit` option causes an unknown identifier to be treated as an implicitly bound variable with an unknown type. However, the unknown type cannot be a function, and a function is what Lean expects here. This is often the result of a typo or a missing `import` or `open` statement.
error: QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.lean:76:10: Invalid argument: Variable `predicateControlledTargetEquiv` is not a proposition or let-declaration
error: QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.lean:76:10: Invalid argument: Variable `predicateControlledTargetEquiv` is not a proposition or let-declaration
error: QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.lean:73:71: unsolved goals
case false
x✝ : Sort u_3
predicateControlledTargetEquiv : x✝
κ : Type u_1
α : Type u_2
active : κ → Bool
target : Equiv.Perm α
involutive : ∀ (value : α), target (target value) = value
key : κ
value : α
condition : active key = false
⊢ value = sorry ()

case true
x✝ : Sort u_3
predicateControlledTargetEquiv : x✝
κ : Type u_1
α : Type u_2
active : κ → Bool
target : Equiv.Perm α
involutive : ∀ (value : α), target (target value) = value
key : κ
value : α
condition : active key = true
⊢ target value = sorry ()
warning: QuantumBlockEncoding/StrongPromiseCleanToDirtyInvolution.lean:76:42: This simp argument is unused:
  condition

Hint: Omit it from the simp argument list.
  simp [predicateControlledTargetEquiv,̵ ̵c̵o̵n̵d̵i̵t̵i̵o̵n̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
✖ [3400/3405] Building QuantumBlockEncoding.VandaeleEquation58PromiseGadget (3.4s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleEquation58PromiseGadget.setup.json --json
warning: QuantumBlockEncoding/VandaeleEquation58PromiseGadget.lean:68:17: This simp argument is unused:
  ccxToggle_involutive

Hint: Omit it from the simp argument list.
  simp [compute,̵ ̵c̵c̵x̵T̵o̵g̵g̵l̵e̵_̵i̵n̵v̵o̵l̵u̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleEquation58PromiseGadget.lean:101:2: Tactic `rfl` failed: The left-hand side
  (equation58Equiv state).1 = state.1
is not definitionally equal to the right-hand side
  (equation58Equiv state).2.1 = state.2.1 ∧ (equation58Equiv state).2.2.1 = state.2.2.1

state : GadgetState
⊢ (equation58Equiv state).1 = state.1 ∧
    (equation58Equiv state).2.1 = state.2.1 ∧ (equation58Equiv state).2.2.1 = state.2.2.1
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.VandaeleLadderContract
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.PredicateControlledStrongPromise
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.MultiControlledXSchedule
- QuantumBlockEncoding.NieZiSunFigure3Protocol
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.ComparatorIncrementer
- QuantumBlockEncoding.PromiseGateCircuitIdentities
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleComparatorFormalization`

```text
      primitiveDepth := 14, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: QuantumBlockEncoding/ComparatorIncrementer.lean:258:52: unsolved goals
state : PrimitiveBasis 3
clean : state 2 = 0
⊢ (if state 0 = 1 ∧ state 1 = 1 then state else Function.update state 2 1) 2 =
    if state 0 = 1 ∧ state 1 = 1 then 0 else 1
error: QuantumBlockEncoding/ComparatorIncrementer.lean:283:2: Tactic `decide` failed for proposition
  compilationCost comparatorLtThreeProgram =
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
✖ [3348/3361] Building QuantumBlockEncoding.ReversibleSchedule (4.1s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleSchedule.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.setup.json --json
error: QuantumBlockEncoding/ReversibleSchedule.lean:150:29: unsolved goals
case cons
qubits : ℕ
gate : ReversibleGate qubits
rest : List (ReversibleGate qubits)
induction : (sequential rest).program = rest
⊢ (List.map (fun gate => [gate]) rest).flatten = rest
warning: QuantumBlockEncoding/ReversibleSchedule.lean:152:36: This simp argument is unused:
  induction

Hint: Omit it from the simp argument list.
  simp [sequential, ScheduledReversibleProgram.program, R̵e̵v̵e̵r̵s̵i̵b̵l̵e̵S̵c̵h̵e̵d̵u̵l̵e̵.̵p̵r̵o̵g̵r̵a̵m̵,̵ ̵i̵n̵d̵u̵c̵t̵i̵o̵n̵]̵R̲e̲v̲e̲r̲s̲i̲b̲l̲e̲S̲c̲h̲e̲d̲u̲l̲e̲.̲p̲r̲o̲g̲r̲a̲m̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ReversibleSchedule.lean:156:55: unsolved goals
qubits : ℕ
program : ReversibleProgram qubits
⊢ List.length (sequential program).layers.program = List.length program
error: QuantumBlockEncoding/ReversibleSchedule.lean:186:6: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  (seq ?left ?right).program
in the target expression
  List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program

qubits : ℕ
left right : ScheduledReversibleProgram qubits
⊢ List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program
error: Lean exited with code 1
✖ [3354/3361] Building QuantumBlockEncoding.VandaeleLadderContract (3.2s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderContract.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderContract.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderContract.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderContract.lean:67:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:90:6: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:101:2: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:141:70: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ (sorry ()).1 = state.1

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ (sorry ()).1 = state.1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:143:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:154:4: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).1 = (state.2 index).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:38: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:156:4: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ladderActive state index
same : ¬query = index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
error: QuantumBlockEncoding/VandaeleLadderContract.lean:157:2: unsolved goals
case neg
localControls steps : ℕ
index query : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 query).1 = (state.2 query).1
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:12: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:155:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:156:30: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep, a̵c̵t̵i̵v̵e̵,̵ ̵Function.update_noteq same]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:157:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLadderContract.lean:164:7: failed to synthesize instance of type class
  Decidable (ladderActive state index)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLadderContract.lean:166:33: unsolved goals
case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
⊢ ((sorry ()).2 index).2 = sorry ()
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLadderContract.lean:168:28: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [sourceLadderStep,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
✔ [3359/3361] Built QuantumBlockEncoding.ComparatorIncrementerLemma8Budget (3.1s)
Some required targets logged failures:
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ComparatorIncrementer
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.VandaeleLadderContract
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleIncrementerFormalization`

```text
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: QuantumBlockEncoding/ComparatorIncrementer.lean:258:52: unsolved goals
state : PrimitiveBasis 3
clean : state 2 = 0
⊢ (if state 0 = 1 ∧ state 1 = 1 then state else Function.update state 2 1) 2 =
    if state 0 = 1 ∧ state 1 = 1 then 0 else 1
error: QuantumBlockEncoding/ComparatorIncrementer.lean:283:2: Tactic `decide` failed for proposition
  compilationCost comparatorLtThreeProgram =
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
✖ [3346/3379] Building QuantumBlockEncoding.VandaeleLemma1Contract (3.9s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLemma1Contract.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLemma1Contract.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLemma1Contract.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLemma1Contract.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLemma1Contract.setup.json --json
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:30:2: failed to synthesize instance of type class
  Decidable (allControlsOne state.1)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:40:2: unsolved goals
case pos
k : ℕ
controls : PrimitiveBasis k
target : Fin 2
active : allControlsOne controls
⊢ sorry () = (controls, target)
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:41:2: unsolved goals
case neg
k : ℕ
controls : PrimitiveBasis k
target : Fin 2
active : ¬allControlsOne controls
⊢ sorry () = (controls, target)
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:40:10: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:40:34: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [multiControlledXAction,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:41:34: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [multiControlledXAction,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:54:51: unsolved goals
case pos
k : ℕ
state : PrimitiveBasis k × Fin 2
active : allControlsOne state.1
⊢ (sorry ()).1 = state.1

case neg
k : ℕ
state : PrimitiveBasis k × Fin 2
active : ¬allControlsOne state.1
⊢ (sorry ()).1 = state.1
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:56:33: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:56:57: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [multiControlledXEquiv, multiControlledXAction,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:62:6: failed to synthesize instance of type class
  Decidable (allControlsOne state.1)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:62:69: unsolved goals
case pos
k : ℕ
state : PrimitiveBasis k × Fin 2
active : allControlsOne state.1
⊢ (sorry ()).2 = sorry ()

case neg
k : ℕ
state : PrimitiveBasis k × Fin 2
active : ¬allControlsOne state.1
⊢ (sorry ()).2 = sorry ()
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:64:33: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:64:57: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [multiControlledXEquiv, multiControlledXAction,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
✖ [3354/3379] Building QuantumBlockEncoding.ReversibleProgramInverse (3.0s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleProgramInverse.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.setup.json --json
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:60:29: Unknown identifier `evalReversibleProgram_append`
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:73:8: Function expected at
  List.length_reverse
but this term has type
  (List.reverse ?m.7).length = List.length ?m.7

Note: Expected a function because this term is being applied to the argument
  program
error: Lean exited with code 1
✖ [3355/3379] Building QuantumBlockEncoding.ReversibleSchedule (3.4s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleSchedule.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleSchedule.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleSchedule.setup.json --json
error: QuantumBlockEncoding/ReversibleSchedule.lean:150:29: unsolved goals
case cons
qubits : ℕ
gate : ReversibleGate qubits
rest : List (ReversibleGate qubits)
induction : (sequential rest).program = rest
⊢ (List.map (fun gate => [gate]) rest).flatten = rest
warning: QuantumBlockEncoding/ReversibleSchedule.lean:152:36: This simp argument is unused:
  induction

Hint: Omit it from the simp argument list.
  simp [sequential, ScheduledReversibleProgram.program, R̵e̵v̵e̵r̵s̵i̵b̵l̵e̵S̵c̵h̵e̵d̵u̵l̵e̵.̵p̵r̵o̵g̵r̵a̵m̵,̵ ̵i̵n̵d̵u̵c̵t̵i̵o̵n̵]̵R̲e̲v̲e̲r̲s̲i̲b̲l̲e̲S̲c̲h̲e̲d̲u̲l̲e̲.̲p̲r̲o̲g̲r̲a̲m̲]̲

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ReversibleSchedule.lean:156:55: unsolved goals
qubits : ℕ
program : ReversibleProgram qubits
⊢ List.length (sequential program).layers.program = List.length program
error: QuantumBlockEncoding/ReversibleSchedule.lean:186:6: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  (seq ?left ?right).program
in the target expression
  List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program

qubits : ℕ
left right : ScheduledReversibleProgram qubits
⊢ List.length (left.seq right).layers.program = List.length left.layers.program + List.length right.layers.program
error: Lean exited with code 1
✖ [3376/3379] Building QuantumBlockEncoding.StrongPromiseInverse (3.4s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/StrongPromiseInverse.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/StrongPromiseInverse.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/StrongPromiseInverse.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/StrongPromiseInverse.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/StrongPromiseInverse.setup.json --json
error: QuantumBlockEncoding/StrongPromiseInverse.lean:35:4: Type mismatch: After simplification, term
  inverse
 has type
  (cleanPromise, (Equiv.symm target) value) = (Equiv.symm implementation) (cleanPromise, value)
but is expected to have type
  (Equiv.symm implementation) (cleanPromise, value) = (cleanPromise, (Equiv.symm target) value)
error: QuantumBlockEncoding/StrongPromiseInverse.lean:42:6: Type mismatch: After simplification, term
  firstRoundTrip
 has type
  True
but is expected to have type
  ((Equiv.symm implementation) (promise, value)).1 = promise
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.BinaryCarryTelescoping
- QuantumBlockEncoding.MixedRadixIncrement
- QuantumBlockEncoding.ComparatorIncrementerLemma8TwoRoundSchedule
- QuantumBlockEncoding.PredicateControlledStrongPromise
- QuantumBlockEncoding.ComparatorIncrementerLemma8Composition
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.ComparatorIncrementer
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.StrongPromiseInverse
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleAdderFormalization`

```text
k : ℕ
state : PrimitiveBasis k × Fin 2
active : allControlsOne state.1
⊢ (sorry ()).1 = state.1

case neg
k : ℕ
state : PrimitiveBasis k × Fin 2
active : ¬allControlsOne state.1
⊢ (sorry ()).1 = state.1
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:56:33: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:56:57: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [multiControlledXEquiv, multiControlledXAction,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:62:6: failed to synthesize instance of type class
  Decidable (allControlsOne state.1)

Hint: Type class instance resolution failures can be inspected with the `set_option trace.Meta.synthInstance true` command.
error: QuantumBlockEncoding/VandaeleLemma1Contract.lean:62:69: unsolved goals
case pos
k : ℕ
state : PrimitiveBasis k × Fin 2
active : allControlsOne state.1
⊢ (sorry ()).2 = sorry ()

case neg
k : ℕ
state : PrimitiveBasis k × Fin 2
active : ¬allControlsOne state.1
⊢ (sorry ()).2 = sorry ()
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:64:33: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleLemma1Contract.lean:64:57: This simp argument is unused:
  active

Hint: Omit it from the simp argument list.
  simp [multiControlledXEquiv, multiControlledXAction,̵ ̵a̵c̵t̵i̵v̵e̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
✖ [3320/3337] Building QuantumBlockEncoding.VandaeleLemma5Contract (5.2s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLemma5Contract.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLemma5Contract.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLemma5Contract.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLemma5Contract.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLemma5Contract.setup.json --json
error: QuantumBlockEncoding/VandaeleLemma5Contract.lean:78:27: unsolved goals
case true
κ : Type u_1
α : Type u_2
n : ℕ
active : κ → Bool
gates : Fin n → Equiv.Perm α
key : κ
state : Fin n → α
condition : active key = true
⊢ productAction gates state = fun index => (gates index) (state index)
warning: QuantumBlockEncoding/VandaeleLemma5Contract.lean:81:20: This simp argument is unused:
  productAction

Hint: Omit it from the simp argument list.
  simp [controlledProductEquiv, predicateControlledTargetEquiv, productEquiv, p̵r̵o̵d̵u̵c̵t̵A̵c̵t̵i̵o̵n̵,̵ ̵condition]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: Lean exited with code 1
✖ [3323/3337] Building QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound (6.4s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ComparatorIncrementerTheorem4DepthBound.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementerTheorem4DepthBound.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementerTheorem4DepthBound.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementerTheorem4DepthBound.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementerTheorem4DepthBound.setup.json --json
error: QuantumBlockEncoding/ComparatorIncrementerTheorem4DepthBound.lean:191:2: omega could not prove the goal:
a possible counterexample may satisfy the constraints
  j ≥ 0
  0 ≤ 2*i - j ≤ 1
  h ≥ 0
  g ≥ 0
  g - i ≥ 3
  f ≥ -2
  f - g ≥ -2
  -1 ≤ 2*f - h ≤ 0
  e ≥ 0
  d - e ≥ 2
  c ≥ 0
  b ≥ 0
  b - c ≥ -1
  a ≥ 1
  2*a - b ≥ 1
  2*a - c ≥ 0
where
 a := ↑2 ^ (logRank n / 2)
 b := ↑n.sqrt
 c := ↑(ceilSqrt n)
 d := ↑2 ^ (logRank n / 2 + 3)
 e := ↑(alpha n)
 f := ↑(logRank n) / 2
 g := ↑(Nat.log 2 (alpha n + 1))
 h := ↑(logRank n)
 i := ↑((n + 1).log2 + 1) / 2
 j := ↑(n + 1).log2
error: Lean exited with code 1
✖ [3326/3337] Building QuantumBlockEncoding.ComparatorIncrementer (13s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ComparatorIncrementer.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.setup.json --json
error: QuantumBlockEncoding/ComparatorIncrementer.lean:84:8: unsolved goals
case nil
qubits : ℕ
⊢ 1 = equivPermutationMatrix (Equiv.refl (PrimitiveBasis qubits))
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:86:8: This simp argument is unused:
  equivPermutationMatrix

Hint: Omit it from the simp argument list.
  simp [compileReversibleProgram, evalReversibleProgram,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵e̵q̵u̵i̵v̵P̵e̵r̵m̵u̵t̵a̵t̵i̵o̵n̵M̵a̵t̵r̵i̵x̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:116:48: Invalid field `xCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.xCount`, so it is not possible to project the field `xCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:119:48: Invalid field `cxCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.cxCount`, so it is not possible to project the field `cxCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:122:48: Invalid field `toffoliCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:136:48: Invalid field `tCount`: The environment does not contain `QuantumBlockEncoding.PrimitiveGate.tCount`, so it is not possible to project the field `tCount` from an expression
  gate
of type `PrimitiveGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:155:24: Invalid field `xCount`: The environment does not contain `List.xCount`, so it is not possible to project the field `xCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:156:27: Invalid field `cxCount`: The environment does not contain `List.cxCount`, so it is not possible to project the field `cxCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:157:30: Invalid field `toffoliCount`: The environment does not contain `List.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:158:31: Invalid field `tCount`: The environment does not contain `List.tCount`, so it is not possible to project the field `tCount` from an expression
  compiled.circuit
of type `List (PrimitiveGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:223:2: Tactic `decide` failed for proposition
  compilationCost incrementer3Program =
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost incrementer3Program)
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: QuantumBlockEncoding/ComparatorIncrementer.lean:258:52: unsolved goals
state : PrimitiveBasis 3
clean : state 2 = 0
⊢ (if state 0 = 1 ∧ state 1 = 1 then state else Function.update state 2 1) 2 =
    if state 0 = 1 ∧ state 1 = 1 then 0 else 1
error: QuantumBlockEncoding/ComparatorIncrementer.lean:283:2: Tactic `decide` failed for proposition
  compilationCost comparatorLtThreeProgram =
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.ComparatorIncrementer
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleShorFormalization`

```text
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:69:5: unused variable `aLt`

Note: This linter can be disabled with `set_option linter.unusedVariables false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:70:5: unused variable `bLt`

Note: This linter can be disabled with `set_option linter.unusedVariables false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:74:4: 'have sumLt := sum_lt_modulus_of_noOverflow aLt branch' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:75:4: 'rw [Nat.mod_eq_of_lt]' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:76:4: '· omega' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:77:4: '· simpa [Nat.add_comm] using sumLt' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:79:4: 'have overflow := modulus_le_sum_of_overflow aLt bLt branch' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:80:4: 'have reducedLt := overflow_output_lt_modulus positive aLt bLt branch' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:81:4: 'have oneSub : a + b = N + (b + a - N) := by omega' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:82:4: 'rw [oneSub, Nat.add_mod]' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:83:4: 'simp [Nat.mod_self, Nat.mod_eq_of_lt reducedLt]' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:74:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:75:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:76:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:77:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:79:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:80:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:81:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:82:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:83:4: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:90:6: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:86:8: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:88:5: unused variable `branch`

Note: This linter can be disabled with `set_option linter.unusedVariables false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:91:2: 'omega' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:91:2: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:101:6: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:95:8: declaration uses `sorry`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:97:5: unused variable `aLt`

Note: This linter can be disabled with `set_option linter.unusedVariables false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:98:5: unused variable `bLt`

Note: This linter can be disabled with `set_option linter.unusedVariables false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:99:5: unused variable `branch`

Note: This linter can be disabled with `set_option linter.unusedVariables false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:102:2: 'have overflow := modulus_le_sum_of_overflow aLt bLt branch' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:103:2: 'omega' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:102:2: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/VandaeleModularAdditionSemantics.lean:103:2: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
error: Lean exited with code 1
✖ [3332/3345] Building QuantumBlockEncoding.ComparatorIncrementer (13s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ComparatorIncrementer.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ComparatorIncrementer.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ComparatorIncrementer.setup.json --json
error: QuantumBlockEncoding/ComparatorIncrementer.lean:84:8: unsolved goals
case nil
qubits : ℕ
⊢ 1 = equivPermutationMatrix (Equiv.refl (PrimitiveBasis qubits))
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:86:8: This simp argument is unused:
  equivPermutationMatrix

Hint: Omit it from the simp argument list.
  simp [compileReversibleProgram, evalReversibleProgram,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵e̵q̵u̵i̵v̵P̵e̵r̵m̵u̵t̵a̵t̵i̵o̵n̵M̵a̵t̵r̵i̵x̵]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:116:48: Invalid field `xCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.xCount`, so it is not possible to project the field `xCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:119:48: Invalid field `cxCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.cxCount`, so it is not possible to project the field `cxCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:122:48: Invalid field `toffoliCount`: The environment does not contain `QuantumBlockEncoding.ReversibleGate.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  gate
of type `ReversibleGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:136:48: Invalid field `tCount`: The environment does not contain `QuantumBlockEncoding.PrimitiveGate.tCount`, so it is not possible to project the field `tCount` from an expression
  gate
of type `PrimitiveGate qubits`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:155:24: Invalid field `xCount`: The environment does not contain `List.xCount`, so it is not possible to project the field `xCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:156:27: Invalid field `cxCount`: The environment does not contain `List.cxCount`, so it is not possible to project the field `cxCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:157:30: Invalid field `toffoliCount`: The environment does not contain `List.toffoliCount`, so it is not possible to project the field `toffoliCount` from an expression
  program
of type `List (ReversibleGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:158:31: Invalid field `tCount`: The environment does not contain `List.tCount`, so it is not possible to project the field `tCount` from an expression
  compiled.circuit
of type `List (PrimitiveGate qubits)`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:223:2: Tactic `decide` failed for proposition
  compilationCost incrementer3Program =
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost incrementer3Program)
    { logicalX := 1, logicalCnot := 1, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 7,
      primitiveDepth := 14, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: QuantumBlockEncoding/ComparatorIncrementer.lean:258:52: unsolved goals
state : PrimitiveBasis 3
clean : state 2 = 0
⊢ (if state 0 = 1 ∧ state 1 = 1 then state else Function.update state 2 1) 2 =
    if state 0 = 1 ∧ state 1 = 1 then 0 else 1
error: QuantumBlockEncoding/ComparatorIncrementer.lean:283:2: Tactic `decide` failed for proposition
  compilationCost comparatorLtThreeProgram =
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
Some required targets logged failures:
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.VandaeleModularAdditionSemantics
- QuantumBlockEncoding.ComparatorIncrementer
error: build failed

```

## FAIL `QuantumBlockEncoding`

```text
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost comparatorLtThreeProgram)
    { logicalX := 1, logicalCnot := 0, logicalToffoli := 1, tCount := 7, primitiveOneQubit := 12, primitiveCnot := 6,
      primitiveDepth := 13, cleanAncillas := 0 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 1 with
  | true => isTrue ⋯
  | false => isFalse ⋯
warning: QuantumBlockEncoding/ComparatorIncrementer.lean:331:16: This simp argument is unused:
  h2

Hint: Omit it from the simp argument list.
  simp [intervalLtThreeSelectProgram, evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲ccxBasisAction, cxBasisEquiv, cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean, h0,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲h1, h̵2̵,̵ ̵h3]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
error: QuantumBlockEncoding/ComparatorIncrementer.lean:356:2: Tactic `decide` failed for proposition
  compilationCost intervalLtThreeSelectProgram 1 =
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
because its `Decidable` instance
  instDecidableEqCompilationCost (compilationCost intervalLtThreeSelectProgram 1)
    { logicalX := 2, logicalCnot := 1, logicalToffoli := 2, tCount := 14, primitiveOneQubit := 24, primitiveCnot := 13,
      primitiveDepth := 27, cleanAncillas := 1 }
did not reduce to `isTrue` or `isFalse`.

After unfolding the instances `instDecidableEqNat`, `Nat.decEq`, `instDecidableEqCompilationCost`, and `instDecidableEqCompilationCost.decEq`, reduction got stuck at the `Decidable` instance
  match h : sorry.beq 2 with
  | true => isTrue ⋯
  | false => isFalse ⋯
error: Lean exited with code 1
⚠ [3540/3566] Built QuantumBlockEncoding.ModularAdder3 (15s)
warning: QuantumBlockEncoding/ModularAdder3.lean:138:8: This simp argument is unused:
  c0_ne_work

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0̵_̵n̵e̵_̵w̵o̵r̵k̵,̵ ̵c̵1_ne_work, work_ne_c2, work_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵c0_ne_target, c1_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm c0_ne_work,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲Ne.symm c1_ne_work,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:138:20: This simp argument is unused:
  c1_ne_work

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c̵1̵_̵n̵e̵_̵work,̵ ̵w̵o̵r̵k̵_ne_c2, work_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵c0_ne_target, c1_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm c0_ne_work,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲Ne.symm c1_ne_work,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:138:32: This simp argument is unused:
  work_ne_c2

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c1_ne_work, work_ne_c̵2̵,̵ ̵w̵o̵r̵k̵_̵n̵e̵_̵target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵c0_ne_target, c1_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm c0_ne_work,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲Ne.symm c1_ne_work,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:138:44: This simp argument is unused:
  work_ne_target

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram, evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv, ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c1_ne_work, work_ne_c2, w̵o̵r̵k̵_̵n̵e̵_̵t̵a̵r̵g̵e̵t̵,̵c0_ne_target, c1_ne_target, Ne.symm c0_ne_work,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲Ne.symm c1_ne_work, Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:139:8: This simp argument is unused:
  c0_ne_target

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram, evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv, ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c1_ne_work, work_ne_c2, work_ne_target, c̵0̵_̵n̵e̵_̵t̵a̵r̵g̵e̵t̵,̵ ̵c1_ne_target, Ne.symm c0_ne_work,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲Ne.symm c1_ne_work, Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:139:22: This simp argument is unused:
  c1_ne_target

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram, evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv, ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c1_ne_work, work_ne_c2, work_ne_target, c0_ne_target, c̵1̵_̵n̵e̵_̵t̵a̵r̵g̵e̵t̵,̵Ne.symm c0_ne_work,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲Ne.symm c1_ne_work, Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:140:8: This simp argument is unused:
  Ne.symm c0_ne_work

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c1_ne_work, work_ne_c2, work_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵c0_ne_target, c1_ne_target,
          Ne.symm c0̵_̵n̵e̵_̵w̵o̵r̵k̵,̵ ̵N̵e̵.̵s̵y̵m̵m̵ ̵c̵1_ne_work,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵Ne.symm work_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/ModularAdder3.lean:140:28: This simp argument is unused:
  Ne.symm c1_ne_work

Hint: Omit it from the simp argument list.
  simp_all [cleanC3XBasisEquiv, cleanC3XReversibleProgram,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵evalReversibleProgram,
  ̲  ̲ ̲ ̲ ̲ ̲ ̲ ̲evalReversibleGate, ccxBasisEquiv,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵ccxBasisAction, c3xBasisAction, xBasisAction, flipBit,
          c0_ne_work, c1_ne_work, work_ne_c2, work_ne_target,
  ̵  ̵ ̵ ̵ ̵ ̵ ̵ ̵c0_ne_target, c1_ne_target,
          Ne.symm c0_ne_work, Ne.symm c̵1̵_̵n̵e̵_̵work,̵
  ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵ ̵N̵e̵.̵s̵y̵m̵m̵ ̵w̵o̵r̵k̵_ne_c2, Ne.symm work_ne_target]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
✔ [3551/3566] Built QuantumBlockEncoding.TextbookStatePreparation (4.6s)
✔ [3552/3566] Built QuantumBlockEncoding.TeachingRouteClosures (4.7s)
✔ [3553/3566] Built QuantumBlockEncoding.BandedSparseAccessPrimitive (19s)
⚠ [3554/3566] Built QuantumBlockEncoding.CubicStatePreparation (65s)
warning: QuantumBlockEncoding/CubicStatePreparation.lean:452:2: try 'simp' instead of 'simpa'

Note: This linter can be disabled with `set_option linter.unnecessarySimpa false`
warning: QuantumBlockEncoding/CubicStatePreparation.lean:452:42: this tactic is never executed

Note: This linter can be disabled with `set_option linter.unreachableTactic false`
warning: QuantumBlockEncoding/CubicStatePreparation.lean:452:42: 'decide' tactic does nothing

Note: This linter can be disabled with `set_option linter.unusedTactic false`
warning: QuantumBlockEncoding/CubicStatePreparation.lean:562:35: This simp argument is unused:
  Rat.inv_mul_rev

Hint: Omit it from the simp argument list.
  simp [Rat.div_def, Rat.pow_succ, R̵a̵t̵.̵i̵n̵v̵_̵m̵u̵l̵_̵r̵e̵v̵,̵ ̵Rat.mul_assoc]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/CubicStatePreparation.lean:698:12: This simp argument is unused:
  Rat.add_zero

Hint: Omit it from the simp argument list.
  simp ̵[̵R̵a̵t̵.̵a̵d̵d̵_̵z̵e̵r̵o̵]̵

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/CubicStatePreparation.lean:3437:4: Try this: intro hRoute _hBackend
warning: QuantumBlockEncoding/CubicStatePreparation.lean:3502:41: This simp argument is unused:
  Rat.inv_mul_rev

Hint: Omit it from the simp argument list.
  simp [Rat.div_def, Rat.pow_succ, R̵a̵t̵.̵i̵n̵v̵_̵m̵u̵l̵_̵r̵e̵v̵,̵ ̵Rat.mul_assoc]

Note: This linter can be disabled with `set_option linter.unusedSimpArgs false`
warning: QuantumBlockEncoding/CubicStatePreparation.lean:3653:4: Try this: intro hRoute _hScalar
✔ [3556/3566] Built QuantumBlockEncoding.StatePreparationBenchmarksCoreFixed (111s)
Some required targets logged failures:
- QuantumBlockEncoding.MixedRadixIncrement
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ComparatorIncrementerLemma8TwoRoundSchedule
- QuantumBlockEncoding.PredicateControlledStrongPromise
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.StrongPromiseInverse
- QuantumBlockEncoding.PromiseGateCircuitIdentities
- QuantumBlockEncoding.ComparatorIncrementerLemma8Composition
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.VandaeleModularAdditionSemantics
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
- QuantumBlockEncoding.NieZiSunFigure3Protocol
- QuantumBlockEncoding.MultiControlledXSchedule
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.VandaeleLadderContract
- QuantumBlockEncoding.PrimitivePromiseBorrow
- QuantumBlockEncoding.BinaryCarryTelescoping
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.ComparatorIncrementer
error: build failed

```

## Overall: FAIL

At least one source-spine build failed Lean admission.
