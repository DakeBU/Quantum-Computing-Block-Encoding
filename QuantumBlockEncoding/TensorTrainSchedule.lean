import QuantumBlockEncoding.TensorTrainCanonical

/-!
# Dependent tensor trains in a fixed padded sequential register

Extract the actual active ranks and local padded cores from a dependent chain.
Bits are emitted in increasing wire order. Theorems below concern exact matrix
action; local primitive synthesis and global wire placement are separate.
-/

namespace QuantumBlockEncoding.TensorTrainSchedule

open scoped BigOperators
open TensorTrainCanonical
open SequentialBondPreparation

/-- Convert increasing-wire basis labels to the head-first chain word. -/
def wordOfBasis : {n : ℕ} → PrimitiveBasis n → Word n
  | 0, _ => ()
  | _ + 1, x => (x 0, wordOfBasis (Fin.tail x))

/-- Active rank before stage `t`; after the chain it is the terminal rank. -/
def rankAt : {n l r : ℕ} → Chain n l r → ℕ → ℕ
  | _, _, _, .nil r, _ => r
  | _, l, _, .cons _ _, 0 => l
  | _, _, _, .cons _ C, t + 1 => rankAt C t

@[simp] theorem rankAt_zero {n l r : ℕ} (C : Chain n l r) : rankAt C 0 = l := by
  cases C <;> rfl

@[simp] theorem rankAt_length {n l r : ℕ} (C : Chain n l r) : rankAt C n = r := by
  induction C with
  | nil _ => rfl
  | cons _ _ ih => exact ih

/-- The finite schedule, zero after the final core. Later stages are never
used by the bounded run theorem. -/
def paddedAt {B : ℕ} : {n l r : ℕ} → Chain n l r → ℕ →
    SequentialBondPreparation.Core (Fin B)
  | _, _, _, .nil _, _ => 0
  | _, _, _, .cons A _, 0 => paddedCore A
  | _, _, _, .cons _ C, t + 1 => paddedAt C t

theorem rankAt_le_maxBond {n l r : ℕ} (C : Chain n l r) (t : ℕ) :
    rankAt C t ≤ maxBond C := by
  induction C generalizing t with
  | nil _ => exact le_rfl
  | @cons n l m r A C ih =>
    cases t with
    | zero => exact le_max_left _ _
    | succ t => exact (ih t).trans (le_max_right _ _)

/-- Zero amplitude outside the next actual rank, for the extracted schedule. -/
theorem paddedAt_supported {n l r B : ℕ} (C : Chain n l r) (t : ℕ)
    (bit : Fin 2) (b a : Fin B) (hb : rankAt C (t + 1) ≤ b.val) :
    paddedAt C t (bit, b) a = 0 := by
  induction C generalizing t with
  | nil _ => rfl
  | @cons n l m r A C ih =>
    cases t with
    | zero =>
      apply paddedCore_inactive_output
      simpa only [rankAt, rankAt_zero] using hb
    | succ t => exact ih t hb

/-- Rewrite chronological transfer in first-bit order, matching `Chain.cons`.
The algebra still multiplies the last emitted matrix on the left. -/
theorem transfer_shift {B : Type*} [Fintype B] [DecidableEq B]
    (K : ℕ → SequentialBondPreparation.Core B) (n : ℕ)
    (x : PrimitiveBasis (n + 1)) :
    transfer K (n + 1) x =
      transfer (fun t => K (t + 1)) n (Fin.tail x) * coreSlice (K 0) (x 0) := by
  induction n with
  | zero => simp [transfer]
  | succ n ih =>
    rw [transfer, ih, transfer, _root_.Matrix.mul_assoc]
    simp [Fin.tail_init_eq_init_tail, Fin.tail, Fin.init]

/-- One extracted core slice acts as its exact real row-vector contraction,
with zero padding on the old and new bond labels. -/
theorem paddedSlice_mulVec {l r B : ℕ} (hl : l ≤ B) (A : TensorTrainCanonical.Core l r)
    (bit : Fin 2) (v : Fin l → ℝ) :
    (coreSlice (paddedCore A : SequentialBondPreparation.Core (Fin B)) bit).mulVec
      (padVector (fun a => (v a : ℂ))) =
      padVector (fun b => ((_root_.Matrix.vecMul v (slice A bit)) b : ℂ)) := by
  funext b
  change (∑ a : Fin B, paddedCore A (bit, b) a * padVector (fun a => (v a : ℂ)) a) = _
  rw [sum_padVector hl]
  by_cases hb : b.val < r
  · simp [paddedCore, padVector, hb, _root_.Matrix.vecMul, dotProduct, slice,
      Complex.ofReal_sum, Complex.ofReal_mul, mul_comm]
  · simp [paddedCore, padVector, hb]

