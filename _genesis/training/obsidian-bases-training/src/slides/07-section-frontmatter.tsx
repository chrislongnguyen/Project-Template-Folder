import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionFrontmatter() {
  return (
    <SectionDivider
      number={2}
      title="THE FRONTMATTER SYSTEM"
      subtitle="The metadata that powers every dashboard"
      accentColor={colors.midnightLight}
    />
  );
}
