---
version: "1.0"
status: Draft
last_updated: 2026-04-01
source: "Vinh Nguyen (CIO), branch Vinh-ALPEI-AI-Operating-System"
---

# OVERVIEW OF LTC'S ALPEI FRAMEWORK

At LTC, we enable internal users and external users (i.e., our clients) to solve their problems by developing and delivering User Enablement Systems (UES). Based on LTC's effectiveness truths and principles, all User Enablement Projects at LTC follow an agile framework built on three structural layers: five concurrent work streams, four stages per work stream, and four sub-systems within the resulting UES.

## Layer 1: Five Concurrent Work Streams

These are concurrent, not sequential — they run in parallel and feed into each other continuously (Align → Learn → Plan → Execute → Improve → back to Align).

- **Align.** Align the desired outcome and a master plan detailing timelines, key version milestones, and available resources.
- **Learn.** Understand the relevant blockers (UBS) and drivers (UDS) of the user enablement system and its four sub-systems, then design an effective solution based on the desired outcome, timeline, and available resources.
- **Plan.** Create an execution plan to develop the appropriate set of features in each iteration of a version.
- **Execute.** Develop and deliver the planned set of features.
- **Improve.** Collect feedback from users, validate the feedback, and input validated improvement requests into the master plan to create a continuous improvement loop.

## Layer 2: Four Stages Per Work Stream

To ensure effectiveness and risk management, each work stream follows four agile stages. The output of each stage is the input for the next (Design → Sequence → Build → Validate).

- **Design.** Define what needs to be done and why.
- **Sequence.** Design how to do it.
- **Build.** Do it.
- **Validate.** Verify it was done correctly and feeds the right output forward.

## Layer 3: Four Sub-Systems Within the UES

The five work streams produce a UES composed of four sequential sub-systems. The output of each sub-system is the input for the next (Problem Diagnosis → Data Pipeline → Data Analysis → Insights & Decision Making).

- **Problem Diagnosis.** Understand the blockers and drivers of the users' problems, then design the right principles for the entire UES to overcome these blockers and utilize these drivers. These principles govern the design of the remaining three sub-systems.
- **Data Pipeline.** Understand the blockers and drivers of acquiring, cleaning, standardizing, and processing the necessary data inputs. Design the right principles, then develop and deliver the pipeline from raw to processed data.
- **Data Analysis.** Understand the blockers and drivers of analyzing the processed data and extracting effective insights. Design the right principles, then develop and deliver the analyzed insights.
- **Insights & Decision Making.** Understand the blockers and drivers of viewing analyzed insights, making effective decisions, and managing risks. Design the right principles, then develop and deliver insight dashboards with recommended decisions and risk management.

> [!note] Important Compared to the six work streams in LTC's Ultimate Truths, the risk management work stream is not missing — it is embedded in all five work streams and their four stages.

---

# WORKING PRINCIPLES OF THE ALPEI FRAMEWORK

**Principle 1: Sub-systems are sequential.** The output of each sub-system is the input for the next: Problem Diagnosis → Data Pipeline → Data Analysis → Insights & Decision Making.

**Principle 2: Versions follow the three pillars of effectiveness.** Each sub-system progresses through five versions: Logic Scaffold → Concept → Prototype → Minimum Viable Enablement → Leadership. Each version is not "more features" — it is a deliberate progression: first understand the problem (Logic Scaffold), then make it safe (Sustainability), then make it productive (Efficiency), then make it grow effortlessly (Scalability).

