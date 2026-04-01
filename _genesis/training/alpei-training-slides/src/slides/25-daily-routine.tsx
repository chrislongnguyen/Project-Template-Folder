import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer, staggerFast } from '../lib/animations';

const timeBlocks = [
  {
    time: 'MORNING',
    duration: '5-10 MIN',
    items: [
      'Review yesterday\'s daily note',
      'Run /session-start to create today\'s note',
      'Check standup preparation dashboard',
      'Scan blocker dashboard for urgent items',
    ],
  },
  {
    time: 'STANDUP',
    duration: '15-30 MIN',
    items: [
      'Report increment, blockers, and plan',
      'Group discussion on common blockers',
      'Private discussion for project-specific issues',
    ],
  },
  {
    time: 'WORK SESSION',
    duration: 'FLEXIBLE',
    items: [
      'Execute tasks via /dsbv build',
      'Move cards through Design → Sequence → Build → Validate',
      'Commit and push every meaningful change',
      'Update progress tracker as work completes',
    ],
  },
  {
    time: 'END OF DAY',
    duration: '5-10 MIN',
    items: [
      'Run /dsbv validate for daily audit',
      'Update daily note with reflections',
      'Stage and commit all work to Git',
    ],
  },
];

export default function DailyRoutineSlide() {
  return (
    <SlideLayout>
      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 20% 50%, rgba(0, 72, 81, 0.35) 0%, transparent 55%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '48px 100px',
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
            YOUR DAILY ROUTINE
          </h1>
        </AnimatedText>

        {/* Timeline */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '0px',
            position: 'relative',
            paddingLeft: '36px',
          }}
        >
          {/* Vertical timeline line */}
          <motion.div
            initial={{ scaleY: 0 }}
            animate={{ scaleY: 1 }}
            transition={{ duration: 1, delay: 0.3, ease: [0.25, 0.1, 0.25, 1] }}
            style={{
              position: 'absolute',
              left: '7px',
              top: '8px',
              bottom: '8px',
              width: '2px',
              background: `linear-gradient(180deg, ${colors.gold} 0%, ${colors.goldDim} 100%)`,
              transformOrigin: 'top',
            }}
          />

          {timeBlocks.map((block, i) => (
            <motion.div
              key={block.time}
              variants={fadeInUp}
              style={{
                display: 'flex',
                alignItems: 'flex-start',
                gap: '24px',
                marginBottom: i < timeBlocks.length - 1 ? '24px' : '0',
                position: 'relative',
              }}
            >
              {/* Gold dot */}
              <div
                style={{
                  position: 'absolute',
                  left: '-36px',
                  top: '6px',
                  width: '16px',
                  height: '16px',
                  borderRadius: '50%',
                  background: colors.gold,
                  boxShadow: `0 0 12px ${colors.gold}44`,
                  zIndex: 2,
                }}
              />

              {/* Time label */}
              <div style={{ minWidth: '140px', flexShrink: 0 }}>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.75rem, 1.2vw, 0.95rem)',
                    color: colors.gold,
                    textTransform: 'uppercase',
                    letterSpacing: '0.04em',
                  }}
                >
                  {block.time}
                </span>
                <br />
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.6rem, 0.9vw, 0.75rem)',
                    color: colors.textDim,
                    letterSpacing: '0.02em',
                  }}
                >
                  {block.duration}
                </span>
              </div>

              {/* Action items */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                {block.items.map((item, j) => (
                  <span
                    key={j}
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.6rem, 1vw, 0.8rem)',
                      color: colors.text,
                      lineHeight: 1.5,
                    }}
                  >
                    {item}
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
