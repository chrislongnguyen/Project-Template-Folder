import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeIn, staggerContainer, staggerFast } from '../lib/animations';

const steps = [
  { step: 1,  desc: 'Create/update project charter',          command: '/dsbv design align',       gate: 'PM review' },
  { step: 2,  desc: 'Define master plan & OKRs',              command: '/dsbv sequence align',     gate: 'PM sign-off' },
  { step: 3,  desc: 'Build alignment deliverables',           command: '/dsbv build align',        gate: 'PM approval' },
  { step: 4,  desc: 'Validate alignment completeness',        command: '/dsbv validate align',     gate: 'Auto-check' },
  { step: 5,  desc: 'Scope learning objectives',              command: '/learn:input',             gate: '' },
  { step: 6,  desc: 'Run research pipeline',                  command: '/learn:research',          gate: '' },
  { step: 7,  desc: 'Structure UBS/UDS + EPs',                command: '/learn:structure',         gate: 'PM review' },
  { step: 8,  desc: 'Review learning outputs',                command: '/learn:review',            gate: 'Auto-check' },
  { step: 9,  desc: 'Design plan zone',                       command: '/dsbv design plan',        gate: '' },
  { step: 10, desc: 'Sequence plan zone tasks',               command: '/dsbv sequence plan',      gate: 'PM review' },
  { step: 11, desc: 'Build plan artifacts',                   command: '/dsbv build plan',         gate: '' },
  { step: 12, desc: 'Validate plan completeness',             command: '/dsbv validate plan',      gate: 'Auto-check' },
  { step: 13, desc: 'Build execute zone artifacts',           command: '/dsbv build execute',      gate: '' },
  { step: 14, desc: 'Validate execution deliverables',        command: '/dsbv validate execute',   gate: 'PM review' },
  { step: 15, desc: 'Build improve zone',                     command: '/dsbv build improve',      gate: 'PM review' },
  { step: 16, desc: 'Validate improve & close iteration',     command: '/dsbv validate improve',   gate: 'PM approval' },
];

export default function IterationChecklistSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '52px 80px 40px' }}>
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
            ITERATION CHECKLIST
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        {/* Table */}
        <motion.div
          variants={fadeIn}
          initial="hidden"
          animate="show"
          style={{ flex: 1, marginTop: '20px', overflow: 'hidden' }}
        >
          {/* Header row */}
          <div style={{
            display: 'grid',
            gridTemplateColumns: '40px 2.5fr 1.5fr 1fr 36px',
            gap: '1px',
            borderBottom: `2px solid ${colors.gold}44`,
            paddingBottom: '6px',
            marginBottom: '2px',
          }}>
            {['#', 'STEP DESCRIPTION', 'COMMAND', 'APPROVAL GATE', '\u2713'].map(h => (
              <div key={h} style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.38rem, 0.5vw, 0.44rem)',
                color: colors.gold,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
                padding: '4px 6px',
              }}>
                {h}
              </div>
            ))}
          </div>

          {/* Data rows */}
          <motion.div
            variants={staggerFast}
            initial="hidden"
            animate="show"
          >
            {steps.map((row, i) => {
              // Color code by work stream
              const wsColor = row.step <= 4 ? '#F2C75C'
                : row.step <= 8 ? '#69C7CC'
                : row.step <= 12 ? '#69994D'
                : row.step <= 14 ? '#FF9D3B'
                : row.step <= 15 ? '#653469'
                : colors.gold;

              return (
                <motion.div
                  key={row.step}
                  variants={fadeIn}
                  style={{
                    display: 'grid',
                    gridTemplateColumns: '40px 2.5fr 1.5fr 1fr 36px',
                    gap: '1px',
                    background: i % 2 === 0 ? 'rgba(255,255,255,0.02)' : 'transparent',
                    borderLeft: `3px solid ${wsColor}`,
                  }}
                >
                  {/* Step number */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.38rem, 0.5vw, 0.44rem)',
                    color: wsColor,
                    padding: '4px 6px',
                    textAlign: 'center',
                  }}>
                    {String(row.step).padStart(2, '0')}
                  </div>

                  {/* Description */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.38rem, 0.5vw, 0.44rem)',
                    color: colors.text,
                    padding: '4px 6px',
                    lineHeight: 1.3,
                  }}>
                    {row.desc}
                  </div>

                  {/* Command */}
                  <div style={{
                    fontFamily: 'monospace',
                    fontSize: 'clamp(0.35rem, 0.48vw, 0.42rem)',
                    color: colors.gold,
                    padding: '4px 6px',
                    lineHeight: 1.3,
                  }}>
                    {row.command}
                  </div>

                  {/* Approval gate */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: row.gate ? 600 : 400,
                    fontSize: 'clamp(0.35rem, 0.48vw, 0.42rem)',
                    color: row.gate === 'PM approval' ? colors.gold : row.gate ? colors.textDim : 'rgba(255,255,255,0.15)',
                    padding: '4px 6px',
                    lineHeight: 1.3,
                  }}>
                    {row.gate || '—'}
                  </div>

                  {/* Checkbox */}
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '4px 6px',
                  }}>
                    <div style={{
                      width: '12px',
                      height: '12px',
                      border: `1px solid ${colors.gold}44`,
                      borderRadius: '2px',
                    }} />
                  </div>
                </motion.div>
              );
            })}
          </motion.div>
        </motion.div>

        {/* Legend */}
        <AnimatedText delay={0.6}>
          <div style={{
            display: 'flex',
            gap: '20px',
            marginTop: '10px',
            paddingTop: '8px',
            borderTop: `1px solid ${colors.gold}15`,
          }}>
            {[
              { color: '#F2C75C', label: 'Align' },
              { color: '#69C7CC', label: 'Learn' },
              { color: '#69994D', label: 'Plan' },
              { color: '#FF9D3B', label: 'Execute' },
              { color: '#653469', label: 'Improve' },
            ].map(item => (
              <div key={item.label} style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
                <div style={{ width: '10px', height: '3px', background: item.color, borderRadius: '1px' }} />
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.35rem, 0.45vw, 0.4rem)',
                  color: colors.textDim,
                  letterSpacing: '0.03em',
                }}>
                  {item.label}
                </span>
              </div>
            ))}
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
