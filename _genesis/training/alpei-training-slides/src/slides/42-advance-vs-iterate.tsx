import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const advanceConditions = [
  'ALL VANA criteria met for the current version',
  'Chain-of-custody intact — no missing upstream outputs',
  'Audit passed for every work stream',
  'PM has reviewed and approved all deliverables',
];

const iterateConditions = [
  'One or more VANA criteria not yet satisfied',
  'Upstream sub-system needs more iteration at same version',
  'Deliverables exist but quality needs refinement',
  'Feedback from Improve reveals gaps to address',
];

const decisionSteps = [
  { label: 'RUN', desc: '/dsbv validate improve', isCommand: true },
  { label: 'CHECK', desc: 'All criteria met?', isCommand: false },
  { label: 'YES', desc: 'Close + Advance', isCommand: false, color: '#69994D' },
  { label: 'NO (MINOR)', desc: 'Iterate at same version', isCommand: false, color: colors.gold },
  { label: 'NO (MAJOR)', desc: 'Reassess scope & plan', isCommand: false, color: colors.ruby },
];

export default function AdvanceVsIterateSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '56px 80px 44px' }}>
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
            WHEN TO ADVANCE VS. ITERATE
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        {/* Two-panel split */}
        <div style={{ display: 'flex', flex: 1, gap: '32px', marginTop: '28px' }}>
          {/* LEFT: Advance When */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
              borderRight: '1px solid rgba(255,255,255,0.06)',
              paddingRight: '32px',
            }}
          >
            <h2 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
              color: '#69994D',
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '20px',
            }}>
              ADVANCE WHEN
            </h2>

            <StaggerGroup>
              {advanceConditions.map((cond, i) => (
                <StaggerItem key={i}>
                  <div style={{
                    display: 'flex',
                    gap: '10px',
                    alignItems: 'flex-start',
                    marginBottom: '14px',
                  }}>
                    {/* Check icon */}
                    <div style={{
                      width: '18px',
                      height: '18px',
                      borderRadius: '50%',
                      border: `2px solid #69994D`,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      flexShrink: 0,
                      marginTop: '1px',
                    }}>
                      <div style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 700,
                        fontSize: '10px',
                        color: '#69994D',
                        lineHeight: 1,
                      }}>
                        ✓
                      </div>
                    </div>
                    <p style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
                      color: colors.text,
                      margin: 0,
                      lineHeight: 1.5,
                    }}>
                      {cond}
                    </p>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>

            <div style={{
              marginTop: 'auto',
              fontFamily: 'monospace',
              fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
              color: '#69994D',
              padding: '6px 12px',
              border: `1px solid #69994D44`,
              borderRadius: '3px',
              alignSelf: 'flex-start',
            }}>
              Update VERSION_REGISTRY
            </div>
          </motion.div>

          {/* RIGHT: Iterate When */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            <h2 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '20px',
            }}>
              ITERATE WHEN
            </h2>

            <StaggerGroup>
              {iterateConditions.map((cond, i) => (
                <StaggerItem key={i}>
                  <div style={{
                    display: 'flex',
                    gap: '10px',
                    alignItems: 'flex-start',
                    marginBottom: '14px',
                  }}>
                    {/* Rotate icon */}
                    <div style={{
                      width: '18px',
                      height: '18px',
                      borderRadius: '50%',
                      border: `2px solid ${colors.gold}`,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      flexShrink: 0,
                      marginTop: '1px',
                    }}>
                      <div style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 700,
                        fontSize: '10px',
                        color: colors.gold,
                        lineHeight: 1,
                      }}>
                        ↻
                      </div>
                    </div>
                    <p style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
                      color: colors.text,
                      margin: 0,
                      lineHeight: 1.5,
                    }}>
                      {cond}
                    </p>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>

            <div style={{
              marginTop: 'auto',
              fontFamily: 'monospace',
              fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
              color: colors.gold,
              padding: '6px 12px',
              border: `1px solid ${colors.gold}44`,
              borderRadius: '3px',
              alignSelf: 'flex-start',
            }}>
              /dsbv validate improve → /dsbv design align
            </div>
          </motion.div>
        </div>

        {/* Decision flowchart */}
        <AnimatedText delay={0.6}>
          <div style={{
            borderTop: `1px solid ${colors.gold}22`,
            paddingTop: '16px',
            marginTop: '16px',
          }}>
            <h3 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '12px',
            }}>
              DECISION FLOW
            </h3>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              {decisionSteps.map((step, i) => (
                <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <div style={{
                    padding: '5px 12px',
                    border: `1px solid ${(step.color || colors.gold)}44`,
                    borderRadius: step.label === 'CHECK' ? '12px' : '3px',
                  }}>
                    <div style={{
                      fontFamily: step.isCommand ? 'monospace' : 'Inter, sans-serif',
                      fontWeight: 600,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                      color: step.color || colors.gold,
                      letterSpacing: '0.03em',
                    }}>
                      {step.label}
                    </div>
                    <div style={{
                      fontFamily: step.isCommand ? 'monospace' : 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.35rem, 0.48vw, 0.42rem)',
                      color: colors.textDim,
                      marginTop: '1px',
                    }}>
                      {step.desc}
                    </div>
                  </div>
                  {i < decisionSteps.length - 1 && i !== 2 && (
                    <div style={{
                      width: 0,
                      height: 0,
                      borderTop: '4px solid transparent',
                      borderBottom: '4px solid transparent',
                      borderLeft: `5px solid ${colors.gold}`,
                      opacity: 0.3,
                    }} />
                  )}
                  {/* Fork indicator after CHECK */}
                  {i === 1 && (
                    <div style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.35rem, 0.45vw, 0.4rem)',
                      color: colors.textDim,
                      padding: '0 2px',
                    }}>
                      →
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
