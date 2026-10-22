import Lean
import QuantumBlockEncoding.BlockEncoding
import QuantumBlockEncoding.AdjacentGivens

/- Fixed, trusted engineering regressions, not a runner for model output.
   No production theorem, source contract or historical definition is changed. -/
namespace QuantumComputingBench.ReferenceChecks

open QuantumBlockEncoding
open QuantumBlockEncoding.RealAmplitudePreparation

theorem ryZero : standardRyMatrix 0 = 1 := standardRyMatrix_zero

theorem halfAngle (alpha : ℝ) : standardRyMatrix (2 * alpha) =
    QuantumBlockEncoding.Robin.ComplexLCU.realRotation alpha := by
  unfold standardRyMatrix
  congr 1
  ring

theorem flipInvolution : ∀ bit : Fin 2, flipBit (flipBit bit) = bit := flipBit_flipBit

theorem planeDet : ∀ {N : ℕ} (i j : Fin N), i ≠ j → ∀ theta : ℝ,
    (AdjacentGivens.planeMatrix i j theta).det = 1 := AdjacentGivens.planeMatrix_det

theorem resourceWitness :
    let r := Resource.ofCountsWithDepth 2 3 1 1 4
    let s := Resource.ofCountsWithDepth 5 7 2 1 6
    ((Resource.add r s).gates, (Resource.add r s).depth,
      (Resource.add r s).pureAncilla, (Resource.parallel r s).gates,
      (Resource.parallel r s).depth, (Resource.parallel r s).pureAncilla) =
      (20, 10, 2, 20, 6, 1) := by decide

-- Disjoint simultaneous unit demands add, contradicting a universal max rule.
-- This is a demand-model counterexample, NOT a theorem about physical scheduling.
theorem disjointDemandNotMax : (1 : Nat) + 1 > Nat.max 1 1 := by decide

theorem zeroSplit : splitAngle 0 0 = ExactAngle.rational 0 := by
  simp [splitAngle, pairNorm]

noncomputable def sparse : PrimitiveBasis 1 → ℝ := fun b => if b 0 = 0 then 1 else 0

theorem sparseNonnegative : ∀ b, 0 ≤ sparse b := by
  intro b
  simp only [sparse]
  split_ifs <;> norm_num

theorem sparseHasZero : sparse (fun _ => 1) = 0 := by norm_num [sparse]

theorem sparsePositiveMass : 0 < normSq sparse := by
  apply Finset.sum_pos'
  · intro b _
    exact sq_nonneg _
  · exact ⟨(fun _ => 0), Finset.mem_univ _, by norm_num [sparse]⟩

theorem sparseNotStrictlyPositive : ¬ (∀ b, 0 < sparse b) := by
  intro h
  have bad := h (fun _ => 1)
  rw [sparseHasZero] at bad
  exact lt_irrefl 0 bad

theorem sparsePrepared (b : PrimitiveBasis 1) :
    evalPrimitiveCircuit (prepareCircuit 1 sparse) b (fun _ => 0) =
      ((sparse b / Real.sqrt (normSq sparse) : ℝ) : ℂ) :=
  prepareCircuit_firstColumn sparse sparseNonnegative sparsePositiveMass b

theorem oracleAbstractGate : (Gate.resource (.oracleCall "qcb")).gates = 1 := by
  rfl

theorem oracleResourceTuple :
    let r := Gate.resource (.oracleCall "qcb")
    (r.oneQubit, r.cnot, r.oracleCalls, r.gates) = (0, 0, 1, 1) := rfl

theorem addressWidth (n : Nat) : clog2 (gridSize n) = n := clog2_gridSize n

theorem addressBoundary : [clog2 0, clog2 1, clog2 2, clog2 3, clog2 4, clog2 5, clog2 8] =
    [0, 0, 1, 2, 2, 3, 3] := by decide

end QuantumComputingBench.ReferenceChecks

open Lean Elab Command in
elab "qcbAuditReferences" : command => do
  let roots := [``QuantumComputingBench.ReferenceChecks.ryZero,
    ``QuantumComputingBench.ReferenceChecks.halfAngle,
    ``QuantumComputingBench.ReferenceChecks.flipInvolution,
    ``QuantumComputingBench.ReferenceChecks.planeDet,
    ``QuantumComputingBench.ReferenceChecks.resourceWitness,
    ``QuantumComputingBench.ReferenceChecks.disjointDemandNotMax,
    ``QuantumComputingBench.ReferenceChecks.zeroSplit,
    ``QuantumComputingBench.ReferenceChecks.sparseNonnegative,
    ``QuantumComputingBench.ReferenceChecks.sparseHasZero,
    ``QuantumComputingBench.ReferenceChecks.sparsePositiveMass,
    ``QuantumComputingBench.ReferenceChecks.sparseNotStrictlyPositive,
    ``QuantumComputingBench.ReferenceChecks.sparsePrepared,
    ``QuantumComputingBench.ReferenceChecks.oracleAbstractGate,
    ``QuantumComputingBench.ReferenceChecks.oracleResourceTuple,
    ``QuantumComputingBench.ReferenceChecks.addressWidth,
    ``QuantumComputingBench.ReferenceChecks.addressBoundary]
  for root in roots do
    let axioms ← liftCoreM (Lean.collectAxioms root)
    let names := axioms.toList.map Lean.Name.toString
    logInfo s!"QCB_REFERENCE_AXIOMS|{root}|{String.intercalate "," names}"

qcbAuditReferences
