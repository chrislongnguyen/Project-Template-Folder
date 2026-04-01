import { motion } from 'framer-motion';
import { SlideLayout } from './SlideLayout';
import { colors } from '../lib/theme';

interface SectionDividerProps {
  number: number;
  title: string;
  subtitle?: string;
  accentColor?: string;
}

export function SectionDivider({ number, title, subtitle, accentColor = colors.gold }: SectionDividerProps) {
  return (
    <SlideLayout>
      {/* Gold accent bar on left edge */}
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
          background: accentColor,
          transformOrigin: 'top',
          zIndex: 2,
        }}
      />

      <div style={{ display: 'flex', alignItems: 'center', height: '100%', padding: '0 120px' }}>
        <div>
          {/* Section number */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 0.15, x: 0 }}
            transition={{ duration: 0.6, delay: 0.1 }}
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 900,
              fontSize: 'clamp(6rem, 14vw, 12rem)',
              lineHeight: 0.85,
              color: accentColor,
              marginBottom: '16px',
            }}
          >
            {String(number).padStart(2, '0')}
          </motion.div>

          {/* Title */}
          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3, ease: [0.25, 0.1, 0.25, 1] }}
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(2rem, 4.5vw, 3.5rem)',
              color: '#e8eaf0',
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
            }}
          >
            {title}
          </motion.h1>

          {subtitle && (
            <motion.p
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.45 }}
              style={{
                fontFamily: 'Inter, sans-serif',
                fontWeight: 400,
                fontSize: 'clamp(0.875rem, 1.5vw, 1.125rem)',
                color: '#9ca0b5',
                marginTop: '12px',
                maxWidth: '600px',
              }}
            >
              {subtitle}
            </motion.p>
          )}
        </div>
      </div>
    </SlideLayout>
  );
}
