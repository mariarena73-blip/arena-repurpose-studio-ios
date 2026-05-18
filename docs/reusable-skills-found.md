# Reusable Skills Found

This document lists reusable patterns and Codex skill routing found during the audit.
Nothing here has been migrated into the app, builder, or private skill-library yet.

## Skill Routing Note

The repository does not contain workspace-local skills. Arena Repurpose Studio iOS uses globally installed Codex skills when an agent works on the project.

This map is guidance for Codex prompts and development sessions only. It does not mean these skills should be integrated into the SwiftUI app runtime.
Do not import these skills into Swift files, app targets, templates, model code, storage code, or Xcode project settings.

The app remains a native SwiftUI iPhone project. Do not use Expo, React Native, backend services, or AI APIs unless a future task explicitly changes that scope.

## Primary Skills For iOS Development

| Skill | Function | When to use | When not to use | Risk if used at the wrong time | Recommended phase |
|---|---|---|---|---|---|
| `build-ios-apps` | Native iOS build, simulator, signing, and run workflow guidance. | Use for SwiftUI iOS build/run/test work, preferring local Xcode/XcodeBuildMCP in Codex Desktop unless Vibecode/cloud is explicitly requested. | Do not use as a reason to switch this project to Vibecode/cloud when the task asks for local `xcodebuild`. | May route to the wrong build pipeline or add signing/cloud complexity too early. | ora |
| `build-ios-apps:swiftui-ui-patterns` | SwiftUI UI guidance and platform-native interaction patterns. | Use when refining existing screens, navigation, controls, spacing, accessibility, and iPhone ergonomics. | Do not use to invent new screens or redesign the product without a scoped UI task. | UI drift, over-design, or accidental feature expansion. | ora |
| `build-ios-apps:swiftui-view-refactor` | Focused SwiftUI view decomposition and maintainability. | Use when a view becomes hard to maintain, especially `ProjectDetailView` or `PromptComposerView`. | Do not use during documentation-only work or before behavior is stable. | Refactor churn can hide regressions in working flows. | dopo consolidamento UI |
| `build-ios-apps:test-triage` | Xcode/XCTest failure triage and local test stabilization. | Use when replacing placeholder tests with useful unit/UI smoke tests. | Do not use before deciding which flows deserve test coverage. | Time spent debugging low-value placeholder tests. | dopo test locali |
| `github:github` | Read and compare GitHub repository state, commits, files, and branches. | Use for remote/local alignment checks, diff review, and repository inspection. | Do not use for direct file writes unless the user explicitly asks for GitHub-side edits. | Cloud edits can bypass local build verification. | ora |
| `github:gh-fix-ci` | GitHub Actions/check failure investigation. | Use only if GitHub CI exists and reports failures. | Do not use when there are no CI checks or no failing PR/build. | Wasted debugging path or false CI assumptions. | dopo test locali |

## Primary Skills For AID Repurpose Workflows

