"""Serialize an inspected correction/diagnostic batch; zero model calls.

This is original authoring, not independent NL review. Reference Lean checks do
not admit these questions to the reviewed release. Old authoring is immutable.
"""
from copy import deepcopy
from pathlib import Path
import sys

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
from qcb_core import read_json, write_json
from qcb_integrity import text_sha

AUTHOR = {"identity": "codex-qcb-repair-2026-10-21", "method": "local source inspection and actual Lean reference regressions",
          "independence": "self-authored; independent NL/source review pending"}
old = {i["key"]: i for i in read_json(B / "data/authored/pilot.json")}
items = []


def correction(key, question, answer, criteria, step, roots):
    i = deepcopy(old[key])
    i.update(key=key + "-corrected-v3", supersedes=key, question=question,
             reference_answer=answer, author=AUTHOR, unresolved_issues=[],
             reference_checks=roots, semantic_steps=[{"claim": step,
                 "supporting_nodes": i["target_nodes"] + i["supporting_nodes"]}],
             rubric=[{"id": f"c{j}", "criterion": c, "weight": 1} for j, c in enumerate(criteria, 1)])
    # Never inherit a false semantic premise/convention from the withdrawn gold.
    if key == "qs-resource-depth-parallel-vs-serial":
        i["assumptions"] = ["r and s are the exact bookkeeping records specified in the question; no physical scheduling theorem is assumed"]
        i["conventions"] = ["Resource.add sums all fields; Resource.parallel maxes the recorded depth and pureAncilla fields, without certifying physical peak demand"]
    elif key == "neg-ry-not-half-only-at-pi":
        i["assumptions"] = ["alpha=0.7 is the real state-vector amplitude-plane angle; the amplitudes are cos(alpha) and sin(alpha)"]
        i["conventions"] = ["The RY argument equals the Bloch rotation angle 2*alpha; amplitudes use half that argument"]
    elif key == "neg-prepare-firstcolumn-positivity":
        i["conventions"] = ["One-qubit basis labels 0 and 1 correspond to PrimitiveBasis 1 assignments; splitAngle handles zero pair mass explicitly"]
    elif key == "k-becost-lexicographic-order":
        i["supporting_nodes"].append({"declaration": "QuantumBlockEncoding.Resource.gates"})
        i["source_refs"].append({"path": "QuantumBlockEncoding/Resources.lean", "sha256": text_sha(R / "QuantumBlockEncoding/Resources.lean"),
                                  "anchor": "Resource.gates", "license": "MIT (repository LICENSE)"})
    items.append(i)
    return i


correction("qs-resource-depth-parallel-vs-serial",
    "Resource.add sums all coordinates. Resource.parallel sums oneQubit, cnot and oracleCalls but takes max of depth and pureAncilla. For r=(2,3,1,1,4), s=(5,7,2,1,6) in that coordinate order, compute gates, depth and pureAncilla of both results. Does max ancilla alone certify physical peak usage for independent simultaneous subcircuits requiring disjoint clean ancillas?",
    "Serial: gates=20, depth=10, pureAncilla=2. Parallel bookkeeping: gates=20, depth=6, pureAncilla=1. These are values of the current Resource operations, not a scheduling/physical-resource theorem. Two simultaneous independent subcircuits each demanding one distinct ancilla need two ancillas: 1+1=2 > max(1,1)=1. Thus the max rule needs an explicit reuse/overlap/scheduling contract to represent physical peak usage. CircuitLayer is intended as parallel but the IR itself does not prove non-overlap. Do not infer a universal physical bound or change the library definition to hide this boundary.",
    ["All six numerical fields correct", "Separate defined bookkeeping from physical resource claims", "Give disjoint-unit-demand counterexample and required additional contract"],
    "Compute Resource fields, then refute the universal physical interpretation by disjoint simultaneous unit demands.",
    ["resourceWitness", "disjointDemandNotMax"])

i = correction("neg-prepare-firstcolumn-positivity",
    "The flat prepareMatrixLE_firstColumn API assumes all entries strictly positive. Is strict positivity mathematically necessary for this library's recursive real amplitude preparation? State the weaker prepareCircuit_firstColumn hypotheses, give a sparse nonzero input with a zero entry, and explain the all-zero subtree and all-zero input separately.",
    "No. The lower prepareCircuit_firstColumn theorem assumes pointwise nonnegativity and positive total squared norm. For one qubit, f(0)=1 and f(1)=0 is nonnegative with positive total mass and is prepared correctly, despite failing strict pointwise positivity. The flat API's strict positivity is sufficient to derive the lower hypotheses, not proof of necessity. splitAngle assigns angle zero when pairNorm=0; the proof handles zero subtrees without requiring every local branch to have nonzero mass. The all-zero input fails the positive global-mass premise and cannot be normalized to a unit vector. Lean's total division convention does not turn that vector into a normalized state.",
    ["Distinguish sufficient flat-API hypothesis from necessary conditions", "State nonnegative plus positive global normSq and sparse witness", "Explain zero subtree guard and global zero-vector obstruction"],
    "The lower theorem applies to a sparse nonnegative vector with positive global mass; splitAngle explicitly handles zero local mass.",
    ["sparseNonnegative", "sparseHasZero", "sparsePositiveMass", "sparseNotStrictlyPositive", "sparsePrepared", "zeroSplit"])
