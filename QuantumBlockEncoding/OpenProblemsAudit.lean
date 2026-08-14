import QuantumBlockEncoding.OpenProblems
import Mathlib.Tactic

/-!
# Machine checks for the open-problem registry

The mathematical problems intentionally remain open.  What this module closes
is the library route promised by the teaching page: the registry is finite,
uses stable distinct identifiers, and gives every entry a nonempty statement,
acceptance test, and reference list.
-/

namespace QuantumBlockEncoding

/-- Stable list of the published problem identifiers. -/
def openProblemIds : List String := openProblems.map OpenProblem.id

/-- Every public registry entry carries enough data to be actionable. -/
def OpenProblem.actionable (problem : OpenProblem) : Prop :=
  problem.id ≠ "" ∧
  problem.title ≠ "" ∧
  problem.statement ≠ "" ∧
  problem.acceptanceTest ≠ "" ∧
  problem.references ≠ []

instance (problem : OpenProblem) : Decidable problem.actionable := by
  unfold OpenProblem.actionable
  infer_instance

/-- The current registry contains seven explicitly scoped problems. -/
theorem openProblems_count : problemCount = 7 := by
  decide

/-- Problem identifiers are unique, so memories and task packets cannot collide. -/
theorem openProblemIds_nodup : openProblemIds.Nodup := by
  decide

/-- Every current problem has a nonempty statement, acceptance test, and source list. -/
theorem openProblems_all_actionable :
    ∀ problem ∈ openProblems, problem.actionable := by
  intro problem membership
  simp [openProblems] at membership
  rcases membership with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    decide

/-- The registry itself is a compiled artifact even though its entries remain open research. -/
theorem openProblemRegistry_compiled :
    problemCount = 7 ∧ openProblemIds.Nodup ∧
      (∀ problem ∈ openProblems, problem.actionable) := by
  exact ⟨openProblems_count, openProblemIds_nodup,
    openProblems_all_actionable⟩

end QuantumBlockEncoding
