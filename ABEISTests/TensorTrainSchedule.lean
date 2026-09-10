import QuantumBlockEncoding.TensorTrainSchedule

open QuantumBlockEncoding
open QuantumBlockEncoding.TensorTrainCanonical
open QuantumBlockEncoding.TensorTrainSchedule
open QuantumBlockEncoding.SequentialBondPreparation

noncomputable section

example : wordOfBasis (![0, 1] : PrimitiveBasis 2) = (0, 1, ()) := rfl
example : wordOfBasis (![1, 0] : PrimitiveBasis 2) = (1, 0, ()) := rfl

def varyingTrain : Chain 2 1 1 :=
  .cons (fun _ out => if out.1 = 0 ∧ out.2 = 0 then 1 else 0)
    (.cons (fun _ out => if out.1 = 0 then 3 / 5 else 4 / 5) (.nil 1) : Chain 1 3 1)

example : rankAt varyingTrain 0 = 1 ∧ rankAt varyingTrain 1 = 3 ∧
    rankAt varyingTrain 2 = 1 := by decide

example (x : PrimitiveBasis 2) (b : Fin 5) :
    (transfer (paddedAt varyingTrain) 2 x).mulVec
      (padVector (fun _ : Fin 1 => (1 : ℂ))) b =
      padVector (fun c => ((_root_.Matrix.vecMul (fun _ => 1)
        (contract varyingTrain (wordOfBasis x))) c : ℂ)) b :=
  transfer_padded varyingTrain (by norm_num [varyingTrain, maxBond]) _ x b

example (U : ℕ → Stage (Fin 5))
    (columns : ∀ t, t < 2 → ∀ bit b a, a.val < rankAt varyingTrain t →
      U t (bit, b) (0, a) = paddedAt varyingTrain t (bit, b) a)
    (x : PrimitiveBasis 2) (b : Fin 5) :
    run U (padVector (fun _ : Fin 1 => (1 : ℂ))) 2 (x, b) =
      if b.val = 0 then (contract varyingTrain (wordOfBasis x) 0 0 : ℂ) else 0 := by
  have h := TensorTrainSchedule.run_terminal_clean varyingTrain
    (by norm_num [varyingTrain, maxBond]) U columns (fun _ => 1) x b
  simpa [_root_.Matrix.vecMul, dotProduct] using h

-- Concrete local stages: identity emits zero from the active bond label.
def zeroCore : TensorTrainCanonical.Core 1 1 := fun _ out => if out.1 = 0 then 1 else 0
def zeroTrain : Chain 2 1 1 := .cons zeroCore (.cons zeroCore (.nil 1))

theorem identity_columns : ∀ t, t < 2 → ∀ (bit : Fin 2) (b a : Fin 3),
    a.val < rankAt zeroTrain t →
    (1 : Stage (Fin 3)) (bit, b) (0, a) = paddedAt zeroTrain t (bit, b) a := by
  intro t ht bit b a ha
  interval_cases t <;> fin_cases bit <;> fin_cases b <;> fin_cases a <;>
    simp_all [zeroTrain, zeroCore, rankAt, paddedAt, paddedCore,
      _root_.Matrix.one_apply]

example (x : PrimitiveBasis 2) (b : Fin 3) :
    run (fun _ => (1 : Stage (Fin 3))) (padVector (fun _ : Fin 1 => (1 : ℂ))) 2 (x, b) =
      if b.val = 0 then (contract zeroTrain (wordOfBasis x) 0 0 : ℂ) else 0 := by
  have h := TensorTrainSchedule.run_terminal_clean zeroTrain
    (by norm_num [zeroTrain, maxBond]) (fun _ => (1 : Stage (Fin 3))) identity_columns
    (fun _ => 1) x b
  simpa [_root_.Matrix.vecMul, dotProduct] using h

-- Empty intermediate rank remains a valid exact transfer case.
example (x : PrimitiveBasis 2) (b : Fin 3) :
    let C : Chain 2 1 1 := .cons (0 : TensorTrainCanonical.Core 1 0) (.cons 0 (.nil 1))
    (transfer (paddedAt C) 2 x).mulVec (padVector (fun _ : Fin 1 => (1 : ℂ))) b =
      padVector (fun c => ((_root_.Matrix.vecMul (fun _ => 1)
        (contract C (wordOfBasis x))) c : ℂ)) b := by
  apply transfer_padded
  norm_num [maxBond]

#print axioms transfer_shift
#print axioms transfer_padded
#print axioms run_eq_transfer_bounded
#print axioms run_padded
#print axioms TensorTrainSchedule.run_terminal_clean
#print axioms paddedAt_active_isometry
#print axioms exists_normalized_preparation_schedule
