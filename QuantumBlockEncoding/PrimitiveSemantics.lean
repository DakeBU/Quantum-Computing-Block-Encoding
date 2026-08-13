import QuantumBlockEncoding.PrimitiveCircuit
import QuantumBlockEncoding.Robin.Hadamard8Verified
import Mathlib.Tactic

/-!
# Exact matrix semantics for the primitive basis

The standard `RY` convention uses a half angle.  The bridge theorem below is
the convention check needed by every Robin coefficient loader.
-/

namespace QuantumBlockEncoding

open QuantumBlockEncoding.Robin.ComplexLCU
open scoped Kronecker

/-- Standard `RY(theta)` in the convention used by Qiskit and OpenQASM 3. -/
noncomputable def standardRyMatrix (theta : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  realRotation (theta / 2)

theorem standardRyMatrix_unitary (theta : Real) :
    standardRyMatrix theta ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  realRotation_unitary _

/-- The exact half-angle correction from standard `RY` to the logical loader. -/
theorem standardRyMatrix_two_arccos_eq_amplitudeRotation
    (coefficient : Real) (_lower : -1 ≤ coefficient)
    (_upper : coefficient ≤ 1) :
    standardRyMatrix (2 * Real.arccos coefficient) =
      amplitudeRotation coefficient := by
  unfold standardRyMatrix amplitudeRotation
  congr 1
  ring

/-- The symmetry PREPARE is exactly a standard `RY(pi/2)`, not an opaque H. -/
theorem standardRyMatrix_pi_div_two_eq_warmRobinUniformBitPrepare :
    standardRyMatrix (Real.pi / 2) =
      QuantumBlockEncoding.Robin.warmRobinUniformBitPrepare := by
  have half : (Real.pi / 2) / 2 = Real.pi / 4 := by ring
  unfold standardRyMatrix
  rw [half]
  unfold realRotation QuantumBlockEncoding.Robin.warmRobinUniformBitPrepare
  rw [Real.cos_pi_div_four, Real.sin_pi_div_four]

/-- Computational-basis bit strings with one named coordinate per qubit. -/
abbrev PrimitiveBasis (qubits : Nat) := Fin qubits → Fin 2

def flipBit (bit : Fin 2) : Fin 2 := if bit = 0 then 1 else 0

@[simp] theorem flipBit_flipBit (bit : Fin 2) : flipBit (flipBit bit) = bit := by
  fin_cases bit <;> rfl

def xBasisAction {qubits : Nat} (target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  Function.update state target (flipBit (state target))

theorem xBasisAction_involutive {qubits : Nat} (target : Fin qubits) :
    Function.Involutive (xBasisAction target) := by
  intro state
  funext wire
  by_cases same : wire = target
  · subst wire
    simp [xBasisAction]
  · simp [xBasisAction, same]

def xBasisEquiv {qubits : Nat} (target : Fin qubits) :
    PrimitiveBasis qubits ≃ PrimitiveBasis qubits where
  toFun := xBasisAction target
  invFun := xBasisAction target
  left_inv := xBasisAction_involutive target
  right_inv := xBasisAction_involutive target

def cxBasisAction {qubits : Nat} (control target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  if state control = 0 then state else xBasisAction target state

theorem cxBasisAction_involutive {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    Function.Involutive (cxBasisAction control target) := by
  intro state
  by_cases controlZero : state control = 0
  · simp [cxBasisAction, controlZero]
  · have controlUnchanged : xBasisAction target state control = state control := by
      simp [xBasisAction, distinct]
    simp [cxBasisAction, controlZero, controlUnchanged,
      xBasisAction_involutive target state]

def cxBasisEquiv {qubits : Nat} (control target : Fin qubits)
    (distinct : control ≠ target) :
    PrimitiveBasis qubits ≃ PrimitiveBasis qubits where
  toFun := cxBasisAction control target
  invFun := cxBasisAction control target
  left_inv := cxBasisAction_involutive control target distinct
  right_inv := cxBasisAction_involutive control target distinct

abbrev OtherPrimitiveWires {qubits : Nat} (target : Fin qubits) :=
  {wire : Fin qubits // wire ≠ target}

def splitPrimitiveWire {qubits : Nat} (target : Fin qubits) :
    PrimitiveBasis qubits ≃
      Fin 2 × (OtherPrimitiveWires target → Fin 2) where
  toFun state := (state target, fun wire => state wire.1)
  invFun pair wire :=
    if same : wire = target then pair.1 else pair.2 ⟨wire, same⟩
  left_inv state := by
    funext wire
    by_cases same : wire = target
    · subst wire
      simp
    · simp [same]
  right_inv pair := by
    rcases pair with ⟨targetBit, otherBits⟩
    apply Prod.ext
    · simp
    · funext wire
      simp [wire.property]

/-- Lift a one-qubit matrix to a named wire, leaving every other wire fixed. -/
noncomputable def liftPrimitiveOneQubit {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (splitPrimitiveWire target).symm
    (gate ⊗ₖ (1 : _root_.Matrix
      (OtherPrimitiveWires target → Fin 2)
      (OtherPrimitiveWires target → Fin 2) ℂ))

theorem liftPrimitiveOneQubit_unitary {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ)
    (unitary : gate ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ) :
    liftPrimitiveOneQubit target gate ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  apply reindex_unitary
  apply _root_.Matrix.kronecker_mem_unitary
  · exact unitary
  · exact (_root_.Matrix.unitaryGroup
      (OtherPrimitiveWires target → Fin 2) ℂ).one_mem

/-- Standard exact `RZ(theta)` matrix, including its phase convention. -/
noncomputable def standardRzMatrix (theta : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  if row = column then
    if row = 0 then
      (Real.cos (theta / 2) : ℂ) - (Real.sin (theta / 2) : ℂ) * Complex.I
    else
      (Real.cos (theta / 2) : ℂ) + (Real.sin (theta / 2) : ℂ) * Complex.I
  else 0

theorem standardRzMatrix_unitary (theta : Real) :
    standardRzMatrix theta ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ := by
  let c := Real.cos (theta / 2)
  let s := Real.sin (theta / 2)
  have trig : s ^ 2 + c ^ 2 = 1 := by
    simp [c, s, Real.sin_sq_add_cos_sq]
  have minusNorm :
      star ((c : ℂ) - (s : ℂ) * Complex.I) *
          ((c : ℂ) - (s : ℂ) * Complex.I) = 1 := by
    apply Complex.ext <;> simp <;> nlinarith
  have plusNorm :
      star ((c : ℂ) + (s : ℂ) * Complex.I) *
          ((c : ℂ) + (s : ℂ) * Complex.I) = 1 := by
    apply Complex.ext <;> simp <;> nlinarith
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  ext row column
  fin_cases row <;> fin_cases column
  · simpa [standardRzMatrix, _root_.Matrix.mul_apply, c, s] using minusNorm
  · simp [standardRzMatrix, _root_.Matrix.mul_apply]
  · simp [standardRzMatrix, _root_.Matrix.mul_apply]
  · simpa [standardRzMatrix, _root_.Matrix.mul_apply, c, s] using plusNorm

/-- Exact matrix denotation of one primitive instruction. -/
noncomputable def evalPrimitiveGate {qubits : Nat} : PrimitiveGate qubits →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | .x target => equivPermutationMatrix (xBasisEquiv target)
  | .ry target angle => liftPrimitiveOneQubit target (standardRyMatrix angle.eval)
  | .rz target angle => liftPrimitiveOneQubit target (standardRzMatrix angle.eval)
  | .cx control target distinct =>
      equivPermutationMatrix (cxBasisEquiv control target distinct)

theorem evalPrimitiveGate_unitary {qubits : Nat} (gate : PrimitiveGate qubits) :
    evalPrimitiveGate gate ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  cases gate with
  | x target => exact equivPermutationMatrix_unitary _
  | ry target angle =>
      exact liftPrimitiveOneQubit_unitary target _ (standardRyMatrix_unitary _)
  | rz target angle =>
      exact liftPrimitiveOneQubit_unitary target _ (standardRzMatrix_unitary _)
  | cx control target distinct => exact equivPermutationMatrix_unitary _

/-- Chronological circuit evaluation: later instructions multiply on the left. -/
noncomputable def evalPrimitiveCircuit {qubits : Nat} : PrimitiveCircuit qubits →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | [] => 1
  | gate :: rest => evalPrimitiveCircuit rest * evalPrimitiveGate gate

theorem evalPrimitiveCircuit_unitary {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit circuit ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  induction circuit with
  | nil => exact (_root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ).one_mem
  | cons gate rest induction =>
      exact (_root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ).mul_mem
        induction (evalPrimitiveGate_unitary gate)

theorem evalPrimitiveCircuit_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit (left ++ right) =
      evalPrimitiveCircuit right * evalPrimitiveCircuit left := by
  induction left with
  | nil => simp [evalPrimitiveCircuit]
  | cons gate rest induction =>
      simp only [List.cons_append, evalPrimitiveCircuit]
      rw [induction]
      simp [mul_assoc]

/-- A typed primitive refinement records exact equality, not equality up to phase. -/
structure PrimitiveRefinement (qubits : Nat) where
  circuit : PrimitiveCircuit qubits
  target : _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  exact : evalPrimitiveCircuit circuit = target

end QuantumBlockEncoding
