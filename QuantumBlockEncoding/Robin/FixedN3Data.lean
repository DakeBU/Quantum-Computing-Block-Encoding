import QuantumBlockEncoding.RobinEvolution
import QuantumBlockEncoding.BlockEncodingClassics
import Mathlib.Tactic

/-!
# Frozen N=8 Robin data

This module owns the arithmetic conventions shared by every fixed-instance
Robin route. It contains no circuit or resource claim.
-/

namespace QuantumBlockEncoding.Robin

open RobinEvolution

/-- The integer matrix `M = 12 A`, kept integral for finite decomposition proofs. -/
def warmRobinIntegerTarget : Matrix 8 8 Int := fun i j =>
  match i.val, j.val with
  | 0, 0 => -30 | 0, 1 => 32 | 0, 2 => -2
  | 1, 0 => 16 | 1, 1 => -31 | 1, 2 => 16 | 1, 3 => -1
  | 2, 0 => -1 | 2, 1 => 16 | 2, 2 => -30 | 2, 3 => 16 | 2, 4 => -1
  | 3, 1 => -1 | 3, 2 => 16 | 3, 3 => -30 | 3, 4 => 16 | 3, 5 => -1
  | 4, 2 => -1 | 4, 3 => 16 | 4, 4 => -30 | 4, 5 => 16 | 4, 6 => -1
  | 5, 3 => -1 | 5, 4 => 16 | 5, 5 => -30 | 5, 6 => 16 | 5, 7 => -1
  | 6, 4 => -1 | 6, 5 => 16 | 6, 6 => -31 | 6, 7 => 16
  | 7, 5 => -2 | 7, 6 => 32 | 7, 7 => -30
  | _, _ => 0

/-- Rational view of the frozen integer target. -/
def warmRobinIntegerTargetRat : Matrix 8 8 Rat := fun i j =>
  warmRobinIntegerTarget i j

/-- Exact fixed-instance identity `M = 12 A`. -/
theorem warmRobinIntegerTarget_eq_twelve_mul_target :
    warmRobinIntegerTargetRat = fun i j => 12 * warmRobinTarget i j := by
  funext i j
  fin_cases i <;> fin_cases j <;> native_decide

/-- Exact normalized target identity `A / (56/3) = M / 224`. -/
theorem warmRobin_normalized_eq_integer_div_224 :
    (fun i j => warmRobinTarget i j / warmRobinNormalizer) =
      fun i j => warmRobinIntegerTargetRat i j / 224 := by
  funext i j
  fin_cases i <;> fin_cases j <;> native_decide

/-- Signal-first clean embedding for the fixed `signal x system` convention. -/
def warmRobinCleanEmbed (system : Fin 8) : Fin (8 * 8) :=
  BlockEncodingClassics.productIndex (0 : Fin 8) system

theorem warmRobinCleanEmbed_value (system : Fin 8) :
    (warmRobinCleanEmbed system).val = system.val := by
  simp [warmRobinCleanEmbed, BlockEncodingClassics.productIndex]

end QuantumBlockEncoding.Robin
