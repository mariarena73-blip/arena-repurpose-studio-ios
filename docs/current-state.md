# Current State

## Project Structure

The repository currently contains a small native iOS project:

- `ArenaRepurposeStudio.xcodeproj/`: Xcode project and workspace metadata.
- `ArenaRepurposeStudio/`: SwiftUI source files, app entry point, model, theme, voice/copy constants, and storage service.
- `ArenaRepurposeStudio/Assets.xcassets/`: asset catalog with app icon and accent color.
- `ArenaRepurposeStudioTests/`: XCTest target with placeholder tests.
- `ArenaRepurposeStudioUITests/`: UI XCTest target with placeholder tests.
- `BUILD_LOG.md`: historical recovery build log; not the current build state.
- `AGENT_HANDOFF.md`: previous agent handoff notes plus current operating notes.

## Branch And Remote

- Current branch: `master`
- Tracking branch: `origin/master`
- Remote URL: `https://github.com/mariarena73-blip/arena-repurpose-studio-ios.git`
- Local repository and GitHub `origin/master` were aligned before the skill-routing documentation update.
- Last known aligned commit before this documentation update: `94c31d7 Consolidate local SwiftUI repurpose workflow`.
- Commit `b31f6a7 Add project recovery documentation` was also pushed to `origin/master`.
- Working tree was clean before the documentation update.

## Build And Manual Validation Baseline

- The project has a buildable SwiftUI baseline.
- `xcodebuild` succeeded on `iPhone 17 Pro` Simulator after the local SwiftUI repurpose workflow was consolidated.
- The app launched successfully on the simulator and Home showed no anomalies.
- The Prompt tab works: project selection, prompt display, and `Copia` were manually verified.
- The `Nota` action copies the prompt to the pasteboard and opens Comandi Rapidi.
- `Ai Nota Taker` was not installed on the simulator; Comandi Rapidi showed "Il file non esiste".
- The iCloud fallback could not be verified in that simulator case because iOS considered opening Comandi Rapidi successful.

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

- `BUILD_LOG.md`: records a historical failed build and recovery context; treat it as history, not current state.
- `AGENT_HANDOFF.md`: records earlier recovery context and current operational notes; older paths are historical unless repeated in current docs.
- `docs/reusable-skills-found.md`: records reusable app patterns and the Codex skill-routing map for future development.

## Skill Catalog State

- The repository does not contain workspace-local Codex skills.
- Development should use globally installed Codex skills when appropriate.
- The skill map is documentation for agent routing and prompt planning; it is not an app feature and should not be integrated into the SwiftUI runtime.
- Primary development routing is native iOS/SwiftUI first: `build-ios-apps`, SwiftUI UI/refactor/test skills, and GitHub inspection skills.
- Primary content routing is AID repurpose first: transformation, prompt, didactic, social post, visual prompt, concept map, YouTube, Excalidraw, presentation, and blog-support skills.
- Expo, React Native, web deploy, backend, and OpenAI/API skills are out of current scope unless a future task explicitly changes the product direction.

## Future Visual Reference

The PDF `app web corus ios builder app da imitare.pdf` may be used later as inspiration for an advanced dashboard concept with areas such as Overview, Files, Skills, Channels, Connections, Cron jobs, and Terminal.

This is not part of the current app scope. Do not add tabs, screens, or dashboard UI from that reference during the current SwiftUI MVP phase.

## Already Usable

- keep: App shell, tab structure, and SwiftUI navigation concept.
- keep: Local JSON storage approach for an MVP.
- keep: Output taxonomy for educational repurposing formats.
- keep: Prompt-composition concept.
- keep: Current SwiftUI baseline is buildable with local `xcodebuild`.
- keep: Prompt/Shortcut handoff has a verified simulator baseline, with the noted limitation for missing Shortcuts.
- document-only: Existing handoff and build log are useful as historical context.
- document-only: Codex skill routing is useful for planning future work but is not runtime app behavior.
