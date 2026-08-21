import QuantumBlockEncoding.VandaeleLemma3NaiveProgram
import QuantumBlockEncoding.VandaeleLemma4NaiveProgram

/-!
# Finite truth-table checks for the actual naive ladder programs

The arbitrary-width proofs are authoritative. These small native-decision checks
serve as admission diagnostics for the concrete gate syntax itself: if a wire
index or chronology is accidentally changed, a compact finite counterexample
appears close to the source program rather than only deep in downstream
comparator/incrementer builds.
-/

namespace QuantumBlockEncoding
namespace VandaeleNaiveLadderFiniteChecks

open VandaeleCorollary4ProgramFamily
open VandaeleLemma3NaiveProgram
open VandaeleLemma3ProgramFamily
open VandaeleLemma4NaiveProgram
open VandaeleLemma4ProgramFamily

/-- Four-step first-order reverse-CX ladder matches the complete Eq.-(5) truth
table. -/
theorem lemmaThree_fourStep_truthTable :
    LemmaThreeFlatSpec 4
      (evalReversibleProgram (VandaeleLemma3NaiveProgram.program 4)) := by
  native_decide

/-- Three-step second-order reverse-CCX ladder matches the clean Lemma-4 truth
table. -/
theorem lemmaFour_threeStep_clean_truthTable :
    LemmaFourCleanFlatSpec 3
      (evalReversibleProgram (VandaeleLemma4NaiveProgram.program 3)) := by
  native_decide

/-- The same finite second-order program restores all three workspace bits for
arbitrary incoming workspace contents, not only on the clean branch. -/
theorem lemmaFour_threeStep_strong_truthTable :
    LemmaFourStrongPromiseFlatSpec 3
      (evalReversibleProgram (VandaeleLemma4NaiveProgram.program 3)) := by
  native_decide

end VandaeleNaiveLadderFiniteChecks
end QuantumBlockEncoding
