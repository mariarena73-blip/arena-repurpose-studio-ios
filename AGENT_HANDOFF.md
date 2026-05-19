# AGENT HANDOFF — Arena Repurpose Studio iOS

> Per l'agente che riprende domani. Leggi tutto prima di toccare qualsiasi file.

---

## Progetto

**Nome:** Arena Repurpose Studio  
**Bundle ID:** `com.aid.arenarepurposestudio`  
**Repo GitHub:** https://github.com/mariarena73-blip/arena-repurpose-studio-ios  
**Branch:** `master`  
**Tech stack:** Native iOS / SwiftUI / UserDefaults (JSON)  
**NON usare:** React Native, Expo, SwiftData, Xcode manuale, istruzioni copia-incolla

### Nota operativa 2026-05-18

- Il repo non contiene skill proprie nel workspace; usa skill Codex installate globali.
- La mappa delle skill utili allo sviluppo iOS/AID e' documentata in `docs/reusable-skills-found.md`.
- La mappa guida i prompt Codex e non implica integrazione delle skill nell'app SwiftUI.
- Non implementare ora dashboard, tab Skill o aree ispirate al PDF `app web corus ios builder app da imitare.pdf`.
- Documentazione di stato aggiornata sulla baseline remota `af68fcb`; non integrare skill o nuove superfici UI nell'app.

### Stato corrente verificato 2026-05-19

- Baseline SwiftUI buildabile con `xcodebuild` su iPhone 17 Pro Simulator.
- Ultimo commit remoto noto su `origin/master`: `af68fcb Realign repurpose workflow model and prompt composer`.
- Il micro-task codice di riallineamento workflow/model/prompt composer e' stato pushato correttamente su `origin/master`.
- Workflow di repurposing riallineato: aggiunti `SourceKind`, `RepurposeContext`, `RepurposeAudience`, `RepurposeVoice`, `RepurposeOutput`; `Project` esteso con nuovi campi; decoder legacy aggiunto; mapping temporaneo `RepurposeOutput` -> `ProjectType` aggiunto.
- View aggiornate nel micro-task codice: `NewContentView`, `QuickCaptureView`, `PromptComposerView`, `ProjectDetailView`.
- Test aggiornati in `ArenaRepurposeStudioTests`.
- Validazioni completate: `xcodebuild build` su iPhone 17 Pro Simulator `BUILD SUCCEEDED`; `xcodebuild test` solo `ArenaRepurposeStudioTests` `TEST SUCCEEDED`; test manuale minimo su iPhone 17 Pro Simulator `SUCCEEDED`.
- Verifica manuale Prompt/Nota completata: app avviata, flusso Nuovo contenuto ok, progetto bozza creato, dettaglio aperto, metadati visibili, Prompt ok, `Copia` funzionante, `Nota` funzionante, Comandi Rapidi aperto correttamente.
- URL Shortcut invariato: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- Fallback iCloud invariato: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
- Limite noto: il full `xcodebuild test` dello scheme non e' stato rilanciato perche' il runner UI era gia' noto come instabile. Trattarlo come task separato.
- Prossimi step consigliati: 1) aggiungere test locali piu' mirati sul nuovo modello e sul prompt master; 2) stabilizzare `ProjectStorageService`; 3) consolidare template e prompt master locali; 4) piccoli miglioramenti UI SwiftUI solo dopo test e storage.

---

## Stato Day 1 storico

Questa sezione resta come contesto di recupero iniziale. Non rappresenta lo stato corrente del progetto.

### ✅ Completato nella sessione storica
- Bootstrap progetto Xcode (`ios-cli bootstrap`)
- 12 file Swift scritti (views, model, service, theme)
- App icon generata (Ideogram) e installata in `Assets.xcassets`
- Primo commit + push su GitHub

### ❌ Bloccato nella sessione storica
- Build `ios-cli` fallita per errori Swift (vedi `BUILD_LOG.md`)
- Fix preparati in locale ma NON committati al momento del push

---

## AZIONE IMMEDIATA storica: fix build errors

