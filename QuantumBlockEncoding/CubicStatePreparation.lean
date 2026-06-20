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
cube/comparator workspace.  Nonzero input columns set the reject signal before
the `nz` cleanup, so the clean projection cannot leak identity entries.
-/
def hadamardCountingCubicLayout (n : Nat) : RegisterLayout where
  systemQubits := n
  signalQubits := 1
  pureAncillas := 1 + 4 * n + hadamardCountingCubicWorkspace n

/--
Oracle-level transcript for the Hadamard-counting route.

The row XOR is not uncomputed, because it writes the output system row for the
rank-one operator.  The separate nonzero-column reject signal is applied before
the `nz` cleanup, so nonzero input columns keep a clean-projection rejection
witness.  The Hadamard layers and reversible arithmetic are still semantic
obligations at this interface tier.
-/
def hadamardCountingCubicCircuit (_n : Nat) : Circuit :=
  [ Gate.oracleCall "hcount-zero-input-flag"
  , Gate.oracleCall "hcount-nonzero-column-reject"
  , Gate.oracleCall "hcount-path-H-on-R-T"
  , Gate.oracleCall "hcount-row-xor-R-into-system"
  , Gate.oracleCall "hcount-cubic-threshold-compare"
  , Gate.oracleCall "(hcount-cubic-threshold-compare)^dagger"
  , Gate.oracleCall "hcount-path-H-on-R-T"
  , Gate.oracleCall "(hcount-zero-input-flag)^dagger"
  ]

/--
The repaired transcript records a separate nonzero-column reject signal before
the final `nz` cleanup.  This is the compiled surface for
`CUBIC-HCOUNT-REJECT-REPAIR-001`; semantic clean-block correctness remains a
future proof leaf.
-/
theorem hadamardCountingCubicCircuit_rejectSignalRepair (n : Nat) :
    hadamardCountingCubicCircuit n =
      [ Gate.oracleCall "hcount-zero-input-flag"
      , Gate.oracleCall "hcount-nonzero-column-reject"
      , Gate.oracleCall "hcount-path-H-on-R-T"
      , Gate.oracleCall "hcount-row-xor-R-into-system"
      , Gate.oracleCall "hcount-cubic-threshold-compare"
      , Gate.oracleCall "(hcount-cubic-threshold-compare)^dagger"
      , Gate.oracleCall "hcount-path-H-on-R-T"
      , Gate.oracleCall "(hcount-zero-input-flag)^dagger"
      ] := by
  rfl

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

/-- The Hadamard-counting interface has eight unresolved oracle-level calls. -/
theorem hadamardCountingCubicResource_eq (n : Nat) :
    hadamardCountingCubicResource n =
      Resource.ofCountsWithDepth 0 0 8 0 8 := by
  rfl

/-- Auxiliary qubits for the counting route include reject, `nz`, path, and workspace registers. -/
theorem hadamardCountingCubicLayout_auxiliaryQubits (n : Nat) :
    (hadamardCountingCubicLayout n).auxiliaryQubits =
      1 + (1 + 4 * n + hadamardCountingCubicWorkspace n) := by
  rfl

/-- Default small diagnostic score for the counting route at `n = 2`. -/
theorem hadamardCountingCubicResourceTuple_n2 :
    hadamardCountingCubicResourceTuple 2 = (8, 8, 21, 8) := by
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
      CostExpr.atom "nonzero_column_reject(n)" +
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

/-- Core rational normalization for the Hadamard-counting path ratio. -/
theorem rat_div_cube_div_eq (a b : Rat) :
    (a / b) ^ 3 / b = a ^ 3 / b ^ 4 := by
  simp [Rat.div_def, Rat.pow_succ, Rat.inv_mul_rev, Rat.mul_assoc]
  grind [Rat.mul_comm, Rat.mul_assoc]

/--
Arithmetic bridge for the Hadamard-counting path formula.

After scaling by `alpha = conservativeNormalizer n = gridSize n`, the candidate
clean-block entry `j^3 / gridSize^4` recovers the cubic target amplitude.
-/
theorem cubicAmplitude_div_conservativeNormalizer_eq (n : Nat)
    (j : Fin (gridSize n)) :
    cubicAmplitude n j / conservativeNormalizer n =
      (j.val : Rat) ^ 3 / (gridSize n : Rat) ^ 4 := by
  simpa [cubicAmplitude, gridPoint, conservativeNormalizer] using
    rat_div_cube_div_eq (j.val : Rat) (gridSize n : Rat)

/-- Path-register capacity identity for the Hadamard-counting route. -/
theorem gridSize_three_mul_eq_cube (n : Nat) :
    gridSize (3 * n) = gridSize n ^ 3 := by
  rw [Nat.mul_comm 3 n]
  simp [gridSize, Nat.pow_mul]

/-- Four-register path-space identity for the Hadamard-counting denominator. -/
theorem gridSize_four_mul_eq_fourth (n : Nat) :
    gridSize (4 * n) = gridSize n ^ 4 := by
  rw [Nat.mul_comm 4 n]
  simp [gridSize, Nat.pow_mul]

/--
Reusable threshold count over `List.finRange`.

