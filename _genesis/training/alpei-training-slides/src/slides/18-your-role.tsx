import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInLeft, fadeInRight } from '../lib/animations';

const humanActivities = [
  { activity: 'Daily standup', frequency: 'Daily', time: '15 min' },
  { activity: 'Review AI output', frequency: 'Per task', time: '5-10 min' },
  { activity: 'Approve at gates', frequency: 'Per stage', time: '5 min' },
  { activity: 'Set priorities', frequency: 'Weekly', time: '20 min' },
  { activity: 'Escalate blockers', frequency: 'As needed', time: '10 min' },
];

const aiActivities = [
  { activity: 'Execute all tasks', trigger: 'Your command', output: 'Deliverables' },
  { activity: 'Pre-flight checks', trigger: 'Auto on UES work', output: 'Validation report' },
  { activity: 'Template routing', trigger: 'Auto on creation', output: 'Formatted note' },
  { activity: 'Chain-of-custody', trigger: 'Auto before build', output: 'Dependency check' },
  { activity: 'Commit & push', trigger: 'After changes', output: 'PR with audit trail' },
];

export default function YourRoleSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '64px 72px 48px' }}>
        {/* Headline */}
        <AnimatedText>
          <h1 style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1.5rem, 3vw, 2.5rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '-0.02em',
            margin: 0,
          }}>
            YOUR ROLE AS PROJECT MANAGER
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Two panel split */}
        <div style={{ flex: 1, display: 'flex', gap: '0', marginTop: '28px' }}>
          {/* LEFT: What You Do */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ flex: 1, paddingRight: '32px' }}
          >
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginBottom: '16px',
            }}>
              WHAT YOU DO
            </div>

            {/* Table */}
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr>
                  {['ACTIVITY', 'FREQUENCY', 'TIME'].map((h) => (
                    <th key={h} style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.5rem)',
                      color: colors.textDim,
                      textTransform: 'uppercase',
                      letterSpacing: '0.08em',
                      textAlign: 'left',
                      padding: '8px 8px 8px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.1)',
                    }}>
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {humanActivities.map((row) => (
                  <tr key={row.activity}>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 500,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                      color: colors.text,
                      padding: '10px 8px 10px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.activity}
                    </td>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                      color: colors.textDim,
                      padding: '10px 8px 10px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.frequency}
                    </td>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                      color: colors.muted,
                      padding: '10px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.time}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </motion.div>

          {/* Gold divider */}
          <div style={{
            width: '2px',
            background: `linear-gradient(180deg, transparent 5%, ${colors.gold} 30%, ${colors.gold} 70%, transparent 95%)`,
            marginTop: '8px',
          }} />

          {/* RIGHT: What AI Does */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ flex: 1, paddingLeft: '32px' }}
          >
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
              color: colors.midnightLight,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginBottom: '16px',
            }}>
              WHAT AI DOES
            </div>

            {/* Table */}
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr>
                  {['ACTIVITY', 'TRIGGER', 'OUTPUT'].map((h) => (
                    <th key={h} style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.5rem)',
                      color: colors.textDim,
                      textTransform: 'uppercase',
                      letterSpacing: '0.08em',
                      textAlign: 'left',
                      padding: '8px 8px 8px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.1)',
                    }}>
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {aiActivities.map((row) => (
                  <tr key={row.activity}>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 500,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.58rem)',
                      color: colors.text,
                      padding: '10px 8px 10px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.activity}
                    </td>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                      color: colors.textDim,
                      padding: '10px 8px 10px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.trigger}
                    </td>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                      color: colors.muted,
                      padding: '10px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.output}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </motion.div>
        </div>

        {/* Bottom quote */}
        <AnimatedText delay={0.7}>
          <div style={{
            borderLeft: `3px solid ${colors.gold}`,
            padding: '10px 0 10px 20px',
          }}>
            <p style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 500,
              fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
              color: colors.textDim,
              fontStyle: 'italic',
              margin: 0,
            }}>
              "You own the what and why. AI owns the how and when."
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
