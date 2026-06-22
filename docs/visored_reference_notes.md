# Visored Reference Notes

Reference:

- Xiyu Zhai, Xinyi Chen, Yiping Wang, Runlong Zhou, Liao Zhang, Simon S. Du,
  [Visored: A Controlled-Natural-Language Prover for LLM-Generated Mathematics](https://arxiv.org/abs/2606.17581).
- Repository: [xiyuzhai-husky-lang/visored](https://github.com/xiyuzhai-husky-lang/visored).

Local reference copies:

- Paper PDF/source: `outer_papers/automation_systems/Visored/`
- Repository checkout: `outer_repos/automation_systems/visored/`

## What Visored Does

Visored studies a controlled-natural-language prover for LLM-generated
mathematics.  Its main design is a triangle:

```text
LaTeX / natural mathematical text
  -> controlled natural language with explicit semantics
  -> optional emitted Lean
```

The important point for ABEIS is not that Visored replaces Lean.  Visored uses
a high-level mathematical surface, local elaboration diagnostics, and a
rule-driven layer to close routine steps before optionally emitting Lean.  Its
public repository currently exposes representative Lean output excerpts rather
than a complete prover implementation.

## Similar Patterns Worth Borrowing

1. **Controlled proof packets.**  ABEIS lower natural-language architects should
   write proof packets in a constrained style: target, registers, assumptions,
   candidate unitary, clean-block statement, resource tuple, local lemmas,
   external contracts, and failure class.  Lean workers may still work directly
   in Lean in the same generation.  The packet is the exchange object that lets
   natural-language and Lean workers compare ideas, not a mandatory
   natural-language-first pipeline.

2. **Localized diagnostics.**  Visored rejects a proof at the source location
   where parsing, elaboration, or solver discharge fails.  ABEIS should mirror
   this by making every lower handoff identify one active proof-DAG leaf, one
   source/user target anchor, and one typed failure class.

3. **Rule-driven routine closure.**  Visored separates high-level proof intent
   from low-level routine discharge.  In ABEIS, this suggests building small
   reusable rule packs for common block-encoding steps: permutation image
   tables, clean-block projection entries, ancilla cleanup, resource tuple
   arithmetic, finite diagonal operators, and epsilon ledgers.

4. **Target-neutral intermediate proof shape.**  Visored lowers accepted proofs
   through an intermediate representation before emitting Lean.  ABEIS can use
   the same idea at a lighter level: a problem-specific proof packet should
   describe the mathematical object independently enough that it can inform
   Lean tasks, natural-language proof review, human LaTeX proof export, and,
   after Lean closure, Qiskit/QASM/QuantumKatas code.

5. **Sparse versus dense emission tradeoff.**  Visored's sparse Lean emission is
   debuggable but verbose.  ABEIS should keep sparse proof leaves while a task is
   failing, then compress them into cleaner reusable declarations and readable
   proof notes after the theorem closes.

## ABEIS Adaptation

ABEIS should not use Visored as an acceptance gate.  The acceptance rule remains:

```text
candidate enters certified population
iff Lean proves the advertised block-entry/unitarity/resource theorem
```

The concrete adaptation is a discipline for two-way proof exchange:

- Natural-language lower agents write controlled proof packets, not essays.
- Lean lower agents can independently write Lean constructions and proofs in
  the same cycle.
- Middle agents align both outputs: Lean results are translated into human
  proof packets, and natural-language packets are translated into Lean-facing
  leaves when they contain useful structure.
- Reviewer agents reject packets that omit the target, register layout,
  normalizer, projector, exact/approximate semantic tier, or typed failure class.
- If a packet is accepted in natural language, it enters the insight pool only.
  It becomes a certified candidate only after Lean formalization.

## Not Borrowed

- ABEIS does not route correctness through Visored's own checker.
- ABEIS does not copy Visored source code.
- ABEIS does not treat generated Lean excerpts as a quantum block-encoding
  library.
- ABEIS does not relax its block-encoding theorem target to a CNL acceptance
  judgment.
