import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText, StaggerGroup, StaggerItem } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { staggerContainer, fadeInUp } from '../lib/animations';

const sectionsLeft = [
  { num: '01', title: 'INTRODUCTION' },
  { num: '02', title: 'THE ALPEI FRAMEWORK' },
  { num: '03', title: 'YOUR WORKSPACE' },
  { num: '04', title: 'DAILY WORKFLOW' },
];

const sectionsRight = [
  { num: '05', title: 'WORK STREAM DEEP DIVE' },
  { num: '06', title: 'VERSION & ITERATION' },
  { num: '07', title: 'GETTING STARTED' },
  { num: '08', title: 'APPENDIX' },
];

function AgendaItem({ num, title }: { num: string; title: string }) {
  return (
    <motion.div
      variants={fadeInUp}
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '16px',
        marginBottom: '28px',
      }}
    >
      <span
        style={{
          fontFamily: 'Inter, sans-serif',
          fontWeight: 800,
          fontSize: 'clamp(1.25rem, 2.5vw, 1.75rem)',
          color: colors.gold,
          minWidth: '48px',
        }}
      >
        {num}
      </span>
      <span
        style={{
          fontFamily: 'Inter, sans-serif',
          fontWeight: 400,
          fontSize: 'clamp(0.875rem, 1.5vw, 1.125rem)',
          color: colors.text,
          letterSpacing: '0.02em',
        }}
      >
        {title}
      </span>
    </motion.div>
  );
}

export default function AgendaSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '60px 100px',
        }}
      >
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.75rem, 3.5vw, 2.5rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              marginBottom: '48px',
            }}
          >
            AGENDA
          </h1>
        </AnimatedText>

        {/* Two columns */}
        <div
          style={{
            display: 'flex',
            gap: '80px',
          }}
        >
          {/* Left column - slightly wider */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ flex: '1.1' }}
          >
            {sectionsLeft.map((s) => (
              <AgendaItem key={s.num} num={s.num} title={s.title} />
            ))}
          </motion.div>

          {/* Right column */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="show"
            style={{ flex: '1' }}
          >
            {sectionsRight.map((s) => (
              <AgendaItem key={s.num} num={s.num} title={s.title} />
            ))}
          </motion.div>
        </div>
      </div>
    </SlideLayout>
  );
}
