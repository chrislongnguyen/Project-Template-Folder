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

const urgencyLevels = [
  { label: 'OK', threshold: '< 3d', color: colors.green },
  { label: 'ATTENTION', threshold: '3–7d', color: colors.gold },
  { label: 'OVERDUE', threshold: '> 7d', color: colors.ruby },
];

export default function ApprovalQueueSlide() {
  return (
    <SlideLayout>
      <WorkflowBar active="APPROVAL" />

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
          background: colors.ruby,
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
                color: colors.ruby,
                textTransform: 'uppercase',
                letterSpacing: '0.12em',
                display: 'block',
                marginBottom: '6px',
              }}
            >
              Dashboard 11 of 11 · Approval
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
              APPROVAL: YOUR REVIEW QUEUE
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.ruby, marginTop: '10px' }} />
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
              gap: '12px',
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
                { text: 'Items waiting for YOUR decision', accent: colors.ruby },
                { text: 'Shows all non-validated: draft, in-progress, and in-review', accent: colors.ruby },
              ].map((item, i) => (
                <div
                  key={i}
                  style={{
                    padding: '7px 12px',
                    borderRadius: '5px',
                    background: 'rgba(29, 31, 42, 0.6)',
                    border: `1px solid ${item.accent}30`,
                    marginBottom: '5px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
                      color: colors.text,
                    }}
                  >
                    {item.text}
                  </span>
                </div>
              ))}

              {/* Urgency levels */}
              <div style={{ display: 'flex', gap: '6px', marginTop: '6px' }}>
                {urgencyLevels.map((level) => (
                  <div
                    key={level.label}
                    style={{
                      flex: 1,
                      padding: '5px 8px',
                      borderRadius: '4px',
                      background: `${level.color}18`,
                      border: `1px solid ${level.color}50`,
                      textAlign: 'center',
                    }}
                  >
                    <span
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 700,
                        fontSize: 'clamp(0.42rem, 0.6vw, 0.54rem)',
                        color: level.color,
                        display: 'block',
                        textTransform: 'uppercase',
                      }}
                    >
                      {level.label}
                    </span>
                    <span
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)',
                        color: colors.textDim,
                      }}
                    >
                      {level.threshold}
                    </span>
                  </div>
                ))}
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
                'Open the file in Obsidian',
                'Read the content — does it meet acceptance criteria?',
                'To approve: switch to Source View (pencil icon) → find the status: line → change in-review to validated → save',
                'If NO: add a comment, leave as in-review, tell the agent what to fix',
              ].map((action, i) => (
                <div
                  key={i}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '8px',
                    marginBottom: '7px',
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

            {/* RACI callout */}
            <div
              style={{
                padding: '10px 14px',
                borderRadius: '5px',
                border: `2px solid ${colors.gold}60`,
                background: `${colors.gold}08`,
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.05em',
                  display: 'block',
                  marginBottom: '4px',
                }}
              >
                YOUR ROLE: ACCOUNTABLE
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 500,
                  fontSize: 'clamp(0.48rem, 0.68vw, 0.6rem)',
                  color: colors.text,
                  lineHeight: 1.5,
                }}
              >
                RACI (Responsible, Accountable, Consulted, Informed) — You are Accountable for approvals. ONLY YOU CAN APPROVE. Agents write, request review, and surface items. You are the gate.
              </span>
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
                border: `1px solid rgba(155, 24, 66, 0.35)`,
                boxShadow: `0 8px 32px rgba(0,0,0,0.5), 0 0 0 1px rgba(155, 24, 66, 0.15)`,
              }}
            >
              <img
                src="/screenshots/09-approval-all.png"
                alt="Approval Queue Dashboard"
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
