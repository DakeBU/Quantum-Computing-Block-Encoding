"""Non-dense Hermite squared-mass research prototype (not a quantum backend).

The exact algebra uses rational polynomial coefficients and integer power sums.
Only transcendental evaluation uses Decimal.  No table of 2**n amplitudes or
prefix angles is constructed.  The CLI runs bounded diagnostic queries.
"""
from __future__ import annotations

import argparse
import json
import math
from dataclasses import dataclass, field
from decimal import Decimal, localcontext, ROUND_CEILING, getcontext
from fractions import Fraction
from pathlib import Path
from time import perf_counter


def multiply(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    out = [Fraction(0) for _ in range(len(a) + len(b) - 1)]
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def reflect(a: list[Fraction]) -> list[Fraction]:
    """Coefficients of a(1-t), exactly over Q."""
    return [sum((a[r] * math.comb(r, v) * (-1)**v
                 for r in range(v, len(a))), Fraction())
            for v in range(len(a))]


def endpoint_coefficients(k: int) -> list[Fraction]:
    a = [sum((Fraction(math.comb(k + r - u, k), math.factorial(u))
              for u in range(r + 1)), Fraction()) for r in range(k + 1)]
    return multiply([Fraction((-1)**r * math.comb(k + 1, r))
                     for r in range(k + 2)], a)


def power_sums(count: int, degree: int) -> list[int]:
    """S_r(count)=sum(ell**r, ell<count), O(degree**2) integer operations.

    Triangular binomial recurrence; iteration count does not depend on count.
    """
    values: list[int] = []
    for r in range(degree + 1):
        numerator = count**(r + 1) - sum(
            math.comb(r + 1, u) * values[u] for u in range(r))
        quotient, remainder = divmod(numerator, r + 1)
        if remainder:
            raise ArithmeticError("nonintegral exact power-sum recurrence")
        values.append(quotient)
    return values


def decimal_fraction(value: Fraction) -> Decimal:
    return Decimal(value.numerator) / Decimal(value.denominator)


def decimal_pi() -> Decimal:
    """Gauss-Legendre iteration; no binary64 pi substitution."""
    a, b, t, p = Decimal(1), Decimal(1) / Decimal(2).sqrt(), Decimal(1) / 4, Decimal(1)
    for _ in range(math.ceil(math.log2(getcontext().prec)) + 2):
        new_a = (a + b) / 2
        b = (a * b).sqrt()
        t -= p * (a - new_a)**2
        a, p = new_a, 2 * p
    return (a + b)**2 / (4 * t)


def expm1(x: Decimal) -> Decimal:
    if abs(x) >= Decimal('0.1'):
        return x.exp() - 1
    term, total, index = x, x, 1
    while True:
        index += 1
        term = term * x / index
        updated = total + term
        if updated == total:
            return total
        total = updated


def horner(coefficients: list[Fraction], x: Decimal) -> Decimal:
    result = Decimal(0)
    for coefficient in reversed(coefficients):
        result = result * x + decimal_fraction(coefficient)
    return result


def polynomial_progression_sum(coefficients: list[Fraction], start: Decimal,
                               step: Decimal, sums: list[int]) -> Decimal:
    """Affine substitution and power sums: no iteration over sampled points."""
    degree = len(coefficients) - 1
    a_powers = [start**r if r else Decimal(1) for r in range(degree + 1)]
    b_powers = [step**r if r else Decimal(1) for r in range(degree + 1)]
    total = Decimal(0)
    for v in range(degree + 1):
        coefficient = sum((decimal_fraction(coefficients[r]) * math.comb(r, v)
                           * a_powers[r - v] for r in range(v, degree + 1)), Decimal(0))
        total += coefficient * b_powers[v] * sums[v]
    return total


def ceil_div(a: int, b: int) -> int:
    return -((-a) // b)


@dataclass
class HermiteMass:
    k: int
    n: int
    length: Decimal
    counters: dict[str, int] = field(default_factory=lambda: {
        'mass_queries': 0, 'polynomial_segments': 0,
        'geometric_segments': 0, 'power_sum_integer_updates': 0,
        'sample_evaluations': 0})

    def __post_init__(self) -> None:
        if self.k < 0 or self.n < 1 or self.length <= 0:
            raise ValueError('require k>=0, n>=1, L>0')
        if getcontext().prec < math.ceil(self.n * math.log10(2)) + 30:
            raise ArithmeticError('precision insufficient to distinguish neighboring grid indices')
        self.size = 1 << self.n
        self.pi = decimal_pi()
        self.origin = -self.pi * self.length
        self.step = 2 * self.pi * self.length / self.size
        self.g = endpoint_coefficients(self.k)
        self.reflected = reflect(self.g)
        self.squares = (multiply(self.g, self.g),
                        multiply(self.g, self.reflected),
                        multiply(self.reflected, self.reflected))
        self.degree = 4 * self.k + 2
        self.exp_minus_one = Decimal(-1).exp()
        raw = ((-1 - self.origin) / self.step).to_integral_value(rounding=ROUND_CEILING)
        self.middle_start = min(self.size, max(0, int(raw)))
        self.right_start = self.size // 2
        if self.middle_start > self.right_start:
            raise ArithmeticError('inconsistent splice cutoffs')
        if 0 < self.middle_start < self.size:
            if not (self.point(self.middle_start - 1) < -1 <= self.point(self.middle_start)):
                raise ArithmeticError('precision insufficient for middle cutoff')

    def point(self, index: int) -> Decimal:
        # Enforce the exact central zero in the arithmetic expression itself.
        return self.step * (Decimal(index) - Decimal(self.size) / 2)

    def value(self, index: int) -> Decimal:
        """Diagnostic only. Production mass() never calls value()."""
        self.counters['sample_evaluations'] += 1
        p = self.point(index)
        if p < -1:
            return p.exp()
        if p > 0:
            return (-p).exp()
        t = p + 1
        # Positive source representation, independent from squared coefficients.
        a = [sum((Fraction(math.comb(self.k + r - u, self.k), math.factorial(u))
                  for u in range(r + 1)), Fraction()) for r in range(self.k + 1)]
        return self.exp_minus_one * (1 - t)**(self.k + 1) * horner(a, t) + \
            t**(self.k + 1) * horner(a, 1 - t)

    def mass(self, first: int, stride: int, count: int) -> Decimal:
        if stride <= 0 or count < 0 or first < 0 or (count and first + stride * (count - 1) >= self.size):
            raise ValueError('progression outside target grid')
        self.counters['mass_queries'] += 1
        if not count:
            return Decimal(0)
        middle = min(count, max(0, ceil_div(self.middle_start - first, stride)))
        right = min(count, max(0, ceil_div(self.right_start - first, stride)))
        width = self.step * stride
        answer = Decimal(0)
        if middle:
            last = self.point(first + stride * (middle - 1))
            answer += (2 * last).exp() * expm1(-2 * width * middle) / expm1(-2 * width)
            self.counters['geometric_segments'] += 1
        if right > middle:
            segment_count = right - middle
            t0 = self.point(first + stride * middle) + 1
            sums = power_sums(segment_count, self.degree)
            terms = [polynomial_progression_sum(c, t0, width, sums) for c in self.squares]
            answer += self.exp_minus_one**2 * terms[0] + 2 * self.exp_minus_one * terms[1] + terms[2]
            self.counters['polynomial_segments'] += 1
            self.counters['power_sum_integer_updates'] += (self.degree + 1) * (self.degree + 2) // 2
        if right < count:
            p0 = self.point(first + stride * right)
            answer += (-2 * p0).exp() * expm1(-2 * width * (count - right)) / expm1(-2 * width)
            self.counters['geometric_segments'] += 1
        if answer < 0:
            raise ArithmeticError('negative mass: numerical cancellation/precision failure')
        return answer

    def high_prefix(self, depth: int, prefix: int) -> Decimal:
        if not 0 <= depth <= self.n or not 0 <= prefix < (1 << depth):
            raise ValueError('invalid high-bit prefix')
        count = 1 << (self.n - depth)
        return self.mass(prefix * count, 1, count)

    def low_prefix(self, depth: int, prefix: int) -> Decimal:
        if not 0 <= depth <= self.n or not 0 <= prefix < (1 << depth):
            raise ValueError('invalid low-bit prefix')
        return self.mass(prefix, 1 << depth, 1 << (self.n - depth))


def run_queries(k: int, n: int, length: str, digits: int) -> dict:
    with localcontext() as context:
        context.prec = digits
        started = perf_counter()
        model = HermiteMass(k, n, Decimal(length))
        norm_sq = model.high_prefix(0, 0)
        records = []
        for convention in ('high', 'low'):
            evaluator = getattr(model, convention + '_prefix')
            for depth in sorted({0, 1, n // 2, n - 1}):
                for prefix in sorted({0, (1 << depth) // 2, (1 << depth) - 1}):
                    parent = evaluator(depth, prefix)
                    if convention == 'high':
                        left, right = evaluator(depth + 1, 2 * prefix), evaluator(depth + 1, 2 * prefix + 1)
                    else:
                        left, right = evaluator(depth + 1, prefix), evaluator(depth + 1, prefix + (1 << depth))
                    discrepancy = abs(parent - left - right) / max(Decimal(1), parent)
                    records.append({'prefix_kind': convention, 'depth': depth, 'prefix': str(prefix),
                                    'mass': str(parent), 'normalized_mass': str(parent / norm_sq),
                                    'relative_split_error': str(discrepancy)})
        return {'status': 'numerical-diagnostic-only', 'k': k, 'n': n, 'L': length,
                'precision_decimal_digits': digits, 'degree_squared_polynomial': model.degree,
                'coefficient_storage_entries': sum(map(len, model.squares)),
                'norm_squared': str(norm_sq), 'elapsed_seconds': perf_counter() - started,
                'counters': model.counters, 'queries': records,
                'maximum_relative_split_error': str(max(Decimal(q['relative_split_error']) for q in records)),
                'full_amplitude_table_constructed': False,
                'quantum_circuit_constructed': False, 'certified_numerical_error': False}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--k', type=int, default=4)
    parser.add_argument('--n', type=int, default=128)
    parser.add_argument('--L', default='1')
    parser.add_argument('--digits', type=int, default=120)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = run_queries(args.k, args.n, args.L, args.digits)
    text = json.dumps(result, indent=2) + '\n'
    if args.output:
        args.output.write_text(text, encoding='utf-8')
    print(json.dumps({k: v for k, v in result.items() if k != 'queries'}, indent=2))


if __name__ == '__main__':
    main()
