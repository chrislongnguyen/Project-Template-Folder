import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const subSystems = [
  { code: 'PD', name: 'PROBLEM DIAGNOSIS', requires: 'Nothing — this is the source', produces: 'Effective Principles (EP)' },
  { code: 'DP', name: 'DATA PIPELINE', requires: 'PD Effective Principles', produces: 'Analysis-ready data' },
  { code: 'DA', name: 'DATA ANALYSIS', requires: 'DP analysis-ready data', produces: 'Validated insights' },
  { code: 'IDM', name: 'INSIGHTS & DECISIONS', requires: 'DA validated insights', produces: 'Decisions & actions' },
];

const workStreamChain = ['ALIGN', 'LEARN', 'PLAN', 'EXECUTE', 'IMPROVE'];

const breakResponse = [
  { step: 'DETECT', desc: 'AI auto-checks upstream outputs before creating any deliverable' },
  { step: 'WARN', desc: 'States the specific failure and missing upstream output' },
  { step: 'RECOMMEND', desc: 'Suggests the exact command to run first' },
  { step: 'ASK', desc: '"Fix this first, or proceed anyway?" — human decides' },
];

export default function ChainCustodySlide() {
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
            CHAIN-OF-CUSTODY
          </h1>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        {/* Sub-system chain - horizontal */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            alignItems: 'stretch',
            gap: '2px',
            marginTop: '24px',
          }}
        >
          {subSystems.map((ss, i) => (
            <motion.div
              key={ss.code}
              variants={fadeInUp}
              style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                position: 'relative',
                borderTop: `3px solid ${colors.gold}`,
                padding: '14px 10px 12px',
              }}
            >
              {/* Sub-system code */}
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.8rem, 1.3vw, 1rem)',
                color: colors.gold,
                letterSpacing: '0.04em',
                marginBottom: '2px',
              }}>
                {ss.code}
              </div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 600,
                fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                color: colors.text,
                textTransform: 'uppercase',
                letterSpacing: '0.04em',
                marginBottom: '10px',
              }}>
                {ss.name}
              </div>

              {/* Requires */}
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.35rem, 0.45vw, 0.4rem)',
                color: colors.ruby,
                textTransform: 'uppercase',
                letterSpacing: '0.05em',
                marginBottom: '2px',
              }}>
                REQUIRES
              </div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                color: colors.textDim,
                lineHeight: 1.3,
                marginBottom: '8px',
              }}>
                {ss.requires}
              </div>

              {/* Produces */}
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.35rem, 0.45vw, 0.4rem)',
                color: '#69994D',
                textTransform: 'uppercase',
                letterSpacing: '0.05em',
                marginBottom: '2px',
              }}>
                PRODUCES
              </div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                color: colors.text,
                lineHeight: 1.3,
              }}>
                {ss.produces}
              </div>

              {/* Gold arrow */}
              {i < subSystems.length - 1 && (
                <div style={{
                  position: 'absolute',
                  right: '-9px',
                  top: '28px',
                  width: 0,
                  height: 0,
                  borderTop: '7px solid transparent',
                  borderBottom: '7px solid transparent',
                  borderLeft: `10px solid ${colors.gold}`,
                  opacity: 0.5,
                  zIndex: 2,
                }} />
              )}
            </motion.div>
          ))}
        </motion.div>

        {/* Two-panel bottom */}
        <div style={{ display: 'flex', flex: 1, gap: '32px', marginTop: '20px' }}>
          {/* Left: Within each sub-system */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ flex: 1 }}
          >
            <h3 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '12px',
            }}>
              WITHIN EACH SUB-SYSTEM
            </h3>
            <div style={{ display: 'flex', alignItems: 'center', gap: '4px', flexWrap: 'wrap' }}>
              {workStreamChain.map((ws, i) => (
                <div key={ws} style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.text,
                    padding: '5px 10px',
                    border: `1px solid ${colors.gold}33`,
                    borderRadius: '3px',
                    letterSpacing: '0.04em',
                  }}>
                    {ws}
                  </div>
                  {i < workStreamChain.length - 1 && (
                    <div style={{
                      width: 0,
                      height: 0,
                      borderTop: '4px solid transparent',
                      borderBottom: '4px solid transparent',
                      borderLeft: `6px solid ${colors.gold}`,
                      opacity: 0.4,
                    }} />
                  )}
                </div>
              ))}
            </div>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
              color: colors.textDim,
              marginTop: '10px',
              lineHeight: 1.5,
            }}>
              Each work stream's output feeds the next. Stages within each are strictly sequential: Scope → Design → Production → Audit.
            </p>
          </motion.div>

          {/* Right: What happens when chain breaks */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ flex: 1 }}
          >
            <h3 style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
              color: colors.ruby,
              textTransform: 'uppercase',
              letterSpacing: '0.06em',
              marginBottom: '12px',
            }}>
              WHAT HAPPENS WHEN CHAIN BREAKS
            </h3>
            <StaggerGroup>
              {breakResponse.map((item) => (
                <StaggerItem key={item.step}>
                  <div style={{
                    display: 'flex',
                    gap: '10px',
                    alignItems: 'flex-start',
                    marginBottom: '8px',
                  }}>
                    <div style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.45rem, 0.6vw, 0.52rem)',
                      color: colors.gold,
                      textTransform: 'uppercase',
                      letterSpacing: '0.04em',
                      minWidth: '70px',
                      flexShrink: 0,
                    }}>
                      {item.step}
                    </div>
                    <div style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                      color: colors.textDim,
                      lineHeight: 1.4,
                    }}>
                      {item.desc}
                    </div>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
