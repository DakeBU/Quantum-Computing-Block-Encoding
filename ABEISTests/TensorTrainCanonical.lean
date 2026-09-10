import QuantumBlockEncoding.TensorTrainCanonical

open QuantumBlockEncoding
open QuantumBlockEncoding.TensorTrainCanonical
open scoped BigOperators

noncomputable section

-- The last core has three repeated nonzero rows, so its matrix rank is one.
def repeatedLast : Core 3 1 := fun _ out => if out.1 = 0 then 3 / 5 else 4 / 5
def chooseFirst : Core 1 3 := fun _ out => if out.1 = 0 ∧ out.2 = 0 then 1 else 0
def repeatedTrain : Chain 2 1 1 := .cons chooseFirst (.cons repeatedLast (.nil 1))

example : ∃ (l' : ℕ) (R : _root_.Matrix (Fin 1) (Fin l') ℝ) (D : Chain 2 l' 1),
    RightCanonical D ∧ RankReduced repeatedTrain D ∧
    ∀ x, contract repeatedTrain x = R * contract D x :=
  exists_rightCanonical repeatedTrain

example : (∑ x : Word 2, (contract repeatedTrain x 0 0) ^ 2) = 1 := by
  change (∑ x : Fin 2 × (Fin 2 × Unit), (contract repeatedTrain x 0 0) ^ 2) = 1
  simp only [Fintype.sum_prod_type]
  norm_num [Word, repeatedTrain, chooseFirst, repeatedLast, contract, slice,
    _root_.Matrix.mul_apply, _root_.Matrix.one_apply, Fintype.sum_prod_type,
    Fin.sum_univ_succ]

example : ∃ (l' : ℕ) (u : Fin l' → ℝ) (D : Chain 2 l' 1),
    RightCanonical D ∧ RankReduced repeatedTrain D ∧ mass u = 1 ∧
    ∀ x, contract repeatedTrain x 0 0 = ∑ a, u a * contract D x a 0 := by
  apply exists_normalized_state
  change (∑ x : Fin 2 × (Fin 2 × Unit), (contract repeatedTrain x 0 0) ^ 2) = 1
  simp only [Fintype.sum_prod_type]
  norm_num [Word, repeatedTrain, chooseFirst, repeatedLast, contract, slice,
    _root_.Matrix.mul_apply, _root_.Matrix.one_apply, Fintype.sum_prod_type,
    Fin.sum_univ_succ]

-- Empty intermediate rank and zero train are accepted without nonemptiness.
example : ∃ (l' : ℕ) (R : _root_.Matrix (Fin 4) (Fin l') ℝ) (D : Chain 2 l' 1),
    RightCanonical D ∧ RankReduced (.cons (0 : Core 4 0) (.cons 0 (.nil 1))) D ∧
    ∀ x, contract (.cons (0 : Core 4 0) (.cons 0 (.nil 1))) x = R * contract D x :=
  exists_rightCanonical _

example : ∃ (l' : ℕ) (R : _root_.Matrix (Fin 0) (Fin l') ℝ) (D : Chain 0 l' 0),
    RightCanonical D ∧ RankReduced (.nil 0) D ∧
    ∀ x, contract (.nil 0) x = R * contract D x := exists_rightCanonical _

example {n l r : ℕ} (C : Chain n l r) :
    ∃ (l' : ℕ) (R : _root_.Matrix (Fin l) (Fin l') ℝ) (D : Chain n l' r),
      RightCanonical D ∧ maxBond D ≤ maxBond C ∧
      ∀ x, contract C x = R * contract D x := by
  obtain ⟨l', R, D, hD, hr, h⟩ := exists_rightCanonical C
  exact ⟨l', R, D, hD, hr.maxBond_le, h⟩

#print axioms exists_core_lq
#print axioms exists_rightCanonical
#print axioms chainMass_eq
#print axioms exists_normalized_state
#print axioms sequential_step_padded
#print axioms paddedCore_active_isometry
#print axioms RankReduced.last_bond_le_two
