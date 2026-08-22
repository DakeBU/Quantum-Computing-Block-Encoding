import QuantumBlockEncoding.MultiControlledXSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaResource
import Mathlib.Data.List.OfFn
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: actual MCX outer layers

For an alpha-vector with `m=k-1` source MCX gates, Algorithm 2 forms two
depth-one walls.  In source-gate numbering:

* `C_R` contains gates `0,2,4,...`;
* `C_L` contains gates `1,3,5,...`, with its final slot always occupied by the
  final source gate `m-1`.

The loop bounds in the pseudocode are exactly chosen so that both walls contain
`floor((k-1)/2)=floor(m/2)` gates.  Source gates two positions apart act on
disjoint contiguous intervals, hence each nonempty wall is one valid MCX layer.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOuterLayers

open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaResource

/-- Boundary count `k` from an alpha-vector of length `m=k-1`. -/
def boundaryCount (m : Nat) : Nat := m + 1

/-- Number of Algorithm-2 gates in each outer wall. -/
def wallCount (m : Nat) : Nat := outerCount (boundaryCount m)

@[simp] theorem wallCount_eq (m : Nat) : wallCount m = m / 2 := by
  unfold wallCount boundaryCount outerCount
  omega

/-- Right wall source-gate index `2j`. -/
def rightSourceIndex
    (m : Nat) (j : Fin (wallCount m)) : Fin m :=
  ⟨2 * j.val, by
    have hj := j.isLt
    rw [wallCount_eq] at hj
    omega⟩

/-- Left wall source-gate index.  Every nonfinal slot uses `2j+1`; the last slot
uses the final source gate `m-1`, exactly matching Algorithm-2 line 9. -/
def leftSourceIndex
    (m : Nat) (j : Fin (wallCount m)) : Fin m :=
  if last : j.val + 1 = wallCount m then
    ⟨m - 1, by
      have positive : 0 < m := by
        have hj := j.isLt
        omega
      omega⟩
  else
    ⟨2 * j.val + 1, by
      have hj := j.isLt
      rw [wallCount_eq] at hj
      omega⟩

/-- Right source indices are strictly separated by at least two. -/
theorem rightSourceIndex_gap
    (m : Nat) {i j : Fin (wallCount m)} (order : i < j) :
    (rightSourceIndex m i).val + 2 ≤ (rightSourceIndex m j).val := by
  simp [rightSourceIndex]
  omega

/-- Left source indices are also separated by at least two. -/
theorem leftSourceIndex_gap
    (m : Nat) {i j : Fin (wallCount m)} (order : i < j) :
    (leftSourceIndex m i).val + 2 ≤ (leftSourceIndex m j).val := by
  have hi := i.isLt
  have hj := j.isLt
  have iNotLast : i.val + 1 ≠ wallCount m := by omega
  by_cases jLast : j.val + 1 = wallCount m
  · simp [leftSourceIndex, iNotLast, jLast]
    rw [wallCount_eq] at hi hj
    omega
  · simp [leftSourceIndex, iNotLast, jLast]
    omega

/-- Lower endpoint is the preceding target for every nonfirst source gate. -/
theorem lowerEndpoint_ge_previous
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m) (nonzero : index.val ≠ 0) :
    (plan.target ⟨index.val - 1, by omega⟩).val = lowerEndpoint plan index := by
  simp [lowerEndpoint, nonzero]

/-- The support of source gate i lies from its lower endpoint through its target. -/
theorem sourceGate_touches_bounds
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m) (wire : Fin q)
    (touches : MultiControlledXSchedule.touches (sourceGate plan index) wire) :
    lowerEndpoint plan index ≤ wire.val ∧
      wire.val ≤ (plan.target index).val := by
  rcases touches with target | control
  · subst wire
    simp [lowerEndpoint]
    by_cases first : index.val = 0
    · simp [first]
    · have strict := plan.strict (show
          (⟨index.val - 1, by omega⟩ : Fin m) < index by omega)
      simp [lowerEndpoint, first]
      omega
  · have interval := (mem_controlFinset_iff plan index wire).1 control
    exact ⟨interval.1, interval.2.le⟩

/-- Two source gates whose indices differ by at least two are wire-disjoint. -/
theorem sourceGate_disjoint_of_gap
    {q m : Nat} (plan : AlphaPlan q m)
    {left right : Fin m}
    (gap : left.val + 2 ≤ right.val) :
    WireDisjoint (sourceGate plan left) (sourceGate plan right) := by
  intro wire overlap
  have leftBounds := sourceGate_touches_bounds plan left wire overlap.1
  have rightBounds := sourceGate_touches_bounds plan right wire overlap.2
  have leftBefore : (plan.target left).val <
      (plan.target ⟨right.val - 1, by omega⟩).val := by
    apply plan.strict
    omega
  have rightNonzero : right.val ≠ 0 := by omega
  have rightLower := lowerEndpoint_ge_previous plan right rightNonzero
  rw [← rightLower] at rightBounds
  omega

