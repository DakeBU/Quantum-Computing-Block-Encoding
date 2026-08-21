import QuantumBlockEncoding.VandaeleTheorem5Resource
import Mathlib.Tactic

/-!
# Closing Vandaele Theorem-5 recurrences

This file discharges the master-recurrence leaf left by Equations (49)-(50).
For the exact floor/ceiling split, use the recursion rank

`halfRank(n) = log2(n-1)+1`.

For `n>=3`, both actual halves satisfy

`halfRank(half)+1 <= halfRank(n)`.

That one-step rank drop is enough for direct strong induction:

* a linear local gate layer plus both recursive halves sums to O(n log n);
* a logarithmic local depth layer plus the maximum recursive half sums to
  O(log^2 n).

Finite widths 0,1,2 are absorbed into the final uniform constants.
-/

namespace QuantumBlockEncoding
namespace VandaeleTheorem5RecurrenceClosure

open ComparatorIncrementerTheorem4DepthBound
open VandaeleLemma5SplitBudget
open VandaeleTheorem5Resource

/-- Rank adapted to floor/ceiling halving. -/
def halfRank (n : Nat) : Nat := Nat.log2 (n - 1) + 1

@[simp] theorem halfRank_one : halfRank 1 = 1 := by
  simp [halfRank]

@[simp] theorem halfRank_two : halfRank 2 = 1 := by
  simp [halfRank]

/-- The adapted rank is bounded by the repository's standard logarithmic rank. -/
theorem halfRank_le_logRank (n : Nat) : halfRank n ≤ logRank n := by
  unfold halfRank logRank
  have value : n - 1 ≤ n + 1 := by omega
  have logarithm : Nat.log2 (n - 1) ≤ Nat.log2 (n + 1) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right value
  omega

/-- Ceiling half minus one is bounded by half of n-1. -/
theorem upperHalf_sub_one_le
    {n : Nat} (large : 3 ≤ n) :
    upperHalf n - 1 ≤ (n - 1) / 2 := by
  unfold upperHalf lowerHalf
  omega

/-- Floor half is no larger than ceiling half. -/
theorem lowerHalf_le_upperHalf (n : Nat) : lowerHalf n ≤ upperHalf n := by
  unfold lowerHalf upperHalf
  omega

/-- The adapted rank drops by at least one on the ceiling half. -/
theorem halfRank_upper_drop
    {n : Nat} (large : 3 ≤ n) :
    halfRank (upperHalf n) + 1 ≤ halfRank n := by
  have halfArg := upperHalf_sub_one_le large
  have logMono :
      Nat.log2 (upperHalf n - 1) ≤ Nat.log2 ((n - 1) / 2) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right halfArg
  have baseFits : 2 ≤ n - 1 := by omega
  have splitLog :
      Nat.log 2 (n - 1) = Nat.log 2 ((n - 1) / 2) + 1 :=
    Nat.log_of_one_lt_of_le Nat.one_lt_two baseFits
  unfold halfRank
  rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
  rw [splitLog]
  omega

/-- The floor half inherits the same one-step rank drop. -/
theorem halfRank_lower_drop
    {n : Nat} (large : 3 ≤ n) :
    halfRank (lowerHalf n) + 1 ≤ halfRank n := by
  have order := lowerHalf_le_upperHalf n
  have argument : lowerHalf n - 1 ≤ upperHalf n - 1 := by omega
  have logarithm :
      Nat.log2 (lowerHalf n - 1) ≤ Nat.log2 (upperHalf n - 1) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right argument
  have upperDrop := halfRank_upper_drop large
  unfold halfRank at upperDrop ⊢
  omega

/-- Standard source `logRank` is at most one larger than the halving rank for
`n>=3`. -/
theorem logRank_le_halfRank_add_one
    {n : Nat} (large : 3 ≤ n) :
    logRank n ≤ halfRank n + 1 := by
  have value : n + 1 ≤ 2 * (n - 1) := by omega
  have logMono :
      Nat.log 2 (n + 1) ≤ Nat.log 2 (2 * (n - 1)) :=
    Nat.log_mono_right value
  have nonzero : n - 1 ≠ 0 := by omega
  have productLog :
      Nat.log 2 ((n - 1) * 2) = Nat.log 2 (n - 1) + 1 :=
    Nat.log_mul_base Nat.one_lt_two nonzero
  have comm : 2 * (n - 1) = (n - 1) * 2 := by ring
  rw [comm, productLog] at logMono
  unfold logRank halfRank
  rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
  omega

