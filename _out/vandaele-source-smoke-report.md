# Vandaele source Lean admission report

- commit: `94190b8466d7f38197436cb5d7e41770f8b41ed8`
- workflow: `vandaele-source-admission-report.yml`
- policy: each top-level spine is built by Lean; traced upstream dependencies are compiled transitively.

## PASS `QuantumBlockEncoding.PromiseGateUnitaryMux`

## PASS `QuantumBlockEncoding.PromiseGatePermutationMatrixBridge`

## FAIL `QuantumBlockEncoding.VandaeleNaiveLadderFiniteChecks`

```text
  (equation58Equiv state).1 = state.1
is not definitionally equal to the right-hand side
  (equation58Equiv state).2.1 = state.2.1 ∧ (equation58Equiv state).2.2.1 = state.2.2.1

state : GadgetState
⊢ (equation58Equiv state).1 = state.1 ∧
    (equation58Equiv state).2.1 = state.2.1 ∧ (equation58Equiv state).2.2.1 = state.2.2.1
error: Lean exited with code 1
✔ [3310/3322] Built QuantumBlockEncoding.VandaeleLemma4AppendixResource (3.1s)
✖ [3311/3322] Building QuantumBlockEncoding.VandaeleLadderPermutation (3.5s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderPermutation.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderPermutation.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderPermutation.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderPermutation.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderPermutation.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:45:36: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:45:2: unsolved goals
case pos
localControls steps : ℕ
index query : Fin steps
different : query ≠ index
state : LadderState localControls steps
active : ladderActive state index
⊢ (Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2) query).2 = (state.2 query).2
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:95:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  dite (ladderActive state index) ?m.26 ?m.27
in the target expression
  (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state

case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
activeAfter : ladderActive (sourceLadderStep localControls steps index state) index
⊢ (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:109:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  dite (ladderActive state index) ?m.41 ?m.42
in the target expression
  (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
inactiveAfter : ¬ladderActive (sourceLadderStep localControls steps index state) index
⊢ (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: Lean exited with code 1
✔ [3313/3322] Built QuantumBlockEncoding.ReversibleClassical (3.2s)
✖ [3314/3322] Building QuantumBlockEncoding.ReversibleProgramInverse (2.3s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/ReversibleProgramInverse.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/ReversibleProgramInverse.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/ReversibleProgramInverse.setup.json --json
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:60:29: Unknown identifier `evalReversibleProgram_append`
error: QuantumBlockEncoding/ReversibleProgramInverse.lean:73:8: Function expected at
  List.length_reverse
but this term has type
  (List.reverse ?m.7).length = List.length ?m.7

Note: Expected a function because this term is being applied to the argument
  program
error: Lean exited with code 1
✖ [3315/3322] Building QuantumBlockEncoding.ReversibleSchedule (2.4s)
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
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
- QuantumBlockEncoding.VandaeleLadderPermutation
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ReversibleSchedule
error: build failed

```

## FAIL `QuantumBlockEncoding.RemaudVandaeleLadder1Family`

```text
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
✖ [3310/3323] Building QuantumBlockEncoding.VandaeleLadderPermutation (3.3s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderPermutation.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderPermutation.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderPermutation.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderPermutation.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderPermutation.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:45:36: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:45:2: unsolved goals
case pos
localControls steps : ℕ
index query : Fin steps
different : query ≠ index
state : LadderState localControls steps
active : ladderActive state index
⊢ (Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2) query).2 = (state.2 query).2
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:95:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  dite (ladderActive state index) ?m.26 ?m.27
in the target expression
  (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state

case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
activeAfter : ladderActive (sourceLadderStep localControls steps index state) index
⊢ (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:109:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  dite (ladderActive state index) ?m.41 ?m.42
in the target expression
  (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
inactiveAfter : ¬ladderActive (sourceLadderStep localControls steps index state) index
⊢ (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: Lean exited with code 1
✖ [3312/3323] Building QuantumBlockEncoding.ReversibleSchedule (3.3s)
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
- QuantumBlockEncoding.VandaeleLadderPermutation
- QuantumBlockEncoding.ReversibleSchedule
error: build failed

```

