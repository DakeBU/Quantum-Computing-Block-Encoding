import QuantumBlockEncoding.HermitePolynomial
import QuantumBlockEncoding.RealAmplitudePreparation

/-!
# Exact Hermite smooth-initial-data preparation

The target is the literal exponential / Hermite-polynomial / exponential
splice, sampled at `p_j = -πL + 2πLj / 2^n`. The unitary below is the denotation
of an explicit RY/CX circuit. Its first column, normalization, and reference
gate counts hold for every smoothing order and register width.

Exact real angles belong to the symbolic certificate. Numerical evaluation
and rounded QASM angles remain separate executable-export evidence.
-/

namespace QuantumBlockEncoding.HermiteStatePreparation

open HermitePolynomial RealAmplitudePreparation ConcreteSemantics

noncomputable section

/-- Left-inclusive, right-exclusive grid on `[-πL,πL)` when `L>0`. -/
def gridPoint (n : ℕ) (L : ℝ) (j : Fin (gridSize n)) : ℝ :=
  -Real.pi * L + (j.val : ℝ) * (2 * Real.pi * L / (gridSize n : ℝ))

/-- The physical sample, without changing the polynomial on the splice interval. -/
def sampledAmplitude (k n : ℕ) (L : ℝ) (j : Fin (gridSize n)) : ℝ :=
  smoothInitial k (gridPoint n L j)

theorem sampledAmplitude_pos (k n : ℕ) (L : ℝ) (j : Fin (gridSize n)) :
    0 < sampledAmplitude k n L j := smoothInitial_pos _ _

/-- The true Euclidean normalizer of the complete finite sample table. -/
def sampleNorm (k n : ℕ) (L : ℝ) : ℝ :=
  Real.sqrt (∑ j, sampledAmplitude k n L j ^ 2)

theorem sampleNorm_pos (k n : ℕ) (L : ℝ) : 0 < sampleNorm k n L := by
  apply Real.sqrt_pos.mpr
  have h := normSq_pos_of_positive
    (fun b => sampledAmplitude k n L (primitiveBasisLEEquiv n b))
    (fun b => sampledAmplitude_pos k n L _)
  simpa only [normSq_reindex] using h

def normalizedAmplitude (k n : ℕ) (L : ℝ) (j : Fin (gridSize n)) : ℂ :=
  ((sampledAmplitude k n L j / sampleNorm k n L : ℝ) : ℂ)

/-- An actual list of primitive instructions on precisely `n` wires. -/
def hermiteCircuit (k n : ℕ) (L : ℝ) : PrimitiveCircuit n :=
  prepareCircuit n (fun b => sampledAmplitude k n L (primitiveBasisLEEquiv n b))

/-- The exact primitive denotation, reindexed by little-endian integers. -/
def hermiteUnitary (k n : ℕ) (L : ℝ) :
    _root_.Matrix (Fin (gridSize n)) (Fin (gridSize n)) ℂ :=
  prepareMatrixLE (sampledAmplitude k n L)

theorem hermiteUnitary_eq_circuit (k n : ℕ) (L : ℝ) :
    hermiteUnitary k n L =
      _root_.Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv n)
        (evalPrimitiveCircuit (hermiteCircuit k n L)) := rfl

theorem hermiteUnitary_unitary (k n : ℕ) (L : ℝ) :
    hermiteUnitary k n L ∈ _root_.Matrix.unitaryGroup (Fin (gridSize n)) ℂ :=
  prepareMatrixLE_unitary _

theorem hermite_firstColumn (k n : ℕ) (L : ℝ) (j : Fin (gridSize n)) :
    hermiteUnitary k n L j (zeroBasisIndex n) = normalizedAmplitude k n L j :=
  prepareMatrixLE_firstColumn _ (sampledAmplitude_pos k n L) j

/-- Every squared norm is included, including both exponential tails and the splice. -/
theorem hermite_normalized (k n : ℕ) (L : ℝ) :
    (∑ j, Complex.normSq (normalizedAmplitude k n L j)) = 1 := by
  simpa only [normalizedAmplitude, sampleNorm, Complex.normSq_ofReal, ← sq]
    using normalized_sum_sq_LE (sampledAmplitude k n L) (sampledAmplitude_pos k n L)

theorem hermite_stateAction (k n : ℕ) (L : ℝ) :
    applyVec (hermiteUnitary k n L) (zeroKet n) = normalizedAmplitude k n L := by
  rw [applyVec_zeroKet]
  funext j
  exact hermite_firstColumn k n L j

theorem hermite_ryCount (k n : ℕ) (L : ℝ) :
    (hermiteCircuit k n L).ryCount = 2 ^ n - 1 := prepareCircuit_ryCount _

theorem hermite_cxCount (k n : ℕ) (L : ℝ) :
    (hermiteCircuit k n L).cxCount = 2 * (2 ^ n - 1 - n) := prepareCircuit_cxCount _

theorem hermite_oracleCalls (k n : ℕ) (L : ℝ) :
    (hermiteCircuit k n L).resource.oracleCalls = 0 := prepareCircuit_oracleCalls _

/-- The circuit has exactly the data register and no allocated ancillary wire. -/
theorem hermite_noAncilla (k n : ℕ) (L : ℝ) :
    (hermiteCircuit k n L).resource.pureAncilla = 0 := rfl

/-- The closed symbolic root: normalization, genuine unitarity, primitive
state action and exact reference compiler resources are proved together. -/
theorem hermiteStatePreparation_complete (k n : ℕ) (L : ℝ) :
    0 < sampleNorm k n L ∧
    (∑ j, Complex.normSq (normalizedAmplitude k n L j)) = 1 ∧
    hermiteUnitary k n L ∈ _root_.Matrix.unitaryGroup (Fin (gridSize n)) ℂ ∧
    applyVec (hermiteUnitary k n L) (zeroKet n) = normalizedAmplitude k n L ∧
    (hermiteCircuit k n L).ryCount = 2 ^ n - 1 ∧
    (hermiteCircuit k n L).cxCount = 2 * (2 ^ n - 1 - n) ∧
    (hermiteCircuit k n L).resource.oracleCalls = 0 :=
  ⟨sampleNorm_pos k n L, hermite_normalized k n L, hermiteUnitary_unitary k n L,
    hermite_stateAction k n L, hermite_ryCount k n L, hermite_cxCount k n L,
    hermite_oracleCalls k n L⟩

/-- Integration into the existing concrete state-preparation certificate API. -/
def hermiteCertificate (k n : ℕ) (L : ℝ) : ComplexStatePreparationCertificate n where
  target := {
    amplitudes := normalizedAmplitude k n L
    normalization := (∑ j, Complex.normSq (normalizedAmplitude k n L j)) = 1
    source := "Exact exponential–Hermite–exponential initial datum on a little-endian grid"
  }
  gate := {
    matrix := hermiteUnitary k n L
    unitary := hermiteUnitary_unitary k n L
  }
  normalizationProof := hermite_normalized k n L
  preparationProof := hermite_stateAction k n L

end

end QuantumBlockEncoding.HermiteStatePreparation
