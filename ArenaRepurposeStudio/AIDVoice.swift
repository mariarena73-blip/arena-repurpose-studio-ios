import Foundation

enum AIDVoice {
    enum App {
        static let name = "Arena Repurpose Studio"
        static let tagline = "Trasforma i tuoi contenuti"
    }

    enum Home {
        static let recentProjects = "Recenti"
        static let noRecentProjects = "Nessun progetto ancora.\nInizia catturando un'idea."
        static let newContent = "Nuovo contenuto"
        static let goToArchive = "Vedi tutti"
    }

    enum Archive {
        static let title = "Archivio"
        static let empty = "Nessun contenuto salvato."
        static let filterAll = "Tutti"
    }

    enum Capture {
        static let titleField = "Titolo"
        static let placeholder = "Scrivi la tua idea, nota o bozza..."
        static let sourceReferenceNote = "In questa fase il riferimento resta manuale: nessun import, parsing, fetch o download."
        static let shortDescription = "Descrizione breve"
        static let shortDescriptionPlaceholder = "Aggiungi una descrizione opzionale..."
        static let operationalNotes = "Note operative"
        static let operationalNotesPlaceholder = "Vincoli, obiettivi, punti da rispettare..."
        static let context = "Contesto"
        static let customContext = "Contesto personalizzato"
        static let audience = "Destinatari"
        static let customAudience = "Destinatari personalizzati"
        static let voice = "Tono di voce"
        static let outputType = "Output finale"
        static let saveAsDraft = "Salva come bozza"
        static let saved = "Salvato"
        static let youtubeTranscriptNote = "Estrazione automatica trascrizione non ancora attiva. Incolla la trascrizione per il repurpose locale."
    }

    enum NewContent {
        static let title = "Nuovo contenuto"
        static let subtitle = "Scegli la sorgente per l'output finale"
    }

    enum Detail {
        static let content = "Contenuto"
        static let workflow = "Preparazione output"
        static let source = "Sorgente"
        static let notes = "Note operative"
        static let createdAt = "Creato"
        static let edit = "Modifica"
        static let save = "Salva"
        static let composePrompt = "Genera con Ai Nota Taker"
        static let structuredDraft = "Vista tecnica"
        static let structuredDraftNote = "Richiesta di generazione copiabile: non e' l'output finale."
        static let saveStructuredDraft = "Salva richiesta"
        static let structuredDraftSaved = "Richiesta salvata nel progetto"
        static let copyStructuredDraft = "Copia richiesta"
        static let structuredDraftCopied = "Richiesta copiata negli appunti"
    }

    enum PromptComposer {
        static let title = "Genera output"
        static let intro = "Seleziona un progetto per preparare l'output finale"
        static let chooseProject = "Scegli progetto"
        static let projectPickerGuide = "Scegli un progetto salvato per preparare l'output finale con Ai Nota Taker. La richiesta strutturata resta disponibile come vista tecnica."
        static let promptToCopy = "Richiesta strutturata"
        static let technicalViewNote = "Vista tecnica copiabile: non e' l'output finale."
        static let copy = "Copia richiesta"
        static let copied = "Richiesta copiata"
        static let close = "Chiudi"
        static let back = "Indietro"
        static let shortcutSection = "Genera con Ai Nota Taker"
        static let note = "Genera con Ai Nota Taker"
        static let shortcutUnavailable = "Ai Nota Taker non disponibile"
        static let promptCopied = "Richiesta copiata negli appunti"
        static let shortcutUnavailableMessage = "\(shortcutUnavailable). \(promptCopied)."
        static let installShortcut = "Installa Shortcut"
        static let shortcutsMustBeInstalled = "Gli Shortcut devono essere installati nell'app Comandi Rapidi"
        static let promptPassedViaClipboard = "La richiesta viene passata tramite appunti"
        static let shortcutInstallNote = "\(shortcutsMustBeInstalled). \(promptPassedViaClipboard)."
        static let shortcutNote = "Nella fase corrente l'output finale viene generato tramite Ai Nota Taker. L'app copia la richiesta strutturata negli appunti e apre Comandi Rapidi."
    }

    static func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
