import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const workStreams = [
  { name: 'ALIGN', color: '#F2C75C', stages: ['Charter + Force Analysis', 'OKR Register', 'Charter (final)', 'VALIDATE.md'] },
  { name: 'LEARN', color: '#69C7CC', stages: ['/learn:input', '/learn:research', 'UBS-UDS + EPs', '/learn:review'] },
  { name: 'PLAN', color: '#69994D', stages: ['UBS Register', 'Roadmap + Drivers', 'Architecture', 'VALIDATE.md'] },
  { name: 'EXECUTE', color: '#FF9D3B', stages: ['DESIGN.md (ACs)', 'SEQUENCE.md', 'Workstream artifacts', 'VALIDATE.md'] },
  { name: 'IMPROVE', color: '#653469', stages: ['Metrics Baseline', 'Retro Plan', 'Feedback Register', 'Version Review'] },
];

const stageLabels = ['DESIGN', 'SEQUENCE', 'BUILD', 'VALIDATE'];

export default function IterationFlowSlide() {
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
            ONE ITERATION END-TO-END
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        {/* Stage column headers */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: '120px 1fr 1fr 1fr 1fr',
          gap: '2px',
          marginTop: '22px',
          marginBottom: '4px',
        }}>
          <div />
          {stageLabels.map(label => (
            <div key={label} style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.08em',
              textAlign: 'center',
              padding: '4px 0',
            }}>
              {label}
            </div>
          ))}
        </div>

        {/* Flow diagram */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}
          >
            {workStreams.map((ws, wsIdx) => (
              <motion.div
                key={ws.name}
                variants={fadeInUp}
                style={{ position: 'relative' }}
              >
                <div style={{
                  display: 'grid',
                  gridTemplateColumns: '120px 1fr 1fr 1fr 1fr',
                  gap: '2px',
                  alignItems: 'stretch',
                }}>
                  {/* Work stream label */}
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '8px',
                    padding: '10px 12px',
                  }}>
                    <div style={{
                      width: '4px',
                      height: '100%',
                      minHeight: '28px',
                      background: ws.color,
                      borderRadius: '2px',
                      flexShrink: 0,
                    }} />
                    <div style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                      color: ws.color,
                      textTransform: 'uppercase',
                      letterSpacing: '0.05em',
                    }}>
                      {ws.name}
                    </div>
                  </div>

                  {/* 4 stage cells */}
                  {ws.stages.map((stage, sIdx) => (
                    <div key={sIdx} style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      padding: '8px 6px',
                      borderLeft: `1px solid ${ws.color}15`,
                      position: 'relative',
                    }}>
                      <div style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.4rem, 0.58vw, 0.5rem)',
                        color: colors.text,
                        textAlign: 'center',
                        lineHeight: 1.3,
                      }}>
                        {stage}
                      </div>
                      {/* Arrow between stages */}
                      {sIdx < 3 && (
                        <div style={{
                          position: 'absolute',
                          right: '-5px',
                          top: '50%',
                          transform: 'translateY(-50%)',
                          width: 0,
                          height: 0,
                          borderTop: '4px solid transparent',
                          borderBottom: '4px solid transparent',
                          borderLeft: `5px solid ${ws.color}`,
                          opacity: 0.3,
                          zIndex: 2,
                        }} />
                      )}
                    </div>
                  ))}
                </div>

                {/* Vertical arrow between work streams */}
                {wsIdx < workStreams.length - 1 && (
                  <div style={{
                    display: 'flex',
                    justifyContent: 'center',
                    padding: '1px 0',
                  }}>
                    <div style={{
                      width: 0,
                      height: 0,
                      borderLeft: '5px solid transparent',
                      borderRight: '5px solid transparent',
                      borderTop: `6px solid ${colors.gold}`,
                      opacity: 0.35,
                    }} />
                  </div>
                )}
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Bottom: Close iteration loop */}
        <AnimatedText delay={0.8}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
            borderTop: `1px solid ${colors.gold}22`,
            paddingTop: '14px',
          }}>
            <div style={{
              fontFamily: 'monospace',
              fontWeight: 600,
              fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
              color: colors.gold,
              padding: '5px 12px',
              border: `1px solid ${colors.gold}44`,
              borderRadius: '3px',
              whiteSpace: 'nowrap',
            }}>
              /dsbv validate improve
            </div>
            <div style={{
              width: 0,
              height: 0,
              borderTop: '5px solid transparent',
              borderBottom: '5px solid transparent',
              borderLeft: `7px solid ${colors.gold}`,
              opacity: 0.5,
            }} />
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
              color: colors.textDim,
              lineHeight: 1.4,
            }}>
              Close iteration → VANA check → If passed: advance version. If not: back to <span style={{ color: colors.gold, fontWeight: 600 }}>/dsbv design align</span> for another iteration.
            </div>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
