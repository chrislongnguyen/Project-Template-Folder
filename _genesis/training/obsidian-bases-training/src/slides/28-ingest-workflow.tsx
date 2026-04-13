import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp } from '../lib/animations';

const stages = [
  {
    accent: colors.purple,
    label: 'CAPTURE',
    actor: 'YOU',
    actorColor: colors.purple,
    detail: '/capture or Obsidian Web Clipper (⌥⇧O)',
    sub: 'Drops to PERSONAL-KNOWLEDGE-BASE/1-captured/',
    tool: '/capture  or  ⌥⇧O',
  },
  {
    accent: colors.gold,
    label: 'ORGANISE',
    actor: 'AI',
    actorColor: colors.gold,
    detail: '5-step pipeline: Read new in 1-captured/ → Find related via _index.md → Write wiki pages in 2-organised/{topic}/ → Append to _log.md → Update _index.md catalog',
    sub: '',
    tool: '/organise',
  },
  {
    accent: colors.midnight,
    label: 'DISTIL',
    actor: 'YOU (opt-in)',
    actorColor: colors.midnightLight,
    detail: 'Write your cross-source synthesis into 3-distilled/ — mental models, patterns across multiple organised pages',
    sub: 'No /distil skill — populated via natural conversation + save',
    tool: 'conversation + save',
  },
  {
    accent: colors.green,
    label: 'EXPRESS & AUTO-RECALL',
    actor: 'AUTO',
    actorColor: colors.green,
    detail: 'QMD indexes 2-organised/ (SessionStop hook). Agent auto-recalls via MCP in future sessions. Browse in Obsidian: backlinks, graph, Spaced Repetition.',
    sub: '',
    tool: 'QMD  +  /obsidian  +  Obsidian graph',
  },
];

const sizeRows = [
  { size: '< 100 KB', strategy: 'Standard pipeline', example: 'Blog post' },
  { size: '100-500 KB', strategy: 'Chunked pipeline', example: 'Long doc' },
  { size: '> 500 KB', strategy: 'Parallel agent dispatch', example: 'claude-code-docs (2MB)' },
];

export default function IngestWorkflowSlide() {
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
          height: '100%',
          padding: '28px 64px 24px 80px',
          gap: '10px',
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.2rem, 2.2vw, 1.8rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 4px 0',
            }}
          >
            CODE LIFECYCLE — CAPTURE TO AUTO-RECALL
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '10px' }} />
        </AnimatedText>

        {/* Stage cards */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', flex: 1 }}>
          {stages.map((stage, i) => (
            <div key={stage.label}>
              <motion.div
                initial={{ opacity: 0, x: -16 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.4, delay: 0.15 * i }}
                style={{
                  display: 'flex',
                  alignItems: 'stretch',
                  background: 'rgba(29,31,42,0.5)',
                  border: '1px solid rgba(255,255,255,0.06)',
                  borderRadius: '6px',
                  overflow: 'hidden',
                }}
              >
                {/* Left accent bar */}
                <div style={{ width: '5px', background: stage.accent, flexShrink: 0 }} />

                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '14px',
                    padding: '10px 16px',
                    flex: 1,
                  }}
                >
                  {/* Stage label */}
                  <div style={{ minWidth: '160px', flexShrink: 0 }}>
                    <span
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 800,
                        fontSize: 'clamp(0.65rem, 0.95vw, 0.82rem)',
                        color: stage.accent,
                        textTransform: 'uppercase',
                        letterSpacing: '0.04em',
                        display: 'block',
                        marginBottom: '4px',
                      }}
                    >
                      {stage.label}
                    </span>
                    {/* Actor badge */}
                    <span
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 700,
                        fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                        color: stage.actorColor,
                        background: `${stage.actorColor}18`,
                        border: `1px solid ${stage.actorColor}40`,
                        borderRadius: '3px',
                        padding: '1px 6px',
                        textTransform: 'uppercase',
                        letterSpacing: '0.06em',
                      }}
                    >
                      {stage.actor}
                    </span>
                  </div>

                  {/* Detail */}
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                      color: colors.text,
                      margin: 0,
                      lineHeight: 1.5,
                      flex: 1,
                    }}
                  >
                    {stage.detail}
                    {stage.sub && (
                      <span style={{ color: colors.textDim, display: 'block', marginTop: '2px', fontSize: '0.9em' }}>
                        {stage.sub}
                      </span>
                    )}
                  </p>

                  {/* Tool badge */}
                  <code
                    style={{
                      fontFamily: "'Courier New', Courier, monospace",
                      fontSize: 'clamp(0.52rem, 0.72vw, 0.62rem)',
                      color: colors.gold,
                      background: `${colors.gold}12`,
                      border: `1px solid ${colors.gold}30`,
                      borderRadius: '4px',
                      padding: '3px 8px',
                      whiteSpace: 'nowrap',
                      flexShrink: 0,
                    }}
                  >
                    {stage.tool}
                  </code>
                </div>
              </motion.div>

              {/* Arrow between stages */}
              {i < stages.length - 1 && (
                <div
                  style={{
                    textAlign: 'center',
                    color: `${colors.gold}60`,
                    fontSize: 'clamp(0.7rem, 1vw, 0.9rem)',
                    lineHeight: 1,
                    margin: '2px 0',
                  }}
                >
                  ↓
                </div>
              )}
            </div>
          ))}
        </div>

        {/* Size routing table */}
        <motion.div
          variants={fadeInUp}
          initial="hidden"
          animate="show"
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
              gridTemplateColumns: '1fr 1.4fr 1fr',
              background: 'rgba(101,52,105,0.2)',
              padding: '5px 18px',
              borderBottom: '1px solid rgba(255,255,255,0.08)',
            }}
          >
            {['Source Size', 'Strategy', 'Example'].map((h) => (
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
          {sizeRows.map((row, i) => (
            <div
              key={i}
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1.4fr 1fr',
                padding: '5px 18px',
                borderBottom: i < sizeRows.length - 1 ? '1px solid rgba(255,255,255,0.04)' : 'none',
                alignItems: 'center',
              }}
            >
              <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.52rem, 0.7vw, 0.62rem)', color: colors.gold, fontWeight: 600 }}>
                {row.size}
              </span>
              <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.52rem, 0.7vw, 0.62rem)', color: colors.text }}>
                {row.strategy}
              </span>
              <span style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.52rem, 0.7vw, 0.62rem)', color: colors.textDim }}>
                {row.example}
              </span>
            </div>
          ))}
        </motion.div>
      </div>
    </SlideLayout>
  );
}
