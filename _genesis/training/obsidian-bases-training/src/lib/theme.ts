export const colors = {
  midnight: '#004851',
  midnightLight: '#006a78',
  midnightDark: '#003039',
  gold: '#F2C75C',
  goldDim: '#c9a54a',
  ruby: '#9B1842',
  rubyLight: '#c22058',
  gunmetal: '#1D1F2A',
  gunmetalLight: '#2a2d3d',
  gunmetalDark: '#13141c',
  surface: '#232636',
  muted: '#8b8fa3',
  text: '#e8eaf0',
  textDim: '#9ca0b5',
  green: '#69994D',
  purple: '#653469',
} as const;

export const sectionColors: Record<string, string> = {
  'INTRODUCTION': colors.gold,
  'WHAT ARE BASES?': colors.midnight,
  'DASHBOARD TOUR': colors.midnightLight,
  'YOUR DAILY WORKFLOW': colors.gold,
  'FRONTMATTER SYSTEM': colors.midnight,
  'GETTING STARTED': colors.gold,
};
