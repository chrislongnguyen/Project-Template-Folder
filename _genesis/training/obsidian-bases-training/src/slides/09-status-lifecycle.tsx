import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';

const statuses = [
  {
    value: 'draft',
    bg: '#2a2d3d',
    border: '#4a4d5e',
    text: '#9ca0b5',
    actor: 'AGENT',
    actorDesc: 'creates\nthe file',
  },
  {
    value: 'in-progress',
    bg: `${colors.gold}22`,
    border: `${colors.gold}60`,
    text: colors.gold,
    actor: 'AGENT',
    actorDesc: 'works\non it',
  },
  {
    value: 'in-review',
    bg: `${colors.purple}22`,
    border: `${colors.purple}60`,
    text: '#9b78b5',
    actor: 'AGENT',
    actorDesc: 'requests\nyour review',
  },
  {
    value: 'validated',
    bg: `${colors.green}22`,
    border: `${colors.green}60`,
    text: '#8bc46a',
    actor: 'YOU ONLY',
    actorDesc: 'approve\nor reject',
    isHuman: true,
  },
  {
    value: 'archived',
    bg: '#1e2028',
    border: '#3a3d4e',
    text: '#5a5d70',
    actor: 'AGENT',
    actorDesc: 'after\nlifecycle',
  },
];

export default function StatusLifecycleSlide() {
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
          padding: '48px 80px',
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
            STATUS LIFECYCLE
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '40px',
            }}
          />
        </AnimatedText>

        {/* Flow diagram */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          style={{
            display: 'flex',
            alignItems: 'flex-start',
            gap: '0',
            marginBottom: '48px',
          }}
        >
          {statuses.map((s, i) => (
            <div
              key={s.value}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '0',
                flex: 1,
              }}
            >
              {/* Status node + actor below */}
              <div
                style={{
                  flex: 1,
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  gap: '12px',
                }}
              >
                {/* Status pill */}
                <div
                  style={{
                    padding: 'clamp(6px, 0.8vw, 10px) clamp(10px, 1.2vw, 16px)',
                    borderRadius: '20px',
                    background: s.bg,
                    border: `1px solid ${s.border}`,
                    textAlign: 'center',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: s.text,
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {s.value}
                  </span>
                </div>

                {/* Vertical connector */}
                <div
                  style={{
                    width: '1px',
                    height: '16px',
                    background: 'rgba(255,255,255,0.12)',
                  }}
                />

                {/* Actor */}
                <div style={{ textAlign: 'center' }}>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                      color: s.isHuman ? colors.gold : colors.muted,
                      textTransform: 'uppercase',
                      letterSpacing: '0.06em',
                      display: 'block',
                    }}
                  >
                    {s.actor}
                  </span>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                      color: colors.textDim,
                      whiteSpace: 'pre-line',
                      lineHeight: 1.4,
                    }}
                  >
                    {s.actorDesc}
                  </span>
                </div>
              </div>

              {/* Arrow connector between nodes */}
              {i < statuses.length - 1 && (
                <span
                  style={{
                    color: `${colors.gold}60`,
                    fontSize: 'clamp(0.75rem, 1vw, 0.9rem)',
                    flexShrink: 0,
                    marginBottom: '32px',
                    padding: '0 2px',
                  }}
                >
                  →
                </span>
              )}
            </div>
          ))}
        </motion.div>

        {/* Key rule callout */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7, duration: 0.5 }}
          style={{
            borderLeft: `3px solid ${colors.gold}`,
            paddingLeft: '16px',
            background: `${colors.gold}08`,
            borderRadius: '0 6px 6px 0',
            padding: '12px 16px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 600,
              fontSize: 'clamp(0.65rem, 0.95vw, 0.8rem)',
              color: colors.gold,
              margin: 0,
              lineHeight: 1.5,
            }}
          >
            KEY RULE: Only YOU can set 'validated'. Agents create, work, and request review. You approve.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