/-- Actual right MCX wall. -/
def rightLayer
    {q m : Nat} (plan : AlphaPlan q m) : MCXLayer q :=
  List.ofFn (fun j : Fin (wallCount m) =>
    sourceGate plan (rightSourceIndex m j))

/-- Actual left MCX wall. -/
def leftLayer
    {q m : Nat} (plan : AlphaPlan q m) : MCXLayer q :=
  List.ofFn (fun j : Fin (wallCount m) =>
    sourceGate plan (leftSourceIndex m j))

/-- `C_R` is a valid depth-one MCX layer. -/
theorem rightLayer_valid
    {q m : Nat} (plan : AlphaPlan q m) : LayerValid (rightLayer plan) := by
  unfold LayerValid rightLayer
  rw [List.pairwise_ofFn]
  intro i j order
  exact sourceGate_disjoint_of_gap plan
    (rightSourceIndex_gap m order)

/-- `C_L` is a valid depth-one MCX layer. -/
theorem leftLayer_valid
    {q m : Nat} (plan : AlphaPlan q m) : LayerValid (leftLayer plan) := by
  unfold LayerValid leftLayer
  rw [List.pairwise_ofFn]
  intro i j order
  exact sourceGate_disjoint_of_gap plan
    (leftSourceIndex_gap m order)

@[simp] theorem rightLayer_length
    {q m : Nat} (plan : AlphaPlan q m) :
    (rightLayer plan).length = wallCount m := by
  simp [rightLayer]

@[simp] theorem leftLayer_length
    {q m : Nat} (plan : AlphaPlan q m) :
    (leftLayer plan).length = wallCount m := by
  simp [leftLayer]

/-- The two paper walls are concrete one-layer scheduled MCX circuits. -/
def rightScheduled
    {q m : Nat} (plan : AlphaPlan q m) : ScheduledMCXProgram q :=
  oneLayer (rightLayer plan) (rightLayer_valid plan)

def leftScheduled
    {q m : Nat} (plan : AlphaPlan q m) : ScheduledMCXProgram q :=
  oneLayer (leftLayer plan) (leftLayer_valid plan)

/-- Exact all-m depth of the right wall: an empty wall has depth zero. -/
theorem rightScheduled_depth_exact
    {q m : Nat} (plan : AlphaPlan q m) :
    (rightScheduled plan).depth =
      if rightLayer plan = [] then 0 else 1 := by
  change
    (oneLayer (rightLayer plan) (rightLayer_valid plan)).depth =
      if rightLayer plan = [] then 0 else 1
  exact oneLayer_depth (rightLayer plan) (rightLayer_valid plan)

/-- Exact all-m depth of the left wall: an empty wall has depth zero. -/
theorem leftScheduled_depth_exact
    {q m : Nat} (plan : AlphaPlan q m) :
    (leftScheduled plan).depth =
      if leftLayer plan = [] then 0 else 1 := by
  change
    (oneLayer (leftLayer plan) (leftLayer_valid plan)).depth =
      if leftLayer plan = [] then 0 else 1
  exact oneLayer_depth (leftLayer plan) (leftLayer_valid plan)

/-- In the recursive regime each right wall is nonempty. -/
theorem rightLayer_ne_nil_of_two_le
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    rightLayer plan ≠ [] := by
  intro empty
  have length := rightLayer_length plan
  rw [empty] at length
  simp at length
  rw [wallCount_eq] at length
  omega

/-- In the recursive regime each left wall is nonempty. -/
theorem leftLayer_ne_nil_of_two_le
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    leftLayer plan ≠ [] := by
  intro empty
  have length := leftLayer_length plan
  rw [empty] at length
  simp at length
  rw [wallCount_eq] at length
  omega

@[simp] theorem rightScheduled_depth_of_two_le
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    (rightScheduled plan).depth = 1 := by
  rw [rightScheduled_depth_exact,
    if_neg (rightLayer_ne_nil_of_two_le plan large)]

@[simp] theorem leftScheduled_depth_of_two_le
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    (leftScheduled plan).depth = 1 := by
  rw [leftScheduled_depth_exact,
    if_neg (leftLayer_ne_nil_of_two_le plan large)]

end RemaudVandaeleLadderAlphaOuterLayers
end QuantumBlockEncoding
