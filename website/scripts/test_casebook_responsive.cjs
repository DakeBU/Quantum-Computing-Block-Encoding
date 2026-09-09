// Run with: node --test website/scripts/test_casebook_responsive.cjs
// Requires Playwright. A locally installed browser may be selected with
// PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH; otherwise Playwright's Chromium is used.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { test } = require('node:test');
const { chromium } = require('playwright');

const staticRoot = path.resolve(__dirname, '..', 'static');
const styles = ['site.css', 'casebook.css'].map(name =>
  fs.readFileSync(path.join(staticRoot, name), 'utf8')).join('\n');
const siteScript = fs.readFileSync(path.join(staticRoot, 'site.js'), 'utf8');

for (const width of [390, 768, 1440]) {
  test(`casebook equations and source remain contained at ${width}px`, async () => {
    const browser = await chromium.launch({
      headless: true,
      ...(process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH
        ? { executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH } : {}),
    });
    try {
      const page = await browser.newPage({ viewport: { width, height: 900 } });
      await page.setContent(`<!doctype html><meta name="viewport" content="width=device-width,initial-scale=1">
        <style>${styles}</style><style>body{margin:0}main{margin:0;width:100%;max-width:none;padding:0}</style>
        <main><section class="casebook-tutorial">
          <div class="casebook-opening"><h2>Reading a long equation</h2>
            <div class="casebook-query-formula"><span style="display:inline-block;width:1000px">A long source expression</span></div>
          </div>
          <section class="casebook-subsection" id="case-theorems"><h2>Proof steps</h2>
            <article class="casebook-theorem"><h3>An equation with many terms</h3>
              <div class="casebook-formula"><span style="display:inline-block;width:1000px">A long theorem expression</span></div>
              <details class="copy-source-panel" open><summary>Source</summary><pre><code>${'expression '.repeat(180)}</code></pre></details>
            </article>
          </section>
        </section></main>`);
      const result = await page.evaluate(() => {
        const panels = [...document.querySelectorAll('.casebook-formula,.casebook-query-formula,.copy-source-panel pre')];
        return {
          pageWidth: document.documentElement.scrollWidth,
          viewport: innerWidth,
          panels: panels.map(element => {
            element.scrollLeft = element.scrollWidth;
            return {
              left: element.getBoundingClientRect().left,
              right: element.getBoundingClientRect().right,
              canScroll: element.scrollLeft > 0,
              overflowX: getComputedStyle(element).overflowX,
            };
          }),
        };
      });
      assert.ok(result.pageWidth <= result.viewport + 1, JSON.stringify(result));
      assert.equal(result.panels.length, 3);
      for (const panel of result.panels) {
        assert.ok(panel.left >= 0 && panel.right <= width + 1, JSON.stringify(panel));
        assert.equal(panel.overflowX, 'auto');
        assert.equal(panel.canScroll, true);
      }
    } finally {
      await browser.close();
    }
  });
}

for (const width of [390, 768, 1440]) {
  test(`sidebar reading styles are accessible and persistent at ${width}px`, async () => {
    const browser = await chromium.launch({
      headless: true,
      ...(process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH
        ? { executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH } : {}),
    });
    try {
      const page = await browser.newPage({ viewport: { width, height: 900 } });
      const errors = [];
      page.on('pageerror', error => errors.push(String(error)));
      // Use the production sidebar classes, controls, stylesheet and controller.
      // A routed origin makes genuine localStorage and reload behavior available.
      await page.route('http://reading-style.test/**', route => route.fulfill({
        contentType: 'text/html',
        body: `<!doctype html><html><head><meta name="viewport" content="width=device-width,initial-scale=1">
          <style>${styles}</style></head><body>
          <header class="mobile-header"><button class="icon-button mobile-menu" type="button"
            data-menu-button aria-label="Open book navigation" aria-expanded="false">Menu</button></header>
          <aside class="site-sidebar" data-main-nav><nav class="book-nav">Book navigation</nav>
            <div class="sidebar-footer"><div class="theme-switcher" aria-label="Reading style">
              <button type="button" data-theme-choice="blueprint" aria-pressed="true">Book</button>
              <button type="button" data-theme-choice="modern" aria-pressed="false">Sans</button>
              <button type="button" data-theme-choice="bold" aria-pressed="false">High contrast</button>
            </div></div></aside><main><h1>Hermite-smoothed initial states</h1></main>
          <script>${siteScript}</script></body></html>`,
      }));
      await page.goto('http://reading-style.test/');
      const snapshots = [];
      for (const theme of ['blueprint', 'modern', 'bold']) {
        if (width <= 820) {
          await page.locator('[data-menu-button]').click();
          assert.equal(await page.locator('[data-menu-button]').getAttribute('aria-expanded'), 'true');
        }
        const button = page.locator(`[data-theme-choice="${theme}"]`);
        assert.equal(await button.isVisible(), true);
        await button.click();
        const clicked = await page.evaluate(() => {
          const style = getComputedStyle(document.body);
          return {
            theme: document.documentElement.dataset.theme,
            saved: localStorage.getItem('quantumcomputinglib-theme'),
            selected: [...document.querySelectorAll('[data-theme-choice][aria-pressed="true"]')]
              .map(element => element.dataset.themeChoice),
            background: style.backgroundColor,
            font: style.fontFamily,
          };
        });
        assert.equal(clicked.theme, theme);
        assert.equal(clicked.saved, theme);
        assert.deepEqual(clicked.selected, [theme]);
        await page.reload();
        const reloaded = await page.evaluate(() => ({
          theme: document.documentElement.dataset.theme,
          saved: localStorage.getItem('quantumcomputinglib-theme'),
          background: getComputedStyle(document.body).backgroundColor,
          font: getComputedStyle(document.body).fontFamily,
        }));
        assert.equal(reloaded.theme, theme);
        assert.equal(reloaded.saved, theme);
        assert.equal(reloaded.background, clicked.background);
        assert.equal(reloaded.font, clicked.font);
        snapshots.push(clicked);
      }
      assert.equal(new Set(snapshots.map(item => item.background)).size, 3);
      assert.notEqual(snapshots[0].font, snapshots[1].font);
      assert.deepEqual(errors, []);
    } finally {
      await browser.close();
    }
  });
}
