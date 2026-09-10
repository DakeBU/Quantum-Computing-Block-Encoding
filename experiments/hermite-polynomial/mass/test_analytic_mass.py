import unittest
import math
from decimal import Decimal, localcontext
from analytic_mass import HermiteMass, power_sums, run_queries


class AnalyticMassTests(unittest.TestCase):
    def test_integer_power_sums(self):
        for degree in range(16):
            for count in (0, 1, 2, 7, 31):
                actual = power_sums(count, degree)
                self.assertEqual(actual, [sum(j**r for j in range(count)) for r in range(degree + 1)])

    def test_small_grid_independent_positive_formula(self):
        # Enumeration is restricted to the independent small-grid diagnostic.
        with localcontext() as context:
            context.prec = 100
            for k, n, length in ((0, 1, '.1'), (1, 3, '1'), (2, 5, '.25'), (4, 6, '1'), (8, 6, '10')):
                model = HermiteMass(k, n, Decimal(length))
                values = [model.value(j)**2 for j in range(1 << n)]
                for first, stride, count in ((0, 1, 1 << n), (1, 2, (1 << n) // 2),
                                              (0, 3, ((1 << n) + 2) // 3), ((1 << n) // 2, 1, 1)):
                    expected = sum(values[first + stride * j] for j in range(count))
                    actual = model.mass(first, stride, count)
                    self.assertLess(abs(actual - expected), Decimal('1e-75') * max(Decimal(1), expected))

    def test_low_and_high_prefix_partitions(self):
        with localcontext() as context:
            context.prec = 90
            model = HermiteMass(4, 6, Decimal('1'))
            for depth in range(6):
                for prefix in range(1 << depth):
                    high = model.high_prefix(depth, prefix)
                    low = model.low_prefix(depth, prefix)
                    self.assertLess(abs(high - model.high_prefix(depth + 1, prefix * 2)
                                        - model.high_prefix(depth + 1, prefix * 2 + 1)), Decimal('1e-65'))
                    self.assertLess(abs(low - model.low_prefix(depth + 1, prefix)
                                        - model.low_prefix(depth + 1, prefix + (1 << depth))), Decimal('1e-65'))

    def test_known_mps_instability_cases_small_only(self):
        # Deliberate small-width dense reference, never used by mass queries.
        with localcontext() as context:
            context.prec = 160
            for k, length in ((4, '2'), (8, '10'), (8, '300')):
                model = HermiteMass(k, 8, Decimal(length))
                reference = sum(model.value(j)**2 for j in range(256))
                self.assertLess(abs(model.mass(0, 1, 256) - reference),
                                Decimal('1e-120') * max(Decimal(1), reference))

    def test_large_width_never_evaluates_samples(self):
        for n in (32, 128, 512):
            result = run_queries(2, n, '1', max(100, math.ceil(n * math.log10(2)) + 80))
            self.assertEqual(result['counters']['sample_evaluations'], 0)
            self.assertLess(result['counters']['mass_queries'], 100)
            self.assertLess(Decimal(result['maximum_relative_split_error']), Decimal('1e-70'))

    def test_invalid_progressions_fail(self):
        with localcontext() as context:
            context.prec = 60
            model = HermiteMass(1, 3, Decimal('1'))
            for query in ((0, 0, 1), (-1, 1, 1), (7, 1, 2), (0, 1, -1)):
                with self.assertRaises(ValueError):
                    model.mass(*query)

    def test_insufficient_index_precision_fails_closed(self):
        with self.assertRaises(ArithmeticError):
            run_queries(2, 512, '1', 100)


if __name__ == '__main__':
    unittest.main()
