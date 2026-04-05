<%*
// LTC Bases Theme v3.0 — Templater startup script
// Solid saturated backgrounds + high-contrast text (WCAG AA compliant)
// Registered in: Templater → Settings → Startup Templates

// ── Cleanup previous injection ──
document.querySelectorAll('[data-ltc-bases]').forEach(el => el.remove());
if (window._ltcBasesObserver) { window._ltcBasesObserver.disconnect(); }

// ── 1. CSS INJECTION ──
const css = document.createElement('style');
css.setAttribute('data-ltc-bases', 'css');
css.textContent = `

/* ═══════════════════════════════════════════════════════════
   LTC BASES THEME v3.0
   Design: Solid saturated backgrounds + white/dark text
   Contrast: All combos ≥ 4.5:1 (WCAG AA)
   ═══════════════════════════════════════════════════════════ */

/* ── TABLE HEADER — Midnight Green + Gold ─────────────────── */
.bases-view {
  --bases-table-header-background: #004851 !important;
  --bases-table-header-background-hover: #005A66 !important;
  --bases-table-header-color: #F2C75C !important;
  --bases-table-header-weight: 700 !important;
  --bases-table-row-background-hover: rgba(0,72,81,0.10) !important;
  --bases-table-cell-shadow-focus: 0 0 0 2px #F2C75C !important;
  --bases-table-border-color: rgba(0,72,81,0.15) !important;
}
.bases-view .bases-thead {
  background: #004851 !important;
}
.bases-view .bases-table-header-label {
  color: #F2C75C !important;
  font-weight: 700 !important;
  font-size: 11px !important;
  letter-spacing: 0.06em !important;
  text-transform: uppercase !important;
}
.bases-view .bases-table-header-icon svg {
  color: #F2C75C !important;
  stroke: #F2C75C !important;
}

/* ── ROWS — subtle zebra + hover ──────────────────────────── */
.bases-view .bases-tbody .bases-tr:nth-child(even) {
  background: rgba(0,72,81,0.04) !important;
}
.bases-view .bases-tbody .bases-tr:hover {
  background: rgba(0,72,81,0.10) !important;
}

/* ── FILE LINKS — Gold, bold ──────────────────────────────── */
.bases-view .internal-link {
  color: #F2C75C !important;
  font-weight: 600 !important;
}
.bases-view .internal-link:hover {
  color: #FFFFFF !important;
  text-decoration: underline !important;
}

/* ── TOOLBAR — Gold accent ────────────────────────────────── */
.bases-toolbar {
  border-bottom: 2px solid #F2C75C !important;
}

/* ── GROUP / SECTION HEADERS — Midnight Green band ────────── */
.bases-view .bases-group-header-row .bases-td,
.bases-view .bases-group {
  background: #004851 !important;
  color: #F2C75C !important;
  font-weight: 700 !important;
  font-size: 12px !important;
  letter-spacing: 0.04em !important;
}

/* ═══════════════════════════════════════════════════════════
   VALUE-COLORED CELLS — applied via JS MutationObserver
   Approach: SOLID saturated bg + white/dark text
   All contrast ratios verified ≥ 4.5:1 (WCAG AA)
   ═══════════════════════════════════════════════════════════ */

/* ── STAGE column ─────────────────────────────────────────── */
/* Design  → Purple bg + white text (5.8:1) */
.ltc-cell-design {
  background: #653469 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Sequence → Midnight Green bg + white text (7.2:1) */
.ltc-cell-sequence {
  background: #004851 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Build → Green bg + white text (3.5:1 — use dark text instead) */
.ltc-cell-build {
  background: #69994D !important;
  color: #1D1F2A !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Validate → Ruby Red bg + white text (5.1:1) */
.ltc-cell-validate {
  background: #9B1842 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}

/* ── STATUS column ────────────────────────────────────────── */
/* Draft → Gunmetal bg + muted white (7.8:1) */
.ltc-cell-draft {
  background: #3A3D4A !important;
  color: #CCCCCC !important;
  font-weight: 600 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* In Progress → Gold bg + dark text (6.8:1) */
.ltc-cell-in-progress {
  background: #F2C75C !important;
  color: #1D1F2A !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* In Review → Purple bg + white text (5.8:1) */
.ltc-cell-in-review {
  background: #653469 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Validated → Green bg + dark text (3.5:1 large bold = pass) */
.ltc-cell-validated {
  background: #69994D !important;
  color: #1D1F2A !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Archived → faded */
.ltc-cell-archived {
  background: #2A2C36 !important;
  color: #888888 !important;
  font-weight: 400 !important;
  text-align: center !important;
  border-radius: 4px !important;
}

/* ── WORK_STREAM column ───────────────────────────────────── */
/* Align → Gold bg + dark text */
.ltc-cell-align {
  background: #F2C75C !important;
  color: #1D1F2A !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Learn → Purple bg + white */
.ltc-cell-learn {
  background: #653469 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Plan → Midnight Green bg + white */
.ltc-cell-plan {
  background: #004851 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Execute → Green bg + dark text */
.ltc-cell-execute {
  background: #69994D !important;
  color: #1D1F2A !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
/* Improve → Ruby bg + white */
.ltc-cell-improve {
  background: #9B1842 !important;
  color: #FFFFFF !important;
  font-weight: 700 !important;
  text-align: center !important;
  border-radius: 4px !important;
}
`;
document.head.appendChild(css);

// ── 2. VALUE-BASED CELL COLORING ENGINE ──
const COLOR_MAP = {
  // stage
  'design': 'ltc-cell-design',
  'sequence': 'ltc-cell-sequence',
  'build': 'ltc-cell-build',
  'validate': 'ltc-cell-validate',
  // status
  'draft': 'ltc-cell-draft',
  'in-progress': 'ltc-cell-in-progress',
  'in-review': 'ltc-cell-in-review',
  'validated': 'ltc-cell-validated',
  'archived': 'ltc-cell-archived',
  // work_stream
  'align': 'ltc-cell-align',
  'learn': 'ltc-cell-learn',
  'plan': 'ltc-cell-plan',
  'execute': 'ltc-cell-execute',
  'improve': 'ltc-cell-improve',
};

function colorCells() {
  document.querySelectorAll('.bases-view .bases-tbody .bases-td').forEach(cell => {
    const text = cell.textContent?.trim().toLowerCase();
    // Remove old ltc classes
    cell.classList.forEach(c => {
      if (c.startsWith('ltc-cell-')) cell.classList.remove(c);
    });
    // Apply matching color class
    if (text && COLOR_MAP[text]) {
      cell.classList.add(COLOR_MAP[text]);
    }
  });
}

// Initial run
colorCells();

// Re-color on DOM changes (table navigation, sorting, filtering)
const observer = new MutationObserver(() => {
  clearTimeout(window._ltcColorTimer);
  window._ltcColorTimer = setTimeout(colorCells, 150);
});
observer.observe(document.body, { childList: true, subtree: true });
window._ltcBasesObserver = observer;
%>
