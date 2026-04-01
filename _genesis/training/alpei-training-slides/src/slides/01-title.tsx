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
            radial-gradient(ellipse at 35% 45%, rgba(0, 72, 81, 0.5) 0%, transparent 55%),
            radial-gradient(ellipse at 70% 70%, rgba(0, 72, 81, 0.2) 0%, transparent 45%)
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
        {/* ALPEI - large gold gradient text */}
        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.2, ease: [0.25, 0.1, 0.25, 1] }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(5rem, 12vw, 9rem)',
            lineHeight: 0.95,
            letterSpacing: '-0.03em',
            background: `linear-gradient(135deg, ${colors.gold} 0%, #e6b84d 40%, ${colors.goldDim} 100%)`,
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text',
            margin: 0,
          }}
        >
          ALPEI
        </motion.h1>

        {/* AI OPERATING SYSTEM */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.5, ease: [0.25, 0.1, 0.25, 1] }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 800,
            fontSize: 'clamp(1rem, 2.5vw, 1.75rem)',
            color: colors.text,
            textTransform: 'uppercase',
            letterSpacing: '0.15em',
            marginTop: '16px',
          }}
        >
          AI OPERATING SYSTEM
        </motion.p>

        {/* Subtitle */}
        <motion.p
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.7 }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.75rem, 1.2vw, 1rem)',
            color: colors.textDim,
            marginTop: '24px',
            letterSpacing: '0.05em',
          }}
        >
          Training Deck v4.0 | LTC Capital Partners
        </motion.p>

        {/* Year */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.4 }}
          transition={{ duration: 0.5, delay: 0.9 }}
          style={{
            fontFamily: 'Inter, sans-serif',
            fontWeight: 400,
            fontSize: 'clamp(0.75rem, 1vw, 0.875rem)',
            color: colors.textDim,
            position: 'absolute',
            bottom: '48px',
            left: '120px',
            letterSpacing: '0.1em',
          }}
        >
          2026
        </motion.p>
      </div>
    </SlideLayout>
  );
}
