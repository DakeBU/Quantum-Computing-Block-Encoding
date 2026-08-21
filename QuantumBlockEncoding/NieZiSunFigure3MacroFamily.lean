import QuantumBlockEncoding.NieZiSunFigure3ExactRecurrence
import QuantumBlockEncoding.NieZiSunFigure3RecursiveFamily
import QuantumBlockEncoding.VandaeleLemma1Contract

/-!
# Proof-bearing Nie--Zi--Sun Figure-3 source family

`NieZiSunFigure3RecursiveFamily` proves the exact basis action of the recursive
five-step construction.  `NieZiSunFigure3ExactRecurrence` independently counts
the *same recursion tree* in the source macro model, where X and constant-order
multi-controlled X gates each have constant cost.

This module binds those two sides into one source certificate.  It still does
not identify the source macro model with an elementary gate set: the next layer
must synthesize the constant C^3X/C^4X blocks in the desired downstream model.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3MacroFamily

open NieZiSunFigure3ExactRecurrence
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Protocol
open VandaeleLemma1Contract

/-- Complete source-macro certificate at one control width. -/
structure MacroCertificate (n : Nat) where
  implementation : Equiv.Perm (PrimitiveBasis n × Fin 2 × Fin 2)
  macroSize : Nat
  macroDepth : Nat
  cleanAction : ∀ controls target,
    implementation (controls,0,target) =
      if allOne controls then
        (controls,0,flipBit target)
      else (controls,0,target)
  sizeEq : macroSize = NieZiSunFigure3ExactRecurrence.macroSize n
  depthEq : macroDepth = NieZiSunFigure3ExactRecurrence.macroDepth n

/-- Canonical certificate obtained from the actual recursive source semantics. -/
def certificate (n : Nat) : MacroCertificate n where
  implementation := fullFamily n
  macroSize := NieZiSunFigure3ExactRecurrence.macroSize n
  macroDepth := NieZiSunFigure3ExactRecurrence.macroDepth n
  cleanAction := fullFamily_clean_action n
  sizeEq := rfl
  depthEq := rfl

/-- The source certificate has explicit uniform resource envelopes. -/
theorem certificate_resources (n : Nat) :
    (certificate n).macroSize <= 11 * (n + 1) ∧
    (certificate n).macroDepth <= 5 * (Nat.log2 (n + 1) + 1) := by
  constructor
  · exact macroSize_linear n
  · exact macroDepth_logarithmic n

/-- Clean-ancilla source semantics in the exact target language later used by
Vandaele Definition 2.1. -/
theorem certificate_target_action
    (n : Nat) (controls : PrimitiveBasis n) (target : Fin 2) :
    let output := (certificate n).implementation (controls,0,target)
    output.1 = controls ∧ output.2.1 = 0 ∧
      output.2.2 =
        if allControlsOne controls then flipBit target else target := by
  dsimp [certificate]
  rw [fullFamily_clean_action]
  by_cases active : allOne controls
  · have sourceActive : allControlsOne controls := active
    simp [active, sourceActive]
  · have sourceInactive : ¬ allControlsOne controls := by
      intro source
      exact active source
    simp [active, sourceInactive]

end NieZiSunFigure3MacroFamily
end QuantumBlockEncoding
