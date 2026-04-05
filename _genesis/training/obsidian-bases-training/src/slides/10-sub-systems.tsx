import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const subsystems = [
  {
    abbr: '1-PD',
    name: 'Problem Diagnosis',
    purpose: 'Define the problem — root causes, drivers, constraints',
    examples: ['Charter', 'Risk models', 'UBS register'],
    accent: colors.gold,
  },
  {
    abbr: '2-DP',
    name: 'Data Pipeline',
    purpose: 'Build the data flow — collection, transformation, storage',
    examples: ['Data pipeline spec', 'API integration doc'],
    accent: colors.midnightLight,
  },
  {
    abbr: '3-DA',
    name: 'Data Analysis',
    purpose: 'Analyze & visualize — patterns, findings, dashboards',
    examples: ['Visualization spec', 'Analysis report'],
    accent: colors.green,
  },
  {
    abbr: '4-IDM',
    name: 'Insights & Decision Making',
    purpose: 'Decide & report — metrics, recommendations, retrospectives',
    examples: ['Metrics baseline', 'Retrospectives'],
    accent: colors.ruby,
  },
];

export default function SubSystemsSlide() {
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
          padding: '48px 80px',
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
            THE 4 SUB-SYSTEMS
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '32px',
            }}
          />
        </AnimatedText>

        {/* Cards row */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            gap: '12px',
            alignItems: 'stretch',
          }}
        >
          {subsystems.map((ss, i) => (
            <div key={ss.abbr} style={{ display: 'flex', alignItems: 'center', gap: '12px', flex: 1 }}>
              <motion.div
                variants={fadeInUp}
                style={{
                  flex: 1,
                  border: '1px solid rgba(255,255,255,0.08)',
                  borderTop: `3px solid ${ss.accent}`,
                  borderRadius: '8px',
                  display: 'flex',
                  flexDirection: 'column',
                  padding: '20px 16px',
                  background: `${ss.accent}06`,
                }}
              >
                {/* Abbreviation */}
                <h2
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
                    color: ss.accent,
                    margin: '0 0 4px 0',
                    letterSpacing: '-0.02em',
                  }}
                >
                  {ss.abbr}
                </h2>

                {/* Full name */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                    color: colors.textDim,
                    margin: '0 0 10px 0',
                    textTransform: 'uppercase',
                    letterSpacing: '0.03em',
                  }}
                >
                  {ss.name}
                </p>

                {/* Purpose */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                    color: colors.text,
                    lineHeight: 1.5,
                    margin: '0 0 14px 0',
                    flex: 1,
                  }}
                >
                  {ss.purpose}
                </p>

                {/* Example deliverables */}
                <div
                  style={{
                    borderTop: '1px solid rgba(255,255,255,0.08)',
                    paddingTop: '10px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.45rem, 0.6vw, 0.55rem)',
                      color: colors.muted,
                      textTransform: 'uppercase',
                      letterSpacing: '0.05em',
                      display: 'block',
                      marginBottom: '6px',
                    }}
                  >
                    EXAMPLE DELIVERABLES
                  </span>
                  {ss.examples.map((ex) => (
                    <p
                      key={ex}
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
                        color: colors.text,
                        margin: '2px 0',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '6px',
                      }}
                    >
                      <span style={{ color: ss.accent, fontSize: '0.5em' }}>■</span>
                      {ex}
                    </p>
                  ))}
                </div>
              </motion.div>

              {/* Arrow between cards */}
              {i < subsystems.length - 1 && (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.75rem, 1vw, 0.875rem)',
                    color: colors.gold,
                    flexShrink: 0,
                  }}
                >
                  →
                </span>
              )}
            </div>
          ))}
        </motion.div>

        {/* Bottom note */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7, duration: 0.5 }}
          style={{
            marginTop: '28px',
            borderLeft: `3px solid ${colors.gold}`,
            paddingLeft: '14px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
              color: colors.textDim,
              margin: 0,
              fontStyle: 'italic',
            }}
          >
            Every deliverable has a <span style={{ color: colors.gold, fontStyle: 'normal', fontWeight: 600 }}>sub_system</span> field. Dashboards group by sub-system to show you which part of the problem you're working on.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
