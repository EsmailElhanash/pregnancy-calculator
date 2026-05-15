# Project Summary: Pregnancy Calculator (HamilGuide)

Generated: 2026-05-15

## Executive Summary

This repository contains a legacy Flutter mobile application for pregnancy tracking and Arabic pregnancy guidance. The app lets a user calculate pregnancy progress from either a last menstrual period date or expected delivery date, supports Gregorian and Hijri date selection, stores the selected pregnancy date locally, schedules weekly pregnancy notifications, shows week-by-week pregnancy content, embeds the HamilGuide website, and links users to Facebook community pages.

The codebase targets mobile platforms through Flutter with Android and iOS native shells. The resolved lockfile points to an older Flutter/Dart toolchain: Dart `>=2.10.2 <2.11.0` and Flutter `>=1.22.2 <2.0.0`. The app is not null-safe and uses several legacy Flutter APIs such as `RaisedButton` and `FlatButton`.

## Project Identity

| Item | Value |
| --- | --- |
| Project/package name | `HamilGuide` |
| Product name | Pregnancy Calculator / HamilGuide |
| App type | Flutter mobile application |
| Primary audience | Arabic-speaking pregnancy app users |
| Main app package/application ID | `com.hamilguide.pregnancycalc` |
| Pubspec version | `1.0.0+6` |
| Android label | Arabic "Pregnancy Calculator" label in `strings.xml` |
| iOS bundle name | `elhwamelfinal` |
| Flutter project type | `app` |
| Flutter metadata channel | `stable` |
| Flutter metadata revision | `27321ebbad34b0a3fafe99fac037102196d655ff` |

## High-Level Features

- Pregnancy date calculator using either the last menstrual period date or expected delivery date.
- Gregorian and Hijri calendar support.
- Pregnancy progress display by day, week, and month.
- Expected delivery date calculation.
- Persistent storage of the selected pregnancy start date and calendar type.
- Automatic restoration of the saved pregnancy state on app start.
- Week-by-week pregnancy education content for the mother and baby.
- One-tap navigation from calculator results to the current pregnancy week.
- Weekly local notification scheduling for the next pregnancy week.
- Firebase Cloud Messaging setup for push notification handling.
- Google AdMob banner/interstitial support through Firebase AdMob.
- Kochava tracker initialization for attribution/analytics.
- In-app website tab using WebView.
- Social links to HamilGuide Facebook page and Facebook group.
- In-app rating prompt after repeated launches.
- Arabic localization and right-to-left UI content.

## Application Structure

The app is organized as a small Flutter codebase under `lib/`, with native Android and iOS project folders.

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Flutter entry point, `MaterialApp`, Arabic locale setup, tab navigation, global ad placement, and page-change listener wiring. |
| `lib/constants.dart` | Shared app constants for pregnancy terms, 280-day pregnancy period, database names, notification channel IDs, app ID, and small display helpers. |
| `lib/screens/elhaml.dart` | Main pregnancy calculator screen, date input UI, result screen, progress bar, SQLite save/restore, and notification scheduling. |
| `lib/screens/weeks.dart` | Week-by-week pregnancy content screen with static mother/baby content arrays and week navigation. |
| `lib/screens/website.dart` | Embedded WebView for `https://hamilguide.com/hamilguide/`. |
| `lib/screens/links.dart` | Social/community and article-style content screen, using Facebook links and URL launching. |
| `lib/utils/calculations.dart` | Pregnancy date math, expected delivery date formatting, remaining day calculation, and progress text helpers. |
| `lib/utils/database.dart` | SQLite persistence using `sqflite`. |
| `lib/utils/date_util.dart` | Gregorian/Hijri calendar type helpers, Arabic month lists, year lists, and day list generation. |
| `lib/utils/weeks_manager.dart` | Static current-week state and listener notification for tab navigation. |
| `lib/utils/ads_manager.dart` | Firebase AdMob setup, banner/interstitial loading, and Kochava initialization. |
| `lib/utils/notification_manager.dart` | Local notification initialization/scheduling plus Firebase Messaging configuration. |
| `lib/utils/rate_app.dart` | Rate-my-app prompt configuration and dialog text. |
| `lib/utils/color.dart` | Hex color string parsing helper. |
| `android/` | Android Gradle project, Kotlin activity, Java application class, manifests, resources, and signing/Firebase templates. |
| `ios/` | iOS Flutter runner project with Swift `AppDelegate`, Xcode project, launch storyboard, and app icons. |
| `assets/images/` | Runtime images used by the app UI and launcher icon generation. |

## Runtime Navigation

