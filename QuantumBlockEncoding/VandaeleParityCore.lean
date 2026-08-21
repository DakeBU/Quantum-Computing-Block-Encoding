import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.GroupTheory.Perm.Sign
import Mathlib.Tactic

/-!
# Parity core for Vandaele's ancilla lower bound

The source optimal-qubit argument separates cleanly into two facts.

1. `C^k X` on its k control bits and one target bit is an odd permutation: it
   swaps exactly the two basis states with all controls one and target 0/1.
2. A local permutation duplicated over one completely unused binary wire has
   squared sign.  In particular, duplicating an odd local gate over that unused
   bit produces an even global permutation.

The second fact is the mechanism behind the source observation that X/CX/CCX
are even on sufficiently large registers.  A subsequent wire-support module
connects arbitrary reversible gates to this duplicated-fibre form.
-/

namespace QuantumBlockEncoding
namespace VandaeleParityCore

open VandaeleLemma1Contract

/-- Canonical all-ones control word. -/
def allOnesControls (k : Nat) : PrimitiveBasis k :=
  fun _ => 1

/-- The predicate from Definition 2.1 selects exactly the canonical all-ones
control word. -/
theorem allControlsOne_iff_eq_allOnes
    (k : Nat) (controls : PrimitiveBasis k) :
    allControlsOne controls ↔ controls = allOnesControls k := by
  constructor
  · intro active
    funext wire
    exact active wire
  · intro equal
    subst controls
    intro wire
    rfl

/-- The two basis states exchanged by C^k X. -/
def swapZeroState (k : Nat) : PrimitiveBasis k × Fin 2 :=
  (allOnesControls k, 0)

/-- The target-one partner. -/
def swapOneState (k : Nat) : PrimitiveBasis k × Fin 2 :=
  (allOnesControls k, 1)

/-- The exchanged states are distinct. -/
theorem swapStates_ne (k : Nat) :
    swapZeroState k ≠ swapOneState k := by
  intro equal
  have targetEq := congrArg Prod.snd equal
  norm_num [swapZeroState, swapOneState] at targetEq

/-- Definition 2.1 is literally one transposition. -/
theorem multiControlledX_eq_swap (k : Nat) :
    multiControlledXEquiv k =
      Equiv.swap (swapZeroState k) (swapOneState k) := by
  apply Equiv.ext
  intro state
  rcases state with ⟨controls,target⟩
  by_cases active : allControlsOne controls
  · have controlsEq := (allControlsOne_iff_eq_allOnes k controls).mp active
    subst controls
    fin_cases target <;>
      simp [multiControlledXEquiv, multiControlledXAction,
        allControlsOne, allOnesControls,
        swapZeroState, swapOneState, Equiv.swap_apply_def]
  · have controlsNe : controls ≠ allOnesControls k := by
      intro equal
      exact active ((allControlsOne_iff_eq_allOnes k controls).mpr equal)
    have neZero :
        (controls,target) ≠ swapZeroState k := by
      intro equal
      apply controlsNe
      exact congrArg Prod.fst equal
    have neOne :
        (controls,target) ≠ swapOneState k := by
      intro equal
      apply controlsNe
      exact congrArg Prod.fst equal
    simp [multiControlledXEquiv, multiControlledXAction, active,
      Equiv.swap_apply_of_ne_of_ne neZero neOne]

/-- Therefore C^k X has odd sign for every k. -/
theorem multiControlledX_sign (k : Nat) :
    Equiv.Perm.sign (multiControlledXEquiv k) = -1 := by
  rw [multiControlledX_eq_swap]
  exact Equiv.Perm.sign_swap (swapStates_ne k)

/-- Duplicate one local permutation independently over a binary spectator wire. -/
def duplicateOverBit
    {β : Type*} [DecidableEq β]
    (local : Equiv.Perm β) : Equiv.Perm (Fin 2 × β) :=
  Equiv.Perm.prodCongrRight (fun _ : Fin 2 => local)

/-- Sign of the duplicated permutation is the square of the local sign. -/
theorem duplicateOverBit_sign
    {β : Type*} [Fintype β] [DecidableEq β]
    (local : Equiv.Perm β) :
    Equiv.Perm.sign (duplicateOverBit local) =
      (Equiv.Perm.sign local) ^ 2 := by
  unfold duplicateOverBit
  rw [Equiv.Perm.sign_prodCongrRight]
  rw [Finset.prod_const]
  simp

/-- In particular, duplicating an odd local permutation over one unused bit is
even globally. -/
theorem duplicateOdd_is_even
    {β : Type*} [Fintype β] [DecidableEq β]
    (local : Equiv.Perm β)
    (odd : Equiv.Perm.sign local = -1) :
    Equiv.Perm.sign (duplicateOverBit local) = 1 := by
  rw [duplicateOverBit_sign, odd]
  norm_num

/-- Conjugating a duplicated odd local permutation into any equivalent state
space preserves its even sign.  This is the exact generic form needed once an
unused physical qubit is split from a reversible gate. -/
theorem even_of_conjugate_duplicateOdd
    {α β : Type*}
    [Fintype α] [DecidableEq α]
    [Fintype β] [DecidableEq β]
    (global : Equiv.Perm α)
    (local : Equiv.Perm β)
    (split : α ≃ Fin 2 × β)
    (refines : (split.symm.trans global).trans split = duplicateOverBit local)
    (odd : Equiv.Perm.sign local = -1) :
    Equiv.Perm.sign global = 1 := by
  have conjugateSign := Equiv.Perm.sign_symm_trans_trans global split
  rw [refines, duplicateOdd_is_even local odd] at conjugateSign
  exact conjugateSign.symm

end VandaeleParityCore
end QuantumBlockEncoding
