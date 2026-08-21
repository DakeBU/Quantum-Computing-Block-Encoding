import QuantumBlockEncoding.NieZiSunConstantToffoliMacros
import QuantumBlockEncoding.NieZiSunFigure3Resource
import QuantumBlockEncoding.ReversibleProgramInverse
import QuantumBlockEncoding.ReversibleWireEmbedding
import Mathlib.Tactic

/-!
# Actual `{X,CCX}` gate list for the Nie--Zi--Sun Figure-3 recursion

The semantic recursion has already been formalized.  Here we instantiate the
same five-step source topology in ASPBE's reversible proof IR.

Register convention for n controls:

* controls: wires `0,...,n-1`;
* the one source ancilla A: wire n;
* final target T: wire n+1.

For n>=5, Figure-3 Step 1 implements C^4X on I1..I4 -> A while borrowing I5
as a dirty wire.  Step 3 implements C^3X on I1,I3,A -> T while borrowing I2.
The two tail first-halves use `(I2,I1)` and `(I4,I3)` as their local
(ancilla,target) pairs, exactly as in the source figure.

This file constructs the chronological gate list and its exact instruction
recurrence.  Certified logarithmic parallel scheduling is a later node: the
left/right recursive halves are physically disjoint and will be merged layer by
layer rather than serialized for the depth proof.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3ReversibleProgram

open NieZiSunFigure3Resource
open ReversibleProgramInverse
open ReversibleWireEmbedding

/-- Total physical width: controls + A + T. -/
def totalWidth (n : Nat) : Nat := n + 2

/-- Named source wires. -/
def ancillaWire (n : Nat) : Fin (totalWidth n) := ⟨n, by unfold totalWidth; omega⟩
def finalTargetWire (n : Nat) : Fin (totalWidth n) :=
  ⟨n + 1, by unfold totalWidth; omega⟩

/-- Four head X gates in Step 2/4. -/
def headXProgram (n : Nat) (large : 5 <= n) :
    ReversibleProgram (totalWidth n) :=
  [.x ⟨0, by unfold totalWidth; omega⟩,
   .x ⟨1, by unfold totalWidth; omega⟩,
   .x ⟨2, by unfold totalWidth; omega⟩,
   .x ⟨3, by unfold totalWidth; omega⟩]

/-- Step-1 C^4X macro, expanded to ten CCX gates.  Wire 4=I5 is borrowed dirty
and restored by the macro. -/
def step1Program (n : Nat) (large : 5 <= n) :
    ReversibleProgram (totalWidth n) :=
  let a : Fin (totalWidth n) := ⟨0, by unfold totalWidth; omega⟩
  let b : Fin (totalWidth n) := ⟨1, by unfold totalWidth; omega⟩
  let c : Fin (totalWidth n) := ⟨2, by unfold totalWidth; omega⟩
  let e : Fin (totalWidth n) := ⟨3, by unfold totalWidth; omega⟩
  let d : Fin (totalWidth n) := ⟨4, by unfold totalWidth; omega⟩
  let t := ancillaWire n
  [ .ccx a b d (by simp [a,b,d]) (by simp [a,d]) (by simp [b,d]),
    .ccx d c a (by simp [d,c]) (by simp [d,a]) (by simp [c,a]),
    .ccx a e t (by simp [a,e]) (by simp [a,e,t,ancillaWire]; omega)
      (by simp [e,t,ancillaWire]; omega),
    .ccx d c a (by simp [d,c]) (by simp [d,a]) (by simp [c,a]),
    .ccx a e t (by simp [a,e]) (by simp [a,e,t,ancillaWire]; omega)
      (by simp [e,t,ancillaWire]; omega),
    .ccx a b d (by simp [a,b,d]) (by simp [a,d]) (by simp [b,d]),
    .ccx d c a (by simp [d,c]) (by simp [d,a]) (by simp [c,a]),
    .ccx a e t (by simp [a,e]) (by simp [a,e,t,ancillaWire]; omega)
      (by simp [e,t,ancillaWire]; omega),
    .ccx d c a (by simp [d,c]) (by simp [d,a]) (by simp [c,a]),
    .ccx a e t (by simp [a,e]) (by simp [a,e,t,ancillaWire]; omega)
      (by simp [e,t,ancillaWire]; omega) ]

