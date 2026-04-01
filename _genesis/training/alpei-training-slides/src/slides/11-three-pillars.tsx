import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const pillars = [
  {
    num: '#1',
    name: 'SUSTAINABILITY',
    question: 'Is it correct? Is it safe?',
    focus: 'Correctness, safety, graceful failure',
    color: colors.midnight,
    borderColor: colors.midnightLight,
    size: 'clamp(1.5rem, 2.8vw, 2.25rem)',
    barWidth: '100%',
  },
  {
    num: '#2',
    name: 'EFFICIENCY',
    question: 'Is it productive?',
    focus: 'Time savings, resource optimization',
    color: colors.gold,
    borderColor: colors.goldDim,
    size: 'clamp(1.25rem, 2.3vw, 1.75rem)',
    barWidth: '75%',
  },
  {
    num: '#3',
    name: 'SCALABILITY',
    question: 'Does it grow effortlessly?',
    focus: 'Automation, prediction, growth',
    color: colors.muted,
    borderColor: 'rgba(139, 143, 163, 0.4)',
    size: 'clamp(1rem, 1.8vw, 1.5rem)',
    barWidth: '50%',
  },
];

export default function ThreePillarsSlide() {
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
            THREE PILLARS OF EFFECTIVENESS
          </h1>
        </AnimatedText>

        {/* Pillar stack */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '20px',
            maxWidth: '900px',
          }}
        >
          {pillars.map((pillar) => (
            <motion.div
              key={pillar.name}
              variants={fadeInUp}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '24px',
                width: pillar.barWidth,
              }}
            >
              {/* Priority number */}
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.75rem, 1.2vw, 1rem)',
                  color: pillar.color,
                  minWidth: '32px',
                }}
              >
                {pillar.num}
              </span>

              {/* Pillar bar */}
              <div
                style={{
                  flex: 1,
                  borderLeft: `4px solid ${pillar.borderColor}`,
                  paddingLeft: '20px',
                }}
              >
                {/* Name */}
                <h2
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: pillar.size,
                    color: pillar.color,
                    textTransform: 'uppercase',
                    letterSpacing: '-0.01em',
                    margin: '0 0 4px 0',
                  }}
                >
                  {pillar.name}
                </h2>

                {/* Key question */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
                    color: colors.textDim,
                    fontStyle: 'italic',
                    margin: '0 0 4px 0',
                  }}
                >
                  {pillar.question}
                </p>

                {/* Focus area */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                    color: colors.muted,
                    margin: 0,
                  }}
                >
                  {pillar.focus}
                </p>
              </div>
            </motion.div>
          ))}
        </motion.div>

        {/* Golden rule */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8, duration: 0.5 }}
          style={{
            marginTop: '48px',
            borderLeft: `3px solid ${colors.gold}`,
            paddingLeft: '16px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
              color: colors.gold,
              fontStyle: 'italic',
              margin: 0,
            }}
          >
            "Never sacrifice sustainability for efficiency."
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
