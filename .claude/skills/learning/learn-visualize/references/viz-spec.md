# Visualization Spec — learn-visualize

Detail reference for data extraction and HTML generation. Loaded on demand from SKILL.md.

---

## §1 — Node and Edge Extraction Rules

### P-page table format

P-pages use a 17-column format. Relevant columns:

| Col | Name | Content |
|-----|------|---------|
| 1 | CAG prefix | Node ID (e.g. `UBS.R.1`, `EP.3`, `EOE.2`) |
| 2 | Row subject | Node label text |
| 12 | Causes | Upstream nodes that cause this row (comma-separated CAG IDs) |
| 13 | Effects | Downstream nodes this row causes (comma-separated CAG IDs) |
| 15 | Pillar | S / E / Sc |
| 16 | Page source | P0-P5 |

### Node extraction

For each table row in each P-page:
```
node = {
  id:     col[1],          // CAG prefix — unique identifier
  label:  col[2],          // row subject
  page:   "P{N}",          // source page
  pillar: col[15],         // S | E | Sc
  topic:  "{topic-name}",  // parent topic directory name
  detail: {full row as key-value object for side panel}
}
```

Skip rows where col[1] is empty or does not match CAG prefix pattern (`[A-Z]+\.[A-Z0-9]+\.[0-9]+` or `[A-Z]+\.[0-9]+`).

### Edge extraction

From col[12] (Causes — upstream → this node):
```
for each CAG ID in col[12]:
  edge = { from: CAG_ID, to: this_node_id, label: "causes" }
```

From col[13] (Effects — this node → downstream):
```
for each CAG ID in col[13]:
  edge = { from: this_node_id, to: CAG_ID, label: "leads to" }
```

Deduplicate edges (same from+to pair = one edge).

---

