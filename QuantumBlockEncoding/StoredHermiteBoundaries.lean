import QuantumBlockEncoding.HermiteExplicitBond
import QuantumBlockEncoding.StoredGivens
import QuantumBlockEncoding.StoredRectangularGivens

/-!
source-boundary supplier. The cutoff and midpoint are stored
integer inputs, not free source oracles. Two equality tests produce shared
initial flags; every vector entry is materialized. A conservative fixed
12-comparison envelope covers the explicit finite sum/option tag dispatch.
Natural index arithmetic and bit complexity remain outside this exact-real
word model. There is no exponential or source-sample evaluation here.
-/

namespace QuantumBlockEncoding.StoredHermiteBoundaries

open StoredGivens HermiteBoundaryInjection

def initialLiteral {k : ℕ} (left middle : Bool) : HermiteFiniteBond k → ℝ
  | .inl none => if left then 1 else 0
  | .inl (some _) => 0
  | .inr (.inl none) => if middle then 1 else 0
  | .inr (.inl (some _)) => 0
  | .inr (.inr _) => 1

def terminalLiteral {k : ℕ} : HermiteFiniteBond k → ℝ
  | .inl none => 0
  | .inl (some _) => 1
  | .inr (.inl none) => 0
  | .inr (.inl (some j)) => if j.val = 0 then 1 else 0
  | .inr (.inr _) => 1

def initial (k cut midpoint : ℕ) : Run (Vector ℝ (2*k+6)) := do
  let left ← charge .compare (decide (cut ≠ 0))
  let middle ← charge .compare (decide (cut ≠ midpoint))
  collect fun i =>
    ⟨initialLiteral left middle (HermiteExplicitBond.bondEquiv k i),
      12 • tick .compare⟩

def terminal (k : ℕ) : Run (Vector ℝ (2*k+6)) :=
  collect fun i =>
    ⟨terminalLiteral (HermiteExplicitBond.bondEquiv k i), 12 • tick .compare⟩

theorem initial_get (k cut midpoint : ℕ) (i : Fin (2*k+6)) :
    (initial k cut midpoint).value[i.val] =
      initialLiteral (decide (cut ≠ 0)) (decide (cut ≠ midpoint))
        (HermiteExplicitBond.bondEquiv k i) := by
  simp only [initial, bind, Run.bind, charge, collect_value]

theorem terminal_get (k : ℕ) (i : Fin (2*k+6)) :
    (terminal k).value[i.val] = terminalLiteral (HermiteExplicitBond.bondEquiv k i) := by
  simp only [terminal, collect_value]

theorem initial_value (k n : ℕ) (L : ℝ) (cut : ℕ)
    (hcut : cut = cutIndex n L) (i : Fin (2*k+6)) :
    (initial k cut (2^n)).value[i.val] = HermiteExplicitBond.initial k n L i := by
  subst cut
  simp only [initial, bind, Run.bind, charge, collect_value,
    HermiteExplicitBond.initial, hermiteInitial]
  generalize HermiteExplicitBond.bondEquiv k i = a
  rcases a with a | a
  · cases a <;> simp [initialLiteral, leftInitial]
  · rcases a with a | a
    · cases a <;> simp [initialLiteral, middleInitial]
    · rfl

theorem terminal_value (k : ℕ) (i : Fin (2*k+6)) :
    (terminal k).value[i.val] = HermiteExplicitBond.terminal k i := by
  simp only [terminal, collect_value, HermiteExplicitBond.terminal, hermiteTerminal]
  generalize HermiteExplicitBond.bondEquiv k i = a
  rcases a with a | a
  · cases a <;> rfl
  · rcases a with a | a
    · cases a <;> rfl
    · rfl

theorem initial_cost (k cut midpoint : ℕ) (op : Op) :
    (initial k cut midpoint).cost op = 2*tick .compare op +
      (2*k+6)*(12*tick .compare op+2*tick .read op+2*tick .write op) := by
  simp [initial, bind, Run.bind, charge, collect_cost]
  ring

theorem terminal_cost (k : ℕ) (op : Op) :
    (terminal k).cost op =
      (2*k+6)*(12*tick .compare op+2*tick .read op+2*tick .write op) := by
  simp [terminal, collect_cost]
  ring

theorem initial_total_cost (k cut midpoint : ℕ) :
    StoredRectangularGivens.total (initial k cut midpoint).cost = 16*(2*k+6)+2 := by
  simp [StoredRectangularGivens.total, initial_cost, tick]
  ring

theorem terminal_total_cost (k : ℕ) :
    StoredRectangularGivens.total (terminal k).cost = 16*(2*k+6) := by
  simp [StoredRectangularGivens.total, terminal_cost, tick]
  ring


end QuantumBlockEncoding.StoredHermiteBoundaries
