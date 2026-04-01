import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, scaleIn, staggerContainer } from '../lib/animations';

const raciRows = [
  { activity: 'DEFINE SCOPE & GOALS', you: 'A', ai: 'R', stakeholder: 'C' },
  { activity: 'RESEARCH & ANALYSIS', you: 'I', ai: 'R', stakeholder: '-' },
  { activity: 'CREATE DELIVERABLES', you: 'I', ai: 'R', stakeholder: '-' },
  { activity: 'REVIEW & APPROVE', you: 'A', ai: 'I', stakeholder: 'C' },
  { activity: 'ESCALATE BLOCKERS', you: 'A', ai: 'R', stakeholder: 'I' },
  { activity: 'DAILY STANDUP', you: 'A', ai: 'R', stakeholder: 'I' },
];

function Badge({ label, color }: { label: string; color: string }) {
  return (
    <span
      style={{
        fontFamily: 'Inter, sans-serif',
        fontWeight: 800,
        fontSize: 'clamp(0.5rem, 0.7vw, 0.625rem)',
        color: '#fff',
        background: color,
        borderRadius: '4px',
        letterSpacing: '0.05em',
        textTransform: 'uppercase',
        display: 'inline-block',
        padding: '3px 10px',
      }}
    >
      {label}
    </span>
  );
}

export default function OperatingModelSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          height: '100%',
          padding: '48px 80px',
        }}
      >
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 36px 0',
            }}
          >
            OPERATING MODEL
          </h1>
        </AnimatedText>

        {/* Two-person team diagram */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '60px',
            marginBottom: '32px',
          }}
        >
          {/* YOU */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ textAlign: 'center' }}
          >
            <div
              style={{
                width: '72px',
                height: '72px',
                borderRadius: '50%',
                border: `2px solid ${colors.gold}`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                margin: '0 auto 10px',
              }}
            >
              <span style={{ fontSize: 'clamp(1.25rem, 2vw, 1.75rem)' }}>👤</span>
            </div>
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.875rem, 1.3vw, 1.125rem)',
                color: colors.text,
                margin: '0 0 4px 0',
              }}
            >
              YOU
            </p>
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.625rem, 0.9vw, 0.75rem)',
                color: colors.textDim,
                margin: '0 0 8px 0',
              }}
            >
              PROJECT MANAGER
            </p>
            <Badge label="ACCOUNTABLE" color={colors.goldDim} />
          </motion.div>

          {/* Arrow */}
          <motion.div
            variants={scaleIn}
            initial="hidden"
            animate="show"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
            }}
          >
            <div
              style={{
                width: '80px',
                height: '2px',
                background: `linear-gradient(90deg, ${colors.gold}, ${colors.midnight})`,
              }}
            />
            <span
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.6rem, 0.8vw, 0.7rem)',
                color: colors.textDim,
              }}
            >
              ↔
            </span>
            <div
              style={{
                width: '80px',
                height: '2px',
                background: `linear-gradient(90deg, ${colors.midnight}, ${colors.gold})`,
              }}
            />
          </motion.div>

          {/* AI AGENT */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ textAlign: 'center' }}
          >
            <div
              style={{
                width: '72px',
                height: '72px',
                borderRadius: '50%',
                border: `2px solid ${colors.midnight}`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                margin: '0 auto 10px',
              }}
            >
              <span style={{ fontSize: 'clamp(1.25rem, 2vw, 1.75rem)' }}>🤖</span>
            </div>
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.875rem, 1.3vw, 1.125rem)',
                color: colors.text,
                margin: '0 0 4px 0',
              }}
            >
              AI AGENT
            </p>
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.625rem, 0.9vw, 0.75rem)',
                color: colors.textDim,
                margin: '0 0 8px 0',
              }}
            >
              EXECUTOR
            </p>
            <Badge label="RESPONSIBLE" color={colors.midnight} />
          </motion.div>
        </div>

        {/* RACI Table */}
        <motion.div
          variants={fadeInUp}
          initial="hidden"
          animate="show"
          style={{ flex: 1 }}
        >
          <table
            style={{
              width: '100%',
              borderCollapse: 'collapse',
              fontFamily: 'Inter, sans-serif',
            }}
          >
            <thead>
              <tr>
                {['ACTIVITY', 'YOU (A)', 'AI (R)', 'STAKEHOLDER'].map((h) => (
                  <th
                    key={h}
                    style={{
                      fontWeight: 800,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.gold,
                      textTransform: 'uppercase',
                      letterSpacing: '0.05em',
                      textAlign: h === 'ACTIVITY' ? 'left' : 'center',
                      borderBottom: `1px solid rgba(255, 255, 255, 0.1)`,
                      padding: '8px 12px',
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {raciRows.map((row) => (
                <tr key={row.activity}>
                  <td
                    style={{
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      fontWeight: 400,
                      color: colors.text,
                      borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                      padding: '7px 12px',
                    }}
                  >
                    {row.activity}
                  </td>
                  {[row.you, row.ai, row.stakeholder].map((val, i) => (
                    <td
                      key={i}
                      style={{
                        fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                        fontWeight: val === 'A' || val === 'R' ? 800 : 400,
                        color:
                          val === 'A'
                            ? colors.gold
                            : val === 'R'
                              ? colors.midnightLight
                              : colors.textDim,
                        textAlign: 'center',
                        borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                        padding: '7px 12px',
                      }}
                    >
                      {val}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </motion.div>

        {/* Golden rule */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8, duration: 0.5 }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
            fontStyle: 'italic',
            color: colors.gold,
            textAlign: 'center',
            marginTop: '12px',
          }}
        >
          "AI proposes. You approve."
        </motion.p>
      </div>
    </SlideLayout>
  );
}
