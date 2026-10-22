"""Native mathematical NL successor layer. Frozen release-v3 tooling is reused,
never rewritten. All certification claims are source inspection or independent
NL review; no local Lean execution is performed by this module.
"""
from __future__ import annotations
from collections import Counter, defaultdict
import copy
import difflib
import json
from pathlib import Path
import re
from qcb_core import (prepare, assign_splits, validate, digest, content_hash,
                      model_input, score, read_json, write_json, normalize_question)
from qcb_integrity import text_sha, matches, snapshot_input_matches, check_not_withdrawn
from qcb_snapshot import coverage

VERSION = 'nl-v1'
NATIVE_DIR = 'benchmarks/quantumcomputingbench'
FORBIDDEN_NL = re.compile(r'QuantumBlockEncoding|\b(?:Lean|Lake|Mathlib|tactic|simp|rfl|by exact|Fin\.castLE)\b|\.lean\b|declaration:|module:|\b(?:[a-z]+_){2,}[a-z]+\b|\b[A-Z][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*\b|\b(?:row_isometry|mul_assoc|vec_mul|fin_cast)\b')
EVIDENCE = {'local_source_supported', 'nl_bridge_from_inspected_source', 'primary_source_nl_only'}
CONTROL_FIELDS = {'reviews','validation','lifecycle','verification_receipts'}
# Historical native answers with load-bearing premise/cleanup defects stay
# audit-only. Corrected successors require their own real content review.
WITHDRAWN_NATIVE = {
    'qcb-core-be-001': 'missing nonzero/positive normalizer premise before division',
    'qcb-core-be-002': 'clean subblock equality does not imply success-sector workspace cleanup',
    'qcb-core-be-010': 'reset/inverse is not an automatic free coherent product repair',
}


def review_admits(record,item):
    if record.get('verdict')!='accept':return False
    if record.get('core_verdict')=='new_distinct':return True
    return (record.get('core_verdict')=='existing_view' and record.get('repair_admission') is True
            and bool(item.get('supersedes')) and not item['native_nl']['new_problem_core'])


def paths(root,version=VERSION):
    if (not re.fullmatch(r'nl-v[1-9][0-9]*',version)):
        raise ValueError('native successor version must be nl-v1, nl-v2, ...')
    root=Path(root).resolve()
    base=root/NATIVE_DIR
    return base, base/'manifests'/version, base/'data/public'/version, base/'reports'/version


def check_baseline(root):
    base,_,_,_=paths(root)
    snap=read_json(base/'manifests/release-v3/snapshot.json')
    for rel,expected in snap['input_hashes'].items():
        if not snapshot_input_matches(root,rel,expected):
            raise ValueError('Frozen v3 input differs: '+rel)
    pipeline=read_json(base/'manifests/release-v3/pipeline.json')
    for rel,expected in pipeline['input_hashes'].items():
        if not matches(Path(root)/rel,expected):
            raise ValueError('Frozen v3 pipeline differs: '+rel)
    return snap


def authoring(root,batches=None,include_superseded=False):
    base,_,_,_=paths(root)
    result=[]
    sources=sorted((base/'data/native_nl').glob('*.json')) if batches is None else [base/'data/native_nl'/name for name in batches]
    for p in sources:
        if p.parent.resolve()!=(base/'data/native_nl').resolve() or p.suffix!='.json':
            raise ValueError('native authoring batch must be a local JSON filename')
        batch=read_json(p)
        if not isinstance(batch,list):raise ValueError('authoring batch must be array')
        result.extend(batch)
    if not include_superseded:
        superseded={i['supersedes'] for i in result if i.get('supersedes')}
        result=[i for i in result if i['key'] not in superseded]
    return result


def prepare_native(raw,snap):
    check_not_withdrawn(raw)
    items=prepare(raw,snap)
    for item in items:
        meta=item['native_nl']
        item['author']={'identity':meta['author_identity'],
                        'method':'Native mathematical authoring from inspected complete sources',
                        'independence':'self-authored; distinct reviewer required'}
        item['mathematical_core_id']=item['core_id']
        item['evidence_relation']=meta['evidence_relation']
        item['formal_evidence']={'local_verification_performed':False,
                                'counterpart':meta['formal_counterpart'],
                                'inherited_evidence':'See original provenance only; not rerun or upgraded'}
        item['views']=['natural_language']
        item['reviewed_semantic_step_count']=None
        if 'canonical_family' in meta:item['family']=meta['canonical_family']
    return assign_splits(items,{'nl-block-composition-holdout','nl-tensor-isometry-holdout'})


