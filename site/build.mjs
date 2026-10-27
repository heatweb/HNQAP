// Builds hnqap.org from the repository: the hand-written pages in
// site/content, the data standard in standard/, and the KPI reference in
// kpis/. Every page is written twice, as index.html for people and
// index.md for agents, and llms.txt lists the Markdown versions.
//
//   node site/build.mjs            → _site/
//
// The JSON files are the source of truth; nothing here is edited by hand
// except site/content.
import { readFileSync, writeFileSync, mkdirSync, rmSync, copyFileSync, existsSync, readdirSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { marked } from 'marked';

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '..');
const OUT = join(ROOT, '_site');
const SITE = 'https://hnqap.org';
const REPO = 'https://github.com/heatweb/HNQAP';
const BLOB = `${REPO}/blob/main`;
const RAW = 'https://raw.githubusercontent.com/heatweb/HNQAP/main';
const BUILT = new Date().toISOString().slice(0, 10);

const read = (p) => readFileSync(join(ROOT, p), 'utf8');
const readJson = (p) => JSON.parse(read(p));
const esc = (s) =>
  String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const cellMd = (s) => String(s ?? '').replace(/\|/g, '\\|').replace(/\n/g, ' ');
const kpiSlug = (code) => code.replace(/‑/g, '-').toLowerCase();

const kpi = readJson('kpis/kpi-reference.json');
const vocab = readJson('standard/vocabulary.json');
const mpoints = readJson('standard/monitoring-points.json');

