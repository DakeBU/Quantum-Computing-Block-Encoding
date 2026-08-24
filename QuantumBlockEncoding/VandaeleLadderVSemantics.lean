import QuantumBlockEncoding.VandaeleLadderInverseSemantics
import Mathlib.Tactic

/-!
# Vandaele Definition 2.4: the `V_k^(n)` ladder-difference operator

Vandaele Definition 2.4 introduces

`V_k^(n) = L_k^(n) (L_k^(n-1)† ⊗ I)`.

The tensor identity is important: `L_k^(n-1)†` is not a map on a smaller state
that can be composed naively with `L_k^(n)`.  It must first be embedded into the
same `n`-step register while acting trivially on the final fresh `k`-wire block.

For our positive-order representation `k = localControls + 1`, a full
`n = prefixSteps + 1` ladder state consists of the shared initial pivot followed
by `n` blocks.  The first `prefixSteps` blocks are the support of
`L_k^(n-1)†`; the final block is exactly the tensor-identity factor.

This file certifies that interpretation in two independent ways:

* restricting the embedded action to the prefix is exactly the already proved
  inverse source ladder action for `L_k^(n-1)†`;
* the complete final block (all of its fresh controls and its target) is
  preserved exactly.

It then composes this certified prefix adjoint with the authoritative Equation
(5) permutation for `L_k^(n)`, producing a reversible, source-facing semantics
for `V_k^(n)` without hiding a register-shape coercion in notation.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderVSemantics

open VandaeleLadderContract
open VandaeleLadderEquationFiveSemantics
open VandaeleLadderInverseSemantics

/-- Restrict an `n = prefixSteps + 1` ladder register to its first
`prefixSteps` blocks. -/
def restrictPrefixState {localControls prefixSteps : Nat}
    (state : LadderState localControls (prefixSteps + 1)) :
    LadderState localControls prefixSteps :=
  (state.1, fun index => state.2 index.castSucc)

/-- The predecessor pivot seen by a prefix block is unchanged by embedding that
block into the one-block-larger register. -/
theorem previousPivot_restrictPrefixState
    {localControls prefixSteps : Nat}
    (state : LadderState localControls (prefixSteps + 1))
    (index : Fin prefixSteps) :
    previousPivot (restrictPrefixState state) index =
      previousPivot state index.castSucc := by
  unfold previousPivot restrictPrefixState
  by_cases first : index.val = 0
  · simp [first]
  · simp [first]

/-- Therefore the activation predicate of every prefix block agrees exactly in
the smaller register and in its full-register embedding. -/
theorem ladderActive_restrictPrefixState
    {localControls prefixSteps : Nat}
    (state : LadderState localControls (prefixSteps + 1))
    (index : Fin prefixSteps) :
    ladderActive (restrictPrefixState state) index ↔
      ladderActive state index.castSucc := by
  unfold ladderActive
  rw [previousPivot_restrictPrefixState state index]
  rfl

