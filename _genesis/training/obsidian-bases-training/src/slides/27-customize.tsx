import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

export default function CustomizeSlide() {
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

      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 80% 20%, rgba(0, 72, 81, 0.2) 0%, transparent 50%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '48px 120px 40px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
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
            CUSTOMIZE WITH CLAUDE CODE
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '28px',
            }}
          />
        </AnimatedText>

        {/* Two panels */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '20px' }}>

          {/* Panel 1 — ADD A NEW DASHBOARD */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{
              padding: '20px 24px',
              borderRadius: '8px',
              background: 'rgba(29, 31, 42, 0.6)',
              border: `1px solid ${colors.gold}30`,
              borderLeft: `4px solid ${colors.gold}`,
            }}
          >
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                color: colors.gold,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                margin: '0 0 12px 0',
              }}
            >
              ADD A NEW DASHBOARD
            </p>

            {/* Prompt block */}
            <div
              style={{
                padding: '10px 16px',
                borderRadius: '4px',
                background: 'rgba(0, 0, 0, 0.35)',
                border: `1px solid rgba(255,255,255,0.08)`,
                marginBottom: '10px',
              }}
            >
              <p
                style={{
                  fontFamily: 'monospace',
                  fontWeight: 400,
                  fontSize: 'clamp(0.6rem, 0.88vw, 0.76rem)',
                  color: colors.textDim,
                  margin: 0,
                  lineHeight: 1.5,
                }}
              >
                "Create a .base dashboard that shows all files in 3-PLAN/ grouped by risk level,
                with a days-stale formula"
              </p>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                  color: colors.gold,
                }}
              >
                →
              </span>
              <p
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                  color: colors.textDim,
                  margin: 0,
                }}
              >
                Agent creates the .base file with correct syntax. You open it in Obsidian.
              </p>
            </div>
          </motion.div>

          {/* Panel 2 — MODIFY AN EXISTING DASHBOARD */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{
              padding: '20px 24px',
              borderRadius: '8px',
              background: 'rgba(0, 48, 57, 0.35)',
              border: `1px solid ${colors.midnightLight}40`,
              borderLeft: `4px solid ${colors.midnightLight}`,
            }}
          >
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                color: colors.midnightLight,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                margin: '0 0 12px 0',
              }}
            >
              MODIFY AN EXISTING DASHBOARD
            </p>

            {/* Prompt block */}
            <div
              style={{
                padding: '10px 16px',
                borderRadius: '4px',
                background: 'rgba(0, 0, 0, 0.35)',
                border: `1px solid rgba(255,255,255,0.08)`,
                marginBottom: '10px',
              }}
            >
              <p
                style={{
                  fontFamily: 'monospace',
                  fontWeight: 400,
                  fontSize: 'clamp(0.6rem, 0.88vw, 0.76rem)',
                  color: colors.textDim,
                  margin: 0,
                  lineHeight: 1.5,
                }}
              >
                "Add a new view to C4-blocker-dashboard that groups by sub_system instead of work_stream"
              </p>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                  color: colors.midnightLight,
                }}
              >
                →
              </span>
              <p
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                  color: colors.textDim,
                  margin: 0,
                }}
              >
                Agent edits the .base YAML. Dashboard updates instantly.
              </p>
            </div>
          </motion.div>
        </div>

        {/* Bottom note */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8, duration: 0.4 }}
          style={{ marginTop: '20px', textAlign: 'center' }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
              color: colors.muted,
              margin: 0,
              fontStyle: 'italic',
            }}
          >
            Bases are just YAML files. Your agent reads and writes them. You describe what you want.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