**Principle 3: VANA defines "done" at every version.** Each version has clear success criteria based on the VANA framework (Verb, Adverb, Noun, Adjective from Ultimate Truth #2):

- **Logic Scaffold** is the foundation before any building begins. Verb: understand and design. Adverbs: clearly, completely. Noun: the scope and logic of the enablement system. Adjectives: clear, complete. We are mapping out what the system needs to solve, identifying its blockers (UBS) and drivers (UDS), and designing the logical structure that the Concept version will prove. Think of it as the blueprint — no construction yet, just making sure we understand the problem and have a sound design before investing resources.
- **Concept** focuses on Sustainability. Verb: derisk and deliver output. Adverbs: correctly, safely. Noun: the user's environment with simulated tools, SOP, and actions. Adjectives: correct, safe. We are proving the logic works and failure risks are under control.
- **Prototype** begins adding Efficiency. The Adverbs expand to include "more easily, higher output, and better time-saving than alternatives." The Noun is now a prototype of the real enablement system (environment, tools, and SOP). The Adjectives remain sustainable (correct, safe) while the system starts demonstrating it can outperform other approaches.
- **Minimum Viable Enablement** delivers full Efficiency. The Adverbs now also include "reliably." The Noun becomes the full, working enablement system. The Adjectives expand to include "cheaper and fairly easy to acquire." The system is now proven to be both safe and productive with current resources.
- **Leadership** adds Scalability. The Adverbs expand to "automatically, predictively, prescriptively." The Noun is the full enablement system including some user actions. The Adjectives add "automatic, predictive, prescriptive." The system now gets disproportionately better as resources grow.

**Principle 4: Versions iterate.** Each version of a sub-system can have one or more iterations, delivering incremental improvements via the improvement feedback loops from the five work streams and their four stages.

**Principle 5: Work streams chain forward.** Each work stream's output is the input for the next: Align → Learn → Plan → Execute → Improve.

**Principle 6: Stages chain forward within a work stream.** The output of each stage is the input for the next: Design → Sequence → Build → Validate.

**Principle 7: Improve loops back to Align.** The output of Improve feeds back into Align, creating a continuous improvement loop for the next iteration.

---

# REFERENCE TABLES FOR AI AGENTS

The tables below are structured summaries of the prose above. AI agents should use these tables for quick lookup, validation, and decision-making. LTC Members may also find them useful as cheat sheets.

## Table 1: UES Version Success Criteria (VANA)

|VERSION|PILLAR|VERB|ADVERBS|NOUN|ADJECTIVES|
|---|---|---|---|---|---|
|LOGIC SCAFFOLD|(Pre-build)|Understand and design|Clearly, completely|The scope and logic of the enablement system|Clear, complete|
|CONCEPT|Sustainability|Derisk and deliver output|Correctly, safely|User's environment with simulated tools, SOP, and actions|Correct, safe|
|PROTOTYPE|Sustainability + Efficiency (emerging)|Derisk and deliver output|Correctly, safely, more easily, higher output, better time-saving than alternatives|Prototype of the real enablement system (environment, tools, and SOP)|Correct, safe|
|MINIMUM VIABLE ENABLEMENT|Sustainability + Efficiency (full)|Derisk and deliver output|Correctly, safely, reliably, more easily, higher output, better time-saving than alternatives|Full, working enablement system|Correct, safe, reliable, cheaper, fairly easy to acquire|
|LEADERSHIP|Sustainability + Efficiency + Scalability|Derisk and deliver output|Correctly, safely, reliably, more easily, higher output, better time-saving, automatically, predictively, prescriptively|Full enablement system including some user actions|Correct, safe, reliable, cheaper, fairly easy to acquire, automatic, predictive, prescriptive|

## Table 2: Sub-System Sequence

|ORDER|SUB-SYSTEM|PRIMARY OUTPUT (FEEDS INTO NEXT)|
|---|---|---|
|1|Problem Diagnosis|Effective principles for the entire UES (UBS/UDS analysis)|
|2|Data Pipeline|Processed data ready for analysis|
|3|Data Analysis|Analyzed insights ready for viewing and decision-making|
|4|Insights & Decision Making|Insight dashboards, recommended decisions, and risk management|

## Table 3: Work Stream Sequence

|ORDER|WORK STREAM|PRIMARY OUTPUT (FEEDS INTO NEXT)|
|---|---|---|
|1|Align|Desired outcome, master plan, stakeholder commitments|
|2|Learn|Validated understanding of blockers (UBS) and drivers (UDS), effective solution design|
|3|Plan|Execution plan with feature scope, resource allocation, risk register|
|4|Execute|Deployed solution, tested and delivered to users|
|5|Improve|Validated improvements and feedback → loops back to Align|

## Table 4: Stage Sequence (within each work stream)

|ORDER|STAGE|PURPOSE|GENERIC INPUT|GENERIC OUTPUT|
|---|---|---|---|---|
|1|Design|Define what and why|Context, needs, objectives from prior work stream|Objectives and success criteria for this work stream|
|2|Sequence|Design how|Objectives, constraints, available resources|Plan or blueprint for execution|
|3|Build|Do it|Plan, resources, access|Completed deliverable|
|4|Validate|Verify correctness|Completed deliverable, original objectives|Validated deliverable ready to feed the next work stream|

## Table 5: Chain-of-Custody Rules

|RULE|SEQUENCE|DIRECTION|
|---|---|---|
|SUB-SYSTEMS CHAIN FORWARD|Problem Diagnosis → Data Pipeline → Data Analysis → Insights & Decision Making|Sequential, output-to-input|
|WORK STREAMS CHAIN FORWARD|Align → Learn → Plan → Execute → Improve|Concurrent, output-to-input|
|STAGES CHAIN FORWARD WITHIN A WORK STREAM|Design → Sequence → Build → Validate|Sequential, output-to-input|
|IMPROVE LOOPS BACK TO ALIGN|Improve → Align|Feedback loop for next iteration|
|VERSIONS PROGRESS THROUGH PILLARS|Logic Scaffold → Concept → Prototype → MVE → Leadership|Sequential, pillar-by-pillar|

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[deliverable]]
- [[iteration]]
