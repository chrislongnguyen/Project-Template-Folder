import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const steps = [
  { num: '01', title: 'CLONE THE TEMPLATE', action: 'Clone the LTC Project Template repo', how: 'git clone → rename → open in your IDE', time: '2 min' },
  { num: '02', title: 'RUN TEMPLATE CHECK', action: 'Verify all workstreams and configs are in place', how: './scripts/template-check.sh --quiet', time: '1 min' },
  { num: '03', title: 'START CLAUDE CODE', action: 'Launch Claude Code in the repo root', how: 'Run: claude   — reads CLAUDE.md, loads rules', time: '1 min' },
  { num: '04', title: 'CHECK DSBV STATUS', action: 'See where every workstream stands', how: '/dsbv status — shows workstream × phase progress', time: '2 min' },
  { num: '05', title: 'START ALIGN', action: 'Begin your first DSBV cycle', how: '/dsbv design align — pre-flight → DESIGN.md', time: '5 min' },
];

export default function QuickstartSlide() {
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
            YOUR FIRST DAY — QUICKSTART
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        {/* 5 steps */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}
          >
            {steps.map((step, i) => (
              <motion.div
                key={step.num}
                variants={fadeInUp}
                style={{
                  display: 'grid',
                  gridTemplateColumns: '56px 1fr 1fr 60px',
                  gap: '16px',
                  alignItems: 'center',
                  padding: '12px 16px',
                  borderLeft: `3px solid ${colors.gold}`,
                  background: i % 2 === 0 ? 'rgba(255,255,255,0.02)' : 'transparent',
                }}
              >
                {/* Number */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 900,
                  fontSize: 'clamp(1.2rem, 2vw, 1.6rem)',
                  color: colors.gold,
                  opacity: 0.25,
                  lineHeight: 1,
                }}>
                  {step.num}
                </div>

                {/* Title + Action */}
                <div>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    marginBottom: '3px',
                  }}>
                    {step.title}
                  </div>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.62vw, 0.54rem)',
                    color: colors.textDim,
                    lineHeight: 1.4,
                  }}>
                    {step.action}
                  </div>
                </div>

                {/* How */}
                <div style={{
                  fontFamily: 'monospace',
                  fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                  color: colors.gold,
                  lineHeight: 1.4,
                  opacity: 0.8,
                }}>
                  {step.how}
                </div>

                {/* Time */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                  color: colors.text,
                  textAlign: 'right',
                  opacity: 0.6,
                }}>
                  {step.time}
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Total time + tagline */}
        <AnimatedText delay={0.7}>
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'flex-end',
            borderTop: `1px solid ${colors.gold}22`,
            paddingTop: '14px',
          }}>
            <div style={{
              borderLeft: `3px solid ${colors.gold}`,
              paddingLeft: '14px',
            }}>
              <p style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                color: colors.textDim,
                margin: 0,
                lineHeight: 1.5,
              }}>
                The AI knows the framework. Your job: <span style={{ color: colors.text, fontWeight: 600 }}>direct</span>, <span style={{ color: colors.text, fontWeight: 600 }}>review</span>, <span style={{ color: colors.text, fontWeight: 600 }}>approve</span>.
              </p>
            </div>
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.04em',
            }}>
              ~11 MINUTES
            </div>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
