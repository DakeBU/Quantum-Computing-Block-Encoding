import QuantumBlockEncoding.RobinMatrix
import Mathlib.Tactic

/-!
# Robin block-encoding evolution targets

Fixed contracts shared by the paper-seeded warm construction and its later
certified descendants.
-/

namespace QuantumBlockEncoding.RobinEvolution

/-- The fixed eight-dimensional homogeneous-Robin benchmark matrix. -/
def warmRobinTarget : Matrix 8 8 Rat := fun i j =>
  match i.val, j.val with
  | 0, 0 => -5 / 2
  | 0, 1 => 8 / 3
  | 0, 2 => -1 / 6
  | 1, 0 => 4 / 3
  | 1, 1 => -31 / 12
  | 1, 2 => 4 / 3
  | 1, 3 => -1 / 12
  | 2, 0 => -1 / 12
  | 2, 1 => 4 / 3
  | 2, 2 => -5 / 2
  | 2, 3 => 4 / 3
  | 2, 4 => -1 / 12
  | 3, 1 => -1 / 12
  | 3, 2 => 4 / 3
  | 3, 3 => -5 / 2
  | 3, 4 => 4 / 3
  | 3, 5 => -1 / 12
  | 4, 2 => -1 / 12
  | 4, 3 => 4 / 3
  | 4, 4 => -5 / 2
  | 4, 5 => 4 / 3
  | 4, 6 => -1 / 12
  | 5, 3 => -1 / 12
  | 5, 4 => 4 / 3
  | 5, 5 => -5 / 2
  | 5, 6 => 4 / 3
  | 5, 7 => -1 / 12
  | 6, 4 => -1 / 12
  | 6, 5 => 4 / 3
  | 6, 6 => -31 / 12
  | 6, 7 => 4 / 3
  | 7, 5 => -1 / 6
  | 7, 6 => 8 / 3
  | 7, 7 => -5 / 2
  | _, _ => 0

/-- Exact normalizer frozen by the warm/cold comparison contract. -/
def warmRobinNormalizer : Rat := 56 / 3

/-- The clean signal basis index is zero. -/
def warmRobinCleanSignalIndex : Nat := 0

/-- Signal-first flattening of a signal index and an eight-dimensional system index. -/
def warmRobinSignalFirstIndex (signal : Nat) (system : Fin 8) : Nat :=
  signal * 8 + system.val

/-- Evaluating the symbolic Robin stencil at homogeneous boundary data gives
the fixed rational benchmark entrywise. -/
theorem warmRobinTarget_eq_eval_robinDerivativeMatrix :
    warmRobinTarget = fun i j =>
      Coeff.evalWith (fun _ => 0)
        (Examples.RobinHeat.robinDerivativeMatrix 3 i j) := by
  funext i j
  fin_cases i <;> fin_cases j <;>
    native_decide

/-! ## Source-ordered warm circuit adapter

These declarations expose the paper-facing ten-block transcript and its fixed
`n = 3` register arithmetic. They do not assign matrices to the transcript
labels or prove oracle cleanup, unitarity, or block correctness.
-/

/-- Fixed paper-seeded parameters for the eight-dimensional warm instance. -/
def warmRobinParameters : GHL2025.OneTermRobinParameters :=
  Examples.RobinHeat.oneTermParameters 3

/-- The theorem-level register layout specialized to the warm instance. -/
def warmRobinSourceLayout : RegisterLayout :=
  GHL2025.oneTermRobinLayout warmRobinParameters

/-- The visible source register partition specialized to the warm instance. -/
def warmRobinVisiblePartition : GHL2025.RobinRegisterPartition :=
  GHL2025.defaultRobinRegisterPartition warmRobinParameters

/-- The source-ordered ten-block circuit transcript for the warm instance. -/
def warmRobinSourceCircuit : Circuit :=
  GHL2025.oneTermRobinTheoremFacingFig4Circuit

/-- The warm adapter preserves the exact source order of all ten blocks. -/
theorem warmRobinSourceCircuit_gateList :
    warmRobinSourceCircuit =
      [ Gate.oracleCall "H_W^(kappa)"
      , Gate.oracleCall "U_indic"
      , Gate.oracleCall "O_DT^S"
      , Gate.oracleCall "Ry_boundary"
      , Gate.oracleCall "O_DT^BS"
      , Gate.oracleCall "U_indic^dagger"
      , Gate.oracleCall "O_f"
      , Gate.swap 0 0
      , Gate.oracleCall "(O_D^BS)^dagger"
      , Gate.oracleCall "(H_W^(kappa))^dagger"
      ] := by
  exact GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList

