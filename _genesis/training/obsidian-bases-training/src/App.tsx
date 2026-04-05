import { useState, useEffect, useCallback } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { slides } from './slides';

export default function App() {
  const [current, setCurrent] = useState(0);
  const [direction, setDirection] = useState(0);

  const goNext = useCallback(() => {
    if (current < slides.length - 1) {
      setDirection(1);
      setCurrent((c) => c + 1);
    }
  }, [current]);

  const goPrev = useCallback(() => {
    if (current > 0) {
      setDirection(-1);
      setCurrent((c) => c - 1);
    }
  }, [current]);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'ArrowRight' || e.key === ' ' || e.key === 'Enter') {
        e.preventDefault();
        goNext();
      } else if (e.key === 'ArrowLeft') {
        e.preventDefault();
        goPrev();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [goNext, goPrev]);

  const handleClick = (e: React.MouseEvent) => {
    const target = e.target as HTMLElement;
    if (target.closest('[data-interactive]') || target.closest('button') || target.closest('input') || target.closest('a')) {
      return;
    }
    const rect = (e.currentTarget as HTMLElement).getBoundingClientRect();
    const x = e.clientX - rect.left;
    if (x > rect.width / 2) {
      goNext();
    } else {
      goPrev();
    }
  };

  const SlideComponent = slides[current];
  const progress = ((current + 1) / slides.length) * 100;

  return (
    <div onClick={handleClick} style={{ cursor: 'pointer', position: 'relative', width: '100vw', height: '100vh', overflow: 'hidden' }}>
      <AnimatePresence mode="wait">
        <motion.div
          key={current}
          initial={{ opacity: 0, x: direction >= 0 ? 40 : -40 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: direction >= 0 ? -40 : 40 }}
          transition={{ duration: 0.3, ease: [0.25, 0.1, 0.25, 1] }}
          style={{ position: 'absolute', inset: 0 }}
        >
          <SlideComponent />
        </motion.div>
      </AnimatePresence>

      {/* Progress bar */}
      <div
        style={{
          position: 'fixed',
          bottom: 0,
          left: 0,
          right: 0,
          height: '3px',
          background: 'rgba(0, 72, 81, 0.3)',
          zIndex: 100,
        }}
      >
        <motion.div
          animate={{ width: `${progress}%` }}
          transition={{ duration: 0.3, ease: 'easeOut' }}
          style={{
            height: '100%',
            background: 'linear-gradient(90deg, #004851, #F2C75C)',
          }}
        />
      </div>

      {/* Slide counter */}
      <div
        style={{
          position: 'fixed',
          bottom: '12px',
          right: '20px',
          fontFamily: 'Inter, sans-serif',
          fontSize: '12px',
          fontWeight: 500,
          color: 'rgba(156, 160, 181, 0.6)',
          zIndex: 100,
          userSelect: 'none',
        }}
      >
        {current + 1} / {slides.length}
      </div>
    </div>
  );
}