If the threshold `k` fits in an `m`-element register, exactly `k` entries of
`List.finRange m` have value strictly below `k`.
-/
theorem hadamardCountingCubic_thresholdCountP_finRange
    (m k : Nat) (hk : k ≤ m) :
    List.countP (fun t : Fin m => t.val < k) (List.finRange m) = k := by
  induction m generalizing k with
  | zero =>
      have hk0 : k = 0 := Nat.eq_zero_of_le_zero hk
      subst k
      rfl
  | succ m ih =>
      cases k with
      | zero =>
          simp
      | succ k =>
          have hk' : k ≤ m := Nat.le_of_succ_le_succ hk
          rw [List.finRange_succ, List.countP_cons, List.countP_map]
          have hcomp :
              List.countP
                ((fun t : Fin (m + 1) =>
                    decide (t.val < Nat.succ k)) ∘ Fin.succ)
                (List.finRange m) =
              List.countP
                (fun t : Fin m => decide (t.val < k))
                (List.finRange m) := by
            congr 1
            funext t
            simp [Function.comp, Fin.succ]
          rw [hcomp, ih k hk']
          simp

theorem hadamardCountingCubic_thresholdFilterLength
    (m k : Nat) (hk : k ≤ m) :
    ((List.finRange m).filter (fun t => t.val < k)).length = k := by
  rw [← List.countP_eq_length_filter]
  exact hadamardCountingCubic_thresholdCountP_finRange m k hk

/-- The cubic threshold for row `j` fits in the `3*n`-qubit path register. -/
theorem hadamardCountingCubic_threshold_le_pathCapacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 <= gridSize (3 * n) := by
  have hle : j.val ^ 3 ≤ gridSize n ^ 3 :=
    Nat.pow_le_pow_left (Nat.le_of_lt j.isLt) 3
  simpa [gridSize_three_mul_eq_cube] using hle

/--
Symbolic accepted-path count for the Hadamard-counting threshold register.

For fixed output row `j`, the `3*n`-qubit threshold register contributes
exactly `j.val ^ 3` accepted values.
-/
theorem hadamardCountingCubic_thresholdPathCount
    (n : Nat) (j : Fin (gridSize n)) :
    ((List.finRange (gridSize (3 * n))).filter
        (fun t => t.val < j.val ^ 3)).length = j.val ^ 3 := by
  exact hadamardCountingCubic_thresholdFilterLength
    (gridSize (3 * n)) (j.val ^ 3)
    (hadamardCountingCubic_threshold_le_pathCapacity n j)

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

namespace CubicDiagonalOracle

/-- Task identifier used by the retrieval and verifier ledgers. -/
def taskId : String := "QBE-OP-CUBIC-DIAGONAL-001"

/-- The diagonal cubic oracle target `D_n[row,col] = (row/2^n)^3` if `row=col`, else zero. -/
def cubicDiagonalOperator (n : Nat) :
    Matrix (gridSize n) (gridSize n) Rat :=
  fun row col =>
    if row = col then CubicStatePreparation.cubicAmplitude n row else 0

/-- Exact normalizer for the diagonal target at the primitive amplitude-oracle tier. -/
def exactNormalizer (_n : Nat) : Rat := 1

/-- Operator-first target record for the diagonal cubic oracle. -/
def cubicDiagonalTarget (n : Nat) :
    QueryOperatorTarget Rat (gridSize n) (gridSize n) where
  operator := cubicDiagonalOperator n
  normalizer := exactNormalizer n
  source :=
    "QBE-OP-CUBIC-DIAGONAL-001: D_n=sum_j (j/2^n)^3 |j><j|"
  semanticContract :=
    "diagonal cubic oracle; exact primitive amplitude-oracle route first"
  freeParameters := [
    "n positive",
    "diagonal target, not rank-one state preparation",
    "score order inside one tier: gateCount, depth, auxiliaryQubits, oracleCalls"
  ]

/-- One signal qubit and no pure workspace at the oracle-label tier. -/
def amplitudeOracleLayout (n : Nat) : RegisterLayout where
  systemQubits := n
  signalQubits := 1
  pureAncillas := 0

/-- Oracle-level exact diagonal amplitude transcript. -/
def amplitudeOracleCircuit (_n : Nat) : Circuit :=
  [Gate.oracleCall "diag-cubic-amplitude-oracle"]

/-- Resource of the oracle-label diagonal candidate. -/
def amplitudeOracleResource (n : Nat) : Resource :=
  (amplitudeOracleCircuit n).resource

/-- Candidate score for the oracle-label diagonal candidate. -/
def amplitudeOracleCost (n : Nat) : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    (amplitudeOracleLayout n) (amplitudeOracleResource n)

/-- Tuple in the QBE score order `(gateCount, depth, auxiliaryQubits, oracleCalls)`. -/
def amplitudeOracleResourceTuple (n : Nat) : Nat × Nat × Nat × Nat :=
  ( (amplitudeOracleCost n).gateCount
  , (amplitudeOracleCost n).depth
  , (amplitudeOracleCost n).auxiliaryQubits
  , (amplitudeOracleCost n).oracleCalls
  )

theorem amplitudeOracleResource_eq (n : Nat) :
    amplitudeOracleResource n = Resource.ofCountsWithDepth 0 0 1 0 1 := by
  rfl

theorem amplitudeOracleResourceTuple_eq (n : Nat) :
    amplitudeOracleResourceTuple n = (1, 1, 1, 1) := by
  simp [amplitudeOracleResourceTuple, amplitudeOracleCost, amplitudeOracleLayout,
    amplitudeOracleResource, amplitudeOracleCircuit, BlockEncodingCost.fromLayoutAndResource,
    RegisterLayout.auxiliaryQubits, Circuit.resource, Gate.resource, Resource.gates, Resource.ofCountsWithDepth]

/-- Clean-block contract for the diagonal cubic candidate. -/
def diagonalCleanBlockContract (n : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop :=
  ∀ row col,
    block row col =
      if row = col then CubicStatePreparation.cubicAmplitude n row else 0

theorem diagonalCleanBlockContract_pointwise_eq
    (n : Nat) (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : diagonalCleanBlockContract n block) :
    Matrix.PointwiseEq block (cubicDiagonalOperator n) := by
  intro row col
  simpa [cubicDiagonalOperator] using h row col

theorem primitiveOracleCleanBlock_eq_target
    (n : Nat) (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : diagonalCleanBlockContract n block) :
    Matrix.PointwiseEq block (cubicDiagonalTarget n).operator := by
  simpa [cubicDiagonalTarget] using
    (diagonalCleanBlockContract_pointwise_eq n block h)

/-- Amplitude range needed by the one-signal diagonal construction. -/
theorem cubicAmplitude_le_one (n : Nat) (j : Fin (gridSize n)) :
    CubicStatePreparation.cubicAmplitude n j ≤ 1 := by
  exact CubicStatePreparation.rat_pow_le_one_of_nonneg_le_one
    (CubicStatePreparation.gridPoint n j) 3
    (CubicStatePreparation.gridPoint_nonneg n j)
    (CubicStatePreparation.gridPoint_le_one n j)

theorem cubicAmplitude_nonneg (n : Nat) (j : Fin (gridSize n)) :
    0 ≤ CubicStatePreparation.cubicAmplitude n j := by
  simpa [CubicStatePreparation.cubicAmplitude] using
    (Rat.pow_nonneg (CubicStatePreparation.gridPoint_nonneg n j) :
      0 ≤ CubicStatePreparation.gridPoint n j ^ 3)

/-- Full matrix dimension of the unexpanded one-signal primitive oracle. -/
def primitiveAmplitudeOracleDimension (n : Nat) : Nat :=
  gridSize (n + (amplitudeOracleLayout n).auxiliaryQubits)

/--
External primitive matrix supplied by the oracle-label tier.

This is only a named object for the semantic contract below.  The current file
does not prove that this opaque matrix is a gate-expanded unitary.
-/
opaque primitiveAmplitudeOracleUnitary (n : Nat) :
    Matrix (primitiveAmplitudeOracleDimension n)
      (primitiveAmplitudeOracleDimension n) Rat

/-- Explicit unitarity obligation for the primitive oracle-label matrix. -/
opaque primitiveAmplitudeOracleIsUnitary (n : Nat)
    (unitary : Matrix (primitiveAmplitudeOracleDimension n)
      (primitiveAmplitudeOracleDimension n) Rat) : Prop

/-- Explicit clean-block extraction obligation for the primitive oracle-label matrix. -/
opaque primitiveAmplitudeOracleCleanBlockExtracts (n : Nat)
    (unitary : Matrix (primitiveAmplitudeOracleDimension n)
      (primitiveAmplitudeOracleDimension n) Rat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop

/--
Primitive one-signal amplitude-oracle semantic contract.

This contract keeps the unexpanded primitive tier honest: it requires both a
unitarity obligation for the named oracle matrix and a clean-block extraction
obligation whose extracted block satisfies the diagonal target contract.
-/
def primitiveAmplitudeOracleSemanticContract (n : Nat) : Prop :=
  primitiveAmplitudeOracleIsUnitary n (primitiveAmplitudeOracleUnitary n) ∧
    ∃ block : Matrix (gridSize n) (gridSize n) Rat,
      primitiveAmplitudeOracleCleanBlockExtracts n
        (primitiveAmplitudeOracleUnitary n) block ∧
        diagonalCleanBlockContract n block

theorem primitiveAmplitudeOracleSemanticContract_unitary
    (n : Nat) (h : primitiveAmplitudeOracleSemanticContract n) :
    primitiveAmplitudeOracleIsUnitary n (primitiveAmplitudeOracleUnitary n) :=
  h.1

theorem primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target
    (n : Nat) (h : primitiveAmplitudeOracleSemanticContract n) :
    ∃ block : Matrix (gridSize n) (gridSize n) Rat,
      primitiveAmplitudeOracleCleanBlockExtracts n
        (primitiveAmplitudeOracleUnitary n) block ∧
        Matrix.PointwiseEq block (cubicDiagonalTarget n).operator := by
  rcases h with ⟨_hUnitary, block, hExtract, hClean⟩
  exact ⟨block, hExtract, primitiveOracleCleanBlock_eq_target n block hClean⟩

/--
Expanded arithmetic route layout.

The workspace count is explicit because the reversible arithmetic, angle
synthesis, and uncomputation proof are not yet fixed to one resource backend.
-/
def expandedAmplitudeOracleLayout (n workspaceQubits : Nat) : RegisterLayout where
  systemQubits := n
  signalQubits := 1
  pureAncillas := workspaceQubits

theorem expandedAmplitudeOracleLayout_auxiliaryQubits
    (n workspaceQubits : Nat) :
    (expandedAmplitudeOracleLayout n workspaceQubits).auxiliaryQubits =
      1 + workspaceQubits := by
  rfl

/-- The expanded route targets the same exact normalizer `alpha = 1`. -/
theorem expandedAmplitudeOracleNormalizer_eq (n _workspaceQubits : Nat) :
    exactNormalizer n = 1 := by
  rfl

/--
Scalar-tier contract for the standard `R_y` clean-entry identity.

The project-local matrix layer is still exact `Rat`, so `arccos` and `cos`
are represented here by backend-supplied scalar functions.  The contract keeps
the standard convention explicit: for every rational amplitude `a` in `[0, 1]`,
the clean signal entry of `R_y (2 * arccos a)` is exactly `a` after embedding
into the backend scalar tier.
-/
structure StandardRyCleanEntryScalarTier where
  Scalar : Type
  ratAmplitude : Rat -> Scalar
  thetaForAmplitude : Scalar -> Scalar
  cleanEntry : Scalar -> Scalar
  cleanEntry_of_range :
    ∀ a : Rat, 0 ≤ a -> a ≤ 1 ->
      cleanEntry (thetaForAmplitude (ratAmplitude a)) = ratAmplitude a
  thetaFormula : String := "theta = 2 * arccos(amplitude)"
  cleanEntryFormula : String := "cos(theta / 2)"

/--
Indexwise clean-entry obligation for the cubic diagonal amplitudes in a chosen
standard-`R_y` scalar tier.
-/
def expandedRyCleanEntryForCubicAmplitudes
    (tier : StandardRyCleanEntryScalarTier) (n : Nat) : Prop :=
  ∀ j : Fin (gridSize n),
    tier.cleanEntry
        (tier.thetaForAmplitude
          (tier.ratAmplitude (CubicStatePreparation.cubicAmplitude n j))) =
      tier.ratAmplitude (CubicStatePreparation.cubicAmplitude n j)

/--
`DIAG-EXP-RY-001`: the standard scalar-tier `R_y` clean-entry contract applies
to every cubic grid amplitude because the existing Lean range lemmas prove
`0 <= (j / 2^n)^3 <= 1`.
-/
theorem expandedRyCleanEntryForCubicAmplitudes_of_standardTier
    (tier : StandardRyCleanEntryScalarTier) (n : Nat) :
    expandedRyCleanEntryForCubicAmplitudes tier n := by
  intro j
  exact tier.cleanEntry_of_range
    (CubicStatePreparation.cubicAmplitude n j)
    (cubicAmplitude_nonneg n j)
    (cubicAmplitude_le_one n j)

/--
Semantic obligation that the expanded reversible arithmetic computes
`a_j = (j / 2^n)^3` into the named workspace.
-/
opaque expandedArithmeticComputesCubicAmplitude
    (n workspaceQubits : Nat) : Prop

/--
Backend-level shape for the expanded reversible arithmetic compute phase.

The structure records only the compute half of the route: starting from a
clean workspace, the backend returns the same system index together with a
workspace whose distinguished amplitude register contains
`CubicStatePreparation.cubicAmplitude n j`.  Clean uncompute remains the
separate obligation `expandedWorkspaceCleanUncomputed`.
-/
structure ExpandedCubicArithmeticBackend (n workspaceQubits : Nat) where
  Workspace : Type
  workspaceQubitCount : Nat
  workspaceQubitCount_eq : workspaceQubitCount = workspaceQubits
  zeroWorkspace : Workspace
  amplitudeRegister : Workspace -> Rat
  compute : Fin (gridSize n) -> Workspace -> Fin (gridSize n) × Workspace

/--
Symbolic compute-phase backend for `DIAG-EXP-ARITH-BACKEND-001`.

This witness records only the pointwise arithmetic value written by the compute
phase.  It does not certify a reversible gate implementation, clean uncompute,
or the bridge to `expandedArithmeticComputesCubicAmplitude`.
-/
def symbolicExpandedCubicArithmeticBackend (n workspaceQubits : Nat) :
    ExpandedCubicArithmeticBackend n workspaceQubits where
  Workspace := Rat
  workspaceQubitCount := workspaceQubits
  workspaceQubitCount_eq := rfl
  zeroWorkspace := 0
  amplitudeRegister := fun a => a
  compute := fun j _workspace =>
    (j, CubicStatePreparation.cubicAmplitude n j)

/--
Pointwise arithmetic-backend semantics for `DIAG-EXP-ARITH-001`.

For each system index `j`, the compute phase preserves `j` and writes exactly
the cubic diagonal amplitude into its distinguished amplitude register.
-/
def expandedArithmeticBackendComputesCubicAmplitude
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits) : Prop :=
  backend.workspaceQubitCount = workspaceQubits ∧
    ∀ j : Fin (gridSize n),
      (backend.compute j backend.zeroWorkspace).1 = j ∧
        backend.amplitudeRegister ((backend.compute j backend.zeroWorkspace).2) =
          CubicStatePreparation.cubicAmplitude n j

/--
The symbolic backend satisfies the pointwise compute contract for every system
index.  The opaque expanded-route predicate still requires a separate backend
bridge witness.
-/
theorem symbolicExpandedCubicArithmeticBackend_computes
    (n workspaceQubits : Nat) :
    expandedArithmeticBackendComputesCubicAmplitude
      (symbolicExpandedCubicArithmeticBackend n workspaceQubits) := by
  constructor
  · rfl
  · intro j
    constructor <;> rfl

/--
Bridge obligation from a concrete arithmetic backend to the expanded route
predicate.  This is conditional for the same reason as the rotation bridge:
the backend must still justify that its pointwise compute semantics are the
semantics of the route predicate used by the block-encoding contract.
-/
def expandedArithmeticBackendBridge
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits) : Prop :=
  expandedArithmeticBackendComputesCubicAmplitude backend ->
    expandedArithmeticComputesCubicAmplitude n workspaceQubits

theorem expandedArithmeticComputesCubicAmplitude_of_backendBridge
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits)
    (hBackend : expandedArithmeticBackendComputesCubicAmplitude backend)
    (hBridge : expandedArithmeticBackendBridge backend) :
    expandedArithmeticComputesCubicAmplitude n workspaceQubits :=
  hBridge hBackend