`lib/main.dart` builds a `MaterialApp` with four top-level tabs:

1. Pregnancy calculator (`Elhaml`)
2. Week-by-week guide (`Weeks`)
3. Website (`WebSite`)
4. Social/content links (`Links`)

The app forces the supported locale to Arabic via `flutter_localizations` and uses a pink-themed Material UI. `CurrentPageManager` acts as a simple global state bridge: when calculator results set the current week, the main `TabController` moves the user to the weeks tab.

## Main Calculator Flow

The calculator screen in `lib/screens/elhaml.dart` uses a `StatefulWidget` with three states:

- `LOADING`
- `SHOW_DETAILS`
- `SHOW_MAIN_SCREEN`

The main flow is:

1. Initialize calendar lists and instruction text.
2. Check SQLite for an existing saved pregnancy date.
3. If saved data exists, restore the calendar type and calculate remaining pregnancy days.
4. If not, show date selection.
5. User chooses Gregorian or Hijri calendar.
6. User chooses year, month, and day from dropdowns.
7. App calculates remaining days using a 280-day pregnancy period.
8. Invalid dates are rejected if remaining days are `<= 0` or `>= 280`.
9. Valid selections are saved to SQLite.
10. The app schedules the next weekly local notification.
11. The result screen displays expected delivery date, current month/week/day, progress bar, and remaining time.

## Data Model and Persistence

Local persistence uses SQLite through `sqflite`.

| Item | Value |
| --- | --- |
| Database file | `pregnant_data.db` |
| Table | `PregnantData` |
| Primary key strategy | Single fixed row ID, `id = 1` |
| Columns | `id`, `EntryDate`, `StartDate`, `CalendarType` |
| Date storage | Milliseconds since Unix epoch for the selected date |
| Calendar storage | `CalendarType.index`, where `0` is Gregorian and `1` is Hijri |
| Write behavior | `ConflictAlgorithm.replace` overwrites the fixed row |
| Read behavior | Query by fixed ID and restore the last saved pregnancy state |

The app stores only one pregnancy calculation state at a time.

## Date and Pregnancy Calculation Logic

The pregnancy model is based on:

- Total pregnancy period: `280` days.
- Last menstrual period mode: selected date plus `280` days.
- Expected delivery date mode: selected date is treated as the target delivery date.
- Hijri support: selected Hijri dates are converted to Gregorian dates with the `hijri` package before date difference calculations.
- Expected delivery date formatting:
  - Gregorian: `d-M-yyyy` through `intl`.
  - Hijri: converted back to Arabic Hijri date fields.

The app reports progress in:

- Days since pregnancy start.
- Current pregnancy week.
- Approximate current pregnancy month.
- Remaining days, months/days, and weeks/days.

## Notifications

The app uses two notification-related systems:

| System | Package/library | Purpose |
| --- | --- | --- |
| Local scheduled notifications | `flutter_local_notifications` plus transitive `timezone` | Schedules a weekly pregnancy progress notification. |
| Push messaging | `firebase_messaging` | Requests notification permission and configures foreground/background/launch/resume callbacks. |

The local notification channel constants are defined in `lib/constants.dart`. The scheduled notification uses fixed ID `501`, channel ID `401`, and a payload containing the next week number. Selecting the notification restarts the app and sets `CurrentPageManager.pageNumber`.

On Android, `android/app/src/main/java/Application.java` registers Firebase Messaging plugin handling and logs the FCM token on startup.

## Ads, Attribution, and Monetization

The app includes Google AdMob support through `firebase_admob`.

| Area | Implementation |
| --- | --- |
| Ad initialization | `FirebaseAdMob.instance.initialize(appId: appId)` in `AdsManager.initialize()` |
| Banner ad | `BannerAd` with `AdSize.smartBanner`, shown at top anchor |
| Interstitial ad | `InterstitialAd`, loaded and shown through `AdsManager.loadInterstitialAd()` |
| Ad targeting | `MobileAdTargetingInfo` with keywords and content URL |
| Android manifest AdMob app ID | Configured with `com.google.android.gms.ads.APPLICATION_ID` |

The code also initializes `kochava_tracker` with placeholder Android/iOS GUID values. Facebook Audience Network constants and loading logic are present but commented out, while Facebook SDK metadata remains in the Android manifest.

## Web and External Links

The `WebSite` tab uses `webview_flutter` and opens:

- `https://hamilguide.com/hamilguide/`

On Android, it uses `SurfaceAndroidWebView`.

The links screen uses `url_launcher` to open:

- `https://www.facebook.com/HamilGuide/`
- `https://www.facebook.com/groups/hamilguide`

## Assets

