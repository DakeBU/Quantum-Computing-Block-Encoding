"""Author a bounded original breadth batch from individually inspected sources.

No template expansion or generated name-recall: each item below has its own
mathematical contract. This script only serializes curated original authoring.
"""
from pathlib import Path
import hashlib
import json
B = Path(__file__).resolve().parents[1]
R = B.parents[1]
items = []

def add(key, topic, track, question, answer, assumptions, conventions, sources, targets, supports, steps, criteria):
    nodes = ['declaration:'+x for x in targets+supports]
    items.append(dict(key=key,topic=topic,track=track,question=question,reference_answer=answer,
        rubric=[dict(id=f'c{i+1}',criterion=c,weight=1) for i,c in enumerate(criteria)],
        target_nodes=nodes[:len(targets)],supporting_nodes=nodes[len(targets):],assumptions=assumptions,
        conventions=conventions,semantic_steps=[dict(claim=s,supporting_nodes=[nodes[j] for j in refs]) for s,refs in steps],
        difficulty=dict(level='intermediate',rationale='Track the exact mathematical hypotheses, construction and evidence boundary; steps explicitly mapped.'),
        source_refs=[dict(path=p,sha256=hashlib.sha256((R/p).read_bytes()).hexdigest(),anchor=a,license='MIT (repository LICENSE)') for p,a in sources],
        family=key,answer_format='rubric',evidence_status='source_inspected',formal=None,unresolved_issues=[],
        author=dict(identity='main-session-breadth-author',method='actual complete declarations and bounded ambient source inspected',independence='self-authored; distinct reviewer required')))

add('breadth-cubic-unnormalized-operator','cubic_preparation','reasoning',
'For n=1, let v_j=(j/2)^3 for j=0,1. Can a unitary map |0> exactly to this v? Compute its squared norm and state the action of the library rank-one cubicOperator on both basis vectors. Distinguish this operator target from a normalized state-preparation target.',
'v=(0,1/8), so ||v||^2=1/64, not 1. A unitary preserves the norm of |0>, hence cannot produce this unnormalized vector exactly. cubicOperator has only its zero-th column nonzero: O|0>=v and O|1>=0. It is a rank-one, generally nonunitary operator target for block encoding with an explicit normalizer, not a certificate of normalized state loading. For n=1 the corresponding normalized vector is |1>, but replacing v by |1> changes the advertised target. The conservative normalizer 2^n is not claimed optimal.',
['n=1 for the numerical witness','Column-vector basis action; rational coefficients embedded into a real/complex vector'],
['j runs from 0 to 2^n-1','Operator normalization is not state normalization'],
[('QuantumBlockEncoding/CubicStatePreparation.lean','gridPoint/cubicAmplitude/cubicOperator/cubicNormSq/conservativeNormalizer, lines30-61')],
['QuantumBlockEncoding.CubicStatePreparation.cubicOperator'],['QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude','QuantumBlockEncoding.CubicStatePreparation.cubicNormSq'],
[('Evaluate the two cubic amplitudes, then sum their squared magnitudes.',[1,2]),('Use norm preservation to refute the unitary state-action claim and inspect the two operator columns.',[0])],
['Compute v and norm squared correctly','Explain the unitary norm obstruction','Distinguish rank-one operator and normalized state target'])

