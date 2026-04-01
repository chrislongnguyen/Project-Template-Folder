import { motion } from 'framer-motion';
import { SlideLayout } from '../components/SlideLayout';
import { AnimatedText } from '../components/AnimatedText';
import { colors } from '../lib/theme';
import { fadeInUp, fadeIn, staggerContainer } from '../lib/animations';

const vanaRows = [
  {
    version: 'LOGIC SCAFFOLD',
    verb: 'Understand & design',
    adverb: 'Clearly, completely',
    noun: 'Scope & logic',
    adjective: 'Clear, complete',
  },
  {
    version: 'CONCEPT',
    verb: 'Derisk & deliver',
    adverb: 'Correctly, safely',
    noun: 'Simulated environment',
    adjective: 'Correct, safe',
  },
  {
    version: 'PROTOTYPE',
    verb: 'Derisk & deliver',
    adverb: '+ more easily, better',
    noun: 'Prototype system',
    adjective: '+ efficient',
  },
  {
    version: 'MVE',
    verb: 'Derisk & deliver',
    adverb: '+ reliably',
    noun: 'Full working system',
    adjective: '+ reliable, cheaper',
  },
  {
    version: 'LEADERSHIP',
    verb: 'Derisk & deliver',
    adverb: '+ automatically',
    noun: 'Full system + actions',
    adjective: '+ automatic, predictive',
  },
];

const headers = ['VERSION', 'VERB', 'ADVERB', 'NOUN', 'ADJECTIVE'];

export default function VanaSlide() {
  return (
    <SlideLayout>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          height: '100%',
          padding: '48px 80px',
        }}
      >
        {/* Headline */}
        <AnimatedText>
          <h1
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(1.5rem, 3vw, 2.25rem)',
              color: colors.text,
              textTransform: 'uppercase',
              letterSpacing: '-0.02em',
              margin: '0 0 12px 0',
            }}
          >
            VANA SUCCESS CRITERIA
          </h1>
        </AnimatedText>

        {/* Subtitle explanation */}
        <AnimatedText delay={0.1}>
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.7rem, 1vw, 0.85rem)',
              color: colors.textDim,
              margin: '0 0 32px 0',
            }}
          >
            Every version defines "done" through four dimensions:{' '}
            <span style={{ color: colors.gold, fontWeight: 800 }}>Verb</span> +{' '}
            <span style={{ color: colors.gold, fontWeight: 800 }}>Adverb</span> +{' '}
            <span style={{ color: colors.gold, fontWeight: 800 }}>Noun</span> +{' '}
            <span style={{ color: colors.gold, fontWeight: 800 }}>Adjective</span>
          </p>
        </AnimatedText>

        {/* VANA Table */}
        <motion.div
          variants={fadeInUp}
          initial="hidden"
          animate="show"
        >
          <table
            style={{
              width: '100%',
              borderCollapse: 'collapse',
              fontFamily: 'Inter, sans-serif',
            }}
          >
            <thead>
              <tr>
                {headers.map((h) => (
                  <th
                    key={h}
                    style={{
                      fontWeight: 800,
                      fontSize: 'clamp(0.5rem, 0.75vw, 0.65rem)',
                      color: colors.gold,
                      textTransform: 'uppercase',
                      letterSpacing: '0.06em',
                      textAlign: 'left',
                      borderBottom: `2px solid rgba(242, 199, 92, 0.3)`,
                      padding: '8px 12px',
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {vanaRows.map((row, i) => (
                <motion.tr
                  key={row.version}
                  initial={{ opacity: 0, x: -10 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.3 + i * 0.08, duration: 0.3 }}
                >
                  <td
                    style={{
                      fontWeight: 800,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.gold,
                      borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                      padding: '9px 12px',
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {row.version}
                  </td>
                  <td
                    style={{
                      fontWeight: 400,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.text,
                      borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                      padding: '9px 12px',
                    }}
                  >
                    {row.verb}
                  </td>
                  <td
                    style={{
                      fontWeight: 400,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.textDim,
                      borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                      padding: '9px 12px',
                    }}
                  >
                    {row.adverb}
                  </td>
                  <td
                    style={{
                      fontWeight: 400,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.text,
                      borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                      padding: '9px 12px',
                    }}
                  >
                    {row.noun}
                  </td>
                  <td
                    style={{
                      fontWeight: 400,
                      fontSize: 'clamp(0.55rem, 0.8vw, 0.7rem)',
                      color: colors.textDim,
                      borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
                      padding: '9px 12px',
                    }}
                  >
                    {row.adjective}
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </motion.div>

        {/* How to read VANA */}
        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8, duration: 0.5 }}
          style={{
            marginTop: '28px',
            borderLeft: `3px solid ${colors.gold}`,
            paddingLeft: '16px',
          }}
        >
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 800,
              fontSize: 'clamp(0.55rem, 0.75vw, 0.65rem)',
              color: colors.muted,
              textTransform: 'uppercase',
              letterSpacing: '0.05em',
              margin: '0 0 4px 0',
            }}
          >
            HOW TO READ VANA
          </p>
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
              color: colors.textDim,
              margin: '0 0 4px 0',
              lineHeight: 1.5,
            }}
          >
            Formula:{' '}
            <span style={{ color: colors.text, fontWeight: 800 }}>
              [Verb] [Adverb] a [Adjective] [Noun]
            </span>
          </p>
          <p
            style={{
              fontFamily: 'Inter, sans-serif',
              fontWeight: 400,
              fontSize: 'clamp(0.6rem, 0.9vw, 0.8rem)',
              color: colors.textDim,
              margin: 0,
              lineHeight: 1.5,
            }}
          >
            Example (Concept):{' '}
            <span style={{ color: colors.gold, fontStyle: 'italic' }}>
              "Derisk and deliver correctly, safely a correct, safe simulated environment"
            </span>
          </p>
        </motion.div>
      </div>
    </SlideLayout>
  );
}
