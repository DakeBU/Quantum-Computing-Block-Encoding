import QuantumBlockEncoding.VandaeleLadderContract
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Appendix A.2 resource closure for Vandaele Corollary 1

Appendix A.2 generalizes Lemma 4 from the second-order ladder to `L_k^(n)`.
The source proof has two resource components:

* the recursive middle ladder is an `L_2` instance and therefore inherits the
  Lemma-4 `O(n)` gate / `O(log n)` depth / `n`-workspace bound;
* the first two and last two layers consist of `C^k X` gates. Across the four
  layers there are at most `4n` such gates, while gates inside one layer may be
  scheduled in parallel. Lemma 1 supplies `O(k)` gates and `O(log k)` depth per
  multi-controlled-X primitive.

This file ties those two *actual resource functions* together and proves the
existing `CorollaryOneUniformResourceTarget`. It is deliberately an envelope:
a concrete Appendix-(63) schedule must still refine the same semantic ladder
and fit these component counts.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary1ResourceClosure

open VandaeleLadderContract
open VandaeleLemma1Contract

/-- Conservative gate envelope for Appendix A.2. `localControls + 1` is the
source control order k. -/
def gateEnvelope
    (lemmaFourGate : Nat -> Nat)
    (multiXGate : Nat -> Nat)
    (localControls steps : Nat) : Nat :=
  lemmaFourGate steps +
    4 * steps * multiXGate (localControls + 1)

/-- Conservative chronological depth envelope. For an empty ladder the outer
layers are absent; otherwise at most four multi-control layers surround the
middle Lemma-4 recursion. -/
def depthEnvelope
    (lemmaFourDepth : Nat -> Nat)
    (multiXDepth : Nat -> Nat)
    (localControls steps : Nat) : Nat :=
  lemmaFourDepth steps +
    if steps = 0 then 0 else 4 * multiXDepth (localControls + 1)

/-- Workspace is inherited unchanged from Lemma 4. -/
def ancillaEnvelope
    (lemmaFourAncillas : Nat -> Nat)
    (_localControls steps : Nat) : Nat :=
  lemmaFourAncillas steps

