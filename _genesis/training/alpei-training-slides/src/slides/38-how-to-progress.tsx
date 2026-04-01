import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const steps = [
  { label: 'CHECK', command: '/dsbv status', desc: 'See current version for each zone', icon: '01' },
  { label: 'VALIDATE', command: '/dsbv validate improve', desc: 'Run validate gate check on deliverables', icon: '02' },
  { label: 'CLOSE', command: 'Close iteration via IMPROVE validate', desc: 'Close the current iteration cycle', icon: '03' },
  { label: 'ADVANCE', command: 'Update VERSION_REGISTRY', desc: 'Move to the next version level', icon: '04' },
];

const checklist = [
  { action: 'Confirm all zones complete', command: '/dsbv validate', approval: 'PM review' },
  { action: 'Run validate for improve zone', command: '/dsbv validate improve', approval: 'VANA gate' },
  { action: 'Verify chain-of-custody intact', command: '/dsbv status', approval: 'Auto-check' },
  { action: 'Close current iteration', command: 'Close iteration via IMPROVE validate', approval: 'PM sign-off' },
  { action: 'Advance zone version', command: 'Update VERSION_REGISTRY', approval: 'PM approval' },
];

const vanaFails = [
  'Identify which criteria failed — fix only those, do not over-build',
  'Run another iteration at the SAME version level — never skip ahead',
  'If multiple criteria fail, reassess scope before iterating',
];

export default function HowToProgressSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '56px 80px 44px' }}>
        {/* Headline */}
        <AnimatedText>
          <h1 style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '-0.02em',
            margin: 0,
          }}>
            HOW TO PROGRESS BETWEEN VERSIONS
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        {/* 4-step horizontal flow */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            gap: '4px',
            marginTop: '28px',
            alignItems: 'stretch',
          }}
        >
          {steps.map((s, i) => (
            <motion.div
              key={s.label}
              variants={fadeInUp}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                position: 'relative',
                padding: '16px 10px 14px',
                borderTop: `3px solid ${colors.gold}`,
              }}
            >
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 900,
                fontSize: 'clamp(0.8rem, 1.4vw, 1.1rem)',
                color: colors.gold,
                opacity: 0.2,
                marginBottom: '4px',
              }}>
                {s.icon}
              </div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.6rem, 0.9vw, 0.75rem)',
                color: colors.text,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
                marginBottom: '4px',
              }}>
                {s.label}
              </div>
              <div style={{
                fontFamily: 'monospace',
                fontWeight: 600,
                fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                color: colors.gold,
                marginBottom: '4px',
              }}>
                {s.command}
              </div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.45rem, 0.6vw, 0.52rem)',
                color: colors.textDim,
                textAlign: 'center',
                lineHeight: 1.3,
              }}>
                {s.desc}
              </div>
              {i < steps.length - 1 && (
                <div style={{
                  position: 'absolute',
                  right: '-8px',
                  top: '50%',
                  transform: 'translateY(-50%)',
                  width: 0,
                  height: 0,
                  borderTop: '6px solid transparent',
                  borderBottom: '6px solid transparent',
                  borderLeft: `8px solid ${colors.gold}`,
                  opacity: 0.35,
                  zIndex: 2,
                }} />
              )}
            </motion.div>
          ))}
        </motion.div>

        {/* Two-panel bottom */}
        <div style={{ display: 'flex', flex: 1, gap: '32px', marginTop: '24px' }}>
          {/* Left: Progression checklist table */}
          <motion.div
            variants={fadeIn}
            initial="hidden"
            animate="show"
            style={{ flex: 3 }}
          >
            <h3 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '10px',
            }}>
              PROGRESSION CHECKLIST
            </h3>
            <div style={{ width: '100%' }}>
              {/* Table header */}
              <div style={{
                display: 'grid',
                gridTemplateColumns: '2fr 1.2fr 1fr',
                gap: '1px',
                marginBottom: '2px',
              }}>
                {['ACTION', 'COMMAND', 'APPROVAL'].map(h => (
                  <div key={h} style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                    color: colors.gold,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                    padding: '6px 8px',
                    borderBottom: `1px solid ${colors.gold}33`,
                  }}>
                    {h}
                  </div>
                ))}
              </div>
              {/* Table rows */}
              {checklist.map((row, i) => (
                <div key={i} style={{
                  display: 'grid',
                  gridTemplateColumns: '2fr 1.2fr 1fr',
                  gap: '1px',
                  background: i % 2 === 0 ? 'rgba(255,255,255,0.02)' : 'transparent',
                }}>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                    color: colors.text,
                    padding: '5px 8px',
                    lineHeight: 1.3,
                  }}>
                    {row.action}
                  </div>
                  <div style={{
                    fontFamily: 'monospace',
                    fontWeight: 400,
                    fontSize: 'clamp(0.38rem, 0.5vw, 0.45rem)',
                    color: colors.gold,
                    padding: '5px 8px',
                    lineHeight: 1.3,
                  }}>
                    {row.command}
                  </div>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.38rem, 0.5vw, 0.45rem)',
                    color: colors.textDim,
                    padding: '5px 8px',
                    lineHeight: 1.3,
                  }}>
                    {row.approval}
                  </div>
                </div>
              ))}
            </div>
          </motion.div>

          {/* Right: When VANA is not met */}
          <motion.div
            variants={fadeIn}
            initial="hidden"
            animate="show"
            transition={{ delay: 0.4 }}
            style={{ flex: 2 }}
          >
            <h3 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
              color: colors.ruby,
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '10px',
            }}>
              WHEN VANA IS NOT MET
            </h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {vanaFails.map((item, i) => (
                <div key={i} style={{
                  borderLeft: `3px solid ${colors.ruby}`,
                  paddingLeft: '12px',
                }}>
                  <p style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    margin: 0,
                    lineHeight: 1.5,
                  }}>
                    {item}
                  </p>
                </div>
              ))}
            </div>
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
