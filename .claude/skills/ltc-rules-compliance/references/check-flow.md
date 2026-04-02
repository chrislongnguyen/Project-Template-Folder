# Compliance Check Flow

Run this sequence for each compliance request.

1. **Define target**
   - What artifact(s) are being checked?
   - What delivery moment? (draft, pre-merge, pre-release)

2. **Select in-scope rule families**
   - Use `references/scope-matrix.md`
   - Record `PASS/WARN/FAIL/BLOCKED/NOT APPLICABLE` placeholders

3. **Gather evidence**
   - Read canonical rule files for each in-scope family
   - Run deterministic validators where available (e.g., `skill-validator.sh`)
   - Route deep checks through specialist skills (brand, naming)

4. **Evaluate**
   - `PASS` = no violations and no unresolved assumptions
   - `WARN` = acceptable for now, but has corrective actions
   - `FAIL` = violation blocks completion
   - `BLOCKED` = required source/check unavailable

5. **Gate and publish**
   - Ensure every `FAIL` has at least one action owner + next step
   - Ensure every `WARN` has explicit follow-up condition
   - Publish with `templates/compliance-report.md`

## Links

- [[SEQUENCE]]
- [[compliance-report]]
- [[scope-matrix]]
