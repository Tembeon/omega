# Repository Guidelines

## Project Structure & Module Organization
Omega is a Dart Discord bot. Runtime entrypoint in `bin/bot.dart`; generated binaries land in `bin/`. The reusable services, data, and constants live under `lib/core`, while command-specific flows sit in `lib/features`. Localization assets reside in `lib/core/l10n` (ARB sources in `arb/`, generated Dart output in `generated/`). Shared tooling and Docker configs are in the root (`Taskfile.yml`, `compose.yml`, `Dockerfile`). Tests belong in `test/`, mirroring the library paths.

## Build, Test, and Development Commands
Run `dart pub get` after dependency or version changes. Use `dart run bin/bot.dart` for local smoke checks with your env vars loaded. Enforce static analysis with `dart analyze` before opening a PR. Execute the suite using `dart test`; add `--coverage` locally when checking critical flows. Build a distributable with `dart build exe bin/bot.dart`. For localization workflows, `task arb:export` pulls strings from code and `task arb:import -- <locale>` regenerates translated Dart files.

## Coding Style & Naming Conventions
Formatting follows `dart format` defaults (two-space indentation, trailing commas where sensible). Stick to `package:lints/recommended` plus the stricter rules defined in `analysis_options.yaml`: avoid `dynamic`, prefer `final`, use single quotes, and keep zero unbounded catches. Name files with `snake_case.dart`, classes with `PascalCase`, and variables/functions with `camelCase`. Keep domain logic deterministic; extract Discord API calls into injectable services for easier testing.

## Testing Guidelines
Write tests with `package:test` and place them under `test/`, using the `<subject>_test.dart` pattern (see `test/lfg_bot_test.dart`). Cover new commands and error paths, especially around guild configuration and localization. Stub outbound Discord interactions; do not hit the network in tests. Run `dart test` before pushing and ensure new modules ship with matching test coverage.

## Commit & Pull Request Guidelines
Follow the existing history: lowercase semantic prefixes (`feat:`, `fixes:`, `docs:`), concise summary, and reference issues or PR numbers (e.g., `feat: roles QoL (closes #43)`). Each PR should: detail the behavior change, list verification steps (`dart analyze`, `dart test`), attach screenshots or logs for user-facing command updates, and call out any migrations or env var impacts. Keep commits focused; avoid bundling unrelated fixes.
