import QuantumBlockEncoding.ResetBlockProcess

open QuantumBlockEncoding ResetBlockProcess
open scoped Matrix.Norms.L2Operator

-- A genuine one-qubit Pauli-X oracle, not an abstract effect or reflection premise.
private noncomputable def xOracle : Matrix.unitaryGroup (Fin 2) ℂ :=
  ⟨!![0, 1; 1, 0], by
    rw [Matrix.mem_unitaryGroup_iff']
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Matrix.star_eq_conjTranspose,
        Matrix.conjTranspose_apply, Fin.sum_univ_two]⟩

-- Forward, forward, inverse is semantically X but costs THREE queries.
private def oneQubitPlan : Plan 1 3 (Fin 2) where
  arm := 0
  word := [.forward, .forward, .inverse]
  bounded := by decide

private noncomputable def zeroState : EuclideanSpace ℂ (Fin 2) :=
  PiLp.single 2 0 1

private theorem zeroState_norm : ‖zeroState‖ = 1 := by simp [zeroState]

example : QuantumQueryWord.queryCount oneQubitPlan.word = 3 := rfl

private theorem eval_plan : QuantumQueryWord.eval oneQubitPlan.word (xOracle : Matrix (Fin 2) (Fin 2) ℂ) =
    (xOracle : Matrix (Fin 2) (Fin 2) ℂ) := by
  simp only [oneQubitPlan, QuantumQueryWord.eval, QuantumQueryWord.Instruction.eval, one_mul]
  rw [Unitary.star_mul_self_of_mem xOracle.property, one_mul]

-- Every block resets to |0>, so its output is |1>, independently of history.
private theorem output_plan :
    BasisHellinger.wordOutput oneQubitPlan.word (xOracle : Matrix (Fin 2) (Fin 2) ℂ) zeroState =
      PiLp.single 2 1 (1 : ℂ) := by
  unfold BasisHellinger.wordOutput
  rw [eval_plan]
  ext j
  simp only [Matrix.ofLp_toEuclideanCLM]
  change Matrix.mulVec (xOracle : Matrix (Fin 2) (Fin 2) ℂ) zeroState.ofLp j =
    (PiLp.single 2 (1 : Fin 2) (1 : ℂ) : EuclideanSpace ℂ (Fin 2)) j
  fin_cases j <;>
    norm_num [xOracle, zeroState, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
      PiLp.single_apply]

private theorem block_plan : blockPMF oneQubitPlan (fun _ => xOracle) zeroState zeroState_norm =
    PMF.pure (1 : Fin 2) := by
  ext j
  rw [blockPMF_apply, output_plan]
  fin_cases j <;> simp [BasisHellinger.basisProbability, PMF.pure_apply]

-- This discriminates reset from carrying the X output forward (which would alternate).
example : historyLaw (fun _ => oneQubitPlan) (fun _ => xOracle) zeroState zeroState_norm 2 =
    PMF.pure [(1 : Fin 2), 1] := by
  simp [historyLaw, block_plan]

example (n : ℕ) : ∀ h ∈
    (historyLaw (fun _ => oneQubitPlan) (fun _ => xOracle) zeroState zeroState_norm n).support,
    h.length = n := historyLaw_length_support _ _ _ _ _

example : historyQueryCost (fun _ => oneQubitPlan) [(1 : Fin 2), 1] = 6 := by
  norm_num [historyQueryCost, oneQubitPlan, QuantumQueryWord.queryCount,
    QuantumQueryWord.Instruction.queryCost, Finset.sum_range_succ]

example (n T : ℕ) (hT : n * 3 ≤ T) : ∀ h ∈
    (historyLaw (fun _ => oneQubitPlan) (fun _ => xOracle) zeroState zeroState_norm n).support,
    historyQueryCost (fun _ => oneQubitPlan) h ≤ T :=
  historyLaw_queryCost_le_budget _ _ _ _ n hT

#check ResetBlockProcess.basisPMF
#check ResetBlockProcess.blockPMF
#check ResetBlockProcess.historyLaw
#check ResetBlockProcess.historyLaw_length_support
#check ResetBlockProcess.historyLaw_queryCost_le_budget

#print axioms ResetBlockProcess.basisPMF
#print axioms ResetBlockProcess.blockPMF
#print axioms ResetBlockProcess.historyLaw
#print axioms ResetBlockProcess.historyLaw_length_support
#print axioms ResetBlockProcess.historyLaw_queryCost_le
#print axioms ResetBlockProcess.historyLaw_queryCost_le_budget
