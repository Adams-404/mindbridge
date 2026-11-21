import React, { useState, useEffect } from 'react';
import {
  LEARNING_ARTICLES,
  MOOD_OPTIONS,
  SUPPORT_PROMPTS,
  GROUNDING_STEPS,
} from '../../data/content';
import { LearningArticle, Language } from '../../types';
import { translations } from '../../data/translations';

interface WebPrototypeProps {
  initialTab?: string;
  language: Language;
  onLanguageChange: (lang: Language) => void;
  onClose: () => void;
}

export const WebPrototype: React.FC<WebPrototypeProps> = ({
  initialTab = 'home',
  language,
  onLanguageChange,
  onClose,
}) => {
  const [activeTab, setActiveTab] = useState<string>(initialTab);
  const t = translations[language];

  // Learn tab states
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedArticle, setSelectedArticle] = useState<LearningArticle | null>(null);

  // Check-in tab states
  const [selectedMood, setSelectedMood] = useState<string | null>(null);
  const [moodHistory, setMoodHistory] = useState<Array<{ mood: string; time: string }>>([]);

  // Reset tab states
  const [activeExercise, setActiveExercise] = useState<'breathing' | 'grounding' | 'bodyPause'>('breathing');
  const [breathingRunning, setBreathingRunning] = useState(false);
  const [breathingPhase, setBreathingPhase] = useState<'inhale' | 'exhale'>('inhale');
  const [groundingChecked, setGroundingChecked] = useState<Record<string, boolean>>({});

  // Reduced motion
  const [reduceMotion, setReduceMotion] = useState(false);

  useEffect(() => {
    let timer: ReturnType<typeof setInterval> | undefined;
    if (breathingRunning && !reduceMotion) {
      timer = setInterval(() => {
        setBreathingPhase((prev) => (prev === 'inhale' ? 'exhale' : 'inhale'));
      }, 4000);
    }
    return () => {
      if (timer) clearInterval(timer);
    };
  }, [breathingRunning, reduceMotion]);

  const handleMoodSelect = (label: string) => {
    setSelectedMood(label);
    if (label !== 'Skipped') {
      const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      setMoodHistory((prev) => [{ mood: label, time }, ...prev.slice(0, 4)]);
    }
  };

  const filteredArticles = LEARNING_ARTICLES.filter((art) => {
    const q = searchQuery.toLowerCase();
    return (
      art.title.toLowerCase().includes(q) ||
      art.summary.toLowerCase().includes(q) ||
      art.category.toLowerCase().includes(q) ||
      art.sections.some((s) => s.toLowerCase().includes(q))
    );
  });

  return (
    <div className="app-view-container wrap" role="main" aria-label="MindBridge Web Prototype">
      {/* Top Prototype Controls */}
      <div className="app-view-header">
        <div>
          <div className="app-breadcrumbs">
            <span>MINDBRIDGE WEB APP PROTOTYPE</span>
            <span style={{ margin: '0 8px', color: 'var(--clay)' }}>/</span>
            <span style={{ textTransform: 'uppercase' }}>{activeTab}</span>
          </div>
        </div>

        <button
          type="button"
          className="button button-outline"
          onClick={onClose}
          style={{ padding: '8px 14px', fontSize: '11px' }}
        >
          ← {t.closeWebPrototype}
        </button>
      </div>

      {/* App Navigation Tabs */}
      <nav className="app-tabs" role="tablist" aria-label="Web prototype screens">
        <button
          type="button"
          role="tab"
          aria-selected={activeTab === 'home'}
          className={`app-tab-btn ${activeTab === 'home' ? 'active' : ''}`}
          onClick={() => {
            setActiveTab('home');
            setSelectedArticle(null);
          }}
        >
          <span>⌂</span>
          <span>{t.phoneNavHome}</span>
        </button>

        <button
          type="button"
          role="tab"
          aria-selected={activeTab === 'learn'}
          className={`app-tab-btn ${activeTab === 'learn' ? 'active' : ''}`}
          onClick={() => {
            setActiveTab('learn');
            setSelectedArticle(null);
          }}
        >
          <span>▤</span>
          <span>{t.phoneNavLearn}</span>
        </button>

        <button
          type="button"
          role="tab"
          aria-selected={activeTab === 'check-in'}
          className={`app-tab-btn ${activeTab === 'check-in' ? 'active' : ''}`}
          onClick={() => {
            setActiveTab('check-in');
            setSelectedArticle(null);
          }}
        >
          <span>◉</span>
          <span>{t.phoneNavCheckIn}</span>
        </button>

        <button
          type="button"
          role="tab"
          aria-selected={activeTab === 'reset'}
          className={`app-tab-btn ${activeTab === 'reset' ? 'active' : ''}`}
          onClick={() => {
            setActiveTab('reset');
            setSelectedArticle(null);
          }}
        >
          <span>≈</span>
          <span>Reset</span>
        </button>

        <button
          type="button"
          role="tab"
          aria-selected={activeTab === 'support'}
          className={`app-tab-btn ${activeTab === 'support' ? 'active' : ''}`}
          onClick={() => {
            setActiveTab('support');
            setSelectedArticle(null);
          }}
        >
          <span>♡</span>
          <span>{t.phoneNavSupport}</span>
        </button>

        <button
          type="button"
          role="tab"
          aria-selected={activeTab === 'settings'}
          className={`app-tab-btn ${activeTab === 'settings' ? 'active' : ''}`}
          onClick={() => {
            setActiveTab('settings');
            setSelectedArticle(null);
          }}
        >
          <span>⚙</span>
          <span>Settings</span>
        </button>
      </nav>

      <div style={{ marginTop: '24px' }}>
        {/* ==================== HOME TAB ==================== */}
        {activeTab === 'home' && (
          <div>
            <div className="app-page-heading">
              <div className="eyebrow">
                <span className="eyebrow-line" aria-hidden="true" />
                <span>{t.phoneGreetingSubtitle}</span>
              </div>
              <h2>Good to have you here.</h2>
              <p>
                Take things at your own pace. MindBridge provides gentle self-guided tools and
                psychoeducational resources with honest human boundaries.
              </p>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '20px' }}>
              <div className="app-card">
                <div className="card-topline">
                  <span>CHECK IN</span>
                  <span className="card-icon">◉</span>
                </div>
                <h3 style={{ marginTop: '12px', fontSize: '20px' }}>How are things feeling today?</h3>
                <p style={{ color: 'var(--muted)', fontSize: '13px', lineHeight: 1.6 }}>
                  A brief check-in to reflect on your current state. No scores, judgments, or records stored.
                </p>
                <button
                  type="button"
                  className="button button-dark"
                  onClick={() => setActiveTab('check-in')}
                  style={{ marginTop: '14px', padding: '10px 16px', fontSize: '12px' }}
                >
                  Start check-in ↗
                </button>
              </div>

              <div className="app-card">
                <div className="card-topline">
                  <span>RESET & BREATHE</span>
                  <span className="card-icon">≈</span>
                </div>
                <h3 style={{ marginTop: '12px', fontSize: '20px' }}>Take a breathing pause</h3>
                <p style={{ color: 'var(--muted)', fontSize: '13px', lineHeight: 1.6 }}>
                  Slow down with a gentle 4-second inhale and exhale cycle, or grounding exercises.
                </p>
                <button
                  type="button"
                  className="button button-dark"
                  onClick={() => setActiveTab('reset')}
                  style={{ marginTop: '14px', padding: '10px 16px', fontSize: '12px' }}
                >
                  Begin exercise ↗
                </button>
              </div>

              <div className="app-card">
                <div className="card-topline">
                  <span>LEARN</span>
                  <span className="card-icon">▤</span>
                </div>
                <h3 style={{ marginTop: '12px', fontSize: '20px' }}>Understanding your emotions</h3>
                <p style={{ color: 'var(--muted)', fontSize: '13px', lineHeight: 1.6 }}>
                  Read clear, accessible guides about anxiety, depression, and when to seek care.
                </p>
                <button
                  type="button"
                  className="button button-dark"
                  onClick={() => setActiveTab('learn')}
                  style={{ marginTop: '14px', padding: '10px 16px', fontSize: '12px' }}
                >
                  Browse library ↗
                </button>
              </div>
            </div>

            <div
              style={{
                marginTop: '25px',
                background: '#f0e3d9',
                border: '1px solid #e0c9ba',
                borderRadius: '10px',
                padding: '16px 20px',
                display: 'flex',
                gap: '12px',
                alignItems: 'flex-start',
              }}
            >
              <span style={{ fontSize: '20px', color: 'var(--clay)' }}>✳</span>
              <div style={{ fontSize: '12px', color: 'var(--ink)', lineHeight: 1.6 }}>
                <b>Safety & Boundary Reminder:</b> MindBridge is not an emergency service and does
                not replace clinical care or provide medical diagnoses. If you are experiencing an
                acute crisis, please reach out to trusted local emergency services.
              </div>
            </div>
          </div>
        )}

        {/* ==================== LEARN TAB ==================== */}
        {activeTab === 'learn' && (
          <div>
            {!selectedArticle ? (
              <>
                <div className="app-page-heading">
                  <div className="eyebrow">
                    <span className="eyebrow-line" aria-hidden="true" />
                    <span>PSYCHOEDUCATIONAL LIBRARY</span>
                  </div>
                  <h2>Understanding what you're experiencing.</h2>
                  <p>
                    Clear, calm information designed to be understood. Each article documents its
                    review status and version.
                  </p>
                </div>

                <div style={{ marginBottom: '24px' }}>
                  <input
                    type="search"
                    placeholder="Search articles by topic, keyword, or symptom..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    style={{
                      width: '100%',
                      maxWidth: '500px',
                      padding: '12px 16px',
                      borderRadius: '8px',
                      border: '1px solid var(--line)',
                      background: 'var(--paper)',
                      fontFamily: 'inherit',
                      fontSize: '14px',
                    }}
                    aria-label="Search articles"
                  />
                </div>

                <div className="articles-grid">
                  {filteredArticles.map((article) => (
                    <article
                      key={article.id}
                      className="article-card"
                      onClick={() => setSelectedArticle(article)}
                      role="button"
                      tabIndex={0}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter' || e.key === ' ') setSelectedArticle(article);
                      }}
                      aria-label={`Read article: ${article.title}`}
                    >
                      <span className="article-badge">{article.category}</span>
                      <h3 className="article-title">{article.title}</h3>
                      <p className="article-summary">{article.summary}</p>
                      <div className="article-status-tag">{article.reviewStatus}</div>
                    </article>
                  ))}
                </div>
              </>
            ) : (
              /* Article Reader View */
              <div className="article-reader">
                <button
                  type="button"
                  className="button button-outline"
                  onClick={() => setSelectedArticle(null)}
                  style={{ marginBottom: '20px', padding: '6px 12px', fontSize: '12px' }}
                >
                  ← Back to library
                </button>

                <div className="eyebrow">
                  <span className="eyebrow-line" aria-hidden="true" />
                  <span>{selectedArticle.category.toUpperCase()}</span>
                </div>

                <h1 style={{ fontSize: 'clamp(28px, 4vw, 40px)', marginBottom: '16px' }}>
                  {selectedArticle.title}
                </h1>

                <div className="article-reader-meta">
                  <div>
                    <b>Version:</b> {selectedArticle.contentVersion}
                  </div>
                  <div>
                    <b>Review status:</b> {selectedArticle.reviewStatus}
                  </div>
                </div>

                {selectedArticle.sections.map((paragraph, idx) => (
                  <p key={idx}>{paragraph}</p>
                ))}

                <div
                  style={{
                    marginTop: '30px',
                    paddingTop: '20px',
                    borderTop: '1px solid var(--line)',
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    flexWrap: 'wrap',
                    gap: '12px',
                  }}
                >
                  <button
                    type="button"
                    className="button button-outline"
                    onClick={() => setSelectedArticle(null)}
                  >
                    Back to all articles
                  </button>
                  <button
                    type="button"
                    className="button button-dark"
                    onClick={() => setActiveTab('support')}
                  >
                    Finding support options ↗
                  </button>
                </div>
              </div>
            )}
          </div>
        )}

        {/* ==================== CHECK-IN TAB ==================== */}
        {activeTab === 'check-in' && (
          <div style={{ maxWidth: '640px', marginInline: 'auto' }}>
            <div className="app-page-heading">
              <div className="eyebrow">
                <span className="eyebrow-line" aria-hidden="true" />
                <span>A MOMENT FOR YOU</span>
              </div>
              <h2>How are you feeling today?</h2>
              <p>
                There is no right answer. Choose what feels closest, or leave this for another
                time. Your response is kept in temporary memory only.
              </p>
            </div>

            {selectedMood === null ? (
              <div>
                <div style={{ display: 'grid', gap: '10px', marginBottom: '20px' }}>
                  {MOOD_OPTIONS.map((mood) => (
                    <button
                      key={mood.id}
                      type="button"
                      onClick={() => handleMoodSelect(mood.label)}
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: '16px',
                        padding: '16px 20px',
                        background: 'var(--paper)',
                        border: '1px solid var(--line)',
                        borderRadius: '10px',
                        textAlign: 'left',
                        cursor: 'pointer',
                        transition: 'border-color 0.15s ease',
                      }}
                    >
                      <span style={{ fontSize: '26px', color: 'var(--clay)' }}>
                        {mood.symbol}
                      </span>
                      <div style={{ flexGrow: 1 }}>
                        <div style={{ fontWeight: 700, fontSize: '15px', color: 'var(--ink)' }}>
                          {mood.label}
                        </div>
                        <div style={{ fontSize: '12px', color: 'var(--muted)' }}>
                          {mood.description}
                        </div>
                      </div>
                      <span style={{ color: 'var(--clay)', fontSize: '18px' }}>→</span>
                    </button>
                  ))}
                </div>

                <div style={{ textAlign: 'center' }}>
                  <button
                    type="button"
                    className="text-link"
                    onClick={() => handleMoodSelect('Skipped')}
                  >
                    Skip this check-in <span>→</span>
                  </button>
                </div>
              </div>
            ) : (
              <div
                style={{
                  background: '#e8ede5',
                  borderRadius: '12px',
                  border: '1px solid #c9d4c7',
                  padding: '30px',
                }}
              >
                <div style={{ fontSize: '28px', color: 'var(--forest)', marginBottom: '14px' }}>
                  ✳
                </div>
                <h3 style={{ fontSize: '22px', marginBottom: '10px' }}>
                  {selectedMood === 'Skipped' ? 'That’s completely okay.' : 'Thank you for pausing.'}
                </h3>
                <p style={{ color: 'var(--ink)', fontSize: '14px', lineHeight: 1.7, marginBottom: '20px' }}>
                  {selectedMood === 'Skipped'
                    ? 'You do not have to check in to use MindBridge. Check-ins are always optional.'
                    : `You selected: ${selectedMood}. This reflection is not a clinical assessment, diagnostic tool, or permanent record.`}
                </p>

                <div style={{ display: 'flex', gap: '14px', flexWrap: 'wrap' }}>
                  <button
                    type="button"
                    className="button button-outline"
                    onClick={() => setSelectedMood(null)}
                  >
                    Choose again
                  </button>
                  <button
                    type="button"
                    className="button button-dark"
                    onClick={() => setActiveTab('reset')}
                  >
                    Take a breathing pause ↗
                  </button>
                </div>
              </div>
            )}

            {moodHistory.length > 0 && (
              <div style={{ marginTop: '30px' }}>
                <h4 style={{ fontSize: '13px', color: 'var(--muted)', letterSpacing: '0.05em' }}>
                  RECENT IN-SESSION REFLECTIONS (SESSION ONLY)
                </h4>
                <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginTop: '8px' }}>
                  {moodHistory.map((h, i) => (
                    <span
                      key={i}
                      style={{
                        background: 'var(--paper)',
                        border: '1px solid var(--line)',
                        padding: '4px 10px',
                        borderRadius: '6px',
                        fontSize: '11px',
                        fontFamily: 'var(--mono)',
                      }}
                    >
                      {h.mood} ({h.time})
                    </span>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* ==================== RESET TAB ==================== */}
        {activeTab === 'reset' && (
          <div style={{ maxWidth: '640px', marginInline: 'auto' }}>
            <div className="app-page-heading">
              <div className="eyebrow">
                <span className="eyebrow-line" aria-hidden="true" />
                <span>MOMENTS OF STILLNESS</span>
              </div>
              <h2>Find a slower rhythm.</h2>
              <p>
                Self-guided calming exercises. You can pause, stop, or switch exercises at any time.
              </p>
            </div>

            {/* Exercise selector */}
            <div
              style={{
                display: 'flex',
                gap: '8px',
                marginBottom: '28px',
                borderBottom: '1px solid var(--line)',
                paddingBottom: '12px',
              }}
            >
              <button
                type="button"
                className={`button ${activeExercise === 'breathing' ? 'button-dark' : 'button-outline'}`}
                style={{ padding: '8px 14px', fontSize: '12px' }}
                onClick={() => {
                  setActiveExercise('breathing');
                  setBreathingRunning(false);
                }}
              >
                Breathing Pause
              </button>
              <button
                type="button"
                className={`button ${activeExercise === 'grounding' ? 'button-dark' : 'button-outline'}`}
                style={{ padding: '8px 14px', fontSize: '12px' }}
                onClick={() => {
                  setActiveExercise('grounding');
                  setBreathingRunning(false);
                }}
              >
                5-4-3-2-1 Grounding
              </button>
              <button
                type="button"
                className={`button ${activeExercise === 'bodyPause' ? 'button-dark' : 'button-outline'}`}
                style={{ padding: '8px 14px', fontSize: '12px' }}
                onClick={() => {
                  setActiveExercise('bodyPause');
                  setBreathingRunning(false);
                }}
              >
                Body Pause
              </button>
            </div>

            {activeExercise === 'breathing' && (
              <div className="app-card breathing-box">
                <div className="breathing-circle-container">
                  <div className="breathing-outer-ring" />
                  <div
                    className={`breathing-circle ${
                      breathingRunning ? (breathingPhase === 'inhale' ? 'inhale' : 'exhale') : ''
                    }`}
                  >
                    <span>
                      {breathingRunning
                        ? breathingPhase === 'inhale'
                          ? 'Inhale...'
                          : 'Exhale...'
                        : 'Breathe'}
                    </span>
                  </div>
                </div>

                <p style={{ color: 'var(--muted)', fontSize: '13px', marginBottom: '20px' }}>
                  {breathingRunning
                    ? breathingPhase === 'inhale'
                      ? 'Inhale slowly through your nose, expanding your breath.'
                      : 'Exhale gently through your mouth, letting tension release.'
                    : 'Press Start when you are ready to begin a gentle 4-second paced breath.'}
                </p>

                <div className="breathing-controls">
                  {!breathingRunning ? (
                    <button
                      type="button"
                      className="button button-dark"
                      onClick={() => {
                        setBreathingRunning(true);
                        setBreathingPhase('inhale');
                      }}
                    >
                      Start breathing
                    </button>
                  ) : (
                    <>
                      <button
                        type="button"
                        className="button button-outline"
                        onClick={() => setBreathingRunning(false)}
                      >
                        Pause
                      </button>
                      <button
                        type="button"
                        className="button button-outline"
                        onClick={() => {
                          setBreathingRunning(false);
                          setBreathingPhase('inhale');
                        }}
                      >
                        Stop
                      </button>
                    </>
                  )}
                </div>

                <div style={{ marginTop: '20px', fontSize: '11px', color: 'var(--muted)' }}>
                  <label style={{ display: 'inline-flex', alignItems: 'center', gap: '8px', cursor: 'pointer' }}>
                    <input
                      type="checkbox"
                      checked={reduceMotion}
                      onChange={(e) => setReduceMotion(e.target.checked)}
                    />
                    Reduce animation motion
                  </label>
                </div>
              </div>
            )}

            {activeExercise === 'grounding' && (
              <div className="app-card">
                <h3 style={{ fontSize: '18px', marginBottom: '12px' }}>5-4-3-2-1 Sensory Grounding</h3>
                <p style={{ color: 'var(--muted)', fontSize: '13px', lineHeight: 1.6, marginBottom: '20px' }}>
                  Anchor yourself to this present moment. Notice your surroundings step by step:
                </p>

                <div style={{ display: 'grid', gap: '12px' }}>
                  {GROUNDING_STEPS.map((step) => {
                    const isDone = !!groundingChecked[step.count];
                    return (
                      <label
                        key={step.count}
                        style={{
                          display: 'flex',
                          alignItems: 'center',
                          gap: '14px',
                          padding: '12px 16px',
                          background: isDone ? '#eef4ec' : 'var(--milk)',
                          borderRadius: '8px',
                          cursor: 'pointer',
                          border: '1px solid var(--line)',
                          transition: 'all 0.15s ease',
                        }}
                      >
                        <input
                          type="checkbox"
                          checked={isDone}
                          onChange={(e) =>
                            setGroundingChecked((prev) => ({
                              ...prev,
                              [step.count]: e.target.checked,
                            }))
                          }
                        />
                        <span style={{ font: '700 16px var(--mono)', color: 'var(--clay)' }}>
                          {step.count}
                        </span>
                        <span style={{ fontSize: '14px', textDecoration: isDone ? 'line-through' : 'none' }}>
                          {step.label}
                        </span>
                      </label>
                    );
                  })}
                </div>
              </div>
            )}

            {activeExercise === 'bodyPause' && (
              <div className="app-card">
                <h3 style={{ fontSize: '18px', marginBottom: '12px' }}>Gentle Body Pause</h3>
                <p style={{ color: 'var(--muted)', fontSize: '13px', lineHeight: 1.6, marginBottom: '20px' }}>
                  A moment to gently release tension in the shoulders, jaw, and hands:
                </p>

                <div style={{ display: 'grid', gap: '14px', fontSize: '14px', lineHeight: 1.7 }}>
                  <div style={{ padding: '12px', background: 'var(--milk)', borderRadius: '8px' }}>
                    <b>1. Drop your shoulders:</b> Allow your shoulders to sink away from your ears.
                  </div>
                  <div style={{ padding: '12px', background: 'var(--milk)', borderRadius: '8px' }}>
                    <b>2. Soften your jaw:</b> Unclench your teeth and allow your tongue to rest naturally.
                  </div>
                  <div style={{ padding: '12px', background: 'var(--milk)', borderRadius: '8px' }}>
                    <b>3. Open your hands:</b> Uncurl your fingers and let your palms rest open.
                  </div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* ==================== SUPPORT TAB ==================== */}
        {activeTab === 'support' && (
          <div style={{ maxWidth: '640px', marginInline: 'auto' }}>
            <div className="app-page-heading">
              <div className="eyebrow">
                <span className="eyebrow-line" aria-hidden="true" />
                <span>NAVIGATING CARE</span>
              </div>
              <h2>Finding the right support.</h2>
              <p>
                Learning about your options can be a useful first step. A qualified health
                professional can help you understand what support may be appropriate.
              </p>
            </div>

            <div
              style={{
                padding: '24px',
                background: '#e8ede5',
                border: '1px solid #c9d4c7',
                borderRadius: '12px',
                marginBottom: '24px',
              }}
            >
              <div style={{ fontSize: '24px', color: 'var(--forest)', marginBottom: '8px' }}>
                👥
              </div>
              <h3 style={{ fontSize: '20px', marginBottom: '8px' }}>
                Verified Support Directory
              </h3>
              <p style={{ fontSize: '13px', color: 'var(--ink)', lineHeight: 1.6, marginBottom: '14px' }}>
                We are building a careful process to verify health professionals and referral
                services before listing them. To protect user safety, no unverified directory entries
                are fabricated.
              </p>
              <span
                style={{
                  display: 'inline-block',
                  background: '#dde5d9',
                  padding: '6px 12px',
                  borderRadius: '16px',
                  fontSize: '11px',
                  fontFamily: 'var(--mono)',
                }}
              >
                Directory in verification · Not yet available
              </span>
            </div>

            <div className="app-card">
              <h3 style={{ fontSize: '18px', marginBottom: '12px' }}>
                What you can ask a healthcare provider
              </h3>
              <div style={{ display: 'grid', gap: '10px' }}>
                {SUPPORT_PROMPTS.map((prompt) => (
                  <div
                    key={prompt.id}
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: '12px',
                      padding: '12px 14px',
                      background: 'var(--milk)',
                      borderRadius: '8px',
                      fontSize: '13px',
                    }}
                  >
                    <span style={{ color: 'var(--forest)' }}>✓</span>
                    <span>{prompt.text}</span>
                  </div>
                ))}
              </div>
            </div>

            <div
              style={{
                marginTop: '20px',
                fontSize: '11px',
                color: 'var(--muted)',
                lineHeight: 1.6,
                padding: '14px',
                borderLeft: '2px solid var(--clay)',
              }}
            >
              <b>Important:</b> If you or someone else may be in immediate danger or distress, seek
              urgent in-person help from local emergency services or a trusted person. MindBridge is
              not monitored and cannot dispatch assistance.
            </div>
          </div>
        )}

        {/* ==================== SETTINGS TAB ==================== */}
        {activeTab === 'settings' && (
          <div style={{ maxWidth: '640px', marginInline: 'auto' }}>
            <div className="app-page-heading">
              <div className="eyebrow">
                <span className="eyebrow-line" aria-hidden="true" />
                <span>PREFERENCES & PRIVACY</span>
              </div>
              <h2>Settings & Accessibility.</h2>
              <p>Configure language preferences, view accessibility settings, and review privacy boundaries.</p>
            </div>

            <div className="app-card">
              <h3 style={{ fontSize: '18px', marginBottom: '12px' }}>Language / Harshe</h3>
              <p style={{ color: 'var(--muted)', fontSize: '13px', marginBottom: '16px' }}>
                MindBridge is designed for bilingual English and Hausa support.
              </p>
              <div style={{ display: 'flex', gap: '12px' }}>
                <button
                  type="button"
                  className={`button ${language === 'en' ? 'button-dark' : 'button-outline'}`}
                  onClick={() => onLanguageChange('en')}
                >
                  English
                </button>
                <button
                  type="button"
                  className={`button ${language === 'ha' ? 'button-dark' : 'button-outline'}`}
                  onClick={() => onLanguageChange('ha')}
                >
                  Hausa (Harshen Hausa)
                </button>
              </div>
            </div>

            <div className="app-card">
              <h3 style={{ fontSize: '18px', marginBottom: '12px' }}>Accessibility</h3>
              <label style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer', fontSize: '14px' }}>
                <input
                  type="checkbox"
                  checked={reduceMotion}
                  onChange={(e) => setReduceMotion(e.target.checked)}
                />
                <span>Prefers reduced motion (disables smooth animations)</span>
              </label>
            </div>

            <div className="app-card">
              <h3 style={{ fontSize: '18px', marginBottom: '12px' }}>Privacy & Data Minimisation</h3>
              <p style={{ color: 'var(--muted)', fontSize: '13px', lineHeight: 1.6 }}>
                MindBridge operates on a privacy-by-default baseline:
              </p>
              <ul style={{ color: 'var(--ink)', fontSize: '13px', lineHeight: 1.8, paddingLeft: '20px' }}>
                <li>No account registration required for educational access.</li>
                <li>Check-ins and exercises are held in browser memory only.</li>
                <li>No diagnostic labels, medical histories, or health profiles created.</li>
              </ul>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
