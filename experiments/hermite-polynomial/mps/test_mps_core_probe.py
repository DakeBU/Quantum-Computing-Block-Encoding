"""Finite discriminators, no-dense scaling, and retained obstructions."""
from fractions import Fraction
import math
import unittest
from unittest import mock
import numpy as np
import mps_core_probe as mps


class ExplicitCoreTests(unittest.TestCase):
    def test_all_thresholds_both_orderings(self):
        for n in range(1, 6):
            for cutoff in range((1 << n)+1):
                for kind in ("lt", "ge"):
                    tt = mps.threshold_tt(n, cutoff, kind)
                    expected = [float(j < cutoff if kind == "lt" else j >= cutoff)
                                for j in range(1 << n)]
                    np.testing.assert_array_equal(tt.small_dense_diagnostic(), expected)
                    self.assertLessEqual(tt.max_bond, 2)

    def test_translation_polynomial_core(self):
        coeff = np.array([1., -2., 3., -4., 0.5])
        for n in range(1, 7):
            tt = mps.polynomial_tt(n, -0.3, 1/(1 << n), coeff)
            expected = [sum(c*(-0.3+j/(1 << n))**r for r, c in enumerate(coeff))
                        for j in range(1 << n)]
            np.testing.assert_allclose(tt.small_dense_diagnostic(), expected, atol=2e-14)

    def test_rational_cutoff_interval_small_and_large(self):
        for n in (1, 5, 64, 128):
            for length in (Fraction(1, 10), Fraction(1, 2), Fraction(1), Fraction(300)):
                cutoff, terms = mps.left_cutoff(n, length)
                low, high = mps.pi_interval(terms)
                self.assertLess(low, high)
                for pi in (low, high):
                    count = 1 << n
                    if cutoff > 0:
                        self.assertLess(-pi*length+2*pi*length*(cutoff-1)/count, -1)
                    if cutoff < count//2:
                        self.assertGreaterEqual(-pi*length+2*pi*length*cutoff/count, -1)

    def test_cutoff_fail_closed(self):
        with self.assertRaises(ArithmeticError):
            mps.left_cutoff(128, Fraction(1), max_terms=8)
        for n, length in ((0, Fraction(1)), (2, Fraction(0)), (2, Fraction(-1))):
            with self.assertRaises(ValueError):
                mps.left_cutoff(n, length)

    def test_hermite_small_width_msb_contraction_lsb_basis(self):
        for n, k, length in ((1, 0, "1/10"), (2, 1, "1"), (5, 2, "1/2"), (7, 3, "1")):
            result = mps.finite_discriminator(n, k, Fraction(length))
            self.assertLess(result["max_amplitude_error"], 2e-8)
            self.assertLess(result["state_error"], 2e-8)
            self.assertLess(result["row_isometry_error"], 1e-12)
            self.assertEqual(result["last_bond"], 1)

    def test_large_constructor_never_needs_dense_or_svd(self):
        with mock.patch.object(mps.TT, "small_dense_diagnostic", side_effect=AssertionError("dense forbidden")), \
                mock.patch.object(np.linalg, "svd", side_effect=AssertionError("SVD forbidden")):
            for n in (32, 64, 128):
                tt, metadata = mps.hermite_tt(n, 2, Fraction(1))
                canonical, norm = mps.right_canonicalize(tt)
                self.assertTrue(math.isfinite(norm) and norm > 0)
                self.assertLessEqual(tt.max_bond, 28)
                self.assertLessEqual(tt.scalar_count, n*2*28**2)
                self.assertLess(mps.row_isometry_error(canonical), 1e-12)
                self.assertFalse(metadata["dense_constructor_input"])

    def test_dense_diagnostic_refuses_large_width(self):
        tt, _ = mps.hermite_tt(32, 0, Fraction(1))
        with self.assertRaises(ValueError):
            tt.small_dense_diagnostic()

    def test_retains_monomial_conditioning_counterexample(self):
        result = mps.finite_discriminator(8, 8, Fraction(10))
        self.assertGreater(result["max_amplitude_error"], 1)
        self.assertGreater(result["state_error"], 0.1)

    def test_retains_exponential_overflow_counterexample(self):
        with self.assertRaises(OverflowError):
            mps.hermite_tt(8, 2, Fraction(300))


if __name__ == "__main__":
    unittest.main()
