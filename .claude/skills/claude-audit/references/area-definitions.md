# Area Definitions — 21 Audit Areas

Each area is a MECE partition of the repo. Every tracked file belongs to exactly one area.
`genesis-training` is excluded (Vite build artifacts, node_modules — not audit-relevant).

## Area Inventory

### 1. ws-align
- **Path:** `1-ALIGN/`
- **Expected:** Charter, OKRs, ADRs, stakeholder map per subsystem (1-PD, 2-DP, 3-DA, 4-IDM) + `_cross` for shared decisions
- **Audit criteria:**
  - Each subsystem dir has README.md
  - `_cross/` has cross-cutting decision registers
  - Populated files have correct frontmatter (version, status, last_updated)
  - ADRs follow template from `_genesis/templates/adr-template.md`
  - Content aligns with charter scope — no scope creep into other workstreams

### 2. ws-learn
- **Path:** `2-LEARN/`
- **Expected:** 6-state pipeline (input→research→specs→output→archive) per subsystem. NO DSBV files.
- **Audit criteria:**
  - **CRITICAL:** ZERO DSBV files (DESIGN.md, SEQUENCE.md, VALIDATE.md) must exist here
  - Pipeline dirs exist per subsystem
  - Learning specs follow Effective Learning page format (P0-P5)
  - UBS/UDS analysis with force categorization
  - `_cross/` has shared learning resources and scripts

### 3. ws-plan
- **Path:** `3-PLAN/`
- **Expected:** Architecture docs, UBS_REGISTER.md, UDS_REGISTER.md, roadmaps per subsystem
- **Audit criteria:**
  - Risk registers (UBS) categorized by S > E > Sc priority
  - Driver registers (UDS) link to specific ALIGN decisions
  - Architecture docs reference upstream LEARN outputs
  - `_cross/` has cross-cutting registers

### 4. ws-execute
- **Path:** `4-EXECUTE/`
- **Expected:** Source, tests, config, docs per subsystem
- **Audit criteria:**
  - Build outputs traceable to PLAN architecture
  - Tests exist for any source code
  - Config files documented
  - `_cross/` has shared execution artifacts

### 5. ws-improve
- **Path:** `5-IMPROVE/`
- **Expected:** Changelog, metrics baselines (S/E/Sc), retro templates, review stubs
- **Audit criteria:**
  - Changelog covers recent changes
  - Metrics baselines reference S > E > Sc priority
  - Retro templates follow pattern from `_genesis/templates/`
  - `_cross/` has cross-changelog and feedback register