for name in ["prepareCircuit_firstColumn", "splitAngle", "normSq"]:
    node = {"declaration": "QuantumBlockEncoding.RealAmplitudePreparation." + name}
    if node not in i["supporting_nodes"]:
        i["supporting_nodes"].append(node)

correction("neg-ry-not-half-only-at-pi",
    "A proposed replacement changes standardRyMatrix(theta)=realRotation(theta/2) to realRotation(theta), claiming the half angle matters only at pi. Refute this using the target cos(alpha)|0>+sin(alpha)|1> for alpha=0.7. Distinguish the amplitude-plane angle alpha, the RY parameter, and the Bloch-sphere polar angle.",
    "The distinction holds generally, not only at pi. RY(theta)|0> has amplitudes (cos(theta/2),sin(theta/2)), so the target uses theta=2 alpha=1.4. Passing 0.7 instead produces amplitudes (cos(0.35),sin(0.35)). For this real great-circle state, the Bloch polar angle is 2 alpha: the RY parameter equals that Bloch angle, not twice it. The loader formula 2 arccos(c) doubles the amplitude-plane angle arccos(c), not the physical Bloch angle. Sign/phase conventions and arccos range must still be retained.",
    ["Correct half-angle matrix action and numerical parameters", "Distinguish amplitude angle from Bloch angle", "No claim that the RY parameter doubles the Bloch angle"],
    "Apply the half-angle definition; distinguish state-vector plane coordinates from Bloch coordinates.", ["halfAngle"])

correction("k-becost-lexicographic-order",
    "State BlockEncodingCost.betterThan's comparison order. Gate.resource of an unresolved oracle has oneQubit=0, cnot=0, oracleCalls=1, depth=1. Is its Resource.gates contribution zero? Does this score certify the oracle's expanded physical implementation cost?",
    "The strict lexicographic order is gateCount, then depth, then auxiliaryQubits, then oracleCalls. Resource.gates sums oneQubit+cnot+oracleCalls, so this oracle contributes one abstract gate, not zero. Zero local elementary-gate counts mean its physical implementation has not been expanded or certified, not that implementation is free. The score order is an explicit search-design choice, not a theorem derived from free oracle cost; physical/query/finite-bit comparisons require matched contracts.",
    ["Correct comparison order", "Oracle contributes one abstract Resource.gates unit", "Separate unresolved elementary implementation cost and score-design choice"],
    "Unfold Resource.gates on Gate.resource(.oracleCall); inspect the lexicographic predicate without inferring a physical cost certificate.", ["oracleAbstractGate"])

for key, module, target, proof, root in [
    ("lean-standardRyMatrix-zero", "QuantumBlockEncoding.PrimitiveSemantics",
     "QuantumBlockEncoding.standardRyMatrix 0 = 1", "by exact QuantumBlockEncoding.standardRyMatrix_zero", "ryZero"),
    ("lean-flipBit-involutive", "QuantumBlockEncoding.PrimitiveSemantics",
     "∀ bit : Fin 2, QuantumBlockEncoding.flipBit (QuantumBlockEncoding.flipBit bit) = bit",
     "by exact QuantumBlockEncoding.flipBit_flipBit", "flipInvolution"),
    ("lean-planeMatrix-det-applicability", "QuantumBlockEncoding.AdjacentGivens",
     "∀ {N : ℕ} (i j : Fin N), i ≠ j → ∀ theta : ℝ, (QuantumBlockEncoding.AdjacentGivens.planeMatrix i j theta).det = 1",
     "by exact QuantumBlockEncoding.AdjacentGivens.planeMatrix_det", "planeDet")]:
    i = deepcopy(old[key])
    i.update(key=key + "-corrected-v3", supersedes=key, author=AUTHOR,
             question="Supply a fully qualified lemma-application proof of the frozen formal target. Reusing the imported theorem is permitted; this tests interface application, not novel theorem discovery. Return only the proof term.",
             reference_answer=proof, reference_checks=[root], unresolved_issues=[],
             rubric=[{"id": "formal", "criterion": "Proof elaborates against the unchanged fully qualified target and satisfies the axiom policy", "weight": 1}],
             formal={"imports": [module], "target": target, "reference_proof": proof,
                     "approved_axioms": ["propext", "Classical.choice", "Quot.sound"]})
    # Questions must remain distinct even when the requested response format agrees.
    i["question"] += " Target: " + target
    i["difficulty"] = {"level": "easy", "rationale": "Approved imported lemma application with exact hypothesis matching; not proof synthesis."}
    i["semantic_steps"] = [{"claim": "Apply the exact imported declaration to the frozen fully qualified target without adding assumptions.",
                            "supporting_nodes": i["target_nodes"]}]
    items.append(i)


