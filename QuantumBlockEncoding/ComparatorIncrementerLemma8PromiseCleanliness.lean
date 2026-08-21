import QuantumBlockEncoding.ComparatorIncrementerEq40ControlInvariant

/-!
# Promise-register cleanliness in Vandaele Equation (42)

The passage from Equation (41) to Equation (42) removes some all-X layers from
promise registers.  The source explanation is local and exact.  A controlled
increment on one block is active only when the block immediately above it was
all ones.

There are then two ways that upper block can provide the all-zero promise state:

* before the upper increment has run, apply all-X to the all-ones block;
* after the upper increment has run, do nothing, because a correct modular
  increment already maps the all-ones block to all zero.

This module proves those two promise views coincide on the active branch.  The
two-round scheduler can therefore omit the redundant X layers exactly in the
round described by Equation (42).
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8PromiseCleanliness

open ComparatorIncrementerAllX
open ComparatorIncrementerEq40ControlInvariant
open ComparatorIncrementerGeneral

/-- Promise view used before the upper block has been incremented: complement
an all-ones block into all zero. -/
def promiseViewBeforeIncrement (n : Nat)
    (state : PrimitiveBasis n) : PrimitiveBasis n :=
  allXBasisEquiv n state

/-- Promise view available after the upper block's increment has already run. -/
def promiseViewAfterIncrement (n : Nat)
    (incrementer : PrimitiveBasis n ≃ PrimitiveBasis n)
    (state : PrimitiveBasis n) : PrimitiveBasis n :=
  incrementer state

/-- All-X turns the active all-ones control block into the all-zero promise
state.  The proof intentionally reuses the previously certified involution
rather than redoing flat-index arithmetic. -/
theorem beforeIncrement_active_is_clean
    (n : Nat) :
    promiseViewBeforeIncrement n (allOnesBasisState n) = zeroBasisState n := by
  change
    allXBasisAction (allXBasisAction (zeroBasisState n)) = zeroBasisState n
  exact allXBasisAction_involutive (zeroBasisState n)

/-- A correct incrementer also turns the active all-ones control block into the
all-zero promise state, with no X layer needed. -/
theorem afterIncrement_active_is_clean
    (n : Nat) (incrementer : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n incrementer) :
    promiseViewAfterIncrement n incrementer (allOnesBasisState n) =
      zeroBasisState n := by
  exact incrementerSpec_allOnes_to_zero n incrementer correct

/-- Equation (42) local optimization: on the branch where the lower controlled
promise increment is active, the pre-increment `X` promise view and the
post-increment no-`X` promise view are exactly the same clean state. -/
theorem promise_views_agree_on_active_branch
    (n : Nat) (incrementer : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n incrementer) :
    promiseViewBeforeIncrement n (allOnesBasisState n) =
      promiseViewAfterIncrement n incrementer (allOnesBasisState n) := by
  rw [beforeIncrement_active_is_clean]
  rw [afterIncrement_active_is_clean n incrementer correct]

/-- Pointwise form consumed by a promise-gate implementation expecting every
promise qubit to be zero. -/
theorem afterIncrement_active_promise_bit_zero
    (n : Nat) (incrementer : PrimitiveBasis n ≃ PrimitiveBasis n)
    (correct : IncrementerSpec n incrementer)
    (wire : Fin n) :
    promiseViewAfterIncrement n incrementer (allOnesBasisState n) wire = 0 := by
  rw [afterIncrement_active_is_clean n incrementer correct]
  rfl

end ComparatorIncrementerLemma8PromiseCleanliness
end QuantumBlockEncoding
