import React from 'react';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface DownloadSectionProps {
  language: Language;
}

export const DownloadSection: React.FC<DownloadSectionProps> = ({ language }) => {
  const t = translations[language];

  return (
    <section className="download-section" id="download" aria-labelledby="download-heading">
      <div className="wrap download-inner">
        <div>
          <p className="section-index">{t.downloadEyebrow}</p>
          <h2 id="download-heading">{t.downloadHeading}</h2>
          <p>{t.downloadBody}</p>
        </div>

        <div className="download-action">
          <span className="coming-soon">
            <i aria-hidden="true" />
            <span>{t.downloadBadge}</span>
          </span>
          <a
            className="button button-light"
            href="https://github.com/Adams-404/mindbridge"
            target="_blank"
            rel="noopener noreferrer"
          >
            <span>{t.downloadFollow}</span>
            <span aria-hidden="true">↗</span>
          </a>
          <small>We'll share official app links here when they're ready.</small>
        </div>

        <span className="download-flower" aria-hidden="true">
          ✳
        </span>
      </div>
    </section>
  );
};
