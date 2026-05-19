# Arena Repurpose Studio iOS Product Requirements Document

## Visione prodotto

Arena Repurpose Studio iOS is a local-first SwiftUI production studio for transforming source material into final editorial, didactic and training outputs for AID, Prof Arena and LevelUp.

## Utente principale

Mariangela, docente/content creator, con workflow AID, Prof Arena e LevelUp.

## Promessa prodotto

Arena Repurpose Studio iOS deve aiutare l'utente a produrre output finali professionali partendo da materiale grezzo, appunti, testi incollati o riferimenti manuali.

Il valore per l'utente non e' "ottenere un prompt". Il valore e' arrivare piu' rapidamente a un contenuto finale coerente con sorgente, destinatari, tono di voce e formato richiesto.

## Problema

L'utente parte da materiale eterogeneo e deve trasformarlo in contenuti editoriali, didattici o formativi coerenti con la voce AID, Prof Arena o LevelUp. Senza uno studio dedicato, ogni trasformazione richiede di ricostruire manualmente contesto, vincoli, target, tono e struttura dell'output.

Arena Repurpose Studio iOS riduce questa complessita raccogliendo le scelte essenziali e preparando una richiesta di generazione strutturata che puo' essere inviata al bridge esterno attuale o, in futuro, a una modalita LLM approvata.

## Output utente

Gli output user-facing sono contenuti finali o asset ausiliari pronti per il lavoro editoriale, didattico e formativo:

- Articolo blog AID.
- Post Facebook AID.
- Materiale didattico Markdown.
- Riassunto lezione.
- Mappa concettuale per BES.
- Project work / elaborato universitario in stile Scienze Motorie.
- Lezione simulata.
- Rubrica valutativa.
- Outline presentazione PowerPoint.
- Schema Excalidraw.
- Prompt immagine/video come asset ausiliario quando serve.

## Ruolo del prompt master

Il prompt master non e' il prodotto finale.

Nel prodotto il prompt master e':

- motore interno di orchestrazione della generazione;
- vista avanzata/debug utile a verificare la richiesta;
- payload copiabile manualmente;
- payload inviato allo Shortcut Ai Nota Taker;
- formato di richiesta per eventuali future modalita LLM approvate.

La comunicazione di prodotto deve quindi evitare di presentare il prompt master come risultato principale. Il risultato principale e' il contenuto finale richiesto dall'utente; il prompt master e' il mezzo tecnico usato per arrivarci.

## Limite tecnico corrente

Nella fase tecnica corrente, la generazione dell'output finale e' delegata al workflow esterno Shortcut/LLM perche' l'app non include ancora un runtime AI interno.

Questo significa che l'app:

- raccoglie sorgente, contesto, destinatari, tono e output finale richiesto;
- costruisce internamente una richiesta di generazione strutturata;
- consente di copiare la richiesta;
- consente di inviarla allo Shortcut Ai Nota Taker;
- usa lo Shortcut come bridge esterno corrente per ottenere l'output finale.

Questo limite non cambia la promessa prodotto. Arena Repurpose Studio iOS e' progettata per produrre output finali; nell'implementazione corrente, la generazione finale passa da Copia/Shortcut invece che da un runtime AI in-app.

## Percorso di generazione corrente

Il percorso MVP e':

1. Source input.
2. Context.
3. Audience.
4. Voice.
5. Requested final output.
6. Structured generation request.
7. Copy / Shortcut handoff.
8. Final output produced through the external generation bridge.

Lo Shortcut esistente deve restare invariato:

- URL Shortcut: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- Fallback iCloud: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.

## User journey

Esempio principale:

1. L'utente incolla un testo sorgente.
2. Seleziona "Post Facebook AID" come output finale.
3. Seleziona "Docenti" come destinatari.
4. Seleziona "AID" come tono di voce.
5. Tocca "Genera con Ai Nota Taker" o una CTA equivalente futura.
6. L'app prepara la richiesta strutturata e la passa al bridge esterno corrente.
7. L'utente ottiene un post Facebook generato dalla richiesta strutturata.

Il prompt rimane un payload interno. Puo' essere copiato manualmente quando serve, ma non deve essere presentato come il risultato principale del flusso.

## Content families

### AID editorial

- Post Facebook.
- Blog article.
- Top prompt post.
- Comment sequence.
- SEO article.