/-- Restricting one embedded source gate is the same as executing the
corresponding source gate directly on the prefix register.  The proof is kept
at the semantic wire level rather than relying on simplification of dependent
`Function.update` terms. -/
theorem restrictPrefixState_sourceLadderStep
    {localControls prefixSteps : Nat}
    (state : LadderState localControls (prefixSteps + 1))
    (index : Fin prefixSteps) :
    restrictPrefixState
        (sourceLadderStep localControls (prefixSteps + 1) index.castSucc state) =
      sourceLadderStep localControls prefixSteps index
        (restrictPrefixState state) := by
  apply Prod.ext
  · change
      (sourceLadderStep localControls (prefixSteps + 1) index.castSucc state).1 =
        (sourceLadderStep localControls prefixSteps index
          (restrictPrefixState state)).1
    rw [sourceLadderStep_preserves_initialPivot,
      sourceLadderStep_preserves_initialPivot]
    rfl
  · funext query
    apply Prod.ext
    · change
        ((sourceLadderStep localControls (prefixSteps + 1)
          index.castSucc state).2 query.castSucc).1 =
          ((sourceLadderStep localControls prefixSteps index
            (restrictPrefixState state)).2 query).1
      rw [sourceLadderStep_preserves_localControls,
        sourceLadderStep_preserves_localControls]
      rfl
    · by_cases same : query = index
      · subst query
        change
          ((sourceLadderStep localControls (prefixSteps + 1)
            index.castSucc state).2 index.castSucc).2 =
            ((sourceLadderStep localControls prefixSteps index
              (restrictPrefixState state)).2 index).2
        rw [sourceLadderStep_target, sourceLadderStep_target]
        by_cases activeFull : ladderActive state index.castSucc
        · have activePrefixRaw :
              ladderActive (state.1, fun query => state.2 query.castSucc) index := by
            have activePrefix :
                ladderActive (restrictPrefixState state) index :=
              (ladderActive_restrictPrefixState state index).2 activeFull
            simpa only [restrictPrefixState] using activePrefix
          rw [if_pos activeFull, if_pos activePrefixRaw]
        · have inactivePrefixRaw :
              ¬ ladderActive (state.1, fun query => state.2 query.castSucc) index := by
            intro contradiction
            have contradictionPrefix :
                ladderActive (restrictPrefixState state) index := by
              simpa only [restrictPrefixState] using contradiction
            exact activeFull
              ((ladderActive_restrictPrefixState state index).1 contradictionPrefix)
          rw [if_neg activeFull, if_neg inactivePrefixRaw]
      · have castNe : query.castSucc ≠ index.castSucc := by
          intro equalCast
          apply same
          apply Fin.ext
          exact congrArg
            (fun x : Fin (prefixSteps + 1) => x.val) equalCast
        change
          ((sourceLadderStep localControls (prefixSteps + 1)
            index.castSucc state).2 query.castSucc).2 =
            ((sourceLadderStep localControls prefixSteps index
              (restrictPrefixState state)).2 query).2
        rw [sourceLadderStep_preserves_other_target
              index.castSucc query.castSucc state castNe,
          sourceLadderStep_preserves_other_target
              index query (restrictPrefixState state) same]
        rfl

/-- Restriction commutes with an arbitrary chronological list of prefix gates
embedded into the full register. -/
theorem restrictPrefixState_runLadderSteps_map_castSucc
    {localControls prefixSteps : Nat}
    (indices : List (Fin prefixSteps))
    (state : LadderState localControls (prefixSteps + 1)) :
    restrictPrefixState
        (runLadderSteps (indices.map Fin.castSucc) state) =
      runLadderSteps indices (restrictPrefixState state) := by
  induction indices generalizing state with
  | nil => rfl
  | cons index rest induction =>
      simp only [List.map_cons, runLadderSteps]
      calc
        restrictPrefixState
            (runLadderSteps (rest.map Fin.castSucc)
              (sourceLadderStep localControls (prefixSteps + 1)
                index.castSucc state)) =
            runLadderSteps rest
              (restrictPrefixState
                (sourceLadderStep localControls (prefixSteps + 1)
                  index.castSucc state)) :=
          induction
            (sourceLadderStep localControls (prefixSteps + 1)
              index.castSucc state)
        _ = runLadderSteps rest
              (sourceLadderStep localControls prefixSteps index
                (restrictPrefixState state)) := by
          rw [restrictPrefixState_sourceLadderStep state index]

/-- Ascending prefix indices embedded into the full `prefixSteps + 1` register.
This is the full-register chronology for `L_k^(n-1)† ⊗ I`. -/
def embeddedPrefixIndices (prefixSteps : Nat) :
    List (Fin (prefixSteps + 1)) :=
  (List.finRange prefixSteps).map Fin.castSucc

