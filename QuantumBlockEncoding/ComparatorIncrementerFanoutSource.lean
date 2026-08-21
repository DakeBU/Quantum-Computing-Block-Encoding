import QuantumBlockEncoding.ComparatorIncrementerFanoutIdentity
import Mathlib.Tactic

/-!
# Source contract for Vandaele Definition 2.2 fan-out

Vandaele Definition 2.2 introduces the k-th order fan-out operator
`F_k^(n)`.  There is one global control bit `c`; for each block `i` there are
`k` local control bits `x_i` and one target bit `t_i`.  The operator preserves
all controls and maps

`t_i ↦ t_i XOR (c AND AND_j x_{i,j})`.

This file formalizes that source statement as an exact finite permutation.
Lemma 2 of the paper additionally states that the first- and second-order
families admit O(n) `{CCX,CX}` gate count and O(log n) depth.  No such resource
claim is assumed here: a later ASPBE layer must provide an actual circuit family
and prove those bounds before Lemma 2 can be promoted from source-backed memory
to a formalized result.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerFanoutSource

open ComparatorIncrementerFanoutIdentity

/-- One source fan-out block: k local controls and one target. -/
abbrev FanoutBlock (k : Nat) := PrimitiveBasis k × Fin 2

/-- Source register shape for `F_k^(n)`: one global control and n blocks. -/
abbrev FanoutState (k n : Nat) := Fin 2 × (Fin n → FanoutBlock k)

/-- Boolean conjunction of the global control and all k local controls. -/
def fanoutActive {k : Nat} (global : Fin 2)
    (local : PrimitiveBasis k) : Bool :=
  if global = 1 ∧ ∀ wire, local wire = 1 then true else false

@[simp] theorem fanoutActive_global_zero {k : Nat}
    (local : PrimitiveBasis k) : fanoutActive 0 local = false := by
  simp [fanoutActive]

/-- Exact computational-basis action from Definition 2.2. -/
def sourceFanoutAction (k n : Nat) (state : FanoutState k n) :
    FanoutState k n :=
  (state.1, fun index =>
    let block := state.2 index
    (block.1, toggleBit (fanoutActive state.1 block.1) block.2))

/-- Definition 2.2 is reversible because every target is toggled by a predicate
that depends only on controls, all of which are preserved. -/
theorem sourceFanoutAction_involutive (k n : Nat) :
    Function.Involutive (sourceFanoutAction k n) := by
  intro state
  rcases state with ⟨global, blocks⟩
  apply Prod.ext
  · rfl
  · funext index
    apply Prod.ext
    · rfl
    · simpa [sourceFanoutAction] using
        toggleBit_involutive
          (fanoutActive global (blocks index).1) (blocks index).2

/-- Exact basis permutation corresponding to Vandaele `F_k^(n)`. -/
def sourceFanoutEquiv (k n : Nat) :
    Equiv.Perm (FanoutState k n) where
  toFun := sourceFanoutAction k n
  invFun := sourceFanoutAction k n
  left_inv := sourceFanoutAction_involutive k n
  right_inv := sourceFanoutAction_involutive k n

/-- Source-facing correctness proposition.  Circuit implementations should
refine to this object rather than restating the fan-out semantics ad hoc. -/
def FanoutSpec (k n : Nat)
    (permutation : Equiv.Perm (FanoutState k n)) : Prop :=
  permutation = sourceFanoutEquiv k n

@[simp] theorem sourceFanoutEquiv_satisfies_spec (k n : Nat) :
    FanoutSpec k n (sourceFanoutEquiv k n) := by
  rfl

/-- The global control is preserved exactly. -/
theorem sourceFanout_preserves_global
    (k n : Nat) (state : FanoutState k n) :
    (sourceFanoutEquiv k n state).1 = state.1 := by
  rfl

/-- Every local control word is preserved exactly. -/
theorem sourceFanout_preserves_local
    (k n : Nat) (state : FanoutState k n) (index : Fin n) :
    ((sourceFanoutEquiv k n state).2 index).1 = (state.2 index).1 := by
  rfl

/-- Exact target equation from Definition 2.2. -/
theorem sourceFanout_target
    (k n : Nat) (state : FanoutState k n) (index : Fin n) :
    ((sourceFanoutEquiv k n state).2 index).2 =
      toggleBit
        (fanoutActive state.1 (state.2 index).1)
        (state.2 index).2 := by
  rfl

/-- With global control zero the entire fan-out operator is the identity. -/
theorem sourceFanout_global_zero
    (k n : Nat) (blocks : Fin n → FanoutBlock k) :
    sourceFanoutEquiv k n (0, blocks) = (0, blocks) := by
  apply Prod.ext
  · rfl
  · funext index
    apply Prod.ext
    · rfl
    · simp [sourceFanoutEquiv, sourceFanoutAction, fanoutActive, toggleBit]

/-- Empty local-control register used by the order-zero specialization. -/
def emptyLocalControls : PrimitiveBasis 0 :=
  fun wire => Fin.elim0 wire

/-- For k=0 the empty local conjunction is true, so the fan-out reduces to one
single pivot/global control toggling every target. -/
@[simp] theorem fanoutActive_zero_order (global : Fin 2) :
    fanoutActive global emptyLocalControls =
      (if global = 1 then true else false) := by
  fin_cases global <;> simp [fanoutActive, emptyLocalControls]

/-- Pack plain target bits into the k=0 source register. -/
def zeroOrderBlocks {n : Nat} (targets : Fin n → Fin 2) :
    Fin n → FanoutBlock 0 :=
  fun index => (emptyLocalControls, targets index)

/-- Target action of the zero-order source fan-out agrees with ordinary
single-control fan-out semantics. -/
theorem sourceFanout_zero_order_target
    (n : Nat) (global : Fin 2) (targets : Fin n → Fin 2)
    (index : Fin n) :
    ((sourceFanoutEquiv 0 n (global, zeroOrderBlocks targets)).2 index).2 =
      if global = 1 then flipBit (targets index) else targets index := by
  fin_cases global <;>
    simp [sourceFanoutEquiv, sourceFanoutAction, zeroOrderBlocks,
      fanoutActive, emptyLocalControls, toggleBit]

/-- Data-only reminder of the two orders covered by source Lemma 2.  This is not
an asymptotic proof object; it prevents downstream code from silently treating
all k as covered by that lemma. -/
def lemmaTwoCoveredOrder (k : Nat) : Prop := k = 1 ∨ k = 2

@[simp] theorem lemmaTwo_covers_one : lemmaTwoCoveredOrder 1 := by
  exact Or.inl rfl

@[simp] theorem lemmaTwo_covers_two : lemmaTwoCoveredOrder 2 := by
  exact Or.inr rfl

end ComparatorIncrementerFanoutSource
end QuantumBlockEncoding
