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
  maxExactIterations := 2
  exactStallIterations := 1
  requiredCost := defaultRequiredCost
  requestedEpsilon := requestedEpsilon
  allowRelaxedEpsilon := true
  maxUpperAgents := 4
  maxMiddleAgents := 5
  maxLowerAgents := 8

/-- First arithmetic-route precision seed for Scenario 2. -/
def arithmeticCubicDefaultPrecision : Nat := 40

/--
Register layout for the first arithmetic-transduction candidate route.

The single signal qubit is the clean block selector.  The pure workspace keeps
an address copy, reversible square/cube work registers, and fixed-point
precision workspace.  This is a candidate interface only; it does not certify
the arithmetic or rotation subroutines.
-/
def arithmeticCubicLayout (n precision : Nat) : RegisterLayout where
  systemQubits := n
  signalQubits := 1
  pureAncillas := 3 * n + precision + 2

/--
Oracle-level transcript for the scalable cubic route.

The clean branch is intended to compute `j / 2^n`, reversibly form the cubic
fixed-point amplitude, apply one amplitude-transduction rotation, and uncompute
the arithmetic workspace.  Each label remains a semantic proof obligation.
-/
def arithmeticCubicCircuit (_n _precision : Nat) : Circuit :=
  [ Gate.oracleCall "cubic-load-j-over-2^n"
  , Gate.oracleCall "cubic-square-fixed-point"
  , Gate.oracleCall "cubic-multiply-by-x"
  , Gate.oracleCall "cubic-amplitude-transduction-Ry"
  , Gate.oracleCall "(cubic-multiply-by-x)^dagger"
  , Gate.oracleCall "(cubic-square-fixed-point)^dagger"
  , Gate.oracleCall "(cubic-load-j-over-2^n)^dagger"
  ]

/-- Local resource count for the unexpanded oracle-level transcript. -/
def arithmeticCubicResource (n precision : Nat) : Resource :=
  (arithmeticCubicCircuit n precision).resource

/-- Normalizer used by the first arithmetic-transduction route. -/
def arithmeticCubicNormalizer (n : Nat) : Rat :=
  conservativeNormalizer n

/-- Candidate score extracted from the arithmetic-route layout and transcript. -/
def arithmeticCubicCost (n precision : Nat) : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    (arithmeticCubicLayout n precision)
    (arithmeticCubicResource n precision)

/-- Resource tuple in QBE candidate-population order. -/
def arithmeticCubicResourceTuple (n precision : Nat) : Nat × Nat × Nat × Nat :=
  ( (arithmeticCubicCost n precision).gateCount
  , (arithmeticCubicCost n precision).depth
  , (arithmeticCubicCost n precision).auxiliaryQubits
  , (arithmeticCubicCost n precision).oracleCalls
  )

/-- The oracle-level transcript has seven unresolved calls and depth seven. -/
theorem arithmeticCubicResource_eq (n precision : Nat) :
    arithmeticCubicResource n precision =
      Resource.ofCountsWithDepth 0 0 7 0 7 := by
  rfl

/-- The first arithmetic route records one signal qubit plus pure workspace. -/
theorem arithmeticCubicLayout_auxiliaryQubits (n precision : Nat) :
    (arithmeticCubicLayout n precision).auxiliaryQubits =
      1 + (3 * n + precision + 2) := by
  rfl

/--
Human-facing construction claim for the first scalable route.  This claim is an
unproved candidate record, not a certified block encoding.
-/
def arithmeticCubicClaim : ConstructionClaim where
  name := "arithmetic-cubic-amplitude-transduction"
  source := "QBE-OP-CUBIC-STATEPREP-001 exploratory candidate CUBIC-CAND-001"
  target := "O_n = |v_n><0^n|, v_n[j] = (j / 2^n)^3"
  normalization := "alpha = conservativeNormalizer n"
  layout := "one signal qubit plus 3*n + precision + 2 pure arithmetic ancillas"
  resource := {
    gates :=
      CostExpr.atom "poly(n, precision)" +
      CostExpr.atom "rotation_synthesis(precision)"
    pureAncilla :=
      (3 : CostExpr) * CostExpr.atom "n" + CostExpr.atom "precision" + 2
  }

/--
Rank-one wrapper layout for the arithmetic cubic route.

