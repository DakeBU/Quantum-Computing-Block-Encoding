import QuantumBlockEncoding.Robin.ComplexLCU
import Mathlib.Tactic

/-!
# Matrix-level promise gates (Vandaele Definitions 3.1 and 3.2)

The reversible `WeakPromiseSpec` / `StrongPromiseSpec` used by most ASPBE
arithmetic files is the computational-basis permutation specialization needed by
the concrete `{CCX,CX,X}` constructions.  The paper's definitions are more
general: both the target and implementation are arbitrary unitaries.

For finite promise basis `ρ` and target basis `α`, this module records those
source definitions directly at the matrix level.

* Weak promise gate: the columns whose input promise label is `cleanPromise`
  have support only on the same output promise label, and their clean block is
  exactly the target unitary.
* Strong promise gate: the whole implementation is block diagonal in the
  promise basis (a QMUX), and the clean diagonal block is the target unitary.

Both the target and implementation are required to be unitary.  This is the
source-facing general layer; later files connect the reversible permutation
specialization to it.
-/

namespace QuantumBlockEncoding
namespace PromiseGateUnitary

/-- Matrix type for one finite-dimensional quantum register. -/
abbrev Operator (ι : Type*) [Fintype ι] := _root_.Matrix ι ι ℂ

/-- Vandaele Definition 3.1 in matrix-entry form.  The clean input fibre cannot
leak to another promise label and carries exactly the target operator. -/
def WeakPromiseMatrixSpec
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ)
    (target : _root_.Matrix α α ℂ) : Prop :=
  target ∈ _root_.Matrix.unitaryGroup α ℂ ∧
  implementation ∈ _root_.Matrix.unitaryGroup (ρ × α) ℂ ∧
  ∀ promiseOut targetOut targetIn,
    implementation (promiseOut, targetOut) (cleanPromise, targetIn) =
      if promiseOut = cleanPromise then target targetOut targetIn else 0

/-- Vandaele Definition 3.2: a strong promise gate is a unitary block diagonal
in the promise basis, with its clean block fixed to the requested target. -/
def StrongPromiseMatrixSpec
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ)
    (target : _root_.Matrix α α ℂ) : Prop :=
  target ∈ _root_.Matrix.unitaryGroup α ℂ ∧
  implementation ∈ _root_.Matrix.unitaryGroup (ρ × α) ℂ ∧
  (∀ promiseOut targetOut promiseIn targetIn,
    promiseOut ≠ promiseIn →
      implementation (promiseOut, targetOut) (promiseIn, targetIn) = 0) ∧
  ∀ targetOut targetIn,
    implementation (cleanPromise, targetOut) (cleanPromise, targetIn) =
      target targetOut targetIn

/-- Every strong promise gate is weak, exactly as stated after Definition 3.2. -/
theorem strong_implies_weak
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ)
    (target : _root_.Matrix α α ℂ)
    (strong : StrongPromiseMatrixSpec cleanPromise implementation target) :
    WeakPromiseMatrixSpec cleanPromise implementation target := by
  rcases strong with ⟨targetUnitary, implementationUnitary,
    blockDiagonal, cleanBlock⟩
  refine ⟨targetUnitary, implementationUnitary, ?_⟩
  intro promiseOut targetOut targetIn
  by_cases clean : promiseOut = cleanPromise
  · subst promiseOut
    simp [cleanBlock]
  · rw [if_neg clean]
    exact blockDiagonal promiseOut targetOut cleanPromise targetIn clean

/-- Off-diagonal promise blocks of a strong promise gate vanish independently
of the target indices. -/
theorem strong_offDiagonal
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    {cleanPromise : ρ}
    {implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ}
    {target : _root_.Matrix α α ℂ}
    (strong : StrongPromiseMatrixSpec cleanPromise implementation target)
    {promiseOut promiseIn : ρ} (different : promiseOut ≠ promiseIn)
    (targetOut targetIn : α) :
    implementation (promiseOut, targetOut) (promiseIn, targetIn) = 0 :=
  strong.2.2.1 promiseOut targetOut promiseIn targetIn different

/-- The clean diagonal block of a strong promise gate is exactly U. -/
theorem strong_cleanBlock
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    {cleanPromise : ρ}
    {implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ}
    {target : _root_.Matrix α α ℂ}
    (strong : StrongPromiseMatrixSpec cleanPromise implementation target)
    (targetOut targetIn : α) :
    implementation (cleanPromise, targetOut) (cleanPromise, targetIn) =
      target targetOut targetIn :=
  strong.2.2.2 targetOut targetIn

/-- Weak source guarantee split into its two operational consequences: no
promise leakage on clean input, and exact target block action. -/
theorem weak_clean_fibre
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    {cleanPromise : ρ}
    {implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ}
    {target : _root_.Matrix α α ℂ}
    (weak : WeakPromiseMatrixSpec cleanPromise implementation target)
    (promiseOut : ρ) (targetOut targetIn : α) :
    implementation (promiseOut, targetOut) (cleanPromise, targetIn) =
      if promiseOut = cleanPromise then target targetOut targetIn else 0 :=
  weak.2.2 promiseOut targetOut targetIn

/-- In particular, the promised subspace never leaks to a different promise
basis label. -/
theorem weak_no_leakage
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    {cleanPromise : ρ}
    {implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ}
    {target : _root_.Matrix α α ℂ}
    (weak : WeakPromiseMatrixSpec cleanPromise implementation target)
    {promiseOut : ρ} (different : promiseOut ≠ cleanPromise)
    (targetOut targetIn : α) :
    implementation (promiseOut, targetOut) (cleanPromise, targetIn) = 0 := by
  rw [weak_clean_fibre weak promiseOut targetOut targetIn, if_neg different]

/-- And on the clean output promise label the matrix entries are exactly U. -/
theorem weak_cleanBlock
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    {cleanPromise : ρ}
    {implementation : _root_.Matrix (ρ × α) (ρ × α) ℂ}
    {target : _root_.Matrix α α ℂ}
    (weak : WeakPromiseMatrixSpec cleanPromise implementation target)
    (targetOut targetIn : α) :
    implementation (cleanPromise, targetOut) (cleanPromise, targetIn) =
      target targetOut targetIn := by
  simpa using weak_clean_fibre weak cleanPromise targetOut targetIn

end PromiseGateUnitary
end QuantumBlockEncoding