/-- All-length transfer equals the original chain contraction at every
padded output label, not just after projection onto its active subspace. -/
theorem transfer_padded {n l r B : ℕ} (C : Chain n l r) (hB : maxBond C ≤ B)
    (v : Fin l → ℝ) (x : PrimitiveBasis n) (b : Fin B) :
    (transfer (paddedAt C) n x).mulVec (padVector (fun a => (v a : ℂ))) b =
      padVector (fun c => ((_root_.Matrix.vecMul v (contract C (wordOfBasis x))) c : ℂ)) b := by
  induction C with
  | nil r => simp [transfer, contract]
  | @cons n l m r A C ih =>
    have hl : l ≤ B := (le_max_left l (maxBond C)).trans hB
    have ht : maxBond C ≤ B := (le_max_right l (maxBond C)).trans hB
    rw [transfer_shift, ← _root_.Matrix.mulVec_mulVec]
    change (transfer (paddedAt C) n (Fin.tail x)).mulVec
      ((coreSlice (paddedCore A) (x 0)).mulVec (padVector (fun a => (v a : ℂ)))) b = _
    rw [paddedSlice_mulVec hl, ih ht]
    simp only [contract, wordOfBasis, _root_.Matrix.vecMul_vecMul]

/-- A bounded version of the sequential local-column theorem: unused later
stages need not implement the zero cores after the end of the schedule. -/
theorem run_eq_transfer_bounded {B : Type*} [Fintype B] [DecidableEq B]
    (U : ℕ → Stage B) (K : ℕ → SequentialBondPreparation.Core B)
    (active : ℕ → B → Prop) (boundary : B → ℂ)
    (initialSupport : ∀ b, ¬ active 0 b → boundary b = 0)
    (coreSupport : ∀ t bit b a, ¬ active (t + 1) b → K t (bit, b) a = 0)
    (n : ℕ)
    (columns : ∀ t, t < n → ∀ bit b a, active t a → U t (bit, b) (0, a) = K t (bit, b) a)
    (x : PrimitiveBasis n) (b : B) :
    run U boundary n (x, b) = (transfer K n x).mulVec boundary b := by
  classical
  induction n generalizing b with
  | zero => simp [run, transfer]
  | succ n ih =>
    rw [run, step_apply, transfer, ← _root_.Matrix.mulVec_mulVec]
    simp only [_root_.Matrix.mulVec, dotProduct, coreSlice]
    apply Finset.sum_congr rfl
    intro a _
    have hc : ∀ t, t < n → ∀ bit b a, active t a →
        U t (bit, b) (0, a) = K t (bit, b) a :=
      fun t ht => columns t (Nat.lt_succ_of_lt ht)
    rw [ih hc]
    by_cases ha : active n a
    · rw [columns n (Nat.lt_succ_self n) _ b a ha]
      rfl
    · have hz := transfer_boundary_supported K active boundary initialSupport coreSupport
        n (Fin.init x) a ha
      change _ * (transfer K n (Fin.init x)).mulVec boundary a =
        _ * (transfer K n (Fin.init x)).mulVec boundary a
      rw [hz, mul_zero, mul_zero]

/-- Exact complete sequential action of the schedule extracted from an
actual dependent train. Only its first `n` local active columns are premises. -/
theorem run_padded {n l r B : ℕ} (C : Chain n l r) (hB : maxBond C ≤ B)
    (U : ℕ → Stage (Fin B))
    (columns : ∀ t, t < n → ∀ bit b a, a.val < rankAt C t →
      U t (bit, b) (0, a) = paddedAt C t (bit, b) a)
    (v : Fin l → ℝ) (x : PrimitiveBasis n) (b : Fin B) :
    run U (padVector (fun a => (v a : ℂ))) n (x, b) =
      padVector (fun c => ((_root_.Matrix.vecMul v (contract C (wordOfBasis x))) c : ℂ)) b := by
  rw [run_eq_transfer_bounded U (paddedAt C) (fun t a => a.val < rankAt C t)
    (padVector (fun a => (v a : ℂ)))
    (fun b hb => by
      simp only [rankAt_zero] at hb
      simp [padVector, hb])
    (fun t bit b a hb => paddedAt_supported C t bit b a (Nat.le_of_not_gt hb))
    n columns]
  exact transfer_padded C hB v x b

