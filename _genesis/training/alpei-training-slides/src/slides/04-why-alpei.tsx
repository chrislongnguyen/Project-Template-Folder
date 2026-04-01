import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const problems = [
  'Ad-hoc processes create inconsistent results across projects',
  'No audit trail makes it impossible to learn from failures',
  'AI potential wasted on unstructured, one-off prompting',
];

const benefits = [
  { title: 'CONSISTENCY', desc: 'Every project follows the same proven framework' },
  { title: 'AUDITABILITY', desc: 'Full chain-of-custody from scope to delivery' },
  { title: 'AI LEVERAGE', desc: 'Agents execute within structured guardrails' },
  { title: 'CONTINUOUS IMPROVEMENT', desc: 'Every iteration builds on validated learnings' },
];

export default function WhyAlpeiSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          height: '100%',
        }}
      >
        {/* LEFT PANEL - 40% - The Problem */}
        <motion.div
          variants={fadeInLeft}
          initial="hidden"
          animate="show"
          style={{
            width: '40%',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            padding: '60px 48px 60px 80px',
            borderRight: '1px solid rgba(255, 255, 255, 0.06)',
          }}
        >
          <h2
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1rem, 2vw, 1.5rem)',
              color: colors.ruby,
              textTransform: 'uppercase',
              letterSpacing: '0.05em',
              marginBottom: '32px',
            }}
          >
            THE PROBLEM
          </h2>

          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}
          >
            {problems.map((p, i) => (
              <motion.div
                key={i}
                variants={fadeInUp}
                style={{
                  borderLeft: `3px solid ${colors.ruby}`,
                  paddingLeft: '16px',
                }}
              >
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.75rem, 1.2vw, 0.9rem)',
                    color: colors.textDim,
                    lineHeight: 1.5,
                    margin: 0,
                  }}
                >
                  {p}
                </p>
              </motion.div>
            ))}
          </motion.div>
        </motion.div>

        {/* RIGHT PANEL - 60% - The Solution */}
        <motion.div
          variants={fadeInRight}
          initial="hidden"
          animate="show"
          style={{
            width: '60%',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            padding: '60px 80px 60px 48px',
          }}
        >
          <h2
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1rem, 2vw, 1.5rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.05em',
              marginBottom: '16px',
            }}
          >
            THE SOLUTION
          </h2>

          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.75rem, 1.1vw, 0.875rem)',
              color: colors.textDim,
              lineHeight: 1.6,
              marginBottom: '32px',
              maxWidth: '480px',
            }}
          >
            ALPEI is a complete operating system that structures every project
            through five concurrent work streams, four stages, and four sub-systems
            — giving AI agents clear guardrails and humans full visibility.
          </p>

          {/* 2x2 Benefit grid */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '16px',
            }}
          >
            {benefits.map((b) => (
              <motion.div
                key={b.title}
                variants={fadeInUp}
                style={{
                  borderLeft: `3px solid ${colors.gold}`,
                  paddingLeft: '14px',
                }}
              >
                <h3
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.7rem, 1vw, 0.8rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    margin: '0 0 4px 0',
                  }}
                >
                  {b.title}
                </h3>
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.65rem, 0.9vw, 0.8rem)',
                    color: colors.textDim,
                    lineHeight: 1.4,
                    margin: 0,
                  }}
                >
                  {b.desc}
                </p>
              </motion.div>
            ))}
          </motion.div>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