/-- Step-3 C^3X macro, expanded to four CCX gates and borrowing I2 (wire 1). -/
def step3Program (n : Nat) (large : 5 <= n) :
    ReversibleProgram (totalWidth n) :=
  let a : Fin (totalWidth n) := ⟨0, by unfold totalWidth; omega⟩
  let b : Fin (totalWidth n) := ⟨2, by unfold totalWidth; omega⟩
  let c := ancillaWire n
  let t := finalTargetWire n
  let d : Fin (totalWidth n) := ⟨1, by unfold totalWidth; omega⟩
  [ .ccx a b d (by simp [a,b]) (by simp [a,d]) (by simp [b,d]),
    .ccx d c t (by simp [d,c,ancillaWire]; omega)
      (by simp [d,t,finalTargetWire]; omega)
      (by simp [c,t,ancillaWire,finalTargetWire]; omega),
    .ccx a b d (by simp [a,b]) (by simp [a,d]) (by simp [b,d]),
    .ccx d c t (by simp [d,c,ancillaWire]; omega)
      (by simp [d,t,finalTargetWire]; omega)
      (by simp [c,t,ancillaWire,finalTargetWire]; omega) ]

/-- Left recursive first-half embedding. -/
def leftEmbed (n : Nat) (large : 5 <= n) :
    Fin (leftTailWidth n + 2) -> Fin (totalWidth n) := fun wire =>
  if control : wire.val < leftTailWidth n then
    ⟨4 + wire.val, by
      have h := wire.isLt
      have sum := tailWidths_sum n
      unfold totalWidth
      omega⟩
  else if work : wire.val = leftTailWidth n then
    ⟨1, by unfold totalWidth; omega⟩
  else
    ⟨0, by unfold totalWidth; omega⟩

/-- The left embedding is injective: controls live at >=4, while work/target
are wires 1/0. -/
theorem leftEmbed_injective (n : Nat) (large : 5 <= n) :
    Function.Injective (leftEmbed n large) := by
  intro x y equal
  apply Fin.ext
  unfold leftEmbed at equal
  by_cases xc : x.val < leftTailWidth n
  · by_cases yc : y.val < leftTailWidth n
    · simp [xc,yc] at equal
      have values := congrArg Fin.val equal
      omega
    · by_cases yw : y.val = leftTailWidth n <;> simp [xc,yc,yw] at equal
  · by_cases yc : y.val < leftTailWidth n
    · by_cases xw : x.val = leftTailWidth n <;> simp [xc,yc,xw] at equal
    · by_cases xw : x.val = leftTailWidth n
      · by_cases yw : y.val = leftTailWidth n
        · omega
        · simp [xc,yc,xw,yw] at equal
      · by_cases yw : y.val = leftTailWidth n
        · simp [xc,yc,xw,yw] at equal
        · have xlt := x.isLt
          have ylt := y.isLt
          omega

/-- Right recursive first-half embedding. -/
def rightEmbed (n : Nat) (large : 5 <= n) :
    Fin (rightTailWidth n + 2) -> Fin (totalWidth n) := fun wire =>
  if control : wire.val < rightTailWidth n then
    ⟨4 + leftTailWidth n + wire.val, by
      have h := wire.isLt
      have sum := tailWidths_sum n
      unfold totalWidth
      omega⟩
  else if work : wire.val = rightTailWidth n then
    ⟨3, by unfold totalWidth; omega⟩
  else
    ⟨2, by unfold totalWidth; omega⟩

/-- The right embedding is injective. -/
theorem rightEmbed_injective (n : Nat) (large : 5 <= n) :
    Function.Injective (rightEmbed n large) := by
  intro x y equal
  apply Fin.ext
  unfold rightEmbed at equal
  by_cases xc : x.val < rightTailWidth n
  · by_cases yc : y.val < rightTailWidth n
    · simp [xc,yc] at equal
      have values := congrArg Fin.val equal
      omega
    · by_cases yw : y.val = rightTailWidth n <;> simp [xc,yc,yw] at equal
  · by_cases yc : y.val < rightTailWidth n
    · by_cases xw : x.val = rightTailWidth n <;> simp [xc,yc,xw] at equal
    · by_cases xw : x.val = rightTailWidth n
      · by_cases yw : y.val = rightTailWidth n
        · omega
        · simp [xc,yc,xw,yw] at equal
      · by_cases yw : y.val = rightTailWidth n
        · simp [xc,yc,xw,yw] at equal
        · have xlt := x.isLt
          have ylt := y.isLt
          omega

