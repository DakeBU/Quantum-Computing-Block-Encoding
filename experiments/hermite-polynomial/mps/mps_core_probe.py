"""Formula-derived Hermite TT: no dense input, no full-vector SVD.

Finite floating-point discriminator, NOT an exact or approximate certificate.
All dense vectors are restricted to explicitly named small-width diagnostics.
"""
from __future__ import annotations
import argparse
from dataclasses import dataclass
from fractions import Fraction
from functools import lru_cache
import json
import math
from pathlib import Path
import time
import numpy as np


@lru_cache(maxsize=None)
def pi_interval(terms: int) -> tuple[Fraction, Fraction]:
    """Machin identity with alternating-series rational bounds."""
    def atan(q):
        total = sum((Fraction((-1)**i, (2*i+1)*q**(2*i+1))
                     for i in range(terms)), Fraction(0))
        following = total + Fraction((-1)**terms, (2*terms+1)*q**(2*terms+1))
        return min(total, following), max(total, following)
    lo5, hi5 = atan(5)
    lo239, hi239 = atan(239)
    return 16*lo5-4*hi239, 16*hi5-4*lo239


def ceil_fraction(x: Fraction) -> int:
    return -((-x.numerator)//x.denominator)


def left_cutoff(n: int, length: Fraction, max_terms: int = 512) -> tuple[int, int]:
    """Exact rational interval separation or fail closed; no uniform bit claim."""
    if n < 1 or length <= 0:
        raise ValueError("requires n >= 1 and rational L > 0")
    count, middle = 1 << n, 1 << (n-1)
    for terms in range(8, max_terms+1, 8):
        low, high = pi_interval(terms)
        lower = Fraction(middle)-Fraction(count, 2)/(low*length)
        upper = Fraction(middle)-Fraction(count, 2)/(high*length)
        clamp = lambda x: max(0, min(middle, ceil_fraction(x)))
        a, b = clamp(lower), clamp(upper)
        if a == b:
            return a, terms
    raise ArithmeticError("rational pi interval did not separate the cutoff")


def poly_mul(a, b):
    result = [Fraction(0)]*(len(a)+len(b)-1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            result[i+j] += x*y
    return result


def cardinal_coefficients(k: int):
    """Exact B(t), B(1-t): P(t-1)=exp(-1) B(t)+B(1-t)."""
    a = [sum((Fraction(math.comb(k+r-m, k), math.factorial(m))
              for m in range(r+1)), Fraction(0)) for r in range(k+1)]
    b = poly_mul([Fraction((-1)**j*math.comb(k+1, j)) for j in range(k+2)], a)
    reflected = [sum((b[j]*(-1)**i*math.comb(j, i) for j in range(i, len(b))),
                     Fraction(0)) for i in range(len(b))]
    return b, reflected


def source_value(k: int, p: float) -> float:
    """Independent factored source formula, not monomial evaluation."""
    if p < -1:
        return math.exp(p)
    if p > 0:
        return math.exp(-p)
    t = p+1
    a = [sum(math.comb(k+r-m, k)/math.factorial(m) for m in range(r+1))
         for r in range(k+1)]
    evaluate = lambda x: sum(c*x**r for r, c in enumerate(a))
    return math.exp(-1)*(1-t)**(k+1)*evaluate(t)+t**(k+1)*evaluate(1-t)


@dataclass
class TT:
    cores: list[np.ndarray]

    def __post_init__(self):
        if not self.cores or self.cores[0].shape[0] != 1 or self.cores[-1].shape[2] != 1:
            raise ValueError("open boundaries required")
        for i, core in enumerate(self.cores):
            if core.ndim != 3 or core.shape[1] != 2:
                raise ValueError("binary core required")
            if i and self.cores[i-1].shape[2] != core.shape[0]:
                raise ValueError("bond mismatch")

    @property
    def n(self):
        return len(self.cores)

    @property
    def max_bond(self):
        return max(max(c.shape[0], c.shape[2]) for c in self.cores)

    @property
    def scalar_count(self):
        return sum(c.size for c in self.cores)

    def amplitude(self, j: int) -> float:
        if not 0 <= j < 1 << self.n:
            raise ValueError("basis index outside register")
        vector = np.ones(1)
        # Process MSB first, while integer basis labels keep q0 as LSB.
        for offset, core in enumerate(self.cores):
            vector = vector @ core[:, (j >> (self.n-1-offset)) & 1, :]
        return float(vector[0])

    def squared_norm(self):
        environment = np.ones((1, 1))
        for core in self.cores:
            environment = sum(core[:, b, :].T @ environment @ core[:, b, :]
                              for b in range(2))
        return float(environment[0, 0])

    def small_dense_diagnostic(self, max_n=10):
        if self.n > max_n:
            raise ValueError("dense diagnostics forbidden beyond max_n")
        return np.array([self.amplitude(j) for j in range(1 << self.n)])


def fold_boundaries(matrices, left, right):
    cores = [c.copy() for c in matrices]
    cores[0] = np.einsum("a,abc->bc", left, cores[0])[None, :, :]
    cores[-1] = np.einsum("abc,c->ab", cores[-1], right)[:, :, None]
    return TT(cores)


def threshold_tt(n: int, cutoff: int, kind="lt") -> TT:
    """Two-state MSB comparison automaton; rejected paths have zero weight."""
    if kind not in {"lt", "ge"} or not 0 <= cutoff <= 1 << n:
        raise ValueError("invalid threshold")
    if cutoff in {0, 1 << n}:
        value = float((cutoff == 1 << n) == (kind == "lt"))
        cores = [np.ones((1, 2, 1)) for _ in range(n)]
        cores[0] *= value
        return TT(cores)
    matrices = []
    for offset in range(n):
        digit = (cutoff >> (n-1-offset)) & 1
        core = np.zeros((2, 2, 2))
        for bit in range(2):
            core[1, bit, 1] = 1
            if bit == digit:
                core[0, bit, 0] = 1
            elif (bit < digit) == (kind == "lt"):
                core[0, bit, 1] = 1
        matrices.append(core)
    return fold_boundaries(matrices, np.array([1., 0.]),
                           np.array([0., 1.]) if kind == "lt" else np.ones(2))


def polynomial_tt(n: int, origin: float, step: float, coeff) -> TT:
    degree = len(coeff)-1
    matrices = []
    for offset in range(n):
        weight = math.ldexp(step, n-1-offset)
        core = np.zeros((degree+1, 2, degree+1))
        for bit in range(2):
            for u in range(degree+1):
                for v in range(u, degree+1):
                    core[u, bit, v] = math.comb(v, u)*(weight*bit)**(v-u)
        matrices.append(core)
    return fold_boundaries(matrices, np.array([origin**i for i in range(degree+1)]), coeff)


def exponential_tt(n: int, origin: float, step: float, sign: int) -> TT:
    cores = [np.array([1., math.exp(sign*math.ldexp(step, n-1-offset))])
             .reshape(1, 2, 1) for offset in range(n)]
    cores[0] *= math.exp(sign*origin)
    return TT(cores)


def hadamard(first: TT, second: TT):
    if first.n != second.n:
        raise ValueError("width mismatch")
    return TT([np.stack([np.kron(a[:, bit, :], b[:, bit, :]) for bit in range(2)], axis=1)
               for a, b in zip(first.cores, second.cores)])


def direct_sum(terms):
    n = terms[0][1].n
    if any(t.n != n for _, t in terms):
        raise ValueError("width mismatch")
    if n == 1:
        return TT([sum(w*t.cores[0] for w, t in terms)])
    cores = [np.concatenate([w*t.cores[0] for w, t in terms], axis=2)]
    for offset in range(1, n-1):
        left = sum(t.cores[offset].shape[0] for _, t in terms)
        right = sum(t.cores[offset].shape[2] for _, t in terms)
        core = np.zeros((left, 2, right))
        a = b = 0
        for _, term in terms:
            piece = term.cores[offset]
            da, _, db = piece.shape
            core[a:a+da, :, b:b+db] = piece
            a, b = a+da, b+db
        cores.append(core)
    cores.append(np.concatenate([t.cores[-1] for _, t in terms], axis=0))
    return TT(cores)


def hermite_tt(n: int, k: int, length: Fraction):
    if k < 0:
        raise ValueError("requires natural k")
    cutoff, terms = left_cutoff(n, length)
    radius = math.pi*float(length)
    step = math.ldexp(2*radius, -n)
    cardinal, reflected = cardinal_coefficients(k)
    coeff = np.array([math.exp(-1)*float(a)+float(b) for a, b in zip(cardinal, reflected)])
    polynomial = polynomial_tt(n, 1-radius, step, coeff)
    left_mask = threshold_tt(n, cutoff)
    middle_mask = threshold_tt(n, 1 << (n-1))
    right_mask = threshold_tt(n, 1 << (n-1), "ge")
    result = direct_sum([
        (1, hadamard(left_mask, exponential_tt(n, -radius, step, 1))),
        (1, hadamard(middle_mask, polynomial)),
        (-1, hadamard(left_mask, polynomial)),
        (1, hadamard(right_mask, exponential_tt(n, -radius, step, -1))),
    ])
    return result, {"n": n, "k": k, "L": str(length), "left_cutoff": str(cutoff),
                    "pi_series_terms": terms, "bond_bound": 8*k+12,
                    "max_bond": result.max_bond, "core_scalars": result.scalar_count,
                    "dense_constructor_input": False, "dense_svd_used": False,
                    "arithmetic": "float64 cores; rational interval cutoff"}


def right_canonicalize(tt: TT):
    """LQ on O(D) cores only: no SVD, no approximate rank truncation."""
    cores = [c.copy() for c in tt.cores]
    for offset in range(tt.n-1, 0, -1):
        left, _, right = cores[offset].shape
        q, r = np.linalg.qr(cores[offset].reshape(left, 2*right).T, mode="reduced")
        cores[offset] = q.T.reshape(q.shape[1], 2, right)
        cores[offset-1] = np.einsum("abc,cd->abd", cores[offset-1], r.T)
    norm = float(np.linalg.norm(cores[0]))
    if not math.isfinite(norm) or norm <= 0:
        raise ArithmeticError("canonicalization has no finite positive norm")
    cores[0] /= norm
    return TT(cores), norm


def row_isometry_error(tt):
    return max(float(np.linalg.norm(c.reshape(c.shape[0], -1) @ c.reshape(c.shape[0], -1).T
                                    - np.eye(c.shape[0]), ord=2)) for c in tt.cores)


def finite_discriminator(n, k, length):
    started = time.perf_counter()
    raw, metadata = hermite_tt(n, k, length)
    vector = raw.small_dense_diagnostic()
    radius = math.pi*float(length)
    expected = np.array([source_value(k, -radius+2*radius*j/(1 << n)) for j in range(1 << n)])
    canonical, norm = right_canonicalize(raw)
    normalized = canonical.small_dense_diagnostic()
    metadata.update({"kind": "finite_discriminator", "seconds": time.perf_counter()-started,
                     "max_amplitude_error": float(np.max(np.abs(vector-expected))),
                     "state_error": float(np.linalg.norm(normalized-expected/np.linalg.norm(expected))),
                     "norm_relative_error": abs(norm/float(np.linalg.norm(expected))-1),
                     "row_isometry_error": row_isometry_error(canonical),
                     "last_bond": canonical.cores[-1].shape[2],
                     "normalized_tt_norm": canonical.squared_norm(),
                     "positive_source_min": float(expected.min())})
    return metadata


def large_probe(n, k, length):
    started = time.perf_counter()
    raw, metadata = hermite_tt(n, k, length)
    canonical, norm = right_canonicalize(raw)
    indices = sorted({0, (1 << (n-1))-1, 1 << (n-1), (1 << n)-1})
    metadata.update({"kind": "large_no_dense_probe", "seconds": time.perf_counter()-started,
                     "canonical_core_scalars": canonical.scalar_count,
                     "norm": norm, "row_isometry_error": row_isometry_error(canonical),
                     "last_bond": canonical.cores[-1].shape[2],
                     "normalized_tt_norm": canonical.squared_norm(),
                     "queries": [{"index": str(j), "amplitude": raw.amplitude(j)} for j in indices]})
    return metadata


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    records = []
    for n, k, length in [(1, 0, "1/10"), (4, 0, "1"), (6, 1, "1"),
                          (7, 2, "1/2"), (8, 3, "1"), (8, 4, "2"),
                          (8, 8, "10"), (8, 2, "300")]:
        try:
            records.append(finite_discriminator(n, k, Fraction(length)))
        except (ArithmeticError, ValueError, np.linalg.LinAlgError) as error:
            records.append({"kind": "retained_numerical_failure", "n": n, "k": k, "L": length,
                            "error_type": type(error).__name__, "message": str(error)})
    for n in (16, 32, 64, 128):
        records.append(large_probe(n, 2, Fraction(1)))
    report = {"task": "SP-HERMITE-POLY-002", "candidate": "MPS-01",
              "status": "diagnostic_only_not_formal_acceptance",
              "construction": "explicit monomial translations, rank-two masks, exponential factors",
              "claims_excluded": ["uniform finite-precision bound", "Lean TT certificate",
                                   "primitive gate acceptance", "uniform polynomial bit complexity"],
              "records": records}
    encoded = json.dumps(report, indent=2, allow_nan=False)
    if args.output:
        args.output.write_text(encoded+"\n", encoding="utf-8")
    print(encoded)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
