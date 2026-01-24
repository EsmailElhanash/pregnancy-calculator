# Pregnancy Calculator (HamilGuide)

Flutter app project.

## Requirements
- Flutter SDK (pubspec targets Dart < 3.0)
- Android Studio / Xcode as needed


Note: this project targets a legacy Flutter/Dart toolchain (Dart < 3.0). Modernizing to Flutter 3+ will require dependency and code updates.

## Run (Debug)
```bash
flutter pub get
flutter run
```

## Secrets
This repo keeps secrets out of git. Provide the following locally:
- `android/app/google-services.json` (Firebase config)
- `android/key.properties` (signing config)
- `android/app/src/key.jks` (keystore)

Templates:
- `android/app/google-services.json.example`
- `android/key.properties.example`
