#!/usr/bin/env bash
# generate-brand-gallery.sh — Build a visual review page of all brand fixtures.
# Usage: generate-brand-gallery.sh [--open]
# Output: tests/brand-identity/gallery.html
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="$SCRIPT_DIR/validate-brand.sh"
FIXTURES="$SCRIPT_DIR/fixtures"
OUTPUT="$SCRIPT_DIR/gallery.html"

# ═══════════════════════════════════════════════════════
# Generate Python chart PNGs (if matplotlib available)
# ═══════════════════════════════════════════════════════

generate_charts() {
    if command -v python3 &>/dev/null; then
        echo "Generating matplotlib charts..."
        (cd "$FIXTURES" && python3 good-sample.py 2>/dev/null) && echo "  Generated good-sample.png" || echo "  WARN: good-sample.py failed (matplotlib may not be installed)"
        (cd "$FIXTURES" && python3 bad-sample.py 2>/dev/null) && echo "  Generated bad-sample.png" || echo "  WARN: bad-sample.py failed (matplotlib may not be installed)"
    else
        echo "WARN: python3 not found — skipping chart generation"
    fi
}

# ═══════════════════════════════════════════════════════
# Run validator and capture badge
# ═══════════════════════════════════════════════════════

get_badge() {
    local file="$1"
    if "$VALIDATOR" "$file" &>/dev/null; then
        echo '<span style="background:#69994D;color:#fff;padding:4px 12px;border-radius:4px;font-weight:600;font-size:13px;">PASS</span>'
    else
        echo '<span style="background:#9B1842;color:#fff;padding:4px 12px;border-radius:4px;font-weight:600;font-size:13px;">FAIL</span>'
    fi
}

# ═══════════════════════════════════════════════════════
# Escape HTML content for embedding
# ═══════════════════════════════════════════════════════

escape_html() {
    sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g' "$1"
}

# ═══════════════════════════════════════════════════════
# Build gallery HTML
# ═══════════════════════════════════════════════════════

generate_charts

echo "Building gallery..."