/-- The source-facing warm transcript contains exactly ten blocks. -/
theorem warmRobinSourceCircuit_length :
    warmRobinSourceCircuit.length = 10 := by
  rw [warmRobinSourceCircuit_gateList]
  rfl

/-- Concrete fields of the fixed warm parameter adapter. -/
theorem warmRobinParameters_spec :
    warmRobinParameters.n = 3 ∧
      warmRobinParameters.kappa = 7 ∧
      warmRobinParameters.functionPieces = 1 ∧
      warmRobinParameters.polynomialDegreeCost = 1 := by
  native_decide

/-- The theorem layout is `(system, signal, pure ancilla) = (3, 9, 6)`. -/
theorem warmRobinSourceLayout_spec :
    warmRobinSourceLayout.systemQubits = 3 ∧
      warmRobinSourceLayout.signalQubits = 9 ∧
      warmRobinSourceLayout.pureAncillas = 6 := by
  native_decide

/-- The visible source partition has widths `(5, 1, 3, 0, 3, 1)`. -/
theorem warmRobinVisiblePartition_spec :
    warmRobinVisiblePartition.mfQubits = 5 ∧
      warmRobinVisiblePartition.indicatorQubit = 1 ∧
      warmRobinVisiblePartition.sparseIndexQubits = 3 ∧
      warmRobinVisiblePartition.odPureAncillaQubits = 0 ∧
      warmRobinVisiblePartition.systemQubits = 3 ∧
      warmRobinVisiblePartition.ancillaQubit = 1 := by
  native_decide

/-- The visible source register partition occupies thirteen qubits. -/
theorem warmRobinTotalQubits_eq :
    GHL2025.oneTermRobinTotalQubits warmRobinParameters = 13 := by
  native_decide

/-- The clean projection covers all ten non-system wires. -/
theorem warmRobinEffectiveSignalQubits_eq :
    GHL2025.effectiveRobinSignalQubits warmRobinParameters = 10 := by
  rw [GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace]
  native_decide

/-- The fixed warm indicator and its dagger form one self-inverse permutation pair. -/
theorem warmRobinIndicatorCertificate :
    (GHL2025.oneTermRobinGate_U_indic_dagger warmRobinParameters).matrix =
        (GHL2025.oneTermRobinGate_U_indic warmRobinParameters).matrix ∧
      (∀ j : Nat,
        GHL2025.indicatorOracleImage warmRobinParameters
          (GHL2025.indicatorOracleImage warmRobinParameters j) = j) ∧
      (∀ i : Fin (qubitDim
          (GHL2025.oneTermRobinTotalQubits warmRobinParameters)),
        ∃ j : Fin (qubitDim
            (GHL2025.oneTermRobinTotalQubits warmRobinParameters)),
          GHL2025.indicatorOracleMatrix warmRobinParameters i j = Coeff.rat 1 ∧
          ∀ j' : Fin (qubitDim
              (GHL2025.oneTermRobinTotalQubits warmRobinParameters)),
            GHL2025.indicatorOracleMatrix warmRobinParameters i j' = Coeff.rat 1 →
              j' = j) ∧
      (∀ j : Fin (qubitDim
          (GHL2025.oneTermRobinTotalQubits warmRobinParameters)),
        ∃ i : Fin (qubitDim
            (GHL2025.oneTermRobinTotalQubits warmRobinParameters)),
          GHL2025.indicatorOracleMatrix warmRobinParameters i j = Coeff.rat 1 ∧
          ∀ i' : Fin (qubitDim
              (GHL2025.oneTermRobinTotalQubits warmRobinParameters)),
            GHL2025.indicatorOracleMatrix warmRobinParameters i' j = Coeff.rat 1 →
              i' = i) := by
  have hbridge :=
    GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge
      warmRobinParameters
  have hperm :=
    GHL2025.indicatorOracleMatrix_is_permutation warmRobinParameters
  exact ⟨hbridge.1, GHL2025.indicatorOracleImage_self_inverse warmRobinParameters,
    hperm.1, hperm.2⟩

end QuantumBlockEncoding.RobinEvolution
