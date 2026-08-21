import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Reusable flat/product register split for `PrimitiveBasis`

Circuit programs use one flat `PrimitiveBasis q`, while higher-level semantic
contracts are easier to state on products of logical registers.  This module
provides the lossless bridge

`PrimitiveBasis (a+b) ≃ PrimitiveBasis a × PrimitiveBasis b`

with the low `a` wires first and the high `b` wires second.  The construction is
purely about wire layout and is intended to be shared by promise gates, State
Preparation clean-register extensions, and Block Encoding signal/system
registers.
-/

namespace QuantumBlockEncoding
namespace PrimitiveBasisRegisterSplit

/-- Embed a low-register wire into the combined register. -/
def lowWire (a b : Nat) (wire : Fin a) : Fin (a + b) :=
  ⟨wire.val, by omega⟩

/-- Embed a high-register wire after the low-register prefix. -/
def highWire (a b : Nat) (wire : Fin b) : Fin (a + b) :=
  ⟨a + wire.val, by omega⟩

/-- Read the two logical registers from one flat basis state. -/
def splitBasis (a b : Nat) (state : PrimitiveBasis (a + b)) :
    PrimitiveBasis a × PrimitiveBasis b :=
  (fun wire => state (lowWire a b wire),
   fun wire => state (highWire a b wire))

/-- Assemble a flat basis state from low/high logical registers. -/
def combineBasis (a b : Nat)
    (state : PrimitiveBasis a × PrimitiveBasis b) :
    PrimitiveBasis (a + b) :=
  fun wire =>
    if low : wire.val < a then
      state.1 ⟨wire.val, low⟩
    else
      state.2 ⟨wire.val - a, by omega⟩

/-- Splitting after combination returns the original logical registers. -/
theorem splitBasis_combineBasis
    (a b : Nat) (state : PrimitiveBasis a × PrimitiveBasis b) :
    splitBasis a b (combineBasis a b state) = state := by
  apply Prod.ext
  · funext wire
    simp [splitBasis, combineBasis, lowWire]
  · funext wire
    have notLow : ¬(a + wire.val < a) := by omega
    simp [splitBasis, combineBasis, highWire, notLow]

/-- Combining after splitting returns the original flat state. -/
theorem combineBasis_splitBasis
    (a b : Nat) (state : PrimitiveBasis (a + b)) :
    combineBasis a b (splitBasis a b state) = state := by
  funext wire
  by_cases low : wire.val < a
  · have wireEq :
        lowWire a b (⟨wire.val, low⟩ : Fin a) = wire := by
      apply Fin.ext
      rfl
    simp [combineBasis, splitBasis, low, wireEq]
  · have aLe : a ≤ wire.val := by omega
    have highLt : wire.val - a < b := by omega
    have wireEq :
        highWire a b (⟨wire.val - a, highLt⟩ : Fin b) = wire := by
      apply Fin.ext
      simp [highWire]
      omega
    simp [combineBasis, splitBasis, low, wireEq]

/-- Canonical low/high register equivalence. -/
def basisSplitEquiv (a b : Nat) :
    PrimitiveBasis (a + b) ≃
      PrimitiveBasis a × PrimitiveBasis b where
  toFun := splitBasis a b
  invFun := combineBasis a b
  left_inv := combineBasis_splitBasis a b
  right_inv := splitBasis_combineBasis a b

@[simp] theorem basisSplitEquiv_apply
    (a b : Nat) (state : PrimitiveBasis (a + b)) :
    basisSplitEquiv a b state = splitBasis a b state := by
  rfl

@[simp] theorem basisSplitEquiv_symm_apply
    (a b : Nat) (state : PrimitiveBasis a × PrimitiveBasis b) :
    (basisSplitEquiv a b).symm state = combineBasis a b state := by
  rfl

/-- Three-register view obtained by applying the binary split twice. -/
def basisTripleSplitEquiv (a b c : Nat) :
    PrimitiveBasis (a + (b + c)) ≃
      PrimitiveBasis a × PrimitiveBasis b × PrimitiveBasis c :=
  (basisSplitEquiv a (b + c)).trans
    (Equiv.prodCongr (Equiv.refl (PrimitiveBasis a))
      (basisSplitEquiv b c))

/-- The first logical register is the low `a`-wire prefix. -/
theorem basisTripleSplit_first
    (a b c : Nat) (state : PrimitiveBasis (a + (b + c))) :
    (basisTripleSplitEquiv a b c state).1 =
      fun wire => state (lowWire a (b + c) wire) := by
  rfl

end PrimitiveBasisRegisterSplit
end QuantumBlockEncoding
