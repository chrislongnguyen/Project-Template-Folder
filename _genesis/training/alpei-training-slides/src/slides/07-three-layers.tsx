import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const layers = [
  {
    label: '5 ALPEI WORKSTREAMS',
    items: ['ALIGN', 'LEARN', 'PLAN', 'EXECUTE', 'IMPROVE'],
    color: colors.gold,
  },
  {
    label: '4 DSBV PHASES',
    items: ['DESIGN', 'SEQUENCE', 'BUILD', 'VALIDATE'],
    color: colors.midnightLight,
  },
  {
    label: 'SUB-SYSTEMS',
    items: ['PD', 'DP', 'DA', 'IDM'],
    color: colors.midnight,
  },
];

function FlowBoxes({ items, color }: { items: string[]; color: string }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
      {items.map((item, i) => (
        <div key={item} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <div
            style={{
              border: `1px solid ${color}`,
              borderRadius: '6px',
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.55rem, 0.85vw, 0.7rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '0.03em',
              whiteSpace: 'nowrap',
              padding: '6px 14px',
            }}
          >
            {item}
          </div>
          {i < items.length - 1 && (
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
                color: color,
              }}
            >
              →
            </span>
          )}
        </div>
      ))}
    </div>
  );
}

export default function ThreeLayersSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '48px 80px',
        }}
      >
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 48px 0',
            }}
          >
            THREE STRUCTURAL LAYERS
          </h1>
        </AnimatedText>

        {/* Stacked layers */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '0',
          }}
        >
          {layers.map((layer, idx) => (
            <motion.div key={layer.label} variants={fadeInUp}>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '32px',
                  marginBottom: '12px',
                }}
              >
                {/* Layer label */}
                <div
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.65rem, 1vw, 0.8rem)',
                    color: layer.color,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    minWidth: '140px',
                  }}
                >
                  {layer.label}
                </div>

                {/* Flow boxes */}
                <FlowBoxes items={layer.items} color={layer.color} />
              </div>

              {/* Separator line (except last) */}
              {idx < layers.length - 1 && (
                <div
                  style={{
                    height: '1px',
                    background: 'rgba(255, 255, 255, 0.06)',
                    margin: '20px 0 24px 0',
                  }}
                />
              )}
            </motion.div>
          ))}
        </motion.div>

        {/* Equation */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.6, duration: 0.5, ease: [0.25, 0.1, 0.25, 1] }}
          style={{
            textAlign: 'center',
            marginTop: '48px',
          }}
        >
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3.5vw, 2.5rem)',
              background: `linear-gradient(135deg, ${colors.gold} 0%, ${colors.goldDim} 100%)`,
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              backgroundClip: 'text',
              letterSpacing: '-0.02em',
            }}
          >
            5 WORKSTREAMS × 4 PHASES = 20 CELLS
          </span>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
