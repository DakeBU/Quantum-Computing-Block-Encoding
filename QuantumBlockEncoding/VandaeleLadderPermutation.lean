import QuantumBlockEncoding.VandaeleLadderContract
import Mathlib.Tactic

/-!
# Reversible ladder permutation and V-shaped conjugation

The source ladder target is the closed-form Equation (5).  Its naive circuit is
most conveniently represented on one fixed total register by a descending
recursion: with `count` active blocks inside a register containing `total`
blocks, execute block `count-1` first and continue downward.

Each individual ladder gate is self-inverse because its activation predicate
depends on the preceding pivot and fresh controls, never on its own target.
This gives a proof-bearing permutation for the naive gate list.

The reverse chronology makes Definition 2.4 transparent.  On an `(n+1)`-block
register,

`L^(n+1) = G_n ; L^n_prefix`.

Therefore

`(L^n_prefix)^† ; L^(n+1)
 = (L^n_prefix)^† ; G_n ; L^n_prefix`,

which is exactly the V-shaped decomposition used as Equation (18) for k=2.
The eventual source correctness theorem must additionally discharge
`NaiveLadderRefinement`, identifying this gate permutation with closed-form
Equation (5).
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderPermutation

open VandaeleLadderContract

/-- A source step preserves every other block target. -/
theorem sourceLadderStep_preserves_other_target
    (localControls steps : Nat)
    (index query : Fin steps) (different : query ≠ index)
    (state : LadderState localControls steps) :
    ((sourceLadderStep localControls steps index state).2 query).2 =
      (state.2 query).2 := by
  by_cases active : ladderActive state index
  · simp [sourceLadderStep, active, different]
  · simp [sourceLadderStep, active]

/-- The preceding pivot used by one gate is unchanged when that same gate is
applied. -/
theorem previousPivot_sourceLadderStep_same
    (localControls steps : Nat)
    (index : Fin steps)
    (state : LadderState localControls steps) :
    previousPivot (sourceLadderStep localControls steps index state) index =
      previousPivot state index := by
  by_cases first : index.val = 0
  · simp [previousPivot, first,
      sourceLadderStep_preserves_initialPivot]
  · let previous : Fin steps := ⟨index.val - 1, by omega⟩
    have different : previous ≠ index := by
      intro equal
      have values := congrArg Fin.val equal
      simp [previous] at values
      omega
    rw [previousPivot_nonfirst
      (sourceLadderStep localControls steps index state) index first]
    rw [previousPivot_nonfirst state index first]
    exact sourceLadderStep_preserves_other_target
      localControls steps index previous different
      state

/-- A gate's activation predicate is invariant under that gate itself. -/
theorem ladderActive_sourceLadderStep_iff
    (localControls steps : Nat)
    (index : Fin steps)
    (state : LadderState localControls steps) :
    ladderActive (sourceLadderStep localControls steps index state) index ↔
      ladderActive state index := by
  unfold ladderActive
  rw [previousPivot_sourceLadderStep_same]
  rw [sourceLadderStep_preserves_localControls
    localControls steps index index]

/-- One source ladder gate is self-inverse. -/
theorem sourceLadderStep_involutive
    (localControls steps : Nat) (index : Fin steps) :
    Function.Involutive (sourceLadderStep localControls steps index) := by
  intro state
  by_cases active : ladderActive state index
  · have activeAfter :
        ladderActive (sourceLadderStep localControls steps index state) index :=
      (ladderActive_sourceLadderStep_iff
        localControls steps index state).2 active
    let updated : LadderState localControls steps :=
      (state.1,
        Function.update state.2 index
          ((state.2 index).1, flipBit (state.2 index).2))
    have firstStep :
        sourceLadderStep localControls steps index state = updated := by
      simp [sourceLadderStep, active, updated]
    have activeUpdated : ladderActive updated index := by
      rw [← firstStep]
      exact activeAfter
    rw [firstStep]
    simp only [sourceLadderStep, if_pos activeUpdated]
    apply Prod.ext
    · rfl
    · funext query
      by_cases same : query = index
      · subst query
        simp [updated, flipBit_flipBit]
      · simp [updated, same]
  · simp [sourceLadderStep, active]