Assets are declared in `pubspec.yaml` under `assets/images/`.

| Asset | Observed use |
| --- | --- |
| `assets/images/bubble_speech.png` | Available asset, not seen in current Dart imports during scan. |
| `assets/images/doctor.png` | Calculator result screen. |
| `assets/images/facebook.png` | Links/social screen. |
| `assets/images/icon.png` | Launcher icon source for `flutter_launcher_icons`. |
| `assets/images/koky.jpg` | Background image for calculator and links screens. |
| `assets/images/logo2.png` | Main calculator screen logo. |
| `assets/images/logo3.png` | Links/social content card. |

## UI and Localization

- Flutter Material widgets are used throughout.
- The app declares Arabic as the supported locale through `flutter_localizations`.
- Several screens use right-to-left layout via `Directionality` and `textDirection: TextDirection.rtl`.
- UI text and static pregnancy content are mostly Arabic.
- Visual styling uses Material colors, pink/amber backgrounds, image overlays, cards, chat bubbles, progress bars, and Font Awesome icons.

## Native Android Stack

| Technology | Version/configuration |
| --- | --- |
| Android Gradle Plugin | `4.1.2` |
| Gradle wrapper | `6.7-all` |
| Kotlin Gradle plugin | `1.4.30` |
| Kotlin stdlib | `org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version` |
| Compile SDK | `30` |
| Min SDK | `21` |
| Target SDK | `30` |
| AndroidX | Enabled |
| Jetifier | Enabled |
| R8 | Enabled |
| Google Services Gradle plugin | `4.3.5` |
| Repositories | `google()`, `jcenter()`, `mavenCentral()` |

Native Android dependencies declared in `android/app/build.gradle`:

- `org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version`
- `com.google.firebase:firebase-messaging:21.0.1`
- `com.google.firebase:firebase-bom:26.4.0`
- `com.google.firebase:firebase-analytics-ktx`
- `androidx.annotation:annotation:1.1.0`
- `com.google.android.gms:play-services-ads-identifier:17.0.0`
- `com.android.installreferrer:installreferrer:2.1`

Android manifest capabilities:

- Internet permission.
- Flutter embedding v2 metadata.
- Main launcher activity based on `FlutterActivity`.
- Notification click intent action.
- Google Mobile Ads app ID metadata.
- Facebook SDK app ID metadata.
- Facebook activity declaration.
- Facebook content provider declaration.

Android native source files:

- `android/app/src/main/kotlin/com/hamilguide/elhawamel/MainActivity.kt`
- `android/app/src/main/java/Application.java`

## Native iOS Stack

The iOS side is a standard Flutter Runner project.

| Technology | Use |
| --- | --- |
| Swift | `ios/Runner/AppDelegate.swift` |
| UIKit | iOS application delegate |
| Flutter iOS embedding | `GeneratedPluginRegistrant.register(with: self)` |
| Xcode project/workspace | `ios/Runner.xcodeproj`, `ios/Runner.xcworkspace` |
| Storyboards | `LaunchScreen.storyboard`, `Main.storyboard` |
| Asset catalogs | App icon and launch image assets |

The iOS app supports iPhone and declares portrait plus landscape orientations.

## Flutter and Dart SDK Configuration

`pubspec.yaml` declares:

- Dart environment: `>=2.2.2 <3.0.0`
- Flutter Material support: `uses-material-design: true`

`pubspec.lock` resolves:

- Dart SDK: `>=2.10.2 <2.11.0`
- Flutter SDK: `>=1.22.2 <2.0.0`

This means the checked-in dependency set is tied to the pre-null-safety Flutter 1.x era.

## Direct Flutter/Dart Dependencies

The following direct runtime dependencies are declared in `pubspec.yaml`. Resolved versions come from `pubspec.lock`.

