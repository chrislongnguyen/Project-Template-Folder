import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const stages = ['UBS REGISTER', 'ROADMAP + DRIVERS', 'ARCHITECTURE', 'VALIDATE.md'];

const tableRows = [
  {
    stage: 'DESIGN',
    command: '/dsbv design plan',
    template: 'DESIGN.md',
    pm: 'Approve risks inventory',
    ai: 'Inventory UBS, map UDS',
  },
  {
    stage: 'SEQUENCE',
    command: '/dsbv sequence plan',
    template: 'SEQUENCE.md',
    pm: 'Approve roadmap',
    ai: 'Draft roadmap + driver register',
  },
  {
    stage: 'BUILD',
    command: '/dsbv build plan',
    template: 'Architecture doc',
    pm: 'Approve architecture',
    ai: 'Draft architecture, create roadmap',
  },
  {
    stage: 'VALIDATE',
    command: '/dsbv validate plan',
    template: 'VALIDATE.md',
    pm: 'Lock plan',
    ai: 'Validate per-AC, produce report',
  },
];

const principles = [
  { label: 'DERISK-FIRST', desc: 'Sustainability before efficiency before scalability' },
  { label: 'RACI EVERY TASK', desc: 'AI is Responsible, human is Accountable' },
  { label: 'LOCK BEFORE EXECUTE', desc: 'No execution without a frozen plan' },
];

export default function PlanDeepSlide() {
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
            DEEP DIVE: PLAN
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
            Create the execution plan
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

        {/* RACI */}
        <div style={{ display: 'flex', gap: '24px', marginTop: '14px', padding: '10px 16px', background: 'rgba(242, 199, 92, 0.06)', borderRadius: '6px' }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.gold, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '4px' }}>YOU (ACCOUNTABLE)</div>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Approve risk mitigations · Review architecture · Approve roadmap milestones · Lock plan</div>
          </div>
          <div style={{ width: '1px', background: 'rgba(242, 199, 92, 0.2)' }} />
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.midnightLight, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '4px' }}>AGENT (RESPONSIBLE)</div>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Inventory risks (UBS) · Map drivers (UDS) · Draft architecture · Create roadmap · Validate completeness</div>
          </div>
        </div>
      </div>
    </SlideLayout>
  );
}
