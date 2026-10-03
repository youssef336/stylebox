# Mysterybag Workspace Instructions

## Code Style

- Follow Flutter lints from [analysis_options.yaml](analysis_options.yaml).
- Keep K-prefixed constants in [lib/constant.dart](lib/constant.dart). The lint rule allows this style (`constant_identifier_names: false`).
- Keep existing naming patterns already used by the codebase (including mixed-case legacy folders like `onBoarding`).

## Architecture

This project uses Clean Architecture with Cubit state management.

- Domain layer: `lib/features/[feature]/domains/` for entities and abstract repos.
- Data layer: `lib/features/[feature]/data/` for models and repo implementations.
- Presentation layer: `lib/features/[feature]/presentation/` for views, cubits, and widgets.

Repository methods return `Either<Failure, T>` (no thrown errors from repos). Keep this flow:

1. Services throw `CustomException`
2. Repos map to `Left(Failure)` or `Right(data)`
3. Cubits fold and emit `Initial/Loading/Success/Error` states
4. UI shows errors via [lib/core/helper_functions/build_error_bar.dart](lib/core/helper_functions/build_error_bar.dart)

Use DI registrations from [lib/core/services/get_it_service.dart](lib/core/services/get_it_service.dart). Add new feature dependencies there when needed.

## Build and Test

Preferred local workflow:

```bash
flutter clean && flutter pub get
flutter gen-l10n
dart format lib/
flutter analyze
flutter test
flutter run
```

Build commands used in this repo:

```bash
flutter build apk --debug
```

Do not add `build_runner` steps unless code generation is actually introduced. Current models use manual mapping (`toMap`/factory constructors), not `json_serializable`.

## Conventions

- Add route names as static constants in views and wire routes in [lib/core/helper_functions/on_generate_routes.dart](lib/core/helper_functions/on_generate_routes.dart).
- Localized strings come from ARB files in [lib/l10n](lib/l10n), generated into [lib/generated](lib/generated).
- Keep feature structure complete when adding a new feature: entity + abstract repo + model + repo implementation + cubit/state + view.
- Prefer matching existing patterns in [lib/main.dart](lib/main.dart) for app bootstrap, DI setup, and root providers.

## Project Gotchas

- After editing ARB files, run `flutter gen-l10n`. If analyzer still shows missing `S` keys, rerun diagnostics once before changing code.
- Firebase duplicate-app exceptions can appear during hot reload/restart; handle them consistently with existing initialization in [lib/main.dart](lib/main.dart).
- Keep Android release minification disabled as configured in [android/app/build.gradle.kts](android/app/build.gradle.kts) because TFLite assets are used in `assets/tflite/`.
- Cloudflare worker files ([worker.js](worker.js), [worker-simple.js](worker-simple.js)) are deployed separately from Flutter app builds.

## Key References

- App bootstrap: [lib/main.dart](lib/main.dart)
- DI and services: [lib/core/services/get_it_service.dart](lib/core/services/get_it_service.dart)
- Error model: [lib/core/errors/exception.dart](lib/core/errors/exception.dart), [lib/core/errors/failures.dart](lib/core/errors/failures.dart)
- Routing: [lib/core/helper_functions/on_generate_routes.dart](lib/core/helper_functions/on_generate_routes.dart)
- Dependencies and assets: [pubspec.yaml](pubspec.yaml)
- Localization config: [l10n.yaml](l10n.yaml)
