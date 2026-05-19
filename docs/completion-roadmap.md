# Completion Roadmap

This roadmap starts from the current verified remote baseline: `af68fcb Realign repurpose workflow model and prompt composer` on `origin/master`. The native SwiftUI app builds locally with `xcodebuild`, targeted unit tests pass, and the Prompt/Nota handoff has been manually checked on the `iPhone 17 Pro` Simulator.

The roadmap still avoids backend, direct AI APIs, Expo, React Native, and new product surfaces until local iPhone flows and tests are intentionally expanded.

## Phase 1: Recover Build Baseline

Status: completed.

Completed work:

- Consolidated the SwiftUI data model, views, local JSON storage, AID theme, microcopy, and repurpose templates.
- Verified the app with `xcodebuild` on `iPhone 17 Pro` Simulator.
- Pushed the consolidated baseline to `origin/master` in commit `94c31d7 Consolidate local SwiftUI repurpose workflow`.

Classification: completed baseline.

## Phase 2: Normalize Git And Recovery Documentation

Status: completed.

Completed work:

- Added recovery documentation and repository notes.
- Pushed `b31f6a7 Add project recovery documentation` to `origin/master`.
- Confirmed `master` was aligned with `origin/master` before later documentation baselines.

Classification: completed documentation baseline.

## Phase 3: Document Post-Push Test And Skill Routing

Status: completed.

Completed work:

- Record that the app launches correctly and Home shows no anomalies.
- Record that the Prompt tab shows the prompt, `Copia` works, and `Nota` copies the prompt before opening Comandi Rapidi.
- Record the current Shortcut handoff baseline, with Comandi Rapidi opening correctly and the URL/fallback values kept unchanged.
- Keep the skill map in `docs/reusable-skills-found.md` as Codex routing guidance, not runtime app behavior.

Classification: completed documentation baseline.

## Phase 4: Realign Repurpose Workflow Model And Prompt Composer

Status: completed.

Completed work:

- Pushed `af68fcb Realign repurpose workflow model and prompt composer` to `origin/master`.
- Added `SourceKind`, `RepurposeContext`, `RepurposeAudience`, `RepurposeVoice`, and `RepurposeOutput`.
- Extended `Project` with new repurpose workflow fields.
- Added the legacy decoder for older saved drafts.
- Added temporary `RepurposeOutput` -> `ProjectType` mapping.
- Updated `NewContentView`, `QuickCaptureView`, `PromptComposerView`, and `ProjectDetailView`.
- Updated `ArenaRepurposeStudioTests`.

Validation:

- `xcodebuild build` on `iPhone 17 Pro` Simulator: `BUILD SUCCEEDED`.
- `xcodebuild test` only `ArenaRepurposeStudioTests`: `TEST SUCCEEDED`.
- Minimal manual test on `iPhone 17 Pro` Simulator: `SUCCEEDED`.
- `Copia` works.
- `Nota` works.
- Comandi Rapidi opens correctly.
- URL Shortcut unchanged: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- iCloud fallback unchanged: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.

Known limit:

- Full `xcodebuild test` for the scheme was not rerun because the UI runner was already known as unstable. Treat that as a separate task.

Recommended skill support:

- `skill-orchestrator` for skill catalog/routing checks.
- `github:github` for read-only local/remote alignment checks.
- `build-ios-apps` for local simulator and Xcode workflow checks.

Classification: completed code baseline.

## Phase 5: Add Targeted Local Tests

Status: next step / priority 1.

Recommended tests:

- `Project` encode/decode round trip.
- Legacy `Project` decode coverage for pre-`af68fcb` saved drafts.
- `SourceKind`, `RepurposeContext`, `RepurposeAudience`, `RepurposeVoice`, and `RepurposeOutput` display/prompt behavior.
- `RepurposeOutput` -> `ProjectType` temporary mapping.
- Master prompt content checks for source, context, audience, tone, output, structure, quality criteria, Italian language, no invented data, and insufficient-information handling.
- `ProjectStorageService` save/load/delete behavior with an injectable file URL or test-safe storage boundary.
- UI smoke test for app launch.
- UI smoke test for create content -> archive -> detail -> prompt.

Recommended skill support:

- `build-ios-apps:test-triage` for XCTest and UI test failure analysis.
- `build-ios-apps:swiftui-view-refactor` only when testability requires focused view cleanup.

Classification: local test hardening.

## Phase 6: Stabilize ProjectStorageService

Status: next step / priority 2.

Recommended work:

- Make storage tests deterministic.
- Improve error visibility without introducing backend or networking.
- Keep persistence local and JSON-based until a future task explicitly changes scope.

Classification: local storage hardening.

## Phase 7: Consolidate AID Repurpose Quality

Status: priority 3 after targeted tests and storage stabilization.

Recommended work:

- Review prompt and template language against AID didactic use cases.
- Keep transformations local and copy/Shortcut-based unless a future task explicitly approves API integration.
- Use the skill map in `docs/reusable-skills-found.md` to choose the right Codex helper for each output type.
- Prioritize `content-transformer`, `aid-agent-codex-docs`, `prompt-generator-for-codex`, `rap-post-didattici-skill`, and `pedagogia-applicata-ai-lab`.

Classification: keep-in-app and documentation-guided.

## Phase 8: Small SwiftUI UI Improvements

Status: priority 4 after tests and storage.

Recommended work:

- Make small, focused SwiftUI improvements only after the model, prompt, and storage tests are stable.
- Keep existing tab structure and avoid new product surfaces unless a separate UI task scopes them.
- Do not modify `MainTabView` as part of this roadmap step.

Classification: future UI polish.

## Phase 9: Evaluate Backend Or API Integrations Later

Status: future only.

Only after local tests and prompt quality are stable:

- Evaluate whether prompt composition remains local or calls an AI API.
- Evaluate whether a backend is needed.
- Evaluate whether builder automation can generate this app pattern.
- Evaluate which patterns should migrate to the private skill-library.
- Use `security-threat-model`, `openai-docs`, and `openai-developers:*` only if backend/API work is explicitly approved.

Classification: future decision; not current scope.

## Phase 10: Future Dashboard Inspiration

Status: future design reference only.

The PDF `app web corus ios builder app da imitare.pdf` can inspire a future advanced dashboard with areas such as Overview, Files, Skills, Channels, Connections, Cron jobs, and Terminal.

Do not implement this UI now. Do not add new tabs. Do not modify `MainTabView`. Do not add a Skill screen until a separate UI task scopes it.

Classification: future design reference.
