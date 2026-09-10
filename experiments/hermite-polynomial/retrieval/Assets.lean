import QuantumBlockEncoding.HermiteStatePreparation
import QuantumBlockEncoding.StatePreparationPrimitiveRoutes
import QuantumBlockEncoding.StatePreparationPaperRoutesCompact
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Algebra.Field.GeomSum
import Mathlib.NumberTheory.Bernoulli
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Analysis.Normed.Operator.LinearIsometry

open QuantumBlockEncoding
open scoped BigOperators

#check HermitePolynomial.sourceInterpolant_degree
#check HermitePolynomial.sourceInterpolant_eval
#check HermitePolynomial.coefficientPolynomial_eval
#check HermitePolynomial.smoothInitial_left
#check HermitePolynomial.smoothInitial_middle
#check HermitePolynomial.smoothInitial_right
#check HermiteStatePreparation.sampledAmplitude_pos
#check HermiteStatePreparation.hermiteStatePreparation_complete
#check RealAmplitudePreparation.splitAngle_firstColumn
#check RealAmplitudePreparation.normSq_marginal
#check RealAmplitudePreparation.prepareCircuit_firstColumn
#check RealAmplitudePreparation.prepareMatrixLE_firstColumn
#check RealAmplitudePreparation.eval_liftCircuit
#check compileUniformlyControlledRy_eval_controlledRyBlockMatrix
#check compileUniformlyControlledRy_ryCount
#check compileUniformlyControlledRy_cxCount
#check evalPrimitiveCircuit_unitary
#check evalPrimitiveCircuit_append
#check evalPrimitiveCircuit_dagger
#check StatePreparationBenchmarks.groverRudolphTree_eval_eq_factorized
#check StatePreparationBenchmarks.ExactPrimitiveStatePreparationRoute
#check Matrix.rank_mul_le_left
#check Matrix.rank_mul_le_right
#check Matrix.rank_le_width
#check Matrix.rank_vecMulVec_le
#check geom_sum_eq
#check geom_sum_Ico
#check sum_range_pow
#check LinearMap.isometryOfOrthonormal
#check ContinuousLinearMap.opNorm_comp_le
#check ContinuousLinearMap.le_opNorm
#check LinearIsometry.norm_map

example (k : Nat) : (HermitePolynomial.sourceInterpolant k).natDegree ≤ 2 * k + 1 :=
  HermitePolynomial.sourceInterpolant_degree k

example {n : Nat} (f : PrimitiveBasis (n+1) → ℝ) :
    RealAmplitudePreparation.normSq (RealAmplitudePreparation.marginal f) =
      RealAmplitudePreparation.normSq f := RealAmplitudePreparation.normSq_marginal f

example (a b : ℝ) (v : Fin 2) :
    standardRyMatrix (RealAmplitudePreparation.splitAngle a b).eval v 0 *
        (RealAmplitudePreparation.pairNorm a b : ℂ) =
      if v = 0 then (a : ℂ) else (b : ℂ) :=
  RealAmplitudePreparation.splitAngle_firstColumn a b v

example (x : ℝ) (hx : x ≠ 1) (n : ℕ) :
    (∑ i ∈ Finset.range n, x ^ i) = (x ^ n - 1) / (x - 1) :=
  geom_sum_eq hx n

example {m d n : ℕ} (A : Matrix (Fin m) (Fin d) ℝ) (B : Matrix (Fin d) (Fin n) ℝ) :
    (A * B).rank ≤ d := (Matrix.rank_mul_le_left A B).trans (Matrix.rank_le_width A)

example {n : Nat} (a b : PrimitiveCircuit n) :
    evalPrimitiveCircuit (a ++ b) = evalPrimitiveCircuit b * evalPrimitiveCircuit a :=
  evalPrimitiveCircuit_append a b
