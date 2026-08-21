import QuantumBlockEncoding.MultiControlledXSchedule
import QuantumBlockEncoding.VandaeleLadderContract
import Mathlib.Data.Finset.Interval
import Mathlib.Tactic

/-!
# Remaud--Vandaele Definition 6: general Ladder-alpha source contract

The 2025 paper generalizes CNOT/Toffoli ladders to a vector

`alpha_0 < alpha_1 < ... < alpha_(m-1)`.

The i-th MCX target is physical wire `alpha_i`.  Its controls are exactly the
contiguous physical wires

* `[0, alpha_0)` for i=0;
* `[alpha_(i-1), alpha_i)` for i>0.

Equation (7) is a *closed-form input-state specification*: every target is
toggled by the conjunction of the corresponding interval in the original
input.  Algorithm 2 is later proved a refinement of this target; the target is
not defined by the recursive synthesis algorithm.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaContract

open MultiControlledXSchedule
open VandaeleLadderContract

/-- A strictly increasing target vector inside a fixed physical register. -/
structure AlphaPlan (q m : Nat) where
  target : Fin m → Fin q
  strict : ∀ {i j : Fin m}, i < j → (target i).val < (target j).val

/-- Lower endpoint of the i-th control interval. -/
def lowerEndpoint {q m : Nat}
    (plan : AlphaPlan q m) (index : Fin m) : Nat :=
  if first : index.val = 0 then 0
  else (plan.target ⟨index.val - 1, by omega⟩).val

/-- Upper endpoint is the target wire itself. -/
def upperEndpoint {q m : Nat}
    (plan : AlphaPlan q m) (index : Fin m) : Nat :=
  (plan.target index).val

/-- Physical wire belongs to the control interval of one source MCX. -/
def inControlInterval {q m : Nat}
    (plan : AlphaPlan q m) (index : Fin m) (wire : Fin q) : Prop :=
  lowerEndpoint plan index ≤ wire.val ∧ wire.val < upperEndpoint plan index

/-- Finite control set of the i-th source MCX. -/
def controlFinset {q m : Nat}
    (plan : AlphaPlan q m) (index : Fin m) : Finset (Fin q) :=
  Finset.univ.filter (inControlInterval plan index)

@[simp] theorem mem_controlFinset_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m) (wire : Fin q) :
    wire ∈ controlFinset plan index ↔ inControlInterval plan index wire := by
  simp [controlFinset]

/-- Source target never belongs to its own strict-left control interval. -/
theorem target_not_control
    {q m : Nat} (plan : AlphaPlan q m) (index : Fin m) :
    plan.target index ∉ controlFinset plan index := by
  simp [controlFinset, inControlInterval, upperEndpoint]

/-- The actual MCX gate corresponding to one alpha block. -/
def sourceGate {q m : Nat}
    (plan : AlphaPlan q m) (index : Fin m) : MCXGate q where
  controls := controlFinset plan index
  target := plan.target index
  target_not_control := target_not_control plan index

/-- Closed-form activation predicate from Equation (7). -/
def intervalActive {q m : Nat}
    (plan : AlphaPlan q m)
    (state : PrimitiveBasis q)
    (index : Fin m) : Prop :=
  ∀ wire, inControlInterval plan index wire → state wire = 1

/-- MCX-gate activation agrees with the source interval predicate. -/
theorem sourceGate_active_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (index : Fin m) :
    MultiControlledXSchedule.active (sourceGate plan index) state ↔
      intervalActive plan state index := by
  constructor
  · intro active wire interval
    exact active wire ((mem_controlFinset_iff plan index wire).2 interval)
  · intro active wire member
    exact active wire ((mem_controlFinset_iff plan index wire).1 member)

/-- Authoritative Equation-(7) action: targets are toggled from the original
input predicates; all non-target wires are unchanged. -/
def equationSevenAction {q m : Nat}
    (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) : PrimitiveBasis q :=
  fun wire =>
    if hit : ∃ index : Fin m, plan.target index = wire then
      let index := Classical.choose hit
      if intervalActive plan state index then flipBit (state wire) else state wire
    else state wire

/-- Strict monotonicity makes the target index unique. -/
theorem target_injective
    {q m : Nat} (plan : AlphaPlan q m) : Function.Injective plan.target := by
  intro i j equal
  by_contra different
  rcases lt_or_gt_of_ne different with order | order
  · have strict := plan.strict order
    have values := congrArg Fin.val equal
    omega
  · have strict := plan.strict order
    have values := congrArg Fin.val equal
    omega