/--
General normal form for arithmetic backend bridge proof search.

Once a backend's pointwise compute contract is available, proving its bridge is
equivalent to proving the opaque expanded-route predicate itself.  This lemma
is a proof-reduction aid; it does not supply the route semantics.
-/
theorem expandedArithmeticBackendBridge_iff_of_computes
    {n workspaceQubits : Nat}
    (backend : ExpandedCubicArithmeticBackend n workspaceQubits)
    (hBackend : expandedArithmeticBackendComputesCubicAmplitude backend) :
    expandedArithmeticBackendBridge backend ↔
      expandedArithmeticComputesCubicAmplitude n workspaceQubits := by
  constructor
  · intro hBridge
    exact expandedArithmeticComputesCubicAmplitude_of_backendBridge
      backend hBackend hBridge
  · intro hRoute
    intro _hBackend
    exact hRoute

/--
Specialized conditional closure for the symbolic arithmetic backend.

This does not prove the backend bridge witness; it only packages the already
compiled pointwise compute proof with a future honest bridge witness for
`DIAG-ARITH-BACKEND-BRIDGE-001`.
-/
theorem expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge
    (n workspaceQubits : Nat)
    (hBridge :
      expandedArithmeticBackendBridge
        (symbolicExpandedCubicArithmeticBackend n workspaceQubits)) :
    expandedArithmeticComputesCubicAmplitude n workspaceQubits := by
  exact expandedArithmeticComputesCubicAmplitude_of_backendBridge
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
    (symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits)
    hBridge

