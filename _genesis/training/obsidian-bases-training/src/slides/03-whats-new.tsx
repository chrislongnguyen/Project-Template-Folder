import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';

const features = [
  {
    accent: colors.gold,
    name: '18 Obsidian Dashboards',
    what: 'Live project views — standup prep, blocker detection, approval queue, version tracking',
    evidence: 'WHERE: _genesis/obsidian/bases/ (18 .base files). Open any .base in Obsidian.',
  },
  {
    accent: colors.purple,
    name: 'Personal Knowledge Base',
    what: 'Capture articles/docs → AI distils into searchable wiki pages (CODE pipeline)',
    evidence: 'WHERE: PERSONAL-KNOWLEDGE-BASE/ (captured/, distilled/, expressed/). HOW: /ingest',
  },
  {
    accent: colors.green,
    name: '5 New + 1 Upgraded Skill',
    what: '/ingest, /template-check, /template-sync, /setup, /vault-capture + upgraded /ltc-brainstorming',
    evidence: 'WHERE: .claude/skills/ (one folder per skill). HOW: Type the command in Claude Code.',
  },
  {
    accent: colors.midnight,
    name: 'Filesystem Blueprint',
    what: 'Subsystem-based folders (1-PD, 2-DP, 3-DA, 4-IDM) with routing rules and enforcement harness per workstream',
    evidence: 'SHIPPED: _genesis/BLUEPRINT.md + routing harness. Replaces flat charter/, decisions/ dirs.',
  },
  {
    accent: colors.ruby,
    name: 'Frontmatter Standard',
    what: 'Locked status vocabulary, SCREAMING work_stream format (e.g. 4-EXECUTE), sub_system codes',
    evidence: 'Every .md deliverable. Agent enforces on creation; /template-sync migrates existing.',
  },
  {
    accent: colors.midnightLight,
    name: 'LTC Brand Theme',
    what: 'Color-coded pills, zebra-striped tables, hover effects in Obsidian',
    evidence: 'WHERE: _genesis/obsidian/ltc-bases-colors.css + ltc-bases-theme plugin.',
  },
];

export default function WhatsNewSlide() {
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
            WHAT'S NEW IN Iteration 2
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

        <StaggerGroup>
          {features.map((f) => (
            <StaggerItem key={f.name}>
              <div
                style={{
                  position: 'relative',
                  display: 'flex',
                  flexDirection: 'column',
                  padding: '11px 16px 11px 22px',
                  marginBottom: '7px',
                  borderRadius: '6px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                  background: 'rgba(29, 31, 42, 0.5)',
                  overflow: 'hidden',
                }}
              >
                {/* Left accent bar */}
                <div
                  style={{
                    position: 'absolute',
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: '4px',
                    background: f.accent,
                  }}
                />

                <div style={{ display: 'flex', alignItems: 'baseline', gap: '12px', marginBottom: '3px' }}>
                  <span
                    style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 700,
                      fontSize: 'clamp(0.65rem, 0.95vw, 0.82rem)',
                      color: colors.text,
                      textTransform: 'uppercase',
                      letterSpacing: '0.02em',
                    }}
                  >
                    {f.name}
                  </span>
                </div>

                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.55rem, 0.78vw, 0.66rem)',
                    color: colors.text,
                    margin: '0 0 3px 0',
                    lineHeight: 1.45,
                    opacity: 0.85,
                  }}
                >
                  {f.what}
                </p>

                <p
                  style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.5rem, 0.68vw, 0.58rem)',
                    color: colors.muted,
                    margin: 0,
                    lineHeight: 1.4,
                  }}
                >
                  {f.evidence}
                </p>
              </div>
            </StaggerItem>
          ))}
        </StaggerGroup>
      </div>
    </SlideLayout>
  );
}
