import QuantumBlockEncoding.VandaeleLadderContract
import QuantumBlockEncoding.VandaeleLemma4ProgramFamily
import QuantumBlockEncoding.VandaeleLemma5Contract
import QuantumBlockEncoding.VandaeleTheorem1Contract
import Mathlib.Tactic

/-!
# Resource closure for Vandaele Corollary 3

Corollary 3 is the first full application of Theorem 1.  After two controlled
conjugation reductions in the ripple-carry adder of Figure 4, its resources
separate into:

* two uncontrolled `L_1` ladders (Lemma 3);
* one central `U_3† ; C^k(U_4) ; U_3` block handled by Theorem 1, where `U_3`
  is the `L_2` ladder of Lemma 4 and slice 4 reduces to constant-size work;
* three remaining controlled independent layers handled by Lemma 5.

This file first specializes Theorem 1 to the central adder block and then closes
the complete `O(n+k)` gate, `O(log n + log k)` depth, and
`max(1,n-k+1)` clean-ancilla statement.  All constants are uniform.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary3ControlledQuantumAdderResource

open VandaeleLadderContract
open VandaeleLemma5Contract
open VandaeleTheorem1Contract

/-- Common logarithmic scale for the controlled adder. -/
def combinedLogScale (n controls : Nat) : Nat :=
  (Nat.log2 (n + 1) + 1) + (Nat.log2 (controls + 1) + 1)

/-- Central Theorem-1 specialization.  Slice 4 contributes only constant-size
middle work; `4` is a conservative logical-gate envelope for the source C^3X
decomposition, and its depth is totalized as one source layer. -/
def centralParameters
    (lemmaFourGate lemmaFourDepth : Nat -> Nat)
    (n controls : Nat) : SourceParameters where
  targetQubits := n
  controls := controls
  sourceCleanAncillas := n
  outerGateCount := lemmaFourGate n
  middleGateCount := 4
  outerDepth := lemmaFourDepth n
  middleDepth := 1

