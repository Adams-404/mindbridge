# MindBridge AI

**An intelligent digital mental health and psychological knowledge platform.**

MindBridge AI is being designed to connect people with trusted mental health information, early support, and pathways to professional care. The initial focus is underserved communities in Nigeria, with English and Hausa as intended first-class languages.

> **Status:** Concept-stage product with an active Flutter frontend prototype. This repository is not a clinically validated service, live referral network, or diagnostic/treatment product.

## Repository

- `lib/`, `test/`, `pubspec.yaml` — Flutter application at the repository root.
- `web/` — responsive public landing page.
- `docs/` — research, product requirements, UX direction, architecture, safety, and roadmap.
- `.github/` — CI workflows.

## Start here

- [Product brief](docs/product-brief.md)
- [Research and references](docs/research.md)
- [UX and visual direction](docs/ux-and-design.md)
- [Safety and privacy baseline](docs/safety-and-privacy.md)
- [Technical architecture](docs/architecture.md)
- [Roadmap](docs/roadmap.md)
- [Flutter development guide](docs/flutter-development.md)
- [GitHub Issues](https://github.com/Adams-404/mindbridge/issues)

## Run the Flutter app

Requires the Flutter SDK and Android tooling. Generate the Android runner files on first setup:

```bash
flutter create --platforms=android .
flutter pub get
flutter run
```

See [docs/flutter-development.md](docs/flutter-development.md) for setup, checks, and current prototype journeys.

## Preview the landing page

```bash
cd web
python3 -m http.server 4173
```

Then open http://localhost:4173.

## Product principles

- Clear, compassionate, non-judgmental language.
- English/Hausa localisation, with translations reviewed before release.
- Low-bandwidth and offline-aware design.
- Privacy by default and data minimisation.
- Education and navigation, never diagnosis or prescribing.
- Verified human support, never fabricated directory entries.
- Local demo repositories behind interfaces so a backend can be added later.

## Safety notice

MindBridge is not an emergency service and does not replace professional care. Health content, referral pathways, translations, and future AI behaviour require review by qualified professionals and intended users before real-world deployment. Do not treat prototype content as clinical guidance.
