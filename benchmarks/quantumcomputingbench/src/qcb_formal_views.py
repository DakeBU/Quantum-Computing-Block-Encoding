"""Native formal-view candidates and exact-content admission; no untrusted execution."""
from pathlib import Path
import hashlib
import sys

from qcb_core import digest, read_json
from qcb_integrity import text_sha
from qcb_textbook_policy import check_source_bindings
from qcb_lean import build_harness, APPROVED_AXIOMS

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(R / "website/scripts"))
CANDIDATE = B / "tracks/lean/views/native-v1.json"
EVIDENCE = B / "reports/textbook-v1/formal-native"


def candidates(cores):
    batch = read_json(CANDIDATE)
    if batch["execution_class"] != "trusted_local_reference" or batch["isolated"] is not False:
        raise ValueError("fixed-reference views cannot claim isolated prediction evaluation")
    check_source_bindings(batch["source_bindings"])
    by_core = {c["core_id"]: c for c in cores}
    seen, anonymous = set(), set()
    for view in batch["views"]:
        if view["view_id"] in seen or view["anonymous_id"] in anonymous:
            raise ValueError("duplicate native formal view identity")
        seen.add(view["view_id"]); anonymous.add(view["anonymous_id"])
        core = by_core[view["core_id"]]
        for field in ("contract_hash", "item_digest", "family", "split", "snapshot_id"):
            if view[field] != core[field]:
                raise ValueError("formal view changed an existing core contract or split: " + field)
        if view["task_kind"] != "library_lemma_application":
            raise ValueError("this fixed-reference batch is not a deep proof-synthesis benchmark")
        build_harness({"id": view["view_id"], "formal_context": view["formal_context"]}, view["reference_proof"], "validation")
        for excerpt in view["ambient_definitions"]:
            path = R / excerpt["path"]
            if not path.resolve().is_relative_to(R) or excerpt["path"] not in {s["path"] for s in batch["source_bindings"]}:
                raise ValueError("unbound formal ambient definition")
            start, end = excerpt["lines"]
            source = path.read_text(encoding="utf-8").splitlines()[start - 1:end]
            if start < 1 or end < start or len(source) != end - start + 1 or any('/-' in s or '--' in s for s in source):
                raise ValueError("decoder context must contain literal definitions, not source commentary")
    return batch


def decoder_packet(batch):
    views = []
    for view in batch["views"]:
        definitions = []
        for excerpt in view["ambient_definitions"]:
            start, end = excerpt["lines"]
            source = (R / excerpt["path"]).read_text(encoding="utf-8").splitlines()[start - 1:end]
            definitions.append("\n".join(source))
        views.append({"anonymous_id": view["anonymous_id"], "formal_context": view["formal_context"],
                      "ambient_definitions": definitions})
    # Deliberately no NL question, original answer, proof, author classifications,
    # desired reconstruction, prior verdict, core ID, title or source file path.
    return {"schema_version": "qcb.source_blind_decode_packet.v1", "views": views}