Questa procedura e' storica. Lo stato corrente verificato e' documentato nella nota operativa 2026-05-18 e in `docs/current-state.md`.

### Step 1 — Verifica stato locale

```bash
cat ~/Projects/arena-repurpose-studio-ios/ArenaRepurposeStudio/Project.swift | grep "enum ProjectType\|enum EditorialStatus"
```

Se stampa le due enum → fix già applicato, vai a Step 2.  
Se non stampa nulla → applica il fix:

```bash
# Aggiungi a Project.swift le enum mancanti:
# enum ProjectType: String, Codable, CaseIterable, Identifiable
#   casi: quiz, flashcard, youtubeScript, conceptMap, infographic, text
# enum EditorialStatus: String, Codable, CaseIterable, Identifiable
#   casi: draft, review, published
# Aggiorna ContentItem.type da ContentType a ProjectType
# Aggiorna Project con var type: ProjectType e var status: EditorialStatus
```

### Step 2 — Verifica AIDVoice.swift

```bash
grep "enum App\|enum Home\|enum Archive" ~/Projects/arena-repurpose-studio-ios/ArenaRepurposeStudio/AIDVoice.swift
```

Deve restituire 3 righe. Se no → riscrivi con struttura nested (vedi BUILD_LOG.md).

### Step 3 — Rebuild

```bash
cd ~/Projects/arena-repurpose-studio-ios
rm -f /tmp/arena-repurpose-studio.zip
zip -r /tmp/arena-repurpose-studio.zip . -x ".git/*" -x "xcuserdata/*" -x "*.xcuserstate" -q
~/.chorus/skills/vibecode-build-ios-apps/ios-cli build /tmp/arena-repurpose-studio.zip
```

### Step 4 — Se build fallisce ancora

```bash
~/.chorus/skills/vibecode-build-ios-apps/ios-cli logs <buildJobId>
# leggi errori → fixa → rezip → rebuild
```

### Step 5 — Quando build OK

- L'`ios-cli` emette `previewUrl` — darlo a Mariangela
- Eseguire checklist Day 1 (vedi sotto)

---

## Checklist Day 1 (validazione su Simulator/iPhone)

1. App si apre → Home screen visibile
2. Tap "Idea vocale" → QuickCaptureView aperto con TextEditor
3. Scrivi testo → "Salva come bozza" → ritorna a Home con progetto nella lista
4. Tab "Archivio" → lista progetti
5. Tap su progetto → ProjectDetailView con contenuti
6. Tab "Prompt" → PromptComposerView stub ("Prossimamente") nella versione storica Day 1

---

## Regole operative (NON derogare)

Nota: questa sezione appartiene alla procedura storica Vibecode/ios-cli e non si applica ai task correnti in Codex Desktop locale. Per il progetto corrente il workflow operativo e': SwiftUI nativo, Xcode project esistente, `xcodebuild` locale quando richiesto, nessun Expo, nessun backend, nessuna API AI.

- Tutto tool-based: `ios-cli`, `git`, script Bash
- NO istruzioni copia-incolla / snippet manuali all'utente
- NO SwiftData, NO Xcode GUI
- Risposta in italiano, punto per punto, con ✅/🔄/❌
- La build DEVE girare senza errori prima di considerare Day 1 completo

---

## Path chiave

| Risorsa | Path |
|---------|------|
| Progetto Xcode | `~/Projects/arena-repurpose-studio-ios/` |
| ios-cli | `~/.chorus/skills/vibecode-build-ios-apps/ios-cli` |
| Skill reference | `~/.chorus/skills/vibecode-build-ios-apps/SKILL.md` |
| Gotchas Xcode 26 | `~/.chorus/skills/vibecode-build-ios-apps/references/gotchas.md` |
| Zip build | `/tmp/arena-repurpose-studio.zip` |

---

## Note Xcode 26 (importante)

Qualsiasi classe `ObservableObject` richiede `import Combine` esplicito — `import SwiftUI` non basta.  
Ref: `references/gotchas.md`
