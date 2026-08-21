import QuantumBlockEncoding.VandaeleControlledComparatorResource
import QuantumBlockEncoding.VandaeleCorollary8ControlledAdderResource
import Mathlib.Tactic

/-!
# Section 6.2 resource composition for Shor's algorithm

Vandaele follows the 2n+2-qubit modular-multiplication architecture of Häner,
Roetteler, and Svore.  The external architecture contributes only call counts:

* O(n) controlled modular multiplications in modular exponentiation;
* O(n) controlled modular additions per multiplication;
* hence O(n^2) singly-controlled classical-quantum comparators and O(n^2)
  doubly-controlled classical-quantum adders/subtractors.

Corollary 6 supplies the comparator resources and Corollary 8 supplies the
adder resources.  This file composes those *actual source-scale resource
functions* and derives the paper's final envelopes

`O(n^3 log n)` gates and `O(n^2 log^2 n)` depth.

The O(n^2) call-count statement remains an explicit architecture contract from
[5]; it is not silently proved from the arithmetic primitives.
-/

namespace QuantumBlockEncoding
namespace VandaeleShorResourceApplication

open ComparatorIncrementerTheorem4DepthBound
open VandaeleControlledComparatorResource
open VandaeleCorollary8ControlledAdderResource

/-- Uniform resource interface in exactly the form returned by Corollary 6. -/
def ControlledComparatorResourceTarget
    (gateCount depth : Nat -> Nat -> Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ controls n,
      gateCount controls n <= gateConstant * (controls + n + 2) ∧
      depth controls n <=
        depthConstant * VandaeleControlledComparatorResource.combinedLogScale controls n

/-- Uniform resource interface in exactly the form returned by Corollary 8. -/
def ControlledAdderResourceTarget
    (gateCount depth : Nat -> Nat -> Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ controls n,
      gateCount controls n <=
        gateConstant * VandaeleCorollary8ControlledAdderResource.gateScale controls n ∧
      depth controls n <=
        depthConstant * VandaeleCorollary8ControlledAdderResource.depthScale controls n

/-- External Häner-architecture call-count contract: both relevant primitive
families are invoked O(n^2) times over the complete modular exponentiation. -/
def ArchitectureCallCountTarget
    (comparatorUses adderUses : Nat -> Nat) : Prop :=
  ∃ comparatorConstant adderConstant : Nat,
    ∀ n,
      comparatorUses n <= comparatorConstant * (n + 1) ^ 2 ∧
      adderUses n <= adderConstant * (n + 1) ^ 2

/-- Total gate count of the source composition. -/
def totalGateCount
    (comparatorUses adderUses : Nat -> Nat)
    (comparatorGate adderGate : Nat -> Nat -> Nat)
    (n : Nat) : Nat :=
  comparatorUses n * comparatorGate 1 n +
    adderUses n * adderGate 2 n

/-- Conservative serial depth of the source composition. -/
def totalDepth
    (comparatorUses adderUses : Nat -> Nat)
    (comparatorDepth adderDepth : Nat -> Nat -> Nat)
    (n : Nat) : Nat :=
  comparatorUses n * comparatorDepth 1 n +
    adderUses n * adderDepth 2 n

/-- Final logarithmic rank.  Using n+2 absorbs the constant one/two control
registers without changing the paper's asymptotic statement. -/
def shorLogRank (n : Nat) : Nat := logRank (n + 2)

@[simp] theorem shorLogRank_pos (n : Nat) : 1 <= shorLogRank n := by
  unfold shorLogRank logRank
  omega

/-- The ordinary n-bit logarithmic rank is bounded by the final application
rank. -/
theorem logRank_le_shorLogRank (n : Nat) :
    logRank n <= shorLogRank n := by
  unfold shorLogRank logRank
  have argument : n + 1 <= n + 3 := by omega
  have logarithm : Nat.log2 (n + 1) <= Nat.log2 (n + 3) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right argument
  omega

/-- The fixed control-log constants used by the one/two-controlled application
are bounded by a small multiple of the final rank. -/
theorem fixed_control_log_bounds (n : Nat) :
    VandaeleLemma1Contract.logScale 2 <= 3 * shorLogRank n := by
  have rankPos := shorLogRank_pos n
  have fixed : VandaeleLemma1Contract.logScale 2 <= 3 := by
    native_decide
  omega

/-- A singly-controlled Corollary-6 comparator has a linear-times-log envelope
under the application rank. -/
theorem singlyControlledComparator_gate_bound
    (gateCount depth : Nat -> Nat -> Nat)
    (resources : ControlledComparatorResourceTarget gateCount depth) :
    ∃ gateConstant depthConstant : Nat,
      ∀ n,
        gateCount 1 n <= gateConstant * (n + 1) * shorLogRank n ∧
        depth 1 n <= depthConstant * shorLogRank n := by
  rcases resources with ⟨gateConstant, depthConstant, bounds⟩
  refine ⟨3 * gateConstant, 4 * depthConstant, ?_⟩
  intro n
  have source := bounds 1 n
  have rankPos := shorLogRank_pos n
  constructor
  · have width : n + 3 <= 3 * (n + 1) := by omega
    calc
      gateCount 1 n <= gateConstant * (n + 3) := by simpa using source.1
      _ <= gateConstant * (3 * (n + 1)) :=
        Nat.mul_le_mul_left gateConstant width
      _ <= (3 * gateConstant) * (n + 1) * shorLogRank n := by
        nlinarith
  · have baseLog := logRank_le_shorLogRank n
    have fixedLog := fixed_control_log_bounds n
    unfold VandaeleControlledComparatorResource.combinedLogScale at source
    calc
      depth 1 n <= depthConstant *
          (logRank n + VandaeleLemma1Contract.logScale 2) := source.2
      _ <= depthConstant * (4 * shorLogRank n) := by
        apply Nat.mul_le_mul_left
        omega
      _ = (4 * depthConstant) * shorLogRank n := by ring

/-- A doubly-controlled Corollary-8 adder has O(n log n) gates and O(log^2 n)
depth under the same application rank. -/
theorem doublyControlledAdder_bound
    (gateCount depth : Nat -> Nat -> Nat)
    (resources : ControlledAdderResourceTarget gateCount depth) :
    ∃ gateConstant depthConstant : Nat,
      ∀ n,
        gateCount 2 n <= gateConstant * (n + 1) * shorLogRank n ∧
        depth 2 n <= depthConstant * (shorLogRank n * shorLogRank n) := by
  rcases resources with ⟨gateConstant, depthConstant, bounds⟩
  refine ⟨4 * gateConstant, 5 * depthConstant, ?_⟩
  intro n
  have source := bounds 2 n
  have rankPos := shorLogRank_pos n
  have rankMono := logRank_le_shorLogRank n
  constructor
  · unfold VandaeleCorollary8ControlledAdderResource.gateScale at source
    have scaleBound :
        2 + (n + 1) * logRank n + 1 <=
          4 * (n + 1) * shorLogRank n := by
      have main : (n + 1) * logRank n <= (n + 1) * shorLogRank n :=
        Nat.mul_le_mul_left (n + 1) rankMono
      nlinarith
    calc
      gateCount 2 n <= gateConstant *
          (2 + (n + 1) * logRank n + 1) := source.1
      _ <= gateConstant * (4 * (n + 1) * shorLogRank n) :=
        Nat.mul_le_mul_left gateConstant scaleBound
      _ = (4 * gateConstant) * (n + 1) * shorLogRank n := by ring
  · unfold VandaeleCorollary8ControlledAdderResource.depthScale at source
    have fixedLog := fixed_control_log_bounds n
    have shiftedRank : logRank (2 + n) = shorLogRank n := by
      congr 1
      omega
    have squareMono : logRank n * logRank n <=
        shorLogRank n * shorLogRank n :=
      Nat.mul_le_mul rankMono rankMono
    have rankToSquare : shorLogRank n <=
        shorLogRank n * shorLogRank n := by
      nlinarith
    have scaleBound :
        VandaeleLemma1Contract.logScale 2 +
          logRank n * logRank n + logRank (2 + n) <=
        5 * (shorLogRank n * shorLogRank n) := by
      rw [shiftedRank]
      nlinarith
    calc
      depth 2 n <= depthConstant *
          (VandaeleLemma1Contract.logScale 2 +
            logRank n * logRank n + logRank (2 + n)) := source.2
      _ <= depthConstant *
          (5 * (shorLogRank n * shorLogRank n)) :=
        Nat.mul_le_mul_left depthConstant scaleBound
      _ = (5 * depthConstant) *
          (shorLogRank n * shorLogRank n) := by ring

/-- Main Section-6.2 composition theorem. -/
theorem shor_resource_closure
    (comparatorUses adderUses : Nat -> Nat)
    (comparatorGate comparatorDepth : Nat -> Nat -> Nat)
    (adderGate adderDepth : Nat -> Nat -> Nat)
    (architecture : ArchitectureCallCountTarget comparatorUses adderUses)
    (comparatorResources :
      ControlledComparatorResourceTarget comparatorGate comparatorDepth)
    (adderResources :
      ControlledAdderResourceTarget adderGate adderDepth) :
    ∃ gateConstant depthConstant : Nat,
      ∀ n,
        totalGateCount comparatorUses adderUses comparatorGate adderGate n <=
          gateConstant * (n + 1) ^ 3 * shorLogRank n ∧
        totalDepth comparatorUses adderUses comparatorDepth adderDepth n <=
          depthConstant * (n + 1) ^ 2 *
            (shorLogRank n * shorLogRank n) := by
  rcases architecture with ⟨cmpUseConstant, addUseConstant, useBounds⟩
  rcases singlyControlledComparator_gate_bound
    comparatorGate comparatorDepth comparatorResources with
      ⟨cmpGateConstant, cmpDepthConstant, cmpBounds⟩
  rcases doublyControlledAdder_bound
    adderGate adderDepth adderResources with
      ⟨addGateConstant, addDepthConstant, addBounds⟩
  refine ⟨cmpUseConstant * cmpGateConstant + addUseConstant * addGateConstant,
    cmpUseConstant * cmpDepthConstant + addUseConstant * addDepthConstant, ?_⟩
  intro n
  have uses := useBounds n
  have cmp := cmpBounds n
  have add := addBounds n
  constructor
  · unfold totalGateCount
    calc
      comparatorUses n * comparatorGate 1 n +
          adderUses n * adderGate 2 n <=
        (cmpUseConstant * (n + 1) ^ 2) *
            (cmpGateConstant * (n + 1) * shorLogRank n) +
          (addUseConstant * (n + 1) ^ 2) *
            (addGateConstant * (n + 1) * shorLogRank n) :=
        Nat.add_le_add
          (Nat.mul_le_mul uses.1 cmp.1)
          (Nat.mul_le_mul uses.2 add.1)
      _ = (cmpUseConstant * cmpGateConstant +
            addUseConstant * addGateConstant) *
          (n + 1) ^ 3 * shorLogRank n := by ring
  · unfold totalDepth
    have cmpDepthSquare :
        cmpDepthConstant * shorLogRank n <=
          cmpDepthConstant * (shorLogRank n * shorLogRank n) :=
      Nat.mul_le_mul_left cmpDepthConstant (by
        have rankPos := shorLogRank_pos n
        nlinarith)
    calc
      comparatorUses n * comparatorDepth 1 n +
          adderUses n * adderDepth 2 n <=
        (cmpUseConstant * (n + 1) ^ 2) *
            (cmpDepthConstant * (shorLogRank n * shorLogRank n)) +
          (addUseConstant * (n + 1) ^ 2) *
            (addDepthConstant * (shorLogRank n * shorLogRank n)) :=
        Nat.add_le_add
          (Nat.mul_le_mul uses.1 (cmp.2.trans cmpDepthSquare))
          (Nat.mul_le_mul uses.2 add.2)
      _ = (cmpUseConstant * cmpDepthConstant +
            addUseConstant * addDepthConstant) *
          (n + 1) ^ 2 * (shorLogRank n * shorLogRank n) := by ring

/-- Qubit count stated in Section 6.2 / Table 2.  The source architecture uses
n input qubits, n clean modular-multiplication workspace qubits, one clean
comparator-output bit, and one reused semiclassical-QFT control bit. -/
def shorQubitCount (n : Nat) : Nat := n + n + 1 + 1

@[simp] theorem shorQubitCount_eq (n : Nat) : shorQubitCount n = 2 * n + 2 := by
  unfold shorQubitCount
  omega

end VandaeleShorResourceApplication
end QuantumBlockEncoding
