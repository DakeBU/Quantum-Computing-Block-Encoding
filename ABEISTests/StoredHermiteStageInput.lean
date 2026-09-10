import QuantumBlockEncoding.StoredHermiteStageInput

namespace QuantumBlockEncoding.StoredHermiteStageInputTests

open StoredGivens StoredHermiteStageInput

example (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1)) :
    StoredHermiteStageFields.CacheCorrect n t.val L
      (input (StoredHermiteSourceCache.compile k n L).run.value t).run.value :=
  inputCorrect k n L hL t

-- N=1: parent, remaining-width span and midpoint all use valid index zero.
example (L : ℝ) (hL : 0 < L) :
    StoredHermiteStageFields.CacheCorrect 0 0 L
      (input (StoredHermiteSourceCache.compile 0 0 L).run.value 0).run.value :=
  inputCorrect 0 0 L hL 0

-- Boundary fixtures exercise the exact -1 and empty-middle source regimes.
example (n : ℕ) (t : Fin (n+1)) :
    StoredHermiteStageFields.CacheCorrect n t.val (1 / Real.pi)
      (input (StoredHermiteSourceCache.compile 0 n (1 / Real.pi)).run.value t).run.value :=
  inputCorrect 0 n (1 / Real.pi) (by positivity) t

example : StoredHermiteStageFields.CacheCorrect 0 0 (2 / Real.pi)
    (input (StoredHermiteSourceCache.compile 0 0 (2 / Real.pi)).run.value 0).run.value :=
  inputCorrect 0 0 (2 / Real.pi) (by positivity) 0

-- Explicitly checks that midpoint is the cached last span, not a new Nat.pow.
example {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) (t : Fin (n+1)) :
    (load cache t).value.midpoint = cache.spans[n] := by
  rw [load_value]
  rfl

example (k n : ℕ) (L : ℝ) (t : Fin (n+1)) :
    (load (StoredHermiteSourceCache.compile k n L).run.value t).value.midpoint = 2^n := by
  rw [load_value]
  exact StoredHermiteSourceCache.compile_spans k n L (Fin.last n)

example (k n : ℕ) (L : ℝ) :
    (load (StoredHermiteSourceCache.compile k n L).run.value (Fin.last n)).value.span = 1 := by
  rw [load_value]
  change (StoredHermiteSourceCache.compile k n L).run.value.spans[n-n] = 1
  simpa using StoredHermiteSourceCache.compile_spans k n L ⟨n-n, by omega⟩

example {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) (t : Fin (n+1)) :
    (load cache t).cost .read = 11 := by simp [load_cost, tick]

example {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) (t : Fin (n+1)) :
    (input cache t).run.cost .read = 29 ∧ (input cache t).run.cost .write = 31 := by
  simp [input_cost, tick]

example {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) (t : Fin (n+1)) :
    (∑ op : Op, (input cache t).run.cost op) = 86 ∧ (input cache t).integerAdditions = 4 :=
  ⟨input_total_cost cache t, input_integerAdditions cache t⟩

example (k : ℕ) (L : ℝ) (hL : 0 < L) :
    StoredHermiteStageFields.CacheCorrect 127 0 L
      (input (StoredHermiteSourceCache.compile k 127 L).run.value 0).run.value :=
  inputCorrect k 127 L hL 0

#print axioms inputCorrect
#print axioms input_certified
#print axioms input_cost
#print axioms input_integerAdditions

end QuantumBlockEncoding.StoredHermiteStageInputTests