// ── Links inside repository Markdown ────────────────────────────────────
// Repository files link to each other relatively; on the site those links
// go to the matching page, and anything without a page goes to GitHub.
const PAGE_FOR = {
  'standard/README.md': '/standard/',
  'standard/': '/standard/',
  'standard/BMS-CONNECTION-GUIDE.md': '/bms-guide/',
  'standard/PROPOSED.md': '/vocabulary/proposed/',
  'standard/varkeys.md': '/vocabulary/',
  'standard/vargroups.md': '/vocabulary/',
  'standard/vocabulary.json': '/data/vocabulary.json',
  'standard/monitoring-points.json': '/data/monitoring-points.json',
  'kpis/': '/kpis/',
  'kpis/README.md': '/kpis/',
  'kpis/kpi-reference.md': '/kpis/',
  'kpis/kpi-reference.json': '/data/kpi-reference.json',
  'kpis/heat-network-kpi-reference.pdf': '/data/heat-network-kpi-reference.pdf',
  'CONTRIBUTING.md': '/collaborate/',
};
function rewriteLinks(md, fromDir) {
  return md.replace(/\]\((?!https?:|mailto:|#|\/)([^)\s]+)\)/g, (_m, target) => {
    const [path, hash] = target.split('#');
    const joined = join(fromDir, path).replace(/\\/g, '/').replace(/^\.\//, '');
    const key = existsSync(join(ROOT, joined)) && !joined.includes('.') ? `${joined}/` : joined;
    const page = PAGE_FOR[key] ?? PAGE_FOR[joined] ?? `${BLOB}/${joined}`;
    return `](${page}${hash ? `#${hash}` : ''})`;
  });
}

// ── Markdown with heading anchors ───────────────────────────────────────
const slugify = (t) =>
  t.toLowerCase().replace(/<[^>]+>/g, '').replace(/[^\w\s-]/g, '').trim().replace(/\s+/g, '-');
marked.use({
  gfm: true,
  renderer: {
    heading(text, depth) {
      const id = slugify(text);
      return `<h${depth} id="${id}"><a class="anchor" href="#${id}" aria-hidden="true">#</a>${text}</h${depth}>\n`;
    },
    table(header, body) {
      return `<div class="table-wrap"><table>\n<thead>\n${header}</thead>\n<tbody>${body}</tbody></table></div>\n`;
    },
  },
});

function frontMatter(src) {
  const m = src.match(/^---\n([\s\S]*?)\n---\n/);
  if (!m) return { meta: {}, body: src };
  const meta = {};
  for (const line of m[1].split('\n')) {
    const i = line.indexOf(':');
    if (i > 0) meta[line.slice(0, i).trim()] = line.slice(i + 1).trim();
  }
  return { meta, body: src.slice(m[0].length) };
}

// ── Page shell ──────────────────────────────────────────────────────────
const NAV = [
  ['/', 'Home'],
  ['/getting-started/', 'Get started'],
  ['/collaborate/', 'Collaborate'],
  ['/protocol/', 'Protocol'],
  ['/monitoring-points/', 'Points'],
  ['/kpis/', 'KPIs'],
  ['/vocabulary/', 'Vocabulary'],
];
const pages = []; // { url, title, description, markdown, section }

function shell({ url, title, description, html, source, jsonLd }) {
  const full = url === '/' ? 'HNQAP — Heat Network Quality Assurance Publications' : `${title} — HNQAP`;
  const nav = NAV.map(
    ([href, label]) =>
      `<a href="${href}"${href === url || (href !== '/' && url.startsWith(href)) ? ' aria-current="page"' : ''}>${label}</a>`,
  ).join('');
  const ld = jsonLd ? `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>` : '';
  const edit = source ? ` · <a href="${BLOB}/${source}">Edit this page on GitHub</a>` : '';
  return `<!doctype html>
<html lang="en-GB">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(full)}</title>
<meta name="description" content="${esc(description)}">
<link rel="canonical" href="${SITE}${url}">
<link rel="alternate" type="text/markdown" href="${SITE}${url}index.md">
<meta property="og:title" content="${esc(full)}">
<meta property="og:description" content="${esc(description)}">
<meta property="og:url" content="${SITE}${url}">
<meta property="og:type" content="website">
<meta property="og:site_name" content="HNQAP">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="/style.css">
${ld}
</head>
<body>
<header class="site"><div class="wrap">
<a class="brand" href="/"><span class="mark" aria-hidden="true"></span>HNQAP</a>
<nav aria-label="Site">${nav}<a href="${REPO}">GitHub</a></nav>
</div></header>
<main class="wrap">
${html}
</main>
<footer class="site"><div class="wrap">
<p>HNQAP is an open, Apache-2.0 licensed project maintained by Heatweb Solutions Ltd with contributors from across the heat network industry.
It is independent: it is not part of, or endorsed by, the Heat Network Technical Assurance Scheme, whose own documents remain the authority for the scheme.</p>
<p>Built ${BUILT} from <a href="${REPO}">github.com/heatweb/HNQAP</a>${edit} · <a href="/llms.txt">llms.txt</a> · <a href="/about/">About</a></p>
</div></footer>
</body>
</html>
`;
}

function emit(url, title, description, markdown, opts = {}) {
  const html = opts.html ?? marked.parse(markdown);
  const dir = join(OUT, url);
  mkdirSync(dir, { recursive: true });
  writeFileSync(join(dir, 'index.html'), shell({ url, title, description, html, source: opts.source, jsonLd: opts.jsonLd }));
  writeFileSync(join(dir, 'index.md'), `# ${title}\n\n> ${description}\n\n${markdown.replace(/^# .*\n+/, '')}`);
  pages.push({ url, title, description, markdown, section: opts.section ?? 'Pages', list: opts.list !== false });
}

// ── Build ────────────────────────────────────────────────────────────────
rmSync(OUT, { recursive: true, force: true });
mkdirSync(OUT, { recursive: true });

// Hand-written pages.
for (const f of readdirSync(join(HERE, 'content')).filter((f) => f.endsWith('.md')).sort()) {
  const { meta, body } = frontMatter(read(`site/content/${f}`).replace(/\r\n/g, '\n'));
  const url = f === 'index.md' ? '/' : `/${f.replace(/\.md$/, '')}/`;
  const markdown = body
    .replaceAll('{{kpiCount}}', String(kpi.elements.reduce((n, e) => n + e.rows.length, 0)))
    .replaceAll('{{varkeyCount}}', String(vocab.varkeys.length))
    .replaceAll('{{vargroupCount}}', String(vocab.vargroups.length))
    .replaceAll('{{kpiGenerated}}', kpi.generated)
    .replaceAll('{{vocabExported}}', vocab.exportedAt.slice(0, 10));
  emit(url, meta.title ?? f, meta.description ?? '', markdown, {
    source: `site/content/${f}`,
    section: meta.section ?? 'Pages',
    jsonLd: url === '/' ? homeLd() : undefined,
  });
}

// The data standard and the reference connection guide, from the repo.
emit(
  '/standard/',
  'Data standard',
  'The six-level address, vargroups and varkeys: the names every HNQAP data point is published and stored under.',
  rewriteLinks(read('standard/README.md'), 'standard'),
  { source: 'standard/README.md', section: 'Standard' },
);
emit(
  '/bms-guide/',
  'BMS connection guide',
  'A worked implementation of the protocol: how a BMS or data logger publishes to one platform that runs it, with native, batch JSON and Sparkplug profiles.',
  rewriteLinks(read('standard/BMS-CONNECTION-GUIDE.md'), 'standard'),
  { source: 'standard/BMS-CONNECTION-GUIDE.md', section: 'Standard' },
);
if (existsSync(join(ROOT, 'standard/PROPOSED.md'))) {
  emit(
    '/vocabulary/proposed/',
    'Proposed names',
    'Varkeys and vargroups nominated but not yet approved. Comment before they land.',
    rewriteLinks(read('standard/PROPOSED.md'), 'standard'),
    { source: 'standard/PROPOSED.md', section: 'Vocabulary' },
  );
}

// KPI reference: the tables page, then one page per KPI.
const kpiTotal = kpi.elements.reduce((n, e) => n + e.rows.length, 0);
const kpiIntro = `${kpiTotal} KPIs across ${kpi.elements.length} element types, generated ${kpi.generated}. Download: [JSON](/data/kpi-reference.json) · [PDF, landscape A4](/data/heat-network-kpi-reference.pdf). Every code links to its own page, where it can be discussed.\n\n`;
const kpiTables = read('kpis/kpi-reference.md').replace(/\| (([A-Z]{2})‑KPI‑[^ |]+) \|/g, (_m, code) => `| [${code}](/kpis/${kpiSlug(code)}/) |`);
emit(
  '/kpis/',
  'Heat Network KPI Reference',
  `Every heat network KPI in one table per element type, with monitoring points, thresholds and the calculation. ${kpiTotal} KPIs, open for review.`,
  kpiTables.replace(/^# .*\n+/, `# Heat Network KPI Reference\n\n${kpiIntro}`),
  { source: 'kpis/kpi-reference.md', section: 'KPIs', jsonLd: datasetLd('Heat Network KPI Reference', 'kpi-reference.json', kpi.generated) },
);
for (const el of kpi.elements) {
  for (const r of el.rows) {
    const code = r.code.replace(/‑/g, '-');
    const slug = kpiSlug(code);
    const issue = `${REPO}/issues/new?template=kpi-comment.yml&kpi=${encodeURIComponent(code)}&title=${encodeURIComponent(`${code}: `)}`;
    const siblings = el.rows.filter((x) => x.group === r.group && x !== r).slice(0, 8);
    const md = [
      `# ${code} ${r.title}`,
      '',
      `| | |`,
      `|---|---|`,
      `| Element | ${el.name} (${el.code}) |`,
      `| Standing | ${r.standing} |`,
      `| Monitoring points | ${r.monitoring} |`,
      `| Threshold | ${r.threshold} |`,
      `| Calculation | ${r.calc} |`,
      `| Period | ${r.period} |`,
      '',
      r.group && kpi.groupLabels[r.group] ? `Part of the **${kpi.groupLabels[r.group]}** family.\n` : '',
      ...(kpi.departures ?? [])
        .filter((d) => (d.codes ?? []).includes(code))
        .map((d) => `> **Departs from the published method: ${d.topic}.** Published: ${d.published} This reference: ${d.here} Why: ${d.why} [Discussed in #${d.ref.split('/').pop()}](${d.ref}); see [all departures](/kpis/#where-this-reference-departs-from-the-published-methods).\n`),
      `## Discuss this KPI`,
      '',
      `Is the threshold right? Does the calculation match what you compute on your networks? [Comment on ${code}](${issue}), or report how it behaves on your data. Comments are public and are read before every revision.`,
      '',
      `## Machine-readable`,
      '',
      `This KPI is a row of [kpi-reference.json](/data/kpi-reference.json) (element \`${el.code}\`, code \`${code}\`). The [notation and rules](/kpis/#how-to-read-the-tables) that apply to every KPI are on the reference page.`,
      siblings.length ? `\n## Related KPIs on the ${el.name.toLowerCase()}\n\n${siblings.map((s) => `- [${s.code.replace(/‑/g, '-')} ${s.title}](/kpis/${kpiSlug(s.code)}/)`).join('\n')}` : '',
    ].join('\n');
    emit(`/kpis/${slug}/`, `${code} ${r.title}`, `${r.title}: ${r.threshold}. ${el.name} KPI, ${r.standing}. Monitoring points, threshold and calculation.`, md, {
      section: 'KPIs',
      list: false,
      jsonLd: {
        '@context': 'https://schema.org',
        '@type': 'DefinedTerm',
        termCode: code,
        name: r.title,
        description: `${r.calc}. Threshold ${r.threshold}; period ${r.period}.`,
        inDefinedTermSet: { '@type': 'DefinedTermSet', name: 'Heat Network KPI Reference', url: `${SITE}/kpis/` },
        url: `${SITE}/kpis/${slug}/`,
      },
    });
  }
}

// Monitoring points: every assurance point with its six-level address.
{
  const ELS = [['EC', 'Energy Centre'], ['DD', 'District Distribution'], ['SS', 'Substation'], ['CD', 'Communal Distribution'], ['CC', 'Consumer Connection']];
  const addr = (p) => `\`${p.device || '{device}'}/${p.vargroup}/${p.varkey}\``;
  const perDay = (n) => (n >= 288 ? '5 min' : n >= 96 ? '15 min' : n >= 48 ? '30 min' : n >= 24 ? 'hourly' : n > 0 ? `${n} a day` : '');
  const sections = ELS.map(([code, name]) => {
    const rows = mpoints.points.filter((p) => String(p.elementType).startsWith(code));
    const live = rows.filter((p) => p.kind === 'timeseries');
    const fixed = rows.filter((p) => p.kind === 'static');
    const derived = rows.filter((p) => p.kind === 'calculated' || p.kind === 'kpi');
    const out = [`## ${name} (${code})`, ''];
    if (live.length) {
      out.push('**Live readings**', '', '| Point | Monitoring point | Quantity | Address (device/vargroup/varkey) | Units | Minimum frequency |', '|---|---|---|---|---|---|');
      out.push(...live.map((p) => `| ${p.pointId} | ${cellMd(p.monitoringPoint)} | ${cellMd(p.description)} | ${addr(p)} | ${cellMd(p.units)} | ${perDay(p.valuesPerDay)} |`), '');
    }
    if (fixed.length) {
      out.push('**Values entered once** (design, identity)', '', '| Value | Address | Units |', '|---|---|---|');
      out.push(...fixed.map((p) => `| ${cellMd(p.description)} | \`${p.vargroup}/${p.varkey}\` | ${cellMd(p.units)} |`), '');
    }
    if (derived.length) {
      out.push('**Derived by the platform**', '', '| Value | Address | Units |', '|---|---|---|');
      out.push(...derived.map((p) => `| ${cellMd(p.description)} | \`${p.vargroup}/${p.varkey}\` | ${cellMd(p.units)} |`), '');
    }
    return out.join('\n');
  });
  const md = [
    '# Monitoring points',
    '',
    `Every monitoring point that heat network technical assurance asks for, with the address it is published under in [HNQAP-MQTT v1](/protocol/). ${mpoints.points.length} entries, generated ${mpoints.generated}. Download as [monitoring-points.json](/data/monitoring-points.json).`,
    '',
    'A full address is `{schema}/{network}/{element}/` followed by the device, vargroup and varkey shown. On a monitored element the device is named for the point it serves (`intake`, `offtake`, `boundary` and so on, see [protocol §2.2](/protocol/#22-elements-and-devices-on-monitored-networks)), so a receiver finds each point without a mapping step:',
    '',
    '```',
    'acme/riverside_court/ss1/intake/hmeter/kwh',
    '```',
    '',
    'Point codes and descriptions paraphrase the scheme drafts; the scheme documents remain the authority. Some of these names, including the `hmeter` and `meter` vargroups, are in use on live networks but not yet in the [vocabulary](/vocabulary/) export. They are being registered, and this table is their reference until then. Comments on any address are welcome as [issues](https://github.com/heatweb/HNQAP/issues/new?template=protocol-comment.yml).',
    '',
    ...sections,
  ].join('\n');
  emit('/monitoring-points/', 'Monitoring points', 'Every heat network assurance monitoring point mapped to its six-level MQTT address, with units and minimum data frequency.', md, {
    section: 'Standard',
    jsonLd: datasetLd('Heat network monitoring points', 'monitoring-points.json', mpoints.generated),
  });
}

// Vocabulary: index plus one page per vargroup.
const byGroup = new Map(vocab.vargroups.map((g) => [g.name, []]));
for (const k of vocab.varkeys) for (const g of k.vargroups ?? []) byGroup.get(g)?.push(k);
const kinds = [...new Set(vocab.vargroups.map((g) => g.kind))];
const vocabIndex = [
  `# Vocabulary`,
  '',
  `${vocab.varkeys.length} registered varkeys in ${vocab.vargroups.length} vargroups, exported ${vocab.exportedAt.slice(0, 10)}. A varkey has one shape (type and units) everywhere it is used. Download the registry as [vocabulary.json](/data/vocabulary.json); see the [data standard](/standard/) for the rules and [proposed names](/vocabulary/proposed/) for what is coming.`,
  '',
  ...kinds.flatMap((kind) => [
    `## ${kind.replace('_', ' ')}`,
    '',
    `| Vargroup | Title | Varkeys |`,
    `|---|---|---|`,
    ...vocab.vargroups
      .filter((g) => g.kind === kind)
      .map((g) => `| [\`${g.name}\`](/vocabulary/${g.name}/) | ${cellMd(g.title)} | ${byGroup.get(g.name).length} |`),
    '',
  ]),
  `## Propose a name`,
  '',
  `Search before you name anything. If no registered name has your meaning, [propose a varkey](${REPO}/issues/new?template=varkey-proposal.yml) with its vargroup, type, units and a one-line meaning.`,
].join('\n');
emit('/vocabulary/', 'Vocabulary', `The HNQAP registry: ${vocab.varkeys.length} varkeys in ${vocab.vargroups.length} vargroups, each with one type and one set of units.`, vocabIndex, {
  section: 'Vocabulary',
  jsonLd: datasetLd('HNQAP vocabulary', 'vocabulary.json', vocab.exportedAt.slice(0, 10)),
});
for (const g of vocab.vargroups) {
  const keys = byGroup.get(g.name).sort((a, b) => a.name.localeCompare(b.name));
  const md = [
    `# Vargroup ${g.name}`,
    '',
    `${g.title !== g.name ? `**${g.title}.** ` : ''}${g.description ?? ''} Kind: \`${g.kind}\`. ${keys.length} varkeys.`,
    '',
    `| Varkey | Title | Type | Units | Meaning | Aliases |`,
    `|---|---|---|---|---|---|`,
    ...keys.map(
      (k) =>
        `| <span id="${esc(k.name)}"></span>\`${k.name}\` | ${cellMd(k.title)} | ${cellMd(k.type)} | ${cellMd(k.units)} | ${cellMd(k.meaning)} | ${cellMd((k.aliases ?? []).join(', '))} |`,
    ),
  ].join('\n');
  emit(`/vocabulary/${g.name}/`, `Vargroup ${g.name}`, `${keys.length} varkeys in the ${g.name} vargroup (${g.kind}): names, types, units and meanings.`, md, {
    section: 'Vocabulary',
    list: false,
  });
}

// Static files and data.
mkdirSync(join(OUT, 'data'), { recursive: true });
copyFileSync(join(ROOT, 'kpis/kpi-reference.json'), join(OUT, 'data/kpi-reference.json'));
copyFileSync(join(ROOT, 'kpis/kpi-reference.md'), join(OUT, 'data/kpi-reference.md'));
copyFileSync(join(ROOT, 'kpis/heat-network-kpi-reference.pdf'), join(OUT, 'data/heat-network-kpi-reference.pdf'));
copyFileSync(join(ROOT, 'standard/vocabulary.json'), join(OUT, 'data/vocabulary.json'));
copyFileSync(join(ROOT, 'standard/monitoring-points.json'), join(OUT, 'data/monitoring-points.json'));
for (const f of readdirSync(join(HERE, 'static'))) copyFileSync(join(HERE, 'static', f), join(OUT, f));
writeFileSync(join(OUT, 'CNAME'), 'hnqap.org\n');
writeFileSync(join(OUT, '.nojekyll'), '');
writeFileSync(
  join(OUT, '404.html'),
  shell({ url: '/404/', title: 'Not found', description: 'Page not found', html: '<h1>Not found</h1><p>That page does not exist. Try the <a href="/">home page</a> or the <a href="/kpis/">KPI reference</a>.</p>' }),
);

// robots.txt: every crawler welcome, AI crawlers named so it is explicit.
const AI_BOTS = ['GPTBot', 'OAI-SearchBot', 'ChatGPT-User', 'ClaudeBot', 'Claude-SearchBot', 'Claude-User', 'PerplexityBot', 'Google-Extended', 'Applebot-Extended', 'CCBot', 'Bingbot'];
writeFileSync(
  join(OUT, 'robots.txt'),
  `# HNQAP is an open standard: everyone, people and agents, is welcome to read and reuse it.\nUser-agent: *\nAllow: /\n\n${AI_BOTS.map((b) => `User-agent: ${b}\nAllow: /`).join('\n\n')}\n\nSitemap: ${SITE}/sitemap.xml\n`,
);

// sitemap.xml
writeFileSync(
  join(OUT, 'sitemap.xml'),
  `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${pages
    .map((p) => `  <url><loc>${SITE}${p.url}</loc><lastmod>${BUILT}</lastmod></url>`)
    .join('\n')}\n</urlset>\n`,
);

// llms.txt (llmstxt.org): a short map of the site pointing at Markdown.
const ORDER = ['/', '/getting-started/', '/collaborate/', '/protocol/', '/monitoring-points/', '/standard/', '/bms-guide/', '/about/'];
const rank = (p) => (ORDER.indexOf(p.url) + 1 || 99);
const listed = (section) => pages.filter((p) => p.section === section && p.list).sort((a, b) => rank(a) - rank(b));
const line = (p) => `- [${p.title}](${SITE}${p.url}index.md): ${p.description}`;
writeFileSync(
  join(OUT, 'llms.txt'),
  `# HNQAP

> Heat Network Quality Assurance Publications: an open, Apache-2.0 data standard for heat network monitoring. It defines a six-level MQTT address for every data point (schema/network/element/device/vargroup/varkey), a registry of ${vocab.varkeys.length} point names with fixed types and units, and a reference of ${kpiTotal} heat network KPIs per element type (energy centre, district distribution, substation, communal distribution, consumer connection) aligned with the Heat Network Technical Assurance Scheme (HNTAS) and extending it to cooling, meter health and hours below outage limits. HNQAP is independent of the scheme.

Use the JSON files as the source of truth: look KPIs up by code in kpi-reference.json and validate point names against vocabulary.json. KPI codes look like EC-KPI-01, SS-KPI-07, CC-KPI-C-06 (cooling), CC-KPI-M-01 (meter health), EC-KPI-H-01 (hours below outage limits).

## Start here

${[...listed('Pages')].map(line).join('\n')}

## Standard

${listed('Standard').map(line).join('\n')}
- [Vocabulary](${SITE}/vocabulary/index.md): every vargroup with links to its varkeys.

## KPIs

- [Heat Network KPI Reference](${SITE}/kpis/index.md): all KPI tables with notation and rules.
- [Full text](${SITE}/llms-full.txt): the protocol, monitoring points, KPI reference and vocabulary in one file.
- Each KPI also has its own page at ${SITE}/kpis/<code>/, for example ${SITE}/kpis/ss-kpi-07/index.md.

## Data

- [kpi-reference.json](${SITE}/data/kpi-reference.json): KPI tables as data, per element, per KPI.
- [vocabulary.json](${SITE}/data/vocabulary.json): the varkey and vargroup registry.
- [monitoring-points.json](${SITE}/data/monitoring-points.json): assurance monitoring points with their six-level addresses.
- [heat-network-kpi-reference.pdf](${SITE}/data/heat-network-kpi-reference.pdf): printable KPI reference.

## Optional

- [GitHub repository](${REPO}): issues, discussions, history and source.
- [Proposed names](${SITE}/vocabulary/proposed/index.md): nominated, not yet approved.
`,
);

// llms-full.txt: the substance in one file for agents that want it all.
const fullParts = ['/protocol/', '/standard/', '/monitoring-points/', '/kpis/', '/getting-started/', '/collaborate/'].map((u) => pages.find((p) => p.url === u)).filter(Boolean);
const vocabFlat = vocab.vargroups
  .map((g) => `## Vargroup ${g.name} (${g.kind})\n\n${byGroup.get(g.name).map((k) => `- ${k.name}: ${k.title}${k.units ? ` [${k.units}]` : ''} (${k.type})${k.meaning ? ` — ${k.meaning}` : ''}`).join('\n')}`)
  .join('\n\n');
writeFileSync(
  join(OUT, 'llms-full.txt'),
  `# HNQAP — full text\n\nSource: ${SITE} · ${REPO} · built ${BUILT}\n\n${fullParts.map((p) => `---\n\n# ${p.title}\n\n${p.markdown.replace(/^# .*\n+/, '')}`).join('\n\n')}\n\n---\n\n# Vocabulary\n\n${vocabFlat}\n`,
);

console.log(`hnqap.org: ${pages.length} pages → ${OUT}`);

// ── JSON-LD helpers ─────────────────────────────────────────────────────
function homeLd() {
  return {
    '@context': 'https://schema.org',
    '@graph': [
      { '@type': 'WebSite', name: 'HNQAP', alternateName: 'Heat Network Quality Assurance Publications', url: `${SITE}/` },
      { '@type': 'Organization', name: 'Heatweb Solutions Ltd', url: 'https://heatweb.co.uk' },
      {
        '@type': 'SoftwareSourceCode',
        name: 'HNQAP',
        codeRepository: REPO,
        license: 'https://www.apache.org/licenses/LICENSE-2.0',
        programmingLanguage: ['SQL', 'JavaScript', 'JSON'],
      },
    ],
  };
}
function datasetLd(name, file, date) {
  return {
    '@context': 'https://schema.org',
    '@type': 'Dataset',
    name,
    description: `${name}, published by HNQAP as open data.`,
    url: `${SITE}/data/${file}`,
    license: 'https://www.apache.org/licenses/LICENSE-2.0',
    dateModified: date,
    creator: { '@type': 'Organization', name: 'Heatweb Solutions Ltd' },
    isAccessibleForFree: true,
    distribution: [{ '@type': 'DataDownload', encodingFormat: 'application/json', contentUrl: `${SITE}/data/${file}` }],
    sameAs: `${RAW}/${file.startsWith('kpi') ? 'kpis' : 'standard'}/${file}`,
  };
}
