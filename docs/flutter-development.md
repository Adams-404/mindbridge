# Flutter application

Frontend prototype for MindBridge AI. No backend, account system, analytics, or live AI is included.

## Requirements
- Flutter SDK with Dart 3.5 or later
- Android Studio / Android SDK or a connected Android device

## Generate Android platform scaffolding (first setup)
The Flutter application lives at the repository root. Generate the Android runner project once with:

```bash
flutter create --platforms=android .
```

This adds native Android Gradle/runner files without replacing the existing Dart source.

## Run
```bash
flutter pub get
flutter run
```

## Checks
```bash
dart format lib test
flutter analyze
flutter test
```

## Architecture
The app uses Flutter's UI/data separation with feature screens, Riverpod for dependency injection/state, and go_router for navigation. Bundled content is prototype copy and needs qualified clinical review. The support directory intentionally has no provider records until a verification process exists.

## Current journeys
Home, Learn (bundled introductory articles), optional non-diagnostic check-in (not persisted), breathing pause (start/stop), session-only follow-up reminders (no notifications), Support guidance (no fabricated listings), an inactive assistant concept screen, and Settings (English/Hausa selection foundation).

Hausa selection is a localisation placeholder; full translation and clinical terminology review are not complete.
