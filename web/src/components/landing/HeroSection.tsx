import React, { useState } from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface HeroSectionProps {
  language: Language;
  onOpenPrototype: (initialTab?: string) => void;
}

export const HeroSection: React.FC<HeroSectionProps> = ({
  language,
  onOpenPrototype,
}) => {
  const t = translations[language];
  const [selectedMood, setSelectedMood] = useState<number | null>(0);

  const moods = [
    { icon: '☀', label: 'Bright' },
    { icon: '◒', label: 'Calm' },
    { icon: '⌁', label: 'Worried' },
    { icon: '○', label: 'Sad' },
  ];

  return (
    <section className="hero wrap" aria-labelledby="hero-heading">
      <div className="hero-copy">
        <div className="eyebrow">
          <span className="eyebrow-line" aria-hidden="true" />
          <span>{t.heroEyebrow}</span>
        </div>

        <h1 id="hero-heading">
          {t.heroTitle1}
          <br />
          <em>{t.heroTitleEm}</em>
        </h1>

        <p className="hero-lede">{t.heroLede}</p>

        <div className="hero-actions">
          <a
            className="button button-dark"
            href="#download"
          >
            <span>{t.heroCtaPrimary}</span>
            <span aria-hidden="true">↗</span>
          </a>
          <button
            type="button"
            className="button button-outline"
            onClick={() => onOpenPrototype('home')}
          >
            <span>{t.openWebPrototype}</span>
            <span aria-hidden="true">↗</span>
          </button>
          <a className="text-link" href="#inside">
            {t.heroCtaSecondary} <span>↓</span>
          </a>
        </div>

        <div className="hero-footnote">
          <span className="tiny-spark" aria-hidden="true">✳</span>
          <span>{t.heroFootnote}</span>
        </div>
      </div>

      <div className="hero-art" aria-label="Interactive illustration of MindBridge mobile interface">
        <div className="art-note note-top">
          <span className="note-icon" aria-hidden="true">✳</span>
          <span>
            Small steps.
            <br />
            <b>At your pace.</b>
          </span>
        </div>

        <div className="phone" role="region" aria-label="MindBridge mobile app interactive preview">
          <div className="phone-top">
            <span>9:41</span>
            <span className="phone-signal" aria-hidden="true">● ● ▰</span>
          </div>

          <div className="phone-content">
            <div className="app-greeting">
              <div>
                <small>{t.phoneGreetingSubtitle}</small>
                <h3>{t.phoneGreetingTitle}</h3>
              </div>
              <span className="avatar-mark" aria-hidden="true">m.</span>
            </div>

            <div className="phone-feature">
              <div className="feature-kicker">{t.phoneGreetingSubtitle}</div>
              <h4>{t.phoneQuestionTitle}</h4>
              <p>{t.phoneQuestionSubtitle}</p>

              <div className="mood-row" role="radiogroup" aria-label="Select mood">
                {moods.map((mood, idx) => (
                  <button
                    key={mood.label}
                    type="button"
                    className={`mood-btn ${selectedMood === idx ? 'selected' : ''}`}
                    onClick={() => setSelectedMood(idx)}
                    aria-label={mood.label}
                    aria-pressed={selectedMood === idx}
                  >
                    {mood.icon}
                  </button>
                ))}
              </div>

              <button
                type="button"
                className="phone-action"
                onClick={() => onOpenPrototype('check-in')}
              >
                <span>{t.phoneCheckInAction}</span>
                <b>↗</b>
              </button>
            </div>

            <div className="phone-section-head">
              <b>{t.phoneResourcesTitle}</b>
              <span
                role="button"
                tabIndex={0}
                onClick={() => onOpenPrototype('learn')}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' || e.key === ' ') {
                    onOpenPrototype('learn');
                  }
                }}
              >
                See all
              </span>
            </div>

            <div
              className="phone-resource"
              role="button"
              tabIndex={0}
              onClick={() => onOpenPrototype('learn')}
              onKeyDown={(e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                  onOpenPrototype('learn');
                }
              }}
            >
              <span className="resource-symbol" aria-hidden="true">↗</span>
              <span>
                <b>{t.phoneUnderstandingAnxiety}</b>
                <small>A little clarity can help.</small>
              </span>
              <span className="resource-arrow" aria-hidden="true">→</span>
            </div>

            <div
              className="phone-resource"
              role="button"
              tabIndex={0}
              onClick={() => onOpenPrototype('reset')}
              onKeyDown={(e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                  onOpenPrototype('reset');
                }
              }}
            >
              <span className="resource-symbol resource-clay" aria-hidden="true">≈</span>
              <span>
                <b>{t.phoneBreathingPause}</b>
                <small>A few quiet moments.</small>
              </span>
              <span className="resource-arrow" aria-hidden="true">→</span>
            </div>
          </div>

          <div className="phone-nav" role="navigation" aria-label="Phone preview navigation">
            <button type="button" onClick={() => onOpenPrototype('home')} aria-label={t.phoneNavHome}>
              <span>⌂</span>
              <small>{t.phoneNavHome}</small>
            </button>
            <button type="button" onClick={() => onOpenPrototype('learn')} aria-label={t.phoneNavLearn}>
              <span>▤</span>
              <small>{t.phoneNavLearn}</small>
            </button>
            <button type="button" onClick={() => onOpenPrototype('check-in')} aria-label={t.phoneNavCheckIn}>
              <span>◉</span>
              <small>{t.phoneNavCheckIn}</small>
            </button>
            <button type="button" onClick={() => onOpenPrototype('support')} aria-label={t.phoneNavSupport}>
              <span>♡</span>
              <small>{t.phoneNavSupport}</small>
            </button>
          </div>
        </div>

        <div className="art-note note-bottom">
          <span className="note-leaf" aria-hidden="true">↗</span>
          <span>
            Information first.
            <br />
            <b>People always.</b>
          </span>
        </div>

        <span className="art-stamp" aria-hidden="true">
          A MORE
          <br />
          HUMAN
          <br />
          APPROACH.
        </span>
      </div>

      <div className="hero-bottom-rule" aria-hidden="true">
        <span>01 / A DIFFERENT KIND OF SPACE</span>
        <span>
          DESIGNED FOR REAL LIFE <b>↓</b>
        </span>
      </div>
    </section>
  );
};
