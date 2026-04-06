import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';

const sections = [
  {
    num: '01',
    title: 'QUICK START & MIGRATION',
    desc: 'Upgrade from I1 → I2 with zero struggle, see your first dashboard',
    time: '10 min',
  },
  {
    num: '02',
    title: 'FOUNDATIONS',
    desc: 'What is Obsidian, what we built, how Bases work',
    time: '5 min',
  },
  {
    num: '03',
    title: 'THE FRONTMATTER SYSTEM',
    desc: 'The metadata that powers every dashboard',
    time: '5 min',
  },
  {
    num: '04',
    title: 'PART 1: OBSIDIAN BASES & PM WORKFLOW',
    desc: '18 dashboards + your daily cycle (morning → weekly)',
    time: '10 min',
  },
  {
    num: '05',
    title: 'PART 2: PERSONAL KNOWLEDGE BASE',
    desc: 'CODE pipeline, /ingest, Karpathy LLM-wiki, Obsidian plugins',
    time: '8 min',
  },
  {
    num: '06',
    title: 'QMD & MEMORY VAULT',
    desc: 'How semantic search powers auto-recall across sessions',
    time: '3 min',
  },
  {
    num: '07',
    title: 'UPGRADED SKILLS',
    desc: '/ltc-brainstorming Discovery Protocol + all new commands',
    time: '3 min',
  },
  {
    num: '08',
    title: 'REFERENCE',
    desc: 'Cheat sheets, dashboard index, file locations',
    time: 'ref',
  },
];

export default function AgendaSlide() {
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

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '36px 80px 36px 100px',
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
              marginBottom: '28px',
            }}
          />
        </AnimatedText>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
          <StaggerGroup>
            {sections.map((s) => (
              <StaggerItem key={s.num}>
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '20px',
                    padding: '10px 16px',
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
                      fontSize: 'clamp(0.85rem, 1.4vw, 1.1rem)',
                      color: colors.gold,
                      opacity: 0.6,
                      minWidth: '32px',
                      lineHeight: 1,
                    }}
                  >
                    {s.num}
                  </span>

                  {/* Divider */}
                  <div
                    style={{
                      width: '1px',
                      height: '24px',
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
                        fontSize: 'clamp(0.65rem, 0.95vw, 0.82rem)',
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
                        fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                        color: colors.textDim,
                        margin: '2px 0 0 0',
                      }}
                    >
                      {s.desc}
                    </p>
                  </div>

                  {/* Time badge */}
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 600,
                      fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                      color: colors.muted,
                      background: 'rgba(255,255,255,0.05)',
                      border: '1px solid rgba(255,255,255,0.08)',
                      borderRadius: '3px',
                      padding: '2px 8px',
                      whiteSpace: 'nowrap',
                      flexShrink: 0,
                    }}
                  >
                    {s.time}
                  </span>
                </div>
              </StaggerItem>
            ))}
          </StaggerGroup>
        </div>
      </div>
    </SlideLayout>
  );
}
