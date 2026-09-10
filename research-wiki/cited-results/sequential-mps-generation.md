# Sequential MPS generation and primitive realization

Sources:

- Schön, Solano, Verstraete, Cirac and Wolf, *Sequential generation of
  entangled multi-qubit states*, PRL 95, 110503 (2005),
  [arXiv:quant-ph/0501096](https://arxiv.org/abs/quant-ph/0501096).
- Vartiainen, Möttönen and Salomaa, *Efficient decomposition of quantum gates*,
  PRL 92, 177902 (2004),
  [arXiv:quant-ph/0312218v3](https://arxiv.org/abs/quant-ph/0312218v3).
- Möttönen et al., *Quantum Circuits for General Multiqubit Gates*, PRL 93,
  130502 (2004), [arXiv:quant-ph/0404089v3](https://arxiv.org/abs/quant-ph/0404089v3).
- Iten et al., *Quantum Circuits for Isometries*, PRA 93, 032318 (2016),
  [arXiv:1501.06911v4](https://arxiv.org/abs/1501.06911v4).

Use: a finite-bond MPS can be generated sequentially using an ancillary
register and local isometries; those isometries must still be compiled into
charged elementary gates. Gray order is useful for mapping adjacent
elimination rows to computational-basis states differing on one bit.

Dependency site: `SP-HERMITE-POLY-002`, nodes R2/R3. This is cited background,
not an imported axiom or a certificate for the implementation. Local proofs
are tracked individually in the task frontier. General orthogonalization,
completion and decomposition are not treated as free suppliers merely
because they are described in the literature. Finite precision and classical
preprocessing costs require their own analysis.
