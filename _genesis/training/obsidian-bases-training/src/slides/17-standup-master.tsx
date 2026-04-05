import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

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

const workstreamColors = [
  { label: 'ALIGN', color: colors.gold },
  { label: 'LEARN', color: colors.purple },
  { label: 'PLAN', color: colors.midnightLight },
  { label: 'EXECUTE', color: colors.green },
  { label: 'IMPROVE', color: colors.ruby },
];

export default function StandupMasterSlide() {
  return (
    <SlideLayout>
      <WorkflowBar active="STANDUP" />

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
          background: colors.midnightLight,
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
                color: colors.midnightLight,
                textTransform: 'uppercase',
                letterSpacing: '0.12em',
                display: 'block',
                marginBottom: '6px',
              }}
            >
              Dashboard 3 of 11 · Standup
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
              STANDUP: MASTER DASHBOARD
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.midnightLight, marginTop: '10px' }} />
          </div>
        </AnimatedText>

        {/* Content */}
        <div style={{ flex: 1, display: 'flex', gap: '32px', minHeight: 0 }}>

          {/* LEFT — 40% */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{
              width: '40%',
              flexShrink: 0,
              display: 'flex',
              flexDirection: 'column',
              gap: '16px',
            }}
          >
            {/* What it shows */}
            <div>
              <div
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
                  color: colors.textDim,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                  marginBottom: '10px',
                }}
              >
                WHAT THIS SHOWS
              </div>
              {[
                {
                  bold: 'Single source of truth —',
                  rest: 'all deliverables, all workstreams',
                  accent: colors.midnightLight,
                },
                {
                  bold: 'Use BY WORK STREAM view',
                  rest: 'for standup reporting',
                  accent: colors.midnightLight,
                },
              ].map((item, i) => (
                <div
                  key={i}
                  style={{
                    padding: '8px 12px',
                    borderRadius: '5px',
                    background: 'rgba(29, 31, 42, 0.6)',
                    border: `1px solid ${item.accent}30`,
                    marginBottom: '6px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
                      color: colors.text,
                    }}
                  >
                    {item.bold}
                  </span>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
                      color: colors.textDim,
                      marginLeft: '4px',
                    }}
                  >
                    {item.rest}
                  </span>
                </div>
              ))}

              {/* Color-coded pills */}
              <div
                style={{
                  padding: '8px 12px',
                  borderRadius: '5px',
                  background: 'rgba(29, 31, 42, 0.6)',
                  border: '1px solid rgba(255,255,255,0.06)',
                  marginBottom: '6px',
                }}
              >
                <div
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                    color: colors.textDim,
                    marginBottom: '6px',
                  }}
                >
                  Color-coded pills: gold = 1-align, purple = 2-learn, teal = 3-plan, green = 4-execute, ruby = 5-improve
                </div>
                <div style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}>
                  {workstreamColors.map((ws) => (
                    <span
                      key={ws.label}
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 700,
                        fontSize: 'clamp(0.38rem, 0.55vw, 0.5rem)',
                        color: ws.color,
                        background: `${ws.color}18`,
                        border: `1px solid ${ws.color}50`,
                        borderRadius: '3px',
                        padding: '2px 6px',
                        textTransform: 'uppercase',
                        letterSpacing: '0.04em',
                      }}
                    >
                      {ws.label}
                    </span>
                  ))}
                </div>
              </div>
            </div>

            {/* YOU DO */}
            <div>
              <div
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                  marginBottom: '10px',
                }}
              >
                YOU DO:
              </div>
              {[
                'Report per workstream: what\'s in-progress, what moved forward',
                'Highlight any version bumps or stage transitions',
                'Flag items with high DAYS STALE to the team',
              ].map((action, i) => (
                <div
                  key={i}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '8px',
                    marginBottom: '8px',
                  }}
                >
                  <div
                    style={{
                      width: '18px',
                      height: '18px',
                      borderRadius: '3px',
                      background: `${colors.gold}20`,
                      border: `1px solid ${colors.gold}50`,
                      flexShrink: 0,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      marginTop: '1px',
                    }}
                  >
                    <span style={{ fontSize: '8px', color: colors.gold, fontWeight: 700 }}>{i + 1}</span>
                  </div>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.52rem, 0.72vw, 0.65rem)',
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

          {/* RIGHT — 60% screenshot */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}
          >
            <div
              style={{
                width: '100%',
                borderRadius: '8px',
                overflow: 'hidden',
                border: `1px solid rgba(0, 106, 120, 0.35)`,
                boxShadow: `0 8px 32px rgba(0,0,0,0.5), 0 0 0 1px rgba(0, 106, 120, 0.1)`,
              }}
            >
              <img
                src="/screenshots/02-master-by-workstream.png"
                alt="Master Dashboard by Workstream"
                style={{
                  width: '100%',
                  height: 'auto',
                  display: 'block',
                  maxHeight: '55vh',
                  objectFit: 'cover',
                  objectPosition: 'top',
                }}
              />
            </div>
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
