import React, { useState } from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface HeaderProps {
  language: Language;
  onLanguageChange: (lang: Language) => void;
  onOpenPrototype: () => void;
  isPrototypeOpen: boolean;
}

export const Header: React.FC<HeaderProps> = ({
  language,
  onLanguageChange,
  onOpenPrototype,
  isPrototypeOpen,
}) => {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const t = translations[language];

  const handleNavLinkClick = () => {
    setMobileMenuOpen(false);
  };

  return (
    <>
      <a href="#main-content" className="skip-link">
        Skip to main content
      </a>

      <div className="announcement" role="region" aria-label="Project status announcement">
        <span className="announcement-dot" aria-hidden="true" />
        <span>{t.announcement}</span>
        <span className="announcement-tag">{t.inDevelopment}</span>
      </div>

      <header className="site-header wrap" role="banner">
        <a
          className="brand"
          href="#"
          aria-label="MindBridge home"
          onClick={(e) => {
            if (isPrototypeOpen) {
              e.preventDefault();
              onOpenPrototype();
            }
          }}
        >
          <span className="brand-mark" aria-hidden="true">
            <i />
            <i />
            <i />
          </span>
          <span>
            mindbridge<span className="brand-period">.</span>
          </span>
        </a>

        <div className="header-right">
          <div className="lang-switch" role="group" aria-label="Select language">
            <button
              type="button"
              className={`lang-btn ${language === 'en' ? 'active' : ''}`}
              onClick={() => onLanguageChange('en')}
              aria-pressed={language === 'en'}
            >
              EN
            </button>
            <button
              type="button"
              className={`lang-btn ${language === 'ha' ? 'active' : ''}`}
              onClick={() => onLanguageChange('ha')}
              aria-pressed={language === 'ha'}
            >
              HA
            </button>
          </div>

          <button
            className="menu-toggle"
            aria-label={mobileMenuOpen ? 'Close navigation' : 'Open navigation'}
            aria-expanded={mobileMenuOpen}
            onClick={() => setMobileMenuOpen((prev) => !prev)}
          >
            <span aria-hidden="true" />
            <span aria-hidden="true" />
          </button>

          <nav
            className={`nav-links ${mobileMenuOpen ? 'open' : ''}`}
            aria-label="Main navigation"
          >
            {!isPrototypeOpen ? (
              <>
                <a href="#why" onClick={handleNavLinkClick}>
                  {t.navWhy}
                </a>
                <a href="#inside" onClick={handleNavLinkClick}>
                  {t.navInside}
                </a>
                <a href="#care" onClick={handleNavLinkClick}>
                  {t.navCare}
                </a>
                <a href="#faq" onClick={handleNavLinkClick}>
                  {t.navFaq}
                </a>
              </>
            ) : null}

            <button
              type="button"
              className="nav-cta"
              onClick={() => {
                onOpenPrototype();
                handleNavLinkClick();
              }}
            >
              <span>{isPrototypeOpen ? t.closeWebPrototype : t.openWebPrototype}</span>
              <span aria-hidden="true">↗</span>
            </button>
          </nav>
        </div>
      </header>
    </>
  );
};
