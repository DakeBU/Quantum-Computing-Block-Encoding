import QuantumBlockEncoding.ScheduledWireEmbedding

/-!
# Pointwise semantics for scheduled wire embeddings

The schedule-level embedding theorem already identifies the entire logical child
state after execution.  Recursive correctness proofs usually need two smaller
rewrite rules instead:

* on an embedded physical wire, read the corresponding logical child output;
* outside the embedding image, the parent wire is unchanged.

These are direct corollaries of the existing proof-bearing program transport and
introduce no new circuit assumptions.
-/

namespace QuantumBlockEncoding
namespace ScheduledWireEmbedding

open ReversibleWireEmbedding

/-- Pointwise form of `readEmbeddedState_eval_mapScheduledWires`. -/
theorem eval_mapScheduledWires_on_image
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small)
    (state : PrimitiveBasis large)
    (logical : Fin small) :
    evalReversibleProgram
        (mapScheduledWires embed injective scheduled).program state
        (embed logical) =
      evalReversibleProgram scheduled.program
        (readEmbeddedState embed state) logical := by
  have whole := readEmbeddedState_eval_mapScheduledWires
    embed injective scheduled state
  exact congrFun whole logical

/-- A scheduled child leaves every physical wire outside its embedding image
unchanged. -/
theorem eval_mapScheduledWires_outside
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small)
    (state : PrimitiveBasis large)
    (wire : Fin large)
    (outside : ∀ logical, embed logical ≠ wire) :
    evalReversibleProgram
        (mapScheduledWires embed injective scheduled).program state wire =
      state wire := by
  rw [mapScheduledWires_program]
  exact ReversibleWireEmbedding.eval_mapProgramWires_outside
    embed injective scheduled.program state wire outside

end ScheduledWireEmbedding
end QuantumBlockEncoding
