import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const plugins = [
  {
    name: 'Dataview',
    description: 'Powers dashboard.md — 5 live panels showing learning levels, backlog, ingests, topics, review queue',
    hint: 'Settings → Community Plugins → Search "dataview"',
  },
  {
    name: 'Spaced Repetition',
    description: 'Flashcard-style review of wiki pages. Cmd+P → "Review flashcards" → rate Easy/Good/Hard',
    hint: 'Search "obsidian-spaced-repetition" → configure note folder to 2-organised/',
  },
  {
    name: 'Canvas Mindmap',
    description: 'Open knowledge-map.canvas → drag wiki pages to visualize topic clusters',
    hint: 'Search "canvas-mindmap" → No config needed',
  },
  {
    name: 'PDF++',
    description: 'Annotate PDFs → send highlights directly to 1-captured/ for ingest',
    hint: 'Search "pdf-plus" → Set highlight export to 1-captured/',
  },
  {
    name: 'Web Clipper',
    description: 'Press ⌥⇧O on any web page → clips to 1-captured/ with frontmatter',
    hint: 'Browser extension → Template: note location = 1-captured/, name = {{title}}',
  },
];

const dashboardPanels = [
  { name: 'Learning Level Distribution', why: 'Spot shallow knowledge areas' },
  { name: 'Unorganised Files', why: 'Your organise backlog — aim for zero' },
  { name: 'Recent Organise Operations', why: 'Activity heartbeat — is knowledge growing?' },
  { name: 'Topics', why: 'Where your knowledge concentrates' },
  { name: 'Review Queue', why: 'Oldest-first — prevents knowledge rot' },
];

export default function PkbObsidianSlide() {
  return (
    <SlideLayout>
      {/* Purple accent bar */}
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
          background: colors.purple,
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
          padding: '32px 80px',
          gap: '14px',
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
            PKB IN OBSIDIAN — YOUR READING & REVIEW IDE
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '12px' }} />
        </AnimatedText>

        {/* Plugins table */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, duration: 0.5 }}
          style={{
            background: 'rgba(29,31,42,0.5)',
            border: '1px solid rgba(255,255,255,0.06)',
            borderRadius: '6px',
            overflow: 'hidden',
          }}
        >
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: '0.7fr 1.6fr 1.4fr',
              background: 'rgba(101,52,105,0.2)',
              padding: '7px 18px',
              borderBottom: '1px solid rgba(255,255,255,0.08)',
            }}
          >
            {['Plugin', 'What It Does', 'Install'].map((h) => (
              <span
                key={h}
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.65vw, 0.58rem)',
                  color: colors.muted,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                }}
              >
                {h}
              </span>
            ))}
          </div>
          {plugins.map((p, i) => (
            <div
              key={p.name}
              style={{
                display: 'grid',
                gridTemplateColumns: '0.7fr 1.6fr 1.4fr',
                padding: '8px 18px',
                borderBottom: i < plugins.length - 1 ? '1px solid rgba(255,255,255,0.04)' : 'none',
                alignItems: 'start',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.52rem, 0.7vw, 0.62rem)',
                  color: colors.gold,
                }}
              >
                {p.name}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.5rem, 0.68vw, 0.6rem)',
                  color: colors.text,
                  lineHeight: 1.5,
                }}
              >
                {p.description}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.48rem, 0.62vw, 0.56rem)',
                  color: colors.textDim,
                  lineHeight: 1.5,
                }}
              >
                {p.hint}
              </span>
            </div>
          ))}
        </motion.div>

        {/* Dashboard panels row */}
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ display: 'flex', gap: '8px' }}
        >
          {dashboardPanels.map((panel) => (
            <motion.div
              key={panel.name}
              variants={fadeInUp}
              style={{
                flex: 1,
                background: 'rgba(29,31,42,0.5)',
                border: '1px solid rgba(255,255,255,0.06)',
                borderTop: `2px solid ${colors.purple}`,
                borderRadius: '6px',
                padding: '10px 12px',
                display: 'flex',
                flexDirection: 'column',
                gap: '4px',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.48rem, 0.62vw, 0.56rem)',
                  color: colors.purple,
                  textTransform: 'uppercase',
                  letterSpacing: '0.02em',
                  lineHeight: 1.4,
                }}
              >
                {panel.name}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.46rem, 0.6vw, 0.54rem)',
                  color: colors.textDim,
                  lineHeight: 1.4,
                }}
              >
                {panel.why}
              </span>
            </motion.div>
          ))}
        </motion.div>

        {/* PKB Lint callout */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7, duration: 0.5 }}
          style={{
            background: 'rgba(242,199,92,0.08)',
            border: '1px solid rgba(242,199,92,0.25)',
            borderLeft: `4px solid ${colors.gold}`,
            borderRadius: '6px',
            padding: '9px 18px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.58rem, 0.78vw, 0.68rem)',
              color: colors.text,
              margin: 0,
            }}
          >
            <span style={{ color: colors.gold, fontWeight: 700 }}>PKB Lint:</span>{' '}
            8 checks, zero AI, &lt; 1 second — runs automatically at session start/stop
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
