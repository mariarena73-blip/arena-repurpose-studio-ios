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

---

## Stato Day 1

### ✅ Completato
- Bootstrap progetto Xcode (`ios-cli bootstrap`)
- 12 file Swift scritti (views, model, service, theme)
- App icon generata (Ideogram) e installata in `Assets.xcassets`
- Primo commit + push su GitHub

### ❌ Bloccato
- Build `ios-cli` fallita per errori Swift (vedi `BUILD_LOG.md`)
- Fix preparati in locale ma NON committati al momento del push

---

## AZIONE IMMEDIATA: fix build errors

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
6. Tab "Prompt" → PromptComposerView stub ("Prossimamente")

---

## Regole operative (NON derogare)

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
