import QuantumBlockEncoding.PromiseGateUnitary
import Mathlib.Tactic

/-!
# QMUX constructor for matrix-level strong promise gates

Vandaele Definition 3.2 writes a strong promise gate as

`sum_j |j><j| tensor U_j`.

Mathlib's `Matrix.blockDiagonal` has exactly this semantics, with product index
order `target × promise`.  This module reindexes it to the source-facing
`promise × target` order and proves the complete constructor theorem: a family
of unitary target blocks gives a unitary QMUX, and fixing the clean block to U
gives a `StrongPromiseMatrixSpec`.
-/

namespace QuantumBlockEncoding
namespace PromiseGateUnitaryMux

open PromiseGateUnitary
open QuantumBlockEncoding.Robin.ComplexLCU

/-- Promise-first QMUX matrix associated with a family of target operators. -/
def qmuxMatrix
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (blocks : ρ -> _root_.Matrix α α ℂ) :
    _root_.Matrix (ρ × α) (ρ × α) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ
    (Equiv.prodComm α ρ)
    (_root_.Matrix.blockDiagonal blocks)

/-- Entry formula: QMUX has zero off-diagonal promise blocks. -/
theorem qmuxMatrix_apply
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (blocks : ρ -> _root_.Matrix α α ℂ)
    (promiseOut promiseIn : ρ) (targetOut targetIn : α) :
    qmuxMatrix blocks (promiseOut, targetOut) (promiseIn, targetIn) =
      if promiseOut = promiseIn then
        blocks promiseOut targetOut targetIn
      else 0 := by
  simp [qmuxMatrix, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    _root_.Matrix.blockDiagonal_apply]

/-- A QMUX of unitary blocks is unitary. -/
theorem qmuxMatrix_unitary
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (blocks : ρ -> _root_.Matrix α α ℂ)
    (unitary : ∀ promise,
      blocks promise ∈ _root_.Matrix.unitaryGroup α ℂ) :
    qmuxMatrix blocks ∈ _root_.Matrix.unitaryGroup (ρ × α) ℂ := by
  unfold qmuxMatrix
  exact reindex_unitary
    (Equiv.prodComm α ρ)
    (_root_.Matrix.blockDiagonal blocks)
    (blockDiagonal_unitary blocks unitary)

/-- Construct Definition 3.2 from an arbitrary unitary block family whose clean
block is the requested target U. -/
theorem qmux_strongPromise
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (blocks : ρ -> _root_.Matrix α α ℂ)
    (target : _root_.Matrix α α ℂ)
    (unitary : ∀ promise,
      blocks promise ∈ _root_.Matrix.unitaryGroup α ℂ)
    (cleanBlock : blocks cleanPromise = target) :
    StrongPromiseMatrixSpec cleanPromise (qmuxMatrix blocks) target := by
  constructor
  · rw [← cleanBlock]
    exact unitary cleanPromise
  · constructor
    · exact qmuxMatrix_unitary blocks unitary
    · constructor
      · intro promiseOut targetOut promiseIn targetIn different
        rw [qmuxMatrix_apply, if_neg different]
      · intro targetOut targetIn
        rw [qmuxMatrix_apply, if_pos rfl, cleanBlock]

/-- QMUX clean-fibre action as a matrix-entry theorem. -/
theorem qmux_cleanBlock
    {ρ α : Type*} [Fintype ρ] [DecidableEq ρ]
    [Fintype α] [DecidableEq α]
    (cleanPromise : ρ)
    (blocks : ρ -> _root_.Matrix α α ℂ)
    (target : _root_.Matrix α α ℂ)
    (cleanBlock : blocks cleanPromise = target)
    (targetOut targetIn : α) :
    qmuxMatrix blocks (cleanPromise, targetOut) (cleanPromise, targetIn) =
      target targetOut targetIn := by
  rw [qmuxMatrix_apply, if_pos rfl, cleanBlock]

end PromiseGateUnitaryMux
end QuantumBlockEncoding