def assign_native_splits(items,legacy):
    """Bind all reviewed core aliases and related views before legacy locks."""
    parent=list(range(len(items)))
    def find(i):
        while parent[i]!=i:
            parent[i]=parent[parent[i]];i=parent[i]
        return i
    index={}
    for j,item in enumerate(items):
        index[item['key']]=j;index[item['core_id']]=j
    groups=defaultdict(list)
    for j,item in enumerate(items):
        aliases=list(item['native_nl'].get('existing_core_aliases',[]))
        for review in item.get('reviews',[]):aliases.extend(review.get('core_aliases',[]))
        for alias in aliases:
            if alias in index:parent[find(j)]=find(index[alias])
    for j,item in enumerate(items):groups[find(j)].append(item)
    # View equivalence changes grouping metadata, never authoring/proof content.
    prepared=copy.deepcopy(items)
    for component in groups.values():
        if len(component)>1:
            family='+'.join(sorted({i['family'] for i in component}))
            for item in prepared:
                if item['core_id'] in {i['core_id'] for i in component}:
                    item['family']=family
    combined=assign_splits(copy.deepcopy(legacy)+prepared,
                           {'nl-block-composition-holdout','nl-tensor-isometry-holdout'})
    original={i['id']:i['split'] for i in legacy}
    constraints=defaultdict(set)
    for item in combined[:len(legacy)]:
        constraints[item['split_group']].add(original[item['id']])
    result=combined[len(legacy):]
    original_families={i['id']:i['family'] for i in items}
    for item in result:item['family']=original_families[item['id']]
    planned_groups={i['split_group'] for i in result if i['track']=='planned'}
    for item in result:
        locked=constraints.get(item['split_group'],set())
        item['legacy_split_constraints']=sorted(locked)
        item['cross_version_split_conflict']=len(locked)>1
        if item['split_group'] in planned_groups or len(locked)>1:
            item['split']='test_public'
        elif locked:
            item['split']=next(iter(locked))
    return result


