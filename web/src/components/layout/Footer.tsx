import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface FooterProps {
  language: Language;
  onOpenPrototype: () => void;
}

export const Footer: React.FC<FooterProps> = ({ language, onOpenPrototype }) => {
  const t = translations[language];

  return (
    <footer className="site-footer wrap" role="contentinfo">
      <a className="brand" href="#" aria-label="MindBridge home">
        <span className="brand-mark" aria-hidden="true">
          <i />
          <i />
          <i />
        </span>
        <span>
          mindbridge<span className="brand-period">.</span>
        </span>
      </a>

      <p>{t.footerTagline}</p>

      <div className="footer-links">
        <a href="#care">{t.navCare}</a>
        <a href="#faq">{t.navFaq}</a>
        <button
          type="button"
          onClick={onOpenPrototype}
          style={{ background: 'none', border: 'none', padding: 0, font: 'inherit', cursor: 'pointer' }}
        >
          {t.openWebPrototype}
        </button>
        <a
          href="https://github.com/Adams-404/mindbridge"
          target="_blank"
          rel="noopener noreferrer"
        >
          GitHub ↗
        </a>
      </div>

      <div className="footer-bottom">
        <span>{t.footerRights}</span>
        <span>{t.footerDisclaimer}</span>
      </div>
    </footer>
  );
};
