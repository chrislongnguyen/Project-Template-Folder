import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const stages = [
  {
    name: 'DESIGN',
    purpose: 'Define what to build',
    question: 'What artifacts, ACs, and alignment?',
    output: 'DESIGN.md (artifact inventory + ACs)',
    intensity: 0.15,
  },
  {
    name: 'SEQUENCE',
    purpose: 'Order the work',
    question: 'What order, dependencies, sizing?',
    output: 'SEQUENCE.md (ordered task list)',
    intensity: 0.25,
  },
  {
    name: 'BUILD',
    purpose: 'Produce artifacts',
    question: 'Does each artifact pass its AC?',
    output: 'Workstream artifacts per SEQUENCE.md',
    intensity: 0.35,
  },
  {
    name: 'VALIDATE',
    purpose: 'Verify against DESIGN',
    question: 'All criteria PASS with evidence?',
    output: 'VALIDATE.md (per-criterion verdicts)',
    intensity: 0.45,
  },
];

export default function FourStagesSlide() {
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
            FOUR PHASES — DSBV
          </h1>
        </AnimatedText>

        {/* Linear flow blocks */}
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
          {stages.map((stage, i) => (
            <div key={stage.name} style={{ display: 'flex', alignItems: 'center', gap: '12px', flex: 1 }}>
              <motion.div
                variants={fadeInUp}
                style={{
                  flex: 1,
                  background: `linear-gradient(180deg, rgba(0, 72, 81, ${stage.intensity}) 0%, rgba(0, 72, 81, ${stage.intensity * 0.3}) 100%)`,
                  border: '1px solid rgba(255, 255, 255, 0.08)',
                  borderRadius: '8px',
                  padding: '24px 18px',
                }}
              >
                {/* Stage name */}
                <h3
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.9rem, 1.5vw, 1.25rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.02em',
                    margin: '0 0 12px 0',
                  }}
                >
                  {stage.name}
                </h3>

                {/* Purpose */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                    color: colors.gold,
                    margin: '0 0 10px 0',
                    textTransform: 'uppercase',
                    letterSpacing: '0.03em',
                  }}
                >
                  {stage.purpose}
                </p>

                {/* Key question */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                    color: colors.textDim,
                    fontStyle: 'italic',
                    margin: '0 0 10px 0',
                    lineHeight: 1.4,
                  }}
                >
                  "{stage.question}"
                </p>

                {/* Output */}
                <div
                  style={{
                    borderTop: '1px solid rgba(255, 255, 255, 0.08)',
                    paddingTop: '8px',
                    marginTop: '8px',
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
                    OUTPUT
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
                    {stage.output}
                  </p>
                </div>
              </motion.div>

              {/* Arrow between blocks */}
              {i < stages.length - 1 && (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.875rem, 1.2vw, 1rem)',
                    color: colors.goldDim,
                    flexShrink: 0,
                  }}
                >
                  →
                </span>
              )}
            </div>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
