import QuantumBlockEncoding.StoredTensorTrainNorm

namespace ABEISTests.StoredTensorTrainNorm

open scoped BigOperators
open QuantumBlockEncoding StoredGivens TensorTrainCanonical StoredTensorTrain
open QuantumBlockEncoding.StoredTensorTrainNorm

def zeroCore (l r : ℕ) : StoredCore l r := Vector.replicate l (Vector.replicate (2 * r) 0)
def zeroBond : StoredChain 1 3 0 := .cons (zeroCore 3 0) (.nil 0)
def emptyLeft : StoredChain 1 0 2 := .cons (zeroCore 0 2) (.nil 2)
def zeroState : StoredChain 1 1 1 := .cons (zeroCore 1 1) (.nil 1)
def zeroInterior : StoredChain 2 1 1 :=
  .cons (zeroCore 1 0) (.cons (zeroCore 0 1) (.nil 1))

def signedCore : StoredCore 1 1 :=
  Vector.ofFn (fun _ => Vector.ofFn (fun j : Fin 2 => if j = 0 then -3 else 4))
def signedState : StoredChain 1 1 1 := .cons signedCore (.nil 1)

def repeatedCore : StoredCore 2 1 :=
  Vector.ofFn (fun _ => Vector.ofFn (fun j : Fin 2 => if j = 0 then 1 else 0))
def cancelCore : StoredCore 1 2 :=
  Vector.ofFn (fun _ => Vector.ofFn (fun j : Fin 4 => if j.val % 2 = 0 then 1 else -1))
def cancellation : StoredChain 2 1 1 := .cons cancelCore (.cons repeatedCore (.nil 1))

-- All dimensions, including empty matrices, use the actual stored producer.
example (r : ℕ) : denote (gram (.nil r)).value =
    (1 : _root_.Matrix (Fin r) (Fin r) ℝ) := gram_value (.nil r)
example : denote (gram emptyLeft).value = TensorTrainNormEnvironment.gram
    (denoteChain emptyLeft) := gram_value emptyLeft
example : denote (gram zeroBond).value = 0 := by
  rw [gram_value]
  ext a c
  simp [zeroBond, denoteChain, TensorTrainNormEnvironment.gram]
example : (norm (.nil 1)).value = 1 := by
  rw [norm_value]
  simp [TensorTrainNormEnvironment.norm, TensorTrainNormEnvironment.gram, denoteChain]
example : (norm zeroState).value = 0 := by
  rw [norm_value]
  simp [zeroState, denoteChain, TensorTrainNormEnvironment.norm,
    TensorTrainNormEnvironment.gram, slice, denoteCore, zeroCore, denote,
    _root_.Matrix.mul_apply]
example : (norm zeroInterior).value = 0 := by
  rw [norm_value]
  simp [zeroInterior, denoteChain, TensorTrainNormEnvironment.norm,
    TensorTrainNormEnvironment.gram]

-- A signed, non-normalized input; no positivity assumption is imposed on cores.
example : (norm signedState).value = 5 := by
  rw [norm_value]
  norm_num [signedState, denoteChain, TensorTrainNormEnvironment.norm,
    TensorTrainNormEnvironment.gram, slice, denoteCore, signedCore, denote,
    _root_.Matrix.mul_apply, finProdFinEquiv, Fin.sum_univ_two]

-- Repeated nonzero rows and cancellation across the internal bond.
example : denoteCore repeatedCore 0 = denoteCore repeatedCore 1 := rfl
example : (norm cancellation).value = 0 := by
  rw [norm_value]
  norm_num [cancellation, denoteChain, TensorTrainNormEnvironment.norm,
    TensorTrainNormEnvironment.gram, slice, denoteCore, cancelCore, repeatedCore,
    denote, _root_.Matrix.mul_apply, finProdFinEquiv, Fin.sum_univ_two]

-- Zero-length/zero-bond bounds do not require positive dimensions.
example : StoredRectangularGivens.total (gram (.nil 0)).cost ≤ 6 := by
  simpa using gram_total_cost_le (.nil 0) 0 (by simp [denoteChain, maxBond])
example : StoredRectangularGivens.total (norm (.nil 1)).cost ≤ 18 := by
  simpa using norm_total_cost_le (.nil 1) 1 (by simp [denoteChain, maxBond])
example : StoredRectangularGivens.total (norm signedState).cost ≤ 93 := by
  simpa using norm_total_cost_le signedState 1
    (by simp [signedState, denoteChain, maxBond])
example : StoredRectangularGivens.total (norm cancellation).cost ≤ 713 := by
  simpa using norm_total_cost_le cancellation 2
    (by simp [cancellation, denoteChain, maxBond])
example : StoredRectangularGivens.total (norm zeroInterior).cost ≤ 168 := by
  simpa using norm_total_cost_le zeroInterior 1
    (by simp [zeroInterior, denoteChain, maxBond])

example {n l r : ℕ} (C : StoredChain n l r) :
    denote (gram C).value = TensorTrainNormEnvironment.gram (denoteChain C) := gram_value C
example {n : ℕ} (C : StoredChain n 1 1) :
    (norm C).value = Real.sqrt (∑ x : Word n, contract (denoteChain C) x 0 0 ^ 2) :=
  norm_eq_sum C
example {n : ℕ} (C : StoredChain n 1 1) (D : ℕ) (h : maxBond (denoteChain C) ≤ D) :
    StoredRectangularGivens.total (norm C).cost ≤
      n * (24 * D ^ 3 + 25 * D ^ 2 + 20 * D + 6) + 5 * D ^ 2 + 4 * D + 9 :=
  norm_total_cost_le C D h

-- No arithmetic occurs when the inner contraction dimension is zero.
example (a : Fin 3) (c : Fin 3) :
    (secondEntry (Vector.replicate 3 (Vector.replicate 0 0)) (zeroCore 3 0) 0 a c).value = 0 := by
  simp [secondEntry, sumEntries, pure, Run.pure]
example (a : Fin 3) (c : Fin 3) :
    (secondEntry (Vector.replicate 3 (Vector.replicate 0 0)) (zeroCore 3 0) 0 a c).cost .field = 0 := by
  simp [secondEntry, sumEntries, pure, Run.pure]

#print axioms QuantumBlockEncoding.StoredTensorTrainNorm.gram
#print axioms QuantumBlockEncoding.StoredTensorTrainNorm.norm
#print axioms QuantumBlockEncoding.StoredTensorTrainNorm.gram_value
#print axioms QuantumBlockEncoding.StoredTensorTrainNorm.norm_value
#print axioms QuantumBlockEncoding.StoredTensorTrainNorm.gram_total_cost_le
#print axioms QuantumBlockEncoding.StoredTensorTrainNorm.norm_total_cost_le

end ABEISTests.StoredTensorTrainNorm
