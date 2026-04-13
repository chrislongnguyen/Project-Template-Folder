import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

const beforeItems = [
  { time: '8:30', text: 'Open repo. Scan folders. What changed?' },
  { time: '8:45', text: 'Check git log. Try to remember context' },
  { time: '9:00', text: 'Standup. "I think we\'re on track..."' },
  { time: '9:30', text: 'Start working. Which file was I on?' },
  { time: '11:00', text: 'Idea for new feature. Blank page.' },
  { time: '14:00', text: 'Agent finished. Open 5 folders to check.' },
  { time: '16:00', text: 'Read an article. Bookmark it. Forget it.' },
  { time: '17:00', text: 'Close laptop. Context lost.' },
];

const afterItems = [
  { time: '8:30', text: 'Open C3. See exactly what changed.', highlight: true },
  { time: '8:32', text: 'Open C4. No blockers. System healthy.', highlight: true },
  { time: '9:00', text: 'Standup. "3 items moved, 1 at risk."', highlight: false },
  { time: '9:15', text: '/ltc-brainstorming → 4 gates → Discovery Complete', highlight: true },
  { time: '10:00', text: '/dsbv design → ALIGN → agent writes DESIGN.md', highlight: true },
  { time: '14:00', text: 'C5: 2 items need review → validated.', highlight: false },
  { time: '16:00', text: 'Drop in 1-captured/. /organise. Wiki created.', highlight: true },
  { time: '17:00', text: '/compress. Tomorrow: /resume picks up.', highlight: true },
];

export default function DayInLifeSlide() {
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
          padding: '32px 80px 32px 100px',
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.1rem, 2.2vw, 1.7rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 4px 0',
            }}
          >
            YOUR DAY AS A PM — BEFORE AND AFTER Iteration 2
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '20px',
            }}
          />
        </AnimatedText>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px', marginBottom: '16px' }}>
          {/* Before column */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
          >
            <div
              style={{
                padding: '6px 14px',
                marginBottom: '8px',
                borderRadius: '4px',
                background: 'rgba(29, 31, 42, 0.7)',
                border: '1px solid rgba(255,255,255,0.08)',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.55rem, 0.82vw, 0.7rem)',
                  color: colors.muted,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                }}
              >
                BEFORE (Iteration 1)
              </span>
            </div>
            {beforeItems.map((item, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  gap: '10px',
                  padding: '7px 14px',
                  marginBottom: '4px',
                  borderRadius: '4px',
                  background: 'rgba(29, 31, 42, 0.3)',
                  border: '1px solid rgba(255,255,255,0.04)',
                  alignItems: 'flex-start',
                }}
              >
                <span
                  style={{
                    fontFamily: '"JetBrains Mono", "Fira Code", monospace',
                    fontSize: 'clamp(0.48rem, 0.65vw, 0.56rem)',
                    color: colors.muted,
                    opacity: 0.6,
                    flexShrink: 0,
                    paddingTop: '1px',
                  }}
                >
                  {item.time}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: colors.muted,
                    lineHeight: 1.45,
                    opacity: 0.7,
                  }}
                >
                  {item.text}
                </span>
              </div>
            ))}
          </motion.div>

          {/* After column */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
          >
            <div
              style={{
                padding: '6px 14px',
                marginBottom: '8px',
                borderRadius: '4px',
                background: 'rgba(0, 72, 81, 0.4)',
                border: '1px solid rgba(242, 199, 92, 0.2)',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.55rem, 0.82vw, 0.7rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                }}
              >
                AFTER (Iteration 2)
              </span>
            </div>
            {afterItems.map((item, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  gap: '10px',
                  padding: '7px 14px',
                  marginBottom: '4px',
                  borderRadius: '4px',
                  background: item.highlight
                    ? 'rgba(0, 72, 81, 0.25)'
                    : 'rgba(0, 72, 81, 0.12)',
                  border: item.highlight
                    ? '1px solid rgba(242, 199, 92, 0.12)'
                    : '1px solid rgba(242, 199, 92, 0.05)',
                  alignItems: 'flex-start',
                }}
              >
                <span
                  style={{
                    fontFamily: '"JetBrains Mono", "Fira Code", monospace',
                    fontSize: 'clamp(0.48rem, 0.65vw, 0.56rem)',
                    color: colors.gold,
                    opacity: 0.7,
                    flexShrink: 0,
                    paddingTop: '1px',
                  }}
                >
                  {item.time}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: item.highlight ? colors.text : colors.textDim,
                    lineHeight: 1.45,
                    fontWeight: item.highlight ? 500 : 400,
                  }}
                >
                  {item.text}
                </span>
              </div>
            ))}
          </motion.div>
        </div>

        {/* Bold gold callout */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.9 }}
          style={{
            padding: '10px 18px',
            borderRadius: '5px',
            background: 'rgba(242, 199, 92, 0.08)',
            border: `1px solid rgba(242, 199, 92, 0.25)`,
            borderLeft: `3px solid ${colors.gold}`,
          }}
        >
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 0.9vw, 0.75rem)',
              color: colors.gold,
              letterSpacing: '0.01em',
            }}
          >
            Iteration 2 doesn't add more work. It removes the work you were already doing badly.
          </span>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
