# BUILD LOG — Arena Repurpose Studio iOS

## Stato corrente verificato — 2026-05-19

### Stato: BASELINE REMOTA BUILDABILE

Le build fallite registrate piu' sotto appartengono allo storico di recupero iniziale. Non rappresentano lo stato corrente del progetto.

Baseline corrente:

- Progetto SwiftUI nativo con Xcode project esistente.
- Workflow operativo corrente: Codex Desktop locale, Xcode project, `xcodebuild` locale quando richiesto.
- Branch `master` allineato con `origin/master` dopo il commit remoto `af68fcb Realign repurpose workflow model and prompt composer`.
- Il commit remoto completo della baseline corrente e' `af68fcbd0b5382432785c08ecf0ac60d1f5dfd66`.
- Nessun Expo, React Native, backend, API AI, App Intents o Share Extension introdotti.

Riallineamento workflow/model/prompt composer:

- Aggiunti `SourceKind`, `RepurposeContext`, `RepurposeAudience`, `RepurposeVoice`, `RepurposeOutput`.
- `Project` esteso con nuovi campi per sorgente, contesto, destinatari, voce, output e note.
- Decoder legacy aggiunto per mantenere compatibilita' con bozze salvate prima del nuovo modello.
- Mapping temporaneo `RepurposeOutput` -> `ProjectType` aggiunto.
- `NewContentView`, `QuickCaptureView`, `PromptComposerView` e `ProjectDetailView` aggiornate.
- Test aggiornati in `ArenaRepurposeStudioTests`.

Validazioni completate su `iPhone 17 Pro` Simulator:

- `xcodebuild build -project ArenaRepurposeStudio.xcodeproj -scheme ArenaRepurposeStudio -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`: `BUILD SUCCEEDED`.
- `xcodebuild test -project ArenaRepurposeStudio.xcodeproj -scheme ArenaRepurposeStudio -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:ArenaRepurposeStudioTests`: `TEST SUCCEEDED`.
- Test manuale minimo: `SUCCEEDED`.

- App avviata correttamente.
- Flusso Nuovo contenuto aperto e progetto bozza creato con testo incollato, Scuola, BES, Prof Arena, Materiale didattico Markdown e note.
- Progetto visibile in Home, dettaglio aperto e nuovi metadati visibili.
- Prompt master verificato con sorgente, testo, contesto, destinatari, tono, output, italiano, struttura attesa, criteri qualita', divieto di inventare dati e richiesta di segnalare informazioni insufficienti.
- `Copia` funzionante: il prompt viene copiato negli appunti.
- `Nota` funzionante per handoff: copia il prompt negli appunti e apre Comandi Rapidi.
- URL Shortcut invariato: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- Fallback iCloud invariato: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
- Nessuna anomalia app osservata.

Limite noto:

- Il full `xcodebuild test` dello scheme non e' stato rilanciato perche' il runner UI era gia' noto come instabile. Trattarlo come task separato.

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
