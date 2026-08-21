import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Figure 11 carry arithmetic for Vandaele Theorem 5

Split the n-bit quantum word and classical constant at
`l = ceil(n/2)` low bits.  Let

`x = xL + 2^l xH`, `c = cL + 2^l cH`.

The carry from the low half is one exactly when

`xL + cL >= 2^l`,

which is equivalently the classical-quantum comparison

`xL >= 2^l - cL`.

After reducing the low sum modulo `2^l`, the high half receives exactly that
carry.  The recombined output is `(x+c) mod 2^n`.  This is the arithmetic spine
of Figure 11 and is independent of the recursive gate implementation.
-/

namespace QuantumBlockEncoding
namespace VandaeleTheorem5AdderCarry

open ComparatorIncrementerGeneral
open VandaeleLemma5SplitBudget

/-- Low and high bit widths used by Figure 11. -/
def lowWidth (n : Nat) : Nat := upperHalf n

def highWidth (n : Nat) : Nat := lowerHalf n

/-- Exact width partition. -/
theorem low_add_high (n : Nat) : lowWidth n + highWidth n = n := by
  unfold lowWidth highWidth
  rw [Nat.add_comm]
  exact halves_partition n

/-- Low-half radix. -/
def lowBase (n : Nat) : Nat := gridSize (lowWidth n)

/-- High-half radix. -/
def highBase (n : Nat) : Nat := gridSize (highWidth n)

/-- Full radix factors into low and high radices. -/
theorem gridSize_factor (n : Nat) :
    gridSize n = lowBase n * highBase n := by
  unfold lowBase highBase gridSize
  rw [← pow_add]
  rw [low_add_high]

/-- Split any natural representative into low/high halves. -/
def lowPart (n value : Nat) : Nat := value % lowBase n

def highPart (n value : Nat) : Nat :=
  (value / lowBase n) % highBase n

/-- Low parts are in range. -/
theorem lowPart_lt (n value : Nat) : lowPart n value < lowBase n := by
  unfold lowPart lowBase gridSize
  exact Nat.mod_lt _ (Nat.pow_pos (by decide))

/-- High parts are in range. -/
theorem highPart_lt (n value : Nat) : highPart n value < highBase n := by
  unfold highPart highBase gridSize
  exact Nat.mod_lt _ (Nat.pow_pos (by decide))

/-- Carry bit out of the low half. -/
def carryBit (n x c : Nat) : Nat :=
  if lowBase n ≤ lowPart n x + lowPart n c then 1 else 0

/-- Carry is Boolean. -/
theorem carryBit_le_one (n x c : Nat) : carryBit n x c ≤ 1 := by
  unfold carryBit
  split <;> omega

/-- Source comparator threshold from the Theorem-5 proof. -/
def carryThreshold (n c : Nat) : Nat :=
  lowBase n - lowPart n c

/-- Figure-11 carry predicate is exactly the classical threshold comparison. -/
theorem carry_iff_threshold
    (n x c : Nat) :
    carryBit n x c = 1 ↔
      carryThreshold n c ≤ lowPart n x := by
  have xBound := lowPart_lt n x
  have cBound := lowPart_lt n c
  have basePositive : 0 < lowBase n := by
    unfold lowBase gridSize
    exact Nat.pow_pos (by decide)
  unfold carryBit carryThreshold
  by_cases overflow : lowBase n ≤ lowPart n x + lowPart n c
  · rw [if_pos overflow]
    constructor
    · intro _
      omega
    · intro _
      rfl
  · rw [if_neg overflow]
    constructor
    · intro impossible
      omega
    · intro threshold
      exfalso
      omega

/-- Low output digit. -/
def lowOutput (n x c : Nat) : Nat :=
  (lowPart n x + lowPart n c) % lowBase n

/-- High output digit including the carry from the low half. -/
def highOutput (n x c : Nat) : Nat :=
  (highPart n x + highPart n c + carryBit n x c) % highBase n

/-- The low sum satisfies the exact carry equation. -/
theorem low_balance (n x c : Nat) :
    lowOutput n x c + lowBase n * carryBit n x c =
      lowPart n x + lowPart n c := by
  have xBound := lowPart_lt n x
  have cBound := lowPart_lt n c
  have sumBound : lowPart n x + lowPart n c < 2 * lowBase n := by
    omega
  unfold lowOutput carryBit
  by_cases overflow : lowBase n ≤ lowPart n x + lowPart n c
  · rw [if_pos overflow]
    have reduced :
        (lowPart n x + lowPart n c) % lowBase n =
          lowPart n x + lowPart n c - lowBase n := by
      exact Nat.mod_eq_sub_mod (by omega) |>.trans (by
        have below : lowPart n x + lowPart n c - lowBase n < lowBase n := by
          omega
        rw [Nat.mod_eq_of_lt below])
    rw [reduced]
    omega
  · rw [if_neg overflow]
    have below : lowPart n x + lowPart n c < lowBase n := by omega
    rw [Nat.mod_eq_of_lt below]
    omega

/-- Recompose an in-range n-bit value from its split halves. -/
theorem recompose_of_lt
    (n value : Nat) (bound : value < gridSize n) :
    lowPart n value + lowBase n * highPart n value = value := by
  unfold lowPart highPart
  have basePositive : 0 < lowBase n := by
    unfold lowBase gridSize
    exact Nat.pow_pos (by decide)
  have quotientBound : value / lowBase n < highBase n := by
    have factor := gridSize_factor n
    rw [factor] at bound
    exact (Nat.div_lt_iff_lt_mul basePositive).2 (by
      simpa [Nat.mul_comm] using bound)
  rw [Nat.mod_eq_of_lt quotientBound]
  exact (Nat.mod_add_div value (lowBase n)).symm

/-- Main Figure-11 arithmetic theorem. -/
theorem add_recomposition
    (n x c : Nat)
    (xBound : x < gridSize n)
    (cBound : c < gridSize n) :
    lowOutput n x c + lowBase n * highOutput n x c =
      (x + c) % gridSize n := by
  have xRec := recompose_of_lt n x xBound
  have cRec := recompose_of_lt n c cBound
  have lowEq := low_balance n x c
  have highBasePositive : 0 < highBase n := by
    unfold highBase gridSize
    exact Nat.pow_pos (by decide)
  have factor := gridSize_factor n
  have highRaw := highPart n x + highPart n c + carryBit n x c
  have highMod : highOutput n x c = highRaw % highBase n := rfl
  rw [highMod]
  have targetMod :
      (x + c) % gridSize n =
        (lowOutput n x c + lowBase n * (highRaw % highBase n)) %
          gridSize n := by
    rw [← xRec, ← cRec]
    rw [← lowEq]
    rw [factor]
    simp [Nat.add_assoc, Nat.mul_add, Nat.add_mul_mod_self_left,
      Nat.mul_mod]
  rw [targetMod]
  have lowBound : lowOutput n x c < lowBase n := by
    unfold lowOutput
    exact Nat.mod_lt _ (by
      unfold lowBase gridSize
      exact Nat.pow_pos (by decide))
  have highBound : highRaw % highBase n < highBase n :=
    Nat.mod_lt _ highBasePositive
  have combinedBound :
      lowOutput n x c + lowBase n * (highRaw % highBase n) < gridSize n := by
    rw [factor]
    nlinarith
  rw [Nat.mod_eq_of_lt combinedBound]

end VandaeleTheorem5AdderCarry
end QuantumBlockEncoding
