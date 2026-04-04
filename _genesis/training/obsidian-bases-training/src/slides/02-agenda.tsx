import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';

const sections = [
  {
    num: '01',
    title: 'FOUNDATIONS',
    desc: 'What is Obsidian, what we built, how Bases work',
  },
  {
    num: '02',
    title: 'THE FRONTMATTER SYSTEM',
    desc: 'The metadata that powers your dashboards',
  },
  {
    num: '03',
    title: 'YOUR PM WORKFLOW',
    desc: 'Step-by-step daily workflow with dashboards',
  },
  {
    num: '04',
    title: 'GETTING STARTED',
    desc: 'First actions + how to customize',
  },
  {
    num: '05',
    title: 'APPENDIX',
    desc: 'Setup & install guide',
  },
];

export default function AgendaSlide() {
  return (
    <SlideLayout>
      {/* Midnight accent bar */}
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

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '48px 120px',
        }}
      >
        <AnimatedText>
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
            AGENDA
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '40px',
            }}
          />
        </AnimatedText>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        <StaggerGroup>
          {sections.map((s) => (
            <StaggerItem key={s.num}>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '24px',
                  padding: '14px 20px',
                  borderRadius: '6px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                  background: 'rgba(29, 31, 42, 0.5)',
                }}
              >
                {/* Section number */}
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(1rem, 1.8vw, 1.4rem)',
                    color: colors.gold,
                    opacity: 0.6,
                    minWidth: '36px',
                    lineHeight: 1,
                  }}
                >
                  {s.num}
                </span>

                {/* Divider */}
                <div
                  style={{
                    width: '1px',
                    height: '28px',
                    background: 'rgba(255,255,255,0.1)',
                    flexShrink: 0,
                  }}
                />

                {/* Title + description */}
                <div style={{ flex: 1 }}>
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.75rem, 1.1vw, 0.9rem)',
                      color: colors.text,
                      textTransform: 'uppercase',
                      letterSpacing: '0.04em',
                      margin: 0,
                    }}
                  >
                    {s.title}
                  </p>
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.6rem, 0.9vw, 0.75rem)',
                      color: colors.textDim,
                      margin: '3px 0 0 0',
                    }}
                  >
                    {s.desc}
                  </p>
                </div>
              </div>
            </StaggerItem>
          ))}
        </StaggerGroup>
        </div>
      </div>
    </SlideLayout>
  );
}
