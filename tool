<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
<meta charset="UTF-8">
<title>Cover Payouts Checker</title>
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
/* ── THEMES ─────────────────────────────────────────────── */
[data-theme="light"] {
  --bg: #f5f6fa;
  --surface: #ffffff;
  --surface2: #f0f1f5;
  --border: #e2e4ec;
  --green: #0a9e6e;
  --green-dim: rgba(10,158,110,0.10);
  --red: #d93652;
  --red-dim: rgba(217,54,82,0.10);
  --yellow: #c48a00;
  --yellow-dim: rgba(196,138,0,0.10);
  --text: #1a1d27;
  --muted: #8b90a0;
  --accent: #2f5fd4;
  --tooltip-bg: #1a1d27;
  --tooltip-text: #f5f6fa;
  --shadow: 0 4px 20px rgba(0,0,0,0.08);
}
[data-theme="dark"] {
  --bg: #0d0f14;
  --surface: #151820;
  --surface2: #1c2030;
  --border: #252a38;
  --green: #00e5a0;
  --green-dim: rgba(0,229,160,0.12);
  --red: #ff4d6a;
  --red-dim: rgba(255,77,106,0.12);
  --yellow: #f5c542;
  --yellow-dim: rgba(245,197,66,0.12);
  --text: #e8ecf4;
  --muted: #5a6278;
  --accent: #4d7cff;
  --tooltip-bg: #e8ecf4;
  --tooltip-text: #0d0f14;
  --shadow: 0 4px 20px rgba(0,0,0,0.4);
}

* { box-sizing: border-box; margin: 0; padding: 0; }
body {
  background: var(--bg); color: var(--text);
  font-family: 'IBM Plex Sans', sans-serif;
  min-height: 100vh; padding: 32px 24px;
  transition: background 0.3s, color 0.3s;
}

/* ── HEADER ─────────────────────────────────────────────── */
header {
  display: flex; align-items: center;
  gap: 12px; margin-bottom: 28px;
}
header .dot {
  width: 10px; height: 10px; border-radius: 50%;
  background: var(--green); box-shadow: 0 0 8px var(--green);
  animation: pulse 2s infinite; flex-shrink: 0;
}
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.35} }
header h1 {
  font-family: 'IBM Plex Mono', monospace;
  font-size: 18px; font-weight: 600;
  letter-spacing: 0.04em; color: var(--text);
}
header .v-tag {
  font-size: 11px; color: var(--muted);
  font-family: 'IBM Plex Mono', monospace;
}
.header-right { margin-left: auto; }

.theme-toggle {
  display: flex; align-items: center; gap: 8px;
  cursor: pointer; background: var(--surface);
  border: 1px solid var(--border); border-radius: 99px;
  padding: 5px 12px 5px 8px; transition: all 0.2s; user-select: none;
}
.theme-toggle:hover { border-color: var(--accent); }
.toggle-track {
  width: 32px; height: 18px; background: var(--surface2);
  border-radius: 99px; border: 1px solid var(--border);
  position: relative; transition: background 0.2s;
}
.toggle-thumb {
  width: 12px; height: 12px; border-radius: 50%;
  background: var(--muted); position: absolute;
  top: 2px; left: 2px;
  transition: transform 0.25s cubic-bezier(0.34,1.56,0.64,1), background 0.2s;
}
[data-theme="dark"] .toggle-thumb { transform: translateX(14px); background: var(--accent); }
.toggle-label {
  font-family: 'IBM Plex Mono', monospace;
  font-size: 11px; font-weight: 600; color: var(--muted); letter-spacing: 0.06em;
}

/* ── INPUT ───────────────────────────────────────────────── */
.input-section {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: 10px; padding: 20px; margin-bottom: 20px;
}
.input-section label {
  display: block; font-size: 11px; font-weight: 600;
  letter-spacing: 0.1em; color: var(--muted);
  text-transform: uppercase; margin-bottom: 10px;
}
textarea {
  width: 100%; height: 140px; background: var(--surface2);
  border: 1px solid var(--border); border-radius: 6px;
  color: var(--text); font-family: 'IBM Plex Mono', monospace;
  font-size: 12px; padding: 12px; resize: vertical; outline: none;
  transition: border-color 0.2s, background 0.3s;
}
textarea:focus { border-color: var(--accent); }
textarea::placeholder { color: var(--muted); }
.btn-row { display: flex; gap: 10px; margin-top: 14px; }
button {
  font-family: 'IBM Plex Mono', monospace; font-size: 13px; font-weight: 600;
  border: none; border-radius: 6px; padding: 10px 22px;
  cursor: pointer; letter-spacing: 0.04em; transition: all 0.15s;
}
.btn-primary { background: var(--accent); color: #fff; }
.btn-primary:hover { filter: brightness(1.15); transform: translateY(-1px); }
.btn-ghost { background: transparent; color: var(--muted); border: 1px solid var(--border); }
.btn-ghost:hover { color: var(--text); border-color: var(--text); }

#error {
  background: var(--red-dim); border: 1px solid var(--red);
  color: var(--red); border-radius: 6px; padding: 10px 14px;
  font-size: 13px; margin-bottom: 16px; display: none;
}

