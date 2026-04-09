import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';

const rows = [
  {
    num: '1',
    pain: '"What changed since yesterday?" — required git log or memory',
    solution: 'C3 Standup Preparation dashboard auto-surfaces files modified in last 24–72 hours',
    result: '5-min morning check replaces 15 min of digging',
  },
  {
    num: '2',
    pain: 'Blockers were invisible until standup or a missed deadline',
    solution: 'C4 Blocker dashboard auto-detects risk from days-since-last-update (no manual flags)',
    result: 'Blockers surface to you before they become crises',
  },
  {
    num: '3',
    pain: 'No approval workflow — you had to track "what needs my sign-off" in your head',
    solution: 'C5 Approval Queue collects all in-review items with urgency levels',
    result: 'You never miss a review, team never waits on you',
  },
  {
    num: '4',
    pain: 'Knowledge scattered across notes, chats, and bookmarks',
    solution: 'Personal Knowledge Base — capture sources → AI distils into searchable wiki',
    result: 'Knowledge compounds instead of evaporating',
  },
  {
    num: '5',
    pain: 'Agent output was a black box — files appeared but dashboards didn\'t exist',
    solution: '18 dashboards make agent work visible — status, stage, version, staleness',
    result: 'You manage by exception, not by inspection',
  },
  {
    num: '6',
    pain: 'Starting a new feature was blank-page anxiety',
    solution: '/ltc-brainstorming runs 4 invisible gates to structure your thinking before you write a line',
    result: 'Structured exploration replaces unstructured guessing',
  },
];

export default function PainPointsSlide() {
  return (
    <SlideLayout>
      {/* Ruby accent bar — this slide shows pain */}
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
          background: colors.ruby,
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
          padding: '36px 80px 36px 100px',
        }}
      >
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.2rem, 2.5vw, 1.9rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 6px 0',
            }}
          >
            WHY Iteration 2 MATTERS
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

        {/* Table header */}
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '28px 1fr 1.2fr 0.9fr',
            gap: '0 16px',
            padding: '6px 16px',
            marginBottom: '6px',
          }}
        >
          {['#', 'Iteration 1 PAIN POINT', 'Iteration 2 SOLUTION', 'RESULT FOR YOU'].map((h) => (
            <span
              key={h}
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 700,
                fontSize: 'clamp(0.5rem, 0.65vw, 0.58rem)',
                color: colors.muted,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              {h}
            </span>
          ))}
        </div>

        <StaggerGroup>
          {rows.map((row) => (
            <StaggerItem key={row.num}>
              <div
                style={{
                  display: 'grid',
                  gridTemplateColumns: '28px 1fr 1.2fr 0.9fr',
                  gap: '0 16px',
                  padding: '10px 16px',
                  marginBottom: '5px',
                  borderRadius: '6px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                  background: 'rgba(29, 31, 42, 0.5)',
                  alignItems: 'start',
                }}
              >
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 800,
                    fontSize: 'clamp(0.6rem, 0.9vw, 0.78rem)',
                    color: colors.ruby,
                    opacity: 0.8,
                    lineHeight: 1,
                    paddingTop: '1px',
                  }}
                >
                  {row.num}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.textDim,
                    lineHeight: 1.45,
                  }}
                >
                  {row.pain}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 500,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.text,
                    lineHeight: 1.45,
                  }}
                >
                  {row.solution}
                </span>
                <span
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.gold,
                    lineHeight: 1.45,
                  }}
                >
                  {row.result}
                </span>
              </div>
            </StaggerItem>
          ))}
        </StaggerGroup>

        {/* Gold callout */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 1.0 }}
          style={{
            marginTop: '20px',
            padding: '12px 20px',
            borderRadius: '6px',
            borderLeft: `3px solid ${colors.gold}`,
            background: 'rgba(242, 199, 92, 0.06)',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 500,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.72rem)',
              color: colors.gold,
              margin: 0,
              lineHeight: 1.5,
            }}
          >
            The shift: In Iteration 1, you managed the project. In Iteration 2,{' '}
            <strong>the project tells you what needs managing.</strong>
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
