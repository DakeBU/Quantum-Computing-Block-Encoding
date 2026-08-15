#!/usr/bin/env python3
from pathlib import Path

module = Path('QuantumBlockEncoding/GHLHamiltonian.lean')
text = module.read_text(encoding='utf-8')

if 'theorem adjoint_sumTerms' not in text:
    anchor = '''@[simp] theorem sumTerms_entry {η : Type*} [Fintype η]
    (terms : η → CMatrix ι ι) (i j : ι) :
    sumTerms terms i j = ∑ k, terms k i j := rfl
'''
    insertion = anchor + '''
/-- Taking the adjoint commutes with the paper's finite sum of one-term matrices. -/
theorem adjoint_sumTerms {η : Type*} [Fintype η]
    (terms : η → CMatrix ι ι) :
    adjoint (sumTerms terms) = sumTerms (fun k => adjoint (terms k)) := by
  funext i j
  simp [adjoint, sumTerms]
'''
    if anchor not in text:
        raise SystemExit('sumTerms anchor missing')
    text = text.replace(anchor, insertion, 1)

if 'def Adagger (cert' not in text:
    anchor = '''def A (cert : OneDimCompositionCertificate η ι ξ) : CMatrix ι ι :=
  sumTerms cert.terms
'''
    insertion = anchor + '''
/-- `A†`, exposed as a named stage because Theorem 4 combines both `A` and `A†`. -/
def Adagger (cert : OneDimCompositionCertificate η ι ξ) : CMatrix ι ι :=
  adjoint cert.A

/-- The adjoint assembled from the one-term adjoints equals the adjoint of `A`. -/
theorem Adagger_eq_sum_term_adjoints
    (cert : OneDimCompositionCertificate η ι ξ) :
    cert.Adagger = sumTerms (fun k => adjoint (cert.terms k)) := by
  exact adjoint_sumTerms cert.terms
'''
    if anchor not in text:
        raise SystemExit('certificate A anchor missing')
    text = text.replace(anchor, insertion, 1)

module.write_text(text, encoding='utf-8')

test = Path('ABEISTests/GHLHamiltonian.lean')
t = test.read_text(encoding='utf-8')
if 'Adagger_eq_sum_term_adjoints' not in t:
    anchor = '''example (cert : OneDimCompositionCertificate η ι ξ) :
    ∀ i j,
      cert.S i j = cert.first i j + Complex.I * cert.second i j :=
  cert.S_decomposition
'''
    insertion = '''example (cert : OneDimCompositionCertificate η ι ξ) :
    cert.Adagger = sumTerms (fun k => adjoint (cert.terms k)) :=
  cert.Adagger_eq_sum_term_adjoints

''' + anchor
    if anchor not in t:
        raise SystemExit('test insertion anchor missing')
    t = t.replace(anchor, insertion, 1)
    test.write_text(t, encoding='utf-8')
