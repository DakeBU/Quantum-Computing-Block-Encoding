import QuantumBlockEncoding.BlockEncoding

/-!
# Cubic grid state-preparation operator benchmark

This module records task `QBE-OP-CUBIC-STATEPREP-001`.

The user-facing statement

`O |0^n> = sum_j (j / 2^n)^3 |j>`

does not define a unitary state-preparation map, because the right hand side is
not normalized in general.  ABEIS therefore fixes the operator target as the
rank-one map `O_n = |v_n><0^n|`, where `v_n[j] = (j / 2^n)^3`.  A block
encoding may use any explicit normalizer.  Exact finite gate synthesis is not
expected to be the useful route for this target; the task is configured to
enter approximate search with tolerance `1e-10` when exact search stalls.
-/

namespace QuantumBlockEncoding
namespace CubicStatePreparation

/-- Task identifier used by the retrieval and verifier ledgers. -/
def taskId : String := "QBE-OP-CUBIC-STATEPREP-001"

/-- User-requested error tolerance `1e-10`. -/
def requestedEpsilon : Rat := (1 : Rat) / 10000000000

/-- Grid point `x_j = j / 2^n`. -/
def gridPoint (n : Nat) (j : Fin (gridSize n)) : Rat :=
  (j.val : Rat) / (gridSize n : Rat)

/-- Cubic amplitude `f(x_j) = x_j^3`. -/
def cubicAmplitude (n : Nat) (j : Fin (gridSize n)) : Rat :=
  (gridPoint n j) ^ 3

/--
The rank-one operator `O_n = |v_n><0^n|`.  In column-vector convention this
maps the input basis state `|0^n>` to the unnormalized vector with entries
`(j / 2^n)^3`, and maps every other input basis state to zero.
-/
def cubicOperator (n : Nat) : Matrix (gridSize n) (gridSize n) Rat :=
  fun row col => if col.val = 0 then cubicAmplitude n row else 0

/--
Exact rational squared norm of the unnormalized target vector.  The analytic
normalizer is its square root; this rational quantity is the cheap diagnostic
used before any approximate rotation-synthesis route is accepted.
-/
def cubicNormSq (n : Nat) : Rat :=
  (List.finRange (gridSize n)).foldl
    (fun acc j => acc + cubicAmplitude n j ^ 2) 0

/--
A conservative rational normalizer.  It is not intended to be optimal; it is a
stable placeholder until the approximate synthesis backend proves a sharper
normalizer and error bound.
-/
def conservativeNormalizer (n : Nat) : Rat :=
  (gridSize n : Rat)

/-- Operator-first target record used by the ABEIS harness. -/
def cubicTarget (n : Nat) : QueryOperatorTarget Rat (gridSize n) (gridSize n) where
  operator := cubicOperator n
  normalizer := conservativeNormalizer n
  source := "QBE-OP-CUBIC-STATEPREP-001: O_n = |v_n><0^n|, v_j=(j/2^n)^3"
  semanticContract :=
    "rank-one unnormalized cubic grid state-preparation operator; approximate BE target epsilon=1e-10"
  freeParameters := [
    "n positive",
    "epsilon = 1e-10",
    "exact search first, then Scenario 2 approximate arithmetic synthesis"
  ]

/-- Resource floor used for the first Scenario 2 run. -/
def defaultRequiredCost : BlockEncodingCost where
  auxiliaryQubits := 4
  gateCount := 0
  depth := 0
  oracleCalls := 0

/--
Adaptive search policy for the cubic benchmark.  The zero gate/depth fields in
`defaultRequiredCost` deliberately mean "discover a concrete candidate and then
rank it"; the active search is expected to relax from exact to approximate
construction after a small exact-search stall window.
-/
def defaultPolicy : AdaptiveBlockEncodingPolicy Rat where
  maxExactIterations := 6
  exactStallIterations := 2
  requiredCost := defaultRequiredCost
  requestedEpsilon := requestedEpsilon
  allowRelaxedEpsilon := true
  maxUpperAgents := 4
  maxMiddleAgents := 5
  maxLowerAgents := 8

/--
Current expected phase.  This is a planning declaration, not a proof of
impossibility: it records that exact finite gate synthesis should not consume
the full budget before approximate arithmetic/state-preparation search starts.
-/
def initialExpectedPhase : BlockEncodingSearchPhase :=
  BlockEncodingSearchPhase.relaxedApproxSearch

theorem cubicOperator_only_first_column (n : Nat)
    (row col : Fin (gridSize n)) (h : col.val ≠ 0) :
    cubicOperator n row col = 0 := by
  simp [cubicOperator, h]

theorem cubicNormSq_n1 :
    cubicNormSq 1 = (1 : Rat) / 64 := by
  native_decide

theorem cubicNormSq_n2 :
    cubicNormSq 2 = (397 : Rat) / 2048 := by
  native_decide

theorem cubicNormSq_n3 :
    cubicNormSq 3 = (46205 : Rat) / 65536 := by
  native_decide

end CubicStatePreparation
end QuantumBlockEncoding