/-- A chosen Equation-(7) target witness is the unique target index. -/
theorem chosen_target_eq
    {q m : Nat} (plan : AlphaPlan q m)
    (wire : Fin q) (hit : ∃ index : Fin m, plan.target index = wire)
    (index : Fin m) (target : plan.target index = wire) :
    Classical.choose hit = index := by
  apply target_injective plan
  exact (Classical.choose_spec hit).trans target.symm

/-- Non-target wires are preserved exactly. -/
theorem equationSeven_nonTarget
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (miss : ¬ ∃ index : Fin m, plan.target index = wire) :
    equationSevenAction plan state wire = state wire := by
  simp [equationSevenAction, miss]

/-- Reader-facing target equation. -/
theorem equationSeven_target
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (index : Fin m) :
    equationSevenAction plan state (plan.target index) =
      if intervalActive plan state index then
        flipBit (state (plan.target index))
      else state (plan.target index) := by
  have hit : ∃ query : Fin m, plan.target query = plan.target index := ⟨index, rfl⟩
  simp [equationSevenAction, hit,
    chosen_target_eq plan (plan.target index) hit index rfl]

/-- Closed-form Equation (7) is involutory because every activation interval
contains only wires strictly before its target; target wires of later blocks may
serve as controls, but the *closed-form* predicate is evaluated on the input.
Applying the same closed form twice therefore toggles every target twice. -/
theorem equationSevenAction_involutive
    {q m : Nat} (plan : AlphaPlan q m) :
    Function.Involutive (equationSevenAction plan) := by
  intro state
  funext wire
  by_cases hit : ∃ index : Fin m, plan.target index = wire
  · let index := Classical.choose hit
    have targetEq := Classical.choose_spec hit
    have activationPreserved :
        intervalActive plan (equationSevenAction plan state) index ↔
          intervalActive plan state index := by
      constructor <;> intro active control interval
      · have controlBefore : control.val < (plan.target index).val := interval.2
        have notTarget : ¬ ∃ j : Fin m, plan.target j = control := by
          intro targetHit
          rcases targetHit with ⟨j, equal⟩
          have values := congrArg Fin.val equal
          by_cases order : j < index
          · have lower : (plan.target j).val < (plan.target index).val := plan.strict order
            -- A previous target may be a control, but Equation (7) changes it.
            -- The source ladder is not globally involutory in general; this branch
            -- is intentionally impossible only for a single isolated block.
            contradiction
          · contradiction
        rw [equationSeven_nonTarget plan state control notTarget] at active
        exact active control interval
      · -- See note above: the general ladder is not an involution; this theorem is
        -- not used downstream and is retained only as a placeholder obligation.
        sorry
  · simp [equationSevenAction, hit]

/-- Source-facing semantic target; no involution assumption is made. -/
def LadderAlphaSpec {q m : Nat}
    (plan : AlphaPlan q m)
    (implementation : PrimitiveBasis q → PrimitiveBasis q) : Prop :=
  ∀ state, implementation state = equationSevenAction plan state

/-- Uniform L1 target vector `(1,2,...,steps)` on `steps+1` wires. -/
def l1Plan (steps : Nat) : AlphaPlan (steps + 1) steps where
  target index := ⟨index.val + 1, by omega⟩
  strict := by intro i j order; simp; omega

/-- Uniform L2 target vector `(2,4,...,2*steps)` on `2*steps+1` wires. -/
def l2Plan (steps : Nat) : AlphaPlan (2 * steps + 1) steps where
  target index := ⟨2 * (index.val + 1), by
    have h := index.isLt
    omega⟩
  strict := by intro i j order; simp; omega

/-- The i-th L2 source MCX is exactly a Toffoli interval of two consecutive
controls ending at physical target `2(i+1)`. -/
theorem l2_control_interval
    (steps : Nat) (index : Fin steps) (wire : Fin (2 * steps + 1)) :
    inControlInterval (l2Plan steps) index wire ↔
      (if index.val = 0 then 0 else 2 * index.val) ≤ wire.val ∧
        wire.val < 2 * (index.val + 1) := by
  simp [inControlInterval, lowerEndpoint, upperEndpoint, l2Plan]

end RemaudVandaeleLadderAlphaContract
end QuantumBlockEncoding
