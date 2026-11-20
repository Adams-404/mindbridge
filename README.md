# MindBridge AI

**Bridging the gap between mental health information and professional support.**

MindBridge AI is a mobile-first mental-health information and referral platform being designed for underserved communities in Nigeria, with English and Hausa as intended first-class languages.

> **Status:** Concept-stage product with an active frontend prototype. This repository is not a clinically validated service, live referral network, or diagnostic/treatment product.

## Repository

- `web/` — responsive public landing page.
- `app/` — Flutter mobile frontend.
- `docs/` — research, product requirements, UX direction, architecture, safety, and roadmap.

## Start here

- [Product brief](docs/product-brief.md)
- [Research and references](docs/research.md)
- [UX and visual direction](docs/ux-and-design.md)
- [Safety and privacy baseline](docs/safety-and-privacy.md)
- [Technical architecture](docs/architecture.md)
- [Roadmap](docs/roadmap.md)
- [GitHub Issues](https://github.com/Adams-404/mindbridge/issues)

## Preview the landing page

```bash
cd web
python3 -m http.server 4173
```

Then open http://localhost:4173.

## Run the Flutter app

Requires Flutter and Android tooling. Generate the Android runner files on first setup:

```bash
cd app
flutter create --platforms=android .
flutter pub get
flutter run
```

See [app/README.md](app/README.md) for checks and current prototype journeys.

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