| Skill | Function | When to use | When not to use | Risk if used at the wrong time | Recommended phase |
|---|---|---|---|---|---|
| `content-transformer` | Transform raw material into structured outputs. | Use to design or review repurpose behavior for text, transcripts, notes, posts, and lesson material. | Do not wire it as a runtime dependency in the app. | Confusing Codex design guidance with app logic or external AI execution. | ora |
| `skill-chain-master` | Chain multi-step content workflows. | Use for planning end-to-end flows such as capture -> post -> prompt image -> outline. | Do not implement multi-step automation before the local MVP is stable. | Scope creep and premature workflow complexity. | dopo consolidamento UI |
| `aid-agent-codex-docs` | AID-oriented prompt design and agent documentation. | Use to improve prompt quality for didactic and teacher-training use cases. | Do not use to add direct ChatGPT integration. | May imply an API-backed agent architecture that is out of scope. | ora |
| `prompt-generator-for-codex` | Codex prompt generation and evaluation. | Use to create better implementation prompts, testing prompts, and handoff prompts. | Do not embed generated prompts blindly into Swift without review. | Prompt sprawl or inconsistent app microcopy. | ora |
| `perfect-prompt-creator` | Production-ready prompt structure. | Use to harden reusable prompt templates and Shortcut handoff text. | Do not use for every minor copy change. | Over-engineered prompts for simple UI text. | dopo consolidamento UI |
| `rap-post-didattici-skill` | Didactic social post structure. | Use for the `Post Facebook Aid` output style and comment sequences. | Do not use for non-social app screens or storage work. | Output may become too social-specific for generic project types. | ora |
| `pedagogia-applicata-ai-lab` | Converts theory into concrete teaching actions. | Use for classroom-ready outputs, lesson framing, inclusion, and assessment criteria. | Do not use for build, UI, or Git tasks. | Educational content may leak into technical implementation decisions. | ora |
| `mappe-concettuali-scolastiche` | Concept map generation for school contexts. | Use for `Mappa concettuale` output design and validation. | Do not use for general diagrams unrelated to school learning. | Wrong diagram conventions for non-didactic use cases. | dopo consolidamento UI |
| `youtube-researcher` | YouTube search/transcript research workflows. | Use when the product later handles YouTube source material beyond pasted text. | Do not add automated transcript fetching now. | Introduces external services and API-like dependencies too early. | solo con backend/API future |
| `excalidraw-diagrams` | Excalidraw-compatible diagram planning. | Use for `Schema Excalidraw` output format and diagram prompt shape. | Do not add a diagram editor inside the app now. | Premature UI surface and file-format complexity. | dopo consolidamento UI |
| `course-slide-deck-builder` | Course and presentation outline generation. | Use for `Schema presentazione` output design. | Do not add slide export or presentation generation now. | Turns a local prompt app into a deck builder too early. | dopo consolidamento UI |
| `blog-post-seo-optimizer` | Blog post structure and SEO framing. | Use for `Articolo blog Aid` output quality. | Do not optimize app documentation or Swift comments as SEO content. | Misapplied marketing structure in technical docs. | dopo consolidamento UI |
| `aid-brand-imager` | AID-branded image direction. | Use for future branded visual prompts and image style consistency. | Do not generate or bundle new app assets without a visual task. | Asset churn and brand inconsistency. | dopo consolidamento UI |
| `nano-banana-chatgpt-scroll-prompts` | Scroll-stopping image prompt concepts. | Use for `Prompt immagine blocca-scroll` output variants. | Do not assume image generation is part of the app runtime. | Implies external image generation/API integration. | dopo consolidamento UI |
| `visual-discovery-overlay` | Visual critique and overlay strategy. | Use to review future visual references or social graphics. | Do not use to redesign the current tab UI without a UI brief. | Design detours away from core iPhone flow. | dopo consolidamento UI |

## Supporting Skills

| Skill | Function | When to use | When not to use | Risk if used at the wrong time | Recommended phase |
|---|---|---|---|---|---|
| `app-launch-preflight-advisor` | Pre-launch readiness review. | Use before TestFlight, App Store, or external user testing. | Do not use while core local flows are still changing. | Premature launch checklist noise. | dopo test locali |
| `security-threat-model` | Repository-grounded threat modeling. | Use if backend, auth, cloud sync, or external APIs are introduced. | Do not use for the current offline-only MVP unless asked. | Security analysis may assume assets and attackers that do not exist yet. | solo con backend/API future |
| `citation-validator` | Source and citation checking. | Use if educational outputs need verified citations or bibliography. | Do not use for local app mechanics or UI-only work. | Adds research overhead to simple repurpose flows. | dopo consolidamento UI |
| `notebooklm-codex` | NotebookLM source workflow from Codex. | Use if future workflows import NotebookLM sources, YouTube notes, or source collections. | Do not couple the SwiftUI app to NotebookLM now. | Creates cross-tool dependency before product scope is stable. | solo con backend/API future |
| `skill-orchestrator` | Catalog scan and routing across available skills. | Use when planning new phases, checking skill gaps, or deciding the right skill stack. | Do not treat scan output as implementation requirements. | Over-routing simple tasks or installing unnecessary skills. | ora |

