import { useSlideScale } from '../lib/useSlideScale';

interface SlideLayoutProps {
  children: React.ReactNode;
  className?: string;
}

export function SlideLayout({ children, className = '' }: SlideLayoutProps) {
  const { scale, width, height } = useSlideScale();

  return (
    <div
      style={{
        width: '100vw',
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
        background: '#13141c',
      }}
    >
      <div
        style={{
          width: `${width}px`,
          height: `${height}px`,
          transform: `scale(${scale})`,
          transformOrigin: 'center center',
          position: 'relative',
          overflow: 'hidden',
        }}
        className={className}
      >
        {/* Atmospheric background layers */}
        <div
          style={{
            position: 'absolute',
            inset: 0,
            background: `
              radial-gradient(ellipse at 10% 90%, rgba(0, 72, 81, 0.35) 0%, transparent 50%),
              radial-gradient(ellipse at 90% 10%, rgba(0, 72, 81, 0.2) 0%, transparent 50%),
              radial-gradient(ellipse at 50% 50%, rgba(29, 31, 42, 1) 0%, rgba(19, 20, 28, 1) 100%)
            `,
            zIndex: 0,
          }}
        />
        {/* Subtle grid pattern */}
        <div
          style={{
            position: 'absolute',
            inset: 0,
            backgroundImage: `
              linear-gradient(rgba(0, 72, 81, 0.06) 1px, transparent 1px),
              linear-gradient(90deg, rgba(0, 72, 81, 0.06) 1px, transparent 1px)
            `,
            backgroundSize: '60px 60px',
            zIndex: 0,
          }}
        />
        {/* Content */}
        <div style={{ position: 'relative', zIndex: 1, width: '100%', height: '100%' }}>
          {children}
        </div>
      </div>
    </div>
  );
}
