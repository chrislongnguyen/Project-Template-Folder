import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const fields = [
  {
    key: 'type:',
    value: 'ues-deliverable',
    annotation: 'UES (User Enablement System) — marks this as a project deliverable',
    color: colors.gold,
  },
  {
    key: 'version:',
    value: '"2.1"',
    annotation: 'Iteration 2 iteration, 1st edit (Iteration 2 = 2.x)',
    color: colors.midnightLight,
  },
  {
    key: 'status:',
    value: 'in-progress',
    annotation: 'Pill color + which views show it',
    color: colors.gold,
  },
  {
    key: 'work_stream:',
    value: '4-EXECUTE',
    annotation: 'ALPEI grouping (1-ALIGN through 5-IMPROVE)',
    color: colors.green,
  },
  {
    key: 'stage:',
    value: 'build',
    annotation: 'DSBV pipeline position (D→S→B→V)',
    color: colors.midnightLight,
  },
  {
    key: 'sub_system:',
    value: '2-DP',
    annotation: '1-PD/2-DP/3-DA/4-IDM classification (defined on next slide)',
    color: colors.purple,
  },
  {
    key: 'owner:',
    value: '"Long Nguyen"',
    annotation: 'Who owns this deliverable',
    color: colors.textDim,
  },
  {
    key: 'last_updated:',
    value: '2026-04-04',
    annotation: 'Agent updates automatically',
    color: colors.textDim,
  },
];

export default function FrontmatterAnatomySlide() {
  return (
    <SlideLayout>
      {/* Midnight accent bar */}
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
          background: colors.midnightLight,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '40px 120px 36px',
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
            FRONTMATTER ANATOMY
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.midnightLight,
              marginBottom: '24px',
            }}
          />
        </AnimatedText>

        {/* Main content: code block + annotations */}
        <div style={{ flex: 1, display: 'flex', gap: '32px', alignItems: 'flex-start' }}>
          {/* Code block */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            style={{
              background: colors.gunmetal,
              border: '1px solid rgba(255,255,255,0.1)',
              borderRadius: '10px',
              padding: '20px 24px',
              minWidth: '280px',
            }}
          >
            <p
              style={{
                fontFamily: "'Courier New', Courier, monospace",
                fontSize: 'clamp(0.55rem, 0.78vw, 0.68rem)',
                color: 'rgba(255,255,255,0.3)',
                margin: '0 0 6px 0',
              }}
            >
              ---
            </p>
            {fields.map((f) => (
              <p
                key={f.key}
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.55rem, 0.78vw, 0.68rem)',
                  margin: '3px 0',
                  lineHeight: 1.7,
                  display: 'flex',
                  gap: '8px',
                }}
              >
                <span style={{ color: colors.midnightLight }}>{f.key}</span>
                <span style={{ color: colors.gold }}>{f.value}</span>
              </p>
            ))}
            <p
              style={{
                fontFamily: "'Courier New', Courier, monospace",
                fontSize: 'clamp(0.55rem, 0.78vw, 0.68rem)',
                color: 'rgba(255,255,255,0.3)',
                margin: '6px 0 0 0',
              }}
            >
              ---
            </p>
          </motion.div>

          {/* Arrow connector */}
          <div
            style={{
              display: 'flex',
              alignItems: 'flex-start',
              paddingTop: '12px',
              flexShrink: 0,
            }}
          >
            <span style={{ color: `${colors.gold}60`, fontSize: 'clamp(0.8rem, 1.2vw, 1rem)' }}>→</span>
          </div>

          {/* Annotations */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
              gap: '4px',
            }}
          >
            {fields.map((f) => (
              <motion.div
                key={f.key}
                variants={fadeInUp}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '10px',
                  padding: '5px 10px',
                  borderRadius: '4px',
                  background: 'rgba(29,31,42,0.4)',
                  borderLeft: `2px solid ${f.color}`,
                  minHeight: 'clamp(22px, 2vw, 28px)',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.textDim,
                    lineHeight: 1.4,
                  }}
                >
                  {f.annotation}
                </span>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
