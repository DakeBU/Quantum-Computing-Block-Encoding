"""Bounded native-math expansion serialized from individually inspected sources.
No model call, no Lean execution, no name-recall templates.
"""
from pathlib import Path
import hashlib,json
B=Path(__file__).resolve().parents[1];R=B.parents[1]
items=[]
def add(number,topic,kind,q,a,target,support,source,anchor,steps,rubric):
 nodes=['declaration:'+n for n in [target]+support]
 items.append({'core_id':f'qcb-core-la-{number:03}','key':f'qcb-core-la-{number:03}','topic':topic,'track':'reasoning' if kind!='concept' else 'quantum_semantics','task_kind':kind,
 'question':q,'reference_answer':a,'rubric':[{'id':f'c{j+1}','criterion':v,'weight':1} for j,v in enumerate(rubric)],
 'target_nodes':nodes[:1],'supporting_nodes':nodes[1:],'assumptions':['Finite-dimensional complex Hilbert spaces unless real amplitudes are explicitly specified','All basis/register permutations are fixed and applied to both input and output'],
 'conventions':['Column-vector action; Euclidean induced operator norm for norm claims','Source inspection only; no fresh formal verification'],
 'semantic_steps':[{'claim':s,'supporting_nodes':[nodes[k] for k in refs]} for s,refs in steps],
 'difficulty':{'level':'intermediate','rationale':'A complete mathematical derivation with explicit boundary or convention, not interface recall.'},
 'source_refs':[{'path':source,'sha256':hashlib.sha256((R/source).read_bytes().replace(b'\r\n',b'\n')).hexdigest(),'anchor':anchor,'license':'MIT (repository LICENSE)'}],
 'family':f'native-expansion-mechanism-{number:03}','answer_format':'rubric','evidence_status':'source_inspected','formal':None,'unresolved_issues':[],
 'native_nl':{'core_summary':q,'evidence_relation':'nl_bridge_from_inspected_source','formal_counterpart':'none','author_identity':'main-native-expansion-author','new_problem_core':True,'existing_core_aliases':[]}})

add(13,'wire_placement','proof',
'Let P permute computational-basis labels and let a circuit have chronological matrices U1,...,Ut. Prove that consistently renaming every wire realizes P(Ut...U1)P inverse rather than inserting a physical permutation gate. Explain why output-only relabeling would fail to preserve circuit multiplication.',
'Renaming one stage consistently gives P Uj P inverse. Multiplying chronological stages, each adjacent P inverse P cancels, so the product is P(Ut...U1)P inverse. Both boundary label maps are essential. Output-only relabeling gives P Uj, and two stages multiply as P U2 P U1, which generally differs from P(U2U1). For example choose a nontrivial involutive permutation P and both stages identity: output-only gives P squared=I rather than P. Consistent renaming is a representation/placement operation; it does not supply a free physical SWAP on an already fixed hardware layout.',
'QuantumBlockEncoding.PrimitiveWireRename.eval_circuit',['QuantumBlockEncoding.PrimitiveWireRename.matrix_mul','QuantumBlockEncoding.PrimitiveWireRename.eval_gate'],
'QuantumBlockEncoding/PrimitiveWireRename.lean','matrix_mul lines35-38; eval_gate83-109; eval_circuit111-118; module placement boundary',
[('Each stage is conjugated by the same basis permutation.',[2]),('Interior inverse/permutation pairs cancel through the product.',[0,1]),('Output-only relabeling lacks cancellation, as identity-stage counterexample shows.',[1])],
['Derive conjugation not one-sided permutation','Give valid failure of output-only relabeling','Distinguish representation renaming from physical SWAP'])

add(14,'wire_placement','concept',
'A circuit uses only single-qubit rotations, bit flips and controlled bit flips. A bijection relabels all physical wires, preserving which wire controls which target. Which of total instruction count, rotation count and controlled-bit-flip count must stay unchanged? Does this alone prove equal nearest-neighbor routing cost on fixed hardware?',
'All three logical counts stay unchanged: map each instruction to the same kind with relabeled target/control, so there is a one-to-one position-preserving correspondence of lists. Counting all positions, rotation positions or controlled-bit-flip positions therefore yields equal counts. Hardware routing cost need not stay unchanged because the permutation can map an adjacent control-target pair to a distant pair while the hardware graph is fixed. Equal logical counts are a semantic placement invariant, not an assumption that connectivity or physical SWAP overhead is free.',
'QuantumBlockEncoding.PrimitiveWireRename.gateCount',['QuantumBlockEncoding.PrimitiveWireRename.ryCount','QuantumBlockEncoding.PrimitiveWireRename.cxCount'],
'QuantumBlockEncoding/PrimitiveWireRename.lean','gate/circuit16-23; count theorems120-133 and module header',
[('Wire renaming maps each instruction to the same instruction kind.',[0]),('Count positions of each kind to preserve all logical counts.',[0,1,2]),('Fixed hardware distance is outside this semantic bijection.',[0])],
['All three logical counts invariant','Preserve control-target roles','No inferred physical routing equality'])

