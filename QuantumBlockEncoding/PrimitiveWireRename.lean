import QuantumBlockEncoding.RealAmplitudePreparation

/-! Renaming physical wires preserves primitive circuit action and counts.
This is a proof-bearing placement operation, not a free physical SWAP gate.
Input and output basis labels are explicitly reindexed together. -/

namespace QuantumBlockEncoding.PrimitiveWireRename
open Robin.ComplexLCU

def basisEquiv {m n : Nat} (e : Fin m ≃ Fin n) : PrimitiveBasis m ≃ PrimitiveBasis n where
  toFun b := fun w => b (e.symm w)
  invFun b := fun w => b (e w)
  left_inv b := by funext w; simp
  right_inv b := by funext w; simp

def gate {m n : Nat} (e : Fin m ≃ Fin n) : PrimitiveGate m → PrimitiveGate n
  | .x t => .x (e t)
  | .ry t a => .ry (e t) a
  | .rz t a => .rz (e t) a
  | .cx c t h => .cx (e c) (e t) (fun he => h (e.injective he))

def circuit {m n : Nat} (e : Fin m ≃ Fin n) (c : PrimitiveCircuit m) : PrimitiveCircuit n :=
  c.map (gate e)

noncomputable def matrix {m n : Nat} (e : Fin m ≃ Fin n)
    (M : _root_.Matrix (PrimitiveBasis m) (PrimitiveBasis m) ℂ) :
    _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (basisEquiv e) M

@[simp] theorem matrix_apply {m n : Nat} (e : Fin m ≃ Fin n)
    (M : _root_.Matrix (PrimitiveBasis m) (PrimitiveBasis m) ℂ)
    (a b : PrimitiveBasis n) :
    matrix e M a b = M (fun w => a (e w)) (fun w => b (e w)) := rfl

theorem matrix_mul {m n : Nat} (e : Fin m ≃ Fin n)
    (M N : _root_.Matrix (PrimitiveBasis m) (PrimitiveBasis m) ℂ) :
    matrix e (M * N) = matrix e M * matrix e N :=
  map_mul (_root_.Matrix.reindexAlgEquiv ℂ ℂ (basisEquiv e)) M N

private theorem context_eq {m n : Nat} (e : Fin m ≃ Fin n) (t : Fin m)
    (a b : PrimitiveBasis n) :
    (splitPrimitiveWire (e t) a).2 = (splitPrimitiveWire (e t) b).2 ↔
      (splitPrimitiveWire t (fun w => a (e w))).2 =
      (splitPrimitiveWire t (fun w => b (e w))).2 := by
  constructor
  · intro h
    funext w
    exact congrFun h ⟨e w.val, fun he => w.property (e.injective he)⟩
  · intro h
    funext w
    have hn : e.symm w.val ≠ t := by
      intro he
      apply w.property
      simpa using congrArg e he
    have he := congrFun h ⟨e.symm w.val, hn⟩
    simpa only [splitPrimitiveWire, Equiv.coe_fn_mk, Equiv.apply_symm_apply] using he

theorem oneQubit {m n : Nat} (e : Fin m ≃ Fin n) (t : Fin m)
    (M : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    liftPrimitiveOneQubit (e t) M = matrix e (liftPrimitiveOneQubit t M) := by
  ext a b
  simp only [matrix_apply, liftPrimitiveOneQubit_apply, context_eq]

private theorem x_action {m n : Nat} (e : Fin m ≃ Fin n) (t : Fin m)
    (b : PrimitiveBasis n) :
    (fun w => xBasisAction (e t) b (e w)) = xBasisAction t (fun w => b (e w)) := by
  funext w
  by_cases h : w = t
  · subst w
    simp [xBasisAction]
  · have he : e w ≠ e t := fun he => h (e.injective he)
    simp [xBasisAction, h, he]

private theorem cx_action {m n : Nat} (e : Fin m ≃ Fin n) (c t : Fin m)
    (b : PrimitiveBasis n) :
    (fun w => cxBasisAction (e c) (e t) b (e w)) =
      cxBasisAction c t (fun w => b (e w)) := by
  by_cases h : b (e c) = 0
  · simp [cxBasisAction, h]
  · simp only [cxBasisAction, h, if_false]
    exact x_action e t b

theorem eval_gate {m n : Nat} (e : Fin m ≃ Fin n) (g : PrimitiveGate m) :
    evalPrimitiveGate (gate e g) = matrix e (evalPrimitiveGate g) := by
  cases g with
  | ry t a => exact oneQubit e t _
  | rz t a => exact oneQubit e t _
  | x t =>
    ext a b
    simp only [gate, evalPrimitiveGate, matrix_apply, equivPermutationMatrix]
    change (if a = xBasisAction (e t) b then (1 : ℂ) else 0) =
      if (fun w => a (e w)) = xBasisAction t (fun w => b (e w)) then 1 else 0
    have he : a = xBasisAction (e t) b ↔
        (fun w => a (e w)) = xBasisAction t (fun w => b (e w)) := by
      rw [← (basisEquiv e).symm.injective.eq_iff]
      rw [show (basisEquiv e).symm (xBasisAction (e t) b) = _ from x_action e t b]
      rfl
    simp only [he]
  | cx c t h =>
    ext a b
    simp only [gate, evalPrimitiveGate, matrix_apply, equivPermutationMatrix]
    change (if a = cxBasisAction (e c) (e t) b then (1 : ℂ) else 0) =
      if (fun w => a (e w)) = cxBasisAction c t (fun w => b (e w)) then 1 else 0
    have he : a = cxBasisAction (e c) (e t) b ↔
        (fun w => a (e w)) = cxBasisAction c t (fun w => b (e w)) := by
      rw [← (basisEquiv e).symm.injective.eq_iff]
      rw [show (basisEquiv e).symm (cxBasisAction (e c) (e t) b) = _ from cx_action e c t b]
      rfl
    simp only [he]

/-- One actual renamed primitive list, with both boundary index maps exposed. -/
theorem eval_circuit {m n : Nat} (e : Fin m ≃ Fin n) (c : PrimitiveCircuit m) :
    evalPrimitiveCircuit (circuit e c) = matrix e (evalPrimitiveCircuit c) := by
  induction c with
  | nil => simp [circuit, evalPrimitiveCircuit, matrix]
  | cons g c ih =>
    simp only [circuit, List.map_cons, evalPrimitiveCircuit] at *
    rw [ih, eval_gate, ← matrix_mul]

@[simp] theorem gateCount {m n : Nat} (e : Fin m ≃ Fin n) (c : PrimitiveCircuit m) :
    (circuit e c).gateCount = c.gateCount := by simp [circuit]

@[simp] theorem ryCount {m n : Nat} (e : Fin m ≃ Fin n) (c : PrimitiveCircuit m) :
    (circuit e c).ryCount = c.ryCount := by
  induction c with
  | nil => rfl
  | cons g c ih => cases g <;> simp_all [circuit, gate, PrimitiveCircuit.ryCount]

@[simp] theorem cxCount {m n : Nat} (e : Fin m ≃ Fin n) (c : PrimitiveCircuit m) :
    (circuit e c).cxCount = c.cxCount := by
  induction c with
  | nil => rfl
  | cons g c ih => cases g <;> simp_all [circuit, gate, PrimitiveCircuit.cxCount]

end QuantumBlockEncoding.PrimitiveWireRename
