import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionQmdSlide() {
  return (
    <SectionDivider
      number={6}
      title="QMD & Memory Vault"
      subtitle="How semantic search powers auto-recall across sessions"
      accentColor={colors.midnightLight}
    />
  );
}
