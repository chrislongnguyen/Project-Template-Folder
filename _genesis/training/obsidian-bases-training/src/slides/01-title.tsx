import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { colors } from '../lib/theme';

export default function TitleSlide() {
  return (
    <SlideLayout>
      {/* Gold accent bar on left edge */}
      <motion.div
        initial={{ scaleY: 0 }}
        animate={{ scaleY: 1 }}
        transition={{ duration: 0.8, ease: [0.25, 0.1, 0.25, 1] }}
        style={{
          position: 'absolute',
          left: 0,
          top: 0,
          bottom: 0,
          width: '8px',
          background: `linear-gradient(180deg, ${colors.gold} 0%, ${colors.goldDim} 100%)`,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      {/* Atmospheric midnight green radial behind text */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `
            radial-gradient(ellipse at 35% 45%, rgba(0, 72, 81, 0.55) 0%, transparent 55%),
            radial-gradient(ellipse at 75% 70%, rgba(0, 72, 81, 0.2) 0%, transparent 45%)
          `,
          zIndex: 0,
        }}
      />

      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '0 120px',
          position: 'relative',
          zIndex: 1,
        }}
      >
        {/* OBSIDIAN BASES — large gold gradient headline */}
        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.2, ease: [0.25, 0.1, 0.25, 1] }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(3.5rem, 8vw, 6.5rem)',
            lineHeight: 0.95,
            letterSpacing: '-0.03em',
            background: `linear-gradient(135deg, ${colors.gold} 0%, #e6b84d 40%, ${colors.goldDim} 100%)`,
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text',
            margin: 0,
          }}
        >
          ITERATION 2: EFFICIENT
        </motion.h1>

        {/* Subtitle */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.5, ease: [0.25, 0.1, 0.25, 1] }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(0.8rem, 1.6vw, 1.2rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '0.08em',
            marginTop: '20px',
          }}
        >
          Your Project Operating System — Now With Dashboards, Knowledge Base &amp; Agent Skills
        </motion.p>

        {/* Tagline */}
        <motion.p
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.7 }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.75rem, 1.2vw, 1rem)',
            color: colors.textDim,
            marginTop: '20px',
            letterSpacing: '0.05em',
          }}
        >
          Dashboards + PKB + Skills + Filesystem
        </motion.p>

        {/* Iteration progression bar */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.85 }}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            marginTop: '20px',
            fontFamily: 'Inter, sans-serif',
            fontSize: 'clamp(0.6rem, 0.9vw, 0.76rem)',
          }}
        >
          <span style={{ color: colors.muted, fontWeight: 400 }}>I1 Sustainable</span>
          <span style={{ color: colors.textDim, opacity: 0.5 }}>──►</span>
          <span
            style={{
              color: colors.gold,
              fontWeight: 700,
              background: 'rgba(242, 199, 92, 0.12)',
              padding: '2px 10px',
              borderRadius: '3px',
              border: `1px solid rgba(242, 199, 92, 0.3)`,
            }}
          >
            I2 Efficient
          </span>
          <span style={{ color: colors.textDim, opacity: 0.5 }}>──►</span>
          <span style={{ color: colors.muted, fontWeight: 400 }}>I3 Scalable</span>
        </motion.div>

        {/* Decorative divider */}
        <motion.div
          initial={{ scaleX: 0, opacity: 0 }}
          animate={{ scaleX: 1, opacity: 1 }}
          transition={{ duration: 0.6, delay: 0.9 }}
          style={{
            width: '80px',
            height: '2px',
            background: `linear-gradient(90deg, ${colors.gold}, transparent)`,
            marginTop: '32px',
            transformOrigin: 'left',
          }}
        />

        {/* Footer */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.5 }}
          transition={{ duration: 0.5, delay: 1.1 }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
            color: colors.textDim,
            position: 'absolute',
            bottom: '48px',
            left: '120px',
            letterSpacing: '0.1em',
          }}
        >
          LT Capital Partners · 2026
        </motion.p>
      </div>
    </SlideLayout>
  );
}
