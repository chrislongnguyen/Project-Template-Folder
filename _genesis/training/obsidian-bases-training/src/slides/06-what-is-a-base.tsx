import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp } from '../lib/animations';

const bullets = [
  'A .base file is a live query over your vault',
  'It reads frontmatter — the metadata block at the top of every .md file, written in YAML (key: value pairs between --- markers)',
  'It renders as interactive tables, cards, or lists',
  "Formulas compute values like 'days stale' or 'risk level'",
  'Views let you slice the same data multiple ways',
];

const yamlLines = [
  { key: 'type:', value: 'ues-deliverable', comment: '← UES = User Enablement System — marks this as a project deliverable' },
  { key: 'status:', value: 'in-progress', comment: '' },
  { key: 'work_stream:', value: '4-EXECUTE', comment: '' },
  { key: 'stage:', value: 'build', comment: '' },
  { key: 'sub_system:', value: '2-DP', comment: '' },
];

export default function WhatIsABaseSlide() {
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
          padding: '48px 120px 40px',
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
            WHAT IS A BASE?
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

        {/* Two column layout */}
        <div style={{ flex: 1, display: 'flex', gap: '48px', alignItems: 'center' }}>
          {/* Left: bullet list */}
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
            <StaggerGroup>
              {bullets.map((b, i) => (
                <StaggerItem key={i}>
                  <div
                    style={{
                      display: 'flex',
                      alignItems: 'flex-start',
                      gap: '12px',
                    }}
                  >
                    <span
                      style={{
                        color: colors.gold,
                        fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
                        marginTop: '2px',
                        flexShrink: 0,
                      }}
                    >
                      ▸
                    </span>
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
                        color: colors.text,
                        margin: 0,
                        lineHeight: 1.5,
                      }}
                    >
                      {b}
                    </p>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
            </div>
          </div>

          {/* Right: YAML code block + arrow + label */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            animate="show"
            transition={{ delay: 0.4 }}
            style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '12px' }}
          >
            {/* Code block */}
            <div
              style={{
                background: colors.gunmetal,
                border: `1px solid rgba(255,255,255,0.1)`,
                borderRadius: '8px',
                padding: '20px 24px',
                width: '100%',
                fontFamily: "'Courier New', Courier, monospace",
              }}
            >
              {/* YAML header */}
              <p
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                  color: colors.textDim,
                  margin: '0 0 4px 0',
                }}
              >
                ---
              </p>
              {yamlLines.map((line) => (
                <div key={line.key}>
                  <p
                    style={{
                      fontFamily: "'Courier New', Courier, monospace",
                      fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                      margin: '2px 0',
                      lineHeight: 1.6,
                    }}
                  >
                    <span style={{ color: colors.midnightLight }}>{line.key}</span>
                    {' '}
                    <span style={{ color: colors.gold }}>{line.value}</span>
                  </p>
                  {line.comment ? (
                    <p
                      style={{
                        fontFamily: "'Courier New', Courier, monospace",
                        fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                        color: 'rgba(255,255,255,0.35)',
                        margin: '0 0 4px 0',
                        fontStyle: 'italic',
                        lineHeight: 1.4,
                      }}
                    >
                      {line.comment}
                    </p>
                  ) : null}
                </div>
              ))}
              <p
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                  color: colors.textDim,
                  margin: '4px 0 0 0',
                }}
              >
                ---
              </p>
            </div>

            {/* Arrow */}
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: '4px',
              }}
            >
              <div
                style={{
                  width: '1px',
                  height: '20px',
                  background: `${colors.gold}60`,
                }}
              />
              <span style={{ color: colors.gold, fontSize: 'clamp(0.8rem, 1.2vw, 1rem)' }}>▼</span>
            </div>

            {/* Result label */}
            <div
              style={{
                padding: '10px 20px',
                borderRadius: '6px',
                background: `${colors.midnight}40`,
                border: `1px solid ${colors.midnightLight}50`,
                textAlign: 'center',
              }}
            >
              <p
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.65rem, 0.9vw, 0.78rem)',
                  color: colors.gold,
                  margin: 0,
                  letterSpacing: '0.03em',
                }}
              >
                This metadata → powers every dashboard
              </p>
            </div>
          </motion.div>
        </div>

        {/* Bottom note */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.9, duration: 0.4 }}
          style={{
            marginTop: '20px',
            borderLeft: `3px solid ${colors.gold}`,
            paddingLeft: '14px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
              color: colors.textDim,
              margin: 0,
              fontStyle: 'italic',
            }}
          >
            You navigate your project through file metadata (frontmatter), not folder structure. Dashboards find files BY their metadata.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
