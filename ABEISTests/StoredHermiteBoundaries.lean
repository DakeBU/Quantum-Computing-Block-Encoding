import QuantumBlockEncoding.StoredHermiteBoundaries

namespace QuantumBlockEncoding.StoredHermiteBoundaries.Regression

open StoredGivens HermiteBoundaryInjection


example : (initial 0 0 1).value[0] = 0 := by
  have h : HermiteExplicitBond.bondEquiv 0 0 = Sum.inl none := by decide
  simpa [initialLiteral, h] using initial_get 0 0 1 (0 : Fin 6)

example : (initial 0 1 1).value[0] = 1 := by
  have h : HermiteExplicitBond.bondEquiv 0 0 = Sum.inl none := by decide
  simpa [initialLiteral, h] using initial_get 0 1 1 (0 : Fin 6)

example : (initial 0 1 1).value[2] = 0 := by
  have h : HermiteExplicitBond.bondEquiv 0 2 = Sum.inr (Sum.inl none) := by decide
  simpa [initialLiteral, h] using initial_get 0 1 1 (2 : Fin 6)

example : (terminal 0).value[3] = 1 := by
  have h : HermiteExplicitBond.bondEquiv 0 3 = Sum.inr (Sum.inl (some 0)) := by decide
  simpa [terminalLiteral, h] using terminal_get 0 (3 : Fin 6)

example : (terminal 0).value[4] = 0 := by
  have h : HermiteExplicitBond.bondEquiv 0 4 = Sum.inr (Sum.inl (some 1)) := by decide
  simpa [terminalLiteral, h] using terminal_get 0 (4 : Fin 6)

example (k cut midpoint : ℕ) : (initial k cut midpoint).cost .field = 0 := by
  simp [initial_cost, tick]

example (k : ℕ) : (terminal k).cost .field = 0 := by
  simp [terminal_cost, tick]

#print axioms initial_value
#print axioms terminal_value


end QuantumBlockEncoding.StoredHermiteBoundaries.Regression
