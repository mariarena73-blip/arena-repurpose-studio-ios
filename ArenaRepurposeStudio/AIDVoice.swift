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
    }

    enum NewContent {
        static let title = "Nuovo contenuto"
        static let subtitle = "Scegli il formato"
    }

    enum Detail {
        static let content = "Contenuto"
        static let createdAt = "Creato"
        static let edit = "Modifica"
        static let composePrompt = "Componi prompt"
    }

    enum PromptComposer {
        static let title = "Compositore Prompt"
        static let intro = "Seleziona un progetto per generare il prompt AI"
        static let copy = "Copia"
    }

    static func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
