import { motion } from 'framer-motion';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

interface AnimatedTextProps {
  children: React.ReactNode;
  className?: string;
  delay?: number;
  variant?: 'up' | 'fade';
}

export function AnimatedText({ children, className = '', delay = 0, variant = 'up' }: AnimatedTextProps) {
  const v = variant === 'up' ? fadeInUp : fadeIn;
  return (
    <motion.div
      variants={v}
      initial="hidden"
      animate="show"
      transition={{ delay }}
      className={className}
    >
      {children}
    </motion.div>
  );
}

interface StaggerGroupProps {
  children: React.ReactNode;
  className?: string;
}

export function StaggerGroup({ children, className = '' }: StaggerGroupProps) {
  return (
    <motion.div
      variants={staggerContainer}
      initial="hidden"
      animate="show"
      className={className}
    >
      {children}
    </motion.div>
  );
}

export function StaggerItem({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return (
    <motion.div variants={fadeInUp} className={className}>
      {children}
    </motion.div>
  );
}