add('breadth-banded-inverse-register','banded_sparse_access','reasoning',
'Let L be a permutation of Z/(2^n). The banded access map loads the address first and then adds the preserved row: F(a,r)=(L(a)+r,r). Derive F inverse, explain why row preservation alone is not a loader specification, and identify the extra premise needed to get F(slot,r)=(offset(slot)+r,r). Does this semantic permutation certify the printed gate-count bounds?',
'Undo SUM before undoing the loader: F^{-1}(b,r)=(L^{-1}(b-r),r). Substitution in either order proves the inverse because the second register is unchanged and L is a permutation. Row preservation holds for every input but gives no information about L(slot). The clean-slot theorem additionally requires forall slot, L(slotWord n slot)=offset(slot). With that premise, substitute into F. The permutation induces a unitary matrix, but the paper gate-count formulas are only source-facing bounds here; a general executable loader/modular-adder compiler is a separate obligation.',
['n is a natural number','L is an actual permutation of Word n','Arithmetic is modulo 2^n'],
['First register overwritten, second register preserved','Inverse composition reverses operation order'],
[('QuantumBlockEncoding/BandedSparseAccess.lean','modularSumEquiv/liftLoaderEquiv/accessEquiv, clean_slot, preserves_row, matrix_unitary; lines20-85 and module boundary')],
['QuantumBlockEncoding.BandedSparseAccess.accessEquiv_clean_slot'],['QuantumBlockEncoding.BandedSparseAccess.accessEquiv','QuantumBlockEncoding.BandedSparseAccess.modularSumEquiv','QuantumBlockEncoding.BandedSparseAccess.accessMatrix_unitary'],
[('Invert modular SUM by subtracting the unchanged row.',[2]),('Apply L inverse after subtraction and verify both compositions.',[1]),('Supply loader_spec separately for clean slots; distinguish semantics from compiled cost.',[0,3])],
['Correct inverse and register order','Retain loader_spec premise','Do not promote semantic unitarity to executable resource closure'])

add('breadth-ghl-hermitian-pieces','ghl_hamiltonian','reasoning',
'For an arbitrary finite complex matrix A define H=(A+A dagger)/2 and K=(A-A dagger)/(2i). Is K anti-Hermitian or Hermitian? Prove the correct claim and reconstruct A. Then apply the identity to S=[[A,B],[0,0]] without assuming A or B Hermitian.',
'K is Hermitian despite the name antiHermitianPart: taking adjoints conjugates 1/(2i) to -1/(2i) and changes A-A dagger to its negative, so the signs cancel. H dagger=H by swapping its two summands. H+iK=(A+A dagger)/2+(A-A dagger)/2=A. These identities hold for every complex matrix. Substituting S yields S=S1+iS2, with both pieces Hermitian; neither original A nor B must be Hermitian for this decomposition. The extra B-Hermitian premise is needed only for a simplified lower-left block formula, not for the general split. This is matrix algebra, not arbitrary-width primitive oracle synthesis.',
['Finite complex matrix with matching row/column index type','2i is nonzero in C'],
['dagger is conjugate transpose','The antiHermitianPart identifier denotes division by 2i, yielding a Hermitian matrix'],
[('QuantumBlockEncoding/GHLHamiltonian.lean','adjoint/IsHermitian/hermitianPart/antiHermitianPart; decomposition and S1/S2 theorems, lines47-136')],
['QuantumBlockEncoding.GHL2025.Hamiltonian.hermitian_decomposition'],['QuantumBlockEncoding.GHL2025.Hamiltonian.hermitianPart_isHermitian','QuantumBlockEncoding.GHL2025.Hamiltonian.antiHermitianPart_isHermitian','QuantumBlockEncoding.GHL2025.Hamiltonian.homogenizedS_eq_S1_add_iS2'],
[('Conjugating the imaginary denominator cancels the sign change of A-A dagger.',[2]),('H is Hermitian and H+iK reconstructs A.',[0,1]),('Substitute homogenized S; no Hermitian A/B assumptions are required.',[3])],
['K Hermitian with both sign changes','Correct reconstruction and general hypotheses','Separate matrix composition from circuit compilation'])

add('breadth-robin-norm-convention-counterexample','robin_matrix','reasoning',
'The implementation matrixOneNorm takes the maximum absolute ROW sum. For M=[[1,2],[0,0]], compute this quantity and the standard induced column-vector l1 operator norm. Explain the convention mismatch and whether a definition docstring can certify their equality.',
'The implementation row sums are 3 and 0, so matrixOneNorm returns 3. The standard induced column-vector l1 norm is the maximum absolute COLUMN sum: max(1,2)=2. Thus the implementation quantity is the standard induced infinity norm (for this ordinary numeric matrix), not the standard induced l1 norm. No docstring or nearby normalization claim proves equality of the two conventions. Any downstream use calling it a 1-norm needs an explicit convention/transpose adapter or source correction; this benchmark records the mismatch without changing historical library proofs.',
['Numeric real/rational matrix M with the stated entries','Standard column-vector l1 norm convention'],
['Library definition is authoritative for computation, its norm label is separately audited','No change to the production definition'],
[('QuantumBlockEncoding/RobinMatrix.lean','matrixRowAbsSum and matrixOneNorm, lines92-109')],
['QuantumBlockEncoding.matrixOneNorm'],['QuantumBlockEncoding.matrixRowAbsSum'],
[('Evaluate implementation maximum row sum to 3.',[0,1]),('Compute standard column-sum norm 2 and use inequality as the concrete counterexample.',[0])],
['Correct row sum 3 and column sum 2','Identify infinity-vs-l1 distinction','Do not claim unsupported source/certificate equivalence'])