/-- Full-register basis-state action of `L_k^(n-1)† ⊗ I`. -/
def prefixInverseSourceLadderAction (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    LadderState localControls (prefixSteps + 1) :=
  runLadderSteps (embeddedPrefixIndices prefixSteps) state

/-- On the prefix, the embedded action is exactly the previously certified
`L_k^(n-1)†` action.  This rules out a merely analogous gate-list encoding. -/
theorem restrictPrefixState_prefixInverseSourceLadder
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    restrictPrefixState
        (prefixInverseSourceLadderAction localControls prefixSteps state) =
      inverseSourceLadderAction localControls prefixSteps
        (restrictPrefixState state) := by
  unfold prefixInverseSourceLadderAction inverseSourceLadderAction
  unfold embeddedPrefixIndices
  exact restrictPrefixState_runLadderSteps_map_castSucc
    (List.finRange prefixSteps) state

/-- No embedded prefix gate targets the final block. -/
theorem embeddedPrefixIndices_avoids_last
    (prefixSteps : Nat) :
    ∀ step ∈ embeddedPrefixIndices prefixSteps,
      Fin.last prefixSteps ≠ step := by
  intro step stepMem
  rw [embeddedPrefixIndices] at stepMem
  rcases List.mem_map.mp stepMem with ⟨index, _, rfl⟩
  exact ne_of_gt (Fin.castSucc_lt_last index)

/-- The tensor-identity certificate: `L_k^(n-1)† ⊗ I` preserves the complete
final fresh `k`-wire block, not only its target bit. -/
theorem prefixInverseSourceLadder_preserves_lastBlock
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    (prefixInverseSourceLadderAction localControls prefixSteps state).2
        (Fin.last prefixSteps) =
      state.2 (Fin.last prefixSteps) := by
  unfold prefixInverseSourceLadderAction
  apply Prod.ext
  · exact runLadderSteps_preserves_localControls
      (embeddedPrefixIndices prefixSteps) state (Fin.last prefixSteps)
  · exact runLadderSteps_preserves_target_of_avoids
      (embeddedPrefixIndices prefixSteps) state (Fin.last prefixSteps)
      (embeddedPrefixIndices_avoids_last prefixSteps)

/-- The embedded prefix adjoint also preserves the shared initial pivot. -/
@[simp] theorem prefixInverseSourceLadder_preserves_initialPivot
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    (prefixInverseSourceLadderAction localControls prefixSteps state).1 =
      state.1 := by
  unfold prefixInverseSourceLadderAction
  exact runLadderSteps_preserves_initialPivot
    (embeddedPrefixIndices prefixSteps) state

/-- `L_k^(n-1)† ⊗ I` itself is a permutation.  Its inverse runs the same embedded
prefix gates in descending order. -/
def prefixInverseEquiv (localControls prefixSteps : Nat) :
    Equiv.Perm (LadderState localControls (prefixSteps + 1)) where
  toFun := prefixInverseSourceLadderAction localControls prefixSteps
  invFun := runLadderSteps (embeddedPrefixIndices prefixSteps).reverse
  left_inv := by
    intro state
    exact runLadderSteps_reverse_after
      (embeddedPrefixIndices prefixSteps) state
  right_inv := by
    intro state
    exact runLadderSteps_after_reverse
      (embeddedPrefixIndices prefixSteps) state

/-- Authoritative basis-state composition for Vandaele Definition 2.4:
`V_k^(n) = L_k^(n) (L_k^(n-1)† ⊗ I)`, with `n = prefixSteps + 1`. -/
def vandaeleVAction (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    LadderState localControls (prefixSteps + 1) :=
  equationFiveAction localControls (prefixSteps + 1)
    (prefixInverseSourceLadderAction localControls prefixSteps state)

/-- Definition 2.4 packaged as a certified permutation: first apply the embedded
prefix adjoint, then the Equation-(5) permutation for the full ladder. -/
def vandaeleVEquiv (localControls prefixSteps : Nat) :
    Equiv.Perm (LadderState localControls (prefixSteps + 1)) :=
  (prefixInverseEquiv localControls prefixSteps).trans
    (equationFiveEquiv localControls (prefixSteps + 1))

@[simp] theorem vandaeleVEquiv_apply
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    vandaeleVEquiv localControls prefixSteps state =
      vandaeleVAction localControls prefixSteps state := by
  rfl

/-- The full `L_k^(n)` factor can equivalently be executed by the verified
reverse-order source gate list.  Thus the Definition-2.4 semantics is connected
all the way back to the paper's source circuit chronology. -/
theorem sourceLadder_prefixInverse_refines_vandaeleV
    (localControls prefixSteps : Nat)
    (state : LadderState localControls (prefixSteps + 1)) :
    sourceLadderAction localControls (prefixSteps + 1)
        (prefixInverseSourceLadderAction localControls prefixSteps state) =
      vandaeleVAction localControls prefixSteps state := by
  unfold vandaeleVAction
  exact sourceLadder_refines_equationFive localControls (prefixSteps + 1)
    (prefixInverseSourceLadderAction localControls prefixSteps state)

end VandaeleLadderVSemantics
end QuantumBlockEncoding
