import QuantumBlockEncoding.Resources
import QuantumBlockEncoding.Robin.ComplexLCU

/-!
# Banded sparse access

This module formalizes the semantic construction used by Definition 6 and
Lemma 1 of arXiv:2405.12855 and reused by Lemma 2 of arXiv:2506.20478.  A
source-dependent reversible loader writes the first-row band address, then a
source-independent modular SUM adds the preserved row register.

The paper's general gate-count formulas are recorded as source-facing bounds.
They are not promoted to executable resource certificates here: that stronger
claim requires a general compiler for the loader and modular adder.
-/

namespace QuantumBlockEncoding
namespace BandedSparseAccess

/-- An `n`-qubit computational-basis word, represented modulo `2^n`. -/
abbrev Word (n : Nat) := ZMod (2 ^ n)

/-- The sparse selector embedded in the clean `n`-qubit address register. -/
def slotWord (n : Nat) {l : Nat} (slot : Fin (2 ^ l)) : Word n :=
  slot.val

/-- Reversible modular SUM: add the second register into the first and preserve
the second register.  This is Eq. (53) of arXiv:2405.12855. -/
def modularSumEquiv (n : Nat) :
    (Word n × Word n) ≃ (Word n × Word n) where
  toFun pair := (pair.1 + pair.2, pair.2)
  invFun pair := (pair.1 - pair.2, pair.2)
  left_inv pair := by simp
  right_inv pair := by simp

/-- Lift a reversible first-row address loader while leaving the row register
untouched. -/
def liftLoaderEquiv (n : Nat) (loader : Equiv.Perm (Word n)) :
    Equiv.Perm (Word n × Word n) :=
  Equiv.prodCongr loader (Equiv.refl _)

/-- The exact arbitrary-size banded-sparse-access semantics: load `r_(s,0)`,
then add the row modulo `2^n`. -/
def accessEquiv (n : Nat) (loader : Equiv.Perm (Word n)) :
    Equiv.Perm (Word n × Word n) :=
  (liftLoaderEquiv n loader).trans (modularSumEquiv n)

@[simp] theorem modularSumEquiv_apply (n : Nat) (address row : Word n) :
    modularSumEquiv n (address, row) = (address + row, row) :=
  rfl

@[simp] theorem accessEquiv_apply (n : Nat)
    (loader : Equiv.Perm (Word n)) (address row : Word n) :
    accessEquiv n loader (address, row) = (loader address + row, row) :=
  rfl

/-- Definition 6 action on the clean sparse-selector input. -/
theorem accessEquiv_clean_slot
    (n : Nat) {l : Nat}
    (offset : Fin (2 ^ l) → Word n)
    (loader : Equiv.Perm (Word n))
    (loader_spec : ∀ slot, loader (slotWord n slot) = offset slot)
    (slot : Fin (2 ^ l)) (row : Word n) :
    accessEquiv n loader (slotWord n slot, row) =
      (offset slot + row, row) := by
  simp [accessEquiv_apply, loader_spec]

/-- The row register is preserved for every basis input, not only clean sparse
selectors. -/
@[simp] theorem accessEquiv_preserves_row
    (n : Nat) (loader : Equiv.Perm (Word n))
    (input : Word n × Word n) :
    (accessEquiv n loader input).2 = input.2 :=
  rfl

/-- Exact matrix semantics induced by the reversible access map. -/
def accessMatrix (n : Nat) (loader : Equiv.Perm (Word n)) :
    _root_.Matrix (Word n × Word n) (Word n × Word n) ℂ :=
  Robin.ComplexLCU.equivPermutationMatrix (accessEquiv n loader)

/-- The arbitrary-size semantic access construction is unitary. -/
theorem accessMatrix_unitary (n : Nat) (loader : Equiv.Perm (Word n)) :
    accessMatrix n loader ∈
      _root_.Matrix.unitaryGroup (Word n × Word n) ℂ :=
  Robin.ComplexLCU.equivPermutationMatrix_unitary _

/-- Source-facing single-qubit upper bound printed in Lemma 1 of
arXiv:2405.12855v3.  Natural subtraction is appropriate only in the paper's
stated nontrivial register regime. -/
def paperSingleQubitUpperBound (n l : Nat) : Nat :=
  (2 ^ l + 1) * (32 * n - 48)

/-- Source-facing CNOT upper bound printed in the same lemma. -/
def paperCnotUpperBound (n l : Nat) : Nat :=
  25 * 2 ^ l * n - 36 * 2 ^ l + 32 * n - 48

/-- Source-facing clean-ancilla upper bound printed in the same lemma. -/
def paperPureAncillaUpperBound (n : Nat) : Nat :=
  n - 1

@[simp] theorem paperSingleQubitUpperBound_eq (n l : Nat) :
    paperSingleQubitUpperBound n l = (2 ^ l + 1) * (32 * n - 48) :=
  rfl

@[simp] theorem paperCnotUpperBound_eq (n l : Nat) :
    paperCnotUpperBound n l =
      25 * 2 ^ l * n - 36 * 2 ^ l + 32 * n - 48 :=
  rfl

@[simp] theorem paperPureAncillaUpperBound_eq (n : Nat) :
    paperPureAncillaUpperBound n = n - 1 :=
  rfl

end BandedSparseAccess
end QuantumBlockEncoding
