import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const mistakes = [
  {
    num: '01',
    mistake: 'SKIPPING LEARN ZONE',
    why: 'Building without UBS/UDS analysis means solving the wrong problem.',
    fix: 'Always run /learn pipeline before starting PLAN. Chain-of-custody enforces this.',
  },
  {
    num: '02',
    mistake: 'RUBBER-STAMPING VALIDATE',
    why: 'Validate catches upstream gaps. Skipping creates invisible debt.',
    fix: 'Treat every G4 gate as a real quality check. ltc-reviewer produces evidence-based verdicts.',
  },
  {
    num: '03',
    mistake: 'OVER-BUILDING FOR THE VERSION',
    why: 'I0 = no code. I1 = safety only. Over-building wastes effort.',
    fix: 'Check version depth matrix. Build only what the current iteration requires.',
  },
  {
    num: '04',
    mistake: 'IGNORING CHAIN-OF-CUSTODY',
    why: 'Zone N cannot build until Zone N-1 has validated artifacts.',
    fix: 'alpei-chain-of-custody rule checks automatically. If it warns, fix upstream first.',
  },
  {
    num: '05',
    mistake: 'SKIPPING DSBV PHASES',
    why: 'Building without DESIGN.md means no ACs. No VALIDATE = unchecked work.',
    fix: 'DSBV rule enforces: Design before Build, Validate before zone complete. No exceptions.',
  },
];

export default function MistakesSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '56px 80px 44px' }}>
        {/* Headline */}
        <AnimatedText>
          <h1 style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '-0.02em',
            margin: 0,
          }}>
            COMMON MISTAKES TO AVOID
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.ruby, marginTop: '10px' }} />
        </AnimatedText>

        {/* Mistake cards - stacked */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}
          >
            {mistakes.map((m) => (
              <motion.div
                key={m.num}
                variants={fadeInUp}
                style={{
                  display: 'grid',
                  gridTemplateColumns: '48px 1fr 1.2fr 1.2fr',
                  gap: '16px',
                  alignItems: 'center',
                  padding: '10px 14px',
                  borderLeft: `3px solid ${colors.ruby}`,
                }}
              >
                {/* Number */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 900,
                  fontSize: 'clamp(1.2rem, 2vw, 1.6rem)',
                  color: colors.gold,
                  opacity: 0.3,
                  lineHeight: 1,
                }}>
                  {m.num}
                </div>

                {/* Mistake */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
                  color: colors.text,
                  textTransform: 'uppercase',
                  letterSpacing: '0.04em',
                  lineHeight: 1.3,
                }}>
                  {m.mistake}
                </div>

                {/* Why it's bad */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                  color: colors.textDim,
                  lineHeight: 1.4,
                }}>
                  {m.why}
                </div>

                {/* What to do instead */}
                <div style={{
                  borderLeft: `2px solid #69994D`,
                  paddingLeft: '10px',
                }}>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                    color: '#69994D',
                    lineHeight: 1.4,
                  }}>
                    {m.fix}
                  </div>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Bottom note */}
        <AnimatedText delay={0.7}>
          <div style={{
            borderLeft: `3px solid ${colors.gold}`,
            padding: '8px 0 8px 14px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
              color: colors.textDim,
              margin: 0,
              lineHeight: 1.5,
            }}>
              The framework exists to prevent these mistakes. When the AI warns you, it is enforcing guardrails — not being difficult.
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
