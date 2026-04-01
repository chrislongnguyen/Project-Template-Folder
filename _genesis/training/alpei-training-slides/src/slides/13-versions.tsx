import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const versions = [
  {
    name: 'LOGIC SCAFFOLD',
    pillar: 'Understanding',
    delivers: 'Scope & logic mapped. No code.',
    opacity: 0.4,
    color: '#3a6a70',
  },
  {
    name: 'CONCEPT',
    pillar: 'Sustainability',
    delivers: 'Correct & safe in simulation.',
    opacity: 0.55,
    color: '#1a7a82',
  },
  {
    name: 'PROTOTYPE',
    pillar: '+ Efficiency',
    delivers: 'Outperforms alternatives. Real tools.',
    opacity: 0.7,
    color: '#009aa3',
  },
  {
    name: 'MVE',
    pillar: '+ Reliability',
    delivers: 'Full working system. Production-ready.',
    opacity: 0.85,
    color: '#d4a942',
  },
  {
    name: 'LEADERSHIP',
    pillar: '+ Scalability',
    delivers: 'Automated, predictive, prescriptive.',
    opacity: 1,
    color: colors.gold,
  },
];

export default function VersionsSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '72px 80px 56px' }}>
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
            VERSION PROGRESSION
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Timeline pipeline */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              display: 'flex',
              alignItems: 'stretch',
              gap: '2px',
              width: '100%',
              maxWidth: '1100px',
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
                  alignItems: 'center',
                  position: 'relative',
                }}
              >
                {/* Version card */}
                <div style={{
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  padding: '24px 12px 20px',
                  position: 'relative',
                  width: '100%',
                }}>
                  {/* Stage number */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 900,
                    fontSize: 'clamp(1.5rem, 3vw, 2.5rem)',
                    color: v.color,
                    opacity: 0.3,
                    lineHeight: 1,
                    marginBottom: '8px',
                  }}>
                    {String(i + 1).padStart(2, '0')}
                  </div>

                  {/* Version name */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.6rem, 1vw, 0.8rem)',
                    color: v.color,
                    textTransform: 'uppercase',
                    letterSpacing: '0.08em',
                    textAlign: 'center',
                    marginBottom: '12px',
                  }}>
                    {v.name}
                  </div>

                  {/* Arrow bar */}
                  <div style={{
                    width: '100%',
                    height: '4px',
                    background: `linear-gradient(90deg, ${i === 0 ? 'transparent' : v.color}, ${v.color})`,
                    borderRadius: '2px',
                    marginBottom: '14px',
                    position: 'relative',
                  }}>
                    {i < versions.length - 1 && (
                      <div style={{
                        position: 'absolute',
                        right: '-6px',
                        top: '-4px',
                        width: 0,
                        height: 0,
                        borderTop: '6px solid transparent',
                        borderBottom: '6px solid transparent',
                        borderLeft: `8px solid ${v.color}`,
                      }} />
                    )}
                  </div>

                  {/* Pillar focus */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.55rem, 0.85vw, 0.7rem)',
                    color: colors.gold,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                    marginBottom: '6px',
                    textAlign: 'center',
                  }}>
                    {v.pillar}
                  </div>

                  {/* Delivers */}
                  <div style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                    color: colors.textDim,
                    textAlign: 'center',
                    lineHeight: 1.4,
                    maxWidth: '150px',
                  }}>
                    {v.delivers}
                  </div>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Quote */}
        <AnimatedText delay={0.8}>
          <div style={{
            borderLeft: `3px solid ${colors.gold}`,
            padding: '12px 0 12px 20px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.65rem, 1vw, 0.85rem)',
              color: colors.textDim,
              fontStyle: 'italic',
              margin: 0,
              lineHeight: 1.5,
            }}>
              "A version is not more features — it is a deliberate progression through the Three Pillars."
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