/* ── DASHBOARD ───────────────────────────────────────────── */
#dashboard { display: none; margin-bottom: 24px; }

.cards {
  display: grid; grid-template-columns: repeat(auto-fit, minmax(180px,1fr));
  gap: 14px; margin-bottom: 20px;
}
.card {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: 10px; padding: 18px; position: relative; overflow: hidden;
  transition: background 0.3s, border-color 0.3s;
}
.card::before { content:''; position:absolute; top:0; left:0; right:0; height:2px; }
.card.green::before  { background: var(--green); }
.card.red::before    { background: var(--red); }
.card.yellow::before { background: var(--yellow); }
.card.blue::before   { background: var(--accent); }
.card-label { font-size:10px; font-weight:600; letter-spacing:0.12em; color:var(--muted); text-transform:uppercase; margin-bottom:8px; }
.card-value { font-family:'IBM Plex Mono',monospace; font-size:22px; font-weight:600; line-height:1; }
.card.green  .card-value { color: var(--green); }
.card.red    .card-value { color: var(--red); }
.card.yellow .card-value { color: var(--yellow); }
.card.blue   .card-value { color: var(--accent); }
.card-sub { font-size:11px; color:var(--muted); margin-top:6px; }

.status-badge {
  display:inline-flex; align-items:center; gap:10px; padding:12px 20px;
  border-radius:8px; font-family:'IBM Plex Mono',monospace;
  font-size:17px; font-weight:600; margin-bottom:20px;
  letter-spacing:0.02em;
}
.status-badge.ok  { background:var(--green-dim); color:var(--green); border:1px solid rgba(0,200,140,0.3); }
.status-badge.bad { background:var(--red-dim);   color:var(--red);   border:1px solid rgba(220,60,80,0.3); }

/* ── COVERAGE PANEL ──────────────────────────────────────── */
.coverage-panel {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: 10px; padding: 24px 28px; margin-bottom: 20px;
  transition: background 0.3s, border-color 0.3s;
}
.coverage-header {
  display:flex; justify-content:space-between;
  align-items:flex-start; margin-bottom:18px; gap:16px;
}
.coverage-left { flex:1; }
.coverage-right { text-align:right; flex-shrink:0; }
.coverage-title {
  font-size:11px; font-weight:600; letter-spacing:0.1em;
  text-transform:uppercase; color:var(--muted); margin-bottom:6px;
}
.coverage-pct {
  font-family:'IBM Plex Mono',monospace;
  font-size:56px; font-weight:600; line-height:1; letter-spacing:-0.02em;
}
.coverage-pct-sub {
  font-size:11px; color:var(--muted); font-family:'IBM Plex Mono',monospace;
  letter-spacing:0.06em; margin-top:4px;
}

/* ── TIMELINE BAR ────────────────────────────────────────── */
.timeline-wrapper {
  position:relative; margin-bottom:12px;
  padding: 5px 0; /* breathing room so scaleY doesn't clip */
}

.timeline-bar {
  display: flex; height: 22px; border-radius: 99px;
  overflow: hidden;
  position: relative; gap: 1px;
  background: var(--surface2); border: 1px solid var(--border);
  cursor: crosshair; width: 100%;
}

.bar-segment {
  height: 100%; transition: filter 0.12s;
  position: relative; min-width: 2px; flex-shrink: 0;
}
.bar-segment:first-child { border-radius: 99px 0 0 99px; }
.bar-segment:last-child  { border-radius: 0 99px 99px 0; }
.bar-segment:only-child  { border-radius: 99px; }
.bar-segment.seg-green   { background: var(--green); }
.bar-segment.seg-red     { background: var(--red); }
.bar-segment.seg-yellow  { background: var(--yellow); }
.bar-segment.seg-neutral { background: var(--muted); opacity: 0.3; }
.bar-segment:hover       { filter: brightness(1.3); transform: scaleY(1.35); z-index: 2; }