add(15,'angle_approximation','proof',
'Define R(theta)=[[cos(theta/2),-sin(theta/2)],[sin(theta/2),cos(theta/2)]]. Derive the exact operator distance between R(a) and R(b), and prove it is at most |a-b|/2. Why does adding any number of untouched spectator qubits not multiply the distance by a dimension factor?',
'Trigonometric sum-difference formulas factor R(a)-R(b)=2 sin((a-b)/4) R((a+b)/2+pi). The second factor is unitary, so its induced Euclidean operator norm is1, giving exactly 2|sin((a-b)/4)|. Since |sin x|<=|x|, the distance is <=|a-b|/2. Adding identity spectators, with any fixed wire placement, tensors the difference with an identity and conjugates by a permutation. The identity has norm1 and unitary conjugation preserves the norm; hence the same scalar-times-unitary factorization has no dimension multiplier. This is uniform operator error, not entrywise error or a finite-bit synthesis algorithm.',
'QuantumBlockEncoding.PrimitiveRyPerturbation.liftedRy_distance',['QuantumBlockEncoding.PrimitiveRyPerturbation.standardRy_difference_factor','QuantumBlockEncoding.PrimitiveRyPerturbation.liftedRy_distance_le'],
'QuantumBlockEncoding/PrimitiveRyPerturbation.lean','difference_factor28-37; liftedRy factor54-59; distance61-79',
[('Use sum-difference identities to factor the difference by a unitary.',[1]),('Take scalar-times-unitary norm to obtain the exact sine expression.',[0]),('Apply sine Lipschitz bound; spectator lift remains unitary.',[0,2])],
['Exact quarter-angle sine formula','Correct linear bound factor1/2','Explain dimension independence in induced norm'])

add(16,'phase_semantics','counterexample',
'For the real rotation R(theta)=[[cos(theta/2),-sin(theta/2)],[sin(theta/2),cos(theta/2)]], compare R(theta+2pi) and R(theta). A colleague claims the two full operators have distance0 because every output probability agrees. Refute or prove that claim, and distinguish bare-system global-phase equivalence from coherent branch use.',
'Both sine and cosine change sign after adding pi to their arguments, so R(theta+2pi)=-R(theta). Their difference is -2R(theta), whose induced operator norm is2, not0. Bare-system output probabilities agree because the sign is a global phase. In a coherent controlled use, however, applying the minus sign only on the active control branch introduces a relative phase between control branches. Thus probabilities on one isolated output do not establish equality of operators; an error metric modulo global phase is different from the exact operator-norm contract. Equivalently the exact distance formula gives2|sin(2pi/4)|=2.',
'QuantumBlockEncoding.PrimitiveRyPerturbation.liftedRy_distance',['QuantumBlockEncoding.PrimitiveRyPerturbation.standardRy_difference_factor'],
'QuantumBlockEncoding/PrimitiveRyPerturbation.lean','exact difference factor and exact operator distance28-68',
[('A2pi parameter shift negates both matrix sine/cosine entries.',[1]),('Unitary norm gives distance2 despite unchanged probabilities.',[0]),('A controlled branch sign is relative rather than globally shared.',[0])],
['Distance2 not0','Explain probability agreement without operator equality','State exact-vs-phase-quotiented metric distinction'])

add(17,'reversible_classical','proof',
'A reversible gate flips a target bit exactly when two control bits are both1. Assume each control wire is distinct from the target, but allow the two control wires to coincide. Prove the gate is its own inverse and explain what it reduces to when the controls coincide.',
'If the control predicate is false, the gate leaves the whole bit string unchanged, so a second application also does nothing. If true, it flips only the target; each control remains1 because neither control is the target. Thus the predicate remains true for the second application, which flips the target back. All other bits stay fixed, proving involution. If the two controls coincide, the condition c=1 and c=1 is just c=1, so the action reduces to one controlled bit flip. Pairwise-distinct controls are required by some instruction encodings but not by this involution argument; control-target distinctness is the load-bearing condition.',
'QuantumBlockEncoding.ccxBasisAction_involutive',['QuantumBlockEncoding.ccxBasisAction','QuantumBlockEncoding.ccxBasisEquiv'],
'QuantumBlockEncoding/ReversibleClassical.lean','ccxBasisAction24-28; involutive30-50; equivalence52-61',
[('Separate inactive and active control cases.',[1]),('Active control values survive the target flip by wire distinctness.',[0]),('Two target flips cancel; coincident controls collapse to a single predicate.',[0,2])],
['Complete two-case inverse argument','Correct minimal distinctness assumptions','Identify coincident-control reduction'])

add(18,'reversible_classical','counterexample',
'On a two-bit string(c,t), consider the update that flips c itself when c=t=1 and otherwise does nothing. Does the familiar self-inverse proof for a two-control target flip remain valid when one control is also the target? Give a concrete collision and explain the lost hypothesis.',
'No. The input(1,1) is sent to(0,1), while(0,1) already fails the activation predicate and is left at(0,1). Two distinct inputs therefore collide, so this map is not injective and cannot be reversible or unitary on basis states. Applying it twice to(1,1) does not return the original state: after the first flip the control predicate became false. The usual involution proof uses that flipping the target preserves all control bits, which fails exactly when a control coincides with the target. This is a mathematical counterexample, not a compiler rejection.',
'QuantumBlockEncoding.ccxBasisAction',['QuantumBlockEncoding.ccxBasisAction_involutive'],
'QuantumBlockEncoding/ReversibleClassical.lean','basis action24-28; control-target hypotheses and preserved controls30-49',
[('Evaluate active input(1,1) to(0,1).',[0]),('Evaluate inactive input(0,1) to itself, exposing collision.',[0]),('Identify failed preservation premise of the inverse proof.',[1])],
['Explicit collision of two inputs','Explain activation predicate changes','Conclude noninjective not just unsupported API'])

out=B/'data/native_nl/expansion1.json'
out.write_text(json.dumps(items,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print('Wrote',len(items),'new substantive expansion candidates')
