# Research & Engineering Design: Production Polish v0.3.1

## 1. True Floating Header & Navigation Stack Architecture
### Problem & Clinical UX Assessment
In prior iterations, the top branding capsule (`mindbridge.`) and the ejected `AI` pill were laid out inside a vertical `Column([header, Expanded(widget.child)])`. This created a rigid top boundary where scrollable content abruptly began underneath the header rather than gliding fluidly beneath it. On physical mobile screens, users perceived this as a static boxed navbar rather than a true floating HUD.

### Solution
- Migrated `AppShell` to an unbounded `Stack`:
  - `widget.child` occupies the primary layer, extending from top edge to bottom edge (`extendBody: true`).
  - Top header and AI pill are positioned via `Positioned(top: 0, left: 0, right: 0)` within a `SafeArea(bottom: false)`.
  - All scrollable views (`HomeScreen`, `LearnScreen`, `CheckInScreen`, `ResetScreen`, `SupportScreen`, `SettingsScreen`, `ReminderScreen`) incorporate a standard top scroll cushion (`EdgeInsets.fromLTRB(20, 84, 20, 110)`).
  - This ensures headers start cleanly visible and scroll smoothly beneath the floating capsules.

---

## 2. Pure Black OLED Dark Theme (#000000)
### Problem
The user tested dark mode on a physical OLED Android device and identified unacceptable low-contrast combinations:
- The "A Moment for You" card retained a hardcoded light sage green (`#E8EDE5`) background while typography switched to milk (`#F4F0E7`), rendering text virtually invisible.
- Action cards retained `#FBF9F3` off-white backgrounds, producing glaring white blocks against pure black screen real-estate.

### Solution & Design Tokens
1. **OLED Backgrounds**: `MindBridgeTheme.darkSurface` and `MindBridgeTheme.darkCard` pinned to `#000000` (Pure Black).
2. **Neo-Brutalist Milk Borders & Shadows**:
   - `Border.all(color: MindBridgeTheme.milk, width: 1.8)`
   - Dark offset shadows: `BoxShadow(color: MindBridgeTheme.milk, offset: Offset(3.5, 3.5), blurRadius: 0)`
3. **Comprehensive Card Audit**:
   - Updated `HomeScreen`, `ResetScreen`, `ReminderScreen`, `LearnScreen`, `SupportScreen`, `SettingsScreen`, and `AssistantScreen` to ensure zero light/sage/white cards render in dark mode.

---

## 3. Instant Snappy Tab Transitions
### Problem
Tab switching used an animated `FadeTransition` with a 180ms delay. In mobile application navigation, bottom tab switching is expected to be immediate and snappy; synthetic fade animations introduce perceived latency.

### Solution
- Replaced custom fade transitions in `_routerProvider` with `NoTransitionPage<void>(key: state.pageKey, child: child)`.
- Tab transitions now occur with zero frame delay, matching iOS and native Android bottom navigation standards.

---

## 4. AI Assistant History & Model Branding
### Problem
- Direct vendor/model strings (`qwen/qwen3.8-27b`, `Powered by Qwen 3.8 27B on Groq`) were surfaced in user-facing UI elements, reducing clinical professionalism.
- Users lacked an interface to view past AI psychoeducation sessions, switch between conversations, or delete obsolete transcripts.

### Architecture
- **Branding**: Replaced vendor names with *"MindBridge AI Companion · Evidence-informed guidance & support"*.
- **Local Storage Model**: `ChatSession` model serializing `id`, `title`, `createdAt`, and `messages` (`ChatMessage.toJson()`).
- **Repository Interface**: `ChatHistoryRepository` implemented via `SharedPrefsChatHistoryRepository` using SharedPreferences JSON storage.
- **State Management**:
  - `ChatNotifier` automatically auto-saves user inputs and assistant responses to the active session.
  - `ChatSessionsNotifier` manages session listings and deletions.
- **UI Sheet**: Bottom modal sheet (`_ChatHistorySheet`) offering a "Start New Conversation" action, complete history list with message count and relative dates, session loading, and session deletion.

---

## 5. Modal Navigation Hiding
### Problem
When opening learning courses, quizzes, and certificate viewers, the floating bottom bar remained visible underneath the bottom sheet.

### Solution
- Configured `useRootNavigator: true` on `showModalBottomSheet` in `_openArticle` and `_openCertificatesModal`.
- Pushes modal sheets to the root navigator layer above `AppShell`, completely concealing the bottom bar during learning sessions.
