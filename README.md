# Pregnancy Companion — Flutter

Flutter build of the **"Home page and menu items"** section of the Figma file
*Mayuri Bhide – Interface design for mobile (Copy)*.

## Open in VS Code

1. Install the Flutter SDK (3.24 or newer) and the **Flutter** extension in VS Code.
2. Unzip this folder and open it in VS Code (`File → Open Folder…`).
3. In the VS Code terminal, run once to generate the Android / iOS / web folders:

   ```bash
   flutter create . --project-name pregnancy_companion --org com.example
   flutter pub get
   ```

   `flutter create .` only adds the missing platform folders — it does not touch `lib/`, `assets/` or `pubspec.yaml`.
4. Pick a device in the status bar (emulator, phone or Chrome) and press **F5**.
   Ready-made launch configs are in `.vscode/launch.json`.

## What's built

### Onboarding
| Screen | Figma frame | Notes |
|---|---|---|
| Splash | iPhone 17 – 1 | Logo fade-in, auto-advances (tap to skip) |
| Login | iPhone 17 – 2 | Photo hero, email + password (eye toggle) |
| Verification Code | iPhone 17 – 9 | 48-second resend countdown; any 4–6 digit code works |
| What's Your Intention? | iPhone 17 – 3 | Single choice |
| Where did you learn about… | iPhone 17 – 5 | 7 sources |
| Your companion for motherhood | iPhone 17 – 6 | Multi-select features with live count |
| Find your delivery date (1/3) | iPhone 17 – 4 | Calculates due date (LMP + 280 days) |
| Enter your details (2/3) | iPhone 17 – 7 | Name, email, password, weight |
| Country (3/3) | — | From the "Country *" fields in frame 7; finishes onboarding |

Flows: **Sign In → Verify → Home** and **Register → Intention → Source → Features → Due date → Details → Country → Home**. Name, week and due date entered here show up on Home; weight seeds the Discover chart.

### Medical reminder (premium)
| Screen | Figma frame | Notes |
|---|---|---|
| Medical Reminder plans | iPhone 17 – 19 | Monthly / Annual / Lifetime |
| Payment | iPhone 17 – 20 / 21 / 22 | Card (live card preview), PayPal, Pay tabs. **Prototype — nothing is charged or stored** |
| You're in Premium | iPhone 17 – 23 | |
| Medicine Reminders | iPhone 17 – 24 / 26 | Today / Upcoming / Missed, swipe left to delete |
| Add medicine | iPhone 17 – 25 | Pill colour, dosage + unit, form, frequency, reminder time |

Open it from **Tools → Medicine Reminder** (goes straight to the list once premium is active).

### Home & menu
| Screen | Figma frame | Notes |
|---|---|---|
| Home | iPhone 17 – 8 | Journey card, day selector, affirmation, plan for the week, This Week toggle, activities grid, mood picker, holistic lessons |
| Tools | iPhone 17 – 10 | 10 tool tiles, Relaxation Activities, webinar cards. *Appointment Tracker* opens the tracker; *Weight Gain Tracker* jumps to Discover |
| Appointment Tracker | iPhone 17 – 14 / 15 / 16 | All / Upcoming / Completed / Cancelled filters, empty state, delete via ··· menu |
| Add Appointment | iPhone 17 – 17 / 18 | Date & time pickers, specialty dropdown, status, notes. Button stays grey until name + date + time are filled |
| Community | iPhone 17 – 13 | Post composer (adds to the feed), like toggle |
| Discover | iPhone 17 – 11 | Weight-gain chart (CustomPainter), kg/lbs toggle, Update Weight dialog, Positive Birth Stories |
| Profile | — | Placeholder until the profile frames are designed |

Bottom navigation (Home · Tools · Discover · Community · Profile) is the floating pill from the design.

## Project structure

```
lib/
  main.dart                  entry point
  app.dart                   MaterialApp, routes, app-state scope
  core/
    routes.dart              named routes
    theme/                   colour tokens, text styles (Lato + Open Sans), ThemeData
    widgets/                 PageHeader, BottomNavBar, PhotoCard, SectionHeader
    utils/formatters.dart    date/time formatting (no intl dependency)
  data/
    models.dart              Appointment, CommunityPost, ToolItem, …
    mock_data.dart           all copy & content from the Figma screens
    app_state.dart           ChangeNotifier store + InheritedNotifier scope
  features/
    shell/                   tab host + floating nav
    home/                    home screen + section widgets
    tools/
    appointments/            tracker, add form, card widget
    community/
    discover/                screen + weight chart painter
    profile/
assets/
  images/                    photos & mood icons exported from Figma
  fonts/                     Lato, Open Sans (SIL Open Font License)
design_refs/                 Figma screenshots for side-by-side comparison
```

## Android APK for testers

**Option A — GitHub (no Android Studio needed).** `.github/workflows/build-apk.yml` builds the APK in the cloud:
1. VS Code → Source Control (left bar) → **Publish to GitHub** → choose *public* (so testers can download without a GitHub login).
2. Open the repo on github.com → **Actions** tab → wait ~8 min for "Build Android APK" to go green.
3. Share `https://github.com/<you>/<repo>/releases/latest/download/app-release.apk`. Every new push updates the same link.

**Option B — on this PC.** Install Android Studio (it brings the Android SDK), run `flutter doctor --android-licenses`, then:
```
flutter build apk --release
```
The file is `build\app\outputs\flutter-apk\app-release.apk` — upload it to Google Drive and share the link.

On the phone: open the link → download → allow *Install unknown apps* for the browser when Android asks.

## Notes

- No third-party packages — only `flutter` and `cupertino_icons`. State lives in
  `AppState`; swap in Provider/Riverpod/Bloc when you connect a backend.
- Icons use Material icons that match the Figma glyphs; the 8 mood faces are
  exported PNGs from the design.
- *Segoe UI* in the Figma file is mapped to *Open Sans*; *SF Pro* status bar is the
  device's real status bar.
- To add the next flow (e.g. the *Medical reminder flow* section), create a folder in
  `lib/features/`, add a route in `core/routes.dart` and register it in `app.dart`.
