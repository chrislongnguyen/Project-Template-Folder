import { SectionDivider } from '../components/SectionDivider';
import { colors } from '../lib/theme';

export default function SectionPkbSlide() {
  return (
    <SectionDivider
      number={5}
      title="Personal Knowledge Base"
      subtitle="New in I2: Your AI-powered knowledge system — inspired by Andrej Karpathy (ex-Tesla AI, OpenAI founding member) and his LLM-wiki pattern"
      accentColor={colors.purple}
    />
  );
}
