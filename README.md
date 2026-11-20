# MindBridge AI

**Bridging the gap between mental health information and professional support.**

MindBridge AI is a mobile-first, bilingual mental health information and referral platform being designed for underserved communities in Nigeria, with an initial focus on English- and Hausa-speaking users.

> **Project status:** Concept and frontend prototype. This repository does not represent a clinically validated service, a live referral network, or a diagnostic/treatment product.

## Repository layout

- `web/` — public product landing page.
- `app/` — Flutter mobile application.
- `docs/` — product research, technical decisions, safety notes, and delivery plan.

## Product principles

- Clear, compassionate, non-judgmental language.
- English and Hausa as first-class experiences.
- Low-bandwidth and offline-aware design.
- Privacy by default and data minimisation.
- Educational support, never diagnosis or prescribing.
- Clear routes to qualified human support and urgent help.
- Architecture that allows local prototype data to be replaced by backend services later.

## Current scope

The first milestone is a polished, responsive landing page. The mobile frontend follows immediately, using local/demo repositories behind interfaces so backend integration does not require rewriting screens.

## Safety notice

MindBridge AI is not an emergency service and does not replace professional care. Prototype content and flows must be reviewed by qualified mental-health professionals and people with relevant lived experience before any real-world deployment. Do not use demo provider listings as real referrals.

## Development

See [docs/](docs/) for research, product requirements, architecture, safety boundaries, and the issue-driven roadmap.

The Flutter app will require the Flutter SDK. The landing page is a static site in `web/` and can be previewed with any local static server.