/-- Appendix A.2 resource composition closes Corollary 1 uniformly. -/
theorem appendixA2_closes_corollaryOne
    (lemmaFourGate lemmaFourDepth lemmaFourAncillas : Nat -> Nat)
    (multiXGate multiXDepth multiXDirty : Nat -> Nat)
    (lemmaFourResources :
      LemmaFourUniformResourceTarget
        lemmaFourGate lemmaFourDepth lemmaFourAncillas)
    (multiXResources :
      LemmaOneUniformResourceTarget
        multiXGate multiXDepth multiXDirty) :
    CorollaryOneUniformResourceTarget
      (gateEnvelope lemmaFourGate multiXGate)
      (depthEnvelope lemmaFourDepth multiXDepth)
      (ancillaEnvelope lemmaFourAncillas) := by
  rcases lemmaFourResources with
    ⟨lemmaFourGateConstant, lemmaFourDepthConstant, lemmaFourBounds⟩
  rcases multiXResources with
    ⟨multiGateConstant, multiDepthConstant, multiBounds⟩
  refine ⟨lemmaFourGateConstant + 8 * multiGateConstant,
    lemmaFourDepthConstant + 4 * multiDepthConstant, ?_⟩
  intro localControls steps
  let scale := (localControls + 1) * steps + 1
  have scalePos : 1 <= scale := by
    simp [scale]
  have stepsScale : steps + 1 <= scale := by
    dsimp [scale]
    nlinarith
  have lemmaFour := lemmaFourBounds steps
  have multi := multiBounds (localControls + 1)
  have lemmaFourGateGlobal :
      lemmaFourGate steps <= lemmaFourGateConstant * scale :=
    lemmaFour.1.trans
      (Nat.mul_le_mul_left lemmaFourGateConstant stepsScale)
  have orderFactor : localControls + 2 <= 2 * (localControls + 1) := by
    omega
  have multiGatePerUse :
      multiXGate (localControls + 1) <=
        2 * multiGateConstant * (localControls + 1) := by
    calc
      multiXGate (localControls + 1) <=
          multiGateConstant * (localControls + 2) := multi.1
      _ <= multiGateConstant * (2 * (localControls + 1)) :=
        Nat.mul_le_mul_left multiGateConstant orderFactor
      _ = 2 * multiGateConstant * (localControls + 1) := by ring
  have outerGateGlobal :
      4 * steps * multiXGate (localControls + 1) <=
        (8 * multiGateConstant) * scale := by
    calc
      4 * steps * multiXGate (localControls + 1) <=
          4 * steps * (2 * multiGateConstant * (localControls + 1)) :=
        Nat.mul_le_mul_left (4 * steps) multiGatePerUse
      _ = (8 * multiGateConstant) * ((localControls + 1) * steps) := by ring
      _ <= (8 * multiGateConstant) * scale := by
        apply Nat.mul_le_mul_left
        dsimp [scale]
        omega
  constructor
  · unfold gateEnvelope
    calc
      lemmaFourGate steps + 4 * steps * multiXGate (localControls + 1) <=
          lemmaFourGateConstant * scale +
            (8 * multiGateConstant) * scale :=
        Nat.add_le_add lemmaFourGateGlobal outerGateGlobal
      _ = (lemmaFourGateConstant + 8 * multiGateConstant) * scale := by ring
  · constructor
    · have middleLogArg : steps + 1 <= scale := stepsScale
      have middleLog :
          Nat.log2 (steps + 1) <= Nat.log2 scale := by
        rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
        exact Nat.log_mono_right middleLogArg
      have lemmaFourDepthGlobal :
          lemmaFourDepth steps <=
            lemmaFourDepthConstant * corollaryOneDepthScale localControls steps := by
        have source := lemmaFour.2.1
        unfold corollaryOneDepthScale
        exact source.trans
          (Nat.mul_le_mul_left lemmaFourDepthConstant (by omega))
      by_cases empty : steps = 0
      · subst steps
        simpa [depthEnvelope, corollaryOneDepthScale] using lemmaFourDepthGlobal
      · have stepsPositive : 1 <= steps := Nat.one_le_iff_ne_zero.2 empty
        have controlArg :
            localControls + 2 <= scale := by
          dsimp [scale]
          nlinarith
        have controlLog :
            VandaeleLemma1Contract.logScale (localControls + 1) <=
              corollaryOneDepthScale localControls steps := by
          unfold VandaeleLemma1Contract.logScale corollaryOneDepthScale
          rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
          exact Nat.add_le_add_right (Nat.log_mono_right controlArg) 1
        have outerDepthGlobal :
            4 * multiXDepth (localControls + 1) <=
              (4 * multiDepthConstant) *
                corollaryOneDepthScale localControls steps := by
          calc
            4 * multiXDepth (localControls + 1) <=
                4 * (multiDepthConstant *
                  VandaeleLemma1Contract.logScale (localControls + 1)) :=
              Nat.mul_le_mul_left 4 multi.2.1
            _ <= 4 * (multiDepthConstant *
                  corollaryOneDepthScale localControls steps) :=
              Nat.mul_le_mul_left 4
                (Nat.mul_le_mul_left multiDepthConstant controlLog)
            _ = (4 * multiDepthConstant) *
                corollaryOneDepthScale localControls steps := by ring
        unfold depthEnvelope
        rw [if_neg empty]
        calc
          lemmaFourDepth steps + 4 * multiXDepth (localControls + 1) <=
              lemmaFourDepthConstant *
                  corollaryOneDepthScale localControls steps +
                (4 * multiDepthConstant) *
                  corollaryOneDepthScale localControls steps :=
            Nat.add_le_add lemmaFourDepthGlobal outerDepthGlobal
          _ = (lemmaFourDepthConstant + 4 * multiDepthConstant) *
              corollaryOneDepthScale localControls steps := by ring
    · exact lemmaFour.2.2

end VandaeleCorollary1ResourceClosure
end QuantumBlockEncoding