/--
Normal form for the symbolic arithmetic bridge obligation.

For the symbolic backend, the pointwise compute proof is already compiled, so
the bridge obligation is logically equivalent to the opaque expanded-route
predicate itself.  This is a proof-reduction lemma, not a bridge witness: it
keeps `DIAG-ARITH-BACKEND-BRIDGE-001` blocked until a concrete route-semantics
representation proves `expandedArithmeticComputesCubicAmplitude`.
-/
theorem symbolicExpandedCubicArithmeticBackend_bridge_iff
    (n workspaceQubits : Nat) :
    expandedArithmeticBackendBridge
        (symbolicExpandedCubicArithmeticBackend n workspaceQubits) ↔
      expandedArithmeticComputesCubicAmplitude n workspaceQubits := by
  exact expandedArithmeticBackendBridge_iff_of_computes
    (symbolicExpandedCubicArithmeticBackend n workspaceQubits)
    (symbolicExpandedCubicArithmeticBackend_computes n workspaceQubits)

/--
`DIAG-ARITH-FIXED-DENOM-CAP-001`: the fixed-denominator cubic payload fits in
the `3 * n`-qubit workspace register.
-/
theorem fixedDenomCubicPayload_lt_capacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 < gridSize (3 * n) := by
  have hlt : j.val ^ 3 < gridSize n ^ 3 :=
    Nat.pow_lt_pow_left j.isLt (by decide : 3 ≠ 0)
  simpa [CubicStatePreparation.gridSize_three_mul_eq_cube] using hlt

