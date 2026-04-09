import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

const rows = [
  {
    before: 'Files in folders',
    after: 'Files + metadata → live dashboards',
  },
  {
    before: 'Status in your head',
    after: 'Status in frontmatter → auto-tracked',
  },
  {
    before: '"What changed?" = git log',
    after: '"What changed?" = open C3 dashboard',
  },
  {
    before: 'Blockers found in standup',
    after: 'Blockers auto-detected by staleness',
  },
  {
    before: 'Knowledge in scattered notes',
    after: 'Knowledge captured → distilled → wiki',
  },
  {
    before: 'Agent writes files',
    after: 'Agent writes + updates dashboards',
  },
  {
    before: 'You check folders manually',
    after: 'Dashboards surface what needs attention',
  },
  {
    before: 'Category-based dirs (charter/)',
    after: 'Subsystem dirs planned (1-PD/, 2-DP/)',
  },
  {
    before: 'Brainstorming = blank page',
    after: '/ltc-brainstorming = 4 structured gates',
  },
  {
    before: 'No migration tooling',
    after: '/template-check + /template-sync',
  },
];

export default function BeforeAfterSlide() {
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
          justifyContent: 'center',
          height: '100%',
          padding: '36px 80px 36px 100px',
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.2rem, 2.5vw, 1.9rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 6px 0',
            }}
          >
            BEFORE & AFTER
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

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
          {/* Iteration 1 column */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
          >
            {/* Column header */}
            <div
              style={{
                padding: '8px 16px',
                marginBottom: '8px',
                borderRadius: '4px',
                background: 'rgba(29, 31, 42, 0.7)',
                border: '1px solid rgba(255,255,255,0.08)',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.6rem, 0.88vw, 0.75rem)',
                  color: colors.muted,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                }}
              >
                Iteration 1 — Sustainable
              </span>
            </div>

            {rows.map((row, i) => (
              <div
                key={i}
                style={{
                  padding: '8px 14px',
                  marginBottom: '4px',
                  borderRadius: '4px',
                  background: 'rgba(29, 31, 42, 0.3)',
                  border: '1px solid rgba(255,255,255,0.04)',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.muted,
                    lineHeight: 1.4,
                    opacity: 0.75,
                  }}
                >
                  {row.before}
                </span>
              </div>
            ))}
          </motion.div>

          {/* Iteration 2 column */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
          >
            {/* Column header */}
            <div
              style={{
                padding: '8px 16px',
                marginBottom: '8px',
                borderRadius: '4px',
                background: `rgba(0, 72, 81, 0.4)`,
                border: `1px solid rgba(242, 199, 92, 0.2)`,
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.6rem, 0.88vw, 0.75rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                }}
              >
                Iteration 2 — Efficient
              </span>
            </div>

            {rows.map((row, i) => (
              <div
                key={i}
                style={{
                  padding: '8px 14px',
                  marginBottom: '4px',
                  borderRadius: '4px',
                  background: 'rgba(0, 72, 81, 0.15)',
                  border: '1px solid rgba(242, 199, 92, 0.08)',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 500,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.text,
                    lineHeight: 1.4,
                  }}
                >
                  {row.after}
                </span>
              </div>
            ))}
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
