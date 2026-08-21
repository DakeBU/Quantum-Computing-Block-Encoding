import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleGateUnusedWireParity
import QuantumBlockEncoding.ReversibleSchedule
import QuantumBlockEncoding.VandaeleParityCore
import Mathlib.GroupTheory.Perm.Sign
import Mathlib.Tactic

/-!
# Evenness of X/CX/CCX circuits on at least four qubits

Each logical gate in ASPBE's reversible IR touches at most three physical
qubits. Therefore on a register with at least four qubits every gate has one
unused spectator wire. `ReversibleGateUnusedWireParity` shows that any gate
with such a spectator is even. Multiplicativity of permutation sign then makes
every X/CX/CCX circuit even.

Combining this with `VandaeleParityCore.multiControlledX_sign = -1` gives the
source parity obstruction: for k>=3, C^k X acts on k+1>=4 data qubits and cannot
be implemented ancilla-free over {X,CX,CCX}.
-/

namespace QuantumBlockEncoding
namespace ReversibleGateParityLowerBound

open PrimitiveBasisRegisterSplit
open ReversibleGateUnusedWireParity
open VandaeleParityCore
open VandaeleLemma1Contract

/-- Finite set of wires touched by one logical reversible gate. -/
def touchedFinset {q : Nat} (gate : ReversibleGate q) : Finset (Fin q) :=
  match gate with
  | .x target => {target}
  | .cx control target _ => {control, target}
  | .ccx control0 control1 target _ _ _ => {control0, control1, target}

/-- Membership in the finite support is exactly the semantic `touches` predicate. -/
theorem mem_touchedFinset_iff
    {q : Nat} (gate : ReversibleGate q) (wire : Fin q) :
    wire ∈ touchedFinset gate ↔ gate.touches wire := by
  cases gate with
  | x target =>
      simp [touchedFinset, ReversibleGate.touches]
  | cx control target distinct =>
      simp [touchedFinset, ReversibleGate.touches, or_comm]
  | ccx control0 control1 target c01 c0t c1t =>
      simp [touchedFinset, ReversibleGate.touches,
        or_assoc, or_left_comm, or_comm]

/-- Every gate touches at most three distinct wires. -/
theorem touchedFinset_card_le_three
    {q : Nat} (gate : ReversibleGate q) :
    (touchedFinset gate).card ≤ 3 := by
  cases gate <;> simp [touchedFinset]

/-- On q>=4 wires, every X/CX/CCX gate has an unused spectator qubit. -/
theorem exists_unused_wire
    {q : Nat} (large : 4 ≤ q)
    (gate : ReversibleGate q) :
    ∃ spectator : Fin q, ¬ gate.touches spectator := by
  by_contra noUnused
  push_neg at noUnused
  have everyMem : (Finset.univ : Finset (Fin q)) ⊆ touchedFinset gate := by
    intro wire _
    exact (mem_touchedFinset_iff gate wire).2 (noUnused wire)
  have cardLower := Finset.card_le_card everyMem
  have cardUpper := touchedFinset_card_le_three gate
  have univCard : (Finset.univ : Finset (Fin q)).card = q := by simp
  rw [univCard] at cardLower
  omega

/-- Every primitive reversible gate is even on a register of width at least 4. -/
theorem gate_sign_eq_one
    {q : Nat} (large : 4 ≤ q)
    (gate : ReversibleGate q) :
    Equiv.Perm.sign (evalReversibleGate gate) = 1 := by
  rcases exists_unused_wire large gate with ⟨spectator, unused⟩
  exact sign_eq_one_of_unused gate spectator unused

/-- Any finite X/CX/CCX program on q>=4 wires is even. -/
theorem program_sign_eq_one
    {q : Nat} (large : 4 ≤ q)
    (program : ReversibleProgram q) :
    Equiv.Perm.sign (evalReversibleProgram program) = 1 := by
  induction program with
  | nil => rfl
  | cons gate rest induction =>
      change
        Equiv.Perm.sign
          ((evalReversibleGate gate).trans (evalReversibleProgram rest)) = 1
      rw [Equiv.Perm.sign_trans]
      rw [gate_sign_eq_one large gate, induction]
      simp

/-- The unique one-bit basis is canonically Fin 2. -/
def oneBitEquiv : PrimitiveBasis 1 ≃ Fin 2 where
  toFun state := state ⟨0, by decide⟩
  invFun bit := fun _ => bit
  left_inv state := by
    funext wire
    fin_cases wire
    rfl
  right_inv bit := rfl

/-- Flat `(k+1)`-wire basis identified with k controls and one target bit. -/
def flatControlTargetEquiv (k : Nat) :
    PrimitiveBasis (k + 1) ≃ PrimitiveBasis k × Fin 2 :=
  (basisSplitEquiv k 1).trans
    (Equiv.prodCongr (Equiv.refl (PrimitiveBasis k)) oneBitEquiv)

/-- Canonical flat-register C^k X target obtained by transporting Definition 2.1
through the register equivalence. -/
def flatMultiControlledXEquiv (k : Nat) :
    Equiv.Perm (PrimitiveBasis (k + 1)) :=
  (flatControlTargetEquiv k).symm.permCongr (multiControlledXEquiv k)

/-- Flat transport does not change the odd sign of C^k X. -/
theorem flatMultiControlledX_sign (k : Nat) :
    Equiv.Perm.sign (flatMultiControlledXEquiv k) = -1 := by
  unfold flatMultiControlledXEquiv
  rw [Equiv.Perm.sign_permCongr]
  exact multiControlledX_sign k

/-- An ancilla-free X/CX/CCX program cannot realize C^k X once k>=3. -/
theorem no_ancilla_program_for_multiControlledX
    {k : Nat} (large : 3 ≤ k)
    (program : ReversibleProgram (k + 1)) :
    evalReversibleProgram program ≠ flatMultiControlledXEquiv k := by
  intro equal
  have qLarge : 4 ≤ k + 1 := by omega
  have evenProgram := program_sign_eq_one qLarge program
  rw [equal, flatMultiControlledX_sign] at evenProgram
  norm_num at evenProgram

/-- Source-facing existence form of the parity obstruction: no ancilla-free
reversible program exists for k>=3. -/
theorem no_ancilla_exists
    {k : Nat} (large : 3 ≤ k) :
    ¬ ∃ program : ReversibleProgram (k + 1),
      evalReversibleProgram program = flatMultiControlledXEquiv k := by
  rintro ⟨program, correct⟩
  exact no_ancilla_program_for_multiControlledX large program correct

end ReversibleGateParityLowerBound
end QuantumBlockEncoding