/--
`DIAG-ARITH-FIXED-DENOM-ALG-001`: projecting the fixed-denominator payload
`j.val ^ 3` by the `3 * n`-qubit denominator recovers the cubic grid
amplitude.
-/
theorem fixedDenomCubicAmplitude_eq
    (n : Nat) (j : Fin (gridSize n)) :
    (j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j := by
  rw [CubicStatePreparation.gridSize_three_mul_eq_cube]
  simpa [CubicStatePreparation.cubicAmplitude, CubicStatePreparation.gridPoint]
    using
      (show (j.val : Rat) ^ 3 / (gridSize n : Rat) ^ 3 =
          ((j.val : Rat) / (gridSize n : Rat)) ^ 3 by
        simp [Rat.div_def, Rat.pow_succ, Rat.inv_mul_rev, Rat.mul_assoc]
        grind [Rat.mul_comm, Rat.mul_assoc])

/--
`DIAG-ARITH-FIXED-DENOM-BACKEND-001`: concrete compute-phase backend whose
`3 * n`-qubit workspace stores the fixed-denominator payload `j.val ^ 3`.
-/
def fixedDenomCubicArithmeticBackend (n : Nat) :
    ExpandedCubicArithmeticBackend n (3 * n) where
  Workspace := Fin (gridSize (3 * n))
  workspaceQubitCount := 3 * n
  workspaceQubitCount_eq := rfl
  zeroWorkspace := ⟨0, CubicStatePreparation.gridSize_pos (3 * n)⟩
  amplitudeRegister := fun payload =>
    (payload.val : Rat) / (gridSize (3 * n) : Rat)
  compute := fun j _workspace =>
    (j, ⟨j.val ^ 3, fixedDenomCubicPayload_lt_capacity n j⟩)

/--
Pointwise compute contract for the fixed-denominator arithmetic backend.

This closes the backend leaf only; the bridge to
`expandedArithmeticComputesCubicAmplitude` remains a separate semantic
obligation.
-/
theorem fixedDenomCubicArithmeticBackend_computes
    (n : Nat) :
    expandedArithmeticBackendComputesCubicAmplitude
      (fixedDenomCubicArithmeticBackend n) := by
  constructor
  · rfl
  · intro j
    constructor
    · rfl
    · exact fixedDenomCubicAmplitude_eq n j

/--
Transparent arithmetic-route interface for `DIAG-ARITH-ROUTE-TRANSPARENT-001`.

This records that some explicit backend satisfies the pointwise compute
contract.  It is intentionally weaker than the opaque expanded-route predicate:
using it as a route certificate still requires a later named bridge or contract
refactor.
-/
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend

/--
Fixed-denominator witness for the transparent arithmetic route interface.

This packages the already compiled fixed-denominator backend and its pointwise
compute theorem.  It does not prove
`expandedArithmeticComputesCubicAmplitude n (3 * n)`.
-/
theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n) := by
  exact ⟨fixedDenomCubicArithmeticBackend n,
    fixedDenomCubicArithmeticBackend_computes n⟩

/--
Fixed-denominator normal form for the arithmetic bridge obligation.

The concrete backend's pointwise compute proof is available, so direct bridge
search is equivalent to proving the opaque expanded-route predicate itself.
This records the remaining route-semantics gap without supplying a bridge
witness.
-/
theorem fixedDenomCubicArithmeticBackend_bridge_iff
    (n : Nat) :
    expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n) ↔
      expandedArithmeticComputesCubicAmplitude n (3 * n) := by
  exact expandedArithmeticBackendBridge_iff_of_computes
    (fixedDenomCubicArithmeticBackend n)
    (fixedDenomCubicArithmeticBackend_computes n)

