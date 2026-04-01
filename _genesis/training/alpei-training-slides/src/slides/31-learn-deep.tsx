import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const stages = ['/learn:input', '/learn:research', '/learn:structure', '/learn:spec'];

const tableRows = [
  {
    stage: 'INPUT',
    command: '/learn:input',
    template: 'Raw input scope',
    pm: 'Provide raw input, define questions',
    ai: 'Scope research boundaries',
  },
  {
    stage: 'RESEARCH',
    command: '/learn:research',
    template: 'Research findings',
    pm: 'Validate research direction',
    ai: 'Deep analysis, synthesize UBS/UDS',
  },
  {
    stage: 'STRUCTURE',
    command: '/learn:structure',
    template: 'UBS/UDS + EPs',
    pm: 'Validate Effective Principles',
    ai: 'Derive EPs from UBS/UDS evidence',
  },
  {
    stage: 'SPEC',
    command: '/learn:spec',
    template: 'Learning spec output',
    pm: 'Approve specs',
    ai: 'Write specs, produce /learn:review',
  },
];

const concepts = [
  { abbr: 'UBS', name: 'User Blocker System', desc: 'What prevents success' },
  { abbr: 'UDS', name: 'User Driver System', desc: 'What enables success' },
  { abbr: 'EP', name: 'Effective Principles', desc: 'Rules derived from UBS/UDS' },
];

export default function LearnDeepSlide() {
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
          width: '5px',
          background: colors.midnight,
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
            DEEP DIVE: LEARN
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
            Understand why things work or fail
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
                borderBottom: `2px solid ${colors.midnight}55`,
                padding: '8px 0',
              }}
            >
              {['STEP', 'COMMAND', 'TEMPLATE', 'PM ROLE', 'AGENT'].map((h) => (
                <span
                  key={h}
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.midnightLight,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    flex: h === 'STEP' ? 0.7 : 1,
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
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Provide raw input (docs, recordings) · Define research questions · Validate Effective Principles · Approve specs</div>
          </div>
          <div style={{ width: '1px', background: 'rgba(242, 199, 92, 0.2)' }} />
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)', color: colors.midnightLight, textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: '4px' }}>AGENT (RESPONSIBLE)</div>
            <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.38rem, 0.55vw, 0.48rem)', color: colors.textDim, lineHeight: 1.4 }}>Scope research · Deep analysis · Synthesize UBS/UDS · Derive Effective Principles · Write spec pages</div>
          </div>
        </div>
      </div>
    </SlideLayout>
  );
}
