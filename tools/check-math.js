// Headless check that every formula renders (no red MathJax errors) in the vignettes and the pkgdown site.
// Needs Node and Playwright (npm i playwright; npx playwright install chromium). Network access for the MathJax
// CDN, or a local copy: MATHJAX_DIR=node_modules/mathjax/es5 (npm i mathjax@3).
// Usage: node tools/check-math.js docs vignettes      (exit status 1 if any page has an error)
const { chromium } = require('playwright');
const fs = require('fs'); const path = require('path');
const walk = d => fs.existsSync(d) ? fs.readdirSync(d, { withFileTypes: true }).flatMap(e =>
  e.isDirectory() ? walk(path.join(d, e.name)) : e.name.endsWith('.html') ? [path.join(d, e.name)] : []) : [];
(async () => {
  const files = process.argv.slice(2).flatMap(walk);
  const mj = process.env.MATHJAX_DIR && path.resolve(process.env.MATHJAX_DIR);
  const b = await chromium.launch(); const p = await b.newPage(); let bad = 0, rendered = 0;
  if (mj) await p.route(/mathjax@[^/]+\/es5\//, r => {
    const f = path.join(mj, r.request().url().replace(/^.*mathjax@[^/]+\/es5\//, '').split('?')[0]);
    return fs.existsSync(f) ? r.fulfill({ path: f }) : r.continue();
  });
  for (const f of files) {
    await p.goto('file://' + path.resolve(f));
    await p.waitForTimeout(2500);
    const r = await p.evaluate(() => ({
      tex: document.querySelectorAll('.math, script[type^="math/tex"]').length,
      ok: document.querySelectorAll('mjx-container').length,
      // red text: an undefined macro (noundefined extension) or a TeX error
      errs: Array.from(document.querySelectorAll('mjx-merror, merror, mtext[mathcolor="red"]'))
        .map(e => e.getAttribute('data-mjx-error') || e.textContent) }));
    if (r.errs.length) { bad++; console.log(`FAIL ${f}: ${[...new Set(r.errs)].slice(0, 5).join(' | ')}`); }
    else if (r.tex > 0 && r.ok === 0) { bad++; console.log(`FAIL ${f}: ${r.tex} formula(s) but MathJax rendered none`); }
    else if (r.ok > 0) { rendered += r.ok; }
  }
  console.log(`${files.length} page(s) checked, ${rendered} formula(s) rendered, ${bad} page(s) with maths errors`);
  await b.close(); process.exit(bad ? 1 : 0);
})();
