import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const categories = [
  {
    name: 'DSBV PROCESS',
    desc: 'Run the 4-phase workflow for any workstream',
    count: 4,
    examples: ['/dsbv design', '/dsbv sequence', '/dsbv build', '/dsbv validate'],
  },
  {
    name: 'LEARNING',
    desc: 'Research pipeline — input → analysis → specs',
    count: 6,
    examples: ['/learn:input', '/learn:research', '/learn:spec'],
  },
  {
    name: 'GIT & VERSION',
    desc: 'Safe commits, version tracking, status checks',
    count: 3,
    examples: ['/git-save', '/commit', '/dsbv status'],
  },
  {
    name: 'QUALITY',
    desc: 'Report issues, simplify code, audit compliance',
    count: 3,
    examples: ['/feedback', '/simplify', '/ltc-rules-compliance'],
  },
  {
    name: 'BRAND & NAMING',
    desc: 'Enforce LTC visual identity and naming grammar',
    count: 2,
    examples: ['/ltc-brand-identity', '/ltc-naming-rules'],
  },
  {
    name: 'SESSION',
    desc: 'Start/end work sessions, restore context',
    count: 3,
    examples: ['/session-start', '/session-end', '/resume'],
  },
  {
    name: 'RESEARCH',
    desc: 'Deep multi-source research, slide presentations',
    count: 2,
    examples: ['/deep-research', '/slide-deck'],
  },
  {
    name: 'GOVERNANCE',
    desc: 'Create new skills, scaffold new projects',
    count: 2,
    examples: ['/ltc-skill-creator', '/init'],
  },
];

export default function CommandsSlide() {
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
            SKILL ROUTES
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* 2x4 Grid */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', marginTop: '16px' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(4, 1fr)',
              gridTemplateRows: 'repeat(2, 1fr)',
              gap: '12px',
              width: '100%',
            }}
          >
            {categories.map((cat) => (
              <motion.div
                key={cat.name}
                variants={fadeInUp}
                style={{
                  padding: '16px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                  borderRadius: '6px',
                  background: 'rgba(255, 255, 255, 0.02)',
                }}
              >
                {/* Category header */}
                <div style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  marginBottom: '10px',
                }}>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.text,
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                  }}>
                    {cat.name}
                  </span>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                    color: colors.gold,
                  }}>
                    {cat.count}
                  </span>
                </div>

                {/* Desc */}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.38rem, 0.52vw, 0.45rem)',
                  color: colors.textDim,
                  fontStyle: 'italic',
                  marginBottom: '8px',
                }}>
                  {cat.desc}
                </div>

                {/* Examples */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                  {cat.examples.map((ex) => (
                    <span key={ex} style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 500,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                      color: colors.midnightLight,
                      padding: '3px 6px',
                      background: 'rgba(0, 72, 81, 0.15)',
                      borderRadius: '3px',
                      width: 'fit-content',
                    }}>
                      {ex}
                    </span>
                  ))}
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Total */}
        <AnimatedText delay={0.7}>
          <div style={{ textAlign: 'center' }}>
            <span style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 900,
              fontSize: 'clamp(1.5rem, 3vw, 2.5rem)',
              color: colors.gold,
            }}>
              25+
            </span>
            <span style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 1vw, 0.85rem)',
              color: colors.textDim,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginLeft: '12px',
            }}>
              SKILLS
            </span>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
