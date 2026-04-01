---
version: "1.0"
status: Draft
last_updated: 2026-04-01
source: "Vinh Nguyen (CIO), branch Vinh-ALPEI-AI-Operating-System"
---

# ALPEI Framework by Sub-Systems

> **Structure:** 4 Sub-Systems × 5 Work Streams × 4 Stages = 80 cells
>
> **Sub-System Flow:** Problem Diagnosis → Data Pipeline → Data Analysis → Insights & Decision Making
>
> **Work Stream Flow:** Align → Learn → Plan → Execute → Improve → Align (continuous)
>
> **Stage Flow:** Design → Sequence → Build → Validate
>
> **Version Progression:** Logic Scaffold → Concept (Sustainability) → Prototype (+ Efficiency) → MVE (full Efficiency) → Leadership (+ Scalability)

---

## 1. Problem Diagnosis (PD)

Diagnose user problems by identifying blockers (UBS) and drivers (UDS). Produce effective principles and design guidelines that govern the entire UES.

### PD — Align

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define boundaries of the diagnosis effort — which problems, stakeholders, and constraints to investigate | Business mandate or strategic directive; user problem statement; available resources; existing constraints; lessons from prior iterations | Validated scope (in/out); stakeholder map (RACI draft); constraint register; initial risk register; Go/No-go |
| DESIGN | Design desired diagnostic outcome using VANA; draft master plan with version milestones and resource allocation | Validated scope; stakeholder map; VANA criteria per version; Three Pillars; UBS/UDS from prior iterations | Desired outcome definition (VANA per version); master plan draft; version roadmap; risk mitigation plan; sign-off checklist |
| BUILD | Finalize and lock the master plan; obtain stakeholder sign-off; communicate objectives to all RACI participants | Master plan draft; VANA criteria; stakeholder feedback; resource confirmation | Approved master plan (locked); signed-off outcomes per version; communicated objectives; baseline KPIs; alignment brief for all work streams |
| VALIDATE | Verify alignment is robust — check for gaps, misalignment, or overlooked risks; ensure genuine stakeholder agreement | Approved master plan; signed-off outcomes; stakeholder spot-checks; cross-reference with Learn findings | Alignment audit report; corrective actions (back to Design/Sequence if needed); validated alignment package → Learn; lessons learned |

### PD — Learn

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define what to learn about the problem domain — root causes, failure mechanisms, success drivers | Validated alignment package; current version target; known unknowns; improvement requests from Improve; existing UBS/UDS docs | Learning scope document; prioritized research questions; data collection plan; learning risk register |
| DESIGN | Design research approach for UBS/UDS diagnosis; define analytical methods; draft effective principles for entire UES | Learning scope; prioritized questions; Effective System Design framework; domain expertise; benchmark data | UBS diagnosis design; UDS diagnosis design; draft effective principles; draft solution architecture; validated methodology |
| BUILD | Execute UBS/UDS analysis; validate findings; produce effective principles and solution design | Approved methodology; raw data; stakeholder interviews; expert consultations; existing system docs | Completed UBS analysis; completed UDS analysis; finalized effective principles; solution design document; validated problem diagnosis |
| VALIDATE | Verify diagnosis is rigorous, evidence-based, complete, and actionable; check principles are logically derived | UBS/UDS analyses; effective principles; solution design; alignment package; peer review | Learning audit report; corrective actions; validated learning package → Plan; updated risk register; lessons learned |

