import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

interface RaciRow {
  activity: string;
  pm: string;
  agent: string;
  pmIsActor: boolean;
}

const raciRows: RaciRow[] = [
  {
    activity: 'Create deliverable files with frontmatter',
    pm: '—',
    agent: 'Writes via /dsbv',
    pmIsActor: false,
  },
  {
    activity: 'Set version, stage, sub_system, work_stream',
    pm: '—',
    agent: 'Auto on creation',
    pmIsActor: false,
  },
  {
    activity: 'Update last_updated date',
    pm: '—',
    agent: 'Auto on every edit',
    pmIsActor: false,
  },
  {
    activity: 'Move status to in-review',
    pm: '—',
    agent: 'Requests your review',
    pmIsActor: false,
  },
  {
    activity: 'Approve (set status to validated)',
    pm: 'YOU decide',
    agent: 'NEVER — only you',
    pmIsActor: true,
  },
  {
    activity: 'View dashboards daily',
    pm: 'YOU check',
    agent: '—',
    pmIsActor: true,
  },
  {
    activity: 'Surface blockers & stale items',
    pm: '—',
    agent: 'Auto via formulas',
    pmIsActor: false,
  },
  {
    activity: 'Triage inbox captures',
    pm: 'YOU decide action',
    agent: '—',
    pmIsActor: true,
  },
  {
    activity: 'Write daily standup notes',
    pm: 'YOU reflect',
    agent: '—',
    pmIsActor: true,
  },
  {
    activity: 'Customize / add new dashboards',
    pm: 'YOU describe what you want',
    agent: 'Builds the .base file',
    pmIsActor: true,
  },
];

export default function WhoDoesWhatSlide() {
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

      {/* Atmospheric radial */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse at 80% 20%, rgba(0, 72, 81, 0.25) 0%, transparent 50%)`,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '48px 72px 40px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* Header */}
        <AnimatedText delay={0.1}>
          <div style={{ marginBottom: '20px' }}>
            <h1
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(1.4rem, 2.8vw, 2.1rem)',
                color: colors.text,
                textTransform: 'uppercase',
                letterSpacing: '-0.02em',
                margin: 0,
              }}
            >
              WHO DOES WHAT — SUMMARY
            </h1>
            <div style={{ width: '60px', height: '3px', background: colors.gold, marginTop: '10px' }} />
          </div>
        </AnimatedText>

        {/* Table */}
        <div style={{ flex: 1, display: 'flex', gap: '32px', minHeight: 0 }}>
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ flex: 1, display: 'flex', flexDirection: 'column', minHeight: 0 }}
          >
            <table style={{ width: '100%', borderCollapse: 'collapse', tableLayout: 'fixed' }}>
              <colgroup>
                <col style={{ width: '52%' }} />
                <col style={{ width: '24%' }} />
                <col style={{ width: '24%' }} />
              </colgroup>
              <thead>
                <tr>
                  {[
                    { label: 'ACTIVITY', align: 'left' as const },
                    { label: 'YOU (PM)', align: 'center' as const },
                    { label: 'AGENT', align: 'center' as const },
                  ].map((h) => (
                    <th
                      key={h.label}
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 700,
                        fontSize: 'clamp(0.4rem, 0.58vw, 0.52rem)',
                        color: colors.textDim,
                        textTransform: 'uppercase',
                        letterSpacing: '0.08em',
                        textAlign: h.align,
                        padding: '8px 8px 8px 0',
                        borderBottom: `1px solid rgba(255,255,255,0.12)`,
                      }}
                    >
                      {h.label}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {raciRows.map((row, i) => (
                  <tr
                    key={i}
                    style={{
                      background: row.pmIsActor ? `${colors.gold}06` : 'transparent',
                    }}
                  >
                    <td
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.42rem, 0.62vw, 0.56rem)',
                        color: colors.text,
                        padding: '8px 8px 8px 0',
                        borderBottom: '1px solid rgba(255,255,255,0.04)',
                        lineHeight: 1.4,
                      }}
                    >
                      {row.activity}
                    </td>
                    <td
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: row.pmIsActor ? 700 : 400,
                        fontSize: 'clamp(0.4rem, 0.6vw, 0.54rem)',
                        color: row.pmIsActor ? colors.gold : colors.muted,
                        padding: '8px 8px 8px 0',
                        borderBottom: '1px solid rgba(255,255,255,0.04)',
                        textAlign: 'center',
                        lineHeight: 1.4,
                      }}
                    >
                      {row.pm}
                    </td>
                    <td
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: !row.pmIsActor && row.agent !== '—' ? 600 : 400,
                        fontSize: 'clamp(0.4rem, 0.6vw, 0.54rem)',
                        color: !row.pmIsActor && row.agent !== '—' ? colors.midnightLight : colors.muted,
                        padding: '8px 0',
                        borderBottom: '1px solid rgba(255,255,255,0.04)',
                        textAlign: 'center',
                        lineHeight: 1.4,
                      }}
                    >
                      {row.agent}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </motion.div>
        </div>

        {/* Bottom gold callout */}
        <motion.div
          variants={fadeInRight}
          initial="hidden"
          animate="show"
          style={{ marginTop: '20px' }}
        >
          <div
            style={{
              padding: '14px 20px',
              borderRadius: '6px',
              border: `2px solid ${colors.gold}60`,
              background: `${colors.gold}08`,
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
            }}
          >
            <div
              style={{
                width: '4px',
                alignSelf: 'stretch',
                borderRadius: '2px',
                background: colors.gold,
                flexShrink: 0,
              }}
            />
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.6rem, 0.95vw, 0.82rem)',
                color: colors.gold,
                margin: 0,
                letterSpacing: '0.01em',
              }}
            >
              Agents write. You review. Only you approve. Dashboards show you everything.
            </p>
          </div>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
