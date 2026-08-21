import QuantumBlockEncoding.VandaeleLadderContract
import Mathlib.Tactic

/-!
# Appendix A.1 resource transformation for Vandaele Lemma 4

Appendix A.1 starts from the logarithmic-depth ladder algorithm of [9].  The
source gives its CCX-count function

`C(n) = 2n - 2 - floor(log2 n) - floor(log2(2n/3))`

and then applies Equation (58) to the middle recursive ladder.  Vandaele's own
resource transformation is summarized by Equations (60)-(62):

* transformed CCX count is bounded by `3 (C(n)-n+1)`;
* transformed depth is bounded by `2 D(n)`;
* introduced clean/promise bits are `C(n)-n+1`.

The exact low-depth schedule `D(n)` belongs to the cited baseline [9].  This
module does not invent that schedule.  Instead it formalizes the Vandaele
transformation and proves that any baseline logarithmic depth bound closes the
repository's Lemma-4 resource target.  The zero-step value is totalized to zero;
the Appendix source regime is positive n.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma4AppendixResource

open VandaeleLadderContract

/-- Source gate-count expression quoted from Appendix A.1 / [9]. -/
def sourceBaselineGateCount (n : Nat) : Nat :=
  2 * n - 2 - Nat.log2 n - Nat.log2 ((2 * n) / 3)

/-- The source expression is no larger than `2n-2`. -/
theorem sourceBaselineGateCount_le
    (n : Nat) : sourceBaselineGateCount n ≤ 2 * n - 2 := by
  unfold sourceBaselineGateCount
  omega

/-- Equation-(60) transformed CCX-count envelope, totalized at n=0. -/
def appendixGateCount (n : Nat) : Nat :=
  if n = 0 then 0
  else 3 * (sourceBaselineGateCount n - n + 1)

/-- Equation-(61) transformed depth envelope. -/
def appendixDepth (baselineDepth : Nat → Nat) (n : Nat) : Nat :=
  if n = 0 then 0 else 2 * baselineDepth n

/-- Equation-(62) introduced workspace/promise count. -/
def appendixAncillas (n : Nat) : Nat :=
  if n = 0 then 0 else sourceBaselineGateCount n - n + 1

/-- Positive-width Appendix workspace fits inside n bits. -/
theorem appendixAncillas_le
    (n : Nat) : appendixAncillas n ≤ n := by
  by_cases zero : n = 0
  · simp [appendixAncillas, zero]
  · have positive : 1 ≤ n := Nat.one_le_iff_ne_zero.2 zero
    have source := sourceBaselineGateCount_le n
    simp [appendixAncillas, zero]
    omega

/-- Equation-(60) is uniformly linear. -/
theorem appendixGateCount_linear
    (n : Nat) : appendixGateCount n ≤ 3 * (n + 1) := by
  by_cases zero : n = 0
  · simp [appendixGateCount, zero]
  · have positive : 1 ≤ n := Nat.one_le_iff_ne_zero.2 zero
    have source := sourceBaselineGateCount_le n
    simp [appendixGateCount, zero]
    omega

/-- Baseline depth resource target from the cited logarithmic-depth algorithm. -/
def BaselineDepthTarget (baselineDepth : Nat → Nat) : Prop :=
  ∃ depthConstant : Nat, ∀ n,
    baselineDepth n ≤ depthConstant * (Nat.log2 (n + 1) + 1)

/-- Appendix A.1 transformation closes the exact `LemmaFourUniformResourceTarget`.
The gate constant is explicit (3), depth constant doubles, and the Equation-(62)
workspace is bounded by n. -/
theorem appendix_closes_lemmaFour_resources
    (baselineDepth : Nat → Nat)
    (baseline : BaselineDepthTarget baselineDepth) :
    LemmaFourUniformResourceTarget
      appendixGateCount
      (appendixDepth baselineDepth)
      appendixAncillas := by
  rcases baseline with ⟨depthConstant, depthBound⟩
  refine ⟨3, 2 * depthConstant, ?_⟩
  intro n
  constructor
  · exact appendixGateCount_linear n
  · constructor
    · by_cases zero : n = 0
      · simp [appendixDepth, zero]
      · have source := depthBound n
        simp [appendixDepth, zero]
        calc
          2 * baselineDepth n ≤
              2 * (depthConstant * (Nat.log2 (n + 1) + 1)) :=
            Nat.mul_le_mul_left 2 source
          _ = (2 * depthConstant) * (Nat.log2 (n + 1) + 1) := by ring
    · exact appendixAncillas_le n

/-- Reader-facing source formulas on the positive regime. -/
theorem positive_source_formulas
    {n : Nat} (positive : 0 < n)
    (baselineDepth : Nat → Nat) :
    appendixGateCount n =
        3 * (sourceBaselineGateCount n - n + 1) ∧
    appendixDepth baselineDepth n = 2 * baselineDepth n ∧
    appendixAncillas n = sourceBaselineGateCount n - n + 1 := by
  have nonzero : n ≠ 0 := Nat.ne_of_gt positive
  simp [appendixGateCount, appendixDepth, appendixAncillas, nonzero]

end VandaeleLemma4AppendixResource
end QuantumBlockEncoding
