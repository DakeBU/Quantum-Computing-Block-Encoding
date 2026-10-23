"""Two original mathematical expansion cores, no formal execution."""
from pathlib import Path
import json,hashlib
B=Path(__file__).resolve().parents[1];R=B.parents[1]
def source(path,anchor):return {'path':path,'sha256':hashlib.sha256((R/path).read_bytes().replace(b'\r\n',b'\n')).hexdigest(),'anchor':anchor,'license':'MIT (repository LICENSE)'}
def core(number,topic,question,answer,targets,support,steps,criteria,refs):
 ids=['declaration:'+n for n in targets+support]
 return {'core_id':f'qcb-core-la-{number:03}','key':f'qcb-core-la-{number:03}','topic':topic,'track':'reasoning','task_kind':'proof','question':question,'reference_answer':answer,
 'rubric':[{'id':f'c{j+1}','criterion':t,'weight':1} for j,t in enumerate(criteria)],'target_nodes':ids[:len(targets)],'supporting_nodes':ids[len(targets):],
 'assumptions':['Finite-dimensional complex matrices; ordinary conjugate transpose','All declared products have compatible dimensions'],
 'conventions':['Tensor factors ordered as written; stencil offsets are ordinary integers, not modular wrapping','Original derivation from inspected local source; no fresh Lean verification'],
 'semantic_steps':[{'claim':text,'supporting_nodes':[ids[k] for k in mapping]} for text,mapping in steps],
 'difficulty':{'level':'intermediate','rationale':'Explicit several-step proof with a convention or missing-hypothesis counterexample.'},'source_refs':refs,
 'family':f'native-mathematical-expansion-{number:03}','answer_format':'rubric','evidence_status':'source_inspected','formal':None,'unresolved_issues':[],
 'native_nl':{'core_summary':question,'evidence_relation':'nl_bridge_from_inspected_source','formal_counterpart':'none','author_identity':'main-native-expansion2-author','new_problem_core':True,'existing_core_aliases':[]}}
x=[]
x.append(core(19,'hamiltonian_composition',
'Let S and T be Hermitian matrices on one finite system and X a Hermitian matrix on a second system. Prove that H=S tensor X+T tensor I is Hermitian without assuming that S and T commute. Give a counterexample showing that the same conclusion can fail if X is not Hermitian.',
'The adjoint of a tensor product is the tensor product of the adjoints: entrywise, conjugating S(j,i)X(v,u) gives S(i,j)X(u,v) under Hermiticity of both factors. Hence (S tensor X) dagger=S tensor X. Similarly T tensor I is Hermitian because I dagger=I. Adjoint is additive, so H dagger=H. No product S T occurs anywhere in this argument, so S and T need not commute. The premise on X matters: take the first system one-dimensional with S=[1], T=[0], and X=[[0,1],[0,0]]. Then H=X, whereas X dagger=[[0,0],[1,0]] is different. This is an operator-algebra closure result, not a claim that implementing the factors or reading out a simulated evolution is free.',
['QuantumBlockEncoding.GHL2025.Hamiltonian.tensor_isHermitian','QuantumBlockEncoding.GHL2025.Hamiltonian.add_isHermitian'],
['QuantumBlockEncoding.GHL2025.Hamiltonian.tensor','QuantumBlockEncoding.GHL2025.Hamiltonian.oneDimHamiltonian_isHermitian'],
[('Check the tensor adjoint identity entry by entry and use both Hermitian premises.',[0,2]),('The identity factor and the sum preserve Hermiticity without a commutation assumption.',[1,3]),('A one-dimensional outer factor reduces to a non-Hermitian X, exposing the missing hypothesis.',[2])],
['Correct tensor and additive adjoint calculation','Explicitly do not assume S and T commute','Valid non-Hermitian counterexample when X premise removed'],
[source('QuantumBlockEncoding/GHLHamiltonian.lean','tensor367-369; tensor_isHermitian394-400; add_isHermitian402-408; oneDimHamiltonian_isHermitian410-417')]))
x.append(core(20,'sparse_stencil_algebra',
'A finite row stencil is a list of offset/coefficient pairs. Its matrix entry at row i and column j is the sum of coefficients of every pair with i+offset=j; no modular wrapping is used. Prove that merging repeated offsets by summing their coefficients leaves every matrix entry unchanged. Use the pairs (1,2),(1,-2),(-1,3) to show why list width and the number of nonzero matrix entries need not agree.',
'Fix i,j. Every pair contributes its coefficient if its offset equals j-i and contributes zero otherwise. Group the finite sum by equal offsets; associativity and commutativity of scalar addition preserve the sum. Replacing each group by a single pair whose coefficient is that group sum therefore gives exactly the same entry for this arbitrary i,j, hence the same matrix. In the example the offset1 coefficient is2-2=0, while the offset-1 coefficient is3. Thus the entry at j=i+1 vanishes and the entry at j=i-1 equals3 if that column lies in the finite grid. The original list has three pairs, its merged list can have two pairs including a zero, and it has at most one nonzero matrix entry in a row; at a left boundary even that entry may disappear because j=i-1 is outside the grid. An access permutation or sparse-oracle cost cannot be inferred solely from the unmerged list length. This proof uses the stated additive matrix semantics, not a claim that arbitrary loaders with collided labels are automatically reversible.',
['QuantumBlockEncoding.stencilRowCoeff'],['QuantumBlockEncoding.buildRobinMatrix'],
[('For fixed i,j, only pairs with the single matching integer offset contribute.',[0]),('Regroup a finite scalar sum by equal offsets to preserve all entries.',[0,1]),('Evaluate the cancellation example and separately check the finite-grid boundary.',[0])],
['Prove entrywise invariance including repeated offsets','Compute cancellation and remaining coefficient3','Distinguish list count, actual support and boundary truncation without claiming free access'],
[source('QuantumBlockEncoding/RobinMatrix.lean','stencilRowCoeff15-26; buildRobinMatrix50-63')] ))
(B/'data/native_nl/expansion2.json').write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print('Wrote',len(x),'new bounded mathematical cores')
