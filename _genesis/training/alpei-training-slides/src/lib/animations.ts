const prefersReducedMotion = typeof window !== 'undefined'
  ? window.matchMedia('(prefers-reduced-motion: reduce)').matches
  : false;

const ease = [0.25, 0.1, 0.25, 1] as const;

export const fadeInUp = prefersReducedMotion
  ? { hidden: { opacity: 0 }, show: { opacity: 1 } }
  : {
      hidden: { opacity: 0, y: 24 },
      show: { opacity: 1, y: 0, transition: { duration: 0.5, ease } },
    };

export const fadeIn = prefersReducedMotion
  ? { hidden: { opacity: 0 }, show: { opacity: 1 } }
  : {
      hidden: { opacity: 0 },
      show: { opacity: 1, transition: { duration: 0.4, ease } },
    };

export const fadeInLeft = prefersReducedMotion
  ? { hidden: { opacity: 0 }, show: { opacity: 1 } }
  : {
      hidden: { opacity: 0, x: -30 },
      show: { opacity: 1, x: 0, transition: { duration: 0.5, ease } },
    };

export const fadeInRight = prefersReducedMotion
  ? { hidden: { opacity: 0 }, show: { opacity: 1 } }
  : {
      hidden: { opacity: 0, x: 30 },
      show: { opacity: 1, x: 0, transition: { duration: 0.5, ease } },
    };

export const scaleIn = prefersReducedMotion
  ? { hidden: { opacity: 0 }, show: { opacity: 1 } }
  : {
      hidden: { opacity: 0, scale: 0.95 },
      show: { opacity: 1, scale: 1, transition: { duration: 0.5, ease } },
    };

export const staggerContainer = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: { staggerChildren: 0.1 },
  },
};

export const staggerFast = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: { staggerChildren: 0.06 },
  },
};

export const slideTransition = {
  enter: { opacity: 0, x: 40 },
  center: { opacity: 1, x: 0 },
  exit: { opacity: 0, x: -40 },
};