### PD — Plan

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define iteration scope for diagnosis deliverables — which artifacts to produce; avoid over-commitment | Validated learning package; master plan; resource availability; technical feasibility; priority backlog from Improve | Iteration scope; feature priority ranking (derisk first); capacity assessment; planning risk register |
| DESIGN | Break deliverables into tasks; assign RACI; estimate effort; define VANA acceptance criteria; sequence derisk-first | Iteration scope; solution design; RACI assignments; tool/environment specs; VANA criteria | Task breakdown; RACI per task; effort estimates and timeline; VANA acceptance criteria; execution sequence; dependency map |
| BUILD | Finalize execution plan; lock assignments; set up ClickUp tracking; distribute to Execute | Task breakdown; confirmed estimates; tool setup requirements; team acknowledgment | Approved execution plan (locked); ClickUp project setup; sprint backlog → Execute; communication plan; escalation protocols |
| VALIDATE | Verify plan is realistic, complete, and risk-managed; all tasks have ownership and acceptance criteria | Approved plan; ClickUp setup; master plan constraints; historical velocity data | Planning audit report; corrective actions; validated plan → Execute; confidence score; lessons learned |

### PD — Execute

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Confirm sprint scope; verify prerequisites (data, tools, environment); catch blockers before work begins | Validated plan; sprint backlog; pre-requisite checklist; team readiness; risk register | Confirmed sprint scope; blocker log with mitigations; team kick-off brief; environment readiness confirmation |
| DESIGN | Design technical implementation for each deliverable (UBS/UDS templates, diagnostic frameworks, principle docs) | Confirmed scope; solution design; effective principles; technical standards; existing components | Technical design per deliverable; design review sign-off; test plan and acceptance cases; integration specs |
| BUILD | Build and deliver: UBS/UDS analysis documents, effective principles, diagnostic frameworks, design guidelines for downstream sub-systems | Approved designs; test plans; dev environment and tools; data and expert access; documentation standards | Delivered UBS/UDS documents; effective principles document; design guidelines for downstream; test results (passed); delivery confirmation |
| VALIDATE | Verify artifacts meet acceptance criteria — UBS/UDS is evidence-based, principles are actionable, guidelines are usable | Delivered artifacts; test results; VANA criteria; stakeholder acceptance feedback; quality benchmarks | Execution audit report; defect log with severity; corrective actions; validated deliverables → Improve; lessons learned |

### PD — Improve

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define feedback to collect — focus on accuracy of diagnosis and usability of outputs | Validated deliverables; stakeholder contacts; KPIs and baselines; known issues from audit; prior improvement backlog | Feedback collection plan; channels activated; improvement scope; feedback risk register |
| DESIGN | Design feedback analysis; establish criteria for validated feedback vs. noise; prioritize by Three Pillars | Feedback plan; raw feedback; Three Pillars criteria; master plan and roadmap; UBS/UDS analysis | Feedback analysis methodology; validation criteria; prioritization framework; analysis RACI |
| BUILD | Process and validate feedback; categorize improvement requests; validate against evidence and Three Pillars | Raw feedback; analysis methodology; validation criteria; system performance data; expert review | Categorized feedback register; validated improvement requests (prioritized); rejected feedback log; updated backlog; recommendations → Align |
| VALIDATE | Verify improvement process was rigorous and fair — no cherry-picking; priorities serve users and Three Pillars | Categorized register; validated requests; rejected log; recommendations; stakeholder review | Improvement audit report; corrective actions; final validated package → Align (loop closes); updated master plan inputs; lessons learned |

> **PD outputs → DP:** Effective principles, UBS/UDS analysis, and design guidelines become the foundational inputs for the Data Pipeline sub-system.

---

## 2. Data Pipeline (DP)

Build and operate the data pipeline: acquire, clean, standardize, transform, and validate data to produce analysis-ready datasets.