## §2 — React+Vite CDN HTML Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>LTC System Map — {system_name}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <!-- React via CDN -->
  <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
  <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
  <!-- vis-network for graph (primary) -->
  <script src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>
  <!-- html2canvas for PNG export -->
  <script src="https://unpkg.com/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', sans-serif;
      background: #004851;
      color: #FFFFFF;
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
    header {
      background: #1D1F2A;
      padding: 12px 24px;
      display: flex;
      align-items: center;
      gap: 16px;
      border-bottom: 2px solid #F2C75C;
    }
    header h1 { font-size: 16px; font-weight: 600; color: #F2C75C; }
    header span { font-size: 12px; color: #FFFFFF; opacity: 0.7; }
    .toolbar {
      background: #1D1F2A;
      padding: 8px 24px;
      display: flex;
      gap: 8px;
      align-items: center;
    }
    .filter-btn {
      padding: 4px 12px;
      border-radius: 4px;
      border: 1px solid #F2C75C;
      background: transparent;
      color: #F2C75C;
      font-family: 'Inter', sans-serif;
      font-size: 12px;
      cursor: pointer;
    }
    .filter-btn.active { background: #F2C75C; color: #1D1F2A; font-weight: 600; }
    .export-btn {
      margin-left: auto;
      padding: 4px 16px;
      border-radius: 4px;
      border: none;
      background: #F2C75C;
      color: #1D1F2A;
      font-family: 'Inter', sans-serif;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
    }
    .main {
      display: flex;
      flex: 1;
      overflow: hidden;
    }
    #graph-container {
      flex: 1;
      background: #004851;
    }
    .side-panel {
      width: 320px;
      background: #1D1F2A;
      border-left: 1px solid #F2C75C;
      padding: 20px;
      overflow-y: auto;
      display: none;
    }
    .side-panel.open { display: block; }
    .side-panel h2 { font-size: 14px; color: #F2C75C; margin-bottom: 12px; }
    .side-panel .field { margin-bottom: 8px; font-size: 12px; }
    .side-panel .field label { color: #F2C75C; font-weight: 600; display: block; }
    .side-panel .field span { color: #FFFFFF; opacity: 0.85; }
    .close-btn {
      float: right;
      background: none;
      border: none;
      color: #F2C75C;
      cursor: pointer;
      font-size: 18px;
    }
  </style>
</head>
<body>
  <header>
    <h1>LT Capital Partners — System Map</h1>
    <span>{system_name}</span>
  </header>
  <div class="toolbar">
    <button class="filter-btn active" data-pillar="all">All</button>
    <button class="filter-btn" data-pillar="S">S — Sustainability</button>
    <button class="filter-btn" data-pillar="E">E — Efficiency</button>
    <button class="filter-btn" data-pillar="Sc">Sc — Scalability</button>
    <button class="export-btn" id="export-btn">Export PNG</button>
  </div>
  <div class="main">
    <div id="graph-container"></div>
    <div class="side-panel" id="side-panel">
      <button class="close-btn" id="close-panel">×</button>
      <h2 id="panel-title"></h2>
      <div id="panel-content"></div>
    </div>
  </div>

  <script>
    // ── GRAPH DATA (injected by learn-visualize skill) ──────────────────────
    const GRAPH_DATA = __GRAPH_DATA_JSON__;

    // ── PILLAR COLORS ────────────────────────────────────────────────────────
    const PILLAR_COLORS = {
      S:   { background: '#004851', border: '#F2C75C', highlight: { background: '#006671', border: '#F2C75C' } },
      E:   { background: '#1D1F2A', border: '#F2C75C', highlight: { background: '#2d3040', border: '#F2C75C' } },
      Sc:  { background: '#653469', border: '#F2C75C', highlight: { background: '#7a3f7e', border: '#F2C75C' } },
      default: { background: '#9B1842', border: '#F2C75C', highlight: { background: '#b51e4e', border: '#F2C75C' } }
    };

    // ── BUILD VIS DATASETS ───────────────────────────────────────────────────
    let activeFilter = 'all';

    function buildDatasets(filter) {
      const filteredNodes = filter === 'all'
        ? GRAPH_DATA.nodes
        : GRAPH_DATA.nodes.filter(n => n.pillar === filter);
      const nodeIds = new Set(filteredNodes.map(n => n.id));
      const filteredEdges = GRAPH_DATA.edges.filter(e => nodeIds.has(e.from) && nodeIds.has(e.to));

      return {
        nodes: new vis.DataSet(filteredNodes.map(n => ({
          id: n.id,
          label: n.id + '\n' + n.label.slice(0, 30),
          title: n.pillar + ' · ' + n.page,
          color: PILLAR_COLORS[n.pillar] || PILLAR_COLORS.default,
          font: { color: '#FFFFFF', face: 'Inter', size: 11 },
          shape: 'box',
          _data: n
        }))),
        edges: new vis.DataSet(filteredEdges.map(e => ({
          from: e.from, to: e.to,
          label: e.label,
          arrows: 'to',
          color: { color: '#F2C75C', opacity: 0.6 },
          font: { color: '#F2C75C', size: 9 }
        })))
      };
    }

    // ── INIT NETWORK ─────────────────────────────────────────────────────────
    const container = document.getElementById('graph-container');
    let { nodes, edges } = buildDatasets('all');
    const network = new vis.Network(container, { nodes, edges }, {
      layout: { improvedLayout: true },
      physics: { stabilization: { iterations: 150 } },
      interaction: { hover: true, tooltipDelay: 100 },
      edges: { smooth: { type: 'cubicBezier' } }
    });

    // ── CLICK: SIDE PANEL ────────────────────────────────────────────────────
    const panel = document.getElementById('side-panel');
    const panelTitle = document.getElementById('panel-title');
    const panelContent = document.getElementById('panel-content');

    network.on('click', params => {
      if (!params.nodes.length) { panel.classList.remove('open'); return; }
      const nodeId = params.nodes[0];
      const node = nodes.get(nodeId);
      if (!node) return;
      const d = node._data;
      panelTitle.textContent = d.id + ' — ' + d.label;
      panelContent.innerHTML = Object.entries(d.detail || {})
        .map(([k, v]) => `<div class="field"><label>${k}</label><span>${v}</span></div>`)
        .join('');
      panel.classList.add('open');
    });

    document.getElementById('close-panel').onclick = () => panel.classList.remove('open');

    // ── FILTERS ──────────────────────────────────────────────────────────────
    document.querySelectorAll('.filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        activeFilter = btn.dataset.pillar;
        const ds = buildDatasets(activeFilter);
        nodes.clear(); nodes.add(ds.nodes.get());
        edges.clear(); edges.add(ds.edges.get());
      });
    });

    // ── EXPORT PNG ───────────────────────────────────────────────────────────
    document.getElementById('export-btn').onclick = () => {
      if (typeof html2canvas === 'undefined') {
        alert('PNG export unavailable — html2canvas not loaded.');
        return;
      }
      html2canvas(document.body).then(canvas => {
        const a = document.createElement('a');
        a.download = 'ltc-system-map-{slug}.png';
        a.href = canvas.toDataURL('image/png');
        a.click();
      });
    };
  </script>
</body>
</html>
```

### Injecting graph data

Replace `__GRAPH_DATA_JSON__` with the serialized JSON:
```js
const GRAPH_DATA = {"nodes":[...],"edges":[...]};
```

Replace `{system_name}`, `{slug}` with actual values from the input argument.

## Links

- [[SKILL]]
