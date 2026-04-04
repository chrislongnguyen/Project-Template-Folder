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

const subSystems = [
  { label: '1-PD', name: 'Principles & Design', color: colors.gold },
  { label: '2-DP', name: 'Decision Process', color: colors.midnightLight },
  { label: '3-DA', name: 'Data & Analytics', color: colors.green },
  { label: '4-IDM', name: 'Insights & Decision Making', color: colors.purple },
];

export default function EodVersionSlide() {
  return (
    <SlideLayout>
      <WorkflowBar active="EOD" />

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
          background: colors.goldDim,
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
                color: colors.goldDim,
                textTransform: 'uppercase',
                letterSpacing: '0.12em',
                display: 'block',
                marginBottom: '6px',
              }}
            >
              Dashboard 10 of 11 · End of Day
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
              END OF DAY: VERSION PROGRESS
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.gold, marginTop: '10px' }} />
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
                { text: 'Are we advancing through iterations?', accent: colors.goldDim },
                { text: 'DAYS AT VERSION: how long since the last version bump', accent: colors.goldDim },
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

              {/* Sub-systems */}
              <div
                style={{
                  padding: '10px 12px',
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
                    marginBottom: '8px',
                  }}
                >
                  Grouped by sub-system:
                </div>
                <div style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}>
                  {subSystems.map((ss) => (
                    <div
                      key={ss.label}
                      style={{
                        padding: '4px 8px',
                        borderRadius: '3px',
                        background: `${ss.color}18`,
                        border: `1px solid ${ss.color}50`,
                      }}
                    >
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: 700,
                          fontSize: 'clamp(0.42rem, 0.6vw, 0.54rem)',
                          color: ss.color,
                          textTransform: 'uppercase',
                          display: 'block',
                        }}
                      >
                        {ss.label}
                      </span>
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: 400,
                          fontSize: 'clamp(0.36rem, 0.52vw, 0.46rem)',
                          color: colors.textDim,
                        }}
                      >
                        {ss.name}
                      </span>
                    </div>
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
                'Check if any sub-system is stuck at the same version too long',
                'End of day reflection: did I advance at least 1 item today?',
                'In terminal: /git-save to commit your progress',
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
                border: `1px solid rgba(242, 199, 92, 0.25)`,
                boxShadow: `0 8px 32px rgba(0,0,0,0.5), 0 0 0 1px rgba(242, 199, 92, 0.1)`,
              }}
            >
              <img
                src="/screenshots/12-version-progress.png"
                alt="Version Progress Dashboard"
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
