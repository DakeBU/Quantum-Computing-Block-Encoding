# Lean collaborator: native core coordination proposal

No new local Lean verification was performed for this NL task.

Before shared integration, please reconcile `manifests/nl-v1/core-registry.json`
and `lean-collaborator-targets.json` with the active formal task registry. This
packet does not assert that you have acknowledged or approved the proposed IDs.

## Rules to confirm

1. One canonical mathematical core across NL, Lean and hybrid views. A repair,
   paraphrase or numerical substitution aliases the same core, never a new count.
2. Keep the same core and related solution family in one split group. A public
   mathematical foundation may support more than one split, but a target solution
   and its variants may not leak between splits.
3. Preserve current author attribution and independent review provenance. Do not
   upgrade inherited fixed-reference Lean checks into new compilation or isolated
   untrusted-output certification.
4. Proposed `qcb-core-la-*`, `qcb-core-sp-*`, `qcb-core-be-*`, `qcb-core-plan-*`
   IDs are additive. Existing v3 views are listed as legacy alias proposals;
   uncertain equivalence is a mathematical dedup review, not decided by string
   similarity or graph distance.
5. Candidate formal targets are NL propositions plus exact assumptions,
   conventions and source anchors. They are not submitted proof bodies. Please
   report API/binder/convention differences before constructing a formal view.

## Requested acknowledgment

Return a recorded collaborator identity/run, accepted core IDs and any ID/family
collisions, canonical alias replacements, split changes and the exact registry
hash acknowledged. Until a real response exists, `integration_allowed` stays
false. The current agent cannot manufacture that response or infer it from a
file being present.

Missing Lean on the NL-authoring machine is not a mathematical blocker. Work
continues with complete-source inspection and genuine independent NL review.
