# Hermite reconstruction and fail-closed publication audit

## Scope and provenance

This work resumes the Hermite smooth-initial-data construction handed off in
the discussion named “光滑初值构造规律”. The inherited branch contained workflow
files but no committed Hermite implementation packet. Earlier archive-transport
or conditional workflow success is therefore not accepted as a proof result.
The mathematical target was recovered from the handoff and checked against
[the source, Sec. 4.3](https://arxiv.org/html/2403.19123v3#S4.SS3).

The formal outcome is described in [the task contract](../tasks/SP-HERMITE-001.md),
[polynomial proof map](hermite-polynomial-proof.md), and
[independent source-to-certificate review](hermite-independent-review.md).
The public case supplies full source, not only selected declaration previews.

## Reproduced failure modes and repairs

| Failure mode | Evidence in the repository | Repair |
| --- | --- | --- |
| Absent implementation still skipped successfully | The inherited Hermite workflow used conditional file checks before compilation and replay. | `tools/check_hermite_artifacts.py` requires nonempty files; actual Lean and replay commands are unconditional. The two archive workflows are retired: manual invocation explains retirement and fails, so it cannot be mistaken for acceptance. |
| Changed or removed source at the same Git commit inherited an old green report | A commit ID alone did not identify the working tree contents. | `proof_inputs.py` hashes all source/configuration inputs; the runner compares before/after, and publication rechecks the digest. |
| Unimported module was counted without compilation | Lake's default root globs build imports, not all source files. The first integrated test run also exposed missing Hermite test-module discovery. | `run_lean_gate.py` builds every discovered module explicitly; `lakefile.lean` discovers all `ABEISTests` submodules; the publication report must contain the complete module list. |
| Export-only change bypassed numerical replay | Pages proof-change selection did not include exported circuits. | Export changes enter the full gate; the committed Hermite packet is also replayed unconditionally on every Pages run. |
| Latest successful Blueprint was older than the preceding main commit | The inherited-artifact selection and immediate-parent comparison used different revisions. | Reuse compares Blueprint inputs against the actual previously verified commit. Mismatch fails; a manual workflow run forces a fresh build. |
| Windows and Linux disagreed on artifact hashes | Generated packet files had CRLF while Git normalized their committed text. | The exporter writes LF explicitly, tests byte-level portability, and scoped Git attributes preserve it. |
| Windows Python execution failed before acceptance | Concurrent lock reads and transient file-sharing violations failed; subprocess tests assumed a `python3` executable. | See [bounded Windows compatibility fixes](windows-runtime-compatibility.md). No failing proof/test gate is skipped. |
| Full Blueprint traversal ended with an absent search-resource destination | Pinned Verso embedded native backslashes but stripped a forward-slash-only source prefix, leaving parent-directory segments in output names. | A Windows-only, exact-pin/exact-pattern compatibility patch normalizes separators; the real search emitter is exercised before the long document render. Unknown pins or unsafe output names fail. |
| The completed Blueprint still exposed local paths in its search page | `find/index.html` embeds a second, JSON-escaped copy of the cross-reference data. Raw text replacement missed doubled separators and could damage cached HTML quoting. | Re-embed the complete normalized `xref.json` using script-safe JSON serialization at the pinned renderer's exact boundary. Preserve all entries and keep the strict privacy scan; unknown layouts fail. |
| A different local entry point omitted publication stages | The PowerShell website entry point stopped before teaching enrichment and case publishing. | Native Windows commands now mirror the canonical pipeline, propagate every nonzero exit, and reject output reparse points before cleanup; parity and negative tests cover the entry points. |
| A new case crashed rendering or exceeded mobile width | Actual render exposed absent evolution fields; real browser testing measured a 933px page on a 390px viewport. | The case has truthful reference-stage metadata and a complete-render test; constrained grid tracks retain independently scrollable formulas, with browser tests at 390/768/1440px. |
| The complete site rejected eleven correctly rendered replay explanations | The checker demanded the obsolete phrase `Qiskit Operator`; the renderer labels the actual backend `Qiskit replay`, and the Hermite replay uses Statevector. | Check the actual evidence section for its replay row, QASM round trip and both numerical-versus-Lean trust boundaries. Missing sections or rows still fail, including when their words are copied elsewhere on the page. |
| The website's selected downloads were not a self-contained replay packet | Four accepted files existed in the repository but were omitted from the download registry: `circuit.qasm2`, `circuit.qasm3`, `mass-tree.json`, `endpoint-jets.json`. | Publish those exact existing bytes with the original directory structure. A download-only test runs the copied replay script in isolated Python, and deleting any restored file fails the assembled-site gate. |
| Blueprint quick-jump search did not find compiled declarations | Cross-reference JSON contained the informal declaration domains, but the emitted search registry registered only standard Manual domains. Actual short-name and fully qualified queries returned no declaration result. | A deterministic adapter uses Verso's existing `DomainMapper` interface, verifies each local page/anchor, and registers 3,129 unique declarations. It does not change proofs, HTML or the upstream dependency. |
| A Windows-specific regression fixture failed on Linux | The first main Pages run passed Lean, harness and executable checks, then failed a test that used the host's native path spelling to reproduce doubled Windows JSON separators. POSIX paths do not reproduce that particular leak. | Use explicit synthetic Windows and POSIX fixtures independent of the test host. Preserve the original production privacy checker and the Windows negative assertion. |

The first integrated Lean attempt failed at test-module discovery and did not
produce a success report. The repaired configuration is evaluated by a fresh
full run; this document does not promote the failed attempt to success.
Likewise, [the first main Pages run](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/actions/runs/34335939467)
failed at the cross-platform regression fixture, not at Lean compilation.
The separate [Hermite CI gate](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/actions/runs/34335939496)
completed successfully. Neither result is represented as a successful Pages
deployment; the corrected revision must pass that workflow independently.

## Negative and positive checks

- `tools.test_hermite_artifacts`: each required file removed, replaced by a
  directory, or emptied must fail; a wholly absent packet returns a nonzero exit.
- `website.scripts.test_proof_inputs`: changes/deletions/new unimported sources
  invalidate identity; equivalent Windows/Linux newlines retain source identity.
- `website.scripts.test_lean_publication_gate`: real input hashing with mocked
  external processes checks failure at the library, Tests, explicit-module
  batches, and version capture; old success reports are removed first.
- `website.scripts.test_hermite_case`: missing catalogs/downloads and escaping or
  machine-absolute paths fail; complete source copies remain available. The
  assembled-site check also rejects absent, empty or stale source downloads.
- `tools.test_powershell_builds` and `tools.test_verso_windows_compat`: publication
  step parity, immediate failure propagation, bounded output cleanup, exact
  dependency pin/pattern matching, patch idempotence and platform no-op behavior.
- `scripts/test-sanitize-blueprint-paths.py`: twelve tests cover portable paths,
  complete inline cross-reference preservation, repair of previously damaged
  JSON, script-safe round trips, and missing or unfamiliar search-page layouts.
  On the actual 99-page Blueprint, normalization and an independent scan passed
  over 204 text files. The embedded data equals the normalized source JSON,
  retaining 3,129 source links and 28,043 cached HTML fields.
- The real assembled site passed checks for 226 HTML pages, 3,129 declaration
  search entries and nine diagrams after the replay-label contract repair.
  The native website pipeline then passed its remaining source-link, preview,
  required-file, teaching-marker and 359-text privacy checks. This component
  rerun follows the failed full-pipeline attempts; it does not relabel those
  earlier nonzero exits as successful single-command runs.
- The executable suite checks primitives, endpoint interpolation, little-endian
  order, zero subtrees, backend round trips, stale/missing/tampered output,
  forged success fields, and LF portability. Independent replay reconstructs
  the target polynomial separately before executing saved QASM.
- `website.scripts.test_hermite_download_packet`: four tests check the complete
  acceptance-bound file set, byte-identical real publisher output and links,
  missing-file rejection, and independent replay with only the temporary
  website download tree available. Replay leaves all accepted bytes unchanged.
  The actual final-site download tree was also replayed directly: all three
  saved QASM representations passed with maximum componentwise amplitude
  error approximately `1.94e-16`. A later real-browser check confirmed all 16
  download links, two figures and six mathematical containers at both 1440px
  and 390px, with no page overflow, browser exceptions or failed requests.
- `website.scripts.test_blueprint_search`: eleven tests cover exact names and
  anchors, duplicate elimination, missing inputs, stale adapters, unknown
  upstream contracts and escaping output paths. Both native build entry points
  run these tests and generate/check the adapter after fragment repair. In the
  actual Blueprint search box, `hermiteStatePreparation_complete` and its full
  namespace each produced one exact result; clicking it reached the existing
  root declaration anchor. The short query `Hermite` produced 88 matches.

The representative export is `k=1,n=3,L=1`, with seven RY gates, eight CX gates
and Qiskit scheduled depth thirteen. Recorded maximum componentwise amplitude
error is approximately `1.94e-16`. That is finite numerical evidence, not a
uniform error bound or the Euclidean norm of the whole discrepancy vector.

## Reproduction and remaining boundary

```bash
python -m pip install -r requirements-executable.txt
python -m unittest tools.test_hermite_artifacts website.scripts.test_proof_inputs website.scripts.test_lean_publication_gate website.scripts.test_hermite_case
python executable-exports/SP-HERMITE-001/qiskit/export.py --self-test
python executable-exports/SP-HERMITE-001/qiskit/replay.py
python website/scripts/run_lean_gate.py
bash scripts/build-all.sh
```

The generated `build-report.json` is the publication's checkout-specific Lean
evidence. Successful independent CI execution is the operational authority;
local JSON consistency checks are not cryptographic attestation against an
attacker who can rewrite the verifier, build scripts and report together.
The Python exporter is not extracted from Lean. Exact-real circuit semantics
and independent finite replay remain deliberately separate claims.

The obsolete remote-environment workaround no longer uploads source bundles,
compiler/dependency archives, or proof-log artifacts. Its historical code remains
in Git history; current workflow files direct users to the real Hermite gate.
Normal CI step output and the existing website publication remain available.

Changes are confined to new construction/proof assets, documentation, build
discovery, negative tests and small Windows execution fixes. Historical trial
records and scientific targets are not rewritten. Current cubic/Robin executable
outputs, acceptance summaries and the public replay report are refreshed by the
actual replay commands; these updates are not new synthesis or cold-start runs.
The patch can be
reverted coherently without a data migration; do not remove an individual
required proof file while leaving its certified case and acceptance rules.