### Prof Arena didactic

- Lesson summary.
- BES map.
- Simplified material.
- Evaluation rubric.
- Simulated lesson.
- Inclusive teaching plan.

### LevelUp / Scienze Motorie

- Project work.
- Thesis-style section.
- Lesson plan.
- Training material.
- Assessment rubric.
- Presentation outline.

## Risorse di tono e stile

Le risorse incluse nel progetto sono materiali di riferimento per progettare richieste di generazione e template futuri. Non sono integrate nel runtime SwiftUI e non introducono networking, API, parsing automatico o import documentale nella fase corrente.

- `docs/resources/aid-tone-of-voice/tone_of_voice_aid_post_facebook_top_prompt_aid_e_blog.md`: tono AID per post Facebook, top prompt, comment sequence e blog.
- `docs/resources/aid-tone-of-voice/Tono di Voce Aid stile Universitario #Project Work 9_1 Scienze Motorie.md`: esempio e stile universitario per Project Work 9.1 Scienze Motorie.
- `docs/resources/didactic-output-examples/`: esempi di materiali didattici reali per primo anno e quinto anno, da usare come riferimento per struttura, livello di semplificazione, domande guida, mappe, riepiloghi, formule e organizzazione disciplinare.

Gli output didattici futuri devono poter imitare questi tratti quando l'utente richiede materiale simile:

- spiegazione chiara e diretta per la classe target;
- definizioni essenziali prima dei passaggi complessi;
- esempi concreti dopo le definizioni;
- domande guida o domande probabili per verifica/interrogazione;
- riepilogo finale o mappa/schema;
- tabelle comparative quando aiutano la comprensione;
- formule e procedimenti passo-passo nelle materie tecniche;
- struttura accessibile anche per studenti BES/DSA.

## MVP attuale

L'MVP deve supportare il workflow produttivo, non un semplice workflow di prompt:

- acquisizione della sorgente o del riferimento manuale;
- descrizione breve;
- note operative;
- scelta del contesto;
- scelta dei destinatari;
- scelta del tono di voce;
- scelta dell'output finale richiesto;
- costruzione della richiesta di generazione strutturata;
- Copia come azione secondaria/manuale;
- invio allo Shortcut Ai Nota Taker come bridge di generazione corrente;
- mantenimento dell'archivio locale delle bozze/progetti.

## Requisiti funzionali attuali

1. L'app deve permettere all'utente di creare una bozza partendo da testo incollato o da un riferimento manuale.
2. L'app deve raccogliere descrizione breve e note operative facoltative.
3. L'app deve raccogliere contesto, destinatari e tono di voce.
4. L'app deve far scegliere all'utente un tipo di output finale, non un tipo di prompt.
5. L'app deve costruire una richiesta strutturata che contenga sorgente, contesto, destinatari, tono, output finale richiesto, vincoli e criteri di qualita.
6. L'app deve indicare nella richiesta che non bisogna inventare dati mancanti e che eventuali informazioni insufficienti vanno segnalate.
7. L'app deve permettere di copiare la richiesta strutturata negli appunti come azione secondaria.
8. L'app deve permettere il passaggio allo Shortcut Ai Nota Taker copiando la richiesta negli appunti e aprendo lo Shortcut.
9. L'app deve mantenere invariato l'URL Shortcut: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
10. L'app deve mantenere invariato il fallback iCloud: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
11. L'app deve restare un MVP locale SwiftUI senza runtime AI interno nella fase corrente.

## Non-obiettivi della fase corrente

- OpenRouter.
- OpenAI API.
- Claude API.
- API AI dirette.
- Backend.
- Networking.
- Keychain.
- App Intents.
- Share Extension.
- Parsing automatico PDF/DOC.
- Fetch YouTube.
- Scraping web.
- Implementazione RAG tecnica.
- Dashboard.
- Nuove tab.
- Schermata Skills.

## Ambiguita da risolvere

La UI corrente puo' far percepire il prompt master come output principale perche' lo mostra esplicitamente. Questa e' una conseguenza del bridge tecnico corrente, non la promessa prodotto.

La UI futura dovrebbe distinguere chiaramente tra:

- scelta del tipo di output finale;
- generazione tramite Ai Nota Taker o altra modalita approvata;
- visualizzazione avanzata della richiesta strutturata;
- Copia come fallback manuale.