.bar-cursor {
  position: absolute; top: -5px; bottom: -5px; width: 2px;
  background: var(--text); border-radius: 2px;
  pointer-events: none; opacity: 0; transition: opacity 0.1s; z-index: 10;
}
.timeline-wrapper:hover .bar-cursor { opacity: 0.45; }

/* ── TOOLTIP ─────────────────────────────────────────────── */
.timeline-tooltip {
  position: fixed; background: var(--tooltip-bg); color: var(--tooltip-text);
  border-radius: 10px; padding: 14px 16px;
  font-family: 'IBM Plex Mono', monospace; font-size: 12px;
  pointer-events: none; opacity: 0; transition: opacity 0.12s;
  z-index: 9999; min-width: 230px; box-shadow: var(--shadow); line-height: 1.65;
}
.timeline-tooltip.visible { opacity: 1; }
.tt-date  { font-size:10px; opacity:0.55; margin-bottom:3px; }
.tt-title { font-size:13px; font-weight:600; margin-bottom:8px; }
.tt-row   { display:flex; justify-content:space-between; gap:16px; font-size:11px; margin-bottom:2px; }
.tt-label { opacity:0.6; }
.tt-value { font-weight:600; }
.tt-value.green  { color: #00e5a0; }
.tt-value.red    { color: #ff6b6b; }
.tt-value.yellow { color: #ffd166; }
.tt-divider { border:none; border-top:1px solid rgba(128,128,128,0.2); margin:7px 0; }

.bar-legend { display:flex; gap:20px; margin-top:10px; }
.legend-item { display:flex; align-items:center; gap:6px; font-size:11px; color:var(--muted); }
.legend-dot  { width:8px; height:8px; border-radius:50%; }

/* ── TABLE ───────────────────────────────────────────────── */
.table-section {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: 10px;
  transition: background 0.3s, border-color 0.3s;
}
.table-header-bar {
  display:flex; justify-content:space-between; align-items:center;
  padding:14px 20px; border-bottom:1px solid var(--border);
  flex-wrap:wrap; gap:8px;
}
.table-header-bar > span {
  font-size:11px; font-weight:600; letter-spacing:0.1em;
  text-transform:uppercase; color:var(--muted);
}
.legend-inline { display:flex; gap:14px; flex-wrap:wrap; }
.legend-inline .chip {
  display:inline-flex; align-items:center; gap:5px;
  font-size:11px; font-family:'IBM Plex Mono',monospace; color:var(--muted);
}
.chip-dot { width:7px; height:7px; border-radius:50%; }
.table-wrapper { overflow-x:auto; width:100%; }
table { width:100%; border-collapse:collapse; font-size:12px; }
thead tr th {
  background:var(--surface2); padding:9px 14px; text-align:right;
  font-size:10px; font-weight:600; letter-spacing:0.08em; text-transform:uppercase;
  color:var(--muted); border-bottom:1px solid var(--border); white-space:nowrap;
  transition:background 0.3s;
}
thead tr th:first-child { text-align:center; }
thead tr th:nth-child(3),thead tr th:nth-child(4),thead tr th:nth-child(5) { text-align:left; }
tbody tr { border-bottom:1px solid var(--border); transition:background 0.1s; }
tbody tr:hover { background:rgba(128,128,128,0.04); }
tbody tr td { padding:8px 14px; text-align:right; font-family:'IBM Plex Mono',monospace; white-space:nowrap; }
tbody tr td:first-child { text-align:center; color:var(--muted); font-size:11px; }
tbody tr td:nth-child(3),tbody tr td:nth-child(4),tbody tr td:nth-child(5) { font-family:'IBM Plex Sans',sans-serif; text-align:left; }
td.cell-green  { color:var(--green);  font-weight:600; }
td.cell-red    { color:var(--red);    font-weight:600; }
td.cell-yellow { color:var(--yellow); font-weight:600; }
.status-cell {
  display:inline-flex; align-items:center; gap:5px;
  font-size:11px; font-weight:600; border-radius:4px; padding:2px 8px; white-space:nowrap;
}
.status-cell.covered   { background:var(--green-dim);  color:var(--green); }
.status-cell.uncovered { background:var(--red-dim);    color:var(--red); }
.status-cell.partial   { background:var(--yellow-dim); color:var(--yellow); }
.status-cell.neutral   { color:var(--muted); }

.btn-download {
  font-family:'IBM Plex Mono',monospace; font-size:11px; font-weight:600;
  background: transparent; color: var(--accent);
  border: 1px solid var(--accent); border-radius: 6px;
  padding: 5px 14px; cursor: pointer; letter-spacing: 0.04em;
  transition: all 0.15s; display: inline-flex; align-items: center; gap: 6px;
}
.btn-download:hover { background: var(--accent); color: #fff; }

/* ── FILTER BAR ──────────────────────────────────────────── */
.filter-bar {
  display: flex; align-items: center; gap: 8px;
  padding: 10px 20px; border-bottom: 1px solid var(--border);
  flex-wrap: wrap; background: var(--surface2);
}
.filter-label {
  font-size: 10px; font-weight: 600; letter-spacing: 0.1em;
  text-transform: uppercase; color: var(--muted);
  margin-right: 4px; flex-shrink: 0;
}
.filter-btn {
  font-family: 'IBM Plex Mono', monospace; font-size: 11px; font-weight: 600;
  border: 1px solid var(--border); border-radius: 99px;
  padding: 4px 12px; cursor: pointer; letter-spacing: 0.03em;
  background: var(--surface); color: var(--muted);
  transition: all 0.15s; white-space: nowrap;
}
.filter-btn:hover { border-color: var(--text); color: var(--text); }
.filter-btn.active { background: var(--text); color: var(--bg); border-color: var(--text); }
.filter-btn.active.f-all    { background: var(--accent); border-color: var(--accent); color: #fff; }
.filter-btn.active.f-debt   { background: var(--red);    border-color: var(--red);    color: #fff; }
.filter-btn.active.f-ok     { background: var(--green);  border-color: var(--green);  color: #fff; }
.filter-btn.active.f-partial{ background: var(--yellow); border-color: var(--yellow); color: #fff; }
.filter-sep { width: 1px; height: 16px; background: var(--border); margin: 0 4px; flex-shrink:0; }
.sort-btn {
  font-family: 'IBM Plex Mono', monospace; font-size: 11px; font-weight: 600;
  border: 1px solid var(--border); border-radius: 99px;
  padding: 4px 12px; cursor: pointer; letter-spacing: 0.03em;
  background: var(--surface); color: var(--muted);
  transition: all 0.15s; display: inline-flex; align-items: center; gap: 5px;
}
.sort-btn:hover { border-color: var(--accent); color: var(--accent); }
.sort-btn.active { background: var(--accent); border-color: var(--accent); color: #fff; }
.filter-count {
  margin-left: auto; font-family: 'IBM Plex Mono', monospace;
  font-size: 11px; color: var(--muted);
}
</style>
</head>
<body>

<header>
  <div class="dot"></div>
  <h1>COVER PAYOUTS CHECKER</h1>
  <span class="v-tag">v2.1</span>
  <div class="header-right">
    <div class="theme-toggle" onclick="toggleTheme()" title="Toggle dark / light mode">
      <div class="toggle-track"><div class="toggle-thumb"></div></div>
      <span class="toggle-label" id="theme-label">LIGHT</span>
    </div>
  </div>
</header>

<div class="input-section">
  <label>Transaction Data — paste tab-separated rows (any order, auto-sorted by timestamp)</label>
  <textarea id="input" placeholder="Paste your tab-separated data here...&#10;&#10;Columns: Document | TranDateTime | TranType | Description | EnteredBy | CreditedAmount | DebitAmount | TotalAmount"></textarea>
  <div class="btn-row">
    <button class="btn-primary" onclick="process()">▶ Run Analysis</button>
    <button class="btn-ghost"   onclick="clearAll()">✕ Clear</button>
  </div>
</div>

<div id="error"></div>

<div id="dashboard">

  <div id="status-badge-wrap"></div>

  <div class="coverage-panel">
    <div class="coverage-header">
      <div class="coverage-left">
        <div class="coverage-title">Payout Coverage Timeline</div>
        <div style="font-size:12px;color:var(--muted);margin-top:2px;">Hover the bar to inspect each transaction</div>
      </div>
      <div class="coverage-right">
        <div class="coverage-pct" id="pct-display">0%</div>
        <div class="coverage-pct-sub" id="pct-sub">of payouts covered</div>
      </div>
    </div>
    <div class="timeline-wrapper" id="timeline-wrapper">
      <div class="timeline-bar" id="timeline-bar"></div>
      <div class="bar-cursor"   id="bar-cursor"></div>
    </div>
    <div class="bar-legend">
      <div class="legend-item"><div class="legend-dot" style="background:var(--green)"></div><span id="leg-covered">$0 covered</span></div>
      <div class="legend-item"><div class="legend-dot" style="background:var(--red)"></div><span id="leg-uncovered">$0 uncovered</span></div>
      <div class="legend-item"><div class="legend-dot" style="background:var(--muted)"></div><span id="leg-total">$0 total payouts</span></div>
    </div>
  </div>

  <div class="cards">
    <div class="card red">
      <div class="card-label">Total Payouts</div>
      <div class="card-value" id="c-payouts">—</div>
      <div class="card-sub"   id="c-payouts-sub"></div>
    </div>
    <div class="card green">
      <div class="card-label">Total Deposits</div>
      <div class="card-value" id="c-deposits">—</div>
      <div class="card-sub"   id="c-deposits-sub"></div>
    </div>
    <div class="card yellow">
      <div class="card-label">Still Uncovered</div>
      <div class="card-value" id="c-uncovered">—</div>
      <div class="card-sub"   id="c-uncovered-sub"></div>
    </div>
    <div class="card blue">
      <div class="card-label">Rows Processed</div>
      <div class="card-value" id="c-rows">—</div>
      <div class="card-sub"   id="c-rows-sub"></div>
    </div>
  </div>

  <div class="table-section">
    <div class="table-header-bar">
      <span>Transaction Detail</span>
      <div style="display:flex;align-items:center;gap:16px;flex-wrap:wrap;">
        <button class="btn-download" onclick="downloadCSV()">⬇ Download CSV</button>
        <div class="legend-inline">
        <div class="chip"><div class="chip-dot" style="background:var(--green)"></div>Covered / No Debt</div>
        <div class="chip"><div class="chip-dot" style="background:var(--red)"></div>Payout / In Debt</div>
        <div class="chip"><div class="chip-dot" style="background:var(--yellow)"></div>Partially Covers Debt</div>
      </div>
    </div>
    <div class="filter-bar" id="filter-bar">
      <span class="filter-label">Filter</span>
      <button class="filter-btn f-all active"    onclick="setFilter('all')"    >All</button>
      <button class="filter-btn f-debt"           onclick="setFilter('debt')"   >⚠ In Debt</button>
      <button class="filter-btn f-ok"             onclick="setFilter('ok')"     >✓ Covered</button>
      <button class="filter-btn f-partial"        onclick="setFilter('partial')">◑ Partial</button>
      <div class="filter-sep"></div>
      <span class="filter-label">Sort</span>
      <button class="sort-btn active" id="sort-asc"  onclick="setSort('asc')" >↑ Oldest first</button>
      <button class="sort-btn"        id="sort-desc" onclick="setSort('desc')">↓ Newest first</button>
      <span class="filter-count" id="filter-count"></span>
    </div>
    <div class="table-wrapper">
      <table>
        <thead><tr>
          <th>#</th><th>Document</th><th>DateTime</th><th>TranType</th>
          <th>Description</th><th>EnteredBy</th><th>Credited</th>
          <th>Debit</th><th>Total</th><th>Status</th>
        </tr></thead>
        <tbody id="tbody"></tbody>
      </table>
    </div>
  </div>
</div>

<div class="timeline-tooltip" id="tt"></div>

<script>
/* ── THEME ─────────────────────────────────────────────── */
function toggleTheme() {
  const html = document.documentElement;
  const dark = html.getAttribute('data-theme') === 'dark';
  html.setAttribute('data-theme', dark ? 'light' : 'dark');
  document.getElementById('theme-label').textContent = dark ? 'LIGHT' : 'DARK';
}

/* ── UTILS ─────────────────────────────────────────────── */
function fmt(val) {
  const n = parseFloat(val);
  if (isNaN(n)) return val ?? '';
  return n.toLocaleString('en-US', { minimumFractionDigits:2, maximumFractionDigits:2 });
}
function fmtUSD(n) {
  return '$' + Math.abs(n).toLocaleString('en-US', { minimumFractionDigits:2, maximumFractionDigits:2 });
}

function clearAll() {
  document.getElementById('input').value = '';
  document.getElementById('error').style.display = 'none';
  document.getElementById('dashboard').style.display = 'none';
  document.getElementById('input').focus();
}

/* ── GLOBAL state ──────────────────────────────────────── */
let _processed = [];

/* ── MAIN ──────────────────────────────────────────────── */
function process() {
  const errorEl = document.getElementById('error');
  errorEl.style.display = 'none';

  const input = document.getElementById('input').value.trim();
  if (!input) { errorEl.textContent='⚠️ Please paste data first.'; errorEl.style.display='block'; return; }

  const lines = input.split('\n').filter(l => l.trim());
  if (!lines.length) { errorEl.textContent='⚠️ No rows found.'; errorEl.style.display='block'; return; }

  // Step 1: clean every row — strip the "Deposit & Redemptions" injected column
  const SKIP_CELL = 'Deposit & Redemptions';
  let allRows = lines.map(l => l.split('\t').filter(c => c.trim() !== SKIP_CELL));

  // Step 2: skip header — a header row has no numeric value in its last column
  const lastCol = r => r[r.length - 1];
  let dataRows = allRows;
  if (allRows.length && isNaN(parseFloat(lastCol(allRows[0])))) {
    dataRows = allRows.slice(1);
  }
  if (!dataRows.length) { errorEl.textContent='⚠️ Only a header row detected.'; errorEl.style.display='block'; return; }

  const dataLines = dataRows.map(r => r.join('\t')); // keep for row count display
  const COL_DATE = 1;

  // Step 3: TotalAmount is always the LAST column after stripping
  let rows = dataRows;
  let COL = rows[0].length - 1;

  rows.sort((a,b) => {
    const da=new Date(a[COL_DATE]), db=new Date(b[COL_DATE]);
    if(isNaN(da)) return 1; if(isNaN(db)) return -1;
    return da-db;
  });

  let debt=0, processed=[];
  let totalPayouts=0, totalDeposits=0, coveredAmount=0;

  for (let i=0; i<rows.length; i++) {
    const r=rows[i];
    const total=parseFloat(r[COL]);
    if (isNaN(total)) {
      processed.push({data:r, color:'', status:'neutral', surplus:0, debtAfter:debt, debtBefore:debt});
      continue;
    }
    const debtBefore=debt;
    let color='green', status='covered', surplus=0;

    if (total < 0) {
      debt += Math.abs(total); totalPayouts += Math.abs(total);
      color='red'; status='uncovered';
    } else if (total > 0) {
      totalDeposits += total;
      if (debt > 0) {
        if (total < debt) {
          coveredAmount += total; debt -= total;
          color='red'; status='uncovered';
        } else {
          coveredAmount += debt; surplus=total-debt; debt=0;
          color='yellow'; status='partial';
        }
      } else { color='green'; status='covered'; }
    }
    processed.push({data:r, color, status, surplus, debtAfter:debt, debtBefore});
  }

  _processed = [...processed];

  document.getElementById('dashboard').style.display='block';

  const covPct = totalPayouts>0 ? Math.min((coveredAmount/totalPayouts)*100,100) : 100;
  const uncovered = totalPayouts - coveredAmount;

  document.getElementById('status-badge-wrap').innerHTML = debt===0
    ? `<div class="status-badge ok">✓ ALL PAYOUTS COVERED — Good to go</div>`
    : `<div class="status-badge bad">✕ UNCOVERED PAYOUTS: ${fmtUSD(debt)} still pending</div>`;

  const pctEl = document.getElementById('pct-display');
  pctEl.textContent = covPct.toFixed(1)+'%';
  pctEl.style.color = debt===0 ? 'var(--green)' : 'var(--yellow)';

  document.getElementById('leg-covered').textContent   = fmtUSD(coveredAmount)+' covered';
  document.getElementById('leg-uncovered').textContent = fmtUSD(uncovered)+' uncovered';
  document.getElementById('leg-total').textContent     = fmtUSD(totalPayouts)+' total payouts';

  document.getElementById('c-payouts').textContent    = fmtUSD(totalPayouts);
  document.getElementById('c-deposits').textContent   = fmtUSD(totalDeposits);
  document.getElementById('c-uncovered').textContent  = fmtUSD(uncovered>0?uncovered:0);
  document.getElementById('c-uncovered-sub').textContent = uncovered>0 ? `${(100-covPct).toFixed(1)}% still open` : 'Fully covered ✓';
  document.getElementById('c-rows').textContent = dataLines.length;
  const netCash = totalDeposits-totalPayouts;
  document.getElementById('c-payouts-sub').textContent  = `${processed.filter(p=>parseFloat(p.data[COL])<0).length} payout rows`;
  document.getElementById('c-deposits-sub').textContent = `Net cash: ${netCash>=0?'+':''}${fmtUSD(netCash)}`;
  document.getElementById('c-rows-sub').textContent     = `${processed.filter(p=>p.color==='red').length} red · ${processed.filter(p=>p.color==='yellow').length} yellow · ${processed.filter(p=>p.color==='green').length} green`;

  _activeCOL = COL;
  _activeFilter = 'all';
  _activeSort   = 'asc';
  // Reset filter buttons
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  document.querySelector('.filter-btn.f-all').classList.add('active');
  document.getElementById('sort-asc').classList.add('active');
  document.getElementById('sort-desc').classList.remove('active');
  document.getElementById('filter-count').textContent = processed.length + ' of ' + processed.length + ' rows';

  buildTimeline(processed);

  // Display oldest → newest
  buildTable(processed, COL);
}

/* ── TIMELINE ──────────────────────────────────────────── */
function buildTimeline(processed) {
  const bar    = document.getElementById('timeline-bar');
  const tt     = document.getElementById('tt');
  const cursor = document.getElementById('bar-cursor');
  bar.innerHTML = '';

  const amounts = processed.map(p => Math.abs(parseFloat(p.data[7])) || 0.01);
  const totalW  = amounts.reduce((a,b)=>a+b, 0);

  processed.forEach((p, i) => {
    const seg = document.createElement('div');
    seg.className = 'bar-segment seg-'+(p.color||'neutral');
    seg.style.width = Math.max((amounts[i]/totalW)*100, 0.25)+'%';
    seg.dataset.idx = i;
    bar.appendChild(seg);
  });

  // Mouse interaction on bar container
  bar.addEventListener('mousemove', e => {
    const rect = bar.getBoundingClientRect();
    const relX = e.clientX - rect.left;
    const pct  = Math.max(0, Math.min(relX / rect.width, 0.9999));
    const idx  = Math.floor(pct * processed.length);
    const p    = processed[idx];
    cursor.style.left = relX+'px';
    if (!p) return;
    tt.innerHTML = buildTooltip(p);
    tt.classList.add('visible');
    positionTooltip(e);
  });

  bar.addEventListener('mouseleave', () => tt.classList.remove('visible'));
  document.addEventListener('mousemove', e => {
    if (tt.classList.contains('visible')) positionTooltip(e);
  });
}

function positionTooltip(e) {
  const tt = document.getElementById('tt');
  const W=window.innerWidth, H=window.innerHeight;
  const tw=tt.offsetWidth||240, th=tt.offsetHeight||150;
  let x=e.clientX+18, y=e.clientY-24;
  if (x+tw>W-10) x=e.clientX-tw-18;
  if (y+th>H-10) y=H-th-10;
  if (y<8) y=8;
  tt.style.left=x+'px'; tt.style.top=y+'px';
}

function buildTooltip(p) {
  const r     = p.data;
  const total = parseFloat(r[7]);
  const date  = r[1]||'—';
  const doc   = r[0]||'—';
  const desc  = (r[3]||'—');
  const descShort = desc.length>26 ? desc.slice(0,26)+'…' : desc;

  const titles = {
    covered:   { icon:'✓', label:'Covered / No Debt',        cls:'green'  },
    uncovered: { icon:'✕', label: total<0 ? 'Payout'
                                          : 'Still in Debt', cls:'red'    },
    partial:   { icon:'◑', label:'Partially Covers Debt',    cls:'yellow' },
    neutral:   { icon:'—', label:'No Amount',                cls:''       },
  };
  const t = titles[p.status] || titles.neutral;

  let html = `
    <div class="tt-date">${date}</div>
    <div class="tt-title"><span class="tt-value ${t.cls}">${t.icon} ${t.label}</span></div>
    <hr class="tt-divider">
    <div class="tt-row"><span class="tt-label">Doc #</span><span class="tt-value">${doc}</span></div>
    <div class="tt-row"><span class="tt-label">Desc</span><span class="tt-value">${descShort}</span></div>`;

  if (!isNaN(total)) {
    html += `<hr class="tt-divider">`;
    html += `<div class="tt-row"><span class="tt-label">Amount</span><span class="tt-value ${total<0?'red':'green'}">${fmtUSD(total)}</span></div>`;

    if (p.debtBefore > 0)
      html += `<div class="tt-row"><span class="tt-label">Debt before</span><span class="tt-value red">${fmtUSD(p.debtBefore)}</span></div>`;

    if (p.debtAfter > 0)
      html += `<div class="tt-row"><span class="tt-label">Debt remaining</span><span class="tt-value red">${fmtUSD(p.debtAfter)}</span></div>`;
    else if (p.debtBefore > 0 && p.debtAfter === 0)
      html += `<div class="tt-row"><span class="tt-label">Debt cleared</span><span class="tt-value green">✓ $0.00</span></div>`;

    if (p.surplus > 0)
      html += `<div class="tt-row"><span class="tt-label">Surplus</span><span class="tt-value green">+${fmtUSD(p.surplus)}</span></div>`;
  }
  return html;
}

/* ── TABLE ─────────────────────────────────────────────── */
function buildTable(processed, COL) {
  const tbody = document.getElementById('tbody');
  tbody.innerHTML = '';
  processed.forEach((p, idx) => {
    const r  = p.data;
    const tr = document.createElement('tr');
    const tdN = document.createElement('td');
    tdN.textContent = idx+1; tr.appendChild(tdN);

    r.slice(0,8).forEach((cell,ci) => {
      const td = document.createElement('td');
      td.textContent = [5,6,7].includes(ci) ? fmt(cell) : cell;
      if (ci===7 && p.color) td.className='cell-'+p.color;
      tr.appendChild(td);
    });

    const tdS = document.createElement('td');
    const total = parseFloat(r[COL]);
    if (p.status==='uncovered')
      tdS.innerHTML = total<0
        ? `<span class="status-cell uncovered">▼ Payout</span>`
        : `<span class="status-cell uncovered">⚠ Still in debt — need ${fmtUSD(p.debtAfter)}</span>`;
    else if (p.status==='partial')
      tdS.innerHTML = `<span class="status-cell partial">◑ Covers +${fmtUSD(p.surplus)} surplus</span>`;
    else if (p.status==='covered')
      tdS.innerHTML = total>0
        ? `<span class="status-cell covered">✓ Deposit — no debt</span>`
        : total<0
          ? `<span class="status-cell covered">✓ Covered</span>`
          : `<span class="status-cell neutral">—</span>`;
    else
      tdS.innerHTML = `<span class="status-cell neutral">—</span>`;

    tr.appendChild(tdS);
    tbody.appendChild(tr);
  });
}

/* ── DOWNLOAD CSV ──────────────────────────────────────── */
/* ── FILTER & SORT STATE ───────────────────────────────── */
let _activeFilter = 'all';
let _activeSort   = 'asc';
let _activeCOL    = 7;

function setFilter(f) {
  _activeFilter = f;
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  const map = { all:'f-all', debt:'f-debt', ok:'f-ok', partial:'f-partial' };
  document.querySelector('.filter-btn.' + map[f]).classList.add('active');
  applyFilterSort();
}

function setSort(dir) {
  _activeSort = dir;
  document.getElementById('sort-asc').classList.toggle('active',  dir === 'asc');
  document.getElementById('sort-desc').classList.toggle('active', dir === 'desc');
  applyFilterSort();
}

function applyFilterSort() {
  if (!_processed.length) return;

  // Filter
  let visible = _processed.filter(p => {
    if (_activeFilter === 'all')     return true;
    if (_activeFilter === 'debt')    return p.status === 'uncovered';
    if (_activeFilter === 'ok')      return p.status === 'covered';
    if (_activeFilter === 'partial') return p.status === 'partial';
    return true;
  });

  // Sort
  if (_activeSort === 'desc') visible = [...visible].reverse();

  // Update count
  document.getElementById('filter-count').textContent =
    visible.length + ' of ' + _processed.length + ' rows';

  // Re-render table
  buildTable(visible, _activeCOL);
}

function downloadCSV() {
  const table = document.getElementById('tbody');
  if (!table || !table.rows.length) return;

  const headers = ['#','Document','DateTime','TranType','Description','EnteredBy','Credited','Debit','Total','Status'];
  const rows = [];
  rows.push(headers.join(','));

  for (const tr of table.rows) {
    const cells = [];
    for (const td of tr.cells) {
      // Get text, strip HTML tags for status chip
      let val = td.innerText.trim().replace(/\n/g,' ');
      // Wrap in quotes if contains comma
      if (val.includes(',') || val.includes('"')) val = '"' + val.replace(/"/g,'""') + '"';
      cells.push(val);
    }
    rows.push(cells.join(','));
  }

  const blob = new Blob([rows.join('\n')], { type: 'text/csv;charset=utf-8;' });
  const url  = URL.createObjectURL(blob);
  const a    = document.createElement('a');
  a.href     = url;
  a.download = 'cover_payouts_' + new Date().toISOString().slice(0,10) + '.csv';
  a.click();
  URL.revokeObjectURL(url);
}
</script>
</body>
</html>

