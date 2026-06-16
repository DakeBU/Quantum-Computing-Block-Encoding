# Proof Attempts

Paper-benchmark mode may use local proof-attempt populations for a fixed Lean
theorem or lemma.  These records are for tactic/proof-script search, not for
changing the paper construction.  Operator-construction mode should put
alternative block-encoding unitaries or circuit families in
`candidate-populations/`; this directory is only for attempts to close a named
Lean leaf.

Each record should identify:

- target theorem or lemma,
- attempted proof route,
- Lean error or remaining goals,
- reusable intermediate lemma found,
- status: rejected, promising, generalized, or proved.
