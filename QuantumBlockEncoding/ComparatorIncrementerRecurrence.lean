import Mathlib.Data.Nat.Sqrt
import Mathlib.Tactic

/-!
# Exact recursion parameters for Vandaele Theorem 4

Theorem 4 of arXiv:2603.12917 chooses

`alpha = 2 * ceil(sqrt n)`, `beta = n - alpha`

and recursively implements the incrementer on the top `alpha` qubits.  The
paper then obtains

`C(n) = Theta(n) + C(alpha)` and
`D(n) = Theta(log n) + D(alpha)`.

Before formalizing the circuit recurrence or asymptotics, ASPBE needs a precise
natural-number version of the split and a proof that the recursive argument is
strictly smaller.  This file supplies that arithmetic layer.  Small widths are
explicit base cases; for `n >= 7`, `alpha(n) < n`.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerRecurrence

/-- Natural-number ceiling of the real square root, expressed using Mathlib's
floor-valued `Nat.sqrt`. -/
def ceilSqrt (n : Nat) : Nat :=
  if Nat.sqrt n * Nat.sqrt n = n then Nat.sqrt n else Nat.sqrt n + 1

/-- The natural square root is never larger than its ceiling. -/
theorem sqrt_le_ceilSqrt (n : Nat) : Nat.sqrt n ≤ ceilSqrt n := by
  unfold ceilSqrt
  by_cases square : Nat.sqrt n * Nat.sqrt n = n <;> simp [square]

/-- The ceiling differs from `Nat.sqrt` by at most one. -/
theorem ceilSqrt_le_sqrt_add_one (n : Nat) :
    ceilSqrt n ≤ Nat.sqrt n + 1 := by
  unfold ceilSqrt
  by_cases square : Nat.sqrt n * Nat.sqrt n = n <;> simp [square]

/-- The square of the ceiling really covers n. -/
theorem le_ceilSqrt_sq (n : Nat) :
    n ≤ ceilSqrt n * ceilSqrt n := by
  unfold ceilSqrt
  by_cases square : Nat.sqrt n * Nat.sqrt n = n
  · simp [square]
  · simp [square]
    have upper := Nat.succ_le_succ_sqrt n
    omega

/-- Theorem 4 recursive top-register size. -/
def alpha (n : Nat) : Nat := 2 * ceilSqrt n

/-- Remaining lower-register size. -/
def beta (n : Nat) : Nat := n - alpha n

/-- Above the finite base-case regime, the recursive call is genuinely smaller.
The cutoff 7 is convenient and exact for this definition; widths below it can
be discharged by fixed circuits. -/
theorem alpha_lt_self {n : Nat} (large : 7 ≤ n) : alpha n < n := by
  have ceilingBound := ceilSqrt_le_sqrt_add_one n
  by_cases smallSqrt : Nat.sqrt n ≤ 2
  · unfold alpha
    omega
  · have sqrtAtLeastThree : 3 ≤ Nat.sqrt n := by omega
    have squareBelow : Nat.sqrt n ^ 2 ≤ n := Nat.sqrt_le' n
    unfold alpha
    nlinarith

/-- Consequently alpha is a valid subregister size. -/
theorem alpha_le_self {n : Nat} (large : 7 ≤ n) : alpha n ≤ n :=
  (alpha_lt_self large).le

/-- The source split exactly partitions the n wires. -/
theorem alpha_add_beta {n : Nat} (large : 7 ≤ n) :
    alpha n + beta n = n := by
  unfold beta
  have bound := alpha_le_self large
  omega

/-- The lower beta block is nonempty in the recursive regime. -/
theorem beta_pos {n : Nat} (large : 7 ≤ n) : 0 < beta n := by
  unfold beta
  have strict := alpha_lt_self large
  omega

/-- The source split packaged as data for later register/circuit constructors. -/
structure RecursiveSplit (n : Nat) where
  top : Nat
  bottom : Nat
  partitions : top + bottom = n
  recursiveSmaller : top < n

/-- Canonical Theorem 4 split for every non-base width. -/
def theoremFourSplit (n : Nat) (large : 7 ≤ n) : RecursiveSplit n where
  top := alpha n
  bottom := beta n
  partitions := alpha_add_beta large
  recursiveSmaller := alpha_lt_self large

/-- Gate-count recurrence interface used after the source circuit itself is
available.  Keeping the local cost as an explicit function prevents an informal
`Theta(n)` label from entering a correctness theorem. -/
def GateRecurrenceUpper
    (cost localGateCost : Nat → Nat) : Prop :=
  ∀ n, 7 ≤ n →
    cost n ≤ localGateCost n + cost (alpha n)

/-- Depth recurrence interface corresponding to Equation (46). -/
def DepthRecurrenceUpper
    (depth localDepthCost : Nat → Nat) : Prop :=
  ∀ n, 7 ≤ n →
    depth n ≤ localDepthCost n + depth (alpha n)

/-- Any recurrence instantiated through these interfaces recurses on a strictly
smaller natural number.  This is the termination fact needed by the later
well-founded circuit family, independent of the chosen resource constants. -/
theorem recurrence_argument_decreases
    (n : Nat) (large : 7 ≤ n) : alpha n < n :=
  alpha_lt_self large

end ComparatorIncrementerRecurrence
end QuantumBlockEncoding
