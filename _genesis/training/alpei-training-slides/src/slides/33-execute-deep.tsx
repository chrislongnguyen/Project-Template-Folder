import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const stages = ['DESIGN.md (ACs)', 'SEQUENCE.md (TASKS)', 'ZONE ARTIFACTS', 'VALIDATE.md'];

const tableRows = [
  {
    stage: 'DESIGN',
    command: '/dsbv design execute',
    template: 'DESIGN.md',
    pm: 'Approve ACs',
    ai: 'Draft DESIGN.md with ACs',
  },
  {
    stage: 'SEQUENCE',
    command: '/dsbv sequence execute',
    template: 'SEQUENCE.md',
    pm: 'Approve deliverables',
    ai: 'Create task sequence, deps',
  },
  {
    stage: 'BUILD',
    command: '/dsbv build execute',
    template: 'Zone artifacts',
    pm: 'Monitor output',
    ai: 'Write code, run tests, build docs, self-verify, update versioning',
  },
  {
    stage: 'VALIDATE',
    command: '/dsbv validate execute',
    template: 'VALIDATE.md',
    pm: 'Sign-off',
    ai: 'Validate against DESIGN.md ACs',
  },
];

const principles = [
  { label: 'CHAIN-OF-CUSTODY', desc: 'Architecture + Risk Register inherited from PLAN' },
  { label: 'GATE ENFORCEMENT', desc: 'No build without approved DESIGN.md and SEQUENCE.md' },
  { label: 'TEST BEFORE SHIPPING', desc: 'Validate correctness before marking complete' },
];

export default function ExecuteDeepSlide() {
  return (
    <SlideLayout>
      {/* Midnight green accent bar */}
      <motion.div
        initial={{ scaleY: 0 }}
        animate={{ scaleY: 1 }}
        transition={{ duration: 0.6, ease: [0.25, 0.1, 0.25, 1] }}
        style={{
          position: 'absolute',
          left: 0,
          top: 0,
          bottom: 0,
          width: '5px',
          background: colors.midnightLight,
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
          padding: '40px 80px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Headline + Subtitle */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.3rem, 2.5vw, 2rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: 0,
            }}
          >
            DEEP DIVE: EXECUTE
          </h1>
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 1vw, 0.85rem)',
              color: colors.textDim,
              marginTop: '6px',
              marginBottom: '20px',
            }}
          >
            Build and deliver
          </p>
        </AnimatedText>

        {/* Stage flow */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0px',
            marginBottom: '20px',
          }}
        >
          {stages.map((stage, i) => (
            <motion.div
              key={stage}
              variants={fadeInUp}
              style={{ display: 'flex', alignItems: 'center' }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.48rem, 0.75vw, 0.65rem)',
                  color: colors.text,
                  background: colors.midnight,
                  padding: '6px 14px',
                  borderRadius: '14px',
                  textTransform: 'uppercase',
                  letterSpacing: '0.03em',
                  whiteSpace: 'nowrap',
                  border: `1px solid ${colors.midnightLight}44`,
                }}
              >
                {stage}
              </span>
              {i < stages.length - 1 && (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.7rem, 1vw, 0.9rem)',
                    color: colors.midnightLight,
                    padding: '0 8px',
                  }}
                >
                  &#8594;
                </span>
              )}
            </motion.div>
          ))}
        </motion.div>

        {/* Table */}
        <AnimatedText delay={0.3}>
          <div>
            <div
              style={{
                display: 'flex',
                borderBottom: `2px solid ${colors.midnightLight}55`,
                padding: '8px 0',
              }}
            >
              {['PHASE', 'COMMAND', 'TEMPLATE', 'PM ROLE', 'AGENT'].map((h) => (
                <span
                  key={h}
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.midnightLight,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    flex: h === 'PHASE' ? 0.7 : 1,
                  }}
                >
                  {h}
                </span>
              ))}
            </div>
            {tableRows.map((row, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  borderBottom: i < tableRows.length - 1 ? `1px solid ${colors.midnight}22` : 'none',
                  padding: '7px 0',
                }}
              >
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)', color: colors.text, flex: 0.7, textTransform: 'uppercase' }}>{row.stage}</span>
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)', color: colors.textDim, flex: 1 }}>{row.command}</span>
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)', color: colors.textDim, flex: 1 }}>{row.template}</span>
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)', color: colors.textDim, flex: 1 }}>{row.pm}</span>
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)', color: colors.textDim, flex: 1 }}>{row.ai}</span>
              </div>
            ))}
          </div>
        </AnimatedText>

        {/* Key principles */}
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.6 }}
          style={{
            marginTop: '14px',
            padding: '10px 16px',
            borderLeft: `3px solid ${colors.midnightLight}`,
          }}
        >
          <div style={{ display: 'flex', gap: '32px', marginBottom: '12px' }}>
            {principles.map((p) => (
              <div key={p.label} style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 800, fontSize: 'clamp(0.48rem, 0.75vw, 0.62rem)', color: colors.midnightLight }}>{p.label}</span>
                <span style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.58vw, 0.5rem)', color: colors.textDim }}>{p.desc}</span>
              </div>
            ))}
          </div>
          <div style={{ display: 'flex', gap: '24px', padding: '8px 0', background: 'rgba(242, 199, 92, 0.06)', borderRadius: '4px' }}>
            <div style={{ flex: 1, paddingLeft: '8px' }}>
              <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.gold, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '2px' }}>YOU (ACCOUNTABLE)</div>
              <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Approve technical ACs · Review deliverables · Accept or reject output · Final sign-off</div>
            </div>
            <div style={{ width: '1px', background: 'rgba(242, 199, 92, 0.2)' }} />
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.midnightLight, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '2px' }}>AGENT (RESPONSIBLE)</div>
              <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Write source code · Run tests · Build documentation · Self-verify against ACs · Update versioning</div>
            </div>
          </div>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
