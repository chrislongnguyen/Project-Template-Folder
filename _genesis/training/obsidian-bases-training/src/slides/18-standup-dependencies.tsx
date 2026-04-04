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

const chainSteps = [
  { label: 'ALIGN', color: colors.gold },
  { label: 'LEARN', color: colors.purple },
  { label: 'PLAN', color: colors.midnightLight },
  { label: 'EXECUTE', color: colors.green },
  { label: 'IMPROVE', color: colors.ruby },
];

export default function StandupDependenciesSlide() {
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
              Dashboard 4 of 11 · Standup
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
              STANDUP: DEPENDENCY TRACKER
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

              {/* Chain-of-custody flow */}
              <div
                style={{
                  padding: '10px 12px',
                  borderRadius: '5px',
                  background: 'rgba(29, 31, 42, 0.6)',
                  border: '1px solid rgba(255,255,255,0.06)',
                  marginBottom: '8px',
                }}
              >
                <div
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                    color: colors.textDim,
                    marginBottom: '8px',
                  }}
                >
                  Cross-workstream view:
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '4px', flexWrap: 'wrap' }}>
                  {chainSteps.map((step, i) => (
                    <div key={step.label} style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: 700,
                          fontSize: 'clamp(0.38rem, 0.55vw, 0.5rem)',
                          color: step.color,
                          background: `${step.color}18`,
                          border: `1px solid ${step.color}50`,
                          borderRadius: '3px',
                          padding: '2px 5px',
                          textTransform: 'uppercase',
                        }}
                      >
                        {step.label}
                      </span>
                      {i < chainSteps.length - 1 && (
                        <span style={{ color: colors.muted, fontSize: '10px' }}>→</span>
                      )}
                    </div>
                  ))}
                </div>
              </div>

              {[
                {
                  text: 'DEP STATUS formula flags upstream issues automatically',
                  accent: colors.midnightLight,
                },
                {
                  text: 'If LEARN isn\'t done, PLAN can\'t advance — this catches it',
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
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
                      color: colors.text,
                      lineHeight: 1.5,
                    }}
                  >
                    {item.text}
                  </span>
                </div>
              ))}
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
                'Look for CHECK UPSTREAM or STALE status',
                'If upstream is blocked: raise in standup as a dependency issue',
                'Chain of custody: ensure workstreams flow in order',
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
                src="/screenshots/09-dependency-pipeline.png"
                alt="Dependency Tracker"
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
