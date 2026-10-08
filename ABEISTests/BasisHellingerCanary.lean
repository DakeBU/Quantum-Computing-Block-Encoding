import QuantumBlockEncoding.BasisHellinger

open QuantumBlockEncoding BasisHellinger
open scoped Matrix.Norms.L2Operator

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

-- One source-contract instantiation: both measured distributions are produced
-- as normalized/nonnegative, together with both information inequalities.
example (w : QuantumQueryWord.Word ι) (U V : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) {D : ℕ} (hD : QuantumQueryWord.queryCount w ≤ D) :
    (∀ j, 0 ≤ basisProbability (wordOutput w U ψ) j) ∧
    (∀ j, 0 ≤ basisProbability (wordOutput w V ψ) j) ∧
    (∑ j, basisProbability (wordOutput w U ψ) j) = 1 ∧
    (∑ j, basisProbability (wordOutput w V ψ) j) = 1 ∧
    hellingerSq (basisProbability (wordOutput w U ψ)) (basisProbability (wordOutput w V ψ))
      ≤ (QuantumQueryWord.queryCount w : ℝ) ^ 2 * η ^ 2 ∧
    hellingerSq (basisProbability (wordOutput w U ψ)) (basisProbability (wordOutput w V ψ))
      ≤ (D : ℝ) * (QuantumQueryWord.queryCount w : ℝ) * η ^ 2 :=
  ⟨basisProbability_nonneg _, basisProbability_nonneg _,
    wordOutput_probability_normalized w U ψ hψ hU,
    wordOutput_probability_normalized w V ψ hψ hV,
    word_hellingerSq_le w U V ψ hψ hU hV hUV,
    bounded_word_hellingerSq_le w U V ψ hψ hU hV hUV hD⟩

#check BasisHellinger.hellingerSq_basis_formula
#check BasisHellinger.wordOutput_probability_normalized
#check BasisHellinger.word_hellingerSq_le
#check BasisHellinger.bounded_word_hellingerSq_le

#print axioms BasisHellinger.basisProbability_normalized
#print axioms BasisHellinger.hellingerSq_basis_le
#print axioms BasisHellinger.wordOutput_probability_normalized
#print axioms BasisHellinger.word_hellingerSq_le
#print axioms BasisHellinger.bounded_word_hellingerSq_le
