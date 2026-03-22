# VANA-SPEC: Eval Runner Test Fixture

<!-- Minimal spec for testing run-deterministic-evals.py.
     Contains §7 AC-TEST-MAP with 3 ACs:
       EVAL-AC1 — Deterministic, passing grader (true)
       EVAL-AC2 — Deterministic, failing grader (false)
       EVAL-AC3 — Manual (should be skipped)
       EVAL-AC4 — AI-Graded (should be deferred)
-->

---

## §7 AC-TEST-MAP (G1: Eval Specification)

| A.C. ID | VANA Word | VANA Source | Eval Type | Dataset Description | Grader Description | Threshold |
|---------|-----------|-------------|-----------|--------------------|--------------------|-----------|
| EVAL-AC1 | Exists | §2 | Deterministic | Test: always passes | true | exit 0 |
| EVAL-AC2 | Valid | §2 | Deterministic | Test: always fails | false | exit 0 |
| EVAL-AC3 | Quality | §3.1 | Manual | Human review of output quality | Human Director rubric | 80% |
| EVAL-AC4 | Coherent | §5.1 | AI-Graded | LLM coherence check | GPT-4o judge | 0.9 |

---
