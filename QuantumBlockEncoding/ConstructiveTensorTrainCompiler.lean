import QuantumBlockEncoding.ConstructiveTensorTrain
import QuantumBlockEncoding.ConstructiveIsometryLocal
import QuantumBlockEncoding.TensorTrainPrimitivePreparation
import QuantumBlockEncoding.TensorTrainWord
import QuantumBlockEncoding.PrimitiveDepthBound

/-!+# An actual primitive compiler for normalized real tensor trains

Canonicalization, signed boundary absorption, local SO completion, Gray/Givens
compilation, and physical-wire assembly are all named data producers. No chain,
matrix, or circuit is selected from an existence theorem. Quantum resource
bounds count the actual final list; classical preprocessing costs remain a
separate refinement obligation.
-/

namespace QuantumBlockEncoding.ConstructiveTensorTrainCompiler

open scoped BigOperators
open TensorTrainCanonical TensorTrainSchedule
open TensorTrainPrimitivePreparation

/-- Absorb the signed residual boundary into the actual first core. -/
noncomputable def absorbBoundary {n l r : ℕ} (u : Fin l → ℝ) :
    Chain (n + 1) l r → Chain (n + 1) 1 r
  | .cons A tail => .cons (boundaryRow u * A) tail

theorem absorbBoundary_canonical {n l r : ℕ} (u : Fin l → ℝ) (hu : mass u = 1)
    (D : Chain (n + 1) l r) (hD : RightCanonical D) :
    RightCanonical (absorbBoundary u D) := by
  cases D with
  | cons A tail => exact ⟨boundaryCore_isometry u hu A hD.1, hD.2⟩

theorem absorbBoundary_contract {n l r : ℕ} (u : Fin l → ℝ)
    (D : Chain (n + 1) l r) (x : Word (n + 1)) :
    contract (absorbBoundary u D) x = boundaryRow u * contract D x := by
  cases D with
  | cons A tail => exact boundaryCore_contract u A tail x

theorem absorbBoundary_maxBond {n l r : ℕ} (u : Fin l → ℝ)
    (D : Chain (n + 1) l r) : maxBond (absorbBoundary u D) ≤ max 1 (maxBond D) := by
  cases D with
  | cons A tail => simp only [absorbBoundary, maxBond]; omega

/-- Concrete scalar-boundary canonical train, with no separate initialization circuit. -/
noncomputable def unitBoundary {n : ℕ} (C : Chain (n + 1) 1 1) : Chain (n + 1) 1 1 :=
  absorbBoundary (ConstructiveTensorTrain.stateBoundary C)
    (ConstructiveTensorTrain.canonicalize C).canonical

theorem unitBoundary_canonical {n : ℕ} (C : Chain (n + 1) 1 1)
    (hNorm : (∑ x : Word (n + 1), (contract C x 0 0) ^ 2) = 1) :
    RightCanonical (unitBoundary C) :=
  absorbBoundary_canonical _ (ConstructiveTensorTrain.stateBoundary_normalized C hNorm)
    _ (ConstructiveTensorTrain.canonicalize_rightCanonical C)

theorem unitBoundary_contract {n : ℕ} (C : Chain (n + 1) 1 1) (x : Word (n + 1)) :
    contract (unitBoundary C) x 0 0 = contract C x 0 0 := by
  rw [unitBoundary, absorbBoundary_contract]
  simpa [boundaryRow, _root_.Matrix.mul_apply] using
    (ConstructiveTensorTrain.stateBoundary_action C x).symm

theorem unitBoundary_maxBond_le {n : ℕ} (C : Chain (n + 1) 1 1) :
    maxBond (unitBoundary C) ≤ maxBond C := by
  have hOne : 1 ≤ maxBond C := by
    have h := rankAt_le_maxBond C 0
    simpa only [rankAt_zero] using h
  exact (absorbBoundary_maxBond _ _).trans
    (max_le hOne (ConstructiveTensorTrain.canonicalize_maxBond_le C))

/-- Every local primitive list is computed from its actual completed SO matrix. -/
noncomputable def stage {n l r q : ℕ} (D : Chain n l r)
    (hB : maxBond D ≤ 2 ^ q) (t : ℕ) : PrimitiveCircuit (q + 1) :=
  GrayGivensCompiler.compileSO (ConstructiveIsometryLocal.completeStage D hB t)

theorem stage_gateCount {n l r q : ℕ} (D : Chain n l r)
    (hB : maxBond D ≤ 2 ^ q) (t : ℕ) :
    (stage D hB t).gateCount ≤ 6 * (2 ^ q) ^ 3 :=
  (GrayGivensCompiler.compileSO_cubic_bound _).1