/-- Positive nonbase halves. -/
theorem halves_positive
    {n : Nat} (large : 3 ≤ n) :
    1 ≤ lowerHalf n ∧ 1 ≤ upperHalf n := by
  unfold lowerHalf upperHalf
  omega

/-- Both halves are strictly smaller in the recursive regime. -/
theorem halves_lt_self
    {n : Nat} (large : 3 ≤ n) :
    lowerHalf n < n ∧ upperHalf n < n := by
  unfold lowerHalf upperHalf
  omega

/-- Gate recurrence closes to an explicit O(n log n) bound for every positive
width. -/
theorem gate_positive_width_upper
    (gate localGate : Nat → Nat)
    (localConstant baseConstant : Nat)
    (localBound : ∀ n, localGate n ≤ localConstant * (n + 1))
    (baseOne : gate 1 ≤ baseConstant)
    (baseTwo : gate 2 ≤ 2 * baseConstant)
    (recurrence : GateRecurrenceUpper gate localGate) :
    ∀ n, 1 ≤ n →
      gate n ≤
        (2 * localConstant) * n * halfRank n + baseConstant * n := by
  intro n positive
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases one : n = 1
      · subst n
        simpa using baseOne.trans (by omega)
      by_cases two : n = 2
      · subst n
        simpa using baseTwo.trans (by omega)
      have large : 3 ≤ n := by omega
      have halvesPos := halves_positive large
      have halvesLt := halves_lt_self large
      have upperIH := induction (upperHalf n) halvesLt.2 halvesPos.2
      have lowerIH := induction (lowerHalf n) halvesLt.1 halvesPos.1
      have step := recurrence n (by omega)
      have local := localBound n
      have upperRank := halfRank_upper_drop large
      have lowerRank := halfRank_lower_drop large
      have partition := halves_partition n
      have recursiveBound :
          gate (upperHalf n) + gate (lowerHalf n) ≤
            (2 * localConstant) *
              ((upperHalf n) * halfRank (upperHalf n) +
                (lowerHalf n) * halfRank (lowerHalf n)) +
              baseConstant * n := by
        calc
          gate (upperHalf n) + gate (lowerHalf n) ≤
              ((2 * localConstant) * (upperHalf n) * halfRank (upperHalf n) +
                baseConstant * upperHalf n) +
              ((2 * localConstant) * (lowerHalf n) * halfRank (lowerHalf n) +
                baseConstant * lowerHalf n) :=
            Nat.add_le_add upperIH lowerIH
          _ = (2 * localConstant) *
                ((upperHalf n) * halfRank (upperHalf n) +
                  (lowerHalf n) * halfRank (lowerHalf n)) +
                baseConstant * n := by
            rw [show upperHalf n + lowerHalf n = n by
              rw [Nat.add_comm]; exact partition]
            ring
      have rankMass :
          (upperHalf n) * halfRank (upperHalf n) +
              (lowerHalf n) * halfRank (lowerHalf n) + n ≤
            n * halfRank n := by
        have upperScaled := Nat.mul_le_mul_left (upperHalf n) upperRank
        have lowerScaled := Nat.mul_le_mul_left (lowerHalf n) lowerRank
        rw [Nat.mul_add] at upperScaled lowerScaled
        have combined := Nat.add_le_add upperScaled lowerScaled
        have partition' : upperHalf n + lowerHalf n = n := by
          rw [Nat.add_comm]
          exact partition
        nlinarith
      have localLinear : localGate n ≤ 2 * localConstant * n := by
        calc
          localGate n ≤ localConstant * (n + 1) := local
          _ ≤ localConstant * (2 * n) :=
            Nat.mul_le_mul_left localConstant (by omega)
          _ = 2 * localConstant * n := by ring
      calc
        gate n ≤ localGate n + gate (upperHalf n) + gate (lowerHalf n) := step
        _ ≤ 2 * localConstant * n +
            ((2 * localConstant) *
              ((upperHalf n) * halfRank (upperHalf n) +
                (lowerHalf n) * halfRank (lowerHalf n)) +
              baseConstant * n) :=
          Nat.add_le_add localLinear recursiveBound
        _ = (2 * localConstant) *
              (((upperHalf n) * halfRank (upperHalf n) +
                (lowerHalf n) * halfRank (lowerHalf n)) + n) +
              baseConstant * n := by ring
        _ ≤ (2 * localConstant) * (n * halfRank n) + baseConstant * n :=
          Nat.add_le_add_right
            (Nat.mul_le_mul_left (2 * localConstant) rankMass)
            (baseConstant * n)
        _ = (2 * localConstant) * n * halfRank n + baseConstant * n := by ring

