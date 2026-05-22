# SWAP Bit-Slice Proof Attempt: 2026-05-22

Task: `QBE-AUTO-002`

Mode: `faithfulPaper`

Target declarations:

- `swapOracleImage_self_inverse`
- `swapOracleImage_lt`
- `swapOracleImage_injective`
- `swapOracleImage_bijective`
- `swapOracleMatrix_is_permutation`

## Attempt Summary

The upper agent selected SWAP unitarity as the next faithful GHL2025 target.
The intended proof-DAG was:

$$
\text{bit-slice block swap} \Rightarrow
\text{self-inverse image} \Rightarrow
\text{injective/bijective image} \Rightarrow
\text{permutation matrix}.
$$

The attempted implementation edited `QuantumBlockEncoding/GHL2025.lean` by
introducing a local `qbeSet` tactic and rewriting several SWAP bit-slice proofs
around `Nat.testBit_shiftLeft`, `Nat.xor_lt_two_pow`, and mask bounds.

## Failure

The attempt did not pass `python3 tools/qbe.py check`.  Representative Lean
failures:

- `swapOracleImage_block1_eq_block2` left unresolved bit goals after
  `Nat.testBit_shiftLeft`, especially proving shifted high-block bits vanish.
- Several `simp` calls made no progress around mask test-bit goals.
- Boolean XOR goals appeared without the expected simplification instance.
- `Nat.eq_of_testBit_eq` could not consume the generated equality because local
  `qbeSet` definitions did not match the unfolded target shape.
- The final XOR cancellation in `swapOracleImage_self_inverse` did not rewrite
  into the target expression.

The dirty Lean edit was therefore reverted to preserve the build.

## Next Route

Do not try another flat all-at-once proof.  Factor the proof-DAG into reusable
lemmas first:

1. A lemma for mask bits:
   for `i < n`, `((1 <<< n) - 1).testBit i = true`; for `n <= i`, it is false.
2. A lemma for shifted blocks:
   `(x <<< lo).testBit (lo + i) = x.testBit i`, and the corresponding
   zero result outside the interval.
3. A block extraction lemma:
   extracting an n-bit interval from
   `j ^^^ (diff <<< lo) ^^^ (diff <<< hi)` affects exactly that interval.
4. Use those lemmas to prove `block1' = block2` and `block2' = block1`.
5. Only then prove `swapOracleImage_self_inverse` and the bijection/permutation
   bridge.

Acceptance condition: the next route must keep `oneTermRobinGate_SWAP.unitary.proved = false`
until all named Lean declarations compile and the Markdown/LaTeX proof map is
synchronized.

## Claude Retry Stopped: 2026-05-22

A later Claude retry created a fresh run deck and completed only the upper-agent
plan before hitting quota on the middle agent.  The generated Lean edit tried to
restart the SWAP proof by adding concrete `native_decide` checks plus a general
`swapOracleImage_self_inverse` theorem with `sorry`.

That edit was discarded.  In faithful-paper mode the main branch must not carry
`sorry`, must not promote `oneTermRobinGate_SWAP.unitary.proved`, and must not
replace the missing proof with finite sampled cases.  The next Codex or Claude
run should continue from the compiled baseline and factor the bit-slice lemmas
before attempting the full SWAP bijection/permutation bridge.
