# Research notes — 20 November 2026

## Flutter architecture
Flutter team, Architecture recommendations: https://docs.flutter.dev/app-architecture/recommendations  
Flutter team, Architecture guide: https://docs.flutter.dev/app-architecture/guide

Applied recommendations: separate UI/data layers; MVVM views and view models; repositories as sources of truth; services isolate external data; unidirectional data flow; immutable models; dependency injection; abstract repository contracts; go_router; unit/widget/integration tests. Add a domain layer only when complexity warrants it.

## Mental-health safety
WHO, Digital interventions for self-harm and suicide: https://www.who.int/teams/mental-health-and-substance-use/treatment-care/mental-health-gap-action-programme/evidence-centre/self-harm-and-suicide/digital-interventions  
WHO describes digital interventions based on evidence-based approaches as a conditional recommendation for people with suicidal thoughts, with low certainty of evidence. This is not an endorsement of arbitrary wellness apps.

WHO, Psychological self-help interventions: https://www.who.int/teams/mental-health-and-substance-use/treatment-care/Psychological-interventions/psychological-self-help-interventions  
Structured, evidence-informed self-help may expand access, including in low-resource settings. Content needs appropriate sourcing, review, and delivery boundaries. A breathing animation is not equivalent to a validated intervention.

UK GOV, Criteria for health app assessment: https://www.gov.uk/government/publications/health-app-assessment-criteria/criteria-for-health-app-assessment  
Useful reference for user-centred design, informed consent, privacy, clinical risk management, accessibility, and user evaluation. Not Nigerian legal advice.

Australian Commission on Safety and Quality in Health Care, Digital mental health governance: https://www.safetyandquality.gov.au/national-standards/digital-mental-health-standards/clinical-and-technical-governance-standard  
Useful governance and privacy impact assessment reference.

## Accessibility
W3C WCAG 2.2: https://www.w3.org/TR/WCAG/  
Target AA principles: normal text contrast 4.5:1; large text 3:1; reflow; keyboard operation; visible focus; meaningful labels; adequate target size. Apply native Android accessibility testing as well as web checks.

## Landing page
Bitly, Landing page best practices: https://bitly.com/blog/landing-page-best-practices-guide/  
Applied structure: benefit-led headline, one-sentence value proposition, clear above-the-fold CTA, product visual, concise benefits, earned trust evidence, FAQ, repeated CTA. Never fabricate testimonials, user counts, clinical endorsements, or app availability.

## Product conclusions
- Lead with accessible mental-health information, not an AI claim.
- Use calm, mature visual design rather than hospital dashboards or gamified mood scores.
- Make check-ins voluntary and skippable.
- Put safety boundaries at point of use.
- Treat language, literacy, connectivity, and accessibility as core requirements.
- Never show fictional providers as verified.
- Do not guess crisis numbers or imply the app is monitored.

## Research still required
Nigerian Data Protection Act 2023 review with qualified counsel/DPO; mapping verified support services and emergency pathways in Gombe/target states; interviews with users, Hausa speakers, clinicians and lived-experience contributors; clinical review of health content; testing on low-end Android, slow connections, screen readers and large text; age/safeguarding review.


## 6. Flutter 3.50 Material UI migration
**Flutter team — Migrate to standalone material_ui and cupertino_ui packages**  
https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui

Flutter 3.50 formally deprecates the in-framework Material library. The app therefore uses the standalone `material_ui` package, and its localization delegates, rather than relying on the legacy `package:flutter/material.dart` import. This keeps the frontend aligned with the current stable Flutter toolchain.
