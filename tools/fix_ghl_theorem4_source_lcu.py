#!/usr/bin/env python3
from pathlib import Path

path = Path('QuantumBlockEncoding/GHLHamiltonian.lean')
text = path.read_text(encoding='utf-8')

# 1. The printed Eq. (29) lower-right check also needs the X⊗B definition
# unfolded; it is identically zero on the lower-right block. Once unfolded,
# simp closes the scalar identity directly.
old = '''  simp [eq29PrintedClean, add, scale, scaledControlledPhaseSource]\n  ring\n'''
new = '''  simp [eq29PrintedClean, add, scale, scaledControlledPhaseSource, pauliXTensor]\n'''
if old in text:
    text = text.replace(old, new, 1)
elif new not in text:
    raise SystemExit('eq29PrintedClean_lowerRight anchor missing')

# 2. After simplification the contradiction is already normalizerA = 0.
text = text.replace('  exact hN (neg_eq_zero.mp hentry)\n', '  exact hN hentry\n', 1)

# 3. In the phase-balanced S1 lower-right diagonal branch, simp already
# closes the goal; a following ring produced "no goals to be solved".
old = '''          · subst j\n            simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,\n              pauliXTensor, S1, hermitianPart, homogenizedS]\n            ring\n'''
new = '''          · subst j\n            simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,\n              pauliXTensor, S1, hermitianPart, homogenizedS]\n'''
if old in text:
    text = text.replace(old, new, 1)

old = '''          · have hji : j ≠ i := fun h => hij h.symm\n            simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,\n              pauliXTensor, S1, hermitianPart, homogenizedS, hij, hji]\n'''
new = '''          · simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,\n              pauliXTensor, S1, hermitianPart, homogenizedS, hij]\n'''
if old in text:
    text = text.replace(old, new, 1)

# 4. Eq. (30) reduces to I^2 = -1 after clearing denominators.
marker = 'theorem eq30Clean_eq_S2'
pos = text.find(marker)
if pos < 0:
    raise SystemExit('eq30Clean_eq_S2 marker missing')
head, tail = text[:pos], text[pos:]
tail = tail.replace(
    '''          field_simp [hI]\n          ring\n''',
    '''          field_simp [hI]\n          simp [pow_two, Complex.I_mul_I]\n''',
    3,
)
# The lower-right diagonal branch does not need ring either when simp closes it.
tail = tail.replace(
    '''          · subst j\n            simp [eq30Clean, add, scale, scaledControlledPhaseSource,\n              pauliYTensor, S2, antiHermitianPart, homogenizedS]\n            ring\n''',
    '''          · subst j\n            simp [eq30Clean, add, scale, scaledControlledPhaseSource,\n              pauliYTensor, S2, antiHermitianPart, homogenizedS]\n''',
    1,
)
tail = tail.replace(
    '''          · have hji : j ≠ i := fun h => hij h.symm\n            simp [eq30Clean, add, scale, scaledControlledPhaseSource,\n              pauliYTensor, S2, antiHermitianPart, homogenizedS, hij, hji]\n''',
    '''          · simp [eq30Clean, add, scale, scaledControlledPhaseSource,\n              pauliYTensor, S2, antiHermitianPart, homogenizedS, hij]\n''',
    1,
)
text = head + tail

# 5. The aggregate theorem was inserted before tensor and the certificate were
# defined. Move it after the existing late claim/resource roots.
root_marker = '/--\nSingle proof root for the paper-level Theorem 4 composition.'
root_start = text.find(root_marker)
if root_start < 0:
    raise SystemExit('theorem4 aggregate root marker missing')
root_end_token = '  · rfl\n'
root_end = text.find(root_end_token, root_start)
if root_end < 0:
    raise SystemExit('theorem4 aggregate root end missing')
root_end += len(root_end_token)
root = text[root_start:root_end]
text = text[:root_start] + text[root_end:]

late_anchor = '''/-- Theorem 4's resource expression is the registered source expression. -/\ntheorem oneDimHamiltonianClaim_resource_closed :\n    oneDimHamiltonianClaim.resource = oneDimHamiltonianResourceExpr := by\n  rfl\n'''
if late_anchor not in text:
    raise SystemExit('late Theorem 4 resource anchor missing')
text = text.replace(late_anchor, late_anchor + '\n' + root, 1)

path.write_text(text, encoding='utf-8')
