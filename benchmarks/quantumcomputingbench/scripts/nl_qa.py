#!/usr/bin/env python3
"""Python-only native mathematical QA successor. Never installs or runs Lean."""
from pathlib import Path
import argparse
import json
import sys
B=Path(__file__).resolve().parents[1]
R=B.parents[1]
sys.path.insert(0,str(B/'src'))
from qcb_core import read_json,write_json,digest,score
from qcb_integrity import matches,text_sha
from qcb_migration import pipeline_matches
from qcb_nl import build,paths,check_baseline,native_errors,authoring,prepare_native,VERSION,WITHDRAWN_NATIVE


def load_checked(version=VERSION):
    _,manifest,public,_=paths(R,version)
    snap=check_baseline(R)
    pipeline=read_json(manifest/'pipeline.json')
    for rel,expected in pipeline['input_hashes'].items():
        if not pipeline_matches(R/rel,expected):raise ValueError('successor pipeline changed; new version needed: '+rel)
    items=read_json(public/'items.json');release=read_json(public/'release.json')
    binding=read_json(manifest/'release.json')
    if digest(items)!=binding['items_hash'] or digest(release)!=binding['release_hash']:
        raise ValueError('release manifest mismatch')
    if release != [i for i in items if i['lifecycle']=='released']:
        raise ValueError('release is not exact admitted subset')
    if digest(authoring(R,binding['authoring_batches']))!=binding['authoring_hash']:
        raise ValueError('frozen native authoring batch changed')
    errors=native_errors(items,snap,R)
    if errors:raise ValueError('\n'.join(errors))
    import jsonschema
    schema=read_json(B/'schemas/native-nl-v1.schema.json')
    for i in items:jsonschema.validate(i,schema)
    if any(i['key'] in WITHDRAWN_NATIVE for i in release):
        raise ValueError('historical native gold withdrawn; use nl-v4 corrected successors, preserve old files audit-only')
    return snap,items,release


def summary(items,version=VERSION):
    from collections import Counter
    released=[i for i in items if i['lifecycle']=='released']
    return {'version':version,'candidate_records':len(items),
            'canonical_core_id_records':len({i['core_id'] for i in items}),'reviewed_cores':len(released),
            'independently_reviewed_same_core_repairs':sum(bool(i.get('supersedes')) for i in released),
            'independent_new_distinct_core_verdicts':sum(i.get('reviewed_core_status')=='new_distinct' for i in items),
            'duplicate_or_existing_view_records':sum(i.get('reviewed_core_status') in {'duplicate','existing_view'} for i in items),
            'counts_by_topic':dict(Counter(i['topic'] for i in items)),
            'reviewed_by_topic':dict(Counter(i['topic'] for i in released)),
            'reviewed_by_semantic_steps':dict(Counter(str(i['semantic_step_count']) for i in released)),
            'reviewed_by_evidence_relation':dict(Counter(i['evidence_relation'] for i in released)),
            'local_lean_verification_performed':False,'goal_complete':False}


def main():
    p=argparse.ArgumentParser(description=__doc__)
    sub=p.add_subparsers(dest='command',required=True)
    for name in ['build','validate','score','summary']:
        q=sub.add_parser(name)
        q.add_argument('--version',default=VERSION)
        if name=='build':
            q.add_argument('--reviews',nargs='*',default=[])
            q.add_argument('--batches',nargs='+')
            q.add_argument('--freeze',action='store_true')
        if name=='score':
            q.add_argument('--predictions',required=True)
            q.add_argument('--ratings')
            q.add_argument('--output')
    a=p.parse_args()
    try:
        if a.command=='build':
            items=build(R,[R/x for x in a.reviews],freeze=a.freeze,version=a.version,batches=a.batches)
            print(json.dumps(summary(items,a.version),indent=2));return
        _,items,release=load_checked(a.version)
        if a.command=='score':
            result=score(release,read_json(a.predictions),read_json(a.ratings) if a.ratings else None)
            if a.output:
                dest=Path(a.output).resolve()
                if dest.is_relative_to(R):raise ValueError('private evaluator logs must remain outside public repository')
                write_json(dest,result)
            print(json.dumps(result['by_track'],indent=2))
        else:print(json.dumps(summary(items,a.version),indent=2))
    except (ValueError,KeyError,OSError) as e:
        print('ERROR: '+str(e),file=sys.stderr);return 1

if __name__=='__main__':raise SystemExit(main() or 0)
