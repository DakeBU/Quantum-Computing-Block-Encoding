import QuantumBlockEncoding.ConcreteSemantics
import QuantumBlockEncoding.CubicStatePreparation
import QuantumBlockEncoding.MainCase

namespace QuantumBlockEncoding.QBenchIntegrationTests

open ConcreteSemantics

def bitFlipMatrix : Matrix (gridSize 1) (gridSize 1) Rat :=
  fun row col => if row.val + col.val = 1 then 1 else 0

def bitFlipTarget : StatePreparationTarget Rat 1 where
  amplitudes := fun row => if row.val = 1 then 1 else 0
  normalization := True
  source := "one-qubit bit-flip state preparation"

def complexZeroTarget : StatePreparationTarget ℂ 1 where
  amplitudes := zeroKet 1
  normalization := True
  source := "one-qubit complex zero state"

def complexIdentityGate : ComplexUnitaryGate 1 where
  matrix := 1
  unitary := one_mem _

def complexIdentityCertificate : ComplexStatePreparationCertificate 1 where
  target := complexZeroTarget
  gate := complexIdentityGate
  normalizationProof := trivial
  preparationProof := by
    exact _root_.Matrix.one_mulVec (zeroKet 1)

example :
    applyVec complexIdentityCertificate.gate.matrix (zeroKet 1) =
      complexIdentityCertificate.target.amplitudes :=
  complexIdentityCertificate.preparesVector

example :
    (complexIdentityCertificate.verified [] [] 0).candidate.isUnitary :=
  (complexIdentityCertificate.verified [] [] 0).unitaryProof

theorem bitFlip_firstColumnMatches :
    FirstColumnMatches bitFlipMatrix bitFlipTarget := by
  intro row
  fin_cases row <;> native_decide

example :
    applyVec bitFlipMatrix (zeroKet 1) = bitFlipTarget.amplitudes :=
  (firstColumnMatches_iff_applyVec_zeroKet
    bitFlipMatrix bitFlipTarget).mp bitFlip_firstColumnMatches

def cubicActionTarget (qubits : Nat) : StatePreparationTarget Rat qubits where
  amplitudes := CubicStatePreparation.cubicAmplitude qubits
  normalization := True
  source := "operator-action view of the cubic rank-one target"

theorem cubicOperator_firstColumnMatches (qubits : Nat) :
    FirstColumnMatches
      (CubicStatePreparation.cubicOperator qubits)
      (cubicActionTarget qubits) := by
  intro row
  exact CubicStatePreparation.cubicOperator_first_column qubits row

example (qubits : Nat) :
    applyVec
        (CubicStatePreparation.cubicOperator qubits)
        (zeroKet qubits) =
      (cubicActionTarget qubits).amplitudes :=
  (firstColumnMatches_iff_applyVec_zeroKet
    (CubicStatePreparation.cubicOperator qubits)
    (cubicActionTarget qubits)).mp
      (cubicOperator_firstColumnMatches qubits)

example (operator : Matrix (2 * 2) (2 * 2) Rat) (signalIndex : Fin 2) :
    Matrix.PointwiseEq
      (signalSystemBlockProjection 2 2 2 operator signalIndex)
      (BlockEncodingClassics.cleanBlockProduct signalIndex operator) :=
  signalSystemBlockProjection_eq_cleanBlockProduct operator signalIndex

example (operator : Matrix (3 * 4) (3 * 4) Rat) (signalIndex : Fin 3) :
    Matrix.PointwiseEq
      (signalSystemBlockProjection 3 4 4 operator signalIndex)
      (BlockEncodingClassics.cleanBlockProduct signalIndex operator) :=
  signalSystemBlockProjection_eq_cleanBlockProduct operator signalIndex

theorem mainCaseCold_cleanBlockProduct_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.cleanBlockProduct
        mainCaseColdCleanSignal mainCaseColdPartialPermMatrix)
      mainCaseColdTarget := by
  intro row col
  have viewBridge :=
    signalSystemBlockProjection_eq_cleanBlockProduct
      mainCaseColdPartialPermMatrix mainCaseColdCleanSignal row col
  exact viewBridge.symm.trans
    (mainCaseColdPartialPerm_blockProjection row col)

example {α : Type} [OfNat α 0]
    (operator : Matrix (2 * 3) (2 * 5) α) (signalIndex : Fin 2) :
    productRegisterBlockProjection
        (flatToProductRegister operator) signalIndex =
      signalSystemBlockProjection 2 3 5 operator signalIndex :=
  productRegisterBlockProjection_flatToProductRegister operator signalIndex

example {α : Type} [OfNat α 0]
    (operator : Matrix (4 * 2) (4 * 7) α) (signalIndex : Fin 4) :
    productRegisterBlockProjection
        (flatToProductRegister operator) signalIndex =
      signalSystemBlockProjection 4 2 7 operator signalIndex :=
  productRegisterBlockProjection_flatToProductRegister operator signalIndex

end QuantumBlockEncoding.QBenchIntegrationTests
