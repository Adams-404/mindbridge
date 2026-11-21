import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface WhySectionProps {
  language: Language;
}

export const WhySection: React.FC<WhySectionProps> = ({ language }) => {
  const t = translations[language];

  return (
    <section className="intro-section" id="why" aria-labelledby="why-heading">
      <div className="wrap intro-grid">
        <p className="section-index">{t.whyEyebrow}</p>
        <div>
          <h2 id="why-heading">{t.whyHeading}</h2>
          <p className="intro-body">{t.whyBody}</p>
        </div>
        <div className="intro-aside">
          <span className="aside-star" aria-hidden="true">✳</span>
          <p>{t.whyAside}</p>
        </div>
      </div>
    </section>
  );
};