cat > "$OUTPUT" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LTC Brand Identity — Visual Review Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', system-ui, sans-serif; background: #f5f5f5; color: #1D1F2A; }
        .header {
            background: #004851; color: #F2C75C; padding: 32px 40px;
            display: flex; align-items: center; gap: 16px;
        }
        .header h1 { font-size: 28px; font-weight: 700; }
        .header p { color: #B7DDE1; font-size: 14px; margin-top: 4px; }
        .section { padding: 32px 40px; }
        .section h2 {
            font-size: 20px; color: #004851; margin-bottom: 20px;
            padding-bottom: 8px; border-bottom: 2px solid #F2C75C;
        }
        .compare {
            display: grid; grid-template-columns: 1fr 1fr; gap: 24px;
            margin-bottom: 40px;
        }
        .card {
            background: #fff; border-radius: 8px; overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .card-header {
            padding: 12px 16px; font-weight: 600; font-size: 14px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .card-header.good { background: #004851; color: #F2C75C; }
        .card-header.bad { background: #1D1F2A; color: #9B1842; }
        .card-body { padding: 16px; }
        .card-body iframe {
            width: 100%; height: 280px; border: 1px solid #ddd; border-radius: 4px;
        }
        .card-body svg { width: 100%; height: auto; border: 1px solid #ddd; border-radius: 4px; }
        .card-body img { width: 100%; height: auto; border: 1px solid #ddd; border-radius: 4px; }
        .card-body pre {
            background: #1D1F2A; color: #B7DDE1; padding: 16px; border-radius: 4px;
            font-size: 12px; line-height: 1.5; overflow-x: auto; max-height: 300px;
        }
        .footer {
            text-align: center; padding: 24px; color: #787B86; font-size: 12px;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
<div class="header">
    <div>
        <h1>LT Capital Partners — Brand Identity Review</h1>
        <p>Visual gallery for human evaluation of brand compliance across formats</p>
    </div>
</div>
HEADER

# ── HTML Section ──────────────────────────────────────
GOOD_BADGE=$(get_badge "$FIXTURES/good-sample.html")
BAD_BADGE=$(get_badge "$FIXTURES/bad-sample.html")
cat >> "$OUTPUT" << SECTION
<div class="section">
<h2>1. HTML</h2>
<div class="compare">
    <div class="card">
        <div class="card-header good">GOOD — good-sample.html $GOOD_BADGE</div>
        <div class="card-body">
            <iframe src="fixtures/good-sample.html" title="Good HTML"></iframe>
        </div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/good-sample.html")</pre></div>
    </div>
    <div class="card">
        <div class="card-header bad">BAD — bad-sample.html $BAD_BADGE</div>
        <div class="card-body">
            <iframe src="fixtures/bad-sample.html" title="Bad HTML"></iframe>
        </div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/bad-sample.html")</pre></div>
    </div>
</div>
</div>
SECTION

# ── CSS Section ───────────────────────────────────────
GOOD_BADGE=$(get_badge "$FIXTURES/good-sample.css")
BAD_BADGE=$(get_badge "$FIXTURES/bad-sample.css")
cat >> "$OUTPUT" << SECTION
<div class="section">
<h2>2. CSS</h2>
<div class="compare">
    <div class="card">
        <div class="card-header good">GOOD — good-sample.css $GOOD_BADGE</div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/good-sample.css")</pre></div>
    </div>
    <div class="card">
        <div class="card-header bad">BAD — bad-sample.css $BAD_BADGE</div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/bad-sample.css")</pre></div>
    </div>
</div>
</div>
SECTION

# ── SVG Section ───────────────────────────────────────
GOOD_BADGE=$(get_badge "$FIXTURES/good-sample.svg")
BAD_BADGE=$(get_badge "$FIXTURES/bad-sample.svg")
GOOD_SVG=$(cat "$FIXTURES/good-sample.svg")
BAD_SVG=$(cat "$FIXTURES/bad-sample.svg")
cat >> "$OUTPUT" << SECTION
<div class="section">
<h2>3. SVG</h2>
<div class="compare">
    <div class="card">
        <div class="card-header good">GOOD — good-sample.svg $GOOD_BADGE</div>
        <div class="card-body">$GOOD_SVG</div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/good-sample.svg")</pre></div>
    </div>
    <div class="card">
        <div class="card-header bad">BAD — bad-sample.svg $BAD_BADGE</div>
        <div class="card-body">$BAD_SVG</div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/bad-sample.svg")</pre></div>
    </div>
</div>
</div>
SECTION

# ── Python/Matplotlib Section ─────────────────────────
GOOD_BADGE=$(get_badge "$FIXTURES/good-sample.py")
BAD_BADGE=$(get_badge "$FIXTURES/bad-sample.py")
cat >> "$OUTPUT" << SECTION
<div class="section">
<h2>4. Python / Matplotlib</h2>
<div class="compare">
    <div class="card">
        <div class="card-header good">GOOD — good-sample.py $GOOD_BADGE</div>
        <div class="card-body">
            <img src="fixtures/good-sample.png" alt="Good chart" onerror="this.outerHTML='<p style=\\'color:#787B86;padding:16px;\\'>Chart PNG not generated. Run: cd fixtures && python3 good-sample.py</p>'">
        </div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/good-sample.py")</pre></div>
    </div>
    <div class="card">
        <div class="card-header bad">BAD — bad-sample.py $BAD_BADGE</div>
        <div class="card-body">
            <img src="fixtures/bad-sample.png" alt="Bad chart" onerror="this.outerHTML='<p style=\\'color:#787B86;padding:16px;\\'>Chart PNG not generated. Run: cd fixtures && python3 bad-sample.py</p>'">
        </div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/bad-sample.py")</pre></div>
    </div>
</div>
</div>
SECTION

# ── Markdown Section ──────────────────────────────────
GOOD_BADGE=$(get_badge "$FIXTURES/good-sample.md")
BAD_BADGE=$(get_badge "$FIXTURES/bad-sample.md")
cat >> "$OUTPUT" << SECTION
<div class="section">
<h2>5. Markdown (with inline HTML)</h2>
<div class="compare">
    <div class="card">
        <div class="card-header good">GOOD — good-sample.md $GOOD_BADGE</div>
        <div class="card-body">
            <iframe src="fixtures/good-sample.md" title="Good Markdown"></iframe>
        </div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/good-sample.md")</pre></div>
    </div>
    <div class="card">
        <div class="card-header bad">BAD — bad-sample.md $BAD_BADGE</div>
        <div class="card-body">
            <iframe src="fixtures/bad-sample.md" title="Bad Markdown"></iframe>
        </div>
        <div class="card-body"><pre>$(escape_html "$FIXTURES/bad-sample.md")</pre></div>
    </div>
</div>
</div>
SECTION

# ── Footer ────────────────────────────────────────────
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
cat >> "$OUTPUT" << FOOTER
<div class="footer">
    Generated by generate-brand-gallery.sh on $TIMESTAMP<br>
    Source: rules/brand-identity.md | Validator: tests/brand-identity/validate-brand.sh
</div>
</body>
</html>
FOOTER

echo "Gallery written to: $OUTPUT"
echo "Open in browser: open $OUTPUT"

# Auto-open if --open flag passed
if [ "${1:-}" = "--open" ]; then
    open "$OUTPUT" 2>/dev/null || xdg-open "$OUTPUT" 2>/dev/null || echo "Open $OUTPUT in your browser."
fi
