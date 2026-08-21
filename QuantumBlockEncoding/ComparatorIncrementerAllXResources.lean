import QuantumBlockEncoding.ComparatorIncrementerAllX
import Mathlib.Tactic

/-!
# Logical resources of the arbitrary-width all-X program

This file records only resource claims justified directly by the reversible
program syntax.  It does not assign the controlled fan-out cost from Vandaele
Eq. (36); that requires a separate controlled construction.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerAllXResources

open ComparatorIncrementerAllX
open ReversibleRegisterLift

/-- Register shifting preserves the number of reversible instructions. -/
@[simp] theorem liftProgramSucc_length {n : Nat}
    (program : ReversibleProgram n) :
    (liftProgramSucc program).length = program.length := by
  simp [liftProgramSucc]

/-- The recursive all-X implementation contains exactly n instructions. -/
@[simp] theorem allXReversibleProgram_length (n : Nat) :
    (allXReversibleProgram n).length = n := by
  induction n with
  | zero => rfl
  | succ n induction =>
      simp [allXReversibleProgram, induction]

/-- Every instruction in the arbitrary-width all-X implementation is an X gate.
Together with the length theorem this certifies exactly n logical X gates and no
CX/CCX instructions at this un-controlled layer. -/
theorem allXReversibleProgram_only_x (n : Nat) :
    ∀ gate ∈ allXReversibleProgram n,
      ∃ target : Fin n, gate = ReversibleGate.x target := by
  induction n with
  | zero =>
      intro gate membership
      simp [allXReversibleProgram] at membership
  | succ n induction =>
      intro gate membership
      simp only [allXReversibleProgram, List.mem_cons] at membership
      rcases membership with head | tail
      · subst gate
        exact ⟨0, rfl⟩
      · change gate ∈ liftProgramSucc (allXReversibleProgram n) at tail
        rw [liftProgramSucc] at tail
        rcases List.mem_map.mp tail with ⟨oldGate, oldMembership, lifted⟩
        rcases induction oldGate oldMembership with ⟨target, targetShape⟩
        subst oldGate
        subst gate
        exact ⟨target.succ, rfl⟩

end ComparatorIncrementerAllXResources
end QuantumBlockEncoding
