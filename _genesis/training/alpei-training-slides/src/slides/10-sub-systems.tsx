import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const subsystems = [
  {
    abbr: 'PD',
    name: 'Problem Diagnosis',
    purpose: 'Identify root blockers and drivers',
    output: 'Effective Principles (EP)',
    isSource: true,
  },
  {
    abbr: 'DP',
    name: 'Data Pipeline',
    purpose: 'Build reliable data flows',
    output: 'Analysis-ready datasets',
    isSource: false,
  },
  {
    abbr: 'DA',
    name: 'Data Analysis',
    purpose: 'Extract validated insights',
    output: 'Validated analytical findings',
    isSource: false,
  },
  {
    abbr: 'IDM',
    name: 'Insights & Decision Making',
    purpose: 'Drive informed decisions',
    output: 'Actionable recommendations',
    isSource: false,
  },
];

export default function SubSystemsSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '48px 80px',
        }}
      >
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 48px 0',
            }}
          >
            FOUR SUB-SYSTEMS
          </h1>
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
                  border: '1px solid rgba(255, 255, 255, 0.08)',
                  borderTop: ss.isSource ? `3px solid ${colors.gold}` : '1px solid rgba(255, 255, 255, 0.08)',
                  borderRadius: '8px',
                  display: 'flex',
                  flexDirection: 'column',
                  padding: '24px 18px',
                }}
              >
                {/* Abbreviation */}
                <h2
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(1.75rem, 3.5vw, 2.5rem)',
                    color: ss.isSource ? colors.gold : colors.text,
                    margin: '0 0 6px 0',
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
                    fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
                    color: colors.textDim,
                    margin: '0 0 14px 0',
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
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                    color: colors.textDim,
                    lineHeight: 1.5,
                    margin: '0 0 16px 0',
                    flex: 1,
                  }}
                >
                  {ss.purpose}
                </p>

                {/* Output */}
                <div
                  style={{
                    borderTop: '1px solid rgba(255, 255, 255, 0.08)',
                    paddingTop: '10px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.5rem, 0.65vw, 0.6rem)',
                      color: colors.muted,
                      textTransform: 'uppercase',
                      letterSpacing: '0.05em',
                    }}
                  >
                    PRIMARY OUTPUT
                  </span>
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
                      color: colors.text,
                      margin: '4px 0 0 0',
                    }}
                  >
                    {ss.output}
                  </p>
                </div>
              </motion.div>

              {/* Gold arrow between cards */}
              {i < subsystems.length - 1 && (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.875rem, 1.2vw, 1rem)',
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

        {/* Critical rule callout */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7, duration: 0.5 }}
          style={{
            marginTop: '36px',
            borderLeft: `3px solid ${colors.gold}`,
            paddingLeft: '16px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.65rem, 1vw, 0.85rem)',
              color: colors.gold,
              margin: 0,
              fontStyle: 'italic',
            }}
          >
            Every LTC member works through all 4 sub-systems. Each sub-system follows the full ALPEI flow (5 workstreams × 4 DSBV phases) across 5 iterations (I0–I4). PD sets the version ceiling for all downstream sub-systems.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
