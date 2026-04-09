import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const steps = [
  {
    number: 1,
    title: 'Connect to Iteration 2 template',
    desc: '~1 min, one-time',
    code: 'git remote add template … && git fetch template main && git checkout template/main -- scripts/ .claude/skills/',
  },
  {
    number: 2,
    title: 'Run the audit',
    desc: '/template-check',
    code: 'Read-only scan → 5 buckets: auto_add · flagged:security · flagged:review · merge · unchanged',
  },
  {
    number: 3,
    title: 'Run the sync',
    desc: '/template-sync',
    code: '4 phases: AUTO-ADD → FLAGGED (you choose) → MERGE (K/T/D/M) → VERIFY (4 checks)',
  },
  {
    number: 4,
    title: 'Commit and verify',
    desc: 'You control staging',
    code: 'git status → git add <files> → git commit -m "feat: upgrade to Iteration 2 Efficient"',
  },
  {
    number: 5,
    title: 'Open Obsidian',
    desc: 'See your dashboards',
    code: 'File → Open Vault → project root → _genesis/obsidian/bases/C3-standup-preparation.base',
  },
];

export default function MigrationGuideSlide() {
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
          padding: '32px 64px 28px 72px',
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
              margin: '0 0 4px 0',
            }}
          >
            Migration in 10 Minutes
          </h1>
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.75rem, 1.1vw, 0.9rem)',
              color: colors.textDim,
              margin: '0 0 20px 0',
            }}
          >
            Iteration 1 → Iteration 2 upgrade — your AI agent handles every step
          </p>
        </AnimatedText>

        {/* Stacked step rows */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ display: 'flex', flexDirection: 'column', gap: '8px', flex: 1 }}
        >
          {steps.map((step) => (
            <motion.div
              key={step.number}
              variants={fadeInUp}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '16px',
                padding: '12px 20px',
                borderRadius: '8px',
                background: 'rgba(29,31,42,0.5)',
                border: '1px solid rgba(255,255,255,0.06)',
                flex: 1,
              }}
            >
              {/* Gold circle number */}
              <div
                style={{
                  width: '40px',
                  height: '40px',
                  borderRadius: '50%',
                  background: colors.gold,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  flexShrink: 0,
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: '1rem',
                    color: colors.midnight,
                  }}
                >
                  {step.number}
                </span>
              </div>

              {/* Title + description */}
              <div style={{ minWidth: '180px', flexShrink: 0 }}>
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.85rem, 1.2vw, 1rem)',
                    color: colors.text,
                    margin: 0,
                    lineHeight: 1.3,
                  }}
                >
                  {step.title}
                </p>
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.7rem, 0.95vw, 0.82rem)',
                    color: colors.textDim,
                    margin: '2px 0 0 0',
                  }}
                >
                  {step.desc}
                </p>
              </div>

              {/* Separator */}
              <div
                style={{
                  width: '1px',
                  alignSelf: 'stretch',
                  background: 'rgba(255,255,255,0.1)',
                  flexShrink: 0,
                }}
              />

              {/* Code / detail */}
              <p
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.7rem, 0.95vw, 0.82rem)',
                  color: `${colors.gold}cc`,
                  margin: 0,
                  lineHeight: 1.5,
                  flex: 1,
                }}
              >
                {step.code}
              </p>
            </motion.div>
          ))}
        </motion.div>

        {/* Key guarantees callout */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.8 }}
          style={{
            marginTop: '12px',
            border: `1px solid ${colors.gold}60`,
            borderRadius: '6px',
            padding: '10px 20px',
            background: `${colors.gold}0a`,
            display: 'flex',
            alignItems: 'center',
            gap: '14px',
          }}
        >
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.7rem, 0.95vw, 0.82rem)',
              color: colors.gold,
              flexShrink: 0,
            }}
          >
            KEY GUARANTEES
          </span>
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.7rem, 0.95vw, 0.82rem)',
              color: colors.textDim,
            }}
          >
            NEVER deletes &nbsp;&middot;&nbsp; NEVER overwrites &nbsp;&middot;&nbsp; NEVER auto-merges &nbsp;&middot;&nbsp; All decisions logged
          </span>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
