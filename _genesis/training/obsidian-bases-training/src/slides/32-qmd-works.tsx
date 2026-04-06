import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const searchTypes = [
  {
    pill: 'lex',
    pillColor: colors.gold,
    pillBg: `${colors.gold}18`,
    pillBorder: `${colors.gold}50`,
    desc: 'Exact keyword matching — fast, precise',
    example: '"connection pool" timeout',
  },
  {
    pill: 'vec',
    pillColor: colors.green,
    pillBg: `${colors.green}18`,
    pillBorder: `${colors.green}50`,
    desc: 'Meaning-based — understands intent',
    example: 'how does rate limiter handle burst?',
  },
  {
    pill: 'hyde',
    pillColor: colors.purple,
    pillBg: `${colors.purple}18`,
    pillBorder: `${colors.purple}50`,
    desc: 'Write what the answer looks like',
    example: 'The rate limiter uses token bucket...',
  },
];

const tiers = [
  {
    label: 'Tier 1',
    name: 'Auto-Memory',
    desc: 'Built into Claude Code — remembers facts across sessions natively',
    accent: colors.gold,
    accentBg: `${colors.gold}10`,
    border: `${colors.gold}30`,
  },
  {
    label: 'Tier 2',
    name: 'Memory Vault',
    desc: 'Google Drive + markdown — sessions/, conversations/, decisions/',
    accent: colors.midnightLight,
    accentBg: `rgba(0, 72, 81, 0.2)`,
    border: `rgba(0, 72, 81, 0.5)`,
  },
  {
    label: 'Tier 3',
    name: 'QMD Search Layer',
    desc: 'Indexes all Tier 2 markdown + PKB distilled/ + 2-LEARN structured output — lex, vec, hyde',
    accent: colors.green,
    accentBg: `${colors.green}10`,
    border: `${colors.green}30`,
  },
];

