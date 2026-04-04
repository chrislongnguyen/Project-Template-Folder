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

const triagePanels = [
  {
    label: 'TASKS',
    file: '16-tasks-overview.png',
    color: colors.gold,
    actions: [
      'Process captures: file to correct workstream, or archive',
      'Anything unprocessed > 7 days? Deal with it or delete it',
    ],
  },
  {
    label: 'PEOPLE',
    file: '17-people-directory.png',
    color: colors.midnightLight,
    actions: [
      'Review stakeholder contacts — anyone you haven\'t engaged recently?',
      'DAYS SINCE CONTACT surfaces who\'s going cold',
    ],
  },
  {
    label: 'DAILY NOTES',
    file: '15-daily-notes-index.png',
    color: colors.purple,
    actions: [
      'Scan the week\'s notes — any patterns or recurring blockers?',
      '~WORDS estimate helps spot thin vs rich days',
    ],
  },
];

export default function WeeklyTriageSlide() {
  return (
    <SlideLayout>
      <WorkflowBar active="WEEKLY" />

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
          background: colors.purple,
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
          <div style={{ marginBottom: '16px' }}>
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                color: colors.purple,
                textTransform: 'uppercase',
                letterSpacing: '0.12em',
                display: 'block',
                marginBottom: '6px',
              }}
            >
              Weekly · Triage &amp; Review
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
              WEEKLY: TRIAGE & REVIEW
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.purple, marginTop: '10px' }} />
          </div>
        </AnimatedText>

        {/* Three panels */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            flex: 1,
            display: 'flex',
            gap: '20px',
            minHeight: 0,
          }}
        >
          {triagePanels.map((panel) => (
            <motion.div
              key={panel.label}
              variants={fadeInUp}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                gap: '10px',
              }}
            >
              {/* Label header */}
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.72vw, 0.64rem)',
                    color: panel.color,
                    background: `${panel.color}18`,
                    border: `1px solid ${panel.color}50`,
                    borderRadius: '3px',
                    padding: '2px 7px',
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                  }}
                >
                  {panel.label}
                </span>
              </div>

              {/* Screenshot thumbnail */}
              <div
                style={{
                  flex: 1,
                  borderRadius: '6px',
                  overflow: 'hidden',
                  border: `1px solid ${panel.color}35`,
                  boxShadow: `0 4px 16px rgba(0,0,0,0.4), 0 0 0 1px ${panel.color}15`,
                  minHeight: 0,
                }}
              >
                <img
                  src={`/screenshots/${panel.file}`}
                  alt={panel.label}
                  style={{
                    width: '100%',
                    height: '100%',
                    objectFit: 'cover',
                    objectPosition: 'top',
                    display: 'block',
                  }}
                />
              </div>

              {/* Actions */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
                {panel.actions.map((action, i) => (
                  <div
                    key={i}
                    style={{
                      display: 'flex',
                      alignItems: 'flex-start',
                      gap: '6px',
                    }}
                  >
                    <div
                      style={{
                        width: '14px',
                        height: '14px',
                        borderRadius: '2px',
                        background: `${panel.color}20`,
                        border: `1px solid ${panel.color}50`,
                        flexShrink: 0,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        marginTop: '1px',
                      }}
                    >
                      <span style={{ fontSize: '7px', color: panel.color, fontWeight: 700 }}>{i + 1}</span>
                    </div>
                    <span
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                        color: colors.text,
                        lineHeight: 1.5,
                      }}
                    >
                      {action}
                    </span>
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
