# Current State

## Project Structure

The repository currently contains a small native iOS project:

- `ArenaRepurposeStudio.xcodeproj/`: Xcode project and workspace metadata.
- `ArenaRepurposeStudio/`: SwiftUI source files, app entry point, model, theme, voice/copy constants, and storage service.
- `ArenaRepurposeStudio/Assets.xcassets/`: asset catalog with app icon and accent color.
- `ArenaRepurposeStudioTests/`: XCTest target with placeholder tests.
- `ArenaRepurposeStudioUITests/`: UI XCTest target with placeholder tests.
- `BUILD_LOG.md`: previous build log and known Swift compiler errors.
- `AGENT_HANDOFF.md`: previous agent handoff notes.

## Branch And Remote

- Current branch: `master`
- Tracking branch: `origin/master`
- Remote URL: `https://github.com/mariarena73-blip/arena-repurpose-studio-ios.git`
- Working tree was clean before the documentation update.

## Main Files

- `ArenaRepurposeStudioApp.swift`: app entry point, creates `ProjectStorageService`, injects it as an environment object, and forces dark color scheme.
- `ContentView.swift`: defines `MainTabView` with Home, Archive, and Prompt tabs.
- `HomeView.swift`: shows recent projects and opens the new-content flow.
- `NewContentView.swift`: lets the user choose an output format.
- `QuickCaptureView.swift`: captures text and saves a draft project.
- `ArchiveView.swift`: lists saved projects and filters by editorial status.
- `ProjectDetailView.swift`: displays and edits a project, and opens prompt composition.
- `PromptComposerView.swift`: generates a structured educational prompt from a project.
- `Project.swift`: contains `ProjectType`, `EditorialStatus`, `ContentItem`, and `Project`.
- `ProjectStorageService.swift`: local JSON persistence service.
- `AIDTheme.swift`: app colors, typography, spacing, and corner constants.
- `AIDVoice.swift`: app microcopy constants and relative date formatting.

## SwiftUI Screens Present

- `MainTabView`: root tab navigation.
- `HomeView`: landing screen inside the app experience.
- `NewContentView`: format selection.
- `QuickCaptureView`: text capture and draft save.
- `ArchiveView`: saved project archive.
- `ProjectDetailView`: project content detail and edit surface.
- `PromptComposerView`: prompt generation surface and empty state.

## Data Models Present

- `ProjectType`: output taxonomy for quiz, flashcard, YouTube script, concept map, infographic, and free text.
- `EditorialStatus`: current model version includes draft, review, and published states.
- `ContentItem`: stores body, type, and creation date for a content unit.
- `Project`: stores title, description, type, status, tags, content items, and timestamps.

## Services Present

- `ProjectStorageService`: an `ObservableObject` that keeps `projects` in memory, loads JSON from the app document directory, and persists changes to `aid_projects.json`.

The service is appropriate for an MVP, but it currently has silent error handling and no schema migration strategy.

## Existing Documentation

- `BUILD_LOG.md`: records a failed build and known Swift issues from a previous session.
- `AGENT_HANDOFF.md`: records intended next actions and operational rules, but contains older paths that should be corrected later.

## Already Usable

- keep: App shell, tab structure, and SwiftUI navigation concept.
- keep: Local JSON storage approach for an MVP.
- keep: Output taxonomy for educational repurposing formats.
- keep: Prompt-composition concept.
- refactor: Model/view integration before compilation can be trusted.
- document-only: Existing handoff and build log are useful as historical context.
