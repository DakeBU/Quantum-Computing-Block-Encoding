import QuantumBlockEncoding.BasisHellinger
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
`FC-WO-reset-basis-v1`: a finite computational-basis reset process. Each block
evaluates a specified chronological word at one selected arm oracle on the SAME
fresh normalized input. Only a list of classical measurement outcomes is carried
to the next block; no quantum output state appears in the policy or history law.

This model refinement supplies actual PMFs from coordinate Born probabilities.
It does not supply an estimator, arbitrary POVM, known-state-loading circuit,
reflection gate, finite-bit compiler, stopping rule or horizon clipping theorem.
-/
namespace QuantumBlockEncoding.ResetBlockProcess

open scoped Matrix.Norms.L2Operator

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Computational-basis PMF, with its normalization derived from the actual
coordinate probabilities of a normalized vector. -/
noncomputable def basisPMF (x : EuclideanSpace ℂ ι) (hx : ‖x‖ = 1) : PMF ι :=
  PMF.ofFintype (fun j => ENNReal.ofReal (BasisHellinger.basisProbability x j)) (by
    rw [← ENNReal.ofReal_sum_of_nonneg
      (fun j _ => BasisHellinger.basisProbability_nonneg x j)]
    rw [BasisHellinger.basisProbability_normalized x hx, ENNReal.ofReal_one])

theorem basisPMF_apply (x : EuclideanSpace ℂ ι) (hx : ‖x‖ = 1) (j : ι) :
    basisPMF x hx j = ENNReal.ofReal (BasisHellinger.basisProbability x j) := rfl

/-- An actual bounded same-arm word; both forward and inverse calls are charged
by the existing syntactic query count. Known gates carry their unitary certificates. -/
structure Plan (K D : ℕ) (ι : Type*) [Fintype ι] [DecidableEq ι] where
  arm : Fin K
  word : QuantumQueryWord.Word ι
  bounded : QuantumQueryWord.queryCount word ≤ D

/-- The block law is the measured output of the specified word, evaluated at the
selected arm, not an assumed estimator distribution. -/
noncomputable def blockPMF {K D : ℕ} (plan : Plan K D ι)
    (oracle : Fin K → Matrix.unitaryGroup ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1) : PMF ι :=
  basisPMF (BasisHellinger.wordOutput plan.word (oracle plan.arm) ψ) (by
    rw [BasisHellinger.wordOutput_norm plan.word (oracle plan.arm) ψ
      (oracle plan.arm).property, hψ])

theorem blockPMF_apply {K D : ℕ} (plan : Plan K D ι)
    (oracle : Fin K → Matrix.unitaryGroup ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1) (j : ι) :
    blockPMF plan oracle ψ hψ j = ENNReal.ofReal
      (BasisHellinger.basisProbability
        (BasisHellinger.wordOutput plan.word (oracle plan.arm) ψ) j) := rfl

/-- The policy is passed once and sees only classical history. At every step the
same fresh ψ is used, and the only stored result is the appended basis outcome. -/
noncomputable def historyLaw {K D : ℕ} (policy : List ι → Plan K D ι)
    (oracle : Fin K → Matrix.unitaryGroup ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1) : ℕ → PMF (List ι)
  | 0 => PMF.pure []
  | n + 1 => (historyLaw policy oracle ψ hψ n).bind fun h =>
      (blockPMF (policy h) oracle ψ hψ).bind fun j => PMF.pure (h ++ [j])

/-- The constructed law has exactly n classical outcomes in every supported
history; this is derived from the real bind/pure support, not an assumed invariant. -/
theorem historyLaw_length_support {K D : ℕ}
    (policy : List ι → Plan K D ι)
    (oracle : Fin K → Matrix.unitaryGroup ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1) (n : ℕ) :
    ∀ h ∈ (historyLaw policy oracle ψ hψ n).support, h.length = n := by
  induction n with
  | zero =>
      intro h hh
      have heq : h = [] := (PMF.mem_support_pure_iff [] h).mp hh
      simp [heq]
  | succ n ih =>
      intro h hh
      obtain ⟨previous, hprevious, hblock⟩ := (PMF.mem_support_bind_iff _ _ h).mp hh
      obtain ⟨j, _, hout⟩ := (PMF.mem_support_bind_iff _ _ h).mp hblock
      have heq : h = previous ++ [j] := (PMF.mem_support_pure_iff _ h).mp hout
      simp [heq, ih previous hprevious]

/-- Exact charged query cost along the classical prefixes: the existing
`QuantumQueryWord.queryCount_eq` charges forward plus inverse calls at each block. -/
def historyQueryCost {K D : ℕ} (policy : List ι → Plan K D ι) (h : List ι) : ℕ :=
  (Finset.range h.length).sum
    (fun t => QuantumQueryWord.queryCount (policy (h.take t)).word)

theorem historyQueryCost_le {K D : ℕ} (policy : List ι → Plan K D ι) (h : List ι) :
    historyQueryCost policy h ≤ h.length * D := by
  unfold historyQueryCost
  calc
    _ ≤ (Finset.range h.length).sum (fun _ => D) :=
      Finset.sum_le_sum (fun t _ => (policy (h.take t)).bounded)
    _ = _ := by simp

theorem historyLaw_queryCost_le {K D : ℕ}
    (policy : List ι → Plan K D ι)
    (oracle : Fin K → Matrix.unitaryGroup ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1) (n : ℕ) :
    ∀ h ∈ (historyLaw policy oracle ψ hψ n).support,
      historyQueryCost policy h ≤ n * D := by
  intro h hh
  have hlength := historyLaw_length_support policy oracle ψ hψ n h hh
  simpa only [hlength] using historyQueryCost_le policy h

/-- Comparison to a supplied total budget, without introducing stopping/clipping. -/
theorem historyLaw_queryCost_le_budget {K D : ℕ}
    (policy : List ι → Plan K D ι)
    (oracle : Fin K → Matrix.unitaryGroup ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1) (n : ℕ)
    {T : ℕ} (hT : n * D ≤ T) :
    ∀ h ∈ (historyLaw policy oracle ψ hψ n).support,
      historyQueryCost policy h ≤ T := by
  intro h hh
  exact (historyLaw_queryCost_le policy oracle ψ hψ n h hh).trans hT

end QuantumBlockEncoding.ResetBlockProcess
