# Technical Debt

## Model And View Mismatch

The highest-priority debt is the mismatch between `Project`, `ProjectType`, `EditorialStatus`, and the SwiftUI views.

Current model shape in `Project.swift`:

- `Project.type`
- `Project.status`
- `Project.contentItems`
- `Project.lastContent`
- `ProjectType` with quiz, flashcard, YouTube script, concept map, infographic, and text.
- `EditorialStatus` with draft, review, and published.

Current view expectations include:

- `project.rawContent`
- `project.projectType`
- `project.displayTitle`
- `project.projectType.promptContext`
- `status` cases such as `.bozza`, `.daRivedere`, `.daPubblicare`, `.pubblicato`, and `.archiviato`

Classification: refactor.

## Missing Enum Cases

`AIDTheme.swift` expects `EditorialStatus` cases that do not exist in the current model:

- `.bozza`
- `.daRivedere`
- `.daPubblicare`
- `.pubblicato`
- `.archiviato`

The model currently defines:

- `.draft`
- `.review`
- `.published`

Classification: refactor.

## Missing Properties And Helpers

The SwiftUI views reference properties or helpers that are not present in the current model:

- `rawContent`
- `projectType`
- `displayTitle`
- `promptContext`

These should be resolved by choosing a single canonical data model and updating the views or adding explicit computed compatibility properties.

Classification: refactor.

## Missing Microcopy Constants

Some views reference copy constants that are not present in `AIDVoice.swift`:

- `AIDVoice.Capture.saved`
- `AIDVoice.Detail.save`
- `AIDVoice.PromptComposer.copied`

Classification: refactor.

## `EditorialStatus.color` Collision

There are two separate `EditorialStatus.color` concepts:

- `Project.swift` defines `color` as a `String`.
- `AIDTheme.swift` defines `color` as a SwiftUI `Color`.

This creates an API collision and unclear ownership. Status presentation color should live in the UI/theme layer, while serializable status data should remain in the model.

Classification: refactor.

## Deployment Target 26.0

The Xcode project currently includes `IPHONEOS_DEPLOYMENT_TARGET = 26.0`.

This is likely too restrictive for practical simulator and device coverage during MVP development. It should be reviewed before serious validation.

Classification: refactor.

## Placeholder Tests

Unit tests and UI tests are generated placeholders. They do not currently verify:

- model encoding/decoding
- storage save/load/delete behavior
- create content -> archive -> detail flow
- prompt generation output

Classification: refactor.

## Xcode Toolchain Selection

`xcodebuild -list -project ArenaRepurposeStudio.xcodeproj` could not run because the active developer directory points to:

`/Library/Developer/CommandLineTools`

The command requires full Xcode selection before local Xcode build verification can be trusted.

Classification: document-only until the toolchain is intentionally changed.

## JSON Persistence Risks

`ProjectStorageService` persists `[Project]` to `aid_projects.json` with `try?` for encoding, writing, reading, and decoding.

Risks:

- write failures are silent
- corrupt JSON is silently ignored
- schema changes can break existing data
- no migration path exists
- no recovery or backup strategy exists

Classification: refactor before any persistent real-user data matters.
