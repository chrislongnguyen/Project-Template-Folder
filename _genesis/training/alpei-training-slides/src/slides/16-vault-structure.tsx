import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const folders = [
  { name: '1-ALIGN', purpose: 'Your project charter, decisions, OKRs, stakeholders', dot: colors.gold },
  { name: '2-LEARN', purpose: 'Research pipeline — input materials, analysis, specs', dot: '#69C7CC' },
  { name: '3-PLAN', purpose: 'Architecture, risk register (UBS), driver register (UDS), roadmap', dot: '#69994D' },
  { name: '4-EXECUTE', purpose: 'Source code, tests, config, documentation', dot: '#FF9D3B' },
  { name: '5-IMPROVE', purpose: 'Changelog, metrics, retrospectives, version reviews', dot: colors.ruby },
  { name: '_genesis/', purpose: 'Shared knowledge base — brand guide, frameworks, templates', dot: '#653469' },
  { name: 'CLAUDE.md', purpose: 'Your AI agent reads this first — project rules & structure', dot: 'rgba(255,255,255,0.25)' },
  { name: 'scripts/', purpose: 'template-check.sh — validates your project setup', dot: 'rgba(255,255,255,0.15)' },
];

export default function VaultStructureSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '64px 80px 48px' }}>
        {/* Headline */}
        <AnimatedText>
          <h1 style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1.75rem, 3.5vw, 2.75rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '-0.02em',
            margin: 0,
          }}>
            YOUR PROJECT STRUCTURE
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Folder tree */}
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', paddingLeft: '40px' }}>
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ width: '100%', maxWidth: '700px' }}
          >
            {folders.map((folder, i) => (
              <motion.div
                key={folder.name}
                variants={fadeInUp}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '16px',
                  marginBottom: '4px',
                  position: 'relative',
                }}
              >
                {/* Vertical connecting line */}
                {i < folders.length - 1 && (
                  <div style={{
                    position: 'absolute',
                    left: '7px',
                    top: '20px',
                    bottom: '-4px',
                    width: '1px',
                    background: 'rgba(255, 255, 255, 0.06)',
                  }} />
                )}

                {/* Horizontal branch line */}
                <div style={{
                  position: 'relative',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  minWidth: '30px',
                }}>
                  {/* Dot */}
                  <div style={{
                    width: '14px',
                    height: '14px',
                    borderRadius: '50%',
                    background: folder.dot,
                    flexShrink: 0,
                    boxShadow: `0 0 8px ${folder.dot}40`,
                  }} />
                  {/* Branch */}
                  <div style={{
                    width: '20px',
                    height: '1px',
                    background: 'rgba(255, 255, 255, 0.08)',
                  }} />
                </div>

                {/* Folder info */}
                <div style={{
                  display: 'flex',
                  alignItems: 'baseline',
                  gap: '16px',
                  padding: '8px 0',
                }}>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 600,
                    fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
                    color: colors.text,
                    whiteSpace: 'nowrap',
                  }}>
                    {folder.name}
                  </span>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 400,
                    fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                    color: colors.textDim,
                  }}>
                    {folder.purpose}
                  </span>
                </div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
