<%*
// LTC Bases Theme v3.2 — Templater startup script
// Structural table styling only (header, toolbar, groups)
// Cell coloring removed per decision

;(function() {
// ── Cleanup previous injection ──
document.querySelectorAll('[data-ltc-bases]').forEach(el => el.remove());
if (window._ltcBasesObserver) { window._ltcBasesObserver.disconnect(); }

// ── CSS INJECTION — structural only ──
const css = document.createElement('style');
css.setAttribute('data-ltc-bases', 'css');
css.textContent = `

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
`;
document.head.appendChild(css);
})();
%>
