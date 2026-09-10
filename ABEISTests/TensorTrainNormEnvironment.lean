import QuantumBlockEncoding.TensorTrainNormEnvironment

open scoped BigOperators
open QuantumBlockEncoding TensorTrainCanonical TensorTrainNormEnvironment

noncomputable def oneCore : Chain 1 1 1 :=
  .cons (fun _ out => if out.1 = 0 then 3 else 4) (.nil 1)

example : gram oneCore 0 0 = 25 := by
  norm_num [oneCore, gram, slice, _root_.Matrix.sum_apply,
    _root_.Matrix.mul_apply, _root_.Matrix.transpose_apply, Fin.sum_univ_two]

example : TensorTrainNormEnvironment.norm oneCore = 5 := by
  unfold TensorTrainNormEnvironment.norm
  have hg : gram oneCore 0 0 = 25 := by
    norm_num [oneCore, gram, slice, _root_.Matrix.sum_apply,
      _root_.Matrix.mul_apply, _root_.Matrix.transpose_apply, Fin.sum_univ_two]
  rw [hg]
  norm_num

noncomputable def varying : Chain 2 1 1 :=
  .cons (fun _ (out : Fin 2 × Fin 2) => if out.1 = out.2 then 1 else 0)
    (.cons (fun a out => if a = out.1 then (if a = 0 then 3 else 4) else 0) (.nil 1))

example : gram varying 0 0 = 25 := by
  norm_num [varying, gram, slice, _root_.Matrix.sum_apply,
    _root_.Matrix.mul_apply, _root_.Matrix.transpose_apply, Fin.sum_univ_two]

example : environmentScalars varying = 6 := by decide
example : arithmeticBudget varying = 53 := by decide

example : arithmeticBudget varying ≤ 9 * 2 * 2 ^ 3 :=
  arithmeticBudget_le varying 2 (by norm_num [varying, maxBond])

example : gram (.cons (0 : Core 1 1) (.nil 1)) 0 0 = 0 := by
  norm_num [gram, slice, _root_.Matrix.sum_apply, _root_.Matrix.mul_apply,
    _root_.Matrix.transpose_apply, Fin.sum_univ_two]

example : arithmeticBudget (.cons (0 : Core 0 0) (.nil 0)) = 0 := by decide
example : environmentScalars (.cons (0 : Core 0 0) (.nil 0)) = 0 := by decide

example (n : ℕ) (C : Chain n 1 1) :
    TensorTrainNormEnvironment.norm C ^ 2 = ∑ x : Word n, (contract C x 0 0) ^ 2 :=
  norm_sq C

example (n : ℕ) (C : Chain n 1 1) {I : Type*} [Fintype I]
    (e : Word n ≃ I) (f : I → ℝ) (h : ∀ x, contract C x 0 0 = f (e x)) :
    TensorTrainNormEnvironment.norm C = Real.sqrt (∑ i : I, f i ^ 2) :=
  norm_eq_of_contract C e f h

#print axioms gram_eq_sum
#print axioms gram_scalar
#print axioms norm_eq_of_contract
#print axioms environmentScalars_le
#print axioms arithmeticBudget_le
