# Positive Hermite bridge: source-to-Lean proof closure

The initial-data contract is the piecewise function in
[arXiv:2403.19123v3, Section 4.3](https://arxiv.org/pdf/2403.19123v3),
equations (4.31)–(4.32). For every natural number $k$, the middle polynomial
must have degree at most $2k+1$, match every derivative of $e^p$ through order
$k$ at $p=-1$, and match every derivative of $e^{-p}$ through order $k$ at
$p=0$. These derivative conditions are conclusions of the implementation.

## Exact construction

Put $t=p+1$ and define

\[
a_{k,r}=\sum_{m=0}^{r}\binom{k+r-m}{k}\frac{1}{m!},
\qquad A_k(t)=\sum_{r=0}^{k}a_{k,r}t^r.
\]

The implemented polynomial is

\[
P_k(p)=e^{-1}(1-t)^{k+1}A_k(t)+t^{k+1}A_k(1-t).
\]

Lean computes the finite coefficient polynomial by truncating the formal power
series $e^X(1-X)^{-(k+1)}$. `coefficientSeries_coeff` proves that this
implementation has exactly the displayed finite binomial/factorial sums;
`coefficientPolynomial_eval` and `sourceInterpolant_eval` connect the formal
power-series implementation to the reader-facing formula. The use of a formal
power series introduces no analytic convergence hypothesis: only finitely many
coefficients enter the polynomial.

## Why the endpoint proofs close

Let $B_k(t)=(1-t)^{k+1}A_k(t)$. The formal identity

\[
(1-X)^{k+1}\,e^X(1-X)^{-(k+1)}=e^X
\]

survives truncation through degree $k$. Consequently, the coefficients of
$B_k$ through degree $k$ are $1/j!$, so $B_k^{(j)}(0)=1$ for $j\le k$.
The factor $(1-t)^{k+1}$ independently proves $B_k^{(j)}(1)=0$ for the same
orders. Reflection contributes the exact factor $(-1)^j$ to the derivative of
$B_k(1-t)$. Multiplication by $e^{-1}$ and the shift $t=p+1$ give both requested
endpoint jets. The generic theorem `iteratedDeriv_polynomial` converts the
polynomial differentiation results to actual real analytic derivatives.

Every coefficient of $A_k$ is nonnegative and its constant coefficient is one.
Thus $A_k(t)>0$ when $t\ge0$. On $0\le t\le1$, both terms of $P_k$ are
nonnegative, and at least one is strictly positive, including at both endpoints.
The resulting complete piecewise initial datum is strictly positive everywhere.

## Theorem map

All names below belong to `QuantumBlockEncoding.HermitePolynomial` in
`QuantumBlockEncoding/HermitePolynomial.lean`.

| Mathematical result | Lean theorem |
| --- | --- |
| Exact finite formula for $a_{k,r}$ | `coefficientSeries_coeff` |
| Exact finite formula for $A_k(t)$ | `coefficientPolynomial_eval` |
| Exact source formula for $P_k(p)$ | `sourceInterpolant_eval` |
| Degree at most $2k+1$ | `sourceInterpolant_degree` |
| All left endpoint derivatives through $k$ | `sourceInterpolant_left_iteratedDeriv` |
| All right endpoint derivatives through $k$ | `sourceInterpolant_right_iteratedDeriv` |
| Positive middle polynomial on $[-1,0]$ | `sourceInterpolant_pos` |
| Literal piecewise initial function | `smoothInitial` |
| Global strict positivity of the complete function | `smoothInitial_pos` |
| Unique polynomial with this degree bound and these jets | `sourceInterpolant_unique` |
| Independent extended-Euclid construction agrees with source formula | `interpolant_eq_sourceInterpolant` |

The separate `interpolant` definition uses polynomial extended Euclid and
remainder, together with explicitly proved local Taylor jets. Its equality with
`sourceInterpolant` is proved by uniqueness: a nonzero difference would be
divisible by both endpoint multiplicity factors, hence by their product of
degree $2k+2$, while its degree is at most $2k+1$.

## Global regularity: the junctions are included

`QuantumBlockEncoding/HermiteSmoothness.lean` supplies the additional analytic
gluing proof. The reusable theorem `HermiteSmoothness.contDiff_splice` proves
that two globally $C^k$ real functions with matching derivatives through order
$k$ at a cut yield a globally $C^k$ splice. Its induction reduces order $k+1$
to order $k$ for the derivative. At the junction, the derivative is justified
by the common limit of the two difference quotients, using both equality of
function values and equality of derivatives.

The theorem is applied first at zero to join the polynomial to $e^{-p}$, then
at $-1$ to join $e^p$ to that result. Equality of the splice's branch convention
and the original source function is proved explicitly, including the point
$p=0$. The final theorem is:

```lean
QuantumBlockEncoding.HermiteSmoothness.smoothInitial_contDiff (k : ℕ) :
  ContDiff ℝ k (QuantumBlockEncoding.HermitePolynomial.smoothInitial k)
```

This is regularity on the entire real line, not merely away from the two
junctions. It holds for arbitrary finite $k$, including the continuous $k=0$
case; it does not claim that a fixed member of the family is $C^\infty$.

## Verification scope

The construction, finite-sum correspondence, degree bound, ordinary and analytic
endpoint derivatives, positivity, and uniqueness are arbitrary-$k$ Lean
theorems. `ABEISTests/HermitePolynomial.lean` also checks the linear $k=0$
member, the cubic coefficient polynomial $A_1(t)=1+3t$, both junction values,
and the public general-order APIs. These examples supplement the universal
proofs rather than replace them.

`ABEISTests/HermiteSmoothness.lean` checks global regularity, continuity of all
iterated derivatives through the requested order, differentiability below that
order, and equality to the double splice. Gate-level state preparation and
executable QASM acceptance remain separate integration targets that consume
these verified mathematical facts.

Reproduce the focused checks with:

```sh
lake build QuantumBlockEncoding.HermitePolynomial
lake env lean ABEISTests/HermitePolynomial.lean
lake build QuantumBlockEncoding.HermiteSmoothness
lake env lean ABEISTests/HermiteSmoothness.lean
```

Repository promotion additionally requires the full `lake build`,
`lake build Tests`, and `bash scripts/build-all.sh` gates on the final integrated
commit. Focused proof success does not replace those gates.
