import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionVersionsSlide() {
  return (
    <SectionDivider
      number={6}
      title="VERSION & ITERATION"
      subtitle="Progression, chain-of-custody, and iteration lifecycle"
      accentColor={colors.ruby}
    />
  );
}
