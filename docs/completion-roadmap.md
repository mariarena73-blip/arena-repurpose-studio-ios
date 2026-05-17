# Completion Roadmap

This roadmap intentionally avoids new product features until the recovered app is build-stable and the local MVP flow works.

## Phase 1: Stabilize Data Model And Compile

Goal: make the app compile without changing the product scope.

Recommended work:

- Choose one canonical shape for `Project`.
- Align `ProjectType` naming and computed helpers with all views.
- Align `EditorialStatus` cases with the UI.
- Resolve missing properties such as `rawContent`, `projectType`, `displayTitle`, and `promptContext`.
- Resolve the `EditorialStatus.color` collision.
- Review deployment target `26.0`.
- Verify the build only after full Xcode is selected locally.

Classification: refactor.

## Phase 2: Realign Microcopy And `AIDVoice`

Goal: make UI copy references complete and centralized.

Recommended work:

- Add or rename missing copy constants.
- Keep user-facing strings in `AIDVoice` where practical.
- Decide whether status labels are stored as enum raw values or presentation copy.
- Keep app-specific microcopy in the app, not in the builder or skill-library.

Classification: keep-in-app.

## Phase 3: Validate Local MVP Flow

Goal: confirm the app can complete the core offline loop.

Validation flow:

1. Create content.
2. Save as draft.
3. See it on Home.
4. Open Archive.
5. Open Detail.
6. Generate or copy Prompt.

This should be validated before adding AI, backend, authentication, or automations.

Classification: keep-in-app.

## Phase 4: Improve Minimal Tests

Goal: replace placeholder tests with a small safety net.

Recommended tests:

- `Project` encode/decode round trip.
- `ProjectType` prompt-context behavior if kept in model.
- `ProjectStorageService` save/load/delete behavior with an injectable file URL.
- UI smoke test for app launch.
- UI smoke test for create content -> archive.

Classification: refactor.

## Phase 5: Evaluate AI, Backend, Or Automations Later

Goal: avoid adding infrastructure before the local MVP is stable.

Only after Phases 1-4:

- Evaluate whether prompt composition remains local or calls an AI API.
- Evaluate whether a backend is needed.
- Evaluate whether builder automation can generate this app pattern.
- Evaluate which patterns should migrate to the private skill-library.

Classification: document-only for now.