def admission(cores):
    batch = candidates(cores)
    packet = decoder_packet(batch)
    files = {key: EVIDENCE / (key + ".json") for key in ("decoder", "comparison", "reference-checks")}
    missing = [key for key, path in files.items() if not path.is_file()]
    if missing:
        return {}, {"status": "pending_evidence", "missing": missing, "candidate_views": len(batch["views"])}
    decoder, comparison, reference = [read_json(files[k]) for k in files]
    if (decoder.get("packet_digest") != digest(packet) or not decoder.get("decoder")
            or decoder["decoder"] == batch["author"] or decoder.get("source_blind") is not True):
        raise ValueError("native formal decoder is stale or not independently source-blind")
    if (comparison.get("batch_digest") != digest(batch) or comparison.get("decoder_digest") != digest(decoder)
            or not comparison.get("reviewer") or comparison["reviewer"] in {batch["author"], decoder["decoder"]}):
        raise ValueError("formal comparison does not bind a distinct reviewer and exact reconstruction")
    if (reference.get("batch_digest") != digest(batch) or reference.get("isolated") is not False
            or reference.get("execution_class") != "trusted_local_reference"):
        raise ValueError("native fixed-reference proof report is stale or misclassified")
    from proof_inputs import proof_input_digest, lean_module_targets
    identity, modules = proof_input_digest(R), lean_module_targets(R)
    gate = reference.get("repository_gate", {})
    if (reference.get("proof_inputs_sha256") != identity
            or reference.get("compiled_modules") != lean_module_targets(R)):
        raise ValueError("native reference report has different production proof inputs")
    if (gate.get("passed") is not True or gate.get("proofInputsSha256") != identity or gate.get("compiledModules") != modules):
        raise ValueError("native reference report lacks a complete matching repository gate")
    expected_pipeline = {"benchmarks/quantumcomputingbench/scripts/native_views.py",
                         "benchmarks/quantumcomputingbench/src/qcb_formal_views.py",
                         "benchmarks/quantumcomputingbench/src/qcb_lean.py"}
    if set(reference.get("pipeline_hashes", {})) != expected_pipeline:
        raise ValueError("native reference pipeline binding is incomplete")
    for path, sha in reference.get("pipeline_hashes", {}).items():
        if not (R / path).resolve().is_relative_to(R) or text_sha(R / path) != sha:
            raise ValueError("native reference-check pipeline changed")
    if not reference.get("pipeline_hashes") or not reference.get("sorry_control_rejected") or not reference.get("wrong_type_control_rejected"):
        raise ValueError("native reference report lacks pipeline bindings or actual negative controls")
    if (reference.get("negative_control", {}).get("reason") != "sorry_axiom"
            or reference.get("wrong_type_control", {}).get("reason") != "unproven"):
        raise ValueError("native replay lacks typed actual negative-control outcomes")
    reconstructed = {v["anonymous_id"]: v for v in decoder["views"]}
    verdicts = {v["anonymous_id"]: v for v in comparison["views"]}
    receipts = {v["view_id"]: v for v in reference["views"]}
    expected = {v["anonymous_id"] for v in batch["views"]}
    if (set(reconstructed) != expected or set(verdicts) != expected or len(receipts) != len(batch["views"])
            or len(decoder["views"]) != len(expected) or len(comparison["views"]) != len(expected)):
        raise ValueError("native formal review/reference coverage incomplete")
    admitted = {}
    for view in batch["views"]:
        review, receipt = verdicts[view["anonymous_id"]], receipts[view["view_id"]]
        if not reconstructed[view["anonymous_id"]].get("reconstructed_statement"):
            raise ValueError("native formal decoder did not provide mathematics")
        if review.get("verdict") != "accept":
            continue
        if (not review.get("reasoning") or review.get("question_contract_hash") != view["contract_hash"]
                or review.get("formal_context_digest") != digest(view["formal_context"])):
            raise ValueError("formal view semantic review does not bind its exact core and target")
        check_source_bindings(review["source_checks"])
        source, _ = build_harness({"id": view["view_id"], "formal_context": view["formal_context"]}, view["reference_proof"], "nativeReference")
        if (receipt.get("status") != "reference_checked" or receipt.get("source_sha256") != hashlib.sha256(source.encode()).hexdigest()
                or receipt.get("formal_context_digest") != digest(view["formal_context"])
                or not isinstance(receipt.get("axioms"), list) or receipt.get("sorry") is not False
                or set(receipt.get("axioms", [])) - APPROVED_AXIOMS):
            raise ValueError("native formal proof receipt has wrong target/source/axioms")
        admitted[view["core_id"]] = {"status": "reference_and_alignment_checked", "view_id": view["view_id"],
            "task_kind": view["task_kind"], "formal_context": view["formal_context"],
            "reference_proof": view["reference_proof"], "coverage": view["coverage"], "boundary": view["boundary"],
            "isolated": False, "execution_class": "trusted_local_reference",
            "batch_digest": digest(batch), "decoder_digest": digest(decoder), "comparison_digest": digest(comparison),
            "reference_report_digest": digest(reference), "evidence_directory": "reports/textbook-v1/formal-native",
            "nl_explanation_certified_by_kernel": False}
    return admitted, {"status": "admitted" if len(admitted) == len(batch["views"]) else "partially_admitted",
                       "candidate_views": len(batch["views"]), "admitted_views": len(admitted)}
