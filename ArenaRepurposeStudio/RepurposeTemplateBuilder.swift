import Foundation

enum RepurposeTemplateBuilder {
    static func draft(for project: Project) -> String? {
        switch project.type {
        case .facebookPostAid:
            return facebookPost(project)
        case .blogArticleAid:
            return blogArticle(project)
        case .imagePrompt:
            return imagePrompt(project)
        case .presentationOutline:
            return presentationOutline(project)
        case .excalidrawDiagram:
            return excalidrawDiagram(project)
        case .youtubeRepurpose:
            return youtubeRepurpose(project)
        default:
            return nil
        }
    }

    private static func facebookPost(_ project: Project) -> String {
        let title = cleanTitle(project)
        let material = cleanContent(project)

        return """
        POST PRINCIPALE
        Nel contesto di \(title), il materiale disponibile evidenzia un nodo operativo da trattare con ordine: \(material)

        L'obiettivo del post è trasformare questa bozza in un ragionamento professionale, chiaro e applicabile. La struttura deve collegare contesto, criticità e proposta operativa, evitando formule motivazionali o promozionali.

        COMMENTO 1: Top Prompt Aid
        CONTESTO:
        Sto lavorando su \(title). Il materiale di partenza è: \(material)

        RUOLO:
        Agisci come consulente esperto in progettazione didattica e comunicazione professionale.

        AZIONE:
        Analizza il contenuto, individua il nucleo utile e trasformalo in una sequenza operativa applicabile.

        VINCOLI:
        Mantieni tono professionale, argomentativo e concreto. Non usare slogan, hashtag automatici o formule promozionali.

        FORMATO:
        Restituisci una sintesi, tre criteri operativi e una checklist di applicazione.

        COMMENTO 2: Applicazione operativa
        1. Individuare il problema pratico.
        2. Definire il criterio di intervento.
        3. Tradurre il criterio in un'azione osservabile.
        4. Verificare se l'azione produce un risultato utilizzabile.

        COMMENTO 3: Prompt immagine blocca-scroll per ChatGPT Image 2.0
        Crea un'immagine mobile-first su \(title). Un solo soggetto focale, un contrasto dominante, un momento visivo decisivo, palette #2E6D74 #009193 #00D4D2 #FFA602 #F6EFDC #10325C. Testo eventuale massimo 3-7 parole. Formato 4:5.

        COMMENTO 4: Possibile repurpose in 5 angolazioni
        1. Angolazione didattica: criteri e applicazione.
        2. Angolazione operativa: procedura passo-passo.
        3. Angolazione visuale: schema o immagine esplicativa.
        4. Angolazione formativa: attività o esercizio.
        5. Angolazione editoriale: articolo breve con esempio concreto.
        """
    }

    private static func blogArticle(_ project: Project) -> String {
        let title = cleanTitle(project)
        let material = cleanContent(project)

        return """
        Titolo
        \(title): criteri operativi e applicazioni concrete

        Apertura contestuale
        Nel lavoro quotidiano di progettazione, \(title.lowercased()) richiede una lettura ordinata del contesto e dei bisogni reali.

        Criticità
        Il rischio principale è trattare il tema in modo generico, senza distinguere obiettivi, vincoli e condizioni di applicazione.

        Analisi
        Materiale di partenza: \(material)

        Il contenuto va letto individuando il problema, il criterio metodologico e la ricaduta operativa.

        Applicazioni operative
        - Definire il contesto di utilizzo.
        - Separare informazioni essenziali e secondarie.
        - Tradurre il contenuto in una procedura verificabile.
        - Preparare una checklist per l'applicazione.

        Esempio concreto
        A partire dalla bozza, si può costruire una scheda operativa con obiettivo, destinatari, passaggi e indicatori di verifica.

        Prompt operativo Aid
        Analizza il materiale seguente e trasformalo in un piano operativo con contesto, criticità, criteri, azioni e verifica: \(material)

        Indicazione finale
        La qualità del risultato dipende dalla coerenza tra problema individuato, metodo scelto e forma di applicazione.

        Meta description
        Una guida operativa su \(title.lowercased()) con criteri, esempi e prompt applicabili.
        """
    }

    private static func imagePrompt(_ project: Project) -> String {
        let title = cleanTitle(project)
        let material = cleanContent(project)

        return """
        creative_strategy
        Trasformare \(title) in una promessa visiva chiara, leggibile in pochi secondi e collegata a un problema operativo reale.

        scroll_rules
        - Una immagine = una promessa.
        - Un solo soggetto focale.
        - Un solo trigger emotivo.
        - Un contrasto dominante.
        - Un momento visivo decisivo.
        - Testo massimo 3-7 parole se presente.
        - Leggibilità mobile in 2-3 secondi.
        - Area sicura per eventuale testo sovrapposto.
        - Composizione mobile-first.

        headline_options
        1. Da bozza a metodo
        2. Il contenuto prende forma
        3. Una struttura utilizzabile

        selected_headline
        Da bozza a metodo

        storytelling_frame
        Mostrare il passaggio da materiale grezzo a struttura ordinata, con una tensione visiva tra confusione iniziale e organizzazione operativa.

        engagement_trigger
        Riconoscimento immediato di un problema professionale: troppe informazioni, poca struttura applicabile.

        layout_guidance
        Soggetto principale al centro, sfondo semplice, contrasto netto, spazio libero in alto o a sinistra per eventuale micro-headline.

        visual_concept
        Una scrivania digitale con appunti disordinati che convergono in una struttura chiara, senza elementi decorativi superflui.

        chatgpt_image_2_prompt
        Obiettivo visivo: creare un'immagine blocca-scroll su \(title).
        Soggetto: una bozza grezza che si trasforma in una struttura ordinata e utilizzabile.
        Composizione: mobile-first, un solo soggetto focale, gerarchia chiara, area sicura per testo breve.
        Atmosfera: professionale, lucida, operativa.
        Stile visuale: editoriale contemporaneo, pulito, ad alta leggibilità.
        Palette AiD: #2E6D74, #009193, #00D4D2, #FFA602, #F6EFDC, #10325C.
        Gerarchia visiva: soggetto principale immediato, contrasto dominante, dettagli secondari ridotti.
        Testo in immagine: "Da bozza a metodo".
        Elementi da evitare: troppi oggetti, sfondo caotico, testo lungo, simboli generici di intelligenza artificiale, estetica stock.
        Formato consigliato: 4:5 per post Facebook / Instagram.
        Materiale di riferimento: \(material)

        negative_constraints
        No testo lungo, no collage confuso, no elementi decorativi senza funzione, no riferimenti a strumenti esterni, no promessa non verificabile.

        format_recommendation
        4:5 per post Facebook / Instagram; 16:9 per copertine video o slide; 1:1 per card sintetiche.
        """
    }

