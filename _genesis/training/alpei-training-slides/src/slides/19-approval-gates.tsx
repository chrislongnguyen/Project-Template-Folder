import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const gates = [
  {
    num: 1,
    name: 'DESIGN GATE',
    when: 'Before any work begins',
    approve: 'DESIGN.md — artifact list, ACs, alignment',
    decide: 'Are these the RIGHT things? Approve → Sequence unlocks',
    command: '/dsbv design',
  },
  {
    num: 2,
    name: 'SEQUENCE GATE',
    when: 'After design approved',
    approve: 'SEQUENCE.md — task order, dependencies, estimates',
    decide: 'Is this the RIGHT order? Approve → Build unlocks',
    command: '/dsbv sequence',
  },
  {
    num: 3,
    name: 'BUILD GATE',
    when: 'After artifacts produced',
    approve: 'Zone artifacts vs DESIGN.md ACs',
    decide: 'Are deliverables CORRECT? Approve → Validate unlocks',
    command: '/dsbv build',
  },
  {
    num: 4,
    name: 'VALIDATE GATE',
    when: 'After reviewer reports',
    approve: 'VALIDATE.md — per-criterion PASS/FAIL',
    decide: 'All PASS → zone complete. FAIL → fix & re-validate',
    command: '/dsbv validate',
  },
];

export default function ApprovalGatesSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '60px 72px 44px' }}>
        {/* Headline */}
        <AnimatedText>
          <h1 style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1.75rem, 3.5vw, 2.75rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '-0.02em',
            margin: 0,
          }}>
            APPROVAL GATES
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Gates flow */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ width: '100%', display: 'flex', flexDirection: 'column', gap: '4px' }}
          >
            {gates.map((gate, i) => (
              <motion.div
                key={gate.num}
                variants={fadeInUp}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '20px',
                  position: 'relative',
                }}
              >
                {/* Numbered circle with connecting line */}
                <div style={{
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  width: '40px',
                  flexShrink: 0,
                }}>
                  <div style={{
                    width: '36px',
                    height: '36px',
                    borderRadius: '50%',
                    background: `linear-gradient(135deg, ${colors.gold}, ${colors.goldDim})`,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    boxShadow: `0 0 16px ${colors.gold}30`,
                  }}>
                    <span style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.gunmetalDark,
                    }}>
                      {gate.num}
                    </span>
                  </div>
                  {i < gates.length - 1 && (
                    <div style={{
                      width: '2px',
                      height: '8px',
                      background: `linear-gradient(180deg, ${colors.gold}40, transparent)`,
                      marginTop: '2px',
                    }} />
                  )}
                </div>

                {/* Gate info row */}
                <div style={{
                  display: 'grid',
                  gridTemplateColumns: '140px 1fr 1.2fr 1.2fr 120px',
                  gap: '16px',
                  flex: 1,
                  alignItems: 'center',
                  padding: '10px 0',
                  borderBottom: i < gates.length - 1 ? '1px solid rgba(255,255,255,0.04)' : 'none',
                }}>
                  {/* Gate name */}
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.04em',
                  }}>
                    {gate.name}
                  </span>

                  {/* When */}
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                  }}>
                    {gate.when}
                  </span>

                  {/* What you approve */}
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.muted,
                  }}>
                    {gate.approve}
                  </span>

                  {/* Decide */}
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                  }}>
                    {gate.decide}
                  </span>

                  {/* Command */}
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.4rem, 0.6vw, 0.5rem)',
                    color: colors.midnightLight,
                    padding: '4px 8px',
                    background: 'rgba(0, 72, 81, 0.2)',
                    borderRadius: '3px',
                    textAlign: 'center',
                  }}>
                    {gate.command}
                  </span>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Rule */}
        <AnimatedText delay={0.8}>
          <div style={{
            borderLeft: `3px solid ${colors.ruby}`,
            padding: '10px 0 10px 20px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 600,
              fontSize: 'clamp(0.55rem, 0.85vw, 0.75rem)',
              color: colors.textDim,
              margin: 0,
            }}>
              You make 4 decisions per zone. The AI does the work between gates. Nothing ships without your sign-off.
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
