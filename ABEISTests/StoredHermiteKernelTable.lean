import QuantumBlockEncoding.StoredHermiteKernelTable

namespace QuantumBlockEncoding.StoredHermiteKernelTable.Tests

open StoredGivens StoredTensorTrain HermiteBoundaryInjection

def first : Fields 0 where
  leftPartial := true
  leftInjection := 2
  leftFree := 3
  middlePartial := false
  middleInjection := Vector.ofFn fun i => if i.val = 0 then 5 else 6
  shared := Vector.ofFn fun i => Vector.ofFn fun j =>
    if i.val = 0 then (if j.val = 0 then 11 else 12)
    else (if j.val = 0 then 21 else 22)
  rightCore := 7

def second : Fields 0 := { first with
  leftPartial := false, leftInjection := 102, leftFree := 103,
  middlePartial := true, rightCore := 107 }

def fields : Vector (Fields 0) 2 := Vector.ofFn fun bit =>
  if bit.val = 0 then first else second

/-- The k=0 layout is left boundary/free, middle boundary/two Bernstein,
right free. Distinct bit records expose swapped bit/bond flattening. -/
example : denoteCore (assemble fields).value 0 (0, 0) = 1 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 0 (1, 0) = 0 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 0 (0, 1) = 2 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 0 (1, 1) = 102 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 1 (0, 1) = 3 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 1 (0, 0) = 0 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 2 (0, 2) = 0 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 2 (1, 2) = 1 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 2 (0, 3) = 5 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 2 (0, 4) = 6 := by
  rw [assemble_value]
  rfl

/-- Shared rows are not transposed: (3,4) is 12, while (4,3) is 21. -/
example : denoteCore (assemble fields).value 3 (0, 4) = 12 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 4 (0, 3) = 21 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 3 (0, 2) = 0 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 5 (0, 5) = 7 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble fields).value 5 (1, 5) = 107 := by
  rw [assemble_value]
  rfl

/-- Off-diagonal component blocks remain zero in either direction. -/
example : denoteCore (assemble fields).value 0 (0, 5) = 0 ∧
    denoteCore (assemble fields).value 5 (1, 2) = 0 := by
  constructor <;> rw [assemble_value] <;>
    rfl

example (op : Op) : (assemble fields).cost op ≤ 2592 := by
  simpa using assemble_cost_le fields op

/-- With D=6, the physical flat column for bit=1,bond=1 is 7. -/
example : (finProdFinEquiv ((1 : Fin 2), (1 : Fin 6))).val = 7 := rfl

example : denote (assemble fields).value 0 7 = 102 := by
  change denoteCore (assemble fields).value 0 (1, 1) = 102
  rw [assemble_value]
  rfl

def larger : Fields 1 where
  leftPartial := false
  leftInjection := 2
  leftFree := 3
  middlePartial := false
  middleInjection := Vector.replicate 4 9
  shared := Vector.replicate 4 (Vector.replicate 4 13)
  rightCore := 17

def largerFields : Vector (Fields 1) 2 := Vector.replicate 2 larger

/-- The last Bernstein index at k=1 stays separate from the right-tail slot. -/
example : denoteCore (assemble largerFields).value 2 (0, 6) = 9 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble largerFields).value 6 (1, 6) = 13 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble largerFields).value 7 (1, 7) = 17 := by
  rw [assemble_value]
  rfl

example : denoteCore (assemble largerFields).value 6 (0, 7) = 0 := by
  rw [assemble_value]
  rfl

/-- The source refinement does not drop its input field obligations, even
at n=0 where the same core will later need both boundary contractions. -/
example (L : ℝ) (f : Vector (Fields 0) 2)
    (h : ∀ bit, SourceCorrect 0 0 0 L bit f[bit.val])
    (a : Fin 6) (out : Fin 2 × Fin 6) :
    denoteCore (assemble f).value a out = HermiteExplicitBond.kernel 0 0 L 0 out.1 a out.2 :=
  assemble_source f h a out

#print axioms assemble_value
#print axioms assemble_source
#print axioms assemble_cost_le
#print axioms assemble_total_cost_le

end QuantumBlockEncoding.StoredHermiteKernelTable.Tests
