import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp } from '../lib/animations';

const visible = [
  {
    headline: '18 Bases dashboards (.base files)',
    detail: 'Pre-built views that query your project files automatically',
  },
  {
    headline: 'LTC brand CSS theme',
    detail: "Color-coded badges (called 'pills') for status, stage, and workstream in dashboard tables",
  },
  {
    headline: 'Wikilinks & backlinks across all files',
    detail: '[[double-bracket]] links connect decisions, risks, specs — Obsidian resolves them',
  },
  {
    headline: 'Daily notes, inbox, people directories',
    detail: 'Quick capture + stakeholder tracking built into the vault structure',
  },
];

const invisible = [
  {
    headline: 'QMD (Query Markdown) — semantic search',
    detail: 'Searches your vault by meaning, not just keywords. Runs locally on your machine.',
  },
  {
    headline: '3-tier search routing',
    detail: 'Agent tries QMD first → Obsidian CLI second → Grep third (automatic)',
  },
  {
    headline: 'Security rules',
    detail: 'Dangerous Obsidian commands are permanently blocked — agents cannot accidentally damage your vault',
  },
  {
    headline: 'Agent skill: /obsidian',
    detail: 'Type /obsidian in Claude Code terminal to search your vault. Agent handles the rest.',
  },
];

export default function WhatWeBuiltSlide() {
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
          padding: '40px 120px 32px',
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
            WHAT WE BUILT FOR YOU
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

        {/* Two columns */}
        <div style={{ flex: 1, display: 'flex', gap: '20px', alignItems: 'stretch' }}>
          {/* VISIBLE column */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            animate="show"
            style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '8px' }}
          >
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                marginBottom: '8px',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                }}
              >
                VISIBLE
              </span>
              <div
                style={{
                  flex: 1,
                  height: '1px',
                  background: `${colors.gold}40`,
                }}
              />
            </div>

            <StaggerGroup>
              {visible.map((item, i) => (
                <StaggerItem key={i}>
                  <div
                    style={{
                      padding: '10px 14px',
                      borderRadius: '6px',
                      background: 'rgba(29, 31, 42, 0.6)',
                      border: `1px solid ${colors.gold}20`,
                      borderLeft: `3px solid ${colors.gold}`,
                    }}
                  >
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 600,
                        fontSize: 'clamp(0.65rem, 0.9vw, 0.78rem)',
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
                        fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                        color: colors.textDim,
                        margin: '3px 0 0 0',
                        lineHeight: 1.5,
                      }}
                    >
                      {item.detail}
                    </p>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </motion.div>

          {/* Column divider */}
          <div
            style={{
              width: '1px',
              background: 'rgba(255,255,255,0.07)',
              flexShrink: 0,
            }}
          />

          {/* INVISIBLE column */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            animate="show"
            transition={{ delay: 0.15 }}
            style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '8px' }}
          >
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                marginBottom: '8px',
              }}
            >
              <span
                style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 800,
                  fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                  color: colors.midnightLight,
                  textTransform: 'uppercase',
                  letterSpacing: '0.1em',
                }}
              >
                INVISIBLE (RUNS IN BACKGROUND)
              </span>
              <div
                style={{
                  flex: 1,
                  height: '1px',
                  background: `${colors.midnightLight}40`,
                }}
              />
            </div>

            <StaggerGroup>
              {invisible.map((item, i) => (
                <StaggerItem key={i}>
                  <div
                    style={{
                      padding: '10px 14px',
                      borderRadius: '6px',
                      background: 'rgba(0, 48, 57, 0.4)',
                      border: `1px solid ${colors.midnight}60`,
                      borderLeft: `3px solid ${colors.midnightLight}`,
                    }}
                  >
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 600,
                        fontSize: 'clamp(0.65rem, 0.9vw, 0.78rem)',
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
                        fontSize: 'clamp(0.55rem, 0.78vw, 0.65rem)',
                        color: colors.textDim,
                        margin: '3px 0 0 0',
                        lineHeight: 1.5,
                      }}
                    >
                      {item.detail}
                    </p>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </motion.div>
        </div>

        {/* Bottom note */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8, duration: 0.4 }}
          style={{
            marginTop: '16px',
            textAlign: 'center',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 600,
              fontSize: 'clamp(0.65rem, 0.9vw, 0.78rem)',
              color: colors.gold,
              margin: 0,
              letterSpacing: '0.03em',
            }}
          >
            All pre-configured. You just open the vault.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
