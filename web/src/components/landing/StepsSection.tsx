import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface StepsSectionProps {
  language: Language;
}

export const StepsSection: React.FC<StepsSectionProps> = ({ language }) => {
  const t = translations[language];

  return (
    <section className="steps-section" aria-labelledby="steps-heading">
      <div className="wrap">
        <div className="section-heading">
          <div>
            <p className="section-index">{t.stepsEyebrow}</p>
            <h2 id="steps-heading">{t.stepsHeading}</h2>
          </div>
          <p className="section-summary">
            You don't need to have everything figured out to begin exploring.
          </p>
        </div>

        <div className="steps-grid">
          <div className="step">
            <span>01</span>
            <h3>Find what you need.</h3>
            <p>Choose a topic, browse an article, or simply explore.</p>
          </div>
          <div className="step">
            <span>02</span>
            <h3>Take a moment.</h3>
            <p>Try an optional check-in or a short breathing pause.</p>
          </div>
          <div className="step">
            <span>03</span>
            <h3>Know where to turn.</h3>
            <p>Understand your support options and the role of qualified care.</p>
          </div>
        </div>
      </div>
    </section>
  );
};
