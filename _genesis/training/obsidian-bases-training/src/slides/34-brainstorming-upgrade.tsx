import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const comparisonRows = [
  {
    aspect: 'Triggering',
    i1: 'You type /brainstorming explicitly',
    i2: 'Auto-triggered — AI leads with inference',
  },
  {
    aspect: 'Structure',
    i1: '9-step sequential checklist',
    i2: '4 invisible gates run automatically',
  },
  {
    aspect: 'First interaction',
    i1: '"What do you want to build?"',
    i2: 'AI infers EO first, then asks ONE focused question',
  },
  {
    aspect: 'Force analysis',
    i1: 'Not explicit',
    i2: 'Mandatory UBS + UDS — blockers AND drivers',
  },
  {
    aspect: 'Message discipline',
    i1: 'One question preferred',
    i2: '1 question per message (hard rule)',
  },
  {
    aspect: 'Output',
    i1: 'Design spec → writing-plans skill',
    i2: 'Discovery Complete pre-spec → /dsbv',
  },
];

const gates = [
  {
    num: '1',
    title: 'EO (Effective Outcome)',
    desc: 'Infers your desired outcome as VANA — asks you to confirm or correct',
  },
  {
    num: '2',
    title: 'SCOPE',
    desc: 'Checks if EO spans multiple systems — narrows to a single system boundary',
  },
  {
    num: '3',
    title: 'FORCE ANALYSIS',
    desc: 'Surfaces UBS (blockers) first, then UDS (drivers) — exit: ≥2 blockers + ≥1 driver',
  },
  {
    num: '4',
    title: 'APPROACH',
    desc: 'Evaluates ≥2 paths using S > E > Sc — exit: approach chosen with rationale',
  },
];

export default function BrainstormingUpgradeSlide() {
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
          padding: '28px 80px 24px 100px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.05}>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.1rem, 2.1vw, 1.65rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 6px 0',
            }}
          >
            /LTC-BRAINSTORMING — THE UPGRADE
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '14px' }} />
        </AnimatedText>

        {/* Split layout */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px', flex: 1, minHeight: 0 }}>

          {/* Left: comparison table */}
          <motion.div variants={fadeInLeft} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
            {/* Column headers */}
            <div style={{ display: 'grid', gridTemplateColumns: '90px 1fr 1fr', gap: '6px', padding: '0 0 4px 0' }}>
              {['ASPECT', 'I1 (Superpowers)', 'I2 (Discovery Protocol)'].map((h, i) => (
                <span key={h} style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                  color: i === 2 ? colors.gold : colors.muted,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                }}>{h}</span>
              ))}
            </div>

            {comparisonRows.map((row, i) => (
              <div key={i} style={{
                display: 'grid',
                gridTemplateColumns: '90px 1fr 1fr',
                gap: '6px',
                padding: '7px 8px',
                borderRadius: '4px',
                background: 'rgba(29,31,42,0.4)',
                border: '1px solid rgba(255,255,255,0.05)',
                alignItems: 'start',
              }}>
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.45rem, 0.62vw, 0.54rem)',
                  color: colors.textDim,
                }}>{row.aspect}</span>
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.45rem, 0.62vw, 0.54rem)',
                  color: colors.muted,
                  opacity: 0.75,
                  lineHeight: 1.4,
                }}>{row.i1}</span>
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 500,
                  fontSize: 'clamp(0.45rem, 0.62vw, 0.54rem)',
                  color: colors.text,
                  lineHeight: 1.4,
                }}>{row.i2}</span>
              </div>
            ))}
          </motion.div>

          {/* Right: 4 invisible gates */}
          <motion.div variants={fadeInRight} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '0' }}>
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.08em',
              marginBottom: '10px',
            }}>The 4 Invisible Gates</div>

            {gates.map((gate, i) => (
              <div key={gate.num} style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start' }}>
                <div style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '10px',
                  padding: '8px 12px',
                  borderRadius: '5px',
                  background: 'rgba(29,31,42,0.45)',
                  border: `1px solid ${colors.gold}20`,
                  width: '100%',
                }}>
                  {/* Number circle */}
                  <div style={{
                    width: '24px',
                    height: '24px',
                    borderRadius: '50%',
                    background: `${colors.gold}18`,
                    border: `1.5px solid ${colors.gold}70`,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0,
                  }}>
                    <span style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.45rem, 0.6vw, 0.52rem)',
                      color: colors.gold,
                    }}>{gate.num}</span>
                  </div>
                  <div>
                    <div style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                      color: colors.text,
                      marginBottom: '2px',
                    }}>{gate.title}</div>
                    <div style={{
                      fontFamily: 'Inter, sans-serif',
                      fontSize: 'clamp(0.45rem, 0.62vw, 0.53rem)',
                      color: colors.textDim,
                      lineHeight: 1.4,
                    }}>{gate.desc}</div>
                  </div>
                </div>
                {/* Connector line */}
                {i < gates.length - 1 && (
                  <div style={{
                    width: '1.5px',
                    height: '8px',
                    background: `${colors.gold}40`,
                    marginLeft: '23px',
                  }} />
                )}
              </div>
            ))}
          </motion.div>
        </div>

        {/* Bottom flow */}
        <motion.div variants={fadeInUp} initial="hidden" animate="show" style={{ marginTop: '12px' }}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0',
            padding: '8px 14px',
            borderRadius: '5px',
            background: `${colors.gold}07`,
            border: `1px solid ${colors.gold}30`,
          }}>
            {[
              { label: '/ltc-brainstorming', sub: 'Discovery Protocol' },
              null,
              { label: 'Discovery Complete', sub: '5 structured fields' },
              null,
              { label: '/dsbv', sub: 'Design phase' },
            ].map((item, i) => {
              if (item === null) {
                return (
                  <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '0 10px' }}>
                    <div style={{ width: '16px', height: '1.5px', background: `${colors.gold}60` }} />
                    <div style={{
                      width: 0, height: 0,
                      borderTop: '4px solid transparent',
                      borderBottom: '4px solid transparent',
                      borderLeft: `6px solid ${colors.gold}60`,
                    }} />
                  </div>
                );
              }
              return (
                <div key={i} style={{ textAlign: 'center' }}>
                  <div style={{
                    fontFamily: "'Courier New', Courier, monospace",
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                    color: colors.gold,
                  }}>{item.label}</div>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                    color: colors.muted,
                  }}>{item.sub}</div>
                </div>
              );
            })}
          </div>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
