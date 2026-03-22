<!-- NOTE: This template is a REFERENCE FORMAT document. It is NOT read programmatically
     by scripts/generate-review-package.py. The script generates output independently.
     If you update this template, also update the corresponding build_*() functions
     in the script to keep them aligned. -->

# Review Package: {project_name}

| Field | Value |
|---|---|
| Spec Version | {spec_version} |
| Plan Version | {plan_version} |
| Exec Version | {exec_version} |
| Pipeline Stage | {pipeline_stage} |
| Total Tasks | {total_tasks} |
| Completed | {completed_tasks} ({pass_rate}%) |
| Rework Cycles | {total_rework_count} |
| Generated | {timestamp} |

## AC Results

| AC ID | Task | Eval Type | Result | Evidence |
|---|---|---|---|---|
{ac_results_rows}

## Deliverable Status

| Deliverable | Name | Tasks | Done | Pass Rate | Status |
|---|---|---|---|---|---|
{deliverable_rows}

## Rework History

{rework_log_entries}

## Risk Flags

{risk_flags}

---

**Human Director Decision:**
- [ ] Approved — trigger completion cascade
- [ ] Code changes needed — specify tasks to rework
- [ ] Plan is wrong — re-enter Stage 3
- [ ] Spec is wrong — re-enter Stage 1
