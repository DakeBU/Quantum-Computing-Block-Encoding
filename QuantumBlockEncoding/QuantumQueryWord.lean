import QuantumBlockEncoding.BornStability

/-!
Single-block coherent query words. Instructions are listed chronologically:
`eval (g :: rest) U = eval rest U * g.eval U`. Known gates are individually
specified unitary matrices; every oracle instruction uses the same fixed `U`.
Both forward and inverse calls count as queries, while known gates count
separately. All operator norms are induced Euclidean L2 norms.

This exact-real circuit semantics does not construct an estimator, a finite-bit
compiler, a measurement/reset producer, or a stochastic process across blocks.
-/
namespace QuantumBlockEncoding.QuantumQueryWord

open scoped Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- A known gate carries its actual unitary certificate; oracle directions are
syntactic instructions and are interpreted against one fixed oracle. -/
inductive Instruction (ι : Type*) [Fintype ι] [DecidableEq ι]
  | known (gate : Matrix.unitaryGroup ι ℂ)
  | forward
  | inverse

abbrev Word (ι : Type*) [Fintype ι] [DecidableEq ι] := List (Instruction ι)

def Instruction.queryCost : Instruction ι → ℕ
  | .known _ => 0
  | .forward => 1
  | .inverse => 1

def queryCount : Word ι → ℕ
  | [] => 0
  | g :: rest => g.queryCost + queryCount rest

def forwardCount : Word ι → ℕ
  | [] => 0
  | .forward :: rest => 1 + forwardCount rest
  | _ :: rest => forwardCount rest

def inverseCount : Word ι → ℕ
  | [] => 0
  | .inverse :: rest => 1 + inverseCount rest
  | _ :: rest => inverseCount rest

def knownCount : Word ι → ℕ
  | [] => 0
  | .known _ :: rest => 1 + knownCount rest
  | _ :: rest => knownCount rest

/-- The charged quantity is exactly the number of forward and inverse calls. -/
theorem queryCount_eq (w : Word ι) : queryCount w = forwardCount w + inverseCount w := by
  induction w with
  | nil => rfl
  | cons g rest ih => cases g <;> simp [queryCount, Instruction.queryCost,
      forwardCount, inverseCount, ih] <;> omega

theorem length_eq_costs (w : Word ι) : w.length = knownCount w + queryCount w := by
  induction w with
  | nil => rfl
  | cons g rest ih => cases g <;> simp [knownCount, queryCount, Instruction.queryCost, ih] <;> omega

noncomputable def Instruction.eval (g : Instruction ι) (U : Matrix ι ι ℂ) :
    Matrix ι ι ℂ :=
  match g with
  | .known gate => gate
  | .forward => U
  | .inverse => star U

noncomputable def eval : Word ι → Matrix ι ι ℂ → Matrix ι ι ℂ
  | [], _ => 1
  | g :: rest, U => eval rest U * g.eval U

theorem Instruction.eval_unitary (g : Instruction ι) (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) : g.eval U ∈ Matrix.unitaryGroup ι ℂ := by
  cases g with
  | known gate => exact gate.property
  | forward => exact hU
  | inverse => exact Unitary.star_mem hU

/-- Unitarity is derived from the instruction semantics, not assumed for a word. -/
theorem eval_unitary (w : Word ι) (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) : eval w U ∈ Matrix.unitaryGroup ι ℂ := by
  induction w with
  | nil => exact (Matrix.unitaryGroup ι ℂ).one_mem
  | cons g rest ih => exact (Matrix.unitaryGroup ι ℂ).mul_mem ih (g.eval_unitary U hU)

/-- Appending preserves chronological execution: the second word acts last. -/
theorem eval_append (a b : Word ι) (U : Matrix ι ι ℂ) :
    eval (a ++ b) U = eval b U * eval a U := by
  induction a with
  | nil => simp [eval]
  | cons g rest ih => simp [eval, ih, mul_assoc]

theorem Instruction.eval_distance_le (g : Instruction ι) (U V : Matrix ι ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    ‖g.eval U - g.eval V‖ ≤ (g.queryCost : ℝ) * η := by
  cases g with
  | known gate => simp [Instruction.eval, Instruction.queryCost]
  | forward => simpa [Instruction.eval, Instruction.queryCost] using hUV
  | inverse => simpa [Instruction.eval, Instruction.queryCost, ← star_sub, norm_star] using hUV

/-- Telescoping with unitary prefix/suffix factors charges exactly the oracle
calls; the same known instructions are evaluated for both fixed oracles. -/
theorem eval_distance_le (w : Word ι) (U V : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    ‖eval w U - eval w V‖ ≤ (queryCount w : ℝ) * η := by
  induction w with
  | nil => simp [eval, queryCount]
  | cons g rest ih =>
      simp only [eval]
      have split : eval rest U * g.eval U - eval rest V * g.eval V =
          (eval rest U - eval rest V) * g.eval U +
            eval rest V * (g.eval U - g.eval V) := by noncomm_ring
      rw [split]
      calc
        _ ≤ ‖(eval rest U - eval rest V) * g.eval U‖ +
            ‖eval rest V * (g.eval U - g.eval V)‖ := norm_add_le _ _
        _ = ‖eval rest U - eval rest V‖ + ‖g.eval U - g.eval V‖ := by
          rw [CStarRing.norm_mul_mem_unitary _ (g.eval_unitary U hU),
            CStarRing.norm_mem_unitary_mul _ (eval_unitary rest V hV)]
        _ ≤ (queryCount rest : ℝ) * η + (g.queryCost : ℝ) * η :=
          add_le_add ih (g.eval_distance_le U V hUV)
        _ = _ := by simp only [queryCount, Nat.cast_add]; ring

/-- A block budget bounds actual forward-plus-inverse oracle calls. -/
theorem bounded_eval_distance_le (w : Word ι) (U V : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) {D : ℕ} (hD : queryCount w ≤ D) :
    ‖eval w U - eval w V‖ ≤ (D : ℝ) * η := by
  have hη : 0 ≤ η := (norm_nonneg (U - V)).trans hUV
  exact (eval_distance_le w U V hU hV hUV).trans
    (mul_le_mul_of_nonneg_right (by exact_mod_cast hD) hη)

/-- The Born bias bound consumes the word's derived unitarity and telescoping
certificate; the input is fresh and normalized and the final matrix an effect. -/
theorem probability_difference_le (w : Word ι) (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |BornStability.probability (eval w U) P ψ -
      BornStability.probability (eval w V) P ψ| ≤ 2 * (queryCount w : ℝ) * η := by
  simpa [mul_assoc] using BornStability.probability_difference_le
    (eval w U) (eval w V) P ψ hψ (eval_unitary w U hU) (eval_unitary w V hV)
    hP hPI (eval_distance_le w U V hU hV hUV)

theorem bounded_probability_difference_le (w : Word ι) (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η)
    {D : ℕ} (hD : queryCount w ≤ D) :
    |BornStability.probability (eval w U) P ψ -
      BornStability.probability (eval w V) P ψ| ≤ 2 * (D : ℝ) * η := by
  simpa [mul_assoc] using BornStability.probability_difference_le
    (eval w U) (eval w V) P ψ hψ (eval_unitary w U hU) (eval_unitary w V hV)
    hP hPI (bounded_eval_distance_le w U V hU hV hUV hD)

end QuantumBlockEncoding.QuantumQueryWord