/-- Uniform resource target for the central controlled-conjugation block. -/
def CentralResourceTarget
    (gateCount depth cleanAncillas : Nat -> Nat -> Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n controls,
      gateCount n controls <= gateConstant * (n + controls + 1) ∧
      depth n controls <= depthConstant * combinedLogScale n controls ∧
      cleanAncillas n controls <= max 1 (n - controls + 1)

/-- Specializing the uniform Theorem-1 family to the Figure-4 middle block gives
exactly the central Corollary-3 resource target. -/
theorem central_from_theoremOne
    (lemmaFourGate lemmaFourDepth lemmaFourAncillas : Nat -> Nat)
    (theoremOneGate theoremOneDepth theoremOneClean : SourceParameters -> Nat)
    (lemmaFourResources :
      LemmaFourUniformResourceTarget
        lemmaFourGate lemmaFourDepth lemmaFourAncillas)
    (theoremOneResources :
      UniformResourceTarget theoremOneGate theoremOneDepth theoremOneClean) :
    CentralResourceTarget
      (fun n controls =>
        theoremOneGate
          (centralParameters lemmaFourGate lemmaFourDepth n controls))
      (fun n controls =>
        theoremOneDepth
          (centralParameters lemmaFourGate lemmaFourDepth n controls))
      (fun n controls =>
        theoremOneClean
          (centralParameters lemmaFourGate lemmaFourDepth n controls)) := by
  rcases lemmaFourResources with
    ⟨outerGateConstant, outerDepthConstant, outerBounds⟩
  rcases theoremOneResources with
    ⟨theoremGateConstant, theoremDepthConstant, theoremBounds⟩
  refine ⟨theoremGateConstant * (outerGateConstant + 7),
    theoremDepthConstant * (outerDepthConstant + 3), ?_⟩
  intro n controls
  let p := centralParameters lemmaFourGate lemmaFourDepth n controls
  let scale := n + controls + 1
  let logN := Nat.log2 (n + 1) + 1
  let logK := Nat.log2 (controls + 1) + 1
  have scalePos : 1 <= scale := by simp [scale]
  have logNPos : 1 <= logN := by simp [logN]
  have logKPos : 1 <= logK := by simp [logK]
  have outer := outerBounds n
  have source := theoremBounds p
  have outerGateGlobal :
      lemmaFourGate n <= outerGateConstant * scale := by
    exact outer.1.trans
      (Nat.mul_le_mul_left outerGateConstant (by
        dsimp [scale]
        omega))
  have gateScaleBound : gateScale p + 1 <=
      (outerGateConstant + 7) * scale := by
    unfold gateScale p centralParameters
    dsimp
    have nLe : n <= scale := by dsimp [scale]; omega
    have kLe : controls <= scale := by dsimp [scale]; omega
    nlinarith
  have gateBound :
      theoremOneGate p <=
        (theoremGateConstant * (outerGateConstant + 7)) * scale := by
    calc
      theoremOneGate p <= theoremGateConstant * (gateScale p + 1) := source.1
      _ <= theoremGateConstant * ((outerGateConstant + 7) * scale) :=
        Nat.mul_le_mul_left theoremGateConstant gateScaleBound
      _ = (theoremGateConstant * (outerGateConstant + 7)) * scale := by ring
  have outerDepthBound :
      lemmaFourDepth n <= outerDepthConstant * logN := by
    simpa [logN] using outer.2.1
  have depthScaleBound :
      depthScale p + 1 <= (outerDepthConstant + 3) * (logN + logK) := by
    unfold depthScale p centralParameters
    dsimp [logN, logK]
    have oneLeSum : 1 <= logN + logK := by omega
    nlinarith
  have depthBound :
      theoremOneDepth p <=
        (theoremDepthConstant * (outerDepthConstant + 3)) *
          combinedLogScale n controls := by
    calc
      theoremOneDepth p <= theoremDepthConstant * (depthScale p + 1) := source.2.1
      _ <= theoremDepthConstant *
          ((outerDepthConstant + 3) * (logN + logK)) :=
        Nat.mul_le_mul_left theoremDepthConstant depthScaleBound
      _ = (theoremDepthConstant * (outerDepthConstant + 3)) *
          combinedLogScale n controls := by
        simp [combinedLogScale, logN, logK]
        ring
  have cleanBound :
      theoremOneClean p <= max 1 (n - controls + 1) := by
    have clean := source.2.2
    simpa [p, centralParameters, cleanAncillaBudget] using clean
  exact ⟨gateBound, depthBound, cleanBound⟩

/-- Conservative full-adder resource envelope matching Equation (16): two
uncontrolled Lemma-3 ladders, one central Theorem-1 block, and three Lemma-5
controlled product layers. -/
def gateEnvelope
    (lemmaThreeGate : Nat -> Nat)
    (centralGate : Nat -> Nat -> Nat)
    (lemmaFiveGate : Nat -> Nat -> Nat)
    (n controls : Nat) : Nat :=
  2 * lemmaThreeGate n + centralGate n controls +
    3 * lemmaFiveGate n controls

/-- Serial depth envelope for the same source decomposition. -/
def depthEnvelope
    (lemmaThreeDepth : Nat -> Nat)
    (centralDepth : Nat -> Nat -> Nat)
    (lemmaFiveDepth : Nat -> Nat -> Nat)
    (n controls : Nat) : Nat :=
  2 * lemmaThreeDepth n + centralDepth n controls +
    3 * lemmaFiveDepth n controls

/-- Final Corollary-3 resource target. -/
def CorollaryThreeResourceTarget
    (gateCount depth cleanAncillas : Nat -> Nat -> Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n controls,
      gateCount n controls <= gateConstant * (n + controls + 1) ∧
      depth n controls <= depthConstant * combinedLogScale n controls ∧
      cleanAncillas n controls <= max 1 (n - controls + 1)

/-- Lemma 3 + Theorem 1 + Lemma 5 close the Corollary-3 resource statement. -/
theorem corollaryThree_resource_closure
    (lemmaThreeGate lemmaThreeDepth : Nat -> Nat)
    (centralGate centralDepth centralClean : Nat -> Nat -> Nat)
    (lemmaFiveGate lemmaFiveDepth lemmaFiveAncillas : Nat -> Nat -> Nat)
    (lemmaThreeResources :
      LemmaThreeUniformResourceTarget lemmaThreeGate lemmaThreeDepth)
    (centralResources :
      CentralResourceTarget centralGate centralDepth centralClean)
    (lemmaFiveResources :
      LemmaFiveUniformResourceTarget
        lemmaFiveGate lemmaFiveDepth lemmaFiveAncillas) :
    CorollaryThreeResourceTarget
      (gateEnvelope lemmaThreeGate centralGate lemmaFiveGate)
      (depthEnvelope lemmaThreeDepth centralDepth lemmaFiveDepth)
      centralClean := by
  rcases lemmaThreeResources with
    ⟨l1GateConstant, l1DepthConstant, l1Bounds⟩
  rcases centralResources with
    ⟨centralGateConstant, centralDepthConstant, centralBounds⟩
  rcases lemmaFiveResources with
    ⟨l5GateConstant, l5DepthConstant, l5Bounds⟩
  refine ⟨2 * l1GateConstant + centralGateConstant + 3 * l5GateConstant,
    2 * l1DepthConstant + centralDepthConstant + 3 * l5DepthConstant, ?_⟩
  intro n controls
  let scale := n + controls + 1
  let logScale := combinedLogScale n controls
  have l1 := l1Bounds n
  have central := centralBounds n controls
  have l5 := l5Bounds n controls
  have l1GateGlobal : lemmaThreeGate n <= l1GateConstant * scale :=
    l1.1.trans (Nat.mul_le_mul_left l1GateConstant (by
      dsimp [scale]
      omega))
  have l1DepthGlobal : lemmaThreeDepth n <= l1DepthConstant * logScale := by
    have logNLe : Nat.log2 (n + 1) + 1 <= logScale := by
      dsimp [logScale, combinedLogScale]
      omega
    exact l1.2.trans (Nat.mul_le_mul_left l1DepthConstant logNLe)
  constructor
  · unfold gateEnvelope
    calc
      2 * lemmaThreeGate n + centralGate n controls +
          3 * lemmaFiveGate n controls <=
        2 * (l1GateConstant * scale) +
          centralGateConstant * scale +
          3 * (l5GateConstant * scale) := by
            exact Nat.add_le_add
              (Nat.add_le_add
                (Nat.mul_le_mul_left 2 l1GateGlobal) central.1)
              (Nat.mul_le_mul_left 3 l5.1)
      _ = (2 * l1GateConstant + centralGateConstant + 3 * l5GateConstant) *
          scale := by ring
  · constructor
    · unfold depthEnvelope
      calc
        2 * lemmaThreeDepth n + centralDepth n controls +
            3 * lemmaFiveDepth n controls <=
          2 * (l1DepthConstant * logScale) +
            centralDepthConstant * logScale +
            3 * (l5DepthConstant * logScale) := by
              exact Nat.add_le_add
                (Nat.add_le_add
                  (Nat.mul_le_mul_left 2 l1DepthGlobal) central.2.1)
                (Nat.mul_le_mul_left 3 (by
                  simpa [VandaeleLemma5Contract.depthScale,
                    combinedLogScale, Nat.add_comm, Nat.add_left_comm,
                    Nat.add_assoc] using l5.2.1))
        _ = (2 * l1DepthConstant + centralDepthConstant + 3 * l5DepthConstant) *
            logScale := by ring
    · exact central.2.2

end VandaeleCorollary3ControlledQuantumAdderResource
end QuantumBlockEncoding
