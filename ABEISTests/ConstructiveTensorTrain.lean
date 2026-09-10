import QuantumBlockEncoding.ConstructiveTensorTrain

namespace ConstructiveTensorTrainTests

open scoped BigOperators
open QuantumBlockEncoding
open TensorTrainCanonical ConstructiveTensorTrain

-- Empty chains retain their actual rank, identity residual, and terminal bond.
example (r : ℕ) : (canonicalize (.nil r)).rank = r := rfl
example (r : ℕ) : (canonicalize (.nil r)).residual =
    (1 : _root_.Matrix (Fin r) (Fin r) ℝ) := rfl
example (r : ℕ) : (canonicalize (.nil r)).canonical = .nil r := rfl

-- The executable structural rank recurrence is the exact backward min rule.
example {n l m r : ℕ} (A : Core l m) (C : Chain n m r) :
    (canonicalize (.cons A C)).rank = min l (2 * (canonicalize C).rank) := rfl

def zeroBond : Chain 1 3 0 := .cons 0 (.nil 0)
example : (canonicalize zeroBond).rank = 0 := rfl
example : maxBond (canonicalize zeroBond).canonical ≤ 3 := by
  simpa [zeroBond, maxBond] using canonicalize_maxBond_le zeroBond
example (x : Word 1) : contract zeroBond x =
    (canonicalize zeroBond).residual * contract (canonicalize zeroBond).canonical x :=
  canonicalize_action zeroBond x

def repeatedHead : Core 2 1 := fun _ out => if out.1 = 0 then 1 else 2
def terminalCore : Core 1 1 := fun _ out => if out.1 = 0 then 1 else 0
def deficient : Chain 2 2 1 := .cons repeatedHead (.cons terminalCore (.nil 1))

example : repeatedHead 0 = repeatedHead 1 := rfl
example : repeatedHead 0 (0, 0) = 1 := by norm_num [repeatedHead]
-- Deficient rank does not shorten the prescribed min-shape canonical rows.
example : (canonicalize deficient).rank = 2 := rfl
example : RightCanonical (canonicalize deficient).canonical :=
  canonicalize_rightCanonical deficient
example : RankReduced deficient (canonicalize deficient).canonical :=
  canonicalize_rankReduced deficient
example (x : Word 2) : contract deficient x =
    (canonicalize deficient).residual * contract (canonicalize deficient).canonical x :=
  canonicalize_action deficient x
example : maxBond (canonicalize deficient).canonical ≤ 2 := by
  simpa [deficient, maxBond] using canonicalize_maxBond_le deficient

def negativeUnit : Chain 1 1 1 :=
  .cons (fun _ out => if out.1 = 0 then -1 else 0) (.nil 1)

private theorem negativeUnit_normalized :
    (∑ x : Word 1, (contract negativeUnit x 0 0) ^ 2) = 1 := by
  change (∑ x : Fin 2 × Unit, (contract negativeUnit x 0 0) ^ 2) = 1
  rw [Fintype.sum_prod_type]
  simp [negativeUnit, contract, slice, Fin.sum_univ_two]

-- A signed normalized source gets a normalized actual residual boundary.
example : mass (stateBoundary negativeUnit) = 1 :=
  stateBoundary_normalized negativeUnit negativeUnit_normalized
example (x : Word 1) : contract negativeUnit x 0 0 =
    ∑ a, stateBoundary negativeUnit a * contract (canonicalize negativeUnit).canonical x a 0 :=
  stateBoundary_action negativeUnit x

-- The residual identity is arbitrary-length and arbitrary-boundary, not a
-- statement about only normalized or scalar-boundary examples.
example {n l r : ℕ} (C : Chain n l r) (v : Fin l → ℝ) :
    chainMass C v = mass (boundary C v) := boundary_mass C v

#print axioms QuantumBlockEncoding.ConstructiveTensorTrain.factorCore
#print axioms QuantumBlockEncoding.ConstructiveTensorTrain.canonicalize
#print axioms QuantumBlockEncoding.ConstructiveTensorTrain.canonicalize_action
#print axioms QuantumBlockEncoding.ConstructiveTensorTrain.canonicalize_maxBond_le
#print axioms QuantumBlockEncoding.ConstructiveTensorTrain.stateBoundary_normalized

end ConstructiveTensorTrainTests