| Package | Declared constraint | Resolved version | Role in project |
| --- | --- | --- | --- |
| `flutter` | SDK | SDK | Core Flutter UI framework. |
| `flutter_localizations` | SDK | SDK | Arabic locale support through Flutter localization delegates. |
| `font_awesome_flutter` | `^8.11.0` | `8.12.0` | Facebook icon in links screen. |
| `url_launcher` | `any` | `5.7.10` | Opens Facebook page/group links externally. |
| `http` | `^0.12.0+3ubunt` | `0.12.2` | Declared dependency; no direct import found in scanned `lib/` files. |
| `webview_flutter` | `^1.0.7` | `1.0.7` | Embedded website tab. |
| `flutter_animation_progress_bar` | `^1.0.0` | `1.0.6` | Pregnancy progress bar on result screen. |
| `demoji` | `^1.0.1` | `1.0.1` | Declared dependency; no direct import found in scanned `lib/` files. |
| `intl` | `^0.16.1` | `0.16.1` | Gregorian date formatting and saved entry date formatting. |
| `firebase_admob` | `0.10.3` | `0.10.3` | Google AdMob banner and interstitial ads. |
| `flutter_date_pickers` | `^0.1.10` | `0.1.10` | Declared dependency; no direct import found in scanned `lib/` files. |
| `date_util` | `^0.1.4` | `0.1.4` | Days-in-month calculations for Gregorian date dropdowns. |
| `hijri` | `^2.0.3` | `2.0.3` | Hijri date selection and Hijri/Gregorian conversion. |
| `sqflite` | `^1.3.0` | `1.3.2+4` | Local SQLite persistence. |
| `fluttertoast` | `^7.1.6` | `7.1.8` | Invalid-date toast messages. |
| `arabic_numbers` | `^0.0.1` | `0.0.1` | Declared dependency; no direct import found in scanned `lib/` files. |
| `path_provider` | `^1.5.1` | `1.6.27` | Declared dependency; no direct import found in scanned `lib/` files. |
| `flutter_local_notifications` | `^3.0.3` | `3.0.3` | Scheduled weekly local notifications. |
| `flutter_chat_bubble` | `^1.0.2` | `1.0.2` | Chat bubble UI on result screen. |
| `firebase_messaging` | `^7.0.3` | `7.0.3` | Firebase Cloud Messaging callbacks and permissions. |
| `kochava_tracker` | `^1.1.2` | `1.1.2` | Attribution/analytics tracker initialization. |
| `rate_my_app` | `0.6.1+7` | `0.6.1+7` | In-app rating prompt after launch thresholds. |
| `facebook_sdk` | `^0.0.7` | `0.0.7` | Declared dependency and native Facebook metadata present; no direct Dart import found in scanned `lib/` files. |

## Dev Dependencies and Tooling Packages

| Package | Declared constraint | Resolved version | Purpose |
| --- | --- | --- | --- |
| `flutter_launcher_icons` | `^0.7.3` | `0.7.5` | Generates Android and iOS launcher icons from `assets/images/icon.png`. |

`flutter_icons` is configured for both Android and iOS.

## Directly Imported Packages from Dart Code

The scanned Dart code imports these package namespaces:

- `date_util`
- `firebase_admob`
- `firebase_messaging`
- `flutter`
- `flutter_animation_progress_bar`
- `flutter_chat_bubble`
- `flutter_local_notifications`
- `flutter_localizations`
- `fluttertoast`
- `font_awesome_flutter`
- `hijri`
- `intl`
- `kochava_tracker`
- `path`
- `rate_my_app`
- `sqflite`
- `timezone`
- `url_launcher`
- `webview_flutter`

Two notable package imports are not direct dependencies in `pubspec.yaml`:

- `path` is imported by `lib/utils/database.dart` and resolved transitively.
- `timezone` is imported by `lib/utils/notification_manager.dart` and resolved transitively.

For long-term maintainability, packages imported directly by app code should usually be listed as direct dependencies.

## Resolved Transitive Dependencies

The lockfile also resolves these transitive packages:

