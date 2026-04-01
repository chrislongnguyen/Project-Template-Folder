import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const categories = [
  { name: 'VERSION REGISTRY', count: 5, items: ['Per-workstream DSBV status', 'Version + status + date', 'Artifact inventory', 'Gate approval log', 'Chain-of-custody trail'], color: colors.gold },
  { name: 'ALWAYS-ON RULES', count: 5, items: ['alpei-pre-flight', 'alpei-chain-of-custody', 'versioning', 'dsbv', 'agent-dispatch'], color: colors.midnightLight },
  { name: 'SCRIPTS & CHECKS', count: 3, items: ['template-check.sh', 'skill-validator.sh', 'git-warn.sh hook'], color: colors.muted },
];

const raciRows = [
  { role: 'PM (YOU)', dashboards: 'VERSION_REGISTRY, gate approvals, /dsbv status', access: 'Full' },
  { role: 'ltc-planner', dashboards: 'DESIGN.md, SEQUENCE.md creation', access: 'Read + Draft' },
  { role: 'ltc-builder', dashboards: 'Workstream artifact production per SEQUENCE.md', access: 'Read + Write' },
  { role: 'ltc-reviewer', dashboards: 'VALIDATE.md — per-criterion PASS/FAIL', access: 'Read + Report' },
];

export default function DashboardsSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '60px 72px 44px' }}>
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
            TRACKING & GOVERNANCE
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Categories */}
        <div style={{ marginTop: '24px' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ display: 'flex', gap: '16px' }}
          >
            {categories.map((cat) => (
              <motion.div
                key={cat.name}
                variants={fadeInUp}
                style={{
                  flex: 1,
                  padding: '18px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                  borderRadius: '6px',
                  background: 'rgba(255, 255, 255, 0.02)',
                  borderTop: `3px solid ${cat.color}`,
                }}
              >
                <div style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  marginBottom: '12px',
                }}>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: cat.color,
                    textTransform: 'uppercase',
                    letterSpacing: '0.08em',
                  }}>
                    {cat.name}
                  </span>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.7rem, 1.1vw, 0.95rem)',
                    color: cat.color,
                  }}>
                    {cat.count}
                  </span>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                  {cat.items.map((item) => (
                    <span key={item} style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                      color: colors.textDim,
                      lineHeight: 1.4,
                    }}>
                      {item}
                    </span>
                  ))}
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Total */}
        <AnimatedText delay={0.4}>
          <div style={{
            textAlign: 'center',
            margin: '18px 0',
          }}>
            <span style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 900,
              fontSize: 'clamp(1.2rem, 2.5vw, 2rem)',
              color: colors.gold,
            }}>
              13
            </span>
            <span style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 600,
              fontSize: 'clamp(0.55rem, 0.85vw, 0.75rem)',
              color: colors.textDim,
              textTransform: 'uppercase',
              letterSpacing: '0.08em',
              marginLeft: '10px',
            }}>
              ENFORCEMENT POINTS
            </span>
          </div>
        </AnimatedText>

        {/* By RACI Role table */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
          <AnimatedText delay={0.5}>
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginBottom: '10px',
            }}>
              BY RACI ROLE
            </div>
          </AnimatedText>

          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
          >
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr>
                  {['ROLE', 'PRIMARY DASHBOARDS', 'ACCESS'].map((h) => (
                    <th key={h} style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.4rem, 0.55vw, 0.48rem)',
                      color: colors.textDim,
                      textTransform: 'uppercase',
                      letterSpacing: '0.08em',
                      textAlign: 'left',
                      padding: '8px 12px 8px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.1)',
                    }}>
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {raciRows.map((row) => (
                  <motion.tr key={row.role} variants={fadeInUp}>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 600,
                      fontSize: 'clamp(0.42rem, 0.6vw, 0.52rem)',
                      color: row.role.includes('YOU') ? colors.gold : colors.text,
                      padding: '8px 12px 8px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.role}
                    </td>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.4rem, 0.58vw, 0.5rem)',
                      color: colors.textDim,
                      padding: '8px 12px 8px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.dashboards}
                    </td>
                    <td style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 500,
                      fontSize: 'clamp(0.4rem, 0.58vw, 0.5rem)',
                      color: colors.muted,
                      padding: '8px 0',
                      borderBottom: '1px solid rgba(255,255,255,0.04)',
                    }}>
                      {row.access}
                    </td>
                  </motion.tr>
                ))}
              </tbody>
            </table>
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
