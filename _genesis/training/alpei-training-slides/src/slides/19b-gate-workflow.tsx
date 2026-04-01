import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, staggerContainer } from '../lib/animations';

const steps = [
  { num: '1', actor: 'YOU', label: 'Run /dsbv design align', desc: 'Pre-flight checks fire automatically. Agent verifies workstream, alignment, risks.', isHuman: true },
  { num: '2', actor: 'AGENT', label: 'ltc-planner drafts DESIGN.md', desc: 'Artifact inventory, binary acceptance criteria, alignment table. ~5 min.', isHuman: false },
  { num: '3', actor: 'YOU', label: 'Review DESIGN.md', desc: 'Check: Are these the right artifacts? Are ACs testable? Anything missing?', isHuman: true },
  { num: '4', actor: 'YOU', label: 'Approve or request changes', desc: 'Approve → Sequence unlocks. Changes → planner revises and re-presents.', isHuman: true },
  { num: '5', actor: 'SYSTEM', label: 'Same pattern for G2, G3, G4', desc: '4 gates × 5 workstreams = 20 approval points per iteration.', isHuman: false },
];

export default function GateWorkflowSlide() {
  return (
    <SlideLayout>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '56px 80px 44px' }}>
        <AnimatedText>
          <h1 style={{ fontFamily: 'Inter, sans-serif', fontWeight: 800, fontSize: 'clamp(1.5rem, 3vw, 2.25rem)', color: colors.text, textTransform: 'uppercase', letterSpacing: '-0.02em', margin: 0 }}>
            HOW A GATE WORKS
          </h1>
          <p style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)', color: colors.textDim, marginTop: '6px' }}>
            Example: G1 Design Gate for ALIGN workstream
          </p>
          <div style={{ width: '80px', height: '3px', background: colors.gold, marginTop: '10px' }} />
        </AnimatedText>

        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <motion.div variants={staggerContainer} initial="hidden" animate="show" style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {steps.map((step) => (
              <motion.div key={step.num} variants={fadeInUp} style={{
                display: 'grid', gridTemplateColumns: '44px 100px 1fr 1.5fr', gap: '14px', alignItems: 'center',
                padding: '12px 16px', borderLeft: `3px solid ${step.isHuman ? colors.gold : 'rgba(0, 72, 81, 0.4)'}`,
                background: step.isHuman ? 'rgba(242, 199, 92, 0.04)' : 'transparent',
              }}>
                <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 900, fontSize: 'clamp(1rem, 1.8vw, 1.4rem)', color: step.isHuman ? colors.gold : colors.muted, opacity: 0.3, lineHeight: 1 }}>{step.num}</div>
                <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 700, fontSize: 'clamp(0.45rem, 0.65vw, 0.55rem)', color: step.isHuman ? colors.gold : colors.midnightLight, textTransform: 'uppercase', letterSpacing: '0.06em' }}>{step.actor}</div>
                <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 600, fontSize: 'clamp(0.48rem, 0.7vw, 0.6rem)', color: colors.text }}>{step.label}</div>
                <div style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.4rem, 0.58vw, 0.5rem)', color: colors.textDim, lineHeight: 1.4 }}>{step.desc}</div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        <AnimatedText delay={0.7}>
          <div style={{ borderLeft: `3px solid ${colors.gold}`, padding: '8px 0 8px 14px' }}>
            <p style={{ fontFamily: 'Inter, sans-serif', fontWeight: 400, fontSize: 'clamp(0.5rem, 0.72vw, 0.62rem)', color: colors.textDim, margin: 0, lineHeight: 1.5 }}>
              The PM makes <span style={{ color: colors.gold, fontWeight: 600 }}>3 decisions</span> in this exchange: approve Design, approve Sequence, authorize Build cost. Agents do not advance on their own.
            </p>
          </div>
        </AnimatedText>
      </div>
    </SlideLayout>
  );
}
