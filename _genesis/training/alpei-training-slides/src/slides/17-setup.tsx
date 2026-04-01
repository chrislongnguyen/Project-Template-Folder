import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeInLeft, fadeInRight, staggerContainer } from '../lib/animations';

const tools = [
  { name: 'Claude Code', hint: 'CLI agent — reads CLAUDE.md, dispatches agents' },
  { name: 'Git', hint: 'Version control — branching strategy I0–I4' },
  { name: 'Node.js v18+', hint: 'Required for Claude Code and build tools' },
  { name: 'VS Code / IDE', hint: 'Code editor with Claude Code extension' },
  { name: 'GitHub', hint: 'Remote repo, PRs, Issues' },
];

const configFiles = [
  'CLAUDE.md', 'AGENTS.md', '.claude/rules/',
  '.claude/agents/', '.claude/skills/',
  '.claude/settings.json', '_genesis/frameworks/',
  '_genesis/templates/', '_genesis/brand/',
  'scripts/template-check.sh',
];

const steps = [
  { num: '01', label: 'Clone template' },
  { num: '02', label: 'Run template-check.sh' },
  { num: '03', label: 'Open in Claude Code' },
  { num: '04', label: 'Run /dsbv status' },
  { num: '05', label: '/dsbv design align' },
];

export default function SetupSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '64px 72px 48px' }}>
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
            SETUP CHECKLIST
          </h1>
          <div style={{
            width: '80px',
            height: '3px',
            background: colors.gold,
            marginTop: '12px',
          }} />
        </AnimatedText>

        {/* Two columns */}
        <div style={{ flex: 1, display: 'flex', gap: '48px', marginTop: '32px' }}>
          {/* LEFT: Required Tools */}
          <motion.div
            variants={fadeInLeft}
            initial="hidden"
            animate="show"
            style={{ flex: 1 }}
          >
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginBottom: '20px',
            }}>
              REQUIRED TOOLS
            </div>

            <StaggerGroup>
              {tools.map((tool) => (
                <StaggerItem key={tool.name}>
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px',
                    marginBottom: '14px',
                  }}>
                    {/* Checkbox icon */}
                    <div style={{
                      width: '18px',
                      height: '18px',
                      border: `2px solid ${colors.gold}`,
                      borderRadius: '3px',
                      flexShrink: 0,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                    }}>
                      <div style={{
                        width: '8px',
                        height: '8px',
                        borderRadius: '1px',
                        background: colors.gold,
                        opacity: 0.5,
                      }} />
                    </div>
                    <div>
                      <div style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 600,
                        fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                        color: colors.text,
                      }}>
                        {tool.name}
                      </div>
                      <div style={{
                        fontFamily: 'Inter, sans-serif',
                        fontWeight: 400,
                        fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                        color: colors.muted,
                        marginTop: '2px',
                      }}>
                        {tool.hint}
                      </div>
                    </div>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </motion.div>

          {/* Gold divider */}
          <div style={{
            width: '1px',
            background: `linear-gradient(180deg, transparent, ${colors.gold}40, transparent)`,
          }} />

          {/* RIGHT: Key Config Files */}
          <motion.div
            variants={fadeInRight}
            initial="hidden"
            animate="show"
            style={{ flex: 1 }}
          >
            <div style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 700,
              fontSize: 'clamp(0.6rem, 0.85vw, 0.75rem)',
              color: colors.gold,
              textTransform: 'uppercase',
              letterSpacing: '0.1em',
              marginBottom: '20px',
            }}>
              KEY CONFIG FILES
            </div>

            <StaggerGroup>
              {configFiles.map((cf) => (
                <StaggerItem key={cf}>
                  <div style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '10px',
                    marginBottom: '12px',
                  }}>
                    <div style={{
                      width: '6px',
                      height: '6px',
                      borderRadius: '50%',
                      background: colors.midnight,
                      border: `1px solid ${colors.midnightLight}`,
                      flexShrink: 0,
                    }} />
                    <span style={{
                      fontFamily: 'Inter, sans-serif',
                      fontWeight: 500,
                      fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
                      color: colors.textDim,
                    }}>
                      {cf}
                    </span>
                  </div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </motion.div>
        </div>

        {/* Bottom: First-time setup */}
        <AnimatedText delay={0.6}>
          <div style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 700,
            fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
            color: colors.gold,
            textTransform: 'uppercase',
            letterSpacing: '0.1em',
            marginBottom: '14px',
          }}>
            FIRST-TIME SETUP
          </div>
          <div style={{ display: 'flex', gap: '4px', alignItems: 'center' }}>
            {steps.map((step, i) => (
              <div key={step.num} style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  padding: '8px 14px',
                  background: 'rgba(0, 72, 81, 0.2)',
                  borderRadius: '4px',
                  border: '1px solid rgba(255, 255, 255, 0.06)',
                }}>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 700,
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    color: colors.gold,
                  }}>
                    {step.num}
                  </span>
                  <span style={{
                    fontFamily: 'Inter, sans-serif',
                    fontWeight: 500,
                    fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)',
                    color: colors.textDim,
                  }}>
                    {step.label}
                  </span>
                </div>
                {i < steps.length - 1 && (
                  <div style={{
                    color: colors.muted,
                    fontSize: 'clamp(0.5rem, 0.7vw, 0.6rem)',
                    opacity: 0.4,
                  }}>
                    ›
                  </div>
                )}
              </div>
            ))}
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