/-- Terminal dimension one gives whole-state cleanup at physical label zero.
The amplitude at every other padded label is exactly zero. -/
theorem run_terminal_clean {n l B : ℕ} (C : Chain n l 1) (hB : maxBond C ≤ B)
    (U : ℕ → Stage (Fin B))
    (columns : ∀ t, t < n → ∀ bit b a, a.val < rankAt C t →
      U t (bit, b) (0, a) = paddedAt C t (bit, b) a)
    (v : Fin l → ℝ) (x : PrimitiveBasis n) (b : Fin B) :
    run U (padVector (fun a => (v a : ℂ))) n (x, b) =
      if b.val = 0 then
        ((_root_.Matrix.vecMul v (contract C (wordOfBasis x))) 0 : ℂ) else 0 := by
  rw [run_padded C hB U columns v x b]
  by_cases hb : b.val = 0
  · simp [padVector, hb]
  · have hb1 : ¬ b.val < 1 := by omega
    simp [padVector, hb, hb1]

/-- Every extracted stage of a canonical chain has orthonormal occupied
columns in the one fixed physical register. -/
theorem paddedAt_active_isometry {n l r B : ℕ} (C : Chain n l r)
    (hC : RightCanonical C) (hB : maxBond C ≤ B) (t : ℕ) (ht : t < n)
    (a c : Fin (rankAt C t)) :
    (∑ out : Fin 2 × Fin B,
      star (paddedAt C t out (Fin.castLE ((rankAt_le_maxBond C t).trans hB) a)) *
        paddedAt C t out (Fin.castLE ((rankAt_le_maxBond C t).trans hB) c)) =
      if a = c then 1 else 0 := by
  induction C generalizing t with
  | nil _ => omega
  | @cons n l m r A C ih =>
    have hl : l ≤ B := (le_max_left l (maxBond C)).trans hB
    have htail : maxBond C ≤ B := (le_max_right l (maxBond C)).trans hB
    have hm : m ≤ B := by simpa using (rankAt_le_maxBond C 0).trans htail
    cases t with
    | zero => exact paddedCore_active_isometry hl hm A hC.1 a c
    | succ t => exact ih hC.2 htail t (by omega) a c

/-- A normalized scalar-boundary source train has a bounded canonical
schedule with exact whole-state source action whenever its *local occupied
columns* are implemented. No source-state oracle or global-action hypothesis
occurs in the premises. -/
theorem exists_normalized_preparation_schedule {n B : ℕ} (C : Chain n 1 1)
    (hB : maxBond C ≤ B)
    (hNorm : (∑ x : Word n, (contract C x 0 0) ^ 2) = 1) :
    ∃ (l' : ℕ) (u : Fin l' → ℝ) (D : Chain n l' 1),
      RightCanonical D ∧ RankReduced C D ∧ mass u = 1 ∧ maxBond D ≤ B ∧
      ∀ (U : ℕ → Stage (Fin B)),
        (∀ t, t < n → ∀ bit b a, a.val < rankAt D t →
          U t (bit, b) (0, a) = paddedAt D t (bit, b) a) →
        ∀ (x : PrimitiveBasis n) (b : Fin B),
          run U (padVector (fun a => (u a : ℂ))) n (x, b) =
            if b.val = 0 then (contract C (wordOfBasis x) 0 0 : ℂ) else 0 := by
  obtain ⟨l', u, D, hD, hRanks, hu, hAmplitude⟩ := exists_normalized_state C hNorm
  have hDB : maxBond D ≤ B := hRanks.maxBond_le.trans hB
  refine ⟨l', u, D, hD, hRanks, hu, hDB, ?_⟩
  intro U columns x b
  rw [run_terminal_clean D hDB U columns u x b]
  simp only [_root_.Matrix.vecMul, dotProduct]
  rw [← hAmplitude]

end QuantumBlockEncoding.TensorTrainSchedule