The extra pure workspace is reserved for a zero-input filter and row-generation
wrapper.  This is still an oracle-level interface: it repairs the register
shape of the candidate transcript, but it does not certify the wrapper
semantics.
-/
def arithmeticRankOneCubicLayout (n precision : Nat) : RegisterLayout where
  systemQubits := n
  signalQubits := 1
  pureAncillas := (arithmeticCubicLayout n precision).pureAncillas + n + 1

/--
Rank-one candidate transcript around the arithmetic middle block.

The first two calls are the missing wrapper from `CUBIC-CAND-SHAPE-001`: reject
nonzero input columns from the clean branch, then generate the output row
register on the zero-input branch.  The final call is a placeholder cleanup for
the zero-input filter.  The row-generation step is intentionally not uncomputed,
because the output row is the system output of the rank-one operator.
-/
def arithmeticRankOneCubicCircuit (n precision : Nat) : Circuit :=
  [ Gate.oracleCall "rank-one-zero-input-clean-filter"
  , Gate.oracleCall "rank-one-row-generation-on-zero-input"
  ] ++
  arithmeticCubicCircuit n precision ++
  [ Gate.oracleCall "rank-one-zero-input-filter-cleanup" ]

/-- Oracle-level resource count for the rank-one wrapped transcript. -/
def arithmeticRankOneCubicResource (n precision : Nat) : Resource :=
  (arithmeticRankOneCubicCircuit n precision).resource

/-- Normalizer used by the rank-one wrapped arithmetic route. -/
def arithmeticRankOneCubicNormalizer (n : Nat) : Rat :=
  arithmeticCubicNormalizer n

/-- Candidate score for the rank-one wrapped arithmetic route. -/
def arithmeticRankOneCubicCost (n precision : Nat) : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    (arithmeticRankOneCubicLayout n precision)
    (arithmeticRankOneCubicResource n precision)

/-- Resource tuple in QBE candidate-population order for the wrapped route. -/
def arithmeticRankOneCubicResourceTuple (n precision : Nat) :
    Nat × Nat × Nat × Nat :=
  ( (arithmeticRankOneCubicCost n precision).gateCount
  , (arithmeticRankOneCubicCost n precision).depth
  , (arithmeticRankOneCubicCost n precision).auxiliaryQubits
  , (arithmeticRankOneCubicCost n precision).oracleCalls
  )

/-- The rank-one wrapper adds three oracle-level calls to the middle block. -/
theorem arithmeticRankOneCubicResource_eq (n precision : Nat) :
    arithmeticRankOneCubicResource n precision =
      Resource.ofCountsWithDepth 0 0 10 0 10 := by
  rfl

/-- Auxiliary qubits for the wrapped route include the zero-test workspace. -/
theorem arithmeticRankOneCubicLayout_auxiliaryQubits (n precision : Nat) :
    (arithmeticRankOneCubicLayout n precision).auxiliaryQubits =
      1 + ((arithmeticCubicLayout n precision).pureAncillas + n + 1) := by
  rfl

/-- Default small diagnostic score for the wrapped route at `n = 2`, `p = 40`. -/
theorem arithmeticRankOneCubicResourceTuple_n2_default :
    arithmeticRankOneCubicResourceTuple 2 arithmeticCubicDefaultPrecision =
      (10, 10, 52, 10) := by
  native_decide

/--
Human-facing construction claim for the rank-one wrapped scalable route.  This
still records obligations, not a verified block-encoding certificate.
-/
def arithmeticRankOneCubicClaim : ConstructionClaim where
  name := "rank-one-arithmetic-cubic-amplitude-transduction"
  source := "QBE-OP-CUBIC-STATEPREP-001 exploratory candidate CUBIC-CAND-SHAPE-001"
  target := "O_n = |v_n><0^n|, v_n[j] = (j / 2^n)^3"
  normalization := "alpha = conservativeNormalizer n"
  layout := "one signal qubit plus arithmetic workspace, zero-input filter, and row-generation workspace"
  resource := {
    gates :=
      CostExpr.atom "zero_input_filter(n)" +
      CostExpr.atom "row_generation(n, precision)" +
      CostExpr.atom "poly(n, precision)" +
      CostExpr.atom "rotation_synthesis(precision)"
    pureAncilla :=
      (4 : CostExpr) * CostExpr.atom "n" + CostExpr.atom "precision" + 3
  }

/--
Workspace seed for the Hadamard-counting mutation.

