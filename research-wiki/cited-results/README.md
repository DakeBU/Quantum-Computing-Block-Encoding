# Cited Results Memory

This directory records external theorem, lemma, oracle, arithmetic, and
quantum-information results that QBE papers rely on.

Use it to keep three statuses distinct:

- `paper-cited`: the current paper cites or invokes the result.
- `formalized`: QBE has a Lean declaration and build-tested proof or contract.
- `obligation`: QBE still needs to formalize or verify the result before a
  dependent theorem can be closed.

Do not treat a result as proved merely because it is standard, classical, or
cited by a paper.  Record the source, the exact statement used, the Lean target
or declaration, and each dependent QBE task.
