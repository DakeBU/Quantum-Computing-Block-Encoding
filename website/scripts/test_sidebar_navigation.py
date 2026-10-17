"""Final sidebar contracts: unique destinations, retained content, idempotence."""
import json
import tempfile
import unittest
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path

from website.scripts import build_site, research_atlas
from website.scripts.sidebar_navigation import render_navigation, replace_navigation

ROOT = Path(__file__).resolve().parents[2]


class NavigationParser(HTMLParser):
    def __init__(self, text):
        super().__init__()
        self.links, self.open_sections, self.parts = [], [], []
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'a':
            self.links.append(attrs)
        if tag == 'details' and 'data-book-part' in attrs:
            self.parts.append(attrs['data-book-part'])
        if tag == 'details' and 'data-nav-section' in attrs and 'open' in attrs:
            self.open_sections.append(attrs['data-nav-section'])


class SidebarNavigationTests(unittest.TestCase):
    def setUp(self):
        self.papers = json.loads((ROOT/'website/papers.json').read_text(encoding='utf-8'))
        self.cases = [
            dict(slug='bell-test', shortTitle='Bell', kind='statePreparation'),
            dict(slug='be-test', shortTitle='BE test', kind='blockEncoding'),
        ]

    def test_each_destination_occurs_once_at_all_depths(self):
        for prefix in ('./', '../', '../../', '../../../'):
            nav = NavigationParser(render_navigation(prefix, 'index.html', self.papers, self.cases))
            duplicates = [href for href, count in Counter(x['href'] for x in nav.links).items() if count > 1]
            self.assertEqual(duplicates, [])
            self.assertEqual(len(nav.parts), 4)
            self.assertEqual(len(set(nav.parts)), 4)

    def test_home_is_compact_and_has_only_one_progress_entry(self):
        text = render_navigation('./', 'index.html', self.papers, self.cases)
        nav = NavigationParser(text)
        self.assertEqual(nav.open_sections, [])
        self.assertNotIn(' open>', text)
        self.assertEqual(text.count('href="./progress/index.html"'), 1)
        self.assertNotIn('href="./roadmap/index.html"', text)

    def test_current_collection_opens_and_exact_page_is_marked(self):
        for route, section in (('example-cases/bell-test/index.html', 'examples'),
                               ('library/index.html', 'tools'), ('progress/index.html', 'research'),
                               ('community/index.html', 'project'), ('papers/index.html', 'papers')):
            nav = NavigationParser(render_navigation('../../', route, self.papers, self.cases))
            self.assertEqual(nav.open_sections, [section])
            self.assertEqual(sum(x.get('aria-current') == 'page' for x in nav.links), 1)

    def test_every_guided_chapter_case_and_paper_is_retained(self):
        text = render_navigation('./', 'index.html', self.papers, self.cases)
        for chapter in build_site.CHAPTERS:
            self.assertEqual(text.count(f'./chapters/{chapter["slug"]}/index.html'), 1)
        for case in self.cases:
            self.assertEqual(text.count(f'data-case="{case["slug"]}"'), 1)
        for paper in self.papers['featured'] + self.papers['queue']:
            if paper.get('route'):
                self.assertEqual(text.count(f'./{paper["route"]}index.html'), 1)
        for target in ('library/', 'lean-graph/', 'implementation-map/', 'workflow/', 'ide/', 'blueprint/'):
            self.assertIn(f'href="./{target}index.html"', text)

    def test_legacy_graph_link_label_is_retained_for_published_pages(self):
        text = render_navigation('../../', 'case-studies/robin/index.html', self.papers, self.cases)
        self.assertEqual(text.count('Underlying Lean Graph of Libraries'), 1)
        self.assertIn('href="../../lean-graph/index.html"', text)

    def test_replacement_is_idempotent_and_does_not_touch_body(self):
        page = build_site.site_header('./', '') + '<main><a href="roadmap/">Keep body link</a></main>'
        once = replace_navigation(page, './', 'index.html', self.papers, self.cases)
        self.assertEqual(replace_navigation(once, './', 'index.html', self.papers, self.cases), once)
        self.assertIn('<main><a href="roadmap/">Keep body link</a></main>', once)

    def test_absent_or_duplicate_sidebar_fails_closed(self):
        nav = render_navigation('./', 'index.html', self.papers, self.cases)
        for text in ('<main>No sidebar</main>', nav + nav):
            with self.assertRaisesRegex(ValueError, 'expected one common sidebar'):
                replace_navigation(text, './', 'index.html', self.papers, self.cases)

    def test_actual_final_publisher_is_idempotent_and_skips_blueprint(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'data').mkdir()
            (root/'data/example-cases.json').write_text(json.dumps({'cases':self.cases}), encoding='utf-8')
            (root/'data/papers.json').write_text(json.dumps(self.papers), encoding='utf-8')
            index = root/'index.html'
            index.write_text(build_site.site_header('./', ''), encoding='utf-8')
            (root/'blueprint').mkdir()
            blueprint = root/'blueprint/index.html'
            blueprint.write_text('Blueprint is a separate navigation surface', encoding='utf-8')
            research_atlas.patch_navigation(root)
            first = index.read_bytes()
            research_atlas.patch_navigation(root)
            self.assertEqual(index.read_bytes(), first)
            self.assertEqual(blueprint.read_text(encoding='utf-8'), 'Blueprint is a separate navigation surface')


if __name__ == '__main__':
    unittest.main()
