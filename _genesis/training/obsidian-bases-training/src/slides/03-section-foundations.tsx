import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionFoundations() {
  return (
    <SectionDivider
      number={1}
      title="FOUNDATIONS"
      subtitle="Understanding your tools before using them"
      accentColor={colors.gold}
    />
  );
}