def native_errors(items,snap,root=None):
    errors=validate(items,snap,None)
    originals={digest(i):i for i in authoring(root,include_superseded=True)} if root else {}
    seen,cores={},set()
    for item in items:
        label=item.get('key','?')
        def fail(text):errors.append(label+': '+text)
        if not re.fullmatch(r'qcb-core-(?:la|sp|be|plan)-\d{3}',item.get('core_id','')):
            fail('invalid stable core ID')
        if item.get('core_id') in cores:fail('duplicate mathematical core')
        cores.add(item.get('core_id'))
        if item.get('core_id')!=item.get('mathematical_core_id'):fail('view/core identity mismatch')
        if item.get('formal') or item.get('formal_context') or item.get('track')=='lean':
            fail('native NL view must not require formal proof context')
        meta=item.get('native_nl',{})
        if meta.get('evidence_relation') not in EVIDENCE:fail('missing distinct evidence relation')
        if not meta.get('core_summary') or not meta.get('author_identity'):fail('missing core/author provenance')
        if item.get('author',{}).get('identity')!=meta.get('author_identity'):fail('author attribution changed')
        if item.get('task_kind') not in {'concept','proof','counterexample','boundary'}:fail('invalid mathematical task kind')
        for field in ['question','reference_answer']:
            text=item.get(field,'')
            if FORBIDDEN_NL.search(text):fail(field+' is API/formal-source facing, not native mathematics')
            if len(text.strip())<35:fail(field+' insufficient mathematical context')
        if item.get('formal_evidence',{}).get('local_verification_performed') is not False:
            fail('no new local Lean verification may be claimed')
        if not isinstance(meta.get('new_problem_core'),bool):fail('novel-core status missing')
        aliases=meta.get('existing_core_aliases',[])
        if aliases and meta.get('new_problem_core'):fail('existing view/repair cannot count as a new core')
        signature=normalize_question(meta.get('core_summary',''))
        if signature in seen:fail('duplicate core-summary signature with '+seen[signature])
        seen[signature]=label
        if item.get('track')=='planned':
            if meta.get('evidence_relation')!='primary_source_nl_only':fail('planned evidence conflated with local formal support')
            for ref in item.get('primary_sources',[]):
                for k in ['url','sha256','edition','pages','anchors','inspection','redistribution','reuse']:
                    if not ref.get(k):fail('primary source missing '+k)
            if not item.get('primary_sources'):fail('primary text provenance required')
        if root:
            raw=originals.get(item.get('authored_hash'))
            if raw is None:
                fail('authored artifact missing/changed')
            else:
                frozen=prepare_native([raw],snap)[0]
                ignored=CONTROL_FIELDS|{'split','split_group','reviewed_semantic_step_count'}
                for field in set(frozen)-ignored:
                    if item.get(field)!=frozen[field]:fail('authored content differs: '+field)
            for ref in item.get('source_refs',[]):
                p=(Path(root)/ref['path']).resolve()
                if not p.is_relative_to(Path(root).resolve()) or not matches(p,ref['sha256']):
                    fail('source path/hash differs')
            for review in item.get('reviews',[]):
                p=(Path(root)/review.get('artifact','')).resolve()
                if not p.is_relative_to(Path(root).resolve()) or not matches(p,review.get('artifact_sha256')):
                    fail('review artifact changed')
                    continue
                packet=read_json(p)
                if (packet.get('reviewer')!=review.get('reviewer') or
                    not any(r.get('key')==item['key'] and r.get('authored_sha256')==item['authored_hash']
                            and r.get('verdict')==review.get('verdict')
                            and r.get('core_verdict')==review.get('core_verdict')
                            and r.get('core_aliases',[])==review.get('core_aliases',[])
                            and r.get('repair_admission',False)==review.get('repair_admission',False)
                            for r in packet.get('items',[]))):
                    fail('review artifact does not bind authored content')
        if item.get('lifecycle')=='released':
            if not any(review_admits(r,item) for r in item.get('reviews',[])):
                fail('released core lacks independent novelty verdict or explicitly reviewed same-core repair')
            if any(not review_admits(r,item) for r in item.get('reviews',[])):
                fail('conflicting review remains unresolved; cannot release')
            if item.get('reviewed_semantic_step_count')!=item['semantic_step_count']:
                fail('released inference steps lack matching reviewed count')
    if root:
        legacy=read_json(Path(root)/NATIVE_DIR/'data/public/release-v3/items.json')
        expected_splits={i['id']:i for i in assign_native_splits(copy.deepcopy(items),legacy)}
        for item in items:
            expected=expected_splits[item['id']]
            for field in ['split','split_group','legacy_split_constraints','cross_version_split_conflict']:
                if item.get(field)!=expected.get(field):errors.append(item['key']+': cross-version split policy mismatch '+field)
    return errors


def dedup_report(items,legacy):
    near=[]
    for j,item in enumerate(items):
        for other in items[:j]:
            ratio=difflib.SequenceMatcher(None,normalize_question(item['question']),normalize_question(other['question'])).ratio()
            if ratio>.82:near.append({'a':item['core_id'],'b':other['core_id'],'similarity':round(ratio,4),'state':'requires_manual_core_review'})
    legacy_near=[]
    for item in items:
        question=normalize_question(item['question'])
        for old in legacy:
            ratio=difflib.SequenceMatcher(None,question,normalize_question(old['question'])).ratio()
            if ratio>.65 or set(item['target_nodes'])==set(old['target_nodes']):
                legacy_near.append({'core_id':item['core_id'],'legacy_key':old['key'],
                                    'question_similarity':round(ratio,4),
                                    'same_primary_target_set':set(item['target_nodes'])==set(old['target_nodes']),
                                    'state':'requires semantic core comparison; same target alone is not same problem'})
    accepted_reviewed={i['core_id'] for i in items if i.get('lifecycle')=='released'}
    # Manual reviewed aliases override count claims; unknown novelty stays unknown.
    duplicate_records=[i for i in items if i.get('reviewed_core_status') in {'duplicate','existing_view'}]
    return {'canonical_core_ids':len({i['core_id'] for i in items}),
            'confirmed_distinct_released_cores':len(accepted_reviewed),
            'candidate_records_not_established_new':len(items)-len(accepted_reviewed),
            'author_claimed_new_core_candidates':sum(i['native_nl']['new_problem_core'] for i in items),
            'independent_new_distinct_cores':sum(i.get('reviewed_core_status')=='new_distinct' for i in items),
            'independent_duplicate_or_existing_views':sum(i.get('reviewed_core_status') in {'duplicate','existing_view'} for i in items),
            'new_core_candidates':sum(i['native_nl']['new_problem_core'] for i in items),
            'existing_view_aliases':[{'core_id':i['core_id'],'aliases':i['native_nl']['existing_core_aliases']} for i in items if i['native_nl']['existing_core_aliases']],
            'normalized_duplicate_questions':len(items)-len({normalize_question(i['question']) for i in items}),
            'near_duplicate_candidates':near,'legacy_overlap_candidates':legacy_near,'legacy_items_compared':len(legacy),
            'semantic_dedup_status':'automatic exact/near checks plus actual reviewer core verdict; similarity alone is not semantic dedup proof'}


