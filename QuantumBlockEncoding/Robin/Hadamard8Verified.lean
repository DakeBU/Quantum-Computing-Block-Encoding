import QuantumBlockEncoding.Robin.EvolvedCandidates
import QuantumBlockEncoding.Robin.ComplexLCUProjection
import Mathlib.Tactic

/-!
# T2 logical complex unitary for the Hadamard-8 Robin decomposition

This module instantiates the reusable complex LCU kernel with the exact
Hadamard-8 structural certificate.  The selector PREPARE, controlled amplitude
rotations, SELECT permutation, and unprepare are concrete finite complex
matrices.  Primitive one-qubit/CNOT synthesis remains a later T3 layer.
-/

namespace QuantumBlockEncoding.Robin

open ComplexLCU
open scoped Kronecker

/-- Three binary selector wires before flattening to `Fin 8`. -/
abbrev WarmRobinHadamardBits := Fin 2 × (Fin 2 × Fin 2)

/-- Signal-register order used by the eight-slot selector. -/
def warmRobinHadamardBitsEquiv : WarmRobinHadamardBits ≃ Fin 8 :=
  (Equiv.prodCongr (Equiv.refl (Fin 2)) finProdFinEquiv).trans
    finProdFinEquiv

/-- One uniform binary PREPARE rotation. -/
noncomputable def warmRobinUniformBitPrepare :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  realOrthogonalRotation (Real.sqrt 2 / 2) (Real.sqrt 2 / 2)

theorem warmRobinUniformBitPrepare_unitary :
    warmRobinUniformBitPrepare ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ := by
  apply realOrthogonalRotation_unitary
  have squareRoot : (Real.sqrt 2) ^ 2 = (2 : Real) :=
    Real.sq_sqrt (by norm_num)
  nlinarith

/-- Tensor product PREPARE on three binary selector wires. -/
noncomputable def warmRobinHadamardBitsPrepare :
    _root_.Matrix WarmRobinHadamardBits WarmRobinHadamardBits ℂ :=
  warmRobinUniformBitPrepare ⊗ₖ
    (warmRobinUniformBitPrepare ⊗ₖ warmRobinUniformBitPrepare)

theorem warmRobinHadamardBitsPrepare_unitary :
    warmRobinHadamardBitsPrepare ∈
      _root_.Matrix.unitaryGroup WarmRobinHadamardBits ℂ := by
  apply _root_.Matrix.kronecker_mem_unitary
  · exact warmRobinUniformBitPrepare_unitary
  · apply _root_.Matrix.kronecker_mem_unitary
    · exact warmRobinUniformBitPrepare_unitary
    · exact warmRobinUniformBitPrepare_unitary

/-- The eight-dimensional selector PREPARE in the flattened selector basis. -/
noncomputable def warmRobinHadamard8SelectorPrepare :
    _root_.Matrix (Fin 8) (Fin 8) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ warmRobinHadamardBitsEquiv
    warmRobinHadamardBitsPrepare

theorem warmRobinHadamard8SelectorPrepare_unitary :
    warmRobinHadamard8SelectorPrepare ∈
      _root_.Matrix.unitaryGroup (Fin 8) ℂ := by
  apply reindex_unitary
  exact warmRobinHadamardBitsPrepare_unitary

/-- Real clean amplitude used by selector slot and system column. -/
def warmRobinHadamard8Coefficient (slot column : Fin 8) : Real :=
  ((warmRobinEightSlotAmplitude slot column : Rat) : Real)

theorem warmRobinHadamard8Coefficient_abs_le_one
    (slot column : Fin 8) :
    |warmRobinHadamard8Coefficient slot column| ≤ 1 := by
  fin_cases slot <;> fin_cases column <;>
    norm_num [warmRobinHadamard8Coefficient,
      warmRobinEightSlotAmplitude, warmRobinEightSlotWeight]

/-- Controlled two-dimensional amplitude block. -/
noncomputable def warmRobinHadamard8Rotation
    (slot column : Fin 8) : _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  amplitudeRotation (warmRobinHadamard8Coefficient slot column)

theorem warmRobinHadamard8Rotation_unitary (slot column : Fin 8) :
    warmRobinHadamard8Rotation slot column ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  amplitudeRotation_unitary _

theorem warmRobinHadamard8Rotation_cleanEntry (slot column : Fin 8) :
    warmRobinHadamard8Rotation slot column 0 0 =
      (warmRobinHadamard8Coefficient slot column : ℂ) := by
  have bounded := abs_le.mp
    (warmRobinHadamard8Coefficient_abs_le_one slot column)
  exact amplitudeRotation_cleanEntry _ bounded.1 bounded.2

/-- Each certified system permutation is packaged as an equivalence. -/
noncomputable def warmRobinHadamard8SystemEquiv (slot : Fin 8) :
    Fin 8 ≃ Fin 8 :=
  Equiv.ofBijective (warmRobinEightSlotPerm slot)
    (warmRobinEightSlotPerm_bijective slot)

/-- Product-register matrix before flattening to seven qubits. -/
noncomputable def warmRobinHadamard8LogicalUnitary :
    _root_.Matrix
      (LCUIndex (Fin 2) (Fin 8) (Fin 8))
      (LCUIndex (Fin 2) (Fin 8) (Fin 8)) ℂ :=
  prepareAmplitudeSelectUnprepare
    warmRobinHadamard8SelectorPrepare
    warmRobinHadamard8Rotation
    warmRobinHadamard8SystemEquiv

/-- The complete Hadamard-8 logical matrix is a standard complex unitary. -/
theorem warmRobinHadamard8LogicalUnitary_unitary :
    warmRobinHadamard8LogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex (Fin 2) (Fin 8) (Fin 8)) ℂ := by
  apply prepareAmplitudeSelectUnprepare_unitary
  · exact warmRobinHadamard8SelectorPrepare_unitary
  · exact warmRobinHadamard8Rotation_unitary

end QuantumBlockEncoding.Robin
