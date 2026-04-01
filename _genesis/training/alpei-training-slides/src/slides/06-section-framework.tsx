import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionFramework() {
  return (
    <SectionDivider
      number={2}
      title="THE ALPEI FRAMEWORK"
      subtitle="Three structural layers: 5 ALPEI workstreams × 4 DSBV phases"
      accentColor={colors.midnight}
    />
  );
}
