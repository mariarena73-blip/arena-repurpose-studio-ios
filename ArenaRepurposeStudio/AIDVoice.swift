import Foundation

enum AIDVoice {
    enum App {
        static let name    = "Arena Repurpose Studio"
        static let tagline = "Trasforma ogni idea in contenuto strutturato."
    }

    enum Home {
        static let recentProjects    = "Progetti recenti"
        static let noRecentProjects  = "Nessun progetto ancora. Inizia con una nuova idea."
        static let newContent        = "Nuovo contenuto"
        static let goToArchive       = "Vai all'archivio completo"
    }

    enum NewContent {
        static let title    = "Tipo di contenuto"
        static let subtitle = "Seleziona il formato di partenza."
    }

    enum Capture {
        static let placeholder  = "Scrivi o detta la tua idea.\nUsa il microfono della tastiera per la dettatura nativa iOS."
        static let outputType   = "Formato di output"
        static let saveAsDraft  = "Salva come bozza"
        static let saved        = "Salvato"
        static let titleField   = "Titolo (opzionale)"
    }

    enum Archive {
        static let title    = "Archivio"
        static let empty    = "Nessun progetto salvato."
        static let filterAll = "Tutti"
    }

    enum Detail {
        static let content       = "Contenuto"
        static let format        = "Formato"
        static let status        = "Stato"
        static let createdAt     = "Creato il"
        static let edit          = "Modifica"
        static let save          = "Salva"
        static let composePrompt = "Componi prompt"
    }

    enum PromptComposer {
        static let title   = "Prompt strutturato"
        static let intro   = "Usa questo testo come base per uno strumento AI esterno. Il prompt applica metodo, struttura e obiettivo didattico al materiale grezzo."
        static let copy    = "Copia prompt"
        static let copied  = "Copiato"
    }
}
