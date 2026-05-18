# Completion Roadmap

This roadmap starts from the current verified baseline: the native SwiftUI app builds locally with `xcodebuild`, the `master` branch is aligned with `origin/master`, and the Prompt/Nota handoff has been manually checked on the `iPhone 17 Pro` Simulator.

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
- Confirmed `master` is aligned with `origin/master` before the current skill-routing documentation update.

Classification: completed documentation baseline.

## Phase 3: Document Post-Push Test And Skill Routing

Status: in progress.

Current documentation work:

- Record that the app launches correctly and Home shows no anomalies.
- Record that the Prompt tab shows the prompt, `Copia` works, and `Nota` copies the prompt before opening Comandi Rapidi.
- Record that `Ai Nota Taker` was missing on the simulator, producing "Il file non esiste"; the iCloud fallback could not be verified because iOS considered opening Comandi Rapidi successful.
- Keep the skill map in `docs/reusable-skills-found.md` as Codex routing guidance, not runtime app behavior.

Recommended skill support:

- `skill-orchestrator` for skill catalog/routing checks.
- `github:github` for read-only local/remote alignment checks.
- `build-ios-apps` for local simulator and Xcode workflow checks.

Classification: documentation-only.

## Phase 4: Add Small Local Tests

Status: next step.

Recommended tests:

- `Project` encode/decode round trip.
- `ProjectType` display name and prompt-context behavior.
- `ProjectStorageService` save/load/delete behavior with an injectable file URL or test-safe storage boundary.
- UI smoke test for app launch.
- UI smoke test for create content -> archive -> detail -> prompt.

Recommended skill support:

- `build-ios-apps:test-triage` for XCTest and UI test failure analysis.
- `build-ios-apps:swiftui-view-refactor` only when testability requires focused view cleanup.

Classification: local test hardening.

## Phase 5: Consolidate AID Repurpose Quality

Status: future local improvement.

Recommended work:

- Review prompt and template language against AID didactic use cases.
- Keep transformations local and copy/Shortcut-based unless a future task explicitly approves API integration.
- Use the skill map in `docs/reusable-skills-found.md` to choose the right Codex helper for each output type.
- Prioritize `content-transformer`, `aid-agent-codex-docs`, `prompt-generator-for-codex`, `rap-post-didattici-skill`, and `pedagogia-applicata-ai-lab`.

Classification: keep-in-app and documentation-guided.

## Phase 6: Evaluate Backend Or API Integrations Later

Status: future only.

Only after local tests and prompt quality are stable:

- Evaluate whether prompt composition remains local or calls an AI API.
- Evaluate whether a backend is needed.
- Evaluate whether builder automation can generate this app pattern.
- Evaluate which patterns should migrate to the private skill-library.
- Use `security-threat-model`, `openai-docs`, and `openai-developers:*` only if backend/API work is explicitly approved.

Classification: future decision; not current scope.

## Phase 7: Future Dashboard Inspiration

Status: future design reference only.

The PDF `app web corus ios builder app da imitare.pdf` can inspire a future advanced dashboard with areas such as Overview, Files, Skills, Channels, Connections, Cron jobs, and Terminal.

Do not implement this UI now. Do not add new tabs. Do not modify `MainTabView`. Do not add a Skill screen until a separate UI task scopes it.

Classification: future design reference.
