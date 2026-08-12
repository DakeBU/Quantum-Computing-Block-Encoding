import QuantumBlockEncoding.Robin.FixedN3Data
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse
import Mathlib.Tactic

/-!
# Fixed Robin source baseline conventions

The paper transcript remains T0/T1. This module makes the rotation convention
and the full three-wire register swap explicit without promoting the source
route to a verified block encoding.
-/

namespace QuantumBlockEncoding.Robin

/-- Literal angle printed in the source-side formula. -/
noncomputable def warmRobinPrintedBoundaryAngle (ratio : Real) : Real :=
  Real.arccos ratio

/-- Angle required by the standard `Ry(theta)` half-angle convention. -/
noncomputable def warmRobinStandardRyBoundaryAngle (ratio : Real) : Real :=
  2 * Real.arccos ratio

theorem warmRobinStandardRyBoundaryAngle_eq_twice_printed (ratio : Real) :
    warmRobinStandardRyBoundaryAngle ratio =
      2 * warmRobinPrintedBoundaryAngle ratio := by
  rfl

/-- The actual logical wire pairs for swapping two three-qubit registers. -/
def warmRobinRegisterSwapPairs : List (Nat × Nat) :=
  [(0, 3), (1, 4), (2, 5)]

/-- Executable transcript fragment: three real SWAPs, never `swap 0 0`. -/
def warmRobinRegisterSwapCircuit : Circuit :=
  [Gate.swap 0 3, Gate.swap 1 4, Gate.swap 2 5]

theorem warmRobinRegisterSwapCircuit_gateList :
    warmRobinRegisterSwapCircuit =
      [Gate.swap 0 3, Gate.swap 1 4, Gate.swap 2 5] := by
  rfl

theorem warmRobinRegisterSwapCircuit_length :
    warmRobinRegisterSwapCircuit.length = 3 := by
  rfl

/-- Fixed wire-index action induced by the register swap. -/
def warmRobinRegisterSwapWire (wire : Fin 6) : Fin 6 :=
  if h : wire.val < 3 then
    ⟨wire.val + 3, by omega⟩
  else
    ⟨wire.val - 3, by fin_cases wire <;> decide⟩

theorem warmRobinRegisterSwapWire_involution (wire : Fin 6) :
    warmRobinRegisterSwapWire (warmRobinRegisterSwapWire wire) = wire := by
  fin_cases wire <;> decide

theorem warmRobinRegisterSwapWire_bijective :
    Function.Bijective warmRobinRegisterSwapWire := by
  constructor
  · intro x y equality
    simpa only [warmRobinRegisterSwapWire_involution] using
      congrArg warmRobinRegisterSwapWire equality
  · intro y
    exact ⟨warmRobinRegisterSwapWire y, warmRobinRegisterSwapWire_involution y⟩

/-- Machine-readable list of obligations preventing source-route promotion. -/
def warmRobinSourceOpenContracts : List String :=
  [ "exact seven-slot PREPARE including selector state 7"
  , "sparse derivative-amplitude loader and inverse"
  , "corrected standard-Ry boundary loader"
  , "pre-SWAP sparse access and transported post-SWAP cleanup"
  , "homogeneous coefficient-loader identity specialization"
  , "whole-circuit unitarity and exact clean-block theorem"
  , "primitive expansion under the common resource convention"
  ]

theorem warmRobinSourceOpenContracts_nonempty :
    warmRobinSourceOpenContracts ≠ [] := by
  decide

end QuantumBlockEncoding.Robin
