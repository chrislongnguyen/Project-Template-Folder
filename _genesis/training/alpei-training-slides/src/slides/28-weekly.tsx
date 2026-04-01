import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const days = [
  {
    label: 'MONDAY',
    color: colors.gold,
    focus: 'ALIGNMENT',
    commands: ['/dsbv status', '/dsbv status'],
    desc: 'Review last week, set priorities',
  },
  {
    label: 'TUESDAY',
    color: colors.midnight,
    focus: 'EXECUTION',
    commands: ['/learn:input', '/dsbv design plan'],
    desc: 'Learn and plan cycle',
  },
  {
    label: 'WEDNESDAY',
    color: colors.midnight,
    focus: 'EXECUTION',
    commands: ['/dsbv build', '/dsbv status'],
    desc: 'Build and deliver',
  },
  {
    label: 'THURSDAY',
    color: colors.midnight,
    focus: 'EXECUTION',
    commands: ['/dsbv build', '/dsbv validate'],
    desc: 'Execute and audit stages',
  },
  {
    label: 'FRIDAY',
    color: colors.ruby,
    focus: 'IMPROVEMENT',
    commands: ['/dsbv validate', '/dsbv validate improve'],
    desc: 'Audit everything, check VANA',
  },
  {
    label: 'MONTHLY',
    color: colors.goldDim,
    focus: 'VERSION CHECK',
    commands: ['VERSION_REGISTRY', 'version advancement'],
    desc: 'Version progression review',
  },
];

export default function WeeklySlide() {
  return (
    <SlideLayout>
      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 50% 80%, rgba(0, 72, 81, 0.3) 0%, transparent 50%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '48px 80px',
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
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              marginBottom: '36px',
            }}
          >
            WEEKLY CADENCE
          </h1>
        </AnimatedText>

        {/* Calendar strip */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            gap: '12px',
          }}
        >
          {days.map((day) => (
            <motion.div
              key={day.label}
              variants={fadeInUp}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                borderTop: `3px solid ${day.color}`,
                padding: '16px 12px',
              }}
            >
              {/* Day label */}
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.55rem, 0.85vw, 0.72rem)',
                  color: day.color,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                  marginBottom: '6px',
                }}
              >
                {day.label}
              </span>

              {/* Focus badge */}
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)',
                  color: colors.gunmetal,
                  background: `${day.color}cc`,
                  padding: '2px 8px',
                  borderRadius: '8px',
                  textTransform: 'uppercase',
                  letterSpacing: '0.04em',
                  alignSelf: 'flex-start',
                  marginBottom: '12px',
                }}
              >
                {day.focus}
              </span>

              {/* Description */}
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.7vw, 0.6rem)',
                  color: colors.text,
                  lineHeight: 1.5,
                  marginBottom: '10px',
                }}
              >
                {day.desc}
              </span>

              {/* Commands */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                {day.commands.map((cmd, ci) => (
                  <span
                    key={ci}
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.4rem, 0.6vw, 0.52rem)',
                      color: colors.textDim,
                      letterSpacing: '0.02em',
                    }}
                  >
                    {cmd}
                  </span>
                ))}
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
