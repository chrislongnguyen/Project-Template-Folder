import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';

const items = [
  {
    label: 'WHAT',
    headline: 'A free markdown editor that runs on your machine',
    detail: 'Opens your project folder as a "vault" — every .md file becomes a viewable page',
  },
  {
    label: 'HOW',
    headline: 'Wikilinks connect your files like a web',
    detail: 'Type [[filename]] in any note to create a clickable link. Obsidian tracks these automatically.',
  },
  {
    label: 'WHY',
    headline: 'Backlinks show you what references each file',
    detail: 'Click any file → see every other file that links TO it. No manual tracking needed.',
  },
  {
    label: 'WHAT',
    headline: 'Plugins extend its power',
    detail: 'Bases (dashboards), Terminal (Claude Code inside Obsidian), Graph View (visual map of connections)',
  },
  {
    label: 'HOW',
    headline: 'Your repo is already a vault',
    detail: 'Clone the project, open in Obsidian, everything is pre-configured.',
  },
];

const labelColor: Record<string, string> = {
  WHAT: colors.gold,
  HOW: colors.midnightLight,
  WHY: colors.green,
};

export default function WhatIsObsidianSlide() {
  return (
    <SlideLayout>
      {/* Left accent bar */}
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
          padding: '48px 120px',
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
            WHAT IS OBSIDIAN?
          </h1>
          <div
            style={{
              width: '60px',
              height: '3px',
              background: colors.gold,
              marginBottom: '32px',
            }}
          />
        </AnimatedText>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
        <StaggerGroup>
          {items.map((item, i) => (
            <StaggerItem key={i}>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '16px',
                  padding: '12px 16px',
                  borderRadius: '6px',
                  background: 'rgba(29, 31, 42, 0.5)',
                  border: '1px solid rgba(255,255,255,0.06)',
                }}
              >
                {/* Label badge */}
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
                    color: labelColor[item.label],
                    background: `${labelColor[item.label]}18`,
                    border: `1px solid ${labelColor[item.label]}40`,
                    borderRadius: '3px',
                    padding: '2px 6px',
                    textTransform: 'uppercase',
                    letterSpacing: '0.06em',
                    flexShrink: 0,
                    marginTop: '2px',
                  }}
                >
                  {item.label}
                </span>

                {/* Text */}
                <div style={{ flex: 1 }}>
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 600,
                      fontSize: 'clamp(0.75rem, 1.05vw, 0.875rem)',
                      color: colors.text,
                      margin: 0,
                      lineHeight: 1.4,
                    }}
                  >
                    {item.headline}
                  </p>
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                      color: colors.textDim,
                      margin: '4px 0 0 0',
                      lineHeight: 1.5,
                    }}
                  >
                    {item.detail}
                  </p>
                </div>
              </div>
            </StaggerItem>
          ))}
        </StaggerGroup>
        </div>
      </div>
    </SlideLayout>
  );
}
