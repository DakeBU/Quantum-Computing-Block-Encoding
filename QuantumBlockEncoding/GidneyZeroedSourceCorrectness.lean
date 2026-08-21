import QuantumBlockEncoding.GidneyZeroedCleanTargetAction
import QuantumBlockEncoding.GidneyZeroedWorkspaceRestorationGlobal
import QuantumBlockEncoding.PrimitiveBasisLENumeric
import Mathlib.Tactic

/-!
# Arbitrary-width correctness of the gate-level Gidney source program

All circuit-specific work is complete before this file:

* arbitrary dirty workspace is restored exactly;
* on a clean workspace, every target bit is the canonical binary increment bit.

This final layer is pure arithmetic.  It converts the bitwise theorem to the
public `basisNat` contract using the arbitrary-width little-endian sum formula
and the subtraction-free carry telescoping identity.  The overflow carry is a
multiple of `2^n`, so it vanishes modulo the target dimension.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedSourceCorrectness

open BinaryCarryTelescoping
open ComparatorIncrementerGeneral
open GidneyZeroedCarryCompute
open GidneyZeroedCleanTargetAction
open GidneyZeroedSourceProgram
open GidneyZeroedWorkspaceRestorationGlobal
open PrimitiveBasisLENumeric

/-- Canonical output basis determined by the source target and binary carry
chain. -/
def incrementBasis
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    PrimitiveBasis (targetWidth carryCount) :=
  fun wire => incrementOutput (targetStream carryCount target) wire.val

/-- Input numeric value as a finite range sum over the totalized target stream. -/
theorem basisNat_eq_targetStream_sum
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    basisNat (targetWidth carryCount) target =
      ∑ i ∈ Finset.range (targetWidth carryCount),
        (targetStream carryCount target i).val * 2 ^ i := by
  rw [basisNat_eq_sum]
  rw [Finset.sum_fin_eq_sum_range]
  apply Finset.sum_congr rfl
  intro i member
  have bound : i < targetWidth carryCount := Finset.mem_range.mp member
  simp [targetStream, bound]

/-- Output numeric value as the corresponding range sum of canonical increment
bits. -/
theorem basisNat_incrementBasis_eq_sum
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    basisNat (targetWidth carryCount) (incrementBasis carryCount target) =
      ∑ i ∈ Finset.range (targetWidth carryCount),
        (incrementOutput (targetStream carryCount target) i).val * 2 ^ i := by
  rw [basisNat_eq_sum]
  rw [Finset.sum_fin_eq_sum_range]
  apply Finset.sum_congr rfl
  intro i member
  simp [incrementBasis]

/-- The canonical increment basis has exactly the modular successor value. -/
theorem incrementBasis_modular_value
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    basisNat (targetWidth carryCount) (incrementBasis carryCount target) =
      (basisNat (targetWidth carryCount) target + 1) %
        gridSize (targetWidth carryCount) := by
  let n := targetWidth carryCount
  let input := targetStream carryCount target
  have weighted := increment_weighted_sum_nat input n
  have inputSum :
      (∑ i ∈ Finset.range n, (input i).val * 2 ^ i) =
        basisNat n target := by
    simpa [n, input] using
      (basisNat_eq_targetStream_sum carryCount target).symm
  have outputSum :
      (∑ i ∈ Finset.range n,
        (incrementOutput input i).val * 2 ^ i) =
        basisNat n (incrementBasis carryCount target) := by
    simpa [n, input] using
      (basisNat_incrementBasis_eq_sum carryCount target).symm
  rw [inputSum, outputSum] at weighted
  have modulusEq : gridSize n = 2 ^ n := by
    rfl
  rw [← modulusEq] at weighted
  have outputBound :
      basisNat n (incrementBasis carryCount target) < gridSize n := by
    unfold basisNat
    exact (primitiveBasisLEEquiv n (incrementBasis carryCount target)).isLt
  have reduced := congrArg (fun value : Nat => value % gridSize n) weighted
  have modulusPositive : 0 < gridSize n := Nat.pow_pos (by decide)
  simpa [Nat.add_mod, Nat.mul_mod, Nat.mod_eq_of_lt outputBound,
    modulusPositive] using reduced

/-- Bitwise source theorem repackaged as equality with the canonical increment
basis. -/
theorem runSource_clean_target_eq_incrementBasis
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    (runSource carryCount (target, zeroWorkspace carryCount)).1 =
      incrementBasis carryCount target := by
  funext wire
  exact runSource_clean_target_bit carryCount target wire

/-- Arbitrary-width clean-branch modular increment theorem for the actual source
gate list. -/
theorem runSource_clean_correct
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    basisNat (targetWidth carryCount)
        (runSource carryCount (target, zeroWorkspace carryCount)).1 =
      (basisNat (targetWidth carryCount) target + 1) %
        gridSize (targetWidth carryCount) := by
  rw [runSource_clean_target_eq_incrementBasis]
  exact incrementBasis_modular_value carryCount target

/-- Clean workspace is returned to zero as a specialization of the arbitrary
workspace restoration theorem. -/
theorem runSource_clean_restores_workspace
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    (runSource carryCount (target, zeroWorkspace carryCount)).2 =
      zeroWorkspace carryCount :=
  runSource_restores_workspace carryCount target (zeroWorkspace carryCount)

/-- Complete arbitrary-width source certificate: clean-branch modular successor
plus unconditional workspace restoration. -/
theorem source_correctness_pair
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (workspace : PrimitiveBasis carryCount) :
    (basisNat (targetWidth carryCount)
        (runSource carryCount (target, zeroWorkspace carryCount)).1 =
      (basisNat (targetWidth carryCount) target + 1) %
        gridSize (targetWidth carryCount)) ∧
    (runSource carryCount (target, workspace)).2 = workspace := by
  exact ⟨runSource_clean_correct carryCount target,
    runSource_restores_workspace carryCount target workspace⟩

end GidneyZeroedSourceCorrectness
end QuantumBlockEncoding