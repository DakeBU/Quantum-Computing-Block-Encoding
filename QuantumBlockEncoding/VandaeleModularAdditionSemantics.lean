import Mathlib.Tactic

/-!
# Figure 12 modular-addition arithmetic

Section 6.2 plugs the classical-quantum adder/comparator primitives into the
space-efficient modular-multiplication construction of Häner et al. Figure 12
implements addition of a classical constant a modulo N.

For `0 < N`, `a < N`, and `b < N`:

* the first comparator tests `b < N-a`;
* on that no-overflow branch the circuit uses `b+a`;
* otherwise it uses `b+a-N`;
* the result is exactly `(a+b) mod N`;
* the second comparator tests whether the result is at least a. This predicate
  is equivalent to the first no-overflow predicate, so the clean comparison bit
  can be uncomputed.

The theorem is pure arithmetic and independent of a particular comparator or
adder gate synthesis.
-/

namespace QuantumBlockEncoding
namespace VandaeleModularAdditionSemantics

/-- Figure-12 branch predicate: adding a does not overflow modulo N. -/
def noOverflow (N a b : Nat) : Prop := b < N - a

/-- Arithmetic output selected by Figure 12 before identifying it with `% N`. -/
def branchOutput (N a b : Nat) : Nat :=
  if noOverflow N a b then b + a else b + a - N

/-- On the no-overflow branch, the ordinary sum stays below N. -/
theorem sum_lt_modulus_of_noOverflow
    {N a b : Nat}
    (aLt : a < N)
    (branch : noOverflow N a b) :
    b + a < N := by
  unfold noOverflow at branch
  omega

/-- On the overflow branch, the ordinary sum reaches or exceeds N. -/
theorem modulus_le_sum_of_overflow
    {N a b : Nat}
    (aLt : a < N)
    (bLt : b < N)
    (branch : ¬ noOverflow N a b) :
    N <= b + a := by
  unfold noOverflow at branch
  omega

/-- The one-subtraction overflow branch is still below N. -/
theorem overflow_output_lt_modulus
    {N a b : Nat}
    (positive : 0 < N)
    (aLt : a < N)
    (bLt : b < N)
    (branch : ¬ noOverflow N a b) :
    b + a - N < N := by
  have sumBound : b + a < 2 * N := by omega
  have overflow := modulus_le_sum_of_overflow aLt bLt branch
  omega

/-- Main Figure-12 arithmetic identity. -/
theorem branchOutput_eq_mod
    {N a b : Nat}
    (positive : 0 < N)
    (aLt : a < N)
    (bLt : b < N) :
    branchOutput N a b = (a + b) % N := by
  by_cases branch : noOverflow N a b
  · rw [branchOutput, if_pos branch]
    have sumLt := sum_lt_modulus_of_noOverflow aLt branch
    rw [Nat.mod_eq_of_lt]
    · omega
    · simpa [Nat.add_comm] using sumLt
  · rw [branchOutput, if_neg branch]
    have overflow := modulus_le_sum_of_overflow aLt bLt branch
    have reducedLt := overflow_output_lt_modulus positive aLt bLt branch
    have oneSub : a + b = N + (b + a - N) := by omega
    rw [oneSub, Nat.add_mod]
    simp [Nat.mod_self, Nat.mod_eq_of_lt reducedLt]

/-- No-overflow output is at least the added constant a. -/
theorem output_ge_addend_of_noOverflow
    {N a b : Nat}
    (branch : noOverflow N a b) :
    a <= branchOutput N a b := by
  rw [branchOutput, if_pos branch]
  omega

/-- Overflow output is strictly below a. This is the arithmetic reason the
second comparator in Figure 12 can uncompute the first comparison bit. -/
theorem output_lt_addend_of_overflow
    {N a b : Nat}
    (aLt : a < N)
    (bLt : b < N)
    (branch : ¬ noOverflow N a b) :
    branchOutput N a b < a := by
  rw [branchOutput, if_neg branch]
  have overflow := modulus_le_sum_of_overflow aLt bLt branch
  omega

/-- Exact comparator-uncomputation invariant from the Figure-12 caption. -/
theorem noOverflow_iff_output_ge_addend
    {N a b : Nat}
    (aLt : a < N)
    (bLt : b < N) :
    noOverflow N a b ↔ a <= branchOutput N a b := by
  constructor
  · exact output_ge_addend_of_noOverflow
  · intro outputGe
    by_contra overflow
    have outputLt := output_lt_addend_of_overflow aLt bLt overflow
    omega

/-- Same invariant stated directly on the canonical modular sum. -/
theorem noOverflow_iff_modular_sum_ge_addend
    {N a b : Nat}
    (positive : 0 < N)
    (aLt : a < N)
    (bLt : b < N) :
    noOverflow N a b ↔ a <= (a + b) % N := by
  rw [← branchOutput_eq_mod positive aLt bLt]
  exact noOverflow_iff_output_ge_addend aLt bLt

end VandaeleModularAdditionSemantics
end QuantumBlockEncoding
