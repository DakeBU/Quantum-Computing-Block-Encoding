import QuantumBlockEncoding.StoredTensorTrain

namespace ABEISTests.StoredTensorTrain

open scoped BigOperators
open QuantumBlockEncoding StoredGivens TensorTrainCanonical QuantumBlockEncoding.StoredTensorTrain

def zeroCore (l r : ℕ) : StoredCore l r := Vector.replicate l (Vector.replicate (2 * r) 0)
def zeroBond : StoredChain 1 3 0 := .cons (zeroCore 3 0) (.nil 0)
def allZero : StoredChain 1 2 1 := .cons (zeroCore 2 1) (.nil 1)
def repeatedHead : StoredCore 2 1 :=
  Vector.ofFn (fun _ => Vector.ofFn (fun j : Fin 2 => if j = 0 then 1 else 2))
def terminalCore : StoredCore 1 1 :=
  Vector.ofFn (fun _ => Vector.ofFn (fun j : Fin 2 => if j = 0 then 1 else 0))
def deficient : StoredChain 2 2 1 := .cons repeatedHead (.cons terminalCore (.nil 1))
def signedChain : StoredChain 1 1 1 := .cons terminalCore (.nil 1)

-- Empty and zero-bond inputs retain their literal structural rank convention.
example (r : ℕ) : (canonicalize (.nil r)).value.rank = r := rfl
example (r : ℕ) : denoteChain (canonicalize (.nil r)).value.canonical = .nil r := rfl
example (r : ℕ) : denote (canonicalize (.nil r)).value.residual =
    (1 : _root_.Matrix (Fin r) (Fin r) ℝ) := StoredRectangularGivens.identity_value r
example : (canonicalize zeroBond).value.rank = 0 := rfl
example : (canonicalize allZero).value.rank = 2 := rfl
example : (canonicalize deficient).value.rank = 2 := rfl

example (x : Word 1) : contract (denoteChain allZero) x = 0 := by
  ext a b
  simp [allZero, denoteChain, contract, slice, denoteCore, zeroCore, denote]

-- Repeated nonzero rows are genuinely deficient, while Q keeps the min shape.
example : denoteCore repeatedHead 0 = denoteCore repeatedHead 1 := rfl
example : denoteCore repeatedHead 0 (0, 0) = 1 := by
  norm_num [denoteCore, repeatedHead, denote, finProdFinEquiv]
example : RightCanonical (denoteChain (canonicalize deficient).value.canonical) :=
  (canonicalize deficient).value.rightCanonical
example : RankReduced (denoteChain deficient) (denoteChain (canonicalize deficient).value.canonical) :=
  (canonicalize deficient).value.rankReduced
example (x : Word 2) : contract (denoteChain deficient) x =
    denote (canonicalize deficient).value.residual *
      contract (denoteChain (canonicalize deficient).value.canonical) x :=
  (canonicalize deficient).value.action x

example : maxBond (denoteChain (canonicalize deficient).value.canonical) ≤ 2 := by
  simpa [deficient, denoteChain, maxBond] using canonicalize_maxBond_le deficient

-- All operation bounds concern the actual stored run, including empty input.
example : StoredRectangularGivens.total (canonicalize (.nil 0)).cost ≤ 6 := by
  simpa using canonicalize_total_cost_le (.nil 0) 0 (by simp [denoteChain, maxBond])
example : StoredRectangularGivens.total (canonicalize deficient).cost ≤ 3910 := by
  simpa using canonicalize_total_cost_le deficient 2 (by simp [deficient, denoteChain, maxBond])
example {n l r : ℕ} (C : StoredChain n l r) (D : ℕ)
    (h : maxBond (denoteChain C) ≤ D) :
    StoredRectangularGivens.total (canonicalize C).cost ≤
      n * (176 * D ^ 3 + 116 * D ^ 2 + 29 * D + 8) + 5 * D ^ 2 + 4 * D + 6 :=
  canonicalize_total_cost_le C D h

-- The dot product is actually empty, with nonempty output indices.
example (a : Fin 3) (out : Fin 2 × Fin 1) :
    (absorptionEntry (zeroCore 3 0) (Vector.replicate 0 (Vector.replicate 1 0)) a out).cost .field = 0 := by
  simp [absorptionEntry, sumEntries, pure, Run.pure]
example (a : Fin 3) (out : Fin 2 × Fin 1) :
    (absorptionEntry (zeroCore 3 0) (Vector.replicate 0 (Vector.replicate 1 0)) a out).value = 0 := by
  simp [absorptionEntry, sumEntries, pure, Run.pure]

private theorem terminalCore_eq : denoteCore terminalCore =
    fun _ out => if out.1 = 0 then (1 : ℝ) else 0 := by
  ext a out
  rcases out with ⟨bit, b⟩
  fin_cases a <;> fin_cases bit <;> fin_cases b <;>
    norm_num [denoteCore, terminalCore, denote, finProdFinEquiv]

private theorem signed_mass : chainMass (denoteChain signedChain) (fun _ => -1) = 1 := by
  change (∑ x : Fin 2 × Unit,
    mass (_root_.Matrix.vecMul (fun _ => -1) (contract (denoteChain signedChain) x))) = 1
  rw [Fintype.sum_prod_type]
  simp [signedChain, denoteChain, contract, slice, terminalCore_eq, mass,
    _root_.Matrix.vecMul, dotProduct]

-- Signed normalized boundaries are preserved, not just nonnegative states.
example : mass (boundary signedChain (fun _ => -1)) = 1 :=
  boundary_normalized signedChain (fun _ => -1) signed_mass
example {n l r : ℕ} (C : StoredChain n l r) (v : Fin l → ℝ) :
    chainMass (denoteChain C) v = mass (boundary C v) := boundary_mass C v

-- Refinement compares all actual rank/residual/canonical data, not existence.
example {n l r : ℕ} (C : StoredChain n l r) :
    (canonicalize C).value.toSemantic = ConstructiveTensorTrain.canonicalize (denoteChain C) :=
  canonicalize_refines C

#print axioms QuantumBlockEncoding.StoredTensorTrain.canonicalize
#print axioms QuantumBlockEncoding.StoredTensorTrain.canonicalize_total_cost_le
#print axioms QuantumBlockEncoding.StoredTensorTrain.absorption_value
#print axioms QuantumBlockEncoding.StoredTensorTrain.boundary_normalized
#print axioms QuantumBlockEncoding.StoredTensorTrain.canonicalize_refines

end ABEISTests.StoredTensorTrain
