import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer } from '../lib/animations';

type SkillRow = { cmd: string; desc: string; when: string };

const categories: { label: string; color: string; rows: SkillRow[] }[] = [
  {
    label: 'Daily Workflow',
    color: colors.gold,
    rows: [
      { cmd: '/dsbv status', desc: 'Show your DSBV pipeline', when: 'Morning check' },
      { cmd: '/resume', desc: 'Load previous session context', when: 'Start of day' },
      { cmd: '/compress', desc: 'Save session to memory vault', when: 'End of day' },
    ],
  },
  {
    label: 'Thinking & Building',
    color: colors.midnightLight,
    rows: [
      { cmd: '/ltc-brainstorming', desc: 'Structured discovery — 4 invisible gates', when: 'Starting any new feature' },
      { cmd: '/dsbv design', desc: 'Design phase — EO, scope, forces, acceptance criteria', when: 'After brainstorming' },
      { cmd: '/dsbv sequence', desc: 'Sequence phase — order the work, identify batches', when: 'After design approved' },
      { cmd: '/dsbv build', desc: 'Build phase — agent writes artifacts', when: 'Active work session' },
      { cmd: '/dsbv validate', desc: 'Validate phase — review against DESIGN.md ACs', when: 'After build complete' },
    ],
  },
  {
    label: 'Knowledge Management',
    color: colors.purple,
    rows: [
      { cmd: '/ingest', desc: 'Compile sources into PKB wiki', when: 'After saving to captured/' },
      { cmd: '/vault-capture', desc: 'Quick capture to PKB inbox', when: 'During work' },
      { cmd: '/obsidian', desc: 'Search vault via QMD', when: 'Find by meaning' },
    ],
  },
  {
    label: 'Setup & Migration',
    color: colors.green,
    rows: [
      { cmd: '/setup', desc: 'Initialize scaffold + QMD + smoke test', when: 'First-time or re-init' },
      { cmd: '/template-check', desc: 'Audit against I2 template', when: 'Before upgrading' },
      { cmd: '/template-sync', desc: 'Apply I2 updates interactively', when: 'I1 → I2 migration' },
    ],
  },
];

function CategorySection({ cat }: { cat: typeof categories[0] }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
      {/* Category header pill */}
      <div
        style={{
          display: 'inline-flex',
          alignItems: 'center',
          gap: '6px',
          marginBottom: '2px',
        }}
      >
        <div
          style={{
            background: `${cat.color}22`,
            border: `1px solid ${cat.color}50`,
            borderRadius: '4px',
            padding: '2px 10px',
          }}
        >
          <span
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.48rem, 0.65vw, 0.55rem)',
              color: cat.color,
              textTransform: 'uppercase',
              letterSpacing: '0.08em',
            }}
          >
            {cat.label}
          </span>
        </div>
      </div>

      {/* Rows */}
      <motion.div variants={staggerContainer} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
        {cat.rows.map((row) => (
          <StaggerItem key={row.cmd}>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: '160px 1fr 150px',
                gap: '10px',
                padding: '7px 10px',
                borderRadius: '5px',
                background: 'rgba(29,31,42,0.45)',
                border: '1px solid rgba(255,255,255,0.05)',
                alignItems: 'center',
              }}
            >
              <span
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontWeight: 700,
                  fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)',
                  color: cat.color,
                }}
              >
                {row.cmd}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.55rem, 0.75vw, 0.64rem)',
                  color: colors.text,
                  lineHeight: 1.4,
                }}
              >
                {row.desc}
              </span>
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                  color: colors.muted,
                  lineHeight: 1.4,
                }}
              >
                {row.when}
              </span>
            </div>
          </StaggerItem>
        ))}
      </motion.div>
    </div>
  );
}

export default function AgentCommandsSlide() {
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
          height: '100%',
          padding: '24px 80px 20px 100px',
          position: 'relative',
          zIndex: 1,
          gap: '10px',
        }}
      >
        <AnimatedText delay={0.05}>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.1rem, 2.1vw, 1.65rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 4px 0',
            }}
          >
            ALL AGENT COMMANDS — CHEAT SHEET
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '2px' }} />
        </AnimatedText>

        {/* Column headers */}
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '160px 1fr 150px',
            gap: '10px',
            padding: '0 10px',
          }}
        >
          {['COMMAND', 'WHAT IT DOES', 'WHEN'].map((h) => (
            <span
              key={h}
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.42rem, 0.56vw, 0.48rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              {h}
            </span>
          ))}
        </div>

        {/* Two-column layout for categories */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px 20px', flex: 1 }}>
          {categories.map((cat) => (
            <CategorySection key={cat.label} cat={cat} />
          ))}
        </div>

        {/* DSBV × Workstream callout */}
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.8 }}
          style={{
            borderLeft: `3px solid ${colors.midnightLight}`,
            background: `${colors.midnight}25`,
            borderRadius: '0 6px 6px 0',
            padding: '8px 14px',
            display: 'flex',
            gap: '24px',
          }}
        >
          <p style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)', color: colors.textDim, margin: 0, lineHeight: 1.5 }}>
            <span style={{ color: colors.gold, fontWeight: 700 }}>DSBV runs per workstream: </span>
            <span style={{ fontFamily: "'Courier New', monospace", color: colors.midnightLight }}>/dsbv design align</span> → 1-ALIGN (charter, decisions) &nbsp;·&nbsp;{' '}
            <span style={{ fontFamily: "'Courier New', monospace", color: colors.midnightLight }}>/dsbv design plan</span> → 3-PLAN (risks, roadmap) &nbsp;·&nbsp;{' '}
            <span style={{ fontFamily: "'Courier New', monospace", color: colors.midnightLight }}>/dsbv build execute</span> → 4-EXECUTE (code, tests)
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
