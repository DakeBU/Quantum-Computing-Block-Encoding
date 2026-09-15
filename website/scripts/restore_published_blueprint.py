#!/usr/bin/env python3
"""Restore unchanged, actually published proof/Blueprint when Pages ZIPs expire.

Require the own-origin passed report, exact complete proof-input digest and
compiled-module list, and unchanged tracked Blueprint input files. The reader
is rebuilt separately. This never claims a fresh Lean execution.
"""
from __future__ import annotations
import argparse
import concurrent.futures
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import shutil
import subprocess
import urllib.parse
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
ORIGIN = 'https://dakebu.github.io/Quantum-Computing-Block-Encoding/'
BLUEPRINT = ORIGIN + 'blueprint/html-multi/'
INPUTS = ['ABEISBlueprint', 'ABEISBlueprint.lean', 'ABEISBlueprintMain.lean',
          'scripts/build-blueprint.sh', 'scripts/generate-blueprint-catalog.py',
          'scripts/generate-aspbe-catalog.py', 'scripts/sanitize-blueprint-paths.py',
          'website/scripts/repair_blueprint_fragments.py', 'web/assets']

class Links(HTMLParser):
    def __init__(self):
        super().__init__(); self.base = None; self.links = []
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'base': self.base = attrs.get('href')
        for key in ('href', 'src'):
            if tag != 'base' and attrs.get(key): self.links.append(attrs[key])

def resource(url: str) -> bytes:
    with urllib.request.urlopen(url, timeout=90) as response:
        if not response.geturl().startswith(ORIGIN):
            raise ValueError('publication redirect left the approved origin')
        data = response.read(160_000_001)
    if len(data) > 160_000_000:
        raise ValueError('oversized publication resource')
    return data

def local_name(url: str, base: str) -> str | None:
    parsed = urllib.parse.urlsplit(urllib.parse.urljoin(base, url))
    full = urllib.parse.urlunsplit((parsed.scheme, parsed.netloc, parsed.path, '', ''))
    if not full.startswith(BLUEPRINT): return None
    name = urllib.parse.unquote(full[len(BLUEPRINT):])
    if not name or name.endswith('/'): name += 'index.html'
    if '..' in Path(name).parts or '\\' in name or Path(name).is_absolute():
        raise ValueError('unsafe publication resource path')
    return name

def restore(output: Path) -> dict:
    from website.scripts.proof_inputs import proof_input_digest, lean_module_targets
    report_bytes = resource(ORIGIN + 'build-report.json')
    report = json.loads(report_bytes); gate = dict(report['leanGate'])
    if gate.get('passed') is not True or gate.get('proofInputsSha256') != proof_input_digest(ROOT) or gate.get('compiledModules') != lean_module_targets(ROOT):
        raise ValueError('published complete proof inputs do not match; run a fresh Lean gate')
    commit = gate.get('commit', '')
    if not re.fullmatch(r'[0-9a-f]{40}', commit): raise ValueError('unversioned proof report')
    subprocess.run(['git', 'cat-file', '-e', commit + '^{commit}'], cwd=ROOT, check=True)
    subprocess.run(['git', 'diff', '--exit-code', '--quiet', commit, 'HEAD', '--', *INPUTS], cwd=ROOT, check=True)
    pending = {'index.html', 'xref.json', 'assets/abeis-evidence-pipeline.svg', 'assets/abeis-library-map.svg'}
    seen = set(); digests = {}; total = 0
    staging = output.parent / (output.name + '-restore')
    staging.mkdir(parents=True, exist_ok=False)
    target = staging / 'html-multi'
    def fetch(name):
        url = BLUEPRINT + urllib.parse.quote(name, safe='/')
        data = resource(url)
        dest = target / name; dest.parent.mkdir(parents=True, exist_ok=True); dest.write_bytes(data)
        urls = []
        if name.endswith('.html'):
            page = Links(); page.feed(data.decode('utf-8'))
            base = urllib.parse.urljoin(url, page.base) if page.base else url
            urls = [(link, base) for link in page.links]
        elif name.endswith('.css'):
            urls = [(x.strip(' \"\''), url) for x in re.findall(r'url\(([^)]+)\)', data.decode('utf-8'))]
        found = {result for link, base in urls if (result := local_name(link, base)) is not None}
        return name, found, len(data), hashlib.sha256(data).hexdigest()
    try:
        while pending - seen:
            batch = sorted(pending - seen); seen.update(batch)
            if len(seen) > 1600: raise ValueError('Blueprint scope exceeded')
            pending = set()
            with concurrent.futures.ThreadPoolExecutor(max_workers=12) as pool:
                for name, found, size, digest in pool.map(fetch, batch):
                    pending.update(found); digests[name] = digest; total += size
                    if total > 650_000_000: raise ValueError('Blueprint size limit exceeded')
            print('Restored resources:', len(digests), 'bytes:', total, flush=True)
        if resource(ORIGIN + 'build-report.json') != report_bytes:
            raise ValueError('published version changed during restoration')
        for name in ('index.html', 'xref.json', 'assets/abeis-evidence-pipeline.svg', 'assets/abeis-library-map.svg'):
            if not (target / name).is_file(): raise ValueError('incomplete published Blueprint: ' + name)
        from website.scripts.check_site import parse_page, target_file
        # Parse each potentially large emitted module page only once.
        page_cache = {}
        def cached_page(path):
            if path not in page_cache:
                page_cache[path] = parse_page(path)
            return page_cache[path]
        for page in target.rglob('*.html'):
            parsed = cached_page(page)
            for _, url in parsed.references:
                if urllib.parse.urlsplit(url).scheme or url.startswith('//'): continue
                destination, fragment = target_file(staging, page, url, parsed.base_href)
                if not destination.resolve().is_relative_to(target.resolve()): continue
                if not destination.is_file(): raise ValueError('incomplete internal Blueprint link: ' + url)
                if fragment and destination.suffix == '.html' and fragment not in cached_page(destination).ids:
                    raise ValueError('missing internal Blueprint fragment: ' + url)
        if output.exists(): raise ValueError('restore destination already exists')
        staging.rename(output)
    except BaseException:
        shutil.rmtree(staging, ignore_errors=True)
        raise
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    gate['inheritedFromPublishedCommit'] = commit
    gate['proofTreeVerifiedAtCommit'] = gate.get('proofTreeVerifiedAtCommit', commit)
    gate['inheritanceReason'] = 'Expired artifact fallback: actual same-origin published report, identical exhaustive proof inputs and unchanged tracked Blueprint inputs; no fresh Lean execution claimed.'
    gate['commit'] = head
    out = ROOT / '_out'; out.mkdir(exist_ok=True)
    (out / 'lean-gate.json').write_text(json.dumps(gate, indent=2) + '\n')
    provenance = {'schema_version': 1, 'publishedCommit': commit, 'readerCommit': head, 'origin': ORIGIN,
                  'reportSha256': hashlib.sha256(report_bytes).hexdigest(), 'blueprintFiles': digests,
                  'proofInputsSha256': gate['proofInputsSha256'], 'freshLeanExecution': False}
    (out / 'published-proof-restore.json').write_text(json.dumps(provenance, indent=2) + '\n')
    print('Restored unchanged published Blueprint:', len(digests), 'files;', total, 'bytes; checked at', commit)
    return provenance

if __name__ == '__main__':
    import sys
    sys.path.insert(0, str(ROOT))
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / '_out/blueprint')
    args = parser.parse_args()
    restore(args.output.resolve())
