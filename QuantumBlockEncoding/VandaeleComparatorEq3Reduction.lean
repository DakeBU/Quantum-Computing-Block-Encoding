import QuantumBlockEncoding.ComparatorIncrementerEq40ControlInvariant
import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Vandaele Equation (3): comparator lower-bound reduction

Equation (3) displays a k-bit threshold comparator labelled

`address >= 2^k - 1`

and identifies it with `C^k X`.  Later, Equation (29) defines the paper's
classical-quantum comparator using the strict convention `c < address`.  These
are not literally the same threshold parameter: on a k-bit address register,

`address >= 2^k - 1`

is equivalent to the strict Equation-(29) comparison

`2^k - 2 < address`

for k>=1.

This module preserves that source distinction explicitly.  The Equation-(3)
flat comparator is defined by transporting the canonical `C^k X` permutation
into the paper's `[k address wires | flag]` layout.  We prove its threshold
interpretation and its shifted Equation-(29) interpretation exactly.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorEq3Reduction

open ComparatorIncrementerEq40ControlInvariant
open ComparatorIncrementerGeneral
open PrimitiveBasisRegisterSplit
open VandaeleLemma1Contract

/-- A one-wire primitive basis register is exactly one `Fin 2` bit. -/
def oneBitBasisEquiv : PrimitiveBasis 1 ≃ Fin 2 where
  toFun state := state 0
  invFun bit := fun _ => bit
  left_inv state := by
    funext wire
    fin_cases wire
    rfl
  right_inv bit := by
    rfl

/-- Canonical layout bridge `[k address | flag] <-> address × flag`. -/
def cqProductEquiv (k : Nat) :
    PrimitiveBasis (k + 1) ≃ PrimitiveBasis k × Fin 2 :=
  (basisSplitEquiv k 1).trans
    (Equiv.prodCongr (Equiv.refl (PrimitiveBasis k)) oneBitBasisEquiv)

/-- Read one flat CQ permutation in product coordinates. -/
def productViewOfCq (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (k + 1))) :
    Equiv.Perm (PrimitiveBasis k × Fin 2) :=
  (cqProductEquiv k).symm.trans
    (implementation.trans (cqProductEquiv k))

/-- Transport one product-coordinate permutation into the flat CQ layout. -/
def flattenCqPermutation (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis k × Fin 2)) :
    Equiv.Perm (PrimitiveBasis (k + 1)) :=
  (cqProductEquiv k).trans
    (implementation.trans (cqProductEquiv k).symm)

/-- Flattening and reopening the product view is lossless. -/
theorem productView_flatten
    (k : Nat) (implementation : Equiv.Perm (PrimitiveBasis k × Fin 2)) :
    productViewOfCq k (flattenCqPermutation k implementation) = implementation := by
  apply Equiv.ext
  intro state
  simp [productViewOfCq, flattenCqPermutation]

/-- Equation-(3) flat target: exactly the canonical `C^k X` permutation in the
CQ register layout. -/
def eqThreeComparatorEquiv (k : Nat) :
    Equiv.Perm (PrimitiveBasis (k + 1)) :=
  flattenCqPermutation k (multiControlledXEquiv k)

/-- Exact reduction identity: Equation-(3) reopened in product coordinates is
literally `C^k X`. -/
theorem eqThree_productView_eq_multiControlledX (k : Nat) :
    productViewOfCq k (eqThreeComparatorEquiv k) = multiControlledXEquiv k := by
  exact productView_flatten k (multiControlledXEquiv k)

/-- Address value of a flat state is the little-endian value of the address
factor exposed by `cqProductEquiv`. -/
theorem cqAddressValue_eq_product_basisNat
    (k : Nat) (state : PrimitiveBasis (k + 1)) :
    cqAddressValue k state = basisNat k (cqProductEquiv k state).1 := by
  unfold cqAddressValue basisNat cqProductEquiv
  rw [primitiveBasisLEEquiv_value_eq_sum]
  apply Finset.sum_congr rfl
  intro wire _
  rfl

/-- A k-bit basis word has maximal value iff every control bit is one. -/
theorem basisNat_eq_max_iff_all_ones
    (k : Nat) (state : PrimitiveBasis k) :
    basisNat k state = gridSize k - 1 ↔ ∀ wire, state wire = 1 := by
  constructor
  · intro maximal
    have stateEq : state = allOnesBasisState k := by
      apply (primitiveBasisLEEquiv k).injective
      apply Fin.ext
      simpa [basisNat] using maximal.trans (basisNat_allOnes k).symm
    intro wire
    rw [stateEq]
    exact allOnesBasisState_apply k wire
  · intro allOne
    have stateEq : state = allOnesBasisState k := by
      funext wire
      rw [allOne wire]
      symm
      exact allOnesBasisState_apply k wire
    rw [stateEq]
    exact basisNat_allOnes k

