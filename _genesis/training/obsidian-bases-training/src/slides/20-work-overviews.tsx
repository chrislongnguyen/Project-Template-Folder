import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

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
    when: 'Working on charter, decisions, OKRs',
    what: 'Files in 1-ALIGN/ grouped by folder',
    color: colors.gold,
    ws: '1-ALIGN',
  },
  {
    dashboard: 'W2-learning-overview',
    when: 'Doing research, writing specs',
    what: 'Files in 2-LEARN/ grouped by folder',
    color: colors.purple,
    ws: '2-LEARN',
  },
  {
    dashboard: 'W3-planning-overview',
    when: 'Architecture, risks, roadmap',
    what: 'Files in 3-PLAN/ grouped by folder',
    color: colors.midnightLight,
    ws: '3-PLAN',
  },
  {
    dashboard: 'W4-execution-overview',
    when: 'Building, testing, documenting',
    what: 'Files in 4-EXECUTE/ grouped by folder',
    color: colors.green,
    ws: '4-EXECUTE',
  },
  {
    dashboard: 'W5-improvement-overview',
    when: 'Metrics, retros, reviews',
    what: 'Files in 5-IMPROVE/ grouped by folder',
    color: colors.ruby,
    ws: '5-IMPROVE',
  },
];

const COL_WIDTHS = ['34%', '34%', '32%'];

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
          padding: '52px 72px 36px',
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
          <div style={{ marginBottom: '20px' }}>
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
              Layer 2 Dashboards · Work Session
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
              WORK SESSION: DRILL INTO YOUR WORKSTREAM
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.green, marginTop: '10px' }} />
          </div>
        </AnimatedText>

        {/* Table */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '0px', minHeight: 0 }}
        >
          {/* Table header */}
          <div
            style={{
              display: 'flex',
              borderRadius: '6px 6px 0 0',
              background: 'rgba(255,255,255,0.04)',
              borderBottom: `1px solid rgba(255,255,255,0.1)`,
              padding: '8px 14px',
            }}
          >
            {['Dashboard', 'When to use', 'What you see'].map((h, i) => (
              <span
                key={h}
                style={{
                  width: COL_WIDTHS[i],
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.48rem, 0.68vw, 0.6rem)',
                  color: colors.textDim,
                  textTransform: 'uppercase',
                  letterSpacing: '0.08em',
                }}
              >
                {h}
              </span>
            ))}
          </div>

          {/* Table rows */}
          {rows.map((row) => (
            <motion.div
              key={row.dashboard}
              variants={fadeInUp}
              style={{
                display: 'flex',
                alignItems: 'center',
                padding: '10px 14px',
                borderBottom: '1px solid rgba(255,255,255,0.04)',
                background: 'rgba(29,31,42,0.35)',
                borderLeft: `3px solid ${row.color}`,
              }}
            >
              {/* Dashboard name */}
              <div style={{ width: COL_WIDTHS[0], display: 'flex', alignItems: 'center', gap: '8px' }}>
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
              </div>

              {/* When to use */}
              <span
                style={{
                  width: COL_WIDTHS[1],
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.56rem)',
                  color: colors.textDim,
                  lineHeight: 1.4,
                  paddingRight: '12px',
                }}
              >
                {row.when}
              </span>

              {/* What you see */}
              <span
                style={{
                  width: COL_WIDTHS[2],
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.56rem)',
                  color: colors.textDim,
                  lineHeight: 1.4,
                }}
              >
                {row.what}
              </span>
            </motion.div>
          ))}
        </motion.div>

        {/* YOU DO row */}
        <AnimatedText delay={0.6}>
          <div
            style={{
              marginTop: '16px',
              padding: '10px 16px',
              borderRadius: '5px',
              background: `${colors.gold}10`,
              border: `1px solid ${colors.gold}30`,
              display: 'flex',
              gap: '12px',
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
              Open the overview matching your CURRENT workstream. Check which files are draft vs in-progress.
            </span>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
