import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const timeBlocks = [
  {
    time: 'MORNING',
    duration: '5 MIN',
    color: colors.gold,
    items: [
      'Open C3-standup-preparation → see what changed overnight',
      'Scan C4-blocker-dashboard → anything stale or blocked?',
    ],
  },
  {
    time: 'STANDUP',
    duration: '15–30 MIN',
    color: colors.midnightLight,
    items: [
      'Review master-dashboard → report status per workstream',
      'Check C7-dependency-tracker → any upstream blockers?',
    ],
  },
  {
    time: 'WORK SESSION',
    duration: 'FLEXIBLE',
    color: colors.green,
    items: [
      'Use stage-pipeline → track D→S→B→V progress',
      'Drill into workstream overviews → focus on your active stream',
    ],
  },
  {
    time: 'APPROVAL',
    duration: 'AS NEEDED',
    color: colors.ruby,
    items: [
      'Check C5-approval-queue → items waiting for YOUR review',
      'Open the file → review → set status to validated',
    ],
  },
  {
    time: 'END OF DAY',
    duration: '5 MIN',
    color: colors.goldDim,
    items: [
      'Check C6-version-progress → are we advancing?',
      'Update daily note → reflect on progress',
    ],
  },
  {
    time: 'WEEKLY',
    duration: '15 MIN',
    color: colors.purple,
    items: [
      'Triage inbox → process, file, or archive captures',
      'Review U4-people-directory → stakeholder follow-ups',
      'Scan U1-daily-notes-index → patterns over the week',
    ],
  },
];

export default function WorkflowMapSlide() {
  return (
    <SlideLayout>
      {/* Left accent bar */}
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

      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 15% 50%, rgba(0, 72, 81, 0.3) 0%, transparent 55%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '40px 100px',
          position: 'relative',
          zIndex: 1,
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
              margin: '0 0 6px 0',
            }}
          >
            YOUR DAILY + WEEKLY CYCLE
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '28px' }} />
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
            paddingLeft: '40px',
          }}
        >
          {/* Vertical timeline line */}
          <motion.div
            initial={{ scaleY: 0 }}
            animate={{ scaleY: 1 }}
            transition={{ duration: 1.2, delay: 0.3, ease: [0.25, 0.1, 0.25, 1] }}
            style={{
              position: 'absolute',
              left: '9px',
              top: '8px',
              bottom: '8px',
              width: '2px',
              background: `linear-gradient(180deg, ${colors.gold} 0%, ${colors.purple} 100%)`,
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
                gap: '20px',
                marginBottom: i < timeBlocks.length - 1 ? '16px' : '0',
                position: 'relative',
              }}
            >
              {/* Colored dot */}
              <div
                style={{
                  position: 'absolute',
                  left: '-40px',
                  top: '5px',
                  width: '18px',
                  height: '18px',
                  borderRadius: '50%',
                  background: block.color,
                  boxShadow: `0 0 10px ${block.color}55`,
                  zIndex: 2,
                  flexShrink: 0,
                }}
              />

              {/* Time label */}
              <div style={{ minWidth: '130px', flexShrink: 0 }}>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.65rem, 1vw, 0.85rem)',
                    color: block.color,
                    textTransform: 'uppercase',
                    letterSpacing: '0.04em',
                    display: 'block',
                  }}
                >
                  {block.time}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                    color: colors.textDim,
                    letterSpacing: '0.02em',
                  }}
                >
                  {block.duration}
                </span>
              </div>

              {/* Action items */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
                {block.items.map((item, j) => (
                  <span
                    key={j}
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.55rem, 0.85vw, 0.75rem)',
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
