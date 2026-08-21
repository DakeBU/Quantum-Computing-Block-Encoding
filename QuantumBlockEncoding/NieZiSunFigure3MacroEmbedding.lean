import QuantumBlockEncoding.NieZiSunFigure3ReversibleProgram
import QuantumBlockEncoding.ReversibleWireEmbedding
import Mathlib.Tactic

/-!
# Physical embedding of the constant Figure-3 Toffoli macros

The recursive gate-list file writes Step 1 and Step 3 directly on the parent
register.  Here we identify those lists with the already truth-table-certified
fixed C^4X/C^3X macros.  This avoids re-proving Boolean gate algebra at every
recursive width.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3MacroEmbedding

open NieZiSunConstantToffoliMacros
open NieZiSunFigure3Protocol
open NieZiSunFigure3ReversibleProgram
open ReversibleWireEmbedding

/-- Step-1 fixed-macro wire map: controls 0..3, macro target -> A, macro dirty -> I5. -/
def step1MacroEmbed (n : Nat) (large : 5 <= n) :
    Fin 6 -> Fin (totalWidth n) := fun wire =>
  ![ (⟨0, by unfold totalWidth; omega⟩ : Fin (totalWidth n)),
     ⟨1, by unfold totalWidth; omega⟩,
     ⟨2, by unfold totalWidth; omega⟩,
     ⟨3, by unfold totalWidth; omega⟩,
     ancillaWire n,
     ⟨4, by unfold totalWidth; omega⟩ ] wire

/-- The six Step-1 physical wires are distinct. -/
theorem step1MacroEmbed_injective (n : Nat) (large : 5 <= n) :
    Function.Injective (step1MacroEmbed n large) := by
  intro left right equal
  fin_cases left <;> fin_cases right <;>
    simp [step1MacroEmbed, ancillaWire, totalWidth] at equal ⊢ <;> omega

/-- Step-1 source list is literally the embedded fixed C^4X macro. -/
theorem step1Program_eq_mapped
    (n : Nat) (large : 5 <= n) :
    step1Program n large =
      mapProgramWires (step1MacroEmbed n large)
        (step1MacroEmbed_injective n large) c4Program := by
  simp [step1Program, c4Program, step1MacroEmbed,
    mapProgramWires, mapGateWires, ancillaWire]

/-- Step-1 action on A is the four-head conjunction. -/
theorem step1Program_ancilla
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    evalReversibleProgram (step1Program n large) state (ancillaWire n) =
      if (∀ i : Fin 4, state ⟨i.val, by unfold totalWidth; omega⟩ = 1) then
        flipBit (state (ancillaWire n))
      else state (ancillaWire n) := by
  rw [step1Program_eq_mapped]
  have embedded := readEmbeddedState_eval_mapProgramWires
    (step1MacroEmbed n large) (step1MacroEmbed_injective n large)
    c4Program state
  have targetEq := congrFun embedded (4 : Fin 6)
  rw [c4Program_correct] at targetEq
  simpa [readEmbeddedState, step1MacroEmbed, c4Action,
    ancillaWire] using targetEq

/-- Any source control is restored by Step 1, including borrowed dirty I5. -/
theorem step1Program_preserves_control
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n))
    (wire : Fin n) :
    evalReversibleProgram (step1Program n large) state
        ⟨wire.val, by unfold totalWidth; omega⟩ =
      state ⟨wire.val, by unfold totalWidth; omega⟩ := by
  rw [step1Program_eq_mapped]
  by_cases named : wire.val < 5
  · interval_cases h : wire.val <;>
      have embedded := readEmbeddedState_eval_mapProgramWires
        (step1MacroEmbed n large) (step1MacroEmbed_injective n large)
        c4Program state <;>
      rw [c4Program_correct] at embedded <;>
      simpa [readEmbeddedState, step1MacroEmbed, c4Action,
        xBasisAction] using congrFun embedded
          (match h with
           | 0 => (0 : Fin 6)
           | 1 => (1 : Fin 6)
           | 2 => (2 : Fin 6)
           | 3 => (3 : Fin 6)
           | _ => (5 : Fin 6))
  · apply eval_mapProgramWires_outside
      (step1MacroEmbed n large) (step1MacroEmbed_injective n large)
      c4Program state
    intro local equal
    fin_cases local <;>
      simp [step1MacroEmbed, ancillaWire, totalWidth] at equal <;> omega

