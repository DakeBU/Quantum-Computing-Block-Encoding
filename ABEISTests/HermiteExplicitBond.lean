import QuantumBlockEncoding.HermiteExplicitBond

namespace HermiteExplicitBondTests

open QuantumBlockEncoding HermiteBoundaryInjection HermiteExplicitBond

/-- These layout checks are executable reductions, not cardinality choice. -/
example : bondEquiv 0 0 = Sum.inl none := by decide
example : bondEquiv 0 1 = Sum.inl (some ()) := by decide
example : bondEquiv 0 2 = Sum.inr (Sum.inl none) := by decide
example : bondEquiv 0 3 = Sum.inr (Sum.inl (some 0)) := by decide
example : bondEquiv 0 4 = Sum.inr (Sum.inl (some 1)) := by decide
example : bondEquiv 0 5 = Sum.inr (Sum.inr ()) := by decide
example : bondEquiv 3 11 = Sum.inr (Sum.inr ()) := by decide

example (k : ℕ) (b : HermiteFiniteBond k) :
    bondEquiv k ((bondEquiv k).symm b) = b := (bondEquiv k).apply_symm_apply b

/-- The layout change preserves the literal source on every grid word. -/
example (k n : ℕ) (L : ℝ) (hL : 0 < L) (x : TensorTrainCanonical.Word (n + 1)) :
    TensorTrainCanonical.contract (rawSourceChain k n L) x 0 0 =
      TensorTrainCanonical.contract (HermiteFiniteNorm.rawSourceChain k n L) x 0 0 :=
  same_literal_source k n L hL x

example (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    0 < TensorTrainNormEnvironment.norm (rawSourceChain k n L) := by
  rw [rawSourceChain_norm k n L hL]
  exact HermiteStatePreparation.sampleNorm_pos k (n + 1) L

#print axioms QuantumBlockEncoding.HermiteExplicitBond.bondEquiv
#print axioms QuantumBlockEncoding.HermiteExplicitBond.same_literal_source
#print axioms QuantumBlockEncoding.HermiteExplicitBond.rawSourceChain_norm

end HermiteExplicitBondTests