La futura CTA non dovrebbe comunicare "genera prompt" come azione primaria. Dovrebbe comunicare la produzione dell'output finale tramite il bridge disponibile, per esempio "Genera con Ai Nota Taker" o una formulazione equivalente.

## Requisiti futuri

### Fase 1: StructuredGenerationRequest template-driven

Consolidare il builder della richiesta strutturata come sistema template-driven, con template locali testabili per post AID, blog, materiali didattici, mappe BES, project work, rubriche, outline PowerPoint e schemi Excalidraw.

### Fase 2: Source-grounded final outputs

Rafforzare le richieste di generazione affinche' ogni output finale derivi dalla sorgente o dal riferimento fornito. La richiesta deve continuare a chiedere di segnalare dati mancanti invece di completarli per invenzione.

### Fase 3: Formati finali parser-friendly

Definire strutture finali piu' regolari per post Facebook, articoli blog, materiali Markdown, mappe concettuali, rubriche, project work, outline PowerPoint e schemi Excalidraw, in modo che un eventuale parser futuro possa riconoscerli.

### Fase 4: ProjectStorageService robusto

Stabilizzare `ProjectStorageService` con test deterministici, error visibility e strategia di compatibilita per evoluzioni dello schema locale.

### Fase 5: Catalogo locale output/template

Valutare un catalogo locale dei template e degli output prodotti, senza introdurre dashboard, nuove tab o schermate Skills nella fase corrente.

### Fase 6: Shortcut evoluto

Valutare un'evoluzione dello Shortcut Ai Nota Taker per ricevere la richiesta strutturata, generare o organizzare l'output finale e restituire un flusso piu' guidato, mantenendo chiaro che la generazione avviene fuori dall'app.

### Fase 7: OpenRouter opzionale

Valutare OpenRouter solo come futura modalita opzionale, esplicitamente approvata, con threat model, gestione sicura delle credenziali e confini chiari tra app locale e servizi esterni.

### Fase 8: Output parser

Valutare un parser dell'output generato esternamente per reimportare sezioni strutturate nell'app, solo dopo che i formati finali saranno stabili e testati.

### Fase 9: Import/parsing documenti

Valutare import e parsing documenti solo come fase futura separata. PDF, DOC, YouTube e web devono restare riferimenti manuali finche' parsing, permessi, privacy e UX non saranno esplicitamente progettati.

### Fase 10: RAG tecnico

Valutare RAG tecnico solo in una roadmap futura con backend o indice locale progettati appositamente. Non fa parte dell'MVP attuale.

## Criteri di accettazione

- L'utente capisce che sta scegliendo un tipo di output finale.
- Il prompt master non e' presentato come risultato principale.
- La UI rende chiaro il percorso di generazione disponibile nella fase corrente.
- Copy resta disponibile come azione secondaria/manuale.
- Shortcut handoff e' presentato come bridge di generazione corrente.
- Nessuna API AI interna e' implicata se una modalita futura non viene esplicitamente implementata.
- La richiesta strutturata include sorgente, contesto, destinatari, tono e output finale richiesto.
- La richiesta strutturata include vincoli contro dati inventati e gestione di informazioni insufficienti.
- URL Shortcut invariato: `shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard`.
- Fallback iCloud invariato: `https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7`.
- Nessun OpenRouter, API AI, backend, networking, Keychain, App Intents o Share Extension viene introdotto nella fase corrente.
- Nessun parsing PDF/DOC, fetch YouTube, scraping web o RAG tecnico viene introdotto nella fase corrente.
- Nessuna nuova tab, dashboard o schermata Skills viene introdotta nella fase corrente.

## Decisione prodotto consigliata

Per la fase corrente usare una dicitura piu' precisa nella roadmap e nella futura UI:

- Preferire "Genera con Ai Nota Taker" o "Prepara output con Ai Nota Taker" per l'azione primaria corrente.
- Tenere "Copia richiesta" o "Copia prompt" come azione secondaria/manuale.
- Evitare di descrivere Arena Repurpose Studio iOS come un generatore di prompt.

La promessa di prodotto corretta e': preparare e instradare la generazione di output finali professionali, locali e source-grounded, usando oggi il bridge Shortcut e domani solo eventuali modalita LLM esplicitamente approvate.
