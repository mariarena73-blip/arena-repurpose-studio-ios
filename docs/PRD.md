# Arena Repurpose Studio iOS Product Requirements Document

## Visione prodotto

Arena Repurpose Studio iOS e' uno studio locale SwiftUI per trasformare sorgenti testuali o riferimenti manuali in prompt master professionali per contenuti editoriali, didattici e formativi.

## Utente principale

Mariangela, docente/content creator, con workflow AID, Prof Arena e LevelUp.

## Problema

L'utente parte da materiale grezzo e vuole ottenere output editoriali o didattici coerenti, senza riscrivere ogni volta prompt complessi.

## Chiarimento fondamentale

Nella fase corrente l'app non genera direttamente l'output finale.

L'app genera un prompt master strutturato, copiabile o inviabile allo Shortcut Ai Nota Taker.

Questo chiarimento e' essenziale per evitare che l'utente interpreti la fase Prompt come un motore LLM integrato. Il risultato prodotto dentro l'app e' il prompt master; l'eventuale generazione del contenuto finale avviene fuori dall'app, tramite workflow esterno approvato dall'utente.

## MVP attuale

- Input sorgente.
- Descrizione.
- Note operative.
- Contesto.
- Destinatari.
- Tono di voce.
- Output richiesto.
- Prompt master.
- Copia.
- Nota tramite Shortcut Ai Nota Taker.

## Non-obiettivi della fase corrente

- Generazione LLM dentro l'app.
- Tasto "Genera output" con modello AI.
- OpenRouter.
- API AI.
- Backend.
- Networking.
- Keychain.
- App Intents.
- Share Extension.
- Parsing automatico PDF/DOC.
- Fetch YouTube.
- Scraping web.
- RAG tecnico.
- Dashboard.
- Nuove tab.
- Schermata Skills.

## Ambiguita da risolvere

L'utente puo' interpretare "output richiesto" come output finale generato.

Nella fase corrente, invece, "output richiesto" significa formato target del prompt master. Per esempio, se l'utente sceglie "Post Facebook", l'app prepara un prompt master che chiede a un assistente esterno di produrre un post Facebook coerente con sorgente, contesto, destinatari e tono.

La UI futura dovrebbe distinguere chiaramente tra:

- "Prepara prompt master".
- "Copia prompt".
- "Invia a Nota".
- "Genera output", solo in una fase futura con modalita LLM approvata.

## Requisiti funzionali attuali

1. L'app deve permettere all'utente di creare una bozza partendo da testo incollato o da un riferimento manuale.
2. L'app deve raccogliere una descrizione breve e note operative facoltative.
3. L'app deve raccogliere il contesto di riuso, inclusa la possibilita di un contesto personalizzato.
4. L'app deve raccogliere i destinatari, inclusa la possibilita di destinatari personalizzati.
5. L'app deve raccogliere il tono di voce tra AID, Prof Arena e LevelUp.
6. L'app deve raccogliere il formato di output richiesto come target del prompt master.
7. L'app deve salvare localmente la bozza con i metadati del workflow di repurposing.
8. L'app deve generare un prompt master che includa sorgente, descrizione, note, contesto, destinatari, tono, output richiesto, vincoli e criteri di qualita.
9. L'app deve indicare nel prompt che non bisogna inventare dati mancanti e che eventuali informazioni insufficienti vanno segnalate.
10. L'app deve permettere di copiare il prompt master negli appunti.
11. L'app deve permettere il passaggio allo Shortcut Ai Nota Taker copiando il prompt negli appunti e aprendo lo Shortcut.
12. L'app deve mantenere invariato l'URL Shortcut: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
13. L'app deve mantenere invariato il fallback iCloud: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
14. L'app deve restare un MVP locale SwiftUI senza API AI, backend, networking, Keychain, App Intents o Share Extension.

## Requisiti futuri

### Fase 1: PromptMasterBuilder template-driven

Consolidare `PromptMasterBuilder` come generatore template-driven, con template locali piu' facili da testare, rivedere e riusare per diversi formati AID.

### Fase 2: Prompt source-grounded

Rafforzare il prompt per rendere esplicito che ogni output deve derivare dalla sorgente o dal riferimento fornito. Il prompt deve continuare a chiedere di segnalare dati mancanti invece di completarli per invenzione.

### Fase 3: Formato finale parser-friendly

Definire strutture finali piu' regolari per output come post Facebook, materiale didattico Markdown, mappe concettuali, outline PowerPoint e schemi Excalidraw, in modo che un eventuale parser futuro possa riconoscerli.

### Fase 4: ProjectStorageService robusto

Stabilizzare `ProjectStorageService` con test deterministici, error visibility e strategia di compatibilita per evoluzioni dello schema locale.

### Fase 5: Catalogo locale prompt master

Valutare un catalogo locale dei prompt master generati o dei template approvati, senza introdurre dashboard, nuove tab o schermate Skills nella fase corrente.

### Fase 6: Shortcut evoluto

Valutare un'evoluzione dello Shortcut Ai Nota Taker per ricevere il prompt master, generare o organizzare una nota, e restituire un flusso piu' guidato, mantenendo chiaro che la generazione avviene fuori dall'app.

### Fase 7: OpenRouter opzionale

Valutare OpenRouter solo come futura modalita opzionale, esplicitamente approvata, con threat model, gestione sicura delle credenziali e confini chiari tra app locale e servizi esterni.

### Fase 8: Output parser

Valutare un parser dell'output generato esternamente per reimportare sezioni strutturate nell'app, solo dopo che il formato finale sara' stabile e testato.

### Fase 9: Import/parsing documenti

Valutare import e parsing documenti solo come fase futura separata. PDF, DOC, YouTube e web devono restare riferimenti manuali finche' parsing, permessi, privacy e UX non saranno esplicitamente progettati.

### Fase 10: RAG tecnico

Valutare RAG tecnico solo in una roadmap futura con backend o indice locale progettati appositamente. Non fa parte dell'MVP attuale.

## Criteri di accettazione

- L'utente capisce che sta generando un prompt, non ancora l'output finale.
- Il prompt include sorgente, contesto, destinatari, tono e output richiesto.
- Il prompt include descrizione e note operative quando presenti.
- Il prompt include vincoli contro dati inventati e gestione di informazioni insufficienti.
- Copia funziona e mette il prompt master negli appunti.
- Nota funziona e apre lo Shortcut Ai Nota Taker usando il prompt copiato.
- URL Shortcut invariato: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- Fallback iCloud invariato: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
- Nessuna API AI, rete, backend, Keychain, App Intents o Share Extension viene introdotta nella fase corrente.
- Nessuna nuova tab, dashboard o schermata Skills viene introdotta nella fase corrente.

## Decisione prodotto consigliata

Per la fase corrente usare una dicitura piu' precisa nella roadmap e nella futura UI:

- Preferire "Genera prompt master" o "Prepara output".
- Evitare "Genera contenuto finale" finche' non esiste una modalita LLM approvata.

La promessa di prodotto dell'MVP e': preparare un prompt master professionale, locale e source-grounded; non generare direttamente il contenuto finale dentro l'app.
