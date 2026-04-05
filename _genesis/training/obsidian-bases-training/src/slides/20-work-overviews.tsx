import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight, fadeInUp, staggerContainer } from '../lib/animations';

// ── Workflow Position Bar ─────────────────────────────────────────────────────
const ALL_PHASES = ['MORNING', 'STANDUP', 'WORK', 'APPROVAL', 'EOD', 'WEEKLY'] as const;
type Phase = (typeof ALL_PHASES)[number];

function WorkflowBar({ active }: { active: Phase }) {
  return (
    <div
      style={{
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        height: '32px',
        display: 'flex',
        zIndex: 10,
        backgroundColor: 'rgba(13, 14, 20, 0.85)',
        borderBottom: '1px solid rgba(255,255,255,0.06)',
      }}
    >
      {ALL_PHASES.map((phase) => {
        const isActive = phase === active;
        return (
          <div
            key={phase}
            style={{
              flex: 1,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              background: isActive ? colors.gold : 'transparent',
              borderRight: '1px solid rgba(255,255,255,0.05)',
            }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: isActive ? 700 : 400,
                fontSize: 'clamp(0.4rem, 0.6vw, 0.55rem)',
                color: isActive ? colors.gunmetalDark : colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              {phase}
            </span>
          </div>
        );
      })}
    </div>
  );
}
// ─────────────────────────────────────────────────────────────────────────────

const rows = [
  {
    dashboard: 'W1-alignment-overview',
    ws: '1-ALIGN',
    purpose: 'Master plan: charter, decisions, OKRs',
    screenshot: '18-alignment-overview.png',
    color: colors.gold,
    annotation: 'W1 = your Master Plan',
  },
  {
    dashboard: 'W2-learning-overview',
    ws: '2-LEARN',
    purpose: 'Research pipeline: input → analysis → specs',
    screenshot: '11-learning-overview.png',
    color: colors.purple,
    annotation: null,
  },
  {
    dashboard: 'W3-planning-overview',
    ws: '3-PLAN',
    purpose: 'Execution plan: architecture, risks, roadmap',
    screenshot: '12-planning-overview.png',
    color: colors.midnightLight,
    annotation: 'W3 = your Execution Plan',
  },
  {
    dashboard: 'W4-execution-overview',
    ws: '4-EXECUTE',
    purpose: 'Build artifacts: src, tests, docs',
    screenshot: '13-execution-overview.png',
    color: colors.green,
    annotation: null,
  },
  {
    dashboard: 'W5-improvement-overview',
    ws: '5-IMPROVE',
    purpose: 'Feedback loop: metrics, retros, reviews',
    screenshot: '14-improvement-overview.png',
    color: colors.ruby,
    annotation: null,
  },
];

export default function WorkOverviewsSlide() {
  return (
    <SlideLayout>
      <WorkflowBar active="WORK" />

      {/* Left accent bar */}
      <motion.div
        initial={{ scaleY: 0 }}
        animate={{ scaleY: 1 }}
        transition={{ duration: 0.6, ease: [0.25, 0.1, 0.25, 1] }}
        style={{
          position: 'absolute',
          left: 0,
          top: 32,
          bottom: 0,
          width: '6px',
          background: colors.green,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '52px 72px 28px',
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
          <div style={{ marginBottom: '16px' }}>
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                color: colors.green,
                textTransform: 'uppercase',
                letterSpacing: '0.12em',
                display: 'block',
                marginBottom: '6px',
              }}
            >
              Dashboards 6–10 of 11 · Work Session
            </span>
            <h1
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(1.4rem, 2.8vw, 2.1rem)',
                color: colors.text,
                textTransform: 'uppercase',
                letterSpacing: '-0.02em',
                margin: 0,
              }}
            >
              WORK SESSION: YOUR WORKSTREAM DASHBOARDS
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.green, marginTop: '10px' }} />
          </div>
        </AnimatedText>

        {/* 5-row table with thumbnails */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '4px', minHeight: 0 }}
        >
          {rows.map((row) => (
            <motion.div
              key={row.dashboard}
              variants={fadeInUp}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                padding: '8px 12px',
                borderRadius: '5px',
                background: 'rgba(29,31,42,0.45)',
                borderLeft: `3px solid ${row.color}`,
                border: `1px solid rgba(255,255,255,0.04)`,
                borderLeftWidth: '3px',
                borderLeftColor: row.color,
                flex: 1,
                minHeight: 0,
              }}
            >
              {/* LEFT — dashboard name + purpose */}
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '3px', minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '7px' }}>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.42rem, 0.6vw, 0.54rem)',
                      color: row.color,
                      background: `${row.color}18`,
                      border: `1px solid ${row.color}50`,
                      borderRadius: '3px',
                      padding: '2px 5px',
                      textTransform: 'uppercase',
                      flexShrink: 0,
                    }}
                  >
                    {row.ws}
                  </span>
                  <span
                    style={{
                      fontFamily: "'Courier New', Courier, monospace",
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.56rem)',
                      color: colors.text,
                    }}
                  >
                    {row.dashboard}
                  </span>
                  {row.annotation && (
                    <span
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 600,
                        fontSize: 'clamp(0.4rem, 0.58vw, 0.52rem)',
                        color: colors.gold,
                        background: `${colors.gold}12`,
                        border: `1px solid ${colors.gold}35`,
                        borderRadius: '3px',
                        padding: '1px 5px',
                        textTransform: 'uppercase',
                        letterSpacing: '0.04em',
                        flexShrink: 0,
                      }}
                    >
                      {row.annotation}
                    </span>
                  )}
                </div>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.56rem)',
                    color: colors.textDim,
                    lineHeight: 1.4,
                  }}
                >
                  {row.purpose}
                </span>
              </div>

              {/* RIGHT — thumbnail */}
              <div
                style={{
                  width: '120px',
                  flexShrink: 0,
                  borderRadius: '4px',
                  overflow: 'hidden',
                  border: `1px solid ${row.color}35`,
                  boxShadow: `0 2px 8px rgba(0,0,0,0.4)`,
                  alignSelf: 'stretch',
                }}
              >
                <img
                  src={`/screenshots/${row.screenshot}`}
                  alt={row.dashboard}
                  style={{
                    width: '100%',
                    height: '100%',
                    objectFit: 'cover',
                    objectPosition: 'top',
                    display: 'block',
                  }}
                />
              </div>
            </motion.div>
          ))}
        </motion.div>

        {/* YOU DO + callouts */}
        <AnimatedText delay={0.7}>
          <div style={{ marginTop: '10px', display: 'flex', flexDirection: 'column', gap: '6px' }}>
            {/* YOU DO */}
            <div
              style={{
                padding: '10px 16px',
                borderRadius: '5px',
                background: `${colors.gold}10`,
                border: `1px solid ${colors.gold}40`,
                display: 'flex',
                gap: '10px',
                alignItems: 'flex-start',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.48rem, 0.68vw, 0.6rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.08em',
                  flexShrink: 0,
                  paddingTop: '1px',
                }}
              >
                YOU DO:
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.48rem, 0.68vw, 0.6rem)',
                  color: colors.text,
                  lineHeight: 1.5,
                }}
              >
                Open the overview for YOUR active workstream. Check which files are draft vs in-progress. Click any file name to open it directly.
              </span>
            </div>
            {/* Auto-updates */}
            <div
              style={{
                padding: '8px 16px',
                borderRadius: '5px',
                background: 'rgba(29, 31, 42, 0.5)',
                border: '1px solid rgba(255,255,255,0.06)',
                display: 'flex',
                gap: '10px',
                alignItems: 'flex-start',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                  color: colors.midnightLight,
                  textTransform: 'uppercase',
                  letterSpacing: '0.08em',
                  flexShrink: 0,
                  paddingTop: '1px',
                }}
              >
                Auto-updates:
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                  color: colors.textDim,
                  lineHeight: 1.5,
                }}
              >
                When agents complete work via /dsbv build, the status changes in frontmatter. To see updates in your dashboard, switch to another tab and back, or reopen the .base file.
              </span>
            </div>
            {/* ClickUp note */}
            <div
              style={{
                padding: '8px 16px',
                borderRadius: '5px',
                background: 'rgba(29, 31, 42, 0.5)',
                border: '1px solid rgba(255,255,255,0.06)',
                display: 'flex',
                gap: '10px',
                alignItems: 'flex-start',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                  color: colors.purple,
                  textTransform: 'uppercase',
                  letterSpacing: '0.08em',
                  flexShrink: 0,
                  paddingTop: '1px',
                }}
              >
                Note:
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                  color: colors.textDim,
                  lineHeight: 1.5,
                }}
              >
                Obsidian shows your project's technical state. ClickUp remains your task tracker. They complement each other — use both.
              </span>
            </div>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