theorem stage_columns {n l r q : ℕ} (D : Chain n l r)
    (hD : RightCanonical D) (hB : maxBond D ≤ 2 ^ q) (t : ℕ) (ht : t < n)
    (bit : Fin 2) (b a : PrimitiveBasis q)
    (ha : (primitiveBasisLEEquiv q a).val < rankAt D t) :
    evalPrimitiveCircuit (stage D hB t) (Fin.snoc b bit) (Fin.snoc a 0) =
      paddedAt D t (bit, primitiveBasisLEEquiv q b) (primitiveBasisLEEquiv q a) := by
  obtain ⟨ho, hd, hc⟩ := ConstructiveIsometryLocal.completeStage_spec D hD hB t ht
  rw [stage, GrayGivensCompiler.compileSO_eval _ ho hd]
  exact hc bit b a ha

/-- Final physical circuit: data occupy the low wires, and the clean bond the high wires. -/
noncomputable def compile {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q) : PrimitiveCircuit ((n + 1) + q) :=
  SequentialPrimitiveAssembly.publicCircuit []
    (stage (unitBoundary C) ((unitBoundary_maxBond_le C).trans hB)) (n + 1)

theorem compile_gateCount {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q) :
    (compile C hB).gateCount ≤ (n + 1) * (6 * (2 ^ q) ^ 3) :=
  publicCircuit_gateCount_bound _ _ _ (fun t _ => stage_gateCount _ _ t)

theorem compile_depth {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q) :
    (compile C hB).resource.depth ≤ (n + 1) * (6 * (2 ^ q) ^ 3) :=
  (compile C hB).resource_depth_le_gateCount.trans (compile_gateCount C hB)

theorem compile_unitary {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q) :
    evalPrimitiveCircuit (compile C hB) ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + q)) ℂ :=
  evalPrimitiveCircuit_unitary _

/-- All data words and all bond sectors, including every non-clean output. -/
theorem compile_columns {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q)
    (hNorm : (∑ x : Word (n + 1), (contract C x 0 0) ^ 2) = 1)
    (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis q) :
    evalPrimitiveCircuit (compile C hB) (Fin.append x b) (fun _ => 0) =
      if b = (fun _ => 0) then
        (contract C (wordOfBasis (fun i => x i.rev)) 0 0 : ℂ) else 0 := by
  rw [compile, publicCircuit_clean (unitBoundary C) ((unitBoundary_maxBond_le C).trans hB) _
    (fun t ht bit b a ha => stage_columns _ (unitBoundary_canonical C hNorm) _ t ht bit b a ha),
    unitBoundary_contract]

theorem compile_word {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q)
    (hNorm : (∑ x : Word (n + 1), (contract C x 0 0) ^ 2) = 1)
    (x : Word (n + 1)) (b : PrimitiveBasis q) :
    evalPrimitiveCircuit (compile C hB)
      (Fin.append (fun i => TensorTrainWord.toBasis x i.rev) b) (fun _ => 0) =
      if b = (fun _ => 0) then (contract C x 0 0 : ℂ) else 0 := by
  simpa only [Fin.rev_rev, TensorTrainWord.wordOfBasis_toBasis] using
    compile_columns C hB hNorm (fun i => TensorTrainWord.toBasis x i.rev) b

/-- Complete quantum correctness and resource certificate for the actual producer. -/
theorem compile_spec {n q : ℕ} (C : Chain (n + 1) 1 1)
    (hB : maxBond C ≤ 2 ^ q)
    (hNorm : (∑ x : Word (n + 1), (contract C x 0 0) ^ 2) = 1) :
    (compile C hB).gateCount ≤ (n + 1) * (6 * (2 ^ q) ^ 3) ∧
    (compile C hB).resource.depth ≤ (n + 1) * (6 * (2 ^ q) ^ 3) ∧
    (compile C hB).resource.oracleCalls = 0 ∧
    evalPrimitiveCircuit (compile C hB) ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + q)) ℂ ∧
    ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis q),
      evalPrimitiveCircuit (compile C hB) (Fin.append x b) (fun _ => 0) =
        if b = (fun _ => 0) then
          (contract C (wordOfBasis (fun i => x i.rev)) 0 0 : ℂ) else 0 :=
  ⟨compile_gateCount C hB, compile_depth C hB, rfl, compile_unitary C hB,
    compile_columns C hB hNorm⟩

end QuantumBlockEncoding.ConstructiveTensorTrainCompiler