### 6. genesis-frameworks
- **Path:** `_genesis/frameworks/`
- **Expected:** 9 canonical frameworks (Vinh's) + ALPEI-DSBV process map (multi-part)
- **Audit criteria:**
  - All frameworks have frontmatter
  - Process map paths (`alpei-dsbv-process-map.md` Parts 1-4) match actual filesystem routing
  - Cross-references between frameworks are valid wikilinks
  - No stale paths to removed directories
  - Part 4 (subsystem layer) reflects current 4-subsystem structure

### 7. genesis-templates
- **Path:** `_genesis/templates/`
- **Expected:** Templates for every DSBV artifact type + learning book pages (P0-P7)
- **Audit criteria:**
  - Every DSBV stage has a template (DESIGN, SEQUENCE, BUILD context, VALIDATE)
  - Templates have placeholder instructions, not empty files
  - Learning book pages follow 17-column CAG format
  - DSBV context template matches agent-prompts pattern
  - Memory seed templates present

### 8. genesis-sops
- **Path:** `_genesis/sops/` + `_genesis/guides/`
- **Expected:** Standard Operating Procedures, migration/setup/multi-agent guides
- **Audit criteria:**
  - Main SOP matches actual repo state (file counts, paths, workflow steps)
  - Migration guide paths are current (no stale references)
  - Setup guide works for fresh clone
  - Multi-agent guide references correct agent files

### 9. genesis-reference
- **Path:** `_genesis/reference/`
- **Expected:** Archived frameworks, EP registry, effectiveness guide, agent designs
- **Audit criteria:**
  - Binary files (PDF, DOCX, PPTX) noted but not content-audited
  - .md files have correct frontmatter
  - Archive dir README explains what's archived and why
  - EP registry (`ltc-effective-agent-principles-registry.md`) is current
  - Agent designs in archive/ are properly labeled as historical

### 10. genesis-other
- **Path:** `_genesis/` remaining dirs (brand, compliance, culture, governance, obsidian, philosophy, principles, scripts, security, tools)
- **Expected:** Organizational knowledge that ships with every clone
- **Audit criteria:**
  - Each subdir has README.md
  - Brand identity files match `rules/brand-identity.md`
  - Security files match `rules/security-rules.md`
  - Obsidian templates + Bases configs are functional
  - No orphaned content (everything linked from somewhere)
  - `_genesis/tools/alpei-navigator.html` — check if stale

### 11. claude-rules
- **Path:** `.claude/rules/`
- **Expected:** 12 always-on rule files (auto-loaded every session)
- **Audit criteria:**
  - README.md lists all 12 files with accurate descriptions
  - Each rule file is concise (summary, not full spec)
  - Full specs in `rules/` are referenced correctly
  - No contradictions between rules
  - Enforcement layer references (hooks, scripts) are accurate
  - All [[wikilinks]] resolve

### 12. claude-agents
- **Path:** `.claude/agents/`
- **Expected:** 4 agent definitions (ltc-explorer, ltc-planner, ltc-builder, ltc-reviewer) + README
- **Audit criteria:**
  - Each agent has correct model declaration (haiku/sonnet/opus)
  - Scope boundaries match agent-dispatch.md rule
  - Tool restrictions documented (e.g., explorer is read-only)
  - EP-13 compliance (no Agent() calls from sub-agents)
  - README accurately describes the 4-agent roster

### 13. claude-skills-core
- **Path:** `.claude/skills/` — critical skills only: dsbv, learn*, git-save, obsidian, deep-research
- **Expected:** PM-facing skills with SKILL.md, references, gotchas
- **Audit criteria:**
  - Every skill dir has SKILL.md with required frontmatter
  - Referenced scripts exist on disk
  - Reference files are current (no stale paths)
  - `/dsbv` skill correctly orchestrates all 4 DSBV stages
  - `/learn` pipeline skills chain correctly (input→research→structure→review→spec)
  - `/git-save` follows git-conventions.md

### 14. claude-skills-other
- **Path:** `.claude/skills/` — all remaining skill dirs
- **Expected:** Governance, utility, WMS, brand, brainstorming skills
- **Audit criteria:**
  - Every skill dir has SKILL.md with required frontmatter
  - No duplicate functionality between skills
  - `ltc-*` prefix skills follow governance conventions
  - Referenced scripts and rules exist
  - Trigger descriptions are accurate

### 15. claude-hooks
- **Path:** `.claude/hooks/` + `.claude/settings.json` + remaining `.claude/` root files
- **Expected:** 29 hook registrations in settings.json, hook scripts in hooks/, config files
- **Audit criteria:**
  - Every settings.json hook entry points to an existing script
  - Every script referenced in hook commands exists on disk
  - Hook event types match the 7 supported events
  - No orphan hook scripts (on disk but not registered)
  - Permission modes appropriate for each hook
  - settings.json parseable as valid JSON

### 16. scripts
- **Path:** `scripts/`
- **Expected:** 53+ scripts (enforcement, validation, DSBV, setup, Obsidian, learning)
- **Audit criteria:**
  - Every .sh/.py has version header comment
  - script-registry.md lists all scripts (cross-reference with disk)
  - No orphan scripts (on disk but not in registry)
  - No phantom scripts (in registry but not on disk)
  - Critical scripts are executable: pre-flight.sh, validate-blueprint.py, pkb-lint.sh
  - Bash scripts compatible with macOS default Bash 3

### 17. rules-fullspec
- **Path:** `rules/`
- **Expected:** 8 full-spec rule files (on-demand, NOT auto-loaded)
- **Audit criteria:**
  - Consistent with `.claude/rules/` summaries (no contradictions)
  - Each full spec covers what the summary omits
  - Cross-references between rules are valid
  - Naming convention spec has current SCOPE codes
  - Brand identity spec has current color/font definitions

### 18. root-config
- **Path:** Root-level files + `.github/`
- **Expected:** README.md, CLAUDE.md, AGENTS.md, GEMINI.md, codex.md, CHANGELOG.md, GitHub config
- **Audit criteria:**
  - README.md counts are accurate (files, scripts, skills, rules, hooks)
  - README.md links are valid
  - CLAUDE.md under 120 lines, accurate architecture summary
  - AGENTS.md matches actual agent files
  - CHANGELOG.md covers recent commits
  - GitHub issue templates functional
  - Bootstrap note present (template ships minimal, PMs generate via /dsbv)

### 19. cursor-config
- **Path:** `.cursor/` + `.agents/`
- **Expected:** Cursor IDE rules mirroring .claude/rules/ key sections. Codex/Copilot agent config.
- **Audit criteria:**
  - Cursor rules cover: DSBV, enforcement, routing, naming, agent roster
  - Parity with .claude/rules/ (no contradictions)
  - `.agents/` rules don't conflict with `.claude/` rules
  - No sensitive data in IDE config files

### 20. pkb
- **Path:** `PERSONAL-KNOWLEDGE-BASE/`
- **Expected:** Capture→Organise→Distil→Express 4-stage pipeline. README, dashboard, 1-captured/, 2-organised/, 3-distilled/
- **Audit criteria:**
  - README documents auto-recall, QMD integration
  - Dashboard config references correct properties (2-organised/ not 3-distilled/ for AI pages)
  - Frontmatter all lowercase
  - No stale content (>30 days without update flagged)
  - 1-captured/ files should be logged in 2-organised/_log.md

### 21. vault-other
- **Path:** `DAILY-NOTES/`, `inbox/`, `MISC-TASKS/`, `PEOPLE/`
- **Expected:** Light scaffolding with READMEs and .gitkeep files
- **Audit criteria:**
  - READMEs exist in each dir
  - .gitkeep files present for empty dirs
  - No personal data (PII) leaked in committed files
  - inbox/ may contain audit reports — note but don't flag
  - No sensitive credentials or tokens
