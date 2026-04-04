import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const yamlFields = [
  { key: 'type:', value: 'ues-deliverable', comment: '← UES = User Enablement System' },
  { key: 'status:', value: 'in-progress', comment: '' },
  { key: 'stage:', value: 'build', comment: '' },
  { key: 'work_stream:', value: '4-execute', comment: '' },
  { key: 'sub_system:', value: '2-DP', comment: '' },
];

const routes = [
  {
    name: 'C1-master-dashboard',
    reason: 'type = ues-deliverable',
    color: colors.gold,
  },
  {
    name: 'C2-stage-board',
    reason: 'stage = build → Build column',
    color: colors.midnightLight,
  },
  {
    name: 'W4-execution-overview',
    reason: 'work_stream = 4-execute',
    color: colors.green,
  },
  {
    name: 'C4-blocker-dashboard',
    reason: 'if days_stale > threshold',
    color: colors.ruby,
  },
];

const statusEffects = [
  {
    status: 'draft',
    effect: 'not in active views',
    color: '#4a4d5e',
    textColor: '#9ca0b5',
  },
  {
    status: 'in-progress',
    effect: 'appears in standup, blocker, approval',
    color: `${colors.gold}60`,
    textColor: colors.gold,
  },
  {
    status: 'in-review',
    effect: 'appears in C5-approval-queue (highlighted)',
    color: `${colors.purple}60`,
    textColor: '#9b78b5',
  },
  {
    status: 'validated',
    effect: 'moves to completed sections',
    color: `${colors.green}60`,
    textColor: '#8bc46a',
  },
  {
    status: 'archived',
    effect: 'hidden from most views',
    color: '#2a2d3d',
    textColor: '#5a5d70',
  },
];

export default function FrontmatterToDashboardSlide() {
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
          padding: '40px 80px 32px',
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
            FRONTMATTER → DASHBOARD
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

        {/* Three column flow */}
        <div style={{ flex: 1, display: 'flex', gap: '24px', alignItems: 'stretch' }}>
          {/* Left: YOUR .MD FILE */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            style={{
              flex: '0 0 220px',
              display: 'flex',
              flexDirection: 'column',
              gap: '8px',
            }}
          >
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                color: colors.textDim,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                margin: '0 0 6px 0',
              }}
            >
              YOUR .MD FILE
            </p>
            <div
              style={{
                background: colors.gunmetal,
                border: '1px solid rgba(255,255,255,0.1)',
                borderRadius: '8px',
                padding: '14px 16px',
                flex: 1,
              }}
            >
              <p
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                  color: 'rgba(255,255,255,0.3)',
                  margin: '0 0 4px 0',
                }}
              >
                ---
              </p>
              {yamlFields.map((f) => (
                <div key={f.key}>
                  <p
                    style={{
                      fontFamily: "'Courier New', Courier, monospace",
                      fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                      margin: '2px 0',
                      lineHeight: 1.7,
                    }}
                  >
                    <span style={{ color: colors.midnightLight }}>{f.key}</span>
                    {' '}
                    <span style={{ color: colors.gold }}>{f.value}</span>
                  </p>
                  {f.comment ? (
                    <p
                      style={{
                        fontFamily: "'Courier New', Courier, monospace",
                        fontSize: 'clamp(0.42rem, 0.58vw, 0.5rem)',
                        color: 'rgba(255,255,255,0.3)',
                        margin: '0 0 3px 0',
                        fontStyle: 'italic',
                        lineHeight: 1.3,
                      }}
                    >
                      {f.comment}
                    </p>
                  ) : null}
                </div>
              ))}
              <p
                style={{
                  fontFamily: "'Courier New', Courier, monospace",
                  fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                  color: 'rgba(255,255,255,0.3)',
                  margin: '4px 0 0 0',
                }}
              >
                ---
              </p>
            </div>
          </motion.div>

          {/* Center: Routes to dashboards */}
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.4 }}
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
              gap: '8px',
            }}
          >
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                color: colors.textDim,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                margin: '0 0 6px 0',
              }}
            >
              ROUTES TO DASHBOARDS
            </p>
            <motion.div
              variants={staggerContainer}
              initial="hidden"
              animate="show"
              style={{ display: 'flex', flexDirection: 'column', gap: '8px', flex: 1 }}
            >
              {routes.map((r) => (
                <motion.div
                  key={r.name}
                  variants={fadeInUp}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '10px',
                    padding: '10px 14px',
                    borderRadius: '6px',
                    background: 'rgba(29,31,42,0.6)',
                    border: `1px solid ${r.color}40`,
                    borderLeft: `3px solid ${r.color}`,
                  }}
                >
                  <div style={{ flex: 1 }}>
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 600,
                        fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
                        color: r.color,
                        margin: 0,
                      }}
                    >
                      {r.name}
                    </p>
                    <p
                      style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                        color: colors.textDim,
                        margin: '2px 0 0 0',
                      }}
                    >
                      {r.reason}
                    </p>
                  </div>
                </motion.div>
              ))}
            </motion.div>
          </motion.div>

          {/* Right: STATUS CHANGE EFFECTS */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.5 }}
            style={{
              flex: '0 0 200px',
              display: 'flex',
              flexDirection: 'column',
              gap: '8px',
            }}
          >
            <p
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 800,
                fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                color: colors.textDim,
                textTransform: 'uppercase',
                letterSpacing: '0.1em',
                margin: '0 0 6px 0',
              }}
            >
              STATUS CHANGE EFFECTS
            </p>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', flex: 1 }}>
              {statusEffects.map((se) => (
                <div
                  key={se.status}
                  style={{
                    padding: '8px 12px',
                    borderRadius: '5px',
                    background: se.color,
                    border: '1px solid rgba(255,255,255,0.06)',
                  }}
                >
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                      color: se.textColor,
                      margin: 0,
                      textTransform: 'lowercase',
                    }}
                  >
                    {se.status}
                  </p>
                  <p
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 400,
                      fontSize: 'clamp(0.45rem, 0.62vw, 0.52rem)',
                      color: 'rgba(255,255,255,0.5)',
                      margin: '2px 0 0 0',
                      lineHeight: 1.4,
                    }}
                  >
                    {se.effect}
                  </p>
                </div>
              ))}
            </div>
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
