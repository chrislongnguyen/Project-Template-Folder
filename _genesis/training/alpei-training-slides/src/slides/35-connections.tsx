import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, scaleIn, staggerContainer } from '../lib/animations';

const flowNodes = [
  { label: 'ALIGN', color: colors.gold },
  { label: 'LEARN', color: colors.midnight },
  { label: 'PLAN', color: colors.gold },
  { label: 'EXECUTE', color: colors.midnightLight },
  { label: 'IMPROVE', color: colors.ruby },
];

const transferRows = [
  { from: 'ALIGN', to: 'LEARN', transfer: 'Charter scope → research boundaries. LEARN cannot expand scope unilaterally.' },
  { from: 'LEARN', to: 'PLAN', transfer: 'UBS/UDS inventories → Risk/Driver registers. Effective Principles → Architecture constraints.' },
  { from: 'LEARN', to: 'ALIGN', transfer: 'Validated EPs → Charter §Design Principles. Research evidence → ADR rationale.' },
  { from: 'PLAN', to: 'EXECUTE', transfer: 'Architecture doc, Risk Register, validated ROADMAP. All constraints inherited.' },
  { from: 'EXECUTE', to: 'IMPROVE', transfer: 'Metrics baseline, production data → IMPROVE measures delta.' },
  { from: 'IMPROVE', to: 'ALIGN', transfer: 'Feedback register, retro findings → next iteration charter update.' },
];

export default function ConnectionsSlide() {
  return (
    <SlideLayout>
      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 50% 35%, rgba(0, 72, 81, 0.3) 0%, transparent 50%)`,
          zIndex: 0,
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
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.3rem, 2.5vw, 2rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              marginBottom: '28px',
            }}
          >
            HOW WORKSTREAMS CONNECT
          </h1>
        </AnimatedText>

        {/* Circular flow diagram */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '0px',
            marginBottom: '28px',
          }}
        >
          {flowNodes.map((node, i) => (
            <motion.div
              key={node.label}
              variants={fadeInUp}
              style={{ display: 'flex', alignItems: 'center' }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.55rem, 0.9vw, 0.75rem)',
                  color: node.color === colors.gold ? colors.gunmetal : colors.text,
                  background: node.color,
                  padding: '8px 18px',
                  borderRadius: '16px',
                  textTransform: 'uppercase',
                  letterSpacing: '0.04em',
                  whiteSpace: 'nowrap',
                }}
              >
                {node.label}
              </span>
              {/* Gold arrow */}
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.8rem, 1.2vw, 1rem)',
                  color: colors.gold,
                  padding: '0 10px',
                }}
              >
                {i < flowNodes.length - 1 ? '\u2192' : '\u21BB'}
              </span>
            </motion.div>
          ))}
        </motion.div>

        {/* Transfer chain table */}
        <AnimatedText delay={0.4}>
          <div>
            {/* Header */}
            <div
              style={{
                display: 'flex',
                borderBottom: `2px solid ${colors.gold}33`,
                padding: '8px 0',
              }}
            >
              {['FROM', 'TO', 'WHAT TRANSFERS'].map((h) => (
                <span
                  key={h}
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.45rem, 0.7vw, 0.58rem)',
                    color: colors.gold,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    flex: h === 'WHAT TRANSFERS' ? 3 : 0.8,
                  }}
                >
                  {h}
                </span>
              ))}
            </div>

            {/* Rows */}
            {transferRows.map((row, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  borderBottom: i < transferRows.length - 1 ? `1px solid ${colors.midnight}22` : 'none',
                  padding: '7px 0',
                  alignItems: 'center',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.text,
                    flex: 0.8,
                    textTransform: 'uppercase',
                  }}
                >
                  {row.from}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.text,
                    flex: 0.8,
                    textTransform: 'uppercase',
                  }}
                >
                  {row.to}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.42rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                    flex: 3,
                    lineHeight: 1.4,
                  }}
                >
                  {row.transfer}
                </span>
              </div>
            ))}
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
