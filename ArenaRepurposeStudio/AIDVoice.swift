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
        static let outputType = "Tipo output"
        static let saveAsDraft = "Salva come bozza"
        static let saved = "Salvato"
        static let youtubeTranscriptNote = "Estrazione automatica trascrizione non ancora attiva. Incolla la trascrizione per il repurpose locale."
    }

    enum NewContent {
        static let title = "Nuovo contenuto"
        static let subtitle = "Scegli il formato"
    }

    enum Detail {
        static let content = "Contenuto"
        static let createdAt = "Creato"
        static let edit = "Modifica"
        static let save = "Salva"
        static let composePrompt = "Componi prompt"
        static let structuredDraft = "Bozza strutturata"
        static let saveStructuredDraft = "Salva bozza strutturata"
        static let structuredDraftSaved = "Bozza salvata nel progetto"
        static let copyStructuredDraft = "Copia bozza"
        static let structuredDraftCopied = "Bozza copiata negli appunti"
    }

    enum PromptComposer {
        static let title = "Prompt strutturato"
        static let intro = "Seleziona un progetto per generare il prompt AI"
        static let chooseProject = "Scegli progetto"
        static let projectPickerGuide = "Scegli un progetto salvato per preparare un prompt da copiare o inviare ai tuoi Comandi Rapidi."
        static let promptToCopy = "Prompt da copiare"
        static let copy = "Copia"
        static let copied = "Copiato"
        static let close = "Chiudi"
        static let back = "Indietro"
        static let shortcutSection = "Invia a Comando Rapido"
        static let note = "Nota"
        static let shortcutUnavailable = "Comando Rapido non disponibile"
        static let promptCopied = "Prompt copiato negli appunti"
        static let shortcutUnavailableMessage = "\(shortcutUnavailable). \(promptCopied)."
        static let installShortcut = "Installa Shortcut"
        static let shortcutsMustBeInstalled = "Gli Shortcut devono essere installati nell'app Comandi Rapidi"
        static let promptPassedViaClipboard = "Il prompt viene passato tramite appunti"
        static let shortcutInstallNote = "\(shortcutsMustBeInstalled). \(promptPassedViaClipboard)."
        static let shortcutNote = "Invia il prompt ad Ai Nota Taker tramite appunti."
    }

    static func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