## Skills Not Suitable Now

| Skill | Function | When to use | When not to use | Risk if used at the wrong time | Recommended phase |
|---|---|---|---|---|---|
| `expo-monorepo-with-shared-types-and-design-token` | Expo/React Native monorepo guidance. | Never for this repository. | This project is native SwiftUI, not Expo or React Native. | Would move the product onto the wrong stack. | vietata per questo progetto |
| `netlify-deploy` | Web deployment to Netlify. | Only for separate web projects. | Do not use for this iOS app. | Creates irrelevant deployment work. | vietata per questo progetto |
| `vercel-deploy` | Web deployment to Vercel. | Only for separate web apps or web backends. | Do not use for this iOS app now. | Encourages backend/web scope creep. | vietata per questo progetto |
| `cloudflare-deploy` | Cloudflare deployment workflows. | Only if a future backend/worker is explicitly scoped. | Do not use for the offline SwiftUI MVP. | Premature cloud architecture. | solo con backend/API future |
| `openai-docs` | Official OpenAI API/product documentation. | Only if direct OpenAI integration is explicitly approved later. | Do not use for current local prompt/Shortcut flow. | May introduce API assumptions into an offline app. | solo con backend/API future |
| `openai-developers:*` | OpenAI API, Agents, and ChatGPT Apps workflows. | Only for a future approved API/agent integration. | Do not use for local SwiftUI, Shortcut-only handoff, or current template work. | Adds API keys, backend, or agent architecture outside current scope. | solo con backend/API future |

## Future Visual Reference

There is a future visual reference PDF named `app web corus ios builder app da imitare.pdf`.
Treat it only as inspiration for a possible advanced dashboard, not as a current implementation target.

Possible future dashboard areas inspired by that reference:

- Overview
- Files
- Skills
- Channels
- Connections
- Cron jobs
- Terminal

Do not implement this UI now. Do not add new tabs now. Do not modify `MainTabView`. Do not add a Skill screen now.

## Prompt Template From `PromptComposerView`

The prompt generated by `PromptComposerView` contains a reusable educational transformation structure:

- context
- source material
- target output
- Italian language requirement
- clear classroom-oriented structure
- quality criteria

Classification: migrate-to-skill.

Rationale: the template is a reusable content-repurposing behavior that can apply beyond this specific app.

## Output Taxonomy

Detected output taxonomy:

- quiz
- flashcard
- YouTube script
- concept map
- infographic
- free text

Classification: migrate-to-skill and keep-in-app.

Rationale: the taxonomy is part of this app's product domain, but it can also seed reusable prompt or builder workflows.

## Capture -> Classify -> Prompt Pattern

The app flow implies a repeatable pattern:

1. Capture raw material.
2. Classify the desired output format.
3. Generate a structured prompt.

Classification: migrate-to-skill.

Rationale: this pattern is reusable for educational content tools and could become a skill workflow outside this app.

## Day 1 Validation Checklist

The existing `AGENT_HANDOFF.md` includes a practical Day 1 validation checklist:

- app opens to Home
- new content flow opens
- text can be entered
- draft can be saved
- archive lists saved projects
- detail opens saved project
- prompt tab or prompt composer is reachable

Classification: migrate-to-builder.

Rationale: this checklist is less app-specific than it first appears. It can help the local builder validate generated SwiftUI MVP apps.

## Lessons From `BUILD_LOG.md`

The build log captures recurring Swift issues:

- views referencing missing model types
- generated views depending on enum cases that do not exist
- model/view drift after partial fixes
- `ObservableObject` requiring explicit `import Combine` in the recorded environment
- handoff docs becoming stale when paths or build state change

Classification: document-only and migrate-to-builder.

Rationale: these lessons should inform future builder guardrails and documentation, but they should not become app runtime code.

## App-Specific Pieces To Keep In The App

- SwiftUI screens
- local project archive
- project detail/edit behavior
- app theme
- app microcopy
- app-specific persistence model once stabilized

Classification: keep-in-app.

Rationale: these define the product experience and should not be extracted prematurely.