This is an oracle-level interface budget for the reversible cube/comparator
workspace.  It is not a gate-level implementation of multiplication.
-/
def hadamardCountingCubicWorkspace (n : Nat) : Nat :=
  4 * n + 3

/--
Register layout for the exact Hadamard-counting candidate.

The signal qubit is the reject flag.  Pure ancillas are the nonzero-input flag,
the `R,T` path registers of total width `4*n`, and the reversible
cube/comparator workspace.
-/
def hadamardCountingCubicLayout (n : Nat) : RegisterLayout where
  systemQubits := n
  signalQubits := 1
  pureAncillas := 1 + 4 * n + hadamardCountingCubicWorkspace n

/--
Oracle-level transcript for the Hadamard-counting route.

The row XOR is not uncomputed, because it writes the output system row for the
rank-one operator.  The Hadamard layers and reversible arithmetic are still
semantic obligations at this interface tier.
-/
def hadamardCountingCubicCircuit (_n : Nat) : Circuit :=
  [ Gate.oracleCall "hcount-zero-input-flag"
  , Gate.oracleCall "hcount-path-H-on-R-T"
  , Gate.oracleCall "hcount-row-xor-R-into-system"
  , Gate.oracleCall "hcount-cubic-threshold-compare"
  , Gate.oracleCall "(hcount-cubic-threshold-compare)^dagger"
  , Gate.oracleCall "hcount-path-H-on-R-T"
  , Gate.oracleCall "(hcount-zero-input-flag)^dagger"
  ]

/-- Oracle-level resource count for the Hadamard-counting route. -/
def hadamardCountingCubicResource (n : Nat) : Resource :=
  (hadamardCountingCubicCircuit n).resource

/-- Normalizer used by the Hadamard-counting route. -/
def hadamardCountingCubicNormalizer (n : Nat) : Rat :=
  conservativeNormalizer n

/-- Candidate score for the Hadamard-counting route. -/
def hadamardCountingCubicCost (n : Nat) : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    (hadamardCountingCubicLayout n)
    (hadamardCountingCubicResource n)

/-- Resource tuple in QBE candidate-population order. -/
def hadamardCountingCubicResourceTuple (n : Nat) : Nat × Nat × Nat × Nat :=
  ( (hadamardCountingCubicCost n).gateCount
  , (hadamardCountingCubicCost n).depth
  , (hadamardCountingCubicCost n).auxiliaryQubits
  , (hadamardCountingCubicCost n).oracleCalls
  )

/-- The Hadamard-counting interface has seven unresolved oracle-level calls. -/
theorem hadamardCountingCubicResource_eq (n : Nat) :
    hadamardCountingCubicResource n =
      Resource.ofCountsWithDepth 0 0 7 0 7 := by
  rfl

/-- Auxiliary qubits for the counting route include reject, `nz`, path, and workspace registers. -/
theorem hadamardCountingCubicLayout_auxiliaryQubits (n : Nat) :
    (hadamardCountingCubicLayout n).auxiliaryQubits =
      1 + (1 + 4 * n + hadamardCountingCubicWorkspace n) := by
  rfl

/-- Default small diagnostic score for the counting route at `n = 2`. -/
theorem hadamardCountingCubicResourceTuple_n2 :
    hadamardCountingCubicResourceTuple 2 = (7, 7, 21, 7) := by
  native_decide

/--
Human-facing construction claim for the Hadamard-counting exact route.  This is
an unproved candidate record, not a certified block encoding.
-/
def hadamardCountingCubicClaim : ConstructionClaim where
  name := "hadamard-counting-cubic-rank-one"
  source := "QBE-OP-CUBIC-STATEPREP-001 exploratory candidate CUBIC-HCOUNT-IFACE-001"
  target := "O_n = |v_n><0^n|, v_n[j] = (j / 2^n)^3"
  normalization := "alpha = conservativeNormalizer n"
  layout := "one reject signal qubit plus nz flag, 4*n path qubits, and reversible cube/comparator workspace"
  resource := {
    gates :=
      CostExpr.atom "path_hadamards(4*n)" +
      CostExpr.atom "zero_input_test(n)" +
      CostExpr.atom "row_xor(n)" +
      CostExpr.atom "cube_compare(n)"
    pureAncilla :=
      (8 : CostExpr) * CostExpr.atom "n" + 4
  }