export default function QmdWorksSlide() {
  return (
    <SlideLayout>
      {/* Accent bar */}
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
          background: colors.midnightLight,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '32px 80px 28px 100px',
          position: 'relative',
          zIndex: 1,
          gap: '16px',
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.05}>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.1rem, 2.2vw, 1.7rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 6px 0',
            }}
          >
            HOW QMD WORKS — YOUR LOCAL SEARCH ENGINE
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.midnightLight, marginBottom: '4px' }} />
        </AnimatedText>

        {/* Flow diagram */}
        <motion.div variants={fadeInUp} initial="hidden" animate="show" style={{ display: 'flex', alignItems: 'stretch', gap: '0' }}>
          {[
            {
              title: 'YOUR MARKDOWN FILES',
              lines: ['distilled/', 'sessions/', 'conversations/', 'decisions/', '2-LEARN/_cross/output/'],
              sub: 'You write/ingest/research',
            },
            null,
            {
              title: 'QMD ENGINE',
              lines: ['BM25 keyword', '+ vector embed', '+ reranking'],
              sub: 'Indexes locally',
            },
            null,
            {
              title: 'YOUR AGENT',
              lines: ['"Based on your', 'wiki page on X,', 'the answer is..."'],
              sub: 'Searches automatically',
            },
          ].map((item, i) => {
            if (item === null) {
              return (
                <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '0 6px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '2px' }}>
                    <div style={{ width: '20px', height: '1.5px', background: `${colors.gold}70` }} />
                    <div style={{
                      width: 0, height: 0,
                      borderTop: '5px solid transparent',
                      borderBottom: '5px solid transparent',
                      borderLeft: `7px solid ${colors.gold}70`,
                    }} />
                  </div>
                </div>
              );
            }
            return (
              <div
                key={i}
                style={{
                  flex: 1,
                  padding: '10px 14px',
                  borderRadius: '6px',
                  background: 'rgba(29,31,42,0.5)',
                  border: '1px solid rgba(255,255,255,0.06)',
                }}
              >
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontWeight: 700,
                  fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                  color: colors.gold,
                  textTransform: 'uppercase',
                  letterSpacing: '0.06em',
                  marginBottom: '6px',
                }}>
                  {item.title}
                </div>
                {item.lines.map((l, j) => (
                  <div key={j} style={{
                    fontFamily: "'Courier New', Courier, monospace",
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: colors.textDim,
                    lineHeight: 1.5,
                  }}>{l}</div>
                ))}
                <div style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.45rem, 0.6vw, 0.52rem)',
                  color: colors.muted,
                  marginTop: '6px',
                  fontStyle: 'italic',
                }}>{item.sub}</div>
              </div>
            );
          })}
        </motion.div>

        {/* Search types table */}
        <motion.div variants={staggerContainer} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
          <div style={{
            display: 'grid',
            gridTemplateColumns: '80px 1fr 1fr',
            gap: '8px',
            padding: '4px 10px',
          }}>
            {['TYPE', 'HOW IT WORKS', 'EXAMPLE'].map((h) => (
              <span key={h} style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}>{h}</span>
            ))}
          </div>
          {searchTypes.map((row) => (
            <StaggerItem key={row.pill}>
              <div style={{
                display: 'grid',
                gridTemplateColumns: '80px 1fr 1fr',
                gap: '8px',
                padding: '8px 10px',
                borderRadius: '5px',
                background: 'rgba(29,31,42,0.4)',
                border: '1px solid rgba(255,255,255,0.05)',
                alignItems: 'center',
              }}>
                <div style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  padding: '3px 8px',
                  borderRadius: '4px',
                  background: row.pillBg,
                  border: `1px solid ${row.pillBorder}`,
                  width: 'fit-content',
                }}>
                  <span style={{
                    fontFamily: "'Courier New', Courier, monospace",
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                    color: row.pillColor,
                  }}>{row.pill}</span>
                </div>
                <span style={{
                  fontFamily: 'Inter, sans-serif',
                  fontSize: 'clamp(0.52rem, 0.72vw, 0.62rem)',
                  color: colors.text,
                }}>{row.desc}</span>
                <span style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.48rem, 0.65vw, 0.56rem)',
                  color: colors.muted,
                  background: colors.gunmetal,
                  padding: '2px 6px',
                  borderRadius: '3px',
                }}>{row.example}</span>
              </div>
            </StaggerItem>
          ))}
        </motion.div>

        {/* Tier architecture */}
        <motion.div variants={fadeInLeft} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
          {tiers.map((tier) => (
            <div key={tier.label} style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '8px 14px',
              borderRadius: '5px',
              background: tier.accentBg,
              border: `1px solid ${tier.border}`,
            }}>
              <div style={{
                width: '3px',
                alignSelf: 'stretch',
                borderRadius: '2px',
                background: tier.accent,
                flexShrink: 0,
              }} />
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.48rem, 0.65vw, 0.55rem)',
                color: tier.accent,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
                minWidth: '54px',
              }}>{tier.label}</div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.52rem, 0.72vw, 0.62rem)',
                color: colors.text,
                minWidth: '120px',
              }}>{tier.name}</div>
              <div style={{
                fontFamily: 'Inter, sans-serif',
                fontSize: 'clamp(0.48rem, 0.65vw, 0.56rem)',
                color: colors.textDim,
              }}>{tier.desc}</div>
            </div>
          ))}
        </motion.div>

        {/* Flywheel callout */}
        <motion.div variants={fadeInUp} initial="hidden" animate="show">
          <div style={{
            padding: '10px 16px',
            borderRadius: '6px',
            border: `1px solid ${colors.gold}40`,
            background: `${colors.gold}07`,
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
          }}>
            <div style={{
              width: '3px',
              alignSelf: 'stretch',
              borderRadius: '2px',
              background: colors.gold,
              flexShrink: 0,
            }} />
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 500,
              fontSize: 'clamp(0.52rem, 0.72vw, 0.62rem)',
              color: colors.textDim,
              margin: 0,
              fontStyle: 'italic',
            }}>
              The flywheel: ingest → wiki grows → QMD indexes → agent recalls → better answers → ingest more
            </p>
          </div>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
