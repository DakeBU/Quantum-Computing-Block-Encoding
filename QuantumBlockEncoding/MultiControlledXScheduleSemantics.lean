import QuantumBlockEncoding.MultiControlledXEmbedding
import Mathlib.Tactic

/-!
# Exact semantics for composed and embedded MCX schedules

The source-level MCX IR already carries gate semantics, schedule validity, and
injective wire embeddings.  Remaud--Vandaele Algorithm 2 additionally needs a
small semantic API for reasoning compositionally about the proof-bearing
schedule itself:

* chronological program append evaluates by state threading;
* scheduled `seq` therefore evaluates left, then right;
* an embedded scheduled circuit reads back exactly as the logical circuit;
* every physical wire outside the embedding image is preserved.

These are deliberately generic library lemmas.  They are the semantic bridge
needed before proving Algorithm 2 refines the closed-form Equation (7) target.
-/

namespace QuantumBlockEncoding
namespace MultiControlledXScheduleSemantics

open MultiControlledXEmbedding
open MultiControlledXSchedule

/-- Chronological append threads the output of the left MCX program into the
right MCX program. -/
theorem evalProgram_append
    {q : Nat} (left right : MCXProgram q)
    (state : PrimitiveBasis q) :
    evalProgram (left ++ right) state =
      evalProgram right (evalProgram left state) := by
  induction left generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      change
        evalProgram (rest ++ right) (gateAction gate state) =
          evalProgram right (evalProgram rest (gateAction gate state))
      exact induction (gateAction gate state)

/-- Proof-bearing schedule composition has the expected exact state semantics. -/
theorem seq_eval
    {q : Nat} (left right : ScheduledMCXProgram q)
    (state : PrimitiveBasis q) :
    (ScheduledMCXProgram.seq left right).eval state =
      right.eval (left.eval state) := by
  change
    evalProgram (ScheduledMCXProgram.seq left right).program state =
      evalProgram right.program (evalProgram left.program state)
  rw [ScheduledMCXProgram.seq_program]
  exact evalProgram_append left.program right.program state

/-- Reading an embedded scheduled computation through the logical embedding
recovers exactly the original scheduled computation. -/
theorem readEmbedded_evalScheduled
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledMCXProgram small)
    (state : PrimitiveBasis large) :
    readEmbedded embed
        ((mapScheduled embed injective scheduled).eval state) =
      scheduled.eval (readEmbedded embed state) := by
  change
    readEmbedded embed
        (evalProgram (mapScheduled embed injective scheduled).program state) =
      evalProgram scheduled.program (readEmbedded embed state)
  rw [mapScheduled_program]
  exact readEmbedded_evalProgram embed injective scheduled.program state

/-- An embedded scheduled computation leaves every physical wire outside the
embedding image unchanged. -/
theorem evalMappedScheduled_outside
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledMCXProgram small)
    (state : PrimitiveBasis large)
    (wire : Fin large)
    (outside : ∀ logical, embed logical ≠ wire) :
    (mapScheduled embed injective scheduled).eval state wire = state wire := by
  change
    evalProgram (mapScheduled embed injective scheduled).program state wire =
      state wire
  rw [mapScheduled_program]
  exact evalProgram_outside embed injective scheduled.program state wire outside

end MultiControlledXScheduleSemantics
end QuantumBlockEncoding