/--
Hard Mode panel escalation schedule.  The three entries are the planned
parallel-agent counts for levels 0, 1, and 2.  Upper agents should only move to
the next level after the active proof leaf has stalled and the reviewer has
confirmed that the blocker is not just stale memory.
-/
def hardModeUpperAgentSchedule : List Nat := [1, 3, 4]

def hardModeMiddleAgentSchedule : List Nat := [1, 2, 3]

def hardModeLowerAgentSchedule : List Nat := [3, 5, 8]

/-- Number of consecutive cycles without a closed leaf before the first escalation. -/
def hardModeExactStallWindow : Nat := 1

/--
Number of consecutive cycles without an improving certified or finite
candidate before the next Hard Mode level is considered.
-/
def hardModeConstructionStallWindow : Nat := 1

/-- Per-level cycle budgets before the upper panel must explicitly review progress. -/
def hardModeLevelCycleBudget : List Nat := [1, 1, 1]

/--
Scenario 2 epsilon ladder.  The first entry is the user-requested tolerance.
Later entries are relaxed exploratory waypoints used only if the exact or
requested-epsilon search stalls; a relaxed waypoint is not a substitute for a
certificate at `requestedEpsilon`.
-/
def relaxedEpsilonLadder : List Rat :=
  [requestedEpsilon, (1 : Rat) / 100000000, (1 : Rat) / 1000000]

theorem relaxedEpsilonLadder_startsWithRequested :
    relaxedEpsilonLadder.head? = some requestedEpsilon := by
  rfl

theorem hardModeSchedules_have_three_levels :
    hardModeUpperAgentSchedule.length = 3 ∧
    hardModeMiddleAgentSchedule.length = 3 ∧
    hardModeLowerAgentSchedule.length = 3 ∧
    hardModeLevelCycleBudget.length = 3 := by
  native_decide

theorem hardModeLowerAgentSchedule_final :
    hardModeLowerAgentSchedule.getLast? = some 8 := by
  native_decide

/--
Current expected phase.  This is a planning declaration, not a proof of
impossibility: it records that exact finite gate synthesis should not consume
the full budget before approximate arithmetic/state-preparation search starts.
-/
def initialExpectedPhase : BlockEncodingSearchPhase :=
  BlockEncodingSearchPhase.relaxedApproxSearch

theorem gridSize_pos (n : Nat) : 0 < gridSize n := by
  simpa [gridSize] using (Nat.pow_pos (by decide : 0 < 2) : 0 < 2 ^ n)

theorem cubicOperator_first_column (n : Nat) (row : Fin (gridSize n)) :
    cubicOperator n row ⟨0, gridSize_pos n⟩ = cubicAmplitude n row := by
  simp [cubicOperator]

theorem cubicOperator_only_first_column (n : Nat)
    (row col : Fin (gridSize n)) (h : col.val ≠ 0) :
    cubicOperator n row col = 0 := by
  simp [cubicOperator, h]

/--
Entrywise clean-block contract for a rank-one cubic candidate.

