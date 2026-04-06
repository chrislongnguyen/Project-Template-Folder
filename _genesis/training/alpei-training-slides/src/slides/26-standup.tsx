import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const parts = [
  {
    num: '01',
    title: 'UPDATE',
    time: '5 MIN',
    type: 'table' as const,
    rows: [
      ['QUESTION', 'FOCUS'],
      ['What did AI deliver?', 'Increment completed'],
      ['What\'s blocked?', 'Blockers to escalate'],
      ['What\'s the plan?', 'Today\'s priorities'],
      ['/dsbv status first', 'Know your pipeline state before you speak'],
    ],
  },
  {
    num: '02',
    title: 'GROUP DISCUSSION',
    time: '10-15 MIN',
    type: 'bullets' as const,
    items: [
      'Company alignment issues',
      'Infrastructure & technology blockers',
      'Process changes & improvements',
      'Resource allocation decisions',
    ],
  },
  {
    num: '03',
    title: 'PRIVATE DISCUSSION',
    time: '5-10 MIN',
    type: 'bullets' as const,
    items: [
      'Project-specific blockers',
      'Breakout with management',
      'Technical deep-dives',
      'Approval gate reviews',
    ],
  },
];

export default function StandupSlide() {
  return (
    <SlideLayout>
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
              marginBottom: '32px',
            }}
          >
            THE 3-PART STANDUP
          </h1>
        </AnimatedText>

        {/* Three horizontal panels */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            gap: '0px',
            flex: 1,
            maxHeight: '70%',
          }}
        >
          {parts.map((part, i) => (
            <motion.div
              key={part.num}
              variants={fadeInUp}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                padding: '24px 20px',
                borderRight: i < parts.length - 1 ? `1px solid ${colors.midnight}44` : 'none',
              }}
            >
              {/* Number + Time badge */}
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  marginBottom: '12px',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(1.5rem, 2.5vw, 2rem)',
                    color: colors.gold,
                    lineHeight: 1,
                  }}
                >
                  {part.num}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.65rem)',
                    color: colors.gunmetal,
                    background: colors.gold,
                    padding: '3px 10px',
                    borderRadius: '10px',
                    letterSpacing: '0.04em',
                    textTransform: 'uppercase',
                  }}
                >
                  {part.time}
                </span>
              </div>

              {/* Title */}
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.7rem, 1.1vw, 0.9rem)',
                  color: colors.text,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                  marginBottom: '16px',
                }}
              >
                {part.title}
              </span>

              {/* Content */}
              {part.type === 'table' && part.rows && (
                <div style={{ display: 'flex', flexDirection: 'column', gap: '0px' }}>
                  {part.rows.map((row, ri) => (
                    <div
                      key={ri}
                      style={{
                        display: 'flex',
                        borderBottom: ri < part.rows.length - 1 ? `1px solid ${colors.midnight}22` : 'none',
                        padding: '6px 0',
                      }}
                    >
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: ri === 0 ? 700 : 400,
                          fontSize: 'clamp(0.5rem, 0.8vw, 0.7rem)',
                          color: ri === 0 ? colors.gold : colors.text,
                          textTransform: ri === 0 ? 'uppercase' : 'none',
                          flex: 1,
                          lineHeight: 1.4,
                        }}
                      >
                        {row[0]}
                      </span>
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: ri === 0 ? 700 : 400,
                          fontSize: 'clamp(0.5rem, 0.8vw, 0.7rem)',
                          color: ri === 0 ? colors.gold : colors.textDim,
                          textTransform: ri === 0 ? 'uppercase' : 'none',
                          flex: 1,
                          lineHeight: 1.4,
                        }}
                      >
                        {row[1]}
                      </span>
                    </div>
                  ))}
                </div>
              )}

              {part.type === 'bullets' && part.items && (
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                  {part.items.map((item, bi) => (
                    <div
                      key={bi}
                      style={{
                        display: 'flex',
                        alignItems: 'flex-start',
                        gap: '8px',
                      }}
                    >
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontSize: 'clamp(0.4rem, 0.6vw, 0.5rem)',
                          color: colors.gold,
                          marginTop: '4px',
                        }}
                      >
                        &#9679;
                      </span>
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: 400,
                          fontSize: 'clamp(0.55rem, 0.85vw, 0.72rem)',
                          color: colors.text,
                          lineHeight: 1.5,
                        }}
                      >
                        {item}
                      </span>
                    </div>
                  ))}
                </div>
              )}
            </motion.div>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
