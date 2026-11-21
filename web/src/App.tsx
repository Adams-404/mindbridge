import React, { useState, useEffect } from 'react';
import { Header } from './components/layout/Header';
import { Footer } from './components/layout/Footer';
import { HeroSection } from './components/landing/HeroSection';
import { WhySection } from './components/landing/WhySection';
import { FeaturesSection } from './components/landing/FeaturesSection';
import { LanguageSection } from './components/landing/LanguageSection';
import { SafetySection } from './components/landing/SafetySection';
import { StepsSection } from './components/landing/StepsSection';
import { FaqSection } from './components/landing/FaqSection';
import { DownloadSection } from './components/landing/DownloadSection';
import { WebPrototype } from './components/app/WebPrototype';
import { Language } from './types';

export const App: React.FC = () => {
  const [language, setLanguage] = useState<Language>('en');
  const [isPrototypeOpen, setIsPrototypeOpen] = useState(false);
  const [initialPrototypeTab, setInitialPrototypeTab] = useState('home');

  useEffect(() => {
    // Check initial hash for deep linking
    const hash = window.location.hash.toLowerCase();
    if (hash.startsWith('#app')) {
      const parts = hash.split('/');
      if (parts[1]) {
        setInitialPrototypeTab(parts[1]);
      }
      setIsPrototypeOpen(true);
    }
  }, []);

  const handleOpenPrototype = (tab: string = 'home') => {
    setInitialPrototypeTab(tab);
    setIsPrototypeOpen(true);
    window.location.hash = `#app/${tab}`;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleClosePrototype = () => {
    setIsPrototypeOpen(false);
    window.location.hash = '';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="mindbridge-app">
      <Header
        language={language}
        onLanguageChange={setLanguage}
        onOpenPrototype={() => {
          if (isPrototypeOpen) {
            handleClosePrototype();
          } else {
            handleOpenPrototype('home');
          }
        }}
        isPrototypeOpen={isPrototypeOpen}
      />

      <main id="main-content">
        {isPrototypeOpen ? (
          <WebPrototype
            initialTab={initialPrototypeTab}
            language={language}
            onLanguageChange={setLanguage}
            onClose={handleClosePrototype}
          />
        ) : (
          <>
            <HeroSection
              language={language}
              onOpenPrototype={handleOpenPrototype}
            />
            <WhySection language={language} />
            <FeaturesSection
              language={language}
              onOpenPrototype={handleOpenPrototype}
            />
            <LanguageSection language={language} />
            <SafetySection language={language} />
            <StepsSection language={language} />
            <FaqSection language={language} />
            <DownloadSection language={language} />
          </>
        )}
      </main>

      <Footer
        language={language}
        onOpenPrototype={() => handleOpenPrototype('home')}
      />
    </div>
  );
};

export default App;
