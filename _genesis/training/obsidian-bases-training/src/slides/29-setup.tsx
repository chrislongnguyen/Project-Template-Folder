import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInRight } from '../lib/animations';

const steps = [
  {
    num: '01',
    text: 'Download Obsidian from obsidian.md — free for personal use',
  },
  {
    num: '02',
    text: 'File → Open Vault → select your project\'s root folder',
  },
  {
    num: '03',
    text: 'Settings → Community Plugins → turn off Restricted Mode. This allows community plugins to run — it is safe here because our repo includes security rules.',
  },
  {
    num: '04',
    text: 'Install & enable: Bases (dashboards), Terminal (Claude Code in Obsidian), Templater (template insertion). Templater lets you create new files from 13 pre-built templates — press Ctrl+T (or Cmd+T) to insert one.',
  },
  {
    num: '05',
    text: 'Settings → Appearance → CSS Snippets → enable "ltc-bases-colors". CSS snippets customize how Obsidian looks — this one adds LTC brand colors to your dashboard tables.',
  },
  {
    num: '06',
    text: 'Install Obsidian Web Clipper browser extension — press ⌥⇧O on any web page to clip articles directly to 1-captured/ folder for /organise',
  },
  {
    num: '07',
    text: '(Optional) Install: Local REST API (/obsidian search), Dataview (PKB dashboard), Spaced Repetition (knowledge review)',
  },
  {
    num: '08',
    text: 'Navigate to _genesis/obsidian/bases/ → click any .base file to verify',
  },
];

export default function SetupSlide() {
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
          background: `radial-gradient(ellipse at 80% 80%, rgba(0, 72, 81, 0.2) 0%, transparent 50%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '48px 120px 40px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: '16px', marginBottom: '8px' }}>
            <h1
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
                color: colors.text,
                textTransform: 'uppercase',
                letterSpacing: '-0.02em',
                margin: 0,
              }}
            >
              OBSIDIAN SETUP &amp; INSTALL
            </h1>
          </div>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '28px',
            }}
          />
        </AnimatedText>

        {/* Steps */}
        <motion.div variants={staggerContainer} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '12px', flex: 1 }}>
          {steps.map((step) => (
            <StaggerItem key={step.num}>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '16px',
                  padding: '14px 18px',
                  borderRadius: '6px',
                  background: 'rgba(29, 31, 42, 0.5)',
                  border: `1px solid rgba(255,255,255,0.05)`,
                }}
              >
                {/* Step number */}
                <div
                  style={{
                    width: '32px',
                    height: '32px',
                    borderRadius: '50%',
                    background: `${colors.gold}14`,
                    border: `1.5px solid ${colors.gold}80`,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0,
                    marginTop: '1px',
                  }}
                >
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 800,
                      fontSize: 'clamp(0.48rem, 0.7vw, 0.6rem)',
                      color: colors.gold,
                      letterSpacing: '0.02em',
                    }}
                  >
                    {step.num}
                  </span>
                </div>

                {/* Step text */}
                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.65rem, 0.95vw, 0.82rem)',
                    color: colors.text,
                    margin: 0,
                    lineHeight: 1.55,
                  }}
                >
                  {step.text}
                </p>
              </div>
            </StaggerItem>
          ))}
        </motion.div>

        {/* Bottom note */}
        <motion.div
          variants={fadeInRight}
          initial="hidden"
          animate="show"
          style={{ marginTop: '20px' }}
        >
          <div
            style={{
              padding: '12px 18px',
              borderRadius: '6px',
              border: `1px solid ${colors.gold}40`,
              background: `${colors.gold}07`,
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
            }}
          >
            <div
              style={{
                width: '3px',
                alignSelf: 'stretch',
                borderRadius: '2px',
                background: colors.gold,
                flexShrink: 0,
              }}
            />
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 500,
                fontSize: 'clamp(0.58rem, 0.82vw, 0.7rem)',
                color: colors.textDim,
                margin: 0,
                fontStyle: 'italic',
              }}
            >
              The .base files and CSS are already in your repo. You just enable the plugin and snippet.
            </p>
          </div>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
