import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface LanguageSectionProps {
  language: Language;
}

export const LanguageSection: React.FC<LanguageSectionProps> = ({ language }) => {
  const t = translations[language];

  return (
    <section className="language-section" id="care" aria-labelledby="language-heading">
      <div className="wrap language-grid">
        <div>
          <p className="section-index">{t.careEyebrow}</p>
          <h2 id="language-heading">
            Your language.
            <br />
            Your pace. <em>Your space.</em>
          </h2>
          <p>{t.careBody}</p>

          <div className="language-pills" role="list">
            <span role="listitem">English</span>
            <span role="listitem">Hausa · Hausa</span>
            <span role="listitem">Low-bandwidth minded</span>
          </div>
        </div>

        <div className="language-art" aria-hidden="true">
          <div className="language-card">
            <span className="language-label">SAME CARE, TWO LANGUAGES</span>
            <div className="language-word">
              Sannu<span>.</span>
            </div>
            <div className="language-divider" />
            <div className="language-word language-word-small">
              Hello<span>.</span>
            </div>
            <p>Start with the language that feels like yours.</p>
            <span className="language-flower">✳</span>
          </div>
          <span className="language-side-note">
            ACCESS SHOULD
            <br />
            FEEL NATURAL.
          </span>
        </div>
      </div>
    </section>
  );
};