/--
Semantic obligation for the standard `R_y` convention on the signal qubit:
for each basis index `j`, the route uses
`theta_j = 2 * arccos ((j / 2^n)^3)`, so the clean entry is
`cos (theta_j / 2) = (j / 2^n)^3`.
-/
opaque expandedControlledRyUsesCubicAngle
    (n workspaceQubits : Nat) : Prop

/--
Transparent controlled-`R_y` angle-convention interface for
`DIAG-RY-TRANSPARENT-INTERFACE-001`.

This records only the already compiled scalar clean-entry fact for every
standard tier.  It does not prove the opaque route predicate
`expandedControlledRyUsesCubicAngle`.
-/
def expandedControlledRyUsesCubicAngleTransparent
    (n _workspaceQubits : Nat) : Prop :=
  forall tier : StandardRyCleanEntryScalarTier,
    expandedRyCleanEntryForCubicAmplitudes tier n

/--
Fixed-denominator wrapper for the transparent controlled-`R_y` route.

This packages the scalar-tier theorem at workspace size `3 * n`.  It does not
provide a backend witness for `expandedControlledRyUsesCubicAngle`.
-/
theorem fixedDenomControlledRyRouteTransparent
    (n : Nat) :
    expandedControlledRyUsesCubicAngleTransparent n (3 * n) := by
  intro tier
  exact expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n

/--
Backend bridge obligation from the scalar-tier `R_y` clean-entry interface to
the expanded route predicate.

This is intentionally conditional: the file already proves the scalar
clean-entry fact for cubic amplitudes, but a concrete backend must still justify
that this fact is the semantics of the controlled rotation used by the route.
-/
def expandedControlledRyBackendBridge
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat) : Prop :=
  expandedRyCleanEntryForCubicAmplitudes tier n ->
    expandedControlledRyUsesCubicAngle n workspaceQubits

theorem expandedControlledRyUsesCubicAngle_of_backendBridge
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat)
    (hBridge : expandedControlledRyBackendBridge tier n workspaceQubits) :
    expandedControlledRyUsesCubicAngle n workspaceQubits :=
  hBridge (expandedRyCleanEntryForCubicAmplitudes_of_standardTier tier n)

/--
Normal form for controlled-rotation backend-bridge proof search.

The scalar-tier clean-entry theorem is already compiled, so proving a backend
bridge for the controlled rotation is equivalent to proving the opaque route
predicate itself.  This is a proof-reduction lemma for
`DIAG-RY-BACKEND-WITNESS-001`; it does not supply the missing backend
semantics.
-/
theorem expandedControlledRyBackendBridge_iff_of_standardTier
    (tier : StandardRyCleanEntryScalarTier)
    (n workspaceQubits : Nat) :
    expandedControlledRyBackendBridge tier n workspaceQubits ↔
      expandedControlledRyUsesCubicAngle n workspaceQubits := by
  constructor
  · intro hBridge
    exact expandedControlledRyUsesCubicAngle_of_backendBridge
      tier n workspaceQubits hBridge
  · intro hRoute
    intro _hScalar
    exact hRoute

/-- Semantic obligation that the arithmetic workspace is returned clean. -/
opaque expandedWorkspaceCleanUncomputed
    (n workspaceQubits : Nat) : Prop

