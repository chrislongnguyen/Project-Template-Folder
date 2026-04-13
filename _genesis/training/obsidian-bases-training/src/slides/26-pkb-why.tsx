import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const tableRows = [
  {
    insight: "LLM owns the wiki",
    impl: "Agent writes to 2-organised/ via /organise",
  },
  {
    insight: "Compile-at-ingest",
    impl: "AI reads source ONCE, writes permanent pages",
  },
  {
    insight: "Index-first retrieval",
    impl: "_index.md + QMD semantic search",
  },
  {
    insight: "Human reads wiki",
    impl: "Obsidian as your reading/review IDE",
  },
  {
    insight: "Schema co-evolution",
    impl: "schema.md + gotchas.md govern page structure",
  },
];

export default function PkbWhySlide() {
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
          justifyContent: 'center',
          height: '100%',
          padding: '40px 80px',
          gap: '18px',
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
            WHY A PERSONAL KNOWLEDGE BASE?
          </h1>
          <div style={{ width: '60px', height: '3px', background: colors.gold, marginBottom: '12px' }} />
        </AnimatedText>

        {/* Problem statement */}
        <motion.p
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, duration: 0.5 }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontSize: 'clamp(0.65rem, 0.9vw, 0.78rem)',
            color: colors.textDim,
            fontStyle: 'italic',
            margin: 0,
            lineHeight: 1.6,
          }}
        >
          You read articles, attend meetings, research tools — but knowledge evaporates. Bookmarks pile up. Notes scatter across apps. Six months later you re-learn the same thing.
        </motion.p>

        {/* Karpathy table */}
        <motion.div
          initial={{ opacity: 0, y: 14 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.35, duration: 0.5 }}
          style={{
            background: 'rgba(29,31,42,0.5)',
            border: '1px solid rgba(255,255,255,0.06)',
            borderRadius: '6px',
            overflow: 'hidden',
          }}
        >
          {/* Table header */}
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              background: 'rgba(101,52,105,0.25)',
              padding: '10px 20px',
              borderBottom: '1px solid rgba(255,255,255,0.08)',
            }}
          >
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.72vw, 0.62rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
              }}
            >
              KARPATHY'S INSIGHT
            </span>
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.55rem, 0.72vw, 0.62rem)',
                color: colors.gold,
                textTransform: 'uppercase',
                letterSpacing: '0.06em',
              }}
            >
              LTC'S IMPLEMENTATION
            </span>
          </div>

          {/* Table rows */}
          <motion.div variants={staggerContainer} initial="hidden" animate="show">
            {tableRows.map((row, i) => (
              <motion.div
                key={i}
                variants={fadeInUp}
                style={{
                  display: 'grid',
                  gridTemplateColumns: '1fr 1fr',
                  padding: '9px 20px',
                  borderBottom: i < tableRows.length - 1 ? '1px solid rgba(255,255,255,0.04)' : 'none',
                  alignItems: 'center',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.58rem, 0.78vw, 0.68rem)',
                    color: colors.muted,
                  }}
                >
                  {row.insight}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontSize: 'clamp(0.58rem, 0.78vw, 0.68rem)',
                    color: colors.gold,
                    fontWeight: 500,
                  }}
                >
                  {row.impl}
                </span>
              </motion.div>
            ))}
          </motion.div>
        </motion.div>

        {/* Gold callout */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7, duration: 0.5 }}
          style={{
            background: 'rgba(242,199,92,0.08)',
            border: '1px solid rgba(242,199,92,0.25)',
            borderLeft: `4px solid ${colors.gold}`,
            borderRadius: '6px',
            padding: '12px 18px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontSize: 'clamp(0.6rem, 0.82vw, 0.72rem)',
              color: colors.text,
              margin: 0,
              lineHeight: 1.6,
            }}
          >
            <span style={{ color: colors.gold, fontWeight: 700 }}>Key insight:</span>{' '}
            Compile-at-ingest, NOT RAG. The AI doesn't re-read sources — it wrote the answer into a wiki page when it first ingested.
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
