import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const teams = [
  { name: 'ltc-explorer', when: 'Pre-DSBV research', agents: 'Haiku — read-only', color: '#69C7CC' },
  { name: 'ltc-planner', when: 'Design + Sequence', agents: 'Opus — defines WHAT', color: colors.gold },
  { name: 'ltc-builder', when: 'Build phase', agents: 'Sonnet — produces artifacts', color: '#69994D' },
  { name: 'ltc-reviewer', when: 'Validate phase', agents: 'Opus — reviews vs DESIGN', color: colors.ruby },
];

const steps = [
  { num: '1', label: 'You run /dsbv {phase}' },
  { num: '2', label: 'Pre-flight checks fire' },
  { num: '3', label: 'Correct agent dispatched' },
  { num: '4', label: 'Artifact produced' },
  { num: '5', label: 'You approve at gate' },
];

export default function AgentTeamsSlide() {
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
            4 MECE AGENTS
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Team cards - horizontal */}
        <div style={{ marginTop: '28px' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              display: 'flex',
              gap: '10px',
            }}
          >
            {teams.map((team) => (
              <motion.div
                key={team.name}
                variants={fadeInUp}
                style={{
                  flex: 1,
                  padding: '20px 16px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                  borderRadius: '6px',
                  background: 'rgba(255, 255, 255, 0.02)',
                  borderTop: `3px solid ${team.color}`,
                }}
              >
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                  color: team.color,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                  marginBottom: '8px',
                }}>
                  {team.name}
                </div>
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.4rem, 0.6vw, 0.5rem)',
                  color: colors.textDim,
                  marginBottom: '6px',
                }}>
                  {team.when}
                </div>
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                  color: colors.muted,
                }}>
                  {team.agents}
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* How it works */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <AnimatedText delay={0.5}>
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginBottom: '20px',
            }}>
              HOW IT WORKS
            </div>
          </AnimatedText>

          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', alignItems: 'center', gap: '6px' }}
          >
            {steps.map((step, i) => (
              <motion.div
                key={step.num}
                variants={fadeInUp}
                style={{ display: 'flex', alignItems: 'center', gap: '6px', flex: 1 }}
              >
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '10px',
                  padding: '12px 14px',
                  background: 'rgba(0, 72, 81, 0.15)',
                  borderRadius: '6px',
                  border: '1px solid rgba(255, 255, 255, 0.04)',
                  flex: 1,
                }}>
                  <div style={{
                    width: '28px',
                    height: '28px',
                    borderRadius: '50%',
                    background: i === 0 || i === 4 ? colors.gold : 'rgba(0, 72, 81, 0.4)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0,
                  }}>
                    <span style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.4rem, 0.6vw, 0.5rem)',
                      color: i === 0 || i === 4 ? colors.gunmetalDark : colors.text,
                    }}>
                      {step.num}
                    </span>
                  </div>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 500,
                    fontSize: 'clamp(0.4rem, 0.6vw, 0.5rem)',
                    color: colors.textDim,
                    lineHeight: 1.3,
                  }}>
                    {step.label}
                  </span>
                </div>
                {i < steps.length - 1 && (
                  <div style={{
                    color: colors.muted,
                    fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
                    opacity: 0.3,
                    flexShrink: 0,
                  }}>
                    ›
                  </div>
                )}
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Key point */}
        <AnimatedText delay={0.8}>
          <div style={{
            borderLeft: `3px solid ${colors.gold}`,
            padding: '10px 0 10px 20px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 500,
              fontSize: 'clamp(0.55rem, 0.85vw, 0.75rem)',
              color: colors.textDim,
              fontStyle: 'italic',
              margin: 0,
            }}>
              "Each agent has a scope boundary. No agent designs AND builds."
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
