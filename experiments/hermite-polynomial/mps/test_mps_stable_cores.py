from decimal import Decimal, localcontext
from fractions import Fraction
import math
import unittest
from unittest import mock
import numpy as np
from mps_core_probe import TT, right_canonicalize, source_value
from mps_stable_cores import positive_bernstein, stable_hermite_tt


class StableCoreTests(unittest.TestCase):
    def test_bernstein_matches_factored_source(self):
        with localcontext() as context:
            context.prec = 90
            for k in (0, 1, 2, 4, 8):
                coeff = positive_bernstein(k)
                d = 2*k+1
                self.assertGreaterEqual(min(coeff), 0)
                for t in (0., 0.1, 0.3, 0.9, 1.):
                    value = sum(float(c)*math.comb(d, r)*t**r*(1-t)**(d-r) for r, c in enumerate(coeff))
                    self.assertAlmostEqual(value, source_value(k, t-1), places=13)

    def test_repaired_previous_conditioning_and_overflow_cases(self):
        for n, k, length in ((1, 0, "1/10"), (7, 2, "1/2"), (8, 3, "1"),
                             (8, 4, "2"), (8, 8, "10"), (8, 2, "300"), (8, 8, "300")):
            raw, metadata = stable_hermite_tt(n, k, Fraction(length))
            actual = raw.small_dense_diagnostic()
            radius = math.pi*float(Fraction(length))
            expected = np.array([source_value(k, -radius+2*radius*j/(1 << n)) for j in range(1 << n)])
            self.assertLess(np.max(np.abs(actual-expected)), 3e-13)
            canonical, norm = right_canonicalize(raw)
            self.assertLess(np.linalg.norm(canonical.small_dense_diagnostic()-expected/np.linalg.norm(expected)), 3e-13)
            self.assertLess(abs(norm/np.linalg.norm(expected)-1), 3e-13)
            self.assertGreaterEqual(metadata["core_min"], 0)
            self.assertLessEqual(raw.max_bond, 2*k+6)

    def test_all_cutoff_shapes_and_basis_order(self):
        for n in range(1, 7):
            for length in ("1/100", "1/4", "1/2", "1", "2", "10", "300"):
                raw, _ = stable_hermite_tt(n, 2, Fraction(length))
                radius = math.pi*float(Fraction(length))
                for j in range(1 << n):
                    self.assertAlmostEqual(raw.amplitude(j), source_value(2, -radius+2*radius*j/(1 << n)), places=12)

    def test_large_widths_no_dense_no_svd(self):
        with mock.patch.object(TT, "small_dense_diagnostic", side_effect=AssertionError("dense forbidden")), \
                mock.patch.object(np.linalg, "svd", side_effect=AssertionError("SVD forbidden")):
            for n, k, length in ((64, 2, "1"), (128, 2, "1"), (128, 8, "10"), (128, 8, "300")):
                raw, metadata = stable_hermite_tt(n, k, Fraction(length))
                canonical, norm = right_canonicalize(raw)
                self.assertLessEqual(raw.max_bond, 2*k+6)
                self.assertLessEqual(raw.scalar_count, n*2*(2*k+6)**2)
                self.assertAlmostEqual(canonical.squared_norm(), 1, places=12)
                self.assertTrue(math.isfinite(norm) and norm > 0)
                self.assertGreaterEqual(metadata["core_min"], 0)
                self.assertAlmostEqual(raw.amplitude(1 << (n-1)), 1, places=14)


if __name__ == "__main__":
    unittest.main()
