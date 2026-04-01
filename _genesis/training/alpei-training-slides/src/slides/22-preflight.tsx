import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const checks = [
  { num: 1, name: 'CHECK WORKSTREAM', ensures: 'Which ALPEI workstream is this task in? Run /dsbv status to see progress.' },
  { num: 2, name: 'CHECK ALIGNMENT', ensures: 'Read 1-ALIGN/charter/ — understand EO, stakeholders, success criteria.' },
  { num: 3, name: 'CHECK RISKS', ensures: 'Read 3-PLAN/risks/UBS_REGISTER.md — what can go wrong?' },
  { num: 4, name: 'CHECK DRIVERS', ensures: 'Read 3-PLAN/drivers/UDS_REGISTER.md — what forces to leverage.' },
  { num: 5, name: 'CHECK TEMPLATES', ensures: 'Identify which templates apply from ALPEI_DSBV_PROCESS_MAP.md.' },
  { num: 6, name: 'CHECK LEARNING', ensures: "Scan 2-LEARN/ — prior research, specs. Don't reinvent." },
  { num: 7, name: 'VERSION CONSISTENCY', ensures: 'Workstream versions consistent with DSBV phase. No regressions.' },
];

export default function PreflightSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '60px 80px 44px' }}>
        {/* Headline */}
        <AnimatedText>
          <h1 style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1.75rem, 3.5vw, 2.75rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '-0.02em',
            margin: 0,
          }}>
            PRE-FLIGHT PROTOCOL
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Checks */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(2, 1fr)',
              gap: '14px 40px',
              width: '100%',
            }}
          >
            {checks.map((check) => (
              <motion.div
                key={check.num}
                variants={fadeInUp}
                style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '16px',
                }}
              >
                {/* Large number */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 900,
                  fontSize: 'clamp(1.5rem, 3vw, 2.5rem)',
                  lineHeight: 1,
                  color: colors.gold,
                  opacity: 0.25,
                  flexShrink: 0,
                  width: '40px',
                  textAlign: 'center',
                }}>
                  {check.num}
                </div>

                <div style={{ paddingTop: '4px' }}>
                  {/* Check name */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                    marginBottom: '4px',
                  }}>
                    {check.name}
                  </div>

                  {/* What it ensures */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    lineHeight: 1.4,
                    maxWidth: '340px',
                  }}>
                    {check.ensures}
                  </div>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Note */}
        <AnimatedText delay={0.7}>
          <div style={{
            borderLeft: `3px solid ${colors.midnightLight}`,
            padding: '10px 0 10px 20px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.55rem, 0.85vw, 0.75rem)',
              color: colors.textDim,
              margin: 0,
            }}>
              AI runs pre-flight automatically. If a check fails, AI suggests a fix — <span style={{ color: colors.gold, fontWeight: 600 }}>you decide whether to proceed or correct</span>.
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
