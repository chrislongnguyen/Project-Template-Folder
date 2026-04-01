import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const zones = ['ALIGN', 'LEARN', 'PLAN', 'EXECUTE', 'IMPROVE'];
const phases = ['DESIGN', 'SEQUENCE', 'BUILD', 'VALIDATE'];

const cells: Record<string, string[]> = {
  ALIGN:   ['Charter + Force Analysis', 'OKR Register', 'Charter (final)', 'VALIDATE.md'],
  LEARN:   ['/learn pipeline', '/learn pipeline', 'UBS-UDS + EPs', '/learn:review'],
  PLAN:    ['UBS Register', 'Roadmap + Drivers', 'Architecture doc', 'VALIDATE.md'],
  EXECUTE: ['DESIGN.md (ACs)', 'SEQUENCE.md (tasks)', 'Zone artifacts', 'VALIDATE.md'],
  IMPROVE: ['Metrics Baseline', 'Retro Plan', 'Feedback Register', 'Version Review'],
};

export default function MatrixSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '64px 72px 48px' }}>
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
            THE 5×4 MATRIX
          </h1>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
            color: colors.textDim,
            marginTop: '8px',
            letterSpacing: '0.04em',
          }}>
            Each zone produces artifacts through 4 DSBV phases — agents assigned per phase
          </p>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '10px',
          }} />
        </AnimatedText>

        {/* Matrix grid */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ width: '100%', maxWidth: '960px' }}
          >
            {/* Header row */}
            <motion.div
              variants={fadeInUp}
              style={{
                display: 'grid',
                gridTemplateColumns: '140px repeat(4, 1fr)',
                gap: '2px',
                marginBottom: '2px',
              }}
            >
              {/* Corner cell */}
              <div style={{
                padding: '12px 14px',
                background: 'rgba(0, 72, 81, 0.3)',
                borderRadius: '4px 0 0 0',
              }}>
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.08em',
                }}>
                  PD
                </span>
              </div>
              {phases.map((phase, i) => (
                <div key={phase} style={{
                  padding: '12px 14px',
                  background: 'rgba(0, 72, 81, 0.4)',
                  borderRadius: i === phases.length - 1 ? '0 4px 0 0' : 0,
                  textAlign: 'center',
                }}>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                  }}>
                    {phase}
                  </span>
                </div>
              ))}
            </motion.div>

            {/* Data rows */}
            {zones.map((ws, rowIdx) => (
              <motion.div
                key={ws}
                variants={fadeInUp}
                style={{
                  display: 'grid',
                  gridTemplateColumns: '140px repeat(4, 1fr)',
                  gap: '2px',
                  marginBottom: '2px',
                }}
              >
                {/* Row header */}
                <div style={{
                  padding: '14px 14px',
                  background: 'rgba(242, 199, 92, 0.12)',
                  borderRadius: rowIdx === zones.length - 1 ? '0 0 0 4px' : 0,
                  display: 'flex',
                  alignItems: 'center',
                }}>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: colors.gold,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                  }}>
                    {ws}
                  </span>
                </div>
                {/* Data cells */}
                {cells[ws].map((cell, colIdx) => (
                  <div key={cell} style={{
                    padding: '14px 10px',
                    background: 'rgba(255, 255, 255, 0.03)',
                    borderRadius:
                      rowIdx === zones.length - 1 && colIdx === 3
                        ? '0 0 4px 0' : 0,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                  }}>
                    <span style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                      color: colors.textDim,
                      textAlign: 'center',
                      lineHeight: 1.3,
                    }}>
                      {cell}
                    </span>
                  </div>
                ))}
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Note */}
        <AnimatedText delay={0.7}>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
            color: colors.muted,
            textAlign: 'center',
            margin: 0,
          }}>
            Design + Sequence → <span style={{ color: colors.gold, fontWeight: 700 }}>ltc-planner (Opus)</span> | Build → <span style={{ color: colors.gold, fontWeight: 700 }}>ltc-builder (Sonnet)</span> | Validate → <span style={{ color: colors.gold, fontWeight: 700 }}>ltc-reviewer (Opus)</span>
          </p>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
