import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const stages = [
  {
    name: 'CAPTURE',
    actor: 'YOU',
    accentColor: colors.purple,
    bullets: ['Articles & PDFs', 'Transcripts', 'Session notes', 'Web clips'],
  },
  {
    name: 'ORGANIZE',
    actor: 'YOU',
    accentColor: colors.midnightLight,
    bullets: ['File to captured/', 'Use Web Clipper', 'Drag & drop MD', 'No editing'],
  },
  {
    name: 'DISTIL',
    actor: 'AI (/ingest)',
    accentColor: colors.gold,
    bullets: ['Compile wiki pages', 'L1-L4 depth tracking', 'Update _index.md', 'Append _log.md'],
  },
  {
    name: 'EXPRESS',
    actor: 'YOU',
    accentColor: colors.green,
    bullets: ['Summaries', 'Reports', 'Deliverables', 'Presentations'],
  },
];

const dirTree = `PERSONAL-KNOWLEDGE-BASE/
├── captured/           ← Raw sources (IMMUTABLE)
├── distilled/          ← AI-generated wiki pages
│   ├── _index.md       ← Navigation hub
│   ├── _log.md         ← Ingest audit trail
│   └── {topics}/       ← Topic folders
├── expressed/          ← Outputs that leave PKB
├── dashboard.md        ← 5 Dataview panels
└── knowledge-map.canvas`;

export default function CodePipelineSlide() {
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
          padding: '36px 80px',
          gap: '16px',
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
            THE CODE PIPELINE
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '16px' }} />
        </AnimatedText>

        {/* 4-stage flow */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ display: 'flex', gap: '8px', alignItems: 'stretch' }}
        >
          {stages.map((stage, i) => (
            <div key={stage.name} style={{ display: 'flex', alignItems: 'center', gap: '8px', flex: 1 }}>
              <motion.div
                variants={fadeInUp}
                style={{
                  flex: 1,
                  background: 'rgba(29,31,42,0.5)',
                  border: '1px solid rgba(255,255,255,0.06)',
                  borderTop: `3px solid ${stage.accentColor}`,
                  borderRadius: '6px',
                  padding: '14px 14px',
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '6px',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.75rem, 1.1vw, 0.95rem)',
                    color: stage.accentColor,
                    textTransform: 'uppercase',
                    letterSpacing: '-0.01em',
                  }}
                >
                  {stage.name}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.5rem, 0.65vw, 0.58rem)',
                    color: colors.muted,
                    textTransform: 'uppercase',
                    letterSpacing: '0.05em',
                    fontWeight: 600,
                  }}
                >
                  {stage.actor}
                </span>
                <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)', paddingTop: '8px', marginTop: '2px' }}>
                  {stage.bullets.map((b) => (
                    <p
                      key={b}
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontSize: 'clamp(0.52rem, 0.72vw, 0.64rem)',
                        color: colors.text,
                        margin: '2px 0',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '6px',
                      }}
                    >
                      <span style={{ color: stage.accentColor, fontSize: '0.5em', flexShrink: 0 }}>■</span>
                      {b}
                    </p>
                  ))}
                </div>
              </motion.div>

              {i < stages.length - 1 && (
                <motion.span
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.3 + i * 0.1, duration: 0.4 }}
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.9rem, 1.2vw, 1.1rem)',
                    color: colors.gold,
                    flexShrink: 0,
                  }}
                >
                  →
                </motion.span>
              )}
            </div>
          ))}
        </motion.div>

        {/* Directory tree */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.65, duration: 0.5 }}
          style={{
            background: colors.gunmetal,
            border: '1px solid rgba(255,255,255,0.08)',
            borderRadius: '6px',
            padding: '14px 20px',
          }}
        >
          <pre
            style={{
              fontFamily: "'Courier New', Courier, monospace",
              fontSize: 'clamp(0.5rem, 0.7vw, 0.62rem)',
              color: colors.text,
              margin: 0,
              lineHeight: 1.65,
              whiteSpace: 'pre',
            }}
          >
            {dirTree}
          </pre>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
