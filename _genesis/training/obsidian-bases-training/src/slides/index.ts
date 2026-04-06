// ── Opening ──
import Title from './01-title';
import PainPoints from './02-pain-points';
import WhatsNew from './03-whats-new';
import BeforeAfter from './04-before-after';
import Agenda from './05-agenda';

// ── Section 1: Quick Start ──
import SectionQuickStart from './06-section-quickstart';
import MigrationGuide from './07-migration-guide';

// ── Section 2: Foundations ──
import SectionFoundations from './03-section-foundations';
import WhatIsObsidian from './04-what-is-obsidian';
import WhatWeBuilt from './05-what-we-built';
import BasesPlugins from './39-bases-plugins';
import WhatIsABase from './06-what-is-a-base';

// ── Section 3: Frontmatter System ──
import SectionFrontmatter from './07-section-frontmatter';
import FrontmatterAnatomy from './08-frontmatter-anatomy';
import StatusLifecycle from './09-status-lifecycle';
import SubSystems from './10-sub-systems';
import FrontmatterFlow from './11-frontmatter-to-dashboard';

// ── Section 4: Obsidian Bases & PM Workflow ──
import SectionWorkflow from './13-section-workflow';
import ThreeLayers from './12-three-layers';
import WorkflowMap from './14-workflow-map';
import MorningStandup from './15-morning-standup';
import MorningBlockers from './16-morning-blockers';
import StandupMaster from './17-standup-master';
import StandupDeps from './18-standup-dependencies';
import WorkPipeline from './19-work-pipeline';
import WorkOverviews from './20-work-overviews';
import ApprovalQueue from './21-approval-queue';
import EodVersion from './22-eod-version';
import WeeklyTriage from './23-weekly-triage';
import WhoDoesWhat from './24-who-does-what';

// ── Section 5: Personal Knowledge Base ──
import SectionPKB from './25-section-pkb';
import PKBWhy from './26-pkb-why';
import CodePipeline from './27-code-pipeline';
import IngestWorkflow from './28-ingest-workflow';
import LearningHierarchy from './29-learning-hierarchy';
import PKBObsidian from './30-pkb-obsidian';

// ── Section 6: QMD & Memory Vault ──
import SectionQMD from './31-section-qmd';
import QMDWorks from './32-qmd-works';

// ── Section 7: Upgraded Skills ──
import SectionSkills from './33-section-skills';
import BrainstormingUpgrade from './34-brainstorming-upgrade';
import AgentCommands from './35-agent-commands';

// ── Section 8: Getting Started + Reference ──
import SectionGettingStarted from './25-section-start';
import Setup from './29-setup';
import SetupQmd from './38-setup-qmd';
import QuickStart from './26-quickstart';
import DayInLife from './37-day-in-life';
import End from './30-end';

export const slides = [
  // Opening (5)
  Title, PainPoints, WhatsNew, BeforeAfter, Agenda,
  // Section 1: Quick Start (2)
  SectionQuickStart, MigrationGuide,
  // Section 2: Foundations (5)
  SectionFoundations, WhatIsObsidian, WhatWeBuilt, BasesPlugins, WhatIsABase,
  // Section 3: Frontmatter (5)
  SectionFrontmatter, FrontmatterAnatomy, StatusLifecycle, SubSystems, FrontmatterFlow,
  // Section 4: PM Workflow (13)
  SectionWorkflow, ThreeLayers, WorkflowMap,
  MorningStandup, MorningBlockers, StandupMaster, StandupDeps,
  WorkPipeline, WorkOverviews, ApprovalQueue, EodVersion, WeeklyTriage, WhoDoesWhat,
  // Section 5: PKB (6)
  SectionPKB, PKBWhy, CodePipeline, IngestWorkflow, LearningHierarchy, PKBObsidian,
  // Section 6: QMD (2)
  SectionQMD, QMDWorks,
  // Section 7: Skills (3)
  SectionSkills, BrainstormingUpgrade, AgentCommands,
  // Section 8: Getting Started + Reference (6)
  SectionGettingStarted, Setup, SetupQmd, QuickStart, DayInLife, End,
];