### DP — Align

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define boundaries of the pipeline effort — which data sources, types, and processing requirements are in scope | Effective principles from PD; design guidelines from PD; data source requirements; available infrastructure; compliance/access/latency constraints; lessons from prior iterations | Validated scope (data sources in/out); stakeholder map (RACI); constraint register; pipeline risk register; Go/No-go |
| DESIGN | Design desired pipeline outcomes using VANA; draft master plan with data quality targets and version milestones | Validated scope; data quality requirements from DA team; VANA criteria per version; Three Pillars; infrastructure capabilities | Desired pipeline outcomes (VANA per version); master plan draft; data quality SLAs per version; version roadmap; risk mitigation plan |
| BUILD | Finalize and lock the pipeline master plan; obtain stakeholder sign-off; communicate objectives | Master plan draft; VANA criteria; stakeholder feedback; resource and infrastructure confirmation | Approved master plan (locked); signed-off data quality SLAs; communicated objectives; baseline pipeline KPIs; alignment brief |
| VALIDATE | Verify pipeline alignment — data quality SLAs are realistic; alignment with PD principles and DA requirements | Approved master plan; data quality SLAs; cross-reference with PD principles; DA team requirements validation | Alignment audit report; corrective actions; validated alignment package → Learn; lessons learned |

### DP — Learn

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define what to learn about data acquisition, cleaning, standardization, and processing | Validated alignment package; current version target; known data quality issues; feedback from Improve; existing pipeline docs | Learning scope; research questions on data blockers/drivers; data source audit plan; learning risk register |
| DESIGN | Design research approach for pipeline UBS/UDS; evaluate data sources, cleaning methods, transformation logic | Learning scope; prioritized questions; UES effective principles; data engineering best practices; source system docs | Pipeline UBS diagnosis design; pipeline UDS diagnosis design; draft pipeline principles; pipeline architecture draft; validated methodology |
| BUILD | Execute research — profile data sources, test cleaning/transformation approaches, produce pipeline principles | Approved methodology; raw data samples; source system access; data engineering expertise; tool evaluations | Pipeline UBS analysis (quality gaps, unreliable sources, schema mismatches); pipeline UDS analysis (automation potential, standard formats); finalized pipeline principles; architecture document; source profiles |
| VALIDATE | Verify source profiles are accurate, pipeline principles are consistent with UES principles, architecture is feasible | Pipeline UBS/UDS; pipeline principles; architecture document; UES principles (consistency check); data engineering peer review | Learning audit report; corrective actions; validated learning package → Plan; updated risk register; lessons learned |

### DP — Plan

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define iteration scope — which data sources, cleaning rules, and transformations to implement | Validated learning package; pipeline master plan; resource availability; technical feasibility; priority backlog from Improve | Iteration scope; feature priority ranking; capacity assessment; planning risk register |
| DESIGN | Break pipeline features into tasks (connectors, cleaning, transformations, validations, scheduling); assign RACI; sequence data safety before speed | Iteration scope; pipeline architecture; RACI assignments; tool specs (ETL, databases); VANA criteria | Task breakdown; RACI per task; effort estimates and timeline; VANA acceptance criteria; execution sequence; dependency map |
| BUILD | Finalize execution plan; lock assignments; set up ClickUp tracking; distribute to Execute | Task breakdown; confirmed estimates; tool setup; team acknowledgment | Approved execution plan (locked); ClickUp setup; sprint backlog → Execute; communication plan; escalation protocols |
| VALIDATE | Verify plan is realistic — data quality SLAs are achievable; derisk-first sequencing confirmed | Approved plan; ClickUp setup; master plan constraints; historical velocity data | Planning audit report; corrective actions; validated plan → Execute; confidence score; lessons learned |

### DP — Execute

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Confirm sprint scope; verify source access, infrastructure readiness, and tool availability | Validated plan; sprint backlog; infrastructure pre-requisites; team readiness; risk register | Confirmed sprint scope; blocker log; team kick-off brief; infrastructure readiness confirmation |
| DESIGN | Design technical implementation for each component (connectors, cleaning rules, transformations, validation checks, scheduling) | Confirmed scope; pipeline architecture; pipeline principles; technical standards; existing components | Technical design per component; design review sign-off; test plan (data quality + integration tests); integration specs with DA |
| BUILD | Build and deploy: source connectors, cleaning rules, standardization logic, transformations, validation gates, scheduling, monitoring | Approved designs; test plans; infrastructure and tools; source system access; SOP templates | Deployed pipeline components; processed, clean, standardized, analysis-ready data; data quality reports; pipeline docs and SOPs; data lineage and audit trail |
| VALIDATE | Verify data meets quality SLAs — completeness, accuracy, consistency, timeliness; confirm usability by DA | Deployed pipeline and output data; quality reports; VANA criteria; DA team acceptance feedback; performance benchmarks | Execution audit report; defect log with severity; corrective actions; validated deliverables → Improve; lessons learned |

