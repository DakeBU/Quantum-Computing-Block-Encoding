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

/-- Obligations outside the fixed benchmark: arbitrary size and literal-source routes. -/
def warmRobinGenericSourceOpenContracts : List String :=
  [ "arbitrary-n sparse access and uniform resource theorem"
  , "general piecewise f coefficient oracle"
  , "paper-literal arccos convention reconciliation"
  , "complete one-dimensional and multidimensional Hamiltonian composition"
  ]

theorem warmRobinGenericSourceOpenContracts_nonempty :
    warmRobinGenericSourceOpenContracts ≠ [] := by
  decide

/-- The fixed-N8, f=1, standard-RY-corrected source route is closed. -/
def warmRobinFixedN8SourceOpenContracts : List String := []

@[simp] theorem warmRobinFixedN8SourceOpenContracts_eq_nil :
    warmRobinFixedN8SourceOpenContracts = [] := rfl

/-- Historical compatibility alias for the generic, arbitrary-n and
paper-literal obligations. It does not describe the certified fixed-N8 route. -/
abbrev warmRobinSourceOpenContracts : List String :=
  warmRobinGenericSourceOpenContracts

theorem warmRobinSourceOpenContracts_nonempty :
    warmRobinSourceOpenContracts ≠ [] :=
  warmRobinGenericSourceOpenContracts_nonempty

end QuantumBlockEncoding.Robin
