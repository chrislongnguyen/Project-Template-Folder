import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

const frontmatterCode = `---
type: ues-deliverable
version: "2.0"
status: draft | in-progress | in-review
       | validated | archived
work_stream: 1-ALIGN | 2-LEARN | 3-PLAN
            | 4-EXECUTE | 5-IMPROVE
stage: design | sequence | build | validate
sub_system: 1-PD | 2-DP | 3-DA | 4-IDM
owner: "Your Name"
last_updated: 2026-04-06
---`;

const locations = [
  { path: '_genesis/obsidian/bases/', desc: '18 dashboard .base files' },
  { path: '_genesis/obsidian/ltc-bases-colors.css', desc: 'LTC brand theme' },
  { path: '_genesis/training/', desc: 'Training deck' },
  { path: 'PERSONAL-KNOWLEDGE-BASE/', desc: 'Knowledge management' },
  { path: '.claude/skills/', desc: 'Agent skill definitions' },
  { path: '.claude/rules/', desc: 'Governance rules' },
  { path: 'scripts/', desc: 'Infrastructure scripts' },
];

export default function CheatSheetSlide() {
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
              fontSize: 'clamp(1.2rem, 2.5vw, 1.9rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 6px 0',
            }}
          >
            CHEAT SHEET
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '24px',
            }}
          />
        </AnimatedText>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '32px' }}>
          {/* Left: frontmatter code block */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
          >
            <div
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '10px',
              }}
            >
              Frontmatter Quick Reference
            </div>
            <pre
              style={{
                fontFamily: '"JetBrains Mono", "Fira Code", monospace',
                fontSize: 'clamp(0.48rem, 0.68vw, 0.58rem)',
                lineHeight: 1.8,
                color: colors.text,
                background: colors.gunmetal,
                border: `1px solid rgba(242, 199, 92, 0.15)`,
                borderRadius: '6px',
                padding: '16px 18px',
                margin: 0,
                whiteSpace: 'pre-wrap',
                wordBreak: 'break-word',
              }}
            >
              {frontmatterCode}
            </pre>
          </motion.div>

          {/* Right: file locations */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
          >
            <div
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.8vw, 0.68rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                marginBottom: '10px',
              }}
            >
              File Locations
            </div>
            <StaggerGroup>
              {locations.map((loc, i) => (
                <StaggerItem key={i}>
                  <div
                    style={{
                      padding: '10px 14px',
                      marginBottom: '6px',
                      borderRadius: '4px',
                      background: 'rgba(29, 31, 42, 0.5)',
                      border: '1px solid rgba(255,255,255,0.06)',
                    }}
                  >
                    <div
                      style={{
                        fontFamily: '"JetBrains Mono", "Fira Code", monospace',
                        fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                        color: colors.gold,
                        marginBottom: '2px',
                      }}
                    >
                      {loc.path}
                    </div>
                    <div
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                        color: colors.textDim,
                        lineHeight: 1.4,
                      }}
                    >
                      {loc.desc}
                    </div>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
