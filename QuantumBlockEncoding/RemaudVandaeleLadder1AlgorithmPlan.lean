import QuantumBlockEncoding.ReversibleSchedule
import QuantumBlockEncoding.ScheduledWireEmbedding
import Mathlib.Data.List.OfFn
import Mathlib.Tactic

/-!
# Remaud--Vandaele 2025, Algorithm 1: exact low-depth CNOT-ladder plan

Vandaele 2026 Lemma 3 cites Remaud--Vandaele, *Ancilla-free Quantum Adder
with Sublinear Depth* (2025), for the logarithmic-depth implementation of
`L_1`.  This module follows that citation to the source Algorithm 1 rather than
leaving it as a prose dependency.

For an input list `X_0,...,X_{n-1}`, Algorithm 1 constructs

* one depth-one left wall `C_L`;
* a recursive ladder circuit on `floor(n/2)` selected wires `X'`;
* one depth-one right wall `C_R`.

The exact selected-wire list is

* odd indices `1,3,5,...`, with
* the final wire replaced by `n-2` when necessary.

The paper proves the recurrences

`D(n) = 2 + D(floor(n/2))`,
`C(n) = 2 floor((n-1)/2) + C(floor(n/2))`

for `n >= 3`, with `D(1)=C(1)=0` and `D(2)=C(2)=1`.

This file formalizes the physical wire plan, proves each outer wall is a valid
parallel layer, proves the recursive wire selection is injective, and records
the exact recurrences.  Semantic refinement to `L_1^(n-1)` is layered on top in
a subsequent module, so resource topology and arithmetic semantics remain
separately inspectable proof nodes.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1AlgorithmPlan

/-- Number of gates in each outer depth-one wall for a register of width `n`. -/
def outerCount (n : Nat) : Nat := (n - 1) / 2

/-- Right wall gate j: `CNOT(X_{2j}, X_{2j+1})`. -/
def rightControl (n : Nat) (j : Fin (outerCount n)) : Fin n :=
  ⟨2 * j.val, by
    have hj := j.isLt
    unfold outerCount at hj
    omega⟩

def rightTarget (n : Nat) (j : Fin (outerCount n)) : Fin n :=
  ⟨2 * j.val + 1, by
    have hj := j.isLt
    unfold outerCount at hj
    omega⟩

theorem rightControl_ne_target
    (n : Nat) (j : Fin (outerCount n)) :
    rightControl n j ≠ rightTarget n j := by
  intro equal
  have values := congrArg Fin.val equal
  simp [rightControl, rightTarget] at values
  omega

/-- Physical CNOT in the right wall. -/
def rightGate (n : Nat) (j : Fin (outerCount n)) : ReversibleGate n :=
  .cx (rightControl n j) (rightTarget n j)
    (rightControl_ne_target n j)

/-- Right wall as the source depth-one layer. -/
def rightLayer (n : Nat) : ReversibleLayer n :=
  List.ofFn (rightGate n)

/-- Distinct right-wall gates are wire-disjoint. -/
theorem rightLayer_valid (n : Nat) : ReversibleLayer.Valid (rightLayer n) := by
  unfold ReversibleLayer.Valid rightLayer
  rw [List.pairwise_ofFn]
  intro i j order wire overlap
  have hi := i.isLt
  have hj := j.isLt
  rcases overlap.1 with leftControl | leftTarget <;>
    rcases overlap.2 with rightControlEq | rightTargetEq
  all_goals
    simp [rightGate, ReversibleGate.touches,
      rightControl, rightTarget] at leftControl leftTarget rightControlEq rightTargetEq ⊢ <;>
      omega

/-- The final gate of the left wall is the special source gate
`CNOT(X_{n-2},X_{n-1})`; all earlier gates are
`CNOT(X_{2j+1},X_{2j+2})`. -/
def leftControl (n : Nat) (j : Fin (outerCount n)) : Fin n :=
  if last : j.val + 1 = outerCount n then
    ⟨n - 2, by
      have hj := j.isLt
      unfold outerCount at hj last
      omega⟩
  else
    ⟨2 * j.val + 1, by
      have hj := j.isLt
      unfold outerCount at hj
      omega⟩

def leftTarget (n : Nat) (j : Fin (outerCount n)) : Fin n :=
  if last : j.val + 1 = outerCount n then
    ⟨n - 1, by
      have hj := j.isLt
      unfold outerCount at hj last
      omega⟩
  else
    ⟨2 * j.val + 2, by
      have hj := j.isLt
      unfold outerCount at hj
      omega⟩

theorem leftControl_ne_target
    (n : Nat) (j : Fin (outerCount n)) :
    leftControl n j ≠ leftTarget n j := by
  intro equal
  have values := congrArg Fin.val equal
  by_cases last : j.val + 1 = outerCount n <;>
    simp [leftControl, leftTarget, last] at values <;> omega

/-- Physical CNOT in the left wall. -/
def leftGate (n : Nat) (j : Fin (outerCount n)) : ReversibleGate n :=
  .cx (leftControl n j) (leftTarget n j)
    (leftControl_ne_target n j)

/-- Left wall as the source depth-one layer. -/
def leftLayer (n : Nat) : ReversibleLayer n :=
  List.ofFn (leftGate n)

