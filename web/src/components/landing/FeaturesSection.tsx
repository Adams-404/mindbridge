import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface FeaturesSectionProps {
  language: Language;
  onOpenPrototype: (tab?: string) => void;
}

export const FeaturesSection: React.FC<FeaturesSectionProps> = ({
  language,
  onOpenPrototype,
}) => {
  const t = translations[language];

  return (
    <section className="features-section wrap" id="inside" aria-labelledby="features-heading">
      <div className="section-heading">
        <div>
          <p className="section-index">{t.insideEyebrow}</p>
          <h2 id="features-heading">{t.insideHeading}</h2>
        </div>
        <p className="section-summary">{t.insideSummary}</p>
      </div>

      <div className="feature-grid">
        {/* Card 1: Learn */}
        <article
          className="feature-card feature-large"
          tabIndex={0}
          role="button"
          onClick={() => onOpenPrototype('learn')}
          onKeyDown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') onOpenPrototype('learn');
          }}
          aria-label="Learn feature: Make sense of what you're feeling"
        >
          <div className="card-topline">
            <span>01 / LEARN</span>
            <span className="card-icon" aria-hidden="true">↗</span>
          </div>
          <div className="feature-illustration learn-illustration" aria-hidden="true">
            <span className="paper paper-one">
              understanding
              <br />
              <b>anxiety</b>
            </span>
            <span className="paper paper-two">
              a note to
              <br />
              come back to
            </span>
            <span className="paper-sun">✳</span>
          </div>
          <h3>
            Make sense of
            <br />
            what you're feeling.
          </h3>
          <p>
            Explore clear, reviewed information about depression, anxiety, stress, and emotional
            wellbeing. Written to be understood, not decoded.
          </p>
        </article>

        {/* Card 2: Check in */}
        <article
          className="feature-card feature-check"
          tabIndex={0}
          role="button"
          onClick={() => onOpenPrototype('check-in')}
          onKeyDown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') onOpenPrototype('check-in');
          }}
          aria-label="Check in feature: A moment to check in"
        >
          <div className="card-topline">
            <span>02 / CHECK IN</span>
            <span className="card-icon" aria-hidden="true">↗</span>
          </div>
          <div className="check-illustration" aria-hidden="true">
            <div className="check-orbit orbit-one" />
            <div className="check-orbit orbit-two" />
            <div className="check-core">
              how are
              <br />
              <i>you?</i>
            </div>
            <span className="check-dot dot-one" />
            <span className="check-dot dot-two" />
            <span className="check-dot dot-three" />
          </div>
          <h3>
            A moment to
            <br />
            check in.
          </h3>
          <p>
            Pause and notice how you're doing. Always optional, always yours. No scores or
            labels.
          </p>
        </article>

        {/* Card 3: Reset */}
        <article
          className="feature-card feature-reset"
          tabIndex={0}
          role="button"
          onClick={() => onOpenPrototype('reset')}
          onKeyDown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') onOpenPrototype('reset');
          }}
          aria-label="Reset feature: Find a slower rhythm"
        >
          <div className="card-topline">
            <span>03 / RESET</span>
            <span className="card-icon" aria-hidden="true">↗</span>
          </div>
          <div className="reset-illustration" aria-hidden="true">
            <div className="reset-ring">
              <span>
                inhale
                <br />
                <b>slowly</b>
              </span>
            </div>
            <span className="reset-caption">A MOMENT OF STILLNESS</span>
          </div>
          <h3>
            Find a slower
            <br />
            rhythm.
          </h3>
          <p>
            Try simple guided breathing and relaxation exercises, with the freedom to pause or stop
            whenever you like.
          </p>
        </article>

        {/* Card 4: Find support */}
        <article
          className="feature-card feature-support"
          tabIndex={0}
          role="button"
          onClick={() => onOpenPrototype('support')}
          onKeyDown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') onOpenPrototype('support');
          }}
          aria-label="Find support feature: There's a person behind the support"
        >
          <div className="card-topline">
            <span>04 / FIND SUPPORT</span>
            <span className="card-icon" aria-hidden="true">↗</span>
          </div>
          <div className="support-illustration" aria-hidden="true">
            <span className="support-line" />
            <span className="support-node node-a">YOU</span>
            <span className="support-node node-b">CARE</span>
            <span className="support-node node-c">PEOPLE</span>
            <span className="support-heart">♡</span>
          </div>
          <h3>
            There's a person
            <br />
            behind the support.
          </h3>
          <p>
            Understand your options and find your way towards qualified professionals and
            appropriate services.
          </p>
        </article>
      </div>
    </section>
  );
};
