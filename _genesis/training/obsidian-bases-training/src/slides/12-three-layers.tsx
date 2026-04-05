import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const layers = [
  {
    label: 'LAYER 1 — CROSS-CUTTING',
    sublabel: 'Your command center — spans all 5 workstreams (6 dashboards)',
    accent: colors.gold,
    items: [
      { name: 'C1-master-dashboard', purpose: 'All deliverables, all workstreams' },
      { name: 'C2-stage-board', purpose: 'D→S→B→V pipeline' },
      { name: 'C3-standup-preparation', purpose: 'Morning check: what changed?' },
      { name: 'C4-blocker-dashboard', purpose: 'Stale items = risk' },
      { name: 'C5-approval-queue', purpose: 'Items waiting for YOUR review' },
      { name: 'C6-version-progress', purpose: 'Are we advancing iterations?' },
    ],
  },
  {
    label: 'LAYER 2 — WORKSTREAM',
    sublabel: 'One per ALPEI stream — follows 1–5 numbering (5 dashboards)',
    accent: colors.midnightLight,
    items: [
      { name: 'W1-alignment-overview', purpose: '1-ALIGN — Charter, decisions, OKRs' },
      { name: 'W2-learning-overview', purpose: '2-LEARN — Research pipeline, input/output' },
      { name: 'W3-planning-overview', purpose: '3-PLAN — Risks, drivers, roadmap' },
      { name: 'W4-execution-overview', purpose: '4-EXECUTE — Source, tests, docs' },
      { name: 'W5-improvement-overview', purpose: '5-IMPROVE — Changelog, retros, metrics' },
    ],
  },
  {
    label: 'LAYER 3 — UTILITY',
    sublabel: 'Supporting tools — not workstream-specific (7 dashboards)',
    accent: colors.green,
    items: [
      { name: 'U1-daily-notes-index', purpose: 'Daily log entries' },
      { name: 'U2-tasks-overview', purpose: 'Task tracking across files' },
      { name: 'U3-inbox-overview', purpose: 'Unprocessed captures' },
      { name: 'U4-people-directory', purpose: 'Stakeholder registry' },
      { name: 'U5-templates-library', purpose: 'Reusable template browser' },
      { name: 'U6-agent-activity', purpose: 'Recent agent actions log' },
      { name: 'C7-dependency-tracker', purpose: 'Cross-workstream dependencies' },
    ],
  },
];

export default function ThreeLayersSlide() {
  return (
    <SlideLayout>
      {/* Gold accent bar */}
      <motion.div
        initial={{ scaleY: 0 }}
        animate={{ scaleY: 1 }}
        transition={{ duration: 0.6, ease: [0.25, 0.1, 0.25, 1] }}
        style={{
          position: 'absolute',
          left: 0,
          top: 0,
          bottom: 0,
          width: '6px',
          background: colors.gold,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '40px 80px 32px',
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 8px 0',
            }}
          >
            18 DASHBOARDS — 3 LAYERS
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '24px',
            }}
          />
        </AnimatedText>

        {/* Three columns */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            flex: 1,
            display: 'flex',
            gap: '16px',
            alignItems: 'stretch',
          }}
        >
          {layers.map((layer) => (
            <motion.div
              key={layer.label}
              variants={fadeInUp}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                gap: '8px',
              }}
            >
              {/* Layer header */}
              <div
                style={{
                  padding: '10px 14px',
                  borderRadius: '6px 6px 0 0',
                  background: `${layer.accent}18`,
                  borderBottom: `2px solid ${layer.accent}`,
                }}
              >
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: layer.accent,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                    margin: 0,
                  }}
                >
                  {layer.label}
                </p>
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                    color: colors.textDim,
                    margin: '2px 0 0 0',
                  }}
                >
                  {layer.sublabel}
                </p>
              </div>

              {/* Items */}
              <div
                style={{
                  flex: 1,
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '5px',
                  padding: '4px 0',
                }}
              >
                {layer.items.map((item) => (
                  <div
                    key={item.name}
                    style={{
                      padding: '7px 12px',
                      borderRadius: '4px',
                      background: 'rgba(29,31,42,0.5)',
                      border: '1px solid rgba(255,255,255,0.05)',
                      borderLeft: `2px solid ${layer.accent}60`,
                    }}
                  >
                    <p
                      style={{
                        fontFamily: "'Courier New', Courier, monospace",
                        fontWeight: 600,
                        fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                        color: layer.accent,
                        margin: 0,
                        letterSpacing: '0.01em',
                      }}
                    >
                      {item.name}
                    </p>
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.45rem, 0.62vw, 0.52rem)',
                        color: colors.textDim,
                        margin: '2px 0 0 0',
                        lineHeight: 1.4,
                      }}
                    >
                      {item.purpose}
                    </p>
                  </div>
                ))}
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