### DP — Improve

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define feedback to collect — focus on data quality issues, latency, missing data, pipeline reliability | Validated deliverables; DA team feedback; KPIs and baselines; known issues from audit; prior improvement backlog | Feedback collection plan; channels activated; improvement scope; feedback risk register |
| DESIGN | Design feedback analysis; distinguish real data quality issues from edge cases; prioritize: safety → throughput → scalability | Feedback plan; raw feedback (quality reports, latency logs, tickets); Three Pillars criteria; pipeline UBS/UDS | Feedback analysis methodology; validation criteria; prioritization framework; analysis RACI |
| BUILD | Process and validate pipeline feedback; categorize by source, quality dimension, and severity | Raw feedback; analysis methodology; validation criteria; pipeline performance data; expert review | Categorized feedback register; validated improvement requests; rejected feedback log; updated backlog; recommendations → Align |
| VALIDATE | Verify improvement process was rigorous — no cherry-picking; priorities serve data quality and Three Pillars | Categorized register; validated requests; rejected log; recommendations; stakeholder review | Improvement audit report; corrective actions; final validated package → Align (loop closes); updated master plan inputs; lessons learned |

> **DP outputs → DA:** Processed, clean, standardized, analysis-ready data becomes the primary input for the Data Analysis sub-system.

---

## 3. Data Analysis (DA)

Analyze processed data to produce validated insights — trends, patterns, correlations, anomalies, and forecasts — with confidence levels and stated limitations.

### DA — Align

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define boundaries of the analysis effort — which analytical questions, methods, and outputs are in scope | Effective principles from PD; pipeline principles and quality SLAs from DP; analysis-ready data spec; stakeholder analytical questions; available resources and tools; lessons from prior iterations | Validated scope (questions in/out); stakeholder map (RACI); analytical constraint register; analysis risk register; Go/No-go |
| DESIGN | Design desired analysis outcomes using VANA; draft master plan — which insights at which version, what methods | Validated scope; insight requirements from IDM team; VANA criteria per version; Three Pillars; available tools and models | Desired analysis outcomes (VANA per version); master plan draft; insight quality SLAs per version; version roadmap; risk mitigation plan |
| BUILD | Finalize and lock the analysis master plan; obtain stakeholder sign-off; communicate objectives | Master plan draft; VANA criteria; stakeholder feedback; resource and tool confirmation | Approved master plan (locked); signed-off insight quality SLAs; communicated objectives; baseline analysis KPIs; alignment brief |
| VALIDATE | Verify analysis alignment — insight SLAs are realistic; alignment with upstream principles and IDM requirements | Approved master plan; insight SLAs; cross-reference with UES principles; IDM team requirements validation | Alignment audit report; corrective actions; validated alignment package → Learn; lessons learned |

### DA — Learn

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define what to learn — which analytical methods are appropriate, what statistical pitfalls exist, what the data can and cannot tell us | Validated alignment package; current version target; data quality profiles from DP; feedback from Improve; existing analytical models | Learning scope; research questions on analytical blockers/drivers; method evaluation plan; learning risk register |
| DESIGN | Design research approach for analysis UBS/UDS; evaluate analytical frameworks, statistical methods, modeling approaches | Learning scope; prioritized questions; UES effective principles; statistical and domain best practices; sample data from DP | Analysis UBS diagnosis design; analysis UDS diagnosis design; draft analysis principles; analytical framework selection rationale; validated methodology |
| BUILD | Execute research — test methods on processed data, validate statistical assumptions, produce analysis principles | Approved methodology; processed data from DP; analytical tools; statistical/domain expertise; benchmark analyses | Analysis UBS (misleading correlations, bias, overfitting, data limitations); analysis UDS (robust methods, validation techniques, domain knowledge); finalized analysis principles; analytical methodology; validated assumptions |
| VALIDATE | Verify statistical rigor; confirm principles prevent misleading conclusions; validate methodology is reproducible | Analysis UBS/UDS; analysis principles; methodology document; UES principles (consistency check); statistician/domain peer review | Learning audit report; corrective actions; validated learning package → Plan; updated risk register; lessons learned |

