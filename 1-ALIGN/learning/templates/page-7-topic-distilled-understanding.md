# Template: Page 7 — Topic Distilled Understanding

_Page type: Topic Distilled Understanding (Phase C. Organise Information). Use for any (chapter, topic, page=7)._

**Canonical reference:** Full subject-level structure and column definitions are in `templates/D-distilled-understanding-full.md`. Spec and page→block mapping: `docs/ai/implementation/distilled-understanding-template-spec.md`.

Page 7 = **one topic's slice** of the D. Distilled Understanding table: same column set (OVERVIEW | SUCCESS 7 | FAILURE 6 | LEARNER'S NOTES 3), rows = that topic's sub-topics (e.g. UBS → 1.0–1.6). All content from pages 0–6 for that topic maps into these rows.

---

## Naming (Learning Book)

All learning-book items use the `BOOK-NN` prefix convention (e.g. `BOOK-00`, `BOOK-01`).

- **Prefix:** `BOOK-{NN} — ` (space-em-dash-space separator)
- **This page type** → file name: `BOOK-{NN} — T{topic}.P7 Topic Distilled Understanding.md` (e.g. `BOOK-00 — T1.P7 Topic Distilled Understanding.md`)
- **Full rule:** `engine/rules/learning-book-naming.md`

---

## Role-Aware Distillation (D23–D29)

When distilling a Topic into Page 7, preserve the role-awareness from P0–P5:

- **Sub-topic X.0 (Overview):** Include the Workstream Contract summary (INPUT → EO → OUTPUT) and RACI from P0.
- **Sub-topic X.1 (UBS):** Distill both UBS(R) and UBS(A) perspectives from P1.
- **Sub-topic X.2 (UDS):** Distill both UDS(R) and UDS(A) perspectives from P2.
- **Sub-topic X.3 (EP):** Preserve pillar + role tags: P1(S)(R), P2(E)(A), etc.
- **Sub-topic X.4 (EOE/EOT):** Preserve role tags: L1.1(R), L2.1(A), etc.
- **Sub-topic X.5 (EOP):** Include EOP Decision Matrix summary (DERISK/OPTIMIZE targets) and role-tagged steps.

---

## Target table format

_Write condensed content per sub-topic (X.0–X.6 as applicable). Columns must match canonical: 1 OVERVIEW + 7 SUCCESS + 6 FAILURE + 3 LEARNER'S NOTES._

<div style="overflow-x: auto;">

<table>
<thead>
<tr>
<th colspan="18"><strong>TOPIC DISTILLED UNDERSTANDING (Page 7)</strong></th>
</tr>
<tr>
<th rowspan="2"><strong></strong><br/><strong></strong></th>
<th colspan="2"><strong>OVERVIEW</strong></th>
<th colspan="7"><strong>SUCCESS</strong></th>
<th colspan="6"><strong>FAILURE</strong></th>
<th colspan="3"><strong>LEARNER'S NOTES</strong></th>
</tr>
<tr>
<th>What is it for? Why is it important? (Relevance)</th>
<th>What is it? (Introduction)</th>
<th>How does it work successfully? (Effective Operating Procedure)</th>
<th>What ultimately cause it to work successfully? (Ultimate Driving System)</th>
<th>How do the Ultimate Driving System cause it to work successfully? (Success Mechanism)</th>
<th>What principles are the Ultimate Driving System based on? (Effective Principle System)</th>
<th>What tool(s) do the ultimate drivers require to work? (Ultimate Effective System)</th>
<th>What environmental conditions do the ultimate drivers require to work? (Ultimate Effective System)</th>
<th>How can it fail? (Failure Actions)</th>
<th>What ultimately cause it to fail? (Ultimate Blocking System)</th>
<th>How do the ultimate blockers cause it to fail? (Failure Mechanism)</th>
<th>What principles are the ultimate blockers based on? (Risky Principles)</th>
<th>What tool(s) do the ultimate blockers require to work? (Risky Tools)</th>
<th>What environmental conditions do the ultimate blockers require to work? (Risky Environments)</th>
<th>What to do if it fails? (What else?)</th>
<th>Other Questions (Others)</th>
<th>Next Steps to Take (Now What? Now How?)</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>SUB-TOPIC X.0–X.6 (e.g. 1.0–1.6 for UBS)</strong></td>
<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
</tr>
</tbody>
</table>

</div>