add('breadth-hermite-resource-scope','hermite_resources','quantum_semantics',
'For k,n natural and L>0, unpack exists_polynomial_resources: how many wires does its circuit use, what are the gate/depth/oracle bounds, and what happens for a nonzero bond output b on the all-zero input? Does the result supply a finite-bit Clifford+T implementation?',
'The circuit uses (n+1)+bondQubits(k) wires. Both gate count and the actual scheduled resource.depth are at most 48(n+1)(2k+6)^3; resource.oracleCalls=0. The matrix is unitary. With the data register x first and the bond register b appended, its all-zero input column equals normalizedAmplitude(k,n+1,L,primitiveBasisLEEquiv(x)) when b=0 and exactly zero otherwise, so the bond returns clean. Depth is obtained from resource_depth_le_gateCount and the gate bound, not from import distance. This is an exact-real primitive statement; it does not furnish finite-bit angle extraction, Clifford+T synthesis, or free classical input processing.',
['k,n natural; L strictly positive','Exact primitive real-angle gate model'],
['Data register first, clean bond appended','Zero oracle calls is a circuit metadata result, not universal free input construction'],
[('QuantumBlockEncoding/HermitePolynomialResources.lean','exists_polynomial_resources complete theorem lines11-24')],
['QuantumBlockEncoding.HermitePolynomialPreparation.exists_polynomial_resources'],[],
[('Read the wire count and gate/depth/oracle conjuncts with L>0.',[0]),('Use the b=0 conditional to separate target data amplitudes from zero dirty-bond sectors.',[0])],
['All resource coordinates and L>0 correct','Clean bond and register order correct','No finite-bit complexity overclaim'])

add('breadth-hermite-angle-budget','primitive_perturbation','reasoning',
'An exact Hermite circuit has at most G=48(n+1)(2k+6)^3 primitive instructions. Assuming positional alignment with only RY angles changed on the same targets by at most delta>=0, derive a sufficient delta for operator error <=epsilon, epsilon>=0. Explain why a small gate-count difference or basis-state probability match alone cannot replace alignment.',
'The aligned telescoping theorem gives induced L2 operator error <=length*delta/2: each RY difference is <=delta/2, unchanged gates contribute zero, and surrounding unitaries preserve operator norm. Choose delta=epsilon/[24(n+1)(2k+6)^3]=2epsilon/G. Then length*delta/2<=G*delta/2=epsilon. Denominators are positive for natural k,n, including epsilon=0. Positional Forall2 alignment retains list length, target wires and every non-RY instruction; no gates are commuted. Equal counts or probabilities on one input do not ensure this structural relation or uniform operator norm. The theorem assumes an aligned approximate circuit, not a free rounding algorithm or synthesized finite-bit supplier.',
['epsilon>=0; k,n natural','Aligned approximate circuit supplied with same physical targets and only permitted RY changes'],
['Chronological eval(g::rest)=eval(rest)*eval(g)','Induced Euclidean L2 operator norm, not entrywise norm or output-distribution distance'],
[('QuantumBlockEncoding/PrimitiveCircuitPerturbation.lean','GateAligned, Aligned, distance_le, aligned_eval_distance_le, hermiteAngleBudget, prepare_conditional_distance_le; lines16-119')],
['QuantumBlockEncoding.PrimitiveCircuitPerturbation.prepare_conditional_distance_le'],['QuantumBlockEncoding.PrimitiveCircuitPerturbation.aligned_eval_distance_le','QuantumBlockEncoding.PrimitiveCircuitPerturbation.GateAligned.distance_le','QuantumBlockEncoding.PrimitiveCircuitPerturbation.hermiteAngleBudget'],
[('Each aligned gate contributes at most delta/2.',[2]),('Telescoping unitary products accumulates at most length*delta/2.',[1]),('Insert gate-count bound and delta=2epsilon/G, preserving alignment as a premise.',[0,3])],
['Correct factor 24 and half-angle','Retain structural alignment and norm convention','No free angle-rounding or probability-only certificate'])

