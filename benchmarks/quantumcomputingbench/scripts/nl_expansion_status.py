#!/usr/bin/env python3
"""Inspect bounded native authoring/review progress without promoting candidates.

No Lean, endpoint calls or package installations. Output is status only; a packet
or a syntactically valid question does not count as released mathematical QA.
"""
from pathlib import Path
from collections import Counter
import argparse,json,sys
B=Path(__file__).resolve().parents[1];R=B.parents[1]
sys.path.insert(0,str(B/'src'))
from qcb_core import read_json,digest,write_json
from qcb_nl import check_baseline,prepare_native,native_errors

BATCHES={
 'batch2_structured_preparation.json':{'prefix':'qcb-core-sp-1','author_scope':'Hermite finite sampled polynomial and interval-mass mathematics'},
 'batch2_matrix_constructions.json':{'prefix':'qcb-core-la-1','author_scope':'Elimination, Gray placement and matrix-construction invariants'},
 'batch2_oracle_composition.json':{'prefix':'qcb-core-be-1','author_scope':'Coherent sparse access and quantum operator construction'},
 'batch2_stored_costs.json':{'prefix':'qcb-core-la-2','author_scope':'Stored exact-real producer refinement and charged operations'},
 'batch2_representation_qit.json':{'prefix':'qcb-core-plan-1','author_scope':'Inspected primary representation theory pp17-36'},
 'batch2_scientific_algorithms.json':{'prefix':'qcb-core-plan-2','author_scope':'Inspected primary scientific algorithms pp151-168'},
 'batch3_schur_tensor_symmetry.json':{'prefix':'qcb-core-plan-3','author_scope':'Inspected primary Schur tensor symmetry pp38-57'},
 'batch3_quantum_information_apps.json':{'prefix':'qcb-core-plan-4','author_scope':'Inspected primary quantum information applications pp58-74'},
 'batch3_polynomial_signals.json':{'prefix':'qcb-core-plan-5','author_scope':'Inspected primary polynomial signals pp169-188'},
}


def collect(root=R):
 root=Path(root);base=root/'benchmarks/quantumcomputingbench'
 snap=check_baseline(root)
 # Historical accepts cannot hide later source/math rejections. For each
 # reviewer/key, take the most recently finalized artifact, preserving older
 # files as audit history. Final release still uses its explicit review list.
 latest={}
 review_paths=sorted((base/'reports/native-nl').glob('*.json'),key=lambda p:(p.stat().st_mtime_ns,p.name))
 for p in review_paths:
  packet=read_json(p)
  for record in packet.get('items',[]):
   latest[(packet.get('reviewer'),record.get('key'))]=(packet.get('reviewer'),record,p.relative_to(root).as_posix())
 reviews=list(latest.values())
 rows=[]
 for filename,scope in BATCHES.items():
  p=base/'data/native_nl'/filename
  if not p.is_file():
   rows.append({'batch':filename,'scope':scope['author_scope'],'state':'not_delivered','candidate_records':0,'independently_accepted_records':0});continue
  raw=read_json(p)
  errors=native_errors(prepare_native(raw,snap),snap,None)
  matches=[]
  for item in raw:
   bound=[(reviewer,record,path) for reviewer,record,path in reviews
          if record.get('key')==item['key'] and record.get('authored_sha256')==digest(item)
          and reviewer!=item['native_nl']['author_identity']]
   if (bound and all(r.get('verdict')=='accept' and r.get('core_verdict')=='new_distinct'
                     for _,r,_ in bound)):
    matches.append(item['core_id'])
  rows.append({'batch':filename,'scope':scope['author_scope'],'state':'candidate_or_reviewed_not_released_here',
               'candidate_records':len(raw),'independently_accepted_records':len(set(matches)),
               'validation_errors':errors,'author_claimed_step_counts':dict(Counter(len(i['semantic_steps']) for i in raw)),
               'note':'Review existence is checked by authored digest; final release requires full artifact/source/split validation.'})
 return {'schema_version':'qcb.native_expansion_status.v1','batches':rows,
         'candidate_records':sum(r['candidate_records'] for r in rows),
         'independently_accepted_records':sum(r['independently_accepted_records'] for r in rows),
         'local_lean_verification_performed':False,'publishing':'local_only_no_push','complete':False}


def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--write',action='store_true');a=p.parse_args()
 report=collect()
 if a.write:write_json(B/'manifests/nl-expansion-progress.json',report)
 print(json.dumps(report,indent=2))

if __name__=='__main__':main()