| Package | Version |
| --- | --- |
| `archive` | `2.0.13` |
| `args` | `1.6.0` |
| `characters` | `1.1.0-nullsafety.3` |
| `charcode` | `1.1.3` |
| `collection` | `1.15.0-nullsafety.3` |
| `convert` | `2.1.1` |
| `crypto` | `2.1.5` |
| `ffi` | `0.1.3` |
| `file` | `5.2.1` |
| `firebase_core` | `0.5.3` |
| `firebase_core_platform_interface` | `2.1.0` |
| `firebase_core_web` | `0.2.1+1` |
| `flutter_local_notifications_platform_interface` | `2.0.0+1` |
| `flutter_web_plugins` | Flutter SDK |
| `http_parser` | `3.1.4` |
| `image` | `2.1.19` |
| `js` | `0.6.2` |
| `matcher` | `0.12.9` |
| `meta` | `1.3.0-nullsafety.3` |
| `path` | `1.8.0-nullsafety.1` |
| `path_provider_linux` | `0.0.1+2` |
| `path_provider_macos` | `0.0.4+8` |
| `path_provider_platform_interface` | `1.0.4` |
| `path_provider_windows` | `0.0.4+3` |
| `pedantic` | `1.9.2` |
| `petitparser` | `3.1.0` |
| `platform` | `2.2.1` |
| `plugin_platform_interface` | `1.0.3` |
| `process` | `3.0.13` |
| `quiver` | `2.1.5` |
| `shared_preferences` | `0.5.12+4` |
| `shared_preferences_linux` | `0.0.2+4` |
| `shared_preferences_macos` | `0.0.1+11` |
| `shared_preferences_platform_interface` | `1.0.4` |
| `shared_preferences_web` | `0.1.2+7` |
| `shared_preferences_windows` | `0.0.2+3` |
| `sky_engine` | `0.0.99` |
| `smooth_star_rating` | `1.1.1` |
| `source_span` | `1.7.0` |
| `sqflite_common` | `1.0.3+3` |
| `stack_trace` | `1.9.6` |
| `string_scanner` | `1.0.5` |
| `synchronized` | `2.2.0+2` |
| `term_glyph` | `1.1.0` |
| `timezone` | `0.5.9` |
| `typed_data` | `1.3.0-nullsafety.3` |
| `url_launcher_linux` | `0.0.1+4` |
| `url_launcher_macos` | `0.0.1+9` |
| `url_launcher_platform_interface` | `1.0.9` |
| `url_launcher_web` | `0.1.5+3` |
| `url_launcher_windows` | `0.0.1+3` |
| `vector_math` | `2.1.0-nullsafety.3` |
| `win32` | `1.7.4+1` |
| `xdg_directories` | `0.1.2` |
| `xml` | `4.5.1` |
| `yaml` | `2.2.1` |

## External Services and Integrations

| Service | Evidence in project | Purpose |
| --- | --- | --- |
| Firebase | `firebase_messaging`, Firebase Android dependencies, `google-services.json.example` | Push messaging and Firebase setup. |
| Google AdMob | `firebase_admob`, Android manifest app ID, ad unit IDs in `AdsManager` | Banner and interstitial ads. |
| Google Play Services Ads Identifier | Native Android dependency | Advertising ID collection. |
| Firebase Analytics | Native Android dependency `firebase-analytics-ktx` | Analytics support via Firebase BOM. |
| Kochava | `kochava_tracker` | Attribution/tracking initialization. |
| Facebook | `facebook_sdk`, Facebook app ID strings, manifest activity/provider, URL links | Facebook SDK metadata and community links. |
| HamilGuide website | WebView initial URL | Embedded website content. |

## Secrets and Local Configuration

The repository intentionally keeps sensitive local files out of source control and provides templates:

- `android/app/google-services.json.example`
- `android/key.properties.example`

Expected local-only files mentioned by the README:

- `android/app/google-services.json`
- `android/key.properties`
- `android/app/src/key.jks`

Android release signing reads `key.properties` if present. The release build type points to the release signing config.

## Build and Run Notes

The README documents the basic debug flow:

```bash
flutter pub get
flutter run
```

Because the lockfile resolves Flutter `<2.0.0` and Dart `<2.11.0`, the safest build environment is a legacy Flutter SDK around the Flutter 1.22 generation. Modern Flutter 3.x builds are likely to require package upgrades, null-safety migration work, Android Gradle updates, and API replacements for deprecated widgets.

## Codebase Size Snapshot

At the time this report was generated:

- Dart source files under `lib/`: 14
- Dart source lines under `lib/`: 2,599
- Main screen files: 4
- Utility files: 7
- Native Android custom source files: Kotlin `MainActivity.kt`, Java `Application.java`
- Native iOS custom source file: Swift `AppDelegate.swift`

## Testing Status

No `test/` directory or Flutter test files were present in the scanned project tree. The repository appears to rely on manual app testing rather than automated unit/widget/integration tests.

## Maintenance Observations

- The app is a legacy Flutter project and is not null-safe.
- Several dependencies are old and may be discontinued or incompatible with current Flutter releases.
- `jcenter()` is still configured in Android Gradle files; this repository should eventually migrate away from it.
- `RaisedButton` and `FlatButton` are deprecated in modern Flutter and should be replaced during modernization.
- `firebase_admob` is a deprecated package in modern Flutter ecosystems; newer projects generally use `google_mobile_ads`.
- Some direct dependencies are declared but were not directly imported in the scanned Dart files: `http`, `demoji`, `flutter_date_pickers`, `arabic_numbers`, `path_provider`, and `facebook_sdk`.
- Some transitive dependencies are imported directly by app code: `path` and `timezone`.
- Kochava app GUIDs are placeholders in source code and should be replaced with real environment-specific configuration if the tracker is intended to be active.
- Facebook Audience Network code appears partially removed or commented out, while some Facebook SDK native configuration remains.
- The app stores only one pregnancy record by design, replacing the existing row each time the user recalculates.

