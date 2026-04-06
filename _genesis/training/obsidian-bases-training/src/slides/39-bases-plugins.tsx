import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const corePlugins = [
  {
    name: 'Bases',
    purpose: 'Live dashboards — powers all 18 .base files (C1–C7, W1–W5, U1–U6)',
    install: 'Settings → Community Plugins → Search "bases" → Enable',
    accent: colors.gold,
  },
  {
    name: 'Templater',
    purpose: '13 pre-built templates (ADR, daily note, risk entry, deliverable, retro). Press Ctrl+T / Cmd+T',
    install: 'Search "templater" → Enable → Set template folder to _genesis/templates/',
    accent: colors.gold,
  },
  {
    name: 'Terminal',
    purpose: 'Run Claude Code inside Obsidian — no switching to a separate terminal',
    install: 'Search "terminal" → Enable → Opens embedded terminal panel',
    accent: colors.midnightLight,
  },
  {
    name: 'Local REST API',
    purpose: 'Enables /obsidian CLI search — agent can query your vault programmatically',
    install: 'Search "local-rest-api" → Enable → Runs on localhost:27124',
    accent: colors.midnightLight,
  },
];

const themeItems = [
  {
    name: 'LTC Bases Colors (CSS Snippet)',
    purpose: 'Color-coded pills for status (green/gold/ruby), workstream (ALPEI), stage (DSBV)',
    install: 'Settings → Appearance → CSS Snippets → Enable "ltc-bases-colors"',
    accent: colors.ruby,
  },
  {
    name: 'LTC Bases Theme (Plugin)',
    purpose: 'Structural table styling — Midnight Green headers, zebra striping, hover effects',
    install: 'Auto-loaded from .obsidian/plugins/ltc-bases-theme/ (already in repo)',
    accent: colors.ruby,
  },
];

function PluginRow({ plugin }: { plugin: { name: string; purpose: string; install: string; accent: string } }) {
  return (
    <motion.div
      variants={fadeInUp}
      style={{
        display: 'grid',
        gridTemplateColumns: '140px 1fr 1fr',
        gap: '16px',
        alignItems: 'center',
        padding: '10px 16px',
        borderRadius: '6px',
        background: 'rgba(29,31,42,0.4)',
        border: '1px solid rgba(255,255,255,0.05)',
        borderLeft: `3px solid ${plugin.accent}`,
      }}
    >
      <span
        style={{
          fontFamily: 'Inter, sans-serif',
          fontWeight: 700,
          fontSize: 'clamp(0.7rem, 0.95vw, 0.82rem)',
          color: plugin.accent,
        }}
      >
        {plugin.name}
      </span>
      <span
        style={{
          fontFamily: 'Inter, sans-serif',
          fontSize: 'clamp(0.6rem, 0.82vw, 0.7rem)',
          color: colors.text,
          lineHeight: 1.4,
        }}
      >
        {plugin.purpose}
      </span>
      <span
        style={{
          fontFamily: "'Courier New', Courier, monospace",
          fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
          color: colors.textDim,
          lineHeight: 1.4,
        }}
      >
        {plugin.install}
      </span>
    </motion.div>
  );
}

export default function BasesPluginsSlide() {
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
          padding: '32px 64px 28px 72px',
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.3rem, 2.5vw, 2rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 4px 0',
            }}
          >
            Obsidian Bases — Plugins & Theme
          </h1>
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.7rem, 0.95vw, 0.82rem)',
              color: colors.textDim,
              margin: '0 0 16px 0',
            }}
          >
            The plugins that power your dashboards, templates, and agent integration
          </p>
        </AnimatedText>

        {/* Column headers */}
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '140px 1fr 1fr',
            gap: '16px',
            padding: '0 16px 6px',
          }}
        >
          {['PLUGIN', 'WHAT IT DOES', 'HOW TO INSTALL'].map((h) => (
            <span
              key={h}
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.5rem, 0.65vw, 0.55rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              {h}
            </span>
          ))}
        </div>

        {/* Core plugins section */}
        <div style={{ marginBottom: '4px' }}>
          <div
            style={{
              display: 'inline-flex',
              background: `${colors.gold}22`,
              border: `1px solid ${colors.gold}50`,
              borderRadius: '4px',
              padding: '2px 10px',
              marginBottom: '6px',
            }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.5rem, 0.65vw, 0.55rem)',
                color: colors.gold,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              Core Plugins (Required)
            </span>
          </div>
        </div>
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ display: 'flex', flexDirection: 'column', gap: '5px', marginBottom: '12px' }}
        >
          {corePlugins.map((p) => (
            <PluginRow key={p.name} plugin={p} />
          ))}
        </motion.div>

        {/* Theme section */}
        <div style={{ marginBottom: '4px' }}>
          <div
            style={{
              display: 'inline-flex',
              background: `${colors.ruby}22`,
              border: `1px solid ${colors.ruby}50`,
              borderRadius: '4px',
              padding: '2px 10px',
              marginBottom: '6px',
            }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.5rem, 0.65vw, 0.55rem)',
                color: colors.ruby,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              LTC Brand Theme (Required)
            </span>
          </div>
        </div>
        <motion.div
          variants={staggerContainer}
          initial="hidden"
          animate="show"
          style={{ display: 'flex', flexDirection: 'column', gap: '5px', flex: 1 }}
        >
          {themeItems.map((p) => (
            <PluginRow key={p.name} plugin={p} />
          ))}
        </motion.div>

        {/* Bottom note */}
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8, duration: 0.4 }}
          style={{
            borderLeft: `3px solid ${colors.gold}`,
            background: `${colors.gold}08`,
            borderRadius: '0 6px 6px 0',
            padding: '8px 14px',
          }}
        >
          <p style={{ fontFamily: 'Inter, sans-serif', fontSize: 'clamp(0.6rem, 0.82vw, 0.7rem)', color: colors.textDim, margin: 0, fontStyle: 'italic' }}>
            All .base files and theme assets are pre-installed in your repo. You just enable the plugins and CSS snippet.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