/-- Base first-half programs for n<=4.  The unique ancilla is available as the
dirty wire for the fixed C^3X/C^4X macros. -/
def smallFirstHalf : (n : Nat) -> ReversibleProgram (totalWidth n)
  | 0 => [.x ⟨1, by decide⟩]
  | 1 => [.cx ⟨0, by decide⟩ ⟨2, by decide⟩ (by decide)]
  | 2 => [.ccx ⟨0, by decide⟩ ⟨1, by decide⟩ ⟨3, by decide⟩
      (by decide) (by decide) (by decide)]
  | 3 => mapProgramWires
      (fun wire : Fin 5 =>
        (Equiv.swap (3 : Fin 5) 4 wire))
      (Equiv.swap (3 : Fin 5) 4).injective
      NieZiSunConstantToffoliMacros.c3Program
  | 4 => mapProgramWires
      (fun wire : Fin 6 =>
        (Equiv.swap (4 : Fin 6) 5 wire))
      (Equiv.swap (4 : Fin 6) 5).injective
      NieZiSunConstantToffoliMacros.c4Program
  | n + 5 => []

/-- Actual recursive first-half gate list. -/
def firstHalfProgram : (n : Nat) -> ReversibleProgram (totalWidth n)
  | 0 => smallFirstHalf 0
  | 1 => smallFirstHalf 1
  | 2 => smallFirstHalf 2
  | 3 => smallFirstHalf 3
  | 4 => smallFirstHalf 4
  | n + 5 =>
      let width := n + 5
      let large : 5 <= width := by omega
      step1Program width large ++
        headXProgram width large ++
        mapProgramWires (leftEmbed width large)
          (leftEmbed_injective width large)
          (firstHalfProgram (leftTailWidth width)) ++
        mapProgramWires (rightEmbed width large)
          (rightEmbed_injective width large)
          (firstHalfProgram (rightTailWidth width)) ++
        step3Program width large
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- Figure-3 Step 2 gate list. -/
def step2Program (n : Nat) (large : 5 <= n) :
    ReversibleProgram (totalWidth n) :=
  headXProgram n large ++
    mapProgramWires (leftEmbed n large) (leftEmbed_injective n large)
      (firstHalfProgram (leftTailWidth n)) ++
    mapProgramWires (rightEmbed n large) (rightEmbed_injective n large)
      (firstHalfProgram (rightTailWidth n))

/-- Complete Figure-3 gate list: Step1;Step2;Step3;Step4;Step5. -/
def fullProgram (n : Nat) : ReversibleProgram (totalWidth n) :=
  if large : 5 <= n then
    let s1 := step1Program n large
    let s2 := step2Program n large
    s1 ++ s2 ++ step3Program n large ++ reverseProgram s2 ++ reverseProgram s1
  else smallFirstHalf n

@[simp] theorem step1Program_length
    (n : Nat) (large : 5 <= n) : (step1Program n large).length = 10 := by rfl

@[simp] theorem step3Program_length
    (n : Nat) (large : 5 <= n) : (step3Program n large).length = 4 := by rfl

@[simp] theorem headXProgram_length
    (n : Nat) (large : 5 <= n) : (headXProgram n large).length = 4 := by rfl

/-- Exact first-half instruction recurrence. -/
theorem firstHalfProgram_length_step
    {n : Nat} (large : 5 <= n) :
    (firstHalfProgram n).length =
      18 + (firstHalfProgram (leftTailWidth n)).length +
        (firstHalfProgram (rightTailWidth n)).length := by
  obtain ⟨m,rfl⟩ : ∃ m, n = m + 5 := ⟨n - 5, by omega⟩
  simp [firstHalfProgram, mapProgramWires_length]
  omega

/-- Exact complete instruction recurrence. -/
theorem fullProgram_length_step
    {n : Nat} (large : 5 <= n) :
    (fullProgram n).length =
      32 + 2 * (firstHalfProgram (leftTailWidth n)).length +
        2 * (firstHalfProgram (rightTailWidth n)).length := by
  simp [fullProgram, large, step2Program, reverseProgram,
    mapProgramWires_length, List.length_reverse]
  omega

end NieZiSunFigure3ReversibleProgram
end QuantumBlockEncoding
