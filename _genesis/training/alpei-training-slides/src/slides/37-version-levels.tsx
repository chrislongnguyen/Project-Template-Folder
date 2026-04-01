import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const versions = [
  {
    name: 'LOGIC SCAFFOLD',
    pillar: 'Understanding',
    vana: 'Understand & design — clearly, completely',
    delivers: 'Scope mapped, logic documented. No code, no building.',
    duration: '1-2 weeks',
    color: '#3a6a70',
    barOpacity: 0.3,
  },
  {
    name: 'CONCEPT',
    pillar: 'Sustainability',
    vana: 'Derisk & deliver — correctly, safely',
    delivers: 'Correct & safe in simulated environment. Manual OK.',
    duration: '2-4 weeks',
    color: '#1a7a82',
    barOpacity: 0.45,
  },
  {
    name: 'PROTOTYPE',
    pillar: '+ Efficiency',
    vana: 'Derisk & deliver — more easily, better than alternatives',
    delivers: 'Real tools, real data. Outperforms alternatives.',
    duration: '3-6 weeks',
    color: '#009aa3',
    barOpacity: 0.6,
  },
  {
    name: 'MVE',
    pillar: '+ Reliability',
    vana: 'Derisk & deliver — reliably, cheaply',
    delivers: 'Full working system. Production-ready & cost-effective.',
    duration: '4-8 weeks',
    color: '#d4a942',
    barOpacity: 0.8,
  },
  {
    name: 'LEADERSHIP',
    pillar: '+ Scalability',
    vana: 'Derisk & deliver — automatically, predictively',
    delivers: 'Automated, predictive. System improves itself.',
    duration: 'Ongoing',
    color: colors.gold,
    barOpacity: 1,
  },
];

export default function VersionLevelsSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '60px 80px 48px' }}>
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
            FIVE VERSION LEVELS
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Pillar progression label */}
        <AnimatedText delay={0.2}>
          <p style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.65rem, 0.9vw, 0.8rem)',
            color: colors.textDim,
            marginTop: '16px',
            letterSpacing: '0.03em',
          }}>
            Each version adds a new pillar dimension. You cannot skip levels.
          </p>
        </AnimatedText>

        {/* Pipeline */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              display: 'flex',
              width: '100%',
              gap: '3px',
              alignItems: 'stretch',
            }}
          >
            {versions.map((v, i) => (
              <motion.div
                key={v.name}
                variants={fadeInUp}
                style={{
                  flex: 1,
                  display: 'flex',
                  flexDirection: 'column',
                  position: 'relative',
                }}
              >
                {/* Top gradient bar - increasing weight */}
                <div style={{
                  height: `${4 + i * 2}px`,
                  background: `linear-gradient(90deg, ${i > 0 ? versions[i - 1].color : v.color}, ${v.color})`,
                  borderRadius: '2px 2px 0 0',
                  marginBottom: '16px',
                }} />

                {/* Version number */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 900,
                  fontSize: 'clamp(1.2rem, 2.2vw, 1.8rem)',
                  color: v.color,
                  opacity: 0.25,
                  lineHeight: 1,
                  textAlign: 'center',
                  marginBottom: '4px',
                }}>
                  {String(i + 1).padStart(2, '0')}
                </div>

                {/* Version name */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.55rem, 0.85vw, 0.72rem)',
                  color: v.color,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                  textAlign: 'center',
                  marginBottom: '12px',
                  minHeight: '28px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}>
                  {v.name}
                </div>

                {/* Pillar focus badge */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.05em',
                  textAlign: 'center',
                  padding: '4px 8px',
                  border: `1px solid ${colors.gold}33`,
                  borderRadius: '3px',
                  marginBottom: '10px',
                  alignSelf: 'center',
                }}>
                  {v.pillar}
                </div>

                {/* VANA */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                  color: colors.textDim,
                  textAlign: 'center',
                  lineHeight: 1.4,
                  fontStyle: 'italic',
                  padding: '0 6px',
                  marginBottom: '8px',
                  minHeight: '30px',
                }}>
                  {v.vana}
                </div>

                {/* Delivers */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 400,
                  fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                  color: colors.text,
                  textAlign: 'center',
                  lineHeight: 1.4,
                  padding: '0 6px',
                  marginBottom: '10px',
                  minHeight: '30px',
                }}>
                  {v.delivers}
                </div>

                {/* Duration */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 600,
                  fontSize: 'clamp(0.45rem, 0.6vw, 0.52rem)',
                  color: v.color,
                  textAlign: 'center',
                  letterSpacing: '0.04em',
                  marginTop: 'auto',
                }}>
                  {v.duration}
                </div>

                {/* Arrow connector */}
                {i < versions.length - 1 && (
                  <div style={{
                    position: 'absolute',
                    right: '-10px',
                    top: '50%',
                    transform: 'translateY(-50%)',
                    width: 0,
                    height: 0,
                    borderTop: '8px solid transparent',
                    borderBottom: '8px solid transparent',
                    borderLeft: `10px solid ${v.color}`,
                    opacity: 0.4,
                    zIndex: 2,
                  }} />
                )}
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Bottom note */}
        <AnimatedText delay={0.8}>
          <div style={{
            borderLeft: `3px solid ${colors.gold}`,
            padding: '10px 0 10px 16px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
              color: colors.textDim,
              margin: 0,
              lineHeight: 1.5,
            }}>
              Three Pillars progression: <span style={{ color: colors.text, fontWeight: 600 }}>Sustainability</span> (Concept)
              {' → '}<span style={{ color: colors.text, fontWeight: 600 }}>Efficiency</span> (Prototype)
              {' → '}<span style={{ color: colors.text, fontWeight: 600 }}>Scalability</span> (Leadership)
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
