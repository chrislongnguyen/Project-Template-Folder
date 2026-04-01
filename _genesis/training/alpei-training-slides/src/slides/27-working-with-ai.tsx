import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const goodExamples = [
  'Run /learn:input pd and document UBS for our data pipeline sub-system',
  'Create a task breakdown for iteration 3 with RACI assignments using the Plan template',
  'Audit all Execute deliverables and flag any missing chain-of-custody links',
];

const badExamples = [
  'Do the ALPEI stuff',
  'Make it better',
  'Fix the project',
];

const pushBackRows = [
  ['Missing upstream deliverables', 'Chain-of-custody is satisfied'],
  ['Version level mismatch', 'VANA criteria are clearly defined'],
  ['No UBS/UDS analysis exists', 'Effective principles are documented'],
  ['Vague or ambiguous scope', 'Specific commands and context given'],
  ['Skips DSBV gates', 'Follows Design → Sequence → Build → Validate'],
];

export default function WorkingWithAiSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '44px 80px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.3rem, 2.5vw, 2rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              marginBottom: '24px',
            }}
          >
            WORKING WITH YOUR AI AGENT
          </h1>
        </AnimatedText>

        {/* Two-panel split */}
        <div
          style={{
            display: 'flex',
            gap: '40px',
            marginBottom: '24px',
          }}
        >
          {/* LEFT: Good Instructions */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ flex: 1 }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.65rem, 1vw, 0.85rem)',
                color: '#69994D',
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
                marginBottom: '14px',
                display: 'block',
              }}
            >
              GOOD INSTRUCTIONS
            </span>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {goodExamples.map((ex, i) => (
                <div
                  key={i}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '10px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
                      color: '#69994D',
                      flexShrink: 0,
                      marginTop: '1px',
                    }}
                  >
                    &#10003;
                  </span>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.8vw, 0.7rem)',
                      color: colors.text,
                      lineHeight: 1.5,
                    }}
                  >
                    {ex}
                  </span>
                </div>
              ))}
            </div>
          </motion.div>

          {/* RIGHT: Bad Instructions */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ flex: 1 }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.65rem, 1vw, 0.85rem)',
                color: colors.ruby,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
                marginBottom: '14px',
                display: 'block',
              }}
            >
              BAD INSTRUCTIONS
            </span>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {badExamples.map((ex, i) => (
                <div
                  key={i}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '10px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
                      color: colors.ruby,
                      flexShrink: 0,
                      marginTop: '1px',
                    }}
                  >
                    &#10007;
                  </span>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.8vw, 0.7rem)',
                      color: colors.text,
                      lineHeight: 1.5,
                    }}
                  >
                    {ex}
                  </span>
                </div>
              ))}
            </div>
          </motion.div>
        </div>

        {/* Push-back criteria table */}
        <AnimatedText delay={0.4}>
          <div>
            {/* Table header */}
            <div
              style={{
                display: 'flex',
                borderBottom: `2px solid ${colors.gold}33`,
                padding: '8px 0',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                  color: colors.ruby,
                  textTransform: 'uppercase',
                  letterSpacing: '0.05em',
                  flex: 1,
                }}
              >
                PUSH BACK WHEN
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                  color: '#69994D',
                  textTransform: 'uppercase',
                  letterSpacing: '0.05em',
                  flex: 1,
                }}
              >
                APPROVE WHEN
              </span>
            </div>

            {/* Table rows */}
            {pushBackRows.map((row, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  borderBottom: i < pushBackRows.length - 1 ? `1px solid ${colors.midnight}22` : 'none',
                  padding: '6px 0',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.48rem, 0.72vw, 0.62rem)',
                    color: colors.text,
                    flex: 1,
                    lineHeight: 1.4,
                  }}
                >
                  {row[0]}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.48rem, 0.72vw, 0.62rem)',
                    color: colors.textDim,
                    flex: 1,
                    lineHeight: 1.4,
                  }}
                >
                  {row[1]}
                </span>
              </div>
            ))}
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
