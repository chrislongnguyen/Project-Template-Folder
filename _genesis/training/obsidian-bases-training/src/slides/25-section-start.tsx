import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionStartSlide() {
  return (
    <SectionDivider
      number={8}
      title="Getting Started"
      subtitle="Setup, first actions, and reference"
      accentColor={colors.gold}
    />
  );
}
