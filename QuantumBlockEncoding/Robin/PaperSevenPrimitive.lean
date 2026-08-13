import QuantumBlockEncoding.Robin.EvolvedCandidates
import QuantumBlockEncoding.UniformlyControlledRy
import Mathlib.Tactic

/-!
# Padded physical selector for the Robin paper-seven route

The source route uses seven active terms but requires three physical selector
qubits.  Slot seven is therefore present in the Hilbert space and receives
zero clean-column amplitude.  This module closes the exact selector PREPARE
stage; it does not promote the still-open source SELECT/Figure-4 route.
-/

namespace QuantumBlockEncoding.Robin

def warmRobinUniformSevenHighAngle : ExactAngle :=
  .twiceArccosSqrtRational (4 / 7) (by norm_num)

def warmRobinUniformSevenTailAngle : ExactAngle :=
  .twiceArccosSqrtRational (2 / 3) (by norm_num)

def warmRobinUniformSevenMiddleAngles
    (bits : PrimitiveBasis 1) : ExactAngle :=
  if bits 0 = 0 then .piRational (1 / 2)
  else warmRobinUniformSevenTailAngle

def warmRobinUniformSevenLowAngles
    (bits : PrimitiveBasis 2) : ExactAngle :=
  if bits 0 = 1 ∧ bits 1 = 1 then .rational 0
  else .piRational (1 / 2)

def warmRobinUniformSevenMiddleWires : Fin 1 → Fin 3 := fun _ => 2

theorem warmRobinUniformSevenMiddleWires_ne_target
    (wire : Fin 1) : warmRobinUniformSevenMiddleWires wire ≠ (1 : Fin 3) := by
  fin_cases wire
  decide

def warmRobinUniformSevenLowWires : Fin 2 → Fin 3
  | 0 => 1
  | _ => 2

theorem warmRobinUniformSevenLowWires_ne_target
    (wire : Fin 2) : warmRobinUniformSevenLowWires wire ≠ (0 : Fin 3) := by
  fin_cases wire <;> decide

noncomputable def warmRobinUniformSevenPrepareCircuit : PrimitiveCircuit 3 :=
  [.ry 2 warmRobinUniformSevenHighAngle] ++
    compileUniformlyControlledRy 1 warmRobinUniformSevenMiddleWires 1
      warmRobinUniformSevenMiddleWires_ne_target
      warmRobinUniformSevenMiddleAngles ++
    compileUniformlyControlledRy 2 warmRobinUniformSevenLowWires 0
      warmRobinUniformSevenLowWires_ne_target warmRobinUniformSevenLowAngles

noncomputable def warmRobinUniformSevenPrepareProgram : PrimitiveProgram 3 where
  circuit := warmRobinUniformSevenPrepareCircuit
  globalPhase := .rational 0

/-- Independent stagewise matrix specification for the padded selector. -/
noncomputable def warmRobinUniformSevenPrepareMatrix :
    _root_.Matrix (PrimitiveBasis 3) (PrimitiveBasis 3) ℂ :=
  controlledRyBlockMatrix warmRobinUniformSevenLowWires 0
      warmRobinUniformSevenLowWires_ne_target warmRobinUniformSevenLowAngles *
    (controlledRyBlockMatrix warmRobinUniformSevenMiddleWires 1
        warmRobinUniformSevenMiddleWires_ne_target
        warmRobinUniformSevenMiddleAngles *
      evalPrimitiveGate (.ry 2 warmRobinUniformSevenHighAngle))

theorem warmRobinUniformSevenPrepareProgram_eval :
    evalPrimitiveProgram warmRobinUniformSevenPrepareProgram =
      warmRobinUniformSevenPrepareMatrix := by
  change evalGlobalPhase (.rational 0) •
      evalPrimitiveCircuit warmRobinUniformSevenPrepareCircuit = _
  have phaseZero : evalGlobalPhase (.rational 0) = 1 := by
    norm_num [evalGlobalPhase, ExactAngle.eval]
  rw [phaseZero, one_smul]
  unfold warmRobinUniformSevenPrepareCircuit
  rw [evalPrimitiveCircuit_append, evalPrimitiveCircuit_append,
    compileUniformlyControlledRy_eval_controlledRyBlockMatrix,
    compileUniformlyControlledRy_eval_controlledRyBlockMatrix]
  simp [warmRobinUniformSevenPrepareMatrix, evalPrimitiveCircuit]

theorem warmRobinPaperSevenSelectorPrepare_unitary :
    warmRobinUniformSevenPrepareMatrix ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis 3) ℂ := by
  rw [← warmRobinUniformSevenPrepareProgram_eval]
  exact evalPrimitiveProgram_unitary _

theorem warmRobinUniformSevenPrepare_noOracleCalls :
    warmRobinUniformSevenPrepareProgram.resource.oracleCalls = 0 :=
  PrimitiveCircuit.resource_oracleCalls_eq_zero _

theorem warmRobinUniformSevenPrepare_counts :
    warmRobinUniformSevenPrepareCircuit.ryCount = 7 ∧
      warmRobinUniformSevenPrepareCircuit.cxCount = 8 := by
  constructor
  · simp only [warmRobinUniformSevenPrepareCircuit,
      PrimitiveCircuit.ryCount_append,
      PrimitiveCircuit.ryCount_singleton_ry,
      compileUniformlyControlledRy_ryCount]
    norm_num
  · simp only [warmRobinUniformSevenPrepareCircuit,
      PrimitiveCircuit.cxCount_append,
      PrimitiveCircuit.cxCount_singleton_ry,
      compileUniformlyControlledRy_cxCount]
    norm_num

/-- The source selector has eight physical states even though only seven are
active.  This prevents accidental use of `Fin 7` as a three-qubit register. -/
def warmRobinPaperSevenPaddedSlot (slot : Fin 8) : Option (Fin 7) :=
  if h : slot.val < 7 then some ⟨slot.val, h⟩ else none

theorem warmRobinPaperSevenPaddedSlot_seven :
    warmRobinPaperSevenPaddedSlot 7 = none := by decide

end QuantumBlockEncoding.Robin
