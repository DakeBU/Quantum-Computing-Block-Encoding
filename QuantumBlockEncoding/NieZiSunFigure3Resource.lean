import QuantumBlockEncoding.NieZiSunFigure3Protocol
import Mathlib.Data.Nat.Log
import Mathlib.Tactic

/-!
# Nie--Zi--Sun Figure 3: resource recurrence closure

The displayed proof treats even n for notational convenience and says the odd
case is identical.  A uniform split is obtained by distributing the `n-4` tail
controls as evenly as possible between the two parallel recursive branches.
The larger branch has

`r(n) = floor((n-3)/2)`

controls.  Figure 3 then has the source recurrences

* depth: one recursive depth plus constant local depth;
* size: two recursive sizes plus constant local size.

This file proves directly that any concrete B2 circuit family satisfying those
finite recurrences has O(log n) depth and O(n) size.  The constants of the
finite Step-1/3/5 B2 decompositions are parameters, so the theorem does not
silently identify B2 with ASPBE's `{X,CX,CCX}` gate model.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3Resource

/-- Left tail after reserving four conditional-clean controls. -/
def leftTailWidth (n : Nat) : Nat := (n - 4) / 2

/-- Right tail gets the remainder. -/
def rightTailWidth (n : Nat) : Nat :=
  n - 4 - leftTailWidth n

/-- The two physical recursive tails partition exactly the controls remaining
after I1..I4.  This is shared by the semantic control split, actual gate
embedding, and resource recurrence. -/
theorem tailWidths_sum (n : Nat) :
    leftTailWidth n + rightTailWidth n = n - 4 := by
  unfold leftTailWidth rightTailWidth
  omega

/-- Larger recursive control count. -/
def recursiveWidth (n : Nat) : Nat := (n - 3) / 2

/-- Both actual branches fit in the common recurrence parameter. -/
theorem tails_le_recursive (n : Nat) :
    leftTailWidth n ≤ recursiveWidth n ∧
      rightTailWidth n ≤ recursiveWidth n := by
  unfold leftTailWidth rightTailWidth recursiveWidth
  omega

/-- Recursive control count strictly decreases once Figure 3 is nontrivial. -/
theorem recursiveWidth_lt
    {n : Nat} (large : 5 ≤ n) : recursiveWidth n < n := by
  unfold recursiveWidth
  omega

/-- The recursive rank has enough contraction to pay one constant depth layer. -/
theorem recursive_log_drop
    {n : Nat} (large : 5 ≤ n) :
    Nat.log2 (recursiveWidth n + 1) + 1 ≤ Nat.log2 n := by
  have halfBound : recursiveWidth n + 1 ≤ n / 2 := by
    unfold recursiveWidth
    omega
  have logarithm :
      Nat.log2 (recursiveWidth n + 1) ≤ Nat.log2 (n / 2) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right halfBound
  have halfIdentity : Nat.log2 n = Nat.log2 (n / 2) + 1 := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_of_one_lt_of_le (by omega) (by omega)
  omega

/-- Two recursive branch state-spaces leave linear slack for O(1) local work. -/
theorem recursive_size_slack
    {n : Nat} (large : 5 ≤ n) :
    2 * (recursiveWidth n + 1) + 1 ≤ n := by
  unfold recursiveWidth
  omega

/-- Source-style recurrence assumptions for one concrete circuit family. -/
def FigureThreeResourceRecurrence
    (depth size : Nat → Nat)
    (baseDepth baseSize localDepth localSize : Nat) : Prop :=
  (∀ n, n < 5 → depth n ≤ baseDepth) ∧
  (∀ n, n < 5 → size n ≤ baseSize * (n + 1)) ∧
  (∀ n, 5 ≤ n →
    depth n ≤ depth (recursiveWidth n) + localDepth) ∧
  (∀ n, 5 ≤ n →
    size n ≤ 2 * size (recursiveWidth n) + localSize)

/-- Uniform source resource target for Nie--Zi--Sun Theorem 1. -/
def FigureThreeResourceTarget
    (depth size : Nat → Nat) : Prop :=
  (∃ constant : Nat, ∀ n,
    depth n ≤ constant * (Nat.log2 (n + 1) + 1)) ∧
  (∃ constant : Nat, ∀ n,
    size n ≤ constant * (n + 1))

