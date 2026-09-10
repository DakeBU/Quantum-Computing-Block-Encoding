"""MPS-02: positive Bernstein injection and bounded exponential cores.

Only the single unresolved cutoff prefix gets a boundary state.  Fully
included dyadic children inject restricted Bernstein coefficients into a
SHARED degree-d subdivision state.  Thus the bond is O(k), not O(n*k), and
no list of amplitudes or exponentially many prefixes is constructed.
"""
from decimal import Decimal, localcontext
from fractions import Fraction
import math
import numpy as np
from mps_core_probe import TT, direct_sum, fold_boundaries, left_cutoff, pi_interval


def decimal_fraction(value: Fraction) -> Decimal:
    return Decimal(value.numerator)/Decimal(value.denominator)


def positive_bernstein(k: int) -> list[Decimal]:
    degree = 2*k+1
    a = [sum((Fraction(math.comb(k+r-m, k), math.factorial(m))
              for m in range(r+1)), Fraction(0)) for r in range(k+1)]
    base = [sum((a[i]*Fraction(math.comb(k-i, r-i), math.comb(degree, r))
                 for i in range(k+1) if i <= r <= k), Fraction(0))
            for r in range(degree+1)]
    exp_minus_one = Decimal(-1).exp()
    return [exp_minus_one*decimal_fraction(base[r])+decimal_fraction(base[degree-r])
            for r in range(degree+1)]


def subdivide(coeff: list[Decimal], point: Decimal):
    if not 0 <= point <= 1:
        raise ArithmeticError("Bernstein split point outside [0,1]")
    row, left, right = list(coeff), [coeff[0]], [coeff[-1]]
    while len(row) > 1:
        row = [(1-point)*a+point*b for a, b in zip(row[:-1], row[1:])]
        left.append(row[0])
        right.append(row[-1])
    return left, list(reversed(right))


def restrict_bernstein(coeff, lower, upper):
    if not 0 <= lower < upper <= 1:
        raise ArithmeticError("source polynomial restriction outside [0,1]")
    _, right = subdivide(coeff, lower)
    left, _ = subdivide(right, (upper-lower)/(1-lower))
    return np.array([float(x) for x in left])


def subdivision_matrices(degree: int):
    lower = np.zeros((degree+1, degree+1))
    upper = np.zeros((degree+1, degree+1))
    for i in range(degree+1):
        for j in range(degree+1):
            if j <= i:
                lower[i, j] = math.comb(i, j)/2**i
            if j >= i:
                upper[i, j] = math.comb(degree-i, j-i)/2**(degree-i)
    return [lower.T, upper.T]


def interval_injection_tt(n, lower, upper, free_dimension, free_core, inject):
    """One boundary state; reject intervals needing two boundary prefixes."""
    if lower == upper:
        cores = [np.ones((1, 2, 1)) for _ in range(n)]
        cores[0] *= 0
        return TT(cores), 0
    if not 0 <= lower < upper <= 1 << n:
        raise ValueError("invalid source interval")
    unresolved = (0, 1 << n)
    matrices, injections = [], 0
    for offset in range(n):
        core = np.zeros((free_dimension+1, 2, free_dimension+1))
        for bit in range(2):
            core[1:, bit, 1:] = free_core(offset, bit)
        following = []
        if unresolved is not None:
            first, end = unresolved
            half = (end-first)//2
            for bit in range(2):
                a, b = first+bit*half, first+(bit+1)*half
                if a >= lower and b <= upper:
                    core[0, bit, 1:] = inject(a, b)
                    injections += 1
                elif b <= lower or a >= upper:
                    pass
                else:
                    core[0, bit, 0] = 1
                    following.append((a, b))
        if len(following) > 1:
            raise ValueError("this interval needs two boundary states")
        unresolved = following[0] if following else None
        matrices.append(core)
    if unresolved is not None:
        raise ArithmeticError("unresolved threshold at final bit")
    left, right = np.zeros(free_dimension+1), np.zeros(free_dimension+1)
    left[0], right[1] = 1, 1
    return fold_boundaries(matrices, left, right), injections


def stable_hermite_tt(n: int, k: int, length: Fraction):
    if k < 0:
        raise ValueError("natural k required")
    cutoff, cutoff_terms = left_cutoff(n, length)
    degree = 2*k+1
    # Extra working digits protect narrow intervals before float conversion.
    # This is a declared numerical choice, not a proven uniform error bound.
    digits = math.ceil(n*math.log10(2))+90
    terms = max(cutoff_terms, math.ceil((digits+10)/math.log10(25)))
    with localcontext() as context:
        context.prec = digits
        pi_low, pi_high = pi_interval(terms)
        pi = decimal_fraction((pi_low+pi_high)/2)
        radius, count = pi*decimal_fraction(length), 1 << n
        step = 2*radius/Decimal(count)
        bernstein = positive_bernstein(k)
        subdivisions = subdivision_matrices(degree)

        def polynomial_inject(a, b):
            # Evaluate cancellation-prone grid coordinates at working precision.
            lower = 1+radius*(Decimal(2*a)/Decimal(count)-1)
            upper = 1+radius*(Decimal(2*b)/Decimal(count)-1)
            return restrict_bernstein(bernstein, lower, upper)

        middle, middle_blocks = interval_injection_tt(
            n, cutoff, count//2, degree+1,
            lambda offset, bit: subdivisions[bit], polynomial_inject)

        def exponential_inject(a, b):
            last = radius*(Decimal(2*(b-1))/Decimal(count)-1)
            return np.array([float(last.exp())])

        def left_free(offset, bit):
            value = 1. if bit else float((-step*Decimal(1 << (n-1-offset))).exp())
            return np.array([[value]])

        left, left_blocks = interval_injection_tt(n, 0, cutoff, 1, left_free, exponential_inject)
        right_cores = [np.array([0., 1.]).reshape(1, 2, 1)]
        for offset in range(1, n):
            right_cores.append(np.array([1., float((-step*Decimal(1 << (n-1-offset))).exp())])
                               .reshape(1, 2, 1))
        right = TT(right_cores)
        result = direct_sum([(1, left), (1, middle), (1, right)])
    return result, {"candidate": "MPS-02", "n": n, "k": k, "L": str(length),
                    "left_cutoff": str(cutoff), "cutoff_pi_terms": cutoff_terms,
                    "coefficient_working_digits": digits,
                    "bond_bound": 2*k+6, "max_bond": result.max_bond,
                    "core_scalars": result.scalar_count,
                    "middle_dyadic_injections": middle_blocks,
                    "left_dyadic_injections": left_blocks,
                    "core_min": min(float(core.min()) for core in result.cores),
                    "core_max": max(float(core.max()) for core in result.cores),
                    "dense_constructor_input": False, "dense_svd_used": False,
                    "formal_status": "not_yet_Lean_verified",
                    "precision_status": "Decimal coefficient construction then float64 cores"}