def core_registry(items,legacy):
    old=[]
    for i in legacy:
        old.append({'legacy_key':i['key'],'view':'lean' if i.get('formal') else 'natural_language_or_hybrid',
                    'family':i['family'],'primary_targets':i['target_nodes'],
                    'proposed_core_id':'qcb-legacy-'+digest(i['key'])[:16],
                    'state':'legacy alias proposal; collaborator reconciliation required'})
    return {'schema_version':'qcb.core_registry.v1','coordination_status':'pending_real_Lean_collaborator_acknowledgment',
            'integration_allowed':False,'note':'No acknowledgment invented. IDs/families are versioned proposals, not merged into shared formal corpus.',
            'new_cores':[{'core_id':i['core_id'],'summary':i['native_nl']['core_summary'],'family':i['family'],
                          'reviewed_core_status':i.get('reviewed_core_status','not_reviewed'),
                          'reviewer_aliases':sorted({a for r in i.get('reviews',[]) for a in r.get('core_aliases',[])}),
                          'views':['natural_language'],'target_nodes':i['target_nodes'],
                          'aliases':i['native_nl']['existing_core_aliases'],'split_group':i['split_group'],'split':i['split']} for i in items],
            'legacy_views_for_reconciliation':old}


def build(root,review_paths=(),freeze=False,version=VERSION,batches=None):
    root=Path(root).resolve()
    base,manifest,public,reports=paths(root,version)
    freeze=freeze or (manifest/'FROZEN.json').exists()
    snap=check_baseline(root)
    prior_manifest=manifest/'release.json'
    if prior_manifest.exists() and freeze:
        prior=read_json(prior_manifest)
        batch_names=prior['authoring_batches']
        if not review_paths:
            review_paths=[root/rel for rel in prior.get('review_artifacts',[])]
    else:
        batch_names=sorted(batches) if batches is not None else [p.name for p in sorted((base/'data/native_nl').glob('*.json'))]
    raw=authoring(root,batch_names)
    if not raw:raise ValueError('no native mathematical authoring')
    legacy=read_json(base/'data/public/release-v3/items.json')
    items=assign_native_splits(prepare_native(raw,snap),legacy)
    by_key={i['key']:i for i in items}
    applied_reviews={}
    for path in review_paths:
        path=Path(path).resolve()
        rel=path.relative_to(Path(root).resolve()).as_posix()
        packet=read_json(path)
        if packet.get('method')!='distinct-context-source-review' or not packet.get('reviewer'):
            raise ValueError('honest distinct-context review provenance required')
        seen=set()
        for record in packet['items']:
            if record['key'] in seen:raise ValueError('duplicate review key')
            seen.add(record['key'])
            review_identity=(packet['reviewer'],record['key'])
            if review_identity in applied_reviews:
                raise ValueError('repeated/conflicting review by same identity requires explicit successor artifact/version')
            applied_reviews[review_identity]=rel
            if record['key'] not in by_key:
                if record['key'] in {i.get('supersedes') for i in items}:
                    continue  # preserved historical review; successor has separate review
                raise ValueError('review references unknown key')
            item=by_key[record['key']]
            if record.get('authored_sha256')!=item['authored_hash']:raise ValueError('review authored-content mismatch')
            if packet['reviewer']==item['author']['identity']:raise ValueError('self-review cannot be independent')
            bound={**record,'reviewer':packet['reviewer'],'method':packet['method'],
                   'artifact':rel,'artifact_sha256':text_sha(path),'content_hash':content_hash(item)}
            item['reviews'].append(bound)
            item['reviewed_core_status']=record.get('core_verdict','uncertain')
            if record.get('core_verdict') not in {'new_distinct','existing_view','duplicate','uncertain'}:
                raise ValueError('independent mathematical-core novelty verdict required')
            if review_admits(record,item) and not item['unresolved_issues'] and item['key'] not in WITHDRAWN_NATIVE:
                item['lifecycle']='released'
                item['validation'].update(nl_alignment='reviewed',answer_quality='reviewed')
                # This explicit field is derived after review; bind final content.
                item['reviewed_semantic_step_count']=item['semantic_step_count']
                for r in item['reviews']:r['content_hash']=content_hash(item)
            else:
                item['lifecycle']='candidate'
                item['validation'].update(nl_alignment='pending',answer_quality='pending')
                item['reviewed_semantic_step_count']=None
    items=assign_native_splits(items,legacy)
    for item in items:
        if any(not review_admits(r,item) for r in item['reviews']) or item['key'] in WITHDRAWN_NATIVE:
            item['lifecycle']='candidate'
            item['validation'].update(nl_alignment='pending',answer_quality='pending')
            item['reviewed_semantic_step_count']=None
        for r in item['reviews']:r['content_hash']=content_hash(item)
    errors=native_errors(items,snap,root)
    if errors:raise ValueError('\n'.join(errors))
    legacy=read_json(base/'data/public/release-v3/items.json')
    released=[i for i in items if i['lifecycle']=='released']
    write_json(public/'items.json',items,immutable=freeze)
    write_json(public/'release.json',released,immutable=freeze)
    write_json(public/'provisional.json',[i for i in items if i['lifecycle']!='released'],immutable=freeze)
    write_json(public/'prompts-closed_book.json',[model_input(i) for i in released],immutable=freeze)
    write_json(manifest/'core-registry.json',core_registry(items,legacy),immutable=freeze)
    write_json(manifest/'release.json',{'schema_version':'qcb.nl_release.v1','snapshot_id':snap['snapshot_id'],
        'items_hash':digest(items),'release_hash':digest(released),'authoring_hash':digest(raw),
        'authoring_batches':batch_names,
        'baseline_version':'release-v3','local_lean_verification_performed':False,'private_gold_published':False,
        'test_is_public':True,'independent_reviewed_cores':len(released),
        'new_distinct_candidate_cores':sum(i['native_nl']['new_problem_core'] for i in items),
        'review_artifacts':[Path(p).resolve().relative_to(root).as_posix() for p in review_paths],
        'core_coordination':'pending collaborator acknowledgment before shared integration',
        'splits':{s:[i['core_id'] for i in released if i['split']==s] for s in ['train','dev','test_public']}},immutable=freeze)
    write_json(reports/'dedup.json',dedup_report(items,legacy),immutable=freeze)
    write_json(reports/'coverage.json',nl_coverage(snap,items),immutable=freeze)
    pipeline=[base/'src/qcb_nl.py',base/'scripts/nl_qa.py',base/'scripts/nl_report.py',
              base/'schemas/native-nl-v1.schema.json']
    write_json(manifest/'pipeline.json',{'input_hashes':{p.relative_to(root).as_posix():text_sha(p) for p in pipeline},
                                      'inherited_v3_pipeline':'../release-v3/pipeline.json'},immutable=freeze)
    if freeze:
        write_json(manifest/'FROZEN.json',{'version':version,'items_hash':digest(items),
                                         'authoring_hash':digest(raw)},immutable=True)
    return items


