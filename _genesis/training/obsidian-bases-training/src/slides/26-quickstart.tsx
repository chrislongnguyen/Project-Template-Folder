import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer } from '../lib/animations';

const actions = [
  {
    num: '01',
    action: 'Open the C3-standup-preparation dashboard',
    detail: 'see what changed today',
  },
  {
    num: '02',
    action: 'Check the blocker dashboard',
    detail: 'anything red means action needed',
  },
  {
    num: '03',
    action: 'Browse the master dashboard',
    detail: 'get the full lay of the land',
  },
  {
    num: '04',
    action: 'Open a deliverable file',
    detail: 'see how frontmatter drives the dashboards',
  },
  {
    num: '05',
    action: 'In Claude Code terminal: run /dsbv status',
    detail: 'see your DSBV pipeline',
  },
];

export default function QuickstartSlide() {
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
          width: '6px',
          background: colors.gold,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 85% 15%, rgba(0, 72, 81, 0.25) 0%, transparent 50%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '48px 120px 48px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 8px 0',
            }}
          >
            YOUR FIRST 5 ACTIONS
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '32px',
            }}
          />
        </AnimatedText>

        {/* Action list */}
        <motion.div variants={staggerContainer} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '14px', flex: 1 }}>
          {actions.map((item) => (
            <StaggerItem key={item.num}>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '20px',
                  padding: '14px 20px',
                  borderRadius: '8px',
                  background: 'rgba(29, 31, 42, 0.6)',
                  border: `1px solid rgba(255,255,255,0.06)`,
                }}
              >
                {/* Gold circle number */}
                <div
                  style={{
                    width: '36px',
                    height: '36px',
                    borderRadius: '50%',
                    background: `${colors.gold}18`,
                    border: `2px solid ${colors.gold}`,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0,
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                      color: colors.gold,
                      letterSpacing: '0.03em',
                    }}
                  >
                    {item.num}
                  </span>
                </div>

                {/* Text */}
                <div>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.7rem, 1.05vw, 0.9rem)',
                      color: colors.text,
                    }}
                  >
                    {item.action}
                  </span>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.65rem, 0.95vw, 0.82rem)',
                      color: colors.textDim,
                      marginLeft: '10px',
                    }}
                  >
                    — {item.detail}
                  </span>
                </div>
              </div>
            </StaggerItem>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
