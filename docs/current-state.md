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
- Current remote baseline: `af68fcb Realign repurpose workflow model and prompt composer`.
- Full baseline commit: `af68fcbd0b5382432785c08ecf0ac60d1f5dfd66`.
- The repurpose workflow/model/prompt-composer micro-task has been pushed to `origin/master`.
- Working tree was clean after the code baseline push.

## Build And Manual Validation Baseline

- The project has a buildable SwiftUI baseline.
- `xcodebuild build` on `iPhone 17 Pro` Simulator: `BUILD SUCCEEDED`.
- `xcodebuild test` with `-only-testing:ArenaRepurposeStudioTests` on `iPhone 17 Pro` Simulator: `TEST SUCCEEDED`.
- Minimal manual test on `iPhone 17 Pro` Simulator: `SUCCEEDED`.
- The app launched successfully on the simulator and the new-content flow opened correctly.
- A draft project was created from pasted source text with Scuola, BES, Prof Arena, Materiale didattico Markdown, and notes.
- The project was visible in Home, opened in detail, and showed the new metadata.
- Prompt composition was verified with source, text, context, audience, tone, output, Italian language, expected structure, quality criteria, no invented data, and a request to report insufficient information.
- `Copia` works.
- `Nota` works and opens Comandi Rapidi correctly.
- URL Shortcut unchanged: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- iCloud fallback unchanged: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
- Known limit: full `xcodebuild test` for the scheme was not rerun because the UI runner was already known as unstable. Treat that as a separate task.

## Main Files

- `ArenaRepurposeStudioApp.swift`: app entry point, creates `ProjectStorageService`, injects it as an environment object, and forces dark color scheme.
- `ContentView.swift`: defines `MainTabView` with Home, Archive, and Prompt tabs.
- `HomeView.swift`: shows recent projects and opens the new-content flow.
- `NewContentView.swift`: starts the aligned repurpose workflow with source, context, audience, voice, output, and notes metadata.
- `QuickCaptureView.swift`: captures source text and saves a draft project with the aligned repurpose metadata.
- `ArchiveView.swift`: lists saved projects and filters by editorial status.
- `ProjectDetailView.swift`: displays the project, aligned repurpose metadata, and prompt entry point.
- `PromptComposerView.swift`: generates the master prompt and keeps the Shortcut handoff controls visible.
- `Project.swift`: contains `ProjectType`, `EditorialStatus`, `SourceKind`, `RepurposeContext`, `RepurposeAudience`, `RepurposeVoice`, `RepurposeOutput`, `ContentItem`, and `Project`.
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
- `SourceKind`: source taxonomy for pasted text, transcript, notes, lesson material, raw idea, and other source types.
- `RepurposeContext`: local context options for school, social, training, business, personal brand, and other use cases.
- `RepurposeAudience`: target audience options for teacher, student, family, colleagues, clients, social audience, and other recipients.
- `RepurposeVoice`: tone options including Prof Arena, didactic, inspirational, technical, simple, and direct.
- `RepurposeOutput`: aligned output taxonomy for Markdown didactic material, social post, carousel outline, video script, concept map, checklist, summary, and other outputs.
- `ContentItem`: stores body, type, and creation date for a content unit.
- `Project`: stores title, description, type, status, tags, content items, timestamps, source kind, source text, context, audience, voice, desired output, and optional notes.
- `Project` includes a legacy decoder for previously saved drafts and a temporary `RepurposeOutput` -> `ProjectType` mapping.

## Services Present

- `ProjectStorageService`: an `ObservableObject` that keeps `projects` in memory, loads JSON from the app document directory, and persists changes to `aid_projects.json`.

The service is appropriate for an MVP, but it currently has silent error handling and no schema migration strategy.

## Existing Documentation

- `BUILD_LOG.md`: records the current `af68fcb` validation baseline plus historical failed build and recovery context.
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
- keep: Prompt/Shortcut handoff has a verified simulator baseline with `Copia`, `Nota`, URL Shortcut, and iCloud fallback values confirmed unchanged.
- document-only: Existing handoff and build log are useful as historical context.
- document-only: Codex skill routing is useful for planning future work but is not runtime app behavior.

## Next Recommended Steps

Priority 1: add more targeted local tests for the new model and master prompt.

Priority 2: stabilize `ProjectStorageService`.

Priority 3: consolidate local templates and the master prompt.

Priority 4: make small SwiftUI UI improvements only after tests and storage are stable.
