import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const levels = [
  {
    label: 'L1 — KNOWLEDGE',
    meta: '4 questions — required for ALL pages',
    accentColor: colors.muted,
    questions: ['So What? (relevance)', 'What Is It?', 'What Else?', 'How Does It Work?'],
    indent: 0,
  },
  {
    label: 'L2 — UNDERSTANDING',
    meta: '2 more — MANDATORY minimum = 6/12',
    accentColor: colors.gold,
    questions: ['Why Does It Work?', 'Why Not?'],
    indent: 1,
  },
  {
    label: 'L3 — WISDOM',
    meta: '2 more — core skill pages = 8/12',
    accentColor: colors.green,
    questions: ['So What? (benefit)', 'Now What?'],
    indent: 2,
  },
  {
    label: 'L4 — EXPERTISE',
    meta: '4 more — architecture decisions = 12/12',
    accentColor: colors.ruby,
    questions: ['What Is It NOT?', 'How Not?', 'What If?', 'Now What? (better than others)'],
    indent: 3,
  },
];

export default function LearningHierarchySlide() {
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
          padding: '36px 80px',
          gap: '14px',
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
            THE 12-QUESTION LEARNING HIERARCHY
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '14px' }} />
        </AnimatedText>

        {/* Hierarchy tiers */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}
        >
          {levels.map((level) => (
            <motion.div
              key={level.label}
              variants={fadeInUp}
              style={{
                marginLeft: `${level.indent * 28}px`,
                background: 'rgba(29,31,42,0.5)',
                border: '1px solid rgba(255,255,255,0.06)',
                borderLeft: `4px solid ${level.accentColor}`,
                borderRadius: '0 6px 6px 0',
                padding: '12px 18px',
                display: 'flex',
                flexDirection: 'column',
                gap: '8px',
              }}
            >
              {/* Level label + meta */}
              <div style={{ display: 'flex', alignItems: 'baseline', gap: '12px', flexWrap: 'wrap' }}>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.65rem, 0.9vw, 0.8rem)',
                    color: level.accentColor,
                    textTransform: 'uppercase',
                    letterSpacing: '-0.01em',
                  }}
                >
                  {level.label}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.5rem, 0.65vw, 0.58rem)',
                    color: colors.textDim,
                    fontStyle: 'italic',
                  }}
                >
                  {level.meta}
                </span>
              </div>

              {/* Question pills */}
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
                {level.questions.map((q) => (
                  <span
                    key={q}
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontSize: 'clamp(0.48rem, 0.62vw, 0.56rem)',
                      color: level.accentColor,
                      background: `${level.accentColor}14`,
                      border: `1px solid ${level.accentColor}30`,
                      borderRadius: '4px',
                      padding: '2px 8px',
                      fontWeight: 500,
                    }}
                  >
                    {q}
                  </span>
                ))}
              </div>
            </motion.div>
          ))}
        </motion.div>

        {/* Gold callout */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.75, duration: 0.5 }}
          style={{
            background: 'rgba(242,199,92,0.08)',
            border: '1px solid rgba(242,199,92,0.25)',
            borderLeft: `4px solid ${colors.gold}`,
            borderRadius: '6px',
            padding: '10px 18px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.58rem, 0.78vw, 0.68rem)',
              color: colors.text,
              margin: 0,
              lineHeight: 1.6,
            }}
          >
            Level is never declared, always derived from how many questions are answered.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