def exact(key, question, answer, family, targets, sources, roots, claim, topic="library boundary diagnostics"):
    nodes = ["declaration:" + t for t in targets]
    items.append({"key": key, "topic": topic, "track": "reasoning", "question": question,
        "reference_answer": answer, "answer_format": "exact", "family": family,
        "target_nodes": nodes[:1], "supporting_nodes": nodes[1:],
        "assumptions": ["Use the current library definitions; return exactly the specified answer format"],
        "conventions": ["Exact symbolic bookkeeping; no unproved physical interpretation"],
        "semantic_steps": [{"claim": claim, "supporting_nodes": nodes}],
        "rubric": [{"id": "exact", "criterion": "Exact answer under the stated formatting contract", "weight": 1}],
        "difficulty": {"level": "intermediate", "rationale": "Library-specific boundary or multi-coordinate calculation; step count is not graph distance."},
        "source_refs": [{"path": p, "sha256": text_sha(R / p), "anchor": a, "license": "MIT (repository LICENSE)"} for p,a in sources],
        "author": AUTHOR, "formal": None, "evidence_status": "source_inspected",
        "unresolved_issues": [], "reference_checks": roots})

exact("exact-resource-six-coordinates-v3",
    "Let r=Resource.ofCountsWithDepth 2 3 1 1 4 and s=Resource.ofCountsWithDepth 5 7 2 1 6. Return [add.gates,add.depth,add.pureAncilla,parallel.gates,parallel.depth,parallel.pureAncilla] as compact JSON with no spaces.",
    "[20,10,2,20,6,1]", "resource-accounting", ["QuantumBlockEncoding.Resource.parallel", "QuantumBlockEncoding.Resource.add", "QuantumBlockEncoding.Resource.gates"],
    [("QuantumBlockEncoding/Resources.lean", "Resource.add/parallel/gates")], ["resourceWitness"], "Unfold both operations, then sum all three gate-count fields.")
exact("exact-oracle-abstract-unit-v3",
    "For Gate.resource(.oracleCall(name)), return [oneQubit,cnot,oracleCalls,gates] as compact JSON with no spaces. Do not substitute the unknown expanded implementation cost.",
    "[0,0,1,1]", "block-encoding-cost", ["QuantumBlockEncoding.Gate.resource", "QuantumBlockEncoding.Resource.gates"],
    [("QuantumBlockEncoding/Circuit.lean", "Gate.resource"), ("QuantumBlockEncoding/Resources.lean", "Resource.gates")], ["oracleResourceTuple"], "An unresolved oracle has one abstract gate unit despite zero expanded local elementary counts.")
exact("exact-clog2-boundaries-v3",
    "Using the library ceiling-address-width convention, return [clog2(0),clog2(1),clog2(2),clog2(3),clog2(4),clog2(5),clog2(8)] as compact JSON without spaces.",
    "[0,0,1,2,2,3,3]", "core-vocabulary", ["QuantumBlockEncoding.clog2"],
    [("QuantumBlockEncoding/Core.lean", "clog2")], ["addressBoundary"], "Compute the guarded Nat.log2(m-1)+1 definition, including 0 and 1.")
exact("exact-sparse-strict-necessity-v3",
    "A one-qubit input has f(0)=1 and f(1)=0. Is it excluded by prepareCircuit_firstColumn's hypotheses solely because one entry is zero? Return exactly yes or no.",
    "no", "real-amplitude-preparation", ["QuantumBlockEncoding.RealAmplitudePreparation.prepareCircuit_firstColumn", "QuantumBlockEncoding.RealAmplitudePreparation.normSq"],
    [("QuantumBlockEncoding/RealAmplitudePreparation.lean", "prepareCircuit_firstColumn / normSq")], ["sparsePrepared", "sparseNotStrictlyPositive"], "Global positive mass and pointwise nonnegativity allow this sparse vector.")
exact("exact-zero-subtree-angle-v3",
    "When a recursive amplitude split has a=b=0, what rational angle does splitAngle choose? Return exactly the integer 0 if it chooses rational zero, or undefined if it has no value.",
    "0", "real-amplitude-preparation", ["QuantumBlockEncoding.RealAmplitudePreparation.splitAngle"],
    [("QuantumBlockEncoding/RealAmplitudePreparation.lean", "splitAngle / pairNorm")], ["zeroSplit"], "The zero-mass guard explicitly selects rational zero.")

write_json(B / "data/authored/repairs-v3.json", items, immutable=True)
print(f"Serialized {len(items)} self-authored candidates, independent review pending.")