/--
Transparent clean-uncompute interface for
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001`.

This records the data needed to state honest reversible cleanup: a compute step
matching the backend on clean workspace, an uncompute step that preserves the
system index, and a two-sided cleanup condition after compute.  It does not
prove the opaque route predicate `expandedWorkspaceCleanUncomputed`.
-/
structure ExpandedArithmeticCleanUncomputeWitness
    (n workspaceQubits : Nat) where
  backend : ExpandedCubicArithmeticBackend n workspaceQubits
  computes : expandedArithmeticBackendComputesCubicAmplitude backend
  computeStep :
    Fin (gridSize n) -> backend.Workspace ->
      Prod (Fin (gridSize n)) backend.Workspace
  uncomputeStep :
    Fin (gridSize n) -> backend.Workspace ->
      Prod (Fin (gridSize n)) backend.Workspace
  computeStep_matches_backend_on_clean :
    forall j,
      computeStep j backend.zeroWorkspace =
        backend.compute j backend.zeroWorkspace
  compute_preserves_index :
    forall j w, (computeStep j w).1 = j
  uncompute_preserves_index :
    forall j w, (uncomputeStep j w).1 = j
  uncompute_after_compute :
    forall j w, uncomputeStep j (computeStep j w).2 = (j, w)

/--
Transparent cleanup predicate backed by an explicit reversible witness.

This is intentionally separate from `expandedWorkspaceCleanUncomputed`; a later
route must either instantiate this interface and refactor a contract to consume
it, or supply a nontrivial bridge to the opaque predicate.
-/
def expandedWorkspaceCleanUncomputedTransparent
    (n workspaceQubits : Nat) : Prop :=
  Nonempty (ExpandedArithmeticCleanUncomputeWitness n workspaceQubits)

theorem expandedWorkspaceCleanUncomputedTransparent_of_witness
    {n workspaceQubits : Nat}
    (w : ExpandedArithmeticCleanUncomputeWitness n workspaceQubits) :
    expandedWorkspaceCleanUncomputedTransparent n workspaceQubits := by
  exact ⟨w⟩

private theorem fixedDenomCubicModAddSub_eq_self
    {modulus workspace payload : Nat}
    (hWorkspace : workspace < modulus) (hPayload : payload < modulus) :
    ((workspace + payload) % modulus + modulus - payload) % modulus =
      workspace := by
  by_cases hlt : workspace + payload < modulus
  · have hmod : (workspace + payload) % modulus =
        workspace + payload := Nat.mod_eq_of_lt hlt
    calc
      ((workspace + payload) % modulus + modulus - payload) % modulus
          = (workspace + payload + modulus - payload) % modulus := by
              rw [hmod]
      _ = (workspace + modulus) % modulus := by
            congr 1
            omega
      _ = workspace % modulus := by
            rw [Nat.add_mod_right]
      _ = workspace := Nat.mod_eq_of_lt hWorkspace
  · have hge : workspace + payload ≥ modulus := by omega
    have hsum_lt : workspace + payload < 2 * modulus := by omega
    have hsub_lt : workspace + payload - modulus < modulus := by omega
    have hmod : (workspace + payload) % modulus =
        workspace + payload - modulus := by
      rw [Nat.mod_eq_sub_mod hge]
      exact Nat.mod_eq_of_lt hsub_lt
    calc
      ((workspace + payload) % modulus + modulus - payload) % modulus
          = (workspace + payload - modulus + modulus - payload) % modulus := by
              rw [hmod]
      _ = workspace % modulus := by
            congr 1
            omega
      _ = workspace := Nat.mod_eq_of_lt hWorkspace

/--
Fixed-denominator reversible compute lift for
`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`.

This modular-add step agrees with `fixedDenomCubicArithmeticBackend` on clean
workspace, but unlike the backend's overwrite-style compute field it is
invertible on every workspace value.
-/
def fixedDenomCubicComputeStep (n : Nat) :
    Fin (gridSize n) -> (fixedDenomCubicArithmeticBackend n).Workspace ->
      Prod (Fin (gridSize n)) (fixedDenomCubicArithmeticBackend n).Workspace :=
  fun j workspace =>
    (j, ⟨(workspace.val + j.val ^ 3) % gridSize (3 * n),
      Nat.mod_lt _ (CubicStatePreparation.gridSize_pos (3 * n))⟩)

/-- Modular-subtract inverse for `fixedDenomCubicComputeStep`. -/
def fixedDenomCubicUncomputeStep (n : Nat) :
    Fin (gridSize n) -> (fixedDenomCubicArithmeticBackend n).Workspace ->
      Prod (Fin (gridSize n)) (fixedDenomCubicArithmeticBackend n).Workspace :=
  fun j workspace =>
    (j, ⟨(workspace.val + gridSize (3 * n) - j.val ^ 3) % gridSize (3 * n),
      Nat.mod_lt _ (CubicStatePreparation.gridSize_pos (3 * n))⟩)

theorem fixedDenomCubicComputeStep_matches_backend_on_clean
    (n : Nat) (j : Fin (gridSize n)) :
    fixedDenomCubicComputeStep n j
        (fixedDenomCubicArithmeticBackend n).zeroWorkspace =
      (fixedDenomCubicArithmeticBackend n).compute j
        (fixedDenomCubicArithmeticBackend n).zeroWorkspace := by
  simp [fixedDenomCubicComputeStep, fixedDenomCubicArithmeticBackend,
    Nat.mod_eq_of_lt (fixedDenomCubicPayload_lt_capacity n j)]

theorem fixedDenomCubicUncomputeStep_after_compute
    (n : Nat) (j : Fin (gridSize n))
    (workspace : (fixedDenomCubicArithmeticBackend n).Workspace) :
    fixedDenomCubicUncomputeStep n j
        (fixedDenomCubicComputeStep n j workspace).2 =
      (j, workspace) := by
  apply Prod.ext
  · rfl
  · apply Fin.ext
    simp [fixedDenomCubicComputeStep, fixedDenomCubicUncomputeStep]
    exact fixedDenomCubicModAddSub_eq_self workspace.isLt
      (fixedDenomCubicPayload_lt_capacity n j)

/--
Fixed-denominator witness for the transparent clean-uncompute interface.

This packages modular add/sub cleanup only.  It does not prove the opaque
predicate `expandedWorkspaceCleanUncomputed`, does not state controlled-rotation
workspace-readonly semantics, and does not close extraction or unitarity.
-/
def fixedDenomExpandedArithmeticCleanUncomputeWitness
    (n : Nat) : ExpandedArithmeticCleanUncomputeWitness n (3 * n) where
  backend := fixedDenomCubicArithmeticBackend n
  computes := fixedDenomCubicArithmeticBackend_computes n
  computeStep := fixedDenomCubicComputeStep n
  uncomputeStep := fixedDenomCubicUncomputeStep n
  computeStep_matches_backend_on_clean := by
    intro j
    exact fixedDenomCubicComputeStep_matches_backend_on_clean n j
  compute_preserves_index := by
    intro j workspace
    rfl
  uncompute_preserves_index := by
    intro j workspace
    rfl
  uncompute_after_compute := by
    intro j workspace
    exact fixedDenomCubicUncomputeStep_after_compute n j workspace

theorem fixedDenomWorkspaceCleanUncomputedTransparent
    (n : Nat) :
    expandedWorkspaceCleanUncomputedTransparent n (3 * n) := by
  exact expandedWorkspaceCleanUncomputedTransparent_of_witness
    (fixedDenomExpandedArithmeticCleanUncomputeWitness n)

/-- Clean-block extraction obligation for the expanded arithmetic/rotation route. -/
opaque expandedAmplitudeOracleCleanBlockExtracts
    (n workspaceQubits : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop

/--
Expanded-route clean-block contract for `DIAG-EXPANDED-CONTRACT-001`.

This is an interface, not a proof of the expanded circuit.  It keeps the
transparent arithmetic witness, transparent controlled-rotation witness, and
clean-uncompute obligations explicit and requires the extracted clean block to
satisfy the existing diagonal contract.
-/
def expandedAmplitudeOracleCleanBlockContract
    (n workspaceQubits : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat) : Prop :=
  expandedArithmeticComputesCubicAmplitudeTransparent n workspaceQubits ∧
    expandedControlledRyUsesCubicAngleTransparent n workspaceQubits ∧
    expandedWorkspaceCleanUncomputed n workspaceQubits ∧
    expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block ∧
    diagonalCleanBlockContract n block

theorem expandedAmplitudeOracleCleanBlockContract_diagonal
    (n workspaceQubits : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : expandedAmplitudeOracleCleanBlockContract n workspaceQubits block) :
    diagonalCleanBlockContract n block := by
  exact h.2.2.2.2

theorem expandedAmplitudeOracleCleanBlockContract_eq_target
    (n workspaceQubits : Nat)
    (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : expandedAmplitudeOracleCleanBlockContract n workspaceQubits block) :
    Matrix.PointwiseEq block (cubicDiagonalTarget n).operator := by
  exact primitiveOracleCleanBlock_eq_target n block
    (expandedAmplitudeOracleCleanBlockContract_diagonal n workspaceQubits block h)

/--
Conditional semantic interface for an expanded arithmetic/rotation route with
an explicit workspace size.
-/
def expandedAmplitudeOracleSemanticContract
    (n workspaceQubits : Nat) : Prop :=
  ∃ block : Matrix (gridSize n) (gridSize n) Rat,
    expandedAmplitudeOracleCleanBlockContract n workspaceQubits block

theorem expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target
    (n workspaceQubits : Nat)
    (h : expandedAmplitudeOracleSemanticContract n workspaceQubits) :
    ∃ block : Matrix (gridSize n) (gridSize n) Rat,
      expandedAmplitudeOracleCleanBlockExtracts n workspaceQubits block ∧
        Matrix.PointwiseEq block (cubicDiagonalTarget n).operator := by
  rcases h with ⟨block, hContract⟩
  exact ⟨block, hContract.2.2.2.1,
    expandedAmplitudeOracleCleanBlockContract_eq_target
      n workspaceQubits block hContract⟩

/-- Conditional candidate at the primitive oracle-label tier. -/
def primitiveAmplitudeOracleCandidate (n : Nat) :
    OperatorBlockEncodingCandidate Rat n where
  auxiliaryQubits := (amplitudeOracleLayout n).auxiliaryQubits
  target := cubicDiagonalTarget n
  unitary := primitiveAmplitudeOracleUnitary n
  layout := amplitudeOracleLayout n
  circuit := amplitudeOracleCircuit n
  resource := amplitudeOracleResource n
  layoutMatches := rfl
  isUnitary :=
    primitiveAmplitudeOracleIsUnitary n (primitiveAmplitudeOracleUnitary n)
  blockContainsTarget :=
    ∃ block : Matrix (gridSize n) (gridSize n) Rat,
      primitiveAmplitudeOracleCleanBlockExtracts n
        (primitiveAmplitudeOracleUnitary n) block ∧
        Matrix.PointwiseEq block (cubicDiagonalTarget n).operator

theorem primitiveAmplitudeOracleCandidate_costTuple_eq (n : Nat) :
    ( (primitiveAmplitudeOracleCandidate n).cost.gateCount
    , (primitiveAmplitudeOracleCandidate n).cost.depth
    , (primitiveAmplitudeOracleCandidate n).cost.auxiliaryQubits
    , (primitiveAmplitudeOracleCandidate n).cost.oracleCalls
    ) = (1, 1, 1, 1) := by
  simp [OperatorBlockEncodingCandidate.cost, primitiveAmplitudeOracleCandidate,
    amplitudeOracleLayout, amplitudeOracleResource, amplitudeOracleCircuit,
    RegisterLayout.auxiliaryQubits, Circuit.resource, Gate.resource,
    Resource.gates, Resource.ofCountsWithDepth]

theorem primitiveAmplitudeOracleCandidate_unitary_from_contract
    (n : Nat) (h : primitiveAmplitudeOracleSemanticContract n) :
    (primitiveAmplitudeOracleCandidate n).isUnitary := by
  simpa [primitiveAmplitudeOracleCandidate] using
    primitiveAmplitudeOracleSemanticContract_unitary n h

theorem primitiveAmplitudeOracleCandidate_block_from_contract
    (n : Nat) (h : primitiveAmplitudeOracleSemanticContract n) :
    (primitiveAmplitudeOracleCandidate n).blockContainsTarget := by
  simpa [primitiveAmplitudeOracleCandidate] using
    primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target n h

/--
Conditional exact certificate for the primitive oracle-label tier.

This packages a verified block encoding only from an explicit proof of
`primitiveAmplitudeOracleSemanticContract n`; the contract itself remains an
open primitive-oracle obligation until such a proof or accepted primitive
axiom is supplied.
-/
def primitiveAmplitudeOracleVerified
    (n : Nat) (h : primitiveAmplitudeOracleSemanticContract n) :
    VerifiedOperatorBlockEncoding Rat n where
  candidate := primitiveAmplitudeOracleCandidate n
  unitaryProof := primitiveAmplitudeOracleCandidate_unitary_from_contract n h
  blockProof := primitiveAmplitudeOracleCandidate_block_from_contract n h

/-- Human-facing construction claim for the first exact diagonal route. -/
def amplitudeOracleClaim : ConstructionClaim where
  name := "diagonal-cubic-amplitude-oracle"
  source := "QBE-OP-CUBIC-DIAGONAL-001 exploratory exact candidate"
  target := "D_n = sum_j (j/2^n)^3 |j><j|"
  normalization := "alpha = 1"
  layout := "one signal qubit, no pure ancilla at the oracle-label tier"
  resource := {
    gates := CostExpr.atom "diag_cubic_amplitude_oracle"
    pureAncilla := 0
  }

end CubicDiagonalOracle
end QuantumBlockEncoding
