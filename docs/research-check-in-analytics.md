# Research: Ecological Momentary Assessment (EMA) & Mood Analytics

## 1. The Clinical Purpose of Mood Check-Ins
Retrospective recall bias is a well-documented cognitive distortion in clinical psychology: when individuals evaluate their emotional state across days or weeks, their memory is disproportionately biased by their most recent or most intense emotion (peak-end rule).

**Ecological Momentary Assessment (EMA)** addresses this by capturing mood, somatic symptoms, and context in real-time within the user's natural environment.

### Why Multiple Check-Ins per Day Matter:
1. **Intra-Day Fluctuation Tracking**: Emotional states are dynamic. Capturing mood in the morning, afternoon, or evening reveals situational patterns (e.g., cortisol spikes during morning work vs. evening decompression).
2. **Emotional Granularity**: Pioneered by psychological research (e.g., Dr. Lisa Feldman Barrett), naming specific feelings (distinguishing *anxious* from *overwhelmed* or *sad* from *fatigued*) engages the prefrontal cortex, down-regulating amygdala reactivity.
3. **Actionable Pattern Recognition**: By correlating mood with lifestyle factors (Sleep, Work, Relationships, Exercise, Nutrition), users discover what nourishes or drains their mental bandwidth.

---

## 2. Key Architectural Requirements for MindBridge

### A. Frictionless Data Entry Flow
- **Primary Emotion**:
  - `Bright` (Rating: 5 · Joyful, hopeful, energetic)
  - `Calm` (Rating: 4 · Steady, grounded, peaceful)
  - `Worried` (Rating: 3 · Active thoughts, unsettled)
  - `Sad` (Rating: 2 · Low energy, heavy)
  - `Anxious` (Rating: 2 · Tense, nervous, hyper-vigilant)
  - `Overwhelmed` (Rating: 1 · Depleted, too much to hold)
- **Contextual Factors (Multi-select chips)**:
  - 💤 Sleep
  - 💼 Work / Study
  - 👥 Family & Friends
  - 🏃 Activity / Body
  - 🌧️ Stress / Environment
  - 🧘 Quiet / Solitude
- **Optional Note**: Short micro-reflection.

### B. Analytical Visualizations & Stats
1. **Mood Timeline & Trend Graph**: Custom canvas visualization showing emotional score trajectory over the last 7 entries/days.
2. **Emotional Distribution**: Proportional breakdown of calm vs. stressed moments.
3. **Consistency Streak**: Tracking pauses and reflections completed.
4. **History Log**: Chronological review of previous check-ins with single-tap deletion.

### C. Privacy & Local Storage
- Local persistence using `SharedPreferences` serialization.
- Zero server transmission: data never leaves the user's smartphone.
