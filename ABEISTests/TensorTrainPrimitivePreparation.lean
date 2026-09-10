import QuantumBlockEncoding.TensorTrainPrimitivePreparation

open QuantumBlockEncoding
open QuantumBlockEncoding.TensorTrainCanonical
open QuantumBlockEncoding.TensorTrainSchedule
open QuantumBlockEncoding.TensorTrainPrimitivePreparation
open scoped BigOperators

noncomputable section

-- A negative amplitude tests signed-boundary absorption; a nonnegative
-- preparation-table theorem cannot establish this exact first column.
def negativeZero : Chain 1 1 1 :=
  .cons (fun _ out => if out.1 = 0 then -1 else 0) (.nil 1)

theorem negativeZero_normalized : (∑ x : Word 1, (contract negativeZero x 0 0) ^ 2) = 1 := by
  change (∑ x : Fin 2 × Unit, (contract negativeZero x 0 0) ^ 2) = 1
  simp only [Fintype.sum_prod_type]
  norm_num [negativeZero, contract, slice, _root_.Matrix.mul_apply,
    _root_.Matrix.one_apply, Fintype.sum_prod_type, Fin.sum_univ_succ]

example : ∃ c : PrimitiveCircuit 1, c.gateCount ≤ 6 ∧ c.resource.oracleCalls = 0 ∧
    evalPrimitiveCircuit c (fun _ => 0) (fun _ => 0) = -1 := by
  obtain ⟨c, hc, ho, _, hcol⟩ := exists_primitive_preparation (q := 0) negativeZero
    (by norm_num [negativeZero, maxBond]) negativeZero_normalized
  refine ⟨c, by simpa using hc, ho, ?_⟩
  have h := hcol (fun _ => 0) (fun _ => 0)
  have he : Fin.append (fun _ : Fin 1 => (0 : Fin 2)) (fun _ : Fin 0 => (0 : Fin 2)) =
      (fun _ : Fin 1 => (0 : Fin 2)) := by
    funext i
    fin_cases i
    rfl
  rw [he] at h
  simpa [negativeZero, wordOfBasis, contract, slice, _root_.Matrix.mul_apply,
    _root_.Matrix.one_apply] using h

-- Rank-deficient raw terminal core: three repeated rows, two physical bits.
def repeatedSource : Chain 2 1 1 :=
  .cons (fun _ out => if out.1 = 0 ∧ out.2 = 0 then 1 else 0)
    (.cons (fun _ out => if out.1 = 0 then 3 / 5 else 4 / 5) (.nil 1) : Chain 1 3 1)

theorem repeatedSource_normalized :
    (∑ x : Word 2, (contract repeatedSource x 0 0) ^ 2) = 1 := by
  change (∑ x : Fin 2 × (Fin 2 × Unit), (contract repeatedSource x 0 0) ^ 2) = 1
  simp only [Fintype.sum_prod_type]
  norm_num [repeatedSource, contract, slice, _root_.Matrix.mul_apply,
    _root_.Matrix.one_apply, Fintype.sum_prod_type, Fin.sum_univ_succ]

example : ∃ c : PrimitiveCircuit 4,
    c.gateCount ≤ 768 ∧ c.resource.oracleCalls = 0 ∧
    evalPrimitiveCircuit c ∈ _root_.Matrix.unitaryGroup (PrimitiveBasis 4) ℂ ∧
    ∀ (x : PrimitiveBasis 2) (b : PrimitiveBasis 2),
      evalPrimitiveCircuit c (Fin.append x b) (fun _ => 0) =
        if b = (fun _ => 0) then
          (contract repeatedSource (wordOfBasis (fun i => x i.rev)) 0 0 : ℂ) else 0 := by
  simpa using exists_primitive_preparation (q := 2) repeatedSource
    (by norm_num [repeatedSource, maxBond]) repeatedSource_normalized

-- The new first core remains a row isometry even for a signed residual.
example : ∃ D : Chain 1 1 1, RightCanonical D ∧ maxBond D ≤ 1 ∧
    ∀ x, contract D x 0 0 = contract negativeZero x 0 0 :=
  exists_unitBoundary_canonical negativeZero (by norm_num [negativeZero, maxBond])
    negativeZero_normalized

#print axioms boundaryCore_isometry
#print axioms exists_unitBoundary_canonical
#print axioms run_transport
#print axioms run_circuits_clean
#print axioms publicCircuit_clean
#print axioms publicCircuit_gateCount_bound
#print axioms exists_primitive_preparation
#check exists_primitive_preparation
