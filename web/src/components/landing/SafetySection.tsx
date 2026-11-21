import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface SafetySectionProps {
  language: Language;
}

export const SafetySection: React.FC<SafetySectionProps> = ({ language }) => {
  const t = translations[language];

  return (
    <section className="safety-section wrap" id="safety" aria-labelledby="safety-heading">
      <div className="safety-mark" aria-hidden="true">✳</div>
      <div className="safety-content">
        <p className="section-index">{t.safetyEyebrow}</p>
        <h2 id="safety-heading">
          Technology can help
          <br />
          you find the way.
          <br />
          <em>People provide care.</em>
        </h2>
        <p>{t.safetyBody}</p>
        <a className="text-link" href="#faq">
          A little more about our approach <span>↗</span>
        </a>
      </div>
      <div className="safety-stamp" aria-hidden="true">
        <span>
          HUMAN
          <br />
          SUPPORT
          <br />
          MATTERS
        </span>
        <b>✳</b>
      </div>
    </section>
  );
};
