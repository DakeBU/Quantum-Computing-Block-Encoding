import QuantumBlockEncoding.ReversibleLayerSemantics
import QuantumBlockEncoding.ReversibleProgramSupport
import Mathlib.Tactic

/-!
# Commutation of wire-disjoint reversible programs

Parallel source circuits are flattened to chronological lists in the proof IR.
To justify layerwise merging we need the semantic fact that gates/programs with
disjoint physical support commute exactly.
-/

namespace QuantumBlockEncoding
namespace ReversibleCommutation

open ReversibleLayerSemantics
open ReversibleProgramSupport

/-- Two wire-disjoint reversible gates commute as basis permutations. -/
theorem eval_gate_commute
    {q : Nat} (left right : ReversibleGate q)
    (disjoint : ReversibleGate.WireDisjoint left right) :
    (evalReversibleGate left).trans (evalReversibleGate right) =
      (evalReversibleGate right).trans (evalReversibleGate left) := by
  apply Equiv.ext
  intro state
  funext wire
  by_cases leftTouches : left.touches wire
  · have rightNotTarget := notTargets_of_wireDisjoint_touched
      disjoint wire leftTouches
    rw [evalReversibleGate_apply_of_not_targets right wire
      (evalReversibleGate left state) rightNotTarget]
    have inputAgreement : ∀ query, left.touches query ->
        evalReversibleGate right state query = state query := by
      exact eval_gate_preserves_touches_of_disjoint
        (ReversibleGate.wireDisjoint_symm disjoint) state
    exact (evalReversibleGate_congr_on_touches
      left (evalReversibleGate right state) state
      inputAgreement wire leftTouches).symm
  · by_cases rightTouches : right.touches wire
    · have leftNotTarget := notTargets_of_wireDisjoint_touched
        (ReversibleGate.wireDisjoint_symm disjoint) wire rightTouches
      rw [evalReversibleGate_apply_of_not_targets left wire state leftNotTarget]
      have inputAgreement : ∀ query, right.touches query ->
          evalReversibleGate left state query = state query := by
        exact eval_gate_preserves_touches_of_disjoint disjoint state
      exact evalReversibleGate_congr_on_touches
        right (evalReversibleGate left state) state
        inputAgreement wire rightTouches
    · have leftNotTarget :=
        ReversibleGateUnusedWireParity.notTargets_of_notTouches left wire leftTouches
      have rightNotTarget :=
        ReversibleGateUnusedWireParity.notTargets_of_notTouches right wire rightTouches
      simp only [Equiv.trans_apply]
      rw [evalReversibleGate_apply_of_not_targets left wire state leftNotTarget]
      rw [evalReversibleGate_apply_of_not_targets right wire state rightNotTarget]
      rw [evalReversibleGate_apply_of_not_targets right wire
        (evalReversibleGate left state) rightNotTarget]
      rw [evalReversibleGate_apply_of_not_targets left wire
        (evalReversibleGate right state) leftNotTarget]

/-- Every gate of one program is disjoint from every gate of another. -/
def ProgramsWireDisjoint {q : Nat}
    (left right : ReversibleProgram q) : Prop :=
  ∀ leftGate ∈ left, ∀ rightGate ∈ right,
    ReversibleGate.WireDisjoint leftGate rightGate

/-- Symmetry of program disjointness. -/
theorem programsWireDisjoint_symm
    {q : Nat} {left right : ReversibleProgram q}
    (disjoint : ProgramsWireDisjoint left right) :
    ProgramsWireDisjoint right left := by
  intro r rm l lm
  exact ReversibleGate.wireDisjoint_symm (disjoint l lm r rm)

/-- One gate commutes with an entire disjoint program. -/
theorem eval_gate_program_commute
    {q : Nat} (gate : ReversibleGate q)
    (program : ReversibleProgram q)
    (disjoint : ∀ other ∈ program,
      ReversibleGate.WireDisjoint gate other) :
    (evalReversibleGate gate).trans (evalReversibleProgram program) =
      (evalReversibleProgram program).trans (evalReversibleGate gate) := by
  induction program with
  | nil =>
      apply Equiv.ext
      intro state
      rfl
  | cons head rest induction =>
      have headDisjoint := disjoint head (by simp)
      have restDisjoint : ∀ other ∈ rest,
          ReversibleGate.WireDisjoint gate other := by
        intro other member
        exact disjoint other (by simp [member])
      change
        (evalReversibleGate gate).trans
            ((evalReversibleGate head).trans (evalReversibleProgram rest)) =
          ((evalReversibleGate head).trans (evalReversibleProgram rest)).trans
            (evalReversibleGate gate)
      rw [← Equiv.trans_assoc, eval_gate_commute gate head headDisjoint]
      rw [Equiv.trans_assoc]
      rw [induction restDisjoint]
      rfl

/-- Two completely disjoint programs commute. -/
theorem eval_programs_commute
    {q : Nat} (left right : ReversibleProgram q)
    (disjoint : ProgramsWireDisjoint left right) :
    (evalReversibleProgram left).trans (evalReversibleProgram right) =
      (evalReversibleProgram right).trans (evalReversibleProgram left) := by
  induction left with
  | nil =>
      apply Equiv.ext
      intro state
      rfl
  | cons head rest induction =>
      have headDisjoint : ∀ other ∈ right,
          ReversibleGate.WireDisjoint head other := by
        intro other member
        exact disjoint head (by simp) other member
      have restDisjoint : ProgramsWireDisjoint rest right := by
        intro l lm r rm
        exact disjoint l (by simp [lm]) r rm
      change
        ((evalReversibleGate head).trans (evalReversibleProgram rest)).trans
            (evalReversibleProgram right) =
          (evalReversibleProgram right).trans
            ((evalReversibleGate head).trans (evalReversibleProgram rest))
      rw [Equiv.trans_assoc]
      rw [induction restDisjoint]
      rw [← Equiv.trans_assoc]
      rw [eval_gate_program_commute head right headDisjoint]
      rfl

/-- Concatenating two disjoint programs in either order has the same semantics. -/
theorem eval_append_commute
    {q : Nat} (left right : ReversibleProgram q)
    (disjoint : ProgramsWireDisjoint left right) :
    evalReversibleProgram (left ++ right) =
      evalReversibleProgram (right ++ left) := by
  rw [evalReversibleProgram_append, evalReversibleProgram_append]
  exact eval_programs_commute left right disjoint

end ReversibleCommutation
end QuantumBlockEncoding
