# Sociality AI Case Generator

A Flutter application that generates AI-powered interactive case simulations for social work education. Educators describe a scenario, the AI produces a structured multi-step case with multiple-choice decisions, and learners work through it as a quiz.

---

## What it does

**Generate flow**

1. Educator enters a scenario prompt (e.g. "A social worker dealing with a client in crisis")
2. Optionally uploads supporting material — photos, PDFs, DOCX or TXT files
3. Selects a difficulty level (Easy / Medium / Hard)
4. The app calls the backend API and shows an animated loading screen
5. The generated case appears as **animated flip cards** — front shows the scenario, back shows multiple-choice options (A, B, C…)
6. Cards can be edited inline before use
7. The case can be exported as a PDF and shared/downloaded

**Simulate flow**

After reviewing the cards, learners tap **Start case simulation** to play through the quiz:

- One step per screen; pick an option to advance
- Results screen shows which choice was made per step
- "Play again" restarts with the same case; "Dashboard" returns to the home page

The app is bilingual — Dutch (default) and English — switchable at any time via the flag toggle in the top bar.

---

## Project structure

```
lib/
├── app/
│   └── case_generator_app.dart     # Root widget, sets up LanguageScope
├── main.dart                       # Entry point
├── simulation.dart                 # Quiz simulation screens (QuizScreen, ResultScreen, StartScreen)
├── models/
│   ├── app_language.dart           # AppLanguage enum (dutch / english)
│   ├── difficulty_level.dart       # DifficultyLevel enum + API value mapping
│   ├── evidence_item.dart          # Uploaded file wrapper
│   ├── fallback_case.dart          # Model for the bundled sample case
│   ├── generated_case.dart         # GeneratedCase / GeneratedCaseStep / GeneratedStepDetail
│   ├── home_copy.dart              # All UI strings in NL + EN
│   └── language_scope.dart         # InheritedNotifier that drives language switching
├── screens/
│   ├── home_page.dart              # Landing page (prompt input, file upload, difficulty)
│   ├── loading_screen.dart         # AI generation progress + error handling
│   ├── case_simulation_page.dart   # Flip-card review + edit + export
│   └── download_success_page.dart  # Post-download screen with confetti + simulation entry
└── services/
│   ├── case_api_service.dart       # POST to the backend to generate a case
│   ├── fallback_case_service.dart  # Loads bundled Case_steps.json when API fails
│   └── pdf_export_service.dart     # Renders case cards to PDF and triggers share sheet
└── widgets/
    ├── difficulty_selector.dart
    ├── flags.dart
    ├── how_it_works_overlay.dart
    ├── language_selector.dart
    └── upload_dropzone.dart
```

Assets live in `assets/images/` (app background, icons), `assets/icon/` (launcher icon), and `assets/initial data/Case_steps.json` (bundled fallback case).

---

## Prerequisites

| Tool | Minimum version |
|------|----------------|
| Flutter | 3.x (SDK constraint `^3.11.5`) |
| Dart | bundled with Flutter |
| Xcode | 15+ (iOS builds) |
| Android Studio / SDK | Android builds |

---

## Getting started

```bash
# 1. Clone the repo and enter the project directory
git clone <repo-url>
cd sociality_ai_case_generator

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or simulator
flutter run
```

To build a release:

```bash
flutter build ios --release        # iOS
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android AAB
```

---

## Backend API

The app calls a hosted REST endpoint to generate cases:

```
POST https://case-gen-api-4isa.onrender.com/cases/generate
Content-Type: application/json

{
  "difficulty": "medium",   // "easy" | "medium" | "hard"
  "prompt": "..."           // educator's scenario description
}
```

The endpoint is configured in `lib/services/case_api_service.dart`. The request timeout is **120 seconds** — the hosted service cold-starts on Render, so the first request of the day may be slow.

**If the API is unavailable**, the app automatically falls back to the bundled sample case (`assets/initial data/Case_steps.json`) so the full UI flow can still be demonstrated offline.

To point the app at a different backend, update `_endpoint` in `case_api_service.dart`.

---

## Key dependencies

| Package | Purpose |
|---------|---------|
| `http` | Backend API calls |
| `file_picker` | Upload DOCX / PDF / TXT files as evidence |
| `image_picker` | Upload photos as evidence |
| `pdf` + `printing` | Generate and share the case as a PDF |
| `share_plus` | Native share sheet for the exported PDF |
| `confetti` | Download success celebration animation |

---

## Language support

All UI copy lives in `lib/models/home_copy.dart`. To add a new language:

1. Add a value to the `AppLanguage` enum in `app_language.dart`
2. Add a corresponding branch in `HomeCopy.fromLanguage()`
3. Add a flag widget in `widgets/flags.dart` and a new `_FlagOption` in `widgets/language_selector.dart`

---

## Known limitations

- The `printing` package does not yet support Swift Package Manager on iOS/macOS — this produces a build warning but does not break the build.
- The simulation quiz uses hardcoded English category tags ("Analysis & planning", "Assessment", etc.) that are not tied to the generated case content.
- Uploaded files (photos, PDFs) are passed as metadata only; the current API accepts only the text prompt — file contents are not parsed server-side.

---

## Branch overview

| Branch | Description |
|--------|-------------|
| `DEV` | Main integration branch |
| `Merge-test` | Combined frontend — case generator + simulation quiz |

The `Merge-test` branch is where the two frontend halves were merged. Tapping **Start case simulation** on the flip-card page, or **Start case simulation** on the download success page, launches the quiz pre-loaded with the generated case steps.