/-- Final target T is outside Step 1. -/
theorem step1Program_preserves_finalTarget
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    evalReversibleProgram (step1Program n large) state (finalTargetWire n) =
      state (finalTargetWire n) := by
  rw [step1Program_eq_mapped]
  apply eval_mapProgramWires_outside
    (step1MacroEmbed n large) (step1MacroEmbed_injective n large)
    c4Program state
  intro local equal
  fin_cases local <;>
    simp [step1MacroEmbed, ancillaWire, finalTargetWire, totalWidth] at equal <;> omega

/-- Step-3 fixed-macro map: I1,I3,A -> T with I2 borrowed dirty. -/
def step3MacroEmbed (n : Nat) (large : 5 <= n) :
    Fin 5 -> Fin (totalWidth n) := fun wire =>
  ![ (⟨0, by unfold totalWidth; omega⟩ : Fin (totalWidth n)),
     ⟨2, by unfold totalWidth; omega⟩,
     ancillaWire n,
     finalTargetWire n,
     ⟨1, by unfold totalWidth; omega⟩ ] wire

/-- Step-3 named wires are distinct. -/
theorem step3MacroEmbed_injective (n : Nat) (large : 5 <= n) :
    Function.Injective (step3MacroEmbed n large) := by
  intro left right equal
  fin_cases left <;> fin_cases right <;>
    simp [step3MacroEmbed, ancillaWire, finalTargetWire, totalWidth] at equal ⊢ <;> omega

/-- Step-3 list is the mapped fixed C^3X macro. -/
theorem step3Program_eq_mapped
    (n : Nat) (large : 5 <= n) :
    step3Program n large =
      mapProgramWires (step3MacroEmbed n large)
        (step3MacroEmbed_injective n large) c3Program := by
  simp [step3Program, c3Program, step3MacroEmbed,
    mapProgramWires, mapGateWires, ancillaWire, finalTargetWire]

/-- Step 3 flips T exactly when I1,I3,A are one. -/
theorem step3Program_target
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    evalReversibleProgram (step3Program n large) state (finalTargetWire n) =
      if state ⟨0, by unfold totalWidth; omega⟩ = 1 ∧
          state ⟨2, by unfold totalWidth; omega⟩ = 1 ∧
          state (ancillaWire n) = 1 then
        flipBit (state (finalTargetWire n))
      else state (finalTargetWire n) := by
  rw [step3Program_eq_mapped]
  have embedded := readEmbeddedState_eval_mapProgramWires
    (step3MacroEmbed n large) (step3MacroEmbed_injective n large)
    c3Program state
  have targetEq := congrFun embedded (3 : Fin 5)
  rw [c3Program_correct] at targetEq
  simpa [readEmbeddedState, step3MacroEmbed, c3Action,
    ancillaWire, finalTargetWire] using targetEq

/-- Step 3 restores every source control and A; only T may change. -/
theorem step3Program_preserves_nonTarget
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n))
    (wire : Fin (n + 1)) :
    evalReversibleProgram (step3Program n large) state
        ⟨wire.val, by unfold totalWidth; omega⟩ =
      state ⟨wire.val, by unfold totalWidth; omega⟩ := by
  rw [step3Program_eq_mapped]
  by_cases hit :
      ∃ local : Fin 5, step3MacroEmbed n large local =
        ⟨wire.val, by unfold totalWidth; omega⟩
  · rcases hit with ⟨local,rfl⟩
    have embedded := readEmbeddedState_eval_mapProgramWires
      (step3MacroEmbed n large) (step3MacroEmbed_injective n large)
      c3Program state
    rw [c3Program_correct] at embedded
    have coordinate := congrFun embedded local
    fin_cases local <;>
      simpa [readEmbeddedState, step3MacroEmbed, c3Action,
        xBasisAction, ancillaWire, finalTargetWire] using coordinate
  · apply eval_mapProgramWires_outside
      (step3MacroEmbed n large) (step3MacroEmbed_injective n large)
      c3Program state
    intro local equal
    exact hit ⟨local,equal⟩

end NieZiSunFigure3MacroEmbedding
end QuantumBlockEncoding
