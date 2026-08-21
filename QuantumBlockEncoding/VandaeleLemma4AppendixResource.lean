import QuantumBlockEncoding.VandaeleLadderContract
import Mathlib.Tactic

/-!
# Appendix A.1 resource transformation for Vandaele Lemma 4

Appendix A.1 starts from the logarithmic-depth ladder algorithm of [9]. The
source gives its positive-width CCX-count formula

`C(n) = 2n - 2 - floor(log2 n) - floor(log2(2n/3))`

and then applies Equation (58) to the middle recursive ladder. Vandaele's own
resource transformation is summarized by Equations (60)-(62):

* transformed CCX count is bounded by `3 (C(n)-n+1)`;
* transformed depth is bounded by `2 D(n)`;
* introduced clean/promise bits are `C(n)-n+1`.

There is one representation boundary worth making explicit. The paper's term
`floor(log2(2n/3))` can be negative at `n=1`, whereas `Nat.log2` is
natural-valued. Therefore the exact natural-number closed form below is treated
as source-faithful from `n >= 2`; smaller widths are only totalized so uniform
resource inequalities can be stated without partial functions.

The exact low-depth schedule `D(n)` belongs to the cited baseline [9]. This
module does not invent that schedule. Instead it formalizes Vandaele's resource
transformation and proves that any uniformly logarithmic baseline depth closes
the repository's Lemma-4 resource target.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma4AppendixResource

open VandaeleLadderContract

/-- Width regime in which the Appendix closed form is represented exactly by
natural-number logarithms. -/
def SourceFormulaRegime (n : Nat) : Prop := 2 <= n

/-- Source gate-count expression quoted from Appendix A.1 / [9], represented in
`Nat` on the source-formula regime. -/
def sourceBaselineGateCount (n : Nat) : Nat :=
  2 * n - 2 - Nat.log2 n - Nat.log2 ((2 * n) / 3)

/-- The source expression is no larger than `2n-2`. This upper bound is valid
for the totalized natural-number expression and is all that the later linear
resource closure needs. -/
theorem sourceBaselineGateCount_le
    (n : Nat) : sourceBaselineGateCount n <= 2 * n - 2 := by
  unfold sourceBaselineGateCount
  omega

/-- Equation-(60) transformed CCX-count envelope, totalized at n=0. -/
def appendixGateCount (n : Nat) : Nat :=
  if n = 0 then 0
  else 3 * (sourceBaselineGateCount n - n + 1)

/-- Equation-(61) transformed depth envelope. -/
def appendixDepth (baselineDepth : Nat -> Nat) (n : Nat) : Nat :=
  if n = 0 then 0 else 2 * baselineDepth n

/-- Equation-(62) introduced workspace/promise count. -/
def appendixAncillas (n : Nat) : Nat :=
  if n = 0 then 0 else sourceBaselineGateCount n - n + 1

/-- The Equation-(60) and Equation-(62) envelopes are tied exactly: each
introduced promise/work bit corresponds to one middle-ladder location, and the
Equation-(58) replacement uses at most three CCX gates per such location. -/
theorem appendixGateCount_eq_three_mul_ancillas
    (n : Nat) :
    appendixGateCount n = 3 * appendixAncillas n := by
  by_cases zero : n = 0 <;>
    simp [appendixGateCount, appendixAncillas, zero]

/-- Positive-width Appendix workspace fits inside n bits. -/
theorem appendixAncillas_le
    (n : Nat) : appendixAncillas n <= n := by
  by_cases zero : n = 0
  · simp [appendixAncillas, zero]
  · have positive : 1 <= n := Nat.one_le_iff_ne_zero.2 zero
    have source := sourceBaselineGateCount_le n
    simp [appendixAncillas, zero]
    omega

/-- Equation-(60) is uniformly linear. -/
theorem appendixGateCount_linear
    (n : Nat) : appendixGateCount n <= 3 * (n + 1) := by
  rw [appendixGateCount_eq_three_mul_ancillas]
  have workspaceBound := appendixAncillas_le n
  nlinarith

/-- Baseline depth resource target from the cited logarithmic-depth algorithm.
The constant is chosen once for the entire family. -/
def BaselineDepthTarget (baselineDepth : Nat -> Nat) : Prop :=
  ∃ depthConstant : Nat, ∀ n,
    baselineDepth n <= depthConstant * (Nat.log2 (n + 1) + 1)

/-- Appendix A.1 transformation closes the exact `LemmaFourUniformResourceTarget`.
The gate constant is explicit (3), the depth constant doubles, and the
Equation-(62) workspace is bounded by n. -/
theorem appendix_closes_lemmaFour_resources
    (baselineDepth : Nat -> Nat)
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
          2 * baselineDepth n <=
              2 * (depthConstant * (Nat.log2 (n + 1) + 1)) :=
            Nat.mul_le_mul_left 2 source
          _ = (2 * depthConstant) * (Nat.log2 (n + 1) + 1) := by ring
    · exact appendixAncillas_le n

/-- On the exact source-formula regime, Equations (60)-(62) reduce to the
closed forms printed in the Appendix. The theorem intentionally starts at
`n >= 2`; the `n=0,1` values above are totalized resource bookkeeping only. -/
theorem source_regime_formulas
    {n : Nat} (sourceRegime : SourceFormulaRegime n)
    (baselineDepth : Nat -> Nat) :
    appendixGateCount n =
        3 * (sourceBaselineGateCount n - n + 1) ∧
    appendixDepth baselineDepth n = 2 * baselineDepth n ∧
    appendixAncillas n = sourceBaselineGateCount n - n + 1 := by
  have nonzero : n ≠ 0 := by
    unfold SourceFormulaRegime at sourceRegime
    omega
  simp [appendixGateCount, appendixDepth, appendixAncillas, nonzero]

/-- Reader-facing source identity separating the transformation from the cited
baseline formula. -/
theorem source_regime_gate_workspace_relation
    {n : Nat} (_sourceRegime : SourceFormulaRegime n) :
    appendixGateCount n = 3 * appendixAncillas n :=
  appendixGateCount_eq_three_mul_ancillas n

end VandaeleLemma4AppendixResource
end QuantumBlockEncoding
