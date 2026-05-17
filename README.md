# Arena Repurpose Studio iOS

Technical, provisional README for the current pilot app repository.

## Purpose

Arena Repurpose Studio is a native iOS prototype for capturing educational content ideas and turning them into reusable output formats such as quizzes, flashcards, YouTube scripts, concept maps, infographics, and free-form text prompts.

This repository is currently used as the first pilot app for the local iOS app builder workflow.

## Current Status

- Branch: `master`
- Remote: `origin` -> `https://github.com/mariarena73-blip/arena-repurpose-studio-ios.git`
- App code has been recovered from `origin/master`.
- The repository contains a SwiftUI MVP structure, but the app is not yet considered build-stable.
- Known technical mismatches remain between the data model and the SwiftUI views.
- Existing tests are placeholders.

## Technical Stack Detected

- Native iOS
- SwiftUI
- Combine / `ObservableObject`
- Local JSON persistence in the app document directory
- Xcode project
- XCTest and UI XCTest targets

No React Native, Expo, SwiftData, backend, or AI service integration was detected in the app code.

## Repository Structure

- `ArenaRepurposeStudio.xcodeproj/`: Xcode project.
- `ArenaRepurposeStudio/`: SwiftUI app source files, model, theme, copy, and local storage service.
- `ArenaRepurposeStudio/Assets.xcassets/`: app icon and asset catalog.
- `ArenaRepurposeStudioTests/`: unit test target with placeholder tests.
- `ArenaRepurposeStudioUITests/`: UI test target with placeholder launch tests.
- `BUILD_LOG.md`: existing build log and known Swift compiler issues.
- `AGENT_HANDOFF.md`: existing handoff notes from the previous build session.
- `docs/`: internal state, debt, roadmap, and reusable-skill notes.

## Existing Documentation

- `BUILD_LOG.md` documents a failed build session and records known Swift errors.
- `AGENT_HANDOFF.md` describes the intended Day 1 recovery workflow, but includes older paths that should not be treated as current operating paths.
- The `docs/` files in this repository are the current internal audit documentation.

## Do Not Do Yet

- Do not modify Swift files until the model/UI alignment is intentionally planned.
- Do not modify the Xcode project until the build stabilization step is scoped.
- Do not add AI, backend, or automation features yet.
- Do not import local skill-library assets into this app repository.
- Do not change branch, rename the repository, commit, or push as part of documentation-only work.
- Do not treat the current placeholder tests as meaningful coverage.

## Next Operating Flow

1. Use `docs/current-state.md` to confirm the recovered app structure.
2. Use `docs/technical-debt.md` to scope the build-breaking issues.
3. Stabilize the data model and SwiftUI references before feature work.
4. Rebuild only after the local Xcode toolchain is correctly selected.
5. Validate the local MVP flow: create content -> archive -> detail -> prompt.
6. Update documentation after a verified build, then decide what belongs in the builder or skill-library.

## Relationship With `ios-app-builder`

This app is the first pilot case for:

`/Users/mariangela/LocalWorkspaces/ios-app-builder`

The builder should remain separate. This repository can provide observations and reusable workflow lessons, but the builder must not be modified from this app documentation pass.

## Relationship With `skill-library`

The private local skill library remains at:

`/Users/mariangela/LocalWorkspaces/skill-library`

Some patterns found in this app may later be candidates for skills, especially prompt templates and validation checklists. They should be documented first and migrated only through an explicit future step. No skill files should be imported into this app repository.