    private static func presentationOutline(_ project: Project) -> String {
        let title = cleanTitle(project)
        let material = cleanContent(project)

        return """
        Titolo presentazione
        \(title)

        Obiettivo
        Trasformare il materiale di partenza in una sequenza chiara, presentabile e operativa.

        Pubblico
        Docenti, professionisti o gruppi di lavoro che devono comprendere e applicare il contenuto.

        Slide 1 - Contesto
        Sintesi del tema e del problema affrontato.
        Suggerimento visuale: titolo forte su fondo teal con elemento grafico essenziale.

        Slide 2 - Materiale di partenza
        \(material)
        Suggerimento visuale: blocchi di testo sintetici.

        Slide 3 - Criticità
        Perché il tema richiede struttura e criteri di lettura.
        Suggerimento visuale: confronto tra input grezzo e output ordinato.

        Slide 4 - Criterio guida
        Il principio operativo che orienta la trasformazione del contenuto.
        Suggerimento visuale: una freccia centrale con tre parole chiave.

        Slide 5 - Applicazione 1
        Primo uso concreto nel lavoro professionale.
        Suggerimento visuale: card operativa.

        Slide 6 - Applicazione 2
        Secondo uso concreto o variante di contesto.
        Suggerimento visuale: schema a due colonne.

        Slide 7 - Checklist
        Passaggi minimi per usare il contenuto.
        Suggerimento visuale: elenco verificabile.

        Slide 8 - Chiusura operativa
        Indicazione finale e prossimo passo.
        Suggerimento visuale: sintesi con palette #2E6D74 #00D4D2 #FFA602.

        Prompt immagine copertina per ChatGPT Image 2.0
        Crea una cover 16:9 su \(title), con composizione pulita, un solo soggetto focale, palette AiD, titolo breve e leggibile, atmosfera professionale.
        """
    }

    private static func excalidrawDiagram(_ project: Project) -> String {
        let title = cleanTitle(project)
        let material = cleanContent(project)

        return """
        Nodi principali
        - Tema centrale: \(title)
        - Materiale di partenza: \(material)
        - Criticità
        - Criterio operativo
        - Applicazioni
        - Verifica

        Relazioni
        Tema centrale -> Criticità -> Criterio operativo -> Applicazioni -> Verifica

        Frecce
        Usare frecce direzionali da sinistra a destra per mostrare il passaggio da contenuto grezzo a output utilizzabile.

        Gruppi visivi
        - Gruppo 1: input e contesto.
        - Gruppo 2: analisi e criterio.
        - Gruppo 3: applicazione e controllo.

        Legenda colori
        - #2E6D74 per il nodo centrale.
        - #00D4D2 per relazioni e passaggi.
        - #FFA602 per criticità o punti di attenzione.
        - #F6EFDC per sfondi di gruppo.
        - #10325C per testo principale.

        Layout consigliato
        Mappa orizzontale con nodo centrale a sinistra, sviluppo progressivo verso destra e gruppi separati da cornici leggere.

        Prompt visuale per ChatGPT Image 2.0
        Crea uno schema visivo in stile lavagna digitale su \(title), con nodi chiari, frecce leggibili, gruppi visivi ordinati, palette AiD e composizione mobile-first.
        """
    }

    private static func youtubeRepurpose(_ project: Project) -> String {
        let title = cleanTitle(project)
        let material = cleanContent(project)
        let note = isOnlyYouTubeLink(material)
            ? "\nNota: Estrazione automatica trascrizione non ancora attiva. Incolla la trascrizione per il repurpose locale.\n"
            : ""

        return """
        Repurpose YouTube locale
        \(note)
        Titolo o riferimento
        \(title)

        Materiale incollato
        \(material)

        Sintesi operativa
        Identificare tema centrale, passaggi utili e possibili trasformazioni in contenuti didattici o social.

        Output consigliati
        - Post Facebook Aid.
        - Schema presentazione.
        - Prompt immagine blocca-scroll.
        - Script YouTube riorganizzato.

        Prossimo passaggio
        Incollare una trascrizione completa per ottenere una bozza locale più precisa.
        """
    }

    private static func cleanTitle(_ project: Project) -> String {
        let title = project.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return title.isEmpty ? project.displayTitle : title
    }

    private static func cleanContent(_ project: Project) -> String {
        let content = project.rawContent.trimmingCharacters(in: .whitespacesAndNewlines)
        return content.isEmpty ? "Materiale non ancora dettagliato." : content
    }

    private static func isOnlyYouTubeLink(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.contains(where: { $0.isWhitespace }) else { return false }
        return trimmed.contains("youtube.com") || trimmed.contains("youtu.be")
    }
}
