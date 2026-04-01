import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const stages = ['METRICS BASELINE', 'RETRO PLAN', 'FEEDBACK REGISTER', 'VERSION REVIEW'];

const tableRows = [
  {
    stage: 'DESIGN',
    command: '/dsbv design improve',
    template: 'DESIGN.md',
    pm: 'Define feedback sources',
    ai: 'Collect feedback, analyze',
  },
  {
    stage: 'SEQUENCE',
    command: '/dsbv sequence improve',
    template: 'SEQUENCE.md',
    pm: 'Prioritize findings',
    ai: 'Draft retro plan',
  },
  {
    stage: 'BUILD',
    command: '/dsbv build improve',
    template: 'Feedback Register',
    pm: 'GO/NO-GO decision',
    ai: 'Score pillars, produce review',
  },
  {
    stage: 'VALIDATE',
    command: '/dsbv validate improve',
    template: 'VALIDATE.md',
    pm: 'Authorize version advancement',
    ai: 'Validate improvements applied',
  },
];

const principles = [
  { label: 'EVIDENCE-BASED', desc: 'Every improvement backed by data or feedback' },
  { label: 'THREE PILLARS PRIORITY', desc: 'Fix sustainability issues before optimizing' },
  { label: 'CLOSE THE LOOP', desc: 'Every improvement feeds back into Align' },
];

export default function ImproveDeepSlide() {
  return (
    <SlideLayout>
      {/* Ruby accent bar */}
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
          background: colors.ruby,
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
            DEEP DIVE: IMPROVE
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
            Learn and iterate
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
                  background: `${colors.ruby}88`,
                  padding: '6px 14px',
                  borderRadius: '14px',
                  textTransform: 'uppercase',
                  letterSpacing: '0.03em',
                  whiteSpace: 'nowrap',
                  border: `1px solid ${colors.ruby}44`,
                }}
              >
                {stage}
              </span>
              {i < stages.length - 1 && (
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.7rem, 1vw, 0.9rem)',
                    color: colors.ruby,
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
                borderBottom: `2px solid ${colors.ruby}44`,
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
                    color: colors.ruby,
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
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Define feedback sources · Prioritize findings · GO/NO-GO · Authorize version advancement</div>
          </div>
          <div style={{ width: '1px', background: 'rgba(242, 199, 92, 0.2)' }} />
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.midnightLight, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '4px' }}>AGENT (RESPONSIBLE)</div>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Collect feedback · Analyze · Draft retro · Score pillars · Produce review</div>
          </div>
        </div>
      </div>
    </SlideLayout>
  );
}