/-- On a k-bit word, the Equation-(3) threshold is active exactly at the unique
maximum address, hence exactly when all controls are one. -/
theorem address_ge_max_iff_all_ones
    (k : Nat) (address : PrimitiveBasis k) :
    gridSize k - 1 ≤ basisNat k address ↔ ∀ wire, address wire = 1 := by
  have bound : basisNat k address < gridSize k := by
    unfold basisNat
    exact (primitiveBasisLEEquiv k address).isLt
  constructor
  · intro high
    apply (basisNat_eq_max_iff_all_ones k address).1
    omega
  · intro allOne
    rw [(basisNat_eq_max_iff_all_ones k address).2 allOne]

/-- Equation-(3) threshold convention translated to a flat CQ state. -/
theorem flat_address_ge_max_iff_all_controls
    (k : Nat) (state : PrimitiveBasis (k + 1)) :
    gridSize k - 1 ≤ cqAddressValue k state ↔
      ∀ wire, (cqProductEquiv k state).1 wire = 1 := by
  rw [cqAddressValue_eq_product_basisNat]
  exact address_ge_max_iff_all_ones k (cqProductEquiv k state).1

/-- For positive width, the source Equation-(3) non-strict threshold is exactly
Equation-(29)'s strict comparator with the constant shifted down by one. -/
theorem ge_max_iff_shifted_strict
    {k : Nat} (positive : 1 ≤ k) (address : Nat)
    (addressBound : address < gridSize k) :
    gridSize k - 1 ≤ address ↔ gridSize k - 2 < address := by
  have sizeAtLeastTwo : 2 ≤ gridSize k := by
    have power : 2 ^ 1 ≤ 2 ^ k :=
      Nat.pow_le_pow_right (by decide) positive
    simpa [gridSize] using power
  omega

/-- Flat action of the Equation-(3) target: preserve address and toggle the flag
iff the displayed `>= 2^k-1` threshold is active. -/
theorem eqThree_threshold_action
    (k : Nat) (state : PrimitiveBasis (k + 1)) :
    (∀ wire : Fin k,
      eqThreeComparatorEquiv k state (cqAddressWire k wire) =
        state (cqAddressWire k wire)) ∧
    eqThreeComparatorEquiv k state (cqFlagWire k) =
      if gridSize k - 1 ≤ cqAddressValue k state then
        flipBit (state (cqFlagWire k))
      else state (cqFlagWire k) := by
  let product := cqProductEquiv k state
  have reopened := Equiv.congr_fun
    (eqThree_productView_eq_multiControlledX k) product
  have addressValue := cqAddressValue_eq_product_basisNat k state
  have activeIff := flat_address_ge_max_iff_all_controls k state
  rcases product with ⟨controls, flag⟩
  by_cases active : ∀ wire, controls wire = 1
  · constructor
    · intro wire
      have threshold : gridSize k - 1 ≤ cqAddressValue k state := by
        exact (activeIff).2 active
      simp [eqThreeComparatorEquiv, flattenCqPermutation, cqProductEquiv,
        multiControlledXEquiv, multiControlledXAction,
        VandaeleLemma1Contract.allControlsOne, active]
    · have threshold : gridSize k - 1 ≤ cqAddressValue k state :=
        activeIff.2 active
      simp [eqThreeComparatorEquiv, flattenCqPermutation, cqProductEquiv,
        multiControlledXEquiv, multiControlledXAction,
        VandaeleLemma1Contract.allControlsOne, active, threshold]
  · constructor
    · intro wire
      have threshold : ¬ gridSize k - 1 ≤ cqAddressValue k state := by
        intro high
        exact active (activeIff.1 high)
      simp [eqThreeComparatorEquiv, flattenCqPermutation, cqProductEquiv,
        multiControlledXEquiv, multiControlledXAction,
        VandaeleLemma1Contract.allControlsOne, active]
    · have threshold : ¬ gridSize k - 1 ≤ cqAddressValue k state := by
        intro high
        exact active (activeIff.1 high)
      simp [eqThreeComparatorEquiv, flattenCqPermutation, cqProductEquiv,
        multiControlledXEquiv, multiControlledXAction,
        VandaeleLemma1Contract.allControlsOne, active, threshold]

/-- Source convention bridge: for k>=1, the exact Equation-(3) permutation is a
valid Equation-(29) classical comparator at shifted constant `2^k-2`. -/
theorem eqThree_satisfies_shifted_classicalComparatorSpec
    {k : Nat} (positive : 1 ≤ k) :
    ClassicalComparatorSpec k (gridSize k - 2) (eqThreeComparatorEquiv k) := by
  intro state
  have action := eqThree_threshold_action k state
  have addressBound : cqAddressValue k state < gridSize k := by
    rw [cqAddressValue_eq_product_basisNat]
    unfold basisNat
    exact (primitiveBasisLEEquiv k (cqProductEquiv k state).1).isLt
  have convention := ge_max_iff_shifted_strict positive
    (cqAddressValue k state) addressBound
  constructor
  · exact action.1
  · by_cases high : gridSize k - 1 ≤ cqAddressValue k state
    · have strict : gridSize k - 2 < cqAddressValue k state := convention.1 high
      simpa [high, strict] using action.2
    · have notStrict : ¬ gridSize k - 2 < cqAddressValue k state := by
        intro strict
        exact high (convention.2 strict)
      simpa [high, notStrict] using action.2

end VandaeleComparatorEq3Reduction
end QuantumBlockEncoding