/-- Depth recurrence closes to O(log^2 n) for every positive width. -/
theorem depth_positive_width_upper
    (depth localDepth : Nat → Nat)
    (localConstant baseConstant : Nat)
    (localBound : ∀ n, localDepth n ≤ localConstant * logRank n)
    (baseOne : depth 1 ≤ baseConstant)
    (baseTwo : depth 2 ≤ baseConstant)
    (recurrence : DepthRecurrenceUpper depth localDepth) :
    ∀ n, 1 ≤ n →
      depth n ≤
        (2 * localConstant) * halfRank n * halfRank n + baseConstant := by
  intro n positive
  induction n using Nat.strong_induction_on with
  | h n induction =>
      by_cases one : n = 1
      · subst n
        simpa using baseOne.trans (by omega)
      by_cases two : n = 2
      · subst n
        simpa using baseTwo.trans (by omega)
      have large : 3 ≤ n := by omega
      have halvesPos := halves_positive large
      have halvesLt := halves_lt_self large
      have upperIH := induction (upperHalf n) halvesLt.2 halvesPos.2
      have lowerIH := induction (lowerHalf n) halvesLt.1 halvesPos.1
      have step := recurrence n (by omega)
      have upperRank := halfRank_upper_drop large
      have lowerRank := halfRank_lower_drop large
      have sourceLog := logRank_le_halfRank_add_one large
      have local := localBound n
      have recursiveMax :
          max (depth (upperHalf n)) (depth (lowerHalf n)) ≤
            (2 * localConstant) * (halfRank n - 1) * (halfRank n - 1) +
              baseConstant := by
        apply max_le
        · have rankLe : halfRank (upperHalf n) ≤ halfRank n - 1 := by omega
          exact upperIH.trans (Nat.add_le_add_right
            (Nat.mul_le_mul_left (2 * localConstant)
              (Nat.mul_le_mul rankLe rankLe)) baseConstant)
        · have rankLe : halfRank (lowerHalf n) ≤ halfRank n - 1 := by omega
          exact lowerIH.trans (Nat.add_le_add_right
            (Nat.mul_le_mul_left (2 * localConstant)
              (Nat.mul_le_mul rankLe rankLe)) baseConstant)
      have rankPositive : 2 ≤ halfRank n := by
        have drop := halfRank_upper_drop large
        have upperPositive : 1 ≤ halfRank (upperHalf n) := by
          unfold halfRank
          omega
        omega
      have localRank :
          localDepth n ≤ localConstant * (halfRank n + 1) :=
        local.trans (Nat.mul_le_mul_left localConstant sourceLog)
      have absorb :
          localConstant * (halfRank n + 1) +
              (2 * localConstant) * (halfRank n - 1) * (halfRank n - 1) ≤
            (2 * localConstant) * halfRank n * halfRank n := by
        nlinarith
      calc
        depth n ≤ localDepth n +
            max (depth (upperHalf n)) (depth (lowerHalf n)) := step
        _ ≤ localConstant * (halfRank n + 1) +
            ((2 * localConstant) * (halfRank n - 1) * (halfRank n - 1) +
              baseConstant) :=
          Nat.add_le_add localRank recursiveMax
        _ = (localConstant * (halfRank n + 1) +
            (2 * localConstant) * (halfRank n - 1) * (halfRank n - 1)) +
              baseConstant := by ring
        _ ≤ (2 * localConstant) * halfRank n * halfRank n + baseConstant :=
          Nat.add_le_add_right absorb baseConstant

