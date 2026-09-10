import QuantumBlockEncoding.SequentialBondPreparation

namespace SequentialBondIndependentExamples

open QuantumBlockEncoding QuantumBlockEncoding.SequentialBondPreparation
open QuantumBlockEncoding.Robin.ComplexLCU

-- Every sequence of actual primitive local circuits preserves unit mass.
example {q : Nat} (circuits : Nat → PrimitiveCircuit (q + 1))
    (initial : PrimitiveBasis q) (n : Nat) :
    amplitudeMass (run (fun t => circuitStage (circuits t))
      (basisBoundary initial) n) = 1 := by
  exact amplitudeMass_run_basisBoundary _ initial
    (fun t => circuitStage_unitary (circuits t)) n

-- Chronology: wire 0 selects the first core; wire 1 selects the second.
example (A C : Core (Fin 2)) :
    transfer (fun t => if t = 0 then A else C) 2 ![0, 1] =
      coreSlice C 1 * coreSlice A 0 := by
  simp [transfer, Fin.init]

-- Four padded bond labels, but only two occupied labels. This stage swaps
-- the emitted bit with the low bond bit, preserving the high bond bit.
abbrev PaddedBond := Fin 2 × Fin 2

def swapEmittedLow : (Fin 2 × PaddedBond) ≃ (Fin 2 × PaddedBond) :=
  (Equiv.prodAssoc _ _ _).symm |>.trans
    (Equiv.prodCongr (Equiv.prodComm _ _) (Equiv.refl _)) |>.trans
      (Equiv.prodAssoc _ _ _)

noncomputable def swapStage : Stage PaddedBond :=
  equivPermutationMatrix swapEmittedLow

def terminalTable : _root_.Matrix (Fin 2) PaddedBond ℂ :=
  fun bit a => if bit = a.1 then 1 else 0

example : swapStage ∈ _root_.Matrix.unitaryGroup (Fin 2 × PaddedBond) ℂ :=
  equivPermutationMatrix_unitary _

theorem swap_active_columns (bit : Fin 2) (b a : PaddedBond) (ha : a.2 = 0) :
    swapStage (bit, b) (0, a) = terminalCore (0, 0) terminalTable (bit, b) a := by
  rcases b with ⟨lo, hi⟩
  rcases a with ⟨alo, ahi⟩
  simp only at ha
  subst ahi
  fin_cases bit <;> fin_cases lo <;> fin_cases hi <;> fin_cases alo <;>
    simp [swapStage, equivPermutationMatrix, swapEmittedLow,
      terminalCore, terminalTable]

-- Actual cleanup, despite padded dimension four: both final bond bits zero.
example {n : Nat} (v : BondState n PaddedBond)
    (support : ∀ p a, ¬ a.2 = 0 → v (p, a) = 0)
    (x : PrimitiveBasis (n + 1)) (b : PaddedBond) :
    step swapStage v (x, b) = if b = (0, 0) then
      ∑ a, terminalTable (x (Fin.last n)) a * v (Fin.init x, a) else 0 := by
  exact step_terminalCore_of_supported swapStage v (fun a => a.2 = 0)
    (0, 0) terminalTable support swap_active_columns x b

-- The unused completion column is intentionally NOT the terminal core.
-- This prevents regressions back to an impossible all-padded-columns contract.
example : swapStage (0, (0, 1)) (0, (0, 1)) = 1 ∧
    terminalCore (0, 0) terminalTable (0, (0, 1)) (0, 1) = 0 := by
  simp [swapStage, equivPermutationMatrix, swapEmittedLow, terminalCore]

#print axioms step_apply
#print axioms run_eq_transfer_of_supported
#print axioms run_terminal_clean
#print axioms run_circuitStages_eq_transfer
#print axioms amplitudeMass_run_basisBoundary
#print axioms swap_active_columns

end SequentialBondIndependentExamples
