import Foundation

enum ProjectType: String, Codable, CaseIterable, Identifiable {
    case quiz = "Quiz"
    case flashcard = "Flashcard"
    case facebookPostAid = "Post Facebook Aid"
    case blogArticleAid = "Articolo blog Aid"
    case imagePrompt = "Prompt immagine blocca-scroll"
    case presentationOutline = "Schema presentazione"
    case excalidrawDiagram = "Schema Excalidraw"
    case youtubeRepurpose = "YouTube repurpose"
    case youtubeScript = "Script YouTube"
    case conceptMap = "Mappa concettuale"
    case infographic = "Infografica"
    case text = "Testo libero"
    case freeText = "Testo libero input"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .quiz: return "Quiz"
        case .flashcard: return "Flashcard"
        case .facebookPostAid: return "Post Facebook Aid"
        case .blogArticleAid: return "Articolo blog Aid"
        case .imagePrompt: return "Prompt immagine blocca-scroll"
        case .presentationOutline: return "Schema presentazione"
        case .excalidrawDiagram: return "Schema Excalidraw"
        case .youtubeRepurpose: return "Repurpose YouTube"
        case .youtubeScript: return "Script YouTube"
        case .conceptMap: return "Mappa concettuale"
        case .infographic: return "Infografica"
        case .text, .freeText: return "Testo libero"
        }
    }

    var icon: String {
        switch self {
        case .quiz: return "questionmark.circle.fill"
        case .flashcard: return "rectangle.stack.fill"
        case .facebookPostAid: return "bubble.left.and.bubble.right.fill"
        case .blogArticleAid: return "doc.richtext.fill"
        case .imagePrompt: return "photo.on.rectangle.angled"
        case .presentationOutline: return "rectangle.on.rectangle.angled"
        case .excalidrawDiagram: return "scribble.variable"
        case .youtubeRepurpose: return "link.circle.fill"
        case .youtubeScript: return "play.rectangle.fill"
        case .conceptMap: return "square.grid.3x3.fill"
        case .infographic: return "chart.bar.fill"
        case .text, .freeText: return "doc.text.fill"
        }
    }

    var promptContext: String {
        switch self {
        case .quiz: return "Genera domande o quiz dal materiale fornito."
        case .flashcard: return "Genera flashcard dal materiale fornito."
        case .facebookPostAid: return "Trasforma il materiale in un post Facebook Aid con commenti operativi."
        case .blogArticleAid: return "Trasforma il materiale in una struttura di articolo blog Aid."
        case .imagePrompt: return "Trasforma il materiale in un prompt immagine blocca-scroll per ChatGPT Image 2.0."
        case .presentationOutline: return "Trasforma il materiale in una scaletta di presentazione."
        case .excalidrawDiagram: return "Trasforma il materiale in una descrizione testuale di diagramma."
        case .youtubeRepurpose: return "Trasforma un link, una trascrizione o appunti video in una bozza riutilizzabile."
        case .youtubeScript: return "Genera uno script video dal materiale fornito."
        case .conceptMap: return "Genera una mappa concettuale dal materiale fornito."
        case .infographic: return "Genera una struttura infografica dal materiale fornito."
        case .text, .freeText: return "Rielabora il testo fornito."
        }
    }
}

enum EditorialStatus: String, Codable, CaseIterable, Identifiable {
    case draft = "Bozza"
    case review = "In revisione"
    case published = "Pubblicato"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .draft: return "pencil.circle"
        case .review: return "clock.circle"
        case .published: return "checkmark.circle.fill"
        }
    }
}

extension EditorialStatus {
    var color: String {
        switch self {
        case .draft: return "secondary"
        case .review: return "orange"
        case .published: return "green"
        }
    }
}

struct ContentItem: Identifiable, Codable {
    var id: UUID = UUID()
    var body: String
    var type: ProjectType
    var createdAt: Date = Date()
}

struct Project: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String = ""
    var type: ProjectType = .text
    var status: EditorialStatus = .draft
    var tags: [String] = []
    var contentItems: [ContentItem] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    var projectType: ProjectType { type }

    var displayTitle: String {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty { return trimmedTitle }

        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedDescription.isEmpty {
            return String(trimmedDescription.prefix(40))
        }

        return "Senza titolo"
    }

    var rawContent: String {
        get {
            if let lastContent {
                let trimmedLastContent = lastContent.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedLastContent.isEmpty { return trimmedLastContent }
            }

            let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedDescription.isEmpty { return trimmedDescription }

            return ""
        }
        set {
            if let lastIndex = contentItems.indices.last {
                contentItems[lastIndex].body = newValue
            } else {
                contentItems.append(ContentItem(body: newValue, type: type))
            }
        }
    }

    var lastContent: String? { contentItems.last?.body }
}
