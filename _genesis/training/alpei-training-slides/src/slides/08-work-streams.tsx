import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, scaleIn, staggerContainer } from '../lib/animations';

const streams = [
  { num: '01', name: 'ALIGN', question: 'What are we doing and why?' },
  { num: '02', name: 'LEARN', question: 'What do we need to know?' },
  { num: '03', name: 'PLAN', question: 'How will we do it?' },
  { num: '04', name: 'EXECUTE', question: 'Build and deliver it.' },
  { num: '05', name: 'IMPROVE', question: 'How do we do it better?' },
];

export default function WorkStreamsSlide() {
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
              margin: '0 0 40px 0',
            }}
          >
            FIVE WORK STREAMS
          </h1>
        </AnimatedText>

        {/* Circular flow diagram */}
        <motion.div
          variants={scaleIn}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '12px',
            marginBottom: '48px',
          }}
        >
          {streams.map((s, i) => (
            <div key={s.name} style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
              <div
                style={{
                  border: `2px solid ${colors.gold}`,
                  borderRadius: '8px',
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
                  color: colors.text,
                  textAlign: 'center',
                  minWidth: '90px',
                  padding: '10px 16px',
                }}
              >
                {s.name}
              </div>
              {i < streams.length - 1 ? (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.875rem, 1.2vw, 1rem)',
                    color: colors.gold,
                  }}
                >
                  →
                </span>
              ) : (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.65rem, 0.9vw, 0.75rem)',
                    color: colors.goldDim,
                    fontStyle: 'italic',
                    marginLeft: '4px',
                  }}
                >
                  ↻
                </span>
              )}
            </div>
          ))}
        </motion.div>

        {/* Horizontal strip - descriptions */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            gap: '0',
          }}
        >
          {streams.map((s, i) => (
            <motion.div
              key={s.name}
              variants={fadeInUp}
              style={{
                flex: 1,
                borderLeft: i === 0 ? 'none' : '1px solid rgba(255, 255, 255, 0.06)',
                paddingLeft: i === 0 ? '0' : '16px',
                paddingRight: '16px',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.85rem, 1.4vw, 1.1rem)',
                  color: colors.gold,
                  display: 'block',
                  marginBottom: '4px',
                }}
              >
                {s.num}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
                  color: colors.text,
                  textTransform: 'uppercase',
                  letterSpacing: '0.03em',
                  display: 'block',
                  marginBottom: '6px',
                }}
              >
                {s.name}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                  color: colors.textDim,
                  lineHeight: 1.4,
                }}
              >
                {s.question}
              </span>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
