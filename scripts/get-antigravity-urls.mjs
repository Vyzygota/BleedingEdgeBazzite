import { chromium } from 'playwright';

const browser = await chromium.launch();
const page = await browser.newPage();

// Antigravity 2.0 — latest release from releases page (first entry = newest)
await page.goto('https://antigravity.google/releases', { waitUntil: 'networkidle', timeout: 30000 });
const releaseLinks = await page.$$eval('a', els => els.map(e => e.href));
const ag2Url = releaseLinks.find(h => h.includes('linux-x64') && h.includes('antigravity-hub') && h.endsWith('.tar.gz'));

// Antigravity IDE — only listed on download page
await page.goto('https://antigravity.google/download', { waitUntil: 'networkidle', timeout: 30000 });
const downloadLinks = await page.$$eval('a', els => els.map(e => e.href));
const agIdeUrl = downloadLinks.find(h => h.includes('linux-x64') && h.includes('Antigravity%20IDE') && h.endsWith('.tar.gz'));

await browser.close();

if (!ag2Url) { console.error('ERROR: Nie znaleziono URL dla Antigravity 2.0'); process.exit(1); }
if (!agIdeUrl) { console.error('ERROR: Nie znaleziono URL dla Antigravity IDE'); process.exit(1); }

// GitHub Actions: zapis do GITHUB_ENV
console.log(`ANTIGRAVITY_URL=${ag2Url}`);
console.log(`ANTIGRAVITY_IDE_URL=${agIdeUrl}`);
