import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp } from '../lib/animations';

interface TreeEntry {
  name: string;
  indent: number;
  dotColor?: string;
  isDir?: boolean;
  isComment?: boolean;
}

const tree: TreeEntry[] = [
  { name: '_genesis/', indent: 0, isDir: true },
  { name: 'obsidian/', indent: 1, isDir: true },
  { name: 'bases/', indent: 2, isDir: true, isComment: false },
  { name: '# Layer 1 — Cross-cutting (command center)', indent: 3, isComment: true },
  { name: 'C1-master-dashboard.base', indent: 3, dotColor: colors.gold },
  { name: 'C2-stage-board.base', indent: 3, dotColor: colors.gold },
  { name: 'C3-standup-preparation.base', indent: 3, dotColor: colors.gold },
  { name: 'C4-blocker-dashboard.base', indent: 3, dotColor: colors.gold },
  { name: 'C5-approval-queue.base', indent: 3, dotColor: colors.gold },
  { name: 'C6-version-progress.base', indent: 3, dotColor: colors.gold },
  { name: '# Layer 2 — Workstream (1-ALIGN → 5-IMPROVE)', indent: 3, isComment: true },
  { name: 'W1-alignment-overview.base', indent: 3, dotColor: colors.midnightLight },
  { name: 'W2-learning-overview.base', indent: 3, dotColor: colors.midnightLight },
  { name: 'W3-planning-overview.base', indent: 3, dotColor: colors.midnightLight },
  { name: 'W4-execution-overview.base', indent: 3, dotColor: colors.midnightLight },
  { name: 'W5-improvement-overview.base', indent: 3, dotColor: colors.midnightLight },
  { name: '# Layer 3 — Utility (supporting tools)', indent: 3, isComment: true },
  { name: 'U1-daily-notes-index.base', indent: 3, dotColor: colors.muted },
  { name: 'U2-tasks-overview.base', indent: 3, dotColor: colors.muted },
  { name: 'U3-inbox-overview.base', indent: 3, dotColor: colors.muted },
  { name: 'U4-people-directory.base', indent: 3, dotColor: colors.muted },
  { name: 'U5-templates-library.base', indent: 3, dotColor: colors.muted },
  { name: 'C7-dependency-tracker.base', indent: 3, dotColor: colors.muted },
  { name: 'U6-agent-activity.base', indent: 3, dotColor: colors.muted },
  { name: 'ltc-bases-colors.css', indent: 2, dotColor: colors.goldDim },
];

const INDENT_PX = 18;

function Legend({ color, label }: { color: string; label: string }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
      <div
        style={{
          width: '8px',
          height: '8px',
          borderRadius: '50%',
          background: color,
          flexShrink: 0,
        }}
      />
      <span
        style={{
          fontFamily: 'Inter, sans-serif',
          fontWeight: 400,
          fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
          color: colors.textDim,
        }}
      >
        {label}
      </span>
    </div>
  );
}

export default function WhereAreBasesSlide() {
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

      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 75% 25%, rgba(0, 72, 81, 0.2) 0%, transparent 50%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '40px 120px 36px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
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
            WHERE ARE YOUR .BASE FILES?
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '20px',
            }}
          />
        </AnimatedText>

        {/* File tree + legend */}
        <div style={{ flex: 1, display: 'flex', gap: '40px', alignItems: 'flex-start', minHeight: 0 }}>

          {/* Tree */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            animate="show"
            style={{
              flex: 1,
              padding: '16px 20px',
              borderRadius: '8px',
              background: 'rgba(0,0,0,0.3)',
              border: `1px solid rgba(255,255,255,0.07)`,
              fontFamily: 'monospace',
              overflowY: 'auto',
            }}
          >
            {tree.map((entry, i) => {
              const prefix = entry.indent === 0 ? '' :
                entry.indent === 1 ? '  └── ' :
                entry.indent === 2 ? '      ├── ' :
                '          ├── ';

              return (
                <div
                  key={i}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '6px',
                    lineHeight: '1.6',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'monospace',
                      fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
                      color: entry.isDir ? colors.textDim : colors.muted,
                      whiteSpace: 'pre',
                    }}
                  >
                    {prefix}
                  </span>

                  {entry.dotColor && !entry.isDir && (
                    <div
                      style={{
                        width: '6px',
                        height: '6px',
                        borderRadius: '50%',
                        background: entry.dotColor,
                        flexShrink: 0,
                      }}
                    />
                  )}

                  <span
                    style={{
                      fontFamily: 'monospace',
                      fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)',
                      color: entry.isComment
                        ? 'rgba(255,255,255,0.28)'
                        : entry.isDir
                        ? colors.text
                        : entry.dotColor === colors.gold
                        ? colors.gold
                        : entry.dotColor === colors.midnightLight
                        ? colors.midnightLight
                        : entry.dotColor === colors.goldDim
                        ? colors.goldDim
                        : colors.textDim,
                      fontWeight: entry.isDir ? 700 : 400,
                      fontStyle: entry.isComment ? 'italic' : 'normal',
                    }}
                  >
                    {entry.name}
                    {entry.indent === 2 && entry.name === 'bases/' && (
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: 400,
                          fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                          color: colors.muted,
                          marginLeft: '12px',
                        }}
                      >
                        ← 18 dashboard files
                      </span>
                    )}
                    {entry.name === 'ltc-bases-colors.css' && (
                      <span
                        style={{
                          fontFamily: 'Inter, sans-serif',
                          fontWeight: 400,
                          fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                          color: colors.muted,
                          marginLeft: '12px',
                        }}
                      >
                        ← LTC brand theme
                      </span>
                    )}
                  </span>
                </div>
              );
            })}
          </motion.div>

          {/* Legend */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.5, duration: 0.4 }}
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '10px',
              paddingTop: '4px',
              minWidth: '160px',
            }}
          >
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                color: colors.textDim,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
                margin: '0 0 4px 0',
              }}
            >
              LEGEND
            </p>
            <Legend color={colors.gold} label="Cross-cutting dashboards" />
            <Legend color={colors.midnightLight} label="Per-workstream views" />
            <Legend color={colors.muted} label="Utility dashboards" />
            <Legend color={colors.goldDim} label="CSS theme file" />
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