The first field states the scaled clean first column.  The second field states
that all other input columns vanish in the clean block.  This is a semantic
obligation for a future unitary/circuit proof, not a proof that the current
oracle labels already realize the contract.
-/
def rankOneCleanBlockContract (n : Nat) (alpha : Rat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop :=
  (∀ row : Fin (gridSize n),
      alpha * block row ⟨0, gridSize_pos n⟩ = cubicAmplitude n row) ∧
  (∀ row col : Fin (gridSize n), col.val ≠ 0 → block row col = 0)

/-- Candidate-specific clean-block contract for the repaired rank-one route. -/
def arithmeticRankOneCubicCleanBlockContract (n : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop :=
  rankOneCleanBlockContract n (arithmeticRankOneCubicNormalizer n) block

/--
The rank-one clean-block contract is exactly the target matrix, entry by entry,
after multiplying by its normalizer.
-/
theorem rankOneCleanBlockContract_pointwise_eq {n : Nat} {alpha : Rat}
    {block : Matrix (gridSize n) (gridSize n) Rat}
    (h : rankOneCleanBlockContract n alpha block) :
    Matrix.PointwiseEq
      (fun row col => alpha * block row col)
      (cubicOperator n) := by
  intro row col
  by_cases hcol : col.val = 0
  · have hcolZero : col = ⟨0, gridSize_pos n⟩ := by
      apply Fin.ext
      exact hcol
    subst col
    simpa [cubicOperator] using h.1 row
  · have hzero := h.2 row col hcol
    simp [cubicOperator, hcol, hzero]

/--
Candidate-specific bridge from the repaired wrapper's clean-block contract to
the fixed cubic target.
-/
theorem arithmeticRankOneCubicCleanBlockContract_pointwise_eq {n : Nat}
    {block : Matrix (gridSize n) (gridSize n) Rat}
    (h : arithmeticRankOneCubicCleanBlockContract n block) :
    Matrix.PointwiseEq
      (fun row col => arithmeticRankOneCubicNormalizer n * block row col)
      (cubicOperator n) :=
  rankOneCleanBlockContract_pointwise_eq h

/-- Candidate-specific clean-block contract for the Hadamard-counting route. -/
def hadamardCountingCubicCleanBlockContract (n : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop :=
  rankOneCleanBlockContract n (hadamardCountingCubicNormalizer n) block

/--
Candidate-specific bridge from the Hadamard-counting clean-block contract to
the fixed cubic target.
-/
theorem hadamardCountingCubicCleanBlockContract_pointwise_eq {n : Nat}
    {block : Matrix (gridSize n) (gridSize n) Rat}
    (h : hadamardCountingCubicCleanBlockContract n block) :
    Matrix.PointwiseEq
      (fun row col => hadamardCountingCubicNormalizer n * block row col)
      (cubicOperator n) :=
  rankOneCleanBlockContract_pointwise_eq h

theorem rat_cube_sq_eq_sixth (x : Rat) : (x ^ 3) ^ 2 = x ^ 6 := by
  apply Rat.ext
  · change (x.num ^ 3) ^ 2 = x.num ^ 6
    rw [← Int.pow_mul]
  · change (x.den ^ 3) ^ 2 = x.den ^ 6
    rw [← Nat.pow_mul]

theorem cubicAmplitude_sq_eq_gridPoint_sixth (n : Nat)
    (j : Fin (gridSize n)) :
    cubicAmplitude n j ^ 2 = gridPoint n j ^ 6 := by
  simpa [cubicAmplitude] using rat_cube_sq_eq_sixth (gridPoint n j)

theorem cubicNormSq_sixthPowerFold (n : Nat) :
    cubicNormSq n =
      (List.finRange (gridSize n)).foldl
        (fun acc j => acc + gridPoint n j ^ 6) 0 := by
  simp [cubicNormSq, cubicAmplitude_sq_eq_gridPoint_sixth]

/-- The rational grid dimension is nonzero, for denominator side conditions. -/
theorem gridSize_rat_ne_zero (n : Nat) : (gridSize n : Rat) ≠ 0 := by
  intro h
  exact Nat.ne_of_gt (gridSize_pos n) (Rat.natCast_eq_zero_iff.mp h)

/-- The rational grid dimension is positive. -/
theorem gridSize_rat_pos (n : Nat) : (0 : Rat) < (gridSize n : Rat) := by
  rw [Rat.natCast_pos]
  exact gridSize_pos n

theorem gridPoint_nonneg (n : Nat) (j : Fin (gridSize n)) :
    (0 : Rat) ≤ gridPoint n j := by
  unfold gridPoint
  rw [← Rat.not_lt]
  intro h
  rw [Rat.div_lt_iff (gridSize_rat_pos n)] at h
  rw [Rat.zero_mul] at h
  exact (Rat.not_lt.mpr Rat.natCast_nonneg) h

theorem gridPoint_lt_one (n : Nat) (j : Fin (gridSize n)) :
    gridPoint n j < 1 := by
  unfold gridPoint
  rw [Rat.div_lt_iff (gridSize_rat_pos n)]
  rw [Rat.one_mul]
  exact (Rat.natCast_lt_natCast).mpr j.isLt

theorem gridPoint_le_one (n : Nat) (j : Fin (gridSize n)) :
    gridPoint n j ≤ 1 := by
  exact Rat.le_of_lt (gridPoint_lt_one n j)

theorem rat_pow_le_one_of_nonneg_le_one (x : Rat) (k : Nat)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    x ^ k ≤ 1 := by
  induction k with
  | zero =>
      simp
  | succ k ih =>
      rw [Rat.pow_succ]
      have hmul : x ^ k * x ≤ 1 * x :=
        Rat.mul_le_mul_of_nonneg_right ih hx0
      have hx : 1 * x ≤ 1 := by
        simpa [Rat.one_mul] using hx1
      exact Rat.le_trans hmul hx

theorem cubicAmplitude_sq_le_one (n : Nat) (j : Fin (gridSize n)) :
    cubicAmplitude n j ^ 2 ≤ 1 := by
  rw [cubicAmplitude_sq_eq_gridPoint_sixth]
  exact rat_pow_le_one_of_nonneg_le_one (gridPoint n j) 6
    (gridPoint_nonneg n j) (gridPoint_le_one n j)

theorem foldl_add_le_add_length {α : Type u} (xs : List α) (f : α → Rat)
    (h : ∀ x, x ∈ xs → f x ≤ 1) (acc : Rat) :
    xs.foldl (fun acc x => acc + f x) acc ≤ acc + (xs.length : Rat) := by
  induction xs generalizing acc with
  | nil =>
      simp [Rat.add_zero]
  | cons x xs ih =>
      simp [List.foldl]
      have hx : f x ≤ 1 := h x (by simp)
      have hxs : ∀ y, y ∈ xs → f y ≤ 1 := by
        intro y hy
        exact h y (by simp [hy])
      have hih := ih hxs (acc + f x)
      have hacc : acc + f x ≤ acc + 1 :=
        (Rat.add_le_add_left).mpr hx
      have hstep :
          (acc + f x) + (xs.length : Rat) ≤
            (acc + 1) + (xs.length : Rat) :=
        (Rat.add_le_add_right).mpr hacc
      have htarget :
          (acc + 1) + (xs.length : Rat) =
            acc + ((xs.length + 1 : Nat) : Rat) := by
        simp [Rat.add_comm, Rat.add_left_comm]
      exact Rat.le_trans hih
        (by simpa [htarget, Nat.succ_eq_add_one] using hstep)

theorem cubicNormSq_le_gridSize (n : Nat) :
    cubicNormSq n ≤ (gridSize n : Rat) := by
  unfold cubicNormSq
  have hfold := foldl_add_le_add_length
    (List.finRange (gridSize n))
    (fun j : Fin (gridSize n) => cubicAmplitude n j ^ 2)
    (by
      intro j _
      exact cubicAmplitude_sq_le_one n j)
    (0 : Rat)
  simpa [List.length_finRange, Rat.zero_add] using hfold

theorem gridSize_rat_le_sq (n : Nat) :
    (gridSize n : Rat) ≤ (gridSize n : Rat) ^ 2 := by
  have hOneLe : (1 : Rat) ≤ (gridSize n : Rat) := by
    exact (Rat.natCast_le_natCast).mpr (Nat.succ_le_of_lt (gridSize_pos n))
  have hNonneg : (0 : Rat) ≤ (gridSize n : Rat) :=
    Rat.le_of_lt (gridSize_rat_pos n)
  have hmul :
      (1 : Rat) * (gridSize n : Rat) ≤
        (gridSize n : Rat) * (gridSize n : Rat) :=
    Rat.mul_le_mul_of_nonneg_right hOneLe hNonneg
  simpa [Rat.one_mul, Rat.pow_succ] using hmul

theorem cubicNormSq_le_conservativeNormalizer_sq (n : Nat) :
    cubicNormSq n ≤ conservativeNormalizer n ^ 2 := by
  exact Rat.le_trans (cubicNormSq_le_gridSize n) (by
    simpa [conservativeNormalizer] using gridSize_rat_le_sq n)

/--
Candidate-specific normalizer bridge for the first arithmetic route.  This does
not certify the candidate unitary; it only records that the route's current
choice `alpha = arithmeticCubicNormalizer n` inherits the compiled conservative
norm bound.
-/
theorem cubicNormSq_le_arithmeticCubicNormalizer_sq (n : Nat) :
    cubicNormSq n ≤ arithmeticCubicNormalizer n ^ 2 := by
  simpa [arithmeticCubicNormalizer] using
    cubicNormSq_le_conservativeNormalizer_sq n

/--
Candidate-specific normalizer bridge for the Hadamard-counting route.  This
does not certify the Hadamard-sandwich semantics; it only records that the
route's normalizer inherits the compiled conservative norm bound.
-/
theorem cubicNormSq_le_hadamardCountingCubicNormalizer_sq (n : Nat) :
    cubicNormSq n ≤ hadamardCountingCubicNormalizer n ^ 2 := by
  simpa [hadamardCountingCubicNormalizer] using
    cubicNormSq_le_conservativeNormalizer_sq n

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
