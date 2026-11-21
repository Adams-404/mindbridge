import React, { useState } from 'react';
import { FAQ_ITEMS } from '../../data/content';
import { Language } from '../../types';
import { translations } from '../../data/translations';

interface FaqSectionProps {
  language: Language;
}

export const FaqSection: React.FC<FaqSectionProps> = ({ language }) => {
  const t = translations[language];
  const [openItems, setOpenItems] = useState<Record<string, boolean>>({});

  const toggleItem = (id: string) => {
    setOpenItems((prev) => ({
      ...prev,
      [id]: !prev[id],
    }));
  };

  return (
    <section className="faq-section wrap" id="faq" aria-labelledby="faq-heading">
      <div className="faq-heading">
        <p className="section-index">{t.faqEyebrow}</p>
        <h2 id="faq-heading">
          A few things
          <br />
          worth knowing.
        </h2>
      </div>

      <div className="faq-list" role="region" aria-label="Frequently Asked Questions">
        {FAQ_ITEMS.map((item) => {
          const isOpen = !!openItems[item.id];
          return (
            <div key={item.id} className="faq-item">
              <button
                type="button"
                className="faq-question-btn"
                onClick={() => toggleItem(item.id)}
                aria-expanded={isOpen}
                aria-controls={`faq-answer-${item.id}`}
              >
                <span>{item.question}</span>
                <span className={`faq-icon ${isOpen ? 'open' : ''}`} aria-hidden="true">
                  ＋
                </span>
              </button>
              {isOpen && (
                <div
                  id={`faq-answer-${item.id}`}
                  className="faq-answer"
                  role="region"
                >
                  <p>{item.answer}</p>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </section>
  );
};
