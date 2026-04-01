import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const stages = ['DESIGN.md', 'SEQUENCE.md', 'CHARTER + OKRs', 'VALIDATE.md'];

const tableRows = [
  {
    stage: 'DESIGN',
    command: '/dsbv design align',
    template: 'DESIGN.md',
    pm: 'Define success criteria',
    ai: 'Draft charter from context',
  },
  {
    stage: 'SEQUENCE',
    command: '/dsbv sequence align',
    template: 'SEQUENCE.md',
    pm: 'Approve plan & OKRs',
    ai: 'Generate OKRs, create ADRs',
  },
  {
    stage: 'BUILD',
    command: '/dsbv build align',
    template: 'Charter + OKR Register',
    pm: 'Approve charter artifacts',
    ai: 'Run pre-flight, produce artifacts',
  },
  {
    stage: 'VALIDATE',
    command: '/dsbv validate align',
    template: 'VALIDATE.md',
    pm: 'Review VALIDATE.md',
    ai: 'Produce VALIDATE.md per-AC',
  },
];

export default function AlignDeepSlide() {
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
          width: '5px',
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
            DEEP DIVE: ALIGN
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
            Define what success looks like
          </p>
        </AnimatedText>

        {/* Stage flow diagram */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0px',
            marginBottom: '24px',
          }}
        >
          {stages.map((stage, i) => (
            <motion.div
              key={stage}
              variants={fadeInUp}
              style={{
                display: 'flex',
                alignItems: 'center',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.48rem, 0.75vw, 0.65rem)',
                  color: colors.gunmetal,
                  background: colors.gold,
                  padding: '6px 14px',
                  borderRadius: '14px',
                  textTransform: 'uppercase',
                  letterSpacing: '0.03em',
                  whiteSpace: 'nowrap',
                }}
              >
                {stage}
              </span>
              {i < stages.length - 1 && (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.7rem, 1vw, 0.9rem)',
                    color: colors.gold,
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
            {/* Header */}
            <div
              style={{
                display: 'flex',
                borderBottom: `2px solid ${colors.gold}33`,
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
                    color: colors.gold,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    flex: h === 'PHASE' ? 0.7 : 1,
                  }}
                >
                  {h}
                </span>
              ))}
            </div>

            {/* Rows */}
            {tableRows.map((row, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  borderBottom: i < tableRows.length - 1 ? `1px solid ${colors.midnight}22` : 'none',
                  padding: '7px 0',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.text,
                    flex: 0.7,
                    textTransform: 'uppercase',
                  }}
                >
                  {row.stage}
                </span>

                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    flex: 1,
                  }}
                >
                  {row.command}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    flex: 1,
                  }}
                >
                  {row.template}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    flex: 1,
                  }}
                >
                  {row.pm}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    flex: 1,
                  }}
                >
                  {row.ai}
                </span>
              </div>
            ))}
          </div>
        </AnimatedText>

        {/* RACI */}
        <div style={{ display: 'flex', gap: '24px', marginTop: '14px', padding: '10px 16px', background: 'rgba(242, 199, 92, 0.06)', borderRadius: '6px' }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.gold, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '4px' }}>YOU (ACCOUNTABLE)</div>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Define success criteria · Approve DESIGN.md · Review artifacts · Approve VALIDATE.md · Make final scope decisions</div>
          </div>
          <div style={{ width: '1px', background: 'rgba(242, 199, 92, 0.2)' }} />
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.midnightLight, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '4px' }}>AGENT (RESPONSIBLE)</div>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Draft charter from context · Generate OKRs · Create ADRs · Run pre-flight checks · Produce VALIDATE.md</div>
          </div>
        </div>

        {/* Example flow */}
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.6 }}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            marginTop: '20px',
            padding: '10px 16px',
            borderLeft: `3px solid ${colors.gold}44`,
          }}
        >
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.04em',
            }}
          >
            EXAMPLE:
          </span>
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
              color: colors.textDim,
            }}
          >
            /dsbv design align &#8594; G1 approve &#8594; /dsbv build align &#8594; G4 validate = ALIGN complete
          </span>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