add('breadth-stored-projection-cost','stored_exact_real_cost','reasoning',
'For m stored StageRun values f(i), collectStages_total_cost states ordinary(collectStages f)=sum_i ordinary(f(i))+6m. Explain the 6m, evaluate total ordinary work for m=3 when each stage has ordinary work 10, and distinguish these counts from arbitrary-precision bit complexity.',
'The collection/projection passes add three reads and three writes per stage, so the overhead is 6m; it is not zero just because stage producers are cached. For three stages of cost10 each, total ordinary work is30+18=48. ordinary sums eight named operation categories field,sqrt,angle,trig,compare,read,write,emit; ordinary_eq_total identifies that sum with the existing stored cost total. Selected integer/exponential counters are separately scoped and are not arbitrary-precision bit work, all indexing, proof checking, or a normalized state-preparation compiler. A unit charge for an exact-real transcendental operation is not a bit-runtime theorem.',
['m=3 for numerical example; arbitrary m for stated collection identity','Cost records use the defined eight-operation model'],
['Stored reads/writes charged explicitly','Exact-real operation counts kept separate from finite-bit implementation costs'],
[('QuantumBlockEncoding/StoredHermiteRawCost.lean','module scope; ordinary_eq_total and collectStages_cost/collectStages_total_cost, lines4-29,78-93')],
['QuantumBlockEncoding.StoredHermiteRawCost.collectStages_total_cost'],['QuantumBlockEncoding.StoredHermiteRawCost.collectStages_cost','QuantumBlockEncoding.StoredHermiteRawCost.ordinary_eq_total'],
[('Three reads plus three writes per stage sum to 6m.',[0,1]),('For m3 and work10 each evaluate 3*10+6*3=48; preserve exact-real cost boundary.',[0,2])],
['Overhead6m and numerical48 correct','Count cached projection work','Do not infer finite-bit runtime'])

add('breadth-bell-chronological-wires','bell_preparation','quantum_semantics',
'Using the library little-endian q0 convention, apply RY(pi/2) on q0 to |00>, then CX(q0,q1). Give the nonzero basis labels after each operation and the final resource tuple. Why is it wrong to describe the intermediate label1 as the big-endian q0=0,q1=1 convention without an adapter?',
'RY(pi/2) uses a pi/4 half-angle, producing equal positive amplitudes at integer labels0 and1: label1 is q0=1,q1=0 in the little-endian encoding. Controlled-X with controlq0 and targetq1 sends that label1 to label3 while label0 stays0, yielding (|00>+|11>)/sqrt2, no relative minus sign. bellVerified_cost records auxiliaryQubits0, gateCount2, depth2, oracleCalls0 for exactly this two-instruction list. The statement is about the specified wire order; interpreting label1 with the other endian convention changes which qubit is excited and invalidates the intermediate-map explanation unless a basis permutation is supplied.',
['Initial two-qubit all-zero state','Exact angle pi/2; control wire0 distinct from target wire1'],
['Little-endian label=sum_j bit_j 2^j','Chronological RY then CX; positive Bell amplitudes'],
[('QuantumBlockEncoding/StatePreparationBellRoute.lean','module convention, bellRyAngle, bellAfterRy, bellRy_col_zero, bellPrimitive_prepares_target, bellVerified_cost')],
['QuantumBlockEncoding.StatePreparationBenchmarks.bellVerified_cost'],['QuantumBlockEncoding.StatePreparationBenchmarks.bellRy_col_zero','QuantumBlockEncoding.StatePreparationBenchmarks.bellPrimitive_prepares_target'],
[('RY half-angle yields equal amplitudes at labels0,1.',[1]),('CX sends1 to3, preserving0; final Bell state and actual cost tuple.',[0,2])],
['Correct intermediate and final basis labels','Positive relative phase and chronological order','Resource tuple with no ancilla and no oracle'])

output = B/'data/authored/breadth.json'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(json.dumps(items,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(f'Wrote {len(items)} source-inspected original breadth candidates')