### DA — Plan

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define iteration scope — which analyses, models, and insight outputs to produce | Validated learning package; analysis master plan; resource availability; data readiness from DP; priority backlog from Improve | Iteration scope; priority ranking; capacity assessment; planning risk register |
| DESIGN | Break analysis features into tasks (exploration, modeling, validation, insight generation); assign RACI; sequence accuracy before speed | Iteration scope; analytical methodology; RACI assignments; tool/data specs; VANA criteria | Task breakdown; RACI per task; effort estimates and timeline; VANA acceptance criteria; execution sequence; dependency map |
| BUILD | Finalize execution plan; lock assignments; set up tracking; distribute to Execute | Task breakdown; confirmed estimates; tool setup; team acknowledgment | Approved execution plan (locked); ClickUp setup; sprint backlog → Execute; communication plan; escalation protocols |
| VALIDATE | Verify plan is realistic — accuracy validation precedes performance optimization; data dependencies from DP are met | Approved plan; ClickUp setup; master plan constraints; DP delivery schedule | Planning audit report; corrective actions; validated plan → Execute; confidence score; lessons learned |

### DA — Execute

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Confirm sprint scope; verify processed data is available from DP, tools are ready, models can be trained/tested | Validated plan; sprint backlog; data availability from DP; team and tool readiness; risk register | Confirmed sprint scope; blocker log; team kick-off brief; data and tool readiness confirmation |
| DESIGN | Design technical implementation for each analysis component (statistical models, business logic, validation checks, output formats) | Confirmed scope; analytical methodology; analysis principles; technical standards; existing components | Technical design per component; design review sign-off; test plan (accuracy, edge cases); output format specs for IDM |
| BUILD | Build and run analyses; execute models, compute insights, validate results; derisk-first: validate accuracy before throughput | Approved designs; test plans; processed data from DP; analytical tools and compute; documentation standards | Analyzed insights (trends, patterns, correlations, anomalies, forecasts); validated conclusions with confidence levels; methodology docs; flagged risks, uncertainties, limitations |
| VALIDATE | Verify analyses are statistically sound, reproducible, and meet insight quality SLAs; conclusions supported by evidence | Analyzed insights; test results and accuracy metrics; VANA criteria; IDM team acceptance feedback; statistical peer review | Execution audit report; defect log; corrective actions; validated deliverables → Improve; lessons learned |

### DA — Improve

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define feedback to collect — focus on insight accuracy, analytical gaps, misleading conclusions, IDM usability | Validated deliverables; IDM team feedback; KPIs and baselines; known issues from audit; prior improvement backlog | Feedback collection plan; channels activated; improvement scope; feedback risk register |
| DESIGN | Design feedback analysis; distinguish real analytical issues from misinterpretation; prioritize: accuracy → efficiency → scalability | Feedback plan; raw feedback; Three Pillars criteria; master plan and roadmap; analysis UBS/UDS | Feedback analysis methodology; validation criteria; prioritization framework; analysis RACI |
| BUILD | Process and validate feedback; categorize by analytical dimension, severity, and impact | Raw feedback; analysis methodology; validation criteria; performance data; expert review | Categorized feedback register; validated improvement requests; rejected feedback log; updated backlog; recommendations → Align |
| VALIDATE | Verify improvement process was fair and rigorous; priorities serve analytical accuracy and Three Pillars | Categorized register; validated requests; rejected log; recommendations; stakeholder review | Improvement audit report; corrective actions; final validated package → Align (loop closes); updated master plan inputs; lessons learned |