/-- Figure-3 depth recurrence closes to O(log n). -/
theorem depth_closure
    (depth : Nat → Nat)
    (baseDepth localDepth : Nat)
    (base : ∀ n, n < 5 → depth n ≤ baseDepth)
    (step : ∀ n, 5 ≤ n →
      depth n ≤ depth (recursiveWidth n) + localDepth) :
    ∃ constant : Nat, ∀ n,
      depth n ≤ constant * (Nat.log2 (n + 1) + 1) := by
  let constant := max baseDepth localDepth
  refine ⟨constant, ?_⟩
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 5
      · have source := base n small
        have baseLe : baseDepth ≤ constant := Nat.le_max_left _ _
        have rankPos : 1 ≤ Nat.log2 (n + 1) + 1 := by omega
        exact source.trans (by nlinarith)
      · have large : 5 ≤ n := by omega
        have smaller := recursiveWidth_lt large
        have recursive := induction (recursiveWidth n) smaller
        have source := step n large
        have localLe : localDepth ≤ constant := Nat.le_max_right _ _
        have rankDrop := recursive_log_drop large
        have nRankMono : Nat.log2 n ≤ Nat.log2 (n + 1) := by
          rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
          exact Nat.log_mono_right (by omega)
        calc
          depth n ≤ depth (recursiveWidth n) + localDepth := source
          _ ≤ constant * (Nat.log2 (recursiveWidth n + 1) + 1) +
              constant := Nat.add_le_add recursive localLe
          _ ≤ constant * Nat.log2 n + constant := by
            exact Nat.add_le_add_right
              (Nat.mul_le_mul_left constant rankDrop) constant
          _ = constant * (Nat.log2 n + 1) := by ring
          _ ≤ constant * (Nat.log2 (n + 1) + 1) := by
            exact Nat.mul_le_mul_left constant (by omega)

/-- Figure-3 size recurrence closes to O(n). -/
theorem size_closure
    (size : Nat → Nat)
    (baseSize localSize : Nat)
    (base : ∀ n, n < 5 → size n ≤ baseSize * (n + 1))
    (step : ∀ n, 5 ≤ n →
      size n ≤ 2 * size (recursiveWidth n) + localSize) :
    ∃ constant : Nat, ∀ n,
      size n ≤ constant * (n + 1) := by
  let constant := max baseSize localSize
  refine ⟨constant, ?_⟩
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases small : n < 5
      · have source := base n small
        have baseLe : baseSize ≤ constant := Nat.le_max_left _ _
        exact source.trans (Nat.mul_le_mul_right (n + 1) baseLe)
      · have large : 5 ≤ n := by omega
        have smaller := recursiveWidth_lt large
        have recursive := induction (recursiveWidth n) smaller
        have source := step n large
        have localLe : localSize ≤ constant := Nat.le_max_right _ _
        have slack := recursive_size_slack large
        calc
          size n ≤ 2 * size (recursiveWidth n) + localSize := source
          _ ≤ 2 * (constant * (recursiveWidth n + 1)) + constant :=
            Nat.add_le_add (Nat.mul_le_mul_left 2 recursive) localLe
          _ = constant * (2 * (recursiveWidth n + 1) + 1) := by ring
          _ ≤ constant * n := Nat.mul_le_mul_left constant slack
          _ ≤ constant * (n + 1) :=
            Nat.mul_le_mul_left constant (by omega)

/-- Main asymptotic closure for the exact source recurrence. -/
theorem recurrence_closure
    (depth size : Nat → Nat)
    (baseDepth baseSize localDepth localSize : Nat)
    (recurrence :
      FigureThreeResourceRecurrence depth size
        baseDepth baseSize localDepth localSize) :
    FigureThreeResourceTarget depth size := by
  rcases recurrence with ⟨baseD,baseS,stepD,stepS⟩
  exact ⟨depth_closure depth baseDepth localDepth baseD stepD,
    size_closure size baseSize localSize baseS stepS⟩

end NieZiSunFigure3Resource
end QuantumBlockEncoding