def nl_coverage(snap,items):
    report=coverage(snap,items)
    primary=defaultdict(list);support=defaultdict(list)
    for i in items:
        if i['lifecycle']!='released':continue
        for n in i['target_nodes']:primary[n].append(i['core_id'])
        for n in i['supporting_nodes']:support[n].append(i['core_id'])
    for row in report['ledger']:
        row['primary_target_cores']=sorted(set(primary.get(row['id'],[])))
        row['incidental_support_cores']=sorted(set(support.get(row['id'],[])))
        row['primary_target_covered']=bool(row['primary_target_cores'])
    report['primary_target_nodes']=len(primary)
    report['support_only_nodes']=len(set(support)-set(primary))
    report['local_lean_verification_performed']=False
    report['counts_by_evidence_relation']=dict(Counter(i['evidence_relation'] for i in items if i['lifecycle']=='released'))
    report['native_core_counts_by_topic']=dict(Counter(i['topic'] for i in items))
    report['reviewed_core_counts_by_topic']=dict(Counter(i['topic'] for i in items if i['lifecycle']=='released'))
    report['reviewed_depth_counts']=dict(Counter(str(i['reviewed_semantic_step_count']) for i in items if i['lifecycle']=='released'))
    report['source_inspection_is_compilation']=False
    return report
