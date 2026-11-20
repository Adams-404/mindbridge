# Technical architecture

## Goals
Ship a backend-free frontend; keep UI independent from storage/network; replace local demo repositories with API implementations later; make features testable and accessible.

## Flutter pattern
Follow Flutter's recommended separation of UI and data layers with MVVM:
- View: widgets and screen composition.
- ViewModel: presentation state and commands.
- Repository: feature data contract/source of truth.
- Service: wraps local assets, platform APIs, or future HTTP endpoints.
- Domain/use cases: add only for complex or reused workflows.

## Structure
```
app/lib/
  app/                 # app shell, router, theme
  core/                # shared widgets, localisation, accessibility
  features/
    home/
    learn/
    check_in/
    reset/
    support/
    settings/
  data/                # models, repository contracts, demo sources
app/test/
```

## State and navigation
Riverpod for dependency injection/reactive state; go_router for navigation; immutable models where practical. Widgets must not access data services directly.

## Prototype data
Bundle reviewed/demo learning content locally. Use abstract repositories with local implementations. No sensitive check-in persistence. Provider directory must be empty or clearly labelled sample-only; never imply demo records are real/verified. Core flows must work offline.

## Backend seam
Potential contracts: LearnRepository, ProviderRepository, ReminderRepository, SettingsRepository. AssistantRepository is intentionally not implemented. Backend, auth, database, hosting and AI provider remain undecided until frontend review.

## Tests and quality
Unit tests for repositories/view models; widget tests for screen states, semantics and routing; integration tests for onboarding/navigation; test offline startup, narrow screens and large text. Use flutter_lints and run format/analyze in CI.
