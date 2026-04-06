import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionQuickstart() {
  return (
    <SectionDivider
      number={1}
      title="Quick Start & Migration"
      subtitle="Upgrade from I1 → I2 with zero struggle, see your first dashboard"
      accentColor={colors.gold}
    />
  );
}