/-- Distinct left-wall gates are wire-disjoint, including the even-width
special final gate `(n-2,n-1)`. -/
theorem leftLayer_valid (n : Nat) : ReversibleLayer.Valid (leftLayer n) := by
  unfold ReversibleLayer.Valid leftLayer
  rw [List.pairwise_ofFn]
  intro i j order wire overlap
  have hi := i.isLt
  have hj := j.isLt
  have notLastI : i.val + 1 ≠ outerCount n := by omega
  by_cases lastJ : j.val + 1 = outerCount n
  · rcases overlap.1 with leftControlEq | leftTargetEq <;>
      rcases overlap.2 with rightControlEq | rightTargetEq
    all_goals
      simp [leftGate, ReversibleGate.touches,
        leftControl, leftTarget, notLastI, lastJ] at
        leftControlEq leftTargetEq rightControlEq rightTargetEq ⊢ <;>
        omega
  · rcases overlap.1 with leftControlEq | leftTargetEq <;>
      rcases overlap.2 with rightControlEq | rightTargetEq
    all_goals
      simp [leftGate, ReversibleGate.touches,
        leftControl, leftTarget, notLastI, lastJ] at
        leftControlEq leftTargetEq rightControlEq rightTargetEq ⊢ <;>
        omega

/-- Width of the recursive subproblem in Algorithm 1. -/
def recursiveWidth (n : Nat) : Nat := n / 2

/-- Exact source-selected subregister `X'`.

For the final local index we use `X_{n-2}`.  For every earlier local index `j`
we use `X_{2j+1}`.  This uniformly describes both parities:

* `n=2m`: `1,3,...,2m-3,2m-2`;
* `n=2m+1`: `1,3,...,2m-1`.
-/
def recursiveWire (n : Nat) (j : Fin (recursiveWidth n)) : Fin n :=
  if last : j.val + 1 = recursiveWidth n then
    ⟨n - 2, by
      have hj := j.isLt
      unfold recursiveWidth at hj last
      omega⟩
  else
    ⟨2 * j.val + 1, by
      have hj := j.isLt
      unfold recursiveWidth at hj
      omega⟩

/-- Algorithm 1 really selects a subregister: no physical wire is repeated. -/
theorem recursiveWire_injective
    {n : Nat} : Function.Injective (recursiveWire n) := by
  intro i j equal
  have hi := i.isLt
  have hj := j.isLt
  have values := congrArg Fin.val equal
  by_cases lastI : i.val + 1 = recursiveWidth n
  · by_cases lastJ : j.val + 1 = recursiveWidth n
    · apply Fin.ext
      omega
    · simp [recursiveWire, lastI, lastJ] at values
      unfold recursiveWidth at hi hj lastI lastJ
      omega
  · by_cases lastJ : j.val + 1 = recursiveWidth n
    · simp [recursiveWire, lastI, lastJ] at values
      unfold recursiveWidth at hi hj lastI lastJ
      omega
    · simp [recursiveWire, lastI, lastJ] at values
      apply Fin.ext
      omega

/-- Recursive width is strictly smaller in the non-base source regime. -/
theorem recursiveWidth_lt {n : Nat} (nontrivial : 2 < n) :
    recursiveWidth n < n := by
  unfold recursiveWidth
  omega

/-- Paper recurrence for Algorithm-1 parallel depth. -/
def depthRecurrence : Nat → Nat
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | n + 3 => 2 + depthRecurrence ((n + 3) / 2)
termination_by n => n

decreasing_by omega

/-- Paper recurrence for the Algorithm-1 CNOT count. -/
def gateRecurrence : Nat → Nat
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | n + 3 =>
      2 * outerCount (n + 3) + gateRecurrence ((n + 3) / 2)
termination_by n => n

decreasing_by omega

@[simp] theorem depthRecurrence_zero : depthRecurrence 0 = 0 := rfl
@[simp] theorem depthRecurrence_one : depthRecurrence 1 = 0 := rfl
@[simp] theorem depthRecurrence_two : depthRecurrence 2 = 1 := rfl

@[simp] theorem gateRecurrence_zero : gateRecurrence 0 = 0 := rfl
@[simp] theorem gateRecurrence_one : gateRecurrence 1 = 0 := rfl
@[simp] theorem gateRecurrence_two : gateRecurrence 2 = 1 := rfl

/-- Reader-facing exact recurrence `D(n)=2+D(floor(n/2))` for `n>=3`. -/
theorem depthRecurrence_step
    {n : Nat} (large : 3 ≤ n) :
    depthRecurrence n = 2 + depthRecurrence (recursiveWidth n) := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le large
  rfl

/-- Reader-facing exact recurrence
`C(n)=2 floor((n-1)/2)+C(floor(n/2))` for `n>=3`. -/
theorem gateRecurrence_step
    {n : Nat} (large : 3 ≤ n) :
    gateRecurrence n =
      2 * outerCount n + gateRecurrence (recursiveWidth n) := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le large
  rfl

/-- Both source outer walls contain exactly `floor((n-1)/2)` CNOTs. -/
@[simp] theorem rightLayer_length (n : Nat) :
    (rightLayer n).length = outerCount n := by
  simp [rightLayer]

@[simp] theorem leftLayer_length (n : Nat) :
    (leftLayer n).length = outerCount n := by
  simp [leftLayer]

end RemaudVandaeleLadder1AlgorithmPlan
end QuantumBlockEncoding
