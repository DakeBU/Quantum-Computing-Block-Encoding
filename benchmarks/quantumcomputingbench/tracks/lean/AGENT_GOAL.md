# Goal: semantically aligned Lean views for QuantumComputingBench

Work from current main on a dedicated branch. Read AGENTS.md, HARNESS.md,
the publication protocols and the shared contribution contract. Preserve frozen
data, all historical contributions and other branches. Published content is English.

Prioritize exact formal views of the admitted locally source-supported NL cores,
then original bridge targets whose full assumptions can be formalized. Start
with State Preparation and shared linear-algebra mechanisms; expand to genuine
composition, counterexample/repair and bounded incremental proof tasks. A one-call
application of an existing lemma is an honest warmup, not deep proof synthesis.

Export the shared registry and inspect existing cores plus open PRs. Reuse the
core ID, contract hash, family, split and snapshot for equivalent targets. A
formal version must not change normalization, phase equivalence, dimensions,
register ordering, norm, precision, oracle model or resource accounting. Document
specialization/generalization rather than inventing an equivalence. If a target
is new, use a UUID proposal in this track's `proposals/` folder with
`core_id: candidate:<UUID>`, `admission: candidate_not_counted` and
`dedup_review_required: true`; permanent admission is a maintainer decision.

For each view provide exact imports and target, a readable NL-to-Lean alignment,
complete fixed-reference proof, source identities/hashes and a distinct semantic
review bound to that content. Follow the repository's source/decoder/reviewer
publication gates when changing production mathematics. Report actual identities
and exposure limits; do not fabricate a blind decoder or collaborator approval.

Run the pinned Lean gate and benchmark reference checks using the supported
repository entry points. Check the fixed root's exact type and transitive axiom
allowlist in a fresh process. Reject incomplete proofs, changed assumptions and
wrong-target proofs. Never run arbitrary model-generated Lean on the host just
to bypass an unavailable sandbox: trusted reference execution and isolated
prediction evaluation are different claims. Restoring a proof state does not
undo IO. Do not claim a formally accepted tactic is a positive PRM label without
evidence of progress or completed correctness.

Keep all views/aliases in the same family and split, with no cross-view training
leakage or duplicate core counting. Existing historical Lean pilots are
diagnostic until explicitly reconciled. Record any unsupported formal view as
provisional, not as absent mathematics or a rejected NL answer.

Run benchmark tests, `scripts/curriculum.py validate`, exact reference checks and
the full publication gate appropriate to changed proof inputs. Do not install
system packages, contact administrators, launch long GPU jobs or paid training.
Submit bounded PR milestones with source alignment, semantic and kernel evidence,
execution class, split reconciliation and unresolved obligations separately.
