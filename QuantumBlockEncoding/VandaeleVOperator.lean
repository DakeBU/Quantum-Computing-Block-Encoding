import QuantumBlockEncoding.VandaeleLadderRefinement

/-!
# Vandaele Definition 2.4: V operators

With the corrected reverse ladder chronology, the actual naive ladder
permutation has now been proved equal to the authoritative Equation-(5) target.
Definition 2.4 can therefore be represented without introducing a new semantic
oracle.

On an `(n+1)`-block register, let `Lprefix` be the embedded n-block ladder and
`Lfull` the `(n+1)`-block ladder.  The source operator is

`V = Lprefix^† ; Lfull`.

Both ladders are already source-certified.  Since
`Lfull = G_last ; Lprefix`, this is exactly

`V = Lprefix^† ; G_last ; Lprefix`,

the Equation-(18) decomposition used for `V_2` in the comparator section.
-/

namespace QuantumBlockEncoding
namespace VandaeleVOperator

open VandaeleLadderContract
open VandaeleLadderPermutation
open VandaeleLadderRefinement

/-- Closed-form prefix target: Equation (5) on the first n blocks of an
`(n+1)`-block register, leaving the final block untouched. -/
def prefixEquationFiveAction
    (localControls n : Nat)
    (state : LadderState localControls (n + 1)) :
    LadderState localControls (n + 1) :=
  equationFivePrefixAction localControls (n + 1) n state

/-- The proof-bearing prefix ladder realizes that embedded closed-form target. -/
theorem prefixNaiveLadder_correct
    (localControls n : Nat)
    (state : LadderState localControls (n + 1)) :
    prefixNaiveLadderEquiv localControls n state =
      prefixEquationFiveAction localControls n state := by
  exact descendingLadderEquiv_eq_prefix
    localControls (n + 1) n (by omega) state

/-- The full ladder is the authoritative Equation-(5) operator. -/
theorem fullNaiveLadder_correct
    (localControls n : Nat) :
    LadderSpec localControls (n + 1)
      (naiveLadderEquiv localControls (n + 1)) :=
  naiveLadderEquiv_spec localControls (n + 1)

/-- Source Definition-2.4 V operator on an `(n+1)`-block register. -/
def sourceVSuccEquiv (localControls n : Nat) :
    Equiv.Perm (LadderState localControls (n + 1)) :=
  (prefixNaiveLadderEquiv localControls n).symm.trans
    (naiveLadderEquiv localControls (n + 1))

/-- Source-facing V correctness proposition. -/
def VSuccSpec (localControls n : Nat)
    (implementation : Equiv.Perm (LadderState localControls (n + 1))) : Prop :=
  implementation = sourceVSuccEquiv localControls n

@[simp] theorem sourceVSuccEquiv_spec (localControls n : Nat) :
    VSuccSpec localControls n (sourceVSuccEquiv localControls n) := by
  rfl

/-- The source V target is definitionally the already proof-bearing naive V
permutation. -/
theorem sourceVSucc_eq_naiveV
    (localControls n : Nat) :
    sourceVSuccEquiv localControls n = naiveVSuccEquiv localControls n := by
  rfl

/-- Definition 2.4 plus the reverse-ladder decomposition gives the exact
V-shaped conjugation by the final `C^(localControls+1) X` gate. -/
theorem sourceVSucc_eq_conjugated_lastGate
    (localControls n : Nat) :
    sourceVSuccEquiv localControls n =
      ((prefixNaiveLadderEquiv localControls n).symm.trans
        (ladderStepEquiv localControls (n + 1) ⟨n, by omega⟩)).trans
          (prefixNaiveLadderEquiv localControls n) := by
  exact naiveVSucc_eq_conjugated_lastGate localControls n

/-- Comparator-specialized `V_2`.  Here `localControls=1`, hence each ladder
step/final middle gate is CCX. -/
def sourceV2SuccEquiv (n : Nat) :
    Equiv.Perm (LadderState 1 (n + 1)) :=
  sourceVSuccEquiv 1 n

/-- Exact Equation (18) for the source-certified V2 operator. -/
theorem equationEighteen_sourceV2
    (n : Nat) :
    sourceV2SuccEquiv n =
      ((prefixNaiveLadderEquiv 1 n).symm.trans
        (ladderStepEquiv 1 (n + 1) ⟨n, by omega⟩)).trans
          (prefixNaiveLadderEquiv 1 n) := by
  exact sourceVSucc_eq_conjugated_lastGate 1 n

end VandaeleVOperator
end QuantumBlockEncoding
