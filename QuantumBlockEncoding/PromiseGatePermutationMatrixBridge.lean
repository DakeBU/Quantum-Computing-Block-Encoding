import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.PromiseGateUnitary
import QuantumBlockEncoding.Robin.ComplexLCU
import Mathlib.Tactic

/-!
# Reversible promise gates embed into the matrix-level source definitions

Most arithmetic proofs in ASPBE use computational-basis permutations. The
source Definitions 3.1 and 3.2 are arbitrary unitaries. This module proves the
bridge: taking the permutation matrix of a reversible weak/strong promise gate
produces a matrix-level weak/strong promise gate with the permutation matrix of
the target unitary.

Thus the reversible formalization is a genuine specialization of the general
unitary promise-gate layer, not a separate notion with the same name.
-/

namespace QuantumBlockEncoding
namespace PromiseGatePermutationMatrixBridge

open PromiseGateOptimization
open PromiseGateUnitary
open QuantumBlockEncoding.Robin.ComplexLCU

/-- Reversible weak promise semantics imply the matrix-level weak promise
contract. -/
theorem weakPermutation_to_matrix
    {ρ α : Type*}
    [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (weak : WeakPromiseSpec cleanPromise implementation target) :
    WeakPromiseMatrixSpec
      cleanPromise
      (equivPermutationMatrix implementation)
      (equivPermutationMatrix target) := by
  constructor
  · exact equivPermutationMatrix_unitary target
  · constructor
    · exact equivPermutationMatrix_unitary implementation
    · intro promiseOut targetOut targetIn
      unfold equivPermutationMatrix
      rw [weak targetIn]
      by_cases clean : promiseOut = cleanPromise
      · subst promiseOut
        simp
      · have miss :
          (promiseOut, targetOut) ≠ (cleanPromise, target targetIn) := by
          intro equal
          exact clean (congrArg Prod.fst equal)
        simp [clean, miss]

/-- Reversible strong promise semantics imply the matrix-level QMUX/block
contract. -/
theorem strongPermutation_to_matrix
    {ρ α : Type*}
    [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    StrongPromiseMatrixSpec
      cleanPromise
      (equivPermutationMatrix implementation)
      (equivPermutationMatrix target) := by
  constructor
  · exact equivPermutationMatrix_unitary target
  · constructor
    · exact equivPermutationMatrix_unitary implementation
    · constructor
      · intro promiseOut targetOut promiseIn targetIn different
        have restored := strong.2 promiseIn targetIn
        have miss :
            (promiseOut, targetOut) ≠ implementation (promiseIn, targetIn) := by
          intro equal
          apply different
          calc
            promiseOut = (implementation (promiseIn, targetIn)).1 :=
              congrArg Prod.fst equal
            _ = promiseIn := restored
        unfold equivPermutationMatrix
        simp [miss]
      · intro targetOut targetIn
        unfold equivPermutationMatrix
        rw [strong.1 targetIn]
        simp

/-- The bridge respects the source statement that every strong promise gate is
weak. -/
theorem strongPermutation_to_weakMatrix
    {ρ α : Type*}
    [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    WeakPromiseMatrixSpec
      cleanPromise
      (equivPermutationMatrix implementation)
      (equivPermutationMatrix target) := by
  exact strong_implies_weak cleanPromise
    (equivPermutationMatrix implementation)
    (equivPermutationMatrix target)
    (strongPermutation_to_matrix cleanPromise implementation target strong)

end PromiseGatePermutationMatrixBridge
end QuantumBlockEncoding