## PASS `QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister`

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
warning: QuantumBlockEncoding/PrimitiveMacros.lean:96:61: Used `tac1 <;> tac2` where `(tac1; tac2)` would suffice

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
✖ [3386/3394] Building QuantumBlockEncoding.ComparatorIncrementer (8.4s)
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
- QuantumBlockEncoding.NieZiSunFigure3Protocol
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.PromiseGateCircuitIdentities
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.VandaeleLadderPermutation
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
- QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ComparatorIncrementer
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleQuantumAdderFormalization`

```text
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: Lean exited with code 1
✖ [3385/3405] Building QuantumBlockEncoding.ComparatorIncrementer (14s)
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
✖ [3397/3405] Building QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution (2.8s)
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
✖ [3400/3405] Building QuantumBlockEncoding.VandaeleEquation58PromiseGadget (2.9s)
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
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.PredicateControlledStrongPromise
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.NieZiSunFigure3Protocol
- QuantumBlockEncoding.PromiseGateCircuitIdentities
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.VandaeleLadderPermutation
- QuantumBlockEncoding.ComparatorIncrementer
- QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleComparatorFormalization`

```text
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
✖ [3349/3361] Building QuantumBlockEncoding.ReversibleSchedule (3.7s)
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
✖ [3355/3361] Building QuantumBlockEncoding.VandaeleLadderPermutation (2.7s)
trace: .> LEAN_PATH=/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/subverso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/MD4Lean/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/verso/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Cli/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/batteries/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/Qq/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/aesop/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/proofwidgets/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/importGraph/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/LeanSearchClient/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/plausible/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/VersoBlueprint/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/packages/mathlib/.lake/build/lib/lean:/home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean /home/runner/.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/QuantumBlockEncoding/VandaeleLadderPermutation.lean -o /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderPermutation.olean -i /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/lib/lean/QuantumBlockEncoding/VandaeleLadderPermutation.ilean -c /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderPermutation.c --setup /home/runner/work/Quantum-Computing-Block-Encoding/Quantum-Computing-Block-Encoding/.lake/build/ir/QuantumBlockEncoding/VandaeleLadderPermutation.setup.json --json
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:45:36: Unknown identifier `Function.update_noteq`
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:45:2: unsolved goals
case pos
localControls steps : ℕ
index query : Fin steps
different : query ≠ index
state : LadderState localControls steps
active : ladderActive state index
⊢ (Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2) query).2 = (state.2 query).2
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:95:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  dite (ladderActive state index) ?m.26 ?m.27
in the target expression
  (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state

case pos
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ladderActive state index
activeAfter : ladderActive (sourceLadderStep localControls steps index state) index
⊢ (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: QuantumBlockEncoding/VandaeleLadderPermutation.lean:109:8: Tactic `rewrite` failed: Did not find an occurrence of the pattern
  dite (ladderActive state index) ?m.41 ?m.42
in the target expression
  (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state

case neg
localControls steps : ℕ
index : Fin steps
state : LadderState localControls steps
active : ¬ladderActive state index
inactiveAfter : ¬ladderActive (sourceLadderStep localControls steps index state) index
⊢ (if
        ladderActive
          (if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state)
          index then
      ((if ladderActive state index then
            (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
          else state).1,
        Function.update
          (if ladderActive state index then
              (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
            else state).2
          index
          (((if ladderActive state index then
                    (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                  else state).2
                index).1,
            flipBit
              ((if ladderActive state index then
                      (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
                    else state).2
                  index).2))
    else
      if ladderActive state index then
        (state.1, Function.update state.2 index ((state.2 index).1, flipBit (state.2 index).2))
      else state) =
    state
error: Lean exited with code 1
✔ [3359/3361] Built QuantumBlockEncoding.ComparatorIncrementerLemma8Budget (2.9s)
Some required targets logged failures:
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ComparatorIncrementer
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.VandaeleLadderPermutation
error: build failed

```

## FAIL `QuantumBlockEncoding.VandaeleIncrementerFormalization`

```text

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
✖ [3339/3370] Building QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound (4.4s)
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
✖ [3346/3379] Building QuantumBlockEncoding.VandaeleLemma1Contract (3.6s)
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
✖ [3354/3379] Building QuantumBlockEncoding.ReversibleProgramInverse (3.7s)
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
✖ [3376/3379] Building QuantumBlockEncoding.StrongPromiseInverse (3.1s)
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
- QuantumBlockEncoding.MixedRadixIncrement
- QuantumBlockEncoding.BinaryCarryTelescoping
- QuantumBlockEncoding.ComparatorIncrementerLemma8TwoRoundSchedule
- QuantumBlockEncoding.PredicateControlledStrongPromise
- QuantumBlockEncoding.ComparatorIncrementerLemma8Composition
- QuantumBlockEncoding.ComparatorIncrementer
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
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
✖ [3320/3337] Building QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound (5.8s)
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
✖ [3321/3337] Building QuantumBlockEncoding.VandaeleLemma5Contract (4.9s)
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
✖ [3326/3337] Building QuantumBlockEncoding.ComparatorIncrementer (12s)
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
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.VandaeleLemma5Contract
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
✔ [3541/3566] Built QuantumBlockEncoding.TeachingRouteClosures (3.8s)
⚠ [3542/3566] Built QuantumBlockEncoding.ModularAdder3 (15s)
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
⚠ [3553/3566] Built QuantumBlockEncoding.CubicStatePreparation (55s)
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
✔ [3555/3566] Built QuantumBlockEncoding.BandedSparseAccessPrimitive (19s)
✔ [3556/3566] Built QuantumBlockEncoding.StatePreparationBenchmarksCoreFixed (98s)
Some required targets logged failures:
- QuantumBlockEncoding.MixedRadixIncrement
- QuantumBlockEncoding.ComparatorIncrementerDirtyAncilla
- QuantumBlockEncoding.ComparatorIncrementerLemma8TwoRoundSchedule
- QuantumBlockEncoding.StrongPromiseInverse
- QuantumBlockEncoding.ComparatorIncrementerTheorem4DepthBound
- QuantumBlockEncoding.PredicateControlledStrongPromise
- QuantumBlockEncoding.PromiseGateCircuitIdentities
- QuantumBlockEncoding.VandaeleLemma5Contract
- QuantumBlockEncoding.ComparatorIncrementerLemma8Composition
- QuantumBlockEncoding.VandaeleModularAdditionSemantics
- QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
- QuantumBlockEncoding.VandaeleEquation58PromiseGadget
- QuantumBlockEncoding.NieZiSunFigure3Protocol
- QuantumBlockEncoding.PrimitivePromiseBorrow
- QuantumBlockEncoding.VandaeleLemma1Contract
- QuantumBlockEncoding.BinaryCarryTelescoping
- QuantumBlockEncoding.PrimitiveBasisLE
- QuantumBlockEncoding.VandaeleLadderPermutation
- QuantumBlockEncoding.ReversibleProgramInverse
- QuantumBlockEncoding.ReversibleSchedule
- QuantumBlockEncoding.ReversibleRegisterLift
- QuantumBlockEncoding.ComparatorIncrementer
error: build failed

```

## Overall: FAIL

At least one source-spine build failed Lean admission.