> **DA outputs → IDM:** Analyzed insights, validated conclusions, and confidence levels become the primary inputs for the Insights & Decision Making sub-system.

---

## 4. Insights & Decision Making (IDM)

Deliver actionable insights through dashboards, decision recommendations, and risk alerts. This is the user-facing sub-system — the final quality gate of the UES.

### IDM — Align

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define boundaries of insight delivery and decision support — which roles need dashboards, what decisions to support, what risk management is required | Effective principles from all upstream sub-systems; analyzed insights from DA; user decision-making context (roles, authority, criteria); risk tolerance thresholds; UX requirements; lessons from prior iterations | Validated scope; stakeholder map (decision-makers, viewers, RACI); dashboard and reporting constraints; IDM risk register; Go/No-go |
| DESIGN | Design desired IDM outcomes using VANA; draft master plan — which dashboards, decision tools, risk alerts at which version | Validated scope; decision-maker requirements; VANA criteria per version; Three Pillars; available presentation tools and platforms | Desired IDM outcomes (VANA per version); master plan draft; dashboard and decision tool SLAs per version; version roadmap; risk mitigation plan |
| BUILD | Finalize and lock the IDM master plan; obtain decision-maker sign-off; communicate objectives | Master plan draft; VANA criteria; decision-maker feedback; resource and platform confirmation | Approved master plan (locked); signed-off SLAs; communicated objectives; baseline metrics; alignment brief |
| VALIDATE | Verify IDM alignment — dashboard SLAs are realistic; alignment with upstream principles and actual decision-maker needs | Approved master plan; signed-off SLAs; cross-reference with UES principles; decision-maker validation interviews | Alignment audit report; corrective actions; validated alignment package → Learn; lessons learned |

### IDM — Learn

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define what to learn about insight presentation, decision-making processes, and risk management | Validated alignment package; current version target; user decision workflows; feedback from Improve; existing dashboards and tools | Learning scope; research questions on decision-making blockers/drivers; user observation plan; learning risk register |
| DESIGN | Design research approach for IDM UBS/UDS; evaluate dashboard paradigms, decision frameworks, risk alerting mechanisms | Learning scope; research questions; UES effective principles; decision science best practices; UX/UI benchmarks | IDM UBS diagnosis design; IDM UDS diagnosis design; draft IDM principles; dashboard/decision tool architecture draft; validated methodology |
| BUILD | Execute research — observe decision-maker workflows, test dashboard prototypes, validate risk alerting logic | Approved methodology; decision-maker interviews and observations; dashboard prototypes; risk framework inputs; UX/decision science expertise | IDM UBS (information overload, misinterpretation, decision paralysis, alert fatigue); IDM UDS (clear hierarchy, actionable framing, contextual risk, role-based views); finalized IDM principles; design document; validated risk alerting logic |
| VALIDATE | Verify dashboard designs prevent misinterpretation, decision frameworks are sound, risk alerting avoids false alarms and missed risks | IDM UBS/UDS; IDM principles; design document; UES principles (consistency check); UX peer review and decision-maker validation | Learning audit report; corrective actions; validated learning package → Plan; updated risk register; lessons learned |

