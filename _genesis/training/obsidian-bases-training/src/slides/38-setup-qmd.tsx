import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

const setupSteps = [
  { num: 1, text: 'Scaffolds Memory Vault folders on Google Drive (sessions/, conversations/, decisions/)' },
  { num: 2, text: 'Installs QMD search engine — indexes your vault for semantic search' },
  { num: 3, text: 'Connects QMD to your PKB (distilled/ → qmd collection add)' },
  { num: 4, text: 'Runs smoke test to verify everything works' },
  { num: 5, text: 'Idempotent — safe to re-run anytime' },
];

export default function SetupQmdSlide() {
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
          height: '100%',
          padding: '32px 64px 28px 80px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.2rem, 2.2vw, 1.8rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 4px 0',
            }}
          >
            /SETUP — QMD &amp; MEMORY VAULT
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '20px' }} />
        </AnimatedText>

        {/* Two-column body */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '28px', flex: 1 }}>

          {/* Left: What /setup does */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
              }}
            >
              What /setup does
            </span>

            {/* Command block */}
            <div
              style={{
                background: colors.gunmetal,
                border: '1px solid rgba(255,255,255,0.08)',
                borderRadius: '6px',
                padding: '12px 16px',
                marginBottom: '4px',
              }}
            >
              <p
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.65rem, 0.9vw, 0.78rem)',
                  color: colors.gold,
                  margin: 0,
                }}
              >
                /setup
              </p>
            </div>

            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 600,
                fontSize: 'clamp(0.58rem, 0.8vw, 0.68rem)',
                color: colors.textDim,
                margin: '0 0 6px 0',
              }}
            >
              Agent automatically:
            </p>

            {setupSteps.map((step) => (
              <div
                key={step.num}
                style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '10px',
                  padding: '8px 12px',
                  borderRadius: '6px',
                  background: 'rgba(29,31,42,0.5)',
                  border: '1px solid rgba(255,255,255,0.05)',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)',
                    color: colors.gold,
                    flexShrink: 0,
                    minWidth: '16px',
                  }}
                >
                  {step.num}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.58rem, 0.8vw, 0.68rem)',
                    color: colors.text,
                    lineHeight: 1.5,
                  }}
                >
                  {step.text}
                </span>
              </div>
            ))}
          </motion.div>

          {/* Right: How it connects */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', flexDirection: 'column', gap: '12px', justifyContent: 'center' }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
              }}
            >
              How it connects
            </span>

            {/* Diagram */}
            <div
              style={{
                background: 'rgba(29,31,42,0.5)',
                border: '1px solid rgba(255,255,255,0.08)',
                borderRadius: '8px',
                padding: '24px 20px',
                display: 'flex',
                flexDirection: 'column',
                gap: '8px',
              }}
            >
              {/* Top row: PKB → QMD → Agent */}
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
                <div
                  style={{
                    background: `${colors.purple}22`,
                    border: `1px solid ${colors.purple}50`,
                    borderRadius: '6px',
                    padding: '8px 14px',
                    textAlign: 'center',
                  }}
                >
                  <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)', color: colors.purple, display: 'block' }}>
                    PKB
                  </span>
                  <span style={{ fontFamily: "'Courier New', Courier, monospace", fontSize: 'clamp(0.48rem, 0.65vw, 0.55rem)', color: colors.muted }}>
                    distilled/
                  </span>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px' }}>
                  <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)', color: colors.textDim }}>index</span>
                  <span style={{ color: `${colors.gold}80`, fontSize: '0.9rem' }}>──►</span>
                </div>

                <div
                  style={{
                    background: `${colors.gold}18`,
                    border: `1px solid ${colors.gold}50`,
                    borderRadius: '6px',
                    padding: '8px 14px',
                    textAlign: 'center',
                  }}
                >
                  <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)', color: colors.gold, display: 'block' }}>
                    QMD Engine
                  </span>
                  <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)', color: colors.muted }}>
                    semantic search
                  </span>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px' }}>
                  <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)', color: colors.textDim }}>auto-recall</span>
                  <span style={{ color: `${colors.gold}80`, fontSize: '0.9rem' }}>──►</span>
                </div>

                <div
                  style={{
                    background: `${colors.green}18`,
                    border: `1px solid ${colors.green}50`,
                    borderRadius: '6px',
                    padding: '8px 14px',
                    textAlign: 'center',
                  }}
                >
                  <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)', color: colors.green, display: 'block' }}>
                    Your Agent
                  </span>
                  <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)', color: colors.muted }}>
                    Claude Code
                  </span>
                </div>
              </div>

              {/* Arrow up from Memory Vault to QMD */}
              <div style={{ display: 'flex', alignItems: 'center', paddingLeft: '44%' }}>
                <span style={{ color: `${colors.gold}60`, fontSize: '0.9rem', transform: 'rotate(90deg)', display: 'inline-block' }}>──►</span>
              </div>

              {/* Memory Vault box */}
              <div style={{ display: 'flex', justifyContent: 'center' }}>
                <div
                  style={{
                    background: `${colors.midnightLight}22`,
                    border: `1px solid ${colors.midnightLight}50`,
                    borderRadius: '6px',
                    padding: '8px 20px',
                    textAlign: 'center',
                  }}
                >
                  <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)', color: colors.midnightLight, display: 'block' }}>
                    Memory Vault
                  </span>
                  <span style={{ fontFamily: "'Courier New', Courier, monospace", fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)', color: colors.muted }}>
                    sessions/
                  </span>
                </div>
              </div>
            </div>
          </motion.div>
        </div>

        {/* Bottom callout */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.8 }}
          style={{
            marginTop: '16px',
            border: `1px solid ${colors.gold}60`,
            borderRadius: '6px',
            padding: '10px 18px',
            background: `${colors.gold}0a`,
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
          }}
        >
          <div style={{ width: '3px', alignSelf: 'stretch', borderRadius: '2px', background: colors.gold, flexShrink: 0 }} />
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.58rem, 0.82vw, 0.7rem)',
              color: colors.textDim,
              margin: 0,
              lineHeight: 1.5,
            }}
          >
            <span style={{ color: colors.gold, fontWeight: 700 }}>After /setup:</span>{' '}
            your agent can auto-recall knowledge from your wiki AND your past sessions.{' '}
            <span style={{ color: colors.text }}>/ingest</span> adds to the wiki.{' '}
            <span style={{ color: colors.text }}>/compress</span> adds to sessions.{' '}
            <span style={{ color: colors.text }}>QMD</span> searches both.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