/-- Proof-bearing permutation of one naive ladder gate. -/
def ladderStepEquiv
    (localControls steps : Nat) (index : Fin steps) :
    Equiv.Perm (LadderState localControls steps) where
  toFun := sourceLadderStep localControls steps index
  invFun := sourceLadderStep localControls steps index
  left_inv := sourceLadderStep_involutive localControls steps index
  right_inv := sourceLadderStep_involutive localControls steps index

/-- Descending composition of the first `count` block gates inside one fixed
`total`-block register. -/
def descendingLadderEquiv (localControls total : Nat) :
    (count : Nat) → count ≤ total →
      Equiv.Perm (LadderState localControls total)
  | 0, _ => Equiv.refl _
  | count + 1, bound =>
      (ladderStepEquiv localControls total ⟨count, by omega⟩).trans
        (descendingLadderEquiv localControls total count (by omega))

/-- Full naive reverse-order ladder permutation. -/
def naiveLadderEquiv (localControls steps : Nat) :
    Equiv.Perm (LadderState localControls steps) :=
  descendingLadderEquiv localControls steps steps (Nat.le_refl _)

/-- Prefix `L^n` embedded in an `(n+1)`-block register, leaving the final block
untouched. -/
def prefixNaiveLadderEquiv (localControls n : Nat) :
    Equiv.Perm (LadderState localControls (n + 1)) :=
  descendingLadderEquiv localControls (n + 1) n (by omega)

/-- The full `(n+1)`-block reverse ladder is last gate followed by the embedded
n-block prefix. -/
theorem naiveLadder_succ_decomposition
    (localControls n : Nat) :
    naiveLadderEquiv localControls (n + 1) =
      (ladderStepEquiv localControls (n + 1) ⟨n, by omega⟩).trans
        (prefixNaiveLadderEquiv localControls n) := by
  rfl

/-- Naive Definition-2.4 V target on an `(n+1)`-block register: first undo the
embedded prefix ladder, then run the full ladder. -/
def naiveVSuccEquiv (localControls n : Nat) :
    Equiv.Perm (LadderState localControls (n + 1)) :=
  (prefixNaiveLadderEquiv localControls n).symm.trans
    (naiveLadderEquiv localControls (n + 1))

/-- Equation (18) / V-shaped conjugation identity. -/
theorem naiveVSucc_eq_conjugated_lastGate
    (localControls n : Nat) :
    naiveVSuccEquiv localControls n =
      ((prefixNaiveLadderEquiv localControls n).symm.trans
        (ladderStepEquiv localControls (n + 1) ⟨n, by omega⟩)).trans
          (prefixNaiveLadderEquiv localControls n) := by
  unfold naiveVSuccEquiv
  rw [naiveLadder_succ_decomposition]
  rfl

/-- k=2 specialization used throughout the comparator section. -/
def naiveV2SuccEquiv (n : Nat) :
    Equiv.Perm (LadderState 1 (n + 1)) :=
  naiveVSuccEquiv 1 n

/-- Exact source-facing Equation-(18) statement for k=2. -/
theorem equationEighteen_V2
    (n : Nat) :
    naiveV2SuccEquiv n =
      ((prefixNaiveLadderEquiv 1 n).symm.trans
        (ladderStepEquiv 1 (n + 1) ⟨n, by omega⟩)).trans
          (prefixNaiveLadderEquiv 1 n) := by
  exact naiveVSucc_eq_conjugated_lastGate 1 n

/-- Once the naive ladder refinement to Equation (5) is supplied for a fixed
width, the same proof-bearing permutation becomes a valid LadderSpec witness. -/
theorem naiveLadderEquiv_satisfies_spec_of_refinement
    (localControls steps : Nat)
    (refinement : NaiveLadderRefinement localControls steps)
    (actionBridge : ∀ state,
      naiveLadderEquiv localControls steps state =
        sourceLadderAction localControls steps state) :
    LadderSpec localControls steps (naiveLadderEquiv localControls steps) := by
  intro state
  rw [actionBridge state]
  exact refinement state

end VandaeleLadderPermutation
end QuantumBlockEncoding