/-- Full source Theorem-5 upper closure, including finite width zero and the
single dirty-ancilla bound. -/
theorem theoremFive_upper_closure
    (gate depth dirty : Nat → Nat)
    (localGate localDepth : Nat → Nat)
    (localGateConstant localDepthConstant
      gateBaseConstant depthBaseConstant : Nat)
    (localGateBound : ∀ n,
      localGate n ≤ localGateConstant * (n + 1))
    (localDepthBound : ∀ n,
      localDepth n ≤ localDepthConstant * logRank n)
    (gateBaseOne : gate 1 ≤ gateBaseConstant)
    (gateBaseTwo : gate 2 ≤ 2 * gateBaseConstant)
    (depthBaseOne : depth 1 ≤ depthBaseConstant)
    (depthBaseTwo : depth 2 ≤ depthBaseConstant)
    (gateRecurrence : GateRecurrenceUpper gate localGate)
    (depthRecurrence : DepthRecurrenceUpper depth localDepth)
    (dirtyBound : ∀ n, dirty n ≤ 1) :
    TheoremFiveUpperTarget gate depth dirty := by
  have gatePositive := gate_positive_width_upper
    gate localGate localGateConstant gateBaseConstant
    localGateBound gateBaseOne gateBaseTwo gateRecurrence
  have depthPositive := depth_positive_width_upper
    depth localDepth localDepthConstant depthBaseConstant
    localDepthBound depthBaseOne depthBaseTwo depthRecurrence
  constructor
  · refine ⟨gate 0 + 2 * localGateConstant + gateBaseConstant, ?_⟩
    intro n
    by_cases zero : n = 0
    · subst n
      simp [logRank]
    · have positive : 1 ≤ n := Nat.one_le_iff_ne_zero.2 zero
      have source := gatePositive n positive
      have rank := halfRank_le_logRank n
      have rankPositive : 1 ≤ logRank n := by unfold logRank; omega
      have gate0Term : gate 0 ≤
          gate 0 * (n + 1) * logRank n := by
        have one : 1 ≤ (n + 1) * logRank n := by nlinarith
        have := Nat.mul_le_mul_left (gate 0) one
        simpa [Nat.mul_assoc] using this
      calc
        gate n ≤ (2 * localGateConstant) * n * halfRank n +
            gateBaseConstant * n := source
        _ ≤ (2 * localGateConstant) * (n + 1) * logRank n +
            gateBaseConstant * (n + 1) * logRank n := by
          apply Nat.add_le_add
          · exact Nat.mul_le_mul
              (Nat.mul_le_mul_left (2 * localGateConstant) (Nat.le_succ n)) rank
          · have scale : n ≤ (n + 1) * logRank n := by nlinarith
            exact Nat.mul_le_mul_left gateBaseConstant scale
        _ ≤ gate 0 * (n + 1) * logRank n +
            (2 * localGateConstant) * (n + 1) * logRank n +
            gateBaseConstant * (n + 1) * logRank n := by omega
        _ = (gate 0 + 2 * localGateConstant + gateBaseConstant) *
            (n + 1) * logRank n := by ring
  · constructor
    · refine ⟨depth 0 + 2 * localDepthConstant + depthBaseConstant, ?_⟩
      intro n
      by_cases zero : n = 0
      · subst n
        simp [logRank]
      · have positive : 1 ≤ n := Nat.one_le_iff_ne_zero.2 zero
        have source := depthPositive n positive
        have rank := halfRank_le_logRank n
        have squareRank : halfRank n * halfRank n ≤ logRank n * logRank n :=
          Nat.mul_le_mul rank rank
        have depth0Term : depth 0 ≤
            depth 0 * logRank n * logRank n := by
          have rankPositive : 1 ≤ logRank n := by unfold logRank; omega
          have scale : 1 ≤ logRank n * logRank n := by nlinarith
          have := Nat.mul_le_mul_left (depth 0) scale
          simpa [Nat.mul_assoc] using this
        calc
          depth n ≤ (2 * localDepthConstant) * halfRank n * halfRank n +
              depthBaseConstant := source
          _ ≤ (2 * localDepthConstant) * logRank n * logRank n +
              depthBaseConstant * logRank n * logRank n := by
            apply Nat.add_le_add
            · exact Nat.mul_le_mul_left (2 * localDepthConstant) squareRank
            · have rankPositive : 1 ≤ logRank n := by unfold logRank; omega
              have scale : 1 ≤ logRank n * logRank n := by nlinarith
              exact Nat.mul_le_mul_left depthBaseConstant scale
          _ ≤ depth 0 * logRank n * logRank n +
              (2 * localDepthConstant) * logRank n * logRank n +
              depthBaseConstant * logRank n * logRank n := by omega
          _ = (depth 0 + 2 * localDepthConstant + depthBaseConstant) *
              logRank n * logRank n := by ring
    · exact dirtyBound

end VandaeleTheorem5RecurrenceClosure
end QuantumBlockEncoding
