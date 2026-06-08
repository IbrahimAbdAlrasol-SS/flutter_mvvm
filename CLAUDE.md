# CLAUDE.md

> **STOP. Before doing anything, read `LLM.md` completely.**
> `LLM.md` is the single source of truth for this project.
> It overrides everything else, including this file.

---

## How to start every task

1. Read `LLM.md` from top to bottom — no skipping.
2. Say "I have read LLM.md and will follow its rules."
3. Then proceed with the task.

`LLM.md` contains:
- The exact folder structure for every file you will create
- Copy-pasteable code templates for every layer
- The complete shared widget API
- Forbidden patterns with examples of wrong vs right code
- The 8-step checklist for every new feature

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Run `build_runner` after any change to `@freezed`, `@RestApi`, `@riverpod`, or `@TypedGoRoute`.
