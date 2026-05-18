# BUILD LOG — Arena Repurpose Studio iOS

## Stato corrente verificato — 2026-05-18

### Stato: BASELINE BUILDABILE

Le build fallite registrate piu' sotto appartengono allo storico di recupero iniziale. Non rappresentano lo stato corrente del progetto.

Baseline corrente:

- Progetto SwiftUI nativo con Xcode project esistente.
- Workflow operativo corrente: Codex Desktop locale, Xcode project, `xcodebuild` locale quando richiesto.
- `xcodebuild` riuscito su `iPhone 17 Pro` Simulator.
- Branch `master` allineato con `origin/master` dopo il commit remoto `bb38eb8 Document iOS Creator skill routing for Aid Repurpose`.
- Nessun Expo, React Native, backend, API AI, App Intents o Share Extension introdotti.

Verifica manuale Prompt/Nota su `iPhone 17 Pro` Simulator:

- App avviata correttamente.
- Home senza anomalie.
- Tab Prompt funzionante.
- Prompt visualizzato correttamente.
- `Copia` funzionante: il prompt viene copiato negli appunti.
- `Nota` funzionante per handoff: copia il prompt negli appunti e apre Comandi Rapidi.
- Limite noto: se `Ai Nota Taker` non e' installato, Comandi Rapidi puo' mostrare "Il file non esiste". In quel caso il fallback iCloud interno all'app non scatta perche' iOS considera riuscita l'apertura dell'app Comandi Rapidi.

Nota workflow:

- Vibecode/`ios-cli` resta storico in questo repository, oppure valido solo se richiesto esplicitamente e configurato.
- Per i task correnti in Codex Desktop locale, preferire SwiftUI nativo + Xcode project + `xcodebuild` quando viene richiesta una build.

---

## Sessione storica 2026-05-16

### Stato: BUILD FALLITA — errori Swift da risolvere

---

## Job ID ultima build
```
e097aff4-c094-4194-9038-92ad506ea06e
```

## Errori Swift (compiler errors)

```
AIDTheme.swift:12: error: cannot find type 'EditorialStatus' in scope
ArchiveView.swift:5: error: cannot find type 'EditorialStatus' in scope
HomeView.swift:116: error: cannot find type 'EditorialStatus' in scope
NewContentView.swift:8: error: cannot find type 'ProjectType' in scope
NewContentView.swift:12-17: error: cannot infer contextual base in reference to member 'quiz' / 'flashcard' / 'youtubeScript' / 'conceptMap' / 'infographic'
NewContentView.swift:25: error: cannot find type 'ProjectType' in scope
ProjectDetailView.swift:8: error: cannot find type 'EditorialStatus' in scope
QuickCaptureView.swift:7,11,15: error: cannot find type 'ProjectType' in scope
```

## Causa root

Le view root-level (generate dal sistema durante la sessione) usano due enum non definiti:
- `ProjectType` — casi: `.quiz`, `.flashcard`, `.youtubeScript`, `.conceptMap`, `.infographic`, `.text`
- `EditorialStatus` — casi: `.draft`, `.review`, `.published`

`Project.swift` contiene solo `ContentType` (testo/idea/voice) — non basta.

## Fix già preparato (NON ancora committato)

`Project.swift` è stato aggiornato in locale con:
```swift
enum ProjectType: String, Codable, CaseIterable, Identifiable { ... }
enum EditorialStatus: String, Codable, CaseIterable, Identifiable { ... }
struct ContentItem { var type: ProjectType ... }
struct Project { var type: ProjectType; var status: EditorialStatus ... }
```

`AIDVoice.swift` è stato riscritto con struttura nested:
```swift
enum AIDVoice {
    enum App { static let name, tagline }
    enum Home { static let recentProjects, noRecentProjects, newContent, goToArchive }
    enum Archive { static let title, empty, filterAll }
    enum Capture { static let titleField, placeholder, outputType, saveAsDraft }
    enum NewContent { static let title, subtitle }
    enum Detail { static let content, createdAt, edit, composePrompt }
    enum PromptComposer { static let title, intro, copy }
}
```

## Prossimo step

1. Verificare che `Project.swift` e `AIDVoice.swift` locali siano corretti
2. Rezip e rebuild: `./ios-cli build /tmp/arena-repurpose-studio.zip`
3. Se altri errori → `./ios-cli logs <jobId>` → fix → rebuild
4. Quando build OK → `./ios-cli` emette `previewUrl` → test Day 1

---

## File Swift presenti nel progetto (root)

| File | Stato |
|------|-------|
| `ArenaRepurposeStudioApp.swift` | ✅ No SwiftData, usa `ProjectStorageService` |
| `ContentView.swift` | ✅ `MainTabView` con 3 tab: Home / Archivio / Prompt |
| `Project.swift` | 🔄 Aggiornato in locale, NON committato |
| `ProjectStorageService.swift` | ✅ JSON su documentDirectory, ObservableObject |
| `AIDTheme.swift` | ✅ Colori: aidDeepBlue, aidPurpleBlue, ecc. |
| `AIDVoice.swift` | 🔄 Riscritto in locale con nested enum, NON committato |
| `HomeView.swift` | ✅ |
| `NewContentView.swift` | ✅ (dipende da ProjectType) |
| `QuickCaptureView.swift` | ✅ (dipende da ProjectType) |
| `ArchiveView.swift` | ✅ (dipende da EditorialStatus) |
| `ProjectDetailView.swift` | ✅ (dipende da EditorialStatus) |
| `PromptComposerView.swift` | ✅ stub |
