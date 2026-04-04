import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionStartSlide() {
  return (
    <SectionDivider
      number={4}
      title="GETTING STARTED"
      subtitle="Your first actions + how to customize"
      accentColor={colors.gold}
    />
  );
}