### IDM — Plan

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define iteration scope — which dashboards, decision tools, risk alerts, and SOPs to produce | Validated learning package; IDM master plan; resource availability; insight readiness from DA; priority backlog from Improve | Iteration scope; priority ranking; capacity assessment; planning risk register |
| DESIGN | Break IDM features into tasks (dashboard views, recommendation logic, alert rules, training, SOPs); assign RACI; sequence safe presentation before automation | Iteration scope; IDM design; RACI assignments; platform/tool specs; VANA criteria | Task breakdown; RACI per task; effort estimates and timeline; VANA acceptance criteria; execution sequence; dependency map |
| BUILD | Finalize execution plan; lock assignments; set up tracking; distribute to Execute | Task breakdown; confirmed estimates; platform setup; team acknowledgment | Approved execution plan (locked); ClickUp setup; sprint backlog → Execute; communication plan; escalation protocols |
| VALIDATE | Verify plan is realistic — safe presentation before automated recommendations; insight dependencies from DA are met | Approved plan; ClickUp setup; master plan constraints; DA delivery schedule | Planning audit report; corrective actions; validated plan → Execute; confidence score; lessons learned |

### IDM — Execute

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Confirm sprint scope; verify insights from DA are available, platforms are ready, user testing is arranged | Validated plan; sprint backlog; insight availability from DA; platform/tool readiness; risk register | Confirmed sprint scope; blocker log; team kick-off brief; platform and data readiness confirmation |
| DESIGN | Design technical implementation for each component (dashboard layouts, recommendation logic, alert rules, escalation workflows, SOPs) | Confirmed scope; IDM design; IDM principles; UX/UI standards; existing dashboard components | Technical design per component; design review sign-off (including decision-makers); test plan (usability, accuracy); integration specs |
| BUILD | Build and deploy: insight dashboards, decision recommendation engines, risk alerts and escalation protocols, decision logs, user SOPs and training; derisk-first: safe presentation before automated prescriptions | Approved designs; test plans; analyzed insights from DA; platform and tools; SOP templates and training standards | Deployed dashboards (role-based views); decision recommendations (with evidence and confidence); risk alerts, thresholds, and escalation protocols; decision logs and audit trails; user SOPs and training materials |
| VALIDATE | Final quality gate — verify dashboards are clear, recommendations are evidence-based, alerts fire correctly, SOPs are actionable | Deployed IDM system; test results (usability, accuracy, alerts); VANA criteria; decision-maker and end-user feedback | Execution audit report; defect log with severity; corrective actions; validated UES deliverables → users and Improve; lessons learned |

### IDM — Improve

| STAGE | PURPOSE | INPUT | OUTPUT |
|-------|---------|-------|--------|
| DESIGN | Define feedback to collect from end users — dashboard usability, decision quality, alert accuracy, overall enablement effectiveness | Validated UES deliverables; end-user contacts and channels; KPIs and baselines; known issues from audit; prior improvement backlog | Feedback collection plan; channels activated; improvement scope; feedback risk register |
| DESIGN | Design feedback analysis; distinguish UX issues from analytical gaps (upstream fixes) and genuine IDM improvements; prioritize: safety → usability → automation | Feedback plan; raw user feedback (usage data, interviews, tickets); Three Pillars criteria; IDM UBS/UDS | Feedback analysis methodology; validation criteria; prioritization framework; feedback routing rules (IDM vs. upstream fixes); analysis RACI |
| BUILD | Process and validate all user feedback; categorize by sub-system responsibility, severity, and pillar; route improvements to correct sub-system | Raw user feedback; analysis methodology; validation criteria; system performance data across all sub-systems; expert review | Categorized feedback register (by sub-system, pillar, severity); validated improvement requests routed to correct sub-system; rejected feedback log; updated backlog per sub-system; recommendations → Align (all sub-systems) |
| VALIDATE | Final audit closing the full ALPEI loop — verify process was rigorous across all sub-systems; feedback routing was accurate; priorities serve end-user enablement | Categorized register (all sub-systems); validated requests; rejected log; recommendations; stakeholder and end-user review | Final improvement audit report (entire UES); corrective actions per sub-system; final validated package → Align (closes full ALPEI loop); updated master plan inputs for all sub-systems; lessons learned |

> **IDM Improve → All Sub-Systems Align:** The improvement loop feeds validated requests back to the Align work stream of each sub-system, closing the continuous improvement cycle.
